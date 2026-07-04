<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>我的主页 - 高校公寓管理系统</title>
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/static/images/favicon.svg">
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

            <!-- 欢迎区 — 参照原型：左文字 + 右芯片 -->
            <section class="data-panel" style="display:flex;align-items:center;justify-content:space-between;padding:var(--gap-lg);margin-bottom:var(--gap-xl);opacity:0;animation:fadeUp .5s .2s cubic-bezier(.22,1,.36,1) both;">
                <div>
                    <h1 style="font-family:var(--font-display);font-size:var(--fs-h1);font-weight:700;line-height:1.2;letter-spacing:-0.01em;margin:0;">
                        欢迎回来，<span style="color:var(--accent);">${sessionScope.loginUser.realName}</span>同学！
                    </h1>
                    <p style="font-family:var(--font-mono);font-size:var(--fs-meta);color:var(--muted);margin:var(--gap-xs) 0 0 0;">
                        学号 <span class="num">${sessionScope.loginUser.username}</span>
                    </p>
                </div>
                <div style="display:flex;flex-direction:column;gap:var(--gap-xs);align-items:flex-end;">
                    <span class="info-chip">当前住宿：<strong id="dormInfo">加载中...</strong></span>
                    <span class="info-chip">已入住 <strong class="num" id="stayDaysChip">--</strong> 天</span>
                </div>
            </section>

            <!-- 快捷操作 -->
            <section class="quick-actions" style="opacity:0;animation:fadeUp .5s .3s cubic-bezier(.22,1,.36,1) both;">
                <a href="${pageContext.request.contextPath}/student/repair/submit" class="quick-action" id="btnRepair">
                    <div class="quick-action-icon">
                        <svg><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-wrench"/></svg>
                    </div>
                    <div class="quick-action-text"><h3>提交报修</h3><p>报告宿舍设施问题</p></div>
                </a>
                <a href="${pageContext.request.contextPath}/student/move/applyPage" class="quick-action">
                    <div class="quick-action-icon">
                        <svg><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-external-link"/></svg>
                    </div>
                    <div class="quick-action-text"><h3>申请调宿</h3><p>申请更换宿舍房间</p></div>
                </a>
                <a href="${pageContext.request.contextPath}/student/user/info" class="quick-action">
                    <div class="quick-action-icon">
                        <svg><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-user"/></svg>
                    </div>
                    <div class="quick-action-text"><h3>个人信息</h3><p>查看和修改个人资料</p></div>
                </a>
            </section>

            <!-- 数据卡片 ×3 -->
            <section class="stats-row" style="grid-template-columns: repeat(3, 1fr);opacity:0;animation:fadeUp .5s .4s cubic-bezier(.22,1,.36,1) both;">
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
                    <div class="stat-card-sub">天 · 温馨宿舍</div>
                </div>
            </section>

            <!-- 最近报修 + 最近晚归 -->
            <section class="charts-row" style="opacity:0;animation:fadeUp .5s .55s cubic-bezier(.22,1,.36,1) both;">
                <div class="content-panel">
                    <div class="content-panel-header">
                        <h3>最近报修</h3>
                        <a href="${pageContext.request.contextPath}/student/repair/list" class="panel-link">全部 <svg><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-chevron-right"/></svg></a>
                    </div>
                    <div class="activity-log" id="recentRepairs"></div>
                    <div class="empty-state" id="repairEmpty" style="display:none;">
                        <svg><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-activity"/></svg>
                        <div class="empty-state-title">暂无报修记录</div>
                    </div>
                </div>
                <div class="content-panel">
                    <div class="content-panel-header">
                        <h3>最近晚归</h3>
                        <a href="${pageContext.request.contextPath}/student/late-return/list" class="panel-link">全部 <svg><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-chevron-right"/></svg></a>
                    </div>
                    <div class="activity-log" id="recentLateReturns"></div>
                    <div class="empty-state" id="lateEmpty" style="display:none;">
                        <svg><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-activity"/></svg>
                        <div class="empty-state-title">暂无晚归记录</div>
                    </div>
                </div>
            </section>

            <!-- 最新公告 -->
            <section class="content-panel" style="margin-bottom:var(--gap-xl);opacity:0;animation:fadeUp .5s .65s cubic-bezier(.22,1,.36,1) both;">
                <div class="content-panel-header">
                    <h3>最新公告</h3>
                    <a href="${pageContext.request.contextPath}/common/notice/listPage" class="panel-link">全部公告 <svg><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-chevron-right"/></svg></a>
                </div>
                <div class="activity-log" id="recentNotices"></div>
                <div class="empty-state" id="noticeEmpty" style="display:none;">
                    <svg><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-bell"/></svg>
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
        if (!el) return; suffix = suffix || '';
        var duration = 800;
        if (target <= 0) { el.textContent = '0' + suffix; return; }
        var startTime = null;
        function step(ts) { if (!startTime) startTime = ts;
            var p = Math.min((ts - startTime) / duration, 1);
            el.textContent = Math.round(target * (1 - Math.pow(1 - p, 3))) + suffix;
            if (p < 1) requestAnimationFrame(step); }
        requestAnimationFrame(step);
    }

    function getRepairStatusText(s) { if (s === 2) return '已完成'; if (s === 1) return '处理中'; return '待处理'; }
    function getRepairStatusClass(s) { if (s === 2) return 'pill-done'; if (s === 1) return 'pill-processing'; return 'pill-pending'; }

    $(function() {
        // 统计数据
        $.ajaxRequest('/student/dashboard', 'GET', null, function(r) {
            var d = r.data; countUp('monthRepair', d.monthRepairCount || 0, ' 条');
            countUp('monthLate', d.monthLateReturnCount || 0, ' 次');
            countUp('stayDays', d.stayDays || 0, ' 天');
            if (d.stayDays) $('#stayDaysChip').text(d.stayDays);
        });
        // 住宿信息
        $.ajaxRequest('/student/checkin/info', 'GET', null, function(r) {
            var info = r.data;
            if (info && info.buildingName) {
                $('#dormInfo').html(info.buildingName + ' ' + info.roomNo + '室 ' + info.bedNo + '号床');
                $.ajaxRequest('/student/checkin/roommates', 'GET', null, function(r2) {
                    var mates = r2.data || []; var names = [];
                    for (var i = 0; i < mates.length; i++) names.push(mates[i].studentName || mates[i].realName || '同学');
                    if (names.length > 0) {
                        var btnHtml = ' <a href="${pageContext.request.contextPath}/student/checkin/infoPage" class="btn-ghost btn-sm" style="margin-left:6px;font-size:11px;">';
                        btnHtml += '<svg style="width:12px;height:12px;margin-right:3px;"><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-users"/></svg>舍友</a>';
                        $('#dormInfo').after(' <span class="info-chip">'+names.join('、')+btnHtml+'</span>');
                    }
                });
            } else { $('#dormInfo').text('暂未入住'); $('#btnRepair').hide(); }
        });
        // 最近报修
        $.ajaxRequest('/student/repair/page', 'GET', { pageNum: 1, pageSize: 3 }, function(r) {
            var items = (r.data && r.data.list) || [];
            var a = $('#recentRepairs'), e = $('#repairEmpty');
            if (!items.length) { a.empty(); e.show(); return; } e.hide();
            var h = '';
            for (var i = 0; i < items.length; i++) {
                var it = items[i], t = (it.repairContent || '').substring(0, 28), tm = (it.submitTime || '').substring(5, 16);
                h += '<div class="log-entry"><span class="log-time">' + tm + '</span><span class="log-text">' + $('<span>').text(t).html() + '</span><span class="pill ' + getRepairStatusClass(it.repairStatus) + '" style="font-size:11px;">' + getRepairStatusText(it.repairStatus) + '</span></div>';
            }
            a.html(h);
        });
        // 最近晚归
        $.ajaxRequest('/student/late-return/page', 'GET', { pageNum: 1, pageSize: 3 }, function(r) {
            var items = (r.data && r.data.list) || [];
            var a = $('#recentLateReturns'), e = $('#lateEmpty');
            if (!items.length) { a.empty(); e.show(); return; } e.hide();
            var h = '';
            for (var i = 0; i < items.length; i++) {
                var it = items[i], rs = (it.lateReason || '未填写原因').substring(0, 24), tm = (it.lateTime || '').substring(5, 16);
                h += '<div class="log-entry"><span class="log-time">' + tm + '</span><span class="log-text">' + $('<span>').text(rs).html() + '</span></div>';
            }
            a.html(h);
        });
        // 最新公告
        $.ajaxRequest('/common/notice/visible', 'GET', { pageNum: 1, pageSize: 3 }, function(r) {
            var items = (r.data && r.data.list) || [];
            var a = $('#recentNotices'), e = $('#noticeEmpty');
            if (!items.length) { a.empty(); e.show(); return; } e.hide();
            var h = '', ctx = '${pageContext.request.contextPath}';
            for (var i = 0; i < items.length; i++) {
                var n = items[i], t = (n.title || '').substring(0, 36), tm = (n.publishTime || '').substring(5, 10);
                h += '<div class="log-entry"><span class="log-time">' + tm + '</span><a href="' + ctx + '/common/notice/detailPage?noticeId=' + n.noticeId + '" class="log-text" style="text-decoration:none;">' + $('<span>').text(t).html() + '</a></div>';
            }
            a.html(h);
        });
    });
})();
</script>
</body>
</html>
