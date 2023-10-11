var PageLogicObj = {
    RowId: "",
    m_InterfaceLogDataGrid: "",
}
$(function() {
    Init();
    InitEvent();
})

$(window).load(function() {
	InitTip();
})

function Init() {
    InitProductLine();
    InitInterfaceLogDataGrid();
    ReLoadLogRegListTab();
    //初始话head参数
    InitParamsStyle("LogSuccess");
    //$("#LogSuccess").disabled()
    //$('#LogSuccess').textbox('disable');
}

function InitEvent() {
    $("#Find").click(ReLoadLogRegListTab);
    $("#SaveLogBtn").click(SaveLogData);
}

function AddClickHandle() {
    PageLogicObj.RowId = "";
    ClearDetailContent();
    $("#LogRegDetail").window('open');
    $("#interfaceCode").focus();
}

function ClearDetailContent() {
    $('#LogCode,#LogDesc,#productLinkGroup,#LogNote,#LogDays,#LogSuccess').val("");
    $('#productLine').combobox('select', "");
    $("#LogStatus").combobox('select', "Y");
    $('#LogFlag').checkbox('setValue', false);
}

function SaveLogData() {
    var LogType = $('#LogType').combobox('getValue');
    var LogCode = $('#LogCode').val().replace(/\ /g, "");
    if (LogCode == "") {
        $.messager.alert('提示', "请输入日志代码!", "info", function() {
            $('#LogCode').focus();
        });
        return false;
    }
    var LogDesc = $('#LogDesc').val().replace(/\ /g, "");
    if (LogDesc == "") {
        $.messager.alert('提示', "请输入日志名称!", "info", function() {
            $('#LogDesc').focus();
        });
        return false;
    }
    var productLine = $("#productLine").combobox('getValue');
    if (!productLine) {
        $.messager.alert('提示', "请输入产品线!", "info", function() {
            $('#productLine').next('span').find('input').focus();
        });
        return false;
    }
    var LogStatus = $("#LogStatus").combobox('getValue');
    var LogFlag = $("#LogFlag").checkbox('getValue') ? "Y" : "N";
    var productLinkGroup = $('#productLinkGroup').val().replace(/\ /g, "");
    var LogNote = $('#LogNote').val();
    LogNote = ReplaceTextarea1(LogNote);
    var LogDays = $('#LogDays').val();
    var LogSuccessJson = $('#LogSuccess').val();
    
    var LogObj = {
        LogID: PageLogicObj.RowId,
        LogType: LogType,
        LogCode: LogCode,
        LogDesc: LogDesc,
        productLine: productLine,
        productLinkGroup: productLinkGroup,
        LogStatus: LogStatus,
        LogFlag: LogFlag,
        LogDays: LogDays,
        LogSuccessJson: LogSuccessJson,
        LogNote: LogNote
    }
    var LogInfo = JSON.stringify(LogObj);

    var Ret = $.m({
        ClassName: "web.DHCDocInterfaceLog",
        MethodName: "SaveLogRegistInfo",
        LogInfo: LogInfo,
        JsonInfo: ""
    }, false);
    var Code = Ret.split("^")[0];
    var Desc = Ret.split("^")[1];
    if (Code != 0) {
        $.messager.alert('提示', "保存失败：" + Desc, "info");
    } else {
        $.messager.popover({ msg: '保存成功！', type: 'success', timeout: 1000 });
        PageLogicObj.RowId = "";
        ReLoadLogRegListTab();
        $('#LogRegDetail').window('close');
    }
}

function ReLoadLogRegListTab() {
    var LogType = $('#SLogType').combobox('getValue');
    var LogCode = $('#SLogCode').val().replace(/\ /g, "");
    var LogDesc = $('#SLogDesc').val().replace(/\ /g, "");
    var LogStatus = $("#SLogStatus").combobox('getValue');
    var LogFlag = $("#SLogFlag").combobox('getValue');
    var ProductLine = "";
    var ProductLineArr = $("#SProductLine").combobox('getValues');
    for (var i = 0; i < ProductLineArr.length; i++) {
        if (ProductLine == "") ProductLine = ProductLineArr[i];
        else ProductLine = ProductLine = ProductLine + "#" + ProductLineArr[i];
    }

    var Input = LogType + "^" + LogCode + "^" + LogDesc + "^" + LogStatus + "^" + LogFlag + "^" + ProductLine;

    $.cm({
        ClassName: "web.DHCDocInterfaceLog",
        QueryName: "FindLogRegist",
        Input: Input,
        rows:99999
    }, function(GridData) {
        PageLogicObj.m_InterfaceLogDataGrid.datagrid({ loadFilter: DocToolsHUI.lib.pagerFilter }).datagrid('loadData', GridData);
        $("#LogRegListTab").datagrid('clearSelections');
    });
}

function InitInterfaceLogDataGrid() {
    var toolbar = [
	    {
	        text: '新增',
	        iconCls: 'icon-add',
	        handler: function() { AddClickHandle(); }
	    },'-',{
			id:"tip",
			text: '说明',
			iconCls: 'icon-help',
			handler: function(){
				InitTip();
				$("#tip").popover('show');
			}
    	}
    ];
    var Columns = [
        [
            { field: 'ID', title: 'ID', width: 20, hidden: 'true' },
            { field: 'ColOper', title: '列操作', width: 150,
                formatter: function(v, rec, index) {
                    var editBtn = '<a href="#this" class="editcls1" onclick="EditRow(' + (rec.ID + ',' + index) + ')"></a>';
                    var deleteBtn = '<a href="#this" class="deletecls" onclick="DeleteRow(' + (rec.ID + ',' + index) + ')"></a>';
                    var logBtn = '<a href="#this" class="logcls" onclick="UpdateLog(' + (rec.ID + ',' + index) + ')"></a>';
                    if (rec.LogFlag == "Y") {
                        logBtn = '<a href="#this" class="slogcls" onclick="UpdateLog(' + (rec.ID + ',' + index) + ')"></a>';
                    }
                    return editBtn + " " + deleteBtn + " " + logBtn;
                }
            },
            { field: 'LogCode', title: '日志代码', width: 200 },
            { field: 'LogDesc', title: '日志名称', width: 200 },
            { field: 'LogType', title: '日志类型', width: 100, align: "center" },
            { field: 'LogStatus', title: '状态', width: 70, align: "center",
                formatter: function(v, rec, index) {
                    var LogStatus = (rec.LogStatus == "Y") ? "运行" : "停用";
                    return LogStatus;
                }
            },
            { field: 'LogFlag', title: '记录日志', width: 70, align: "center",
                formatter: function(v, rec, index) {
                    var LogFlag = (rec.LogFlag == "Y") ? "是" : "否";
                    return LogFlag;
                }
            },
            { field: 'LogNote', title: '备注', width: 200, align: "center",
            	formatter: function(v, rec, index) {
	            	var LogNote = ReplaceTextarea2(v);
	            	return LogNote; 
	            }
            },
            { field: 'InsertDate', title: '插入日期', width: 120, align: "center" },
            { field: 'InsertTime', title: '插入时间', width: 100, align: "center" },
        ]
    ]
    var interfaceLogDataGrid = $("#LogRegListTab").datagrid({
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
        onLoadSuccess: function(data) {
	    ChangeButtonText($('.editcls1'),"修改","icon-write-order");
            ChangeButtonText($('.deletecls'),"删除","icon-cancel");
            ChangeButtonText($('.logcls'),"记日志","icon-cal-pen");
            ChangeButtonText($('.slogcls'),"不记日志","icon-red-cancel-paper");
        },
        detailFormatter: function(rowIndex, rowData) {
            return "<div id='detailDiv" + rowIndex + "' style='color:black;height:auto;'><div/>";;
        },
        rowStyler: function(index, row) {
            if (row.LogStatus != 'Y') {
                return 'background-color:#FFC1C1;color:#fff;';
            }
        }
    });
    PageLogicObj.m_InterfaceLogDataGrid = interfaceLogDataGrid;
    return interfaceLogDataGrid;
}

function EditRow(ID, index) {
    PageLogicObj.RowId = ID;
    ClearDetailContent();
    $("#LogRegListTab").datagrid('selectRow', index);
    var JsonStr = $.m({
        ClassName: "web.DHCDocInterfaceLog",
        MethodName: "GetLogRegistInfo",
        Input: ID
    }, false);
    var Obj = JSON.parse(JsonStr);
    $("#LogCode").val(Obj.LogCode);
    $("#LogDesc").val(Obj.LogDesc);
    $("#productLinkGroup").val(Obj.LogProductLinkGroup);
    $("#LogNote").val(Obj.LogNote);
    $("#LogType").combobox('select', Obj.LogType);
    $('#productLine').combobox('select', Obj.ProductLine);
    $('#LogStatus').combobox('select', Obj.LogStatus);
    $('#LogFlag').checkbox('setValue', (Obj.LogFlag == "Y") ? true : false);
    var LogNote = Obj.LogNote;
    	LogNote = ReplaceTextarea2(LogNote);
    $("#LogNote").val(LogNote);
    $('#LogDays').val(Obj.LogDays);
    $('#LogSuccess').val(Obj.LogSuccessJson);

    $("#LogRegDetail").window('open');
    $("#LogCode").focus();
}

function DeleteRow(ID, index) {
    $("#LogRegListTab").datagrid('selectRow', index);
    $.messager.confirm("操作提示", "您确定要执行删除操作吗？", function(r) {
        if (r) {
            var Ret = $.m({
                ClassName: "web.DHCDocInterfaceLog",
                MethodName: "DeleteLogRegistInfo",
                Input: ID
            }, false);
            var Code = Ret.split("^")[0];
            var Desc = Ret.split("^")[1];
            if (Code == "0") {
                $.messager.popover({ msg: '删除成功！', type: 'success', timeout: 1000 });
                ReLoadLogRegListTab();
            } else {
                $.messager.alert('提示', Desc);
            }
        }
    })
}

function UpdateLog(ID, index) {
    $("#LogRegListTab").datagrid('selectRow', index);
    var LogFlag = "";
    var Obj = $("#LogRegListTab").datagrid('getSelected');
    if (Obj != null) {
        LogFlag = Obj.LogFlag;
    }
    var LogFlag = (LogFlag == "Y") ? "N" : "Y";
    $.messager.confirm("操作提示", "您确定要执行修改操作吗？", function(r) {
        if (r) {
            var Ret = $.m({
                ClassName: "web.DHCDocInterfaceLog",
                MethodName: "UpdateLogRegistInfo",
                Input: ID + "^" + LogFlag
            }, false);
            var Code = Ret.split("^")[0];
            var Desc = Ret.split("^")[1];
            if (Code == "0") {
                $.messager.popover({ msg: '修改成功！', type: 'success', timeout: 1000 });
                ReLoadLogRegListTab();
            } else {
                $.messager.alert('提示', Desc);
            }
        }
    })
}

function ReplaceTextarea1(str) {
    var reg = new RegExp("\n", "g");
    var reg1 = new RegExp(" ", "g");
    str = str.replace(reg, "<br>");
    str = str.replace(reg1, "<p>");
    return str;
}

function ReplaceTextarea2(str) {
    var reg = new RegExp("<br>", "g");
    var reg1 = new RegExp("<p>", "g");
    str = str.replace(reg, "\n");
    str = str.replace(reg1, " ");
    return str;
}

function InitProductLine() {
    $HUI.combobox("#SProductLine", {
        url: $URL + "?ClassName=DHCDoc.DHCDocConfig.LocalConfig&QueryName=QryProductLine&ResultSetType=array",
        valueField: 'code',
        textField: 'name',
        rowStyle: 'checkbox',
        multiple: true,
        editable: false
    });
    $HUI.combobox("#productLine", {
        url: $URL + "?ClassName=DHCDoc.DHCDocConfig.LocalConfig&QueryName=QryProductLine&ResultSetType=array",
        valueField: 'code',
        textField: 'name',
        editable: false
    });
}

function InitParamsStyle(id) {
	LoadCombo2Css();
	var html = "<div id='DiagWin' style='width:150px'>";
		html += "	<table class='search-table' style='margin:0 auto;border:none;'>";
		html += "		<tr>";
		html += "			<td class='r-label'>固定标识</td>";
		html += "			<td><input class='hisui-checkbox' type='checkbox' id='FixedFlag'/></td>";
		html += "			<td class='r-label'>^分割</td>";
		html += "			<td><input class='hisui-checkbox' type='checkbox' id='Delimiter'/></td>";
		html += "		</tr>";
		html += "	</table>";
		html += "</div>";
	
	var target = $('#' + id)[0];    		       
    initKeyValueBox(target, {
        panelWidth: 600,
        panelHeight: 250,
        parseValue: parseValue,
        formatValue: formatValue,
        descEditor: 'text',
        singleRow:"Y",
        innerhtml:html,
        keyTitle:"分隔符",
        valueTitle:"分隔位",
        descTitle:"校验值",
        callback:LoadFixedFlag
    });    
   
    function formatValue(o) {
	    var FixedFlag=$HUI.checkbox("#FixedFlag").getValue();
        var arr = [];
        $.each(o, function() {
	        if (!FixedFlag){
		    	if ((this.key != "")&&(this.value==""||this.desc=="")) {
			    	dhcsys_alert("有分割符时，分割位和判断值不能为空，请输入！");
			    	return false;
			    }
		    }
            arr.push({ key: this.key, value: this.value, desc: this.desc, FixedFlag:FixedFlag});
        })
        if (arr.length==0) return false;
        return JSON.stringify(arr);
    }

    function parseValue(str) {
        try {
            var arr = $.parseJSON(str);
        } catch (e) {
            var arr = [];
        }	    
        var FixedFlag=false;
        var all = [];
        if (arr.length==0){
	    	all.push({ key: '', desc: '', value: '', custom: true});
        }else{
	        $.each(arr, function() {
	            all.push({ key: this.key, value: this.value, desc: this.desc, custom: true, FixedFlag:this.FixedFlag });
	            FixedFlag=this.FixedFlag;
	        })
        }
        setTimeout(function(){
	    	$HUI.checkbox("#FixedFlag").setValue(FixedFlag);
	    	//因为会被change事件重置
	    	$('#combo2-panel-content-dg').datagrid("loadData", all);
	    }, 300);
        return all;
    }
}

function LoadFixedFlag(){
	$HUI.checkbox("#FixedFlag",{
		onCheckChange:function(e,value){
			var optionk = $('#combo2-panel-content-dg').datagrid("getColumnOption", "key");
			var optionv = $('#combo2-panel-content-dg').datagrid("getColumnOption", "value");
			var optiond = $('#combo2-panel-content-dg').datagrid("getColumnOption", "desc");
			optionk.title=value?"判断代码":"分隔符";
			optionv.title=value?"判断值":"分隔位";
			optiond.title=value?"说明":"判断值";
			$('#combo2-panel-content-dg').datagrid().datagrid("loadData", [{ key: '', desc: '', value: '', custom: true}]);
		}
	});
	
	$HUI.checkbox("#Delimiter",{
		onCheckChange:function(e,value){
			var FixedFlag=$HUI.checkbox("#FixedFlag").getValue();
			if ((!FixedFlag)&&(value)){
				$('#combo2-panel-content-dg').datagrid("beginEdit", 0);
				var ed = $('#combo2-panel-content-dg').datagrid('getEditor', {index:0,field:'key'});
				$(ed.target).val('"^"'); 
				$('#combo2-panel-content-dg').data('editindex','0');
			}
		}
	})
}

function ChangeButtonText(element,desc,icon){
	$(element).linkbutton({iconCls: icon, plain: true});
	$(element).popover({content: desc, placement: 'top-right', trigger: 'hover'});
}

function InitTip(){
	var _content = "<ul class='tip_class'><li style='font-weight:bold'>医生站接口日志注册使用说明</li>" + 
		"<li>1、接口日志注册适用于需要记录接口调用入参及返回值的场景。对于HIS内部日志类型的接口，采用异步方式记录，防止存在数据回滚，其他日志类型采用同步方式记录日志。</li>" +
		"<li>2、医生站接口注册表：Doc_InterfaceMethod 、日志注册表: CF_DOC_Interface.LogRegist 、日志记录表：DOC_Interface.Log</li>" +
		"<li>3、具体配置操作(参数说明)：" +
		"<li><span>日志代码规则：Soap类型以：W.开头、Http类型以：H.开头，JS中以：J.开头</span></li>" + 
		"<li><span>保存时间(天)：日志保存的有效时间(默认3天)</span></li>" + 
		'<li><span>成功标识：校验接口返回值是否成功，说明：1.固定返回串：配置校验值(非数字类需要加"")。2.分割符判断：配置分割符、分割位、校验值。</span></li>' +
		'<li><span></span><span>3.固定字段值：勾选固定标识，配置判断代码、判断值。</span></li>' + 
		"<li>4、调用方式：</li>" +
		"<li><span>1.后台：调用类如果继承：DHCDoc.Util.RegisteredObject.cls，则采用：d $$$DocLogObj.SaveInterfaceLog(日志Code, Json串, 返回值, 入参...)</span></li>" + 
		'<li><span>示例：s rtn=$$$DocLogObj.SaveInterfaceLog("LogTest","","返回值测试","入参1","入参2","入参3")</span></li>' + 
		"<li><span>2.前台：调用js如果继承：scripts/dhcdoc/tools/tools.hui.js，则采用：DocLogObj.SaveInterfaceLog(日志Code, Json串, 返回值, 入参...)</span></li>" + 
		'<li><span>示例：var rtn=DocLogObj.SaveInterfaceLog("LogTest","","返回值测试","入参1","入参2","入参3")</span></li>' + 
		"<li><span>3.直接调用：对于没有继承类或js的地方可直接调用方法：##class(web.DHCDocInterfaceLog).SaveInterfaceLog(日志Code, Json串, 返回值, 入参...)</span></li>" 

	$("#tip").popover({
		trigger:'hover',
		content:_content
	});
}
