<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>高校公寓管理系统 - 登录</title>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/tokens.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/login.css">
</head>
<body>
<div class="login-container">
    <h2>高校公寓管理系统</h2>
    <form id="loginForm">
        <div class="form-group">
            <label for="username">用户名</label>
            <input type="text" id="username" name="username" placeholder="请输入用户名" required>
        </div>
        <div class="form-group">
            <label for="password">密码</label>
            <input type="password" id="password" name="password" placeholder="请输入密码" required>
        </div>
        <div class="form-group">
            <button type="submit">登录</button>
        </div>
        <div id="errorMsg" class="error-msg"></div>
    </form>
</div>

<script src="${pageContext.request.contextPath}/static/js/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/static/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/common.js"></script>
<script>
    $(function () {
        // 角色跳转路径映射
        var rolePathMap = {
            1: '/admin/index',
            2: '/dorm/index',
            3: '/student/index'
        };

        $('#loginForm').submit(function (e) {
            e.preventDefault();
            var username = $('#username').val().trim();
            var password = $('#password').val().trim();

            if (!username || !password) {
                $('#errorMsg').text('用户名和密码不能为空');
                return;
            }

            // 登录接口使用$.ajax直接调用，不走$.ajaxRequest的401统一拦截
            // 原因：登录失败返回401，应显示具体错误信息，而非跳转登录页
            $.ajax({
                url: $.buildUrl('/login'),
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({username: username, password: password}),
                dataType: 'json',
                timeout: 30000,
                success: function (result) {
                    if (result.code === 200) {
                        var roleType = result.data.roleType;
                        var targetUrl = rolePathMap[roleType] || '/login';
                        window.location.href = $.buildUrl(targetUrl);
                    } else {
                        $('#errorMsg').text(result.msg || '登录失败');
                    }
                },
                error: function (xhr) {
                    if (xhr.status === 401) {
                        try {
                            var result = JSON.parse(xhr.responseText);
                            $('#errorMsg').text(result.msg || '用户名或密码错误');
                        } catch (e) {
                            $('#errorMsg').text('用户名或密码错误');
                        }
                    } else {
                        $('#errorMsg').text('登录失败，请稍后重试');
                    }
                }
            });
        });
    });
</script>
</body>
</html>
