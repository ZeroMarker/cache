/**
 * FileName: dhcbill.ipbill.deposit.lostreg.js
 * Author: ZhYW
 * Date: 2020-09-23
 * Description: 住院押金票据挂失/解挂
 */
 
$(function () {
	initLostDepMenu();
	initLostDepList();
});

function initLostDepMenu() {
	//挂失
	$HUI.linkbutton("#btn-lostReg", {
		onClick: function () {
			lostRegClick();
		}
	});
	
	//解挂
	$HUI.linkbutton("#btn-delLostReg", {
		onClick: function () {
			delLostRegClick();
		}
	});
	
	//押金类型
	$HUI.combobox("#loadDepositType", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryGrpDepType&ResultSetType=array',
		method: 'GET',
		editable: false,
		valueField: 'id',
		textField: 'text',
		onBeforeLoad: function(param) {
			param.groupId = PUBLIC_CONSTANT.SESSION.GROUPID;
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		},
		onChange: function(newValue, oldValue) {
			loadLostDepList();
		}
	});
}

function initLostDepList() {
	$HUI.datagrid("#lostDepList", {
		fit: true,
		border: false,
		singleSelect: true,
		pagination: true,
		pageSize: 20,
		className: 'web.DHCIPBillDeposit',
		queryName: 'FindDeposit',
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["TPrtDate", "Tbbackflag", "Tbbackdate", "Tbbacktime", "TDepositTypeDR", "TDepositTypeCode", "TAutoFlag", "TReRcptNo", "TLostRegDate"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if ($.inArray(cm[i].field, ["TDepRowId", "TPaymodeDR", "TPrtStatus", "TUserDR", "TFootId", "TInitPrtRowId", "TStrikeInvPrtId", "TLostRegistDR"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (cm[i].field == "TPrtTime") {
					cm[i].formatter = function (value, row, index) {
						return row.TPrtDate + " " + value;
					};
				}
				if (cm[i].field == "TStatus") {
					cm[i].styler = function(value, row, index) {
						if ([1, 4].indexOf(+row.TPrtStatus) == -1) {
							return "color: #FF0000;";
						}
					};
				}
				if (cm[i].field == "TFootFlag") {
					cm[i].formatter = function (value, row, index) {
					   	if (value) {
						   	var color = (value == "Y") ? "#21ba45" : "#f16e57";
							return "<font color=\"" + color + "\">" + ((value == "Y") ? $g("是") : $g("否")) + "</font>";
						}
					};
				}
				if (cm[i].field == "TPayedFlag") {
					cm[i].formatter = function (value, row, index) {
					   	if (value) {
							return (value == "Y") ? $g("已结") : $g("未结");
						}
					};
				}
				if (cm[i].field == "TIsLostReg") {
					cm[i].formatter = function (value, row, index) {
					    if (row.TDepRowId) {
							return (row.TLostRegistDR > 0) ? $g("是") : $g("否");
						}
					};
				}
				if (cm[i].field == "TLostRegTime") {
					cm[i].formatter = function (value, row, index) {
						return row.TLostRegDate + " " + value;
					};
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if ($.inArray(cm[i].field, ["TPrtTime", "TLostRegTime"]) != -1) {
						cm[i].width = 155;
					}
				}
			}
		},
		rowStyler: function(index, row) {
			if (row.TLostRegistDR) {
				return "color: #FF0000;";
			}
		}
	});
}

function loadLostDepList() {
	var episodeId = getValueById("EpisodeId");
	if (!episodeId) {
		return;
	}
	var queryParams = {
		ClassName: "web.DHCIPBillDeposit",
		QueryName: "FindDeposit",
		adm: episodeId,
		depositType: getValueById("loadDepositType")
	}
	loadDataGridStore("lostDepList", queryParams);
}

/**
* 挂失
*/
function lostRegClick() {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			var bool = true;
			$("#lostDepList").parents(".layout-panel-center").prev(".layout-panel-north").find(".clsRequired").parent().next().children().each(function(index, item) {
				if (!this.id) {
					return true;
				}
				if (!getValueById(this.id)) {
					bool = false;
					focusById(this.id);
					$.messager.popover({msg: "<font color='red'>" + $(this).parent().prev().children().text() + "</font>" + $g("不能为空"), type: "info"});
					return false;
				}
			});
			if (!bool) {
				return reject();
			}
			var row = $("#lostDepList").datagrid("getSelected");
			if (!row || !row.TDepRowId) {
				$.messager.popover({msg: "请选择要挂失的押金记录", type: "info"});
				return reject();
			}
			if (row.TPayedFlag == "Y") {
				$.messager.popover({msg: "该笔押金已结算，不能挂失", type: "info"});
				return reject();
			}
			if (row.TPrtStatus != 1) {
				$.messager.popover({msg: "该笔押金已退款，不能挂失", type: "info"});
				return reject();
			}
			if (!row.TRecepitNo) {
				$.messager.popover({msg: "该笔押金未打印收据，不能挂失", type: "info"});
				return reject();
			}
			if (row.TLostRegistDR > 0) {
				$.messager.popover({msg: "该笔押金已挂失，不能重复挂失", type: "info"});
				return reject();
			}
			depositId = row.TDepRowId;
			resolve();
		});
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", "确认挂失该笔押金？", function (r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	var _lostReg = function() {
		return new Promise(function (resolve, reject) {
			var expStr = lostReason;
			var rtn = $.m({
				ClassName: "BILL.IP.BL.DepLostRegist",
				MethodName: "Regist",
				depositId: depositId,
				userId: PUBLIC_CONSTANT.SESSION.USERID,
				expStr: expStr
			}, false);
			var myAry = rtn.split("^");
			if (myAry[0] == 0) {
				$.messager.popover({msg: "挂失成功", type: "success"});
				return resolve();
			}
			$.messager.popover({msg: "挂失失败：" + (myAry[1] || myAry[0]), type: "error"});
			return reject();
		});
	};
	
	if ($("#btn-lostReg").hasClass("l-btn-disabled")) {
		return;
	}
	$("#btn-lostReg").linkbutton("disable");
	
	var lostReason = getValueById("lostReason");
	var depositId = "";
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_lostReg)
		.then(function() {
			loadLostDepList();
			$("#btn-lostReg").linkbutton("enable");
		}, function() {
			$("#btn-lostReg").linkbutton("enable");
		});
}

/**
* 解挂
*/
function delLostRegClick() {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			var row = $("#lostDepList").datagrid("getSelected");
			if (!row || !row.TDepRowId) {
				$.messager.popover({msg: "请选择要解挂的押金记录", type: "info"});
				return reject();
			}
			if (row.TPayedFlag == "Y") {
				$.messager.popover({msg: "该笔押金已结算，不能解挂", type: "info"});
				return reject();
			}
			rowId = row.TLostRegistDR;
			if (!rowId) {
				$.messager.popover({msg: "该笔押金未挂失，不能解挂", type: "info"});
				return reject();
			}
			resolve();
		});
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", "是否确认解挂该笔押金？", function (r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	var _cancel = function() {
		return new Promise(function (resolve, reject) {
			var expStr = "";
			var rtn = $.m({
				ClassName: "BILL.IP.BL.DepLostRegist",
				MethodName: "Cancel",
				rowId: rowId,
				userId: PUBLIC_CONSTANT.SESSION.USERID,
				expStr: expStr
			}, false);
			var myAry = rtn.split("^");
			if (myAry[0] == 0) {
				$.messager.popover({msg: "解挂成功", type: "success"});					
				return resolve();
			}
			$.messager.popover({msg: "解挂失败：" + (myAry[1] || myAry[0]), type: "error"});
			return reject();
		});
	};
	
	if ($("#btn-delLostReg").hasClass("l-btn-disabled")) {
		return;
	}
	$("#btn-delLostReg").linkbutton("disable");
	
	var rowId = "";
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_cancel)
		.then(function() {
			loadLostDepList();
			$("#btn-delLostReg").linkbutton("enable");
		}, function() {
			$("#btn-delLostReg").linkbutton("enable");
		});
}

function initLostDepDoc() {
	$("#lostDepList").parents(".layout-panel-center").prev(".layout-panel-north").find("input[id],textarea[id]").each(function(index, item) {
		if ($(this).prop("class").indexOf("combobox-f") != -1) {
			$(this).combobox("clear").combobox("reload");
		}else if($(this).prop("class").indexOf("numberbox-f") != -1) {
			$(this).numberbox("clear");
		}else {
			$(this).val("");
		}
	});
}