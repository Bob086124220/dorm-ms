package com.huuc.dormitory.service;

import com.huuc.dormitory.vo.AdminDashboardVO;

/**
 * 管理员看板服务接口
 */
public interface AdminDashboardService {

    /**
     * 获取管理员看板聚合数据
     *
     * @param adminUserId 当前管理员用户ID
     */
    AdminDashboardVO getDashboard(Long adminUserId);
}
