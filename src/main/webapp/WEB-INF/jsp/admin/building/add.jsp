<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>新增楼栋 - 高校公寓管理系统</title>
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
                        <h1>新增楼栋</h1>
                        <p class="page-meta">创建新的楼栋信息</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/building/list" class="btn btn-secondary">返回列表</a>
                </div>

                <div class="form-container">
                    <form id="buildingForm" novalidate>
                        <div class="form-grid">
                            <div class="form-field">
                                <label>楼栋编号 <span class="required">*</span></label>
                                <input type="text" class="form-control" id="buildingNo" name="buildingNo" placeholder="如：1号楼" maxlength="20">
                            </div>
                            <div class="form-field">
                                <label>楼栋名称 <span class="required">*</span></label>
                                <input type="text" class="form-control" id="buildingName" name="buildingName" placeholder="如：东区1号学生公寓" maxlength="50">
                            </div>
                            <div class="form-field">
                                <label>楼层总数 <span class="required">*</span></label>
                                <input type="number" class="form-control" id="floorCount" name="floorCount" placeholder="请输入楼层总数" min="1" max="99">
                            </div>
                            <div class="form-field">
                                <label>所属区域</label>
                                <input type="text" class="form-control" id="area" name="area" placeholder="如：东区" maxlength="20">
                            </div>
                            <div class="form-field">
                                <label>负责宿管</label>
                                <div class="cselect" id="managerIdCselect">
                                    <div class="cselect-trigger" tabindex="0" aria-haspopup="listbox" aria-expanded="false">
                                        <span class="cselect-val cselect-placeholder">请选择宿管</span>
                                        <svg class="cselect-arrow" viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="1.6" fill="none" stroke-linecap="round" stroke-linejoin="round">
                                            <polyline points="6 9 12 15 18 9"></polyline>
                                        </svg>
                                    </div>
                                    <div class="cselect-panel" role="listbox">
                                        <div class="cselect-option" data-value="">请选择宿管</div>
                                    </div>
                                </div>
                            </div>
                            <div class="form-field">
                                <label>备注</label>
                                <input type="text" class="form-control" id="remark" name="remark" placeholder="如：男生公寓" maxlength="100">
                            </div>
                        </div>

                        <div style="margin-top: var(--gap-lg); display: flex; gap: var(--gap-sm);">
                            <button type="submit" class="btn btn-primary" id="btnSubmit">保存</button>
                            <a href="${pageContext.request.contextPath}/admin/building/list" class="btn btn-secondary">取消</a>
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
        $(function() {
            $.initCustomSelect();
            loadManagerList();

            $('#buildingForm').validate({
                rules: {
                    buildingNo: { required: true, maxlength: 20 },
                    buildingName: { required: true, maxlength: 50 },
                    floorCount: { required: true, min: 1, max: 99, digits: true }
                },
                messages: {
                    buildingNo: { required: '请输入楼栋编号', maxlength: '编号不超过20个字符' },
                    buildingName: { required: '请输入楼栋名称', maxlength: '名称不超过50个字符' },
                    floorCount: { required: '请输入楼层总数', min: '至少为1', max: '不超过99', digits: '必须为整数' }
                },
                submitHandler: function() { submitForm(); }
            });
        });

        function loadManagerList() {
            $.ajaxRequest('/admin/user/list/2', 'GET', null, function(result) {
                if (result.data) {
                    var options = [{value: '', text: '请选择宿管'}];
                    result.data.forEach(function(user) {
                        options.push({value: user.userId, text: user.realName + ' (' + user.username + ')'});
                    });
                    $.updateCselectOptions(
                        document.querySelector('#managerIdCselect'),
                        options
                    );
                }
            });
        }

        function submitForm() {
            var formData = {
                buildingNo: $('#buildingNo').val().trim(),
                buildingName: $('#buildingName').val().trim(),
                floorCount: parseInt($('#floorCount').val()),
                area: $('#area').val().trim() || null,
                managerId: document.querySelector('#managerIdCselect').dataset.value ? parseInt(document.querySelector('#managerIdCselect').dataset.value) : null,
                remark: $('#remark').val().trim() || null
            };

            $('#btnSubmit').prop('disabled', true).text('保存中...');

            $.ajaxRequest('/admin/building/add', 'POST', formData, function() {
                $.toast('success', '楼栋创建成功');
                setTimeout(function() { window.location.href = $.buildUrl('/admin/building/list'); }, 1000);
            }, function(result) {
                $.toast('error', result.msg || '创建失败');
                $('#btnSubmit').prop('disabled', false).text('保存');
            });
        }
    </script>
</body>
</html>
