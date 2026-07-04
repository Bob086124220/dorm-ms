<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>运营看板 - 高校公寓管理系统</title>
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
                    <span class="page-eyebrow">DORM OVERVIEW</span>
                    <h1 id="dashboardTitle">运营看板</h1>
                    <p class="page-meta" id="dashboardMeta">欢迎回来，${sessionScope.loginUser.realName} · 宿管工作概览</p>
                </div>
            </div>

            <!-- 统计卡片 ×4 -->
            <section class="stats-row">
                <div class="stat-card" data-decorative-num="01">
                    <div class="stat-card-label">入住率</div>
                    <div class="stat-card-value accent" id="occupancyRate">--</div>
                    <div class="stat-card-sub">当前管辖楼栋入住情况</div>
                </div>
                <div class="stat-card" data-decorative-num="02">
                    <div class="stat-card-label">空余床位</div>
                    <div class="stat-card-value" id="freeBedCount">--</div>
                    <div class="stat-card-sub">可分配床位数量</div>
                </div>
                <div class="stat-card" data-decorative-num="03" id="processingRepairCard">
                    <div class="stat-card-label">维修中</div>
                    <div class="stat-card-value accent2" id="processingRepair">--</div>
                    <div class="stat-card-sub">已接单待完成的报修</div>
                </div>
                <div class="stat-card" data-decorative-num="04" id="todayCheckinCard">
                    <div class="stat-card-label">今日新增</div>
                    <div class="stat-card-value" id="todayCheckin">--</div>
                    <div class="stat-card-sub">今日新增入住人数</div>
                </div>
            </section>

            <!-- 链接跳转卡片（调宿/在访） -->
            <section class="stats-row" style="margin-bottom: var(--gap-xl);">
                <div class="stat-card" data-decorative-num="05">
                    <div class="stat-card-label">待审批调宿</div>
                    <div class="stat-card-value accent" id="pendingMoveCount">--</div>
                    <div class="stat-card-sub">需审核的调宿申请</div>
                </div>
                <div class="stat-card" data-decorative-num="06" id="activeVisitorCard">
                    <div class="stat-card-label">在访未离校</div>
                    <div class="stat-card-value accent2" id="activeVisitorCount">--</div>
                    <div class="stat-card-sub">尚未登记离开的访客</div>
                </div>
            </section>

            <!-- 图表双栏 -->
            <section class="charts-row">
                <div class="chart-panel">
                    <div class="chart-panel-title">
                        <h2>楼层入住分布</h2>
                    </div>
                    <div class="chart-box" id="chartFloor"></div>
                </div>
                <div class="chart-panel">
                    <div class="chart-panel-title">
                        <h2>报修状态占比</h2>
                    </div>
                    <div class="chart-box" id="chartRepairStatus"></div>
                </div>
            </section>

            <!-- 待处理报修表格 -->
            <section class="content-panel" style="margin-bottom: var(--gap-xl);">
                <div class="content-panel-header">
                    <h3>待处理报修</h3>
                    <a href="${pageContext.request.contextPath}/dorm/repair/list" class="panel-link">
                        查看全部
                        <svg><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-chevron-right"/></svg>
                    </a>
                </div>
                <table class="pending-table">
                    <thead>
                        <tr><th>状态</th><th>事项</th><th>提交时间</th></tr>
                    </thead>
                    <tbody id="pendingList"></tbody>
                </table>
                <div class="empty-state" id="pendingEmpty" style="display:none;">
                    <svg><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-activity"/></svg>
                    <div class="empty-state-title">暂无待处理报修</div>
                    <div class="empty-state-desc">所有报修已处理完毕</div>
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

    function showChartEmpty(chart) {
        chart.setOption({
            title: {
                text: '暂无数据',
                left: 'center',
                top: 'center',
                textStyle: { color: 'rgb(122, 112, 103)', fontFamily: "-apple-system, system-ui, sans-serif", fontSize: 14 }
            }
        });
    }

    function isTimeout(createTime) {
        if (!createTime) return false;
        var then = new Date(createTime.replace(/-/g, '/'));
        if (isNaN(then.getTime())) return false;
        return (new Date() - then) > 24 * 60 * 60 * 1000;
    }

    // ==================== 数据加载 ====================

    function loadDashboard() {
        $.ajaxRequest('/dorm/dashboard', 'GET', null, function(result) {
            renderDashboard(result.data);
        }, function() {
            $('#occupancyRate').html('<a href="javascript:void(0)" onclick="loadDashboard()" style="font-size:13px;color:var(--accent)">加载失败，点击重试</a>');
        });
    }

    function renderDashboard(data) {
        var prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

        // 页面标题
        updatePageHeader(data.managedBuildings, data.buildingCount);

        // 统计卡片
        countUp('occupancyRate', Math.round(data.occupancyRate || 0), '%');
        countUp('freeBedCount', data.freeBedCount || 0);
        countUp('processingRepair', data.processingRepairCount || 0);
        countUp('todayCheckin', data.todayNewCheckinCount || 0);
        countUp('pendingMoveCount', data.pendingMoveCount || 0);
        countUp('activeVisitorCount', data.activeVisitorCount || 0);

        // 迷你横向指示条（占管理楼栋总容量比例）
        renderMiniBars(data);

        // 图表
        renderFloorChart(data.floorOccupancy, prefersReducedMotion);
        renderRepairStatusChart(data.repairStatusPie, prefersReducedMotion);

        // 待处理报修
        renderPendingTable(data.pendingRepairs, data.timeoutRepairCount);
    }

    // ==================== 迷你横向指示条 ====================

    function renderMiniBars(data) {
        var v1 = data.processingRepairCount || 0;
        var v2 = data.todayNewCheckinCount || 0;
        var v3 = data.activeVisitorCount || 0;
        var maxVal = Math.max(v1, v2, v3);

        function ensureBar(cardSelector, value, color) {
            var $card = $(cardSelector);
            if ($card.length === 0) return;
            var $bar = $card.find('.stat-card-minibar');
            if ($bar.length === 0) {
                $card.append(
                    '<div class="stat-card-minibar"><div class="stat-card-minibar-fill"></div></div>'
                );
                $bar = $card.find('.stat-card-minibar');
            }
            var pct = maxVal > 0 ? ((value || 0) / maxVal * 100) : 0;
            $bar.find('.stat-card-minibar-fill').css({
                width: pct + '%',
                background: color
            });
        }

        ensureBar('#processingRepairCard', v1, 'var(--accent-2)');
        ensureBar('#todayCheckinCard', v2, 'var(--accent)');
        ensureBar('#activeVisitorCard', v3, 'var(--status-ok)');
    }

    function updatePageHeader(managedBuildings, buildingCount) {
        if (!managedBuildings || managedBuildings.length === 0) {
            $('#dashboardTitle').text('运营看板 · 未分配楼栋');
            $('#dashboardMeta').text('暂未分配管辖楼栋');
            return;
        }
        if (managedBuildings.length === 1) {
            $('#dashboardTitle').text('运营看板 · ' + managedBuildings[0]);
        } else {
            $('#dashboardTitle').text('运营看板 · 共 ' + buildingCount + ' 栋');
        }
    }

    // ==================== 图表 ====================

    function renderFloorChart(data, prefersReducedMotion) {
        var el = document.getElementById('chartFloor');
        if (!el) return;
        var chart = echarts.init(el, MAGAZINE_THEME);

        if (!data || data.length === 0) {
            showChartEmpty(chart);
            return;
        }

        var floors = [], values = [];
        data.forEach(function(item) {
            floors.push(item.floor);
            values.push(item.rate);
        });
        floors.reverse();
        values.reverse();

        chart.setOption({
            tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
            grid: { left: '20%', right: '10%', top: '6%', bottom: '14%' },
            xAxis: { type: 'value', max: 100, axisLabel: { formatter: '{value}%' } },
            yAxis: { type: 'category', data: floors },
            series: [{
                type: 'bar', data: values, barWidth: '50%',
                itemStyle: {
                    borderRadius: [0, 4, 4, 0],
                    color: 'rgb(212, 132, 90)'
                },
                label: {
                    show: true, position: 'right',
                    fontFamily: "'SF Mono', 'JetBrains Mono', Consolas, ui-monospace, monospace",
                    fontSize: 11, color: 'rgb(122, 112, 103)', formatter: '{c}%'
                }
            }],
            animationDuration: prefersReducedMotion ? 0 : 800
        });

        $(window).on('resize.chartFloor', function() { chart.resize(); });
    }

    function renderRepairStatusChart(data, prefersReducedMotion) {
        var el = document.getElementById('chartRepairStatus');
        if (!el) return;
        var chart = echarts.init(el, MAGAZINE_THEME);

        if (!data || data.length === 0) {
            showChartEmpty(chart);
            return;
        }

        chart.setOption({
            tooltip: { trigger: 'item', formatter: '{b}: {c} 件 ({d}%)' },
            series: [{
                type: 'pie',
                radius: ['40%', '65%'],
                center: ['50%', '50%'],
                data: data.map(function(item) {
                    var color = 'rgb(122, 112, 103)';
                    if (item.name === '待处理') color = 'rgb(212, 132, 90)';
                    else if (item.name === '处理中') color = 'rgb(196, 69, 58)';
                    else if (item.name === '已完成') color = 'rgb(46, 125, 111)';
                    return { value: item.value, name: item.name, itemStyle: { color: color } };
                }),
                label: { show: false },
                emphasis: { label: { show: true, fontSize: 13, fontWeight: 'bold' } }
            }],
            animationDuration: prefersReducedMotion ? 0 : 800
        });

        $(window).on('resize.chartRepairStatus', function() { chart.resize(); });
    }

    // ==================== 待处理报修表格 ====================

    function renderPendingTable(items, timeoutCount) {
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
            var timedOut = isTimeout(item.createTime);
            var statusText, statusClass;
            if (item.status === 1) { // PROCESSING
                statusText = '处理中';
                statusClass = 'pill-processing';
            } else if (timedOut) {
                statusText = '已超时';
                statusClass = 'pill-danger';
            } else {
                statusText = '待处理';
                statusClass = 'pill-pending';
            }
            var title = item.title || '';
            var displayTitle = title.length > 24 ? $('<span>').text(title).html().substring(0, 24) + '...' : $('<span>').text(title).html();
            var time = (item.createTime || '').substring(5, 16);

            html += '<tr>'
                + '<td><span class="pill ' + statusClass + '">' + statusText + '</span></td>'
                + '<td title="' + $('<span>').text(title).html() + '">' + displayTitle + '</td>'
                + '<td><span style="font-family:var(--font-mono);font-size:var(--fs-sm);color:var(--muted)">' + time + '</span></td>'
                + '</tr>';
        }
        $tbody.html(html);
    }

    // ==================== 入口 ====================

    $(function() {
        loadDashboard();
    });

})();
</script>
</body>
</html>
