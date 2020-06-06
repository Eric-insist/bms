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
    <script src="<%=basePath%>/js/layui/extends/excel.js"></script>
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
        <a lay-href="">宿舍管理</a><span lay-separator="">/</span> <a><cite>宿舍列表</cite></a>
    </div>
</div>

<div class="layui-card">
    <div class="layui-form layuiadmin-card-header-auto" lay-filter="layadmin-userfront-formlist">
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">寝室号</label>
                <div class="layui-input-block">
                    <input type="text" name="roomNo" placeholder="请输入寝室号" autocomplete="off" class="layui-input">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">宿舍楼编号:</label>
                <div class="layui-input-block">
                    <input type="text" name="towerNo" placeholder="请输入宿舍楼编号(几栋)" autocomplete="off" class="layui-input">
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
    <script type="text/html" id="barDemo">
        <%--        {{#  if(d.roomMan == null || d.roomMan == undefined){ }}--%>
        <%--        <a class="layui-btn layui-btn-xs" lay-event="assign">指派室长</a>--%>
        <%--        {{# }}}--%>
        <%--        <a class="layui-btn layui-btn-xs" lay-event="detail">查看详情</a>--%>
        {{#  if(d.towerNo == $('#userTowerNo').val() ){ }}
        <a class="layui-btn layui-btn-warm layui-btn-xs" lay-event="update">修改</a>
        {{# }}}
        <c:if test="${sessionScope.user.roleId == 1}">
            <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
        </c:if>
    </script>
    <script type="text/html" id="toolbarDemo">
        <a class="layui-btn layui-btn-sm" lay-event="add">添加宿舍</a>
        <a class="layui-btn layui-btn-sm" lay-event="excelImport">批量导入</a>
    </script>
    <input type="text" id="log_roomNo" value="" hidden>
    <input type="text" id="log_maxPerson" value="" hidden>
</div>

<script>
    var ExcelIndex;
    var layerThis;
    var fileUrl;
    var tabThis;
    var excelThis;
    layui.use(['table', 'element', 'jquery', 'form', 'upload', 'layer','excel'], function () {
        var table = layui.table;
        var element = layui.element;
        var form = layui.form;
        var $ = layui.$;
        var upload = layui.upload;
        layerThis = layui.layer;
        tabThis = table;
        var excel = layui.excel;
        excelThis = excel;
        // var bedRoom = {};


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
            , url: '<%=basePath%>bedroom/getBedRoomList'
            , title: '宿舍列表'
            , toolbar: '#toolbarDemo'
            // , defaultToolbar: ['print', 'exports']
            , totalRow: 'true'
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
                , {field: 'roomNo', title: '寝室号', sort: true}
                , {field: 'towerNo', title: '宿舍楼编号(几栋)', sort: true}
                // , {field: 'roomMan', title: '室长'}
                // , {field: 'phone', title: '寝室电话'}
                , {field: 'realPerson', title: '已用床位'}
                , {field: 'maxPerson', title: '最大床位'}
                /* 使用带有其他按钮的bar */
                , {title: '操作', toolbar: '#barDemo'}
            ]]
            , page: true
            , id: "table"
            , done: function (res, curr, count) {
                for (var i in res.data) {		//遍历整个表格数据
                    var item = res.data[i];		//获取当前行数据
                    if (item.realPerson == item.maxPerson) {
                        $("tr[data-index='" + i + "']").attr({"style": "background:#FFDEAD"});  //将当前行变成橙色
                    }
                    // ……
                }
            }
        });

        //监听行工具事件
        table.on('tool(test)', function (obj) {
            var data = obj.data;
            console.log(data);
            if (obj.event === 'detail') {
                console.log("查看详情");
            } else if (obj.event === 'update') {
                console.log("修改");
                $("#update_id").val(data.id);
                $("#update_roomNo").val(data.roomNo);
                $("#update_maxPerson").val(data.maxPerson);
                $("#log_roomNo").val(data.roomNo);
                $("#log_maxPerson").val(data.maxPerson);
                layer.open({
                    type: 1,
                    title: '修改宿舍',
                    area: ['380px', '260px'],
                    content: $('#update-modal'),
                    // shade: 0,
                    success: function (layero, index) {
                        //表单提交
                        form.on('submit(update-form-submit)', function (data1) {
                            if (data1.field.roomNo == data.roomNo && data1.field.maxPerson == data.maxPerson) {
                                layer.msg("请修改信息");
                                return;
                            }
                            $.ajax({
                                url: '<%=basePath%>bedroom/updateBedroom',
                                type: 'post',
                                data: data1.field,
                                dataType: 'json',
                                success: function (data) {
                                    if (data.code == 0) {
                                        layer.msg(data.description);
                                        layer.close(index);
                                        table.reload('table');
                                        var log = {};
                                        log.type = 2;
                                        log.description = '将宿舍信息由(寝室号:' + $("#log_roomNo").val() + ',最大人数:' + $("#log_maxPerson").val() + ')改为' +
                                            '(寝室号:' + data1.field.roomNo + ',最大人数:' + data1.field.maxPerson + ')';
                                        $.ajax({
                                            url: '<%=basePath%>log/add',
                                            type: 'post',
                                            data: log,
                                            dataType: 'json',
                                            success: function (data) {
                                                if (data.code == 0) {
                                                    log = null;
                                                    $("#log_roomNo").val('');
                                                    $("#log_maxPerson").val('');
                                                }
                                            }
                                        })
                                    } else {
                                        layer.msg(data.description);
                                    }
                                }
                            });
                        });
                    }
                })
            } else if (obj.event === 'del') {
                console.log("删除");
                layer.confirm('确认删除?', function (index) {
                    $.ajax({
                        url: '<%=basePath%>bedroom/delBedroom',
                        type: 'post',
                        data: {id: data.id},
                        success: function (data1) {
                            if (data1.code == 0) {
                                layer.msg(data1.description);
                                layer.close(index);
                                table.reload('table');
                                var log = {};
                                log.type = 3;
                                log.description = '删除了寝室号为' + data.roomNo + '的寝室';
                                $.ajax({
                                    url: '<%=basePath%>log/add',
                                    type: 'post',
                                    data: log,
                                    dataType: 'json',
                                    success: function (data) {
                                        if (data.code == 0) {
                                            log = null;
                                        }
                                    }
                                })
                            } else {
                                layer.close(index);
                                layer.msg(data1.description);
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
                    console.log("添加宿舍");
                    $("#add_roomNo").val(null);
                    $("#add_maxPerson").val(null);
                    layer.open({
                        type: 1,
                        title: '添加宿舍',
                        area: ['380px', '260px'],
                        content: $('#add-modal'),
                        // shade: 0,
                        success: function (layero, index) {
                            //表单提交
                            form.on('submit(add-form-submit)', function (data) {
                                $.ajax({
                                    url: '<%=basePath%>bedroom/addBedroom',
                                    type: 'post',
                                    data: data.field,
                                    dataType: 'json',
                                    success: function (data1) {
                                        if (data1.code == 0) {
                                            layer.msg(data1.description);
                                            layer.close(index);
                                            table.reload('table');
                                            var log = {};
                                            log.type = 3;
                                            log.description = '新增了寝室号为,' + data.roomNo + '的寝室';
                                            $.ajax({
                                                url: '<%=basePath%>log/add',
                                                type: 'post',
                                                data: log,
                                                dataType: 'json',
                                                success: function (data) {
                                                    if (data.code == 0) {
                                                        log = null;
                                                    }
                                                }
                                            })
                                        } else {
                                            layer.msg(data1.description);
                                        }
                                    }
                                });
                            });
                        }
                    })
                    break;
                case 'excelImport':
                    console.log("导入宿舍");
                    // src.value = "";
                    $("#file").val("");
                    fileUrl = "";
                    $("#fileUpload").val("");
                    ExcelIndex = layer.open({
                        type: 1,
                        title: '导入',
                        area: ['400px', '220px'],
                        content: $('#excel'),
                        shade: 0.3,
                        closeBtn: 2
                    });
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
    <div class="layui-form" lay-filter="add-form"
         style="padding: 20px 0 0 0;">
        <input type="hidden" name="id"/>
        <div class="layui-form-item">
            <label class="layui-form-label">宿舍号</label>
            <div class="layui-input-inline">
                <input type="text" id="add_roomNo" name="roomNo" value="" lay-verify="required"
                       placeholder="请输入宿舍号" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">床位数</label>
                <div class="layui-input-inline">
                    <input type="text" id="add_maxPerson" name="maxPerson" value="" lay-verify="required"
                           placeholder="请输入床位数" autocomplete="off" class="layui-input">
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
    </div>
</div>
<div id="update-modal" style="display: none">
    <div class="layui-form" lay-filter="update-form"
         style="padding: 20px 0 0 0;">
        <input type="hidden" name="id" id="update_id"/>
        <div class="layui-form-item">
            <label class="layui-form-label">宿舍号</label>
            <div class="layui-input-inline">
                <input type="text" id="update_roomNo" name="roomNo" value="" lay-verify="required"
                       placeholder="请输入宿舍号" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">床位数</label>
                <div class="layui-input-inline">
                    <input type="text" id="update_maxPerson" name="maxPerson" value="" lay-verify="required"
                           placeholder="请输入床位数" autocomplete="off" class="layui-input">
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
<div id="excel" style="display: none">
    <form id="bedroom" method="post" enctype="multipart/form-data"
          action="" class="layui-form">
        <div id="vertical">
            <div id="horizontal" style="margin-left:20px;">
                <div>
                    <!-- 左开始 -->
                    <div>
                        <p style="position: relative;">
                            <%--                            <input id="dataType" name="dataType" value="policeData" type="hidden"/>--%>
                            <%--                            <input id="sessionId" value="${requestScope.sessionId}" name="sessionId" type="hidden"/>--%>
                            <input type="file" onchange="checkType(event)" style="top:4px;position: absolute" id="file"
                                   class="ty-file"
                                   name="file" text="选择文件上传"/>
                            <input type="text" class="k-textbox" id="fileUpload"
                                   style="margin-top: 31px;width: 90%" readonly="readonly"/>
                        <div style="text-align: center;margin-top: 50px"><span onclick="commitSubmit();"
                                                                               class="layui-btn layui-btn-sm">开始导入</span>
                            <span onclick="downLoadModel();" class="layui-btn layui-btn-sm">模板下载</span>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </form>
</div>
<script>
    function checkType(e) {
        var src = e.target || window.event.srcElement;

        var filepath = src.value;
        // debugger;
        fileUrl = filepath;
        var files = src.files;

        $("#fileUpload").val(fileUrl);
        filepath = filepath.substring(filepath.lastIndexOf('.') + 1, filepath.length);
        if (filepath != 'xlsx' && filepath != "") {
            // layerThis.msg("只能上传2007版本格式文件，后缀名为.xlsx", {
            //     button: {
            //         text: "&nbsp&nbsp确定&nbsp&nbsp", callback: function (e) {
            //             src.value = "";
            //             fileUrl = "";
            //             $("#fileUpload").val("");
            //             e.close();
            //         }
            //     }
            // });
            // layerThis.msg("请上传正确的文件啊，后缀名为.xlsx", function () {
            //     src.value = "";
            //     fileUrl = "";
            //     $("#fileUpload").val("");
            //     e.close();
            // });
            layer.alert('请上传正确的文件啊，后缀名为.xlsx', function(index){
                src.value = "";
                fileUrl = "";
                $("#fileUpload").val("");
                // e.close();
                layer.close(index);
            });
            return;
        }

    }

    function commitSubmit() {
        if (fileUrl == undefined || fileUrl == "") {
            layerThis.msg("请选择文件进行上传！", {icon: 2});
            return;
        }
        var formData = new FormData($("#bedroom")[0]);
        $.ajax({
            type: "post",
            url: basePath + "/file/excelImport",
            data: formData,
            async: false,
            cache: false,
            contentType: false,
            processData: false,
            success: function (data) {
                console.log(data);
                if (data.code == 0) {
                    var resultList = data.data;
                    layer.close(ExcelIndex);
                    if (resultList == null) {
                        layerThis.msg(data.description, {icon: 6});
                        tabThis.reload("table")
                    }else {
                        // debugger;
                        // console.log(resultList);
                        // var data = excelThis.filterExportData(resultList,['roomNo','maxPerson','failure']);
                        // console.log(data);
                        // debugger;
                        //导出excel
                        // excel.exportExcel({
                        //     sheet1: data
                        // }, '导入失败数据.xlsx', 'xlsx');
                        layer.open({
                            type: 1,
                            title: '导入失败数据',
                            offset: 'auto',
                            closeBtn: '2',
                            area: '650px',
                            content: $('#failure')
                        });
                        //生成一个表格，提供导出功能（ajax不能实现流的传输，不能实现下载）
                        var index = tabThis.render({
                            elem: '#failureTest'
                            ,title: '导入失败数据'
                            ,data: resultList
                            , toolbar: true
                            , defaultToolbar: [ 'print', 'exports']
                            , cols: [[
                                {field: 'id', hide: true}
                                , {field: 'roomNo', title: '寝室号'}
                                , {field: 'maxPerson', title: '最大床位'}
                                , {field: 'failure', title: '失败原因'}
                                /* 使用带有其他按钮的bar */
                                // , {title: '操作', toolbar: '#barDemo'}
                            ]]
                            , page: true
                            , id: "failureTable"
                        });
                        //头工具栏事件
                        tabThis.on('toolbar(failureTest)', function (obj) {
                            console.log(obj);
                            if (obj.event === 'LAYTABLE_EXPORT') {
                                // exportFile('failureTest');
                                tabThis.exportFile(index.config.id, resultList,'xlsx');
                            }
                        })

                        //表格导出
                        function exportFile(id) {
                            debugger;
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
                            excelThis.exportExcel({
                                sheet1: bodysArr
                            }, '导入失败数据.xlsx', 'xlsx');
                        }

                        // window.open(basePath+"file/excelExport?list="+JSON.stringify(resultList),"_top");
                        // tabThis.reload("table");
                        <%--$.ajax({--%>
                        <%--    url: '<%=basePath%>file/excelExport',--%>
                        <%--    type: 'post',--%>
                        <%--    data: JSON.stringify(resultList),--%>
                        <%--    dataType: 'json',--%>
                        <%--    contentType:'application/json;charset=UTF-8',--%>
                        <%--    success: function (data) {--%>
                        <%--    }--%>
                        <%--})--%>
                    }
                } else {
                    // layerThis.closeAll();
                    layerThis.msg(data.description, {icon: 2});
                }
            },
            error: function (data) {
                layerThis.msg("导入失败！", {icon: 2});
                // window.location.reload();
                return;
            }
        });
    };

    //模板下载
    function downLoadModel() {
        console.log("模板下载");
        var filePath = "room.xlsx";
        var urlStr = basePath + "/file/downloadFileRename?filePath=" + filePath + "&realName=room.xlsx";
        window.location.href = urlStr;
    }
</script>
<div id="failure" style="display: none">
    <table id="failureTest" lay-filter="failureTest"></table>
</div>
</body>
</html>