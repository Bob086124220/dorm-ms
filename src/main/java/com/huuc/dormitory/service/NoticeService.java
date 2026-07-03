package com.huuc.dormitory.service;

import com.github.pagehelper.PageInfo;
import com.huuc.dormitory.dto.NoticeDTO;
import com.huuc.dormitory.vo.NoticeVO;

import java.util.List;

/**
 * 公告通知服务接口
 */
public interface NoticeService {

    /**
     * 管理员分页查询公告
     *
     * @param title      标题（模糊查询）
     * @param noticeType 公告类型（可选）
     * @param pageNum    页码
     * @param pageSize   每页条数
     */
    PageInfo<NoticeVO> pageNotices(String title, Integer noticeType, int pageNum, int pageSize);

    /**
     * 新增公告
     *
     * @param dto         公告数据（bannerImagePath 已由 Controller 回填）
     * @param publisherId 发布人ID
     */
    void addNotice(NoticeDTO dto, Long publisherId);

    /**
     * 编辑公告
     *
     * @param dto 公告数据
     */
    void updateNotice(NoticeDTO dto);

    /**
     * 发布/下架切换
     *
     * @param noticeId 公告ID
     */
    void toggleStatus(Long noticeId);

    /**
     * 置顶/取消置顶切换
     *
     * @param noticeId 公告ID
     */
    void toggleTop(Long noticeId);

    /**
     * 下轮播（取消轮播展示）
     *
     * @param noticeId 公告ID
     */
    void unbanner(Long noticeId);

    /**
     * 根据ID查询公告（含发布人姓名）
     *
     * @param noticeId 公告ID
     */
    NoticeVO getNoticeById(Long noticeId);

    /**
     * 当前用户可见公告分页
     *
     * @param userId   当前用户ID
     * @param roleType 当前用户角色类型
     * @param pageNum  页码
     * @param pageSize 每页条数
     */
    PageInfo<NoticeVO> getVisibleNotices(Long userId, Integer roleType, int pageNum, int pageSize);

    /**
     * 当前用户可见轮播公告
     *
     * @param userId   当前用户ID
     * @param roleType 当前用户角色类型
     */
    List<NoticeVO> getBannerNotices(Long userId, Integer roleType);

    /**
     * 相关公告（同类型或同范围，最多3条）
     *
     * @param noticeId 当前公告ID
     * @param userId   当前用户ID
     * @param roleType 当前用户角色类型
     */
    List<NoticeVO> getRelatedNotices(Long noticeId, Long userId, Integer roleType);
}
