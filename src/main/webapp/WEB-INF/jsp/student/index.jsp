<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>学生首页 - 高校公寓管理系统</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/vendor/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/tokens.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/common.css">
</head>
<body class="student-layout">
    <div class="main-container">
        <!-- 侧边栏（学生角色不显示） -->
        <%@ include file="/WEB-INF/jsp/common/sidebar.jsp" %>

        <!-- 内容区域 -->
        <div class="content-wrapper">
            <!-- 导航栏 -->
            <%@ include file="/WEB-INF/jsp/common/header.jsp" %>

            <!-- 学生标签导航 -->
            <%@ include file="/WEB-INF/jsp/common/student_tabs.jsp" %>

            <!-- 内容主体 -->
            <div class="content-body">
                <!-- 页面头部 -->
                <div class="page-header">
                    <div>
                        <span class="page-eyebrow">STUDENT HOME</span>
                        <h1>我的主页</h1>
                        <p class="page-meta">欢迎回来，${sessionScope.loginUser.realName}</p>
                    </div>
                </div>

                <!-- 统计卡片 -->
                <section class="row mb-4">
                    <div class="col-md-6 mb-3">
                        <div class="stat-card" data-decorative-num="01">
                            <div class="stat-card-label">住宿状态</div>
                            <div class="stat-card-value" id="checkinStatus">--</div>
                            <div class="stat-card-sub">当前住宿信息</div>
                        </div>
                    </div>
                    <div class="col-md-6 mb-3">
                        <div class="stat-card" data-decorative-num="02">
                            <div class="stat-card-label">待处理报修</div>
                            <div class="stat-card-value accent" id="repairCount">--</div>
                            <div class="stat-card-sub">报修工单数量</div>
                        </div>
                    </div>
                </section>

                <!-- 快捷操作 -->
                <section class="row mb-4">
                    <div class="col-lg-3 col-md-6 mb-3">
                        <a href="${pageContext.request.contextPath}/student/checkin/infoPage" class="module-card">
                            <span class="module-card-num">01</span>
                            <div class="module-icon">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg>
                            </div>
                            <h3>住宿信息</h3>
                            <p>查看当前住宿和舍友</p>
                        </a>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <a href="${pageContext.request.contextPath}/student/move/list" class="module-card">
                            <span class="module-card-num">02</span>
                            <div class="module-icon">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 11 12 14 22 4"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/></svg>
                            </div>
                            <h3>调宿申请</h3>
                            <p>提交或查看调宿申请</p>
                        </a>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <a href="${pageContext.request.contextPath}/student/repair/submit" class="module-card">
                            <span class="module-card-num">03</span>
                            <div class="module-icon">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94l-3.76 3.76z"/></svg>
                            </div>
                            <h3>提交报修</h3>
                            <p>提交宿舍报修申请</p>
                        </a>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <a href="${pageContext.request.contextPath}/student/late-return/list" class="module-card">
                            <span class="module-card-num">04</span>
                            <div class="module-icon">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                            </div>
                            <h3>晚归记录</h3>
                            <p>查看个人晚归记录</p>
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
                                    <span class="pill pill-student">学生</span>
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
        /**
         * 数字滚动动画
         * @param {string} elementId - 目标元素 ID
         * @param {number} target - 目标数值
         * @param {number} duration - 动画时长（毫秒），默认 600
         */
        function countUp(elementId, target, duration) {
            duration = duration || 600;
            var el = document.getElementById(elementId);
            if (!el || target <= 0) {
                if (el) el.textContent = target;
                return;
            }
            var start = 0;
            var startTime = null;
            function step(timestamp) {
                if (!startTime) startTime = timestamp;
                var progress = Math.min((timestamp - startTime) / duration, 1);
                var current = Math.floor(progress * target);
                el.textContent = current;
                if (progress < 1) {
                    requestAnimationFrame(step);
                } else {
                    el.textContent = target;
                }
            }
            requestAnimationFrame(step);
        }

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
            $('#' + elementId).html('<a href="javascript:void(0)" onclick="loadStatistics()" class="error-retry-link">加载失败，点击重试</a>');
        }

        function loadStatistics() {
            $('#checkinStatus').text('--');
            $.ajaxRequest('/student/checkin/info', 'GET', {}, function(result) {
                if (result.data) {
                    $('#checkinStatus').html('<span class="pill pill-active">在住</span>');
                } else {
                    $('#checkinStatus').html('<span class="pill pill-quiet">未入住</span>');
                }
            }, function() {
                setLoadError('checkinStatus');
            });

            $('#repairCount').text('--');
            $.ajaxRequest('/student/repair/page', 'GET', { repairStatus: 0, pageSize: 1 }, function(result) {
                countUp('repairCount', result.data.total || 0);
            }, function() {
                setLoadError('repairCount');
            });
        }
    </script>
</body>
</html>
