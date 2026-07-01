<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>500 - 高校公寓管理系统</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/tokens.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/error.css">
</head>
<body>
<div class="error-container">
    <div class="error-code">500</div>
    <h1>服务器错误</h1>
    <p class="error-message">抱歉，服务器出现了错误，请稍后再试</p>
    <div class="error-actions">
        <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">重试登录</a>
        <a href="javascript:history.back()" class="btn btn-secondary">返回上一页</a>
    </div>
</div>
</body>
</html>
