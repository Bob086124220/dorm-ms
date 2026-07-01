package com.huuc.dormitory.service.impl;

import com.github.pagehelper.PageInfo;
import com.huuc.dormitory.common.enums.RepairStatusEnum;
import com.huuc.dormitory.common.enums.RepairTypeEnum;
import com.huuc.dormitory.common.exception.BusinessException;
import com.huuc.dormitory.dao.*;
import com.huuc.dormitory.dto.RepairDTO;
import com.huuc.dormitory.dto.RepairHandleDTO;
import com.huuc.dormitory.entity.*;
import com.huuc.dormitory.service.RepairService;
import com.huuc.dormitory.vo.RepairVO;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * 报修服务实现类
 */
@Service
public class RepairServiceImpl implements RepairService {

    @Autowired
    private DormRepairMapper repairMapper;

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
    public RepairVO getRepairById(Long repairId) {
        DormRepair repair = repairMapper.selectById(repairId);
        if (repair == null) {
            throw new BusinessException(BusinessException.CODE_NOT_FOUND, "报修记录不存在");
        }
        return convertToVO(repair);
    }

    @Override
    public PageInfo<RepairVO> getRepairList(DormRepair query, Integer pageNum, Integer pageSize) {
        List<DormRepair> repairs = repairMapper.selectList(query);
        PageInfo<DormRepair> pageInfo = new PageInfo<>(repairs);

        PageInfo<RepairVO> voPageInfo = new PageInfo<>();
        BeanUtils.copyProperties(pageInfo, voPageInfo);
        voPageInfo.setList(convertToVOList(repairs));

        return voPageInfo;
    }

    @Override
    public PageInfo<RepairVO> getMyRepairs(Long studentId, Integer pageNum, Integer pageSize) {
        List<DormRepair> repairs = repairMapper.selectByStudentId(studentId);
        PageInfo<DormRepair> pageInfo = new PageInfo<>(repairs);

        PageInfo<RepairVO> voPageInfo = new PageInfo<>();
        BeanUtils.copyProperties(pageInfo, voPageInfo);
        voPageInfo.setList(convertToVOList(repairs));

        return voPageInfo;
    }

    @Override
    public PageInfo<RepairVO> getRepairListByStudentNo(String studentNo, Integer repairType, Integer repairStatus, Integer pageNum, Integer pageSize) {
        List<DormRepair> repairs = repairMapper.selectListByStudentNo(studentNo, repairType, repairStatus);
        PageInfo<DormRepair> pageInfo = new PageInfo<>(repairs);

        PageInfo<RepairVO> voPageInfo = new PageInfo<>();
        BeanUtils.copyProperties(pageInfo, voPageInfo);
        voPageInfo.setList(convertToVOList(repairs));

        return voPageInfo;
    }

    @Override
    public PageInfo<RepairVO> getRepairsByBuildingId(Long buildingId, Integer repairStatus, Integer pageNum, Integer pageSize) {
        List<DormRepair> repairs = repairMapper.selectByBuildingId(buildingId, repairStatus);
        PageInfo<DormRepair> pageInfo = new PageInfo<>(repairs);

        PageInfo<RepairVO> voPageInfo = new PageInfo<>();
        BeanUtils.copyProperties(pageInfo, voPageInfo);
        voPageInfo.setList(convertToVOList(repairs));

        return voPageInfo;
    }

    /**
     * 提交报修
     * 自动关联学生在住房间
     */
    @Override
    @Transactional
    public void submitRepair(RepairDTO dto, Long studentId) {
        // 校验学生当前有在住记录
        DormCheckinRecord checkinRecord = checkinRecordMapper.selectActiveByStudentId(studentId);
        if (checkinRecord == null) {
            throw new BusinessException(BusinessException.CODE_BAD_REQUEST, "您当前无在住记录，无法提交报修");
        }

        // 通过床位查询房间ID
        DormBed bed = bedMapper.selectById(checkinRecord.getBedId());
        if (bed == null) {
            throw new BusinessException(BusinessException.CODE_ERROR, "床位信息异常");
        }

        // 插入报修记录
        DormRepair repair = new DormRepair();
        repair.setStudentId(studentId);
        repair.setRoomId(bed.getRoomId());
        repair.setRepairType(dto.getRepairType());
        repair.setRepairContent(dto.getRepairContent());
        repair.setContactPhone(dto.getContactPhone());
        repair.setSubmitTime(LocalDateTime.now());
        repair.setRepairStatus(RepairStatusEnum.PENDING.getCode());
        repairMapper.insert(repair);
    }

    /**
     * 接单处理（状态：待处理 → 处理中）
     */
    @Override
    @Transactional
    public void handleRepair(Long repairId, Long handlerId) {
        // 校验报修记录存在且状态为待处理
        DormRepair repair = repairMapper.selectById(repairId);
        if (repair == null) {
            throw new BusinessException(BusinessException.CODE_NOT_FOUND, "报修记录不存在");
        }
        if (!RepairStatusEnum.PENDING.getCode().equals(repair.getRepairStatus())) {
            throw new BusinessException(BusinessException.CODE_BAD_REQUEST, "该报修状态无法接单");
        }

        // 更新状态为处理中，回填处理人ID
        repair.setRepairStatus(RepairStatusEnum.PROCESSING.getCode());
        repair.setHandlerId(handlerId);
        repairMapper.update(repair);
    }

    /**
     * 完结报修（状态：处理中 → 已完成）
     */
    @Override
    @Transactional
    public void completeRepair(Long repairId, RepairHandleDTO dto, Long handlerId) {
        // 校验报修记录存在且状态为处理中
        DormRepair repair = repairMapper.selectById(repairId);
        if (repair == null) {
            throw new BusinessException(BusinessException.CODE_NOT_FOUND, "报修记录不存在");
        }
        if (!RepairStatusEnum.PROCESSING.getCode().equals(repair.getRepairStatus())) {
            throw new BusinessException(BusinessException.CODE_BAD_REQUEST, "该报修状态无法完结");
        }

        // 更新状态为已完成，回填处理结果、完成时间
        repair.setRepairStatus(RepairStatusEnum.COMPLETED.getCode());
        repair.setHandleResult(dto.getHandleResult());
        repair.setFinishTime(LocalDateTime.now());
        repairMapper.update(repair);
    }

    /**
     * 实体转VO
     */
    private RepairVO convertToVO(DormRepair repair) {
        RepairVO vo = new RepairVO();
        BeanUtils.copyProperties(repair, vo);

        // 查询学生信息
        SysUser student = userMapper.selectById(repair.getStudentId());
        if (student != null) {
            vo.setStudentName(student.getRealName());
            vo.setStudentNo(student.getUsername());
        }

        // 查询房间、楼栋信息
        DormRoom room = roomMapper.selectById(repair.getRoomId());
        if (room != null) {
            vo.setRoomNo(room.getRoomNo());

            DormBuilding building = buildingMapper.selectById(room.getBuildingId());
            if (building != null) {
                vo.setBuildingName(building.getBuildingName());
            }
        }

        // 查询处理人信息
        if (repair.getHandlerId() != null) {
            SysUser handler = userMapper.selectById(repair.getHandlerId());
            if (handler != null) {
                vo.setHandlerName(handler.getRealName());
            }
        }

        // 设置报修类型文本
        RepairTypeEnum typeEnum = RepairTypeEnum.getByCode(repair.getRepairType());
        if (typeEnum != null) {
            vo.setRepairTypeText(typeEnum.getDesc());
        }

        // 设置报修状态文本
        RepairStatusEnum statusEnum = RepairStatusEnum.getByCode(repair.getRepairStatus());
        if (statusEnum != null) {
            vo.setRepairStatusText(statusEnum.getDesc());
        }

        // 判断是否超时（24小时未处理）
        if (RepairStatusEnum.PENDING.getCode().equals(repair.getRepairStatus())) {
            LocalDateTime now = LocalDateTime.now();
            LocalDateTime deadline = repair.getSubmitTime().plusHours(24);
            vo.setIsTimeout(now.isAfter(deadline));
        } else {
            vo.setIsTimeout(false);
        }

        return vo;
    }

    /**
     * 实体列表转VO列表
     */
    private List<RepairVO> convertToVOList(List<DormRepair> repairs) {
        List<RepairVO> voList = new ArrayList<>();
        for (DormRepair repair : repairs) {
            voList.add(convertToVO(repair));
        }
        return voList;
    }
}
