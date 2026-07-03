package com.huuc.dormitory.vo;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;

/**
 * 公告视图对象（含发布人姓名）
 */
@Getter
@Setter
@NoArgsConstructor
@ToString
public class NoticeVO {

    /** 公告主键ID */
    private Long noticeId;

    /** 标题 */
    private String title;

    /** 内容（Markdown 原文） */
    private String content;

    /** 分类：1-通知 2-维修 3-活动 4-紧急 */
    private Integer noticeType;

    /** 分类文本 */
    private String noticeTypeText;

    /** 可见范围：1-全部 2-按楼栋 */
    private Integer visibleScope;

    /** 目标楼栋ID */
    private Long buildingId;

    /** 目标楼栋名称 */
    private String buildingName;

    /** 状态：1-发布 0-下架 */
    private Integer status;

    /** 是否置顶：0-否 1-是 */
    private Integer isTop;

    /** 是否上轮播：0-否 1-是 */
    private Integer isBanner;

    /** 轮播图片路径 */
    private String bannerImage;

    /** 轮播过期时间 */
    private LocalDateTime bannerExpire;

    /** 发布人ID */
    private Long publisherId;

    /** 发布人姓名 */
    private String publisherName;

    /** 发布时间 */
    private LocalDateTime publishTime;

    /** 创建时间 */
    private LocalDateTime createTime;
}
