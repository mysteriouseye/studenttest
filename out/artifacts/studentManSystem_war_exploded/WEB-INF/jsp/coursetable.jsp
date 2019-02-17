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

                $.ajax({
                    url:'${pageContext.request.contextPath}/index/getAllCourseYear',
                    type:'post',
                    success:function (data) {
                        <c:if test="${user.identity == '学生'}">
                            if(data.length == 0 || data == null){
                                mdui.snackbar({
                                    message: '没有课程表数据，可能还没有安排课程！',
                                    timeout: '2000',
                                    position: 'bottom',
                                });
                                setTimeout(function () {
                                    window.history.back(-1);
                                },3000);

                            }
                        </c:if>
                        for(var i = 0;i < data.length;i++){
                            $("#select_class").append('<option value='+data[i]+'>'+data[i]+'</option>');
                        }
                    }
                });

        }
        $(function () {
            $("#checkCoursetabel").click(function () {
                <c:if test="${user.identity == '学生'}">
                    var m = $("#select_class option:selected").text();
                    window.location.href = '${pageContext.request.contextPath}/index/loadCourseTable/'+m+"&"+${user.classNum};
                </c:if>
                <c:if test="${user.identity == '管理员'}">
                var m = $("#select_class option:selected").text();
                window.location.href = '${pageContext.request.contextPath}/index/admin/loadCourseTable/'+m;
                </c:if>
            });
        });
        function courseupload(vl) {
            var formData = new FormData();
            formData.append("courseFile",vl.files[0]);
            $.ajax({
                url:'${pageContext.request.contextPath}/index/admin/uploadExcelofCourse',
                type:'post',
                data:formData,
                contentType: false,
                processData: false,
                success:function (data) {
                    mdui.snackbar({
                        message: data.msg,
                        timeout: '2000',
                        position: 'bottom',
                    });
                    if(data.msg == "成功"){
                        setTimeout(function () {
                            location.reload();
                        },2000);
                    }
                }
            });
        }
        function delcourse(vls,the) {
            $.ajax({
                url:'${pageContext.request.contextPath}/index/admin/delCourse/',
                type:'post',
                data:{classNum:vls},
                success:function (data) {
                    mdui.snackbar({
                        message: data,
                        timeout: '2000',
                        position: 'bottom',
                    });
                    if(data == '删除成功!'){
                        var $ths = $(the);
                        $ths.parent().parent().remove();
                    }
                }
            })
        }
    </script>
    <style>
        .cl{
            border: 1px lightgray solid;
            text-align: center;
            padding: 0px;
            padding-left: 0px;
        }
        .cl th{
            border: 1px lightgray solid;
            text-align: center;
            padding: 0px;
            padding-left: 0px;
        }
    </style>
</head>
<body onload="init()" class="mdui-drawer-body-left mdui-appbar-with-toolbar mdui-theme-primary-indigo mdui-theme-accent-pink">
<%
    session.setAttribute("suoyin",4);
%>
<div id="loading" class="spinner">
    <div class="double-bounce1  mdui-color-theme mdui-shadow-9"></div>
    <div class="double-bounce2  mdui-color-theme mdui-shadow-9"></div>
</div>
<div id="loadingback" class="mdui-overlay mdui-overlay-show" style="background-color: white;z-index:9999"></div>
<jsp:include page="header.jsp"/>
<jsp:include page="left.jsp"/>
<a id="anchor-top"></a>
<c:if test="${user.identity == '学生'}">
    <div class="mdui-container">
        <h1 class="mdui-text-color-theme" style="margin-top: 30px;margin-bottom: 30px">课程表</h1>
        选择课程表年份：
        <select class="mdui-select" id="select_class">
        </select>
        <button class="mdui-btn mdui-color-theme mdui-ripple mdui-ripple-white" id="checkCoursetabel">查询</button>
        <div class="mdui-table-fluid mdui-shadow-16">
            <div class="mdui-table-fluid">
                <table class="mdui-table mdui-table-hoverable">
                    <thead>
                    <tr class="cl">
                        <th>#</th>
                        <th style="padding-left: 0px;">星期一</th>
                        <th>星期二</th>
                        <th>星期三</th>
                        <th>星期四</th>
                        <th>星期五</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach begin="1" end="8" var="each" step="1">
                        <tr>
                            <td style="text-align: center;padding: 0px">${each}</td>
                            <c:forEach begin="1" end="5" step="1" var="c">
                                <td style="border: 0.1px lightgray solid;text-align: center;padding: 0px">
                                    <c:forEach items="${coursetable}" var="p">
                                        <c:if test="${p.c_time == c && p.c_what == each}">
                                            <p style="color: red">${p.cname}</p>
                                            <p>${p.c_teacher}</p>
                                            <p>${p.c_time_more}</p>
                                            <p>${p.c_location}</p>
                                        </c:if>
                                    </c:forEach>
                                </td>
                            </c:forEach>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</c:if>
<c:if test="${user.identity == '管理员'}">
    <div class="mdui-container">
        <h1 class="mdui-text-color-theme" style="margin-top: 30px;margin-bottom: 30px">课程表</h1>
        选择课程表年份：
        <select class="mdui-select" id="select_class">
        </select>
        <button class="mdui-btn mdui-color-theme mdui-ripple mdui-ripple-white" id="checkCoursetabel">查询</button>
        <button class="mdui-btn mdui-color-theme mdui-ripple mdui-ripple-white" id="dd">
            导入Excel表
            <input style="position:absolute;right: 0px;top: 0px;opacity: 0;-ms-filter: 'alpha(opacity=0)';font-size: 200px;width: 100px;height: 40px;" class="ip" type="file" name="courseFile" onchange="courseupload(this)" accept=".xls">
        </button>
        <div class="mdui-panel" mdui-panel>
            <c:forEach items="${courseclass}" var="each">
                <div class="mdui-panel-item">
                    <div class="mdui-panel-item-header">
                            ${each}班
                                <i class="mdui-panel-item-arrow mdui-icon material-icons">keyboard_arrow_down</i>
                    </div>
                    <div class="mdui-panel-item-body">
                        <div class="mdui-table-fluid mdui-shadow-16">
                            <div class="mdui-table-fluid">
                                <table class="mdui-table mdui-table-hoverable">
                                    <thead>
                                    <tr class="cl">
                                        <th>#</th>
                                        <th style="padding-left: 0px;">星期一</th>
                                        <th>星期二</th>
                                        <th>星期三</th>
                                        <th>星期四</th>
                                        <th>星期五</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach begin="1" end="8" var="eachs" step="1">
                                        <tr>
                                            <td style="text-align: center;padding: 0px">${eachs}</td>
                                            <c:forEach begin="1" end="5" step="1" var="c">
                                                <td style="border: 0.1px lightgray solid;text-align: center;padding: 0px">
                                                    <c:forEach items="${coursetable}" var="p">
                                                        <c:if test="${p.c_time == c && p.classNum == each && p.c_what == eachs}">
                                                            <p style="color: red">${p.cname}</p>
                                                            <p>${p.c_teacher}</p>
                                                            <p>${p.c_time_more}</p>
                                                            <p>${p.c_location}</p>
                                                        </c:if>
                                                    </c:forEach>
                                                </td>
                                            </c:forEach>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <button class="mdui-btn mdui-ripple-white mdui-ripple mdui-color-red" style="float: right;margin: 10px;" onclick="delcourse(${each},this)">删除</button>
                    </div>
                </div>

            </c:forEach>
        </div>
    </div>
</c:if>

<jsp:include page="theme.jsp"/>
<jsp:include page="bottom.jsp"/>

</body>
</html>
