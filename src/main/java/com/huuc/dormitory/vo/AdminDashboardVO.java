package com.huuc.dormitory.vo;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

/**
 * 管理员看板聚合VO
 */
@Getter
@Setter
public class AdminDashboardVO {

    /** 整体入住率（百分比） */
    private double occupancyRate;

    /** 本月报修量 */
    private int monthRepairCount;

    /** 本月晚归人次 */
    private int monthLateReturnCount;

    /** 本月访客量 */
    private int monthVisitorCount;

    /** 各楼栋入住率 */
    private List<BuildingOccupancyItem> buildingOccupancy;

    /** 近6月业务趋势 */
    private List<MonthlyTrendItem> monthlyTrend;

    /** 待处理事项列表（含报修+调宿，前5条） */
    private List<PendingItem> pendingItems;

    /** 待处理报修数（含待处理+处理中） */
    private int pendingRepairCount;

    /** 超时报修数 */
    private int timeoutRepairCount;

    /** 待审批调宿数 */
    private int pendingMoveCount;

    /** 近期操作日志（当前管理员最近5条） */
    private List<RecentLogItem> recentLogs;

    /** 近30天业务构成 */
    private RecentThirtyDays recentThirtyDays;

    // ==================== 内部类 ====================

    @Getter
    @Setter
    public static class BuildingOccupancyItem {
        private String buildingName;
        private double rate;
    }

    @Getter
    @Setter
    public static class MonthlyTrendItem {
        private String month;
        private int repair;
        private int lateReturn;
        private int visitor;
        private int checkin;
    }

    @Getter
    @Setter
    public static class PendingItem {
        /** 事项类型：repair / move */
        private String type;
        /** 事项描述 */
        private String title;
        /** 原始状态码 */
        private int status;
        /** 状态文本：待处理 / 已超时 / 处理中 / 待审批 */
        private String statusText;
        /** 提交时间 */
        private String createTime;
    }

    @Getter
    @Setter
    public static class RecentLogItem {
        private Long id;
        private String operType;
        private String module;
        private String operTime;
    }

    @Getter
    @Setter
    public static class RecentThirtyDays {
        private int repair;
        private int lateReturn;
        private int visitor;
        private int checkin;
    }
}
