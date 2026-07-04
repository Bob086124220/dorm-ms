<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>操作日志 - 高校公寓管理系统</title>
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
                        <span class="page-eyebrow">OPERATION LOG</span>
                        <h1>操作日志</h1>
                        <p class="page-meta">查看系统操作记录</p>
                    </div>
                </div>

                <div class="filter-bar">
                    <div class="filter-field">
                        <label>操作人ID</label>
                        <input type="text" id="searchOperatorId" placeholder="请输入操作人ID">
                    </div>
                    <div class="filter-field">
                        <label>操作模块</label>
                        <div class="cselect" id="searchModuleNameCselect">
                            <div class="cselect-trigger" tabindex="0" aria-haspopup="listbox" aria-expanded="false">
                                <span class="cselect-val cselect-placeholder">全部</span>
                                <svg class="cselect-arrow" viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="1.6" fill="none" stroke-linecap="round" stroke-linejoin="round">
                                    <polyline points="6 9 12 15 18 9"></polyline>
                                </svg>
                            </div>
                            <div class="cselect-panel" role="listbox">
                                <div class="cselect-option selected" data-value="">全部</div>
                                <div class="cselect-option" data-value="用户管理">用户管理</div>
                                <div class="cselect-option" data-value="楼栋管理">楼栋管理</div>
                                <div class="cselect-option" data-value="房间管理">房间管理</div>
                                <div class="cselect-option" data-value="床位管理">床位管理</div>
                                <div class="cselect-option" data-value="入住管理">入住管理</div>
                                <div class="cselect-option" data-value="调宿管理">调宿管理</div>
                                <div class="cselect-option" data-value="报修管理">报修管理</div>
                                <div class="cselect-option" data-value="晚归登记">晚归登记</div>
                                <div class="cselect-option" data-value="访客登记">访客登记</div>
                                <div class="cselect-option" data-value="用户认证">用户认证</div>
                                <div class="cselect-option" data-value="个人信息">个人信息</div>
                            </div>
                        </div>
                    </div>
                    <div class="filter-field">
                        <label>操作类型</label>
                        <div class="cselect" id="searchOperTypeCselect">
                            <div class="cselect-trigger" tabindex="0" aria-haspopup="listbox" aria-expanded="false">
                                <span class="cselect-val cselect-placeholder">全部</span>
                                <svg class="cselect-arrow" viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="1.6" fill="none" stroke-linecap="round" stroke-linejoin="round">
                                    <polyline points="6 9 12 15 18 9"></polyline>
                                </svg>
                            </div>
                            <div class="cselect-panel" role="listbox">
                                <div class="cselect-option selected" data-value="">全部</div>
                                <div class="cselect-option" data-value="新增">新增</div>
                                <div class="cselect-option" data-value="修改">修改</div>
                                <div class="cselect-option" data-value="删除">删除</div>
                                <div class="cselect-option" data-value="审批">审批</div>
                                <div class="cselect-option" data-value="登录">登录</div>
                                <div class="cselect-option" data-value="登出">登出</div>
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

                <div class="data-panel">
                    <table>
                        <thead>
                            <tr>
                                <th>操作人ID</th>
                                <th>操作模块</th>
                                <th>操作类型</th>
                                <th>操作描述</th>
                                <th>操作IP</th>
                                <th>请求参数</th>
                                <th>操作时间</th>
                            </tr>
                        </thead>
                        <tbody id="tableBody">
                            <tr><td colspan="7" class="text-center" style="padding: 40px 0; color: var(--muted);"><svg width="32" height="32" style="color: var(--border); margin: 0 auto 8px; display: block;"><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-info"/></svg>
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
        // 分页参数
        var pageQueryParams = {
            pageNum: 1,
            pageSize: 10
        };

        $(function() {
            $.initCustomSelect();
            loadData(pageQueryParams);
        });

        /**
         * 加载数据
         * @param {object} params - 查询参数
         */
        function loadData(params) {
            var queryParams = {
                pageNum: params.pageNum || 1,
                pageSize: params.pageSize || 10
            };

            var operatorId = $('#searchOperatorId').val().trim();
            var csEl1 = document.querySelector('#searchModuleNameCselect');
            var moduleName = csEl1 ? csEl1.dataset.value : undefined;
            var csEl2 = document.querySelector('#searchOperTypeCselect');
            var operType = csEl2 ? csEl2.dataset.value : undefined;

            if (operatorId) {
                queryParams.operatorId = operatorId;
            }
            if (moduleName) {
                queryParams.moduleName = moduleName;
            }
            if (operType) {
                queryParams.operType = operType;
            }

            $.ajaxRequest('/admin/log/page', 'GET', queryParams, function(result) {
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
                $('#tableBody').html('<tr><td colspan="7" class="text-center" style="padding: 40px 0;"><a href="javascript:void(0)" onclick="loadData(pageQueryParams)" class="error-retry-link">加载失败，点击重试</a></td></tr>');
            });
        }

        /**
         * 渲染表格
         * @param {Array} list - 操作日志列表
         */
        function renderTable(list) {
            var $tbody = $('#tableBody');
            $tbody.empty();

            if (!list || list.length === 0) {
                $tbody.html('<tr><td colspan="7" class="text-center" style="padding: 40px 0; color: var(--muted);"><svg width="32" height="32" style="color: var(--border); margin: 0 auto 8px; display: block;"><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-inbox"/></svg>暂无数据</td></tr>');
                return;
            }

            list.forEach(function(item) {
                var operTypeBadge = getOperTypeBadge(item.operType);
                var requestParam = item.requestParam || '-';
                var requestParamDisplay = requestParam.length > 50 ? requestParam.substring(0, 50) + '...' : requestParam;
                var requestParamTitle = requestParam !== '-' ? ' title="' + escapeHtml(requestParam) + '"' : '';

                var row = '<tr>';
                row += '<td>' + (item.operatorId || '-') + '</td>';
                row += '<td>' + (item.moduleName || '-') + '</td>';
                row += '<td>' + operTypeBadge + '</td>';
                row += '<td>' + (item.operDesc || '-') + '</td>';
                row += '<td>' + (item.operIp || '-') + '</td>';
                row += '<td' + requestParamTitle + '><span class="text-truncate" style="max-width: 200px; display: inline-block;">' + escapeHtml(requestParamDisplay) + '</span></td>';
                row += '<td>' + $.formatDate(item.operTime) + '</td>';
                row += '</tr>';
                $tbody.append(row);
            });
        }

        /**
         * 获取操作类型徽章
         * @param {string} operType - 操作类型
         * @returns {string} 状态徽章HTML
         */
        function getOperTypeBadge(operType) {
            var map = {
                '新增': '<span class="pill pill-done">新增</span>',
                '修改': '<span class="pill pill-admin">修改</span>',
                '删除': '<span class="pill pill-danger">删除</span>',
                '审批': '<span class="pill pill-pending">审批</span>',
                '登录': '<span class="pill pill-processing">登录</span>',
                '登出': '<span class="pill pill-quiet">登出</span>'
            };
            return map[operType] || '<span class="pill pill-quiet">' + (operType || '-') + '</span>';
        }

        /**
         * HTML转义
         * @param {string} str - 原始字符串
         * @returns {string} 转义后的字符串
         */
        function escapeHtml(str) {
            if (!str) return '';
            return str.replace(/&/g, '&amp;')
                      .replace(/</g, '&lt;')
                      .replace(/>/g, '&gt;')
                      .replace(/"/g, '&quot;')
                      .replace(/'/g, '&#039;');
        }

        function search() {
            pageQueryParams.pageNum = 1;
            loadData(pageQueryParams);
        }

        function resetSearch() {
            $('#searchOperatorId').val('');
            // 重置操作模块下拉框
            $.updateCselectOptions(
                document.querySelector('#searchModuleNameCselect'),
                [
                    {value: '', text: '全部', selected: true},
                    {value: '用户管理', text: '用户管理'},
                    {value: '楼栋管理', text: '楼栋管理'},
                    {value: '房间管理', text: '房间管理'},
                    {value: '床位管理', text: '床位管理'},
                    {value: '入住管理', text: '入住管理'},
                    {value: '调宿管理', text: '调宿管理'},
                    {value: '报修管理', text: '报修管理'},
                    {value: '晚归登记', text: '晚归登记'},
                    {value: '访客登记', text: '访客登记'},
                    {value: '用户认证', text: '用户认证'},
                    {value: '个人信息', text: '个人信息'}
                ]
            );
            // 重置操作类型下拉框
            $.updateCselectOptions(
                document.querySelector('#searchOperTypeCselect'),
                [
                    {value: '', text: '全部', selected: true},
                    {value: '新增', text: '新增'},
                    {value: '修改', text: '修改'},
                    {value: '删除', text: '删除'},
                    {value: '审批', text: '审批'},
                    {value: '登录', text: '登录'},
                    {value: '登出', text: '登出'}
                ]
            );
            search();
        }
    </script>
</body>
</html>
