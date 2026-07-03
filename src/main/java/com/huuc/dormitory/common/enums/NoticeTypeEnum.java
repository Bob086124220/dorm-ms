package com.huuc.dormitory.common.enums;

/**
 * 公告类型枚举
 */
public enum NoticeTypeEnum {

    NOTICE(1, "通知"),
    REPAIR(2, "维修"),
    ACTIVITY(3, "活动"),
    URGENT(4, "紧急");

    private final Integer code;
    private final String desc;

    NoticeTypeEnum(Integer code, String desc) {
        this.code = code;
        this.desc = desc;
    }

    public Integer getCode() {
        return code;
    }

    public String getDesc() {
        return desc;
    }

    /**
     * 根据编码获取枚举
     */
    public static NoticeTypeEnum getByCode(Integer code) {
        if (code == null) {
            return null;
        }
        for (NoticeTypeEnum item : values()) {
            if (item.code.equals(code)) {
                return item;
            }
        }
        return null;
    }
}
