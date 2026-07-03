<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>报修详情 - 高校公寓管理系统</title>
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
                        <span class="page-eyebrow">REPAIR SERVICE</span>
                        <h1>报修详情</h1>
                        <p class="page-meta">查看报修处理进度</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/student/repair/list" class="btn btn-secondary">
                        <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="1.6" fill="none" stroke-linecap="round" stroke-linejoin="round"><line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/></svg>
                        返回列表
                    </a>
                </div>

                <!-- 报修信息 -->
                <div class="detail-panel" id="repairInfo">
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
        // 当前报修ID
        var currentRepairId = null;

        $(function() {
            // 从URL参数获取报修ID
            var urlParams = new URLSearchParams(window.location.search);
            currentRepairId = urlParams.get('repairId');

            if (!currentRepairId) {
                $('#repairInfo').html('<div class="text-center py-4" class="error-retry-link">参数错误，未指定报修ID</div>');
                return;
            }

            loadRepairDetail(currentRepairId);
        });

        /**
         * 加载报修详情
         * @param {number} repairId - 报修ID
         */
        function loadRepairDetail(repairId) {
            $.ajaxRequest('/student/repair/' + repairId, 'GET', null, function(result) {
                if (result.data) {
                    renderRepairInfo(result.data);
                }
            }, function(result) {
                $('#repairInfo').html('<div class="text-center py-4"><a href="javascript:void(0)" onclick="loadRepairDetail(' + repairId + ')" class="error-retry-link">加载失败，点击重试</a></div>');
            });
        }

        /**
         * 渲染报修信息
         * @param {object} repair - 报修数据
         */
        function renderRepairInfo(repair) {
            var statusBadge = getStatusBadge(repair.repairStatus);
            var typeText = getRepairTypeText(repair.repairType);
            var timeoutBadge = repair.isTimeout ? ' <span class="pill pill-danger">超时</span>' : '';

            // 状态步骤条
            var steps = [
                { label: '待处理', status: 0 },
                { label: '处理中', status: 1 },
                { label: '已完成', status: 2 }
            ];
            var currentStepIndex = steps.findIndex(function(s) { return s.status === repair.repairStatus; });

            var html = '<div class="mb-4">';
            html += '<h3 class="detail-section-title">处理进度</h3>';
            html += '<div class="d-flex align-items-center">';
            steps.forEach(function(step, index) {
                var isActive = index <= currentStepIndex;
                var isCurrent = index === currentStepIndex;
                var stepClass = isCurrent ? 'step-circle--active' : (isActive ? 'step-circle--done' : 'step-circle--pending');

                html += '<div class="d-flex align-items-center">';
                html += '<div class="step-circle ' + stepClass + '">';
                if (index < currentStepIndex) {
                    html += '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" width="14" height="14"><polyline points="20 6 9 17 4 12"/></svg>';
                } else {
                    html += (index + 1);
                }
                html += '</div>';
                html += '<span class="ms-2 ' + (isActive ? '' : 'text-muted') + '">' + step.label + '</span>';
                html += '</div>';

                if (index < steps.length - 1) {
                    html += '<div class="flex-grow-1 mx-3" style="height: 2px; background-color: ' + (isActive && index < currentStepIndex ? 'var(--status-ok)' : 'var(--border)') + ';"></div>';
                }
            });
            html += '</div>';
            html += '</div>';

            // 报修详细信息
            html += '<div class="row">';
            // 左侧：基本信息
            html += '<div class="col-md-6">';
            html += '<h3 class="detail-section-title">基本信息</h3>';
            html += '<table>';
            html += '<tr><td>楼栋</td><td>' + (repair.buildingName || '-') + '</td></tr>';
            html += '<tr><td >房间</td><td>' + (repair.roomNo || '-') + '</td></tr>';
            html += '<tr><td >报修类型</td><td>' + typeText + '</td></tr>';
            html += '<tr><td >报修内容</td><td>' + (repair.repairContent || '-') + '</td></tr>';
            html += '<tr><td >联系电话</td><td class="num">' + (repair.contactPhone ? repair.contactPhone.replace(/(\d{3})\d{4}(\d{4})/, '$1****$2') : '-') + '</td></tr>';
            html += '<tr><td >提交时间</td><td class="num">' + $.formatDate(repair.submitTime) + '</td></tr>';
            html += '</table>';
            html += '</div>';

            // 右侧：处理信息
            html += '<div class="col-md-6">';
            html += '<h3 class="detail-section-title">处理信息</h3>';
            html += '<table>';
            html += '<tr><td>状态</td><td>' + statusBadge + timeoutBadge + '</td></tr>';
            html += '<tr><td >处理人</td><td>' + (repair.handlerName || '-') + '</td></tr>';
            html += '<tr><td >处理结果</td><td>' + (repair.handleResult || '-') + '</td></tr>';
            html += '<tr><td >完成时间</td><td class="num">' + (repair.finishTime ? $.formatDate(repair.finishTime) : '-') + '</td></tr>';
            html += '</table>';
            html += '</div>';
            html += '</div>';

            $('#repairInfo').html(html);
        }

        /**
         * 获取状态徽章
         * @param {number} status - 处理状态
         * @returns {string} 状态徽章HTML
         */
        function getStatusBadge(status) {
            var map = {
                0: '<span class="pill pill-pending">待处理</span>',
                1: '<span class="pill pill-processing">处理中</span>',
                2: '<span class="pill pill-done">已完成</span>'
            };
            return map[status] || '<span class="pill pill-quiet">未知</span>';
        }

        /**
         * 获取报修类型文本
         * @param {number} type - 报修类型
         * @returns {string} 类型文本
         */
        function getRepairTypeText(type) {
            var map = {
                1: '水电故障',
                2: '家具损坏',
                3: '门窗故障',
                4: '其他'
            };
            return map[type] || '-';
        }
    </script>
</body>
</html>
