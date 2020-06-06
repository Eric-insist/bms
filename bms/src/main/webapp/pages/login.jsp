<%@ page language="java" isELIgnored="false" import="java.util.*"
         pageEncoding="utf-8" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>
<!doctype html>
<html lang="zh-cn">
<head>
    <title>学生宿舍管理系统</title>
    <link rel="icon" href="<%=basePath%>/image/bedroom.jpg">
    <link rel="stylesheet" href="<%=basePath%>/js/layui/css/layui.css">
    <script src="<%=basePath%>/js/layui/jquery-3.4.1.min.js"></script>
    <script src="<%=basePath%>/js/layui/layui.js"></script>
    <link href="<%=basePath%>/js/layui/css/layui.css" rel="stylesheet" type="text/css"/>
    <link href="<%=basePath%>/css/login.css" rel="stylesheet" type="text/css" />
</head>
<body>
<div class="banner" style="background: #2f2f4f;height: 320px">

    <div style="font-size: 40px; position: relative; top: 12%; color: #ffffff">
        <div style="padding-top: 60px">学生宿舍管理系统
        </div>
    </div>
</div>
<div class="login_box" style="top:240px;">
    <form id="loginForm" name="loginForm" id="view_jsp_loginForm" class="layui-form">
        <h1 class="title">用户登录</h1>
        <div class="login_box_input">
            <p id="codeerr" class="error" style="visibility: hidden;"></p>
            <input type="text" class="lname" name="account" autocomplete="off"
                   id="view_jsp_loginname" placeholder="用户名" required
                   lay-verify='required' lay-filter="view_jsp_loginname"> <input
                type="password" class="lpass" name="pwd" autocomplete="off"
                id="view_jsp_password" placeholder="密码" required
                lay-verify='required' lay-filter="view_jsp_password">
            <button id="view_jsp_loginBtn" class="btn_login layui-btn" style="background-color: #0c7cd5" id="loginBtn"
                    type="button" lay-filter="login-btn" lay-submit>登录
            </button>
        </div>
    </form>
</div>

<script type="text/javascript">
    layui.use(['form', 'jquery', 'layer'], function () {
        var form = layui.form;
        var $ = layui.$;
        var layer = layui.layer;

        //变更验证码
        <%-- $('#codeImg').click(function(){
            $(this).attr('src','<%=basePath%>home/getVerifyCode?x='+Math.floor(Math.random()*100));
        }); --%>

        //渲染表单
        form.render();

        //表单验证
        form.verify({
            codepattern: [
                /^[[0-9a-zA-Z]{4}$/,
                '验证码格式错误'
            ]
        });

        //提交表单发送请求
        form.on('submit(login-btn)', function (data) {
            $.ajax({
                url: '<%=basePath%>login/login',
                data: data.field,
                type:'post',
                // dataType: 'json',
                success: function (datav) {
                    console.log(datav);
                    if (datav.code == 0) {
                        window.location.href = '<%=basePath%>' + datav.data.gotoUrl;
                    } else {
                        layer.msg(datav.data.msg);
                    }
                }
            });
            return false;
        });

    });

    $(document).ready(function() {
        // 在这里写你的代码...
        $("input[name='account']").keypress(function(e){
            if(e.keyCode == 13){
                $("input[name='pwd']").focus();
            }
        });
        $("input[name='pwd']").keypress(function(e){
            if(e.keyCode == 13){
                $.ajax({
                    url: '<%=basePath%>login/login',
                    data: {"account":$("input[name='account']").val(),"pwd":$("input[name='pwd']").val()},
                    type:'post',
                    // dataType: 'json',
                    success: function (data) {
                        if (data.code == 0) {
                            window.location.href = '<%=basePath%>' + data.data.gotoUrl;
                        } else {
                            layer.msg(data.data.msg);
                        }
                    }
                });
            }
        });
    });
</script>
</body>
</html>