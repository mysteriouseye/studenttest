<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-cmn-Hans">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0,maximum-scale=1.0, user-scalable=no"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
    <meta name="renderer" content="webkit">
    <meta http-equiv="Cache-Control" content="no-siteapp"/>
    <title>学生信息管理系统</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/mdui.min.css"/>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/index.css">
    <script src="${pageContext.request.contextPath}/js/smooth-scroll.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/holder.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/mdui.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/jquery.js"></script>
    <script src="${pageContext.request.contextPath}/js/security.js"></script>
    <script>var $$ = mdui.JQ;</script>
    <script src="${pageContext.request.contextPath}/js/index.js"></script>
    <script src="${pageContext.request.contextPath}/js/jquery.form.js"></script>
    <script>
        function init() {
            setTimeout(function () {
                $("#loading").css("opacity","0");

                $("#loadingback").css("opacity","0");
                setTimeout(function () {
                    $("#loading").remove();
                    $("#loadingback").remove();
                },300);
            },1000);
            <c:if test="${teacherinfo == [] || teacherinfo == ''}">
                mdui.snackbar({
                    message: '没有教师信息，请等待管理员导入！',
                    timeout: '2000',
                    position: 'bottom',
                });
                setTimeout(function () {
                    window.history.back(-1);
                },2000)
            </c:if>
        }
    </script>
</head>
<body onload="init()" class="mdui-drawer-body-left mdui-appbar-with-toolbar mdui-theme-primary-indigo mdui-theme-accent-pink">
<%
    session.setAttribute("suoyin",3);
%>
<div id="loading" class="spinner">
    <div class="double-bounce1  mdui-color-theme mdui-shadow-9"></div>
    <div class="double-bounce2  mdui-color-theme mdui-shadow-9"></div>
</div>
<div id="loadingback" class="mdui-overlay mdui-overlay-show" style="background-color: white;z-index:9999"></div>
<jsp:include page="header.jsp"/>
<jsp:include page="left.jsp"/>
<a id="anchor-top"></a>
<div class="mdui-container">
    <h1 class="mdui-text-color-theme" style="margin-top: 30px;margin-bottom: 30px">课程老师信息</h1>
    <div class="mdui-row">
        <c:forEach items="${teacherinfo}" var="each">
            <div class="mdui-shadow-9 mdui-card mdui-row" style="margin-bottom: 30px;">
            <div class="mdui-col-sm-6 mdui-col-md-5" style="padding: 0px">
                <div class="mdui-card">
                    <div class="mdui-card-media">
                        <c:if test="${each.headIco == '' || each.headIco == null}">
                            <c:if test="${each.sex == '男'}">
                                <img style="background: url('../../img/manteacher.jpg');width:100%;height:450px;background-size:cover;background-position:50%;">
                            </c:if>
                            <c:if test="${each.sex == '女'}">
                                <img style="background: url('../../img/womanteacher.jpg');width:100%;height:450px;background-size:cover;background-position:50%;">
                            </c:if>
                        </c:if>
                        <c:if test="${each.headIco != '' && each.headIco != null}">
                            <img style="background: url('${each.headIco}');width:100%;height:450px;background-size:cover;background-position:50%;">
                        </c:if>
                    </div>
                </div>
            </div>
            <div class="mdui-col-sm-6 mdui-col-md-7" >
                <div class="mdui-card mdui-shadow-0">
                    <h1 class="mdui-text-color-theme-accent mdui-ripple" style=" margin-top: 30px;margin-left: 10px;">
                        <i class="mdui-icon material-icons mdui-text-color-theme-accent">&#xe86e;</i>
                        ${each.cname}老师</h1>
                    <div class="mdui-typo" style="padding-left: 1em">
                        <blockquote>
                            <p>个性昵称：${each.r_userName}</p>
                            <p>姓名：${each.userName}</p>
                            <p>性别：${each.sex}</p>
                            <p>年龄：${each.age}岁</p>
                            <p>任教班级：${each.classNum}</p>
                            <p>邮箱：${each.email}</p>
                            <p>手机号：${each.phoneNum}</p>
                            <c:if test="${each.signed == '' || each.signed == null}">
                                <p>个性签名：老师可能不大想透露自己，所以没有签名~</p>
                            </c:if>
                            <c:if test="${each.signed != '' && each.signed != null}">
                                <p>个性签名：${each.signed}</p>
                            </c:if>
                        </blockquote>
                    </div>
                </div>
            </div>
            </div>
        </c:forEach>
    </div>
</div>

<jsp:include page="theme.jsp"/>
<jsp:include page="bottom.jsp"/>
</body>
</html>
