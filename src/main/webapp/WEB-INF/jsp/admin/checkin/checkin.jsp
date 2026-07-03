<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>办理入住 - 高校公寓管理系统</title>
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
                        <span class="page-eyebrow">CHECK-IN REGISTRATION</span>
                        <h1>办理入住</h1>
                        <p class="page-meta">为学生分配床位，办理入住手续</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/checkin/list" class="btn btn-secondary">
                        <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="1.6" fill="none" stroke-linecap="round" stroke-linejoin="round"><line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/></svg>
                        返回列表
                    </a>
                </div>

                <!-- 步骤1：选择学生 -->
                <div class="form-container mb-4">
                    <h3 class="detail-section-title">第一步：选择学生</h3>
                    <div class="input-group">
                                <input type="text" class="form-control" id="studentNo" placeholder="请输入学号" maxlength="20">
                                <button type="button" class="btn btn-secondary" onclick="searchStudent()">
                                    <svg viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="1.6" fill="none" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                                    查询
                                </button>
                            </div>
                    <!-- 查询结果列表 -->
                    <div id="studentResult" style="display: none;" class="mt-3">
                        <div class="data-panel">
                            <table>
                                <thead>
                                    <tr>
                                        <th>学号</th>
                                        <th>姓名</th>
                                        <th>年级</th>
                                        <th>专业</th>
                                        <th>操作</th>
                                    </tr>
                                </thead>
                                <tbody id="studentTableBody">
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <!-- 已选学生信息 -->
                    <div id="selectedStudent" style="display: none;" class="mt-3">
                        <div class="alert alert-success d-flex justify-content-between align-items-center">
                            <span>
                                已选学生：<strong id="selectedStudentInfo"></strong>
                                <input type="hidden" id="studentId">
                            </span>
                            <button type="button" class="btn btn-sm btn-secondary" onclick="clearSelectedStudent()">
                                重新选择
                            </button>
                        </div>
                    </div>
                    <!-- 错误提示 -->
                    <div id="studentError" style="display: none;" class="mt-3">
                        <div class="alert alert-danger">
                            <span id="studentErrorMsg"></span>
                        </div>
                    </div>
                </div>

                <!-- 步骤2：选择床位 -->
                <div class="form-container mb-4" id="bedSection" style="display: none;">
                    <h3 class="detail-section-title">第二步：选择床位</h3>
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

                <!-- 步骤3：确认提交 -->
                <div class="form-container mb-4" id="submitSection" style="display: none;">
                    <h3 class="detail-section-title">第三步：确认提交</h3>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="remark">备注</label>
                                <input type="text" class="form-control" id="remark" placeholder="可选填备注信息" maxlength="100">
                            </div>
                        </div>
                    </div>
                    <div class="mt-3">
                        <button type="button" class="btn btn-primary" id="btnSubmit" onclick="submitForm()">
                            确认办理入住
                        </button>
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
        // 选中的学生ID
        var selectedStudentId = null;

        $(function() {
            $.initCustomSelect();
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

            // 学号输入框回车事件
            $('#studentNo').on('keypress', function(e) {
                if (e.which === 13) {
                    e.preventDefault();
                    searchStudent();
                }
            });
        });

        /**
         * 查询学生（支持模糊查询）
         */
        function searchStudent() {
            var studentNo = $('#studentNo').val().trim();
            if (!studentNo) {
                showStudentError('请输入学号');
                return;
            }

            hideStudentInfo();
            hideStudentError();

            $.ajaxRequest('/admin/user/page', 'GET', {
                username: studentNo,
                roleType: 3,
                pageNum: 1,
                pageSize: 10
            }, function(result) {
                if (result.data && result.data.list && result.data.list.length > 0) {
                    // 如果只有一个结果，直接选中
                    if (result.data.list.length === 1) {
                        showStudentInfo(result.data.list[0]);
                    } else {
                        // 多个结果，显示列表供选择
                        showStudentList(result.data.list);
                    }
                } else {
                    showStudentError('未找到学号包含 "' + studentNo + '" 的学生');
                }
            }, function() {
                showStudentError('查询失败，请重试');
            });
        }

        /**
         * 显示学生列表供选择
         * @param {Array} students - 学生列表
         */
        function showStudentList(students) {
            var $tbody = $('#studentTableBody');
            $tbody.empty();

            students.forEach(function(student) {
                var grade = (student.grade || '-').replace(/'/g, "\\'");
                var major = (student.major || '-').replace(/'/g, "\\'");
                var row = '<tr>';
                row += '<td>' + (student.username || '-') + '</td>';
                row += '<td>' + (student.realName || '-') + '</td>';
                row += '<td>' + (student.grade || '-') + '</td>';
                row += '<td>' + (student.major || '-') + '</td>';
                row += '<td><button class="btn btn-ghost btn-sm" onclick="selectStudent(' + student.userId + ', \'' + student.username.replace(/'/g, "\\'") + '\', \'' + student.realName.replace(/'/g, "\\'") + '\', \'' + grade + '\', \'' + major + '\')">选择</button></td>';
                row += '</tr>';
                $tbody.append(row);
            });

            $('#studentError').hide();
            $('#studentResult').show();
            $('#selectedStudent').hide();
            $('#bedSection').hide();
            $('#submitSection').hide();
        }

        /**
         * 从列表中选择学生
         * @param {number} userId - 学生ID
         * @param {string} username - 学号
         * @param {string} realName - 姓名
         * @param {string} grade - 年级
         * @param {string} major - 专业
         */
        function selectStudent(userId, username, realName, grade, major) {
            selectedStudentId = userId;
            $('#studentId').val(userId);
            $('#selectedStudentInfo').text(username + ' - ' + realName);
            $('#selectedStudent').show();
            $('#studentResult').hide();
            $('#bedSection').show();
            $('#submitSection').show();
            $('#studentNo').val('');
            hideStudentError();
        }

        /**
         * 显示学生信息（只有一个结果时直接选中）
         * @param {object} student - 学生信息
         */
        function showStudentInfo(student) {
            selectedStudentId = student.userId;
            $('#studentId').val(student.userId);
            $('#selectedStudentInfo').text(student.username + ' - ' + student.realName);
            $('#selectedStudent').show();
            $('#studentResult').hide();
            $('#bedSection').show();
            $('#submitSection').show();
            $('#studentNo').val('');
            hideStudentError();
        }

        /**
         * 清除已选学生
         */
        function clearSelectedStudent() {
            selectedStudentId = null;
            $('#studentId').val('');
            $('#selectedStudentInfo').text('');
            $('#selectedStudent').hide();
            $('#bedSection').hide();
            $('#submitSection').hide();
        }

        /**
         * 隐藏学生信息
         */
        function hideStudentInfo() {
            selectedStudentId = null;
            $('#studentId').val('');
            $('#selectedStudent').hide();
            $('#studentResult').hide();
            $('#bedSection').hide();
            $('#submitSection').hide();
        }

        /**
         * 显示学生错误
         * @param {string} msg - 错误信息
         */
        function showStudentError(msg) {
            $('#studentErrorMsg').text(msg);
            $('#studentError').show();
            hideStudentInfo();
        }

        /**
         * 隐藏学生错误
         */
        function hideStudentError() {
            $('#studentError').hide();
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
            $.updateCselectOptions(document.querySelector('#roomIdCselect'), [{value: '', text: '加载中...'}]);
            $.updateCselectOptions(document.querySelector('#bedIdCselect'), [{value: '', text: '请先选择房间'}]);

            $.ajaxRequest('/common/room/building/' + buildingId, 'GET', null, function(result) {
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
         * 加载空闲床位
         * @param {number} roomId - 房间ID
         */
        function loadFreeBeds(roomId) {
            $.updateCselectOptions(document.querySelector('#bedIdCselect'), [{value: '', text: '加载中...'}]);

            $.ajaxRequest('/common/bed/free/' + roomId, 'GET', null, function(result) {
                if (result.data) {
                    if (result.data.length === 0) {
                        $.updateCselectOptions(document.querySelector('#bedIdCselect'), [{value: '', text: '该房间无空闲床位'}]);
                    } else {
                        var options = [{value: '', text: '请选择床位'}];
                        result.data.forEach(function(bed) {
                            options.push({value: bed.bedId, text: bed.bedNo});
                        });
                        $.updateCselectOptions(document.querySelector('#bedIdCselect'), options);
                    }
                }
            });
        }

        /**
         * 提交表单
         */
        function submitForm() {
            if (!selectedStudentId) {
                $.toast('warning', '请先查询并选择学生');
                return;
            }

            var bedId = document.querySelector('#bedIdCselect').dataset.value;
            if (!bedId) {
                $.toast('warning', '请选择床位');
                return;
            }

            var formData = {
                studentId: selectedStudentId,
                bedId: parseInt(bedId),
                remark: $('#remark').val().trim() || null
            };

            $('#btnSubmit').prop('disabled', true).text('办理中...');

            $.ajaxRequest('/admin/checkin/checkin', 'POST', formData, function(result) {
                $.toast('success', '入住办理成功');
                setTimeout(function() {
                    window.location.href = $.buildUrl('/admin/checkin/list');
                }, 1000);
            }, function(result) {
                $.toast('error', result.msg || '办理失败');
                $('#btnSubmit').prop('disabled', false).text('确认办理入住');
            });
        }
    </script>
</body>
</html>
