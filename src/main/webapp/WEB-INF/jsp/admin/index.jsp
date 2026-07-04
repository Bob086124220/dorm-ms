<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>系统总览 - 高校公寓管理系统</title>
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/static/images/favicon.svg">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/vendor/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/tokens.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/common.css">
</head>
<body>
<div class="main-container">
    <%@ include file="/WEB-INF/jsp/common/sidebar.jsp" %>

    <div class="content-wrapper">
        <%@ include file="/WEB-INF/jsp/common/header.jsp" %>

        <div class="content-body">
            <!-- 轮播公告 -->
            <%@ include file="/WEB-INF/jsp/common/carousel.jsp" %>

            <!-- 页面头部 -->
            <div class="page-header">
                <div>
                    <span class="page-eyebrow">SYSTEM OVERVIEW</span>
                    <h1>系统总览</h1>
                    <p class="page-meta">高校公寓管理系统 · 实时数据看板</p>
                </div>
            </div>

            <!-- 统计卡片 ×4 -->
            <section class="stats-row">
                <div class="stat-card" data-decorative-num="01">
                    <div class="stat-card-label">入住率</div>
                    <div class="stat-card-value accent" id="occupancyRate">--</div>
                    <div class="stat-card-sub">当前公寓整体入住情况</div>
                </div>
                <div class="stat-card" data-decorative-num="02">
                    <div class="stat-card-label">本月报修</div>
                    <div class="stat-card-value" id="monthRepair">--</div>
                    <div class="stat-card-sub">超时 <span class="num" id="timeoutRepair">0</span> 件</div>
                </div>
                <div class="stat-card" data-decorative-num="03">
                    <div class="stat-card-label">本月晚归</div>
                    <div class="stat-card-value accent2" id="monthLate">--</div>
                    <div class="stat-card-sub">本月晚归登记人次</div>
                </div>
                <div class="stat-card" data-decorative-num="04">
                    <div class="stat-card-label">本月访客</div>
                    <div class="stat-card-value" id="monthVisitor">--</div>
                    <div class="stat-card-sub">本月访客登记总量</div>
                </div>
            </section>

            <!-- 图表双栏 -->
            <section class="charts-row">
                <div class="chart-panel">
                    <div class="chart-panel-title">
                        <h2>楼栋入住率</h2>
                    </div>
                    <div class="chart-box" id="chartBuilding"></div>
                </div>
                <div class="chart-panel">
                    <div class="chart-panel-title">
                        <h2>近 6 月业务趋势</h2>
                    </div>
                    <div class="chart-box" id="chartTrend"></div>
                </div>
            </section>

            <!-- 待处理事项 -->
            <section class="content-panel" style="margin-bottom: var(--gap-lg);">
                <div class="content-panel-header">
                    <h3>待处理事项</h3>
                    <a href="${pageContext.request.contextPath}/admin/repair/list" class="panel-link">
                        查看全部
                        <svg><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-chevron-right"/></svg>
                    </a>
                </div>
                <table class="pending-table">
                    <thead>
                        <tr><th>类型</th><th>事项</th><th>状态</th></tr>
                    </thead>
                    <tbody id="pendingList"></tbody>
                </table>
                <div class="empty-state" id="pendingEmpty" style="display:none;">
                    <svg><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-activity"/></svg>
                    <div class="empty-state-title">暂无待处理事项</div>
                    <div class="empty-state-desc">所有事项已处理完毕</div>
                </div>
            </section>

            <!-- 近期操作日志 -->
            <section class="content-panel" style="margin-bottom: var(--gap-xl);">
                <div class="content-panel-header">
                    <h3>近期操作日志</h3>
                    <a href="${pageContext.request.contextPath}/admin/log/list" class="panel-link">
                        全部日志
                        <svg><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-chevron-right"/></svg>
                    </a>
                </div>
                <div class="activity-log" id="recentLogs"></div>
                <div class="empty-state" id="logEmpty" style="display:none;">
                    <svg><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-file-text"/></svg>
                    <div class="empty-state-title">暂无操作记录</div>
                    <div class="empty-state-desc">近期无管理操作</div>
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
<script src="${pageContext.request.contextPath}/static/vendor/echarts/echarts.min.js"></script>

<script>
(function() {
    'use strict';

    /**
     * 数字滚动动画 (ease-out-cubic)
     */
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

    /**
     * 图表空状态
     */
    function showChartEmpty(chart) {
        chart.setOption({
            title: {
                text: '暂无数据',
                left: 'center',
                top: 'center',
                textStyle: {
                    color: 'rgb(122, 112, 103)',
                    fontFamily: "-apple-system, system-ui, sans-serif",
                    fontSize: 14
                }
            }
        });
    }

    /**
     * PendingItem → pill class 映射
     */
    function getTypeClass(type, statusText) {
        if (type === 'repair' && statusText === '已超时') return 'pill-danger';
        if (type === 'repair' && statusText === '处理中') return 'pill-processing';
        return 'pill-pending';
    }

    function getTypeLabel(type) {
        return type === 'repair' ? '报修' : '调宿';
    }

    function getStatusClass(statusText) {
        if (statusText === '已超时') return 'pill-danger';
        if (statusText === '处理中') return 'pill-processing';
        return 'pill-pending';
    }

    // ==================== 数据加载 ====================

    function loadDashboard() {
        $.ajaxRequest('/admin/dashboard', 'GET', null, function(result) {
            renderDashboard(result.data);
        }, function() {
            $('#occupancyRate').html('<a href="javascript:void(0)" onclick="loadDashboard()" style="font-size:13px;color:var(--accent)">加载失败，点击重试</a>');
        });
    }

    function renderDashboard(data) {
        var prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

        // 统计卡片
        countUp('occupancyRate', Math.round(data.occupancyRate || 0), '%');
        countUp('monthRepair', data.monthRepairCount || 0);
        countUp('monthLate', data.monthLateReturnCount || 0);
        countUp('monthVisitor', data.monthVisitorCount || 0);
        $('#timeoutRepair').text(data.timeoutRepairCount || 0);

        // 图表
        renderBuildingChart(data.buildingOccupancy, prefersReducedMotion);
        renderTrendChart(data.monthlyTrend, prefersReducedMotion);

        // 待处理事项
        renderPendingTable(data.pendingItems);

        // 操作日志
        renderLogList(data.recentLogs);
    }

    // ==================== 图表 ====================

    function renderBuildingChart(data, prefersReducedMotion) {
        var el = document.getElementById('chartBuilding');
        if (!el) return;

        var chart = echarts.init(el, MAGAZINE_THEME);

        if (!data || data.length === 0) {
            showChartEmpty(chart);
            return;
        }

        var names = [], values = [], maxVal = 0;
        data.forEach(function(item) {
            names.push(item.buildingName);
            values.push(item.rate);
            if (item.rate > maxVal) maxVal = item.rate;
        });

        chart.setOption({
            tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
            grid: { left: '12%', right: '8%', top: '10%', bottom: '12%' },
            xAxis: { type: 'category', data: names, axisLabel: { fontSize: 11 } },
            yAxis: { type: 'value', max: 100, axisLabel: { formatter: '{value}%' } },
            series: [{
                type: 'bar', data: values, barWidth: '45%',
                itemStyle: {
                    borderRadius: [4, 4, 0, 0],
                    color: function(params) {
                        return params.value >= maxVal
                            ? 'rgb(196, 69, 58)'
                            : 'rgb(212, 132, 90)';
                    }
                },
                label: {
                    show: true, position: 'top',
                    fontFamily: "'SF Mono', 'JetBrains Mono', Consolas, ui-monospace, monospace",
                    fontSize: 11, color: 'rgb(122, 112, 103)', formatter: '{c}%'
                }
            }],
            animationDuration: prefersReducedMotion ? 0 : 800
        });

        $(window).on('resize.chartBuilding', function() { chart.resize(); });
    }

    function renderTrendChart(data, prefersReducedMotion) {
        var el = document.getElementById('chartTrend');
        if (!el) return;

        var chart = echarts.init(el, MAGAZINE_THEME);

        if (!data || data.length === 0) {
            showChartEmpty(chart);
            return;
        }

        var months = [], repairArr = [], lateArr = [], visitorArr = [], checkinArr = [];
        data.forEach(function(item) {
            months.push(item.month);
            repairArr.push(item.repair);
            lateArr.push(item.lateReturn);
            visitorArr.push(item.visitor);
            checkinArr.push(item.checkin);
        });

        chart.setOption({
            tooltip: { trigger: 'axis' },
            legend: { data: ['报修', '晚归', '访客', '入住'], bottom: 0 },
            grid: { left: '10%', right: '6%', top: '10%', bottom: '18%' },
            xAxis: { type: 'category', data: months, axisLabel: { fontSize: 11 } },
            yAxis: { type: 'value' },
            series: [
                { name: '报修', type: 'line', data: repairArr, lineStyle: { color: 'rgb(196, 69, 58)', width: 2 }, itemStyle: { color: 'rgb(196, 69, 58)' } },
                { name: '晚归', type: 'line', data: lateArr, lineStyle: { color: 'rgb(212, 132, 90)', width: 2 }, itemStyle: { color: 'rgb(212, 132, 90)' } },
                { name: '访客', type: 'line', data: visitorArr, lineStyle: { color: 'rgb(46, 125, 111)', width: 2 }, itemStyle: { color: 'rgb(46, 125, 111)' } },
                { name: '入住', type: 'line', data: checkinArr, lineStyle: { color: 'rgb(122, 112, 103)', width: 2, type: 'dashed' }, itemStyle: { color: 'rgb(122, 112, 103)' } }
            ],
            animationDuration: prefersReducedMotion ? 0 : 800
        });

        $(window).on('resize.chartTrend', function() { chart.resize(); });
    }

    // ==================== 待处理表格 ====================

    function renderPendingTable(items) {
        var $tbody = $('#pendingList');
        var $empty = $('#pendingEmpty');

        if (!items || items.length === 0) {
            $tbody.empty();
            $empty.show();
            return;
        }

        $empty.hide();
        var html = '';
        for (var i = 0; i < items.length; i++) {
            var item = items[i];
            var typeLabel = getTypeLabel(item.type);
            var typeClass = getTypeClass(item.type, item.statusText);
            var statusClass = getStatusClass(item.statusText);
            var title = item.title || '';
            var safeTitle = $('<span>').text(title).html();
            var displayTitle = title.length > 24 ? safeTitle.substring(0, 24) + '...' : safeTitle;

            html += '<tr>'
                + '<td><span class="pill ' + typeClass + '">' + typeLabel + '</span></td>'
                + '<td title="' + $('<span>').text(title).html() + '">' + displayTitle + '</td>'
                + '<td><span class="pill ' + statusClass + '">' + item.statusText + '</span></td>'
                + '</tr>';
        }
        $tbody.html(html);
    }

    // ==================== 操作日志 ====================

    function renderLogList(items) {
        var $logArea = $('#recentLogs');
        var $empty = $('#logEmpty');

        if (!items || items.length === 0) {
            $logArea.empty();
            $empty.show();
            return;
        }

        $empty.hide();
        var html = '';
        for (var i = 0; i < items.length; i++) {
            var log = items[i];
            var time = (log.operTime || '').substring(5, 16);
            var text = $('<span>').text((log.module || '') + ' - ' + (log.operType || '')).html();
            html += '<div class="log-entry">'
                + '<span class="log-time">' + time + '</span>'
                + '<span class="log-text">' + text + '</span>'
                + '</div>';
        }
        $logArea.html(html);
    }

    // ==================== 入口 ====================

    $(function() {
        loadDashboard();
    });

})();
</script>
</body>
</html>
