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
        .down-panel {
            padding: 0;
            z-index: 100;
        }

        .down-panel .layui-select-title {
            padding-right: 30px;
            padding-left: 10px;
            overflow: visible;
        }

        .down-panel dl {
            color: #000;
            top: 30px;
            font-size: 14px;
        }

        .down-panel .layui-select-title i {
            border-top-color: #fff;
        }

        .down-panel:hover {
            opacity: 1 !important;
            filter: alpha(opacity=100) !important;
            color: #fff
        }

        .layui-anim-upbit {
            top: 100% !important;
            z-index: 999999 !important;
        }

        .layui-anim-upbit dd {
            text-align: left;
        }

        .over-hover {
            overflow: visible;
            z-index: 9999;
        }

        .layui-select-title {
            background-color: #008FBF;
        }
    </style>

</head>
<body>
<div class="layui-card layadmin-header" style="height: 50px; line-height: 50px; padding-left: 15px;">
    <div class="layui-breadcrumb" lay-filter="breadcrumb" style="visibility: visible;">
        <a lay-href="">宿舍管理</a><span lay-separator="">/</span> <a><cite>外来人员列表</cite></a>
    </div>
</div>

<div class="layui-card">
    <div class="layui-form layuiadmin-card-header-auto" lay-filter="layadmin-userfront-formlist">
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">姓名</label>
                <div class="layui-input-block">
                    <input type="text" name="name" placeholder="请输入姓名" autocomplete="off" class="layui-input">
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
    <script type="text/html" id="barDemo">
        <%--        {{#  if(d.roomMan == null || d.roomMan == undefined){ }}--%>
        <%--        <a class="layui-btn layui-btn-xs" lay-event="assign">指派室长</a>--%>
        <%--        {{# }}}--%>
        <%--&lt;%&ndash;        <a class="layui-btn layui-btn-xs" lay-event="detail">查看详情</a>&ndash;%&gt;--%>
        <%--        <a class="layui-btn layui-btn-warm layui-btn-xs" lay-event="update">修改</a>--%>
                <c:if test="${sessionScope.user.roleId == 1}">
        <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
                </c:if>
    </script>
    <script type="text/html" id="toolbarDemo">
        <a class="layui-btn layui-btn-sm" lay-event="add">外来人员登记</a>
        <a class="layui-btn layui-btn-sm" lay-event="excelImport" id="excelImport">批量导入</a>
        <%--        <button type="button" class="layui-btn layui-btn-normal" id="excelImport">--%>
        <%--            批量导入--%>
        <%--        </button>--%>
        <%--        <button type="button" class="layui-btn" id="test1">--%>
        <%--            <i class="layui-icon">&#xe67c;</i>上传图片--%>
        <%--        </button>--%>
    </script>
</div>

<script>
    layui.use(['table', 'element', 'jquery', 'form', 'upload','laydate'], function () {
        var table = layui.table;
        var element = layui.element;
        var form = layui.form;
        var $ = layui.$;
        var upload = layui.upload;
        var laydate = layui.laydate;
        // var bedRoom = {};

        //时间选择
        laydate.render({
            elem: '#inTime',//指定元素
            type:'datetime'
        });

        //时间选择
        laydate.render({
            elem: '#outTime',//指定元素
            type:'datetime'
        });


        //搜索表单提交
        form.on('submit(search-btn)', function (data) {
            var field = data.field;
            console.log(data.field);
            //表格重载条件
            table.reload('table', {
                where: field, page: {curr: 1}
            });
        });
        table.render({
            elem: '#test'
            , url: '<%=basePath%>outsider/getOutsiderList'
            , title: '外来人员列表'
            , toolbar: '#toolbarDemo'
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
                {type: 'checkbox'}
                , {field: 'name', title: '姓名'}
                , {field: 'phone', title: '联系电话'}
                , {field: 'inTime', title: '进入时间'}
                , {field: 'outTime', title: '离开时间'}
                , {field: 'reason', title: '进入原因'}
                /* 使用带有其他按钮的bar */
                , {title: '操作', toolbar: '#barDemo'}
            ]]
            , page: true
            , id: "table"
            // , done:function (res, curr, count) {
            //     for(var i in res.data){		//遍历整个表格数据
            //         var item = res.data[i];		//获取当前行数据
            //         if(item.realPerson==item.maxPerson){
            //             $("tr[data-index='" + i + "']").attr({"style":"background:#FFDEAD"});  //将当前行变成橙色
            //         }
            //         // ……
            //     }
            // }
        });

        //监听行工具事件
        table.on('tool(test)', function (obj) {
            var data = obj.data;
            console.log(data);
            if (obj.event === 'detail') {
                console.log("查看详情");
            } else if (obj.event === 'del') {
                console.log("删除");
                layer.confirm('确认删除?', function (index) {
                    $.ajax({
                        url: '<%=basePath%>outsider/del',
                        type: 'post',
                        data: {id: data.id},
                        success: function (data1) {
                            // alert
                            if (data1.code == 0) {
                                layer.msg(data1.description);
                                layer.close(index);
                                table.reload('table');
                                var log = {};
                                log.type = 3;
                                log.description = "删除了外来人员记录,姓名:"+data.name+",电话:"+data.phone;
                                $.ajax({
                                    url: '<%=basePath%>log/add',
                                    type: 'post',
                                    data: log,
                                    dataType: 'json',
                                    success: function (data) {
                                    }
                                });
                                log = null;
                            } else {
                                layer.msg(data.description);
                            }
                        }
                    });
                });
            }

        });
        //监听头工具事件
        table.on('toolbar(test)', function (obj) {
            var checkStatus = table.checkStatus(obj.config.id);
            switch (obj.event) {
                case 'add':
                    $("#add-form")[0].reset();
                    layui.form.render();
                    layer.open({
                        type: 1,
                        title: '添加记录',
                        area: ['700px', '400px'],
                        content: $('#add-modal'),
                        // shade: 0,
                        success: function (layero, index) {
                            //表单提交
                            form.on('submit(add-form-submit)', function (data) {
                                $.ajax({
                                    url: '<%=basePath%>outsider/add',
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
                                            log.description = "增加了外来人员记录,姓名:"+data.name+",电话:"+data.phone;
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
                case 'excelImport':
                    console.log("导入宿舍");

                    break;
                case 'update':
                    layer.msg('编辑');
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
<div id="add-modal" style="display: none">
    <form class="layui-form" lay-filter="add-form"
         style="padding: 20px 0 0 0;" id="add-form">
        <input type="hidden" name="id"/>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">姓名</label>
                <div class="layui-input-inline">
                    <input type="text" name="name" value="" lay-verify="required"
                           placeholder="请输入姓名" autocomplete="off" class="layui-input">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">联系电话</label>
                <div class="layui-input-inline">
                    <input type="text" name="phone" value="" lay-verify="required|phone|number"
                           placeholder="请输入电话" autocomplete="off" class="layui-input">
                </div>
            </div>
        </div>
        <div class="layui-form-item" style="margin-top: 30px">
            <div class="layui-inline">
                <label class="layui-form-label">进入时间</label>
                <div class="layui-input-inline">
                    <input type="text" name="inTime" id="inTime" value="" lay-verify="required"
                           placeholder="请选择时间" autocomplete="off" class="layui-input">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">离开时间</label>
                <div class="layui-input-inline">
                    <input type="text" name="outTime" id="outTime" value="" lay-verify="required"
                           placeholder="请选择时间" autocomplete="off" class="layui-input">
                </div>
            </div>
        </div>
        <div class="layui-form-item" style="margin-top: 30px">
            <div class="layui-inline">
                <label class="layui-form-label">进入原因</label>
                <div class="layui-input-inline">
                    <textarea name="reason" placeholder="请输入进入原因" class="layui-textarea" lay-verify="required" style="width: 514px"></textarea>
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label"></label>
            <div class="layui-input-inline">
                <input type="button" lay-submit=""
                       lay-filter="add-form-submit" value="确认" class="layui-btn">
            </div>
        </div>
    </form>
</div>
</body>
</html>