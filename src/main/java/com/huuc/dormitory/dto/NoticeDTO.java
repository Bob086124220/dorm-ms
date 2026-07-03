package com.huuc.dormitory.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

/**
 * 公告新增/编辑DTO
 * 前端以 multipart/form-data 提交，Controller 手动绑定字段
 */
@Getter
@Setter
@NoArgsConstructor
@ToString
public class NoticeDTO {

    /** 公告ID（编辑时必填） */
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

    /** 是否上轮播：0-否 1-是 */
    private Integer isBanner;

    /** 轮播展示天数 */
    private Integer bannerDays;

    /** 轮播图片存储路径（Controller 上传后回填） */
    private String bannerImagePath;
}
