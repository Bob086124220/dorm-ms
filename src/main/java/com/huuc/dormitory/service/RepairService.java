package com.huuc.dormitory.service;

import com.github.pagehelper.PageInfo;
import com.huuc.dormitory.dto.RepairDTO;
import com.huuc.dormitory.dto.RepairHandleDTO;
import com.huuc.dormitory.entity.DormRepair;
import com.huuc.dormitory.vo.RepairVO;

/**
 * 报修服务接口
 */
public interface RepairService {

    /**
     * 根据ID获取报修详情
     */
    RepairVO getRepairById(Long repairId);

    /**
     * 分页查询报修列表
     */
    PageInfo<RepairVO> getRepairList(DormRepair query, Integer pageNum, Integer pageSize);

    /**
     * 按学号模糊查询报修列表
     */
    PageInfo<RepairVO> getRepairListByStudentNo(String studentNo, Integer repairType, Integer repairStatus, Integer pageNum, Integer pageSize);

    /**
     * 分页查询我的报修
     */
    PageInfo<RepairVO> getMyRepairs(Long studentId, Integer pageNum, Integer pageSize);

    /**
     * 分页查询楼栋报修
     */
    PageInfo<RepairVO> getRepairsByBuildingId(Long buildingId, Integer repairStatus, Integer pageNum, Integer pageSize);

    /**
     * 提交报修
     *
     * @param dto       报修参数（报修类型、内容、联系电话）
     * @param studentId 学生ID
     * @throws com.huuc.dormitory.common.exception.BusinessException 无在住记录、床位信息异常
     */
    void submitRepair(RepairDTO dto, Long studentId);

    /**
     * 接单处理（状态从待处理变为处理中）
     *
     * @param repairId  报修ID
     * @param handlerId 处理人ID
     * @throws com.huuc.dormitory.common.exception.BusinessException 报修不存在、状态无法接单
     */
    void handleRepair(Long repairId, Long handlerId);

    /**
     * 完结报修（状态从处理中变为已完成）
     *
     * @param repairId  报修ID
     * @param dto       处理结果参数
     * @param handlerId 处理人ID
     * @throws com.huuc.dormitory.common.exception.BusinessException 报修不存在、状态无法完结
     */
    void completeRepair(Long repairId, RepairHandleDTO dto, Long handlerId);
}
