package com.huuc.dormitory.vo;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

/**
 * 宿管看板聚合VO
 */
@Getter
@Setter
public class DormDashboardVO {

    /** 管理楼栋名称列表 */
    private List<String> managedBuildings;

    /** 管理楼栋数 */
    private int buildingCount;

    /** 整体入住率（百分比） */
    private double occupancyRate;

    /** 空余床位数 */
    private int freeBedCount;

    /** 维修中报修数（status=PROCESSING） */
    private int processingRepairCount;

    /** 今日新增入住数 */
    private int todayNewCheckinCount;

    /** 楼层入住分布 */
    private List<FloorOccupancyItem> floorOccupancy;

    /** 报修状态占比 */
    private List<RepairStatusItem> repairStatusPie;

    /** 待处理报修列表（前5条） */
    private List<PendingRepairItem> pendingRepairs;

    /** 超时报修数 */
    private int timeoutRepairCount;

    /** 待审批调宿数 */
    private int pendingMoveCount;

    /** 在访未离校人数 */
    private int activeVisitorCount;

    // ==================== 内部类 ====================

    @Getter
    @Setter
    public static class FloorOccupancyItem {
        private String floor;
        private double rate;
    }

    @Getter
    @Setter
    public static class RepairStatusItem {
        private String name;
        private int value;
    }

    @Getter
    @Setter
    public static class PendingRepairItem {
        private Long id;
        private String title;
        private int status;
        private String createTime;
    }
}
