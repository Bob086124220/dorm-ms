package com.huuc.dormitory.dao;

import com.huuc.dormitory.entity.DormRepair;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import java.time.LocalDateTime;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

/**
 * DormRepairMapper单元测试
 */
@DisplayName("DormRepairMapper报修Mapper测试")
class DormRepairMapperTest extends BaseMapperTest {

    @Autowired
    private DormRepairMapper repairMapper;

    @Test
    @DisplayName("selectById_存在记录_返回记录信息")
    void selectById_存在记录_返回记录信息() {
        DormRepair repair = repairMapper.selectById(1L);

        assertNotNull(repair);
        assertEquals(1L, repair.getRepairId());
    }

    @Test
    @DisplayName("selectByStudentId_查询学生报修_返回报修列表")
    void selectByStudentId_查询学生报修_返回报修列表() {
        List<DormRepair> repairs = repairMapper.selectByStudentId(4L);

        assertNotNull(repairs);
    }

    @Test
    @DisplayName("selectList_按状态筛选_返回匹配列表")
    void selectList_按状态筛选_返回匹配列表() {
        DormRepair query = new DormRepair();
        query.setRepairStatus(0);

        List<DormRepair> repairs = repairMapper.selectList(query);

        assertNotNull(repairs);
        repairs.forEach(r -> assertEquals(0, r.getRepairStatus()));
    }

    @Test
    @DisplayName("selectList_按报修类型筛选_返回匹配列表")
    void selectList_按报修类型筛选_返回匹配列表() {
        DormRepair query = new DormRepair();
        query.setRepairType(1);

        List<DormRepair> repairs = repairMapper.selectList(query);

        assertNotNull(repairs);
        repairs.forEach(r -> assertEquals(1, r.getRepairType()));
    }

    @Test
    @DisplayName("selectByBuildingId_按楼栋查询_返回该楼栋报修")
    void selectByBuildingId_按楼栋查询_返回该楼栋报修() {
        List<DormRepair> repairs = repairMapper.selectByBuildingId(1L, 1);

        assertNotNull(repairs);
    }

    @Test
    @DisplayName("selectListByStudentNo_按学号模糊查询_返回匹配记录")
    void selectListByStudentNo_按学号模糊查询_返回匹配记录() {
        List<DormRepair> repairs = repairMapper.selectListByStudentNo("2022", null, null);

        assertNotNull(repairs);
    }

    @Test
    @DisplayName("selectListByStudentNo_按学号和状态查询_返回匹配记录")
    void selectListByStudentNo_按学号和状态查询_返回匹配记录() {
        List<DormRepair> repairs = repairMapper.selectListByStudentNo("2022", null, 0);

        assertNotNull(repairs);
        repairs.forEach(r -> assertEquals(0, r.getRepairStatus()));
    }

    @Test
    @DisplayName("insert_新增报修记录_返回自增ID")
    void insert_新增报修记录_返回自增ID() {
        DormRepair repair = new DormRepair();
        repair.setStudentId(4L);
        repair.setRoomId(101L);
        repair.setRepairType(1);
        repair.setRepairContent("测试报修内容");
        repair.setContactPhone("13800000000");
        repair.setSubmitTime(LocalDateTime.now());
        repair.setRepairStatus(0);

        int rows = repairMapper.insert(repair);

        assertEquals(1, rows);
        assertNotNull(repair.getRepairId());
    }

    @Test
    @DisplayName("update_更新报修状态_返回影响行数")
    void update_更新报修状态_返回影响行数() {
        DormRepair repair = new DormRepair();
        repair.setRepairId(1L);
        repair.setRepairStatus(1);
        repair.setHandlerId(2L);

        int rows = repairMapper.update(repair);

        assertEquals(1, rows);
    }

    @Test
    @DisplayName("update_完结报修_更新处理结果和完成时间")
    void update_完结报修_更新处理结果和完成时间() {
        DormRepair repair = new DormRepair();
        repair.setRepairId(1L);
        repair.setRepairStatus(2);
        repair.setHandleResult("已修复");
        repair.setFinishTime(LocalDateTime.now());

        int rows = repairMapper.update(repair);

        assertEquals(1, rows);
    }
}
