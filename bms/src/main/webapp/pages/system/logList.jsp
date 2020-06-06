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
<style type="text/css">

    .icon_snowflake {
        font-size: 5px;
        color: red
    }

</style>
<div class="layui-card layadmin-header" style="height: 50px; line-height: 50px; padding-left: 15px;">
    <div class="layui-breadcrumb" lay-filter="breadcrumb" style="visibility: visible;">
        <a lay-href="">系统设置</a><span lay-separator="">/</span> <a><cite>操作日志</cite></a>
    </div>
</div>

<div class="layui-form layui-card-header layuiadmin-card-header-auto" lay-filter="layadmin-userfront-formlist">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">操作类型</label>
            <div class="layui-input-block">
                <select name="type" id="type">
                    <option value="">无</option>
                    <option value="1">增加</option>
                    <option value="2">修改</option>
                    <option value="3">删除</option>
                    <option value="4">查询</option>
                </select>
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">用户名</label>
            <div class="layui-input-block">
                <input type="text" name="name" placeholder="输入用户名" autocomplete="off" class="layui-input"
                       style="width: 255px">
            </div>
        </div>
        <div class="layui-inline">
            <button class="layui-btn layuiadmin-btn-useradmin" lay-submit="" lay-filter="search-btn">
                <i class="layui-icon layui-icon-search layuiadmin-button-btn"></i>
            </button>
        </div>
    </div>
</div>
<div class="layui-card-body">
    <table class="layui-hide" id="test" lay-filter="test"></table>
</div>
<script type="text/html" id="toolbarDemo">
<%--    <div class="layui-btn-container">--%>
<%--        <button class="layui-btn layui-btn-sm" lay-event="addUser">添加用户</button>--%>
<%--    </div>--%>
</script>

<script type="text/html" id="barDemo">
<%--    <a class="layui-btn layui-btn-xs" lay-event="reset">重置密码</a>--%>
<%--    <a class="layui-btn layui-btn-warm layui-btn-xs" lay-event="update">修改</a>--%>
<%--    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>--%>
</script>
<script type="text/javascript">
    var messageSend = 1;
    var curObj = {
        curOrganName: "",
        curOrgCode: "", //选中机构的code
        curOrgId: "",  //选中机构的id
        curArea: ""
    }
    var updateObj = {
        curOrganName: "",
        curOrgCode: "", //选中机构的code
        curOrgId: "",  //选中机构的id
        curArea: ""
    }
    $(document).ready(function () {

    });


</script>
<script>
    layui.config({
        base: '<%=basePath%>/js/layui/extends/',
    }).extend({
        treeSelect: 'treeSelect',
    });
    var LayerThis;
    var formThis;

    layui.use(['jquery', 'treeSelect', 'form', 'layer', 'table'], function () {
        var table = layui.table,
            $ = layui.jquery,
            treeSelect = layui.treeSelect,
            form = layui.form,
            layer = layui.layer,
            excel = layui.excel;
        LayerThis = layer;
        formThis = form;
        var parentId = $("#parentId").val();


        var query = {};
        var log = {};
        //搜索表单提交
        form.on('submit(search-btn)', function (data) {
            var field = data.field;
            log.type = field.type;
            log.userName = $.trim(field.name);
            //表格重载条件
            console.log(log);
            table.reload('test', {
                where: log, page: {curr: 1}
            });
        });
        form.verify({
            checkPhone: function (value, item) {
                if (!(/^1[3456789]\d{9}$/.test(value))) {
                    return "请输入正确的手机号";
                }
            }

        });
        var tableIns = table.render({
            elem: '#test'
            , id: 'test'
            , url: '<%=basePath%>/log/getLogList'
            , toolbar: '#toolbarDemo'
            , title: '用户数据表'
            , method: 'GET'
            , defaultToolbar: ['print', 'exports']
            , parseData: function (res) { //res 即为原始返回的数据
                return {
                    "code": res.code == 200 ? 0 : res.code, //解析接口状态
                    "msg": res.description, //解析提示文本
                    "count": res.totalRows, //解析数据长度
                    "data": res.data, //解析数据列表
                };
            }
            , cols: [[
                // {type: 'checkbox', fixed: 'left'}
                {field: 'id', hide: true}
                , {field: 'userName', title: '用户名'}
                , {field: 'type', title: '操作',templet:function (res) {
                        if (res.type == 1) return '新增';
                        else if (res.type == 2) return  '修改';
                        else if (res.type == 3) return '删除';
                        else return '查询';
                    }}
                , {field: 'description', title: '操作详情'}
                , {
                    field: 'time',
                    title: '操作时间',
                }
                , {field: 'organName', title: '机构名称'}
            ]]
            , page: true
        });

        //头工具栏事件
        table.on('toolbar(test)', function (obj) {
            var checkStatus = table.checkStatus(obj.config.id);
            switch (obj.event) {
                case 'addUser':
                    refreshWindowTree();
                    $("#add_name").val(null);
                    $("#add_account").val(null);
                    $("#add_phone").val(null);
                    $("#add_idCard").val(null);
                    layer.open({
                        type: 1,
                        title: '添加用户',
                        area: ['430px', '540px'],
                        content: $('#add-form-modal'),
                        success: function (layero, index) {
                            //表单提交
                            form.on('submit(add)', function (data) {
                                console.log(data);
                                // return;
                                //添加用户
                                $.ajax({
                                    url: '<%=basePath%>user/addUser',
                                    type: 'post',
                                    data: data.field,
                                    dataType: 'json',
                                    success: function (data) {
                                        // alert
                                        if (data.code == 0) {
                                            layer.msg(data.description, {
                                                time: 2000,
                                            });
                                            treeSelect.destroy("tree");
                                            table.reload('test');
                                            layer.close(index);
                                        } else {
                                            layer.msg(data.description, {
                                                time: 2000,
                                            });
                                            treeSelect.destroy("tree");
                                            table.reload('test');
                                        }

                                    }
                                });
                            });
                        }
                        ,cancel:function () {
                            treeSelect.destroy("tree");
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
                case 'LAYTABLE_EXPORT':
                    exportFile('test');
                    insertLog("导出Excel了");
                    break;
                case 'LAYTABLE_PRINT':
                    insertLog("打印了");
                    break;
            }
            ;
        });

        //表格导出
        function exportFile(id) {
            //根据传入tableID获取表头
            var headers = $("div[lay-id=" + id + "] .layui-table-box table").get(0);
            var htrs = Array.from(headers.querySelectorAll('tr'));
            var titles = {};
            for (var j = 0; j < htrs.length; j++) {
                var hths = Array.from(htrs[j].querySelectorAll("th"));
                for (var i = 0; i < hths.length; i++) {
                    var clazz = hths[i].getAttributeNode('class').value;
                    if (clazz != ' layui-table-col-special' && clazz != 'layui-hide') {
                        //排除居左、具有、隐藏字段
                        //修改:默认字段data-field+i,兼容部分数据表格中不存在data-field值的问题
                        titles['data-field' + i] = hths[i].innerText;
                    }
                }
            }
            //根据传入tableID获取table内容
            var bodys = $("div[lay-id=" + id + "] .layui-table-box table").get(1);
            var btrs = Array.from(bodys.querySelectorAll("tr"))
            var bodysArr = new Array();
            for (var j = 0; j < btrs.length; j++) {
                var contents = {};
                var btds = Array.from(btrs[j].querySelectorAll("td"));
                for (var i = 0; i < btds.length; i++) {
                    for (var key in titles) {
                        //修改:默认字段data-field+i,兼容部分数据表格中不存在data-field值的问题
                        var field = 'data-field' + i;
                        if (field === key) {
                            //根据表头字段获取table内容字段
                            contents[field] = btds[i].innerText;
                        }
                    }
                }
                bodysArr.push(contents)
            }
            //将标题行置顶添加到数组
            bodysArr.unshift(titles);
            //导出excel
            excel.exportExcel({
                sheet1: bodysArr
            }, '用户表.xlsx', 'xlsx');
        }

        //监听行工具事件
        table.on('tool(test)', function (obj) {
            var data = obj.data;
            if (obj.event === 'del') {
                layer.confirm('确认删除？', {title: "提示", closeBtn: 2}, function (index) {
                    console.log("删除");
                })
            } else if (obj.event === 'reset') {
                // 重置密码
                $.ajax({
                    type: "PUT",
                    url: "<%=basePath%>/user/resetPwd",
                    data: {userId: data.userId, loginName: data.loginName},
                    success: function (data) {
                        if (data.code == 200) {
                            layer.msg(data.description, {
                                icon: 1,  //成功
                                time: 2000,
                            });
                        } else {
                            layer.msg(data.description, {
                                icon: 2,  //失败
                                time: 2000,
                            });
                        }
                    }
                });
            } else if (obj.event === 'update') {
                var data = obj.data;
                console.log(data);
                refreshUpdateTree(obj.data.organId);
                $("#update_id").val(data.id);
                $("#update_name").val(data.name);
                $("#update_account").val(data.account);
                $("#update_phone").val(data.phone);
                $("#update_idCard").val(data.idCard);
                $("#update_roleId option[value='"+data.roleId+"']").attr("selected","selected");
                formThis.render('select');
                layer.open({
                    type: 1,
                    title: '修改用户',
                    area: ['430px', '540px'],
                    content: $('#update-form-modal'),
                    success: function (layero, index) {
                        //表单提交
                        form.on('submit(update)', function (data) {
                            console.log(data);
                            // return;
                            //添加用户
                            $.ajax({
                                url: '<%=basePath%>user/updateUser',
                                type: 'post',
                                data: data.field,
                                dataType: 'json',
                                success: function (data) {
                                    // alert
                                    if (data.code == 200) {
                                        layer.msg(data.description, {
                                            icon: 1,  //成功
                                            time: 2000,
                                        })
                                        location.reload();
                                    } else {
                                        layer.msg(data.description, {
                                            icon: 2,
                                            time: 2000,
                                        });
                                        location.reload();
                                    }

                                }
                            });
                        });
                    }
                    ,cancel: function(index, layero){
                        treeSelect.destroy('update_tree');
                    }
                })
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
    });

</script>
<%--新增弹窗内容--%>
<div id="add-form-modal" style="display: none">
    <form class="layui-form" lay-filter="add-form" id="add-form"
          style="padding: 20px 0 0 0;">
        <div class="layui-form-item">

            <label class="layui-form-label"> <i class="layui-icon layui-icon-snowflake icon_snowflake"></i>姓名</label>
            <div class="layui-input-inline">
                <input type="text" name="name" id="add_name" value="" lay-verify="required"
                       placeholder="请输入姓名" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label"><i class="layui-icon layui-icon-snowflake icon_snowflake"></i>账号/学号</label>
            <div class="layui-input-inline">
                <input type="text" name="account" id="add_account" value="" lay-verify="required"
                       placeholder="请输入账号" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label"><i class="layui-icon layui-icon-snowflake icon_snowflake"></i>身份证号</label>
            <div class="layui-input-inline">
                <input type="text" name="idCard" id="add_idCard" value="" lay-verify="required|identity"
                       placeholder="请输入身份证号" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label"><i class="layui-icon layui-icon-snowflake icon_snowflake"></i>权限</label>
                <div class="layui-input-inline">
                    <select name="roleId" id="add_roleId" lay-verify="required">
                        <option value="2">宿舍管理员</option>
                        <option value="3">辅导员</option>
                        <option value="4">学生</option>
                        <option value="5">维修人员</option>
                    </select>
                </div>
            </div>
        </div>

        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label"><i
                        class="layui-icon layui-icon-snowflake icon_snowflake"></i>所属机构</label>
                <div class="layui-input-inline">
                    <input type="text" id="tree" name="organId" lay-filter="tree" lay-verify="required"
                           class="layui-input">
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label"><i
                    class="layui-icon layui-icon-snowflake icon_snowflake"></i>联系电话</label>
            <div class="layui-input-inline">
                <input type="tel" name="phone" id="add_phone" value="" lay-verify="phone|required|checkPhone"
                       placeholder="请输入电话号码" autocomplete="off" class="layui-input">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label"></label>
            <div class="layui-input-inline" style="text-align: center;">
                <input type="button" lay-submit=""
                       lay-filter="add" value="确认" class="layui-btn">
            </div>
        </div>
    </form>
</div>
<%--更新弹框内容--%>
<div id="update-form-modal" style="display: none">
    <div class="layui-form" lay-filter="update-form"
         style="padding: 20px 0 0 0;">
        <input type="hidden" name="id" id="update_id"/>
        <div class="layui-form-item">
            <label class="layui-form-label">姓名</label>
            <div class="layui-input-inline">

                <input type="text" name="name" id="update_name" value="" lay-verify="required"
                       placeholder="请输入姓名" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">账号/学号</label>
            <div class="layui-input-inline">
                <input type="text" name="account" id="update_account" value="" lay-verify="required"
                       placeholder="请输入账号" autocomplete="off" class="layui-input" readonly>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">身份证号</label>
            <div class="layui-input-inline">
                <input type="text" name="idCard" id="update_idCard" value="" lay-verify="required|identity"
                       placeholder="请输入身份证号" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">权限</label>
                <div class="layui-input-inline">
                    <select name="roleId" id="update_roleId" lay-verify="required">
                        <option value="2">宿舍管理员</option>
                        <option value="3">辅导员</option>
                        <option value="4">学生</option>
                        <option value="5">维修人员</option>
                    </select>
                </div>
            </div>
        </div>

        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">所属机构</label>
                <div class="layui-input-inline">
                    <input type="text" id="update_tree" name="organId" lay-filter="update_tree" lay-verify="required"
                           class="layui-input">
                </div>
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">联系电话</label>
            <div class="layui-input-inline">
                <input type="tel" name="phone" id="update_phone" value="" lay-verify="phone|required|checkPhone"
                       placeholder="请输入电话号码" autocomplete="off" class="layui-input">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label"></label>
            <div class="layui-input-inline" style="text-align: center">
                <input type="button" lay-submit=""
                       lay-filter="update" value="确认" class="layui-btn">
            </div>
        </div>
    </div>
</div>
</body>
</html>