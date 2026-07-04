<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>楼栋信息 - 高校公寓管理系统</title>
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/static/images/favicon.svg">
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/vendor/bootstrap/css/bootstrap.min.css">
    <!-- 公共CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/tokens.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/common.css">
</head>
<body>
    <div class="main-container">
        <!-- 侧边栏 -->
        <%@ include file="/WEB-INF/jsp/common/sidebar.jsp" %>

        <!-- 内容区域 -->
        <div class="content-wrapper">
            <!-- 导航栏 -->
            <%@ include file="/WEB-INF/jsp/common/header.jsp" %>

            <!-- 内容主体 -->
            <div class="content-body">
                <!-- 页面标题 -->
                <div class="page-header">
                    <div>
                        <span class="page-eyebrow">BUILDING INFORMATION</span>
                        <h1>楼栋信息</h1>
                        <p class="page-meta">查看本人所负责的楼栋基本信息</p>
                    </div>
                </div>

                <!-- 楼栋列表 -->
                <div class="data-panel">
                    <table>
                        <thead>
                            <tr>
                                <th>楼栋编号</th>
                                <th>楼栋名称</th>
                                <th>楼层总数</th>
                                <th>所属区域</th>
                                <th>备注</th>
                            </tr>
                        </thead>
                        <tbody id="tableBody">
                            <tr>
                                <td colspan="5" class="text-center" style="padding: 40px 0; color: var(--muted);">
                                    <svg width="32" height="32" style="color: var(--border); margin: 0 auto 8px; display: block;"><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-info"/></svg>
                                    加载中...
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <div id="paginationContainer"></div>
                </div>
            </div>

            <!-- 底部 -->
            <%@ include file="/WEB-INF/jsp/common/footer.jsp" %>
        </div>
    </div>

    <!-- jQuery -->
    <script src="${pageContext.request.contextPath}/static/js/jquery.min.js"></script>
    <!-- Bootstrap JS -->
    <script src="${pageContext.request.contextPath}/static/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <!-- 公共JS -->
    <script src="${pageContext.request.contextPath}/static/js/common.js"></script>
    <!-- 导航栏JS -->
    <script>window.needChangePasswordFlag = '${sessionScope.needChangePassword}';</script>
    <script src="${pageContext.request.contextPath}/static/js/header.js"></script>

    <script>
        var pageQueryParams = { pageNum: 1, pageSize: 10 };

        $(function() {
            loadData(1);
        });

        /**
         * 分页加载负责楼栋列表
         * @param {number} pageNum - 页码
         */
        function loadData(pageNum) {
            pageQueryParams.pageNum = pageNum;
            var queryParams = {
                pageNum: pageNum,
                pageSize: pageQueryParams.pageSize
            };

            $.ajaxRequest('/dorm/building/page', 'GET', queryParams, function(result) {
                if (result.data) {
                    renderTable(result.data.list);
                    $.renderPagination(result.data, 'paginationContainer', function(page) {
                        loadData(page);
                    });
                }
            }, function(result) {
                if (result.msg && result.msg.indexOf('未负责任何楼栋') !== -1) {
                    $('#tableBody').html('<tr><td colspan="5" class="text-center" style="padding: 40px 0; color: var(--accent-2);">您暂未负责任何楼栋，请联系管理员</td></tr>');
                } else {
                    $('#tableBody').html('<tr><td colspan="5" class="text-center" style="padding: 40px 0;"><a href="javascript:void(0)" onclick="loadData(pageQueryParams.pageNum)" class="error-retry-link">加载失败，点击重试</a></td></tr>');
                }
            });
        }

        /**
         * 渲染表格
         * @param {Array} list - 楼栋列表
         */
        function renderTable(list) {
            var $tbody = $('#tableBody');
            $tbody.empty();

            if (!list || list.length === 0) {
                $tbody.html('<tr><td colspan="5" class="text-center" style="padding: 40px 0; color: var(--muted);"><svg width="32" height="32" style="color: var(--border); margin: 0 auto 8px; display: block;"><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-inbox"/></svg>暂无数据</td></tr>');
                return;
            }

            list.forEach(function(item) {
                var row = '<tr>';
                row += '<td>' + (item.buildingNo || '-') + '</td>';
                row += '<td>' + (item.buildingName || '-') + '</td>';
                row += '<td>' + (item.floorCount || '-') + '</td>';
                row += '<td>' + (item.area || '-') + '</td>';
                row += '<td>' + (item.remark || '-') + '</td>';
                row += '</tr>';
                $tbody.append(row);
            });
        }
    </script>
</body>
</html>
