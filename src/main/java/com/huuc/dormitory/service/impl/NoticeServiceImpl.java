package com.huuc.dormitory.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.huuc.dormitory.common.enums.NoticeTypeEnum;
import com.huuc.dormitory.common.enums.RoleTypeEnum;
import com.huuc.dormitory.common.exception.BusinessException;
import com.huuc.dormitory.dao.DormBedMapper;
import com.huuc.dormitory.dao.DormCheckinRecordMapper;
import com.huuc.dormitory.dao.DormRoomMapper;
import com.huuc.dormitory.dao.NoticeMapper;
import com.huuc.dormitory.dao.SysUserMapper;
import com.huuc.dormitory.dto.NoticeDTO;
import com.huuc.dormitory.entity.DormBed;
import com.huuc.dormitory.entity.DormCheckinRecord;
import com.huuc.dormitory.entity.DormRoom;
import com.huuc.dormitory.entity.Notice;
import com.huuc.dormitory.entity.SysUser;
import com.huuc.dormitory.service.BuildingService;
import com.huuc.dormitory.service.NoticeService;
import com.huuc.dormitory.vo.BuildingVO;
import com.huuc.dormitory.vo.NoticeVO;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 公告通知服务实现
 */
@Service
public class NoticeServiceImpl implements NoticeService {

    @Autowired
    private NoticeMapper noticeMapper;

    @Autowired
    private SysUserMapper sysUserMapper;

    @Autowired
    private DormCheckinRecordMapper checkinRecordMapper;

    @Autowired
    private DormBedMapper bedMapper;

    @Autowired
    private DormRoomMapper roomMapper;

    @Autowired
    private BuildingService buildingService;

    @Override
    public PageInfo<NoticeVO> pageNotices(String title, Integer noticeType, int pageNum, int pageSize) {
        Notice query = new Notice();
        query.setTitle(title);
        query.setNoticeType(noticeType);

        List<Notice> notices = noticeMapper.selectPage(query);
        PageInfo<Notice> pageInfo = new PageInfo<>(notices);
        return convertToVOPageInfo(pageInfo);
    }

    @Override
    @Transactional
    public void addNotice(NoticeDTO dto, Long publisherId) {
        validateNoticeDTO(dto);

        Notice notice = new Notice();
        notice.setTitle(dto.getTitle());
        notice.setContent(dto.getContent());
        notice.setNoticeType(dto.getNoticeType());
        notice.setVisibleScope(dto.getVisibleScope());
        notice.setBuildingId(dto.getBuildingId());
        notice.setStatus(Notice.STATUS_PUBLISHED);
        notice.setIsTop(0);
        notice.setIsBanner(0);
        notice.setPublisherId(publisherId);
        notice.setPublishTime(LocalDateTime.now());

        // 处理轮播图片
        if (dto.getIsBanner() != null && dto.getIsBanner() == 1 && dto.getBannerImagePath() != null) {
            notice.setIsBanner(1);
            notice.setBannerImage(dto.getBannerImagePath());
            int days = dto.getBannerDays() != null ? dto.getBannerDays() : 7;
            notice.setBannerExpire(LocalDateTime.now().plusDays(days));
        }

        noticeMapper.insert(notice);
    }

    @Override
    @Transactional
    public void updateNotice(NoticeDTO dto) {
        if (dto.getNoticeId() == null) {
            throw new BusinessException(BusinessException.CODE_BAD_REQUEST, "公告ID不能为空");
        }

        Notice existNotice = noticeMapper.selectById(dto.getNoticeId());
        if (existNotice == null) {
            throw new BusinessException(BusinessException.CODE_NOT_FOUND, "公告不存在");
        }

        validateNoticeDTO(dto);

        Notice notice = new Notice();
        notice.setNoticeId(dto.getNoticeId());
        notice.setTitle(dto.getTitle());
        notice.setContent(dto.getContent());
        notice.setNoticeType(dto.getNoticeType());
        notice.setVisibleScope(dto.getVisibleScope());
        notice.setBuildingId(dto.getBuildingId());

        // 处理轮播图片
        if (dto.getIsBanner() != null) {
            if (dto.getIsBanner() == 1 && dto.getBannerImagePath() != null) {
                notice.setIsBanner(1);
                notice.setBannerImage(dto.getBannerImagePath());
                int days = dto.getBannerDays() != null ? dto.getBannerDays() : 7;
                notice.setBannerExpire(LocalDateTime.now().plusDays(days));
            } else if (dto.getIsBanner() == 0) {
                notice.setIsBanner(0);
            }
        }

        noticeMapper.update(notice);
    }

    @Override
    @Transactional
    public void toggleStatus(Long noticeId) {
        Notice notice = noticeMapper.selectById(noticeId);
        if (notice == null) {
            throw new BusinessException(BusinessException.CODE_NOT_FOUND, "公告不存在");
        }

        int newStatus = notice.getStatus() == Notice.STATUS_PUBLISHED
                ? Notice.STATUS_DRAFT : Notice.STATUS_PUBLISHED;

        Notice update = new Notice();
        update.setNoticeId(noticeId);
        update.setStatus(newStatus);
        if (newStatus == Notice.STATUS_PUBLISHED) {
            update.setPublishTime(LocalDateTime.now());
        }
        noticeMapper.update(update);
    }

    @Override
    @Transactional
    public void toggleTop(Long noticeId) {
        Notice notice = noticeMapper.selectById(noticeId);
        if (notice == null) {
            throw new BusinessException(BusinessException.CODE_NOT_FOUND, "公告不存在");
        }

        int newTop = notice.getIsTop() == 1 ? 0 : 1;

        Notice update = new Notice();
        update.setNoticeId(noticeId);
        update.setIsTop(newTop);
        noticeMapper.update(update);
    }

    @Override
    @Transactional
    public void unbanner(Long noticeId) {
        Notice notice = noticeMapper.selectById(noticeId);
        if (notice == null) {
            throw new BusinessException(BusinessException.CODE_NOT_FOUND, "公告不存在");
        }

        Notice update = new Notice();
        update.setNoticeId(noticeId);
        update.setIsBanner(0);
        noticeMapper.update(update);
    }

    @Override
    public NoticeVO getNoticeById(Long noticeId) {
        Notice notice = noticeMapper.selectById(noticeId);
        if (notice == null) {
            throw new BusinessException(BusinessException.CODE_NOT_FOUND, "公告不存在");
        }
        return convertToVO(notice);
    }

    @Override
    public PageInfo<NoticeVO> getVisibleNotices(Long userId, Integer roleType, int pageNum, int pageSize) {
        // getVisibleBuildingIds 会触发含 LIMIT 的 MyBatis 查询，
        // 必须在此之前清除 Controller 预置的 PageHelper 分页状态，
        // 之后重新 startPage 让分页作用于真正的查询
        PageHelper.clearPage();
        List<Long> buildingIds = getVisibleBuildingIds(userId, roleType);

        PageHelper.startPage(pageNum, pageSize);
        List<Notice> notices;
        if (RoleTypeEnum.ADMIN.getCode().equals(roleType)) {
            Notice query = new Notice();
            query.setStatus(Notice.STATUS_PUBLISHED);
            notices = noticeMapper.selectPage(query);
        } else {
            notices = noticeMapper.selectVisiblePage(buildingIds);
        }

        PageInfo<Notice> pageInfo = new PageInfo<>(notices);
        return convertToVOPageInfo(pageInfo);
    }

    @Override
    public List<NoticeVO> getBannerNotices(Long userId, Integer roleType) {
        List<Long> buildingIds = getVisibleBuildingIds(userId, roleType);

        List<Notice> notices;
        if (RoleTypeEnum.ADMIN.getCode().equals(roleType)) {
            notices = noticeMapper.selectBanners(null);
        } else {
            notices = noticeMapper.selectBanners(buildingIds);
        }

        return convertToVOList(notices);
    }

    @Override
    public List<NoticeVO> getRelatedNotices(Long noticeId, Long userId, Integer roleType) {
        Notice notice = noticeMapper.selectById(noticeId);
        if (notice == null) {
            return Collections.emptyList();
        }

        List<Long> buildingIds = getVisibleBuildingIds(userId, roleType);

        List<Notice> notices;
        if (RoleTypeEnum.ADMIN.getCode().equals(roleType)) {
            notices = noticeMapper.selectRelated(noticeId, notice.getNoticeType(),
                    notice.getVisibleScope(), null, 3);
        } else {
            notices = noticeMapper.selectRelated(noticeId, notice.getNoticeType(),
                    notice.getVisibleScope(), buildingIds, 3);
        }

        return convertToVOList(notices);
    }

    // ==================== 私有方法 ====================

    /**
     * 校验公告DTO业务规则
     */
    private void validateNoticeDTO(NoticeDTO dto) {
        if (dto.getTitle() == null || dto.getTitle().trim().isEmpty()) {
            throw new BusinessException(BusinessException.CODE_BAD_REQUEST, "标题不能为空");
        }
        if (dto.getContent() == null || dto.getContent().trim().isEmpty()) {
            throw new BusinessException(BusinessException.CODE_BAD_REQUEST, "内容不能为空");
        }
        if (dto.getNoticeType() == null) {
            throw new BusinessException(BusinessException.CODE_BAD_REQUEST, "公告类型不能为空");
        }
        if (NoticeTypeEnum.getByCode(dto.getNoticeType()) == null) {
            throw new BusinessException(BusinessException.CODE_BAD_REQUEST, "无效的公告类型");
        }
        if (dto.getVisibleScope() == null) {
            throw new BusinessException(BusinessException.CODE_BAD_REQUEST, "可见范围不能为空");
        }
        if (dto.getVisibleScope() == Notice.SCOPE_BUILDING && dto.getBuildingId() == null) {
            throw new BusinessException(BusinessException.CODE_BAD_REQUEST, "按楼栋可见时必须选择目标楼栋");
        }
    }

    /**
     * 获取当前用户的可见楼栋ID列表
     */
    private List<Long> getVisibleBuildingIds(Long userId, Integer roleType) {
        if (RoleTypeEnum.ADMIN.getCode().equals(roleType)) {
            return null;
        }

        if (RoleTypeEnum.DORM_MANAGER.getCode().equals(roleType)) {
            List<BuildingVO> buildings = buildingService.getBuildingsByManagerId(userId);
            return buildings.stream()
                    .map(BuildingVO::getBuildingId)
                    .collect(Collectors.toList());
        }

        if (RoleTypeEnum.STUDENT.getCode().equals(roleType)) {
            List<Long> buildingIds = new ArrayList<>();
            DormCheckinRecord checkin = checkinRecordMapper.selectActiveByStudentId(userId);
            if (checkin != null) {
                DormBed bed = bedMapper.selectById(checkin.getBedId());
                if (bed != null) {
                    DormRoom room = roomMapper.selectById(bed.getRoomId());
                    if (room != null) {
                        buildingIds.add(room.getBuildingId());
                    }
                }
            }
            return buildingIds;
        }

        return new ArrayList<>();
    }

    /**
     * 实体转VO（含发布人姓名和类型文本）
     */
    private NoticeVO convertToVO(Notice notice) {
        NoticeVO vo = new NoticeVO();
        BeanUtils.copyProperties(notice, vo);

        // 发布人姓名
        if (notice.getPublisherId() != null) {
            SysUser publisher = sysUserMapper.selectById(notice.getPublisherId());
            if (publisher != null) {
                vo.setPublisherName(publisher.getRealName());
            }
        }

        // 类型文本
        NoticeTypeEnum typeEnum = NoticeTypeEnum.getByCode(notice.getNoticeType());
        if (typeEnum != null) {
            vo.setNoticeTypeText(typeEnum.getDesc());
        }

        return vo;
    }

    private List<NoticeVO> convertToVOList(List<Notice> notices) {
        List<NoticeVO> voList = new ArrayList<>();
        for (Notice notice : notices) {
            voList.add(convertToVO(notice));
        }
        return voList;
    }

    private PageInfo<NoticeVO> convertToVOPageInfo(PageInfo<Notice> pageInfo) {
        List<NoticeVO> voList = convertToVOList(pageInfo.getList());
        PageInfo<NoticeVO> voPageInfo = new PageInfo<>();
        BeanUtils.copyProperties(pageInfo, voPageInfo);
        voPageInfo.setList(voList);
        return voPageInfo;
    }
}
