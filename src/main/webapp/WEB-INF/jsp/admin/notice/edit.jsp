<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title id="pageTitle">新增公告 - 高校公寓管理系统</title>
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/static/images/favicon.svg">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/vendor/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/tokens.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/vendor/simplemde/simplemde.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/simplemde-theme.css">
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
                    <h1 id="formTitle">新增公告</h1>
                    <p class="page-meta" id="formMeta">发布系统公告通知</p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/notice/list" class="btn btn-secondary">返回列表</a>
            </div>

            <div class="form-container">
                <form id="noticeForm" novalidate>
                    <input type="hidden" id="noticeId" name="noticeId" value="">

                    <div class="form-grid">
                        <div class="form-field full">
                            <label>标题 <span class="required">*</span></label>
                            <input type="text" class="form-control" id="title" name="title" placeholder="请输入公告标题" maxlength="100">
                        </div>

                        <div class="form-field">
                            <label>类型 <span class="required">*</span></label>
                            <div class="cselect" id="noticeTypeCselect">
                                <div class="cselect-trigger" tabindex="0">
                                    <span class="cselect-val cselect-placeholder">请选择类型</span>
                                    <svg class="cselect-arrow"><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-chevron-down"/></svg>
                                </div>
                                <div class="cselect-panel" role="listbox">
                                    <div class="cselect-option" data-value="1">通知</div>
                                    <div class="cselect-option" data-value="2">维修</div>
                                    <div class="cselect-option" data-value="3">活动</div>
                                    <div class="cselect-option" data-value="4">紧急</div>
                                </div>
                            </div>
                        </div>

                        <div class="form-field">
                            <label>可见范围 <span class="required">*</span></label>
                            <div class="cselect" id="scopeCselect">
                                <div class="cselect-trigger" tabindex="0">
                                    <span class="cselect-val cselect-placeholder">请选择范围</span>
                                    <svg class="cselect-arrow"><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-chevron-down"/></svg>
                                </div>
                                <div class="cselect-panel" role="listbox">
                                    <div class="cselect-option" data-value="1">全部可见</div>
                                    <div class="cselect-option" data-value="2">按楼栋可见</div>
                                </div>
                            </div>
                        </div>

                        <div class="form-field" id="buildingField" style="display:none;">
                            <label>目标楼栋</label>
                            <div class="cselect" id="buildingCselect">
                                <div class="cselect-trigger" tabindex="0">
                                    <span class="cselect-val cselect-placeholder">请选择楼栋</span>
                                    <svg class="cselect-arrow"><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-chevron-down"/></svg>
                                </div>
                                <div class="cselect-panel" role="listbox" id="buildingOptions"></div>
                            </div>
                        </div>

                        <div class="form-field full">
                            <label>内容 <span class="required">*</span></label>
                            <textarea id="noticeContent" name="content" rows="12"></textarea>
                        </div>

                        <div class="form-field">
                            <label>轮播设置</label>
                            <div style="display:flex;align-items:center;gap:var(--gap-sm);padding-top:4px;">
                                <label class="toggle">
                                    <input type="checkbox" id="isBanner" name="isBanner" value="1">
                                    <span class="toggle-slider"></span>
                                </label>
                                <span style="font-size:var(--fs-body);">上轮播展示</span>
                            </div>
                        </div>

                        <div class="form-field" id="bannerImageField">
                            <label>轮播图片（JPG/PNG，≤1MB）</label>
                            <div style="display:flex;align-items:center;gap:var(--gap-sm);padding-top:4px;">
                                <input type="file" id="bannerImage" name="bannerImage" accept=".jpg,.jpeg,.png" style="display:none;">
                                <label for="bannerImage" class="btn btn-ghost btn-sm" style="cursor:pointer;margin:0;">
                                    <svg width="14" height="14" style="margin-right:4px;"><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-upload"/></svg>
                                    <span id="bannerFileName">选择图片</span>
                                </label>
                            </div>
                            <div id="existingBanner" style="margin-top:var(--gap-xs);display:none;"></div>
                        </div>

                        <div class="form-field" id="bannerDaysField" style="display:none;">
                            <label>展示天数</label>
                            <input type="number" class="form-control" id="bannerDays" name="bannerDays" value="7" min="1" max="365">
                        </div>
                    </div>

                    <div style="margin-top: var(--gap-lg); display: flex; gap: var(--gap-sm);">
                        <button type="submit" class="btn btn-primary" id="btnSubmit">保存</button>
                        <a href="${pageContext.request.contextPath}/admin/notice/list" class="btn btn-secondary">取消</a>
                    </div>
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
<script src="${pageContext.request.contextPath}/static/vendor/simplemde/simplemde.min.js"></script>

<script>
(function() {
    'use strict';
    var editor = null;
    var isEdit = false;
    var noticeId = getUrlParam('noticeId');

    // 初始化编辑器
    function initEditor(textareaId) {
        return new SimpleMDE({
            element: document.getElementById(textareaId),
            spellChecker: false,
            status: false,
            toolbar: ['bold', 'italic', 'heading', '|', 'quote', 'unordered-list', 'ordered-list', '|', 'link', 'image', '|', 'preview', '|', 'guide'],
            renderingConfig: { codeSyntaxHighlighting: false }
        });
    }

    // 获取 URL 参数
    function getUrlParam(name) {
        var m = window.location.search.match(new RegExp('[?&]' + name + '=([^&]*)'));
        return m ? decodeURIComponent(m[1]) : null;
    }

    // 加载楼栋列表
    function loadBuildings(selectedId) {
        $.ajaxRequest('/common/building/list', 'GET', null, function(result) {
            var buildings = result.data || [];
            var opts = '';
            for (var i = 0; i < buildings.length; i++) {
                var b = buildings[i];
                opts += '<div class="cselect-option" data-value="' + b.buildingId + '">' + b.buildingName + '</div>';
            }
            $('#buildingOptions').html(opts);
            $.initCustomSelect();
            if (selectedId) $('#buildingCselect').data('value', selectedId);
        });
    }

    // 显示/隐藏楼栋选择
    function updateBuildingField() {
        var scope = $('#scopeCselect').data('value');
        $('#buildingField').toggle(scope == '2');
    }

    function updateBannerFields() {
        var checked = $('#isBanner').is(':checked');
        $('#bannerDaysField').toggle(checked);
    }

    // 加载已有数据（编辑模式）
    function loadNotice(id) {
        $.ajaxRequest('/common/notice/' + id, 'GET', null, function(result) {
            var d = result.data;
            if (!d) return;
            $('#noticeId').val(d.noticeId);
            $('#title').val(d.title);
            editor.value(d.content || '');
            $('#noticeTypeCselect').data('value', d.noticeType);
            $('#scopeCselect').data('value', d.visibleScope);
            $('#isBanner').prop('checked', d.isBanner === 1);
            if (d.bannerDays) $('#bannerDays').val(d.bannerDays);
            // 有现有图片时显示
            if (d.bannerImage) {
                var imgUrl = $.buildUrl(d.bannerImage);
                $('#existingBanner').html('<img src="' + imgUrl + '" style="max-width:200px;max-height:100px;border-radius:var(--radius);border:1px solid var(--border);"> <span style="font-size:var(--fs-sm);color:var(--muted);margin-left:var(--gap-sm);">当前图片</span>').show();
            }
            updateBannerFields();
            // 编辑模式
            if (d.visibleScope == 2 && d.buildingId) loadBuildings(d.buildingId);
            else loadBuildings(null);
            updateBuildingField();
            $('#pageTitle').text('编辑公告 - 高校公寓管理系统');
            $('#formTitle').text('编辑公告');
            $('#formMeta').text('修改公告内容');
        });
    }

    // 表单提交
    $('#noticeForm').on('submit', function(e) {
        e.preventDefault();

        var title = $('#title').val().trim();
        var content = editor.value().trim();
        var noticeType = $('#noticeTypeCselect').data('value');
        var visibleScope = $('#scopeCselect').data('value');
        var buildingId = $('#buildingCselect').data('value');
        var isBannerVal = $('#isBanner').is(':checked') ? 1 : 0;
        var bannerDays = parseInt($('#bannerDays').val(), 10) || 7;
        var nid = $('#noticeId').val();

        // 校验
        if (!title) { $.toast('warning', '标题不能为空'); return; }
        if (!content) { $.toast('warning', '内容不能为空'); return; }
        if (!noticeType) { $.toast('warning', '请选择公告类型'); return; }
        if (!visibleScope) { $.toast('warning', '请选择可见范围'); return; }
        if (visibleScope == 2 && !buildingId) { $.toast('warning', '请选择目标楼栋'); return; }

        var $btn = $('#btnSubmit');
        $btn.prop('disabled', true).text('提交中...');

        var formData = new FormData();
        formData.append('title', title);
        formData.append('content', content);
        formData.append('noticeType', noticeType);
        formData.append('visibleScope', visibleScope);
        if (visibleScope == 2 && buildingId) formData.append('buildingId', buildingId);
        formData.append('isBanner', isBannerVal);
        formData.append('bannerDays', bannerDays);
        if (nid) formData.append('noticeId', nid);
        var fileInput = $('#bannerImage')[0];
        if (isBannerVal && fileInput && fileInput.files.length > 0) {
            var file = fileInput.files[0];
            if (file.size > 1024 * 1024) {
                $.toast('warning', '轮播图片大小不能超过 1MB');
                $btn.prop('disabled', false).text('保存');
                return;
            }
            formData.append('bannerImage', file);
        }

        var url = nid ? '/admin/notice/update' : '/admin/notice/add';

        $.ajax({
            url: $.buildUrl(url),
            type: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function(result) {
                if (result.code === 200) {
                    $.toast('success', nid ? '更新成功' : '发布成功');
                    setTimeout(function() { window.location.href = $.buildUrl('/admin/notice/list'); }, 800);
                } else {
                    $.toast('error', result.msg || '操作失败');
                    $btn.prop('disabled', false).text('保存');
                }
            },
            error: function() {
                $.toast('error', '请求失败');
                $btn.prop('disabled', false).text('保存');
            }
        });
    });

    // 文件选择后更新按钮文案
    $('#bannerImage').on('change', function() {
        var name = this.files.length > 0 ? this.files[0].name : '选择图片';
        $('#bannerFileName').text(name.length > 18 ? name.substring(0, 15) + '...' : name);
    });

    // 事件绑定
    $('#scopeCselect').on('cselect:change', updateBuildingField);
    $('#isBanner').on('change', updateBannerFields);

    // 初始化
    $(function() {
        editor = initEditor('noticeContent');
        if (noticeId) {
            isEdit = true;
            loadNotice(noticeId);
        } else {
            loadBuildings(null);
        }
    });

})();
</script>
</body>
</html>
