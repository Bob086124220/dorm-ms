package com.huuc.dormitory.controller.admin;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.huuc.dormitory.common.aop.OperLog;
import com.huuc.dormitory.common.enums.OperTypeEnum;
import com.huuc.dormitory.common.exception.BusinessException;
import com.huuc.dormitory.common.result.Result;
import com.huuc.dormitory.common.utils.SessionUtil;
import com.huuc.dormitory.dto.ImportResultDTO;
import com.huuc.dormitory.dto.UserDTO;
import com.huuc.dormitory.entity.SysUser;
import com.huuc.dormitory.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;
import java.util.List;

/**
 * 管理员端用户管理控制器
 */
@Controller
@RequestMapping("/admin/user")
public class AdminUserController {

    @Autowired
    private UserService userService;

    /**
     * 用户列表页面
     */
    @GetMapping("/list")
    public String listPage() {
        return "admin/user/list";
    }

    /**
     * 新增用户页面
     */
    @GetMapping("/addPage")
    public String addPage() {
        return "admin/user/add";
    }

    /**
     * 编辑用户页面
     */
    @GetMapping("/editPage")
    public String editPage() {
        return "admin/user/edit";
    }

    /**
     * 获取用户详情
     *
     * @param userId 用户ID
     * @return 用户信息（密码字段已清空）
     */
    @GetMapping("/detail/{userId}")
    @ResponseBody
    public Result<SysUser> getUserById(@PathVariable Long userId) {
        SysUser user = userService.getUserById(userId);
        return Result.success(user);
    }

    /**
     * 查询用户列表（分页）
     */
    @GetMapping("/page")
    @ResponseBody
    public Result<PageInfo<SysUser>> getUserPage(
            @RequestParam(required = false) String username,
            @RequestParam(required = false) String realName,
            @RequestParam(required = false) Integer roleType,
            @RequestParam(required = false) Integer status,
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize) {

        SysUser query = new SysUser();
        query.setUsername(username);
        query.setRealName(realName);
        query.setRoleType(roleType);
        query.setStatus(status);

        PageHelper.startPage(pageNum, pageSize);
        List<SysUser> users = userService.getUserList(query);
        PageInfo<SysUser> pageInfo = new PageInfo<>(users);

        return Result.success(pageInfo);
    }

    /**
     * 新增用户
     */
    @PostMapping("/add")
    @ResponseBody
    @OperLog(module = "用户管理", type = OperTypeEnum.ADD, desc = "新增用户")
    public Result<Void> addUser(@RequestBody @Valid UserDTO dto, HttpSession session) {
        userService.addUser(dto);
        return Result.success();
    }

    /**
     * 编辑用户
     */
    @PostMapping("/update")
    @ResponseBody
    @OperLog(module = "用户管理", type = OperTypeEnum.UPDATE, desc = "编辑用户")
    public Result<Void> updateUser(@RequestBody @Valid UserDTO dto, HttpSession session) {
        userService.updateUser(dto);
        return Result.success();
    }

    /**
     * 启用/禁用用户
     */
    @PostMapping("/toggleStatus/{userId}")
    @ResponseBody
    @OperLog(module = "用户管理", type = OperTypeEnum.UPDATE, desc = "切换用户状态")
    public Result<Void> toggleUserStatus(@PathVariable Long userId, HttpSession session) {
        userService.toggleUserStatus(userId);
        return Result.success();
    }

    /**
     * 删除用户（逻辑删除）
     */
    @PostMapping("/delete/{userId}")
    @ResponseBody
    @OperLog(module = "用户管理", type = OperTypeEnum.DELETE, desc = "删除用户")
    public Result<Void> deleteUser(@PathVariable Long userId, HttpSession session) {
        Long currentUserId = SessionUtil.getCurrentUserId(session);
        if (currentUserId != null && currentUserId.equals(userId)) {
            return Result.fail(BusinessException.CODE_BAD_REQUEST, "不能删除自己的账号");
        }
        userService.deleteUser(userId);
        return Result.success();
    }

    /**
     * 根据角色类型查询用户列表
     */
    @GetMapping("/list/{roleType}")
    @ResponseBody
    public Result<List<SysUser>> getUsersByRoleType(@PathVariable Integer roleType) {
        List<SysUser> users = userService.getUsersByRoleType(roleType);
        return Result.success(users);
    }

    /**
     * 批量导入用户
     */
    @PostMapping("/import")
    @ResponseBody
    @OperLog(module = "用户管理", type = OperTypeEnum.ADD, desc = "批量导入用户")
    public Result<ImportResultDTO> importUsers(@RequestParam("file") MultipartFile file) {
        // 校验文件非空
        if (file.isEmpty()) {
            throw new BusinessException(BusinessException.CODE_BAD_REQUEST, "请选择要导入的文件");
        }

        // 校验文件扩展名
        String originalFilename = file.getOriginalFilename();
        if (originalFilename == null || !originalFilename.toLowerCase().endsWith(".csv")) {
            throw new BusinessException(BusinessException.CODE_BAD_REQUEST, "仅支持CSV格式文件");
        }

        ImportResultDTO result = userService.importUsers(file);
        return Result.success(result);
    }
}
