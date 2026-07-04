<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>提交报修 - 高校公寓管理系统</title>
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
                        <span class="page-eyebrow">REPAIR SERVICE</span>
                        <h1>提交报修</h1>
                        <p class="page-meta">填写报修信息，房间将根据您的住宿记录自动获取</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/student/repair/list" class="btn btn-secondary">
                        <svg width="16" height="16"><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-arrow-left"/></svg>
                        返回列表
                    </a>
                </div>

                <!-- 报修表单 -->
                <div class="form-container">
                    <form id="repairForm">
                        <div class="mb-3">
                            <label class="form-label">报修类型 <span class="required">*</span></label>
                            <div class="cselect" id="repairTypeCselect">
                                <div class="cselect-trigger" tabindex="0" aria-haspopup="listbox" aria-expanded="false">
                                    <span class="cselect-val cselect-placeholder">请选择报修类型</span>
                                    <svg class="cselect-arrow" viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="1.6" fill="none" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 12 15 18 9"/></svg>
                                </div>
                                <div class="cselect-panel" role="listbox">
                                    <div class="cselect-option" data-value="">请选择报修类型</div>
                                    <div class="cselect-option" data-value="1">水电故障</div>
                                    <div class="cselect-option" data-value="2">家具损坏</div>
                                    <div class="cselect-option" data-value="3">门窗故障</div>
                                    <div class="cselect-option" data-value="4">其他</div>
                                </div>
                            </div>
                            <div class="invalid-feedback" id="repairTypeError"></div>
                        </div>
                        <div class="mb-3">
                            <label for="repairContent" class="form-label">报修内容 <span class="required">*</span></label>
                            <textarea class="form-control" id="repairContent" name="repairContent" rows="5" placeholder="请详细描述报修内容（如故障现象、位置等）" maxlength="500"></textarea>
                            <div class="invalid-feedback" id="repairContentError"></div>
                            <div class="form-text">最多500个字符</div>
                        </div>
                        <div class="mb-3">
                            <label for="contactPhone" class="form-label">联系电话 <span class="required">*</span></label>
                            <input type="text" class="form-control" id="contactPhone" name="contactPhone" placeholder="请输入联系电话" maxlength="11">
                            <div class="invalid-feedback" id="contactPhoneError"></div>
                        </div>
                        <button type="button" class="btn btn-primary" id="btnSubmit" onclick="submitRepair()">
                            提交报修
                        </button>
                    </form>
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
            $.initCustomSelect();
        });

        /**
         * 提交报修
         */
        function submitRepair() {
            var isValid = true;

            // 校验报修类型
            var repairType = document.querySelector('#repairTypeCselect').dataset.value || '';
            if (!repairType) {
                $('#repairTypeCselect').addClass('error');
                $('#repairTypeError').text('请选择报修类型');
                isValid = false;
            } else {
                $('#repairTypeCselect').removeClass('error');
                $('#repairTypeError').text('');
            }

            // 校验报修内容
            var repairContent = $('#repairContent').val().trim();
            if (!repairContent) {
                $('#repairContent').addClass('is-invalid');
                $('#repairContentError').text('请输入报修内容');
                isValid = false;
            } else if (repairContent.length > 500) {
                $('#repairContent').addClass('is-invalid');
                $('#repairContentError').text('报修内容不能超过500个字符');
                isValid = false;
            } else {
                $('#repairContent').removeClass('is-invalid');
                $('#repairContentError').text('');
            }

            // 校验联系电话
            var contactPhone = $('#contactPhone').val().trim();
            var phoneRegex = /^1[3-9]\d{9}$/;
            if (!contactPhone) {
                $('#contactPhone').addClass('is-invalid');
                $('#contactPhoneError').text('请输入联系电话');
                isValid = false;
            } else if (!phoneRegex.test(contactPhone)) {
                $('#contactPhone').addClass('is-invalid');
                $('#contactPhoneError').text('请输入正确的手机号码');
                isValid = false;
            } else {
                $('#contactPhone').removeClass('is-invalid');
                $('#contactPhoneError').text('');
            }

            if (!isValid) {
                return;
            }

            // 禁用提交按钮
            $('#btnSubmit').prop('disabled', true).text('提交中...');

            var formData = {
                repairType: parseInt(repairType),
                repairContent: repairContent,
                contactPhone: contactPhone
            };

            $.ajaxRequest('/student/repair/submit', 'POST', formData, function(result) {
                $.toast('success', '报修提交成功');
                setTimeout(function() {
                    window.location.href = '${pageContext.request.contextPath}/student/repair/list';
                }, 1500);
            }, function(result) {
                if (result.msg && result.msg.indexOf('无在住记录') !== -1) {
                    $.toast('error', '您当前无在住记录，无法提交报修');
                } else {
                    $.toast('error', result.msg || '提交失败');
                }
                $('#btnSubmit').prop('disabled', false).text('提交报修');
            });
        }
    </script>
</body>
</html>
