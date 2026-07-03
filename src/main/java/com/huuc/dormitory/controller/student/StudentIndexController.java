package com.huuc.dormitory.controller.student;

import com.huuc.dormitory.common.result.Result;
import com.huuc.dormitory.common.utils.SessionUtil;
import com.huuc.dormitory.service.StudentDashboardService;
import com.huuc.dormitory.vo.StudentDashboardVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;

/**
 * 学生首页控制器
 */
@Controller
@RequestMapping("/student")
public class StudentIndexController {

    @Autowired
    private StudentDashboardService studentDashboardService;

    /**
     * 学生首页
     */
    @GetMapping("/index")
    public String index() {
        return "student/index";
    }

    /**
     * 学生看板轻量聚合数据
     */
    @GetMapping("/dashboard")
    @ResponseBody
    public Result<StudentDashboardVO> dashboard(HttpSession session) {
        Long studentId = SessionUtil.getCurrentUserId(session);
        StudentDashboardVO vo = studentDashboardService.getDashboard(studentId);
        return Result.success(vo);
    }
}
