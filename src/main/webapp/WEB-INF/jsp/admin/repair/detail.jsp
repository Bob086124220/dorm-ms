<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>报修详情 - 高校公寓管理系统</title>
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
                <div class="page-header">
                    <div>
                        <span class="page-eyebrow">REPAIR MANAGEMENT</span>
                        <h1>报修详情</h1>
                        <p class="page-meta">查看报修信息并处理</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/repair/list" class="btn btn-secondary">
                        返回列表
                    </a>
                </div>

                <!-- 报修信息 -->
                <div class="detail-panel" id="repairInfo">
                    <div class="text-center" style="padding: 40px 0; color: var(--muted);"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" width="32" height="32" style="color: var(--border); margin: 0 auto 8px; display: block;"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                        加载中...</div>
                </div>

                <!-- 完结报修表单（处理中状态显示） -->
                <div class="form-container" id="completeFormContainer" style="display: none;">
                    <h3 class="detail-section-title">完结报修</h3>
                    <form id="completeForm">
                        <div class="mb-3">
                            <label for="handleResult" class="form-label">处理结果 <span class="required">*</span></label>
                            <textarea class="form-control" id="handleResult" rows="4" placeholder="请输入处理结果（如维修内容、更换配件等）" maxlength="500"></textarea>
                            <div class="invalid-feedback" id="handleResultError"></div>
                            <div class="form-text">最多500个字符</div>
                        </div>
                        <button type="button" class="btn btn-primary" id="btnComplete" onclick="submitComplete()">确认完结</button>
                    </form>
                </div>
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
        // 当前报修ID
        var currentRepairId = null;

        $(function() {
            // 从URL参数获取报修ID
            var urlParams = new URLSearchParams(window.location.search);
            currentRepairId = urlParams.get('repairId');

            if (!currentRepairId) {
                $('#repairInfo').html('<div class="text-center" style="padding: 40px 0; color: var(--accent);">参数错误，未指定报修ID</div>');
                return;
            }

            loadRepairDetail(currentRepairId);
        });

        /**
         * 加载报修详情
         * @param {number} repairId - 报修ID
         */
        function loadRepairDetail(repairId) {
            $.ajaxRequest('/admin/repair/' + repairId, 'GET', null, function(result) {
                if (result.data) {
                    renderRepairInfo(result.data);
                }
            }, function(result) {
                $('#repairInfo').html('<div class="text-center" style="padding: 40px 0;"><a href="javascript:void(0)" onclick="loadRepairDetail(' + repairId + ')" style="color: var(--accent);">加载失败，点击重试</a></div>');
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

            var html = '<div class="row">';
            // 左侧：基本信息
            html += '<div class="col-md-6">';
            html += '<h3 class="detail-section-title">基本信息</h3>';
            html += '<table>';
            html += '<tr><td>报修ID</td><td>' + repair.repairId + '</td></tr>';
            html += '<tr><td>学生姓名</td><td>' + (repair.studentName || '-') + '</td></tr>';
            html += '<tr><td>学号</td><td>' + (repair.studentNo || '-') + '</td></tr>';
            html += '<tr><td>楼栋</td><td>' + (repair.buildingName || '-') + '</td></tr>';
            html += '<tr><td>房间</td><td>' + (repair.roomNo || '-') + '</td></tr>';
            html += '<tr><td>联系电话</td><td>' + (repair.contactPhone ? repair.contactPhone.replace(/(\d{3})\d{4}(\d{4})/, '$1****$2') : '-') + '</td></tr>';
            html += '</table>';
            html += '</div>';

            // 右侧：报修信息
            html += '<div class="col-md-6">';
            html += '<h3 class="detail-section-title">报修信息</h3>';
            html += '<table>';
            html += '<tr><td>报修类型</td><td>' + typeText + '</td></tr>';
            html += '<tr><td>报修内容</td><td>' + (repair.repairContent || '-') + '</td></tr>';
            html += '<tr><td>提交时间</td><td>' + $.formatDate(repair.submitTime) + '</td></tr>';
            html += '<tr><td>状态</td><td>' + statusBadge + timeoutBadge + '</td></tr>';
            html += '<tr><td>处理人</td><td>' + (repair.handlerName || '-') + '</td></tr>';
            html += '<tr><td>处理结果</td><td>' + (repair.handleResult || '-') + '</td></tr>';
            html += '<tr><td>完成时间</td><td>' + (repair.finishTime ? $.formatDate(repair.finishTime) : '-') + '</td></tr>';
            html += '</table>';
            html += '</div>';
            html += '</div>';

            $('#repairInfo').html(html);

            // 处理中状态显示完结表单
            if (repair.repairStatus === 1) {
                $('#completeFormContainer').show();
            } else {
                $('#completeFormContainer').hide();
            }
        }

        /**
         * 提交完结报修
         */
        function submitComplete() {
            var handleResult = $('#handleResult').val().trim();

            // 校验处理结果
            if (!handleResult) {
                $('#handleResult').addClass('is-invalid');
                $('#handleResultError').text('请输入处理结果');
                return;
            } else if (handleResult.length > 500) {
                $('#handleResult').addClass('is-invalid');
                $('#handleResultError').text('处理结果不能超过500个字符');
                return;
            } else {
                $('#handleResult').removeClass('is-invalid');
                $('#handleResultError').text('');
            }

            // 禁用提交按钮
            $('#btnComplete').prop('disabled', true).text('提交中...');

            $.ajaxRequest('/admin/repair/complete/' + currentRepairId, 'POST', {
                handleResult: handleResult
            }, function(result) {
                $.toast('success', '报修已完结');
                $('#completeFormContainer').hide();
                loadRepairDetail(currentRepairId);
                $('#btnComplete').prop('disabled', false).text('确认完结');
            }, function(result) {
                $.toast('error', result.msg || '完结失败');
                $('#btnComplete').prop('disabled', false).text('确认完结');
            });
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
