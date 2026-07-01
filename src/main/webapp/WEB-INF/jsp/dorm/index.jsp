<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>宿管首页 - 高校公寓管理系统</title>
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
                <!-- 页面头部 -->
                <div class="page-header">
                    <div>
                        <h1>宿管工作台</h1>
                        <p class="page-meta">欢迎回来，${sessionScope.loginUser.realName} · 宿管工作概览</p>
                    </div>
                </div>

                <!-- 统计卡片 -->
                <section class="row mb-4">
                    <div class="col-lg-4 col-md-6 mb-3">
                        <div class="stat-card">
                            <div class="stat-card-label">负责楼栋</div>
                            <div class="stat-card-value" id="buildingCount">--</div>
                            <div class="stat-card-sub">当前管理楼栋</div>
                        </div>
                    </div>
                    <div class="col-lg-4 col-md-6 mb-3">
                        <div class="stat-card">
                            <div class="stat-card-label">待处理报修</div>
                            <div class="stat-card-value accent" id="repairCount">--</div>
                            <div class="stat-card-sub">需跟进处理</div>
                        </div>
                    </div>
                    <div class="col-lg-4 col-md-6 mb-3">
                        <div class="stat-card">
                            <div class="stat-card-label">本月晚归</div>
                            <div class="stat-card-value accent2" id="lateReturnCount">--</div>
                            <div class="stat-card-sub">本月晚归人次</div>
                        </div>
                    </div>
                </section>

                <!-- 快捷操作 -->
                <section class="row mb-4">
                    <div class="col-lg-3 col-md-6 mb-3">
                        <a href="${pageContext.request.contextPath}/dorm/checkin/list" class="module-card">
                            <div class="module-icon">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="8.5" cy="7" r="4"/><line x1="20" y1="8" x2="20" y2="14"/><line x1="23" y1="11" x2="17" y2="11"/></svg>
                            </div>
                            <h3>入住登记</h3>
                            <p>办理入住，分配空闲床位</p>
                        </a>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <a href="${pageContext.request.contextPath}/dorm/repair/list" class="module-card">
                            <div class="module-icon">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94l-3.76 3.76z"/></svg>
                            </div>
                            <h3>报修处理</h3>
                            <p>查看报修工单，跟进处理</p>
                        </a>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <a href="${pageContext.request.contextPath}/dorm/late-return/list" class="module-card">
                            <div class="module-icon">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"/></svg>
                            </div>
                            <h3>晚归登记</h3>
                            <p>登记学生晚归信息</p>
                        </a>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <a href="${pageContext.request.contextPath}/dorm/visitor/list" class="module-card">
                            <div class="module-icon">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                            </div>
                            <h3>访客登记</h3>
                            <p>登记来访访客信息</p>
                        </a>
                    </div>
                </section>

                <!-- 系统信息 -->
                <section class="data-panel mb-4">
                    <div class="info-section">
                        <h2 class="info-title">系统信息</h2>
                    </div>
                    <div class="info-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="info-row info-row--bordered">
                                    <span class="info-label">当前时间</span>
                                    <span class="info-value num" id="currentTime"></span>
                                </div>
                                <div class="info-row">
                                    <span class="info-label">登录账号</span>
                                    <span class="info-value">${sessionScope.loginUser.username}</span>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="info-row info-row--bordered">
                                    <span class="info-label">角色权限</span>
                                    <span class="pill pill-manager">宿管</span>
                                </div>
                                <div class="info-row">
                                    <span class="info-label">系统版本</span>
                                    <span class="info-value num">v1.0.0</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>
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
        $(function() {
            function updateTime() {
                var now = new Date();
                $('#currentTime').text($.formatDate(now, 'yyyy-MM-dd HH:mm:ss'));
            }
            updateTime();
            setInterval(updateTime, 60000);
            loadStatistics();
        });

        function setLoadError(elementId) {
            $('#' + elementId).html('<a href="javascript:void(0)" onclick="loadStatistics()" style="color: var(--accent); font-size: var(--fs-meta);">加载失败，点击重试</a>');
        }

        function loadStatistics() {
            $('#buildingCount').text('--');
            $.ajaxRequest('/dorm/building/list', 'GET', {}, function(result) {
                if (result.data) {
                    $('#buildingCount').text(result.data.length || 0);
                } else {
                    $('#buildingCount').text('0');
                }
            }, function(result) {
                if (result.msg && result.msg.indexOf('未负责任何楼栋') !== -1) {
                    $('#buildingCount').html('<span style="font-size: var(--fs-meta); color: var(--accent-2);">未分配</span>');
                } else {
                    setLoadError('buildingCount');
                }
            });

            $('#repairCount').text('--');
            $.ajaxRequest('/dorm/repair/page', 'GET', { repairStatus: 0, pageSize: 1 }, function(result) {
                $('#repairCount').text(result.data.total || 0);
            }, function(result) {
                if (result.msg && result.msg.indexOf('未负责任何楼栋') !== -1) {
                    $('#repairCount').html('<span style="font-size: var(--fs-meta); color: var(--accent-2);">-</span>');
                } else {
                    setLoadError('repairCount');
                }
            });

            $('#lateReturnCount').text('--');
            $.ajaxRequest('/dorm/late-return/stats', 'GET', {}, function(result) {
                if (result.data) {
                    var total = 0;
                    result.data.forEach(function(item) { total += item.count || 0; });
                    $('#lateReturnCount').text(total);
                } else {
                    $('#lateReturnCount').text('0');
                }
            }, function(result) {
                if (result.msg && result.msg.indexOf('未负责任何楼栋') !== -1) {
                    $('#lateReturnCount').html('<span style="font-size: var(--fs-meta); color: var(--accent-2);">-</span>');
                } else {
                    setLoadError('lateReturnCount');
                }
            });
        }
    </script>
</body>
</html>
