<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>公告列表 - 高校公寓管理系统</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/vendor/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/tokens.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/common.css">
</head>
<c:set var="isStudent" value="${sessionScope.loginUser.roleType == 3}" />
<body<c:if test="${isStudent}"> class="student-layout"</c:if>>
<div class="main-container">
    <%@ include file="/WEB-INF/jsp/common/sidebar.jsp" %>
    <div class="content-wrapper">
        <%@ include file="/WEB-INF/jsp/common/header.jsp" %>
        <c:if test="${isStudent}">
            <%@ include file="/WEB-INF/jsp/common/student_tabs.jsp" %>
        </c:if>
        <div class="content-body">
            <div class="page-header">
                <div>
                    <span class="page-eyebrow">NOTICE CENTER</span>
                    <h1>公告通知</h1>
                    <p class="page-meta">查看最新发布的公告与通知</p>
                </div>
            </div>

            <div id="noticeCardList"></div>
            <div class="empty-state" id="noticeEmpty" style="display:none;">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg>
                <div class="empty-state-title">暂无公告通知</div>
            </div>
            <div id="paginationContainer"></div>
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
(function() {
    'use strict';
    var pageQueryParams = { pageNum: 1, pageSize: 10 };
    var TYPE_MAP = { 1: '通知', 2: '维修', 3: '活动', 4: '紧急' };
    var ctx = '${pageContext.request.contextPath}';

    $(function() { loadData(pageQueryParams); });

    function loadData(params) {
        $.ajaxRequest('/common/notice/visible', 'GET', params, function(result) {
            if (result.data) {
                renderCards(result.data.list);
                $.renderPagination(result.data, 'paginationContainer', function(page) {
                    pageQueryParams.pageNum = page;
                    loadData(pageQueryParams);
                });
                pageQueryParams.pageNum = result.data.pageNum;
                pageQueryParams.pageSize = result.data.pageSize;
            }
        }, function() {
            $('#noticeCardList').html('<div class="empty-state"><div class="empty-state-title">加载失败</div><div class="empty-state-desc"><a href="javascript:void(0)" onclick="loadData(pageQueryParams)" style="color:var(--accent)">点击重试</a></div></div>');
        });
    }

    function getSummary(markdown, maxLen) {
        if (!markdown) return '';
        var text = markdown.replace(/^[#]{1,6}\s+/gm, '').replace(/\*{1,3}(.+?)\*{1,3}/g, '$1').replace(/\[([^\]]+)\]\([^)]+\)/g, '$1').replace(/`{1,3}[^`]*`{1,3}/g, '').replace(/>\s+/g, '').replace(/\n+/g, ' ').trim();
        return text.length > maxLen ? text.substring(0, maxLen) + '...' : text;
    }

    function renderCards(list) {
        var $area = $('#noticeCardList');
        var $empty = $('#noticeEmpty');
        if (!list || list.length === 0) { $area.empty(); $empty.show(); return; }
        $empty.hide();

        var html = '';
        for (var i = 0; i < list.length; i++) {
            var n = list[i];
            var typeName = TYPE_MAP[n.noticeType] || '通知';
            var summary = getSummary(n.content, 80);
            var time = (n.publishTime || '').substring(0, 10);
            var safeTitle = $('<span>').text(n.title).html();
            var safeSummary = $('<span>').text(summary).html();

            html += '<a href="' + ctx + '/common/notice/detailPage?noticeId=' + n.noticeId + '" class="notice-card" style="display:flex;background:var(--surface);border:1px solid var(--border);border-radius:var(--radius-lg);margin-bottom:var(--gap-md);overflow:hidden;text-decoration:none;color:var(--fg);transition:border-color 0.12s,box-shadow 0.2s;">';
            html += '<div class="notice-card-stripe" style="width:4px;flex-shrink:0;background:' + getTypeColor(n.noticeType) + ';"></div>';
            html += '<div style="flex:1;padding:var(--gap-md) var(--gap-lg);">';
            html += '<div style="display:flex;align-items:center;gap:var(--gap-sm);margin-bottom:var(--gap-xs);">';
            html += '<span class="pill pill-pending" style="font-size:11px;">' + typeName + '</span>';
            if (n.isTop === 1) html += '<span class="pill pill-danger" style="font-size:11px;">置顶</span>';
            html += '<span style="font-family:var(--font-mono);font-size:var(--fs-sm);color:var(--muted);margin-left:auto;">' + time + '</span>';
            html += '</div>';
            html += '<div style="font-family:var(--font-display);font-size:var(--fs-h3);font-weight:600;margin-bottom:var(--gap-xs);">' + safeTitle + '</div>';
            html += '<div style="font-size:var(--fs-meta);color:var(--muted);line-height:1.5;">' + safeSummary + '</div>';
            html += '</div>';
            html += '</a>';
        }
        $area.html(html);
    }

    function getTypeColor(type) {
        var colors = { 1: 'rgb(212, 132, 90)', 2: 'rgb(196, 69, 58)', 3: 'rgb(46, 125, 111)', 4: 'rgb(139, 48, 40)' };
        return colors[type] || 'rgb(122, 112, 103)';
    }

})();
</script>
</body>
</html>
