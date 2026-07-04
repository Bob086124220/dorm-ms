package com.huuc.dormitory.service;

import com.github.pagehelper.PageInfo;
import com.huuc.dormitory.dto.RoomDTO;
import com.huuc.dormitory.entity.DormRoom;
import com.huuc.dormitory.vo.RoomVO;

import java.util.List;

/**
 * 房间服务接口
 */
public interface RoomService {

    /**
     * 根据ID获取房间详情
     */
    RoomVO getRoomById(Long roomId);

    /**
     * 分页查询房间列表
     */
    PageInfo<RoomVO> getRoomList(DormRoom query, Integer pageNum, Integer pageSize);

    /**
     * 根据楼栋ID获取房间列表
     */
    List<RoomVO> getRoomsByBuildingId(Long buildingId);

    /**
     * 根据楼栋ID分页查询房间列表
     */
    PageInfo<RoomVO> getRoomsByBuildingIdPage(Long buildingId, Integer pageNum, Integer pageSize);

    /**
     * 新增房间
     *
     * @param dto        房间信息
     * @param operatorId 操作人ID
     * @throws com.huuc.dormitory.common.exception.BusinessException 楼栋不存在、楼层超出范围、房间号已存在
     */
    void addRoom(RoomDTO dto, Long operatorId);

    /**
     * 编辑房间
     *
     * @param dto        房间信息（必须包含roomId）
     * @param operatorId 操作人ID
     * @throws com.huuc.dormitory.common.exception.BusinessException 房间不存在、楼栋不存在、房间号已存在
     */
    void updateRoom(RoomDTO dto, Long operatorId);

    /**
     * 删除房间（逻辑删除）
     *
     * @param roomId     房间ID
     * @param operatorId 操作人ID
     * @throws com.huuc.dormitory.common.exception.BusinessException 房间不存在、房间下存在床位
     */
    void deleteRoom(Long roomId, Long operatorId);
}
