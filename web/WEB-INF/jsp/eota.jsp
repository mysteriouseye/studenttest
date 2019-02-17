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
               url:'${pageContext.request.contextPath}/index/admin/getAllClassNum',
               type:'post',
               success:function (data) {
                   for(var i = 0;i < data.length;i++){
                       if(data.length == 0){
                           mdui.snackbar({
                               message: '没有班级数据，请检查是否导入了学生数据！',
                               timeout: '2000',
                               position: 'bottom',
                           });
                           window.location.href = '${pageContext.request.contextPath}/index/show';
                       }
                       $("#select_class").append('<option value='+i.toString()+'>'+data[i]+'</option>');
                   }
               }
            });
        }
        $(function () {
            $("#submit_test").click(function () {
                $.ajax({
                    url:'${pageContext.request.contextPath}/index/admin/addNewTest',
                    type:'post',
                    data:{classNum:$("#select_class option:selected").text(),testname:$("#eota_name").val()},
                    success:function (data) {
                        mdui.snackbar({
                            message: data,
                            timeout: '2000',
                            position: 'bottom',
                        });
                        if(data == '添加成功!'){
                            setTimeout(function () {
                                window.location.reload();
                            },2000);
                        }
                    }
                });
            });
        });
        function eotadel(test_id,th) {
            $.ajax({
                url:'${pageContext.request.contextPath}/index/admin/eotadel',
                type:'post',
                data:{test_id:test_id},
                success:function (data) {
                    mdui.snackbar({
                        message: data,
                        timeout: '2000',
                        position: 'bottom',
                    });
                    if(data == '成功!'){
                        var $the = $(th);
                        $the.parent().parent().remove();
                    }
                }
            });
        }
        function eotaupdate_dialog(test_id,th) {
            var inst = new mdui.Dialog('#update_dialog');
            inst.open();
            var dialog = document.getElementById("update_dialog");
            dialog.addEventListener('confirm.mdui.dialog', function () {
                eotaupdate(test_id,th);
            });
        }
        function eotaupdate(test_id,th) {
            $.ajax({
                url:'${pageContext.request.contextPath}/index/admin/eotaupdate',
                type:'post',
                data:{test_name:$("#test_name").val(),test_id:test_id},
                success:function (data) {
                    mdui.snackbar({
                        message: data,
                        timeout: '2000',
                        position: 'bottom',
                    });
                    if(data == '修改成功!'){
                        var $the = $(th);
                        $the.parent().parent().find("td:eq(1)").text($("#test_name").val());
                    }
                }
            });
        }
        function eotalupload(vl) {
            var formData = new FormData();
            formData.append("testTableFile",vl.files[0]);
            $.ajax({
                url:'${pageContext.request.contextPath}/index/admin/uploadExcelofTestinfo',
                type:'post',
                data:formData,
                contentType: false,
                processData: false,
                success:function (data) {
                    alert(data.msg);
                }
            });
        }
    </script>
    <style>
        .ip{
            position:absolute;
            right: 0px;
            top: 0px;
            opacity: 0;
            -ms-filter: 'alpha(opacity=0)';
            font-size: 200px;
        }
    </style>
</head>
<body onload="init()" class="mdui-drawer-body-left mdui-appbar-with-toolbar mdui-theme-primary-indigo mdui-theme-accent-pink">
<%
    session.setAttribute("suoyin",6);
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
    <h1 class="mdui-text-color-theme" style="margin-top: 30px;margin-bottom: 30px">添加一场考务</h1>
    <div class="mdui-row">
        选择班级：
        <select class="mdui-select" id="select_class">
            <option value="1" selected>全部班级</option>
        </select>
        <div class="mdui-textfield mdui-textfield-floating-label">
            <label class="mdui-textfield-label">考务名称</label>
            <input class="mdui-textfield-input" type="text" id="eota_name" name="eota_name"/>
        </div>
        <button class="mdui-btn mdui-ripple mdui-ripple-white mdui-color-theme" id="submit_test">提交</button>
    </div>
    <h1 class="mdui-text-color-theme" style="margin-top: 30px;margin-bottom: 30px">管理一场考务</h1>
    <div class="mdui-table-fluid">
        <table class="mdui-table mdui-table-hoverable">
            <thead>
            <tr>
                <th>考务场次</th>
                <th>考务名称</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${testinfo}" var="each">
                <tr>
                    <td>${each.test_id}</td>
                    <td>${each.test_name}</td>
                    <td>
                        <a class="mdui-color-red mdui-btn mdui-ripple mdui-ripple-white" style="min-width: 70px" onclick="eotadel('${each.test_id}',this)">删除</a>
                        <a class="mdui-color-light-blue mdui-btn mdui-ripple mdui-ripple-white" style="min-width: 70px" onclick="eotaupdate_dialog('${each.test_id}',this)">修改场次名</a>
                        <a class="mdui-color-purple mdui-btn mdui-ripple mdui-ripple-white">
                            上传成绩单
                            <input  class="ip" type="file" name="testTableFile" onchange="eotalupload(this)" accept=".xls .xlsx">
                        </a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
<div class="mdui-dialog" id="update_dialog">
    <div class="mdui-dialog-title">请输入新名称</div>
    <div class="mdui-dialog-content">
        <input class="mdui-textfield-input" type="text" id="test_name" name="test_name"/>
    </div>
    <div class="mdui-dialog-actions">
        <button class="mdui-btn mdui-ripple" mdui-dialog-cancel>取消</button>
        <button class="mdui-btn mdui-ripple" mdui-dialog-confirm>确定</button>
    </div>
</div>
<jsp:include page="theme.jsp"/>
<jsp:include page="bottom.jsp"/>

</body>
</html>
