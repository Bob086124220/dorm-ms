<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>提交调宿申请 - 高校公寓管理系统</title>
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/static/images/favicon.svg">
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/vendor/bootstrap/css/bootstrap.min.css">
    <!-- 公共CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/tokens.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/common.css">
</head>
<body class="student-layout">
    <div class="main-container">
        <!-- 侧边栏 -->
        <%@ include file="/WEB-INF/jsp/common/sidebar.jsp" %>

        <!-- 内容区域 -->
        <div class="content-wrapper">
            <!-- 导航栏 -->
            <%@ include file="/WEB-INF/jsp/common/header.jsp" %>
            <%@ include file="/WEB-INF/jsp/common/student_tabs.jsp" %>

            <!-- 内容主体 -->
            <div class="content-body">
                <!-- 页面标题 -->
                <div class="page-header">
                    <div>
                        <span class="page-eyebrow">ROOM TRANSFER</span>
                        <h1>提交调宿申请</h1>
                        <p class="page-meta">申请调换到其他床位</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/student/move/list" class="btn btn-secondary">
                        <svg width="16" height="16"><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-arrow-left"/></svg>
                        返回列表
                    </a>
                </div>

                <!-- 当前住宿信息 -->
                <div class="form-container mb-4">
                    <h6 class="mb-3">当前住宿信息</h6>
                    <div id="currentInfo">
                        <div class="text-center py-4">
                            加载中...
                        </div>
                    </div>
                </div>

                <!-- 选择目标床位 -->
                <div class="form-container mb-4" id="targetSection" style="display: none;">
                    <h6 class="mb-3">选择目标床位</h6>
                                        <div class="form-grid-3">
                        <div class="form-field">
                            <label>楼栋</label>
                                                        <div class="cselect" id="buildingIdCselect">
                                                            <div class="cselect-trigger" tabindex="0" aria-haspopup="listbox" aria-expanded="false">
                                                                <span class="cselect-val cselect-placeholder">请选择楼栋</span>
                                                                <svg class="cselect-arrow" viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="1.6" fill="none" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 12 15 18 9"/></svg>
                                                            </div>
                                                            <div class="cselect-panel" role="listbox">
                                                                <div class="cselect-option" data-value="">请选择楼栋</div>
                                                            </div>
                                                        </div>
                        </div>
                        <div class="form-field">
                            <label>房间</label>
                                                        <div class="cselect" id="roomIdCselect">
                                                            <div class="cselect-trigger" tabindex="0" aria-haspopup="listbox" aria-expanded="false">
                                                                <span class="cselect-val cselect-placeholder">请先选择楼栋</span>
                                                                <svg class="cselect-arrow" viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="1.6" fill="none" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 12 15 18 9"/></svg>
                                                            </div>
                                                            <div class="cselect-panel" role="listbox">
                                                                <div class="cselect-option" data-value="">请先选择楼栋</div>
                                                            </div>
                                                        </div>
                        </div>
                        <div class="form-field">
                            <label>床位</label>
                                                        <div class="cselect" id="bedIdCselect">
                                                            <div class="cselect-trigger" tabindex="0" aria-haspopup="listbox" aria-expanded="false">
                                                                <span class="cselect-val cselect-placeholder">请先选择房间</span>
                                                                <svg class="cselect-arrow" viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="1.6" fill="none" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 12 15 18 9"/></svg>
                                                            </div>
                                                            <div class="cselect-panel" role="listbox">
                                                                <div class="cselect-option" data-value="">请先选择房间</div>
                                                            </div>
                                                        </div>
                        </div>
                    </div>
                </div>

                <!-- 申请原因 -->
                <div class="form-container mb-4" id="reasonSection" style="display: none;">
                    <h6 class="mb-3">申请原因</h6>
                    <div class="form-group">
                        <label for="applyReason">申请原因 <span class="required">*</span></label>
                        <textarea class="form-control" id="applyReason" rows="4" placeholder="请详细说明调宿原因" maxlength="255"></textarea>
                        <div class="invalid-feedback" id="reasonError"></div>
                    </div>
                    <div class="mt-3">
                        <button type="button" class="btn btn-primary" id="btnSubmit" onclick="submitForm()">
                            提交申请
                        </button>
                    </div>
                </div>

                <!-- 无在住记录提示 -->
                <div id="noCheckinTip" style="display: none;">
                    <div class="form-container">
                        <div class="text-center py-4 text-muted">
                            您当前没有在住记录，无法提交调宿申请。请先联系管理员办理入住。
                        </div>
                    </div>
                </div>
            </div>

            <!-- 底部 -->
            <%@ include file="/WEB-INF/jsp/common/footer.jsp" %>
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
        // 当前住宿信息
        var currentCheckin = null;

        $(function() {
            $.initCustomSelect();

            // 加载当前住宿信息
            loadCurrentCheckin();

            // 加载楼栋列表
            loadBuildingList();

            // 楼栋选择变化事件
            document.querySelector('#buildingIdCselect').addEventListener('cselect:change', function(e) {
                var buildingId = e.detail.value;
                if (buildingId) {
                    loadRoomList(buildingId);
                } else {
                    $.updateCselectOptions(document.querySelector('#roomIdCselect'), [{value: '', text: '请先选择楼栋'}]);
                    $.updateCselectOptions(document.querySelector('#bedIdCselect'), [{value: '', text: '请先选择房间'}]);
                }
            });

            // 房间选择变化事件
            document.querySelector('#roomIdCselect').addEventListener('cselect:change', function(e) {
                var roomId = e.detail.value;
                if (roomId) {
                    loadFreeBeds(roomId);
                } else {
                    $.updateCselectOptions(document.querySelector('#bedIdCselect'), [{value: '', text: '请先选择房间'}]);
                }
            });
        });

        /**
         * 加载当前住宿信息
         */
        function loadCurrentCheckin() {
            $.ajaxRequest('/student/checkin/info', 'GET', null, function(result) {
                if (result.data) {
                    currentCheckin = result.data;
                    showCurrentInfo(result.data);
                } else {
                    showNoCheckinTip();
                }
            }, function() {
                showNoCheckinTip();
            });
        }

        /**
         * 显示当前住宿信息
         * @param {object} info - 住宿信息
         */
        function showCurrentInfo(info) {
            var html = '<div class="row">';
            html += '<div class="col-md-3"><div class="form-group"><label>楼栋</label>';
            html += '<input type="text" class="form-control" value="' + (info.buildingName || '-') + '" readonly></div></div>';
            html += '<div class="col-md-3"><div class="form-group"><label>房间</label>';
            html += '<input type="text" class="form-control" value="' + (info.roomNo || '-') + '" readonly></div></div>';
            html += '<div class="col-md-3"><div class="form-group"><label>床位</label>';
            html += '<input type="text" class="form-control" value="' + (info.bedNo || '-') + '" readonly></div></div>';
            html += '<div class="col-md-3"><div class="form-group"><label>入住时间</label>';
            html += '<input type="text" class="form-control" value="' + $.formatDate(info.checkinTime) + '" readonly></div></div>';
            html += '</div>';

            $('#currentInfo').html(html);
            $('#targetSection').show();
            $('#reasonSection').show();
        }

        /**
         * 显示无在住记录提示
         */
        function showNoCheckinTip() {
            $('#currentInfo').html('');
            $('#targetSection').hide();
            $('#reasonSection').hide();
            $('#noCheckinTip').show();
        }

        /**
         * 加载楼栋列表
         */
        function loadBuildingList() {
            $.ajaxRequest('/common/building/list', 'GET', null, function(result) {
                if (result.data) {
                    var options = [{value: '', text: '请选择楼栋'}];
                    result.data.forEach(function(building) {
                        options.push({value: building.buildingId, text: building.buildingName});
                    });
                    $.updateCselectOptions(document.querySelector('#buildingIdCselect'), options);
                }
            });
        }

        /**
         * 加载房间列表
         * @param {number} buildingId - 楼栋ID
         */
        function loadRoomList(buildingId) {
            var cs = document.querySelector('#roomIdCselect');
            $.updateCselectOptions(cs, [{value: '', text: '加载中...'}]);
            $.updateCselectOptions(document.querySelector('#bedIdCselect'), [{value: '', text: '请先选择房间'}]);

            $.ajaxRequest('/common/room/building/' + buildingId, 'GET', null, function(result) {
                if (result.data) {
                    var options = [{value: '', text: '请选择房间'}];
                    result.data.forEach(function(room) {
                        options.push({value: room.roomId, text: room.roomNo + ' (' + room.roomTypeText + ')'});
                    });
                    $.updateCselectOptions(cs, options);
                }
            });
        }

        /**
         * 加载空闲床位
         * @param {number} roomId - 房间ID
         */
        function loadFreeBeds(roomId) {
            var cs = document.querySelector('#bedIdCselect');
            $.updateCselectOptions(cs, [{value: '', text: '加载中...'}]);

            $.ajaxRequest('/common/bed/free/' + roomId, 'GET', null, function(result) {
                if (result.data) {
                    if (result.data.length === 0) {
                        $.updateCselectOptions(cs, [{value: '', text: '该房间无空闲床位'}]);
                    } else {
                        var options = [{value: '', text: '请选择床位'}];
                        result.data.forEach(function(bed) {
                            options.push({value: bed.bedId, text: bed.bedNo});
                        });
                        $.updateCselectOptions(cs, options);
                    }
                }
            });
        }

        /**
         * 提交表单
         */
        function submitForm() {
            var bedId = document.querySelector('#bedIdCselect').dataset.value || '';
            var applyReason = $('#applyReason').val().trim();

            // 校验
            if (!bedId) {
                $.toast('warning', '请选择目标床位');
                return;
            }

            if (!applyReason) {
                $('#applyReason').addClass('is-invalid');
                $('#reasonError').text('请输入申请原因');
                return;
            }

            if (applyReason.length > 255) {
                $('#applyReason').addClass('is-invalid');
                $('#reasonError').text('申请原因长度不能超过255个字符');
                return;
            }

            $('#applyReason').removeClass('is-invalid');
            $('#reasonError').text('');

            var formData = {
                targetBedId: parseInt(bedId),
                applyReason: applyReason
            };

            $('#btnSubmit').prop('disabled', true).text('提交中...');

            $.ajaxRequest('/student/move/apply', 'POST', formData, function(result) {
                $.toast('success', '调宿申请提交成功');
                setTimeout(function() {
                    window.location.href = $.buildUrl('/student/move/list');
                }, 1000);
            }, function(result) {
                $.toast('error', result.msg || '提交失败');
                $('#btnSubmit').prop('disabled', false).text('提交申请');
            });
        }
    </script>
</body>
</html>
