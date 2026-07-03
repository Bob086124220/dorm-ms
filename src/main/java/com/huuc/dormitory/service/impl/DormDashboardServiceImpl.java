package com.huuc.dormitory.service.impl;

import com.huuc.dormitory.dao.*;
import com.huuc.dormitory.entity.*;
import com.huuc.dormitory.service.BuildingService;
import com.huuc.dormitory.service.DormDashboardService;
import com.huuc.dormitory.service.RoomService;
import com.huuc.dormitory.vo.BuildingVO;
import com.huuc.dormitory.vo.DormDashboardVO;
import com.huuc.dormitory.vo.DormDashboardVO.FloorOccupancyItem;
import com.huuc.dormitory.vo.DormDashboardVO.PendingRepairItem;
import com.huuc.dormitory.vo.DormDashboardVO.RepairStatusItem;
import com.huuc.dormitory.vo.RoomVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 宿管看板服务实现
 */
@Service
public class DormDashboardServiceImpl implements DormDashboardService {

    @Autowired
    private BuildingService buildingService;

    @Autowired
    private RoomService roomService;

    @Autowired
    private DormBedMapper bedMapper;

    @Autowired
    private DormRepairMapper repairMapper;

    @Autowired
    private DormMoveApplyMapper moveApplyMapper;

    @Autowired
    private DormVisitorMapper visitorMapper;

    @Autowired
    private DormCheckinRecordMapper checkinRecordMapper;

    @Override
    public DormDashboardVO getDashboard(Long dormManagerId) {
        DormDashboardVO vo = new DormDashboardVO();

        List<BuildingVO> buildings = buildingService.getBuildingsByManagerId(dormManagerId);
        List<Long> buildingIds = buildings.stream()
                .map(BuildingVO::getBuildingId)
                .collect(Collectors.toList());

        // 管理楼栋信息
        vo.setManagedBuildings(buildings.stream()
                .map(BuildingVO::getBuildingName)
                .collect(Collectors.toList()));
        vo.setBuildingCount(buildings.size());

        if (buildings.isEmpty()) {
            return vo;
        }

        // 入住率 + 空余床位 + 楼层分布
        computeOccupancy(vo, buildings);

        // 维修中报修数 + 状态占比 + 待处理列表
        computeRepairStats(vo, buildingIds);

        // 今日新增入住
        computeTodayCheckins(vo, buildingIds);

        // 待审批调宿
        computePendingMoves(vo, buildingIds);

        // 在访未离校
        computeActiveVisitors(vo, buildingIds);

        return vo;
    }

    // ==================== 私有方法 ====================

    private void computeOccupancy(DormDashboardVO vo, List<BuildingVO> buildings) {
        int totalBeds = 0;
        int occupiedBeds = 0;
        Map<String, int[]> floorStats = new LinkedHashMap<>(); // floor → [total, occupied]

        for (BuildingVO building : buildings) {
            List<RoomVO> rooms = roomService.getRoomsByBuildingId(building.getBuildingId());
            for (RoomVO room : rooms) {
                List<DormBed> beds = bedMapper.selectByRoomId(room.getRoomId());
                String floorKey = room.getFloorNum() + "F";

                for (DormBed bed : beds) {
                    totalBeds++;
                    int[] stats = floorStats.computeIfAbsent(floorKey, k -> new int[2]);
                    stats[0]++;
                    if (bed.getBedStatus() != null && bed.getBedStatus() == 1) {
                        occupiedBeds++;
                        stats[1]++;
                    }
                }
            }
        }

        vo.setOccupancyRate(totalBeds == 0 ? 0 : Math.round(occupiedBeds * 1000.0 / totalBeds) / 10.0);
        vo.setFreeBedCount(totalBeds - occupiedBeds);

        // 楼层入住分布
        List<FloorOccupancyItem> floorList = new ArrayList<>();
        for (Map.Entry<String, int[]> entry : floorStats.entrySet()) {
            FloorOccupancyItem item = new FloorOccupancyItem();
            item.setFloor(entry.getKey());
            int[] stats = entry.getValue();
            item.setRate(stats[0] == 0 ? 0 : Math.round(stats[1] * 1000.0 / stats[0]) / 10.0);
            floorList.add(item);
        }
        vo.setFloorOccupancy(floorList);
    }

    private void computeRepairStats(DormDashboardVO vo, List<Long> buildingIds) {
        List<PendingRepairItem> pendingItems = new ArrayList<>();
        int pendingCount = 0;
        int processingCount = 0;
        int completedCount = 0;
        int timeoutCount = 0;
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime timeoutThreshold = now.minusHours(24);

        for (Long bldId : buildingIds) {
            // 按状态加载
            List<DormRepair> pendingRepairs = repairMapper.selectByBuildingId(bldId, 0); // PENDING
            List<DormRepair> processingRepairs = repairMapper.selectByBuildingId(bldId, 1); // PROCESSING
            List<DormRepair> completedRepairs = repairMapper.selectByBuildingId(bldId, 2); // COMPLETED

            pendingCount += pendingRepairs.size();
            processingCount += processingRepairs.size();
            completedCount += completedRepairs.size();

            for (DormRepair r : pendingRepairs) {
                PendingRepairItem item = new PendingRepairItem();
                item.setId(r.getRepairId());
                item.setTitle(r.getRepairContent());
                item.setStatus(0);
                item.setCreateTime(r.getSubmitTime() != null
                        ? r.getSubmitTime().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"))
                        : "");
                pendingItems.add(item);

                if (r.getSubmitTime() != null && r.getSubmitTime().isBefore(timeoutThreshold)) {
                    timeoutCount++;
                }
            }
        }

        vo.setProcessingRepairCount(processingCount);
        vo.setTimeoutRepairCount(timeoutCount);

        // 待处理列表（前5条）
        pendingItems.sort((a, b) -> b.getCreateTime().compareTo(a.getCreateTime()));
        vo.setPendingRepairs(pendingItems.size() > 5 ? pendingItems.subList(0, 5) : pendingItems);

        // 报修状态饼图
        List<RepairStatusItem> pieData = new ArrayList<>();
        addPieSlice(pieData, "待处理", pendingCount);
        addPieSlice(pieData, "处理中", processingCount);
        addPieSlice(pieData, "已完成", completedCount);
        vo.setRepairStatusPie(pieData);
    }

    private void computeTodayCheckins(DormDashboardVO vo, List<Long> buildingIds) {
        LocalDate today = LocalDate.now();
        int count = 0;
        for (Long bldId : buildingIds) {
            List<DormCheckinRecord> checkins = checkinRecordMapper.selectByBuildingId(bldId);
            for (DormCheckinRecord c : checkins) {
                if (c.getCheckinTime() != null && c.getCheckinTime().toLocalDate().equals(today)) {
                    count++;
                }
            }
        }
        vo.setTodayNewCheckinCount(count);
    }

    private void computePendingMoves(DormDashboardVO vo, List<Long> buildingIds) {
        int count = 0;
        for (Long bldId : buildingIds) {
            List<DormMoveApply> moves = moveApplyMapper.selectListByBuildingId(bldId, 0); // PENDING
            count += moves.size();
        }
        vo.setPendingMoveCount(count);
    }

    private void computeActiveVisitors(DormDashboardVO vo, List<Long> buildingIds) {
        int count = 0;
        for (Long bldId : buildingIds) {
            List<DormVisitor> visitors = visitorMapper.selectByBuildingId(bldId);
            for (DormVisitor v : visitors) {
                if (v.getLeaveTime() == null) {
                    count++;
                }
            }
        }
        vo.setActiveVisitorCount(count);
    }

    private void addPieSlice(List<RepairStatusItem> list, String name, int value) {
        RepairStatusItem item = new RepairStatusItem();
        item.setName(name);
        item.setValue(value);
        list.add(item);
    }
}
