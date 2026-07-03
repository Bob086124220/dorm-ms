<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>管理员首页 - 高校公寓管理系统</title>
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
                        <span class="page-eyebrow">SYSTEM OVERVIEW</span>
                        <h1>系统总览</h1>
                        <p class="page-meta">高校公寓管理系统 · 数据概览与快捷入口</p>
                    </div>
                </div>

                <!-- 统计卡片 — 非对称分组 -->
                <section class="row mb-4">
                    <!-- 左侧主数据区：2/3 宽度 -->
                    <div class="col-lg-8 mb-3">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <div class="stat-card" data-decorative-num="01">
                                    <div class="stat-card-label">用户总数</div>
                                    <div class="stat-card-value accent" id="userCount">--</div>
                                    <div class="stat-card-sub">系统注册账号</div>
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <div class="stat-card" data-decorative-num="02">
                                    <div class="stat-card-label">楼栋总数</div>
                                    <div class="stat-card-value" id="buildingCount">--</div>
                                    <div class="stat-card-sub">公寓楼栋数量</div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- 右侧辅助数据区：1/3 宽度 -->
                    <div class="col-lg-4 mb-3">
                        <div class="row">
                            <div class="col-md-6 col-lg-12 mb-3">
                                <div class="stat-card" data-decorative-num="03">
                                    <div class="stat-card-label">待处理报修</div>
                                    <div class="stat-card-value accent2" id="repairCount">--</div>
                                    <div class="stat-card-sub">需跟进处理</div>
                                </div>
                            </div>
                            <div class="col-md-6 col-lg-12 mb-3">
                                <div class="stat-card" data-decorative-num="04">
                                    <div class="stat-card-label">本月晚归</div>
                                    <div class="stat-card-value" id="lateReturnCount">--</div>
                                    <div class="stat-card-sub">本月晚归人次</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- 功能模块 -->
                <section class="row mb-4">
                    <div class="col-12 mb-3">
                        <span class="page-eyebrow page-eyebrow--muted">QUICK ACCESS</span>
                    <div class="col-lg-4 col-md-6 mb-3">
                        <a href="${pageContext.request.contextPath}/admin/user/list" class="module-card">
                            <span class="module-card-num">01</span>
                            <div class="module-icon">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                            </div>
                            <h3>用户管理</h3>
                            <p>管理系统用户账号，分配角色权限</p>
                        </a>
                    </div>
                    <div class="col-lg-4 col-md-6 mb-3">
                        <a href="${pageContext.request.contextPath}/admin/building/list" class="module-card">
                            <span class="module-card-num">02</span>
                            <div class="module-icon">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg>
                            </div>
                            <h3>楼栋管理</h3>
                            <p>楼栋信息维护，宿管绑定</p>
                        </a>
                    </div>
                    <div class="col-lg-4 col-md-6 mb-3">
                        <a href="${pageContext.request.contextPath}/admin/room/list" class="module-card">
                            <span class="module-card-num">03</span>
                            <div class="module-icon">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="7" width="20" height="14" rx="2" ry="2"/><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/></svg>
                            </div>
                            <h3>房间与床位</h3>
                            <p>房间管理，批量初始化床位</p>
                        </a>
                    </div>
                    <div class="col-lg-4 col-md-6 mb-3">
                        <a href="${pageContext.request.contextPath}/admin/checkin/list" class="module-card">
                            <span class="module-card-num">04</span>
                            <div class="module-icon">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="8.5" cy="7" r="4"/><line x1="20" y1="8" x2="20" y2="14"/><line x1="23" y1="11" x2="17" y2="11"/></svg>
                            </div>
                            <h3>入住登记</h3>
                            <p>办理入住，分配空闲床位</p>
                        </a>
                    </div>
                    <div class="col-lg-4 col-md-6 mb-3">
                        <a href="${pageContext.request.contextPath}/admin/repair/list" class="module-card">
                            <span class="module-card-num">05</span>
                            <div class="module-icon">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94l-3.76 3.76z"/></svg>
                            </div>
                            <h3>报修管理</h3>
                            <p>查看报修工单，跟踪处理进度</p>
                        </a>
                    </div>
                    <div class="col-lg-4 col-md-6 mb-3">
                        <a href="${pageContext.request.contextPath}/admin/move/list" class="module-card">
                            <span class="module-card-num">06</span>
                            <div class="module-icon">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 11 12 14 22 4"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/></svg>
                            </div>
                            <h3>调宿审批</h3>
                            <p>审批学生调宿申请</p>
                        </a>
                    </div>
                </section>

                <!-- 系统信息 -->
                <section class="data-panel mb-4">
                    <div class="info-section">
                        <span class="page-eyebrow page-eyebrow--muted">SYSTEM INFO</span>
                        <h2 class="info-title">系统信息</h2>
                    </div>
                    <div class="info-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="info-row info-row--bordered">
                                    <span class="info-label">当前时间</span>
                                    <span class="num" id="currentTime"></span>
                                </div>
                                <div class="info-row">
                                    <span class="info-label">登录账号</span>
                                    <span>${sessionScope.loginUser.username}</span>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="info-row info-row--bordered">
                                    <span class="info-label">角色权限</span>
                                    <span class="pill pill-admin">系统管理员</span>
                                </div>
                                <div class="info-row">
                                    <span class="info-label">系统版本</span>
                                    <span class="num">v1.0.0</span>
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
            $('#userCount').text('--');
            $.ajaxRequest('/admin/user/page', 'GET', { pageSize: 1 }, function(result) {
                $('#userCount').text(result.data.total || 0);
            }, function() { setLoadError('userCount'); });

            $('#buildingCount').text('--');
            $.ajaxRequest('/admin/building/page', 'GET', { pageSize: 1 }, function(result) {
                $('#buildingCount').text(result.data.total || 0);
            }, function() { setLoadError('buildingCount'); });

            $('#repairCount').text('--');
            $.ajaxRequest('/admin/repair/page', 'GET', { repairStatus: 0, pageSize: 1 }, function(result) {
                $('#repairCount').text(result.data.total || 0);
            }, function() { setLoadError('repairCount'); });

            $('#lateReturnCount').text('--');
            $.ajaxRequest('/admin/late-return/stats', 'GET', {}, function(result) {
                if (result.data) {
                    var total = 0;
                    result.data.forEach(function(item) { total += item.count || 0; });
                    $('#lateReturnCount').text(total);
                } else {
                    $('#lateReturnCount').text('0');
                }
            }, function() { setLoadError('lateReturnCount'); });
        }
    </script>
</body>
</html>
