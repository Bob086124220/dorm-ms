<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>晚归登记 - 高校公寓管理系统</title>
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
                        <span class="page-eyebrow">LATE RETURN LOG</span>
                        <h1>晚归登记</h1>
                        <p class="page-meta">管理学生晚归记录</p>
                    </div>
                    <div style="display: flex; gap: 8px;">
                        <a href="${pageContext.request.contextPath}/admin/late-return/statsPage" class="btn btn-secondary">
                            晚归统计
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/late-return/addPage" class="btn btn-primary">
                            <svg width="16" height="16"><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-plus"/></svg>
                            录入晚归
                        </a>
                    </div>
                </div>

                <div class="filter-bar">
                    <div class="filter-field">
                        <label>学生ID</label>
                        <input type="text" id="searchStudentId" placeholder="请输入学生ID">
                    </div>
                    <div class="filter-field">
                        <label>楼栋ID</label>
                        <input type="text" id="searchBuildingId" placeholder="请输入楼栋ID">
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
                                <th>晚归时间</th>
                                <th>晚归原因</th>
                                <th>登记人</th>
                                <th>登记时间</th>
                            </tr>
                        </thead>
                        <tbody id="tableBody">
                            <tr><td colspan="7" class="text-center" style="padding: 40px 0; color: var(--muted);">加载中...</td></tr>
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

            $.ajaxRequest('/admin/late-return/page', 'GET', queryParams, function(result) {
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
                $('#tableBody').html('<tr><td colspan="7" class="text-center" style="padding: 40px 0;"><a href="javascript:void(0)" onclick="loadData(pageQueryParams)" class="error-retry-link">加载失败，点击重试</a></td></tr>');
            });
        }

        /**
         * 渲染表格
         * @param {Array} list - 晚归记录列表
         */
        function renderTable(list) {
            var $tbody = $('#tableBody');
            $tbody.empty();

            if (!list || list.length === 0) {
                $tbody.html('<tr><td colspan="7" class="text-center" style="padding: 40px 0; color: var(--muted);"><svg width="32" height="32" style="color: var(--border); margin: 0 auto 8px; display: block;"><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-inbox"/></svg>暂无数据</td></tr>');
                return;
            }

            list.forEach(function(item) {
                var row = '<tr>';
                row += '<td>' + (item.studentName || '-') + '</td>';
                row += '<td>' + (item.studentNo || '-') + '</td>';
                row += '<td>' + (item.buildingName || '-') + '</td>';
                row += '<td>' + $.formatDate(item.lateTime) + '</td>';
                row += '<td>' + (item.lateReason || '-') + '</td>';
                row += '<td>' + (item.registrarName || '-') + '</td>';
                row += '<td>' + $.formatDate(item.recordTime) + '</td>';
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
            $('#searchBuildingId').val('');
            search();
        }
    </script>
</body>
</html>
