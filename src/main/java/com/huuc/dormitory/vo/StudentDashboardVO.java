package com.huuc.dormitory.vo;

import lombok.Getter;
import lombok.Setter;

/**
 * 学生看板轻量聚合VO
 */
@Getter
@Setter
public class StudentDashboardVO {

    /** 本月报修次数 */
    private int monthRepairCount;

    /** 本月晚归次数 */
    private int monthLateReturnCount;

    /** 已入住天数 */
    private int stayDays;
}
