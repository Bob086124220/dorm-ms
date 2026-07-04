<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>房间管理 - 高校公寓管理系统</title>
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
                        <h1>房间管理</h1>
                        <p class="page-meta">管理公寓房间信息</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/room/addPage" class="btn btn-primary">
                        <svg width="16" height="16"><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-plus"/></svg>
                        新增房间
                    </a>
                </div>

                <div class="filter-bar">
                    <div class="filter-field">
                        <label>所属楼栋</label>
                        <div class="cselect" id="searchBuildingIdCselect">
                            <div class="cselect-trigger" tabindex="0" aria-haspopup="listbox" aria-expanded="false">
                                <span class="cselect-val cselect-placeholder">全部楼栋</span>
                                <svg class="cselect-arrow" viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="1.6" fill="none" stroke-linecap="round" stroke-linejoin="round">
                                    <polyline points="6 9 12 15 18 9"></polyline>
                                </svg>
                            </div>
                            <div class="cselect-panel" role="listbox">
                                <div class="cselect-option selected" data-value="">全部楼栋</div>
                            </div>
                        </div>
                    </div>
                    <div class="filter-field">
                        <label>房间编号</label>
                        <input type="text" id="searchRoomNo" placeholder="请输入房间号">
                    </div>
                    <div class="filter-field">
                        <label>楼层</label>
                        <input type="number" id="searchFloorNum" placeholder="楼层" min="1">
                    </div>
                    <div class="filter-field">
                        <label>房间类型</label>
                        <div class="cselect" id="searchRoomTypeCselect">
                            <div class="cselect-trigger" tabindex="0" aria-haspopup="listbox" aria-expanded="false">
                                <span class="cselect-val cselect-placeholder">全部</span>
                                <svg class="cselect-arrow" viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="1.6" fill="none" stroke-linecap="round" stroke-linejoin="round">
                                    <polyline points="6 9 12 15 18 9"></polyline>
                                </svg>
                            </div>
                            <div class="cselect-panel" role="listbox">
                                <div class="cselect-option selected" data-value="">全部</div>
                                <div class="cselect-option" data-value="1">四人间</div>
                                <div class="cselect-option" data-value="2">六人间</div>
                                <div class="cselect-option" data-value="3">八人间</div>
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
                                <th>房间编号</th>
                                <th>所属楼栋</th>
                                <th>楼层</th>
                                <th>房间类型</th>
                                <th>额定床位</th>
                                <th>已入住</th>
                                <th>备注</th>
                                <th class="col-actions">操作</th>
                            </tr>
                        </thead>
                        <tbody id="tableBody">
                            <tr><td colspan="8" class="text-center" style="padding: 40px 0; color: var(--muted);">加载中...</td></tr>
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
            loadBuildingList();
            loadData(pageQueryParams);
        });

        /**
         * 加载楼栋列表
         */
        function loadBuildingList() {
            $.ajaxRequest('/admin/building/page', 'GET', {pageSize: 100}, function(result) {
                if (result.data && result.data.list) {
                    var options = [{value: '', text: '全部楼栋'}];
                    result.data.list.forEach(function(building) {
                        options.push({value: building.buildingId, text: building.buildingName});
                    });
                    $.updateCselectOptions(
                        document.querySelector('#searchBuildingIdCselect'),
                        options
                    );
                }
            });
        }

        /**
         * 加载数据
         * @param {object} params - 查询参数
         */
        function loadData(params) {
            var queryParams = $.extend({}, params, {
                buildingId: (document.querySelector('#searchBuildingIdCselect') || {dataset:{}}).dataset?.value ?? null,
                roomNo: $('#searchRoomNo').val().trim(),
                floorNum: $('#searchFloorNum').val() || null,
                roomType: (document.querySelector('#searchRoomTypeCselect') || {dataset:{}}).dataset?.value ?? null
            });

            $.ajaxRequest('/admin/room/page', 'GET', queryParams, function(result) {
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
                $('#tableBody').html('<tr><td colspan="8" class="text-center" style="padding: 40px 0;"><a href="javascript:void(0)" onclick="loadData(pageQueryParams)" class="error-retry-link">加载失败，点击重试</a></td></tr>');
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
                $tbody.html('<tr><td colspan="8" class="text-center" style="padding: 40px 0; color: var(--muted);"><svg width="32" height="32" style="color: var(--border); margin: 0 auto 8px; display: block;"><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-inbox"/></svg>暂无数据</td></tr>');
                return;
            }

            list.forEach(function(item) {
                var roomTypeText = getRoomTypeText(item.roomType);
                var row = '<tr>';
                row += '<td>' + (item.roomNo || '-') + '</td>';
                row += '<td>' + (item.buildingName || '-') + '</td>';
                row += '<td>' + (item.floorNum || '-') + '</td>';
                row += '<td>' + roomTypeText + '</td>';
                row += '<td>' + (item.bedTotal || '-') + '</td>';
                row += '<td>' + (item.bedUsed || 0) + '</td>';
                row += '<td class="text-muted">' + (item.remark || '-') + '</td>';
                row += '<td class="actions">';
                row += '<a href="${pageContext.request.contextPath}/admin/room/editPage?roomId=' + item.roomId + '" class="btn btn-ghost btn-sm">编辑</a>';
                row += '<button class="btn btn-ghost btn-sm" onclick="deleteRoom(' + item.roomId + ')">删除</button>';
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
            // 重置楼栋下拉框
            loadBuildingList();
            // 重置房间类型下拉框
            $.updateCselectOptions(
                document.querySelector('#searchRoomTypeCselect'),
                [
                    {value: '', text: '全部', selected: true},
                    {value: '1', text: '四人间'},
                    {value: '2', text: '六人间'},
                    {value: '3', text: '八人间'}
                ]
            );
            // 重置文本输入
            $('#searchRoomNo').val('');
            $('#searchFloorNum').val('');
            search();
        }

        /**
         * 删除房间
         * @param {number} roomId - 房间ID
         */
        function deleteRoom(roomId) {
            $.confirm('确定删除该房间吗？', function() {
                $.ajaxRequest('/admin/room/delete/' + roomId, 'POST', null, function(result) {
                    $.toast('success', '删除成功');
                    loadData(pageQueryParams);
                }, function(result) {
                    $.toast('error', result.msg || '删除失败');
                });
            });
        }

        /**
         * 获取房间类型文本
         * @param {number} roomType - 房间类型
         * @returns {string} 房间类型文本
         */
        function getRoomTypeText(roomType) {
            var typeMap = {1: '四人间', 2: '六人间', 3: '八人间'};
            return typeMap[roomType] || '-';
        }
    </script>
</body>
</html>
