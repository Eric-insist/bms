<%@ page contentType="text/html;charset=UTF-8" %>
<%--<%@page isELIgnored="false" %>--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>layui</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
</head>
<body>
<script>
    layui.config({
        base: '<%=basePath%>/js/layui/extends/',
    }).extend({
        treeSelect: 'treeSelect',
    });
    layui.use(['jquery', 'treeSelect', 'form', 'layer', 'table', 'upload'], function () {
        var table = layui.table,
            $ = layui.jquery,
            treeSelect = layui.treeSelect,
            form = layui.form,
            layer = layui.layer,
            upload = layui.upload;


        //表单提交
        form.on('submit(inBedroom-form-submit)', function (data) {
            console.log("入住");
            var inputData = data.field;
            console.log(inputData);
            $.ajax({
                url: '<%=basePath%>bedroom/inBedroom',
                type: 'post',
                data: inputData,
                dataType: 'json',
                success: function (data) {
                    // alert
                    if (data.code == 0) {
                        layer.confirm(data.description, function (index) {
                           location.reload();
                        });
                    } else {
                        layer.msg(data.description);
                    }
                }
            });
        });
        if ($("#roleId").val() != '') {
            $(":checkbox").prop("checked", false);
            $(":checkbox").each(function () {
                if ($(this).val() != '') {
                    if ((($("#roleId").val()).indexOf("." + $(this).val() + ".")) > -1) {
                        $(this).prop("checked", "checked");
                    }
                }
            });
            form.render('checkbox');//重新加载勾选框
        }


        //失焦
        $("#idCard").blur(function () {
            if ($("#idCard").val() == null || $("#idCard").val() == '') return;
            console.log("失焦");
            var age = IdCard($("#idCard").val(), 3);
            $("#age").val(age);
            var sex = IdCard($("#idCard").val(), 2);
            console.log(sex);
            if (sex == 1){
                $("#sex option[value='1']").prop("selected",true);
                form.render('select');
            }else {
                $("#sex option[value='2']").prop("selected",true);
                form.render('select');
            }
        });

    });
</script>
<div class="layui-card layadmin-header" style="height: 50px; line-height: 50px; padding-left: 15px;">
    <div class="layui-breadcrumb" lay-filter="breadcrumb" style="visibility: visible;">
        <a lay-href="">学生中心</a><span lay-separator="">/</span> <a><cite>个人信息</cite></a>
    </div>
</div>
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>个人信息</legend>
</fieldset>
<div class="layui-col-md12">
    <div id="inBedroomDiv" style="padding: 10px; background-color: #F2F2F2;">
        <div class="layui-card">
            <div class="layui-card-header">个人信息</div>
            <div class="layui-card-body">
                <div id="form-modal">
                    <div class="layui-form" lay-filter="inBedroom-form"
                         style="padding: 20px 0 0 0;">
                        <div class="layui-form-item">
                            <div class="layui-inline">
                                <label class="layui-form-label">姓名</label>
                                <div class="layui-input-inline">
                                    <input type="text" name="name" value="${sessionScope.user.name}" lay-verify="required"
                                           placeholder="请输入姓名" autocomplete="off" class="layui-input" disabled>
                                </div>
                            </div>
                            <div class="layui-inline">
                                <label class="layui-form-label">身份证号</label>
                                <div class="layui-input-inline">
                                    <input type="text" name="idCard" id="idCard" value="${sessionScope.user.idCard}" lay-verify="required|identity"
                                           placeholder="请输入身份证号" autocomplete="off" class="layui-input" disabled>
                                </div>
                            </div>
                            <div class="layui-inline">
                                <label class="layui-form-label">学号</label>
                                <div class="layui-input-inline">
                                    <input type="text" name="account" id="account" value="${sessionScope.user.account}" lay-verify="required|number"
                                           placeholder="请输入学号" autocomplete="off" class="layui-input" disabled>
                                </div>
                            </div>
                        </div>
                        <div class="layui-form-item" style="margin-top: 30px">
                            <div class="layui-inline">
                                <label class="layui-form-label">性别</label>
                                <div class="layui-input-inline">
                                    <input type="text" name="sex" id="sex" <c:if test="${sessionScope.user.sex == 1}">value="男"</c:if> <c:if test="${sessionScope.user.sex == 2}">value="女"</c:if> lay-verify="required|number"
                                           placeholder="请输入年龄" autocomplete="off" class="layui-input" disabled>
                                </div>
                            </div>
                            <div class="layui-inline">
                                <label class="layui-form-label">年龄</label>
                                <div class="layui-input-inline">
                                    <input type="text" name="age" id="age" value="${sessionScope.user.age}" lay-verify="required|number"
                                           placeholder="请输入年龄" autocomplete="off" class="layui-input" disabled>
                                </div>
                            </div>
                            <div class="layui-inline">
                                <label class="layui-form-label">所属集体</label>
                                <div class="layui-input-inline">
                                    <input type="text" name="organName" id="organName" value="${sessionScope.organ.parentName}${sessionScope.organ.organName}" lay-verify="required|number"
                                           placeholder="请输入年龄" autocomplete="off" class="layui-input" disabled>
                                </div>
                            </div>
                        </div>
                        <div class="layui-form-item" style="margin-top: 30px">
                            <div class="layui-inline">
                                <label class="layui-form-label">联系电话</label>
                                <div class="layui-input-inline">
                                    <input type="tel" name="phone" value="${sessionScope.user.phone}" lay-verify="required|number|phone|checkPhone"
                                           placeholder="请输入电话号码" autocomplete="off" class="layui-input" disabled>
                                </div>
                            </div>
                            <div class="layui-inline">
                                <label class="layui-form-label">户籍</label>
                                <div class="layui-input-inline" style="width: 515px">
                                    <input type="tel" name="home" value="${sessionScope.user.home}" lay-verify="required"
                                           placeholder="请输入户籍所在地" autocomplete="off" class="layui-input" disabled>
                                </div>
                            </div>
                        </div>
                        <div class="layui-form-item" style="margin-top: 30px">
                            <div class="layui-inline">
                                <label class="layui-form-label">寝室号</label>
                                <div class="layui-input-inline">
                                    <input type="text" name="roomNo" value="${sessionScope.room.roomNo}" lay-verify="required"
                                           placeholder="请输入寝室号" autocomplete="off" class="layui-input" disabled>
                                </div>
<%--                                <input type="button" lay-submit=""--%>
<%--                                       lay-filter="changeRoom" value="换寝" class="layui-btn">--%>
                            </div>
                            <div class="layui-inline">
                                <label class="layui-form-label">居住地</label>
                                <div class="layui-input-inline" style="width: 515px">
                                    <input type="tel" name="livePlace" value="${sessionScope.user.livePlace}" lay-verify="required"
                                           placeholder="请输入现居住地" autocomplete="off" class="layui-input" disabled>
                                </div>
                            </div>
                        </div>
<%--                        <div class="layui-form-item">--%>
<%--                            <label class="layui-form-label"></label>--%>
<%--                            <div class="layui-input-inline" style="margin-left: 25%">--%>
<%--                                <input type="button" lay-submit=""--%>
<%--                                       lay-filter="inBedroom-form-submit" value="办理入住" class="layui-btn">--%>
<%--                            </div>--%>
<%--                        </div>--%>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
</script>
</body>
</html>