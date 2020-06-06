<%@ page import="org.springframework.web.context.request.SessionScope" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
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
    <style>
        /*下拉按钮样式**/
        /*.down-panel {*/
        /*    padding: 0;*/
        /*    z-index: 100;*/
        /*}*/

        /*.down-panel .layui-select-title {*/
        /*    padding-right: 30px;*/
        /*    padding-left: 10px;*/
        /*    overflow: visible;*/
        /*}*/

        /*.down-panel dl {*/
        /*    color: #000;*/
        /*    top: 30px;*/
        /*    font-size: 14px;*/
        /*}*/

        /*.down-panel .layui-select-title i {*/
        /*    border-top-color: #fff;*/
        /*}*/

        /*.down-panel:hover {*/
        /*    opacity: 1 !important;*/
        /*    filter: alpha(opacity=100) !important;*/
        /*    color: #fff*/
        /*}*/

        /*.layui-anim-upbit {*/
        /*    top: 100% !important;*/
        /*    z-index: 999999 !important;*/
        /*}*/

        /*.layui-anim-upbit dd {*/
        /*    text-align: left;*/
        /*}*/

        /*.over-hover {*/
        /*    overflow: visible;*/
        /*    z-index: 9999;*/
        /*}*/

        /*.layui-select-title {*/
        /*    background-color: #008FBF;*/
        /*}*/
    </style>

</head>
<body>
<div class="layui-card layadmin-header" style="height: 50px; line-height: 50px; padding-left: 15px;">
    <div class="layui-breadcrumb" lay-filter="breadcrumb" style="visibility: visible;">
        <a lay-href="">学生管理</a><span lay-separator="">/</span> <a><cite>学生列表</cite></a>
    </div>
</div>

<div class="layui-card">
    <div class="layui-form layuiadmin-card-header-auto" lay-filter="layadmin-userfront-formlist">
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">学号</label>
                <div class="layui-input-block">
                    <input type="text" name="account" placeholder="请输入学号" autocomplete="off" class="layui-input">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">姓名</label>
                <div class="layui-input-block">
                    <input type="text" name="name" placeholder="请输入姓名" autocomplete="off" class="layui-input">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">寝室号</label>
                <div class="layui-input-block">
                    <input type="text" name="roomNo" placeholder="请输入寝室号" autocomplete="off" class="layui-input">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">所在学院</label>
                <div class="layui-input-block">
                    <select name="organId" id="organId">
                        <option value="">无</option>
                        <option value="2">藏学学院</option>
                        <option value="3">外国语学院</option>
                        <option value="4">教育科学学院</option>
                        <option value="5">理工学院</option>
                        <option value="6">音乐舞蹈学院</option>
                        <option value="7">美术学院</option>
                        <option value="8">文学院</option>
                        <option value="9">经济与管理学院</option>
                        <option value="10">法学院</option>
                        <option value="11">马克思主义学院</option>
                        <option value="12">农学院</option>
                        <option value="13">历史文化与旅游学院</option>
                        <option value="14">体育学院</option>
                        <option value="15">预科教育学院</option>
                    </select>
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">关键字</label>
                <div class="layui-input-block">
                    <input type="text" name="search" placeholder="请输入联系电话，身份证号，户籍" autocomplete="off" class="layui-input" style="width: 300px">
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
        <table class="" id="test" lay-filter="test"></table>
    </div>
</div>

<script>
    layui.config({
        base: '<%=basePath%>/js/layui/extends/',
    }).extend({
        treeSelect: 'treeSelect',
    });
    layui.use(['table', 'element', 'jquery', 'form','treeSelect'], function () {
        var table = layui.table;
        var element = layui.element;
        var form = layui.form;
        var $ = layui.$;
        var treeSelect = layui.treeSelect;

        // var bedRoom = {};
        //搜索表单提交
        form.on('submit(search-btn)', function (data) {
            var field = data.field;
            console.log(data.field);
            //表格重载条件
            table.reload('table', {
                where: field,page:{curr:1}
            });
        });
        table.render({
            elem: '#test'
            , url: '<%=basePath%>student/getStudentList'
            , title: '宿舍列表'
            , toolbar: true
            , defaultToolbar: [ 'print', 'exports']
            , parseData: function (res) { //res 即为原始返回的数据
                return {
                    "code": res.code == 200 ? 0 : res.code, //解析接口状态
                    "msg": res.description, //解析提示文本
                    "count": res.totalRows, //解析数据长度
                    "data": res.data, //解析数据列表
                };
            }
            , cols: [[
                {type: 'checkbox', fixed: 'left'}
                , {field: 'account', title: '学号', sort: true}
                , {field: 'name', title: '姓名'}
                /*, {field: 'sex', title: '性别',sort:true,templet:function (res) {
                        if (res.sex == 1) return '男';
                        else if (res.sex == 2) return '女';
                        else return '无';
                    }}*/
                , {field: 'idCard', title: '身份证号', minWidth: 175}
                , {field: 'parentName', title: '学院'}
                , {field: 'organName', title: '班级',sort:true}
                , {field: 'home', title: '户籍', minWidth: 180}
                , {field: 'phone', title: '电话',}
                , {field: 'roomNo', title: '寝室号',sort:true}
                /* 使用带有其他按钮的bar */
                , {minWidth: 175, title: '操作', toolbar: '#barDemo'}
            ]]
            , page: true
            , id: "table"
        });

        //监听行工具事件
        table.on('tool(test)', function (obj) {
            var data = obj.data;
            console.log(data);
            var query = {};
            if (obj.event === 'late'){
                query.account = data.account;
                console.log("晚归");
                layer.open({
                    type: 1,
                    title: '晚归记录',
                    offset: 'auto',
                    closeBtn: '2',
                    area: '650px',
                    content: $('#late')
                });
                table.render({
                    elem: '#lateTest'
                    , url: '<%=basePath%>late/getLateList'
                    , title: '晚归列表'
                    , where: query
                    // , toolbar: true
                    // , defaultToolbar: [ 'print', 'exports']
                    , parseData: function (res) { //res 即为原始返回的数据
                        return {
                            "code": res.code == 200 ? 0 : res.code, //解析接口状态
                            "msg": res.description, //解析提示文本
                            "count": res.totalRows, //解析数据长度
                            "data": res.data, //解析数据列表
                        };
                    }
                    , cols: [[
                        {field: 'id', hide: true}
                        , {field: 'time', title: '晚归时间', sort: true}
                        , {field: 'reason', title: '晚归原因'}
                        , {field: 'userName', title: '记录人'}
                        /* 使用带有其他按钮的bar */
                        // , {title: '操作', toolbar: '#barDemo'}
                    ]]
                    , page: true
                    , id: "lateTable"
                });

                //日志
                var log = {};
                log.type = 4;
                log.description = "查看了"+data.name+"的晚归记录";
                $.ajax({
                    url: '<%=basePath%>log/add',
                    type: 'post',
                    data: log,
                    dataType: 'json',
                    success: function (data) {
                        log = null;
                    }
                });

            }
            if (obj.event === 'update'){
                console.log("修改");
                console.log(data);
                refreshUpdateTree(obj.data.organId);
                $("#update_id").val(data.id);
                $("#update_name").val(data.name);
                $("#update_account").val(data.account);
                $("#update_phone").val(data.phone);
                $("#update_idCard").val(data.idCard);
                $("#update_home").val(data.home);
                $("#update_livePlace").val(data.livePlace);
                // $("#update_roleId option[value='"+data.roleId+"']").attr("selected","selected");
                // formThis.render('select');
                layer.open({
                    type: 1,
                    title: '修改学生信息',
                    area: ['700px', '480px'],
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
            if (obj.event === 'lf'){
                query.account = data.account;
                console.log("离返校");
                layer.open({
                    type: 1,
                    title: '离返校记录',
                    offset: 'auto',
                    closeBtn: '2',
                    area: '650px',
                    content: $('#lf')
                });
                table.render({
                    elem: '#lfTest'
                    , url: '<%=basePath%>lf/getLiFanList'
                    , title: '晚归列表'
                    , where: query
                    // , toolbar: true
                    // , defaultToolbar: [ 'print', 'exports']
                    , parseData: function (res) { //res 即为原始返回的数据
                        return {
                            "code": res.code == 200 ? 0 : res.code, //解析接口状态
                            "msg": res.description, //解析提示文本
                            "count": res.totalRows, //解析数据长度
                            "data": res.data, //解析数据列表
                        };
                    }
                    , cols: [[
                        {field: 'id', hide: true}
                        , {field: 'outTime', title: '离校时间', sort: true}
                        , {field: 'inTime', title: '返校时间', sort: true}
                        , {field: 'reason', title: '离校原因'}
                        , {field: 'userName', title: '记录人'}
                        /* 使用带有其他按钮的bar */
                        // , {title: '操作', toolbar: '#barDemo'}
                    ]]
                    , page: true
                    , id: "lfTable"
                });

                //日志
                var log = {};
                log.type = 4;
                log.description = "查看了"+data.name+"的离返校记录";
                $.ajax({
                    url: '<%=basePath%>log/add',
                    type: 'post',
                    data: log,
                    dataType: 'json',
                    success: function (data) {
                        log = null;
                    }
                });

            }

        });
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

        <%--//监听checkbox事件--%>
        <%--form.on('checkbox(status)', function (data) {--%>
        <%--    var submiterUser, consultationUserId;--%>
        <%--    $('.status').prop("checked", false);--%>
        <%--    $(this).prop("checked", true);--%>
        <%--    form.render('checkbox');--%>
        <%--    if (data.elem.value == 'wfqd') {--%>
        <%--        submiterUser = ${sessionScope.user.id};--%>
        <%--        consultationUserId = ""--%>
        <%--    } else if (data.elem.value == 'wcyd') {--%>
        <%--        consultationUserId = ${sessionScope.user.id};--%>
        <%--        submiterUser = ""--%>
        <%--    } else if (data.elem.value == 'qb') {--%>
        <%--        submiterUser = ""--%>
        <%--        consultationUserId = ""--%>
        <%--    }--%>
        <%--    //表格根据Id执行重载--%>
        <%--    table.reload('table', {--%>
        <%--        page: {--%>
        <%--            curr: 1 //重新从第 1 页开始--%>
        <%--        }--%>
        <%--        , where: {--%>
        <%--            submiterUser: submiterUser,--%>
        <%--            consultationUserId: consultationUserId--%>
        <%--        }--%>
        <%--    }, 'data');--%>
        <%--    return false;--%>
        <%--});--%>
    });

    /**下拉按钮事件*/
    function downPanel(that) {
        var nodes = layui.jquery(".layui-form-selected");
        var hoverNodes = layui.jquery(".over-hover");
        var current = layui.jquery(that).parent();
        if (current.hasClass("layui-form-selected")) {
            nodes.removeClass("layui-form-selected");
            hoverNodes.removeClass("over-hover");
        } else {
            if (nodes.length > 0) {
                nodes.removeClass("layui-form-selected");
                hoverNodes.removeClass("over-hover");
            }
            current.addClass("layui-form-selected");
            current.parent(".layui-form").parent().addClass("over-hover");
        }

        layui.jquery(document).click(function (event) {
            var _con2 = layui.jquery(".down-panel");
            if (!_con2.is(event.target) && (_con2.has(event.target).length === 0)) {
                _con2.removeClass("layui-form-selected");
                hoverNodes.removeClass("over-hover");
                nodes.removeClass("layui-form-selected");
            }
        });
    }
</script>
<script type="text/html" id="barDemo">
    <a class="layui-btn layui-btn-warm layui-btn-xs" lay-event="update">修改</a>
    <a class="layui-btn layui-btn-xs" lay-event="late">晚归</a>
    <a class="layui-btn layui-btn-xs" lay-event="lf">离返校</a>
</script>

<div id="late" style="display: none">
    <table id="lateTest" lay-filter="lateTest"></table>
</div>
<div id="lf" style="display: none">
    <table id="lfTest" lay-filter="lfTest"></table>
</div>

<%--修改--%>
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
            <label class="layui-form-label">学号</label>
            <div class="layui-input-inline">
                <input type="text" name="account" id="update_account" value="" lay-verify="required"
                       placeholder="请输入账号" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">身份证号</label>
            <div class="layui-input-inline">
                <input type="text" name="idCard" id="update_idCard" value="" lay-verify="required|identity"
                       placeholder="请输入身份证号" autocomplete="off" class="layui-input">
            </div>
            <label class="layui-form-label">所属机构</label>
            <div class="layui-input-inline">
                <input type="text" id="update_tree" name="organId" lay-filter="update_tree" lay-verify="required"
                       class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">联系电话</label>
            <div class="layui-input-inline">
                <input type="tel" name="phone" id="update_phone" value="" lay-verify="phone|required|checkPhone"
                       placeholder="请输入电话号码" autocomplete="off" class="layui-input">
            </div>
            <label class="layui-form-label">户籍</label>
            <div class="layui-input-inline">
                <input type="text" name="home" id="update_home" value="" lay-verify="required"
                       placeholder="请输入户籍所在地" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">居住地</label>
            <div class="layui-input-inline">
                <input type="text" name="livePlace" id="update_livePlace" value="" lay-verify="required"
                       placeholder="请输入现居住地" autocomplete="off" class="layui-input">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label"></label>
            <div class="layui-input-inline" style="text-align: center;margin-top: 20px;margin-left: 120px">
                <input type="button" lay-submit=""
                       lay-filter="update" value="确认" class="layui-btn">
            </div>
        </div>
    </div>
</div>
</body>
</html>