<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>报修管理 - 高校公寓管理系统</title>
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
                <div class="page-header">
                    <div>
                        <span class="page-eyebrow">REPAIR MANAGEMENT</span>
                        <h1>报修管理</h1>
                        <p class="page-meta">查看和处理学生报修申请 · 超时工单高亮</p>
                    </div>
                </div>

                <div class="filter-bar">
                    <div class="filter-field">
                        <label>学号</label>
                        <input type="text" id="searchStudentNo" placeholder="输入学号搜索">
                    </div>
                    <div class="filter-field">
                        <label>报修类型</label>
                        <div class="cselect" data-name="searchRepairType">
                            <div class="cselect-trigger"><span class="cselect-val cselect-placeholder">全部类型</span><svg class="cselect-arrow" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 12 15 18 9"/></svg></div>
                            <div class="cselect-panel">
                                <button class="cselect-option selected" data-value="">全部类型</button>
                                <button class="cselect-option" data-value="1">水电故障</button>
                                <button class="cselect-option" data-value="2">家具损坏</button>
                                <button class="cselect-option" data-value="3">门窗故障</button>
                                <button class="cselect-option" data-value="4">其他</button>
                            </div>
                        </div>
                    </div>
                    <div class="filter-field">
                        <label>处理状态</label>
                        <div class="cselect" data-name="searchStatus">
                            <div class="cselect-trigger"><span class="cselect-val cselect-placeholder">全部状态</span><svg class="cselect-arrow" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 12 15 18 9"/></svg></div>
                            <div class="cselect-panel">
                                <button class="cselect-option selected" data-value="">全部状态</button>
                                <button class="cselect-option" data-value="0">待处理</button>
                                <button class="cselect-option" data-value="1">处理中</button>
                                <button class="cselect-option" data-value="2">已完成</button>
                            </div>
                        </div>
                    </div>
                    <div class="filter-actions">
                        <button type="button" class="btn btn-secondary btn-sm" onclick="search()">
                            <svg width="14" height="14"><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-search"/></svg>
                            查询
                        </button>
                        <button type="button" class="btn btn-ghost btn-sm" onclick="resetSearch()">重置</button>
                    </div>
                </div>

                <div class="data-panel">
                    <table>
                        <thead>
                            <tr>
                                <th>学生姓名</th>
                                <th>学号</th>
                                <th>楼栋</th>
                                <th>房间</th>
                                <th>报修类型</th>
                                <th>报修内容</th>
                                <th>提交时间</th>
                                <th>状态</th>
                                <th style="width: 100px;">操作</th>
                            </tr>
                        </thead>
                        <tbody id="tableBody">
                            <tr><td colspan="9" class="text-center" style="padding: 40px 0; color: var(--muted);"><svg width="32" height="32" style="color: var(--border); margin: 0 auto 8px; display: block;"><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-info"/></svg>
                                        加载中...</td></tr>
                        </tbody>
                    </table>
                    <div id="paginationContainer"></div>
                </div>
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
        var pageQueryParams = { pageNum: 1, pageSize: 10 };

        $(function() {
            $.initCustomSelect();
            loadData(pageQueryParams);
        });

        function loadData(params) {
            var typeSelect = document.querySelector('.cselect[data-name="searchRepairType"]');
            var statusSelect = document.querySelector('.cselect[data-name="searchStatus"]');
            var queryParams = $.extend({}, params, {
                studentNo: $('#searchStudentNo').val().trim() || undefined,
                repairType: typeSelect ? (typeSelect.dataset.value || undefined) : undefined,
                repairStatus: statusSelect ? (statusSelect.dataset.value || undefined) : undefined
            });

            $.ajaxRequest('/admin/repair/page', 'GET', queryParams, function(result) {
                if (result.data) {
                    renderTable(result.data.list);
                    $.renderPagination(result.data, 'paginationContainer', function(page) {
                        pageQueryParams.pageNum = page;
                        loadData(pageQueryParams);
                    });
                    pageQueryParams.pageNum = result.data.pageNum;
                    pageQueryParams.pageSize = result.data.pageSize;
                }
            }, function() {
                $('#tableBody').html('<tr><td colspan="9" class="text-center" style="padding: 40px 0;"><a href="javascript:void(0)" onclick="loadData(pageQueryParams)" class="error-retry-link">加载失败，点击重试</a></td></tr>');
            });
        }

        function renderTable(list) {
            var $tbody = $('#tableBody');
            $tbody.empty();
            if (!list || list.length === 0) {
                $tbody.html('<tr><td colspan="9" class="text-center" style="padding: 40px 0; color: var(--muted);"><svg width="32" height="32" style="color: var(--border); margin: 0 auto 8px; display: block;"><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-inbox"/></svg>暂无数据</td></tr>');
                return;
            }
            list.forEach(function(item) {
                var statusPill = getStatusPill(item.repairStatus);
                var typeText = getRepairTypeText(item.repairType);
                var timeoutClass = item.isTimeout ? ' class="timeout-row"' : '';
                var timeoutPill = item.isTimeout ? ' <span class="pill pill-danger">超时</span>' : '';
                var content = item.repairContent || '-';
                var contentDisplay = content.length > 20 ? content.substring(0, 20) + '...' : content;

                var actionBtn = '';
                if (item.repairStatus === 0) {
                    actionBtn = '<button class="btn btn-ghost btn-sm" onclick="handleRepair(' + item.repairId + ')">接单</button>';
                } else {
                    actionBtn = '<a href="${pageContext.request.contextPath}/admin/repair/detailPage?repairId=' + item.repairId + '" class="btn btn-ghost btn-sm">详情</a>';
                }

                var row = '<tr' + timeoutClass + '>';
                row += '<td>' + (item.studentName || '-') + '</td>';
                row += '<td class="num">' + (item.studentNo || '-') + '</td>';
                row += '<td>' + (item.buildingName || '-') + '</td>';
                row += '<td class="num">' + (item.roomNo || '-') + '</td>';
                row += '<td>' + typeText + '</td>';
                row += '<td title="' + (item.repairContent || '').replace(/"/g, '&quot;') + '">' + contentDisplay + '</td>';
                row += '<td class="num text-muted">' + $.formatDate(item.submitTime, 'yyyy-MM-dd HH:mm') + '</td>';
                row += '<td>' + statusPill + timeoutPill + '</td>';
                row += '<td>' + actionBtn + '</td>';
                row += '</tr>';
                $tbody.append(row);
            });
        }

        function search() { pageQueryParams.pageNum = 1; loadData(pageQueryParams); }
        function resetSearch() {
            $('#searchStudentNo').val('');
            document.querySelectorAll('.filter-bar .cselect').forEach(function(cs) {
                cs.dataset.value = '';
                var valEl = cs.querySelector('.cselect-val');
                if (valEl) { valEl.textContent = valEl.classList.contains('cselect-placeholder') ? valEl.textContent : ''; valEl.classList.add('cselect-placeholder'); }
                cs.querySelectorAll('.cselect-option').forEach(function(o) { o.classList.remove('selected'); });
            });
            search();
        }

        function getStatusPill(status) {
            return {0: '<span class="pill pill-pending">待处理</span>', 1: '<span class="pill pill-processing">处理中</span>', 2: '<span class="pill pill-done">已完成</span>'}[status] || '<span class="pill pill-quiet">未知</span>';
        }

        function getRepairTypeText(type) {
            return {1: '水电故障', 2: '家具损坏', 3: '门窗故障', 4: '其他'}[type] || '-';
        }

        function handleRepair(repairId) {
            $.confirm('确定要接单处理该报修吗？', function() {
                $.ajaxRequest('/admin/repair/handle/' + repairId, 'POST', null, function() {
                    $.toast('success', '接单成功');
                    loadData(pageQueryParams);
                }, function(result) { $.toast('error', result.msg || '接单失败'); });
            });
        }
    </script>
</body>
</html>
