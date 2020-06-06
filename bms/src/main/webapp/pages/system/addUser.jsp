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
    <script src="<%=basePath%>/js/layui/layui.js"></script>
    <link rel="stylesheet" href="<%=basePath%>/js/layui/css/layui.css">
    <script type="text/javascript" src="<%=basePath%>/js/layui/jquery-3.4.1.min.js"></script>
</head>
<body>
<input type="hidden" id="orgId" value="${orgUser.orgId}">
<input type="hidden" id="roleId" value="${roleId}">
<script>
    layui.config({
        base: '<%=basePath%>/js/layui/extends/',
    }).extend({
        treeSelect: 'treeSelect',
    });
    layui.use(['jquery', 'treeSelect', 'form', 'layer', 'table','upload'], function () {
        var table = layui.table,
            $ = layui.jquery,
            treeSelect = layui.treeSelect,
            form = layui.form,
            layer = layui.layer,
            upload = layui.upload;;
        // if()
        // treeSelect.checkNode('tree', data.organId);//设置树形下拉选默认选中的节点
        treeSelect.render({
            // 选择器
            elem: '#tree',
            // 数据
            data: '<%=basePath%>org/selectOrgTreeData',
            // 异步加载方式：get/post，默认get
            type: 'post',
            // 占位符
            placeholder: '请选择所属单位',
            // 是否开启搜索功能：true/false，默认false
            search: true,
            style: {
                folder: { // 父节点图标
                    enable: true // 是否开启：true/false
                },
                line: { // 连接线
                    enable: true // 是否开启：true/false
                }
            },
            // 点击回调
            click: function (d) {
                // console.log(d);
                // console.log(d.treeId); // 得到组件的id
                console.log(d.current.id); // 得到点击节点的treeObj对象
                $("#tree").val(d.current.id);
                // console.log(d.data); // 得到组成树的数据
            },
            // 加载完成后的回调函数
            success: function (d) {
                if($("#orgId").val() != ''){
                    treeSelect.checkNode('tree', $("#orgId").val());
                }
                // console.log(d);
//                选中节点，根据id筛选
//                treeSelect.checkNode('tree', 3);

//                获取zTree对象，可以调用zTree方法
//                var treeObj = treeSelect.zTree('tree');
//                console.log(treeObj);

//                刷新树结构
//                 treeSelect.refresh();
            }
        });

        //表单提交
        form.on('submit(user-form-submit)', function (data) {

            var inputData = data.field;
            if(attach!=null){
                //删除createTime
                delete attach.createTime;
                inputData.attach = attach;
            }else{
                if('${user.id}' == '') {
                    layer.msg("请上传签名图");
                    return;
                }
            }
            var chk_array = new Array();
            $('input:checkbox[name="resId"]:checked').each(function(){
                chk_array.push($(this).val());
            });
            inputData.resId = chk_array;

            $.ajax({
                url: '<%=basePath%>user/jsonAddUser',
                type: 'post',
                data: JSON.stringify(inputData),
                contentType:'application/json',
                dataType: 'json',
                success: function (data) {
                    // alert
                    if (data.code == 0) {
                        layer.confirm(data.message, function (index) {
                            window.location.href="<%=basePath%>/userList";
                        },function (index2){
                            window.location.href="<%=basePath%>/userList";
                        });
                    } else {
                        layer.msg(data.message);
                    }
                }
            });
        });
        if($("#roleId").val() != ''){
            $(":checkbox").prop("checked", false);
            $(":checkbox").each(function(){
                if($(this).val() != ''){
                    if((($("#roleId").val()).indexOf("."+$(this).val() +".")) > -1){
                        $(this).prop("checked", "checked");
                    }
                }
            });
            form.render('checkbox');//重新加载勾选框
        }



        //附件上传
        var attach =null;//上传的文件信息
        var index;
        var uploadInst = upload.render({
            elem: '#uploadSignBtn', //绑定元素
            size: 1024000
            ,url: '<%=basePath%>user/jsonUploadSignImgFile' //上传接口
            ,before: function(obj){
                index = layer.load(2);
                //预读本地文件示例，不支持ie8
                obj.preview(function(index, file, result){
                    $('#signImg').attr('src', result); //图片链接（base64）
                });
            }
            ,done: function(res){
                layer.close(index);
                if(res.code==0){
                    layer.msg("签名图上传成功");
                    attach = res.data;
                    $('#uploadInfo').html(res.data.filename);
                }else{
                    layer.msg("签名图上传失败");
                    $('#uploadInfo').html("上传失败，请重试");
                }
            }
            ,error: function(){
                layer.close(index);
                //请求异常回调
                layer.msg("附件上传失败");
                $('#uploadInfo').html("上传失败，请重试");
            }
        });

    });
</script>
<div class="layui-card layadmin-header" style="height: 50px; line-height: 50px; padding-left: 15px;">
    <div class="layui-breadcrumb" lay-filter="breadcrumb" style="visibility: visible;">
        <a lay-href="">人员管理</a><span lay-separator="">/</span> <a><cite>添加用户</cite></a>
    </div>
</div>
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>用户信息</legend>
</fieldset>
<div class="layui-col-md12">
    <div id="ssajDiv" style="padding: 10px; background-color: #F2F2F2;">
        <div class="layui-card">
            <div class="layui-card-header">角色信息</div>
            <div class="layui-card-body">
                <div id="form-modal">
                    <div class="layui-form" lay-filter="user-form"
                         style="padding: 20px 0 0 0;">
                        <input type="hidden" name="id" value="${user.id}"/>
                        <div class="layui-form-item">
                            <label class="layui-form-label">姓名</label>
                            <div class="layui-input-inline">
                                <input type="text" name="name" value="${user.name}" lay-verify="required|account"
                                       placeholder="请输入姓名" autocomplete="off" class="layui-input">
                            </div>
                        </div>
                            <div class="layui-form-item">
                                <label class="layui-form-label">账号/警号</label>
                                <div class="layui-input-inline">
                                    <input type="text" name="account" value="${user.account}" lay-verify="required|account"
                                           placeholder="请输入账号" autocomplete="off" class="layui-input">
                                </div>
                            </div>
                        <div class="layui-form-item">
                            <div class="layui-inline">
                                <label class="layui-form-label">性别</label>
                                <div class="layui-input-block">
                                    <select name="sex" lay-verify="required" value="${user.sex}">
                                        <option value="1">男</option>
                                        <option value=2">女</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">联系电话</label>
                            <div class="layui-input-inline">
                                <input type="tel" name="phone" value="${user.phone}" lay-verify=""
                                       placeholder="请输入电话号码" autocomplete="off" class="layui-input">
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">选择角色</label>
                            <div class="layui-input-block">
                                <c:forEach items="${roleList }" var="item" varStatus="d">
                                    <input type="checkbox" name="resId" title="${item.name }" lay-skin="primary"
                                           value="${item.id }">
                                </c:forEach>
                            </div>
                        </div>

                        <div class="layui-form-item">
                            <div class="layui-inline">
                                <label class="layui-form-label">所属单位</label>
                                <div class="layui-input-block">
                                    <input type="text" id="tree" name="orgId" lay-verify="required" lay-filter="tree"
                                           class="layui-input">
                                </div>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">职位</label>
                            <div class="layui-input-inline">
                                <input type="text" name="position" value="${orgUser.position}" lay-verify="required|account"
                                       placeholder="请输入职位" autocomplete="off" class="layui-input">
                            </div>
                        </div>
                        <input type="text" name="used" value="true" lay-verify="required|account"
                               placeholder="请输入职位" autocomplete="off" class="layui-input" style="display: none;">
                        <div class="layui-form-item">
                            <label class="layui-form-label">签名图</label>
                            <img class="layui-upload-img" id="signImg"style="width: 80px;height: 80px;" src="<%=basePath%>/conference/jsonGetSignImage?userId=${user.id}">
                            <a class="layui-btn layui-btn-xs" id="uploadSignBtn">上传签名图</a>
                            <span id="uploadInfo">未上传</span>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label"></label>
                            <div class="layui-input-inline">
                                <input type="button" lay-submit=""
                                       lay-filter="user-form-submit" value="保存用户" class="layui-btn">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>