<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>晚归统计 - 高校公寓管理系统</title>
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
                        <h1>晚归统计</h1>
                        <p class="page-meta">按楼栋统计月度晚归人次</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/dorm/late-return/list" class="btn btn-secondary">
                        <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="1.6" fill="none" stroke-linecap="round" stroke-linejoin="round"><line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/></svg>
                        返回列表
                    </a>
                </div>

                <!-- 未分配楼栋提示 -->
                <div id="noBuildingTip" class="alert alert-warning" style="display: none;">
                    您暂未负责任何楼栋，请联系管理员分配楼栋后再使用此功能。
                </div>

                <!-- 查询区域 -->
                                <div class="filter-bar" id="searchContainer">
                    <div class="filter-field">
                        <label for="searchMonth">统计月份</label>
                                                    <input type="month" class="form-control" id="searchMonth">
                    </div>
                    <div class="filter-actions">
                        <button type="button" class="btn btn-secondary btn-sm" onclick="loadData()">
                                                        <svg viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="1.6" fill="none" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                                                        查询
                                                    </button>
                                                    <button type="button" class="btn btn-ghost btn-sm" onclick="resetSearch()">重置</button>
                    </div>
                </div>

                <!-- 统计数据 -->
                <div class="form-container" id="statsContainer">
                    <div class="data-panel">
                        <table>
                            <thead>
                                <tr>
                                    <th>楼栋ID</th>
                                    <th>楼栋名称</th>
                                    <th>晚归人次</th>
                                </tr>
                            </thead>
                            <tbody id="tableBody">
                                <tr>
                                    <td colspan="3" class="text-center py-4">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" width="32" height="32" style="color: var(--border); margin: 0 auto 8px; display: block;"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                                        加载中...
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <!-- 合计 -->
                    <div id="totalContainer" class="mt-3" style="display: none;">
                        <div class="alert alert-info">
                            合计晚归人次：<strong id="totalCount">0</strong>
                        </div>
                    </div>
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
        $(function() {
            // 设置默认月份为当前月
            var now = new Date();
            var yearMonth = now.getFullYear() + '-' + String(now.getMonth() + 1).padStart(2, '0');
            $('#searchMonth').val(yearMonth);

            loadData();
        });

        /**
         * 加载数据
         */
        function loadData() {
            var yearMonth = $('#searchMonth').val() || null;

            $.ajaxRequest('/dorm/late-return/stats', 'GET', {
                yearMonth: yearMonth
            }, function(result) {
                $('#noBuildingTip').hide();
                $('#searchContainer').show();
                $('#statsContainer').show();

                if (result.data) {
                    renderTable(result.data);
                }
            }, function(result) {
                // 判断是否是未分配楼栋
                if (result.msg && result.msg.indexOf('未负责任何楼栋') !== -1) {
                    $('#noBuildingTip').show();
                    $('#searchContainer').hide();
                    $('#statsContainer').hide();
                } else {
                    $('#tableBody').html('<tr><td colspan="3" class="text-center py-4"><a href="javascript:void(0)" onclick="loadData()" style="color: var(--accent);">加载失败，点击重试</a></td></tr>');
                    $('#totalContainer').hide();
                }
            });
        }

        /**
         * 渲染表格
         * @param {Array} list - 统计数据列表
         */
        function renderTable(list) {
            var $tbody = $('#tableBody');
            $tbody.empty();

            if (!list || list.length === 0) {
                $tbody.html('<tr><td colspan="3" class="text-center py-4 text-muted"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" width="32" height="32" style="color: var(--border); margin: 0 auto 8px; display: block;"><polyline points="22 12 16 12 14 15 10 15 8 12 2 12"/><path d="M5.45 5.11L2 12v6a2 2 0 002 2h16a2 2 0 002-2v-6l-3.45-6.89A2 2 0 0016.76 4H7.24a2 2 0 00-1.79 1.11z"/></svg>暂无统计数据</td></tr>');
                $('#totalContainer').hide();
                return;
            }

            var totalCount = 0;
            list.forEach(function(item) {
                totalCount += item.count || 0;
                var row = '<tr>';
                row += '<td>' + (item.buildingId || '-') + '</td>';
                row += '<td>' + (item.buildingName || '-') + '</td>';
                row += '<td><span class="pill pill-pending">' + (item.count || 0) + '</span></td>';
                row += '</tr>';
                $tbody.append(row);
            });

            // 显示合计
            $('#totalCount').text(totalCount);
            $('#totalContainer').show();
        }

        /**
         * 重置查询
         */
        function resetSearch() {
            var now = new Date();
            var yearMonth = now.getFullYear() + '-' + String(now.getMonth() + 1).padStart(2, '0');
            $('#searchMonth').val(yearMonth);
            loadData();
        }
    </script>
</body>
</html>
