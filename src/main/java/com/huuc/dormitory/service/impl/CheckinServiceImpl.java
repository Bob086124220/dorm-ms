package com.huuc.dormitory.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.huuc.dormitory.common.enums.BedStatusEnum;
import com.huuc.dormitory.common.enums.CheckinStatusEnum;
import com.huuc.dormitory.common.enums.UserStatusEnum;
import com.huuc.dormitory.common.exception.BusinessException;
import com.huuc.dormitory.dao.*;
import com.huuc.dormitory.dto.CheckinDTO;
import com.huuc.dormitory.entity.*;
import com.huuc.dormitory.service.CheckinService;
import com.huuc.dormitory.vo.CheckinVO;
import com.huuc.dormitory.vo.RoommateVO;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * 入住服务实现类
 */
@Service
public class CheckinServiceImpl implements CheckinService {

    @Autowired
    private DormCheckinRecordMapper checkinRecordMapper;

    @Autowired
    private DormBedMapper bedMapper;

    @Autowired
    private DormRoomMapper roomMapper;

    @Autowired
    private DormBuildingMapper buildingMapper;

    @Autowired
    private SysUserMapper userMapper;

    @Override
    public CheckinVO getCheckinByStudentId(Long studentId) {
        PageHelper.clearPage();
        DormCheckinRecord record = checkinRecordMapper.selectActiveByStudentId(studentId);
        if (record == null) {
            return null;
        }
        return convertToVO(record);
    }

    @Override
    public List<RoommateVO> getRoommatesByStudentId(Long studentId) {
        PageHelper.clearPage();
        List<RoommateVO> roommateList = new ArrayList<>();

        // 查询学生在住记录
        DormCheckinRecord record = checkinRecordMapper.selectActiveByStudentId(studentId);
        if (record == null) {
            return roommateList;
        }

        // 查询床位信息，获取房间ID
        DormBed bed = bedMapper.selectById(record.getBedId());
        if (bed == null) {
            return roommateList;
        }

        // 查询同房间其他在住学生
        List<DormCheckinRecord> roommates = checkinRecordMapper.selectActiveByRoomId(bed.getRoomId(), studentId);
        for (DormCheckinRecord roommate : roommates) {
            RoommateVO vo = new RoommateVO();
            vo.setStudentId(roommate.getStudentId());

            // 查询学生信息
            SysUser student = userMapper.selectById(roommate.getStudentId());
            if (student != null) {
                vo.setStudentName(student.getRealName());
                vo.setStudentNo(student.getUsername());
                vo.setPhone(student.getPhone());
            }

            // 查询床位信息
            DormBed roommateBed = bedMapper.selectById(roommate.getBedId());
            if (roommateBed != null) {
                vo.setBedNo(roommateBed.getBedNo());
            }

            roommateList.add(vo);
        }

        return roommateList;
    }

    @Override
    public PageInfo<CheckinVO> getCheckinList(DormCheckinRecord query, Integer pageNum, Integer pageSize) {
        List<DormCheckinRecord> records = checkinRecordMapper.selectList(query);
        PageInfo<DormCheckinRecord> pageInfo = new PageInfo<>(records);

        PageInfo<CheckinVO> voPageInfo = new PageInfo<>();
        BeanUtils.copyProperties(pageInfo, voPageInfo);
        voPageInfo.setList(convertToVOList(records));

        return voPageInfo;
    }

    @Override
    public PageInfo<CheckinVO> getCheckinListByBuildingId(Long buildingId, Integer pageNum, Integer pageSize) {
        List<DormCheckinRecord> records = checkinRecordMapper.selectByBuildingId(buildingId);
        PageInfo<DormCheckinRecord> pageInfo = new PageInfo<>(records);

        PageInfo<CheckinVO> voPageInfo = new PageInfo<>();
        BeanUtils.copyProperties(pageInfo, voPageInfo);
        voPageInfo.setList(convertToVOList(records));

        return voPageInfo;
    }

    @Override
    public PageInfo<CheckinVO> getCheckinListByStudentNo(String studentNo, Integer checkinStatus, Integer pageNum, Integer pageSize) {
        List<DormCheckinRecord> records = checkinRecordMapper.selectListByStudentNo(studentNo, checkinStatus);
        PageInfo<DormCheckinRecord> pageInfo = new PageInfo<>(records);

        PageInfo<CheckinVO> voPageInfo = new PageInfo<>();
        BeanUtils.copyProperties(pageInfo, voPageInfo);
        voPageInfo.setList(convertToVOList(records));

        return voPageInfo;
    }

    @Override
    public PageInfo<CheckinVO> getCheckinListByStudentNoAndBuildingId(String studentNo, Long buildingId, Integer checkinStatus, Integer pageNum, Integer pageSize) {
        List<DormCheckinRecord> records = checkinRecordMapper.selectListByStudentNoAndBuildingId(studentNo, buildingId, checkinStatus);
        PageInfo<DormCheckinRecord> pageInfo = new PageInfo<>(records);

        PageInfo<CheckinVO> voPageInfo = new PageInfo<>();
        BeanUtils.copyProperties(pageInfo, voPageInfo);
        voPageInfo.setList(convertToVOList(records));

        return voPageInfo;
    }

    @Override
    public PageInfo<CheckinVO> getCheckinListByBuildingIdAndStatus(Long buildingId, Integer checkinStatus, Integer pageNum, Integer pageSize) {
        List<DormCheckinRecord> records = checkinRecordMapper.selectListByBuildingIdAndStatus(buildingId, checkinStatus);
        PageInfo<DormCheckinRecord> pageInfo = new PageInfo<>(records);

        PageInfo<CheckinVO> voPageInfo = new PageInfo<>();
        BeanUtils.copyProperties(pageInfo, voPageInfo);
        voPageInfo.setList(convertToVOList(records));

        return voPageInfo;
    }

    /**
     * 办理入住
     * 事务操作：插入入住记录 + 更新床位状态为已入住
     */
    @Override
    @Transactional
    public void checkin(CheckinDTO dto, Long operatorId) {
        // 校验学生存在且状态正常
        SysUser student = userMapper.selectById(dto.getStudentId());
        if (student == null) {
            throw new BusinessException(BusinessException.CODE_NOT_FOUND, "学生不存在");
        }
        if (student.getStatus() == null || !UserStatusEnum.NORMAL.getCode().equals(student.getStatus())) {
            throw new BusinessException(BusinessException.CODE_BAD_REQUEST, "学生账号状态异常");
        }

        // 校验学生当前无在住记录
        int activeCount = checkinRecordMapper.countActiveByStudentId(dto.getStudentId());
        if (activeCount > 0) {
            throw new BusinessException(BusinessException.CODE_CONFLICT, "该学生已有在住记录");
        }

        // 校验床位存在且状态为空闲
        DormBed bed = bedMapper.selectById(dto.getBedId());
        if (bed == null) {
            throw new BusinessException(BusinessException.CODE_NOT_FOUND, "床位不存在");
        }
        if (!BedStatusEnum.FREE.getCode().equals(bed.getBedStatus())) {
            throw new BusinessException(BusinessException.CODE_CONFLICT, "该床位已被占用");
        }

        // 事务内执行：插入入住记录 + 更新床位状态为已入住
        DormCheckinRecord record = new DormCheckinRecord();
        record.setStudentId(dto.getStudentId());
        record.setBedId(dto.getBedId());
        record.setCheckinTime(LocalDateTime.now());
        record.setCheckinStatus(CheckinStatusEnum.LIVING.getCode());
        record.setOperatorId(operatorId);
        record.setRemark(dto.getRemark());
        checkinRecordMapper.insert(record);

        bedMapper.updateStatus(dto.getBedId(), BedStatusEnum.OCCUPIED.getCode());
    }

    /**
     * 办理退宿
     * 事务操作：更新入住记录状态为已退宿 + 释放床位为空闲
     */
    @Override
    @Transactional
    public void checkout(Long checkinId, Long operatorId) {
        // 校验入住记录存在且状态为在住
        DormCheckinRecord record = checkinRecordMapper.selectById(checkinId);
        if (record == null) {
            throw new BusinessException(BusinessException.CODE_NOT_FOUND, "入住记录不存在");
        }
        if (!CheckinStatusEnum.LIVING.getCode().equals(record.getCheckinStatus())) {
            throw new BusinessException(BusinessException.CODE_BAD_REQUEST, "该入住记录状态异常");
        }

        // 事务内执行：更新入住记录状态为已退宿 + 更新床位状态为空闲
        record.setCheckinStatus(CheckinStatusEnum.CHECKED_OUT.getCode());
        record.setCheckoutTime(LocalDateTime.now());
        checkinRecordMapper.update(record);

        bedMapper.updateStatus(record.getBedId(), BedStatusEnum.FREE.getCode());
    }

    /**
     * 实体转VO
     */
    private CheckinVO convertToVO(DormCheckinRecord record) {
        CheckinVO vo = new CheckinVO();
        BeanUtils.copyProperties(record, vo);

        // 查询学生信息
        SysUser student = userMapper.selectById(record.getStudentId());
        if (student != null) {
            vo.setStudentName(student.getRealName());
            vo.setStudentNo(student.getUsername());
        }

        // 查询床位、房间、楼栋信息
        DormBed bed = bedMapper.selectById(record.getBedId());
        if (bed != null) {
            vo.setBedNo(bed.getBedNo());

            DormRoom room = roomMapper.selectById(bed.getRoomId());
            if (room != null) {
                vo.setRoomNo(room.getRoomNo());

                DormBuilding building = buildingMapper.selectById(room.getBuildingId());
                if (building != null) {
                    vo.setBuildingName(building.getBuildingName());
                }
            }
        }

        // 查询办理人信息
        SysUser operator = userMapper.selectById(record.getOperatorId());
        if (operator != null) {
            vo.setOperatorName(operator.getRealName());
        }

        // 设置入住状态文本
        CheckinStatusEnum statusEnum = CheckinStatusEnum.getByCode(record.getCheckinStatus());
        if (statusEnum != null) {
            vo.setCheckinStatusText(statusEnum.getDesc());
        }

        return vo;
    }

    /**
     * 实体列表转VO列表
     */
    private List<CheckinVO> convertToVOList(List<DormCheckinRecord> records) {
        List<CheckinVO> voList = new ArrayList<>();
        for (DormCheckinRecord record : records) {
            voList.add(convertToVO(record));
        }
        return voList;
    }
}
