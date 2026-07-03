package com.huuc.dormitory.service;

import com.huuc.dormitory.vo.DormDashboardVO;

/**
 * 宿管看板服务接口
 */
public interface DormDashboardService {

    /**
     * 获取宿管看板聚合数据
     *
     * @param dormManagerId 宿管用户ID
     */
    DormDashboardVO getDashboard(Long dormManagerId);
}
