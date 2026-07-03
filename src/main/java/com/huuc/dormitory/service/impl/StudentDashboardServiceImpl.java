package com.huuc.dormitory.service.impl;

import com.huuc.dormitory.dao.DormCheckinRecordMapper;
import com.huuc.dormitory.dao.DormLateReturnMapper;
import com.huuc.dormitory.dao.DormRepairMapper;
import com.huuc.dormitory.entity.DormCheckinRecord;
import com.huuc.dormitory.entity.DormLateReturn;
import com.huuc.dormitory.entity.DormRepair;
import com.huuc.dormitory.service.StudentDashboardService;
import com.huuc.dormitory.vo.StudentDashboardVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.List;

/**
 * 学生看板服务实现
 */
@Service
public class StudentDashboardServiceImpl implements StudentDashboardService {

    @Autowired
    private DormRepairMapper repairMapper;

    @Autowired
    private DormLateReturnMapper lateReturnMapper;

    @Autowired
    private DormCheckinRecordMapper checkinRecordMapper;

    @Override
    public StudentDashboardVO getDashboard(Long studentId) {
        StudentDashboardVO vo = new StudentDashboardVO();

        String currentMonth = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM"));

        // 本月报修次数
        List<DormRepair> repairs = repairMapper.selectByStudentId(studentId);
        int repairCount = 0;
        for (DormRepair r : repairs) {
            if (r.getSubmitTime() != null &&
                    r.getSubmitTime().format(DateTimeFormatter.ofPattern("yyyy-MM")).equals(currentMonth)) {
                repairCount++;
            }
        }
        vo.setMonthRepairCount(repairCount);

        // 本月晚归次数
        List<DormLateReturn> lateReturns = lateReturnMapper.selectByStudentId(studentId);
        int lateCount = 0;
        for (DormLateReturn lr : lateReturns) {
            if (lr.getLateTime() != null &&
                    lr.getLateTime().format(DateTimeFormatter.ofPattern("yyyy-MM")).equals(currentMonth)) {
                lateCount++;
            }
        }
        vo.setMonthLateReturnCount(lateCount);

        // 已入住天数
        DormCheckinRecord checkin = checkinRecordMapper.selectActiveByStudentId(studentId);
        if (checkin != null && checkin.getCheckinTime() != null) {
            long days = ChronoUnit.DAYS.between(checkin.getCheckinTime().toLocalDate(), LocalDate.now());
            vo.setStayDays((int) Math.max(days, 1));
        }

        return vo;
    }
}
