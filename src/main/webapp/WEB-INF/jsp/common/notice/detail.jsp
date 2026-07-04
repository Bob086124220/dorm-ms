<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>公告详情 - 高校公寓管理系统</title>
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/static/images/favicon.svg">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/tokens.css">
    <style>
        :root {
            --notice-bg: rgb(250, 249, 245);
            --notice-surface: rgba(255, 255, 255, 0.92);
            --notice-surface-opaque: rgb(255, 255, 255);
            --notice-fg: rgb(45, 36, 28);
            --notice-muted: rgb(122, 112, 103);
            --notice-border: rgb(235, 230, 223);
            --notice-hover-bg: rgb(245, 244, 237);
            --notice-accent: rgb(196, 69, 58);
            --type-1: rgb(212, 132, 90);
            --type-2: rgb(196, 69, 58);
            --type-3: rgb(46, 125, 111);
            --type-4: color-mix(in oklch, rgb(196, 69, 58) 80%, black);
            --ease: cubic-bezier(0.22, 1, 0.36, 1);
        }
        *,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
        html{scroll-behavior:smooth}
        body{
            font-family:var(--font-body);font-size:var(--fs-body);line-height:1.6;
            color:var(--notice-fg);background:
                radial-gradient(circle,rgb(237,234,229) 0.8px,transparent 0.8px),var(--notice-bg);
            background-size:16px 16px;min-height:100vh;display:flex;flex-direction:column;
            -webkit-font-smoothing:antialiased;
        }
        .topbar{position:sticky;top:0;z-index:100;background:var(--notice-surface-opaque);border-bottom:1px solid var(--notice-border);height:56px;display:flex;align-items:center;padding:0 var(--gap-lg);animation:fadeIn 0.3s var(--ease) both}
        .topbar-left{display:flex;align-items:center;gap:var(--gap-md)}
        .topbar-back{display:inline-flex;align-items:center;gap:6px;padding:6px 12px;font-family:var(--font-mono);font-size:var(--fs-sm);letter-spacing:0.02em;color:var(--notice-muted);text-decoration:none;border:1px solid var(--notice-border);border-radius:var(--radius);background:transparent;cursor:pointer;transition:color 0.12s,border-color 0.12s}
        .topbar-back:hover{color:var(--notice-accent);border-color:var(--notice-accent)}
        .topbar-back svg{width:16px;height:16px}
        .topbar-title{font-family:var(--font-body);font-size:var(--fs-meta);color:var(--notice-muted)}
        .detail-page{flex:1;max-width:860px;width:100%;margin:0 auto;padding:var(--gap-xl) var(--gap-lg)}
        .notice-eyebrow{display:flex;align-items:center;gap:var(--gap-sm);margin-bottom:var(--gap-sm);animation:fadeUp 0.3s var(--ease) 0.1s both}
        .notice-type-badge{display:inline-flex;align-items:center;gap:5px;padding:3px 10px;font-family:var(--font-mono);font-size:var(--fs-sm);font-weight:500;letter-spacing:0.06em;text-transform:uppercase;color:#fff;border-radius:4px}
        .notice-type-badge[data-type="1"]{background:var(--type-1)}
        .notice-type-badge[data-type="2"]{background:var(--type-2)}
        .notice-type-badge[data-type="3"]{background:var(--type-3)}
        .notice-type-badge[data-type="4"]{background:var(--type-4)}
        .notice-type-badge svg{width:12px;height:12px}
        .notice-eyebrow-date{font-family:var(--font-mono);font-size:var(--fs-sm);letter-spacing:0.02em;color:var(--notice-muted)}
        .notice-eyebrow-scope{margin-left:auto;font-family:var(--font-mono);font-size:var(--fs-sm);letter-spacing:0.04em;text-transform:uppercase;color:var(--notice-muted);opacity:0.6}
        .notice-title{font-family:var(--font-display);font-size:var(--fs-h1);font-weight:700;line-height:1.15;letter-spacing:-0.01em;color:var(--notice-fg);margin-bottom:var(--gap-md);animation:fadeUp 0.3s var(--ease) 0.15s both}
        .notice-meta{display:flex;align-items:center;gap:var(--gap-lg);padding:var(--gap-md) 0;border-top:1px solid var(--notice-border);border-bottom:1px solid var(--notice-border);margin-bottom:var(--gap-xl);animation:fadeUp 0.3s var(--ease) 0.2s both}
        .meta-item{display:flex;align-items:center;gap:6px}
        .meta-item svg{width:14px;height:14px;stroke:var(--notice-muted);fill:none;stroke-width:2;stroke-linecap:round;stroke-linejoin:round}
        .meta-item-label{font-family:var(--font-mono);font-size:var(--fs-sm);letter-spacing:0.04em;text-transform:uppercase;color:var(--notice-muted)}
        .meta-item-value{font-family:var(--font-body);font-size:var(--fs-sm);color:var(--notice-fg)}
        .notice-banner{margin-bottom:var(--gap-xl);animation:fadeUp 0.3s var(--ease) 0.25s both}
        .notice-banner-img{width:100%;height:320px;object-fit:cover;border-radius:var(--radius-lg);display:block}
        .notice-banner-noimg{display:flex;height:220px;border-radius:var(--radius-lg);overflow:hidden;background:radial-gradient(circle,rgb(237,234,229) .8px,transparent .8px),var(--notice-bg);background-size:16px 16px}
        .banner-stripe{width:4px;flex-shrink:0}
        .banner-stripe[data-type="1"]{background:var(--type-1)}
        .banner-stripe[data-type="2"]{background:var(--type-2)}
        .banner-stripe[data-type="3"]{background:var(--type-3)}
        .banner-stripe[data-type="4"]{background:var(--type-4)}
        .banner-text{flex:1;display:flex;flex-direction:column;justify-content:center;padding:var(--gap-xl)}
        .banner-text h2{font-family:var(--font-display);font-size:var(--fs-h2);font-weight:700;color:var(--notice-fg);margin-bottom:var(--gap-sm)}
        .banner-text p{font-size:var(--fs-body);color:var(--notice-muted);max-width:50ch}
        .notice-content{position:relative;background:var(--notice-surface);border:1px solid var(--notice-border);border-radius:var(--radius-lg);padding:64px var(--gap-xl);margin-bottom:var(--gap-xl);animation:fadeUp 0.3s var(--ease) 0.3s both}
        .notice-content::after{content:attr(data-decorative-num);position:absolute;bottom:-16px;right:24px;font-family:var(--font-display);font-size:96px;font-weight:700;line-height:1;color:var(--notice-muted);opacity:0.04;pointer-events:none;user-select:none}
        .md-body h1,.md-body h2,.md-body h3{font-family:var(--font-display);font-weight:700;color:var(--notice-fg);margin-top:1.8em;margin-bottom:0.6em}
        .md-body h1{font-size:var(--fs-h1);letter-spacing:-0.01em}
        .md-body h2{font-size:var(--fs-h2);padding-bottom:var(--gap-sm);border-bottom:1px solid var(--notice-border)}
        .md-body h3{font-size:var(--fs-h3)}
        .md-body p{margin-bottom:1.2em;line-height:1.7;max-width:65ch}
        .md-body strong{font-weight:600}
        .md-body a{color:var(--notice-accent);text-decoration:none;border-bottom:1px solid transparent;transition:border-color 0.12s}
        .md-body a:hover{border-bottom-color:var(--notice-accent)}
        .md-body ul,.md-body ol{margin-bottom:1.2em;padding-left:1.6em}
        .md-body li{margin-bottom:0.4em;line-height:1.6}
        .md-body li::marker{color:var(--notice-accent)}
        .md-body blockquote{border-left:3px solid var(--notice-accent);padding-left:var(--gap-md);margin:1.5em 0;color:var(--notice-muted);font-style:italic;max-width:56ch}
        .md-body code{font-family:var(--font-mono);font-size:0.9em;background:var(--notice-hover-bg);padding:2px 6px;border-radius:4px;color:var(--notice-accent)}
        .md-body pre{background:var(--notice-fg);color:var(--notice-bg);border-radius:var(--radius);padding:var(--gap-md);margin:1.5em 0;overflow-x:auto;line-height:1.5}
        .md-body pre code{background:none;padding:0;color:inherit;font-size:var(--fs-sm)}
        .md-body table{width:100%;border-collapse:separate;border-spacing:0;margin:1.5em 0}
        .md-body th{font-family:var(--font-mono);font-size:var(--fs-sm);font-weight:500;letter-spacing:0.04em;text-transform:uppercase;color:var(--notice-muted);text-align:left;padding:10px 16px;border-bottom:2px solid var(--notice-fg)}
        .md-body td{padding:10px 16px;border-bottom:1px solid var(--notice-border)}
        .md-body img{max-width:100%;border-radius:var(--radius);margin:1em 0}
        .related-section{margin-bottom:var(--gap-xl);animation:fadeUp 0.3s var(--ease) 0.45s both}
        .related-heading{font-family:var(--font-mono);font-size:var(--fs-sm);font-weight:500;letter-spacing:0.08em;text-transform:uppercase;color:var(--notice-muted);margin-bottom:var(--gap-md);padding-bottom:var(--gap-sm);border-bottom:1px solid var(--notice-border)}
        .related-list{display:flex;flex-direction:column;gap:var(--gap-sm)}
        .related-item{display:flex;align-items:center;gap:var(--gap-md);padding:var(--gap-md);background:var(--notice-surface);border:1px solid var(--notice-border);border-radius:var(--radius);text-decoration:none;color:var(--notice-fg);transition:border-color 0.12s,box-shadow 0.2s}
        .related-item:hover{border-color:var(--notice-accent);box-shadow:0 2px 8px rgba(0,0,0,.04)}
        .related-item-stripe{width:4px;height:36px;border-radius:2px;flex-shrink:0}
        .related-item-stripe[data-type="1"]{background:var(--type-1)}
        .related-item-stripe[data-type="2"]{background:var(--type-2)}
        .related-item-stripe[data-type="3"]{background:var(--type-3)}
        .related-item-stripe[data-type="4"]{background:var(--type-4)}
        .related-item-body{flex:1;min-width:0}
        .related-item-title{font-family:var(--font-display);font-size:var(--fs-body);font-weight:600;line-height:1.3;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
        .related-item-date{font-family:var(--font-mono);font-size:var(--fs-sm);color:var(--notice-muted)}
        .related-item-arrow{color:var(--notice-muted);transition:color 0.12s,transform 0.12s;flex-shrink:0}
        .related-item:hover .related-item-arrow{color:var(--notice-accent);transform:translateX(3px)}
        .related-item-arrow svg{width:16px;height:16px}
        .app-footer{padding:var(--gap-lg);text-align:center;font-family:var(--font-mono);font-size:var(--fs-sm);color:var(--notice-muted);letter-spacing:0.02em;border-top:1px solid var(--notice-border);opacity:0.6;animation:fadeIn 0.3s var(--ease) 0.5s both}
        .scroll-top-btn{position:fixed;bottom:32px;right:32px;width:40px;height:40px;background:var(--notice-surface-opaque);border:1px solid var(--notice-border);border-radius:50%;display:flex;align-items:center;justify-content:center;cursor:pointer;opacity:0;transform:translateY(8px);transition:opacity 0.3s var(--ease),transform 0.3s var(--ease),border-color 0.12s;z-index:50}
        .scroll-top-btn.visible{opacity:1;transform:translateY(0)}
        .scroll-top-btn:hover{border-color:var(--notice-accent)}
        .scroll-top-btn svg{width:18px;height:18px;stroke:var(--notice-muted);fill:none;stroke-width:2;stroke-linecap:round;stroke-linejoin:round}
        .scroll-top-btn:hover svg{stroke:var(--notice-accent)}
        @keyframes fadeUp{from{opacity:0;transform:translateY(12px)}to{opacity:1;transform:translateY(0)}}
        @keyframes fadeIn{from{opacity:0}to{opacity:1}}
        @media(max-width:768px){
            .detail-page{padding:var(--gap-lg) var(--gap-md)}
            .notice-content{padding:var(--gap-xl) var(--gap-lg)}
            .notice-banner-img{height:220px}.notice-banner-noimg{height:160px}
            .notice-meta{flex-wrap:wrap;gap:var(--gap-sm) var(--gap-md)}
            .notice-eyebrow{flex-wrap:wrap}.notice-eyebrow-scope{margin-left:0;width:100%}
            .scroll-top-btn{bottom:20px;right:20px}
        }
        @media(prefers-reduced-motion:reduce){*,*::before,*::after{animation-duration:0.01ms!important;transition-duration:0.01ms!important}}
    </style>
</head>
<body>

<header class="topbar">
    <div class="topbar-left">
        <a href="${pageContext.request.contextPath}/common/notice/listPage" class="topbar-back">
            <svg viewBox="0 0 24 24"><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-arrow-left"/></svg>
            返回列表
        </a>
        <span class="topbar-title">公告通知</span>
    </div>
</header>

<main class="detail-page" id="detailPage">
    <div class="notice-eyebrow">
        <span class="notice-type-badge" id="typeBadge" data-type="1">
            <span id="typeName">通知</span>
        </span>
        <span class="notice-eyebrow-date" id="publishDate">--</span>
        <span class="notice-eyebrow-scope" id="scopeText">--</span>
    </div>
    <h1 class="notice-title" id="noticeTitle">--</h1>
    <div class="notice-meta">
        <div class="meta-item">
            <svg viewBox="0 0 24 24"><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-user"/></svg>
            <span class="meta-item-label">发布者</span>
            <span class="meta-item-value" id="publisher">--</span>
        </div>
        <div class="meta-item">
            <svg viewBox="0 0 24 24"><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-clock"/></svg>
            <span class="meta-item-label">发布时间</span>
            <span class="meta-item-value" id="publishTime">--</span>
        </div>
        <div class="meta-item">
            <svg viewBox="0 0 24 24"><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-map-pin"/></svg>
            <span class="meta-item-label">适用楼栋</span>
            <span class="meta-item-value" id="buildingScope">--</span>
        </div>
    </div>

    <div class="notice-banner" id="bannerArea"></div>

    <article class="notice-content" data-decorative-num="00">
        <div class="md-body" id="markdownBody"></div>
    </article>

    <section class="related-section">
        <div class="related-heading">其他公告</div>
        <div class="related-list" id="relatedList"></div>
    </section>
</main>

<footer class="app-footer">
    高校公寓管理系统
</footer>

<button class="scroll-top-btn" id="scrollTopBtn" aria-label="返回顶部">
    <svg viewBox="0 0 24 24"><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-chevron-up"/></svg>
</button>

<script src="${pageContext.request.contextPath}/static/js/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/static/vendor/marked/marked.min.js"></script>
<script src="${pageContext.request.contextPath}/static/vendor/purify/purify.min.js"></script>

<script>
(function() {
    'use strict';
    var TYPE_MAP = { 1: '通知', 2: '维修', 3: '活动', 4: '紧急' };
    var ctx = '${pageContext.request.contextPath}';

    function getUrlParam(name) {
        var m = window.location.search.match(new RegExp('[?&]' + name + '=([^&]*)'));
        return m ? decodeURIComponent(m[1]) : null;
    }

    var noticeId = getUrlParam('noticeId');
    if (!noticeId) { alert('缺少公告ID'); window.location.href = ctx + '/common/notice/listPage'; }

    function escapeHtml(str) {
        var div = document.createElement('div');
        div.appendChild(document.createTextNode(str));
        return div.innerHTML;
    }

    function renderMarkdown(mdText) {
        if (typeof marked !== 'undefined' && typeof DOMPurify !== 'undefined') {
            var raw = marked.parse(mdText);
            return DOMPurify.sanitize(raw, { ADD_TAGS: ['input'], ADD_ATTR: ['type', 'checked', 'disabled'] });
        }
        return '<p>' + escapeHtml(mdText).replace(/\n/g, '</p><p>') + '</p>';
    }

    function formatDateDot(dtStr) {
        if (!dtStr) return '--';
        return dtStr.substring(0, 10).replace(/-/g, '.');
    }

    function getTypeColor(type) {
        var c = { 1: 'rgb(212, 132, 90)', 2: 'rgb(196, 69, 58)', 3: 'rgb(46, 125, 111)', 4: 'color-mix(in oklch, rgb(196, 69, 58) 80%, black)' };
        return c[type] || 'rgb(122, 112, 103)';
    }

    function renderNotice(d) {
        document.title = (d.title || '公告') + ' - 高校公寓管理系统';
        $('#noticeTitle').text(d.title || '');
        var typeName = TYPE_MAP[d.noticeType] || '通知';
        $('#typeBadge').attr('data-type', d.noticeType);
        $('#typeName').text(typeName);
        $('#publishDate').text(formatDateDot(d.publishTime));
        $('#publishTime').text((d.publishTime || '').substring(0, 16));
        $('#publisher').text(d.publisherName || '--');
        $('#buildingScope').text(d.visibleScope === 2 ? (d.buildingName || '指定楼栋') : '全部楼栋');
        $('#scopeText').text(d.visibleScope === 2 ? (d.buildingName || '指定楼栋') : '全部');
        $('#markdownBody').html(renderMarkdown(d.content || ''));
        $('.notice-content').attr('data-decorative-num', String(d.noticeId || '00').slice(-2));

        // Banner
        var $banner = $('#bannerArea');
        if (d.bannerImage) {
            $banner.html('<img src="' + ctx + d.bannerImage + '" alt="' + escapeHtml(d.title || '') + '" class="notice-banner-img">');
        } else {
            $banner.html('<div class="notice-banner-noimg"><div class="banner-stripe" data-type="' + d.noticeType + '"></div><div class="banner-text"><h2>' + escapeHtml(d.title || '') + '</h2><p>' + escapeHtml((d.content || '').substring(0, 100)) + '</p></div></div>');
        }
    }

    function renderRelated(items) {
        var $list = $('#relatedList');
        if (!items || items.length === 0) {
            $list.html('<p style="color:var(--notice-muted);font-size:var(--fs-sm);">暂无其他公告</p>');
            return;
        }
        var html = '';
        for (var i = 0; i < items.length; i++) {
            var n = items[i];
            html += '<a href="' + ctx + '/common/notice/detailPage?noticeId=' + n.noticeId + '" class="related-item">'
                + '<div class="related-item-stripe" data-type="' + n.noticeType + '"></div>'
                + '<div class="related-item-body">'
                + '<div class="related-item-title">' + escapeHtml(n.title || '') + '</div>'
                + '<div class="related-item-date">' + (n.publishTime || '').substring(0, 10) + '</div>'
                + '</div>'
                + '<div class="related-item-arrow"><svg><use href="' + ctx + '/static/images/icons.svg#icon-chevron-right"/></svg></div>'
                + '</a>';
        }
        $list.html(html);
    }

    // 加载数据
    if (noticeId) {
        $.get(ctx + '/common/notice/' + noticeId, function(result) {
            if (result.code === 200 && result.data) {
                renderNotice(result.data);
            }
        });

        // 相关公告（取前3条）
        $.get(ctx + '/common/notice/visible?pageNum=1&pageSize=4', function(result) {
            if (result.code === 200 && result.data) {
                var list = (result.data.list || []).filter(function(n) { return String(n.noticeId) !== String(noticeId); });
                renderRelated(list.slice(0, 3));
            }
        });
    }

    // 返回顶部按钮
    $(function() {
        var $btn = $('#scrollTopBtn');
        var ticking = false;
        $(window).on('scroll', function() {
            if (!ticking) {
                window.requestAnimationFrame(function() {
                    $btn.toggleClass('visible', $(window).scrollTop() > 300);
                    ticking = false;
                });
                ticking = true;
            }
        });
        $btn.on('click', function() { window.scrollTo({ top: 0, behavior: 'smooth' }); });
    });

})();
</script>
</body>
</html>
