<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>录入晚归 - 高校公寓管理系统</title>
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
                        <span class="page-eyebrow">LATE RETURN LOG</span>
                        <h1>录入晚归</h1>
                        <p class="page-meta">登记学生晚归信息</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/dorm/late-return/list" class="btn btn-secondary">
                        <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="1.6" fill="none" stroke-linecap="round" stroke-linejoin="round"><line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/></svg>
                        返回列表
                    </a>
                </div>

                <!-- 学生查询区域 -->
                <div class="form-container mb-4">
                    <h5 class="mb-3">查询学生</h5>
                    <div class="input-group">
                                <input type="text" class="form-control" id="searchUsername" placeholder="请输入学号查询">
                                <button class="btn btn-secondary" type="button" onclick="searchStudent()">
                                    <svg viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="1.6" fill="none" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                                    查询
                                </button>
                            </div>
                    <!-- 查询结果 -->
                    <div id="studentResult" class="mt-3" style="display: none;">
                        <div class="data-panel">
                            <table>
                                <thead>
                                    <tr>
                                        <th>学号</th>
                                        <th>姓名</th>
                                        <th>性别</th>
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
                    <!-- 已选学生 -->
                    <div id="selectedStudent" class="mt-3" style="display: none;">
                        <div class="alert alert-info d-flex justify-content-between align-items-center">
                            <span>
                                已选学生：<strong id="selectedStudentInfo"></strong>
                                <input type="hidden" id="selectedStudentId">
                            </span>
                            <button type="button" class="btn btn-sm btn-secondary" onclick="clearSelectedStudent()">
                                重新选择
                            </button>
                        </div>
                    </div>
                </div>

                <!-- 晚归信息表单 -->
                <div class="form-container" id="lateReturnForm" style="display: none;">
                    <h5 class="mb-3">晚归信息</h5>
                    <form id="formData">
                        <div class="mb-3">
                            <label for="lateTime" class="form-label">晚归时间 <span class="required">*</span></label>
                            <input type="datetime-local" class="form-control" id="lateTime" name="lateTime">
                            <div class="invalid-feedback" id="lateTimeError"></div>
                        </div>
                        <div class="mb-3">
                            <label for="lateReason" class="form-label">晚归原因</label>
                            <textarea class="form-control" id="lateReason" name="lateReason" rows="3" placeholder="请输入晚归原因（可选）" maxlength="255"></textarea>
                            <div class="form-text">最多255个字符</div>
                        </div>
                        <button type="button" class="btn btn-primary" id="btnSubmit" onclick="submitLateReturn()">
                            保存记录
                        </button>
                    </form>
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
        /**
         * 查询学生
         */
        function searchStudent() {
            var username = $('#searchUsername').val().trim();
            if (!username) {
                $.toast('warning', '请输入学号');
                return;
            }

            $.ajaxRequest('/admin/user/page', 'GET', {
                username: username,
                roleType: 3,
                pageNum: 1,
                pageSize: 10
            }, function(result) {
                if (result.data && result.data.list && result.data.list.length > 0) {
                    if (result.data.list.length === 1) {
                        selectStudent(result.data.list[0].userId, result.data.list[0].username, result.data.list[0].realName);
                    } else {
                        renderStudentTable(result.data.list);
                        $('#studentResult').show();
                    }
                } else {
                    $('#studentResult').show();
                    $('#studentResult').html('<div class="alert alert-warning">未找到学号包含 "' + username + '" 的学生</div>');
                }
            }, function() {
                $.toast('error', '查询学生失败');
            });
        }

        /**
         * 渲染学生查询结果
         * @param {Array} list - 学生列表
         */
        function renderStudentTable(list) {
            var $tbody = $('#studentTableBody');
            $tbody.empty();

            list.forEach(function(student) {
                var genderText = student.gender === 1 ? '男' : (student.gender === 2 ? '女' : '-');
                var row = '<tr>';
                row += '<td>' + (student.username || '-') + '</td>';
                row += '<td>' + (student.realName || '-') + '</td>';
                row += '<td>' + genderText + '</td>';
                row += '<td>' + (student.grade || '-') + '</td>';
                row += '<td>' + (student.major || '-') + '</td>';
                row += '<td><button class="btn btn-ghost btn-sm" onclick="selectStudent(' + student.userId + ', \'' + student.username.replace(/'/g, "\\'") + '\', \'' + student.realName.replace(/'/g, "\\'") + '\')">选择</button></td>';
                row += '</tr>';
                $tbody.append(row);
            });
        }

        /**
         * 选择学生
         * @param {number} userId - 学生ID
         * @param {string} username - 学号
         * @param {string} realName - 姓名
         */
        function selectStudent(userId, username, realName) {
            $('#selectedStudentId').val(userId);
            $('#selectedStudentInfo').text(username + ' - ' + realName);
            $('#selectedStudent').show();
            $('#studentResult').hide();
            $('#lateReturnForm').show();
        }

        /**
         * 清除已选学生
         */
        function clearSelectedStudent() {
            $('#selectedStudentId').val('');
            $('#selectedStudentInfo').text('');
            $('#selectedStudent').hide();
            $('#lateReturnForm').hide();
        }

        /**
         * 提交晚归记录
         */
        function submitLateReturn() {
            var studentId = $('#selectedStudentId').val();
            var lateTime = $('#lateTime').val();
            var lateReason = $('#lateReason').val().trim();

            var isValid = true;

            // 校验学生
            if (!studentId) {
                $.toast('warning', '请先选择学生');
                isValid = false;
            }

            // 校验晚归时间
            if (!lateTime) {
                $('#lateTime').addClass('is-invalid');
                $('#lateTimeError').text('请选择晚归时间');
                isValid = false;
            } else {
                $('#lateTime').removeClass('is-invalid');
                $('#lateTimeError').text('');
            }

            if (!isValid) {
                return;
            }

            // 禁用提交按钮
            $('#btnSubmit').prop('disabled', true).text('提交中...');

            // 格式化lateTime：将 "yyyy-MM-ddTHH:mm" 转换为 "yyyy-MM-dd HH:mm:ss"
            var formattedLateTime = lateTime ? lateTime.replace('T', ' ') + ':00' : null;

            var formData = {
                studentId: parseInt(studentId),
                lateTime: formattedLateTime,
                lateReason: lateReason || null
            };

            $.ajaxRequest('/dorm/late-return/add', 'POST', formData, function(result) {
                $.toast('success', '晚归记录保存成功');
                setTimeout(function() {
                    window.location.href = '${pageContext.request.contextPath}/dorm/late-return/list';
                }, 1500);
            }, function(result) {
                if (result.msg && result.msg.indexOf('无在住记录') !== -1) {
                    $.toast('error', '该学生当前无在住记录');
                } else {
                    $.toast('error', result.msg || '保存失败');
                }
                $('#btnSubmit').prop('disabled', false).text('保存记录');
            });
        }
    </script>
</body>
</html>
