package com.huuc.dormitory.controller;

import com.huuc.dormitory.common.aop.OperLog;
import com.huuc.dormitory.common.enums.OperTypeEnum;
import com.huuc.dormitory.common.exception.BusinessException;
import com.huuc.dormitory.common.result.Result;
import com.huuc.dormitory.common.sms.SmsService;
import com.huuc.dormitory.common.utils.SessionUtil;
import com.huuc.dormitory.dto.LoginDTO;
import com.huuc.dormitory.dto.PasswordDTO;
import com.huuc.dormitory.entity.SysUser;
import com.huuc.dormitory.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * 认证控制器
 */
@Controller
public class AuthController {

    @Autowired
    private UserService userService;

    @Autowired
    private SmsService smsService;

    /** IP发送验证码记录（内存Map，每小时上限5次） */
    private final Map<String, List<Long>> ipSendRecords = new ConcurrentHashMap<>();

    /** 验证码过期时间（毫秒） */
    private static final long CODE_EXPIRE_MS = 300_000;

    /** 重发间隔（毫秒） */
    private static final long RESEND_INTERVAL_MS = 60_000;

    /** IP每小时最大发送次数 */
    private static final int MAX_PER_HOUR_PER_IP = 5;

    /**
     * 根路径返回项目展示页
     */
    @GetMapping("/")
    public String index() {
        return "index";
    }

    /**
     * 跳转登录页
     */
    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }

    /**
     * 用户登录
     */
    @PostMapping("/login")
    @ResponseBody
    @OperLog(module = "用户认证", type = OperTypeEnum.LOGIN, desc = "用户登录")
    public Result<SysUser> login(@RequestBody @Valid LoginDTO dto, HttpSession session) {
        SysUser user = userService.login(dto);

        // 将用户信息存入Session
        SessionUtil.setCurrentUser(session, user);

        // 判断是否需要强制修改密码
        boolean needChangePassword = userService.needChangePassword(user);
        // 将needChangePassword标记存入Session，供页面判断是否强制弹出修改密码框
        session.setAttribute("needChangePassword", needChangePassword);
        user.setPassword(null);

        // 返回用户信息，通过extra字段传递needChangePassword标记
        return Result.success(user).putExtra("needChangePassword", needChangePassword);
    }

    /**
     * 用户登出
     */
    @PostMapping("/logout")
    @ResponseBody
    @OperLog(module = "用户认证", type = OperTypeEnum.LOGOUT, desc = "用户登出")
    public Result<Void> logout(HttpSession session) {
        SessionUtil.removeCurrentUser(session);
        return Result.success();
    }

    /**
     * 修改密码（所有角色通用）
     */
    @PostMapping("/updatePassword")
    @ResponseBody
    @OperLog(module = "用户认证", type = OperTypeEnum.UPDATE, desc = "修改密码")
    public Result<Void> updatePassword(@RequestBody @Valid PasswordDTO dto, HttpSession session) {
        Long userId = SessionUtil.getCurrentUserId(session);
        userService.updatePassword(dto, userId);
        // 清除needChangePassword标记
        session.setAttribute("needChangePassword", false);
        return Result.success();
    }

    /**
     * 获取当前登录用户信息
     */
    @GetMapping("/currentUser")
    @ResponseBody
    public Result<SysUser> getCurrentUser(HttpSession session) {
        SysUser user = SessionUtil.getCurrentUser(session);
        if (user == null) {
            return Result.unauthorized("未登录");
        }
        // 查询最新用户信息
        SysUser latestUser = userService.getUserById(user.getUserId());
        return Result.success(latestUser);
    }

    /**
     * 判断是否需要强制修改密码
     */
    @GetMapping("/needChangePassword")
    @ResponseBody
    public Result<Boolean> needChangePassword(HttpSession session) {
        SysUser user = SessionUtil.getCurrentUser(session);
        if (user == null) {
            return Result.unauthorized("未登录");
        }
        boolean need = userService.needChangePassword(user);
        return Result.success(need);
    }

    /**
     * 发送短信验证码（忘记密码流程）
     */
    @PostMapping("/send-code")
    @ResponseBody
    public Result<Void> sendCode(@RequestBody Map<String, String> body,
                                  HttpSession session,
                                  HttpServletRequest request) {
        String phone = body.get("phone");
        if (phone == null || phone.isBlank()) {
            return Result.badRequest("请输入手机号");
        }

        // 校验手机号是否存在
        try {
            userService.getUserByPhone(phone);
        } catch (BusinessException e) {
            return Result.fail(BusinessException.CODE_NOT_FOUND, "该手机号未注册");
        }

        // 校验60s内未重复发送
        Long lastTime = (Long) session.getAttribute("lastSendCodeTime");
        if (lastTime != null && System.currentTimeMillis() - lastTime < RESEND_INTERVAL_MS) {
            return Result.badRequest("请60秒后再试");
        }

        // 校验IP每小时发送次数
        String ip = getClientIp(request);
        if (!checkIpLimit(ip)) {
            return Result.badRequest("操作过于频繁，请稍后再试");
        }

        // 生成6位随机验证码
        String code = String.format("%06d", (int) (Math.random() * 1_000_000));

        // 发送验证码（演示模式输出到控制台）
        smsService.sendVerificationCode(phone, code);

        // 存入Session
        session.setAttribute("forgotPasswordCode", code);
        session.setAttribute("forgotPasswordCodeTime", System.currentTimeMillis());
        session.setAttribute("forgotPasswordPhone", phone);
        session.setAttribute("lastSendCodeTime", System.currentTimeMillis());

        return Result.success();
    }

    /**
     * 验证码校验并重置密码（忘记密码流程）
     */
    @PostMapping("/reset-password")
    @ResponseBody
    @OperLog(module = "用户认证", type = OperTypeEnum.UPDATE, desc = "忘记密码重置")
    public Result<Void> resetPassword(@RequestBody Map<String, String> body,
                                       HttpSession session) {
        String phone = body.get("phone");
        String code = body.get("code");
        String newPassword = body.get("newPassword");
        String confirmPassword = body.get("confirmPassword");

        // 基础参数校验
        if (phone == null || phone.isBlank()
                || code == null || code.isBlank()
                || newPassword == null || newPassword.isBlank()
                || confirmPassword == null || confirmPassword.isBlank()) {
            return Result.badRequest("请填写完整信息");
        }

        // 校验验证码
        String sessionCode = (String) session.getAttribute("forgotPasswordCode");
        Long codeTime = (Long) session.getAttribute("forgotPasswordCodeTime");
        String sessionPhone = (String) session.getAttribute("forgotPasswordPhone");

        if (sessionCode == null || codeTime == null) {
            return Result.badRequest("请先获取验证码");
        }
        if (System.currentTimeMillis() - codeTime > CODE_EXPIRE_MS) {
            clearSessionCode(session);
            return Result.badRequest("验证码已过期，请重新获取");
        }
        if (!sessionCode.equals(code)) {
            return Result.badRequest("验证码错误");
        }
        if (!phone.equals(sessionPhone)) {
            return Result.badRequest("手机号与获取验证码时不一致");
        }

        // 校验新密码
        if (newPassword.length() < 6 || newPassword.length() > 20) {
            return Result.badRequest("密码长度6-20位");
        }
        if (!newPassword.equals(confirmPassword)) {
            return Result.badRequest("两次密码输入不一致");
        }

        // 重置密码
        try {
            userService.resetPassword(phone, newPassword);
        } catch (BusinessException e) {
            return Result.fail(e.getCode(), e.getMsg());
        }

        // 清除Session中的验证码信息
        clearSessionCode(session);

        return Result.success();
    }

    // ==================== 私有辅助方法 ====================

    /**
     * 清除Session中的验证码
     */
    private void clearSessionCode(HttpSession session) {
        session.removeAttribute("forgotPasswordCode");
        session.removeAttribute("forgotPasswordCodeTime");
        session.removeAttribute("forgotPasswordPhone");
    }

    /**
     * 获取客户端真实IP
     */
    private String getClientIp(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isBlank() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("X-Real-IP");
        }
        if (ip == null || ip.isBlank() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        if (ip != null && ip.contains(",")) {
            ip = ip.split(",")[0].trim();
        }
        return ip != null ? ip : "unknown";
    }

    /**
     * 检查IP是否超过每小时发送限制
     */
    private synchronized boolean checkIpLimit(String ip) {
        long oneHourAgo = System.currentTimeMillis() - 3_600_000;
        List<Long> times = ipSendRecords.computeIfAbsent(ip, k -> new ArrayList<>());
        times.removeIf(t -> t < oneHourAgo);
        if (times.size() >= MAX_PER_HOUR_PER_IP) {
            return false;
        }
        times.add(System.currentTimeMillis());
        return true;
    }
}
