<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>个人信息 - 高校公寓管理系统</title>
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
                        <span class="page-eyebrow">PERSONAL INFO</span>
                        <h1>个人信息</h1>
                        <p class="page-meta">查看和修改您的个人基本信息</p>
                    </div>
                </div>

                <!-- 个人信息 -->
                <div class="row">
                    <div class="col-md-8">
                        <div class="detail-panel">
                            <table>
                                <tr><td>学号</td><td id="username"></td></tr>
                                <tr><td>姓名</td><td id="realName"></td></tr>
                                <tr><td>性别</td><td id="gender"></td></tr>
                                <tr><td>年级</td><td id="grade"></td></tr>
                                <tr><td>专业</td><td id="major"></td></tr>
                                <tr><td>班级</td><td id="className"></td></tr>
                                <tr><td>联系电话</td><td><span id="phone"></span> <button type="button" class="btn btn-ghost btn-sm" onclick="showEditPhoneModal()">修改</button></td></tr>
                                <tr><td>账号状态</td><td id="status"></td></tr>
                                <tr><td>注册时间</td><td id="createTime"></td></tr>
                            </table>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="detail-panel">
                            <h3 class="detail-section-title">操作提示</h3>
                            <ul style="color: var(--muted); font-size: var(--fs-meta); line-height: 1.8;">
                                <li>学号、姓名等基本信息由管理员维护</li>
                                <li>联系电话可自行修改</li>
                                <li>如需修改其他信息，请联系管理员</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 底部 -->
            <%@ include file="/WEB-INF/jsp/common/footer.jsp" %>
        </div>
    </div>

    <!-- 修改联系电话模态框 -->
    <div class="modal fade" id="editPhoneModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="modal-title">修改联系电话</h2>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="editPhoneForm">
                        <div class="mb-3">
                            <label for="newPhone" class="form-label">新联系电话 <span class="required">*</span></label>
                            <input type="text" class="form-control" id="newPhone" placeholder="请输入新的联系电话" maxlength="11">
                            <div class="invalid-feedback" id="newPhoneError"></div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                    <button type="button" class="btn btn-primary" id="btnSavePhone">保存</button>
                </div>
            </div>
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
            // 加载个人信息
            loadUserInfo();

            // 保存联系电话
            $('#btnSavePhone').on('click', function() {
                var phone = $('#newPhone').val().trim();

                // 校验手机号
                if (!phone) {
                    $('#newPhone').addClass('is-invalid');
                    $('#newPhoneError').text('请输入联系电话');
                    return;
                }
                if (!/^1[3-9]\d{9}$/.test(phone)) {
                    $('#newPhone').addClass('is-invalid');
                    $('#newPhoneError').text('请输入正确的手机号码');
                    return;
                }

                $('#newPhone').removeClass('is-invalid');
                $('#newPhoneError').text('');

                // 禁用按钮
                $('#btnSavePhone').prop('disabled', true).text('保存中...');

                $.ajaxRequest('/student/user/updatePhone', 'POST', {phone: phone}, function(result) {
                    $.toast('success', '联系电话修改成功');
                    $('#editPhoneModal').modal('hide');
                    // 更新显示（input元素用val()）
                    $('#phone').text(phone);
                    $('#btnSavePhone').prop('disabled', false).text('保存');
                }, function(result) {
                    $.toast('error', result.msg || '修改失败');
                    $('#btnSavePhone').prop('disabled', false).text('保存');
                });
            });
        });

        /**
         * 加载个人信息
         */
        function loadUserInfo() {
            $.ajaxRequest('/student/user/getInfo', 'GET', {}, function(result) {
                if (result.data) {
                    var user = result.data;
                    $('#username').text(user.username || '-');
                    $('#realName').text(user.realName || '-');
                    $('#gender').text(user.gender === 1 ? '男' : '女');
                    $('#grade').text(user.grade || '-');
                    $('#major').text(user.major || '-');
                    $('#className').text(user.className || '-');
                    $('#phone').text(user.phone || '-');
                    $('#status').html(user.status === 1 ? '<span class="pill pill-active">正常</span>' : '<span class="pill pill-disabled">禁用</span>');
                    $('#createTime').text($.formatDate(user.createTime));
                }
            }, function() {
                $.toast('error', '加载个人信息失败');
            });
        }

        /**
         * 显示修改联系电话模态框
         */
        function showEditPhoneModal() {
            var currentPhone = $('#phone').text().trim();
            $('#newPhone').val(currentPhone).removeClass('is-invalid');
            $('#newPhoneError').text('');
            $('#editPhoneModal').modal('show');
        }
    </script>
</body>
</html>
