package com.huuc.dormitory.service.impl;

import com.huuc.dormitory.dao.*;
import com.huuc.dormitory.entity.*;
import com.huuc.dormitory.service.AdminDashboardService;
import com.huuc.dormitory.service.BuildingService;
import com.huuc.dormitory.service.RoomService;
import com.huuc.dormitory.vo.AdminDashboardVO;
import com.huuc.dormitory.vo.AdminDashboardVO.BuildingOccupancyItem;
import com.huuc.dormitory.vo.AdminDashboardVO.MonthlyTrendItem;
import com.huuc.dormitory.vo.AdminDashboardVO.PendingItem;
import com.huuc.dormitory.vo.AdminDashboardVO.RecentLogItem;
import com.huuc.dormitory.vo.BuildingVO;
import com.huuc.dormitory.vo.RoomVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 管理员看板服务实现
 */
@Service
public class AdminDashboardServiceImpl implements AdminDashboardService {

    @Autowired
    private BuildingService buildingService;

    @Autowired
    private RoomService roomService;

    @Autowired
    private DormBedMapper bedMapper;

    @Autowired
    private DormRepairMapper repairMapper;

    @Autowired
    private DormLateReturnMapper lateReturnMapper;

    @Autowired
    private DormVisitorMapper visitorMapper;

    @Autowired
    private DormCheckinRecordMapper checkinRecordMapper;

    @Autowired
    private DormMoveApplyMapper moveApplyMapper;

    @Autowired
    private SysOperLogMapper operLogMapper;

    @Override
    public AdminDashboardVO getDashboard(Long adminUserId) {
        AdminDashboardVO vo = new AdminDashboardVO();

        List<BuildingVO> buildings = buildingService.getAllBuildings();
        List<Long> buildingIds = buildings.stream()
                .map(BuildingVO::getBuildingId)
                .collect(Collectors.toList());

        String currentMonth = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM"));

        // 楼栋入住率 + 整体入住率
        computeOccupancy(vo, buildings);

        // 本月统计
        computeMonthlyStats(vo, buildingIds, currentMonth);

        // 近6月趋势
        computeMonthlyTrend(vo, buildingIds);

        // 待处理事项（报修 + 调宿）
        computePendingItems(vo, buildingIds);

        // 近期操作日志（当前管理员最近5条）
        computeRecentLogs(vo, adminUserId);

        return vo;
    }

    // ==================== 私有方法 ====================

    private void computeOccupancy(AdminDashboardVO vo, List<BuildingVO> buildings) {
        int totalBeds = 0;
        int occupiedBeds = 0;
        List<BuildingOccupancyItem> buildingOccupancyList = new ArrayList<>();

        for (BuildingVO building : buildings) {
            int bldTotal = 0;
            int bldOccupied = 0;
            List<RoomVO> rooms = roomService.getRoomsByBuildingId(building.getBuildingId());
            for (RoomVO room : rooms) {
                List<DormBed> beds = bedMapper.selectByRoomId(room.getRoomId());
                for (DormBed bed : beds) {
                    bldTotal++;
                    if (bed.getBedStatus() != null && bed.getBedStatus() == 1) {
                        bldOccupied++;
                    }
                }
            }
            totalBeds += bldTotal;
            occupiedBeds += bldOccupied;

            BuildingOccupancyItem item = new BuildingOccupancyItem();
            item.setBuildingName(building.getBuildingName());
            item.setRate(bldTotal == 0 ? 0 : Math.round(bldOccupied * 1000.0 / bldTotal) / 10.0);
            buildingOccupancyList.add(item);
        }

        vo.setOccupancyRate(totalBeds == 0 ? 0 : Math.round(occupiedBeds * 1000.0 / totalBeds) / 10.0);
        vo.setBuildingOccupancy(buildingOccupancyList);
    }

    private void computeMonthlyStats(AdminDashboardVO vo, List<Long> buildingIds, String currentMonth) {
        int repairCount = 0;
        int lateCount = 0;
        int visitorCount = 0;

        // 从各楼栋加载数据并统计本月
        for (Long bldId : buildingIds) {
            List<DormRepair> repairs = repairMapper.selectByBuildingId(bldId, null);
            repairCount += countInMonth(repairs, r -> r.getSubmitTime(), currentMonth);

            List<DormLateReturn> lateReturns = lateReturnMapper.selectByBuildingId(bldId);
            lateCount += countInMonth(lateReturns, DormLateReturn::getLateTime, currentMonth);

            List<DormVisitor> visitors = visitorMapper.selectByBuildingId(bldId);
            visitorCount += countInMonth(visitors, DormVisitor::getVisitTime, currentMonth);
        }

        vo.setMonthRepairCount(repairCount);
        vo.setMonthLateReturnCount(lateCount);
        vo.setMonthVisitorCount(visitorCount);
    }

    private void computeMonthlyTrend(AdminDashboardVO vo, List<Long> buildingIds) {
        // 近6个月（含本月）
        List<String> months = new ArrayList<>();
        for (int i = 5; i >= 0; i--) {
            months.add(LocalDate.now().minusMonths(i).format(DateTimeFormatter.ofPattern("yyyy-MM")));
        }

        // 加载全部数据
        List<DormRepair> allRepairs = loadAllRepairs(buildingIds);
        List<DormLateReturn> allLateReturns = loadAllLateReturns(buildingIds);
        List<DormVisitor> allVisitors = loadAllVisitors(buildingIds);
        List<DormCheckinRecord> allCheckins = loadAllCheckins(buildingIds);

        List<MonthlyTrendItem> trendList = new ArrayList<>();
        for (String month : months) {
            MonthlyTrendItem item = new MonthlyTrendItem();
            item.setMonth(month);
            item.setRepair(countInMonth(allRepairs, DormRepair::getSubmitTime, month));
            item.setLateReturn(countInMonth(allLateReturns, DormLateReturn::getLateTime, month));
            item.setVisitor(countInMonth(allVisitors, DormVisitor::getVisitTime, month));
            item.setCheckin(countInMonth(allCheckins, DormCheckinRecord::getCheckinTime, month));
            trendList.add(item);
        }
        vo.setMonthlyTrend(trendList);
    }

    private void computePendingItems(AdminDashboardVO vo, List<Long> buildingIds) {
        List<PendingItem> items = new ArrayList<>();
        int pendingCount = 0;
        int timeoutCount = 0;
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime timeoutThreshold = now.minusHours(24);

        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

        for (Long bldId : buildingIds) {
            // 待处理报修 (status=0)
            List<DormRepair> pendingRepairs = repairMapper.selectByBuildingId(bldId, 0);
            for (DormRepair r : pendingRepairs) {
                boolean timedOut = r.getSubmitTime() != null && r.getSubmitTime().isBefore(timeoutThreshold);
                PendingItem item = new PendingItem();
                item.setType("repair");
                item.setTitle(r.getRepairContent());
                item.setStatus(r.getRepairStatus());
                item.setStatusText(timedOut ? "已超时" : "待处理");
                item.setCreateTime(r.getSubmitTime() != null ? r.getSubmitTime().format(fmt) : "");
                items.add(item);
                pendingCount++;
                if (timedOut) timeoutCount++;
            }

            // 处理中报修 (status=1)
            List<DormRepair> processingRepairs = repairMapper.selectByBuildingId(bldId, 1);
            for (DormRepair r : processingRepairs) {
                PendingItem item = new PendingItem();
                item.setType("repair");
                item.setTitle(r.getRepairContent());
                item.setStatus(r.getRepairStatus());
                item.setStatusText("处理中");
                item.setCreateTime(r.getSubmitTime() != null ? r.getSubmitTime().format(fmt) : "");
                items.add(item);
                pendingCount++;
            }
        }

        // 待审批调宿
        DormMoveApply moveQuery = new DormMoveApply();
        moveQuery.setAuditStatus(0);
        List<DormMoveApply> pendingMoves = moveApplyMapper.selectList(moveQuery);
        vo.setPendingMoveCount(pendingMoves.size());
        for (DormMoveApply m : pendingMoves) {
            PendingItem item = new PendingItem();
            item.setType("move");
            item.setTitle(m.getApplyReason());
            item.setStatus(0);
            item.setStatusText("待审批");
            item.setCreateTime(m.getApplyTime() != null ? m.getApplyTime().format(fmt) : "");
            items.add(item);
        }

        // 按提交时间倒序，取前5条
        items.sort((a, b) -> b.getCreateTime().compareTo(a.getCreateTime()));
        vo.setPendingItems(items.size() > 5 ? items.subList(0, 5) : items);
        vo.setPendingRepairCount(pendingCount);
        vo.setTimeoutRepairCount(timeoutCount);
    }

    private void computeRecentLogs(AdminDashboardVO vo, Long adminUserId) {
        SysOperLog query = new SysOperLog();
        query.setOperatorId(adminUserId);
        List<SysOperLog> userLogs = operLogMapper.selectList(query);

        List<RecentLogItem> logItems = new ArrayList<>();
        int count = Math.min(userLogs.size(), 5);
        for (int i = 0; i < count; i++) {
            SysOperLog log = userLogs.get(i);
            RecentLogItem item = new RecentLogItem();
            item.setId(log.getLogId());
            item.setOperType(log.getOperType());
            item.setModule(log.getModuleName());
            item.setOperTime(log.getOperTime() != null
                    ? log.getOperTime().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"))
                    : "");
            logItems.add(item);
        }
        vo.setRecentLogs(logItems);
    }

    // ==================== 数据加载辅助 ====================

    private List<DormRepair> loadAllRepairs(List<Long> buildingIds) {
        List<DormRepair> all = new ArrayList<>();
        for (Long bldId : buildingIds) {
            all.addAll(repairMapper.selectByBuildingId(bldId, null));
        }
        return all;
    }

    private List<DormLateReturn> loadAllLateReturns(List<Long> buildingIds) {
        List<DormLateReturn> all = new ArrayList<>();
        for (Long bldId : buildingIds) {
            all.addAll(lateReturnMapper.selectByBuildingId(bldId));
        }
        return all;
    }

    private List<DormVisitor> loadAllVisitors(List<Long> buildingIds) {
        List<DormVisitor> all = new ArrayList<>();
        for (Long bldId : buildingIds) {
            all.addAll(visitorMapper.selectByBuildingId(bldId));
        }
        return all;
    }

    private List<DormCheckinRecord> loadAllCheckins(List<Long> buildingIds) {
        List<DormCheckinRecord> all = new ArrayList<>();
        for (Long bldId : buildingIds) {
            all.addAll(checkinRecordMapper.selectByBuildingId(bldId));
        }
        return all;
    }

    // ==================== 通用工具 ====================

    private <T> int countInMonth(List<T> records, java.util.function.Function<T, LocalDateTime> timeExtractor,
                                  String yearMonth) {
        int count = 0;
        for (T record : records) {
            LocalDateTime time = timeExtractor.apply(record);
            if (time != null && time.format(DateTimeFormatter.ofPattern("yyyy-MM")).equals(yearMonth)) {
                count++;
            }
        }
        return count;
    }
}
