package com.huuc.dormitory.controller.dorm;

import com.huuc.dormitory.common.result.Result;
import com.huuc.dormitory.common.utils.SessionUtil;
import com.huuc.dormitory.service.DormDashboardService;
import com.huuc.dormitory.vo.DormDashboardVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;

/**
 * 宿管首页控制器
 */
@Controller
@RequestMapping("/dorm")
public class DormIndexController {

    @Autowired
    private DormDashboardService dormDashboardService;

    /**
     * 宿管首页
     */
    @GetMapping("/index")
    public String index() {
        return "dorm/index";
    }

    /**
     * 宿管看板聚合数据
     */
    @GetMapping("/dashboard")
    @ResponseBody
    public Result<DormDashboardVO> dashboard(HttpSession session) {
        Long managerId = SessionUtil.getCurrentUserId(session);
        DormDashboardVO vo = dormDashboardService.getDashboard(managerId);
        return Result.success(vo);
    }
}
