<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>床位管理 - 高校公寓管理系统</title>
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
                        <h1>床位管理</h1>
                        <p class="page-meta">管理公寓床位信息</p>
                    </div>
                    <button type="button" class="btn btn-primary" onclick="showBatchModal()" id="btnBatch" disabled>
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" width="16" height="16"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
                        批量初始化
                    </button>
                </div>

                <div class="filter-bar">
                    <div class="filter-field">
                        <label>选择楼栋</label>
                        <div class="cselect" id="buildingIdCselect">
                            <div class="cselect-trigger" tabindex="0" aria-haspopup="listbox" aria-expanded="false">
                                <span class="cselect-val cselect-placeholder">请选择楼栋</span>
                                <svg class="cselect-arrow" viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="1.6" fill="none" stroke-linecap="round" stroke-linejoin="round">
                                    <polyline points="6 9 12 15 18 9"></polyline>
                                </svg>
                            </div>
                            <div class="cselect-panel" role="listbox">
                                <div class="cselect-option" data-value="">请选择楼栋</div>
                            </div>
                        </div>
                    </div>
                    <div class="filter-field">
                        <label>选择房间</label>
                        <div class="cselect" id="roomIdCselect">
                            <div class="cselect-trigger" tabindex="0" aria-haspopup="listbox" aria-expanded="false">
                                <span class="cselect-val cselect-placeholder">请先选择楼栋</span>
                                <svg class="cselect-arrow" viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="1.6" fill="none" stroke-linecap="round" stroke-linejoin="round">
                                    <polyline points="6 9 12 15 18 9"></polyline>
                                </svg>
                            </div>
                            <div class="cselect-panel" role="listbox">
                                <div class="cselect-option" data-value="">请先选择楼栋</div>
                            </div>
                        </div>
                    </div>
                    <div class="filter-actions">
                        <button type="button" class="btn btn-secondary btn-sm" onclick="loadBedList()" id="btnSearch" disabled>
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" width="14" height="14"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                            查询床位
                        </button>
                    </div>
                </div>

                <div class="data-panel">
                    <div id="bedListContainer">
                        <div class="text-center" style="padding: 40px 0; color: var(--muted);">请先选择楼栋和房间</div>
                    </div>
                </div>
            </div>

            <%@ include file="/WEB-INF/jsp/common/footer.jsp" %>
        </div>
    </div>

    <!-- 批量初始化模态框 -->
    <div class="modal fade" id="batchModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="modal-title">批量初始化床位</h2>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="alert alert-info">
                        将为房间 <strong id="batchRoomName"></strong> 自动生成床位，床位号格式为"1号床"、"2号床"...
                    </div>
                    <div class="mb-3">
                        <label class="form-label">房间类型</label>
                        <input type="text" class="form-control" id="batchRoomType" readonly>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">初始化床位数</label>
                        <input type="text" class="form-control" id="batchBedCount" readonly>
                        <small class="form-text text-muted">根据房间类型自动确定</small>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                    <button type="button" class="btn btn-primary" id="btnBatchSubmit" onclick="batchSubmit()">确认初始化</button>
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
        // 当前选中的房间ID和房间信息
        var currentRoomId = null;
        var currentRoomInfo = null;

        $(function() {
            $.initCustomSelect();
            loadBuildingList();

            // 楼栋选择变化事件
            document.querySelector('#buildingIdCselect').addEventListener('cselect:change', function(e) {
                var buildingId = e.detail.value;
                if (buildingId) {
                    loadRoomList(buildingId);
                } else {
                    $.updateCselectOptions(
                        document.querySelector('#roomIdCselect'),
                        [{value: '', text: '请先选择楼栋'}]
                    );
                    $('#btnSearch').prop('disabled', true);
                    $('#btnBatch').prop('disabled', true);
                    currentRoomId = null;
                    currentRoomInfo = null;
                }
            });

            // 房间选择变化事件
            document.querySelector('#roomIdCselect').addEventListener('cselect:change', function(e) {
                currentRoomId = e.detail.value;
                if (currentRoomId) {
                    $('#btnSearch').prop('disabled', false);
                    $('#btnBatch').prop('disabled', false);
                    loadRoomInfo(currentRoomId);
                } else {
                    $('#btnSearch').prop('disabled', true);
                    $('#btnBatch').prop('disabled', true);
                    currentRoomInfo = null;
                }
            });
        });

        /**
         * 加载房间信息
         * @param {number} roomId - 房间ID
         */
        function loadRoomInfo(roomId) {
            $.ajaxRequest('/admin/room/' + roomId, 'GET', null, function(result) {
                if (result.data) {
                    currentRoomInfo = result.data;
                }
            });
        }

        /**
         * 加载楼栋列表
         */
        function loadBuildingList() {
            $.ajaxRequest('/admin/building/page', 'GET', {pageSize: 100}, function(result) {
                if (result.data && result.data.list) {
                    var options = [{value: '', text: '请选择楼栋'}];
                    result.data.list.forEach(function(building) {
                        options.push({value: building.buildingId, text: building.buildingName});
                    });
                    $.updateCselectOptions(
                        document.querySelector('#buildingIdCselect'),
                        options
                    );
                }
            });
        }

        /**
         * 加载房间列表
         * @param {number} buildingId - 楼栋ID
         */
        function loadRoomList(buildingId) {
            var cselectEl = document.querySelector('#roomIdCselect');
            $.updateCselectOptions(cselectEl, [{value: '', text: '加载中...'}]);

            $.ajaxRequest('/admin/room/building/' + buildingId, 'GET', null, function(result) {
                if (result.data) {
                    var options = [{value: '', text: '请选择房间'}];
                    result.data.forEach(function(room) {
                        options.push({
                            value: room.roomId,
                            text: room.roomNo + ' (' + room.roomTypeText + ')'
                        });
                    });
                    $.updateCselectOptions(cselectEl, options);
                }
            });
        }

        /**
         * 加载床位列表
         */
        function loadBedList() {
            if (!currentRoomId) {
                return;
            }

            var $container = $('#bedListContainer');
            $container.html('<div class="text-center" style="padding: 40px 0; color: var(--muted);">加载中...</div>');

            $.ajaxRequest('/admin/bed/room/' + currentRoomId, 'GET', null, function(result) {
                if (result.data && result.data.length > 0) {
                    renderBedList(result.data);
                } else {
                    $container.html('<div class="text-center" style="padding: 40px 0; color: var(--muted);">该房间暂无床位，请点击"批量初始化"创建床位</div>');
                }
            }, function() {
                $container.html('<div class="text-center" style="padding: 40px 0;"><a href="javascript:void(0)" onclick="loadBedList()" style="color: var(--accent);">加载失败，点击重试</a></div>');
            });
        }

        /**
         * 渲染床位列表
         * @param {Array} bedList - 床位列表
         */
        function renderBedList(bedList) {
            var $container = $('#bedListContainer');
            var html = '<table>';
            html += '<thead><tr>';
            html += '<th>床位编号</th>';
            html += '<th>状态</th>';
            html += '<th>入住学生</th>';
            html += '<th>备注</th>';
            html += '<th style="width: 120px;">操作</th>';
            html += '</tr></thead>';
            html += '<tbody>';

            bedList.forEach(function(bed) {
                var statusBadge = getStatusBadge(bed.bedStatus);
                var actionBtn = '';

                if (bed.bedStatus === 0) {
                    actionBtn = '<button class="btn btn-ghost btn-sm" onclick="updateStatus(' + bed.bedId + ', 2)">设为维修</button>';
                } else if (bed.bedStatus === 2) {
                    actionBtn = '<button class="btn btn-ghost btn-sm" onclick="updateStatus(' + bed.bedId + ', 0)">设为空闲</button>';
                } else {
                    actionBtn = '<span class="text-muted">-</span>';
                }

                html += '<tr>';
                html += '<td>' + (bed.bedNo || '-') + '</td>';
                html += '<td>' + statusBadge + '</td>';
                html += '<td>' + (bed.studentName || '-') + '</td>';
                html += '<td class="text-muted">' + (bed.remark || '-') + '</td>';
                html += '<td class="actions">' + actionBtn + '</td>';
                html += '</tr>';
            });

            html += '</tbody></table>';
            $container.html(html);
        }

        /**
         * 获取状态徽章
         * @param {number} status - 床位状态
         * @returns {string} 状态徽章HTML
         */
        function getStatusBadge(status) {
            var map = {
                0: '<span class="pill pill-done">空闲</span>',
                1: '<span class="pill pill-active">已入住</span>',
                2: '<span class="pill pill-pending">维修禁用</span>'
            };
            return map[status] || '<span class="pill pill-quiet">未知</span>';
        }

        /**
         * 显示批量初始化模态框
         */
        function showBatchModal() {
            if (!currentRoomId) {
                $.toast('warning', '请先选择房间');
                return;
            }

            if (!currentRoomInfo) {
                $.toast('warning', '房间信息加载中，请稍后再试');
                return;
            }

            var roomName = document.querySelector('#roomIdCselect .cselect-val').textContent;
            var roomTypeText = currentRoomInfo.roomTypeText || '-';
            var bedTotal = currentRoomInfo.bedTotal || 0;

            $('#batchRoomName').text(roomName);
            $('#batchRoomType').val(roomTypeText);
            $('#batchBedCount').val(bedTotal + ' 个床位');
            $('#batchModal').modal('show');
        }

        /**
         * 批量初始化提交
         */
        function batchSubmit() {
            if (!currentRoomInfo || !currentRoomInfo.bedTotal) {
                $.toast('error', '无法获取房间额定床位数');
                return;
            }

            var bedCount = currentRoomInfo.bedTotal;

            $('#btnBatchSubmit').prop('disabled', true).text('初始化中...');

            $.ajaxRequest('/admin/bed/batch', 'POST', {
                roomId: parseInt(currentRoomId),
                bedCount: bedCount
            }, function(result) {
                $.toast('success', '批量初始化成功，已创建' + bedCount + '个床位');
                $('#batchModal').modal('hide');
                $('#btnBatchSubmit').prop('disabled', false).text('确认初始化');
                loadBedList();
            }, function(result) {
                $.toast('error', result.msg || '初始化失败');
                $('#btnBatchSubmit').prop('disabled', false).text('确认初始化');
            });
        }

        /**
         * 修改床位状态
         * @param {number} bedId - 床位ID
         * @param {number} status - 目标状态
         */
        function updateStatus(bedId, status) {
            var actionText = status === 0 ? '设为空闲' : '设为维修';
            $.confirm('确定要' + actionText + '吗？', function() {
                $.ajaxRequest('/admin/bed/status/' + bedId + '?status=' + status, 'POST', null, function(result) {
                    $.toast('success', actionText + '成功');
                    loadBedList();
                }, function(result) {
                    $.toast('error', result.msg || actionText + '失败');
                });
            });
        }

        /**
         * 重置搜索条件
         */
        function resetSearch() {
            // 重置楼栋下拉框
            loadBuildingList();
            // 重置房间下拉框
            $.updateCselectOptions(
                document.querySelector('#roomIdCselect'),
                [{value: '', text: '请先选择楼栋'}]
            );
            // 重置状态
            currentRoomId = null;
            currentRoomInfo = null;
            $('#btnSearch').prop('disabled', true);
            $('#btnBatch').prop('disabled', true);
            // 清空床位列表
            $('#bedListContainer').html('<div class="text-center" style="padding: 40px 0; color: var(--muted);">请先选择楼栋和房间</div>');
        }
    </script>
</body>
</html>
