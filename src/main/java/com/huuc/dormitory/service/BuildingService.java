package com.huuc.dormitory.service;

import com.github.pagehelper.PageInfo;
import com.huuc.dormitory.dto.BuildingDTO;
import com.huuc.dormitory.entity.DormBuilding;
import com.huuc.dormitory.vo.BuildingVO;

import java.util.List;

/**
 * 楼栋服务接口
 */
public interface BuildingService {

    /**
     * 根据ID获取楼栋详情
     */
    BuildingVO getBuildingById(Long buildingId);

    /**
     * 获取所有楼栋列表（只读）
     */
    List<BuildingVO> getAllBuildings();

    /**
     * 分页查询楼栋列表
     */
    PageInfo<BuildingVO> getBuildingList(DormBuilding query, Integer pageNum, Integer pageSize);

    /**
     * 根据宿管ID获取楼栋列表
     */
    List<BuildingVO> getBuildingsByManagerId(Long managerId);

    /**
     * 根据宿管ID分页查询楼栋列表
     */
    PageInfo<BuildingVO> getBuildingsByManagerIdPage(Long managerId, Integer pageNum, Integer pageSize);

    /**
     * 新增楼栋
     *
     * @param dto        楼栋信息
     * @param operatorId 操作人ID
     * @throws com.huuc.dormitory.common.exception.BusinessException 楼栋编号已存在
     */
    void addBuilding(BuildingDTO dto, Long operatorId);

    /**
     * 编辑楼栋
     *
     * @param dto        楼栋信息（必须包含buildingId）
     * @param operatorId 操作人ID
     * @throws com.huuc.dormitory.common.exception.BusinessException 楼栋不存在、楼栋编号已存在
     */
    void updateBuilding(BuildingDTO dto, Long operatorId);

    /**
     * 删除楼栋（逻辑删除）
     *
     * @param buildingId 楼栋ID
     * @param operatorId 操作人ID
     * @throws com.huuc.dormitory.common.exception.BusinessException 楼栋不存在、楼栋下存在房间
     */
    void deleteBuilding(Long buildingId, Long operatorId);
}
