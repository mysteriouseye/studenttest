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
    <title>学生信息管理系统   -   留言板</title>
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
        }
        $(function () {
            $("#summitmes").click(function () {
               $.ajax({
                 url:'${pageContext.request.contextPath}/index/addNewMessage',
                 type:'post',
                 data:{title:$("#themetitle").val(),message:$("#messagev").val()},
                 success:function (data) {
                     mdui.snackbar({
                         message: data,
                         timeout: '2000',
                         position: 'bottom',
                     });
                     if(data == "提交留言成功，请等待管理员阅读!"){
                         setTimeout(function () {
                             location.reload();
                         },2000)
                     }
                 }
               });
            });
        });
        <c:if test="${user.identity == '管理员'}">
        function passMsgfun(vl,the) {
            $.ajax({
                url:'${pageContext.request.contextPath}/index/admin/passMsg',
                type:'post',
                data:{m_id:vl},
                success:function (data) {
                    mdui.snackbar({
                        message: data,
                        timeout: '2000',
                        position: 'bottom',
                    });
                    if(data == "标记成功!"){
                        var $tis = $(the);
                        var $t = $tis.parent().parent();
                        $t.remove();
                        setTimeout(function () {
                            location.reload();
                        },2000)
                    }
                }
            });
        }
        function Deletemsg(vl,the) {
            $.ajax({
               url:'${pageContext.request.contextPath}/index/admin/deleteMsg',
               type:'post',
               data:{m_id:vl},
               success:function (data) {
                   mdui.snackbar({
                       message: data,
                       timeout: '2000',
                       position: 'bottom',
                   });
                   if(data == "删除成功!"){
                       var $tis = $(the);
                       var $t = $tis.parent().parent();
                       $t.remove();
                   }
               }
            });
        }
        </c:if>
    </script>
</head>
<body onload="init()" class="mdui-drawer-body-left mdui-appbar-with-toolbar mdui-theme-primary-indigo mdui-theme-accent-pink">
<%
    session.setAttribute("suoyin",8);
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
    <c:if test="${user.identity == '学生' || user.identity == '教职工' && messagetable != []}">
        <h1 class="mdui-text-color-theme" style="margin-top: 30px;margin-bottom: 30px">留言板</h1>
        <div class="mdui-textfield mdui-textfield-floating-label">
            <label class="mdui-textfield-label">主题</label>
            <input class="mdui-textfield-input" type="text" id="themetitle"/>
        </div>
        <div class="mdui-textfield">
            <textarea class="mdui-textfield-input" rows="20" placeholder="内容" id="messagev"></textarea>
        </div>
        <button class="mdui-btn mdui-ripple-white mdui-color-theme" id="summitmes">提交</button>
        <h1 class="mdui-text-color-theme" style="margin-top: 30px;margin-bottom: 30px">我留过的言</h1>
        <div class="mdui-panel" mdui-panel id="img_class">
            <c:forEach items="${messagetable}" var="each">
                <div class="mdui-panel-item">
                    <div class="mdui-panel-item-header">
                            主题：${each.title}
                        <i class="mdui-panel-item-arrow mdui-icon material-icons">keyboard_arrow_down</i>
                    </div>
                    <div class="mdui-panel-item-body" style="font-family: 'Microsoft YaHei UI'">
                        <xmp>内容：${each.mes}</xmp>
                        <c:if test="${each.k_status == 0}">
                            <p style="color: red">管理员尚未阅读此条留言</p>
                        </c:if>
                        <c:if test="${each.k_status == 1}">
                            <p style="color: springgreen">管理员已阅读此条留言</p>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:if>

    <c:if test="${user.identity == '管理员'}">
        <h1 class="mdui-text-color-theme" style="margin-top: 30px;margin-bottom: 30px">留言板信息</h1>
        <div class="mdui-panel" mdui-panel id="img_class">
            <div class="mdui-panel" mdui-panel>
                <div class="mdui-panel-item">
                    <div class="mdui-panel-item-header mdui-color-red">未读消息</div>
                    <div class="mdui-panel-item-body">
                        <c:forEach items="${messagetable}" var="each">
                            <c:if test="${each.k_status == 0}">
                                <div class="mdui-panel" mdui-panel>
                                    <div class="mdui-panel-item">
                                        <div class="mdui-panel-item-header" style="margin-top: 20px;">
                                            <img src="${each.headIco}" style="border-radius: 50%;width: 30px;height: 30px;"/>主题：${each.title}
                                            <i class="mdui-panel-item-arrow mdui-icon material-icons">keyboard_arrow_down</i>
                                        </div>
                                        <div class="mdui-panel-item-body" style="font-family: 'Microsoft YaHei UI'">
                                            <h3 class="mdui-text-color-theme-accent"><xmp>作者昵称：${each.r_userName}</xmp></h3>
                                            <h3 class="mdui-text-color-theme-accent"><xmp>作者姓名：${each.userName}</xmp></h3>
                                            <xmp>内容：${each.mes}</xmp>
                                            <button class="mdui-btn mdui-color-teal mdui-ripple-white" id="passMsg" onclick="passMsgfun(${each.m_id},this)">标记为已读</button>
                                            <button class="mdui-btn mdui-color-red mdui-ripple-white" id="noDelete" onclick="Deletemsg(${each.m_id},this)">删除</button>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                </div>
            </div>
            <div class="mdui-panel" mdui-panel>
                <div class="mdui-panel-item">
                    <div class="mdui-panel-item-header mdui-color-green-600">已读消息</div>
                    <div class="mdui-panel-item-body" id="known">
                        <c:forEach items="${messagetable}" var="each">
                            <c:if test="${each.k_status == 1}">
                                <div class="mdui-panel" mdui-panel>
                                    <div class="mdui-panel-item">
                                        <div class="mdui-panel-item-header" style="margin-top: 20px;">
                                            <img src="${each.headIco}" style="border-radius: 50%;width: 30px;height: 30px;"/>主题：${each.title}
                                            <i class="mdui-panel-item-arrow mdui-icon material-icons">keyboard_arrow_down</i>
                                        </div>
                                        <div class="mdui-panel-item-body" style="font-family: 'Microsoft YaHei UI'">
                                            <h3 class="mdui-text-color-theme-accent"><xmp>作者昵称：${each.r_userName}</xmp></h3>
                                            <h3 class="mdui-text-color-theme-accent"><xmp>作者姓名：${each.userName}</xmp></h3>
                                            <xmp>内容：${each.mes}</xmp>
                                            <button class="mdui-btn mdui-color-red mdui-ripple-white" id="delete" onclick="Deletemsg(${each.m_id},this)">删除</button>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>
    </c:if>

</div>

<jsp:include page="theme.jsp"/>
<jsp:include page="bottom.jsp"/>

</body>
</html>
