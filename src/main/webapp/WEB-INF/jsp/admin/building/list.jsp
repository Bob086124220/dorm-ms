<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>楼栋管理 - 高校公寓管理系统</title>
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
                        <span class="page-eyebrow">BUILDING MANAGEMENT</span>
                        <h1>楼栋管理</h1>
                        <p class="page-meta">管理公寓楼栋信息 · 楼层 · 区域 · 宿管绑定</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/building/addPage" class="btn btn-primary">
                        <svg width="16" height="16"><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-plus"/></svg>
                        新增楼栋
                    </a>
                </div>

                <div class="filter-bar">
                    <div class="filter-field">
                        <label>楼栋编号</label>
                        <input type="text" id="searchBuildingNo" placeholder="输入编号搜索">
                    </div>
                    <div class="filter-field">
                        <label>楼栋名称</label>
                        <input type="text" id="searchBuildingName" placeholder="输入名称搜索">
                    </div>
                    <div class="filter-field">
                        <label>所属区域</label>
                        <input type="text" id="searchArea" placeholder="输入区域搜索">
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
                                <th>楼栋编号</th>
                                <th>楼栋名称</th>
                                <th>楼层总数</th>
                                <th>所属区域</th>
                                <th>负责宿管</th>
                                <th>备注</th>
                                <th class="col-actions">操作</th>
                            </tr>
                        </thead>
                        <tbody id="tableBody">
                            <tr><td colspan="7" class="text-center" style="padding: 40px 0; color: var(--muted);"><svg width="32" height="32" style="color: var(--border); margin: 0 auto 8px; display: block;"><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-info"/></svg>
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

        $(function() { loadData(pageQueryParams); });

        function loadData(params) {
            var queryParams = $.extend({}, params, {
                buildingNo: $('#searchBuildingNo').val().trim(),
                buildingName: $('#searchBuildingName').val().trim(),
                area: $('#searchArea').val().trim()
            });

            $.ajaxRequest('/admin/building/page', 'GET', queryParams, function(result) {
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

        function renderTable(list) {
            var $tbody = $('#tableBody');
            $tbody.empty();
            if (!list || list.length === 0) {
                $tbody.html('<tr><td colspan="7" class="text-center" style="padding: 40px 0; color: var(--muted);"><svg width="32" height="32" style="color: var(--border); margin: 0 auto 8px; display: block;"><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-inbox"/></svg>暂无数据</td></tr>');
                return;
            }
            list.forEach(function(item) {
                var row = '<tr>';
                row += '<td class="num">' + (item.buildingNo || '-') + '</td>';
                row += '<td>' + (item.buildingName || '-') + '</td>';
                row += '<td class="num">' + (item.floorCount || '-') + '</td>';
                row += '<td>' + (item.area || '-') + '</td>';
                row += '<td>' + (item.managerName || '-') + '</td>';
                row += '<td class="text-muted">' + (item.remark || '-') + '</td>';
                row += '<td class="actions">';
                row += '<a href="${pageContext.request.contextPath}/admin/building/editPage?buildingId=' + item.buildingId + '" class="btn btn-ghost btn-sm">编辑</a>';
                row += '<button class="btn btn-ghost btn-sm" onclick="deleteBuilding(' + item.buildingId + ')">删除</button>';
                row += '</td></tr>';
                $tbody.append(row);
            });
        }

        function search() { pageQueryParams.pageNum = 1; loadData(pageQueryParams); }
        function resetSearch() { $('#searchBuildingNo').val(''); $('#searchBuildingName').val(''); $('#searchArea').val(''); search(); }

        function deleteBuilding(buildingId) {
            $.confirm('确定删除该楼栋吗？', function() {
                $.ajaxRequest('/admin/building/delete/' + buildingId, 'POST', null, function() {
                    $.toast('success', '删除成功');
                    loadData(pageQueryParams);
                }, function(result) { $.toast('error', result.msg || '删除失败'); });
            });
        }
    </script>
</body>
</html>
