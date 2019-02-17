<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <script src="${pageContext.request.contextPath}/js/jquery.js">
    </script>
    <script>
        function getall(vl) {
            pages =vl;
            $.ajax({
                url:'${pageContext.request.contextPath}/index/admin/GetAllUser',
                type:'post',
                data:{pageNum:vl},
                success:function (data) {
                    window.location.href = '${pageContext.request.contextPath}'+data;
                }
            });
        }
        $(function () {
            var suoyin = ${suoyin};
            $('#'+suoyin).addClass('mdui-list-item-active');
            $('#'+suoyin).parent().parent().addClass('mdui-collapse-item-open');
        });
    </script>
</head>
<div class="mdui-drawer" id="main-drawer">
    <div class="mdui-list" mdui-collapse="{accordion: true}" style="margin-bottom: 76px;">
        <div class="mdui-collapse-item">
            <div class="mdui-collapse-item-header mdui-list-item mdui-ripple">
                <i class="mdui-list-item-icon mdui-icon material-icons mdui-text-color-theme">&#xe88e;</i>
                <div class="mdui-list-item-content">个人相关</div>
                <i class="mdui-collapse-item-arrow mdui-icon material-icons">keyboard_arrow_down</i>
            </div>
            <div class="mdui-collapse-item-body mdui-list">
                <a id="1" href="/index/show" class="mdui-list-item mdui-ripple">个人信息</a>
                <c:if test="${user.identity == '学生' || user.identity == '教职工'}">
                    <a id="2" href="${pageContext.request.contextPath}/index/loadClassinfo/${user.classNum}&1" class="mdui-list-item mdui-ripple">班级同学信息</a>
                    <a id="3" href="${pageContext.request.contextPath}/index/loadTeacherInfo/${user.classNum}" class="mdui-list-item mdui-ripple ">课程教师信息</a>
                </c:if>
                <c:if test="${user.identity  == '管理员'}">
                    <a id="7" class="mdui-list-item mdui-ripple" onclick="getall(1)">学校人员信息管理</a>
                </c:if>
                <a id="8" href="${pageContext.request.contextPath}/index/message" class="mdui-list-item mdui-ripple">留言板</a>
                <a href="${pageContext.request.contextPath}/index/exitLogin" class="mdui-list-item mdui-ripple">退出登录</a>
            </div>
        </div>

        <div class="mdui-collapse-item ">
            <div class="mdui-collapse-item-header mdui-list-item mdui-ripple">
                <i class="mdui-list-item-icon mdui-icon material-icons mdui-text-color-theme">&#xe916;</i>
                <div class="mdui-list-item-content">课程相关</div>
                <i class="mdui-collapse-item-arrow mdui-icon material-icons">keyboard_arrow_down</i>
            </div>
            <div class="mdui-collapse-item-body mdui-list">
                <c:if test="${user.identity == '学生'}">
                    <a id="4" href="${pageContext.request.contextPath}/index/loadCourseTable/2018&${user.classNum}" class="mdui-list-item mdui-ripple">课程表查询</a>
                </c:if>
                <c:if test="${user.identity == '管理员'}">
                    <a id="4" href="${pageContext.request.contextPath}/index/admin/loadCourseTable/2018" class="mdui-list-item mdui-ripple ">课程表查询</a>
                </c:if>
            </div>
        </div>
        <div class="mdui-collapse-item ">
            <div class="mdui-collapse-item-header mdui-list-item mdui-ripple">
                <i class="mdui-list-item-icon mdui-icon material-icons mdui-text-color-theme">widgets</i>
                <div class="mdui-list-item-content">考务相关</div>
                <i class="mdui-collapse-item-arrow mdui-icon material-icons">keyboard_arrow_down</i>
            </div>
            <div class="mdui-collapse-item-body mdui-list">
                <a id="5" href="${pageContext.request.contextPath}/index/eotashow" class="mdui-list-item mdui-ripple ">考试信息查询</a>
                <c:if test="${user.identity == '管理员'}">
                    <a id="6" href="${pageContext.request.contextPath}/index/admin/eota" class="mdui-list-item mdui-ripple ">公共考务管理</a>
                </c:if>
            </div>
        </div>
    </div>
</div>
</html>
