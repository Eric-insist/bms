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
        <a lay-href="">学生中心</a><span lay-separator="">/</span> <a><cite>审批中心</cite></a>
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
            <div class="layui-inline">
                <label class="layui-form-label">申请人:</label>
                <div class="layui-input-block">
                    <input type="text" name="userName" placeholder="请输入申请人" autocomplete="off" class="layui-input">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">寝室号:</label>
                <div class="layui-input-block">
                    <input type="text" name="roomNo" placeholder="请输入寝室号" autocomplete="off" class="layui-input">
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
    <script type="text/html" id="toolbarDemo">
        <a class="layui-btn layui-btn-sm" lay-event="change">换寝申请</a>
        <a class="layui-btn layui-btn-sm" lay-event="repair">报修申请</a>
    </script>
    <script type="text/html" id="barDemo">
        {{#  if(d.state == 1 && d.type ==  1 ){ }}
        <a class="layui-btn layui-btn-xs layui-btn-normal " lay-event="agree">同意</a>
        <a class="layui-btn layui-btn-xs layui-btn-danger" lay-event="refuse">拒绝</a>
        {{# } }}
        {{#  if(d.state == 1 && d.type ==  2 ){ }}
        <a class="layui-btn layui-btn-xs layui-btn-normal " lay-event="deal">已处理</a>
        {{# } }}
    </script>
</div>

<script>
    var refuseIndex;
    layui.use(['table', 'element', 'jquery', 'form', 'upload'], function () {
        var table = layui.table;
        var element = layui.element;
        var form = layui.form;
        var $ = layui.$;
        var upload = layui.upload;


        var apply = {};
        if ($("#userRoleId").val() == 2) {
            apply.towerNo = $("#userTowerNo").val();
        }
        //搜索表单提交
        form.on('submit(search-btn)', function (data) {
            var field = data.field;
            console.log(data.field);
            //表格重载条件
            table.reload('table', {
                where: field, page: {curr: 1}
            });
        });
        if ($("#userRoleId").val() == 2) {
            apply.towerNo = $("#userTowerNo").val();
        }
        table.render({
            elem: '#test'
            , url: '<%=basePath%>apply/getApplyList'
            , where: apply
            , title: '申请记录'
            // , toolbar: '#toolbarDemo'
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
                , {field: 'userName', title: '申请人'}
                , {field: 'roomNo', title: '寝室号', sort: true}
                // , {
                //     field: 'type', title: '申请类型', templet: function (res) {
                //         if (res.type == 1) return '换寝';
                //         else if (res.type == 2) return '报修';
                //     }
                // }
                , {field: 'description', title: '描述', minWidth: 300}
                , {
                    field: 'state', title: '状态', templet: function (data) {
                        if (data.type == 1) {
                            if (data.state == 1) return "<span title='未审核' style='color: royalblue;font-weight: bold;'>未审核</span>";
                            else if (data.state == 2) return "<span title='已审核' style='color: limegreen;font-weight: bold;'>已审核</span>";
                            else return "<span title='已拒绝' style='color: red;font-weight: bold;'>已拒绝</span>";
                        }
                        if (data.type == 2) {
                            if (data.state == 1) return "<span title='处理中' style='color: royalblue;font-weight: bold;'>处理中</span>";
                            else if (data.state == 2) return "<span title='已处理' style='color: limegreen;font-weight: bold;'>已处理</span>";
                        }

                    }
                }
                , {field: 'applyTime', title: '申请时间', minWidth: 140}
                , {
                    field: 'result', title: '结果', minWidth: 200, templet: function (data) {
                        if (data.result == null || data.result == undefined) return '无';
                        else return data.result;
                    }
                }
                /* 使用带有其他按钮的bar */
                , {minWidth: 130, title: '操作', toolbar: '#barDemo'}
            ]]
            , page: true
            , id: "table"
        });

        //监听行工具事件
        table.on('tool(test)', function (obj) {
            var data = obj.data;
            console.log(data);
            if (obj.event === 'agree') {
                console.log("同意");
                layer.confirm('确认通过？', {title: "提示", closeBtn: 2}, function (index) {
                    $.ajax({
                        url: '<%=basePath%>apply/agree',
                        type: 'post',
                        data: {id: data.id,type:1},
                        success: function (res) {
                            if (res.code == 0) {
                                layer.close(index);
                                layer.msg(res.description);
                                table.reload("table");
                                //日志
                                var log = {};
                                log.type = 1;
                                log.description = "同意了"+data.userName+"的换寝申请";
                                $.ajax({
                                    url: '<%=basePath%>log/add',
                                    type: 'post',
                                    data: log,
                                    dataType: 'json',
                                    success: function (data) {
                                        log = null;
                                    }
                                });

                            }else {
                                layer.close(index);
                                layer.msg(res.description);
                                table.reload("table");
                            }
                        }
                    })
                })
            } else if (obj.event === 'refuse') {
                console.log("拒绝");
                $("#refuseInfo").val("");
                $("#colId").val(data.id);
                $("#userName_1").val(data.userName);
                refuseIndex = layer.open({
                    type: 1,
                    title: '拒绝理由',
                    area: ['560px', '260px'],
                    content: $('#refuse-form-modal'),
                    shade: 0.3,
                    closeBtn: 2
                })
            } else if (obj.event === 'deal') {
                console.log("处理");
                layer.confirm('确认？', {title: "提示", closeBtn: 2}, function (index) {
                    $.ajax({
                        url: '<%=basePath%>apply/agree',
                        type: 'post',
                        data: {id: data.id,type:2},
                        success: function (res) {
                            if (res.code == 0) {
                                layer.close(index);
                                layer.msg(res.description);
                                table.reload("table");
                                //日志
                                var log = {};
                                log.type = 1;
                                log.description = "处理了"+data.userName+"的报修申请(寝室:"+data.roomNo+"）";
                                $.ajax({
                                    url: '<%=basePath%>log/add',
                                    type: 'post',
                                    data: log,
                                    dataType: 'json',
                                    success: function (data) {
                                        log = null;
                                    }
                                });
                            }else {
                                layer.close(index);
                                layer.msg(res.description);
                                table.reload("table");
                            }
                        }
                    })
                })
            }

        });
        //监听提交(拒绝)
        form.on('submit(formDemo)', function (data) {
            console.log(data);
            $.ajax({
                url: '<%=basePath%>apply/refuse',
                type: 'post',
                data: data.field,
                dataType:'json',
                success: function (res) {
                    if (res.code == 0){
                        layer.close(refuseIndex);
                        layer.msg(res.description);
                        table.reload("table");
                        //日志
                        var log = {};
                        log.type = 1;
                        log.description = "拒绝了"+data.userName+"的换寝申请";
                        $.ajax({
                            url: '<%=basePath%>log/add',
                            type: 'post',
                            data: log,
                            dataType: 'json',
                            success: function (data) {
                                log = null;
                            }
                        });
                    }else {
                        layer.msg(res.description);
                    }
                }
            })
            return false;
        });
        //监听头工具事件
        table.on('toolbar(test)', function (obj) {
            var checkStatus = table.checkStatus(obj.config.id);
            switch (obj.event) {
                case 'add':
                    break;
                case 'excelImport':
                    break;
                case 'update':
                    break;
            }
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
<div id="refuse-form-modal" style="display: none">
    <div class="layui-form">
        <div class="layui-form-item layui-form-text" style="margin-top: 20px;width: 500px">
            <input type="text" id="colId" name="id" hidden>
            <input type="text" id="userName_1" name="userName" hidden>
            <label class="layui-form-label">拒绝理由:</label>
            <div class="layui-input-block">
                <textarea id="refuseInfo" name="result" placeholder="请输入拒绝理由" class="layui-textarea"></textarea>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-input-block">
                <button class="layui-btn" lay-submit lay-filter="formDemo">立即提交</button>
            </div>
        </div>
    </div>
</div>
</body>
</html>