package com.huuc.dormitory.service;

import com.huuc.dormitory.vo.StudentDashboardVO;

/**
 * 学生看板服务接口
 */
public interface StudentDashboardService {

    /**
     * 获取学生看板轻量聚合数据
     *
     * @param studentId 学生用户ID
     */
    StudentDashboardVO getDashboard(Long studentId);
}
