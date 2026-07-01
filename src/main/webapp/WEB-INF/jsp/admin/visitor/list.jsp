<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>访客登记 - 高校公寓管理系统</title>
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
                        <h1>访客登记</h1>
                        <p class="page-meta">管理公寓访客记录</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/visitor/addPage" class="btn btn-primary">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" width="16" height="16"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
                        录入访客
                    </a>
                </div>

                <div class="filter-bar">
                    <div class="filter-field">
                        <label>被访学生ID</label>
                        <input type="text" id="searchStudentId" placeholder="请输入被访学生ID">
                    </div>
                    <div class="filter-field">
                        <label>楼栋ID</label>
                        <input type="text" id="searchBuildingId" placeholder="请输入楼栋ID">
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
                                <th>访客姓名</th>
                                <th>身份证号</th>
                                <th>被访学生</th>
                                <th>楼栋</th>
                                <th>来访时间</th>
                                <th>离开时间</th>
                                <th>状态</th>
                                <th style="width: 140px;">操作</th>
                            </tr>
                        </thead>
                        <tbody id="tableBody">
                            <tr><td colspan="8" class="text-center" style="padding: 40px 0; color: var(--muted);"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" width="32" height="32" style="color: var(--border); margin: 0 auto 8px; display: block;"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
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
            loadData(pageQueryParams);
        });

        /**
         * 加载数据
         * @param {object} params - 查询参数
         */
        function loadData(params) {
            var queryParams = $.extend({}, params, {
                studentNo: $('#searchStudentId').val().trim() || null,
                buildingId: $('#searchBuildingId').val().trim() || null
            });

            $.ajaxRequest('/admin/visitor/page', 'GET', queryParams, function(result) {
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
                $('#tableBody').html('<tr><td colspan="8" class="text-center" style="padding: 40px 0;"><a href="javascript:void(0)" onclick="loadData(pageQueryParams)" style="color: var(--accent);">加载失败，点击重试</a></td></tr>');
            });
        }

        /**
         * 渲染表格
         * @param {Array} list - 访客记录列表
         */
        function renderTable(list) {
            var $tbody = $('#tableBody');
            $tbody.empty();

            if (!list || list.length === 0) {
                $tbody.html('<tr><td colspan="8" class="text-center" style="padding: 40px 0; color: var(--muted);"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" width="32" height="32" style="color: var(--border); margin: 0 auto 8px; display: block;"><polyline points="22 12 16 12 14 15 10 15 8 12 2 12"/><path d="M5.45 5.11L2 12v6a2 2 0 002 2h16a2 2 0 002-2v-6l-3.45-6.89A2 2 0 0016.76 4H7.24a2 2 0 00-1.79 1.11z"/></svg>暂无数据</td></tr>');
                return;
            }

            list.forEach(function(item) {
                var statusBadge = item.leaveTime
                    ? '<span class="pill pill-quiet">已离开</span>'
                    : '<span class="pill pill-active">在访</span>';

                var actionBtn = '';
                if (!item.leaveTime) {
                    actionBtn = '<button class="btn btn-ghost btn-sm" onclick="confirmLeave(' + item.visitorId + ')">确认离开</button> ';
                }
                actionBtn += '<a href="${pageContext.request.contextPath}/admin/visitor/detailPage?visitorId=' + item.visitorId + '" class="btn btn-ghost btn-sm">详情</a>';

                var row = '<tr>';
                row += '<td>' + (item.visitorName || '-') + '</td>';
                row += '<td>' + (item.idCard ? item.idCard.replace(/(\d{6})\d{8}(\d{4})/, '$1********$2') : '-') + '</td>';
                row += '<td>' + (item.studentName || '-') + '</td>';
                row += '<td>' + (item.buildingName || '-') + '</td>';
                row += '<td>' + $.formatDate(item.visitTime) + '</td>';
                row += '<td>' + (item.leaveTime ? $.formatDate(item.leaveTime) : '-') + '</td>';
                row += '<td>' + statusBadge + '</td>';
                row += '<td class="actions">' + actionBtn + '</td>';
                row += '</tr>';
                $tbody.append(row);
            });
        }

        /**
         * 确认访客离开
         * @param {number} visitorId - 访客ID
         */
        function confirmLeave(visitorId) {
            $.confirm('确定要确认该访客已离开吗？', function() {
                $.ajaxRequest('/admin/visitor/leave/' + visitorId, 'POST', null, function(result) {
                    $.toast('success', '已确认访客离开');
                    loadData(pageQueryParams);
                }, function(result) {
                    $.toast('error', result.msg || '操作失败');
                });
            });
        }

        function search() {
            pageQueryParams.pageNum = 1;
            loadData(pageQueryParams);
        }

        function resetSearch() {
            $('#searchStudentId').val('');
            $('#searchBuildingId').val('');
            search();
        }
    </script>
</body>
</html>
