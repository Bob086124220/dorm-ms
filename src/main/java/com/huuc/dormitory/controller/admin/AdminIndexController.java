package com.huuc.dormitory.controller.admin;

import com.huuc.dormitory.common.result.Result;
import com.huuc.dormitory.common.utils.SessionUtil;
import com.huuc.dormitory.service.AdminDashboardService;
import com.huuc.dormitory.vo.AdminDashboardVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;

/**
 * 管理员首页控制器
 */
@Controller
@RequestMapping("/admin")
public class AdminIndexController {

    @Autowired
    private AdminDashboardService adminDashboardService;

    /**
     * 管理员首页
     */
    @GetMapping("/index")
    public String index() {
        return "admin/index";
    }

    /**
     * 管理员看板聚合数据
     */
    @GetMapping("/dashboard")
    @ResponseBody
    public Result<AdminDashboardVO> dashboard(HttpSession session) {
        Long adminUserId = SessionUtil.getCurrentUserId(session);
        AdminDashboardVO vo = adminDashboardService.getDashboard(adminUserId);
        return Result.success(vo);
    }
}
