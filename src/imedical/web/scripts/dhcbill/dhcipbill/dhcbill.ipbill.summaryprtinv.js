/**
 * FileName: dhcbill.ipbill.summaryprtinv.js
 * Author: ZhYW
 * Date: 2021-04-26
 * Description: 住院集中打印发票
 */

$(function () {
	$(document).keydown(function (e) {
		frameEnterKeyCode(e);
	});
	initQueryMenu();
	initPayList();
	initInvList();
});

function initQueryMenu() {
	$HUI.linkbutton("#btn-print", {
		disabled: true,
		onClick: function () {
			printClick();
		}
	});
	
	//跳号
	$HUI.linkbutton("#btn-skipNo", {
		onClick: function () {
			skipNoClick();
		}
	});
	
	$("#stDate, #endDate").datebox({
		onSelect: function(date) {
			GV.PayList.reload();
		}
	});
	
	//就诊科室
	initAdmList();
	
	getReceiptNo();
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
			GV.PayList.reload();
		}
	});
}

/**
 * 快捷键
 */
function frameEnterKeyCode(e) {
	var key = websys_getKey(e);
	switch (key) {
	case 120: //F9
		e.preventDefault();
		printClick();
		break;
	default:
	}
}

function initPayList() {
	GV.PayList = $HUI.datagrid("#payList", {
		fit: true,
		striped: true,
		border: false,
		singleSelect: true,
		checkOnSelect: false,
		selectOnCheck: false,
		rownumbers: false,
		pageSize: 999999999,
		className: "BILL.IP.BL.SummaryPrtInv",
		queryName: "FindPatPayList",
		frozenColumns: [[{field: 'ck', checkbox: true}]],
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["prtDate", "ward", "admDate", "disDate"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if ($.inArray(cm[i].field, ["prtRowId", "adm", "insTypeDR"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (cm[i].field == "prtTime") {
					cm[i].formatter = function(value, row, index) {
						return row.prtDate + " " + value;
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
					if ($.inArray(cm[i].field, ["prtTime", "admTime", "disTime"]) != -1) {
						cm[i].width = 160;
					}
				}
			}
		},
		url: $URL,
		queryParams: {
			ClassName: "BILL.IP.BL.SummaryPrtInv",
			QueryName: "FindPatPayList",
			patientId:  CV.PatientId,
			episodeId: $("#admList").combogrid("getValue"),
			stDate: getValueById("stDate"),
			endDate: getValueById("endDate"),
			sessionStr: getSessionStr(),
			rows: 99999999
		},
		onLoadSuccess: function (data) {
			if (data.total == 0) {
				$(this).datagrid("clearChecked");
			}else {
				$(this).datagrid("checkAll");
			}
		},
		onCheck: function (rowIndex, rowData) {
			checkPayListHandler();
		},
		onUncheck: function (rowIndex, rowData) {
			checkPayListHandler();
		},
		onCheckAll: function (rows) {
			checkPayListHandler();
		},
		onUncheckAll: function (rows) {
			checkPayListHandler();
		}
	});
}

function depositListDtl(row) {
	var argObj = {
		EpisodeID: row.adm,
		PrtRowId: row.prtRowId
	};
	BILL_INF.showChgedDepList(argObj);
}

function checkPayListHandler() {
	var prtRowIdStr = getPrtRowIdStr();
	parseINVInfo(prtRowIdStr);
	$(".layout-panel-south .layout-panel-east").find(".numberbox-f[id]").numberbox("clear");   //清空打印面板numberbox的值
}

function getPrtRowIdStr() {
	return GV.PayList.getChecked().map(function (row) {
		return row.prtRowId;
	}).join("^");
}

function initInvList() {
	GV.InvList = $HUI.datagrid("#invList", {
		width: 400,
		height: 180,
		fitColumns: true,
		singleSelect: true,
		bodyCls: 'panel-header-gray',
		rownumbers: true,
		pageSize: 999999999,
		columns: [[{title: 'prtRowId', field: 'prtRowId', hidden: true},
				   {title: 'insTypeDR', field: 'insTypeDR', hidden: true},
				   {title: '费别', field: 'insType', width: 100},
				   {title: '押金', field: 'depositAmt', width: 110, align: 'right'},
				   {title: '金额', field: 'payAmt', width: 110, align: 'right'},
				   {title: 'insuSum', field: 'insuSum', hidden: true},
				   {title: 'insuPayAmt', field: 'insuPayAmt', hidden: true},
				   {title: 'insuAccPayAmt', field: 'insuAccPayAmt', hidden: true},
				   {title: 'selfPayAmt', field: 'selfPayAmt', hidden: true}
			]],
		onLoadSuccess: function(data) {
			$("#btn-print").linkbutton({disabled: (!(data.total > 0))});
			var totalSum = 0;
			var depositSum = 0;
			var insuTotalSum = 0;
			var insuPaySum = 0;
			var insuAccPaySum = 0;
			var selfPaySum = 0;
			$.each(data.rows, function(index, row) {
				totalSum = Number(totalSum).add(row.payAmt).toFixed(2);
				depositSum = Number(depositSum).add(row.depositAmt).toFixed(2);
				insuTotalSum = Number(insuTotalSum).add(row.insuSum).toFixed(2);
				insuPaySum = Number(insuPaySum).add(row.insuPayAmt).toFixed(2);
				insuAccSum = Number(insuAccPaySum).add(row.insuAccPayAmt).toFixed(2);
				selfPaySum = Number(selfPaySum).add(row.selfPayAmt).toFixed(2);
			});
			setValueById("totalSum", totalSum);
			setValueById("depositSum", depositSum);
			setValueById("insuTotalSum", insuTotalSum);
			setValueById("insuAccPaySum", insuAccPaySum);
			setValueById("insuPaySum", insuPaySum);
			setValueById("selfPaySum", selfPaySum);
		}
	});
}

function getReceiptNo() {
	$.m({
		ClassName: "web.UDHCJFPAY",
		MethodName: "ReadReceiptNO",
		userId: PUBLIC_CONSTANT.SESSION.USERID,
		insTypeId: "",
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	}, function(rtn) {
		var myAry = rtn.split("^");
		if (myAry[0] != 0) {
			disableById("btn-print");
			$.messager.popover({msg: "没有可用发票，请先领取", type: "info"});
			return;
		}
		var currNo = myAry[1];
		var rowId = myAry[2];
		var endNo = myAry[3];
		var title = myAry[4];
		var leftNum = myAry[5];
		var tipFlag = myAry[6];
		var receiptNo = title + "[" + currNo + "]";
		setValueById("receiptNo", receiptNo);
		var color = "green";
		if ($("#receiptNo").hasClass("newClsInvalid")) {
			$("#receiptNo").removeClass("newClsInvalid");
		}
		if (tipFlag == 1) {
			color = "red";
			$("#receiptNo").addClass("newClsInvalid");
		}
		var content = $g("该号段可用票据剩余") + " <font style='font-weight: bold;color: " + color + ";'>" + leftNum + "</font> " + $g("张");
		$("#btn-tip").popover({cache: false, trigger: 'hover', content: content});
	});
}

function parseINVInfo(prtRowIdStr) {
	if (!prtRowIdStr) {
		GV.InvList.loadData({total: 0, rows: []});
		return;
	}
	//这里在后台加载数据是考虑以后业务可能存在集中打印发票和结算小条存在1:n，则需在后台进行拆分
	loadInvList(prtRowIdStr);
}

function loadInvList(prtRowIdStr) {
	var queryParams = {
		ClassName: "BILL.IP.BL.SummaryPrtInv",
		QueryName: "ParPrtToINVList",
		prtRowIdStr: prtRowIdStr,
		sessionStr: getSessionStr(),
		rows: 99999999
	}
	loadDataGridStore("invList", queryParams);
}

/**
* 打印发票
*/
function printClick() {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			prtRowIdStr = GV.InvList.getRows().map(function(row) {
				return row.prtRowId;
			}).join("^");
			if (!prtRowIdStr) {
				$.messager.popover({msg: "没有需要打印的发票", type: "info"});
				return reject();
			}
			resolve();
		});
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", "是否确认打印发票？", function (r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	var _saveInv = function() {
		return new Promise(function (resolve, reject) {
			$.m({
				ClassName: "BILL.IP.BL.SummaryPrtInv",
				MethodName: "APayColPrtUpdate",
				prtRowIdStr: prtRowIdStr,
				sessionStr: getSessionStr()
			}, function (rtn) {
				var myAry = rtn.split("^");
				if (myAry[0] == 0) {
					spiIdStr = myAry.slice(1).join("^");
					$.messager.popover({msg: "打印成功", type: "success"});
					return resolve();
				}
				$.messager.popover({msg: "打印失败：" + (myAry[1] || myAry[0]), type: "error"});
				reject();
			});
		});
	};
	
	var _success = function() {
		summaryInvPrint(spiIdStr);
		clearDocWin();
	};
	
	if ($("#btn-print").linkbutton("options").disabled) {
		return;
	}
	$("#btn-print").linkbutton("disable");
	
	var prtRowIdStr = "";
	var spiIdStr = "";
	
	var spiRowId = "";
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_saveInv)
		.then(function() {
			_success();
			$("#btn-print").linkbutton("enable");
		}, function() {
			$("#btn-print").linkbutton("enable");
		});
}

function clearDocWin() {
	GV.PayList.reload();
	getReceiptNo();
}

/**
* 跳号
*/
function skipNoClick() {
	var argumentObj = {
		receiptType: "IP"
	};
	BILL_INF.showSkipInv(argumentObj).then(getReceiptNo);
}