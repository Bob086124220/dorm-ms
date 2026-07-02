/**
 * 高校公寓管理系统 - 导航栏功能
 * 说明：修改密码模态框、首次登录强制修改等功能
 */

/**
 * 显示修改密码模态框
 * @param {boolean} forceChange - 是否强制修改（首次登录）
 */
function showChangePasswordModal(forceChange) {
    // 清空表单
    $('#newPassword').val('').removeClass('is-invalid');
    $('#confirmPassword').val('').removeClass('is-invalid');
    $('#newPasswordError').text('');
    $('#confirmPasswordError').text('');

    if (forceChange) {
        // 首次登录强制修改：禁止关闭，显示提示
        $('#forceChangeTip').show();
        $('#btnClosePasswordModal').hide();
        $('#changePasswordModal').off('hide.bs.modal').on('hide.bs.modal', function(e) {
            e.preventDefault();
            $.toast('warning', '请先修改密码后再使用系统');
        });
    } else {
        // 普通修改：允许关闭
        $('#forceChangeTip').hide();
        $('#btnClosePasswordModal').show();
        $('#changePasswordModal').off('hide.bs.modal');
    }

    // 显示模态框
    // 使用 Bootstrap 原生 API——jQuery 的 .modal('dispose') 在 Edge 中
    // 对未初始化实例调用 getInstance() 返回 null 后访问 .dispose() 抛出 TypeError
    var modalEl = document.getElementById('changePasswordModal');
    var existing = bootstrap.Modal.getInstance(modalEl);
    if (existing) { existing.dispose(); }
    var modal = new bootstrap.Modal(modalEl, {
        backdrop: forceChange ? 'static' : true,
        keyboard: !forceChange
    });
    modal.show();
}

$(function() {
    // 判断是否需要强制修改密码
    var needChangePassword = window.needChangePasswordFlag || 'false';
    if (needChangePassword === 'true') {
        showChangePasswordModal(true);
    }

    // 提交修改密码
    $('#btnSubmitPassword').on('click', function() {
        var newPassword = $('#newPassword').val().trim();
        var confirmPassword = $('#confirmPassword').val().trim();
        var isValid = true;

        // 校验新密码
        if (!newPassword) {
            $('#newPassword').addClass('is-invalid');
            $('#newPasswordError').text('请输入新密码');
            isValid = false;
        } else if (newPassword.length < 6 || newPassword.length > 20) {
            $('#newPassword').addClass('is-invalid');
            $('#newPasswordError').text('密码长度必须在6-20个字符之间');
            isValid = false;
        } else {
            $('#newPassword').removeClass('is-invalid');
            $('#newPasswordError').text('');
        }

        // 校验确认密码
        if (!confirmPassword) {
            $('#confirmPassword').addClass('is-invalid');
            $('#confirmPasswordError').text('请再次输入新密码');
            isValid = false;
        } else if (newPassword !== confirmPassword) {
            $('#confirmPassword').addClass('is-invalid');
            $('#confirmPasswordError').text('两次输入的密码不一致');
            isValid = false;
        } else {
            $('#confirmPassword').removeClass('is-invalid');
            $('#confirmPasswordError').text('');
        }

        if (!isValid) {
            return;
        }

        // 禁用提交按钮，防止重复提交
        $('#btnSubmitPassword').prop('disabled', true).text('提交中...');

        $.ajaxRequest('/updatePassword', 'POST', {
            newPassword: newPassword,
            confirmPassword: confirmPassword
        }, function(result) {
            $.toast('success', '密码修改成功，请重新登录');
            // 移除强制关闭限制
            $('#changePasswordModal').off('hide.bs.modal');
            $('#changePasswordModal').modal('hide');
            setTimeout(function() {
                window.location.href = $.buildUrl('/login');
            }, 1500);
        }, function(result) {
            $.toast('error', result.msg || '修改密码失败');
            $('#btnSubmitPassword').prop('disabled', false).text('确认修改');
        });
    });
});
