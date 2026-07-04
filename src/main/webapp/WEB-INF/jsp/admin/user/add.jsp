<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>新增用户 - 高校公寓管理系统</title>
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/static/images/favicon.svg">
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
                        <span class="page-eyebrow">USER MANAGEMENT</span>
                        <h1>新增用户</h1>
                        <p class="page-meta">创建新的用户账号</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/user/list" class="btn btn-secondary">
                        返回列表
                    </a>
                </div>

                <div class="form-container">
                    <form id="userForm" novalidate>
                        <div class="form-grid">
                            <div class="form-field">
                                <label>用户名 <span class="required">*</span></label>
                                <input type="text" class="form-control" id="username" name="username" placeholder="请输入用户名" maxlength="20">
                            </div>
                            <div class="form-field">
                                <label>真实姓名 <span class="required">*</span></label>
                                <input type="text" class="form-control" id="realName" name="realName" placeholder="请输入真实姓名" maxlength="20">
                            </div>
                            <div class="form-field">
                                <label>角色类型 <span class="required">*</span></label>
                                <div class="cselect" id="roleTypeCselect">
                                    <div class="cselect-trigger" tabindex="0" aria-haspopup="listbox" aria-expanded="false">
                                        <span class="cselect-val cselect-placeholder">请选择角色</span>
                                        <svg class="cselect-arrow" viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="1.6" fill="none" stroke-linecap="round" stroke-linejoin="round">
                                            <polyline points="6 9 12 15 18 9"></polyline>
                                        </svg>
                                    </div>
                                    <div class="cselect-panel" role="listbox">
                                        <div class="cselect-option" data-value="">请选择角色</div>
                                        <div class="cselect-option" data-value="1">管理员</div>
                                        <div class="cselect-option" data-value="2">宿管</div>
                                        <div class="cselect-option" data-value="3">学生</div>
                                    </div>
                                </div>
                            </div>
                            <div class="form-field">
                                <label>性别</label>
                                <div class="cselect" id="genderCselect">
                                    <div class="cselect-trigger" tabindex="0" aria-haspopup="listbox" aria-expanded="false">
                                        <span class="cselect-val cselect-placeholder">请选择性别</span>
                                        <svg class="cselect-arrow" viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="1.6" fill="none" stroke-linecap="round" stroke-linejoin="round">
                                            <polyline points="6 9 12 15 18 9"></polyline>
                                        </svg>
                                    </div>
                                    <div class="cselect-panel" role="listbox">
                                        <div class="cselect-option" data-value="">请选择性别</div>
                                        <div class="cselect-option" data-value="1">男</div>
                                        <div class="cselect-option" data-value="2">女</div>
                                    </div>
                                </div>
                            </div>
                            <div class="form-field">
                                <label>联系电话</label>
                                <input type="text" class="form-control" id="phone" name="phone" placeholder="请输入11位手机号" maxlength="11">
                            </div>
                        </div>

                        <!-- 学生专属字段 -->
                        <div id="studentFields" class="student-fields">
                            <div class="student-fields-header">学生信息
                            </div>
                            <div class="form-grid">
                                <div class="form-field">
                                    <label>年级</label>
                                    <input type="text" class="form-control" id="grade" name="grade" placeholder="如：2024">
                                </div>
                                <div class="form-field">
                                    <label>专业</label>
                                    <input type="text" class="form-control" id="major" name="major" placeholder="请输入专业">
                                </div>
                                <div class="form-field full">
                                    <label>班级</label>
                                    <input type="text" class="form-control" id="className" name="className" placeholder="请输入班级">
                                    <span class="form-hint">学生账号初始密码 = 年级 + 手机号（MD5加密），首次登录强制修改</span>
                                </div>
                            </div>
                        </div>

                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary" id="btnSubmit">保存</button>
                            <a href="${pageContext.request.contextPath}/admin/user/list" class="btn btn-secondary">取消</a>
                        </div>
                    </form>
                </div>
            </div>

            <%@ include file="/WEB-INF/jsp/common/footer.jsp" %>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/static/js/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/static/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/jquery.validate.min.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/messages_zh.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/common.js"></script>
    <script>window.needChangePasswordFlag = '${sessionScope.needChangePassword}';</script>
    <script src="${pageContext.request.contextPath}/static/js/header.js"></script>

    <script>
        $(function() {
            $.initCustomSelect();

            // 角色类型变化事件
            document.querySelector('#roleTypeCselect').addEventListener('cselect:change', function(e) {
                if (e.detail.value === '3') {
                    $('#studentFields').show();
                } else {
                    $('#studentFields').hide();
                }
            });

            $.validator.addMethod('phonePattern', function(value, element) {
                return this.optional(element) || /^1[3-9]\d{9}$/.test(value);
            }, '请输入正确的手机号码');

            $('#userForm').validate({
                rules: {
                    username: { required: true, minlength: 3, maxlength: 20 },
                    realName: { required: true, maxlength: 20 },
                    roleType: { required: true },
                    phone: { phonePattern: true }
                },
                messages: {
                    username: { required: '请输入用户名', minlength: '用户名长度3-20个字符', maxlength: '用户名长度3-20个字符' },
                    realName: { required: '请输入真实姓名', maxlength: '姓名长度不超过20个字符' },
                    roleType: { required: '请选择角色类型' }
                },
                submitHandler: function() { submitForm(); }
            });
        });

        function submitForm() {
            var formData = {
                username: $('#username').val().trim(),
                realName: $('#realName').val().trim(),
                roleType: parseInt(document.querySelector('#roleTypeCselect').dataset.value),
                gender: document.querySelector('#genderCselect').dataset.value ? parseInt(document.querySelector('#genderCselect').dataset.value) : null,
                phone: $('#phone').val().trim() || null,
                grade: $('#grade').val().trim() || null,
                major: $('#major').val().trim() || null,
                className: $('#className').val().trim() || null
            };

            $('#btnSubmit').prop('disabled', true).text('保存中...');

            $.ajaxRequest('/admin/user/add', 'POST', formData, function() {
                $.toast('success', '用户创建成功');
                setTimeout(function() { window.location.href = $.buildUrl('/admin/user/list'); }, 1000);
            }, function(result) {
                $.toast('error', result.msg || '创建失败');
                $('#btnSubmit').prop('disabled', false).text('保存');
            });
        }
    </script>
</body>
</html>
