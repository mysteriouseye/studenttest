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
        function skippage(vl) {
            window.location.href = '${pageContext.request.contextPath}/index/loadTestInfoTable/'+vl+"&"+$("#select_class option:selected").val();
        }
        <c:if test="${user.identity == '管理员'}">
            function skippageadmin() {
                window.location.href = '${pageContext.request.contextPath}/index/admin/loadTestInfoTable/'+$("#select_class option:selected").val();
            }
        </c:if>
        $(function () {

        });
        function search(vv) {
            $(".changestyle").each(function()
            {
                var xx=$(this).html();
                $(this).replaceWith(xx);
            });
            var str = $("#img_class").html();
            var val = vv.value;
            if($.trim(val) != ""){
                var re=val;
                var nn = str.replace(new RegExp(val,"gm"),re);
                $("#img_class").html(nn);
                $("#img_class").find(".pps").hide().filter(":contains('"+val+"')").show();
            }else {
                $(".pps").show();

            }
        }
        function downloadExcel() {
            var vl = ${user.classNum};
            <c:if test="${user.identity == '学生' || user.identity == '教职工'}">
                 window.location.href = '${pageContext.request.contextPath}/index/downExcelofTestinfo/'+vl+"&"+$("#select_class option:selected").val();
            </c:if>
            <c:if test="${user.identity == '管理员'}">
                window.location.href = '${pageContext.request.contextPath}/index/admin/downExcelofTestinfo/'+$("#select_class option:selected").val();
            </c:if>

        }
    </script>
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
                url:'${pageContext.request.contextPath}/index/getTestInfo',
                type:'post',
                success:function (data) {
                    if(data.length == 0){
                        mdui.snackbar({
                            message: '没有考试数据，可能教务处还没有安排考试！',
                            timeout: '2000',
                            position: 'bottom',
                        });
                        setTimeout(function () {
                            window.history.back(-1);
                        },3000);

                    }
                    for(var i = 0;i < data.length;i++){
                        $("#select_class").append('<option value='+data[i].test_id+'>'+data[i].test_name+'</option>');
                    }
                }
            });
        }
    </script>
    <style>
        .cl th{
            padding: 0px;
            text-align: center;
            border: 1px lightgray solid;
        }
        .cl td{
            padding: 0px;
            text-align: center;
            border: 1px lightgray solid;
        }
        .pps{

        }
    </style>
</head>
<body onload="init()" class="mdui-drawer-body-left mdui-appbar-with-toolbar mdui-theme-primary-indigo mdui-theme-accent-pink">
<%
    session.setAttribute("suoyin",5);
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
        <h1 class="mdui-text-color-theme" style="margin-top: 30px;margin-bottom: 30px">考试查询</h1>
        <select class="mdui-select" id="select_class">
        </select>
        <button class="mdui-color-theme mdui-btn mdui-ripple mdui-ripple-white" onclick="skippage(${user.classNum})">查询</button>
        <button class="mdui-btn mdui-color-theme mdui-ripple mdui-ripple-white" onclick="downloadExcel()">下载</button>
        ps:注意下载的是选择框里的考试信息表！
        <c:if test="${testtableinfo != null}">
            <div class="mdui-textfield mdui-textfield-floating-label">
                <i class="mdui-icon material-icons ">&#xe8b6;</i>
                <label class="mdui-textfield-label">搜索</label>
                <input class="mdui-textfield-input" type="text" id="search_info" name="search_info" onchange="search(this)"/>
            </div>
            <div class="mdui-table-fluid" id="img_class">
                <table class="mdui-table mdui-table-hoverable cl">
                    <thead>
                        <th>序号</th>
                        <th>姓名</th>
                        <th>学号</th>
                        <th>语文</th>
                        <th>数学</th>
                        <th>英语</th>
                        <th>物理</th>
                        <th>化学</th>
                        <th>生物</th>
                        <th>政治</th>
                        <th>历史</th>
                        <th>地理</th>
                        <th>总分</th>
                    </thead>
                    <tbody>
                    <c:forEach items="${testtableinfo}" var="each">
                        <tr class="pps">
                            <td>${each.xu_number}</td>
                            <td>${each.userName}</td>
                            <td>${each.peoNum}</td>
                            <td>${each.chinese}</td>
                            <td>${each.math}</td>
                            <td>${each.english}</td>
                            <td>${each.physic}</td>
                            <td>${each.chemical}</td>
                            <td>${each.biology}</td>
                            <td>${each.politics}</td>
                            <td>${each.history}</td>
                            <td>${each.geography}</td>
                            <td>${each.sumFen}</td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>

            </div>
        </c:if>
        <c:if test="${testtableinfo == null}">
            <h1 class="mdui-color-grey-50" style="text-align: center;margin-top: 60px">
                没有信息，请点击提交
            </h1>
        </c:if>
    </div>
</c:if>
<c:if test="${user.identity == '管理员'}">
    <div class="mdui-container">
        <h1 class="mdui-text-color-theme" style="margin-top: 30px;margin-bottom: 30px">考试查询</h1>
        <select class="mdui-select" id="select_class">
        </select>
        <button class="mdui-color-theme mdui-btn mdui-ripple mdui-ripple-white" onclick="skippageadmin()">查询</button>
        <button class="mdui-btn mdui-color-theme mdui-ripple mdui-ripple-white" onclick="downloadExcel()">下载</button>
        ps:注意下载的是选择框里的考试信息表！
            <c:if test="${tlist != null}">
                <div class="mdui-textfield mdui-textfield-floating-label">
                    <i class="mdui-icon material-icons ">&#xe8b6;</i>
                    <label class="mdui-textfield-label">搜索</label>
                    <input class="mdui-textfield-input" type="text" id="search_info" name="search_info" onchange="search(this)"/>
                </div>
            <div class="mdui-panel" mdui-panel id="img_class">
                <c:forEach items="${clist}" var="each">
                <div class="mdui-panel-item">
                    <div class="mdui-panel-item-header">
                            ${each}班
                                <i class="mdui-panel-item-arrow mdui-icon material-icons">keyboard_arrow_down</i>
                    </div>
                    <div class="mdui-panel-item-body">
                        <div class="mdui-table-fluid">
                            <table class="mdui-table mdui-table-hoverable cl">
                                <thead>
                                    <th>序号</th>
                                    <th>姓名</th>
                                    <th>学号</th>
                                    <th>语文</th>
                                    <th>数学</th>
                                    <th>英语</th>
                                    <th>物理</th>
                                    <th>化学</th>
                                    <th>生物</th>
                                    <th>政治</th>
                                    <th>历史</th>
                                    <th>地理</th>
                                    <th>总分</th>
                                </thead>
                                <tbody>
                                <c:forEach items="${tlist}" var="eachs">
                                    <c:if test="${eachs.classNum == each}">
                                        <tr class="pps">
                                            <td>${eachs.xu_number}</td>
                                            <td>${eachs.userName}</td>
                                            <td>${eachs.peoNum}</td>
                                            <td>${eachs.chinese}</td>
                                            <td>${eachs.math}</td>
                                            <td>${eachs.english}</td>
                                            <td>${eachs.physic}</td>
                                            <td>${eachs.chemical}</td>
                                            <td>${eachs.biology}</td>
                                            <td>${eachs.politics}</td>
                                            <td>${eachs.history}</td>
                                            <td>${eachs.geography}</td>
                                            <td>${eachs.sumFen}</td>
                                        </tr>
                                    </c:if>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                </c:forEach>
            </div>
            </c:if>
        <c:if test="${tlist == null}">
            <h1 class="mdui-color-grey-50" style="text-align: center;margin-top: 60px">
                没有信息，请点击提交
            </h1>
        </c:if>
    </div>
</c:if>
<jsp:include page="theme.jsp"/>
<jsp:include page="bottom.jsp"/>

</body>
</html>
