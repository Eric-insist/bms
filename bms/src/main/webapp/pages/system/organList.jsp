<%@ page contentType="text/html;charset=UTF-8" %>
<%@page isELIgnored="false" %>
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
<div class="layui-card layadmin-header" style="height: 50px; line-height: 50px; padding-left: 15px;">
    <div class="layui-breadcrumb" lay-filter="breadcrumb" style="visibility: visible;">
        <a lay-href="">机构管理</a><span lay-separator="">/</span> <a><cite>机构列表</cite></a>
    </div>
</div>
<div class="layui-col-md3">
    <div class="layui-card" style="padding: 10px;">
        <div class="layui-card-body" style="border: 1px solid #ddd;">
            <ul id="demo1" class="layui-box layui-tree"></ul>
        </div>
    </div>
</div>
<div class="layui-col-md9">
    <table class="layui-hide" id="test" lay-filter="test"></table>
</div>
<script type="text/html" id="barDemo">
    <%--    {{#  if(d.used == 1){ }}--%>
    <%--    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="used">禁用机构</a>--%>
    <%--    {{#  }else { }}--%>
    <%--    <a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="used">启用机构</a>--%>
    <%--    {{# } }}--%>
    <a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="update">修改</a>
    <a class="layui-btn layui-btn-normal layui-btn-xs layui-btn-danger" lay-event="del">删除</a>
</script>
<script type="text/html" id="toolbarDemo">
    <div class="layui-btn-container">
        <button class="layui-btn layui-btn-sm" lay-event="addOrg">添加机构</button>
    </div>
</script>
<script>
    var organQuery = {};
    layui.config({
        base: '<%=basePath%>/js/layui/extends/',
    }).extend({
        treeSelect: 'treeSelect',
    });
    layui.use(['tree', 'layer', 'table', 'form', 'treeSelect'], function () {
        var layer = layui.layer
            , table = layui.table
            , treeSelect = layui.treeSelect
            , form = layui.form
            , $ = layui.jquery
        var tree = layui.tree
        refreshLeft();

        // 渲染左侧机构树
        function refreshLeft() {
            $.ajax({
                url: '<%=basePath%>organ/selectOrganTree',
                type: 'post',
                dataType: 'json',
                async: false,
                success: function (data) {
                    console.log(data);
                    if (data.code == 0) {
                        tree.render({
                            elem: '#demo1'
                            , data: data.data
                            , onlyIconControl: true  //是否仅允许节点左侧图标控制展开收缩
                            , click: function (obj) {
                                console.log(obj.data.id);
                                organQuery.id = obj.data.id;
                                table.reload('test', {
                                    where: organQuery
                                });
                            }
                        });
                    }
                }
            });
        }


        var tableIns = table.render({
            elem: '#test'
            , url: '<%=basePath%>/organ/getOrganList'
            , toolbar: '#toolbarDemo'
            , title: '机构列表'
            // ,where: {id :0}
            , parseData: function (res) { //res 即为原始返回的数据
                return {
                    "code": res.code == 200 ? 0 : res.code, //解析接口状态
                    "msg": res.description, //解析提示文本
                    "count": res.totalRows, //解析数据长度
                    "data": res.data, //解析数据列表
                };
            }
            , cols: [[
                {type: 'checkbox'}
                // , {field: 'id', title: 'ID', width: 80, fixed: 'left', unresize: true, sort: true}
                , {field: 'organName', title: '机构名称'}
                , { title: '操作', toolbar: '#barDemo'}
            ]]
            , page: true
        });

        //头工具栏事件
        table.on('toolbar(test)', function (obj) {
            var checkStatus = table.checkStatus(obj.config.id);
            switch (obj.event) {
                case 'addOrg':
                <%--window.location.href = "<%=basePath%>/addOrg";--%>
                    refreshWindowTree();
                    $("#add_organName").val("");
                    layer.open({
                        type: 1,
                        title: '添加机构',
                        area: ['500px', '350px'],
                        content: $('#form-modal'),
                        // shade: 0,
                        success: function (layero, index) {
                            //表单提交
                            form.on('submit(user-form-submit)', function (data) {
                                $.ajax({
                                    url: '<%=basePath%>organ/addOrgan',
                                    type: 'post',
                                    data: data.field,
                                    dataType: 'json',
                                    success: function (data) {
                                        // alert
                                        if (data.code == 0) {
                                            layer.confirm("添加机构成功", function (index) {
                                                layer.close(index);
                                                location.reload();
                                            });
                                        } else {
                                            layer.msg(data.description);
                                        }
                                    }
                                });
                            });
                        }
                        ,cancel:function () {
                            treeSelect.destroy('tree');
                        }
                    })
                    break;
                case 'getCheckData':
                    var data = checkStatus.data;
                    layer.alert(JSON.stringify(data));
                    break;
                case 'getCheckLength':
                    var data = checkStatus.data;
                    layer.msg('选中了：' + data.length + ' 个');
                    break;
                case 'isAll':
                    layer.msg(checkStatus.isAll ? '全选' : '未全选');
                    break;
            }
            ;
        });

        //监听行工具事件
        table.on('tool(test)', function (obj) {
            var data = obj.data;
            //console.log(obj)
            if (obj.event === 'del') {
                console.log(data);
                console.log("删除");
                layer.confirm('确认删除？', function (index) {
                    $.ajax({
                        url: '<%=basePath%>organ/delOrgan',
                        type: 'post',
                        data: {id:data.id},
                        // dataType: 'json',
                        success: function (data) {
                            // alert
                            if (data.code == 0) {
                                layer.confirm("删除机构成功", function (index) {
                                    layer.close(index);
                                    location.reload();
                                });
                            } else {
                                layer.confirm(data.description, function (index) {
                                    layer.close(index);
                                });
                            }
                        }
                    });
                });
            }else if (obj.event === 'update') {
                console.log("修改");
                console.log(data);
                $("#update_organName").val(data.organName);
                // $("#update_tree").val(data.parentName);
                // $("#update_tree").text(data.parentName);
                console.log(data.parentId)
                refreshUpdateTree(data.parentId);
                layer.open({
                    type: 1,
                    title: '修改机构',
                    area: ['500px', '350px'],
                    content: $('#update-modal'),
                    shade: 0,
                    success: function (layero, index) {
                        //表单提交
                        form.on('submit(update-form-submit)', function (data) {
                            $.ajax({
                                url: '<%=basePath%>organ/updateOrgan',
                                type: 'post',
                                data: data.field,
                                dataType: 'json',
                                success: function (data) {
                                    // alert
                                    if (data.code == 0) {
                                        layer.confirm("修改机构成功", function (index) {
                                            layer.close(index);
                                            location.reload();
                                        });
                                    } else {
                                        layer.confirm(data.description, function (index) {
                                            layer.close(index);
                                        });
                                    }
                                }
                            });
                        });
                    }
                    ,cancel: function(index, layero){
                        treeSelect.destroy('update_tree');
                    }
                })

            } else if (obj.event === 'used') {
                //used 取反
                obj.data.used = !obj.data.used
                $.ajax({
                    type: "Patch",
                    url: "<%=basePath%>/org/jsonPatchOrg",
                    data: data,
                    dataType: "json",
                    success: function (data) {
                        console.log(data);
                        if (data.code == 0) {
                            refreshLeft();
                            refreshWindowTree();
                            tableIns.reload();
                            layer.msg(obj.data.used == 1 ? '启用成功' : '禁用成功');
                            // layer.close(index);
                        }
                    }
                });
            }
        });

        function refreshWindowTree() {
            treeSelect.render({
                // 选择器
                elem: '#tree',
                // 数据
                data: '<%=basePath%>organ/selectOrgTreeData',
                // 异步加载方式：get/post，默认get
                type: 'post',
                // 占位符
                placeholder: '请选择上级单位',
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
        }


        //渲染更新
        function refreshUpdateTree(organId) {
            treeSelect.render({
                // 选择器
                elem: '#update_tree',
                // 数据
                data: '<%=basePath%>organ/selectOrgTreeData',
                // 异步加载方式：get/post，默认get
                type: 'post',
                // 占位符
                placeholder: '请选择所属集体',
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
                    // console.log(d);
//                选中节点，根据id筛选
                    treeSelect.checkNode('update_tree', organId);

//                获取zTree对象，可以调用zTree方法
//                var treeObj = treeSelect.zTree('tree');
//                console.log(treeObj);

//                刷新树结构
//                 treeSelect.refresh('update_tree');
                }
            });
        }
    })



</script>
<div id="form-modal" style="display: none">
    <div class="layui-form" lay-filter="user-form"
         style="padding: 20px 0 0 0;">
        <input type="hidden" name="id"/>
        <div class="layui-form-item">
            <label class="layui-form-label">机构名称</label>
            <div class="layui-input-inline">
                <input type="text" id="add_organName" name="organName" value="" lay-verify="required|account"
                       placeholder="请输入机构名称" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">上级单位</label>
                <div class="layui-input-block">
                    <input type="text" id="tree" name="parentId" lay-filter="tree" class="layui-input">
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label"></label>
            <div class="layui-input-inline">
                <input type="button" lay-submit=""
                       lay-filter="user-form-submit" value="确认" class="layui-btn">
            </div>
        </div>
    </div>
</div>
<div id="update-modal" style="display: none">
    <div class="layui-form" lay-filter="user-form"
         style="padding: 20px 0 0 0;">
        <input type="hidden" name="id"/>
        <div class="layui-form-item">
            <label class="layui-form-label">机构名称</label>
            <div class="layui-input-inline">
                <input type="text" id="update_organName" name="organName" value="" lay-verify="required|account"
                       placeholder="请输入机构名称" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">上级机构</label>
                <div class="layui-input-block">
                    <input type="text" id="update_tree" name="parentId" lay-filter="update_tree" class="layui-input">
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label"></label>
            <div class="layui-input-inline">
                <input type="button" lay-submit=""
                       lay-filter="update-form-submit" value="确认" class="layui-btn">
            </div>
        </div>
    </div>
</div>
</body>
</html>