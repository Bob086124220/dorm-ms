<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>访客登记 - 高校公寓管理系统</title>
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
                        <span class="page-eyebrow">VISITOR REGISTRATION</span>
                        <h1>访客登记</h1>
                        <p class="page-meta">管理本楼栋访客记录</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/dorm/visitor/addPage" class="btn btn-primary">
                        录入访客
                    </a>
                </div>

                <!-- 未分配楼栋提示 -->
                <div id="noBuildingTip" class="alert alert-warning" style="display: none;">
                    您暂未负责任何楼栋，请联系管理员分配楼栋后再使用此功能。
                </div>

                <!-- 查询区域 -->
                                <div class="filter-bar" id="searchContainer">
                    <div class="filter-actions">
                        <button type="button" class="btn btn-ghost btn-sm" onclick="resetSearch()">
                                                        刷新
                                                    </button>
                    </div>
                </div>

                <!-- 访客记录列表 -->
                <div class="form-container" id="tableContainer">
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
                                    <th>操作</th>
                                </tr>
                            </thead>
                            <tbody id="tableBody">
                                <tr>
                                    <td colspan="8" class="text-center py-4">
                                        <svg width="32" height="32" style="color: var(--border); margin: 0 auto 8px; display: block;"><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-info"/></svg>
                                        加载中...
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <!-- 分页 -->
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
            $.ajaxRequest('/dorm/visitor/page', 'GET', params, function(result) {
                $('#noBuildingTip').hide();
                $('#searchContainer').show();
                $('#tableContainer').show();

                if (result.data) {
                    renderTable(result.data.list);
                    if (result.data && result.data.pages > 1) {
                    $.renderPagination(result.data, 'paginationContainer',
                        function(page) { pageQueryParams.pageNum = page; loadData(pageQueryParams); },
                        pageQueryParams.pageSize,
                        function(ps) { pageQueryParams.pageNum = 1; pageQueryParams.pageSize = ps; loadData(pageQueryParams); }
                    );
                } else { $('#paginationContainer').empty(); }
                    
                    pageQueryParams.pageNum = result.data.pageNum;
                    pageQueryParams.pageSize = result.data.pageSize;
                }
            }, function(result) {
                // 判断是否是未分配楼栋
                if (result.msg && result.msg.indexOf('未负责任何楼栋') !== -1) {
                    $('#noBuildingTip').show();
                    $('#searchContainer').hide();
                    $('#tableContainer').hide();
                } else {
                    $('#tableBody').html('<tr><td colspan="8" class="text-center py-4"><a href="javascript:void(0)" onclick="loadData(pageQueryParams)" class="error-retry-link">加载失败，点击重试</a></td></tr>');
                }
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
                $tbody.html('<tr><td colspan="8" class="text-center py-4 text-muted"><svg width="32" height="32" style="color: var(--border); margin: 0 auto 8px; display: block;"><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-inbox"/></svg>暂无数据</td></tr>');
                return;
            }

            list.forEach(function(item) {
                var statusBadge = item.leaveTime
                    ? '<span class="pill pill-done">已离开</span>'
                    : '<span class="pill pill-active">在访</span>';

                // 操作按钮
                var actionBtn = '';
                if (!item.leaveTime) {
                    actionBtn = '<button class="btn btn-ghost btn-sm" onclick="confirmLeave(' + item.visitorId + ')">确认离开</button> ';
                }
                actionBtn += '<a href="${pageContext.request.contextPath}/dorm/visitor/detailPage?visitorId=' + item.visitorId + '" class="btn btn-sm btn-ghost">详情</a>';

                var row = '<tr>';
                row += '<td>' + (item.visitorName || '-') + '</td>';
                row += '<td>' + (item.idCard ? item.idCard.replace(/(\d{6})\d{8}(\d{4})/, '$1********$2') : '-') + '</td>';
                row += '<td>' + (item.studentName || '-') + '</td>';
                row += '<td>' + (item.buildingName || '-') + '</td>';
                row += '<td>' + $.formatDate(item.visitTime) + '</td>';
                row += '<td>' + (item.leaveTime ? $.formatDate(item.leaveTime) : '-') + '</td>';
                row += '<td>' + statusBadge + '</td>';
                row += '<td>' + actionBtn + '</td>';
                row += '</tr>';
                $tbody.append(row);
            });
        }

        /**
         * 渲染分页
         * @param {object} pageInfo - 分页信息
         */
                                function resetSearch() {
            pageQueryParams.pageNum = 1;
            loadData(pageQueryParams);
        }

        /**
         * 确认访客离开
         * @param {number} visitorId - 访客ID
         */
        function confirmLeave(visitorId) {
            $.confirm('确定要确认该访客已离开吗？', function() {
                $.ajaxRequest('/dorm/visitor/leave/' + visitorId, 'POST', null, function(result) {
                    $.toast('success', '已确认访客离开');
                    loadData(pageQueryParams);
                }, function(result) {
                    $.toast('error', result.msg || '操作失败');
                });
            });
        }
    </script>
</body>
</html>
