/// DHCOPBillOrdRefundAppConfig.js

$(function () {
	init_Layout();
	
	$HUI.linkbutton("#BtnInsert", {
		onClick: function () {
			insertClick();
		}
	});

	$HUI.linkbutton("#BtnUpdate", {
		onClick: function () {
			updateClick();
		}
	});

	$HUI.linkbutton("#BtnClear", {
		onClick: function () {
			clearClick();
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
		textField: "ArcicDesc",
		defaultFilter: 5,
		onBeforeLoad: function (param) {
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
				   {field: "ArcicDesc", title: "医嘱子类", width: 100},
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

function insertClick() {
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
		if (!r) {
			return;
		}
		$.m({
			ClassName: "web.DHCOPBillOrdRefundAppConfig",
			MethodName: "InsertOrdRefundAppConfig",
			InsertInfo: InsertInfo,
			UserId: session['LOGON.USERID'],
			HospId: getValueById("Hospital")
		}, function(rtn) {
			var myAry = rtn.split("^");
			if (myAry[0] == 0) {
				$.messager.popover({msg: "新增成功", type: "success"});
				$("#tDHCOPBillOrdRefundAppConfig").datagrid("reload");
				return;
			}
			$.messager.popover({msg: (myAry[1] || myAry[0]), type: "error"});
		});
	});
}

function SelectRowHandler(index, row) {
	setValueById("ArcicDesc", row.TArcicDr);
	var total = 0;
	var rows = [];
	$("#ArcimDesc").combogrid("clear");
	if (row.TArcimRowid) {
		total = 1;
		rows = [{ArcimDesc1: row.TArcimDesc, ArcimRowid: row.TArcimRowid, ArcicDesc: row.TArcicDesc, ArcCatRowid: row.TArcicDr}];
	}
	$("#ArcimDesc").combogrid("clear").combogrid("grid").datagrid("loadData", {total:total, rows: rows});
	$("#ArcimDesc").combogrid("setValue", row.TArcimRowid);
	setValueById("AppFlag", (row.TAPPFlag == "Y"));
}

function updateClick() {
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
		if (!r) {
			return;
		}
		$.m({
			ClassName: "web.DHCOPBillOrdRefundAppConfig",
			MethodName: "UpdateOrdRefundAppConfig",
			UpdateInfo: UpdateInfo,
			UserId: session['LOGON.USERID'],
			ORACRowid: ORACRowid
		}, function(rtn) {
			var myAry = rtn.split("^");
			if (myAry[0] == 0) {
				$.messager.popover({msg: "修改成功", type: "success"});
				$("#tDHCOPBillOrdRefundAppConfig").datagrid("reload");
				return;
			}
			$.messager.popover({msg: (myAry[1] || myAry[0]), type: "error"});
		});
	});
}

function clearClick() {
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