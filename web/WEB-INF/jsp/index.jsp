<%@ page import="org.springframework.ui.Model" %>
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
      function showImg() {
          if(document.getElementById("oInput").value!=""){
              var docObj = document.getElementById("oInput");
              var imgObjPreview = document.getElementById("oInput_img");
              imgObjPreview.src = window.URL.createObjectURL(docObj.files[0]);
          }
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
          },600);

          $.ajax({
              url:'${pageContext.request.contextPath}/index/loadUserinfo/',
              dataType:"json",
              type:"post",
              success:function (user) {
                  $("#uname").text("姓名："+user.userName);
                  $("#sex").text("性别："+user.sex);
                  if(user.headIco == null){
                      $("#head_img").attr('src',"${pageContext.request.contextPath}/img/user.png");
                  }else {
                      $("#head_img").attr('src','${pageContext.request.contextPath}'+user.headIco);
                  }

                  $("#r_username").text("个性昵称："+user.r_userName);
                  $("#head_rname").text(user.r_userName)
                  $("#class").text("班级："+ user.classNum);
                  $("#peoNum").text("学号/工号："+user.peoNum);
                  $("#age").text("年龄："+user.age);
                  setTimeout(function () {
                      if(user.identity == "管理员"){
                          var inst = new mdui.Dialog('#admins');
                          inst.open();
                      }
                  },2400);
                  $("#identity").text("身份："+user.identity);
                  $("#email").text("邮箱："+user.email);
                  $("#retime").text("注册激活时间："+user.retime);
                  if(user.signed == null){
                      $("#signed").text("这个人很懒，没有个性签名");
                  }else {
                      $("#signed").text(user.signed);
                  }
              },
              error:function () {

              }
          });
      }
  </script>
  <script>
    $(function () {
        $("#savainfo").click(function () {
           $.ajax({
               url:'${pageContext.request.contextPath}/index/updateUserinfo/',
               dataType:"text",
               type:"post",
               data:{r_userName:$('#uprname').val(),email:$('#upemail').val(),signed:$('#upsinged').val()},
               success:function (data) {
                   if(data == 100){
                       mdui.snackbar({
                           message: '修改失败！请稍后重试！',
                           timeout: '2000',
                           position: 'bottom',
                       });
                   }else if(data == 600){
                       mdui.snackbar({
                           message: '修改成功！',
                           timeout: '2000',
                           position: 'bottom',
                       });
                       setTimeout(function () {
                           window.location.reload();
                       },2000);
                   }else if(data == 300){
                       mdui.snackbar({
                           message: '数据库发生错误！',
                           timeout: '2000',
                           position: 'bottom',
                       });
                   }else if(data == 700){
                       mdui.snackbar({
                           message: '该昵称或邮箱已存在！请取别的！或是你留空，没有发生任何变化！',
                           timeout: '2000',
                           position: 'bottom',
                       });
                   }else if(data == 800){
                       mdui.snackbar({
                           message: '用户名或邮箱格式有误！',
                           timeout: '2000',
                           position: 'bottom',
                       });
                   }
               }
           });
        });
        $("#savapassword").click(function () {
            $.ajax({
                url:'${pageContext.request.contextPath}/index/upRsa',
                dataType:"text",
                type:"post",
                success:function (data) {
                    var val = $('#upold_passowrd').val();
                    var val2 = $('#uppassowrd').val();
                    var val3 = $('#upreload_passowrd').val();
                    var str = val.replace(/(^\s*)|(\s*$)/g, '');//去除空格;
                    var str2 = val2.replace(/(^\s*)|(\s*$)/g, '');
                    var str3 = val3.replace(/(^\s*)|(\s*$)/g, '');
                    if(str != "" || str == undefined || str == null || str2 != "" || str2 == undefined || str2 == null || str3 != "" || str3 == undefined || str3 == null){
                        var jn = $.parseJSON(data);
                        if(jn.error != 404){
                            pubexponent = jn.pubexponent;
                            pubmoulues = jn.pubmoulues;
                            cmdEncryptIndex(pubexponent,pubmoulues);
                        }else {
                            mdui.snackbar({
                                message: '密码加密失败!可能是服务器文件错误！',
                                timeout: '2000',
                                position: 'bottom',
                            });
                        }
                    }else {
                        mdui.snackbar({
                            message: '三种密码都不可为空!',
                            timeout: '2000',
                            position: 'bottom',
                        });
                    }
                },
                error:function () {

                }
            });
        });
        $("#savehead").click(function () {
            var datas = new FormData();
            datas.append("file",$('#oInput')[0].files[0]);
            datas.append("peoNum",${user.peoNum});
            $.ajax({
                url: '${pageContext.request.contextPath}/index/upHeadFile',
                cache:false,
                type:'post',
                processData:false,
                contentType:false,
                data:datas,
                success:function (data) {
                    if(data == 600) {
                        mdui.snackbar({
                            message: '文件上传成功!',
                            timeout: '2000',
                            position: 'bottom',
                        });
                        setTimeout(function () {
                            window.location.reload();
                        },2000);
                    }else if(data == 500){
                        mdui.snackbar({
                            message: '文件创建异常!请稍后再试！',
                            timeout: '2000',
                            position: 'bottom',
                        });
                    }else if(data == 300){
                        mdui.snackbar({
                            message: '上传的非图片文件！',
                            timeout: '2000',
                            position: 'bottom',
                        });
                    }else if(data == 400){
                        mdui.snackbar({
                            message: '文件不可为空！',
                            timeout: '2000',
                            position: 'bottom',
                        });
                    }if(data == 700){
                        mdui.snackbar({
                            message: '身份过期！请重新登录！',
                            timeout: '2000',
                            position: 'bottom',
                        });
                        setTimeout(function () {
                            window.location.href='${pageContext.request.contextPath}/login/show';
                        },2000);
                    }
                },
            });
        });
    });
    function cmdEncryptIndex(pubexponent,pubmoulues) {
        RSAUtils.setMaxDigits(200);
        var key = new RSAUtils.getKeyPair(pubexponent,"",pubmoulues);
        var old_encrypedPwd = RSAUtils.encryptedString(key, $('#upold_passowrd').val());
        var upp_encrypedPwd = RSAUtils.encryptedString(key, $('#uppassowrd').val());
        var upre_encrypedPwd = RSAUtils.encryptedString(key,$('#upreload_passowrd').val());
        alert(old_encrypedPwd);
        alert(upp_encrypedPwd);
        alert(upre_encrypedPwd);
        $.ajax({
            url:'${pageContext.request.contextPath}/index/updateUserPass',
            dataType:"text",
            type:"post",
            data:{old_password:old_encrypedPwd,
                new_password:upp_encrypedPwd,
                new_re_passowrd:upre_encrypedPwd},
            success:function (data) {
                if(data == 100){
                    mdui.snackbar({
                        message: '密码修改失败!',
                        timeout: '2000',
                        position: 'bottom',
                    });
                }else if(data == 600){
                    mdui.snackbar({
                        message: '密码修改成功！请重新登录！',
                        timeout: '2000',
                        position: 'bottom',
                    });
                    setTimeout(function () {
                        window.location.href='${pageContext.request.contextPath}/login/show';
                    },2000);
                }else if(data == 300){
                    mdui.snackbar({
                        message: '两次密码输入不一致！',
                        timeout: '2000',
                        position: 'bottom',
                    });
                }else if(data == 400){
                    mdui.snackbar({
                        message: '旧密码不正确！',
                        timeout: '2000',
                        position: 'bottom',
                    });
                }else if(data == 500){
                    mdui.snackbar({
                        message: '解密失败！',
                        timeout: '2000',
                        position: 'bottom',
                    });
                }else if(data == 200){
                    mdui.snackbar({
                        message: '不能为空！',
                        timeout: '2000',
                        position: 'bottom',
                    });
                }else if(data == 700){
                    mdui.snackbar({
                        message: '身份过期！请重新登录！',
                        timeout: '2000',
                        position: 'bottom',
                    });
                    setTimeout(function () {
                        window.location.href='${pageContext.request.contextPath}/login/show';
                    },2000);
                }else if(data == 800){
                    mdui.snackbar({
                        message: '密码格式有误！',
                        timeout: '2000',
                        position: 'bottom',
                    });
                }
            }
        });
    }
  </script>
</head>
<body onload="init()" class="mdui-drawer-body-left mdui-appbar-with-toolbar mdui-theme-primary-indigo mdui-theme-accent-pink">
<%
  session.setAttribute("suoyin",1);
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
      <h1 class="mdui-text-color-theme" style="margin-top: 30px;margin-bottom: 30px">个人信息</h1>
      <div class="mdui-row">
          <div class="mdui-card mdui-shadow-7">
            <div class="mdui-card-media">
              <img style="height: 300px;background: url('../../img/1.jpg');">
              <div class="mdui-card-media-covered">
                <div class="mdui-card-primary">
                  <center>
                  <div class="mdui-card-primary-title">
                    <img id="head_img" src="${pageContext.request.contextPath}/img/user.png" style="height: 90px;width: 90px;border-radius: 50%;">
                  </div>
                    <div class="mdui-card-primary-subtitle" style="margin-top: 30px;font-size: 16px" id="head_rname"></div>
                    <div class="mdui-card-primary-subtitle" style="margin-top: 30px;font-size: 16px" id="signed">这个人很懒，没有个性签名</div>
                  </center>
                </div>
              </div>
            </div>
          </div>
        <div class="mdui-card mdui-shadow-16 mdui-col-sm-6 mdui-col-md-6">
          <div class="mdui-card-media">
            <h1 class="mdui-text-color-theme-accent mdui-ripple" style=" margin-top: 30px;margin-left: 10px;">
              <i class="mdui-icon material-icons mdui-text-color-theme-accent">&#xe86e;</i>
              详细信息</h1>
            <div class="mdui-typo" style="padding-left: 1em;">
              <blockquote>
                <p id="uname">姓名：</p>
                <p id="age">年龄：</p>
                <p id="sex">性别：</p>
                <p id="r_username">个性昵称：</p>
                <c:if test="${user.identity == '学生'}">
                  <p id="class">班级：</p>
                </c:if>
                <c:if test="${user.identity == '教职工'}">
                  <p id="class">任教班级：</p>
                </c:if>
                <p id="peoNum">学号/工号：</p>
                <p id="identity">身份：</p>
                <p id="email">邮箱：</p>
                <p id="retime">注册激活时间：</p>
              </blockquote>
            </div>
          </div>

          <div class="mdui-card-actions">
            <button class="mdui-btn mdui-ripple" disabled></button>
            <button class="mdui-btn mdui-ripple" disabled></button>
          </div>
        </div>
        <div class="mdui-card mdui-shadow-16 mdui-col-sm-6 mdui-col-md-6" style="padding-left: 16px;padding-right: 16px;">
          <div class="mdui-card-media">
            <h1 class="mdui-text-color-theme-accent mdui-ripple" style=" margin-top: 30px;">
              <i class="mdui-icon material-icons mdui-text-color-theme-accent">&#xe86e;</i>
              功能操作</h1>
            <div class="mdui-panel" mdui-panel="{accordion: true}">
              <div class="mdui-panel-item">
                <div class="mdui-panel-item-header mdui-color-light-blue mdui-text-color-white">
                  <div class="mdui-panel-item-title"><i class="mdui-icon material-icons" style="margin-right: 10px">&#xe88e;</i>信息修改</div>
                  <i class="mdui-panel-item-arrow mdui-icon material-icons">keyboard_arrow_down</i>
                </div>
                <div class="mdui-panel-item-body">
                  <div class="mdui-textfield mdui-textfield-floating-label">
                    <label class="mdui-textfield-label">修改个性昵称</label>
                    <input class="mdui-textfield-input" type="text" id="uprname" name="uprname" pattern="^\S{0,16}$" required/>
                    <div class="mdui-textfield-error">注意位数不可超过16位</div>
                  </div>
                  <div class="mdui-textfield mdui-textfield-floating-label">
                    <label class="mdui-textfield-label">修改邮箱</label>
                    <input class="mdui-textfield-input" type="email" id="upemail" name="upemail" required/>
                    <div class="mdui-textfield-error">邮箱格式有误！</div>
                  </div>
                  <div class="mdui-textfield mdui-textfield-floating-label">
                    <label class="mdui-textfield-label">修改个性签名</label>
                    <input class="mdui-textfield-input" type="text" id="upsinged" name="upsigned"/>
                  </div>
                  <div class="mdui-panel-item-actions">
                    <button class="mdui-btn mdui-ripple mdui-color-light-blue mdui-text-color-white" mdui-panel-item-close>取消</button>
                    <button class="mdui-btn mdui-ripple mdui-text-color-white mdui-color-light-blue" id="savainfo">保存</button>
                  </div>
                </div>
              </div>
              <div class="mdui-panel-item mdui-panel-item-open" style="margin-top:20px;">
                <div class="mdui-panel-item-header mdui-color-purple-400 mdui-text-color-white">
                  <div class="mdui-panel-item-title"><i class="mdui-icon material-icons" style="margin-right: 10px">&#xe853;</i>头像上传</div>
                  <i class="mdui-panel-item-arrow mdui-icon material-icons">keyboard_arrow_down</i>
                </div>
                <div class="mdui-panel-item-body">
                  <center>
                    <div class="upHead mdui-btn mdui-ripple">
                      <img src="../../img/user%20(1).png" style="background-size:cover;background-position:50%;width: 139px;height: 139px;border-radius: 50%;position: relative;top: -14px;right: 18px;" id="oInput_img">
                      <input type="file" id="oInput" onchange="showImg()" accept=".gif, .jpeg, .png, .bmp, .jpg">
                    </div>
                  </center>
                  <center><p id="op">点击头像框上传头像</p></center>
                  <div class="mdui-panel-item-actions">
                    <button class="mdui-btn mdui-ripple mdui-color-purple-400 mdui-text-color-white" mdui-panel-item-close>取消</button>
                    <button class="mdui-btn mdui-ripple mdui-text-color-white mdui-color-purple-400" id="savehead">保存</button>
                  </div>
                </div>
              </div>

              <div class="mdui-panel-item" style="margin-top:20px;margin-bottom: 25px;">
                <div class="mdui-panel-item-header mdui-color-red mdui-text-color-white">
                  <div class="mdui-panel-item-title"><i class="mdui-icon material-icons" style="margin-right: 10px">&#xe0da;</i>密码修改</div>
                  <i class="mdui-panel-item-arrow mdui-icon material-icons">keyboard_arrow_down</i>
                </div>
                <div class="mdui-panel-item-body">
                  <div class="mdui-textfield mdui-textfield-floating-label">
                    <label class="mdui-textfield-label">旧密码</label>
                    <input class="mdui-textfield-input" type="password" id="upold_passowrd" name="upold_password" required/>
                    <div class="mdui-textfield-error">不能为空</div>
                  </div>
                  <div class="mdui-textfield mdui-textfield-floating-label">
                    <label class="mdui-textfield-label">新密码</label>
                    <input class="mdui-textfield-input" type="password" id="uppassowrd" name="uppassword" pattern="^\S{6,16}$" required/>
                    <div class="mdui-textfield-error">密码至少 6 位最多16为且不能为空</div>
                  </div>
                  <div class="mdui-textfield mdui-textfield-floating-label">
                    <label class="mdui-textfield-label">重复输入密码</label>
                    <input class="mdui-textfield-input" type="password" id="upreload_passowrd" pattern="^\S{6,16}$" name="upreload_password" required/>
                    <div class="mdui-textfield-error">密码至少 6 位最多16为且不能为空</div>
                  </div>
                  <div class="mdui-panel-item-actions">
                    <button class="mdui-btn mdui-ripple mdui-color-red mdui-text-color-white" mdui-panel-item-close>取消</button>
                    <button class="mdui-btn mdui-ripple mdui-text-color-white mdui-color-red" id="savapassword">保存</button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  <jsp:include page="theme.jsp"/>
  <jsp:include page="bottom.jsp"/>
  <div class="mdui-dialog" id="admins">
    <div class="mdui-dialog-title">欢迎使用学生信息管理平台</div>
    <div class="mdui-dialog-content">管理员每次登录都将看到此提示：如果你是第一次使用本系统，那么请进入“学校人员信息管理”，导入您学校调研审核完毕的excel表格（仅支持xls）文件。或者您也可以手动导入一个新的人物信息，这个功能是为后来报名 后来入学或者后来进入学校的人所准备的。希望您做好一个管理员的职责，全部导入完毕后，您可以通知该校师生可以使用该系统。您拥有系统的所有权限，包括自主修改数据库和源码，部署系统的权限。而教职工仅拥有修改学生成绩能力。祝您使用愉快！</div>
    <div class="mdui-dialog-actions">
      <button class="mdui-btn mdui-ripple" mdui-dialog-cancel>已读</button>
    </div>
  </div>
</body>
</html>
