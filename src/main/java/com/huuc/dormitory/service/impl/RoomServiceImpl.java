package com.huuc.dormitory.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.huuc.dormitory.common.constant.CommonConstants;
import com.huuc.dormitory.common.enums.RoomTypeEnum;
import com.huuc.dormitory.common.exception.BusinessException;
import com.huuc.dormitory.dao.DormBedMapper;
import com.huuc.dormitory.dao.DormBuildingMapper;
import com.huuc.dormitory.dao.DormRoomMapper;
import com.huuc.dormitory.dto.RoomDTO;
import com.huuc.dormitory.entity.DormBuilding;
import com.huuc.dormitory.entity.DormRoom;
import com.huuc.dormitory.service.RoomService;
import com.huuc.dormitory.vo.RoomVO;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

/**
 * 房间服务实现类
 */
@Service
public class RoomServiceImpl implements RoomService {

    @Autowired
    private DormRoomMapper dormRoomMapper;

    @Autowired
    private DormBuildingMapper dormBuildingMapper;

    @Autowired
    private DormBedMapper dormBedMapper;

    @Override
    public RoomVO getRoomById(Long roomId) {
        DormRoom room = dormRoomMapper.selectById(roomId);
        if (room == null) {
            throw new BusinessException(BusinessException.CODE_NOT_FOUND, "房间不存在");
        }
        return convertToVO(room);
    }

    @Override
    public PageInfo<RoomVO> getRoomList(DormRoom query, Integer pageNum, Integer pageSize) {
        List<DormRoom> rooms = dormRoomMapper.selectList(query);
        PageInfo<DormRoom> pageInfo = new PageInfo<>(rooms);

        // 转换为VO
        PageInfo<RoomVO> voPageInfo = new PageInfo<>();
        BeanUtils.copyProperties(pageInfo, voPageInfo);
        voPageInfo.setList(convertToVOList(rooms));

        return voPageInfo;
    }

    @Override
    public List<RoomVO> getRoomsByBuildingId(Long buildingId) {
        List<DormRoom> rooms = dormRoomMapper.selectByBuildingId(buildingId);
        return convertToVOList(rooms);
    }

    @Override
    public PageInfo<RoomVO> getRoomsByBuildingIdPage(Long buildingId, Integer pageNum, Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<DormRoom> rooms = dormRoomMapper.selectByBuildingId(buildingId);
        PageInfo<DormRoom> pageInfo = new PageInfo<>(rooms);

        PageInfo<RoomVO> voPageInfo = new PageInfo<>();
        BeanUtils.copyProperties(pageInfo, voPageInfo);
        voPageInfo.setList(convertToVOList(rooms));

        return voPageInfo;
    }

    /**
     * 新增房间
     * 校验：楼栋存在、楼层范围、房间号唯一
     */
    @Override
    @Transactional
    public void addRoom(RoomDTO dto, Long operatorId) {
        // 校验楼栋存在
        DormBuilding building = dormBuildingMapper.selectById(dto.getBuildingId());
        if (building == null) {
            throw new BusinessException(BusinessException.CODE_NOT_FOUND, "楼栋不存在");
        }

        // 校验楼层是否在楼栋范围内
        if (dto.getFloorNum() > building.getFloorCount()) {
            throw new BusinessException(BusinessException.CODE_BAD_REQUEST, "楼层超出楼栋范围");
        }

        // 校验同一楼栋下房间号是否重复
        DormRoom existRoom = dormRoomMapper.selectByBuildingIdAndRoomNo(dto.getBuildingId(), dto.getRoomNo());
        if (existRoom != null) {
            throw new BusinessException(BusinessException.CODE_CONFLICT, "该楼栋下已存在相同房间号");
        }

        // 构建房间对象
        DormRoom room = new DormRoom();
        room.setRoomNo(dto.getRoomNo());
        room.setBuildingId(dto.getBuildingId());
        room.setFloorNum(dto.getFloorNum());
        room.setBedTotal(dto.getBedTotal());
        room.setRoomType(dto.getRoomType());
        room.setRemark(dto.getRemark());
        room.setIsDeleted(CommonConstants.IS_DELETED_NO);

        dormRoomMapper.insert(room);
    }

    @Override
    @Transactional
    public void updateRoom(RoomDTO dto, Long operatorId) {
        // 校验房间存在
        DormRoom existRoom = dormRoomMapper.selectById(dto.getRoomId());
        if (existRoom == null) {
            throw new BusinessException(BusinessException.CODE_NOT_FOUND, "房间不存在");
        }

        // 校验楼栋存在
        DormBuilding building = dormBuildingMapper.selectById(dto.getBuildingId());
        if (building == null) {
            throw new BusinessException(BusinessException.CODE_NOT_FOUND, "楼栋不存在");
        }

        // 校验楼层是否在楼栋范围内
        if (dto.getFloorNum() > building.getFloorCount()) {
            throw new BusinessException(BusinessException.CODE_BAD_REQUEST, "楼层超出楼栋范围");
        }

        // 校验同一楼栋下房间号是否重复（排除自身）
        DormRoom query = dormRoomMapper.selectByBuildingIdAndRoomNo(dto.getBuildingId(), dto.getRoomNo());
        if (query != null && !query.getRoomId().equals(dto.getRoomId())) {
            throw new BusinessException(BusinessException.CODE_CONFLICT, "该楼栋下已存在相同房间号");
        }

        // 构建更新对象
        DormRoom room = new DormRoom();
        room.setRoomId(dto.getRoomId());
        room.setRoomNo(dto.getRoomNo());
        room.setBuildingId(dto.getBuildingId());
        room.setFloorNum(dto.getFloorNum());
        room.setBedTotal(dto.getBedTotal());
        room.setRoomType(dto.getRoomType());
        room.setRemark(dto.getRemark());

        dormRoomMapper.update(room);
    }

    /**
     * 删除房间（逻辑删除）
     * 校验：房间存在、下无床位
     */
    @Override
    @Transactional
    public void deleteRoom(Long roomId, Long operatorId) {
        // 校验房间存在
        DormRoom room = dormRoomMapper.selectById(roomId);
        if (room == null) {
            throw new BusinessException(BusinessException.CODE_NOT_FOUND, "房间不存在");
        }

        // 校验房间下是否存在床位
        int bedCount = dormRoomMapper.countBeds(roomId);
        if (bedCount > 0) {
            throw new BusinessException(BusinessException.CODE_CONFLICT, "该房间下存在床位，无法删除");
        }

        // 逻辑删除
        dormRoomMapper.updateDeleted(roomId, CommonConstants.IS_DELETED_YES);
    }

    /**
     * 实体转VO
     */
    private RoomVO convertToVO(DormRoom room) {
        RoomVO vo = new RoomVO();
        BeanUtils.copyProperties(room, vo);

        // 查询楼栋名称
        DormBuilding building = dormBuildingMapper.selectById(room.getBuildingId());
        if (building != null) {
            vo.setBuildingName(building.getBuildingName());
        }

        // 设置房间类型文本
        RoomTypeEnum roomTypeEnum = RoomTypeEnum.getByCode(room.getRoomType());
        if (roomTypeEnum != null) {
            vo.setRoomTypeText(roomTypeEnum.getDesc());
        }

        // 统计已入住床位数
        int totalBeds = dormBedMapper.countByRoomId(room.getRoomId());
        vo.setBedUsed(totalBeds);

        return vo;
    }

    /**
     * 实体列表转VO列表
     */
    private List<RoomVO> convertToVOList(List<DormRoom> rooms) {
        List<RoomVO> voList = new ArrayList<>();
        for (DormRoom room : rooms) {
            voList.add(convertToVO(room));
        }
        return voList;
    }
}
