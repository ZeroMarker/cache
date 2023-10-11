// dhcpe/ct/dhcpe.ct.ireportsetting.js
// dhcpe.ct.ireportsetting.csp

var TheCode = $("#TheCode").val();
var TheLocId = $("#LocID").val();
	
var WIDTH = $("#myPanel").width();
$("#myEastPanel").css("width", (WIDTH-250)*0.49);

$(function() {
	$("#ConfigAdd,#ParamAdd,#ExtendAdd,#ConfigUpd,#ParamUpd,#ExtendUpd").click(function() {
		UpdData(this);
	});
	
	InitDatagrid("Config", "REPORTDATA");
	InitCombobox();
});

function UpdData(btn) {
	var Base = btn.id.substring(0, btn.id.length-3);
	var Type = btn.id.substring(btn.id.length-3, btn.id.length);
	BClear_click(Base);
	$("#EditWin").show();
	
	if (Type == "Upd" ) {
		if (!GetData(Base)) {
			return false;
		}
	}
	
	var myWin = $HUI.dialog("#EditWin", {
		iconCls: (Type == "Add")?"icon-w-add":"icon-w-edit",
		resizable: true,
		title: (Type == "Add"?"新增":"更新") + "-" + (Base == "Config"?"配置数据":(Base == "Param"?"参数数据":(Base == "Extend"?"扩展数据":""))),
		modal: true,
		buttonAlign: "center",
		buttons: [{
			text: "保存",
			handler: function() {
				Update(Base, Type);
			}
		}, {
			text: "关闭",
			handler: function() {
				myWin.close();
			}
		}]
	});
}

function GetData(Base) {
	var SelRowData = $("#" + Base + "Data").datagrid("getSelected");
	if (!SelRowData) { 
		$.messager.alert("提示","请选择待修改的" + (Base == "Config"?"配置数据":(Base == "Param"?"参数数据":(Base == "Extend"?"扩展数据":""))) + "！", "info"); 
		return false; 
	}
	
	$cm({
		ClassName: "web.DHCPE.CT.ReportSetting",
		MethodName: "GetRptSetting",
		Id: SelRowData.TId
	}, function(data) {
		if (data.code == "0") {
			$("#CodeWin").val(data.data.Code);
			$("#DescWin").val(data.data.Desc);
			$("#TitleWin").val(data.data.Title);
			var type = data.data.ParamType;
			if (type == "") type = "T"
			$("#TypeWin").combobox("setValue", type);
			$("#ValueWin").val(data.data.Value);
			$("#RemarkWin").val(data.data.Remark);
		} else {
			$.messager.popover({msg: '获取数据失败！' + data.msg, type: 'error'});
		}
	});
	return true;
}

function Update(Base, Type) {
	var PId = "", OId = "";
	if (Type == "Upd") {
		var SelRowData = $("#" + Base + "Data").datagrid("getSelected");
		if (!SelRowData) { 
			$.messager.alert("提示", "请选择待修改的" + (Base == "Config"?"配置数据":(Base == "Param"?"参数数据":(Base == "Extend"?"扩展数据":""))) + "！", "info"); 
			return false; 
		}
		OId = SelRowData.TId;
	}
	
	var prtTab = (Base == "Param"?"Config":(Base == "Extend"?"Param":""));
	var cidTab = (Base == "Config"?"Param":(Base == "Param"?"Extend":""));
	if (prtTab == "") {
		if (Base != "Config") {
			$.messager.alert("提示", "无对照ID，无法新增" + (Base == "Config"?"配置数据":(Base == "Param"?"参数数据":(Base == "Extend"?"扩展数据":""))) + "！", "info"); 
			return false; 
		}
		PId = TheCode;
	} else {
		var prtSelRowData = $("#" + prtTab + "Data").datagrid("getSelected");
		if (!prtSelRowData) { 
			$.messager.alert("提示", "未选择" + (prtTab == "Config"?"配置数据":(prtTab == "Param"?"参数数据":(prtTab == "Extend"?"扩展数据":""))) +"，无法新增" + (Base == "Config"?"配置数据":(Base == "Param"?"参数数据":(Base == "Extend"?"扩展数据":""))) + "！", "info"); 
			return false; 
		}
		PId = prtSelRowData.TId;
	}
	if (PId == "") {
		$.messager.alert("提示", "无对照ID，无法新增" + (Base == "Config"?"配置数据":(Base == "Param"?"参数数据":(Base == "Extend"?"扩展数据":""))) + "！", "info"); 
		return false; 
	}
	
	var Code = $("#CodeWin").val();
	if (Code == "") {
		$.messager.popover({msg: '代码不能为空！' + data.msg, type: 'alert'});
		return false;
	}
	
	var Desc = $("#DescWin").val();
	if (Desc == "") {
		$.messager.popover({msg: '代码不能为空！' + data.msg, type: 'alert'});
		return false;
	}
	
	var Title = $("#TitleWin").val();
	var Type = $("#TypeWin").combobox("getValue");
	var Value = $("#ValueWin").val();
	var Remark = $("#RemarkWin").val();
	
	// 编码  描述  提示  科室  对照ID  参数类型  参数值  备注
	var Strs = Code + "^" + Desc + "^" + Title + "^" + TheLocId + "^" + PId + "^" + Type + "^" + Value + "^" + Remark;
	$cm({
		ClassName: "web.DHCPE.CT.ReportSetting",
		MethodName: "UpdRptSetting",
		Id: OId,
		Strs: Strs
	}, function(data) {
		if (data.code == "0") {
			$.messager.popover({msg: '保存成功！', type: 'success'});
			$("#" + Base + "Data").datagrid("reload");
			$("#" + cidTab + "Data").datagrid("loadData", {total:0, rows:[]});
		} else {
			$.messager.popover({msg: '保存失败！' + data.msg, type: 'error'});
		}
	});
}

function BClear_click(Base) {
	$("#CodeWin,#DescWin,#TitleWin,#ValueWin,#RemarkWin").val("");
	$("#TypeWin").combobox("setValue","");
	if (Base == "Config") {
		$("#ValueWin,#RemarkWin").attr("disabled", "disabled");
		$("#TypeWin").combobox("disable");
	} else {
		$("#ValueWin,#RemarkWin").removeAttr("disabled");
		$("#TypeWin").combobox("enable");
	}
}

function InitDatagrid(Base, BaseId) {
	if (Base == "" || BaseId == "") return false;
	
	var HiddenFlag = false;
	if (isNaN(BaseId)) HiddenFlag = true;
	
	$HUI.datagrid("#" + Base + "Data", {
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.CT.ReportSetting",
			QueryName:"SearchRptSetting",
			BaseId:BaseId,
			LocID:TheLocId
		},
		collapsible: true, //收起表格的内容
		lines: true,
		striped: true, // 条纹化
		pagination:true,
		pageSize:50,
		pageList:[50,100,200],
		showPageList:false,
		//showRefresh:true,
		//beforePageText:'',
		//afterPageText:'页/{pages}页',
		displayMsg:'共{total}条',
		rownumbers: true,
		border: false,
		fit: true,
		fitColumns: true,
		animate: true,
		singleSelect: true,
		
		columns:[[
			{field:'TId', title:'TId', hidden:true},
			{field:'TParamType', title:'类型', hidden:true},
			{field:'TCode', title:'TCode', width:120, hidden:HiddenFlag},
			{field:'TDesc', title:'描述', width:120, formatter: function(value, rowData, rowIndex) {
				var title = rowData.TTitle;
				return "<a id='" + Base + "_" + rowData.TCode + "' href='#' title='"
						+ title
						+ "' class='hisui-tooltip' data-options='position:\"right\",showDelay:50' style='text-decoration: none;color: black;'>"
						+ value + "</a>";
				}
			},
			{field:'TParamTypeDesc', title:'类型', width:70, hidden:HiddenFlag},
			{field:'TValue', title:'值', width:120, hidden:HiddenFlag},
			{field:'TRemark', title:'备注', width:150, hidden:HiddenFlag}
		]],
		onClickRow: function (rowIndex, rowData) {  // 选择行事件
			var nBTable = (Base == "Config"?"Param":(Base == "Param"?"Extend":""));
			InitDatagrid(nBTable, rowData.TId);
			
			if (nBTable != "") {
				try { $("#" + "Extend" + "Data").datagrid("loadData", {total:0, rows:[]}); } catch (e) { }
			}
		},
		onDblClickRow: function (rowIndex, rowData) {  // 双击行事件
		},
		onLoadSuccess: function(data){
		}
	});
}

function InitCombobox() {
	// 参数类型	
	$HUI.combobox("#TypeWin", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'T',text:'文本'},
			{id:'E',text:'扩展'},
			{id:'C',text:'自定义'}
		]
	});
}