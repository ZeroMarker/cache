/// DHCOPBillOrdRefundAppConfig.js

$(function () {
	init_Layout();
	
	$HUI.linkbutton("#BtnInsert", {
		onClick: function () {
			Insert_Click();
		}
	});

	$HUI.linkbutton("#BtnUpdate", {
		onClick: function () {
			Update_Click();
		}
	});

	$HUI.linkbutton("#BtnClear", {
		onClick: function () {
			Clear_Click();
		}
	});
	
	var tableName = "Bill_OP_PartRefApp";
	var defHospId = $.m({
		ClassName: "web.DHCBL.BDP.BDPMappingHOSP",
		MethodName: "GetDefHospIdByTableName",
		tableName: tableName,
		HospID: session['LOGON.HOSPID']
	}, false);
	$("#Hospital").combobox({
		panelHeight: 150,
		width: 300,
		url: $URL + '?ClassName=web.DHCBL.BDP.BDPMappingHOSP&QueryName=GetHospDataForCombo&ResultSetType=array&tablename=' + tableName,
		method: 'GET',
		valueField: 'HOSPRowId',
		textField: 'HOSPDesc',
		editable: false,
		blurValidValue: true,
		onLoadSuccess: function(data) {
			$(this).combobox('select', defHospId);
		},
		onChange: function(newValue, oldValue) {
			setValueById("HospId", newValue);
			
			setValueById("ArcicDr", "");
			var url = $URL + "?ClassName=web.DHCOPBillOrdRefundAppConfig&QueryName=FindArcimCat&ResultSetType=array";
			$("#ArcicDesc").combobox("clear").combobox("reload", url);
			
			setValueById("ArcimRowid", "");
			$("#ArcimDesc").combogrid("clear").combogrid("grid").datagrid("reload");
			
			ReLoadH();
		}
	});
	
	$HUI.combobox("#ArcicDesc", {
		valueField: "ArcicDr",
		textField: "ArcCatDesc",
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			param.ArcicDesc = "";
			param.HospId = getValueById("Hospital");
		},
		onSelect: function (rec) {
			$("#ArcimDesc").combogrid("clear").combogrid("grid").datagrid("reload");
		},
		onChange: function(newValue, oldValue) {
			setValueById("ArcicDr", (newValue || ""));
		}
	});
	
	$HUI.combogrid("#ArcimDesc", {
		panelWidth: 430,
		panelHeight: 280,
		method: 'GET',
		idField: 'ArcimRowid',
		textField: 'ArcimDesc1',
		mode: 'remote',
		delay: 300,
		pagination: true,
		enterNullValueClear: false,
		selectOnNavigation: false,
		lazy: true,
		columns: [[{field: "ArcimDesc1", title: "医嘱项名称", width: 150},
				   {field: "ArcimRowid", title: "医嘱项ID", width: 80},
				   {field: "ArcCatDesc", title: "医嘱子类", width: 100},
				   {field: "ArcCatRowid", title: "医嘱子类ID", width: 80}
			]],
		displayMsg: '',
		url: $URL + '?ClassName=web.DHCOPBillOrdRefundAppConfig&QueryName=FindArcim',
		onBeforeLoad: function (param) {
			param.ArcicDr =  getValueById("ArcicDesc"),
			param.ArcimDesc =  $("#ArcimDesc").combogrid("getText"),
			param.HospId = getValueById("Hospital")
		},
		onSelect: function (index, row) {
			setValueById("ArcicDr", row.ArcCatRowid);
			var url = $URL + "?ClassName=web.DHCOPBillOrdRefundAppConfig&QueryName=FindArcimCat&ResultSetType=array";
			$("#ArcicDesc").combobox("clear").combobox("reload", url).combobox("setValue", row.ArcCatRowid);
		},
		onChange: function (newValue, oldValue) {
			setValueById("ArcimRowid", newValue);
		}
	});
});

function Insert_Click() {
	var ArcicDr = getValueById("ArcicDesc");
	if (!ArcicDr) {
		$.messager.popover({msg: "医嘱子类不能为空", type: "info"});
		return;
	}
	var ArcimRowid = $("#ArcimDesc").combogrid("getValue");
	
	var AppFlag = getValueById("AppFlag") ? "Y" : "N";
	if (AppFlag == "N") {
		$.messager.popover({msg: "请选择有效标识", type: "info"});
		return;
	}
	var StDate = "";
	var EndDate = "";
	var InsertInfo = ArcicDr + "^" + ArcimRowid + "^" + AppFlag + "^" + StDate + "^" + EndDate;
	$.messager.confirm("确认", "确认新增？", function(r) {
		if (r) {
			$.m({
				ClassName: "web.DHCOPBillOrdRefundAppConfig",
				MethodName: "InsertOrdRefundAppConfig",
				InsertInfo: InsertInfo,
				Guser: session['LOGON.USERID'],
				HospId: getValueById("Hospital")
			}, function(rtn) {
				switch(rtn) {
				case "0":
					$.messager.popover({msg: "新增成功", type: "success"});
					$("#tDHCOPBillOrdRefundAppConfig").datagrid("reload");
					break;
				case "InsertNull":
					$.messager.popover({msg: "录入信息不能为空", type: "info"});
					break;
				case "UserNull":
					$.messager.popover({msg: "操作员不能为空", type: "info"});
					break;
				case "Already":
					$.messager.popover({msg: "录入信息已经存在不能增加", type: "info"});
					break;
				case "CatNull":
					$.messager.popover({msg: "医嘱子类不能为空", type: "info"});
					break;
				case "CatAlready":
					$.messager.popover({msg: "该医嘱子类已经存在不能增加", type: "info"});
					break;
				case "OrdAlready":
					$.messager.popover({msg: "该医嘱已经存在不能增加", type: "info"});
					break;
				case "APPFlagErr":
					$.messager.popover({msg: "请选择有效标识", type: "info"});
					break;
				default:
					$.messager.popover({msg: "新增失败：" + RetCode, type: "error"});
				}
			});
		}
	});
}

function SelectRowHandler(index, rowData) {
	setValueById("ArcicDesc", rowData.TArcicDr);
	var total = 0;
	var rows = [];
	$("#ArcimDesc").combogrid("clear");
	if (rowData.TArcimRowid) {
		total = 1;
		rows = [{ArcimDesc1: rowData.TArcimDesc, ArcimRowid: rowData.TArcimRowid, ArcCatDesc: rowData.TArcicDesc, ArcCatRowid: rowData.TArcicDr}];
	}
	$("#ArcimDesc").combogrid("clear").combogrid("grid").datagrid("loadData", {total:total, rows: rows});
	$("#ArcimDesc").combogrid("setValue", rowData.TArcimRowid);
	setValueById("AppFlag", (rowData.TAPPFlag == "Y"));
}

function Update_Click() {
	var row = $("#tDHCOPBillOrdRefundAppConfig").datagrid("getSelected");
	if (!row || !row.TORACRowid) {
		$.messager.popover({msg: "请选择要修改的记录", type: "info"});
		return;
	}
	var ORACRowid = row.TORACRowid;
	var ArcicDr = getValueById("ArcicDesc");
	if (!ArcicDr) {
		$.messager.popover({msg: "医嘱子类不能为空", type: "info"});
		return;
	}
	var ArcimRowid = $("#ArcimDesc").combogrid("getValue");

	var AppFlag = getValueById("AppFlag") ? "Y" : "N";
	var StDate = "";
	var EndDate = "";

	var UpdateInfo = ArcicDr + "^" + ArcimRowid + "^" + AppFlag + "^" + StDate + "^" + EndDate;
	
	$.messager.confirm("确认", "确认修改？", function(r) {
		if (r) {
			$.m({
				ClassName: "web.DHCOPBillOrdRefundAppConfig",
				MethodName: "UpdateOrdRefundAppConfig",
				UpdateInfo: UpdateInfo,
				Guser: session['LOGON.USERID'],
				ORACRowid: ORACRowid
			}, function(rtn) {
				switch(rtn) {
				case "0":
					$.messager.popover({msg: "修改成功", type: "success"});
					$("#tDHCOPBillOrdRefundAppConfig").datagrid("reload");
					break;
				case "UpdateNull":
					$.messager.popover({msg: "录入信息不能为空", type: "info"});
					break;
				case "UserNull":
					$.messager.popover({msg: "操作员不能为空", type: "info"});
					break;
				case "ORACNull":
					$.messager.popover({msg: "请选择要修改的记录", type: "info"});
					break;
				case "CatNull":
					$.messager.popover({msg: "医嘱子类不能为空", type: "info"});
					break;
				default:
					$.messager.popover({msg: "修改失败：" + RetCode, type: "error"});
				}
			});
		}
	});
}

function Clear_Click() {
	setValueById("ArcimRowid", "");
	setValueById("ArcicDr", "");
	$(".combobox-f:not(#Hospital)").combobox("clear");
	$(".checkbox-f").checkbox("uncheck");
	$(".combogrid-f").combogrid("clear").combogrid("grid").datagrid("loadData", {
		total: 0,
		rows: []
	});
	$("#Find").click();
}

function init_Layout() {
	DHCWeb_ComponentLayout();
}

function ReLoadH() {
	$('#Find').click();
}