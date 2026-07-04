<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>房间信息 - 高校公寓管理系统</title>
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/static/images/favicon.svg">
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
                        <span class="page-eyebrow">ROOM INFORMATION</span>
                        <h1>房间信息</h1>
                        <p class="page-meta">查看负责楼栋的房间信息</p>
                    </div>
                </div>

                <!-- 楼栋选择 -->
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
                </div>

                <!-- 房间列表 -->
                <div class="data-panel">
                    <table>
                        <thead>
                            <tr>
                                <th>房间编号</th>
                                <th>楼层</th>
                                <th>房间类型</th>
                                <th>额定床位</th>
                                <th>已入住</th>
                                <th>备注</th>
                            </tr>
                        </thead>
                        <tbody id="tableBody">
                            <tr>
                                <td colspan="6" class="text-center" style="padding: 40px 0; color: var(--muted);">
                                    <svg width="32" height="32" style="color: var(--border); margin: 0 auto 8px; display: block;"><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-info"/></svg>
                                    请先选择楼栋
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <div id="paginationContainer"></div>
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
        var currentBuildingId = null;
        var pageQueryParams = { pageNum: 1, pageSize: 10 };

        $(function() {
            $.initCustomSelect();
            loadBuildingList();

            // 楼栋选择变化事件
            document.querySelector('#buildingIdCselect').addEventListener('cselect:change', function(e) {
                var buildingId = e.detail.value;
                if (buildingId) {
                    currentBuildingId = buildingId;
                    loadData(1);
                } else {
                    currentBuildingId = null;
                    $('#tableBody').html('<tr><td colspan="6" class="text-center" style="padding: 40px 0; color: var(--muted);"><svg width="32" height="32" style="color: var(--border); margin: 0 auto 8px; display: block;"><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-info"/></svg>请先选择楼栋</td></tr>');
                    $('#paginationContainer').empty();
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
                    // 如果只有一个楼栋，自动选中
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
         * 分页加载房间列表
         * @param {number} pageNum - 页码
         */
        function loadData(pageNum) {
            if (!currentBuildingId) return;
            pageQueryParams.pageNum = pageNum;
            var queryParams = {
                buildingId: currentBuildingId,
                pageNum: pageNum,
                pageSize: pageQueryParams.pageSize
            };

            var $tbody = $('#tableBody');
            $tbody.html('<tr><td colspan="6" class="text-center" style="padding: 40px 0; color: var(--muted);"><svg width="32" height="32" style="color: var(--border); margin: 0 auto 8px; display: block;"><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-clock"/></svg>加载中...</td></tr>');

            $.ajaxRequest('/dorm/room/page', 'GET', queryParams, function(result) {
                if (result.data) {
                    renderTable(result.data.list);
                    $.renderPagination(result.data, 'paginationContainer', function(page) {
                        loadData(page);
                    });
                }
            }, function() {
                $tbody.html('<tr><td colspan="6" class="text-center" style="padding: 40px 0;"><a href="javascript:void(0)" onclick="loadData(pageQueryParams.pageNum)" class="error-retry-link">加载失败，点击重试</a></td></tr>');
            });
        }

        /**
         * 渲染表格
         * @param {Array} list - 房间列表
         */
        function renderTable(list) {
            var $tbody = $('#tableBody');
            $tbody.empty();

            if (!list || list.length === 0) {
                $tbody.html('<tr><td colspan="6" class="text-center" style="padding: 40px 0; color: var(--muted);"><svg width="32" height="32" style="color: var(--border); margin: 0 auto 8px; display: block;"><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-inbox"/></svg>暂无房间数据</td></tr>');
                return;
            }

            list.forEach(function(room) {
                var row = '<tr>';
                row += '<td>' + (room.roomNo || '-') + '</td>';
                row += '<td>' + (room.floorNum || '-') + '</td>';
                row += '<td>' + (room.roomTypeText || '-') + '</td>';
                row += '<td class="num">' + (room.bedTotal || '-') + '</td>';
                row += '<td class="num">' + (room.bedUsed || 0) + '</td>';
                row += '<td>' + (room.remark || '-') + '</td>';
                row += '</tr>';
                $tbody.append(row);
            });
        }
    </script>
</body>
</html>
