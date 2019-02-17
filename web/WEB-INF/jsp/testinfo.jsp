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
        }
        function filename(vm) {
            var obj = vm.files;
            for(var i = 0 ;i < obj.length;i++){
                alert(obj[i].name);
                $("#filename").append("<p>"+obj[i].name+'</p>');
            }

        }
        $(function () {
            $("#submitinfo").click(function () {
                $.ajax({
                    type:'post',
                    url:'${pageContext.request.contextPath}/index/admin/updateInfo',
                    data:{userName:$('#userName').val(),age:$("#age").val(),sex:$("#sex option:selected").text(),classNum:$("#classNum").val(),identity:$("#identity option:selected").text(),peoNum:$("#peoNum").val(),email:$("#email").val(),phoneNum:$("#peoNum").val()},
                    success:function (data) {
                        if(data == 300) {
                            mdui.snackbar({
                                message: '发生异常！请稍后重试！',
                                timeout: '2000',
                                position: 'bottom',
                            });
                        }else if(data == 600){
                            mdui.snackbar({
                                message: '插入成功！',
                                timeout: '2000',
                                position: 'bottom',
                            });
                        }else if(data == 400){
                            mdui.snackbar({
                                message: '不可为空！',
                                timeout: '2000',
                                position: 'bottom',
                            });
                        }
                    }
                });
            });
        });
        function xhr2() {
            document.forms[0].submit();
            <%--$("#csvform").ajaxForm({--%>
            <%--type:'post',--%>
            <%--url:'${pageContext.request.contextPath}/index/upCsvFile',--%>
            <%--success:function (data) {--%>
            <%--if(data == 600){--%>
            <%--mdui.snackbar({--%>
            <%--message: '文件上传成功!',--%>
            <%--timeout: '2000',--%>
            <%--position: 'bottom',--%>
            <%--});--%>
            <%--}--%>
            <%--}--%>
            <%--});--%>
            <%--$.ajax({--%>
            <%--url: '${pageContext.request.contextPath}/index/upCsvFile',--%>
            <%--cache:false,--%>
            <%--type:'post',--%>
            <%--processData:false,--%>
            <%--contentType:false,--%>
            <%--data:formData,--%>
            <%--success:function () {--%>

            <%--}--%>
            <%--});--%>

        }
    </script>
</head>
<body onload="init()" class="mdui-drawer-body-left mdui-appbar-with-toolbar mdui-theme-primary-indigo mdui-theme-accent-pink">
<div id="loading" class="spinner">
    <div class="double-bounce1  mdui-color-theme mdui-shadow-9"></div>
    <div class="double-bounce2  mdui-color-theme mdui-shadow-9"></div>
</div>
<div id="loadingback" class="mdui-overlay mdui-overlay-show" style="background-color: white;z-index:9999"></div>
<jsp:include page="header.jsp"/>
<jsp:include page="left.jsp"/>
<a id="anchor-top"></a>
<div class="mdui-container">
    <h1 class="mdui-text-color-theme" style="margin-top: 30px;margin-bottom: 30px">考试成绩查询</h1>
    场次或考试名称：<input class="mdui-textfield-input" id="test_name_or" name="test_name_or" style="width: 70px" type="text">

</div>

<jsp:include page="theme.jsp"/>
<jsp:include page="bottom.jsp"/>

</body>
</html>
