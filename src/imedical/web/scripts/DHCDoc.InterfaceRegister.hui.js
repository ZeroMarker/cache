var PageLogicObj = {
    m_InterfaceRegisterListTab: "",
    inGdNoteArrayObj: new Array(),
    onGdNoteArrayObj: new Array(),
    typeStatus: "",
    RowId: "",
    c1: String.fromCharCode(1),
    c2: String.fromCharCode(2),
    c3: String.fromCharCode(3),
    inGdExtNoteArrayObj: new Array(),
    onGdExtNoteArrayObj: new Array(),
    GdExtType:""
}

$(function() {
    Init();
    InitEvent();
})

$(window).load(function() {
    InitTip();
})

function Init() {
    // 初始化产品线
    InitProductLine();
    //初始化接口注册列表
    PageLogicObj.m_InterfaceRegisterListTab = InitInterfaceRegisterListTabDataGrid();
    //初始化入参备注弹框
    InitInputDescDialog();
    InitInputDetailExt();
    InitInputDetailGridExt();
    //初始化出参备注弹框
    //InitOnputDescDialog();
    //初始表格
    InterfaceType();
    //初始化head参数
    InitParamsStyle("HHeadParmams");
    //加载注册列表
    reLoadInterfaceRegisterListTab();
}

function InitEvent() {
    $('#Find').click(reLoadInterfaceRegisterListTab);
    $("#methodDataSaveBtn").click(methodDataSave);
    $("#debugBtn").click(sendDebugData);
    $("#setGlobal").click(setGlobal);
    $(document.body).bind("keydown", BodykeydownHandler);
}

function InterfaceType() {
    var Type = $("#interfaceType").combobox("getValue");
    if (Type != "HIS") {
        $(".notHisService").show();
        if (Type == "HTTP") {
            $(".httpService").show();
            $("#methodInvokType").combobox("setValue", "C").combobox('disable');
            $("[for='methodClassName'],[for='methodName']").removeClass("clsRequired");
        } else {
            $(".httpService").hide();
            $("#methodInvokType").combobox('enable');
            $("[for='methodClassName'],[for='methodName']").addClass("clsRequired");
        }
        $("#methodType").combobox("setValue", "ClassMethod").combobox('disable');
    } else {
        $(".notHisService,.httpService").hide();
        $("#methodInvokType,#methodType").combobox('enable');
        $("[for='methodClassName'],[for='methodName']").addClass("clsRequired");
    }
}

function httpMethodType() {
    var Type = $("#HMethodType").combobox("getValue");
    if (Type != "POST") {
        $('#HContentType').combobox('setValue', 'form-urlencoded').combobox('disable').combobox('isValid');
    } else {
        $('#HContentType').combobox('enable');
    }
}

function InitProductLine() {
    $HUI.combobox("#searchProductLine", {
        url: $URL + "?ClassName=DHCDoc.DHCDocConfig.LocalConfig&QueryName=QryProductLine&ResultSetType=array",
        valueField: 'code',
        textField: 'name',
        rowStyle: 'checkbox', //显示成勾选行形式
        multiple: true,
        editable: false
    });
    $HUI.combobox("#ProductLine", {
        url: $URL + "?ClassName=DHCDoc.DHCDocConfig.LocalConfig&QueryName=QryProductLine&ResultSetType=array",
        valueField: 'code',
        textField: 'name',
        editable: false
    });
}

function InitInterfaceRegisterListTabDataGrid() {
    var toolbar = [{
        id: "add",
        text: '新增',
        iconCls: 'icon-add',
        handler: function() { AddClickHandle(); }
    }, '-', {
        id: "tip",
        text: '说明',
        iconCls: 'icon-help',
        handler: function() {
            InitTip();
            $("#tip").popover('show');
        }
    }];
    var Columns = [
        [
            { field: 'code', title: '接口代码', width: 200 },
            { field: 'desc', title: '接口名称', width: 200 },
            { field: 'interfaceType', title: '接口类型', width: 70 },
            { field: 'MethodInvokType', title: '调用类型', width: 70 },
            { field: 'methodProductLine', title: '产品线', width: 100 },
            { field: 'methodProductLinkGroup', title: '相关产品组', width: 100 },
            { field: 'MethodStatus', title: '状态', width: 50, 
                styler: function(v, rec, index){
					if (rec.MethodStatus != "运行"){
						return 'background-color:#FFC1C1; color:red;';
					}
				}
			},
            { field: 'LogFlag', title: '记录日志', width: 70, align: "center",
                formatter: function(v, rec, index) {
                    var LogFlag = (rec.LogFlag == "Y") ? "是" : "否";
                    return LogFlag;
                }
            },
            { field: 'AutoStop', title: '自动关闭', width: 70, align: "center",
                formatter: function(v, rec, index) {
                    var LogFlag = (rec.AutoStop == "Y") ? "是" : "否";
                    return LogFlag;
                },
                styler: function(v, rec, index){
					if (rec.AutoStop == "Y"){
						return 'background-color:#FFC1C1; color:red;';
					}
				}
            },
            { field: 'StopLogID', title: '关闭日志ID', width: 150, hidden:true },
            { field: 'id', title: '列操作',width: 220,
                formatter: function(v, rec, index) {
                    var editBtn = '<a href="#this" class="editcls1" onclick="editRow(' + (rec.id) + ')"></a>';
                    var deleteBtn = '<a href="#this" class="deletecls" onclick="deleteRow(' + (rec.id) + ')"></a>';
                    var logBtn = '<a href="#this" class="logcls" onclick="updateLog(' + (rec.id + ',' + index) + ')"></a>';
                    if (rec.LogFlag == "Y") {
                        logBtn = '<a href="#this" class="slogcls" onclick="updateLog(' + (rec.id + ',' + index) + ')"></a>';
                    }
                    if (rec.MethodStatus == "运行") {
                        var statusBtn = '<a href="#this" class="stopcls" onclick="updateStatus(' + (rec.id) + ')"></a>';
                        statusBtn += '<a href="#this" class="debugcls" onclick="debugRow(' + (rec.id) + ',' + index + ')"></a>'
                    } else {
                        var statusBtn = '<a href="#this" class="startcls" onclick="updateStatus(' + (rec.id) + ')"></a>';
                    }
                    return editBtn + " " + deleteBtn + " " + logBtn + " " + statusBtn;
                }
            }
        ]
    ]
    var interfaceRegisterListTabDataGrid = $("#interfaceRegisterListTab").datagrid({
        fit: true,
        border: false,
        striped: true,
        singleSelect: true,
        fitColumns: false,
        autoRowHeight: false,
        rownumbers: true,
        pagination: true,
        rownumbers: true,
        pageSize: 20,
        pageList: [20, 100, 200],
        idField: 'id',
        columns: Columns,
        toolbar: toolbar,
        view: detailview,
        url: 'web.DHCDocInterfaceMethodPageLoad.cls?action=methodlist',
        onLoadSuccess: function(data) {
            ChangeButtonText($(".editcls1"), "修改", "icon-write-order");
            ChangeButtonText($(".deletecls"), "删除", "icon-cancel");
            ChangeButtonText($(".logcls"), "记日志", "icon-cal-pen");
            ChangeButtonText($(".slogcls"), "不记日志", "icon-red-cancel-paper");
            ChangeButtonText($(".stopcls"), "停用", "icon-lock");
            ChangeButtonText($(".startcls"), "运行", "icon-unlock");
            ChangeButtonText($(".debugcls"), "调试", "icon-ok");

            // 列表一列跟二列对齐
            $('td[field="_expander"] div').css('padding-top', '2');
            $('td[field="_expander"] div').css('padding-right', '4');
            $('td[field="_expander"] div').css('margin-top', '1');
            $('td[field="_expander"] div').css('margin-bottom', '1');
            // 行与行之间对齐
            $('#divMethodListDg  div[class="datagrid-body"] table tr td[field="desc"] div').css('height', '18');
            $('#divMethodListDg  div[class="datagrid-body"] table tr ').css('height', '27');
        },
        detailFormatter: function(rowIndex, rowData) {
            return "<div id='detailDiv" + rowIndex + "' style='color:black;height:auto;'><div/>";;
        },
        onExpandRow: function(index, row) {
            loadDetailView(row.id, index);
        },
        rowStyler: function(index, row) {
            if (row.MethodStatus == '停用') {
                //return 'background-color:#FFC1C1;color:#fff;';
            }
        }
    });
    return interfaceRegisterListTabDataGrid;
}

function loadDetailView(id, index) {
    var detailHtml = "";
    $.ajax({
        type: "get",
        url: "web.DHCDocInterfaceMethodPageLoad.cls?action=expandMethodDetail&input=" + id,
        dataType: "json",
        success: function(data) {
            var detailHtml = "<table class='detailview_tab'>";
            $.each(data, function(i, list) {
                detailHtml += "<tr><td><span>调用方法：</span>" + list.methodPublishClassName + "</td></tr>";
                detailHtml += "<tr><td><span>入参格式描述：</span>" + list.methodInputDesc + "</td></tr>";
                detailHtml += "<tr><td><span>返回值：</span>" + list.methodOutputDesc + "</td></tr>";
                detailHtml += "<tr><td><span>方法描述：</span>" + list.methodDesc + "</td></tr>";
                detailHtml += "<tr><td><span>备注：</span>" + list.methodNote + "</td></tr>";
            });
            detailHtml += "</table>";
            $('#detailDiv' + index).html(detailHtml);
            $('#interfaceRegisterListTab').datagrid('fixDetailRowHeight', index);
        }
    })
}

function editRow(id) {
    PageLogicObj.RowId = id;
    clearDetailContent();
    $.ajax({
        type: "get",
        url: "web.DHCDocInterfaceMethodPageLoad.cls?action=methodDetail&input=" + id,
        dateType: "json",
        success: function(data) {
            var obj = eval('(' + data + ')');
            $('#interfaceCode').val(obj.methodCode);
            var methodDesc = replaceTextarea2(obj.methodDesc);
            $('#interfaceName').val(methodDesc);
            $('#methodClassName').val(obj.methodClassName);
            $('#methodName').val(obj.methodName);
            var methodNote = replaceTextarea2(obj.methodNote);
            $('#methodNote').val(methodNote);
            $('#Active').combobox('select', obj.methodStatus);
            $('#interfaceSttDate').datebox('setValue', obj.methodSttDate);
            $('#ProductLine').combobox('select', obj.methodProductLine);
            $('#Local').checkbox('setValue', obj.methodLocal == "Y" ? true : false);
            $('#methodInvokType').combobox('select', obj.methodInvokType);
            $('#ProductLinkGroup').val(obj.methodProductLinkGroup);
            $('#methodType').combobox('select', obj.methodType);
            $('#interfaceType').combobox('select', obj.interfaceType);
            $('#LogFlag').checkbox('setValue', obj.interfaceLogFalg == "Y" ? true : false);
            loadInputDetail(id);
            loadOutputDetail(id);
            loadExtDeatil(id);
            $('#interfaceDetail').window('open');
            $("#interfaceCode").focus();
        }
    });
}

function deleteRow(id) {
    $.messager.defaults = { ok: "是", cancel: "否" };
    $.messager.confirm("操作提示", "您确定要执行删除操作吗？", function(data) {
        if (data) {
            $.ajax({
                type: "get",
                url: "web.DHCDocInterfaceMethodPageLoad.cls?action=delMethodData&input=" + id,
                dateType: "json",
                success: function(data) {
                    var dataInfo = data.replace(/[\r\n]/g, "^")
                    var arr = new Array();
                    arr = dataInfo.split("^^");
                    var length = arr.length
                    var obj = eval('(' + arr[length - 1] + ')');
                    if (obj.retvalue == "0") {
                        $.messager.popover({ msg: '删除成功！', type: 'success', timeout: 1000 });
                        reLoadInterfaceRegisterListTab();
                    } else {
                        $.messager.alert('提示', obj.retinfo);
                    }
                }
            });
        }
    });
}

function updateLog(ID, index) {
    var LogFlag = "";
    $("#interfaceRegisterListTab").datagrid('selectRow', index);
    var Obj = $("#interfaceRegisterListTab").datagrid('getSelected');
    if (Obj != null) {
        LogFlag = Obj.LogFlag;
    }
    var LogFlag = (LogFlag == "Y") ? "N" : "Y";
    $.messager.confirm("操作提示", "您确定要执行修改操作吗？", function(r) {
        if (r) {
            var Ret = $.m({
                ClassName: "web.DHCDocInterfaceMethod",
                MethodName: "UpdateDocInterfaceMethodInfo",
                Input: ID + "^" + LogFlag
            }, false);
            var Code = Ret.split("^")[0];
            var Desc = Ret.split("^")[1];
            if (Code == "0") {
                $.messager.popover({ msg: '修改成功！', type: 'success', timeout: 1000 });
                reLoadInterfaceRegisterListTab();
            } else {
                $.messager.alert('提示', Desc);
            }
        }
    })
}

function updateStatus(id) {
    $.messager.defaults = { ok: "是", cancel: "否" };
    $.messager.confirm("操作提示", "您确定要执行修改操作吗？", function(data) {
        if (data) {
            $.ajax({
                type: "get",
                url: "web.DHCDocInterfaceMethodPageLoad.cls?action=updateMethodStatus&input=" + id,
                dateType: "json",
                success: function(data) {
                    var dataInfo = data.replace(/[\r\n]/g, "^")
                    var arr = new Array();
                    arr = dataInfo.split("^^");
                    var length = arr.length
                    var obj = eval('(' + arr[length - 1] + ')');
                    if (obj.retvalue == "1") {
                        $.messager.popover({ msg: '修改成功！', type: 'success', timeout: 1000 });
                        reLoadInterfaceRegisterListTab();
                    } else {
                        $.messager.alert('提示', obj.retinfo);
                    }
                }
            });
        } else {

        }
    });
}

function reLoadInterfaceRegisterListTab() {
    var searchMethodInvokType = $("#searchMethodInvokType").combobox('getValue');
    var searchMethodCode = $("#searchMethodCode").val().replace(/\ /g, "");
    var searchMethodName = $("#searchMethodName").val().replace(/\ /g, "");
    var searchProductLineArr = $("#searchProductLine").combobox('getValues');
    var searchProductLine = "";
    for (var i = 0; i < searchProductLineArr.length; i++) {
        if (searchProductLine == "") searchProductLine = searchProductLineArr[i];
        else searchProductLine = searchProductLine = searchProductLine + "#" + searchProductLineArr[i];
    }
    var searchProductLinkGroup = $("#searchProductLinkGroup").val().replace(/\ /g, "");
    var searchActive = $("#searchActive").combobox('getValue');
    var searchInterfaceType = $("#searchInterfaceType").combobox('getValue');
    var selectInfo = searchMethodInvokType + "^" + searchMethodCode + "^" + searchMethodName + "^" + searchProductLine + "^" + searchProductLinkGroup + "^" + searchActive + "^" + searchInterfaceType;
    selectInfo = escape(selectInfo);
    $('#interfaceRegisterListTab').datagrid({ url: "web.DHCDocInterfaceMethodPageLoad.cls?action=methodlist&input=" + selectInfo, method: "get" });
    $('#interfaceRegisterListTab').datagrid('load');
}

function AddClickHandle() {
    PageLogicObj.RowId = "";
    //清空数据
    clearDetailContent();
    //初始化入参表格
    loadInputDetail("");
    //初始化出参表格
    loadOutputDetail("");
    $("#interfaceDetail").window('open');
    $("#interfaceCode").focus();
}
//清空接口明细
function clearDetailContent() {
    PageLogicObj.inGdNoteArrayObj = [];
    PageLogicObj.onGdNoteArrayObj = [];
    PageLogicObj.inGdExtNoteArrayObj = [];
    PageLogicObj.onGdExtNoteArrayObj = [];
    $('#interfaceCode,#interfaceName,#ProductLinkGroup,#methodClassName,#methodName,#methodNote').val("");
    $('#mTimeOutNum,#mReturnStr,#HServer,#HPort,#HPath,#HTimeout,#HSSLConfiguration,#HHeadParmams').val("");
    //$("#interfaceSttDate").datebox('setValue',ServerObj.CurDate);
    $('#ProductLine').combobox('select', "");
    $("#Active").combobox('select', "Y");
    $('#Local').checkbox('setValue', false);
}
//保存接口明细信息
function methodDataSave() {
    var interfaceType = $('#interfaceType').combobox('getValue');
    var interfaceCode = $('#interfaceCode').val().replace(/\ /g, "");
    interfaceCode = replaceTextarea1(interfaceCode);
    if (interfaceCode == "") {
        $.messager.alert('提示', "请输入接口代码!", "info", function() {
            $('#interfaceCode').focus();
        });
        return false;
    }
    var interfaceName = $('#interfaceName').val().replace(/\ /g, "");
    interfaceName = replaceTextarea1(interfaceName);
    if (interfaceName == "") {
        $.messager.alert('提示', "请输入接口名称!", "info", function() {
            $('#interfaceName').focus();
        });
        return false;
    }
    var interfaceSttDate = ServerObj.CurDate; //$('#interfaceSttDate').datebox('getValue');
    var ProductLine = $("#ProductLine").combobox('getValue');
    if (!ProductLine) {
        $.messager.alert('提示', "请输入产品线!", "info", function() {
            $('#ProductLine').next('span').find('input').focus();
        });
        return false;
    }
    var Active = $("#Active").combobox('getValue');
    var Local = $("#Local").checkbox('getValue') ? "Y" : "N";
    var methodInvokType = $("#methodInvokType").combobox('getValue');
    var ProductLinkGroup = $('#ProductLinkGroup').val().replace(/\ /g, "");
    ProductLinkGroup = replaceTextarea1(ProductLinkGroup);
    if (ProductLinkGroup == "") {
        $.messager.alert('提示', "请输入关联产品组!", "info", function() {
            $('#ProductLinkGroup').focus();
        });
        return false;
    }
    var methodClassName = $('#methodClassName').val().replace(/\ /g, "");
    methodClassName = replaceTextarea1(methodClassName);
    if (methodClassName == "" && interfaceType != "HTTP") {
        $.messager.alert('提示', "请输入类名!", "info", function() {
            $('#methodClassName').focus();
        });
        return false;
    }
    var methodName = $('#methodName').val().replace(/\ /g, "");
    methodName = replaceTextarea1(methodName);
    if (methodName == "" && interfaceType != "HTTP") {
        $.messager.alert('提示', "请输入方法名!", "info", function() {
            $('#methodName').focus();
        });
        return false;
    }
    var methodType = $("#methodType").combobox('getValue');
    var methodNote = $('#methodNote').val().replace(/\ /g, "");
    methodNote = replaceTextarea1(methodNote);
    var inputGdRows = $('#inputListTab').datagrid('getRows');
    var inputGdInfo = "";
    for (var i = 0; i < inputGdRows.length; i++) {
        $('#inputListTab').datagrid('endEdit', i);
        var tmpType = inputGdRows[i]['type'];
        if (("undefined" == typeof(tmpType)) || ("" == tmpType)) {
            tmpType = "undefined";
            continue;
        }
        var tmpFlag = inputGdRows[i]['requireFlag'];
        var tmpDesc = inputGdRows[i]['desc'];
        var keyname = inputGdRows[i]['keyname'];
        if (keyname==""){
	    	$.messager.alert('提示', "入参中的字段名不能为空，请填写！", "info");
	    	return false;
	    }
        var tmpDescLong = PageLogicObj.inGdNoteArrayObj[i];
        var tmpDescExt = PageLogicObj.inGdExtNoteArrayObj[i]||"";
        var inGdKey = "inGd" + i + "=";
        var tmpRowInfo = inGdKey + tmpType + "&" + inGdKey + tmpFlag + "&" + inGdKey + tmpDesc + "&" + inGdKey + tmpDescLong + "&" + inGdKey + tmpDescExt + "&" + inGdKey + keyname;
        if ("" == inputGdInfo) {
            inputGdInfo = tmpRowInfo;
        } else {
            var endFlag = "inGd" + (i - 1) + "=" + "inGd" + i; //最后一位标志位 记录是否有下一行数据
            inputGdInfo = inputGdInfo + "&" + endFlag + "&" + tmpRowInfo;
        }
    }
    var outputGdRows = $('#outputListTab').datagrid('getRows');
    var outputGdInfo = "";
    for (var i = 0; i < outputGdRows.length; i++) {
        $('#outputListTab').datagrid('endEdit', i);
        var tmpType = outputGdRows[i]['type'];
        if (("undefined" == typeof(tmpType)) || ("" == tmpType)) {
            continue;
        }
        var tmpDesc = outputGdRows[i]['desc'];
        var keyname = outputGdRows[i]['keyname'];
        if (keyname==""){
	    	//$.messager.alert('提示', "出参中的字段名不能为空，请填写！", "info");
	    	//return false;
	    }
        var tmpDescLong = PageLogicObj.onGdNoteArrayObj[i];
        var tmpDescExt = PageLogicObj.onGdExtNoteArrayObj[i]||"";
        var inGdKey = "outGd" + i + "=";
        var tmpRowInfo = inGdKey + tmpType + "&" + inGdKey + tmpDesc + "&" + inGdKey + tmpDescLong+ "&" + inGdKey + tmpDescExt + "&" + inGdKey + keyname;
        if ("" == inputGdInfo) {
            outputGdInfo = tmpRowInfo;
        } else {
            var endFlag = "outGd" + (i - 1) + "=" + "outGd" + i; //最后一位标志位 记录是否有下一行数据
            outputGdInfo = outputGdInfo + "&" + endFlag + "&" + tmpRowInfo;
        }
    }
    var LogFlag = $("#LogFlag").checkbox('getValue') ? "Y" : "N";
    var ExptObj = { "interfaceType": interfaceType, "LogFlag": LogFlag };
    if (interfaceType != "HIS") {
        var HttpObj = GetHttpExtObj();
        if (!HttpObj) return false;
        $.extend(ExptObj, HttpObj);
    }
    var ExptJson = JSON.stringify(ExptObj);

    var methodInfo = "input=" + PageLogicObj.RowId;
    var methodInfo = methodInfo + "&input=" + interfaceCode + "&input=" + interfaceName + "&input=" + interfaceSttDate; //2-4
    var methodInfo = methodInfo + "&input=" + ProductLine + "&input=" + Active + "&input=" + Local; //5-7
    var methodInfo = methodInfo + "&input=" + methodInvokType + "&input=" + ProductLinkGroup + "&input=" + methodClassName; //8-10
    var methodInfo = methodInfo + "&input=" + methodName + "&input=" + methodType + "&input=" + methodNote + "&input=" + ExptJson; //11-14
    methodInfo = encodeURI(methodInfo);
    inputGdInfo = encodeURI(inputGdInfo);
    outputGdInfo = encodeURI(outputGdInfo);
    $.ajax({
        type: "POST",
        contentType: "application/x-www-form-urlencoded; charset=UTF-8",
        url: "web.DHCDocInterfaceMethodPageLoad.cls?action=saveMethodData&" + methodInfo + "&" + inputGdInfo + "&" + outputGdInfo,
        dateType: "json",
        success: function(data) {
            var dataInfo = data.replace(/[\r\n]/g, "^")
            var arr = new Array();
            arr = dataInfo.split("^^");
            var length = arr.length;
            var obj = eval('(' + arr[length - 1] + ')');
            if (obj.retvalue == "1") {
                var Desc = obj.retinfo.split("^")[1];
                var RowID = obj.retinfo.split("^")[2];

                $.messager.popover({ msg: Desc, type: 'success', timeout: 1000 });
                PageLogicObj.inGdNoteArrayObj = [];
                PageLogicObj.onGdNoteArrayObj = [];
                PageLogicObj.inGdExtNoteArrayObj = [];
                PageLogicObj.onGdExtNoteArrayObj = [];
                PageLogicObj.RowId = "";
                reLoadInterfaceRegisterListTab();
                $('#interfaceDetail').window('close');
            } else {
                $.messager.alert('提示', obj.retinfo);
            }
        }
    })
}

function loadInputDetail(rowId) {
    var TitLnk = '<a href="#this" class="editDetail" onclick="ShowClassMethodInfo()"></a>';
    	TitLnk +='<a href="#this" class="editAdd" onclick="insertinputrow()"></a>';
    $('#inputListTab').datagrid({
        nowrap: false,
        singleSelect: true,
        idField: 'code',
        method: 'Get',
        fit: true,
        url: 'web.DHCDocInterfaceMethodPageLoad.cls?action=inputType&input=' + rowId,
        columns: [
            [
	    	{ field:'type',title:'数据类型',width:190,
                    formatter: function(value, rowData) {
                        return value;
                    },
                    editor: {
                        id: "lookTable",
                        type: 'combobox',
                        options: {
                            editable: false,
                            valueField: 'baseType',
                            textField: 'baseType',
                            method: 'get',
                            url: 'web.DHCDocInterfaceMethodPageLoad.cls?action=baseType'
                        }
                    }
                },
                { field:'requireFlag',title:'是否必填',width:70,align:'center',
                    editor: {
                        type: 'icheckbox',
                        options: {
                            on: 'Y',
                            off: 'N'
                        }
                    }
                },
                { field: 'keyname', title: '字段名', width: 120, editor: 'text' },
                { field: 'desc', title: '字段说明', width: 230, editor: 'text' },
                // 设置隐藏域
                { field: 'descHidden', title: '字段说明', width: 135, editor: 'text', hidden: 'true' },
                { field: 'extNoteHidden', title: '扩展说明', width: 135, editor: 'text', hidden: 'true' },
                { field:'note',title:'备注',width:40,align:'center', hidden: 'true',
                    formatter: function(value, row, index) {
                        return '<a class="editcls" onclick="showinputdetail(\'' + index + '\')">详</a>';
                    }
                },
                { field:'action',title:TitLnk,width:130,align:'center',
                    formatter: function(value, row, index) {
                        var d = '<a href="#this" class="editCls" onclick="showinputdetail(\'' + index + '\')"></a>';
	                        d +='<a href="#this" class="editDetail" onclick="ShowInputDetailExt(\''+ index + '\',' +"'inputListTab"+'\')"></a>';
	    					d +='<a href="#this" class="editRemove" onclick="deleteinputrow(this)"></a>';
                        return d;
                    }
                }
            ]
        ],
        onBeforeEdit: function(index, row) {
            row.editing = true;
            ChangeButtonText($(".editCls"), "详细", "icon-write-order");
            ChangeButtonText($(".editDetail"), "明细", "icon-eye");
            ChangeButtonText($(".editRemove"), "删除", "icon-remove");
        },
        onAfterEdit: function(index, row) {
            row.editing = false;
            var interfaceCode = $("#interfaceCode").val().replace(/\ /g, "");
            if (interfaceCode == "") {
                $.messager.alert('提示', "接口代码为空");
                return;
            }
            // bindDescTip();
        },
        onCancelEdit: function(index, row) {
            var type = row["type"];
            if (typeof(type) == "undefined") {
                $('#inputListTab').datagrid('deleteRow', index)
                return;
            } else {
                row.editing = false;
            }
        },
        onDblClickRow: function(index, row) {
	    	$('#inputListTab').datagrid('beginEdit', index);
	    },
        onLoadSuccess: function(data) {
            //bindDescTip();
            var data = $('#inputListTab').datagrid('getData');
            var total = data.total;
            for (i = 0; i < total; i++) {
                $('#inputListTab').datagrid('beginEdit', i);
                PageLogicObj.inGdNoteArrayObj.push(data.rows[i].descHidden);
                var PreStr = data.rows[i].extNoteHidden.substr(0,1);
                if (("[{").indexOf(PreStr) < 0) data.rows[i].extNoteHidden = "";
                PageLogicObj.inGdExtNoteArrayObj.push(data.rows[i].extNoteHidden);
            }
            ChangeButtonText($(".editDetail"), "明细", "icon-eye");
            ChangeButtonText($(".editAdd"), "增加", "icon-add");
        }
    });
}

function insertinputrow() {
    var interfaceType = $('#interfaceType').combobox('getValue');
    var data = $('#inputListTab').datagrid('getData');
    var index = data.total;
    if ((index > 1) && (interfaceType == "SOAP")) {
        $.messager.alert('提示', "接口类型为SOAP，入参最多有两个！");
        return false;
    }
    $('#inputListTab').datagrid('insertRow', {
        index: index,
        row: {
            requireFlag: 'N'
        }
    });
    $('#inputListTab').datagrid('beginEdit', index);
    PageLogicObj.inGdNoteArrayObj.push("");
    PageLogicObj.inGdExtNoteArrayObj.push("");
}

function deleteinputrow(target) {
    var index = getRowIndex(target);
    $('#inputListTab').datagrid('selectRow', getRowIndex(target));
    var row = $('#inputListTab').datagrid('getSelected');
    var type = row["type"];
    if (typeof(type) != "undefined") {
        $('#inputListTab').datagrid('deleteRow', index);
    } else {
        $('#inputListTab').datagrid('cancelEdit', index);
    }
    var data = $('#inputListTab').datagrid('getData');
    var total = data.total;
    for (i = index; i < total; i++) {
        PageLogicObj.inGdNoteArrayObj[index] = inGdNoteArrayObj[index + 1];
        PageLogicObj.inGdExtNoteArrayObj[index] = inGdExtNoteArrayObj[index + 1];
    }
    PageLogicObj.inGdNoteArrayObj.splice(index, 1);
    PageLogicObj.inGdExtNoteArrayObj.splice(index, 1);
}

function showinputdetail(index) {
    var tVal = PageLogicObj.inGdNoteArrayObj[index];
    PageLogicObj.typeStatus = "input";
    bindInputDescDialog(tVal);
}

function bindInputDescDialog(tVal) {
    tVal = replaceTextarea2(tVal);
    $('#inputDescDialog textarea').val(tVal);
    $('#inputDescDialog').dialog("open");
    $('#inputDescDialog textarea').focus();
}

function getRowIndex(target) {
    var tr = $(target).closest('tr.datagrid-row');
    return parseInt(tr.attr('datagrid-row-index'));
}

function InitInputDescDialog() {
    $('#inputDescDialog').dialog({
        autoOpen: false,
        title: '备注',
        iconCls: 'icon-w-edit',
        width: 550,
        height: 400,
        closed: true,
        cache: false,
        href: '',
        modal: true,
        resizable: true,
        buttons: [{
            text: '取消',
            iconCls: 'icon-w-close',
            handler: function() {
                $('#inputDescDialog').dialog('close');
            }
        }, {
            text: '确定',
            iconCls: 'icon-w-save',
            handler: function() {
                var tVal = $('#inputDescDialog textarea').val();
                tVal = replaceTextarea1(tVal);
                if (PageLogicObj.typeStatus == "input") {
                    var row = $('#inputListTab').datagrid('getSelected');
                    var index = $('#inputListTab').datagrid('getRowIndex', row);
                    PageLogicObj.inGdNoteArrayObj[index] = tVal;
                } else {
                    var row = $('#outputListTab').datagrid('getSelected');
                    var index = $('#outputListTab').datagrid('getRowIndex', row);
                    PageLogicObj.onGdNoteArrayObj[index] = tVal;
                }
                $('#inputDescDialog').dialog('close');
            }
        }]
    });
}

function loadOutputDetail(rowId) {
    var TitLnk = '<a href="#" onclick="insertoutputrow()"><img style="margin:6px 3px 0px 3px;" src="../scripts/dhcpha/jQuery/themes/icons/pencil.png" border=0/></a>';
    TitLnk += '<a href="#" onclick="insertoutputrow()"><img style="margin:6px 3px 0px 3px;" src="../scripts/dhcpha/jQuery/themes/icons/edit_add.png" border=0/></a>';
    var TitLnk = '<a href="#this" class="editDetail" onclick="ShowClassMethodInfo()"></a>';
    	TitLnk +='<a href="#this" class="editAdd" onclick="insertoutputrow()"></a>';
    $('#outputListTab').datagrid({
        nowrap: false,
        singleSelect: true,
        idField: 'code',
        method: 'Get',
        fit: true,
        url: 'web.DHCDocInterfaceMethodPageLoad.cls?action=outputType&input=' + rowId,
        columns: [
            [
	    	{ field:'type',title:'数据类型',width:190,
                    formatter: function(value, rowData) {
                        return value;
                    },
                    editor: {
                        id: "lookTable",
                        type: 'combobox',
                        options: {
                            editable: false,
                            valueField: 'baseType',
                            textField: 'baseType',
                            method: 'get',
                            url: 'web.DHCDocInterfaceMethodPageLoad.cls?action=baseType'
                        }
                    }
                },
                { field: 'keyname', title: '字段名', width: 120, editor: 'text' },
                { field: 'desc', title: '字段说明', width: 260, editor: 'text' },
                // 设置隐藏域
                { field: 'descHidden', title: '字段说明', width: 135, editor: 'text', hidden: 'true' },
                { field: 'extNoteHidden', title: '扩展说明', width: 135, editor: 'text', hidden: 'true' },
                { field:'note',title:'备注',width:40,align:'center', hidden: 'true' ,
                    formatter: function(value, row, index) {
                        return '<a class="editcls" onclick="showoutputdetail(\'' + index + '\')">详</a>';
                    }
                },
                { field:'action',title:TitLnk,width:170,align:'center',
                    formatter: function(value, row, index) {
                        var d = '<a href="#this" class="editCls" onclick="showoutputdetail(\'' + index + '\')"></a>';
	                        d +='<a href="#this" class="editDetail" onclick="ShowInputDetailExt(\''+ index + '\',' +"'outputListTab"+'\')"></a>';
	    					d +='<a href="#this" class="editRemove" onclick="deleteoutputrow(this)"></a>';
                        return d;
                    }
                }
            ]
        ],
        onBeforeEdit: function(index, row) {
            row.editing = true;
            updateOutputActions(index);
            ChangeButtonText($(".editCls"), "详细", "icon-write-order");
            ChangeButtonText($(".editDetail"), "明细", "icon-eye");
            ChangeButtonText($(".editRemove"), "删除", "icon-remove");
        },
        onAfterEdit: function(index, row) {
            row.editing = false;
            $('#hiddenOutputDesc').val(row['desc']);
            var interfaceCode = $("#interfaceCode").val().replace(/\ /g, "");
            if (interfaceCode == "") {
                $.messager.alert('提示', "接口代码为空!");
                return;
            }
            updateOutputActions(index);
        },
        onCancelEdit: function(index, row) {
            var type = row["type"];
            if (typeof(type) == "undefined") {
                $('#outputListTab').datagrid('deleteRow', index)
                return;
            } else {
                row.editing = false;
            }
        },
        onDblClickRow: function(index, row) {
	    	$('#outputListTab').datagrid('beginEdit', index);
	    },
        onLoadSuccess: function() {
            var data = $('#outputListTab').datagrid('getData');
            var total = data.total;
            for (i = 0; i < total; i++) {
                PageLogicObj.onGdNoteArrayObj.push(data.rows[i].descHidden);
                PageLogicObj.onGdExtNoteArrayObj.push(data.rows[i].extNoteHidden);
                $('#outputListTab').datagrid('beginEdit', i);
            }
			ChangeButtonText($(".editDetail"), "明细", "icon-eye");
			ChangeButtonText($(".editAdd"), "增加", "icon-add");
        }
    });
}

function insertoutputrow() {
    var interfaceType = $('#interfaceType').combobox('getValue');
    var data = $('#outputListTab').datagrid('getData');
    var index = data.total;
    if ((index > 0) && (interfaceType == "SOAP")) {
        $.messager.alert('提示', "接口类型为SOAP，出参最多有一个！");
        return false;
    }
    $('#outputListTab').datagrid('insertRow', {
        index: index,
        row: {}
    });
    $('#outputListTab').datagrid('selectRow', index).datagrid('beginEdit', index);
    PageLogicObj.onGdNoteArrayObj.push("");
}

function deleteoutputrow(target) {
    var index = getRowIndex(target);
    $('#outputListTab').datagrid('selectRow', getRowIndex(target));
    var row = $('#outputListTab').datagrid('getSelected');
    var type = row["type"];
    if (typeof(type) != "undefined") {
        $('#outputListTab').datagrid('deleteRow', index);
    } else {
        $('#outputListTab').datagrid('cancelEdit', index);
    }
    var data = $('#outputListTab').datagrid('getData');
    var total = data.total;
    for (i = index; i < total; i++) {
        PageLogicObj.onGdNoteArrayObj[index] = PageLogicObj.onGdNoteArrayObj[index + 1];
        PageLogicObj.onGdExtNoteArrayObj[index] = PageLogicObj.onGdExtNoteArrayObj[index + 1];
    }
    PageLogicObj.onGdNoteArrayObj.splice(index, 1);
    PageLogicObj.onGdExtNoteArrayObj.splice(index, 1);
}

function showoutputdetail(index) {
    $('#outputListTab').datagrid('selectRow', index);
    var row = $('#outputListTab').datagrid('getSelected');
    PageLogicObj.typeStatus = "output";
    var tVal = PageLogicObj.onGdNoteArrayObj[index];
    bindInputDescDialog(tVal);
}

function updateOutputActions(index) {
    $('#outputListTab').datagrid('updateRow', {
        index: index
    });
}

function replaceTextarea1(str) {
    var reg = new RegExp("\n", "g");
    var reg1 = new RegExp(" ", "g");
    str = str.replace(reg, "<br>");
    str = str.replace(reg1, "<p>");
    return str;
}

function replaceTextarea2(str) {
    var reg = new RegExp("<br>", "g");
    var reg1 = new RegExp("<p>", "g");
    str = str.replace(reg, "\n");
    str = str.replace(reg1, " ");
    return str;
}

function debugRow(id, index) {
    PageLogicObj.RowId = id;
    $("#interfaceRegisterListTab").datagrid('selectRow', index);
    loadDebugInputDetail("");
    $("#outputListTabD").val("");
    $.ajax({
        type: "get",
        url: "web.DHCDocInterfaceMethodPageLoad.cls?action=methodDetail&input=" + id,
        dateType: "json",
        success: function(data) {
            var obj = eval('(' + data + ')');
            var methodDesc = replaceTextarea2(obj.methodDesc);
            $('#debugCode').val(obj.methodCode);
            $('#debugName').val(methodDesc);
            $('#debugMethod').val(obj.methodPublishClassName);
            loadDebugInputDetail(id)
        }
    })
    $("#debugDetail").css('display', 'block');
    $('#debugDetail').window('open');
}

function loadDebugInputDetail(rowId) {
    $('#inputListTabD').datagrid({
        nowrap: false,
        singleSelect: true,
        idField: 'code',
        method: 'Get',
        fit: true,
        url: 'web.DHCDocInterfaceMethodPageLoad.cls?action=inputType&input=' + rowId,
        columns: [
            [
	    	{ field:'seqNo',title:'序号',width:70,
                    formatter: function(value, rowData, index) {
                        return "input" + (index + 1);
                    }
                },
                { field: 'type', title: '数据类型', width: 70 },
                { field: 'requireFlag', title: '是否必填', width: 70, align: 'center' },
                { field: 'keyname', title: '字段名', width: 120 },
                { field: 'desc', title: '字段说明', width: 230 },
                { field: 'value', title: '调试值', width: 200, editor: 'text' }
            ]
        ],
        onBeforeEdit: function(index, row) {
            row.editing = true;
        },
        onAfterEdit: function(index, row) {
            row.editing = false;
        },
        onClickRow: function(index, row) {
            $('#inputListTabD').datagrid('beginEdit', index);
        },
        onLoadSuccess: function(data) {
            var data = $('#inputListTabD').datagrid('getData');
            var total = data.total;
            for (i = 0; i < total; i++) {
                $('#inputListTabD').datagrid('beginEdit', i);
            }
        }
    });
}

function sendDebugData() {
    if (PageLogicObj.RowId == "") {
        $.messager.alert('提示', "请先选择需要调试的数据行!");
        return;
    }
    var inputGdInfo = "";
    var inputGdRows = $('#inputListTabD').datagrid('getRows');
    for (var i = 0; i < inputGdRows.length; i++) {
        $('#inputListTabD').datagrid('endEdit', i);
        var value = inputGdRows[i]['value'];
        var requireFlag = inputGdRows[i]['requireFlag'];
        if ((requireFlag == "Y") && (value == "")) {
            $.messager.alert('提示', "必填字段需输入值!");
            return;
        }
        var inGdKey = "inGd" + i + "=";
        var tmpRowInfo = inGdKey + value;
        if (inputGdInfo == "") {
            inputGdInfo = tmpRowInfo;
        } else {
            inputGdInfo = inputGdInfo + "&" + tmpRowInfo;
        }
    }
    inputGdInfo = encodeURI(inputGdInfo);
    $.ajax({
        type: "POST",
        contentType: "application/x-www-form-urlencoded; charset=UTF-8",
        url: "web.DHCDocInterfaceMethodPageLoad.cls?action=debugMethodData&RowID=" + PageLogicObj.RowId + "&" + inputGdInfo,
        dateType: "json",
        success: function(data) {
            $("#outputListTabD").val(data);
        }
    })
}

function GetHttpExtObj() {
    var InterfaceType = $('#interfaceType').combobox('getValue');
    var HTimeout = $("#HTimeout").val();
    var HTimeOutNum = $("#HTimeOutNum").val();
    var HReturnStr = $("#HReturnStr").val().replace(/\ /g, "");
    HReturnStr = HReturnStr.replace(/？/g, "?");
    var HAutoSwitch = $("#HAutoSwitch").checkbox('getValue') ? "Y" : "N";
    var HttpObj = { "HTimeout": HTimeout, "HTimeOutNum": HTimeOutNum, "HReturnStr": HReturnStr, "HAutoSwitch": HAutoSwitch };

    if (InterfaceType == "HTTP") {
        var HServer = $("#HServer").val();
        if (HServer == "") {
            $.messager.alert('提示', "请输入服务IP/域名!", "info", function() {
                $('#HServer').focus();
            });
            return false;
        }
        var HPath = $("#HPath").val();
        if (HPath == "") {
            $.messager.alert('提示', "请输入请求路径", "info", function() {
                $('#HPath').focus();
            });
            return false;
        }
        var Type = $("#HMethodType").combobox("getValue");
        if (Type == "") {
            $.messager.alert('提示', "请选择HTTP方法", "info", function() {
                $('#HMethodType').next('span').find('input').focus();
            });
            return false;
        }
        var Type = $("#HContentType").combobox("getValue");
        if (Type == "") {
            $.messager.alert('提示', "请选择数据类型", "info", function() {
                $('#HContentType').next('span').find('input').focus();
            });
            return false;
        }
        var HSSLConfiguration = $("#HSSLConfiguration").val()
        var HHttps = $("#HHttps").checkbox('getValue') ? "Y" : "N";
        if (HHttps == "Y" && HSSLConfiguration == "") {
            $.messager.alert('提示', "HTTPS请输入SSL名字", "info", function() {
                $('#HSSLConfiguration').focus();
            });
            return false;
        }
        var HHeadParmams = $("#HHeadParmams").val().replace(/\ /g, "");
        $.extend(HttpObj, {
            HServer: HServer,
            HDomainFlag: $("#HDomainFlag").checkbox('getValue') ? "Y" : "N",
            HPort: $("#HPort").val(),
            HPath: HPath,
            HMethodType: $("#HMethodType").combobox("getValue"),
            HContentType: $("#HContentType").combobox("getValue"),
            HTimeout: $("#HTimeout").val(),
            HHttps: HHttps,
            HSSLConfiguration: HSSLConfiguration,
            HSSLCheckServerIdentity: $("#HSSLCheckServerIdentity").checkbox('getValue') ? "Y" : "N",
            HHeaderJson: HHeadParmams
        });
    }
    return HttpObj;
}

function loadExtDeatil(ID) {
    var ExtJsonStr = $.m({
        ClassName: 'web.DHCDocInterfaceMethod',
        MethodName: 'GetExtDetailJSONStr',
        Input: ID,
    }, false);
    var ExtArr = ExtJsonStr.split(String.fromCharCode(28));
    var ExtJsonStr = ExtArr[0];
    var ExtJsonStr1 = ExtArr[1];
    var paramsExptStr = ExtArr[2];
    if (ExtJsonStr != "") {
        var ExtObj = JSON.parse(ExtJsonStr);
        var interfaceType = ExtObj.interfaceType;
	$("#HTimeout").val(ExtObj.HTimeout);
	$("#HTimeOutNum").val(ExtObj.HTimeOutNum);
        $('#HAutoSwitch').checkbox('setValue', (ExtObj.HAutoSwitch == "Y") ? true : false);
        $("#HReturnStr").val(ExtObj.HReturnStr);
        $("#HServer").val(ExtObj.HServer);
        $("#HPort").val(ExtObj.HPort);
        $('#HDomainFlag').checkbox('setValue', ExtObj.HDomainFlag == "Y" ? true : false);
        $("#HPath").val(ExtObj.HPath);
        $('#HMethodType').combobox('setValue', ExtObj.HMethodType);
        $('#HContentType').combobox('setValue', ExtObj.HContentType);
        $('#HHttps').checkbox('setValue', ExtObj.HHttps == "Y" ? true : false);
        $("#HSSLConfiguration").val(ExtObj.HSSLConfiguration);
        $('#HSSLCheckServerIdentity').checkbox('setValue', ExtObj.HSSLCheckServerIdentity == "Y" ? true : false);
        $("#HHeadParmams").val(ExtObj.HHeaderJson);
    }else{
    	ClearHttpData();
    }
}

function ClearHttpData() {
    $("#HTimeout,#HTimeOutNum,#HReturnStr,#HServer,#HPort,#HPath,#HSSLConfiguration,#HHeadParmams").val("");
    $('#HAutoSwitch,#HDomainFlag,#HHttps,#HSSLCheckServerIdentity').checkbox('setValue', false);
    $('#HMethodType,#HContentType').combobox('setValue', "")
}

function setGlobal() {
    $("#gTimeOut,#gTimeOutNum").val("");
    $('#gAutoSwitch').checkbox('setValue', false);
    //加载数据	
    var Ret = $.m({
        ClassName: "web.DHCDocInterfaceMethod",
        MethodName: "GetMethodDataExt"
    }, false);
    if (Ret != "") {
        var Arr = Ret.split(String.fromCharCode(3));
        $("#gTimeOut").val(Arr[0]);
        $("#gTimeOutNum").val(Arr[1]);
        $('#gAutoSwitch').checkbox('setValue', (Arr[2] == "Y") ? true : false);
    }
    $('#setGlobal-dialog').window('open');
}

function InitParamsStyle(id) {
    var target = $('#' + id)[0];
    initKeyValueBox(target, {
        panelWidth: 650,
        panelHeight: 250,
        parseValue: parseValue,
        formatValue: formatValue,
        descEditor: 'text'
    });

    function formatValue(o) {
        var arr = [];
        $.each(o, function() {
            if (this.key != "") {
                arr.push({ key: this.key, value: this.value, desc: this.desc });
            }
        })
        return JSON.stringify(arr);
    }

    function parseValue(str) {
        try {
            var arr = $.parseJSON(str);
        } catch (e) {
            var arr = [];
        }
        var all = [];
        $.each(arr, function() {
            all.push({ key: this.key, value: this.value, desc: this.desc, custom: true })
        })
        if (all.length == 0) all.push({ key: '', desc: '', value: '', custom: true });
        all.push({ key: '', desc: '', value: '', custom: true });
        return all;
    }
}

function ChangeButtonText(element, desc, icon) {
    $(element).linkbutton({ iconCls: icon, plain: true });
    $(element).popover({ content: desc, placement: 'top-right', trigger: 'hover' });
}

function InitTip() {
    var _content = "<ul class='tip_class'><li style='font-weight:bold'>医生站接口注册使用说明</li>" +
        '<li>1、接口注册可把HIS内部接口、Webservice接口、Htpp接口进行配置化调用，通过调用统一入口：##class(web.DHCDocInterfaceMethod).DHCDocHisInterface(KeyName,...)"</li>' +
        '<li><span>  即可调用到实际接口。</span></li>' +
        "<li>2、医生站接口注册表：Doc_InterfaceMethod 、日志注册表: CF_DOC_Interface.LogRegist 、日志记录表：DOC_Interface.Log</li>" +
        '<li>3、具体配置操作：' +
        "<li><span>接口代码规则：Soap类型以：W.开头、Http类型以：H.开头</span></li>" +
        "<li><span>HIS内部接口：配置必要的参数即可</span></li>" +
        '<li><span>Soap类型接口：配置必要的参数即可，提供给第三方的统一webservice: web.DHCDocInterfaceWebService.cls</span></li>' +
        "<li><span>Http类型接口：目前只提供调用类型配置，如果配置了类方法，则会当成HIS内部接口处理，否则需要配置IP、端口等数据。</span></li>" +
        "<li><span>当输入完类名和方法名后，回车会自动带出方法的入参信息。</span></li>" +
        "<li>4、如果勾上记录日志，则保存接口方法时，会同步保存医生站接口日志注册信息。</li>" +
        "<li>5、对Soap和Http调用类型的接口，如果设置了超时自动关闭，则当接口请求超时且超过设置次数(默认3次)时，会自动关闭接口。</li>";
    $("#tip").popover({
        trigger: 'hover',
        content: _content
    });
}

function BodykeydownHandler(e) {
    if (window.event) {
        var keyCode = window.event.keyCode;
        var type = window.event.type;
        var SrcObj = window.event.srcElement;
    } else {
        var keyCode = e.which;
        var type = e.type;
        var SrcObj = e.target;
    }
    //浏览器中Backspace不可用  
    var keyEvent;
    if (e.keyCode == 8) {
        var d = e.srcElement || e.target;
        if (d.tagName.toUpperCase() == 'INPUT' || d.tagName.toUpperCase() == 'TEXTAREA') {
            keyEvent = d.readOnly || d.disabled;
        } else {
            keyEvent = true;
        }
    } else {
        keyEvent = false;
    }
    if (keyEvent) {
        e.preventDefault();
    }
    //回车事件或者
    if (keyCode == 13) {
        if ((SrcObj.tagName == "A") || (SrcObj.tagName == "INPUT")) {
            if ((SrcObj.id == "methodClassName") || (SrcObj.id == "methodName")) {
                MethodNameKeydown();
                return false;
            }
            return true;
        }
    }
}

function ShowClassMethodInfo() {
    var ClassName = $("#methodClassName").val();
    var MethodName = $("#methodName").val();
    var MethodType = $("#methodType").combobox('getValue');
    if ((methodClassName == "") || (MethodName == "")) {
        $.messager.alert("提示", "类名称和方法名不能为空")
        return false;
    }
    var NoteStr = $.m({
        ClassName: "web.DHCDocInterfaceMethod",
        MethodName: "GetMethodNoteStr",
        CName: ClassName,
        MName: MethodName,
        MType: MethodType
    }, false);
    bindInputDescDialog(NoteStr);
}

function MethodNameKeydown() {
    var methodClassName = $("#methodClassName").val();
    var MethodName = $("#methodName").val();
    if ((methodClassName != "") && (MethodName != "")) {
        GetParmsReverse();
    }
}

function GetParmsReverse() {
    var ClassName = $("#methodClassName").val();
    var MethodName = $("#methodName").val();
    var MethodType = $("#methodType").combobox('getValue');
    //没有输入过入参的才自动添加数据
    var Total = $('#inputListTab').datagrid('getData').total;
    if (Total == 0) {
        var ParmsJsonStr = $.m({
            ClassName: "web.DHCDocInterfaceMethod",
            MethodName: "GetMethodParamsStr",
            CName: ClassName,
            MName: MethodName,
            MType: MethodType
        }, false);
        var ParamsArr = JSON.parse(ParmsJsonStr);
        for (var len = 0; len < ParamsArr.length; len++) {
            var OneObj = ParamsArr[len];
            $('#inputListTab').datagrid('insertRow', { index: len, row: OneObj })
            $('#inputListTab').datagrid('beginEdit', len);
            PageLogicObj.inGdNoteArrayObj.push("");
        }
    }
    //没有输入过出参的才自动添加数据
    var Total = $('#outputListTab').datagrid('getData').total;
    if (Total == 0) {
        var ParmsJsonStr = $.m({
            ClassName: "web.DHCDocInterfaceMethod",
            MethodName: "GetMethodParamsStr",
            CName: ClassName,
            MName: MethodName,
            MType: MethodType,
            OutFlag: "Out"
        }, false);
        var ParamsArr = JSON.parse(ParmsJsonStr);
        for (var len = 0; len < ParamsArr.length; len++) {
            var OneObj = ParamsArr[len];
            $('#outputListTab').datagrid('insertRow', { index: len, row: OneObj })
            $('#outputListTab').datagrid('beginEdit', len);
            PageLogicObj.onGdNoteArrayObj.push("");
        }
    }
    return
}

function InitInputDetailExt() {
    $('#InputDetailExt').dialog({
        autoOpen: false,
        title: 'cesium',
        iconCls: 'icon-w-edit',
        closed: true,
        cache: false,
        href: '',
        modal: true,
        resizable: false,
        buttons: [{
            text: '取消',
            iconCls: 'icon-w-close',
            handler: function() {
                $('#InputDetailExt').dialog('close');
            }
        }, {
            text: '确定',
            iconCls: 'icon-w-save',
            handler: function() {
                var InputDetailExt = GetInputDetailExt();
                var GdExtTypeStr = PageLogicObj.GdExtType;
                var GdExtTypeArr = GdExtTypeStr.split("^");
                var index = GdExtTypeArr[0];
                var GdExtType = GdExtTypeArr[1];
                if (GdExtType == "inputListTab") {
                    PageLogicObj.inGdExtNoteArrayObj[index] = InputDetailExt;
                } else {
                    PageLogicObj.onGdExtNoteArrayObj[index] = InputDetailExt;
                }
                $('#InputDetailExt').dialog('close');
            }
        }]
    });
}

function InitInputDetailGridExt() {
    var TitLnk = '<a href="#this" class="editAdd" onclick="InsertInputRow()"></a>';
    $('#InputDetailGridExt').datagrid({
        nowrap: false,
        singleSelect: true,
        idField: 'code',
        method: 'Get',
        fit: true,
        columns: [
            [
	    	{ field:'type',title:'数据类型',width:190,
                    formatter: function(value, rowData) {
                        return value;
                    },
                    editor: {
                        id: "lookTable",
                        type: 'combobox',
                        options: {
                            editable: false,
                            valueField: 'baseType',
                            textField: 'baseType',
                            method: 'get',
                            url: 'web.DHCDocInterfaceMethodPageLoad.cls?action=baseType'
                        }
                    }
                },
                { field:'requireFlag',title:'是否必填',width:70,align:'center',
                    editor: {
                        type: 'icheckbox',
                        options: {
                            on: 'Y',
                            off: 'N'
                        }
                    }
                },
                { field: 'keyname', title: '字段名', width: 120, editor: 'text' },
                { field: 'desc', title: '字段说明', width: 230, editor: 'text' },
                { field:'action',title:TitLnk,width:130,align:'center',
                    formatter: function(value, row, index) {
                        var d = '<a href="#this" class="editRemove" onclick="DeleteInputRow(this)"></a>';
                        return d;
                    }
                }
            ]
        ],
        onBeforeEdit: function(index, row) {
            row.editing = true;
            ChangeButtonText($(".editRemove"), "删除", "icon-remove");
        },
        onEndEdit: function(index, row) {},
        onCancelEdit: function(index, row) {
            var type = row["type"];
            if (typeof(type) == "undefined") {
                $('#InputDetailGridExt').datagrid('deleteRow', index)
                return;
            } else {
                row.editing = false;
            }
        },
        onLoadSuccess: function(data) {
            ChangeButtonText($(".editAdd"), "增加", "icon-add");
            var data = $('#InputDetailGridExt').datagrid('getData');
            var total = data.total;
            for (index = 0; index < total; index++) {
                $('#InputDetailGridExt').datagrid('beginEdit', index);
            }
        },
        onDblClickRow: function(index, row) {
            $('#InputDetailGridExt').datagrid('beginEdit', index);
        }
    });
}

function InsertInputRow() {
    var data = $('#InputDetailGridExt').datagrid('getData');
    var index = data.total;
    $('#InputDetailGridExt').datagrid('insertRow', { index: index, row: { requireFlag: 'N' } });
    $('#InputDetailGridExt').datagrid('beginEdit', index);
}

function DeleteInputRow(target) {
    var index = getRowIndex(target);
    $('#InputDetailGridExt').datagrid('deleteRow', index);
}

function ShowInputDetailExt(index, inputType) {
    PageLogicObj.GdExtType = index + "^" + inputType;
    var inputGdRows = $('#InputDetailGridExt').datagrid('getRows');
    while (inputGdRows.length > 0) {
        $('#InputDetailGridExt').datagrid('deleteRow', 0);
    }
    var InputDetailExt = PageLogicObj.onGdExtNoteArrayObj[index] || "";
    if (inputType == "inputListTab") {
        InputDetailExt = PageLogicObj.inGdExtNoteArrayObj[index] || "";
    }
    if (InputDetailExt != "") {
        var InputDetailExtObj = JSON.parse(InputDetailExt);
        $('#InputDetailGridExt').datagrid('loadData', InputDetailExtObj);
    }
    $('#InputDetailExt').dialog("open");
    return false;
}

function GetInputDetailExt() {
    var inputGdArr = new Array();
    var inputGdInfo = "";
    var inputGdRows = $('#InputDetailGridExt').datagrid('getRows');
    for (var i = 0; i < inputGdRows.length; i++) {
        $('#InputDetailGridExt').datagrid('endEdit', i);
        var tmpType = inputGdRows[i]['type'] || "";
        if ("" == tmpType) continue;
        inputGdArr.push(inputGdRows[i]);

        var tmpFlag = inputGdRows[i]['requireFlag'];
        var tmpKey = inputGdRows[i]['keyname'];
        var tmpDesc = inputGdRows[i]['desc'];
        var tmpDescLong = PageLogicObj.inGdNoteArrayObj[i];
        var inGdKey = "inGdExt" + i + "=";
        var tmpRowInfo = inGdKey + tmpType + "&" + inGdKey + tmpFlag + "&" + inGdKey + tmpKey + "&" + inGdKey + tmpDesc;
        if ("" == inputGdInfo) {
            inputGdInfo = tmpRowInfo;
        } else {
            var endFlag = "inGdExt" + (i - 1) + "=" + "inGdExt" + i;
            inputGdInfo = inputGdInfo + "&" + endFlag + "&" + tmpRowInfo;
        }
    }
    inputGdInfo = JSON.stringify(inputGdArr);
    return inputGdInfo
}
