<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>登录 — 高校公寓管理系统</title>
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/static/images/favicon.svg">
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/vendor/bootstrap/css/bootstrap.min.css">
    <!-- 公共CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/tokens.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/login.css">
</head>
<body>

<!-- 纸张纹理 — SVG overlay 层，仅覆盖背景，不影响内容交互（登录页不包含 header.jsp，需单独定义） -->
<svg class="paper-noise-svg" aria-hidden="true"
     style="position:fixed;inset:0;width:100%;height:100%;pointer-events:none;z-index:0;">
  <filter id="paper-grain">
    <feTurbulence type="fractalNoise"
      baseFrequency="0.65"
      numOctaves="5"
      seed="2"
      stitchTiles="stitch" result="noise"/>
    <feColorMatrix type="saturate" values="0" in="noise" result="grey"/>
    <feBlend in="SourceGraphic" in2="grey" mode="soft-light"/>
  </filter>
  <rect width="100%" height="100%" filter="url(#paper-grain)" opacity="0.035"/>
</svg>

<div class="login-card">

    <!-- Logo -->
    <div class="login-logo">
        <div class="login-logo-icon">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">
                <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/>
                <polyline points="9 22 9 12 15 12 15 22"/>
            </svg>
        </div>
        <h1>寓<span>管理</span></h1>
        <p>高校公寓管理系统</p>
    </div>

    <!-- Global Error -->
    <div class="global-error" id="globalError">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/>
        </svg>
        <span id="globalErrorText"></span>
    </div>

    <!-- First Login Notice -->
    <div class="first-login-notice" id="firstLoginNotice" style="display:none;">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/>
        </svg>
        <span>首次登录，请修改初始密码</span>
    </div>

    <!-- Form -->
    <form class="login-form" id="loginForm" novalidate>

        <!-- Username -->
        <div class="field" id="fieldUsername">
            <label for="username">账号</label>
            <div class="field-input-wrap">
                <input class="field-input" type="text" id="username" name="username"
                       placeholder="请输入用户名 / 工号 / 学号" autocomplete="username" autofocus>
            </div>
            <div class="field-error">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/>
                </svg>
                <span>请输入账号</span>
            </div>
        </div>

        <!-- Password -->
        <div class="field" id="fieldPassword">
            <label for="password">密码</label>
            <div class="field-input-wrap">
                <input class="field-input" type="password" id="password" name="password"
                       placeholder="请输入登录密码" autocomplete="current-password">
                <button type="button" class="pwd-toggle" id="pwdToggle" aria-label="显示密码">
                    <svg class="eye-open"><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-eye"/></svg>
                    <svg class="eye-closed" style="display:none;"><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-eye-off"/></svg>
                </button>
            </div>
            <div class="field-error">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/>
                </svg>
                <span>请输入密码</span>
            </div>
        </div>

        <!-- Options -->
        <div class="login-options">
            <label class="remember-check">
                <input type="checkbox" id="rememberMe">
                <span>记住账号</span>
            </label>
            <a href="javascript:void(0)" class="forgot-link" onclick="showForgotPasswordModal()">忘记密码？</a>
        </div>

        <!-- Submit -->
        <button type="submit" class="btn-submit" id="submitBtn">
            <span class="btn-text">登 录</span>
            <span class="btn-spinner">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round">
                    <path d="M12 2v4M12 18v4M4.93 4.93l2.83 2.83M16.24 16.24l2.83 2.83M2 12h4M18 12h4M4.93 19.07l2.83-2.83M16.24 7.76l2.83-2.83"/>
                </svg>
            </span>
        </button>

    </form>

    <!-- Footer -->
    <div class="login-footer">
        <span>&copy; 2026 高校公寓管理系统 &middot; </span>
        <a href="#">SSM 框架</a>
    </div>

</div>

<!-- 忘记密码弹窗 -->
<div class="forgot-overlay" id="forgotOverlay">
    <div class="forgot-modal">
        <div class="forgot-header">
            <h2>重置密码</h2>
            <button class="forgot-close" onclick="closeForgotPasswordModal()">&times;</button>
        </div>
        <div class="forgot-body">
            <div class="forgot-error" id="forgotError"></div>
            <div class="forgot-success" id="forgotSuccess">密码重置成功，请重新登录</div>

            <!-- Step 1: 输入手机号 -->
            <div class="forgot-step" id="forgotStep1">
                <div class="forgot-field-row">
                    <div class="forgot-field">
                        <label for="forgotPhone">手机号</label>
                        <input type="text" id="forgotPhone" placeholder="请输入注册手机号" maxlength="11" inputmode="numeric">
                    </div>
                    <button type="button" class="forgot-send-btn" id="btnSendCode" onclick="sendVerificationCode()">获取验证码</button>
                </div>
            </div>

            <!-- Step 2: 输入验证码 + 新密码 -->
            <div class="forgot-step" id="forgotStep2" style="display:none;">
                <a class="forgot-back" onclick="backToStep1()">&larr; 返回上一步</a>
                <div class="forgot-field">
                    <label for="forgotCode">验证码</label>
                    <input type="text" id="forgotCode" placeholder="请输入6位验证码" maxlength="6" inputmode="numeric">
                </div>
                <div class="forgot-field">
                    <label for="forgotNewPassword">新密码</label>
                    <input type="password" id="forgotNewPassword" placeholder="6-20位" maxlength="20">
                </div>
                <div class="forgot-field">
                    <label for="forgotConfirmPassword">确认密码</label>
                    <input type="password" id="forgotConfirmPassword" placeholder="请再次输入新密码" maxlength="20">
                </div>
                <button type="button" class="forgot-submit" id="btnResetPassword" onclick="doResetPassword()">重置密码</button>
            </div>
        </div>
    </div>
</div>

<!-- jQuery -->
<script src="${pageContext.request.contextPath}/static/js/jquery.min.js"></script>
<!-- 公共JS -->
<script src="${pageContext.request.contextPath}/static/js/common.js"></script>

<script>
    (function() {
        'use strict';

        var form       = document.getElementById('loginForm');
        var username   = document.getElementById('username');
        var password   = document.getElementById('password');
        var submitBtn  = document.getElementById('submitBtn');
        var fieldUser  = document.getElementById('fieldUsername');
        var fieldPwd   = document.getElementById('fieldPassword');
        var globalErr  = document.getElementById('globalError');
        var globalErrT = document.getElementById('globalErrorText');
        var firstNote  = document.getElementById('firstLoginNotice');
        var pwdToggle  = document.getElementById('pwdToggle');
        var rememberMe = document.getElementById('rememberMe');

        // 记住账号：页面加载时从 localStorage 恢复（try-catch 兼容隐私模式）
        try {
            if (localStorage.getItem('rememberedUsername')) {
                username.value = localStorage.getItem('rememberedUsername');
                rememberMe.checked = true;
                username.closest('.field').classList.add('valid');
            }
        } catch (e) { /* localStorage 不可用，跳过 */ }

        // 角色跳转路径映射（保留原后端逻辑）
        var rolePathMap = {
            1: '/admin/index',
            2: '/dorm/index',
            3: '/student/index'
        };

        // 判断是否首次登录
        var needChangePassword = window.needChangePasswordFlag && window.needChangePasswordFlag === 'true';
        if (needChangePassword) {
            showFirstLogin();
        }

        /* Focus/blur 标签变色 */
        [username, password].forEach(function(input) {
            var field = input.closest('.field');
            input.addEventListener('focus', function() {
                field.classList.add('focused');
                field.classList.remove('error');
                hideGlobal();
            });
            input.addEventListener('blur', function() {
                field.classList.remove('focused');
                if (input.value.trim()) {
                    field.classList.add('valid');
                } else {
                    field.classList.remove('valid');
                }
            });
        });

        /* 密码可见切换 */
        pwdToggle.addEventListener('click', function() {
            var isPassword = password.type === 'password';
            password.type = isPassword ? 'text' : 'password';
            this.querySelector('.eye-open').style.display  = isPassword ? 'none' : '';
            this.querySelector('.eye-closed').style.display = isPassword ? '' : 'none';
            this.setAttribute('aria-label', isPassword ? '隐藏密码' : '显示密码');
        });

        /* 表单提交 */
        form.addEventListener('submit', function(e) {
            e.preventDefault();

            var userVal = username.value.trim();
            var pwdVal  = password.value.trim();
            var valid   = true;

            // 清除错误
            fieldUser.classList.remove('error', 'shake');
            fieldPwd.classList.remove('error', 'shake');
            void fieldUser.offsetWidth;

            // 验证用户名
            if (!userVal) {
                fieldUser.classList.add('error');
                fieldUser.classList.remove('valid');
                fieldUser.querySelector('.field-error span').textContent = '请输入账号';
                valid = false;
            }

            // 验证密码
            if (!pwdVal) {
                fieldPwd.classList.add('error');
                fieldPwd.classList.remove('valid');
                fieldPwd.querySelector('.field-error span').textContent = '请输入密码';
                valid = false;
            } else if (pwdVal.length < 6) {
                fieldPwd.classList.add('error');
                fieldPwd.classList.remove('valid');
                fieldPwd.querySelector('.field-error span').textContent = '密码长度不能少于 6 位';
                valid = false;
            }

            if (!valid) {
                shakeCard();
                return;
            }

            // 显示 loading
            submitBtn.classList.add('loading');
            submitBtn.disabled = true;

            // AJAX 登录（保留原后端逻辑：$.ajax 直接调用，不走 $.ajaxRequest 的 401 统一拦截）
            $.ajax({
                url: $.buildUrl('/login'),
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({username: userVal, password: pwdVal}),
                dataType: 'json',
                timeout: 30000,
                success: function(result) {
                    if (result.code === 200) {
                        // 记住账号
                        try {
                            if (rememberMe.checked) {
                                localStorage.setItem('rememberedUsername', userVal);
                            } else {
                                localStorage.removeItem('rememberedUsername');
                            }
                        } catch (e) { /* ignore */ }
                        submitBtn.classList.add('success');
                        submitBtn.querySelector('.btn-text').textContent = '登录成功';
                        setTimeout(function() {
                            var roleType = result.data.roleType;
                            var targetUrl = rolePathMap[roleType] || '/login';
                            window.location.href = $.buildUrl(targetUrl);
                        }, 600);
                    } else {
                        submitBtn.classList.remove('loading');
                        submitBtn.disabled = false;
                        // 后端返回首次登录标记
                        if (result.extra && result.extra.needChangePassword) {
                            showFirstLogin();
                        } else {
                            showGlobal(result.msg || '登录失败');
                        }
                    }
                },
                error: function(xhr) {
                    submitBtn.classList.remove('loading');
                    submitBtn.disabled = false;
                    if (xhr.status === 401) {
                        // 密码错误时清除记住的账号
                        localStorage.removeItem('rememberedUsername');
                        rememberMe.checked = false;
                        try {
                            var result = JSON.parse(xhr.responseText);
                            showGlobal(result.msg || '账号或密码错误');
                            fieldPwd.classList.add('error');
                            fieldPwd.classList.remove('valid');
                            fieldPwd.querySelector('.field-error span').textContent = '密码不正确';
                            fieldPwd.classList.add('shake');
                            setTimeout(function() { fieldPwd.classList.remove('shake'); }, 500);
                        } catch (ex) {
                            showGlobal('账号或密码错误');
                        }
                    } else {
                        showGlobal('登录失败，请稍后重试');
                    }
                }
            });
        });

        /* 卡片 shake 动画 */
        function shakeCard() {
            var card = document.querySelector('.login-card');
            card.classList.remove('shake');
            void card.offsetWidth;
            card.classList.add('shake');
        }

        /* 全局错误 */
        function showGlobal(msg) {
            globalErrT.textContent = msg;
            globalErr.classList.remove('show');
            void globalErr.offsetWidth;
            globalErr.classList.add('show');
        }
        function hideGlobal() {
            globalErr.classList.remove('show');
        }

        /* 首次登录提示 */
        function showFirstLogin() {
            firstNote.style.display = '';
            firstNote.style.maxHeight = '0';
            firstNote.style.opacity = '0';
            firstNote.style.transition = 'max-height 0.3s ease, opacity 0.2s ease';
            void firstNote.offsetWidth;
            firstNote.style.maxHeight = '60px';
            firstNote.style.opacity = '1';
            submitBtn.disabled = false;
            submitBtn.classList.remove('loading', 'success');
            submitBtn.querySelector('.btn-text').textContent = '登 录';
        }

        /* 键盘 Enter 提交 */
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Enter' && !submitBtn.disabled) {
                form.dispatchEvent(new Event('submit'));
            }
        });

        // ==================== 忘记密码 ====================

        var countdownTimer = null;

        window.showForgotPasswordModal = function() {
            resetForgotForm();
            $('#forgotStep1').show();
            $('#forgotStep2').hide();
            $('#forgotSuccess').removeClass('show');
            hideForgotError();
            $('#forgotOverlay').addClass('open');
            setTimeout(function() { $('#forgotPhone').focus(); }, 300);
        };

        window.closeForgotPasswordModal = function() {
            $('#forgotOverlay').removeClass('open');
            resetForgotForm();
        };

        window.sendVerificationCode = function() {
            hideForgotError();
            var phone = $('#forgotPhone').val().trim();
            if (!phone) {
                showForgotError('请输入手机号');
                return;
            }
            if (!/^\d{11}$/.test(phone)) {
                showForgotError('手机号格式不正确');
                return;
            }

            var $btn = $('#btnSendCode');
            $btn.prop('disabled', true).text('发送中...');

            $.ajax({
                url: $.buildUrl('/send-code'),
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({phone: phone}),
                dataType: 'json',
                timeout: 15000,
                success: function(result) {
                    if (result.code === 200) {
                        startCountdown();
                        $('#forgotStep1').hide();
                        $('#forgotStep2').show();
                        $('#forgotCode').focus();
                    } else {
                        showForgotError(result.msg || '发送失败');
                        $btn.prop('disabled', false).text('获取验证码');
                    }
                },
                error: function() {
                    showForgotError('网络错误，请稍后重试');
                    $btn.prop('disabled', false).text('获取验证码');
                }
            });
        };

        window.doResetPassword = function() {
            hideForgotError();
            var phone = $('#forgotPhone').val().trim();
            var code = $('#forgotCode').val().trim();
            var newPwd = $('#forgotNewPassword').val();
            var confirmPwd = $('#forgotConfirmPassword').val();

            if (!code) { showForgotError('请输入验证码'); return; }
            if (!newPwd) { showForgotError('请输入新密码'); return; }
            if (newPwd.length < 6 || newPwd.length > 20) { showForgotError('密码长度6-20位'); return; }
            if (newPwd !== confirmPwd) { showForgotError('两次密码输入不一致'); return; }

            var $btn = $('#btnResetPassword');
            $btn.prop('disabled', true).text('提交中...');

            $.ajax({
                url: $.buildUrl('/reset-password'),
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({
                    phone: phone,
                    code: code,
                    newPassword: newPwd,
                    confirmPassword: confirmPwd
                }),
                dataType: 'json',
                timeout: 15000,
                success: function(result) {
                    if (result.code === 200) {
                        $('#forgotStep2').hide();
                        $('#forgotSuccess').addClass('show');
                        $('#forgotError').removeClass('show');
                        setTimeout(function() {
                            closeForgotPasswordModal();
                        }, 2000);
                    } else {
                        showForgotError(result.msg || '重置失败');
                        $btn.prop('disabled', false).text('重置密码');
                    }
                },
                error: function() {
                    showForgotError('网络错误，请稍后重试');
                    $btn.prop('disabled', false).text('重置密码');
                }
            });
        };

        window.backToStep1 = function() {
            hideForgotError();
            $('#forgotStep2').hide();
            $('#forgotStep1').show();
            stopCountdown();
        };

        function startCountdown() {
            var seconds = 60;
            var $btn = $('#btnSendCode');
            $btn.prop('disabled', true);
            updateCountdownText(seconds);
            countdownTimer = setInterval(function() {
                seconds--;
                if (seconds <= 0) {
                    stopCountdown();
                    $btn.prop('disabled', false).text('获取验证码');
                } else {
                    updateCountdownText(seconds);
                }
            }, 1000);
        }

        function updateCountdownText(s) {
            $('#btnSendCode').text(s + 's 后重发');
        }

        function stopCountdown() {
            if (countdownTimer) {
                clearInterval(countdownTimer);
                countdownTimer = null;
            }
            $('#btnSendCode').prop('disabled', false).text('获取验证码');
        }

        function resetForgotForm() {
            stopCountdown();
            $('#forgotPhone').val('').removeClass('error');
            $('#forgotCode').val('').removeClass('error');
            $('#forgotNewPassword').val('').removeClass('error');
            $('#forgotConfirmPassword').val('').removeClass('error');
            hideForgotError();
            $('#forgotSuccess').removeClass('show');
            $('#forgotError').removeClass('show');
        }

        function showForgotError(msg) {
            $('#forgotError').text(msg).addClass('show');
        }

        function hideForgotError() {
            $('#forgotError').removeClass('show').text('');
        }

        // 点击遮罩关闭
        $('#forgotOverlay').on('click', function(e) {
            if (e.target === this) {
                closeForgotPasswordModal();
            }
        });
    })();
</script>
</body>
</html>
