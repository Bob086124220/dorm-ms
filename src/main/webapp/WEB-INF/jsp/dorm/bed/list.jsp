<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>床位信息 - 高校公寓管理系统</title>
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
                        <span class="page-eyebrow">BED INFORMATION</span>
                        <h1>床位信息</h1>
                        <p class="page-meta">查看负责楼栋的床位信息</p>
                    </div>
                </div>

                <!-- 级联选择 -->
                                <div class="filter-bar">
                    <div class="filter-field">
                                                <label>选择楼栋</label>
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
                                            <div class="filter-field">
                                                <label>选择房间</label>
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
                </div>

                <!-- 床位列表 -->
                <div class="form-container">
                    <h6 class="mb-3">床位列表</h6>
                    <div id="bedListContainer">
                        <div class="text-center py-4 text-muted">
                            请先选择楼栋和房间
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
        $(function() {
            $.initCustomSelect();
            loadBuildingList();

            // 楼栋选择变化事件
            document.querySelector('#buildingIdCselect').addEventListener('cselect:change', function(e) {
                var buildingId = e.detail.value;
                if (buildingId) {
                    loadRoomList(buildingId);
                } else {
                    $.updateCselectOptions(document.querySelector('#roomIdCselect'), [{value: '', text: '请先选择楼栋'}]);
                    $('#bedListContainer').html('<div class="text-center py-4 text-muted">请先选择楼栋和房间</div>');
                }
            });

            // 房间选择变化事件
            document.querySelector('#roomIdCselect').addEventListener('cselect:change', function(e) {
                var roomId = e.detail.value;
                if (roomId) {
                    loadBedList(roomId);
                } else {
                    $('#bedListContainer').html('<div class="text-center py-4 text-muted">请先选择房间</div>');
                }
            });
        });

        /**
         * 加载负责楼栋列表
         */
        function loadBuildingList() {
            $.ajaxRequest('/dorm/building/list', 'GET', null, function(result) {
                if (result.data) {
                    var options = [{value: '', text: '请选择楼栋'}];
                    result.data.forEach(function(building) {
                        options.push({value: building.buildingId, text: building.buildingName});
                    });
                    $.updateCselectOptions(document.querySelector('#buildingIdCselect'), options);
                    if (result.data.length === 1) {
                        var cs = document.querySelector('#buildingIdCselect');
                        cs.dataset.value = result.data[0].buildingId;
                        cs.querySelector('.cselect-val').textContent = result.data[0].buildingName;
                        cs.querySelector('.cselect-val').classList.remove('cselect-placeholder');
                        cs.dispatchEvent(new CustomEvent('cselect:change', {detail: {value: String(result.data[0].buildingId)}}));
                    }
                }
            }, function(result) {
                if (result.msg && result.msg.indexOf('未负责任何楼栋') !== -1) {
                    $.toast('warning', '您暂未负责任何楼栋，请联系管理员');
                }
            });
        }

        /**
         * 加载房间列表
         * @param {number} buildingId - 楼栋ID
         */
        function loadRoomList(buildingId) {
            $.updateCselectOptions(document.querySelector('#roomIdCselect'), [{value: '', text: '加载中...'}]);

            $.ajaxRequest('/dorm/room/building/' + buildingId, 'GET', null, function(result) {
                if (result.data) {
                    var options = [{value: '', text: '请选择房间'}];
                    result.data.forEach(function(room) {
                        options.push({value: room.roomId, text: room.roomNo + ' (' + room.roomTypeText + ')'});
                    });
                    $.updateCselectOptions(document.querySelector('#roomIdCselect'), options);
                }
            });
        }

        /**
         * 加载床位列表
         * @param {number} roomId - 房间ID
         */
        function loadBedList(roomId) {
            var $container = $('#bedListContainer');
            $container.html('<div class="text-center py-4">加载中...</div>');

            $.ajaxRequest('/dorm/bed/room/' + roomId, 'GET', null, function(result) {
                if (result.data && result.data.length > 0) {
                    renderBedList(result.data);
                } else {
                    $container.html('<div class="text-center py-4 text-muted">该房间暂无床位</div>');
                }
            }, function() {
                $container.html('<div class="text-center py-4"><a href="javascript:void(0)" onclick="loadBedList(' + roomId + ')" class="error-retry-link">加载失败，点击重试</a></div>');
            });
        }

        /**
         * 渲染床位列表
         * @param {Array} bedList - 床位列表
         */
        function renderBedList(bedList) {
            var $container = $('#bedListContainer');
            var html = '<div class="data-panel"><table >';
            html += '<thead><tr>';
            html += '<th>床位编号</th>';
            html += '<th>状态</th>';
            html += '<th>入住学生</th>';
            html += '<th>备注</th>';
            html += '</tr></thead>';
            html += '<tbody>';

            bedList.forEach(function(bed) {
                var statusPill = getStatusPill(bed.bedStatus);
                html += '<tr>';
                html += '<td>' + (bed.bedNo || '-') + '</td>';
                html += '<td>' + statusPill + '</td>';
                html += '<td>' + (bed.studentName || '-') + '</td>';
                html += '<td>' + (bed.remark || '-') + '</td>';
                html += '</tr>';
            });

            html += '</tbody></table></div>';
            $container.html(html);
        }

        /**
         * 获取状态标签
         * @param {number} status - 床位状态
         * @returns {string} 状态标签HTML
         */
        function getStatusPill(status) {
            var map = {
                0: '<span class="pill pill-active">空闲</span>',
                1: '<span class="pill pill-done">已入住</span>',
                2: '<span class="pill pill-pending">维修禁用</span>'
            };
            return map[status] || '<span class="pill pill-quiet">未知</span>';
        }
    </script>
</body>
</html>
