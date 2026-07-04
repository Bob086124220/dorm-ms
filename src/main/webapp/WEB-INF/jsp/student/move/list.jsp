<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>调宿申请 - 高校公寓管理系统</title>
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/static/images/favicon.svg">
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/vendor/bootstrap/css/bootstrap.min.css">
    <!-- 公共CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/tokens.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/common.css">
</head>
<body class="student-layout">
    <div class="main-container">
        <!-- 侧边栏 -->
        <%@ include file="/WEB-INF/jsp/common/sidebar.jsp" %>

        <!-- 内容区域 -->
        <div class="content-wrapper">
            <!-- 导航栏 -->
            <%@ include file="/WEB-INF/jsp/common/header.jsp" %>
            <%@ include file="/WEB-INF/jsp/common/student_tabs.jsp" %>

            <!-- 内容主体 -->
            <div class="content-body">
                <!-- 页面标题 -->
                <div class="page-header">
                    <div>
                        <span class="page-eyebrow">ROOM TRANSFER</span>
                        <h1>调宿申请</h1>
                        <p class="page-meta">查看和管理我的调宿申请</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/student/move/applyPage" class="btn btn-primary">
                        提交新申请
                    </a>
                </div>

                <!-- 调宿申请列表 -->
                <div class="form-container">
                    <div class="data-panel">
                        <table>
                            <thead>
                                <tr>
                                    <th>原床位</th>
                                    <th>目标床位</th>
                                    <th>申请原因</th>
                                    <th>申请时间</th>
                                    <th>状态</th>
                                    <th>审批意见</th>
                                    <th>操作</th>
                                </tr>
                            </thead>
                            <tbody id="tableBody">
                                <tr>
                                    <td colspan="7" class="text-center py-4">
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
            $.ajaxRequest('/student/move/page', 'GET', params, function(result) {
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
            }, function() {
                $('#tableBody').html('<tr><td colspan="7" class="text-center py-4"><a href="javascript:void(0)" onclick="loadData(pageQueryParams)" class="error-retry-link">加载失败，点击重试</a></td></tr>');
            });
        }

        /**
         * 渲染表格
         * @param {Array} list - 调宿申请列表
         */
        function renderTable(list) {
            var $tbody = $('#tableBody');
            $tbody.empty();

            if (!list || list.length === 0) {
                $tbody.html('<tr><td colspan="7" class="text-center py-4 text-muted"><svg width="32" height="32" style="color: var(--border); margin: 0 auto 8px; display: block;"><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-inbox"/></svg>暂无调宿申请记录</td></tr>');
                return;
            }

            list.forEach(function(item) {
                var statusBadge = getStatusBadge(item.auditStatus);
                var actionBtn = '';
                if (item.auditStatus === 0) {
                    actionBtn = '<button class="btn btn-sm btn-ghost" onclick="cancelApply(' + item.applyId + ')">撤销</button>';
                } else {
                    actionBtn = '<span class="text-muted">-</span>';
                }

                var row = '<tr>';
                row += '<td>' + (item.originalBedInfo || '-') + '</td>';
                row += '<td>' + (item.targetBedInfo || '-') + '</td>';
                row += '<td>' + (item.applyReason || '-') + '</td>';
                row += '<td>' + $.formatDate(item.applyTime) + '</td>';
                row += '<td>' + statusBadge + '</td>';
                row += '<td>' + (item.auditOpinion || '-') + '</td>';
                row += '<td>' + actionBtn + '</td>';
                row += '</tr>';
                $tbody.append(row);
            });
        }

        /**
         * 渲染分页
         * @param {object} pageInfo - 分页信息
         */
                                /**
         * 获取状态徽章
         * @param {number} status - 审批状态
         * @returns {string} 状态徽章HTML
         */
        function getStatusBadge(status) {
            var map = {
                0: '<span class="pill pill-pending">待审批</span>',
                1: '<span class="pill pill-active">已通过</span>',
                2: '<span class="pill pill-danger">已驳回</span>'
            };
            return map[status] || '<span class="pill pill-quiet">未知</span>';
        }

        /**
         * 撤销调宿申请
         * @param {number} applyId - 申请ID
         */
        function cancelApply(applyId) {
            $.confirm('确定要撤销该调宿申请吗？撤销后状态将变为"已驳回"。', function() {
                $.ajaxRequest('/student/move/cancel/' + applyId, 'POST', null, function(result) {
                    $.toast('success', '申请已撤销');
                    loadData(pageQueryParams);
                }, function(result) {
                    $.toast('error', result.msg || '撤销失败');
                });
            });
        }
    </script>
</body>
</html>
