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
        <a lay-href="">住宿管理</a><span lay-separator="">/</span> <a><cite>迁出办理</cite></a>
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
                    <input type="text" name="search" placeholder="请输入联系电话" autocomplete="off" class="layui-input" style="width: 300px">
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
    layui.use(['table', 'element', 'jquery', 'form'], function () {
        var table = layui.table;
        var element = layui.element;
        var form = layui.form;
        var $ = layui.$;

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
            , toolbar: '#toolbarDemo'
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
                // , {field: 'idCard', title: '身份证号', minWidth: 175}
                , {field: 'parentName', title: '学院'}
                , {field: 'organName', title: '班级',sort:true}
                // , {field: 'home', title: '户籍', minWidth: 180}
                , {field: 'phone', title: '电话'}
                , {field: 'roomNo', title: '寝室号',sort:true}
                /* 使用带有其他按钮的bar */
                , {title: '操作', toolbar: '#barDemo'}
            ]]
            , page: true
            , id: "table"
        });

        //监听行工具事件
        table.on('tool(test)', function (obj) {
            var data = obj.data;
            console.log(data);
            if (obj.event === 'leave'){
                console.log("迁出");
                layer.confirm('确认迁出?', function (index) {
                    $.ajax({
                        url: '<%=basePath%>bedroom/outBedroom',
                        type: 'post',
                        data: data,
                        dataType: 'json',
                        success: function (data1) {
                            // alert
                            if (data1.code == 0) {
                                layer.msg(data1.description);
                                layer.close(index);
                                table.reload('table');
                                var log = {};
                                log.type = 3;
                                log.description = "办理了迁出,姓名:"+data.name+",学号:"+data.account;
                                $.ajax({
                                    url: '<%=basePath%>log/add',
                                    type: 'post',
                                    data: log,
                                    dataType: 'json',
                                    success: function (data) {
                                        log = null;
                                    }
                                });

                            } else {
                                layer.close(index);
                                layer.msg(data.description);
                            }
                        }
                    });
                })
            }
        });

        //监听头工具事件
        table.on('toolbar(test)', function(obj){
            var checkStatus = table.checkStatus(obj.config.id);
            switch(obj.event){
                case 'BatchLeave':
                    // layer.msg('批量迁出');
                    console.log(checkStatus);
                    var idList = new Array();
                    var account = "";
                    $.each(checkStatus.data,function (i,val) {
                       idList.push(val.id);
                       account = account+(","+val.account);
                    });
                    console.log(idList);
                    if (idList.length == 0){
                        layer.msg("请选择迁出人员！");
                        return;
                    }
                    layer.confirm('确认迁出?', function (index) {
                        $.ajax({
                            url: '<%=basePath%>bedroom/BatchLeave',
                            type: 'post',
                            data: JSON.stringify(idList),
                            contentType:"application/json",
                            success: function (data) {
                                if (data.code == 0) {
                                    idList.length = 0;
                                    layer.msg(data.description);
                                    layer.close(index);
                                    table.reload('table');
                                    var log = {};
                                    log.type = 1;
                                    log.description = "批量办理了迁出,学号("+account+")";
                                    $.ajax({
                                        url: '<%=basePath%>log/add',
                                        type: 'post',
                                        data: log,
                                        dataType: 'json',
                                        success: function (data) {
                                            log = null;
                                        }
                                    });

                                } else {
                                    idList.length = 0;
                                    layer.close(index);
                                    layer.msg(data.description);
                                }
                            }
                        });
                    })
                    break;
            };
        });

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

    <a class="layui-btn layui-btn-xs" lay-event="leave">迁出</a>
</script>
<script type="text/html" id="toolbarDemo">
    <a class="layui-btn layui-btn-sm" lay-event="BatchLeave">批量迁出</a>
</script>
</body>
</html>