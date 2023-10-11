/**
 * FileName: dhcbill.conf.page.modifypaymode.js
 * Author: tangzf
 * Date: 2021-06-07
 * Description: 支付方式修改对照
 */

$(function() {
	init_PayMode();
	init_PayModeContrast();

	var tableName = "BILL_Com_ModifyPayMode";
	var defHospId = $.m({
		ClassName: "web.DHCBL.BDP.BDPMappingHOSP",
		MethodName: "GetDefHospIdByTableName",
		tableName: tableName,
		HospID: PUBLIC_CONSTANT.SESSION.HOSPID
	}, false);
	$("#hospital").combobox({
		panelHeight: 150,
		width: 350,
		url: $URL + '?ClassName=web.DHCBL.BDP.BDPMappingHOSP&QueryName=GetHospDataForCombo&ResultSetType=array&tablename=' + tableName,
		method: 'GET',
		valueField: 'HOSPRowId',
		textField: 'HOSPDesc',
		editable: false,
		blurValidValue: true,
		onLoadSuccess: function(data) {
			$(this).combobox('select', PUBLIC_CONSTANT.SESSION.HOSPID);
		},
		onChange: function(newValue, oldValue) {
			loadPayMode();
		}
	});
	
	$("#ConPayMode").combobox({
		panelHeight: 150,
		width: 120,
		url: $URL + '?ClassName=INSU.COM.BaseData&QueryName=FindCTPayMode&ResultSetType=array&ExpStr=Y|' ,
		method: 'GET',
		valueField: 'RowId',
		textField: 'Desc',
		editable: false,
		blurValidValue: true
	});
	loadPayMode();
});

function init_PayMode() {
	$HUI.datagrid("#dg", {
		fit: true,
		border: false,
		singleSelect: true,
		rownumbers: true,
		pageSize: 999999999,
		toolbar: [],
		columns: [[{title: 'RowId', field: 'RowId', hidden: true},
				   {title: '代码', field: 'Code', width: 120},
				   {title: '描述', field: 'Desc', width: 140}
			]],
		onSelect: function(index, row) {
			loadConPayMode();
		}
	});
}

function init_PayModeContrast() {
	$HUI.datagrid("#edg", {
		fit: true,
		border: false,
		singleSelect: true,
		rownumbers: true,
		pageSize: 999999999,
		columns: [[{title: 'confId', field: 'confId', hidden: true},
				   {title: '代码', field: 'Code', width: 120},
				   {title: '描述', field: 'Desc', width: 140}
			]]
	});	
}

function loadConPayMode(){
	ClearGrid("edg");
	$("#edg").datagrid("clearSelections");
	var dgSelected = $("#dg").datagrid("getSelected");
	if(!dgSelected){
		$.messager.popover({msg: "请选择左边的信息", type: "info"});
		return;
	}
	var PayModeCode = dgSelected.RowId;
	var hospital = getValueById("hospital");
	var queryParams = {
		ClassName: "web.DHCBillPageConf",
		QueryName: "FindModifyPayModeCon",
		pageId: GV.PageId,
		site: "HOSPITAL",
		code: dgSelected.RowId,
		hospId: hospital,
		rows: 999999999
	}
	loadDataGridStore("edg", queryParams);
}

function loadPayMode() {
	ClearGrid("dg");
	ClearGrid("edg");
	$("#dg").datagrid("clearSelections");
	$("#edg").datagrid("clearSelections");
	setValueById("ConPayMode","");
	var queryParams = {
		ClassName: "INSU.COM.BaseData",
		QueryName: "FindCTPayMode",
		ExpStr: "Y|",
		rows: 999999999
	}
	loadDataGridStore("dg", queryParams);
}

function ClearGrid(gridId) {
	$("#" + gridId).datagrid("loadData", {total:0, rows:[]});
}

/**
* 保存
*/
function save() {
	var dgSelected = $("#dg").datagrid("getSelected");
	if(!dgSelected){
		$.messager.popover({msg: "请在左边选择一条数据", type: "info"});
		return;
	}
	
	var PayModeCodeId = getValueById("ConPayMode");
	if (PayModeCodeId == "") {
		$.messager.popover({msg: "请选择要增加的支付方式", type: "info"});
		return;
	}
	var hospital = getValueById("hospital");
	var coninfo = $("#edg").datagrid("getData");
	$.messager.confirm("确认", "确认保存?", function(r) {
		if (!r) {
			return;
		}
		var tmpConinfo = PayModeCodeId;
		var StopFlag = "";
		$.each(coninfo.rows, function(index, item) {
			tmpConinfo = tmpConinfo + "|" + item.RowId;
			if(PayModeCodeId == item.RowId){
				$.messager.popover({msg: "支付方式重复", type: "info"});
				StopFlag = "Y";
			}
		});
		if (StopFlag =="Y") {
			return;
		}
		var confAry = [];
		var myObj = {};
		myObj.PCSite = GV.Site;
		myObj.PCSiteDR = hospital;
		myObj.PCCode = dgSelected.RowId;
		myObj.PCValue = tmpConinfo;
		myObj.PCDesc = dgSelected.Desc;
		confAry.push(JSON.stringify(myObj));
		$.m({
			ClassName: "web.DHCBillPageConf",
			MethodName: "SaveConfInfo",
			pageId: GV.PageId,
			confList: confAry
		}, function(rtn) {
			if (rtn == 0) {
				loadConPayMode();
				$.messager.popover({msg: "保存成功", type: "success"});
				loadConPayMode();
				return;
			}
			$.messager.popover({msg: "保存失败：" + rtn, type: "error"});
		});
	});
}

/**
* 删除
*/
function deleteClick() {
	var dgSelected = $("#dg").datagrid("getSelected");
	if (!dgSelected) {
		return;
	}
	var row = $("#edg").datagrid("getSelected");
	if (!row) {
		$.messager.popover({msg: "请选择需要删除的记录", type: "info"});
		return;
	}
	var PayModeCodeId = getValueById("ConPayMode");
	var hospital = getValueById("hospital");
	var coninfo = $("#edg").datagrid("getData");
	$.messager.confirm("确认", "确认删除?", function (r) {
		if (!r) {
			return;
		}
		var tmpConinfo = "";
		$.each(coninfo.rows, function(index, item) {
			if(row.RowId != item.RowId) {
				tmpConinfo = tmpConinfo + "|" + item.RowId;
			}
		});
		var confAry = [];
		var myObj = {};
		myObj.PCSite = "HOSPITAL";
		myObj.PCSiteDR = hospital;
		myObj.PCCode = dgSelected.RowId;
		myObj.PCValue = tmpConinfo;
		myObj.PCDesc = dgSelected.Desc;
		confAry.push(JSON.stringify(myObj));
		
		$.m({
			ClassName: "web.DHCBillPageConf",
			MethodName: "SaveConfInfo",
			pageId: GV.PageId,
			confList: confAry
		}, function(rtn) {
			if (rtn == 0) {
				loadConPayMode();
				$.messager.popover({msg: "删除成功", type: "success"});
				return;
			}
			$.messager.popover({msg: "删除失败：" + rtn, type: "error"});
		});
	});
}