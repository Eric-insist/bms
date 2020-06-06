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
        /*!*下拉按钮样式**!*/
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
        <a lay-href="">学生中心</a><span lay-separator="">/</span> <a><cite>申请记录</cite></a>
    </div>
</div>

<div class="layui-card">
    <div class="layui-form layuiadmin-card-header-auto" lay-filter="layadmin-userfront-formlist">
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">记录类型</label>
                <div class="layui-input-block">
                    <select name="type" id="type">
                        <option value="">无</option>
                        <option value="1">换寝</option>
                        <option value="2">报修</option>
                    </select>
                </div>
            </div>
            <%--            <div class="layui-inline">--%>
            <%--                <label class="layui-form-label">宿舍楼编号:</label>--%>
            <%--                <div class="layui-input-block">--%>
            <%--                    <input type="text" name="towerNo" placeholder="请输入宿舍楼编号(几栋)" autocomplete="off" class="layui-input">--%>
            <%--                </div>--%>
            <%--            </div>--%>
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
    <script type="text/html" id="toolbarDemo">
        <a class="layui-btn layui-btn-sm" lay-event="change">换寝申请</a>
        <a class="layui-btn layui-btn-sm" lay-event="repair">报修申请</a>
    </script>
</div>

<script>
    layui.use(['table', 'element', 'jquery', 'form', 'upload'], function () {
        var table = layui.table;
        var element = layui.element;
        var form = layui.form;
        var $ = layui.$;
        var upload = layui.upload;


        var apply = {};
        apply.userId = $("#userId").val();
        //搜索表单提交
        form.on('submit(search-btn)', function (data) {
            var field = data.field;
            console.log(data.field);
            //表格重载条件
            table.reload('table', {
                where: field, page: {curr: 1}
            });
        });
        apply.userId = $("#userId").val();
        table.render({
            elem: '#test'
            , url: '<%=basePath%>apply/getStudentApplyList'
            , where: apply
            , title: '申请记录'
            , toolbar: '#toolbarDemo'
            , defaultToolbar: false
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
                // , {field: 'roomNo', title: '寝室号', sort: true}
                , {
                    field: 'type', title: '申请类型', templet: function (res) {
                        if (res.type == 1) return '换寝';
                        else if (res.type == 2) return '报修';
                    }
                }
                , {field: 'description', title: '描述', minWidth: 400}
                , {
                    field: 'state', title: '状态', templet: function (data) {
                        if (data.type == 1){
                            if (data.state == 1) return "<span title='未审核' style='color: royalblue;font-weight: bold;'>未审核</span>";
                            else if (data.state == 2) return "<span title='已审核' style='color: limegreen;font-weight: bold;'>已审核</span>";
                            else return "<span title='已拒绝' style='color: red;font-weight: bold;'>已拒绝</span>";
                        }
                        if (data.type == 2){
                            if (data.state == 1) return "<span title='处理中' style='color: royalblue;font-weight: bold;'>处理中</span>";
                            else if (data.state == 2) return "<span title='已处理' style='color: limegreen;font-weight: bold;'>已处理</span>";
                        }

                    }
                }
                , {field: 'applyTime', title: '申请时间'}
                , {
                    field: 'result', title: '结果', minWidth: 250, templet: function (data) {
                        if (data.result == null || data.result == undefined) return '无';
                        else return data.result;
                    }
                }
                /* 使用带有其他按钮的bar */
                // , {fixed: 'right', minWidth: 270, title: '操作', toolbar: '#barDemo'}
            ]]
            , page: true
            , id: "table"
        });

        //监听行工具事件
        table.on('tool(test)', function (obj) {
            var data = obj.data;
            console.log(data);
        });
        //监听头工具事件
        table.on('toolbar(test)', function (obj) {
            var checkStatus = table.checkStatus(obj.config.id);
            switch (obj.event) {
                case 'change':
                    console.log("换寝");
                    $("#description_change").val(null);
                    $("#newRoomNo_change").val(null);
                    layer.open({
                        type: 1,
                        title: '换寝申请',
                        area: ['380px', '300px'],
                        content: $('#change-modal'),
                        // shade: 0,
                        success: function (layero, index) {
                            //表单提交
                            form.on('submit(changeForm)', function (data) {
                                console.log(data);
                                $.ajax({
                                    url: '<%=basePath%>apply/change',
                                    type: 'post',
                                    data: data.field,
                                    dataType: 'json',
                                    success: function (data1) {
                                        // alert
                                        if (data1.code == 0) {
                                            layer.msg(data1.description);
                                            layer.close(index);
                                            table.reload('table');
                                            var log = {};
                                            log.type = 1;
                                            log.description = "提交了换寝申请,姓名:"+data.userName+",寝室:"+data.roomNo+",申请寝室:"+data.newRoomNo;
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
                                            layer.msg(data.description);
                                        }
                                    }
                                });
                            });
                        }
                    });
                    break;
                case 'repair':
                    console.log("报修");
                    $("#description").val(null);
                    $("#result").val("自然损坏");
                    form.render('select','repair');
                    layer.open({
                        type: 1,
                        title: '报修申请',
                        area: ['400px', '360px'],
                        content: $('#repair-modal'),
                        // shade: 0,
                        success: function (layero, index) {
                            //表单提交
                            form.on('submit(repairForm)', function (data) {
                                console.log(data);
                                $.ajax({
                                    url: '<%=basePath%>apply/repair',
                                    type: 'post',
                                    data: data.field,
                                    dataType: 'json',
                                    success: function (data1) {
                                        // alert
                                        if (data1.code == 0) {
                                            layer.msg(data1.description);
                                            layer.close(index);
                                            table.reload('table');
                                            var log = {};
                                            log.type = 1;
                                            log.description = "提交了报修申请,姓名:"+data.userName+",寝室:"+data.roomNo;
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
                                            layer.msg(data.description);
                                        }
                                    }
                                });
                            });
                        }
                    })
                    break;
            }
            ;
        });

        //监听checkbox事件
        form.on('checkbox(status)', function (data) {
            var submiterUser, consultationUserId;
            $('.status').prop("checked", false);
            $(this).prop("checked", true);
            form.render('checkbox');
            if (data.elem.value == 'wfqd') {
                submiterUser = ${sessionScope.user.id};
                consultationUserId = ""
            } else if (data.elem.value == 'wcyd') {
                consultationUserId = ${sessionScope.user.id};
                submiterUser = ""
            } else if (data.elem.value == 'qb') {
                submiterUser = ""
                consultationUserId = ""
            }
            //表格根据Id执行重载
            table.reload('table', {
                page: {
                    curr: 1 //重新从第 1 页开始
                }
                , where: {
                    submiterUser: submiterUser,
                    consultationUserId: consultationUserId
                }
            }, 'data');
            return false;
        });
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
<div id="change-modal" style="display: none">
    <div class="layui-form">
        <input type="text" name="userId" value="${sessionScope.user.id}" hidden>
        <input type="text" name="userName" value="${sessionScope.user.name}" hidden>
        <input type="text" name="roomNo" value="${sessionScope.room.roomNo}" hidden>
        <div class="layui-form-item layui-form-text" style="margin-top: 20px;width: 360px">
            <label class="layui-form-label">换寝理由:</label>
            <div class="layui-input-block">
                <textarea id="description_change" name="description" placeholder="请输入换寝理由" class="layui-textarea" lay-verify="required"></textarea>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">宿舍号</label>
            <div class="layui-input-inline">
                <input type="text" id="newRoomNo_change" name="newRoomNo" value="" lay-verify="required"
                       placeholder="请输入宿舍号" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-input-block">
                <button class="layui-btn" lay-submit lay-filter="changeForm">立即提交</button>
            </div>
        </div>
    </div>
</div>
<div id="repair-modal" style="display: none">
    <div class="layui-form" lay-filter="repair">
        <input type="text" name="userId" value="${sessionScope.user.id}" hidden>
        <input type="text" name="userName" value="${sessionScope.user.name}" hidden>
        <input type="text" name="roomNo" value="${sessionScope.room.roomNo}" hidden>
        <div class="layui-form-item layui-form-text" style="margin-top: 20px;width: 360px">
            <label class="layui-form-label">报修说明:</label>
            <div class="layui-input-block">
                <textarea id="description" name="description" placeholder="请输入报修说明" class="layui-textarea" lay-verify="required"></textarea>
            </div>
        </div>
        <div class="layui-form-item" style="margin-right: 40px">
            <label class="layui-form-label">类型:</label>
            <div class="layui-input-block">
                <select name="result" id="result">
                    <option value="自然损坏">自然损坏</option>
                    <option value="人为损坏">人为损坏</option>
                </select>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-input-block">
                <button class="layui-btn" lay-submit lay-filter="repairForm">立即提交</button>
            </div>
        </div>
    </div>
</div>
</body>
</html>