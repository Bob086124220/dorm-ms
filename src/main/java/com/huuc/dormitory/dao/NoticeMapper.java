package com.huuc.dormitory.dao;

import com.huuc.dormitory.entity.Notice;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 公告通知Mapper接口
 */
public interface NoticeMapper {

    /**
     * 插入公告
     */
    int insert(Notice notice);

    /**
     * 更新公告（动态更新非空字段）
     */
    int update(Notice notice);

    /**
     * 管理员分页查询（条件：标题模糊、类型筛选）
     */
    List<Notice> selectPage(Notice query);

    /**
     * 当前用户可见公告分页
     *
     * @param buildingIds 可见楼栋ID列表（可为空）
     */
    List<Notice> selectVisiblePage(@Param("buildingIds") List<Long> buildingIds);

    /**
     * 根据ID查询公告
     */
    Notice selectById(Long noticeId);

    /**
     * 查询当前用户可见的轮播公告
     *
     * @param buildingIds 可见楼栋ID列表（可为空）
     */
    List<Notice> selectBanners(@Param("buildingIds") List<Long> buildingIds);

    /**
     * 查询相关公告（同类型或同范围，排除自身）
     *
     * @param noticeId     当前公告ID（排除自身）
     * @param noticeType   当前公告类型
     * @param visibleScope 当前公告可见范围
     * @param buildingIds  可见楼栋ID列表（可为空）
     * @param limit        返回条数上限
     */
    List<Notice> selectRelated(@Param("noticeId") Long noticeId,
                               @Param("noticeType") Integer noticeType,
                               @Param("visibleScope") Integer visibleScope,
                               @Param("buildingIds") List<Long> buildingIds,
                               @Param("limit") int limit);
}
