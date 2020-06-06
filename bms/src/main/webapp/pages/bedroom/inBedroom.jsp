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
    var fileUrl;
    var tabThis;
    var ExcelIndex;
    layui.config({
        base: '<%=basePath%>/js/layui/extends/',
    }).extend({
        treeSelect: 'treeSelect',
    });
    layui.use(['jquery', 'treeSelect', 'form', 'layer', 'table', 'upload'], function () {
        var table = layui.table,
            $ = layui.jquery,
            treeSelect = layui.treeSelect,
            form = layui.form,
            layer = layui.layer,
            upload = layui.upload;
            tabThis = table;

        //验证手机号
        form.verify({
            checkPhone: function (value, item) {
                if (!(/^1[3456789]\d{9}$/.test(value))) {
                    return "请输入正确的手机号";
                }
            }

        });

        // if()
        // treeSelect.checkNode('tree', data.organId);//设置树形下拉选默认选中的节点
        treeSelect.render({
            // 选择器
            elem: '#tree',
            // 数据
            data: '<%=basePath%>organ/selectOrgTreeData',
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
                // if($("#orgId").val() != ''){
                //     treeSelect.checkNode('tree', $("#orgId").val());
                // }
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
        form.on('submit(inBedroom-form-submit)', function (data) {
            console.log("入住");
            var inputData = data.field;
            console.log(inputData);
            $.ajax({
                url: '<%=basePath%>bedroom/inBedroom',
                type: 'post',
                data: inputData,
                dataType: 'json',
                success: function (data1) {
                    // alert
                    if (data1.code == 0) {
                        var log = {};
                        log.type = 1;
                        log.description = "办理了入住,姓名:"+inputData.name+",学号:"+data.account;
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
        if ($("#roleId").val() != '') {
            $(":checkbox").prop("checked", false);
            $(":checkbox").each(function () {
                if ($(this).val() != '') {
                    if ((($("#roleId").val()).indexOf("." + $(this).val() + ".")) > -1) {
                        $(this).prop("checked", "checked");
                    }
                }
            });
            form.render('checkbox');//重新加载勾选框
        }


        //附件上传
        var attach = null;//上传的文件信息
        var index;
        var uploadInst = upload.render({
            elem: '#uploadSignBtn', //绑定元素
            size: 1024000
            , url: '<%=basePath%>user/jsonUploadSignImgFile' //上传接口
            , before: function (obj) {
                index = layer.load(2);
                //预读本地文件示例，不支持ie8
                obj.preview(function (index, file, result) {
                    $('#signImg').attr('src', result); //图片链接（base64）
                });
            }
            , done: function (res) {
                layer.close(index);
                if (res.code == 0) {
                    layer.msg("签名图上传成功");
                    attach = res.data;
                    $('#uploadInfo').html(res.data.filename);
                } else {
                    layer.msg("签名图上传失败");
                    $('#uploadInfo').html("上传失败，请重试");
                }
            }
            , error: function () {
                layer.close(index);
                //请求异常回调
                layer.msg("附件上传失败");
                $('#uploadInfo').html("上传失败，请重试");
            }
        });
        //失焦
        $("#idCard").blur(function () {
            if ($("#idCard").val() == null || $("#idCard").val() == '') return;
            console.log("失焦");
            var age = IdCard($("#idCard").val(), 3);
            $("#age").val(age);
            var sex = IdCard($("#idCard").val(), 2);
            console.log(sex);
            if (sex == 1){
                $("#sex option[value='1']").prop("selected",true);
                form.render('select');
            }else {
                $("#sex option[value='2']").prop("selected",true);
                form.render('select');
            }
        });

        //验证身份证
        function validateIdCard(idCard) {
            //15位和18位身份证号码的正则表达式
            var regIdCard = /^(^[1-9]\d{7}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}$)|(^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])((\d{4})|\d{3}[Xx])$)$/;

            //如果通过该验证，说明身份证格式正确，但准确性还需计算
            if (regIdCard.test(idCard)) {
                if (idCard.length == 18) {
                    var idCardWi = new Array(7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2); //将前17位加权因子保存在数组里
                    var idCardY = new Array(1, 0, 10, 9, 8, 7, 6, 5, 4, 3, 2); //这是除以11后，可能产生的11位余数、验证码，也保存成数组
                    var idCardWiSum = 0; //用来保存前17位各自乖以加权因子后的总和
                    for (var i = 0; i < 17; i++) {
                        idCardWiSum += idCard.substring(i, i + 1) * idCardWi[i];
                    }

                    var idCardMod = idCardWiSum % 11;//计算出校验码所在数组的位置
                    var idCardLast = idCard.substring(17);//得到最后一位身份证号码

                    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
                    if (idCardMod == 2) {
                        if (idCardLast == "X" || idCardLast == "x") {
                            return true;
                        } else {
                            return false;
                        }
                    } else {
                        //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
                        if (idCardLast == idCardY[idCardMod]) {
                            return true;
                        } else {
                            return false;
                        }
                    }
                }
            } else {
                return false;
            }
        };

        //获取出生日期，性别，年龄
        function IdCard(UUserCard, num) {
            if (num == 1) {
                //获取出生日期
                var birth = UUserCard.substring(6, 10) + "-" + UUserCard.substring(10, 12) + "-" + UUserCard.substring(12, 14);
                return birth;
            }
            if (num == 2) {
                //获取性别
                if (parseInt(UUserCard.substr(16, 1)) % 2 == 1) {
                    //男
                    return 1;
                } else {
                    //女
                    return 2;
                }
            }
            if (num == 3) {
                //获取年龄
                var myDate = new Date();
                var month = myDate.getMonth() + 1;
                var day = myDate.getDate();
                var age = myDate.getFullYear() - UUserCard.substring(6, 10) - 1;
                if (UUserCard.substring(10, 12) < month || UUserCard.substring(10, 12) == month && UUserCard.substring(12, 14) <= day) {
                    age++;
                }
                return age;
            }
        }
    });
</script>
<div class="layui-card layadmin-header" style="height: 50px; line-height: 50px; padding-left: 15px;">
    <div class="layui-breadcrumb" lay-filter="breadcrumb" style="visibility: visible;">
        <a lay-href="">住宿管理</a><span lay-separator="">/</span> <a><cite>入住办理</cite>&nbsp;&nbsp;<button type="button" class="layui-btn layui-btn-xs" onclick="excelImport()">导入</button></a>
    </div>
</div>
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>入住办理</legend>
</fieldset>
<div class="layui-col-md12">
    <div id="inBedroomDiv" style="padding: 10px; background-color: #F2F2F2;">
        <div class="layui-card">
            <div class="layui-card-header">学生信息</div>
            <div class="layui-card-body">
                <div id="form-modal">
                    <div class="layui-form" lay-filter="inBedroom-form"
                         style="padding: 20px 0 0 0;">
                        <div class="layui-form-item">
                            <div class="layui-inline">
                                <label class="layui-form-label">姓名</label>
                                <div class="layui-input-inline">
                                    <input type="text" name="name" value="" lay-verify="required"
                                           placeholder="请输入姓名" autocomplete="off" class="layui-input">
                                </div>
                            </div>
                            <div class="layui-inline">
                                <label class="layui-form-label">身份证号</label>
                                <div class="layui-input-inline">
                                    <input type="text" name="idCard" id="idCard" value="" lay-verify="required|identity"
                                           placeholder="请输入身份证号" autocomplete="off" class="layui-input">
                                </div>
                            </div>
                            <div class="layui-inline">
                                <label class="layui-form-label">学号</label>
                                <div class="layui-input-inline">
                                    <input type="text" name="account" id="account" value="" lay-verify="required|number"
                                           placeholder="请输入学号" autocomplete="off" class="layui-input">
                                </div>
                            </div>
                        </div>
                        <div class="layui-form-item" style="margin-top: 30px">
                            <div class="layui-inline">
                                <label class="layui-form-label">性别</label>
                                <div class="layui-input-inline">
                                    <select name="sex" id="sex" lay-verify="required" value="">
                                        <option value="">请选择</option>
                                        <option value="1">男</option>
                                        <option value="2">女</option>
                                    </select>
                                </div>
                            </div>
<%--                            <div class="layui-inline">--%>
<%--                                <label class="layui-form-label">年龄</label>--%>
<%--                                <div class="layui-input-inline">--%>
<%--                                    <input type="text" name="age" id="age" value="" lay-verify="required|number"--%>
<%--                                           placeholder="请输入年龄" autocomplete="off" class="layui-input">--%>
<%--                                </div>--%>
<%--                            </div>--%>
                            <div class="layui-inline">
                                <label class="layui-form-label">所属集体</label>
                                <div class="layui-input-inline">
                                    <input type="text" id="tree" name="organId" lay-verify="required" lay-filter="tree"
                                           class="layui-input">
                                </div>
                            </div>
                            <div class="layui-inline">
                                <label class="layui-form-label">寝室号</label>
                                <div class="layui-input-inline">
                                    <input type="text" name="roomNo" value="" lay-verify="required"
                                           placeholder="请输入寝室号" autocomplete="off" class="layui-input">
                                </div>
                            </div>
                        </div>
                        <div class="layui-form-item" style="margin-top: 30px">
                            <div class="layui-inline">
                                <label class="layui-form-label">联系电话</label>
                                <div class="layui-input-inline">
                                    <input type="tel" name="phone" value="" lay-verify="required|number|phone|checkPhone"
                                           placeholder="请输入电话号码" autocomplete="off" class="layui-input">
                                </div>
                            </div>
                            <div class="layui-inline">
                                <label class="layui-form-label">户籍</label>
                                <div class="layui-input-inline">
                                    <input type="text" name="home" value="" lay-verify="required"
                                           placeholder="请输入户籍所在地" autocomplete="off" class="layui-input">
                                </div>
                            </div>
                            <div class="layui-inline">
                                <label class="layui-form-label">居住地</label>
                                <div class="layui-input-inline">
                                    <input type="text" name="livePlace" value="" lay-verify="required"
                                           placeholder="请输入现居住地" autocomplete="off" class="layui-input">
                                </div>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label"></label>
                            <div class="layui-input-inline" style="margin-left: 25%">
                                <input type="button" lay-submit=""
                                       lay-filter="inBedroom-form-submit" value="办理入住" class="layui-btn">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<%--excel--%>
<div id="excel" style="display: none">
    <form id="userExcel" method="post" enctype="multipart/form-data"
          action="" class="layui-form">
        <div id="" style="margin-left:20px;">
            <div>
                <!-- 左开始 -->
                <div>
                    <p style="position: relative;">
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
    </form>
</div>
<script>
    
    function excelImport() {
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
    }
    
    function checkType(e) {
        var src = e.target || window.event.srcElement;

        var filepath = src.value;
        // debugger;
        fileUrl = filepath;
        var files = src.files;

        $("#fileUpload").val(fileUrl);
        filepath = filepath.substring(filepath.lastIndexOf('.') + 1, filepath.length);
        if (filepath != 'xlsx' && filepath != "") {
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
        var formData = new FormData($("#userExcel")[0]);
        $.ajax({
            type: "post",
            url: basePath + "/file/excelIn",
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
                        layer.open({
                            type: 1,
                            title: '导入失败数据',
                            offset: 'auto',
                            closeBtn: '2',
                            area: ['1400px','650px'],
                            content: $('#failure')
                        });
                        //生成一个表格，提供导出功能（ajax不能实现流的传输，不能实现下载）
                        var index = tabThis.render({
                            elem: '#failureTest'
                            ,title: '导入失败数据'
                            ,data: resultList
                            // , toolbar: true
                            // , defaultToolbar: [ 'print', 'exports']
                            , cols: [[
                                {field: 'id', hide: true}
                                , {field: 'account', title: '学号'}
                                , {field: 'name', title: '姓名'}
                                , {field: 'sex', title: '性别',templet:function (res) {
                                        if (res.sex == 1) return '男';
                                        else if (res.sex == 2) return '女';
                                        else return '';
                                    }}
                                , {field: 'idCard', title: '身份证'}
                                , {field: 'organName', title: '所属集体'}
                                , {field: 'roomNo', title: '寝室'}
                                , {field: 'inDate', title: '入住时间'}
                                , {field: 'phone', title: '联系电话'}
                                , {field: 'home', title: '籍贯'}
                                , {field: 'livePlace', title: '居住地'}
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
        var filePath = "InBedroom.xlsx";
        var urlStr = basePath + "/file/downloadFileRename?filePath=" + filePath + "&realName=InBedroom.xlsx";
        window.location.href = urlStr;
    }
</script>
<div id="failure" style="display: none">
    <table id="failureTest" lay-filter="failureTest"></table>
</div>
</body>
</html>