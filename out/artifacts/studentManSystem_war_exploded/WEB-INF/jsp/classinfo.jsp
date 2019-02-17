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
    <script>
        function init() {
                setTimeout(function () {
                    $("#loading").css("opacity","0");

                    $("#loadingback").css("opacity","0");
                    setTimeout(function () {
                        $("#loading").remove();
                        $("#loadingback").remove();
                    },300);
                },300);
                if(6 < ${pageinfo.pageNum}){
                    $("#page_btn").find("a").eq(6).addClass("mdui-color-theme");
                }else {
                    $("#page_btn").find("a").eq(${pageinfo.pageNum}-1).addClass("mdui-color-theme");
                }
                <c:if test="${classinfo == [] || classinfo == ''}">
                mdui.snackbar({
                    message: '没有班级同学信息，请等待管理员导入！',
                    timeout: '2000',
                    position: 'bottom',
                });
                setTimeout(function () {
                    window.history.back(-1);
                },2000)
                </c:if>
        }

        $(function () {
            $("#mod_btn").click(function () {
                $("#img_class").hide();
                $("#item_class").show();
            });
            $("#list_btn").click(function () {
               $("#img_class").show();
               $("#item_class").hide();
            });
            $("#skip_page_btn").click(function () {
                var l = ${pageinfo.pages};
                if($("#skip_page").val() == ""){
                    mdui.snackbar({
                        message: '跳转页面不可输入为空！',
                        timeout: '2000',
                        position: 'bottom',
                    });
                }else if($("#skip_page").val() > l){
                    mdui.snackbar({
                        message: '跳转页面不可大于总页数！',
                        timeout: '2000',
                        position: 'bottom',
                    });
                }else {
                    var p = '${pageContext.request.contextPath}/index/loadClassinfo/${user.classNum}&';
                    var j = p + $("#skip_page").val().toString();
                    window.location.href = j;
                }
            });
        });
        function search(vv) {
            $(".changestyle").each(function()
            {
                var xx=$(this).html();
                $(this).replaceWith(xx);
            });
            var str = $("#img_class_all").html();
            var val = vv.value;
            if($.trim(val) != ""){
                var re=val;
                var nn = str.replace(new RegExp(val,"gm"),re);
                $("#img_class_all").html(nn);
                $("#img_class").hide();
                $("#img_class_all").show();
                $("#img_class_all").find(".mdui-col-sm-6").hide().filter(":contains('"+val+"')").show();
            }else {
                $(".mdui-col-sm-6").show();
                $("#img_class").show();
                $("#img_class_all").hide();
            }
        }
        function moreinfo(r_userName,headIco,userName,sex,age,email,peoNum,signed) {
            var inst = new mdui.Dialog('#info_card');
            var ico = "";
            if(headIco != ""){
                ico = headIco.slice(4);
                ico = "/img/"+ico;
            }else {
                if(sex == "男"){
                    ico = "${pageContext.request.contextPath}/img/boy.jpg";
                }else {
                    ico = "${pageContext.request.contextPath}/img/girl.jpg"
                }
            }
            $("#info_card").find("img").eq(0).css({"background":"url("+ico+")","height":"430px","backgroun-size":"cover","background-position":"50%"});
            $("#info_card").find("p").eq(0).text("个性昵称：" + r_userName);
            $("#info_card").find("p").eq(1).text("姓名：" + userName)
            $("#info_card").find("p").eq(2).text("性别：" + sex);
            $("#info_card").find("p").eq(3).text("年龄：" + age + "岁");
            $("#info_card").find("p").eq(4).text("学号/工号：" + peoNum );
            $("#info_card").find("p").eq(5).text("邮箱：" + email);
            if(signed == ""){
                $("#info_card").find("p").eq(6).text("个性签名：这个人很懒，没有个性签名");
            }else {
                $("#info_card").find("p").eq(6).text("个性签名："+signed);
            }

            inst.open();

        }
    </script>
    <style type="text/css">
        .changestyle{color: red;}
        .serach_nn{}
    </style>
</head>
<body onload="init()" class="mdui-drawer-body-left mdui-appbar-with-toolbar mdui-theme-primary-indigo mdui-theme-accent-pink">
<%
    session.setAttribute("suoyin",2);
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
    <h1 class="mdui-text-color-theme" style="margin-top: 30px;margin-bottom: 30px">班级学生信息
        <i class="mdui-icon material-icons mdui-btn mdui-btn-icon mdui-ripple mdui-ripple-white" style="float: right" id="mod_btn" mdui-tooltip="{content: '切换详细模式'}">&#xe241;</i>
        <i class="mdui-icon material-icons mdui-btn mdui-btn-icon mdui-ripple mdui-ripple-white" style="float: right" id="list_btn" mdui-tooltip="{content: '切换视图模式'}">&#xe5c3;</i>
    </h1>
    <div class="mdui-textfield mdui-textfield-floating-label">
        <i class="mdui-icon material-icons ">&#xe8b6;</i>
        <label class="mdui-textfield-label">搜索</label>
        <input class="mdui-textfield-input" type="text" id="search_info" name="search_info" onchange="search(this)"/>
    </div>
    <div class="mdui-row" id="img_class">
        <c:forEach items="${classinfopage}" var="each">
            <div class="mdui-col-sm-6 mdui-col-md-3 mdui-ripple mdui-ripple-white" style="margin-bottom: 20px;" onclick="moreinfo('${each.r_userName}','${each.headIco}','${each.userName}','${each.sex}','${each.age}','${each.email}','${each.peoNum}','${each.signed}')">
                <div class="mdui-card mdui-shadow-9">
                    <div class="mdui-card-media">
                        <c:if test="${each.headIco == null || each.headIco == '' || each.headIco == 'unknown'}">
                            <c:if test="${each.sex == '女'}">
                                <img style="background: url('${pageContext.request.contextPath}/img/girl.jpg');width:100%;height:252px;background-size:cover;background-position:50%;"/>
                            </c:if>
                            <c:if test="${each.sex == '男'}">
                                <img style="background: url('${pageContext.request.contextPath}/img/boy.jpg');width:100%;height:252px;background-size:cover;background-position:50%;"/>
                            </c:if>
                        </c:if>
                        <c:if test="${each.headIco != null}">
                            <img style="background: url('${pageContext.request.contextPath}${each.headIco}');width:100%;height: 252px;background-size:cover;background-position:50%;"/>
                        </c:if>

                        <div class="mdui-card-media-covered">
                            <div class="mdui-card-primary">
                                <div class="mdui-card-primary-title">${each.userName}    ${each.sex}</div>
                                <div class="mdui-card-primary-subtitle">
                                        <c:if test="${each.signed == null || each.signed == ''}">
                                            这个人很懒，没有个性签名

                                        </c:if>
                                        <c:if test="${each.signed != null}">
                                            个性签名：${each.signed}
                                        </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
    <div class="mdui-row" id="img_class_all" style="display: none;">
        <c:forEach items="${classinfo}" var="each">
            <div class="mdui-col-sm-6 mdui-col-md-3 mdui-ripple mdui-ripple-white" style="margin-bottom: 20px;" onclick="moreinfo('${each.r_userName}','${each.headIco}','${each.userName}','${each.sex}','${each.age}','${each.email}','${each.peoNum}','${each.signed}')">
                <div class="mdui-card mdui-shadow-9">
                    <div class="mdui-card-media">
                        <c:if test="${each.headIco == null || each.headIco == '' || each.headIco == 'unknown'}">
                            <c:if test="${each.sex == '女'}">
                                <img style="background: url('${pageContext.request.contextPath}/img/girl.jpg');width:100%;height:252px;background-size:cover;background-position:50%;"/>
                            </c:if>
                            <c:if test="${each.sex == '男'}">
                                <img style="background: url('${pageContext.request.contextPath}/img/boy.jpg');width:100%;height:252px;background-size:cover;background-position:50%;"/>
                            </c:if>
                        </c:if>
                        <c:if test="${each.headIco != null}">
                            <img style="background: url('${pageContext.request.contextPath}${each.headIco}');width:100%;height: 252px;background-size:cover;background-position:50%;"/>
                        </c:if>

                        <div class="mdui-card-media-covered">
                            <div class="mdui-card-primary">
                                <div class="mdui-card-primary-title">${each.userName}    ${each.sex}</div>
                                <div class="mdui-card-primary-subtitle">
                                    <c:if test="${each.signed == null || each.signed == ''}">
                                        这个人很懒，没有个性签名
                                    </c:if>
                                    <c:if test="${each.signed != null}">
                                        个性签名：${each.signed}
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
    <div id="page_btn" style="text-align: center;width: 100%">
        <c:forEach var="i" begin="1" end="${pageinfo.pages}" step="1">
            <c:if test="${i < 6}">
                <a style="min-width: 20px" class="mdui-btn mdui-ripple" href='${pageContext.request.contextPath}/index/loadClassinfo/${user.classNum}&<c:out value="${i}"></c:out>'>${i}</a>
            </c:if>
        </c:forEach>
        <c:if test="${pageinfo.pages > 6}">
            ... <a style="min-width: 20px" class="mdui-btn mdui-ripple" href='${pageContext.request.contextPath}/index/loadClassinfo/${user.classNum}&<c:out value="${pageinfo.pages}"></c:out>'>${pageinfo.pages}</a>
            <center><input class="mdui-textfield-input" id="skip_page" style="width: 100px" type="text" onkeyup="(this.v=function(){this.value=this.value.replace(/[^0-9-]+/,'');}).call(this)" onblur="this.v();"></center>
            <button class="mdui-btn mdui-ripple-white mdui-color-theme" id="skip_page_btn">跳转</button>
        </c:if>
    </div>
</div>

<jsp:include page="theme.jsp"/>
<jsp:include page="bottom.jsp"/>
<div class="mdui-dialog" id="info_card" >
    <div class="mdui-dialog-content" style="height: 400px;padding: 0px">
    <div class="mdui-row">
        <div class="mdui-col-sm-5 mdui-col-md-5" style="padding: 0px;">
        <div class="mdui-card">
            <div class="mdui-card-media">
                <img>
            </div>
        </div>
        </div>

            <div class="mdui-col-sm-7 mdui-col-md-7">

                <div class="mdui-card mdui-shadow-0">
                    <h1 class="mdui-text-color-theme-accent mdui-ripple" style=" margin-top: 30px;margin-left: 10px;">
                        <i class="mdui-icon material-icons mdui-text-color-theme-accent">&#xe86e;</i>
                        详细信息</h1>
                    <div class="mdui-typo" style="padding-left: 1em">
                        <blockquote>
                            <p>个性昵称：    姓名：    </p>
                            <p>性别：    年龄：</p>
                            <p>性别：    年龄：</p>
                            <p>班级：   学号/工号：</p>
                            <p>班级：   学号/工号：</p>
                            <p>身份：    邮箱：</p>
                            <p>身份：    邮箱：</p>
                        </blockquote>
                    </div>
                </div>
            </div>
            </div>
        <div class="mdui-divider"></div>
    </div>
</div>
</div>
</body>
</html>
