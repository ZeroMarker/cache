/**
 * FileName: dhcbill.conf.cancelchgreason.js
 * Author: ZhYW
 * Date: 2022-06-21
 * Description: 取消结算原因维护
 */

$.extend($.fn.validatebox.defaults.rules, {
	checkCodeExist: {    //校验代码是否存在
	    validator: function(value) {
		    if (GV.EditRowIndex == undefined) {
			    return true;
			}
			var row = GV.ReasonList.getRows()[GV.EditRowIndex];
			if (!row){
				return true;
			}
		    return $.m({ClassName: "BILL.CFG.IP.CancelChgReason", MethodName: "CheckCodeExist", Id: row.Id, code: $.trim(value)}, false) == 0;
		},
		message: "代码已存在"
	}
});

$(function () {
	initReasonList();
	
	var tableName = "Bill_IP_CancelChgReason";
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
			loadReasonList();
		}
	});
});

function initReasonList() {
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
		}, {
			text: '刷新',
			iconCls: 'icon-reload',
			handler: function() {
				loadReasonList();
			}
		}
	]
	GV.ReasonList = $HUI.datagrid("#reasonList", {
		fit: true,
		border: false,
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		toolbar: toolbar,
		className: "BILL.CFG.IP.CancelChgReason",
		queryName: "QryReasonList",
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
				if (cm[i].field == "Id") {
					cm[i].hidden = true;
					continue;
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if (cm[i].field == "ReasonDesc") {
						cm[i].width = 200;
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
				if (cm[i].field == "ReasonCode") {
					cm[i].editor = {
						type: 'validatebox',
						options: {
							required: true,
							validType: ['checkCodeExist']
						}
					};
				}
				if (cm[i].field == "ReasonDesc") {
					cm[i].editor = {
						type: 'validatebox',
						options: {
							required: true
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
    	}
	});
}

function loadReasonList() {
	var queryParams = {
		ClassName: "BILL.CFG.IP.CancelChgReason",
		QueryName: "QryReasonList",
		hospId: getValueById("hospital")
	};
	loadDataGridStore("reasonList", queryParams);
}

function onBeginEditHandler(index, row) {
	if (row.Id > 0) {
		var ed = GV.ReasonList.getEditor({index: index, field: "ReasonCode"});
		if (ed) {
			$(ed.target).prop("disabled", true);
		}
	}
}

/**
* 光标定位到代码编辑器
*/
function focusReasonCode(index) {
	if ((index | 0) === index) {   //判断是否是整数
		var ed = GV.ReasonList.getEditor({index: index, field: "ReasonCode"});
		if (ed) {
			$(ed.target).focus();
		}
	}
}

/**
* 保存
*/
function saveClick() {
	var row = GV.ReasonList.getRows()[GV.EditRowIndex];
	if (!row){
		return;
	}
	$.messager.confirm("确认", "确认保存？", function(r) {
		if (!r) {
			return;
		}
		if (!endEditing()) {
			return;
		}
		var jsonObj = {
			Id: row.Id,
			reaCode: row.ReasonCode,
			reaDesc: row.ReasonDesc,
			dateFrom: row.DateFrom,
			dateTo: row.DateTo,
			userId: PUBLIC_CONSTANT.SESSION.USERID,
			hospId: getValueById("hospital")
		};
		$.m({
			ClassName: "BILL.CFG.IP.CancelChgReason",
			MethodName: "SaveData",
			jsonStr: JSON.stringify(jsonObj)
		}, function (rtn) {
			var myAry = rtn.split("^");
			if (myAry[0] == 0) {
				$.messager.popover({msg: "保存成功", type: "success"});
				GV.ReasonList.reload();
				return;
			}
			$.messager.popover({msg: "保存失败：" + (myAry[1] || myAry[0]), type: "error"});
		});
	});
}

/**
* 新增
*/
function addClick() {
	if (GV.EditRowIndex != undefined) {
		focusReasonCode(GV.EditRowIndex);
		$.messager.popover({msg: "有正在编辑的行", type: "info"});
		return;
	}
	var row = {};
	$.each(GV.ReasonList.getColumnFields(), function (index, item) {
		row[item] = "";
	});
	GV.ReasonList.appendRow(row);
	GV.EditRowIndex = GV.ReasonList.getRows().length - 1;
	GV.ReasonList.beginEdit(GV.EditRowIndex);
	GV.ReasonList.selectRow(GV.EditRowIndex);
	focusReasonCode(GV.EditRowIndex);
}

/**
* 修改
*/
function updateClick() {
	if (GV.EditRowIndex != undefined) {
		focusReasonCode(GV.EditRowIndex);
		$.messager.popover({msg: "有正在编辑的行", type: "info"});
		return;
	}
	var row = GV.ReasonList.getSelected();
	if (!row) {
		$.messager.popover({msg: "请选择需要编辑的行", type: "info"});
		return;
	}
	
	GV.EditRowIndex = GV.ReasonList.getRowIndex(row);
	GV.ReasonList.beginEdit(GV.EditRowIndex);
	focusReasonCode(GV.EditRowIndex);
}

/**
* 取消编辑
*/
function rejectClick() {
	GV.ReasonList.rejectChanges();
	GV.EditRowIndex = undefined;
}

function endEditing() {
	if (GV.EditRowIndex == undefined) {
		return true;
	}
	if (GV.ReasonList.validateRow(GV.EditRowIndex)) {
		GV.ReasonList.endEdit(GV.EditRowIndex);
		GV.EditRowIndex = undefined;
		return true;
	}
	return false;
}
