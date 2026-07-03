package com.huuc.dormitory.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;

/**
 * 公告通知实体类
 */
@Getter
@Setter
@NoArgsConstructor
@ToString
public class Notice {

    /** 公告状态：下架 */
    public static final int STATUS_DRAFT = 0;
    /** 公告状态：发布 */
    public static final int STATUS_PUBLISHED = 1;
    /** 可见范围：全部 */
    public static final int SCOPE_ALL = 1;
    /** 可见范围：按楼栋 */
    public static final int SCOPE_BUILDING = 2;

    /** 公告主键ID */
    private Long noticeId;

    /** 标题 */
    private String title;

    /** 内容（Markdown） */
    private String content;

    /** 分类：1-通知 2-维修 3-活动 4-紧急 */
    private Integer noticeType;

    /** 可见范围：1-全部 2-按楼栋 */
    private Integer visibleScope;

    /** 目标楼栋ID（scope=2时必填） */
    private Long buildingId;

    /** 状态：1-发布 0-下架 */
    private Integer status;

    /** 是否置顶：0-否 1-是 */
    private Integer isTop;

    /** 是否上轮播：0-否 1-是 */
    private Integer isBanner;

    /** 轮播图片路径 */
    private String bannerImage;

    /** 轮播过期时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime bannerExpire;

    /** 发布人ID */
    private Long publisherId;

    /** 发布时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime publishTime;

    /** 创建时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime;

    /** 更新时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime updateTime;
}
