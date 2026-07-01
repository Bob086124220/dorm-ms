package com.huuc.dormitory.dao;

import com.huuc.dormitory.entity.DormRepair;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 报修Mapper接口
 */
public interface DormRepairMapper {

    /**
     * 根据ID查询报修
     */
    DormRepair selectById(Long repairId);

    /**
     * 根据学生ID查询报修列表
     */
    List<DormRepair> selectByStudentId(Long studentId);

    /**
     * 查询报修列表
     */
    List<DormRepair> selectList(DormRepair query);

    /**
     * 根据楼栋ID查询报修列表
     */
    List<DormRepair> selectByBuildingId(@Param("buildingId") Long buildingId, @Param("repairStatus") Integer repairStatus);

    /**
     * 插入报修
     */
    int insert(DormRepair repair);

    /**
     * 更新报修
     */
    int update(DormRepair repair);

    /**
     * 按学号模糊查询报修列表
     */
    List<DormRepair> selectListByStudentNo(@Param("studentNo") String studentNo, @Param("repairType") Integer repairType, @Param("repairStatus") Integer repairStatus);
}
