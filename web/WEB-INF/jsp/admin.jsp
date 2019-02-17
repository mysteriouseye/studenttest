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
        var pages = 0;
        function filename(vm) {
            var obj = vm.files;
            for(var i = 0 ;i < obj.length;i++){
                $("#filename").append("<p>"+obj[i].name+'</p>');
            }

        }
        $(function () {
            $("#skip_page_btn").click(function () {
                var l = ${pageinfo.pages};
                if($("#skip_page").val() == ""){
                    mdui.snackbar({
                        message: '跳转页面不可输入为空！',
                        timeout: '2000',
                        position: 'bottom',
                    });
                }else if($("#skip_page").val() > l || $("#skip_page").val() < 1){
                    mdui.snackbar({
                        message: '跳转页面不可大于总页数或小于1！',
                        timeout: '2000',
                        position: 'bottom',
                    });
                }else {
                    var j = $("#skip_page").val();
                    getall(j);
                }
            });

            $("#submitinfo").click(function () {
               $.ajax({
                 type:'post',
                 url:'${pageContext.request.contextPath}/index/admin/updateInfo',
                 data:{userName:$('#userName').val(),
                     age:$("#age").val(),
                     sex:$("#sex option:selected").text(),
                     classNum:$("#classNum").val(),
                     identity:$("#identity option:selected").text(),
                     peoNum:$("#peoNum").val(),
                     email:$("#email").val(),
                     phoneNum:$("#peoNum").val()},
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
                         setTimeout(function () {
                             location.reload();
                         },2000)
                     }else if(data == 400){
                         mdui.snackbar({
                             message: '不可为空或是有的格式错误！',
                             timeout: '2000',
                             position: 'bottom',
                         });
                     }else if(data == 700){
                         mdui.snackbar({
                             message: '用户名、工号或邮箱已存在！',
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
        }
        function search(vv) {
            var str = $("#user_all_item").html();
            var val = vv.value;
            if($.trim(val) != ""){
                var re=val;
                var nn = str.replace(new RegExp(val,"gm"),re);
                $("#user_all_item").html(nn);
                $("#user_page_item").hide();
                $("#user_all_item").show();
                $("#user_all_item").find(".pp").hide().filter(":contains('"+val+"')").show();
            }else {
                $("#user_page_item").show();
                $("#user_all_item").hide();
            }
        }
        function deleteuserinfo(vl,th) {
            $.ajax({
               url:'${pageContext.request.contextPath}/index/admin/deleteUserinfo',
               type:'post',
               data:{uid:vl},
               success:function (data) {
                   mdui.snackbar({
                       message: data,
                       timeout: '2000',
                       position: 'bottom',
                   });
                    if(data == "删除成功!"){
                        var $the = $(th);
                        $the.parent().parent().remove();
                    }
               }
            });
        }
        function updateuserinfo(vl,th) {
            var inst = new mdui.Dialog('#update_dialog');
            inst.open();
            $("#yes").click(function () {
                $.ajax({
                    url:'${pageContext.request.contextPath}/index/admin/updateUserInfo',
                    type:'post',
                    data:{uid:vl,
                        r_userName:$("#d_r_userName").val(),
                        userName:$("#d_userName").val(),
                        passWord:$("#d_password").val(),
                        age:$("#d_age").val(),
                        peoNum:$("#d_peoNum").val(),
                        email:$("#d_email").val(),
                        phoneNum:$("#d_phoneNum").val(),
                        identity:$("#d_identity option:selected").text(),
                        sex:$("#d_sex option:selected").text(),
                        classNum:$("#d_classNum option:selected").text()},
                    success:function (data) {
                        mdui.snackbar({
                            message: data,
                            timeout: '2000',
                            position: 'bottom',
                        });
                        if(data == "修改成功!"){
                            setTimeout(function () {
                                getall(${pageinfo.pageNum});
                            },2000)
                        }
                    }
                });
            });
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
            if(6 < ${pageinfo.pageNum}){
                $("#page_btn").find("a").eq(6).addClass("mdui-color-theme");
            }else {
                $("#page_btn").find("a").eq(${pageinfo.pageNum}-1).addClass("mdui-color-theme");
            }
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
                        }
                        $("#d_classNum").append('<option value='+i.toString()+'>'+data[i]+'</option>');
                    }
                }
            });
            $.ajax({
                url:'${pageContext.request.contextPath}/index/admin/GetAllUser',
                type:'post',
                data:{pageNum:pages},
                success:function (data) {

                }
            });
        }
    </script>
    <style>
        .pp{

        }
    </style>
</head>
<body onbeforeunload="uponload()" onload="init()" class="mdui-drawer-body-left mdui-appbar-with-toolbar mdui-theme-primary-indigo mdui-theme-accent-pink">
<%
    session.setAttribute("suoyin",7);
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
    <h1 class="mdui-text-color-theme" style="margin-top: 30px;margin-bottom: 30px">学校人员信息导入导出</h1>
    <div class="mdui-row">
        <div class="mdui-card mdui-shadow-16">
            <div class="mdui-card-media">
                <h1 class="mdui-text-color-theme-accent mdui-ripple" style=" margin-top: 30px;margin-left: 10px;">
                    <i class="mdui-icon material-icons mdui-text-color-theme-accent">&#xe86e;</i>
                    一键操作</h1>
                <form id="csvform" action="${pageContext.request.contextPath}/index/admin/upUserExcelFile" method="post" enctype="multipart/form-data">
                    <center>
                        <p id="filename"></p>
                        <button class="mdui-btn mdui-btn-raised mdui-ripple mdui-color-light-blue mdui-text-color-white">
                            导入Excel
                            <input style="position:absolute;right: 0px;top: 0px;opacity: 0;-ms-filter: 'alpha(opacity=0)';font-size: 200px;width: 100px;height: 40px;" onchange="filename(this)" name="files" type="file" id="csvfile" accept=".xls" multiple="multiple">
                        </button>
                      <button class="mdui-btn mdui-btn-raised mdui-ripple mdui-color-light-blue mdui-text-color-white" onclick="xhr2()">提交</button>
                    </center>
                </form>
                <br>
                <center>
                    <a href="/index/admin/downExcelofUserinfo/">
                        <button class="mdui-btn mdui-btn-raised mdui-ripple mdui-color-red">导出用户信息为Excel表</button>
                    </a>
                </center>
                <h1 class="mdui-text-color-theme-accent mdui-ripple" style=" margin-top: 30px;margin-left: 10px;">
                    <i class="mdui-icon material-icons mdui-text-color-theme-accent">&#xe86e;</i>
                    手动添加</h1>
                <div class="mdui-table-fluid mdui-shadow-0">
                    <table class="mdui-table">
                        <thead>
                        <tr>
                            <th>姓名</th>
                            <th>年龄</th>
                            <th>性别</th>
                            <th>班级/任教班级</th>
                            <th>身份</th>
                            <th>学号/工号</th>
                            <th>邮箱</th>
                            <th>手机号</th>
                        </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>
                                    <input class="mdui-textfield-input" type="text" id="userName" name="userName" style="width: 70px"/>
                                </td>
                                <td>
                                    <input class="mdui-textfield-input" id="age" name="age" style="width: 70px" type="text" onkeyup="(this.v=function(){this.value=this.value.replace(/[^0-9-]+/,'');}).call(this)" onblur="this.v();">
                                </td>
                                <td>
                                    <select class="mdui-select" id="sex">
                                        <option value="1" selected>男</option>
                                        <option value="2">女</option>
                                    </select>
                                </td>
                                <td>
                                    <input class="mdui-textfield-input" id="classNum" name="classNum" style="width: 100px" type="text" onkeyup="(this.v=function(){this.value=this.value.replace(/[^0-9-]+/,'');}).call(this)" onblur="this.v();">
                                </td>
                                <td>
                                    <select class="mdui-select" id="identity">
                                        <option value="1" selected>学生</option>
                                        <option value="2">教职工</option>
                                    </select>
                                </td>
                                <td>
                                    <input class="mdui-textfield-input" id="peoNum" style="width: 100px" type="text" onkeyup="(this.v=function(){this.value=this.value.replace(/[^0-9-]+/,'');}).call(this)" onblur="this.v();">
                                </td>
                                <td>
                                    <input class="mdui-textfield-input" id="email" type="email" id="email" name="email" style="width: 100px"/>
                                    <div class="mdui-textfield-error">邮箱格式错误或为空</div>
                                </td>
                                <td>
                                    <input class="mdui-textfield-input" id="phoneNum" style="width: 100px" type="text" onkeyup="(this.v=function(){this.value=this.value.replace(/[^0-9-]+/,'');}).call(this)" onblur="this.v();">
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <button id="submitinfo" class="mdui-btn mdui-btn-raised mdui-ripple mdui-color-light-blue mdui-text-color-white" style="float: right;margin-top: 40px;margin-right: 50px;">提交</button>
                </div>
            </div>

            <div class="mdui-card-actions">
                <button class="mdui-btn mdui-ripple" disabled></button>
                <button class="mdui-btn mdui-ripple" disabled></button>
            </div>
        </div>
    </div>
    <div class="mdui-row">
        <div class="mdui-card mdui-shadow-16">
            <div class="mdui-card-media">
                <h1 class="mdui-text-color-theme-accent mdui-ripple" style=" margin-top: 30px;margin-left: 10px;">
                    <i class="mdui-icon material-icons mdui-text-color-theme-accent">&#xe86e;</i>
                    单个操作</h1>
                <div class="mdui-textfield mdui-textfield-floating-label">
                    <i class="mdui-icon material-icons ">&#xe8b6;</i>
                    <label class="mdui-textfield-label">搜索</label>
                    <input class="mdui-textfield-input" type="text" id="search_info" name="search_info" onchange="search(this)"/>
                </div>
                <div class="mdui-table-fluid mdui-shadow-0" style="display: none" id="user_all_item">
                    <table class="mdui-table">
                        <thead>
                        <tr>
                            <th>个性昵称</th>
                            <th>姓名</th>
                            <th>密码</th>
                            <th>年龄</th>
                            <th>性别</th>
                            <th>所在班级/任教班级</th>
                            <th>身份</th>
                            <th>学号/工号</th>
                            <th>邮箱</th>
                            <th>手机号</th>
                            <th>操作</th>
                        </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${alluserinfo}" var="each">
                                <tr class="pp">
                                    <td>${each.r_userName}</td>
                                    <td>${each.userName}</td>
                                    <td>${each.passWord}</td>
                                    <td>${each.age}</td>
                                    <td>${each.sex}</td>
                                    <td>${each.classNum}</td>
                                    <td>${each.identity}</td>
                                    <td>${each.peoNum}</td>
                                    <td>${each.email}</td>
                                    <td>${each.phoneNum}</td>
                                    <td>
                                        <a class="mdui-color-red mdui-btn mdui-ripple mdui-ripple-white" style="min-width: 70px;margin-bottom: 10px;" onclick="deleteuserinfo(${each.uid},this)">删除</a>
                                        <a class="mdui-color-light-blue mdui-btn mdui-ripple mdui-ripple-white" style="min-width: 70px;margin-bottom: 10px;" onclick="updateuserinfo(${each.uid},this)">修改</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                <div class="mdui-table-fluid mdui-shadow-0" id="user_page_item">
                    <table class="mdui-table">
                        <thead>
                        <tr>
                            <th>个性昵称</th>
                            <th>姓名</th>
                            <th>密码</th>
                            <th>年龄</th>
                            <th>性别</th>
                            <th>所在班级/任教班级</th>
                            <th>身份</th>
                            <th>学号/工号</th>
                            <th>邮箱</th>
                            <th>手机号</th>
                            <th>操作</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${pageuserinfo}" var="each">
                            <tr class="pp">
                                <td>${each.r_userName}</td>
                                <td>${each.userName}</td>
                                <td>${each.passWord}</td>
                                <td>${each.age}</td>
                                <td>${each.sex}</td>
                                <td>${each.classNum}</td>
                                <td>${each.identity}</td>
                                <td>${each.peoNum}</td>
                                <td>${each.email}</td>
                                <td>${each.phoneNum}</td>
                                <td>
                                    <a class="mdui-color-red mdui-btn mdui-ripple mdui-ripple-white" style="min-width: 70px;margin-bottom: 10px;" onclick="deleteuserinfo(${each.uid},this)">删除</a>
                                    <a class="mdui-color-light-blue mdui-btn mdui-ripple mdui-ripple-white" style="min-width: 70px;margin-bottom: 10px;" onclick="updateuserinfo(${each.uid})">修改</a>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
                <div id="page_btn" style="text-align: center;width: 100%;margin-top: 30px;margin-bottom: 30px;">
                    <c:forEach var="i" begin="1" end="${pageinfo.pages}" step="1">
                        <c:if test="${i < 6}">
                            <a style="min-width: 20px" class="mdui-btn mdui-ripple" onclick="getall(${i})">${i}</a>
                        </c:if>
                    </c:forEach>
                    <c:if test="${pageinfo.pages > 6}">
                        ... <a style="min-width: 20px" class="mdui-btn mdui-ripple" onclick="getall(${pageinfo.pages})">${pageinfo.pages}</a>
                        <center><input class="mdui-textfield-input" id="skip_page" style="width: 100px" type="text" onkeyup="(this.v=function(){this.value=this.value.replace(/[^0-9-]+/,'');}).call(this)" onblur="this.v();"></center>
                        <button class="mdui-btn mdui-ripple-white mdui-color-theme" id="skip_page_btn">跳转</button>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="theme.jsp"/>
<jsp:include page="bottom.jsp"/>
<div class="mdui-dialog" id="update_dialog">
    <div class="mdui-dialog-title mdui-text-color-theme-accent">修改该用户信息(留空项为不修改)</div>
    <div class="mdui-dialog-content">
        <div class="mdui-textfield mdui-textfield-floating-label">
            <label class="mdui-textfield-label">个性昵称</label>
            <input class="mdui-textfield-input" type="text" id="d_r_userName" name="d_r_userName"/>
        </div>
        <div class="mdui-textfield mdui-textfield-floating-label">
            <label class="mdui-textfield-label">姓名</label>
            <input class="mdui-textfield-input" type="text" id="d_userName" name="d_userName"/>
        </div>
        <div class="mdui-textfield mdui-textfield-floating-label">
            <label class="mdui-textfield-label">密码</label>
            <input class="mdui-textfield-input" type="password" id="d_password" name="d_password"/>
        </div>
        <div class="mdui-textfield mdui-textfield-floating-label">
            <label class="mdui-textfield-label">年龄</label>
            <input class="mdui-textfield-input" type="text" id="d_age" name="d_age"/>
        </div>
        <div class="mdui-textfield mdui-textfield-floating-label">
            <label class="mdui-textfield-label">学号</label>
            <input class="mdui-textfield-input" type="text" id="d_peoNum" name="d_peoNum"/>
        </div>
        <div class="mdui-textfield mdui-textfield-floating-label">
            <label class="mdui-textfield-label">邮箱</label>
            <input class="mdui-textfield-input" type="email" id="d_email" name="d_sex"/>
        </div>
        <div class="mdui-textfield mdui-textfield-floating-label">
            <label class="mdui-textfield-label">手机号</label>
            <input class="mdui-textfield-input" type="email" id="d_phoneNum" name="d_sex"/>
        </div>
        身份：
        <select class="mdui-select" id="d_identity">
            <option value="1" selected>学生</option>
            <option value="2">教职工</option>
        </select>
        性别：
        <select class="mdui-select" id="d_sex">
            <option value="1" selected>男</option>
            <option value="2">女</option>
        </select>
        班级：
        <select class="mdui-select" id="d_classNum">
        </select>
    </div>
    <div class="mdui-dialog-actions">
        <button class="mdui-btn mdui-ripple" mdui-dialog-cancel>取消</button>
        <button id="yes" class="mdui-btn mdui-ripple" mdui-dialog-confirm>确定</button>
    </div>
</div>
</body>
</html>
