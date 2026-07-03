<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>我的主页 - 高校公寓管理系统</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/vendor/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/tokens.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/common.css">
</head>
<body class="student-layout">
<div class="main-container">
    <%@ include file="/WEB-INF/jsp/common/sidebar.jsp" %>

    <div class="content-wrapper">
        <%@ include file="/WEB-INF/jsp/common/header.jsp" %>
        <%@ include file="/WEB-INF/jsp/common/student_tabs.jsp" %>

        <div class="content-body">
            <!-- 轮播公告 -->
            <%@ include file="/WEB-INF/jsp/common/carousel.jsp" %>

            <!-- 欢迎区 + 住宿信息 -->
            <section class="data-panel" style="margin-bottom: var(--gap-lg);">
                <div class="info-section">
                    <span class="page-eyebrow">STUDENT HOME</span>
                    <h2 class="info-title">欢迎回来，${sessionScope.loginUser.realName}同学！</h2>
                </div>
                <div class="info-body">
                    <div class="info-row info-row--bordered">
                        <span class="info-label">学号</span>
                        <span class="info-value num">${sessionScope.loginUser.username}</span>
                    </div>
                    <div class="info-row info-row--bordered">
                        <span class="info-label">当前住宿</span>
                        <span class="info-value" id="dormInfo">加载中...</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">舍友</span>
                        <span class="info-value" id="roommateInfo">--</span>
                    </div>
                </div>
            </section>

            <!-- 快捷操作 -->
            <section class="row" style="margin-bottom: var(--gap-lg);">
                <div class="col-md-4 mb-3">
                    <a href="${pageContext.request.contextPath}/student/repair/submit" class="module-card" id="btnRepair">
                        <span class="module-card-num">01</span>
                        <div class="module-icon">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94l-3.76 3.76z"/></svg>
                        </div>
                        <h3>提交报修</h3>
                        <p>提交宿舍维修申请</p>
                    </a>
                </div>
                <div class="col-md-4 mb-3">
                    <a href="${pageContext.request.contextPath}/student/move/applyPage" class="module-card">
                        <span class="module-card-num">02</span>
                        <div class="module-icon">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 11 12 14 22 4"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/></svg>
                        </div>
                        <h3>申请调宿</h3>
                        <p>提交调宿申请</p>
                    </a>
                </div>
                <div class="col-md-4 mb-3">
                    <a href="${pageContext.request.contextPath}/student/user/info" class="module-card">
                        <span class="module-card-num">03</span>
                        <div class="module-icon">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                        </div>
                        <h3>个人信息</h3>
                        <p>查看与修改个人资料</p>
                    </a>
                </div>
            </section>

            <!-- 统计卡片 ×3 -->
            <section class="stats-row" style="grid-template-columns: repeat(3, 1fr);">
                <div class="stat-card" data-decorative-num="01">
                    <div class="stat-card-label">本月报修</div>
                    <div class="stat-card-value accent" id="monthRepair">--</div>
                    <div class="stat-card-sub">本月累计提交</div>
                </div>
                <div class="stat-card" data-decorative-num="02">
                    <div class="stat-card-label">本月晚归</div>
                    <div class="stat-card-value accent2" id="monthLate">--</div>
                    <div class="stat-card-sub">本月晚归登记</div>
                </div>
                <div class="stat-card" data-decorative-num="03">
                    <div class="stat-card-label">已入住</div>
                    <div class="stat-card-value" id="stayDays">--</div>
                    <div class="stat-card-sub">温馨宿舍</div>
                </div>
            </section>

            <!-- 最近报修 + 最近晚归 -->
            <section class="charts-row">
                <!-- 最近报修 -->
                <div class="content-panel">
                    <div class="content-panel-header">
                        <h3>最近报修</h3>
                        <a href="${pageContext.request.contextPath}/student/repair/list" class="panel-link">
                            查看全部
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 18 15 12 9 6"/></svg>
                        </a>
                    </div>
                    <div class="activity-log" id="recentRepairs"></div>
                    <div class="empty-state" id="repairEmpty" style="display:none;">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                        <div class="empty-state-title">暂无报修记录</div>
                    </div>
                </div>
                <!-- 最近晚归 -->
                <div class="content-panel">
                    <div class="content-panel-header">
                        <h3>最近晚归</h3>
                        <a href="${pageContext.request.contextPath}/student/late-return/list" class="panel-link">
                            查看全部
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 18 15 12 9 6"/></svg>
                        </a>
                    </div>
                    <div class="activity-log" id="recentLateReturns"></div>
                    <div class="empty-state" id="lateEmpty" style="display:none;">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                        <div class="empty-state-title">暂无晚归记录</div>
                    </div>
                </div>
            </section>

            <!-- 最新公告 -->
            <section class="content-panel" style="margin-bottom: var(--gap-xl);">
                <div class="content-panel-header">
                    <h3>最新公告</h3>
                    <a href="${pageContext.request.contextPath}/common/notice/listPage" class="panel-link">
                        查看全部
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 18 15 12 9 6"/></svg>
                    </a>
                </div>
                <div class="activity-log" id="recentNotices"></div>
                <div class="empty-state" id="noticeEmpty" style="display:none;">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg>
                    <div class="empty-state-title">暂无公告通知</div>
                </div>
            </section>
        </div>

        <%@ include file="/WEB-INF/jsp/common/footer.jsp" %>
    </div>
</div>

<script src="${pageContext.request.contextPath}/static/js/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/static/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/common.js"></script>
<script>window.needChangePasswordFlag = '${sessionScope.needChangePassword}';</script>
<script src="${pageContext.request.contextPath}/static/js/header.js"></script>

<script>
(function() {
    'use strict';

    function countUp(elementId, target, suffix) {
        var el = document.getElementById(elementId);
        if (!el) return;
        suffix = suffix || '';
        var duration = 800;
        if (target <= 0) {
            el.textContent = '0' + suffix;
            return;
        }
        var startTime = null;
        function step(timestamp) {
            if (!startTime) startTime = timestamp;
            var elapsed = timestamp - startTime;
            var progress = Math.min(elapsed / duration, 1);
            var ease = 1 - Math.pow(1 - progress, 3);
            el.textContent = Math.round(target * ease) + suffix;
            if (progress < 1) requestAnimationFrame(step);
        }
        requestAnimationFrame(step);
    }

    // ==================== 数据加载 ====================

    $(function() {
        // 轻量聚合：统计数据
        $.ajaxRequest('/student/dashboard', 'GET', null, function(result) {
            var d = result.data;
            countUp('monthRepair', d.monthRepairCount || 0, ' 条');
            countUp('monthLate', d.monthLateReturnCount || 0, ' 次');
            countUp('stayDays', d.stayDays || 0, ' 天');
        });

        // 住宿信息
        $.ajaxRequest('/student/checkin/info', 'GET', null, function(result) {
            var info = result.data;
            if (info && info.buildingName) {
                $('#dormInfo').text(info.buildingName + ' ' + info.roomNo + '室 ' + info.bedNo + '号床');
                // 加载舍友
                $.ajaxRequest('/student/checkin/roommates', 'GET', null, function(r2) {
                    var mates = r2.data || [];
                    if (mates.length > 0) {
                        var names = [];
                        for (var i = 0; i < mates.length; i++) {
                            names.push(mates[i].studentName || mates[i].realName || '同学');
                        }
                        var roommateHtml = names.join('、');
                        roommateHtml += ' <a href="${pageContext.request.contextPath}/student/checkin/infoPage" class="btn-ghost btn-sm" style="margin-left:var(--gap-sm);">';
                        roommateHtml += '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" style="width:14px;height:14px;margin-right:4px;"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>';
                        roommateHtml += '查看舍友</a>';
                        $('#roommateInfo').html(roommateHtml);
                    } else {
                        $('#roommateInfo').text('暂无舍友');
                    }
                });
            } else {
                $('#dormInfo').text('暂未入住');
                $('#roommateInfo').text('--');
                $('#btnRepair').closest('.col-md-4').hide();
            }
        });

        // 最近报修
        $.ajaxRequest('/student/repair/page', 'GET', { pageNum: 1, pageSize: 3 }, function(result) {
            renderRecentRepairs(result.data.list || []);
        });

        // 最近晚归
        $.ajaxRequest('/student/late-return/page', 'GET', { pageNum: 1, pageSize: 3 }, function(result) {
            renderRecentLateReturns(result.data.list || []);
        });

        // 最新公告
        $.ajaxRequest('/common/notice/visible', 'GET', { pageNum: 1, pageSize: 3 }, function(result) {
            renderNotices(result.data.list || []);
        });
    });

    // ==================== 渲染函数 ====================

    function getRepairStatusText(status) {
        if (status === 2) return '已完成';
        if (status === 1) return '处理中';
        return '待处理';
    }

    function getRepairStatusClass(status) {
        if (status === 2) return 'pill-done';
        if (status === 1) return 'pill-processing';
        return 'pill-pending';
    }

    function renderRecentRepairs(items) {
        var $area = $('#recentRepairs');
        var $empty = $('#repairEmpty');
        if (!items || items.length === 0) { $area.empty(); $empty.show(); return; }
        $empty.hide();

        var html = '';
        for (var i = 0; i < items.length; i++) {
            var r = items[i];
            var title = (r.repairContent || '').substring(0, 30);
            var time = (r.submitTime || '').substring(5, 16);
            html += '<div class="log-entry">'
                + '<span class="log-time">' + time + '</span>'
                + '<span class="log-text">' + $('<span>').text(title).html() + '</span>'
                + '<span class="pill ' + getRepairStatusClass(r.repairStatus) + '" style="font-size:11px;">' + getRepairStatusText(r.repairStatus) + '</span>'
                + '</div>';
        }
        $area.html(html);
    }

    function renderRecentLateReturns(items) {
        var $area = $('#recentLateReturns');
        var $empty = $('#lateEmpty');
        if (!items || items.length === 0) { $area.empty(); $empty.show(); return; }
        $empty.hide();

        var html = '';
        for (var i = 0; i < items.length; i++) {
            var lr = items[i];
            var reason = (lr.lateReason || '未填写原因').substring(0, 24);
            var time = (lr.lateTime || '').substring(5, 16);
            html += '<div class="log-entry">'
                + '<span class="log-time">' + time + '</span>'
                + '<span class="log-text">' + $('<span>').text(reason).html() + '</span>'
                + '</div>';
        }
        $area.html(html);
    }

    function renderNotices(items) {
        var $area = $('#recentNotices');
        var $empty = $('#noticeEmpty');
        if (!items || items.length === 0) { $area.empty(); $empty.show(); return; }
        $empty.hide();

        var html = '';
        for (var i = 0; i < items.length; i++) {
            var n = items[i];
            var title = (n.title || '').substring(0, 36);
            var time = (n.publishTime || '').substring(5, 10);
            html += '<div class="log-entry">'
                + '<span class="log-time">' + time + '</span>'
                + '<a href="${pageContext.request.contextPath}/common/notice/detailPage?noticeId=' + n.noticeId + '" class="log-text" style="text-decoration:none;">' + $('<span>').text(title).html() + '</a>'
                + '</div>';
        }
        $area.html(html);
    }

})();
</script>
</body>
</html>
