<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- 角色类型常量由 sidebar.jsp 统一定义，header.jsp 不重复定义 -->
<!-- 纸张纹理 — SVG overlay 层，仅覆盖背景，不影响内容交互 -->
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

<!-- 顶部导航栏 -->
<nav class="navbar">
    <!-- 左侧：Logo和标题 -->
    <div class="navbar-brand">
        <a href="${pageContext.request.contextPath}/" class="d-flex align-items-center brand-link">
            <span>寓<span>管理</span></span>
        </a>
        <div class="header-divider"></div>
        <c:choose>
            <c:when test="${sessionScope.loginUser.roleType == ROLE_ADMIN}">
                <span class="header-role">系统管理员</span>
            </c:when>
            <c:when test="${sessionScope.loginUser.roleType == ROLE_DORM}">
                <span class="header-role header-role--secondary">宿管</span>
            </c:when>
            <c:otherwise>
                <span class="header-role header-role--secondary">学生</span>
            </c:otherwise>
        </c:choose>
        <!-- 移动端侧边栏切换按钮 -->
        <button class="navbar-toggler d-md-none">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" width="20" height="20"><line x1="3" y1="12" x2="21" y2="12"/><line x1="3" y1="6" x2="21" y2="6"/><line x1="3" y1="18" x2="21" y2="18"/></svg>
        </button>
    </div>

    <!-- 右侧：用户信息 -->
    <div class="navbar-nav">
        <c:if test="${not empty sessionScope.loginUser}">
            <div class="user-dropdown">
                <div class="user-trigger">
                    <div class="avatar">
                        <c:choose>
                            <c:when test="${not empty sessionScope.loginUser.realName}">
                                ${sessionScope.loginUser.realName.substring(0, 1)}
                            </c:when>
                            <c:otherwise>U</c:otherwise>
                        </c:choose>
                    </div>
                    <span class="user-name">${sessionScope.loginUser.realName}</span>
                    <svg class="chevron"><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-chevron-down"/></svg>
                </div>
                <div class="user-menu">
                    <a href="javascript:void(0)" class="dropdown-item" onclick="showChangePasswordModal(false)">
                        <svg width="16" height="16"><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-key"/></svg> 修改密码
                    </a>
                    <div class="dropdown-divider"></div>
                    <a href="javascript:void(0)" class="dropdown-item btn-logout">
                        <svg width="16" height="16"><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-log-out"/></svg> 退出登录
                    </a>
                </div>
            </div>
        </c:if>
    </div>
</nav>

<!-- 修改密码模态框 -->
<div class="modal fade" id="changePasswordModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h2 class="modal-title">修改密码</h2>
                <button type="button" class="btn-close" data-bs-dismiss="modal" id="btnClosePasswordModal"></button>
            </div>
            <div class="modal-body">
                <div id="forceChangeTip" class="alert alert-warning" style="display: none;">
                    首次登录需要修改密码，请先设置新密码。
                </div>
                <form id="changePasswordForm">
                    <div class="mb-3">
                        <label for="newPassword" class="form-label">新密码</label>
                        <input type="password" class="form-control" id="newPassword" placeholder="请输入新密码（6-20个字符）" maxlength="20">
                        <div class="invalid-feedback" id="newPasswordError"></div>
                    </div>
                    <div class="mb-3">
                        <label for="confirmPassword" class="form-label">确认密码</label>
                        <input type="password" class="form-control" id="confirmPassword" placeholder="请再次输入新密码" maxlength="20">
                        <div class="invalid-feedback" id="confirmPasswordError"></div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" id="btnSubmitPassword">确认修改</button>
            </div>
        </div>
    </div>
</div>
