<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>编辑楼栋 - 高校公寓管理系统</title>
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
                        <span class="page-eyebrow">BUILDING MANAGEMENT</span>
                        <h1>编辑楼栋</h1>
                        <p class="page-meta">修改楼栋信息</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/building/list" class="btn btn-secondary">
                        返回列表
                    </a>
                </div>

                <div class="form-container">
                    <form id="buildingForm" novalidate>
                        <input type="hidden" id="buildingId" name="buildingId">
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
            // 从URL获取buildingId
            var urlParams = new URLSearchParams(window.location.search);
            var buildingId = urlParams.get('buildingId');

            if (!buildingId) {
                $.toast('error', '缺少楼栋ID参数');
                setTimeout(function() {
                    window.location.href = $.buildUrl('/admin/building/list');
                }, 1000);
                return;
            }

            // 加载宿管列表，然后加载楼栋数据
            loadManagerList(function() {
                loadBuildingData(buildingId);
            });

            // 表单验证
            $('#buildingForm').validate({
                rules: {
                    buildingNo: {
                        required: true,
                        maxlength: 20
                    },
                    buildingName: {
                        required: true,
                        maxlength: 50
                    },
                    floorCount: {
                        required: true,
                        min: 1,
                        max: 99,
                        digits: true
                    }
                },
                messages: {
                    buildingNo: {
                        required: '请输入楼栋编号',
                        maxlength: '楼栋编号长度不能超过20个字符'
                    },
                    buildingName: {
                        required: '请输入楼栋名称',
                        maxlength: '楼栋名称长度不能超过50个字符'
                    },
                    floorCount: {
                        required: '请输入楼层总数',
                        min: '楼层总数至少为1',
                        max: '楼层总数不能超过99',
                        digits: '楼层总数必须为整数'
                    }
                },
                submitHandler: function(form) {
                    submitForm();
                }
            });
        });

        /**
         * 加载宿管列表
         * @param {function} callback - 回调函数
         */
        function loadManagerList(callback) {
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
                if (typeof callback === 'function') {
                    callback();
                }
            });
        }

        /**
         * 加载楼栋数据
         * @param {number} buildingId - 楼栋ID
         */
        function loadBuildingData(buildingId) {
            $.ajaxRequest('/admin/building/' + buildingId, 'GET', null, function(result) {
                if (result.data) {
                    var building = result.data;
                    $('#buildingId').val(building.buildingId);
                    $('#buildingNo').val(building.buildingNo);
                    $('#buildingName').val(building.buildingName);
                    $('#floorCount').val(building.floorCount);
                    $('#area').val(building.area || '');
                    $('#remark').val(building.remark || '');

                    // 设置负责宿管 cselect
                    if (building.managerId) {
                        var managerEl = document.querySelector('#managerIdCselect');
                        managerEl.dataset.value = building.managerId;
                        // 查找对应的宿管名称
                        var panel = managerEl.querySelector('.cselect-panel');
                        var selectedOpt = panel.querySelector('.cselect-option[data-value="' + building.managerId + '"]');
                        if (selectedOpt) {
                            managerEl.querySelector('.cselect-val').textContent = selectedOpt.textContent;
                            managerEl.querySelector('.cselect-val').classList.remove('cselect-placeholder');
                        }
                    }
                }
            }, function() {
                $.toast('error', '加载楼栋数据失败');
                setTimeout(function() {
                    window.location.href = $.buildUrl('/admin/building/list');
                }, 1000);
            });
        }

        /**
         * 提交表单
         */
        function submitForm() {
            var formData = {
                buildingId: parseInt($('#buildingId').val()),
                buildingNo: $('#buildingNo').val().trim(),
                buildingName: $('#buildingName').val().trim(),
                floorCount: parseInt($('#floorCount').val()),
                area: $('#area').val().trim() || null,
                managerId: document.querySelector('#managerIdCselect').dataset.value ? parseInt(document.querySelector('#managerIdCselect').dataset.value) : null,
                remark: $('#remark').val().trim() || null
            };

            $('#btnSubmit').prop('disabled', true).text('保存中...');

            $.ajaxRequest('/admin/building/update', 'POST', formData, function(result) {
                $.toast('success', '楼栋信息更新成功');
                setTimeout(function() {
                    window.location.href = $.buildUrl('/admin/building/list');
                }, 1000);
            }, function(result) {
                $.toast('error', result.msg || '更新失败');
                $('#btnSubmit').prop('disabled', false).text('保存');
            });
        }
    </script>
</body>
</html>
