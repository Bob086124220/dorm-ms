<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>调宿管理 - 高校公寓管理系统</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/vendor/bootstrap/css/bootstrap.min.css">
    <!-- 公共CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/tokens.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/common.css">
</head>
<body>
    <div class="main-container">
        <!-- 侧边栏 -->
        <%@ include file="/WEB-INF/jsp/common/sidebar.jsp" %>

        <!-- 内容区域 -->
        <div class="content-wrapper">
            <!-- 导航栏 -->
            <%@ include file="/WEB-INF/jsp/common/header.jsp" %>

            <!-- 内容主体 -->
            <div class="content-body">
                <!-- 页面标题 -->
                <div class="page-header">
                    <div>
                        <span class="page-eyebrow">ROOM TRANSFER APPROVAL</span>
                        <h1>调宿管理</h1>
                        <p class="page-meta">审批本楼栋学生的调宿申请</p>
                    </div>
                </div>

                <!-- 查询区域 -->
                                <div class="filter-bar">
                    <div class="filter-field">
                        <label for="searchStudentNo">学号</label>
                                                    <input type="text" class="form-control" id="searchStudentNo" placeholder="请输入学号">
                    </div>
                    <div class="filter-field">
                        <label>审批状态</label>
                                                    <div class="cselect" id="searchStatusCselect">
                                                        <div class="cselect-trigger" tabindex="0" aria-haspopup="listbox" aria-expanded="false">
                                                            <span class="cselect-val cselect-placeholder">全部</span>
                                                            <svg class="cselect-arrow" viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="1.6" fill="none" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 12 15 18 9"/></svg>
                                                        </div>
                                                        <div class="cselect-panel" role="listbox">
                                                            <div class="cselect-option" data-value="">全部</div>
                                                            <div class="cselect-option" data-value="0">待审批</div>
                                                            <div class="cselect-option" data-value="1">已通过</div>
                                                            <div class="cselect-option" data-value="2">已驳回</div>
                                                        </div>
                                                    </div>
                    </div>
                    <div class="filter-actions">
                        <button type="button" class="btn btn-secondary btn-sm" onclick="search()">
                                                        <svg viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="1.6" fill="none" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                                                        查询
                                                    </button>
                                                    <button type="button" class="btn btn-ghost btn-sm" onclick="resetSearch()">重置</button>
                    </div>
                </div>

                <!-- 调宿申请列表 -->
                <div class="form-container">
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
                                    <th>操作</th>
                                </tr>
                            </thead>
                            <tbody id="tableBody">
                                <tr>
                                    <td colspan="8" class="text-center py-4">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" width="32" height="32" style="color: var(--border); margin: 0 auto 8px; display: block;"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                                        加载中...
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <!-- 分页 -->
                    <div id="paginationContainer"></div>
                </div>
            </div>

            <!-- 底部 -->
            <%@ include file="/WEB-INF/jsp/common/footer.jsp" %>
        </div>
    </div>

    <!-- 审批弹窗 -->
    <div class="modal-overlay" id="auditModal">
        <div class="modal-custom">
            <div class="modal-header">
                <h2>审批调宿申请</h2>
                <button type="button" class="modal-close" onclick="closeAuditModal()">
                    <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                </button>
            </div>
            <div class="modal-body">
                <div class="detail-panel">
                    <h3 class="detail-section-title">申请信息</h3>
                    <table>
                        <tr><td>申请人</td><td id="auditStudentName"></td></tr>
                        <tr><td>原床位</td><td id="auditOriginalBed"></td></tr>
                        <tr><td>目标床位</td><td id="auditTargetBed"></td></tr>
                        <tr><td>申请原因</td><td id="auditReason"></td></tr>
                        <tr><td>申请时间</td><td id="auditTime"></td></tr>
                    </table>
                </div>
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
                <button type="button" class="btn btn-secondary" onclick="closeAuditModal()">取消</button>
                <button type="button" class="btn btn-primary" id="btnAuditSubmit" onclick="submitAudit()">确认提交</button>
            </div>
        </div>
    </div>

    <!-- jQuery -->
    <script src="${pageContext.request.contextPath}/static/js/jquery.min.js"></script>
    <!-- Bootstrap JS -->
    <script src="${pageContext.request.contextPath}/static/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <!-- 公共JS -->
    <script src="${pageContext.request.contextPath}/static/js/common.js"></script>
    <!-- 导航栏JS -->
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
            var studentNo = $('#searchStudentNo').val().trim();
            var csEl = document.querySelector('#searchStatusCselect');
            var auditStatus = csEl ? csEl.dataset.value : undefined;

            var queryParams = {
                pageNum: params.pageNum || 1,
                pageSize: params.pageSize || 10
            };

            if (studentNo) {
                queryParams.studentNo = studentNo;
            }
            if (auditStatus) {
                queryParams.auditStatus = auditStatus;
            }

            $.ajaxRequest('/dorm/move/page', 'GET', queryParams, function(result) {
                if (result.data) {
                    renderTable(result.data.list);
                    if (result.data && result.data.pages > 1) {
                    $.renderPagination(result.data, 'paginationContainer',
                        function(page) { pageQueryParams.pageNum = page; loadData(pageQueryParams); },
                        pageQueryParams.pageSize,
                        function(ps) { pageQueryParams.pageNum = 1; pageQueryParams.pageSize = ps; loadData(pageQueryParams); }
                    );
                } else { $('#paginationContainer').empty(); }
                    
                    pageQueryParams.pageNum = result.data.pageNum;
                    pageQueryParams.pageSize = result.data.pageSize;
                }
            }, function(result) {
                if (result.msg && result.msg.indexOf('未负责任何楼栋') !== -1) {
                    $('#tableBody').html('<tr><td colspan="8" class="text-center py-4" style="color: var(--accent-2);">您暂未负责任何楼栋，请联系管理员</td></tr>');
                } else {
                    $('#tableBody').html('<tr><td colspan="8" class="text-center py-4"><a href="javascript:void(0)" onclick="loadData(pageQueryParams)" style="color: var(--accent);">加载失败，点击重试</a></td></tr>');
                }
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
                $tbody.html('<tr><td colspan="8" class="text-center py-4 text-muted"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" width="32" height="32" style="color: var(--border); margin: 0 auto 8px; display: block;"><polyline points="22 12 16 12 14 15 10 15 8 12 2 12"/><path d="M5.45 5.11L2 12v6a2 2 0 002 2h16a2 2 0 002-2v-6l-3.45-6.89A2 2 0 0016.76 4H7.24a2 2 0 00-1.79 1.11z"/></svg>暂无数据</td></tr>');
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
                row += '<td>' + actionBtn + '</td>';
                row += '</tr>';
                $tbody.append(row);
            });
        }

        /**
         * 渲染分页
         * @param {object} pageInfo - 分页信息
         */
                                function search() {
            pageQueryParams.pageNum = 1;
            loadData(pageQueryParams);
        }

        function resetSearch() {
            $('#searchStudentNo').val('');
            $.updateCselectOptions(document.querySelector('#searchStatusCselect'), [
                {value: '', text: '全部'},
                {value: '0', text: '待审批'},
                {value: '1', text: '已通过'},
                {value: '2', text: '已驳回'}
            ]);
            search();
        }

        /**
         * 获取状态徽章
         * @param {number} status - 审批状态
         * @returns {string} 状态徽章HTML
         */
        function getStatusBadge(status) {
            var map = {
                0: '<span class="pill pill-pending">待审批</span>',
                1: '<span class="pill pill-active">已通过</span>',
                2: '<span class="pill pill-danger">已驳回</span>'
            };
            return map[status] || '<span class="pill pill-quiet">未知</span>';
        }

        /**
         * 显示审批模态框
         * @param {number} applyId - 申请ID
         */
        function showAuditModal(applyId) {
            $.ajaxRequest('/dorm/move/' + applyId, 'GET', null, function(result) {
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
                    $('#auditModal').addClass('open');
                }
            }, function(result) {
                $.toast('error', result.msg || '加载申请详情失败');
            });
        }

        /**
         * 提交审批
         */
        function closeAuditModal() {
            $('#auditModal').removeClass('open');
        }

        // 遮罩点击关闭
        $(document).on('click', '.modal-overlay', function(e) {
            if ($(e.target).hasClass('modal-overlay')) {
                $(this).removeClass('open');
            }
        });

        function submitAudit() {
            var applyId = $('#auditApplyId').val();
            var auditStatus = $('input[name="auditStatus"]:checked').val();
            var auditOpinion = $('#auditOpinion').val().trim();

            var formData = {
                auditStatus: parseInt(auditStatus),
                auditOpinion: auditOpinion || null
            };

            $('#btnAuditSubmit').prop('disabled', true).text('提交中...');

            $.ajaxRequest('/dorm/move/audit/' + applyId, 'POST', formData, function(result) {
                $.toast('success', '审批提交成功');
                closeAuditModal();
                $('#btnAuditSubmit').prop('disabled', false).text('确认提交');
                loadData(pageQueryParams);
            }, function(result) {
                $.toast('error', result.msg || '审批提交失败');
                $('#btnAuditSubmit').prop('disabled', false).text('确认提交');
            });
        }
    </script>
</body>
</html>
