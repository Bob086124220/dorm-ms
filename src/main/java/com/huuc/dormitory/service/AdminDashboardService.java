package com.huuc.dormitory.service;

import com.huuc.dormitory.vo.AdminDashboardVO;

/**
 * 管理员看板服务接口
 */
public interface AdminDashboardService {

    /**
     * 获取管理员看板聚合数据
     */
    AdminDashboardVO getDashboard();
}
