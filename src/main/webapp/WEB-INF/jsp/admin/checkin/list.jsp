<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>入住管理 - 高校公寓管理系统</title>
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
                        <span class="page-eyebrow">CHECK-IN REGISTRATION</span>
                        <h1>入住管理</h1>
                        <p class="page-meta">管理学生入住和退宿</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/checkin/checkinPage" class="btn btn-primary">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" width="16" height="16"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
                        办理入住
                    </a>
                </div>

                <div class="filter-bar">
                    <div class="filter-field">
                        <label>学生ID</label>
                        <input type="text" id="searchStudentId" placeholder="请输入学生ID">
                    </div>
                    <div class="filter-field">
                        <label>入住状态</label>
                        <div class="cselect" id="searchStatusCselect">
                            <div class="cselect-trigger" tabindex="0" aria-haspopup="listbox" aria-expanded="false">
                                <span class="cselect-val cselect-placeholder">全部</span>
                                <svg class="cselect-arrow" viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="1.6" fill="none" stroke-linecap="round" stroke-linejoin="round">
                                    <polyline points="6 9 12 15 18 9"></polyline>
                                </svg>
                            </div>
                            <div class="cselect-panel" role="listbox">
                                <div class="cselect-option selected" data-value="">全部</div>
                                <div class="cselect-option" data-value="1">在住</div>
                                <div class="cselect-option" data-value="2">已退宿</div>
                            </div>
                        </div>
                    </div>
                    <div class="filter-actions">
                        <button type="button" class="btn btn-secondary btn-sm" onclick="search()">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" width="14" height="14"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
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
                                <th>床位</th>
                                <th>入住时间</th>
                                <th>状态</th>
                                <th>办理人</th>
                                <th style="width: 100px;">操作</th>
                            </tr>
                        </thead>
                        <tbody id="tableBody">
                            <tr><td colspan="9" class="text-center" style="padding: 40px 0; color: var(--muted);"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" width="32" height="32" style="color: var(--border); margin: 0 auto 8px; display: block;"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
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
        // 分页参数
        var pageQueryParams = {
            pageNum: 1,
            pageSize: 10
        };

        $(function() {
            $.initCustomSelect();
            loadData(pageQueryParams);
        });

        /**
         * 加载数据
         * @param {object} params - 查询参数
         */
        function loadData(params) {
            var queryParams = $.extend({}, params, {
                studentNo: $('#searchStudentId').val().trim() || null,
                checkinStatus: (document.querySelector('#searchStatusCselect') || {dataset:{}}).dataset?.value ?? null
            });

            $.ajaxRequest('/admin/checkin/page', 'GET', queryParams, function(result) {
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
                $('#tableBody').html('<tr><td colspan="9" class="text-center" style="padding: 40px 0;"><a href="javascript:void(0)" onclick="loadData(pageQueryParams)" style="color: var(--accent);">加载失败，点击重试</a></td></tr>');
            });
        }

        /**
         * 渲染表格
         * @param {Array} list - 入住记录列表
         */
        function renderTable(list) {
            var $tbody = $('#tableBody');
            $tbody.empty();

            if (!list || list.length === 0) {
                $tbody.html('<tr><td colspan="9" class="text-center" style="padding: 40px 0; color: var(--muted);"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" width="32" height="32" style="color: var(--border); margin: 0 auto 8px; display: block;"><polyline points="22 12 16 12 14 15 10 15 8 12 2 12"/><path d="M5.45 5.11L2 12v6a2 2 0 002 2h16a2 2 0 002-2v-6l-3.45-6.89A2 2 0 0016.76 4H7.24a2 2 0 00-1.79 1.11z"/></svg>暂无数据</td></tr>');
                return;
            }

            list.forEach(function(item) {
                var statusBadge = item.checkinStatus === 1
                    ? '<span class="pill pill-active">在住</span>'
                    : '<span class="pill pill-quiet">已退宿</span>';
                var actionBtn = '';
                if (item.checkinStatus === 1) {
                    actionBtn = '<button class="btn btn-ghost btn-sm" onclick="checkout(' + item.checkinId + ')">退宿</button>';
                } else {
                    actionBtn = '<span class="text-muted">-</span>';
                }

                var row = '<tr>';
                row += '<td>' + (item.studentName || '-') + '</td>';
                row += '<td>' + (item.studentNo || '-') + '</td>';
                row += '<td>' + (item.buildingName || '-') + '</td>';
                row += '<td>' + (item.roomNo || '-') + '</td>';
                row += '<td>' + (item.bedNo || '-') + '</td>';
                row += '<td>' + $.formatDate(item.checkinTime) + '</td>';
                row += '<td>' + statusBadge + '</td>';
                row += '<td>' + (item.operatorName || '-') + '</td>';
                row += '<td class="actions">' + actionBtn + '</td>';
                row += '</tr>';
                $tbody.append(row);
            });
        }

        function search() {
            pageQueryParams.pageNum = 1;
            loadData(pageQueryParams);
        }

        function resetSearch() {
            $('#searchStudentId').val('');
            // 重置状态下拉框
            $.updateCselectOptions(
                document.querySelector('#searchStatusCselect'),
                [
                    {value: '', text: '全部', selected: true},
                    {value: '1', text: '在住'},
                    {value: '2', text: '已退宿'}
                ]
            );
            search();
        }

        /**
         * 办理退宿
         * @param {number} checkinId - 入住记录ID
         */
        function checkout(checkinId) {
            $.confirm('确定为该学生办理退宿吗？', function() {
                $.ajaxRequest('/admin/checkin/checkout/' + checkinId, 'POST', null, function(result) {
                    $.toast('success', '退宿办理成功');
                    loadData(pageQueryParams);
                }, function(result) {
                    $.toast('error', result.msg || '退宿办理失败');
                });
            });
        }
    </script>
</body>
</html>
