<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>访客详情 - 高校公寓管理系统</title>
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
                        <h1>访客详情</h1>
                        <p class="page-meta">查看访客信息</p>
                    </div>
                    <div class="d-flex gap-2">
                        <button type="button" class="btn btn-primary" id="btnLeave" style="display: none;" onclick="confirmLeave()">
                            确认离开
                        </button>
                        <a href="${pageContext.request.contextPath}/dorm/visitor/list" class="btn btn-secondary">
                            <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="1.6" fill="none" stroke-linecap="round" stroke-linejoin="round"><line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/></svg>
                            返回列表
                        </a>
                    </div>
                </div>

                <!-- 访客信息 -->
                <div class="detail-panel" id="visitorInfo">
                    <div class="text-center py-4">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" width="32" height="32" style="color: var(--border); margin: 0 auto 8px; display: block;"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                        加载中...
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
        // 当前访客ID
        var currentVisitorId = null;

        $(function() {
            // 从URL参数获取访客ID
            var urlParams = new URLSearchParams(window.location.search);
            currentVisitorId = urlParams.get('visitorId');

            if (!currentVisitorId) {
                $('#visitorInfo').html('<div class="text-center py-4" class="error-retry-link">参数错误，未指定访客ID</div>');
                return;
            }

            loadVisitorDetail(currentVisitorId);
        });

        /**
         * 加载访客详情
         * @param {number} visitorId - 访客ID
         */
        function loadVisitorDetail(visitorId) {
            $.ajaxRequest('/dorm/visitor/' + visitorId, 'GET', null, function(result) {
                if (result.data) {
                    renderVisitorInfo(result.data);
                }
            }, function(result) {
                $('#visitorInfo').html('<div class="text-center py-4"><a href="javascript:void(0)" onclick="loadVisitorDetail(' + visitorId + ')" class="error-retry-link">加载失败，点击重试</a></div>');
            });
        }

        /**
         * 渲染访客信息
         * @param {object} visitor - 访客数据
         */
        function renderVisitorInfo(visitor) {
            var statusBadge = visitor.leaveTime
                ? '<span class="pill pill-done">已离开</span>'
                : '<span class="pill pill-active">在访</span>';

            // 显示/隐藏确认离开按钮
            if (!visitor.leaveTime) {
                $('#btnLeave').show();
            } else {
                $('#btnLeave').hide();
            }

            var html = '<div class="row">';
            // 左侧：访客信息
            html += '<div class="col-md-6">';
            html += '<h3 class="detail-section-title">访客信息</h3>';
            html += '<table>';
            html += '<tr><td>访客ID</td><td class="num">' + visitor.visitorId + '</td></tr>';
            html += '<tr><td>访客姓名</td><td>' + (visitor.visitorName || '-') + '</td></tr>';
            html += '<tr><td>身份证号</td><td class="num">' + (visitor.idCard ? visitor.idCard.replace(/(\d{6})\d{8}(\d{4})/, '$1********$2') : '-') + '</td></tr>';
            html += '<tr><td>来访时间</td><td class="num">' + $.formatDate(visitor.visitTime) + '</td></tr>';
            html += '<tr><td>离开时间</td><td class="num">' + (visitor.leaveTime ? $.formatDate(visitor.leaveTime) : '-') + '</td></tr>';
            html += '<tr><td>来访事由</td><td>' + (visitor.visitReason || '-') + '</td></tr>';
            html += '</table>';
            html += '</div>';

            // 右侧：被访学生和状态
            html += '<div class="col-md-6">';
            html += '<h3 class="detail-section-title">其他信息</h3>';
            html += '<table>';
            html += '<tr><td>状态</td><td>' + statusBadge + '</td></tr>';
            html += '<tr><td>被访学生</td><td>' + (visitor.studentName || '-') + '</td></tr>';
            html += '<tr><td>楼栋</td><td>' + (visitor.buildingName || '-') + '</td></tr>';
            html += '<tr><td>登记人</td><td>' + (visitor.registrarName || '-') + '</td></tr>';
            html += '</table>';
            html += '</div>';
            html += '</div>';

            $('#visitorInfo').html(html);
        }

        /**
         * 确认访客离开
         */
        function confirmLeave() {
            $.confirm('确定要确认该访客已离开吗？', function() {
                $.ajaxRequest('/dorm/visitor/leave/' + currentVisitorId, 'POST', null, function(result) {
                    $.toast('success', '已确认访客离开');
                    loadVisitorDetail(currentVisitorId);
                }, function(result) {
                    $.toast('error', result.msg || '操作失败');
                });
            });
        }
    </script>
</body>
</html>
