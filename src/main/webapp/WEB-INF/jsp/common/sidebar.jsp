<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- 角色类型常量 -->
<c:set var="ROLE_ADMIN" value="1" />
<c:set var="ROLE_DORM" value="2" />
<c:set var="ROLE_STUDENT" value="3" />
<c:set var="roleType" value="${sessionScope.loginUser.roleType}" />
<!-- 侧边栏（学生角色不显示） -->
<c:if test="${roleType != ROLE_STUDENT}">
<aside class="sidebar">
    <nav>
        <ul class="sidebar-menu">
            <%-- 管理员菜单 --%>
            <c:if test="${roleType == ROLE_ADMIN}">
                <li class="sidebar-section">系统管理</li>
                <li class="menu-item">
                    <a href="${pageContext.request.contextPath}/admin/index" class="menu-link">
                        <svg><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-grid"/></svg>
                        <span>系统总览</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="${pageContext.request.contextPath}/admin/user/list" class="menu-link">
                        <svg><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-users"/></svg>
                        <span>用户管理</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="${pageContext.request.contextPath}/admin/log/list" class="menu-link">
                        <svg><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-file-text"/></svg>
                        <span>操作日志</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="${pageContext.request.contextPath}/admin/notice/list" class="menu-link">
                        <svg><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-bell"/></svg>
                        <span>公告管理</span>
                    </a>
                </li>

                <li class="sidebar-section">公寓管理</li>
                <li class="menu-item">
                    <a href="${pageContext.request.contextPath}/admin/building/list" class="menu-link">
                        <svg><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-home"/></svg>
                        <span>楼栋管理</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="${pageContext.request.contextPath}/admin/room/list" class="menu-link">
                        <svg><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-building"/></svg>
                        <span>房间管理</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="${pageContext.request.contextPath}/admin/bed/list" class="menu-link">
                        <svg><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-bed"/></svg>
                        <span>床位管理</span>
                    </a>
                </li>

                <li class="sidebar-section">入住管理</li>
                <li class="menu-item">
                    <a href="${pageContext.request.contextPath}/admin/checkin/list" class="menu-link">
                        <svg><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-user-plus"/></svg>
                        <span>入住登记</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="${pageContext.request.contextPath}/admin/move/list" class="menu-link">
                        <svg><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-clipboard-check"/></svg>
                        <span>调宿管理</span>
                    </a>
                </li>

                <li class="sidebar-section">日常事务</li>
                <li class="menu-item">
                    <a href="${pageContext.request.contextPath}/admin/repair/list" class="menu-link">
                        <svg><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-wrench"/></svg>
                        <span>报修管理</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="${pageContext.request.contextPath}/admin/late-return/list" class="menu-link">
                        <svg><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-clock"/></svg>
                        <span>晚归登记</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="${pageContext.request.contextPath}/admin/visitor/list" class="menu-link">
                        <svg><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-users"/></svg>
                        <span>访客登记</span>
                    </a>
                </li>
            </c:if>

            <%-- 宿管菜单 --%>
            <c:if test="${roleType == ROLE_DORM}">
                <li class="sidebar-section">工作台</li>
                <li class="menu-item">
                    <a href="${pageContext.request.contextPath}/dorm/index" class="menu-link">
                        <svg><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-grid"/></svg>
                        <span>工作台首页</span>
                    </a>
                </li>

                <li class="sidebar-section">公寓信息</li>
                <li class="menu-item">
                    <a href="${pageContext.request.contextPath}/dorm/building/listPage" class="menu-link">
                        <svg><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-home"/></svg>
                        <span>楼栋信息</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="${pageContext.request.contextPath}/dorm/room/listPage" class="menu-link">
                        <svg><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-building"/></svg>
                        <span>房间信息</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="${pageContext.request.contextPath}/dorm/bed/listPage" class="menu-link">
                        <svg><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-bed"/></svg>
                        <span>床位信息</span>
                    </a>
                </li>

                <li class="sidebar-section">入住管理</li>
                <li class="menu-item">
                    <a href="${pageContext.request.contextPath}/dorm/checkin/list" class="menu-link">
                        <svg><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-user-plus"/></svg>
                        <span>入住登记</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="${pageContext.request.contextPath}/dorm/move/list" class="menu-link">
                        <svg><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-clipboard-check"/></svg>
                        <span>调宿审批</span>
                    </a>
                </li>

                <li class="sidebar-section">日常事务</li>
                <li class="menu-item">
                    <a href="${pageContext.request.contextPath}/dorm/repair/list" class="menu-link">
                        <svg><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-wrench"/></svg>
                        <span>报修处理</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="${pageContext.request.contextPath}/dorm/late-return/list" class="menu-link">
                        <svg><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-clock"/></svg>
                        <span>晚归登记</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="${pageContext.request.contextPath}/dorm/visitor/list" class="menu-link">
                        <svg><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-users"/></svg>
                        <span>访客登记</span>
                    </a>
                </li>
            </c:if>

            <%-- 学生菜单 --%>
            <c:if test="${roleType == ROLE_STUDENT}">
                <li class="sidebar-section">个人中心</li>
                <li class="menu-item">
                    <a href="${pageContext.request.contextPath}/student/user/info" class="menu-link">
                        <svg><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-user"/></svg>
                        <span>个人信息</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="javascript:void(0)" class="menu-link" onclick="showChangePasswordModal()">
                        <svg><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-key"/></svg>
                        <span>修改密码</span>
                    </a>
                </li>

                <li class="sidebar-section">住宿管理</li>
                <li class="menu-item">
                    <a href="${pageContext.request.contextPath}/student/checkin/infoPage" class="menu-link">
                        <svg><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-home"/></svg>
                        <span>住宿信息</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="${pageContext.request.contextPath}/student/move/list" class="menu-link">
                        <svg><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-clipboard-check"/></svg>
                        <span>调宿申请</span>
                    </a>
                </li>

                <li class="sidebar-section">日常服务</li>
                <li class="menu-item">
                    <a href="${pageContext.request.contextPath}/student/repair/list" class="menu-link">
                        <svg><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-wrench"/></svg>
                        <span>报修服务</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="${pageContext.request.contextPath}/student/late-return/list" class="menu-link">
                        <svg><use href="${pageContext.request.contextPath}/static/images/icons.svg#icon-clock"/></svg>
                        <span>晚归记录</span>
                    </a>
                </li>
            </c:if>
        </ul>
    </nav>
</aside>
</c:if>
