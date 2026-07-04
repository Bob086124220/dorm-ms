<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>404 - 高校公寓管理系统</title>
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/static/images/favicon.svg">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/tokens.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/error.css">
</head>
<body>
<div class="error-container">
    <div class="error-code">404</div>
    <h1>页面未找到</h1>
    <p class="error-message">抱歉，您访问的页面不存在或已被移除</p>
    <div class="error-actions">
        <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">返回登录</a>
        <a href="javascript:history.back()" class="btn btn-secondary">返回上一页</a>
    </div>
</div>
</body>
</html>
