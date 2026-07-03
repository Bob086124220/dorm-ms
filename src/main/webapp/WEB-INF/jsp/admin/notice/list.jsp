<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>公告管理 - 高校公寓管理系统</title>
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
                    <span class="page-eyebrow">NOTICE MANAGEMENT</span>
                    <h1>公告管理</h1>
                    <p class="page-meta">发布与管理系统公告通知</p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/notice/editPage" class="btn btn-primary">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" width="16" height="16"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
                    新增公告
                </a>
            </div>

            <div class="filter-bar">
                <div class="filter-field">
                    <label>标题</label>
                    <input type="text" id="searchTitle" placeholder="输入标题搜索">
                </div>
                <div class="filter-field">
                    <label>类型</label>
                    <div class="cselect" id="noticeTypeCselect">
                        <div class="cselect-trigger" tabindex="0">
                            <span class="cselect-val cselect-placeholder">全部类型</span>
                            <svg class="cselect-arrow" viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="1.6" fill="none" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 12 15 18 9"/></svg>
                        </div>
                        <div class="cselect-panel" role="listbox">
                            <div class="cselect-option" data-value="">全部类型</div>
                            <div class="cselect-option" data-value="1">通知</div>
                            <div class="cselect-option" data-value="2">维修</div>
                            <div class="cselect-option" data-value="3">活动</div>
                            <div class="cselect-option" data-value="4">紧急</div>
                        </div>
                    </div>
                </div>
                <div class="filter-actions">
                    <button type="button" class="btn btn-secondary btn-sm" onclick="search()">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" width="14" height="14"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                        查询
                    </button>
                    <button type="button" class="btn btn-ghost btn-sm" onclick="resetSearch()">重置</button>
                </div>
            </div>

            <div class="data-panel">
                <table>
                    <thead><tr>
                        <th>标题</th><th>类型</th><th>范围</th><th>状态</th><th>置顶</th><th>轮播</th><th>发布时间</th><th>操作</th>
                    </tr></thead>
                    <tbody id="tableBody">
                        <tr><td colspan="8" style="padding:40px 0;text-align:center;color:var(--muted);">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" width="32" height="32" style="color:var(--border);margin:0 auto 8px;display:block;"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                            加载中...</td></tr>
                    </tbody>
                </table>
                <div id="paginationContainer"></div>
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
var pageQueryParams = { pageNum: 1, pageSize: 10 };
var TYPE_MAP = { 1: '通知', 2: '维修', 3: '活动', 4: '紧急' };
var STATUS_MAP = { 0: '下架', 1: '发布' };

$(function() { loadData(pageQueryParams); });

function search() { pageQueryParams.pageNum = 1; loadData(pageQueryParams); }
function resetSearch() { $('#searchTitle').val(''); $('#noticeTypeCselect').data('value', ''); $('.cselect-placeholder').text('全部类型'); search(); }

function loadData(params) {
    var queryParams = $.extend({}, params, {
        title: $('#searchTitle').val().trim(),
        noticeType: $('#noticeTypeCselect').data('value') || undefined
    });
    $.ajaxRequest('/admin/notice/page', 'GET', queryParams, function(result) {
        if (result.data) {
            renderTable(result.data.list);
            $.renderPagination(result.data, 'paginationContainer', function(page) {
                pageQueryParams.pageNum = page;
                loadData(pageQueryParams);
            });
            pageQueryParams.pageNum = result.data.pageNum;
            pageQueryParams.pageSize = result.data.pageSize;
        }
    }, function() {
        $('#tableBody').html('<tr><td colspan="8" style="padding:40px 0;text-align:center;"><a href="javascript:void(0)" onclick="loadData(pageQueryParams)" class="error-retry-link">加载失败，点击重试</a></td></tr>');
    });
}

function renderTable(list) {
    var $tbody = $('#tableBody'); $tbody.empty();
    if (!list || list.length === 0) {
        $tbody.html('<tr><td colspan="8" style="padding:40px 0;text-align:center;color:var(--muted);"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" width="32" height="32" style="color:var(--border);margin:0 auto 8px;display:block;"><polyline points="22 12 16 12 14 15 10 15 8 12 2 12"/><path d="M5.45 5.11L2 12v6a2 2 0 002 2h16a2 2 0 002-2v-6l-3.45-6.89A2 2 0 0016.76 4H7.24a2 2 0 00-1.79 1.11z"/></svg>暂无数据</td></tr>');
        return;
    }
    var ctx = '${pageContext.request.contextPath}';
    list.forEach(function(item) {
        var type = TYPE_MAP[item.noticeType] || '通知';
        var status = item.status === 1;
        var top = item.isTop === 1;
        var banner = item.isBanner === 1;
        var scope = item.visibleScope === 2 ? (item.buildingName || '指定楼栋') : '全部';
        var time = (item.publishTime || '').substring(0, 10);
        var title = (item.title || '').length > 18 ? item.title.substring(0, 18) + '...' : (item.title || '');
        var safeTitle = $('<span>').text(item.title).html();

        var row = '<tr>';
        row += '<td title="' + safeTitle + '">' + $('<span>').text(title).html() + '</td>';
        row += '<td><span class="pill pill-pending">' + type + '</span></td>';
        row += '<td>' + scope + '</td>';
        row += '<td><span class="pill ' + (status ? 'pill-done' : 'pill-quiet') + '">' + (status ? '发布' : '下架') + '</span></td>';
        row += '<td><span class="pill ' + (top ? 'pill-pending' : 'pill-quiet') + '">' + (top ? '置顶' : '否') + '</span></td>';
        row += '<td><span class="pill ' + (banner ? 'pill-pending' : 'pill-quiet') + '">' + (banner ? '轮播' : '否') + '</span></td>';
        row += '<td class="num">' + time + '</td>';
        row += '<td class="actions">';
        row += '<a href="' + ctx + '/admin/notice/editPage?noticeId=' + item.noticeId + '" class="btn btn-ghost btn-sm">编辑</a>';
        row += '<button class="btn btn-ghost btn-sm" onclick="toggleTop(' + item.noticeId + ')">' + (top ? '取消置顶' : '置顶') + '</button>';
        row += '<button class="btn btn-ghost btn-sm" onclick="toggleStatus(' + item.noticeId + ', ' + item.status + ')">' + (status ? '下架' : '发布') + '</button>';
        if (banner) row += '<button class="btn btn-ghost btn-sm" onclick="unbanner(' + item.noticeId + ')">下轮播</button>';
        row += '</td></tr>';
        $tbody.append(row);
    });
}

function toggleTop(id) { $.confirm('确定切换置顶状态吗？', function() { $.ajaxRequest('/admin/notice/toggleTop/' + id, 'POST', null, function() { $.toast('success', '操作成功'); loadData(pageQueryParams); }); }); }
function toggleStatus(id, cur) { var msg = cur === 1 ? '确定下架该公告吗？' : '确定发布该公告吗？'; $.confirm(msg, function() { $.ajaxRequest('/admin/notice/toggleStatus/' + id, 'POST', null, function() { $.toast('success', '操作成功'); loadData(pageQueryParams); }); }); }
function unbanner(id) { $.confirm('确定取消轮播展示吗？', function() { $.ajaxRequest('/admin/notice/unbanner/' + id, 'POST', null, function() { $.toast('success', '已取消轮播'); loadData(pageQueryParams); }); }); }
</script>
</body>
</html>
