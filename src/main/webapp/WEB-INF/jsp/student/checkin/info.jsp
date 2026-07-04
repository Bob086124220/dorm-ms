<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>住宿信息 - 高校公寓管理系统</title>
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
                        <span class="page-eyebrow">ACCOMMODATION INFO</span>
                        <h1>住宿信息</h1>
                        <p class="page-meta">查看您的当前住宿情况和舍友信息</p>
                    </div>
                </div>

                <div class="row">
                    <!-- 住宿信息卡片 -->
                    <div class="col-md-8">
                        <div class="detail-panel">
                            <h3 class="detail-section-title">当前住宿信息</h3>
                            <div id="checkinInfo">
                                <div class="text-center py-4">
                                    <svg width="32" height="32" style="color: var(--border); margin: 0 auto 8px; display: block;"><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-info"/></svg>
                                    加载中...
                                </div>
                            </div>
                        </div>

                        <!-- 舍友信息卡片 -->
                        <div class="form-container">
                            <h6 class="mb-3">舍友信息</h6>
                            <div id="roommateInfo">
                                <div class="text-center py-4">
                                    <svg width="32" height="32" style="color: var(--border); margin: 0 auto 8px; display: block;"><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-info"/></svg>
                                    加载中...
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 提示信息 -->
                    <div class="col-md-4">
                        <div class="detail-panel">
                            <h3 class="detail-section-title">操作提示</h3>
                            <ul style="color: var(--muted); font-size: var(--fs-meta); line-height: 1.8;">
                                <li>住宿信息由管理员/宿管办理</li>
                                <li>如需调宿，请到"调宿申请"页面提交申请</li>
                                <li>如有问题，请联系宿管或管理员</li>
                            </ul>
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
            // 加载住宿信息
            loadCheckinInfo();
            // 加载舍友信息
            loadRoommateInfo();
        });

        /**
         * 加载住宿信息
         */
        function loadCheckinInfo() {
            $.ajaxRequest('/student/checkin/info', 'GET', {}, function(result) {
                if (result.data) {
                    var info = result.data;
                    var html = '<table>';
                    html += '<tr><td>楼栋</td><td>' + (info.buildingName || '-') + '</td></tr>';
                    html += '<tr><td>房间号</td><td>' + (info.roomNo || '-') + '</td></tr>';
                    html += '<tr><td>床位号</td><td>' + (info.bedNo || '-') + '</td></tr>';
                    html += '<tr><td>入住状态</td><td>' + (info.checkinStatusText || '-') + '</td></tr>';
                    html += '<tr><td>入住时间</td><td class="num">' + $.formatDate(info.checkinTime) + '</td></tr>';
                    html += '<tr><td>办理人</td><td>' + (info.operatorName || '-') + '</td></tr>';
                    if (info.remark) {
                        html += '<tr><td>备注</td><td>' + info.remark + '</td></tr>';
                    }
                    html += '</table>';
                    $('#checkinInfo').html(html);
                } else {
                    $('#checkinInfo').html('<div class="text-center py-4 text-muted">暂无住宿信息</div>');
                }
            }, function() {
                $('#checkinInfo').html('<div class="text-center py-4"><a href="javascript:void(0)" onclick="loadCheckinInfo()" class="error-retry-link">加载失败，点击重试</a></div>');
            });
        }

        /**
         * 加载舍友信息
         */
        function loadRoommateInfo() {
            $.ajaxRequest('/student/checkin/roommates', 'GET', {}, function(result) {
                if (result.data && result.data.length > 0) {
                    var html = '<div class="data-panel"><table >';
                    html += '<thead><tr>';
                    html += '<th>姓名</th>';
                    html += '<th>学号</th>';
                    html += '<th>床位</th>';
                    html += '<th>联系电话</th>';
                    html += '</tr></thead>';
                    html += '<tbody>';
                    result.data.forEach(function(roommate) {
                        html += '<tr>';
                        html += '<td>' + (roommate.studentName || '-') + '</td>';
                        html += '<td>' + (roommate.studentNo || '-') + '</td>';
                        html += '<td>' + (roommate.bedNo || '-') + '</td>';
                        html += '<td>' + (roommate.phone ? roommate.phone.replace(/(\d{3})\d{4}(\d{4})/, '$1****$2') : '-') + '</td>';
                        html += '</tr>';
                    });
                    html += '</tbody></table></div>';
                    $('#roommateInfo').html(html);
                } else {
                    $('#roommateInfo').html('<div class="text-center py-4 text-muted">暂无舍友信息</div>');
                }
            }, function() {
                $('#roommateInfo').html('<div class="text-center py-4"><a href="javascript:void(0)" onclick="loadRoommateInfo()" class="error-retry-link">加载失败，点击重试</a></div>');
            });
        }
    </script>
</body>
</html>
