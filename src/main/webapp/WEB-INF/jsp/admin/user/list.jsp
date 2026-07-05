<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户管理 - 高校公寓管理系统</title>
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
                <!-- 页面头部 -->
                <div class="page-header">
                    <div>
                        <span class="page-eyebrow">USER MANAGEMENT</span>
                        <h1>用户管理</h1>
                        <p class="page-meta">管理系统用户账号 · 角色分配 · 状态控制</p>
                    </div>
                    <div class="d-flex gap-2">
                        <button type="button" class="btn btn-secondary" onclick="showImportModal()">
                            <svg width="16" height="16"><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-download"/></svg>
                            批量导入
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/user/addPage" class="btn btn-primary">
                            <svg width="16" height="16"><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-plus"/></svg>
                            新增用户
                        </a>
                    </div>
                </div>

                <!-- 筛选区 -->
                <div class="filter-bar">
                    <div class="filter-field">
                        <label>账号 / 姓名</label>
                        <input type="text" id="searchUsername" placeholder="输入用户名或姓名搜索">
                    </div>
                    <div class="filter-field">
                        <label>角色</label>
                        <div class="cselect" data-name="searchRoleType">
                            <div class="cselect-trigger"><span class="cselect-val cselect-placeholder">全部角色</span><svg class="cselect-arrow" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 12 15 18 9"/></svg></div>
                            <div class="cselect-panel">
                                <button class="cselect-option selected" data-value="">全部角色</button>
                                <button class="cselect-option" data-value="1">管理员</button>
                                <button class="cselect-option" data-value="2">宿管</button>
                                <button class="cselect-option" data-value="3">学生</button>
                            </div>
                        </div>
                    </div>
                    <div class="filter-field">
                        <label>状态</label>
                        <div class="cselect" data-name="searchStatus">
                            <div class="cselect-trigger"><span class="cselect-val cselect-placeholder">全部状态</span><svg class="cselect-arrow" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 12 15 18 9"/></svg></div>
                            <div class="cselect-panel">
                                <button class="cselect-option selected" data-value="">全部状态</button>
                                <button class="cselect-option" data-value="1">正常</button>
                                <button class="cselect-option" data-value="0">禁用</button>
                            </div>
                        </div>
                    </div>
                    <div class="filter-actions">
                        <button type="button" class="btn btn-secondary btn-sm" onclick="search()">
                            <svg width="14" height="14"><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-search"/></svg>
                            查询
                        </button>
                        <button type="button" class="btn btn-ghost btn-sm" onclick="resetSearch()">重置</button>
                    </div>
                </div>

                <!-- 数据表格 -->
                <div class="data-panel">
                    <table>
                        <thead>
                            <tr>
                                <th style="width: 62px;">序号</th>
                                <th>用户名</th>
                                <th>姓名</th>
                                <th>角色</th>
                                <th>性别</th>
                                <th>联系电话</th>
                                <th>状态</th>
                                <th>注册时间</th>
                                <th class="col-actions">操作</th>
                            </tr>
                        </thead>
                        <tbody id="userTableBody">
                            <tr>
                                <td colspan="9" class="text-center" style="padding: 40px 0; color: var(--muted);">
                                    <svg width="32" height="32" style="color: var(--border); margin-bottom: 8px; display: block; margin-left: auto; margin-right: auto;"><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-info"/></svg>
                                    加载中...
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <div id="paginationContainer"></div>
                </div>
            </div>

            <%@ include file="/WEB-INF/jsp/common/footer.jsp" %>
        </div>
    </div>

    <!-- 批量导入模态框 -->
    <div class="modal fade" id="importModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="modal-title">批量导入用户</h2>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">选择CSV文件</label>
                        <input type="file" class="form-control" id="importFile" accept=".csv">
                        <div class="form-text">
                            仅支持CSV格式文件，最大1MB。
                            <a href="${pageContext.request.contextPath}/static/template/用户导入模板.csv" class="btn btn-secondary btn-sm" download>
                                <svg width="14" height="14"><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-download"/></svg>
                                下载模板
                            </a>
                        </div>
                    </div>
                    <div id="importResult" style="display: none;">
                        <div class="alert" id="importResultAlert">
                            <div id="importResultMsg"></div>
                            <div id="importResultDetails" style="margin-top: 10px; max-height: 200px; overflow-y: auto;"></div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="btnImport" onclick="doImport()">
                        <svg width="16" height="16"><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-upload"/></svg>
                        开始导入
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/static/js/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/static/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/common.js"></script>
    <script>window.needChangePasswordFlag = '${sessionScope.needChangePassword}';</script>
    <script src="${pageContext.request.contextPath}/static/js/header.js"></script>

    <script>
        var pageQueryParams = { pageNum: 1, pageSize: 10 };

        $(function() {
            $.initCustomSelect();
            loadData(pageQueryParams);
        });

        function loadData(params) {
            var roleSelect = document.querySelector('.cselect[data-name="searchRoleType"]');
            var statusSelect = document.querySelector('.cselect[data-name="searchStatus"]');
            var queryParams = $.extend({}, params, {
                username: $('#searchUsername').val().trim(),
                realName: $('#searchUsername').val().trim(),
                roleType: roleSelect ? (roleSelect.dataset.value || '') : '',
                status: statusSelect ? (statusSelect.dataset.value || '') : ''
            });

            $.ajaxRequest('/admin/user/page', 'GET', queryParams, function(result) {
                if (result.data) {
                    renderUserTable(result.data.list);
                    $.renderPagination(result.data, 'paginationContainer', function(page) {
                        pageQueryParams.pageNum = page;
                        loadData(pageQueryParams);
                    });
                    pageQueryParams.pageNum = result.data.pageNum;
                    pageQueryParams.pageSize = result.data.pageSize;
                }
            }, function() {
                $('#userTableBody').html('<tr><td colspan="9" class="text-center" style="padding: 40px 0;"><a href="javascript:void(0)" onclick="loadData(pageQueryParams)" class="error-retry-link">加载失败，点击重试</a></td></tr>');
            });
        }

        function renderUserTable(userList) {
            var $tbody = $('#userTableBody');
            $tbody.empty();

            if (!userList || userList.length === 0) {
                $tbody.html('<tr><td colspan="9" class="text-center" style="padding: 40px 0; color: var(--muted);"><svg width="32" height="32" style="color: var(--border); margin: 0 auto 8px; display: block;"><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-inbox"/></svg>暂无数据</td></tr>');
                return;
            }

            var startIndex = (pageQueryParams.pageNum - 1) * pageQueryParams.pageSize;
            userList.forEach(function(user, index) {
                var roleText = getRoleText(user.roleType);
                var rolePill = getRolePill(user.roleType);
                var genderText = user.gender === 1 ? '男' : (user.gender === 2 ? '女' : '-');
                var toggleChecked = user.status === 1 ? ' checked' : '';
                var toggleHtml = '<label class="toggle"><input type="checkbox"' + toggleChecked + ' onchange="toggleStatus(' + user.userId + ', this.checked)"><span class="toggle-slider"></span></label>';

                var row = '<tr>';
                row += '<td class="num text-muted">' + (startIndex + index + 1) + '</td>';
                row += '<td class="num">' + (user.username || '-') + '</td>';
                row += '<td>' + (user.realName || '-') + '</td>';
                row += '<td><span class="pill ' + rolePill + '">' + roleText + '</span></td>';
                row += '<td>' + genderText + '</td>';
                row += '<td class="num">' + (user.phone ? user.phone.replace(/(\d{3})\d{4}(\d{4})/, '$1****$2') : '-') + '</td>';
                row += '<td>' + toggleHtml + '</td>';
                row += '<td class="num text-muted">' + $.formatDate(user.createTime, 'yyyy-MM-dd') + '</td>';
                row += '<td class="actions">';
                row += '<a href="${pageContext.request.contextPath}/admin/user/editPage?userId=' + user.userId + '" class="btn btn-ghost btn-sm">编辑</a>';
                row += '<button class="btn btn-ghost btn-sm" onclick="deleteUser(' + user.userId + ', \'' + ($('<span>').text(user.username || '').html()) + '\')">删除</button>';
                row += '</td>';
                row += '</tr>';
                $tbody.append(row);
            });
        }

        function search() {
            pageQueryParams.pageNum = 1;
            loadData(pageQueryParams);
        }

        function resetSearch() {
            $('#searchUsername').val('');
            // 重置自定义下拉框
            document.querySelectorAll('.filter-bar .cselect').forEach(function(cs) {
                cs.dataset.value = '';
                var valEl = cs.querySelector('.cselect-val');
                if (valEl) {
                    valEl.textContent = valEl.classList.contains('cselect-placeholder') ? valEl.textContent : '';
                    valEl.classList.add('cselect-placeholder');
                }
                cs.querySelectorAll('.cselect-option').forEach(function(o) { o.classList.remove('selected'); });
            });
            search();
        }

        function toggleStatus(userId, isChecked) {
            var actionText = isChecked ? '启用' : '禁用';
            $.confirm('确定要' + actionText + '该用户吗？', function() {
                $.ajaxRequest('/admin/user/toggleStatus/' + userId, 'POST', null, function() {
                    $.toast('success', actionText + '成功');
                    loadData(pageQueryParams);
                }, function(result) {
                    $.toast('error', result.msg || actionText + '失败');
                    loadData(pageQueryParams);
                });
            }, function() {
                // 取消时恢复 checkbox 状态
                loadData(pageQueryParams);
            });
        }

        function deleteUser(userId, username) {
            $.confirm('确认删除用户「' + username + '」？删除后数据不可恢复。', function() {
                $.ajaxRequest('/admin/user/delete/' + userId, 'POST', null, function() {
                    $.toast('success', '删除成功');
                    loadData(pageQueryParams);
                }, function(result) {
                    $.toast('error', result.msg || '删除失败');
                });
            });
        }

        function getRoleText(roleType) {
            return {1: '管理员', 2: '宿管', 3: '学生'}[roleType] || '-';
        }

        function getRolePill(roleType) {
            return {1: 'pill-admin', 2: 'pill-manager', 3: 'pill-student'}[roleType] || 'pill-quiet';
        }

        function showImportModal() {
            $('#importFile').val('');
            $('#importResult').hide();
            $('#importResultDetails').empty();
            $('#btnImport').prop('disabled', false).html('<svg width="16" height="16"><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-upload"/></svg>开始导入');
            $('#importModal').modal('show');
        }

        function doImport() {
            var fileInput = document.getElementById('importFile');
            var file = fileInput.files[0];
            if (!file) { $.toast('warning', '请选择要导入的文件'); return; }
            if (!file.name.toLowerCase().endsWith('.csv')) { $.toast('error', '仅支持CSV格式文件'); return; }
            if (file.size > 1048576) { $.toast('error', '文件大小不能超过1MB'); return; }

            $('#btnImport').prop('disabled', true).html('<svg class="spinner-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" width="16" height="16"><path d="M12 2v4M12 18v4M4.93 4.93l2.83 2.83M16.24 16.24l2.83 2.83M2 12h4M18 12h4M4.93 19.07l2.83-2.83M16.24 7.76l2.83-2.83"/></svg>导入中...');
            var formData = new FormData();
            formData.append('file', file);

            $.ajax({
                url: $.buildUrl('/admin/user/import'),
                type: 'POST',
                data: formData,
                processData: false,
                contentType: false,
                dataType: 'json',
                timeout: 60000,
                success: function(result) {
                    if (result.code === 200) {
                        showImportResult(result.data);
                        loadData(pageQueryParams);
                    } else if (result.code === 401) {
                        window.location.href = $.buildUrl('/login');
                    } else {
                        $.toast('error', result.msg || '导入失败');
                    }
                    $('#btnImport').prop('disabled', false).html('<svg width="16" height="16"><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-upload"/></svg>开始导入');
                },
                error: function(xhr, status, error) {
                    $.toast('error', '请求失败：' + error);
                    $('#btnImport').prop('disabled', false).html('<svg width="16" height="16"><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-upload"/></svg>开始导入');
                }
            });
        }

        function showImportResult(data) {
            var $result = $('#importResult');
            var $alert = $('#importResultAlert');
            var $msg = $('#importResultMsg');
            var $details = $('#importResultDetails');
            $details.empty();

            if (data.failCount === 0) {
                $alert.attr('class', 'alert alert-success');
                $msg.html('导入成功！共导入 <strong>' + data.successCount + '</strong> 条记录。');
            } else {
                $alert.attr('class', 'alert alert-warning');
                $msg.html('导入完成！成功 <strong>' + data.successCount + '</strong> 条，失败 <strong>' + data.failCount + '</strong> 条。');
                if (data.failDetails && data.failDetails.length > 0) {
                    var detailHtml = '<ul class="mb-0" style="padding-left: 20px;">';
                    data.failDetails.forEach(function(detail) {
                        detailHtml += '<li>第' + detail.row + '行：' + detail.reason + '</li>';
                    });
                    detailHtml += '</ul>';
                    $details.html(detailHtml);
                }
            }
            $result.show();
        }
    </script>
</body>
</html>
