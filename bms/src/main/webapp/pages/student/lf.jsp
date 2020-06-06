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
    layui.use(['jquery', 'treeSelect', 'form', 'layer', 'table', 'upload', 'laydate'], function () {
        var table = layui.table,
            $ = layui.jquery,
            treeSelect = layui.treeSelect,
            form = layui.form,
            layer = layui.layer,
            upload = layui.upload;
        var laydate = layui.laydate;

        //验证手机号
        form.verify({
            checkPhone: function (value, item) {
                if (!(/^1[3456789]\d{9}$/.test(value))) {
                    return "请输入正确的手机号";
                }
            }

        });
        //时间选择
        laydate.render({
            elem: '#inTime',//指定元素
        });

        //时间选择
        laydate.render({
            elem: '#outTime',//指定元素
        });


        //表单提交
        form.on('submit(lf-form-submit)', function (data) {
            var inputData = data.field;
            console.log(inputData);
            $.ajax({
                url: '<%=basePath%>lf/add',
                type: 'post',
                data: inputData,
                dataType: 'json',
                success: function (data1) {
                    // alert
                    if (data1.code == 0) {
                        var log = {};
                        log.type = 1;
                        log.description = "新增了离返校记录,姓名:"+data.name+",学号:"+data.account;
                        $.ajax({
                            url: '<%=basePath%>log/add',
                            type: 'post',
                            data: log,
                            dataType: 'json',
                            success: function (data) {
                                log = null;
                            }
                        });

                        layer.confirm(data1.description, function (index) {
                            location.reload();
                        });
                    } else {
                        layer.msg(data.description);
                    }
                }
            });
        });

    });
</script>
<div class="layui-card layadmin-header" style="height: 50px; line-height: 50px; padding-left: 15px;">
    <div class="layui-breadcrumb" lay-filter="breadcrumb" style="visibility: visible;">
        <a lay-href="">学生中心</a><span lay-separator="">/</span> <a><cite>离返校录入</cite></a>
    </div>
</div>
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>离返校录入</legend>
</fieldset>
<div class="layui-col-md12">
    <div id="inBedroomDiv" style="padding: 10px; background-color: #F2F2F2;">
        <div class="layui-card">
            <div class="layui-card-body">
                <div id="form-modal">
                    <div class="layui-form" lay-filter="lf-form"
                         style="padding: 20px 0 0 0;">
                        <input type="text" name="userId" value="${sessionScope.user.id}" hidden>
                        <div class="layui-form-item">
                            <div class="layui-inline">
                                <label class="layui-form-label">姓名</label>
                                <div class="layui-input-inline">
                                    <input type="text" name="name" value="" lay-verify="required"
                                           placeholder="请输入姓名" autocomplete="off" class="layui-input">
                                </div>
                            </div>
                            <div class="layui-inline">
                                <label class="layui-form-label">学号</label>
                                <div class="layui-input-inline">
                                    <input type="text" name="account" id="account" value="" lay-verify="required|number"
                                           placeholder="请输入学号" autocomplete="off" class="layui-input">
                                </div>
                            </div>
                            <div class="layui-form-item" style="margin-top: 30px">
                                <div class="layui-inline">
                                    <label class="layui-form-label">离校日期</label>
                                    <div class="layui-input-inline">
                                        <input type="text" name="outTime" id="outTime" value="" lay-verify="required"
                                               placeholder="请选择时间" autocomplete="off" class="layui-input">
                                    </div>
                                </div>
                                <div class="layui-inline">
                                    <label class="layui-form-label">返校日期</label>
                                    <div class="layui-input-inline">
                                        <input type="text" name="inTime" id="inTime" value="" lay-verify="required"
                                               placeholder="请选择时间" autocomplete="off" class="layui-input">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="layui-form-item" style="margin-top: 30px">
                            <div class="layui-inline">
                                <label class="layui-form-label">离校原因</label>
                                <div class="layui-input-inline">
                                    <textarea name="reason" placeholder="请输入离校原因" class="layui-textarea"
                                              lay-verify="required" style="width: 514px"></textarea>
                                </div>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label"></label>
                            <div class="layui-input-inline">
                                <input type="button" lay-submit=""
                                       lay-filter="lf-form-submit" value="录入" class="layui-btn">
                            </div>
                        </div>
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