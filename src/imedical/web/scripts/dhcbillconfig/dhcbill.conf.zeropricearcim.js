/**
 * FileName: dhcbill.conf.zeropricearcim.js
 * Author: ZhYW
 * Date: 2022-06-15
 * Description: 允许零价格医嘱维护
 */

$(function () {
	//新增
	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadArcimList();
		}
	});
	
	initArcimList();
	
	var tableName = "Bill_OP_ZeroPriceArcim";
	var defHospId = $.m({
		ClassName: "web.DHCBL.BDP.BDPMappingHOSP",
		MethodName: "GetDefHospIdByTableName",
		tableName: tableName,
		HospID: PUBLIC_CONSTANT.SESSION.HOSPID
	}, false);
	$("#hospital").combobox({
		panelHeight: 150,
		width: 300,
		url: $URL + '?ClassName=web.DHCBL.BDP.BDPMappingHOSP&QueryName=GetHospDataForCombo&ResultSetType=array&tablename=' + tableName,
		method: 'GET',
		valueField: 'HOSPRowId',
		textField: 'HOSPDesc',
		editable: false,
		blurValidValue: true,
		onLoadSuccess: function(data) {
			$(this).combobox("select", defHospId);
		},
		onChange: function(newValue, oldValue) {
			$("#arcim").combobox("clear").combobox("loadData", []);    //清空医嘱项
			loadArcimList();
		}
	});
	
	//医嘱项
	$HUI.combobox("#arcim", {
		panelHeight: 150,
		width: 300,
		mode: 'remote',
		method: 'GET',
		delay: 300,
		valueField: 'ArcimRowID',
		textField: 'ArcimDesc',
		onBeforeLoad: function (param) {
			if ($.trim(param.q).length > 1) {
				$.extend($(this).combobox("options"), {url: $URL});
				param.ClassName = "BILL.COM.ItemMast";
				param.QueryName = "FindARCItmMast";
				param.ResultSetType = "array";
				var sessionStr = PUBLIC_CONSTANT.SESSION.USERID + "^" + "" + "^" + PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + getValueById("hospital");
				param.alias = param.q;
				param.sessionStr = sessionStr;
			}
		}
	});
});

function initArcimList() {
	var toolbar = [{
			text: '新增',
			iconCls: 'icon-add',
			handler: function() {
				addClick();
			}
		}, {
			text: '修改',
			iconCls: 'icon-write-order',
			handler: function() {
				updateClick();
			}
		}, {
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				saveClick();
			}
		}, {
			text: '取消编辑',
			iconCls: 'icon-redo',
			handler: function() {
				rejectClick();
			}
		}
	]
	GV.ArcimList = $HUI.datagrid("#arcimList", {
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		toolbar: toolbar,
		className: "BILL.CFG.OP.ZeroPriceArcim",
		queryName: "QryZeroPriceArcimList",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["CreatDate", "UpdtDate"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if (cm[i].field == "CreatTime") {
					cm[i].formatter = function (value, row, index) {
						if (row.CreatDate) {
							return row.CreatDate + " " + value;
						}
					}
				}
				if (cm[i].field == "UpdtTime") {
					cm[i].formatter = function (value, row, index) {
						if (row.UpdtDate) {
							return row.UpdtDate + " " + value;
						}
					}
				}
				if ($.inArray(cm[i].field, ["CfgId", "ArcimId"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if (cm[i].field == "ArcimDesc") {
						cm[i].width = 230;
					}
					if (cm[i].field == "DateFrom") {
						cm[i].width = 150;
					}
					if (cm[i].field == "DateTo") {
						cm[i].width = 150;
					}
					if ($.inArray(cm[i].field, ["CreatTime", "UpdtTime"]) != -1) {
						cm[i].width = 155;
					}
				}
				if (cm[i].field == "ArcimDesc") {
					cm[i].editor = {
						type: 'combogrid',
						options: {
							panelWidth: 530,
							fitColumns: true,
							method: 'GET',
							pagination: true,
							idField: 'ArcimRowID',
							textField: 'ArcimDesc',
							mode: 'remote',
							url: $URL + '?ClassName=BILL.COM.ItemMast&QueryName=FindARCItmMast',
							delay: 300,
							lazy: true,
							enterNullValueClear: false,
							selectOnNavigation: false,
							required: true,
							columns: [[{field: 'ArcimCode', title: '医嘱项代码', width: 100},
									   {field: 'ArcimDesc', title: '医嘱项名称', width: 180},
								   	   {field: 'ArcimRowID', title: 'ArcimRowID', hidden: true}
							]],
							onBeforeLoad: function (param) {
								var sessionStr = PUBLIC_CONSTANT.SESSION.USERID + "^" + "" + "^" + PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + getValueById("hospital");
								param.alias = param.q;
								param.sessionStr = sessionStr;
							},
							onSelect: function(index, row) {
								onSelectArcimHandler(row);
							}
						}
					};
				}
				if (cm[i].field == "DateFrom") {
					cm[i].editor = {
					   	type: 'datebox',
					   	options: {
						   	required: true
					   	}
					};
				}
				if (cm[i].field == "DateTo") {
					cm[i].editor = {
					    type: 'datebox'
					};
				}
			}
		},
		onLoadSuccess: function(data) {
			GV.EditRowIndex = undefined;
		},
		onBeginEdit: function(index, row) {
			onBeginEditHandler(index, row);
    	},
		onEndEdit: function(index, row, changes) {
			onEndEditHandler(index, row);
		}
	});
}

function loadArcimList() {
	var queryParams = {
		ClassName: "BILL.CFG.OP.ZeroPriceArcim",
		QueryName: "QryZeroPriceArcimList",
		arcimId: getValueById("arcim"),
		hospId: getValueById("hospital")
	};
	loadDataGridStore("arcimList", queryParams);
}

function onSelectArcimHandler(row) {
	if (!row) {
		return;
	}
	var editRow = GV.ArcimList.getRows()[GV.EditRowIndex];
	if (!editRow) {
		return;
	}
	editRow.ArcimId = row.ArcimRowID;
}

function onBeginEditHandler(index, row) {
	if (row.CfgId > 0) {
		var ed = GV.ArcimList.getEditor({index: index, field: "ArcimDesc"});
		if (ed) {
			$(ed.target).combogrid("disable");
		}
	}
}

function onEndEditHandler(index, row) {
	var ed = GV.ArcimList.getEditor({index: index, field: "ArcimDesc"});
	if (ed) {
		row.ArcimDesc = $(ed.target).combogrid("getText");
	}
}

/**
* 光标定位到医嘱项combogrid编辑器
*/
function focusArcimDesc(index) {
	if ((index | 0) === index) {   //判断是否是整数
		var ed = GV.ArcimList.getEditor({index: index, field: "ArcimDesc"});
		if (ed) {
			$(ed.target).next("span").find("input").focus();
		}
	}
}

/**
* 保存
*/
function saveClick() {
	var row = GV.ArcimList.getRows()[GV.EditRowIndex];
	if (!row){
		return;
	}
	if (!endEditing()) {
		return;
	}	
	var jsonObj = {
		cfgId: row.CfgId,
		arcimId: row.ArcimId,
		dateFrom: row.DateFrom,
		dateTo: row.DateTo,
		userId: PUBLIC_CONSTANT.SESSION.USERID,
		hospId: getValueById("hospital")
	};
	$.m({
		ClassName: "BILL.CFG.OP.ZeroPriceArcim",
		MethodName: "SaveData",
		jsonStr: JSON.stringify(jsonObj)
	}, function (rtn) {
		var myAry = rtn.split("^");
		if (myAry[0] == 0) {
			$.messager.popover({msg: "保存成功", type: "success"});
			GV.ArcimList.reload();
			return;
		}
		$.messager.popover({msg: "保存失败：" + (myAry[1] || myAry[0]), type: "error"});
	});
}

/**
* 新增
*/
function addClick() {
	if (GV.EditRowIndex != undefined) {
		focusArcimDesc(GV.EditRowIndex);
		$.messager.popover({msg: "有正在编辑的行", type: "info"});
		return;
	}
	var row = {};
	$.each(GV.ArcimList.getColumnFields(), function (index, item) {
		row[item] = "";
	});
	GV.ArcimList.appendRow(row);
	GV.EditRowIndex = GV.ArcimList.getRows().length - 1;
	GV.ArcimList.beginEdit(GV.EditRowIndex);
	GV.ArcimList.selectRow(GV.EditRowIndex);
	focusArcimDesc(GV.EditRowIndex);
}

/**
* 修改
*/
function updateClick() {
	if (GV.EditRowIndex != undefined) {
		focusArcimDesc(GV.EditRowIndex);
		$.messager.popover({msg: "有正在编辑的行", type: "info"});
		return;
	}
	var row = GV.ArcimList.getSelected();
	if (!row) {
		$.messager.popover({msg: "请选择需要编辑的行", type: "info"});
		return;
	}
	
	GV.EditRowIndex = GV.ArcimList.getRowIndex(row);
	GV.ArcimList.beginEdit(GV.EditRowIndex);
	focusArcimDesc(GV.EditRowIndex);
}

/**
* 取消编辑
*/
function rejectClick() {
	GV.ArcimList.rejectChanges();
	GV.EditRowIndex = undefined;
}

function endEditing() {
	if (GV.EditRowIndex == undefined) {
		return true;
	}
	if (GV.ArcimList.validateRow(GV.EditRowIndex)) {
		GV.ArcimList.endEdit(GV.EditRowIndex);
		GV.EditRowIndex = undefined;
		return true;
	}
	return false;
}