<%@ page import="com.bms.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>
<%--<%--%>
<%--    User user = (User) session.getAttribute("user");--%>
<%--    if (user == null) {--%>
<%--        response.sendRedirect(basePath);--%>
<%--        return;--%>
<%--    }--%>
<%--%>--%>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>学生宿舍管理系统</title>
    <link rel="icon" href="<%=basePath%>/image/bedroom.jpg">
    <link rel="stylesheet" href="<%=basePath%>/js/layui/css/layui.css">
    <script src="<%=basePath%>/js/layui/jquery-3.4.1.min.js"></script>
    <script src="<%=basePath%>/js/layui/layui.js"></script>
<%--    <script src="<%=basePath%>/js/layui/extends/excel.js"></script>--%>
    <link href="<%=basePath%>/js/layui/css/layui.css" rel="stylesheet" type="text/css"/>
</head>
<sitemesh:write property='head'/>
<body class="layui-layout-body">
<style type="text/css">
    a {
        text-decoration: none !important;
    }

    body .demo-class .layui-layer-title {
        background: #000;
        color: #fff;
        border: none;
    }

    body .demo-class .layui-layer-btn {
        border-top: 1px solid #E9E7E7
    }

    body .demo-class .layui-layer-btn a {
        background: #000;
    }

    body .demo-class .layui-layer-btn .layui-layer-btn1 {
        background: #fff;
    }

    .apply-msg {
        width: 120px;
        height: 48px;
        background-color: rgba(0, 0, 0, .6);
        text-align: center;
        line-height: 48px;
        word-break: break-all;
        overflow: hidden;
        font-size: 14px;
        color: #ffffff;
    }

    .layui-table-tool-panel {
        display: none;
    }

    .ddclass {
        margin-left: 25px;
    }

</style>
<div class="layui-layout layui-layout-admin">
    <div class="layui-header" style="min-width: 995px;">
        <div id="logo" class="layui-logo" style="color:white;min-width: 200px;">
            <div>
                <img src="<%=basePath%>/image/bedroom.jpg" class="layui-nav-img" style="width: 32px;margin-top: -1%;">学生宿舍管理系统
                <i id="shrink-i" class="layui-icon layui-icon-shrink-right"></i>
            </div>
        </div>

        <ul class="layui-nav layui-layout-right">
            <li class="layui-nav-item">
                <a href="javascript:;">
                    当前用户：${sessionScope.user.name}
                </a>
                <dl class="layui-nav-child">
                    <%--                    <dd>--%>
                    <%--                        <a  href="#" onclick="personal()">个人中心</a>--%>
                    <%--                    </dd>--%>
                    <dd>
                        <a href="#" onclick="editPass()">修改密码</a>
                    </dd>
                    <dd>
                        <a href="<%=basePath%>logout" onclick="logout()">退出系统</a>
                    </dd>
                </dl>
            </li>
            <li class="layui-nav-item"><a
                    href="javascript:;">所属集体：${sessionScope.organ.parentName}${sessionScope.organ.organName}</a></li>
        </ul>
    </div>

    <div id="layui-side" class="layui-side layui-bg-black">
        <div id="layui-side-scroll" class="layui-side-scroll">
            <!-- 左侧垂直导航区域-->
            <ul class="layui-nav layui-nav-tree" lay-filter="test">
                <c:if test="${sessionScope.user.roleId== 1 || sessionScope.user.roleId== 2}">
                    <li class="layui-nav-item  <c:if test="${navigate<=10}">layui-nav-itemed</c:if> ">
                        <a class="" href="javascript:;"><i class='layui-icon layui-icon-app' style="color: #EEB422"></i>&nbsp;宿舍管理</a>
                        <dl class="layui-nav-child">
                            <dd class="<c:if test="${navigate==1}">layui-this</c:if> ddclass">
                                <a href="javascript:;" data-id="1" data-title="宿舍列表"
                                   data-url="<%=basePath%>gotoBedroomList?navigate=1"
                                   class="site-demo-active" data-type="tabAdd" onclick="addLog(sslb)">宿舍列表</a></dd>
                                <%--                            <c:if test="${sessionScope.user.roleId== 4}">--%>
                                <%--                                <dd class="<c:if test="${navigate==2}">layui-this</c:if> ddclass">--%>
                                <%--                                    <a href="javascript:;" data-id="2" data-title="宿舍信息"--%>
                                <%--                                       data-url="<%=basePath%>gotoBedroom?navigate=2"--%>
                                <%--                                       class="site-demo-active" data-type="tabAdd">宿舍信息</a></dd>--%>
                                <%--                            </c:if>--%>
                            <dd class="<c:if test="${navigate==2}">layui-this</c:if> ddclass">
                                <a href="javascript:;" data-id="2" data-title="外来人员登记"
                                   data-url="<%=basePath%>gotoOutsidersList?navigate=2"
                                   class="site-demo-active" data-type="tabAdd" onclick="addLog(wlrydj)">外来人员登记</a></dd>
                        </dl>
                    </li>
                </c:if>
                <c:if test="${sessionScope.user.roleId== 1 || sessionScope.user.roleId== 2}">
                    <li class="layui-nav-item  <c:if test="${navigate>10 && navigate <=20}">layui-nav-itemed</c:if> ">
                        <a class="" href="javascript:;"><i class='layui-icon layui-icon-app' style="color: #EEB422"></i>&nbsp;住宿管理</a>
                        <dl class="layui-nav-child">
                            <dd class="<c:if test="${navigate==11}">layui-this</c:if> ddclass">
                                <a href="javascript:;" data-id="11" data-title="入住办理"
                                   data-url="<%=basePath%>inBedroom?navigate=11"
                                   class="site-demo-active" data-type="tabAdd" onclick="addLog(rzbl)">入住办理</a></dd>
                            <dd class="<c:if test="${navigate==12}">layui-this</c:if> ddclass">
                                <a href="javascript:;" data-id="12" data-title="迁出办理"
                                   data-url="<%=basePath%>outBedroom?navigate=12"
                                   class="site-demo-active" data-type="tabAdd"  onclick="addLog(qcbl)">迁出办理</a></dd>
                        </dl>
                    </li>
                </c:if>

                <%--                <c:if test="${sessionScope.user.roleId== 1 || sessionScope.user.roleId== 2 || sessionScope.user.roleId == 3}">--%>
                <li class="layui-nav-item  <c:if test="${navigate>20 && navigate <=30}">layui-nav-itemed</c:if> ">
                    <a class="" href="javascript:;"><i class='layui-icon layui-icon-app' style="color: #EEB422"></i>&nbsp;学生中心</a>
                    <c:if test="${sessionScope.user.roleId!= 4}">
                        <c:if test="${sessionScope.user.roleId == 1}">
                            <dl class="layui-nav-child">
                                <dd class="<c:if test="${navigate==21}">layui-this</c:if> ddclass">
                                    <a href="javascript:;" data-id="21" data-title="学生列表"
                                       data-url="<%=basePath%>gotoStudentList?navigate=21"
                                       class="site-demo-active" data-type="tabAdd"  onclick="addLog(xslb)">学生列表</a></dd>
                            </dl>
                        </c:if>
                        <dl class="layui-nav-child">
                            <dd class="<c:if test="${navigate==24}">layui-this</c:if> ddclass">
                                <a href="javascript:;" data-id="24" data-title="审批中心"
                                   data-url="<%=basePath%>gotoApplyList?navigate=24"
                                   class="site-demo-active" data-type="tabAdd"  onclick="addLog(spzx)">审批中心</a></dd>
                        </dl>
                        <dl class="layui-nav-child">
                            <dd class="<c:if test="${navigate==25}">layui-this</c:if> ddclass">
                                <a href="javascript:;" data-id="25" data-title="晚归录入"
                                   data-url="<%=basePath%>gotoLate?navigate=25"
                                   class="site-demo-active" data-type="tabAdd"  onclick="addLog(wgjl)">晚归录入</a></dd>
                        </dl>
                        <dl class="layui-nav-child">
                            <dd class="<c:if test="${navigate==26}">layui-this</c:if> ddclass">
                                <a href="javascript:;" data-id="26" data-title="离返校录入"
                                   data-url="<%=basePath%>gotolf?navigate=26"
                                   class="site-demo-active" data-type="tabAdd"  onclick="addLog(lfxjl)">离返校录入</a></dd>
                        </dl>
                    </c:if>
                    <c:if test="${sessionScope.user.roleId== 4}">
                        <dl class="layui-nav-child">
                            <dd class="<c:if test="${navigate==22}">layui-this</c:if> ddclass">
                                <a href="javascript:;" data-id="22" data-title="个人信息"
                                   data-url="<%=basePath%>gotoPersonnel?navigate=22"
                                   class="site-demo-active" data-type="tabAdd"  onclick="addLog(grxx)">个人信息</a></dd>
                        </dl>
                        <dl class="layui-nav-child">
                            <dd class="<c:if test="${navigate==23}">layui-this</c:if> ddclass">
                                <a href="javascript:;" data-id="23" data-title="申请记录"
                                   data-url="<%=basePath%>gotoStudentApply?navigate=23"
                                   class="site-demo-active" data-type="tabAdd"  onclick="addLog(sqjl)">申请记录</a></dd>
                        </dl>
                    </c:if>
                </li>
                <%--                </c:if>--%>

                <%--                <c:if test="${sessionScope.user.roleId== 5}">--%>
                <%--                    <li class="layui-nav-item  <c:if test="${navigate>30 && navigate <=40}">layui-nav-itemed</c:if> ">--%>
                <%--                        <a class="" href="javascript:;"><i class='layui-icon layui-icon-app' style="color: #EEB422"></i>&nbsp;维修中心</a>--%>
                <%--                        <dl class="layui-nav-child">--%>
                <%--                            <dd class="<c:if test="${navigate==31}">layui-this</c:if> ddclass">--%>
                <%--                                <a href="javascript:;" data-id="31" data-title="维修列表"--%>
                <%--                                   data-url="<%=basePath%>gotoRepairList?navigate=31"--%>
                <%--                                   class="site-demo-active" data-type="tabAdd">维修列表</a></dd>--%>
                <%--                        </dl>--%>
                <%--                            &lt;%&ndash;                        <dl class="layui-nav-child">&ndash;%&gt;--%>
                <%--                            &lt;%&ndash;                            <dd class="<c:if test="${navigate==32}">layui-this</c:if> ddclass">&ndash;%&gt;--%>
                <%--                            &lt;%&ndash;                                <a href="javascript:;" data-id="21" data-title="申请记录"&ndash;%&gt;--%>
                <%--                            &lt;%&ndash;                                   data-url="<%=basePath%>gotoStudentApply?navigate=32"&ndash;%&gt;--%>
                <%--                            &lt;%&ndash;                                   class="site-demo-active" data-type="tabAdd">申请记录</a></dd>&ndash;%&gt;--%>
                <%--                            &lt;%&ndash;                        </dl>&ndash;%&gt;--%>
                <%--                    </li>--%>
                <%--                </c:if>--%>

                <c:if test="${sessionScope.user.roleId== 1}">
                    <li class="layui-nav-item  <c:if test="${navigate>50 && navigate<=60}">layui-nav-itemed</c:if> ">
                        <a href="javascript:;"><i class='layui-icon layui-icon-set-fill' style="color: #EEB422"></i>&nbsp;系统设置</a>
                        <dl class="layui-nav-child">
                            <dd class="<c:if test="${navigate==51}">layui-this</c:if> ddclass">
                                <a href="javascript:;" data-id="51" data-title="组织机构"
                                   data-url="<%=basePath%>gotoOrganList?navigate=51"
                                   class="site-demo-active" data-type="tabAdd"  onclick="addLog(zzjg)">组织机构</a></dd>
                            <dd class="<c:if test="${navigate==52}">layui-this</c:if> ddclass">
                                <a href="javascript:;" data-id="52" data-title="用户管理"
                                   data-url="<%=basePath%>gotoUserList?navigate=52"
                                   class="site-demo-active" data-type="tabAdd"  onclick="addLog(yhgl)">用户管理</a></dd>
                            <dd class="<c:if test="${navigate==53}">layui-this</c:if> ddclass">
                                <a href="javascript:;" data-id="53" data-title="日志中心"
                                   data-url="<%=basePath%>gotoLogList?navigate=53"
                                   class="site-demo-active" data-type="tabAdd"  onclick="addLog(rzzx)">日志中心</a></dd>
                        </dl>
                    </li>
                </c:if>
            </ul>
        </div>
    </div>

    <!--tab标签-->
    <div class="layui-tab" lay-filter="demo" lay-allowclose="true"
         style="margin-left: 200px;background-color: #ffffff;margin-top: 0;overflow-y: scroll;overflow-x: hidden"
         id="tab">
        <%--<ul class="layui-tab-title"></ul>--%>

        <div class="layui-tab-content" style="height: 90%;width: 100%">
            <sitemesh:write property='body'/>
        </div>
    </div>
    <%--修改密码弹窗--%>
    <div id="edit-pwd-form-modal" style="display: none">
        <div class="layui-form" id="layuiform" lay-filter="user-form"
             style="padding: 20px 0 0 0;">
            <div class="layui-form-item">
                <label class="layui-form-label">旧密码</label>
                <div class="layui-input-inline">
                    <input type="password" name="oldPassword" id="oldPassword" required lay-verify="required"
                           placeholder="请输入密码"
                           autocomplete="off" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">新密码</label>
                <div class="layui-input-inline">
                    <input type="password" name="newPassword" id="newPassword" required lay-verify="required|pass"
                           placeholder="请输入密码"
                           autocomplete="off" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">确认密码</label>
                <div class="layui-input-inline">
                    <input type="password" name="confirmPassword" id="confirmPassword" required
                           lay-verify="required|pass|equal" placeholder="请输入密码"
                           autocomplete="off" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-input-block">
                    <button type="button" lay-submit class="layui-btn layui-btn-sm" lay-filter="editPwd">确认修改</button>
                </div>
            </div>
        </div>

    </div>
    <input id="userId" value="${sessionScope.user.id}" type="hidden">
    <input id="userName" value="${sessionScope.user.name}" type="hidden">
    <input id="userPhone" value="${sessionScope.user.phone}" type="hidden">
    <input id="userAccount" value="${sessionScope.user.account}" type="hidden">
    <input id="userRoleId" value="${sessionScope.user.roleId}" type="hidden">
    <input id="password" value="${sessionScope.user.password}" type="hidden">
    <input id="userTowerNo" value="${sessionScope.user.towerNo}" type="hidden">
    <input id="userOrganId" value="${sessionScope.organ.id}" type="hidden">
    <input id="userOrganName" value="${sessionScope.organ.organName}" type="hidden">
    <input id="userOrganShortName" value="${sessionScope.organ.shortName}" type="hidden">
    <input id="userOrganPath" value="${sessionScope.organ.path}" type="hidden">
    <input id="freshTime" value="${sessionScope.freshTime}" type="hidden">
    <div id="layui-footer" class="layui-footer" style="text-align:center;">
        <!-- 底部固定区域// -->
        <%-- sunway.tk --%>
        © 学生宿舍管理系统
    </div>
</div>
<script>
    var basePath = '<%= basePath %>';
    var active;
    var layer;
    var layerThis;
    var index;
    var search = window.location.search;
    var personalIndex;
    var excel;

    //页面名称
    var sslb = "访问了宿舍列表页面";
    var wlrydj = "访问了外来人员登记页面";
    var rzbl = "访问了入住办理页面";
    var qcbl = "访问了迁出办理页面";
    var xslb = "访问了学生列表页面";
    var spzx = "访问了审批中心页面";
    var wgjl = "访问了晚归记录页面";
    var lfxjl = "访问了离返校记录页面";
    var zzjg = "访问了组织机构页面";
    var yhgl = "访问了用户管理页面";
    var rzzx = "访问了日志中心页面";
    var grzx = "访问了个人中心页面";
    var sqjl = "访问了申请记录页面";

    //获取url中的参数
    function getUrlParam(name) {
        var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
        var r = window.location.search.substr(1).match(reg);  //匹配目标参数
        if (r != null) return unescape(r[2]);
        return null; //返回参数值
    }

    // 获取指定参数值
    var id = getUrlParam('navigate');  // 1
    console.log(id);

    layui.use(['element', 'layer', 'jquery', 'form'], function () {
        var element = layui.element;
        layer = layui.layer;
        var form = layui.form;
        var $ = layui.$;
        layerThis = layer;
        // excel = layui.excel;
        // 配置tab实践在下面无法获取到菜单元素
        $('.site-demo-active').on('click', function () {
            var dataid = $(this);
            if (dataid.attr("data-id") == 6) {
                hasRead();
            }
            window.location.href = dataid.attr("data-url");
            // $("#tab").html('<iframe id="mainiframe" data-frameid="' + 1 + '" scrolling="auto" frameborder="0" src='+dataid.attr("data-url")+' style="width:100%;height:100%;"></iframe>');
            FrameWH();

        });
        active = {
            //在这里给active绑定几项事件，后面可通过active调用这些事件
            tabAdd: function (url, id, name) {
                element.tabAdd('demo', {
                    title: name,
                    content: '<iframe id="mainiframe" data-frameid="' + id + '" scrolling="auto" frameborder="0" src="' + url + '" style="width:100%;height:100%;"></iframe>',
                    id: id //规定好的id
                })
                FrameWH();
                //计算ifram层的大小
            },
            tabChange: function (id) {
                //切换到指定Tab项
                element.tabChange('demo', id);
                //根据传入的id传入到指定的tab项
            },
            tabDelete: function (id) {
                element.tabDelete("demo", id);
                //删除
            }
        };

        function FrameWH() {
            var h = $(window).height();
            h = h - 60 - 30;
            $("#tab").css("height", h + "px");
        }

        FrameWH();
        form.verify({
            pass: [
                /^[\S]{4,16}$/
                , '密码必须4到16位，且不能出现空格'
            ],
            equal: function (value, item) {
                var newPassword = $("#newPassword").val();
                var confirmPassword = $("#confirmPassword").val();
                if (newPassword != confirmPassword) {
                    return '两次密码不一致'
                }

            }
        })
        form.on('submit(editPwd)', function (data) {
            var confirmPassword = data.field.confirmPassword;
            var newPassword = data.field.newPassword;
            var oldPassword = data.field.oldPassword;
            var userId = $("#userId").val();
            var user = {
                "userId": userId,
                "password": newPassword
            };
            $.ajax({
                url: basePath + 'user/checkPassword',
                async: false,
                type: "post",
                data: {
                    'userId': userId,
                    "password": oldPassword
                },
                success: function (msg) {
                    console.log(msg);
                    if (msg.code != 0) {
                        layer.msg(msg.description, {icon: 2})
                        return;
                    } else {
                        $.ajax({
                            url: basePath + 'user/updatePassword',
                            type: "post",
                            dataType: "json",
                            data: user,
                            success: function (msg) {
                                if (msg.code == 0) {
                                    window.location.href = "<%=basePath%>logout";
                                } else {
                                    layer.msg(msg.description, {icon: 2})
                                }
                            }
                        });
                    }
                }
            });
            return false; //阻止表单跳转。如果需要表单跳转，去掉这段即可。
        });
    });


    $('#logo').on('click', function () {
        var sideWidth = $('#layui-side').width();
        if (sideWidth === 200) {
            $('#tab').animate({
                'margin-left': '0'
            }); //admin-footer
            $('#layui-footer').animate({
                left: '0'
            });
            $('#layui-side').animate({
                width: '0'
            });
            $("#shrink-i").removeClass("layui-icon-shrink-right").addClass("layui-icon-spread-left");

        } else {
            $('#tab').animate({
                'margin-left': '200px'
            });
            $('#layui-footer').animate({
                left: '200px'
            });
            $('#layui-side').animate({
                width: '200px'
            });
            $("#shrink-i").removeClass("layui-icon-spread-left").addClass("layui-icon-shrink-right");
        }
    });

    function editPass() {
        layer.open({
            type: 1,
            title: '修改密码',
            area: ['400px', '350px'],
            content: $('#edit-pwd-form-modal'),
            cancel: function (index, layero) {

            }
        });
    }

    //个人中心
    function personal() {
        personalIndex = layer.open({
            type: 1,
            title: '修改密码',
            area: ['400px', '350px'],
            content: $('#edit-pwd-form-modal'),
            //shade: 0.3,
            closeBtn: 2,
            skin: 'demo-class',
            cancel: function (index, layero) {
                $("[data-type='del']").remove();
                $("input[name='trainNumberAdd']").val("");
                $("input[name='destinationAdd']").val("");
            }
        });
    }

    function logout() {
        console.log("登出");
        var log ={};
        log.type = 4;
        log.description = "退出了系统";
        $.ajax({
            url: '<%=basePath%>log/add',
            type: 'post',
            data: log,
            dataType: 'json',
            success: function (data) {
                log = null;
            }
        })
    }

    function addLog(description) {
        console.log("addLog");
        var log = {};
        log.type = 4;
        log.description = description;
        $.ajax({
            url: '<%=basePath%>log/add',
            type: 'post',
            data: log,
            dataType: 'json',
            success: function (data) {
                log = null;
            }
        })
    }
</script>
</body>
</html>