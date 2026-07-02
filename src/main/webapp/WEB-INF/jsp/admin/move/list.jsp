<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>调宿管理 - 高校公寓管理系统</title>
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
                        <h1>调宿管理</h1>
                        <p class="page-meta">审批学生的调宿申请</p>
                    </div>
                </div>

                <div class="filter-bar">
                    <div class="filter-field">
                        <label>学生ID</label>
                        <input type="text" id="searchStudentId" placeholder="请输入学生ID">
                    </div>
                    <div class="filter-field">
                        <label>审批状态</label>
                        <div class="cselect" id="searchStatusCselect">
                            <div class="cselect-trigger" tabindex="0" aria-haspopup="listbox" aria-expanded="false">
                                <span class="cselect-val cselect-placeholder">全部</span>
                                <svg class="cselect-arrow" viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="1.6" fill="none" stroke-linecap="round" stroke-linejoin="round">
                                    <polyline points="6 9 12 15 18 9"></polyline>
                                </svg>
                            </div>
                            <div class="cselect-panel" role="listbox">
                                <div class="cselect-option selected" data-value="">全部</div>
                                <div class="cselect-option" data-value="0">待审批</div>
                                <div class="cselect-option" data-value="1">已通过</div>
                                <div class="cselect-option" data-value="2">已驳回</div>
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
                        <thead>
                            <tr>
                                <th>学生姓名</th>
                                <th>学号</th>
                                <th>原床位</th>
                                <th>目标床位</th>
                                <th>申请原因</th>
                                <th>申请时间</th>
                                <th>状态</th>
                                <th style="width: 100px;">操作</th>
                            </tr>
                        </thead>
                        <tbody id="tableBody">
                            <tr><td colspan="8" class="text-center" style="padding: 40px 0; color: var(--muted);"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" width="32" height="32" style="color: var(--border); margin: 0 auto 8px; display: block;"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                                        加载中...</td></tr>
                        </tbody>
                    </table>
                    <div id="paginationContainer"></div>
                </div>
            </div>

            <%@ include file="/WEB-INF/jsp/common/footer.jsp" %>
        </div>
    </div>

    <!-- 审批模态框 -->
    <div class="modal fade" id="auditModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="modal-title">审批调宿申请</h2>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <!-- 申请详情 -->
                    <div class="detail-panel">
                        <h3 class="detail-section-title">申请信息</h3>
                        <table>
                            <tr>
                                <td>申请人</td>
                                <td id="auditStudentName"></td>
                            </tr>
                            <tr>
                                <td>原床位</td>
                                <td id="auditOriginalBed"></td>
                            </tr>
                            <tr>
                                <td>目标床位</td>
                                <td id="auditTargetBed"></td>
                            </tr>
                            <tr>
                                <td>申请原因</td>
                                <td id="auditReason"></td>
                            </tr>
                            <tr>
                                <td>申请时间</td>
                                <td id="auditTime"></td>
                            </tr>
                        </table>
                    </div>
                    <!-- 审批表单 -->
                    <form id="auditForm">
                        <input type="hidden" id="auditApplyId">
                        <div class="mb-3">
                            <label class="form-label">审批结果 <span class="required">*</span></label>
                            <div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="auditStatus" id="auditPass" value="1" checked>
                                    <label class="form-check-label" for="auditPass">通过</label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="auditStatus" id="auditReject" value="2">
                                    <label class="form-check-label" for="auditReject">驳回</label>
                                </div>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="auditOpinion" class="form-label">审批意见</label>
                            <textarea class="form-control" id="auditOpinion" rows="3" placeholder="可选填审批意见" maxlength="255"></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                    <button type="button" class="btn btn-primary" id="btnAuditSubmit" onclick="submitAudit()">确认提交</button>
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
            var queryParams = $.extend({}, params, {
                studentNo: $('#searchStudentId').val().trim() || null,
                auditStatus: (document.querySelector('#searchStatusCselect') || {dataset:{}}).dataset?.value ?? null
            });

            $.ajaxRequest('/admin/move/page', 'GET', queryParams, function(result) {
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
                $('#tableBody').html('<tr><td colspan="8" class="text-center" style="padding: 40px 0;"><a href="javascript:void(0)" onclick="loadData(pageQueryParams)" style="color: var(--accent);">加载失败，点击重试</a></td></tr>');
            });
        }

        /**
         * 渲染表格
         * @param {Array} list - 调宿申请列表
         */
        function renderTable(list) {
            var $tbody = $('#tableBody');
            $tbody.empty();

            if (!list || list.length === 0) {
                $tbody.html('<tr><td colspan="8" class="text-center" style="padding: 40px 0; color: var(--muted);"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" width="32" height="32" style="color: var(--border); margin: 0 auto 8px; display: block;"><polyline points="22 12 16 12 14 15 10 15 8 12 2 12"/><path d="M5.45 5.11L2 12v6a2 2 0 002 2h16a2 2 0 002-2v-6l-3.45-6.89A2 2 0 0016.76 4H7.24a2 2 0 00-1.79 1.11z"/></svg>暂无数据</td></tr>');
                return;
            }

            list.forEach(function(item) {
                var statusBadge = getStatusBadge(item.auditStatus);
                var actionBtn = '';
                if (item.auditStatus === 0) {
                    actionBtn = '<button class="btn btn-ghost btn-sm" onclick="showAuditModal(' + item.applyId + ')">审批</button>';
                } else {
                    actionBtn = '<span class="text-muted">已处理</span>';
                }

                var row = '<tr>';
                row += '<td>' + (item.studentName || '-') + '</td>';
                row += '<td>' + (item.studentNo || '-') + '</td>';
                row += '<td>' + (item.originalBedInfo || '-') + '</td>';
                row += '<td>' + (item.targetBedInfo || '-') + '</td>';
                row += '<td>' + (item.applyReason || '-') + '</td>';
                row += '<td>' + $.formatDate(item.applyTime) + '</td>';
                row += '<td>' + statusBadge + '</td>';
                row += '<td class="actions">' + actionBtn + '</td>';
                row += '</tr>';
                $tbody.append(row);
            });
        }

        /**
         * 获取状态徽章
         * @param {number} status - 审批状态
         * @returns {string} 状态徽章HTML
         */
        function getStatusBadge(status) {
            var map = {
                0: '<span class="pill pill-pending">待审批</span>',
                1: '<span class="pill pill-done">已通过</span>',
                2: '<span class="pill pill-danger">已驳回</span>'
            };
            return map[status] || '<span class="pill pill-quiet">未知</span>';
        }

        /**
         * 显示审批模态框
         * @param {number} applyId - 申请ID
         */
        function showAuditModal(applyId) {
            // 加载申请详情
            $.ajaxRequest('/admin/move/' + applyId, 'GET', null, function(result) {
                if (result.data) {
                    var apply = result.data;
                    $('#auditApplyId').val(apply.applyId);
                    $('#auditStudentName').text(apply.studentName + ' (' + apply.studentNo + ')');
                    $('#auditOriginalBed').text(apply.originalBedInfo || '-');
                    $('#auditTargetBed').text(apply.targetBedInfo || '-');
                    $('#auditReason').text(apply.applyReason || '-');
                    $('#auditTime').text($.formatDate(apply.applyTime));
                    $('#auditPass').prop('checked', true);
                    $('#auditOpinion').val('');
                    $('#auditModal').modal('show');
                }
            }, function(result) {
                $.toast('error', result.msg || '加载申请详情失败');
            });
        }

        /**
         * 提交审批
         */
        function submitAudit() {
            var applyId = $('#auditApplyId').val();
            var auditStatus = $('input[name="auditStatus"]:checked').val();
            var auditOpinion = $('#auditOpinion').val().trim();

            var formData = {
                auditStatus: parseInt(auditStatus),
                auditOpinion: auditOpinion || null
            };

            $('#btnAuditSubmit').prop('disabled', true).text('提交中...');

            $.ajaxRequest('/admin/move/audit/' + applyId, 'POST', formData, function(result) {
                $.toast('success', '审批提交成功');
                $('#auditModal').modal('hide');
                $('#btnAuditSubmit').prop('disabled', false).text('确认提交');
                loadData(pageQueryParams);
            }, function(result) {
                $.toast('error', result.msg || '审批提交失败');
                $('#btnAuditSubmit').prop('disabled', false).text('确认提交');
            });
        }

        function search() {
            pageQueryParams.pageNum = 1;
            loadData(pageQueryParams);
        }

        function resetSearch() {
            $('#searchStudentId').val('');
            // 重置状态下拉框
            $.updateCselectOptions(
                document.querySelector('#searchStatusCselect'),
                [
                    {value: '', text: '全部', selected: true},
                    {value: '0', text: '待审批'},
                    {value: '1', text: '已通过'},
                    {value: '2', text: '已驳回'}
                ]
            );
            search();
        }
    </script>
</body>
</html>
