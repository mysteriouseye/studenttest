<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!doctype html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>登录   -  学生信息管理系统</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/mdui.css"/>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/login.css"/>
    <script src="${pageContext.request.contextPath}/js/mdui.js"></script>
    <script src="${pageContext.request.contextPath}/js/jquery.js"></script>
    <script src="${pageContext.request.contextPath}/js/security.js"></script>
    <script>
        function init() {
            mdui.mutation();
            document.getElementById("code").innerHTML="";
            if(!isPc()){
                var header = $("#headerback").find("div");
                for(var i = 0;i< header.length;i++){
                    $(header).addClass("slideshow-blur");
                }
                updatecss();
            }else {
                if(!isEdges()){
                    updatecss();
                }
            }
        }
        function updatecss() {
            $("#loginback").removeClass("top-color");
            $("#loginback").addClass("top-color-mobile");
            $("#loginbottom").removeClass("card-bottom");
            $("#loginbottom").addClass("card-bottom-mobile");

            $("#regback").removeClass("top-color");
            $("#regback").addClass("top-color-mobile");
            $("#regbottom").removeClass("card-bottom");
            $("#regbottom").addClass("card-bottom-mobile");

            $("#forgetback").removeClass("top-color");
            $("#forgetback").addClass("top-color-mobile");
            $("#forgetbottom").removeClass("card-bottom");
            $("#forgetbottom").addClass("card-bottom-mobile");
        }
        function isPc() {
            var userAgent = navigator.userAgent;
            var Agents = ["Android","Android 9","iPhone",
                "SymbianOS", "Windows Phone"];
            for(var v = 0;v < Agents.length;v++){
                if(userAgent.indexOf(Agents[v])>0){
                    return false;
                }else {
                    return true;
                }
            }
        }
        function isEdges() {
            var userAgent = navigator.userAgent;
            var isEdge = userAgent.indexOf("Edge");
            if(isEdge > -1){
                return true;
            }else {
                return false;
            }
        }
        $(function(){
            $("#regia").click(function () {
                $("#regform").addClass("animated zoomIn");
                $("#regform").css("display","block");
                $("#loginform").css("display","none");
            });
            $("#logina").click(function () {
                $("#loginform").addClass("animated zoomIn");
                $("#loginform").css("display","block");
                $("#regform").css("display","none");
            });
            $("#forget").click(function () {
                $("#forgetform").addClass("animated zoomIn");
                $("#forgetform").css("display","block");
                $("#loginform").css("display","none");
            });
            $("#forlogina").click(function () {
                $("#loginform").addClass("animated zoomIn");
                $("#loginform").css("display","block");
                $("#forgetform").css("display","none");
            });
            $("#loginbutton").bind('click',function () {
                $.ajax({
                    url:'${pageContext.request.contextPath}/login/loginRsa',
                    dataType:"text",
                    type:"post",
                    data:{name:$("#name").val(),password:$("#password").val(),code:$("#code").val()},
                    success:function (data) {
                        var val = $('#password').val();
                        var str = val.replace(/(^\s*)|(\s*$)/g, '');//去除空格;
                        if(str != "" || str == undefined || str == null){
                            var jn = $.parseJSON(data);
                            if(jn.error != 404 && jn.error != 500){
                                pubexponent = jn.pubexponent;
                                pubmoulues = jn.pubmoulues;
                                cmdEncrypt(pubexponent,pubmoulues);
                            }else if(jn.error == 500){
                                mdui.snackbar({
                                    message: '用户名密码验证码不能为空！',
                                    timeout: '2000',
                                    position: 'bottom',
                                });
                            }else if(jn.error == 404){
                                mdui.snackbar({
                                    message: '密码加密失败，可能是服务器文件错误！',
                                    timeout: '2000',
                                    position: 'bottom',
                                });
                            }

                        }else {
                            mdui.snackbar({
                                message: '密码不可为空!',
                                timeout: '2000',
                                position: 'bottom',
                            });
                        }
                    },
                    error:function () {

                    }
                });
            });
            $('#regbutton').click(function () {
                $.ajax({
                    url:'${pageContext.request.contextPath}/regist/registRsa',
                    dataType:"text",
                    type:"post",
                    data:{repassword:$("#repassword").val()},
                    success:function (data) {
                        var val = $('#repassword').val();
                        var str = val.replace(/(^\s*)|(\s*$)/g, '');//去除空格;
                        if(str != "" || str == undefined || str == null){
                            var jn = $.parseJSON(data);
                            if(jn.error != 404 && jn.error != 505){
                                pubexponent = jn.pubexponent;
                                pubmoulues = jn.pubmoulues;
                                cmdEncryptRegist(pubexponent,pubmoulues);
                            }else if(jn.error == 505){
                                mdui.snackbar({
                                    message: '密码不能为空且不能小于6位大于16位！',
                                    timeout: '2000',
                                    position: 'bottom',
                                });
                            }else if(jn.error == 404){
                                mdui.snackbar({
                                    message: '密码加密失败，可能是服务器文件错误！',
                                    timeout: '2000',
                                    position: 'bottom',
                                });
                            }
                        }else {
                            mdui.snackbar({
                                message: '密码不可为空!',
                                timeout: '2000',
                                position: 'bottom',
                            });
                        }
                    },
                    error:function () {

                    }
                });
            });
            $('#foregbutton').click(function () {
                $.ajax({
                    url:'${pageContext.request.contextPath}/login/forgetRsa',
                    dataType:"text",
                    type:"post",
                    success:function (data) {
                        var val = $('#forpassword').val();
                        var str = val.replace(/(^\s*)|(\s*$)/g, '');//去除空格;
                        if(str != "" || str == undefined || str == null){
                            var jn = $.parseJSON(data);
                            if(jn.error != 404){
                                pubexponent = jn.pubexponent;
                                pubmoulues = jn.pubmoulues;
                                cmdEncryptForget(pubexponent,pubmoulues);
                            }else {
                                mdui.snackbar({
                                    message: '密码加密失败!可能是服务器文件错误！',
                                    timeout: '2000',
                                    position: 'bottom',
                                });
                            }
                        }else {
                            mdui.snackbar({
                                message: '密码不可为空!',
                                timeout: '2000',
                                position: 'bottom',
                            });
                        }
                    },
                    error:function () {

                    }
                });
            });
            $("#codeClick").click(function () {
                $.ajax({
                    url:'${pageContext.request.contextPath}/regist/sendmail',
                    dataType:"text",
                    type:"post",
                    data:{peoNum:$("#peoNum").val(),email:$("#email").val()},
                    success:function(data){
                        if(data == 200){
                            mdui.snackbar({
                                message: '工单号或邮箱不能为空或是格式错误!',
                                timeout: '2000',
                                position: 'bottom',
                            });
                            $("#codeClick").attr("disabled",false);
                            $("#codeClick").text("获取验证码");
                            clearTimeout(t1);
                            countdown = 60;
                        }else if(data == 500){
                            mdui.snackbar({
                                message: '工单号和邮箱对应错误!或是账户已经激活！',
                                timeout: '2000',
                                position: 'bottom',
                            });
                            $("#codeClick").attr("disabled",false);
                            $("#codeClick").text("获取验证码");
                            clearTimeout(t1);
                            countdown = 60;
                        }else if(data == 300){
                            mdui.snackbar({
                                message: '发送成功!几秒后请注意查收！',
                                timeout: '2000',
                                position: 'bottom',
                            });
                        }
                    },
                    error:function () {

                    }
                });
            });
            $("#forcodeClick").click(function () {
                $.ajax({
                    url:'${pageContext.request.contextPath}/login/forgetMail',
                    dataType:"text",
                    type:"post",
                    data:{foremail:$("#foremail").val()},
                    success:function(data){
                        if(data == 200){
                            mdui.snackbar({
                                message: '不存在此账户！或是账户未激活！',
                                timeout: '2000',
                                position: 'bottom',
                            });
                            $("#forcodeClick").attr("disabled",false);
                            $("#forcodeClick").text("获取验证码");
                            clearTimeout(t2);
                            countdown2 = 60;
                        }else if(data == 400){
                            mdui.snackbar({
                                message: '邮箱格式有误或为空!',
                                timeout: '2000',
                                position: 'bottom',
                            });
                            $("#forcodeClick").attr("disabled",false);
                            $("#forcodeClick").text("获取验证码");
                            clearTimeout(t2);
                            countdown2 = 60;
                        }else if(data == 300){
                            mdui.snackbar({
                                message: '发送成功!几秒后注意查收！',
                                timeout: '2000',
                                position: 'bottom',
                            });

                        }else if(data == 100){
                            mdui.snackbar({
                                message: '服务器错误!',
                                timeout: '2000',
                                position: 'bottom',
                            });
                            $("#forcodeClick").attr("disabled",false);
                            $("#forcodeClick").text("获取验证码");
                            clearTimeout(t2);
                            countdown2 = 60;
                        }
                    },
                    error:function () {

                    }
                });
            })

        });
        var countdown=60;
        var t1;
        function settime(val) {
            if(countdown == 0){
                val.removeAttribute("disabled");
                val.innerHTML =  "获取验证码";
                countdown = 60;
            }else {
                val.setAttribute("disabled",true);
                val.innerHTML = "重新发送"+"("+countdown+")";
                countdown--;
                t1 = setTimeout(function () {
                    settime(val);
                },1000);
            }

        }
        var countdown2 = 60;
        var t2;
        function settime2(val) {
            if(countdown2 == 0){
                val.removeAttribute("disabled");
                val.innerHTML =  "获取验证码";
                countdown2 = 60;
            }else {
                val.setAttribute("disabled",true);
                val.innerHTML = "重新发送"+"("+countdown2+")";
                countdown2--;
                t2 = setTimeout(function () {
                    settime2(val);
                },1000);
            }

        }
        function changeImg() {
            var imgSrc = $("#cls");
            var src = imgSrc.attr("src");
            imgSrc.attr("src", chgUrl(src));
        }

        //加入时间戳，去缓存机制
        function chgUrl(url) {
            var timestamp = (new Date()).valueOf();if ((url.indexOf("&") >= 0)) {
                url = url + "&timestamp=" + timestamp;
            } else {
                url = url + "?timestamp=" + timestamp;
            }
            return url;
        }
        function cmdEncrypt(pubexponent,pubmoulues) {
            RSAUtils.setMaxDigits(200);
            var key = new RSAUtils.getKeyPair(pubexponent,"",pubmoulues);
            var encrypedPwd = RSAUtils.encryptedString(key, $('#password').val());
            $.ajax({
                url:'${pageContext.request.contextPath}/login/loginCheck',
                dataType:"text",
                type:"post",
                data:{name:$("#name").val(),password:encrypedPwd,code:$("#code").val()},
                success:function (data) {

                    if(data == 200){
                        mdui.snackbar({
                            message: '用户名、密码和验证码不能为空!',
                            timeout: '2000',
                            position: 'bottom',
                        });
                    }else if(data == 300){
                        mdui.snackbar({
                            message: '用户名、密码或验证码错误!或是你没有注册激活！',
                            timeout: '2000',
                            position: 'bottom',
                        });
                    }else if(data == 100){
                        mdui.snackbar({
                            message: '用户名、密码或验证码错误!或是你没有注册激活！',
                            timeout: '2000',
                            position: 'bottom',
                        });
                    }else if(data == 600){
                        document.forms[0].submit();
                    }
                }
            });
        }
        function cmdEncryptForget(pubexponent,pubmoulues) {
            RSAUtils.setMaxDigits(200);
            var key = new RSAUtils.getKeyPair(pubexponent,"",pubmoulues);
            var encrypedPwd = RSAUtils.encryptedString(key, $('#forpassword').val());
            $.ajax({
                url:'${pageContext.request.contextPath}/login/forgetAction',
                dataType:"text",
                type:"post",
                data:{foremail:$("#foremail").val(),forpassword:encrypedPwd,foremailCode:$("#foremailCode").val()},
                success:function (data) {
                    if(data == 400){
                        mdui.snackbar({
                            message: '邮箱、密码和验证码不能为空!或是邮箱格式错误！',
                            timeout: '2000',
                            position: 'bottom',
                        });
                    }else if(data == 200){
                        mdui.snackbar({
                            message: '用户不存在！或者该用户没有注册！',
                            timeout: '2000',
                            position: 'bottom',
                        });
                    }else if(data == 100){
                        mdui.snackbar({
                            message: '验证码错误！',
                            timeout: '2000',
                            position: 'bottom',
                        });
                    }else if(data == 300){
                        mdui.snackbar({
                            message: '服务器错误！',
                            timeout: '2000',
                            position: 'bottom',
                        });
                    }else if(data == 600){
                        mdui.snackbar({
                            message: '修改失败！请稍后重试',
                            timeout: '2000',
                            position: 'bottom',
                        });
                    }else if(data == 700){
                        mdui.snackbar({
                            message: '修改成功！请登录吧！',
                            timeout: '2000',
                            position: 'bottom',
                        });
                        setTimeout(function () {
                            window.location.href='${pageContext.request.contextPath}/login/show';
                        },2000);
                    }else if(data == 800) {
                        mdui.snackbar({
                            message: '密码格式有误！',
                            timeout: '2000',
                            position: 'bottom',
                        });
                    }
                }
            });
        }
        function cmdEncryptRegist(pubexponent,pubmoulues) {
            RSAUtils.setMaxDigits(200);
            var key = new RSAUtils.getKeyPair(pubexponent,"",pubmoulues);
            var encrypedPwd = RSAUtils.encryptedString(key, $('#repassword').val());
            $.ajax({
                url:'${pageContext.request.contextPath}/regist/active',
                dataType:"text",
                type:"post",
                data:{reguname:$("#reguname").val(),
                    repassword:encrypedPwd,
                    peoNum:$("#peoNum").val(),
                    email:$("#email").val(),
                    emailCode:$('#emailCode').val()},
                success:function (data) {
                    if(data == 200){
                        mdui.snackbar({
                            message: '用户名、工单号、密码和邮箱不能为空!',
                            timeout: '2000',
                            position: 'bottom',
                        });
                    }else if(data == 300){
                        mdui.snackbar({
                            message: '验证码不正确！',
                            timeout: '2000',
                            position: 'bottom',
                        });
                    }else if(data == 100){
                        mdui.snackbar({
                            message: '用户名已经被其他人注册！',
                            timeout: '2000',
                            position: 'bottom',
                        });
                    }else if(data == 500){
                        mdui.snackbar({
                            message: '工单号和邮箱对应错误!',
                            timeout: '2000',
                            position: 'bottom',
                        });
                    }else if(data == 600){
                        mdui.snackbar({
                            message: '注册失败!',
                            timeout: '2000',
                            position: 'bottom',
                        });
                    }else if(data == 700){
                        mdui.snackbar({
                            message: '注册成功!',
                            timeout: '2000',
                            position: 'bottom',
                        });
                        setTimeout(function () {
                            window.location.href='${pageContext.request.contextPath}/login/show';
                        },2000);
                    }else if(data == 800){
                        mdui.snackbar({
                            message: '存在格式错误!请检查',
                            timeout: '2000',
                            position: 'bottom',
                        });
                    }
                },
                error:function () {

                }
            });
            return true;
        }
    </script>
</head>

<body onload="init()" class="fadeInDown isStuckanimate animated">

<header class="mdui-color-theme" style="background-color: transparent;position: relative;">
    <div class="mdui-toolbar mdui-container">
        <i class="mdui-icon material-icons mdui-text-color-white" style="margin-right: 0px;margin-left: 17px;">&#xe853;</i>
        <a href="/" class="mdui-typo-headline" style="color: white">学生信息管理系统</a>
        <div class="mdui-toolbar-spacer" style="height: 20px;"></div>
        <button class="mdui-ripple mdui-btn homebutton" value="Home" onclick="javascrtpt:window.location.href='/login/show'">
            <img src="${pageContext.request.contextPath}/img/home.png" style="width: 40px;width: 40px;">
        </button>
    </div>
</header>

<div id="headerback" class="slideshow" style="width: 100%;height: 393px;position: relative;top:-56px;z-index: -1;">
    <div class="slideshow-image" style="background-image: url('${pageContext.request.contextPath}/img/1.jpg');background-repeat:no-repeat;}
"></div>
    <div class="slideshow-image" style="background-image: url('${pageContext.request.contextPath}/img/2.jpg');background-repeat:no-repeat;}
"></div>
    <div class="slideshow-image" style="background-image: url('${pageContext.request.contextPath}/img/3.jpg');background-repeat:no-repeat;}
"></div>
    <div class="slideshow-image" style="background-image: url('${pageContext.request.contextPath}/img/4.jpg');background-repeat:no-repeat;}
"></div>
    <div class="slideshow-image" style="background-image: url('${pageContext.request.contextPath}/img/5.jpg');background-repeat:no-repeat;}
"></div>
</div>

<div class="containers main">
    <div class="col"></div>
    <div class="col">
        <div class="jumbotron mdui-hoverable" id="loginform">
            <div class="card-top">
                <div class="rpw top-color" id="loginback">
                    <div class="card-top-rpw">
                        <div class="login-icon">
                            <img src="${pageContext.request.contextPath}/img/user.png" style="width: 40px;height: 40px;">
                        </div>
                        <div class="login-text">请登录</div>
                    </div>
                </div>
            </div>
            <div class="card-bottom" id="loginbottom">
                <div class="bottom-width">
                    <form action="${pageContext.request.contextPath}/login/loginAction" id="logins" id="logform" method="post">
                        <div class="mdui-textfield mdui-textfield-floating-label">
                            <label class="mdui-textfield-label">用户名/邮箱/学号(工号)</label>
                            <input class="mdui-textfield-input" type="text" id="name" name="name" required/>
                            <div class="mdui-textfield-error">不能为空</div>
                        </div>
                        <div class="mdui-textfield mdui-textfield-floating-label">
                            <label class="mdui-textfield-label">密码</label>
                            <input class="mdui-textfield-input" type="password" id="password" name="password"required/>
                            <div class="mdui-textfield-error">密码不能为空!</div>
                        </div>
                    </form>
                    <div class="mdui-textfield mdui-textfield-floating-label" style="margin-right: 0px; margin-top: -13px;">
                        <label class="mdui-textfield-label">验证码</label>
                        <input class="mdui-textfield-input" type="type" style="width: 130px;" id="code" name="code" required/>
                        <img id="cls" src="${pageContext.request.contextPath}/login/code" onclick="changeImg()" style="position: relative;top:-40px;right: -160px;width: 120px;">
                        <div class="mdui-textfield-error">不能为空</div>
                    </div>
                    <button class="mdui-btn mdui-btn-raised mdui-ripple mdui-color-theme-accent" style="background-color: #00b0ff; color: white;width: 130px;margin-top: -6px" id="loginbutton">登录</button>
                    <div class="mdui-typo-subheading" style="margin-top: 20px;"><a href="javascript:;" style="text-decoration: none;color: #00b0ff" id="regia">注册激活账户</a></div>
                    <div class="mdui-typo-subheading" style="margin-top: 20px;"><a href="javascript:;" style="text-decoration: none;color: #00b0ff" id="forget">忘记了密码？</a></div>
                </div>
            </div>
        </div>
        <div class="jumbotron mdui-hoverable" id="regform" style="display: none">
            <div class="card-top">
                <div class="rpw top-color" id="regback">
                    <div class="card-top-rpw">
                        <div class="login-icon">
                            <img src="${pageContext.request.contextPath}/img/regist.png" style="width: 40px;height: 40px;">
                        </div>
                        <div class="login-text">注册激活账户</div>
                    </div>
                </div>
            </div>
            <div class="card-bottom" id="regbottom">
                <div class="bottom-width">
                        <div class="mdui-textfield mdui-textfield-floating-label">
                            <label class="mdui-textfield-label">用户名/个性昵称</label>
                            <input class="mdui-textfield-input" type="text" id="reguname" name="reguname" pattern="^\S{0,16}$" required/>
                            <div class="mdui-textfield-error">不能为空且不可超过16位</div>
                        </div>
                        <div class="mdui-textfield mdui-textfield-floating-label">
                            <label class="mdui-textfield-label">请输入学号/教师工号</label>
                            <input class="mdui-textfield-input" type="text" id="peoNum" name="peoNum" required/>
                            <div class="mdui-textfield-error">不能为空</div>
                        </div>
                        <div class="mdui-textfield mdui-textfield-floating-label">
                            <label class="mdui-textfield-label">设置密码</label>
                            <input class="mdui-textfield-input" type="password" id="repassword" name="repassword" pattern="^\S{6,16}$" required/>
                            <div class="mdui-textfield-error">密码至少 6 位最多16为且不能为空</div>
                        </div>
                        <div class="mdui-textfield mdui-textfield-floating-label">
                            <label class="mdui-textfield-label">邮箱（填写工单时提供的邮箱）</label>
                            <input class="mdui-textfield-input" type="email" id="email" name="email" required/>
                            <div class="mdui-textfield-error">邮箱格式错误</div>
                        </div>
                        <div class="mdui-textfield mdui-textfield-floating-label" style="height: 50px;">
                            <label class="mdui-textfield-label">邮箱验证码</label>
                            <input class="mdui-textfield-input" type="text" style="width: 130px;" id="emailCode" name="emailCode"/>
                            <button class="mdui-btn mdui-btn-raised mdui-ripple mdui-color-theme-accent" id="codeClick" style="position: relative;top:-40px;right: -160px;width: 120px;background-color: #00b0ff;color: white;" onclick="settime(this)">获取验证码</button>
                        </div>
                    <button class="mdui-btn mdui-btn-raised mdui-ripple mdui-color-theme-accent" style="margin-top:17px;background-color: #00b0ff; color: white;width: 130px;" id="regbutton">注册</button>
                    <div class="mdui-typo-subheading" style="margin-top: 20px;"><a href="javascript:;" style="text-decoration: none;color: #00b0ff" id="logina">已有账户登录</a></div>
                </div>
            </div>
        </div>
        <div class="jumbotron mdui-hoverable" id="forgetform" style="display: none">
            <div class="card-top">
                <div class="rpw top-color" id="forgetback">
                    <div class="card-top-rpw">
                        <div class="login-icon">
                            <i class="mdui-icon material-icons" style="width:40px;height: 40px;font-size: 30px">&#xe887;</i>
                        </div>
                        <div class="login-text">密码找回</div>
                    </div>
                </div>
            </div>
            <div class="card-bottom" id="forgetbottom">
                <div class="bottom-width">
                        <div class="mdui-textfield mdui-textfield-floating-label">
                            <label class="mdui-textfield-label">邮箱</label>
                            <input class="mdui-textfield-input" type="email" id="foremail" name="foremail" required/>
                            <div class="mdui-textfield-error">邮箱格式错误</div>
                        </div>
                        <div class="mdui-textfield mdui-textfield-floating-label">
                            <label class="mdui-textfield-label">设置新密码</label>
                            <input class="mdui-textfield-input" type="password" id="forpassword" name="forpassword" pattern="^\S{6,16}$" required/>
                            <div class="mdui-textfield-error">密码至少6位最多16为且不能为空</div>
                        </div>
                        <div class="mdui-textfield mdui-textfield-floating-label" style="height: 50px;">
                            <label class="mdui-textfield-label">邮箱验证码</label>
                            <input class="mdui-textfield-input" type="text" style="width: 130px;" id="foremailCode" name="foremailCode" required/>
                            <button class="mdui-btn mdui-btn-raised mdui-ripple mdui-color-theme-accent" id="forcodeClick" style="position: relative;top:-40px;right: -160px;width: 120px;background-color: #00b0ff;color: white;" onclick="settime2(this)">获取验证码</button>
                            <div class="mdui-textfield-error">不能为空</div>
                        </div>
                    <button class="mdui-btn mdui-btn-raised mdui-ripple mdui-color-theme-accent" style="margin-top:17px;background-color: #00b0ff; color: white;width: 130px;" id="foregbutton">修改</button>
                    <div class="mdui-typo-subheading" style="margin-top: 20px;"><a href="javascript:;" style="text-decoration: none;color: #00b0ff" id="forlogina">已有账户登录</a></div>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="mdui-dialog" id="dialogs">
    <div class="mdui-dialog-title">Are you sure?</div>
    <div class="mdui-dialog-content">You'll lose all photos and media!</div>
    <div class="mdui-dialog-actions">
        <button class="mdui-btn mdui-ripple">cancel</button>
        <button class="mdui-btn mdui-ripple">erase</button>
    </div>
</div>
</body>
</html>