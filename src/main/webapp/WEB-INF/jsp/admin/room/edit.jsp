<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>编辑房间 - 高校公寓管理系统</title>
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
                        <span class="page-eyebrow">ROOM MANAGEMENT</span>
                        <h1>编辑房间</h1>
                        <p class="page-meta">修改房间信息</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/room/list" class="btn btn-secondary">
                        返回列表
                    </a>
                </div>

                <div class="form-container">
                    <form id="roomForm" novalidate>
                        <input type="hidden" id="roomId" name="roomId">
                        <div class="form-grid">
                            <div class="form-field">
                                <label>房间编号 <span class="required">*</span></label>
                                <input type="text" class="form-control" id="roomNo" name="roomNo" placeholder="如：101" maxlength="20">
                            </div>
                            <div class="form-field">
                                <label>所属楼栋 <span class="required">*</span></label>
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
                            <div class="form-field">
                                <label>所在楼层 <span class="required">*</span></label>
                                <input type="number" class="form-control" id="floorNum" name="floorNum" placeholder="请选择楼栋后输入" min="1" disabled>
                                <span class="form-hint" id="floorHint">请先选择楼栋</span>
                            </div>
                            <div class="form-field">
                                <label>额定床位数 <span class="required">*</span></label>
                                <input type="number" class="form-control" id="bedTotal" name="bedTotal" placeholder="请输入床位数" min="1" max="20">
                            </div>
                            <div class="form-field">
                                <label>房间类型 <span class="required">*</span></label>
                                <div class="cselect" id="roomTypeCselect">
                                    <div class="cselect-trigger" tabindex="0" aria-haspopup="listbox" aria-expanded="false">
                                        <span class="cselect-val cselect-placeholder">请选择房间类型</span>
                                        <svg class="cselect-arrow" viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="1.6" fill="none" stroke-linecap="round" stroke-linejoin="round">
                                            <polyline points="6 9 12 15 18 9"></polyline>
                                        </svg>
                                    </div>
                                    <div class="cselect-panel" role="listbox">
                                        <div class="cselect-option" data-value="">请选择房间类型</div>
                                        <div class="cselect-option" data-value="1">四人间</div>
                                        <div class="cselect-option" data-value="2">六人间</div>
                                        <div class="cselect-option" data-value="3">八人间</div>
                                    </div>
                                </div>
                            </div>
                            <div class="form-field">
                                <label>备注</label>
                                <input type="text" class="form-control" id="remark" name="remark" placeholder="如：朝阳房间" maxlength="100">
                            </div>
                        </div>

                        <div style="margin-top: var(--gap-lg); display: flex; gap: var(--gap-sm);">
                            <button type="submit" class="btn btn-primary" id="btnSubmit">保存</button>
                            <a href="${pageContext.request.contextPath}/admin/room/list" class="btn btn-secondary">取消</a>
                        </div>
                    </form>
                </div>
            </div>

            <%@ include file="/WEB-INF/jsp/common/footer.jsp" %>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/static/js/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/static/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/jquery.validate.min.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/messages_zh.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/common.js"></script>
    <script>window.needChangePasswordFlag = '${sessionScope.needChangePassword}';</script>
    <script src="${pageContext.request.contextPath}/static/js/header.js"></script>

    <script>
        // 当前楼栋的楼层总数
        var currentFloorCount = 0;

        $(function() {
            // 从URL获取roomId
            var urlParams = new URLSearchParams(window.location.search);
            var roomId = urlParams.get('roomId');

            if (!roomId) {
                $.toast('error', '缺少房间ID参数');
                setTimeout(function() {
                    window.location.href = $.buildUrl('/admin/room/list');
                }, 1000);
                return;
            }

            $.initCustomSelect();
            // 加载楼栋列表，然后加载房间数据
            loadBuildingList(function() {
                loadRoomData(roomId);
            });

            // 楼栋选择变化事件
            document.querySelector('#buildingIdCselect').addEventListener('cselect:change', function(e) {
                var buildingId = e.detail.value;
                if (buildingId) {
                    loadBuildingInfo(buildingId);
                } else {
                    currentFloorCount = 0;
                    $('#floorNum').prop('disabled', true).attr('max', '').val('');
                    $('#floorHint').text('请先选择楼栋');
                }
            });

            // 表单验证
            $('#roomForm').validate({
                rules: {
                    roomNo: {
                        required: true,
                        maxlength: 20
                    },
                    buildingId: {
                        required: true
                    },
                    floorNum: {
                        required: true,
                        min: 1,
                        digits: true
                    },
                    bedTotal: {
                        required: true,
                        min: 1,
                        max: 20,
                        digits: true
                    },
                    roomType: {
                        required: true
                    }
                },
                messages: {
                    roomNo: {
                        required: '请输入房间编号',
                        maxlength: '房间编号长度不能超过20个字符'
                    },
                    buildingId: {
                        required: '请选择所属楼栋'
                    },
                    floorNum: {
                        required: '请输入所在楼层',
                        min: '楼层至少为1',
                        digits: '楼层必须为整数'
                    },
                    bedTotal: {
                        required: '请输入额定床位数',
                        min: '床位数至少为1',
                        max: '床位数不能超过20',
                        digits: '床位数必须为整数'
                    },
                    roomType: {
                        required: '请选择房间类型'
                    }
                },
                submitHandler: function(form) {
                    submitForm();
                }
            });
        });

        /**
         * 加载楼栋列表
         * @param {function} callback - 回调函数
         */
        function loadBuildingList(callback) {
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
                if (typeof callback === 'function') {
                    callback();
                }
            });
        }

        /**
         * 加载楼栋信息（获取楼层总数）
         * @param {number} buildingId - 楼栋ID
         */
        function loadBuildingInfo(buildingId) {
            $.ajaxRequest('/admin/building/' + buildingId, 'GET', null, function(result) {
                if (result.data) {
                    currentFloorCount = result.data.floorCount;
                    $('#floorNum').prop('disabled', false).attr('max', currentFloorCount);
                    $('#floorHint').text('最大楼层：' + currentFloorCount);

                    // 更新验证规则
                    var validator = $('#roomForm').validate();
                    validator.settings.rules.floorNum.max = currentFloorCount;
                    validator.settings.messages.floorNum.max = '楼层不能超过' + currentFloorCount;
                }
            });
        }

        /**
         * 加载房间数据
         * @param {number} roomId - 房间ID
         */
        function loadRoomData(roomId) {
            $.ajaxRequest('/admin/room/' + roomId, 'GET', null, function(result) {
                if (result.data) {
                    var room = result.data;
                    $('#roomId').val(room.roomId);
                    $('#roomNo').val(room.roomNo);
                    $('#bedTotal').val(room.bedTotal);
                    $('#remark').val(room.remark || '');

                    // 设置楼栋 cselect
                    if (room.buildingId) {
                        var buildingEl = document.querySelector('#buildingIdCselect');
                        buildingEl.dataset.value = room.buildingId;
                        var panel = buildingEl.querySelector('.cselect-panel');
                        var selectedOpt = panel.querySelector('.cselect-option[data-value="' + room.buildingId + '"]');
                        if (selectedOpt) {
                            buildingEl.querySelector('.cselect-val').textContent = selectedOpt.textContent;
                            buildingEl.querySelector('.cselect-val').classList.remove('cselect-placeholder');
                        }
                    }

                    // 设置房间类型 cselect
                    if (room.roomType) {
                        var roomTypeEl = document.querySelector('#roomTypeCselect');
                        roomTypeEl.dataset.value = room.roomType;
                        var roomTypePanel = roomTypeEl.querySelector('.cselect-panel');
                        var selectedRoomType = roomTypePanel.querySelector('.cselect-option[data-value="' + room.roomType + '"]');
                        if (selectedRoomType) {
                            roomTypeEl.querySelector('.cselect-val').textContent = selectedRoomType.textContent;
                            roomTypeEl.querySelector('.cselect-val').classList.remove('cselect-placeholder');
                        }
                    }

                    // 加载楼栋信息后设置楼层
                    if (room.buildingId) {
                        loadBuildingInfo(room.buildingId, function() {
                            $('#floorNum').val(room.floorNum);
                        });
                    }
                }
            }, function() {
                $.toast('error', '加载房间数据失败');
                setTimeout(function() {
                    window.location.href = $.buildUrl('/admin/room/list');
                }, 1000);
            });
        }

        /**
         * 提交表单
         */
        function submitForm() {
            var formData = {
                roomId: parseInt($('#roomId').val()),
                roomNo: $('#roomNo').val().trim(),
                buildingId: parseInt(document.querySelector('#buildingIdCselect').dataset.value),
                floorNum: parseInt($('#floorNum').val()),
                bedTotal: parseInt($('#bedTotal').val()),
                roomType: parseInt(document.querySelector('#roomTypeCselect').dataset.value),
                remark: $('#remark').val().trim() || null
            };

            $('#btnSubmit').prop('disabled', true).text('保存中...');

            $.ajaxRequest('/admin/room/update', 'POST', formData, function(result) {
                $.toast('success', '房间信息更新成功');
                setTimeout(function() {
                    window.location.href = $.buildUrl('/admin/room/list');
                }, 1000);
            }, function(result) {
                $.toast('error', result.msg || '更新失败');
                $('#btnSubmit').prop('disabled', false).text('保存');
            });
        }
    </script>
</body>
</html>
