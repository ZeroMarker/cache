﻿/**
 * FileName: dhcbill.ipbill.summaryreprtinv.js
 * Author: ShangXuehao
 * Date: 2021-05-27
 * Description: 住院集中打印发票原号补打 过号重打
 */

$(function () {
	initQueryMenu();
	iniSPIList();
});

function initQueryMenu() {
	$HUI.linkbutton("#btn-print", {
		onClick: function () {
			reprtClick();
		}
	});
	
	$HUI.linkbutton("#btn-skipPrint", {
		onClick: function () {
			skipClick();
		}
	});
	
	$HUI.linkbutton("#btn-canclePrint", {
		onClick: function () {
			cancelClick();
		}
	});
	
	$("#stDate, #endDate").datebox({
		onSelect: function(date) {
			GV.SPIList.reload();
		}
	});
	
	//就诊科室
	initAdmList();
}

/**
* 就诊下拉数据表格
*/
function initAdmList() {
	$HUI.combogrid("#admList", {
		panelWidth: 530,
		panelHeight: 200,
		idField: 'TAdm',
		textField: 'TDept',
		columns: [[{field: 'TAdm', title: 'TAdm', hidden: true},
				   {field: 'TAdmDate', title: '入院时间', width: 150,
				    formatter: function(value, row, index) {
					    if (value) {
							return value + " " + row.TAdmTime;
						}
					}
				   },
				   {field: 'TDept', title: '就诊科室', width: 90},
				   {field: 'TWard', title: '就诊病区', width: 130},
				   {field: 'TDischDate', title: '出院时间', width: 150,
				   	formatter: function(value, row, index) {
					    if (value) {
							return value + " " + row.TDischTime;
						}
					}
				   }
			]],
		url: $URL,
		queryParams: {
			ClassName: "web.DHCIPBillCashier",
			QueryName: "SearchAdm",
			papmi: CV.PatientId,
			sessionStr: getSessionStr()
		},
		onChange: function (newValue, oldValue) {
			GV.SPIList.reload();
		}
	});
}

function iniSPIList() {
	GV.SPIList = $HUI.datagrid("#spiList", {
		fit: true,
		border: false,
		singleSelect: true,
		pagination: true,
		pageSize: 20,
		idField: 'spiRowId',
		className: 'BILL.IP.BL.SummaryPrtInv',
		queryName: 'FindPatSummaryInvList',
		frozenColumns: [[{field: 'ck', checkbox: true}]],
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["spiDate", "ward", "admDate", "disDate"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if ($.inArray(cm[i].field, ["spiRowId", "admDR", "prtRowId", "spiFlag"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (cm[i].field == "spiTime") {
					cm[i].formatter = function(value, row, index) {
						return row.spiDate + " " + value;
					};
				}
				if (cm[i].field == "depositAmt") {
					cm[i].formatter = function(value, row, index) {
						if (value) {
							return "<a href='javascript:;' onclick='depositListDtl(" + JSON.stringify(row) + ")'>" + value + "</a>";
						}
					};
				}
				if (cm[i].field == "dept") {
					cm[i].title = "科室病区";
					cm[i].formatter = function(value, row, index) {
						return value + " " + row.ward;
					};
				}
				if (cm[i].field == "admTime") {
					cm[i].formatter = function(value, row, index) {
						return row.admDate + " " + value;
					};
				}
				if (cm[i].field == "disTime") {
					cm[i].formatter = function(value, row, index) {
						return row.disDate + " " + value;
					};
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if (cm[i].field == "dept") {
						cm[i].width = 200;
					}
					if ($.inArray(cm[i].field, ["spiTime", "admTime", "disTime"]) != -1) {
						cm[i].width = 160;
					}
				}
			}
		},
		url: $URL,
		queryParams: {
			ClassName: "BILL.IP.BL.SummaryPrtInv",
			QueryName: "FindPatSummaryInvList",
			stDate: getValueById("stDate"),
			endDate: getValueById("endDate"),
			patientId: CV.PatientId,
			episodeId: $("#admList").combogrid("getValue"),
			sessionStr: getSessionStr()
		},
		onLoadSuccess: function(data) {
			GV.SPIList.clearChecked();
		}
	});
}

function loadSPIList() {
	var queryParams = {
		ClassName: "BILL.IP.BL.SummaryPrtInv",
		QueryName: "FindPatSummaryInvList",
		stDate: getValueById("stDate"),
		endDate: getValueById("endDate"),
		patientId: CV.PatientId,
		episodeId: $("#admList").combogrid("getValue"),
		sessionStr: getSessionStr()
	}
	loadDataGridStore("spiList", queryParams);
}

function depositListDtl(row) {
	var argObj = {
		EpisodeID: row.admDR,
		PrtRowId: row.prtRowId
	};
	BILL_INF.showChgedDepList(argObj);
}

/**
* 原号补打
*/
function reprtClick() {
	var row = GV.SPIList.getSelected();
	if (!row || !row.spiRowId) {
		$.messager.popover({msg: "请选择需要补打的记录", type: "info"});
		return;
	}
	var spiStr = row.spiRowId + "#" + "R";
	$.messager.confirm("确认", "是否确认将发票重新打印? ", function (r) {
		if (!r) {
			return;
		}
		summaryInvPrint(spiStr);
	});
}

/**
* 撤销集中打印
*/
function cancelClick() {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			var row = GV.SPIList.getSelected();
			if (!row || !row.spiRowId) {
				$.messager.popover({msg: "请选择需要撤销集中打印的记录", type: "info"});
				return reject();
			}
			spiRowId = row.spiRowId;
			resolve();
		});
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", "是否确认撤销集中打印? ", function (r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	var _cancel = function() {
		return new Promise(function (resolve, reject) {
			$.m({
				ClassName: "BILL.IP.BL.SummaryPrtInv",
				MethodName: "WriteOffSPI",
				spiRowId: spiRowId,
				sessionStr: getSessionStr()
			}, function(rtn) {
				var myAry = rtn.split("^");
				if (myAry[0] == 0) {
					$.messager.popover({msg: "撤销成功", type: "success"});	
					return resolve();
				}
				$.messager.popover({msg: "撤销失败：" + (myAry[1] || myAry[0]), type: "error"});
				reject();
			});
		});
	};
	
	var _success = function() {
		loadSPIList();
	};
		
	if ($("#btn-canclePrint").linkbutton("options").disabled) {
		return;
	}
	$("#btn-canclePrint").linkbutton("disable");
	
	var spiRowId = "";
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_cancel)
		.then(function() {
			_success();
			$("#btn-canclePrint").linkbutton("enable");
		}, function() {
			$("#btn-canclePrint").linkbutton("enable");
		});
}

/**
* 过号重打
*/
function skipClick() {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			var row = GV.SPIList.getSelected();
			if (!row || !row.spiRowId) {
				$.messager.popover({msg: "请选择需要撤销集中打印的记录", type: "info"});
				return reject();
			}
			spiRowId = row.spiRowId;
			var invJson = getPersistClsObj("BILL.IP.SummaryPrtInv", spiRowId);
			receiptNo = invJson.SPIInvNo;
			if (!receiptNo) {
				$.messager.popover({msg: "发票号为空，不能过号重打", type: "info"});
				return reject();
			}
			if (invJson.SPIUserDR != PUBLIC_CONSTANT.SESSION.USERID) {
				$.messager.popover({msg: "非您本人打印的发票，不能过号重打", type: "info"});
				return reject();
			}
			resolve();
		});
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", ($g("是否确认将发票") + "【<font color=\"red\">" + receiptNo + "</font>】" + $g("过号重打? ")), function (r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	var _skip = function() {
		return new Promise(function (resolve, reject) {
			$.m({
				ClassName: "BILL.IP.BL.SummaryPrtInv",
				MethodName: "SPISkipPrint",
				spiRowId: spiRowId,
				sessionStr: getSessionStr()
			}, function(rtn) {
				var myAry = rtn.split("^");
				if (myAry[0] == 0) {
					$.messager.popover({msg: "过号补打发票成功", type: "success"});	
					return resolve();
				}
				$.messager.popover({msg: "过号重打失败：" + (myAry[1] || myAry[0]), type: "error"});
				reject();
			});
		});
	};
	
	var _success = function() {
		summaryInvPrint(spiRowId);
		loadSPIList();
	};
	
	if ($("#btn-skipPrint").linkbutton("options").disabled) {
		return;
	}
	$("#btn-skipPrint").linkbutton("disable");
	
	var spiRowId = "";
	var receiptNo = "";
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_skip)
		.then(function() {
			_success();
			$("#btn-skipPrint").linkbutton("enable");
		}, function() {
			$("#btn-skipPrint").linkbutton("enable");
		});
}