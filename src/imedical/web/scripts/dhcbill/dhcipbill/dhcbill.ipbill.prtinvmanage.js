/**
 * FileName: dhcbill.ipbill.prtinvmanage.js
 * Author: WangXQ
 * Date: 2023-02-21
 * Description: 发票打印管理
 */

$(function () {
	initQueryMenu();
	initPayList();
});

function initQueryMenu() {
	$("#stDate, #endDate").datebox({
		onSelect: function(date) {
			GV.PayList.reload();
		}
	});

	//原号补打
	$HUI.linkbutton("#btn-reprint", {
		onClick: function () {
			reprtClick();
		}
	});

	//过号重打
	$HUI.linkbutton("#btn-skipPrint", {
		onClick: function () {
			skipClick();
		}
	});

	//打印台账
	$HUI.linkbutton("#btn-PtLedger", {
		onClick: function () {
			printPtLedger();
		}
	});

	//票据遗失证明
	$HUI.linkbutton("#btn-loseProve", {
		onClick: function () {
			loseProveClick();
		}
	});

	//医保结算单
	$HUI.linkbutton("#btn-printInsuJSD", {
		onClick: function () {
			printInsuJSDClick();
		}
	});
	
	//撤销集中打印
	$HUI.linkbutton("#btn-canclePrint", {
		onClick: function () {
			cancelClick();
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
			GV.PayList.reload();
		}
	});
}

function initPayList() {
	GV.PayList = $HUI.datagrid("#payList", {
		fit: true,
		border: false,
		singleSelect: true,
		rownumbers: true,
		pagination: true,
		pageSize: 20,
		className: "BILL.IP.BL.SummaryPrtInv",
		queryName: "QryPatInvList",
		frozenColumns: [[{field: 'ck', checkbox: true}]],
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["prtDate", "ward", "admDate", "disDate"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if ($.inArray(cm[i].field, ["prtRowId", "adm", "insTypeDR","spiDate","spiFlag","admDR","spiRowId","prtRowId","TabFlag"]) != -1) {
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
				if (cm[i].field == "bed") {
					cm[i].title = "床号";
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
				if (cm[i].field == "spiTime") {
					cm[i].formatter = function(value, row, index) {
						return row.spiDate + " " + value;
					};
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if (cm[i].field == "dept") {
						cm[i].width = 200;
					}
					if ($.inArray(cm[i].field, ["prtTime", "admTime", "disTime","invNo","spiTime"]) != -1) {
						cm[i].width = 160;
					}
				}
			}
		},
		url: $URL,
		queryParams: {
			ClassName: "BILL.IP.BL.SummaryPrtInv",
			QueryName: "QryPatInvList",
			patientId:  CV.PatientId,
			episodeId: $("#admList").combogrid("getValue"),
			stDate: getValueById("stDate"),
			endDate: getValueById("endDate"),
			sessionStr: getSessionStr()
		},
		onCheck: function (index, row) {
			isDisableBtn(row);
		}
	});
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
	var row = GV.PayList.getSelected();
	if (!row) {
		$.messager.popover({msg: "请选择需要补打的记录", type: "info"});
		return;
	}
	if (row.TabFlag == "Summary") {
		var spiStr = row.spiRowId + "#" + "R";
		$.messager.confirm("确认", "是否确认将发票重新打印? ", function (r) {
			if (!r) {
				return;
			}
			summaryInvPrint(spiStr);
		});
	}else{
		rePrintInvClick(row);
	}
}

/**
 * 非集中打印发票原号补打
 */
function rePrintInvClick(row) {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			if (!(row.prtRowId > 0)) {
				$.messager.popover({msg: "账单未结算，不能补打发票", type: "info"});
				return reject();
			}
			var jsonObj = getPersistClsObj("User.DHCINVPRTZY", row.prtRowId);
			if ($.inArray(jsonObj.PRTFlag, ["N", "I"]) == -1) {
				$.messager.popover({msg: "该发票已退费，不能补打发票", type: "info"});
				return reject();
			}
			resolve();
		});
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", "确定要补打发票？", function (r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(function() {
			inpatInvPrint(row.prtRowId + "#" + "R");  //R为补打标识
		});
}

/**
* 打印票据遗失证明
*/
function loseProveClick() {
	var row = GV.PayList.getSelected();
	if (!(row.prtRowId > 0)) {
		$.messager.popover({msg: "账单未结算，不能打印", type: "info"});
		return;
	}
	var prtInvNo = row.invNo;
	if (!prtInvNo) {
		$.messager.popover({msg: "发票号为空，不能打印", type: "info"});
		return;
	}
	var fileName = "DHCBILL-IPBILL-PJYSZM.rpx" + "&prtRowId="+ row.prtRowId;
	DHCCPM_RQPrint(fileName, 900, 600);
}

/**
 * 打印台账
 */
function printPtLedger() {
	var row = GV.PayList.getSelected();
	if (!row.bill) {
		$.messager.popover({msg: "请选择账单", type: "info"});
		return;
	}
	var params = "&billId=" + row.bill;
	var fileName = "DHCBILL-IPBILL-Ledger.rpx" + params;
	DHCCPM_RQPrint(fileName, 900, 600);
}

/**
* 打印医保结算单
*/
function printInsuJSDClick() {
	var row = GV.PayList.getSelected();
	if (!row.bill) {
		$.messager.popover({msg: "请选择账单", type: "info"});
		return;
	}
	var admReaAry = getAdmReason(row.bill);
	var insTypeId = admReaAry[0];
	var nationalCode = admReaAry[1];
	if (!(nationalCode > 0)) {
		$.messager.popover({msg: "非医保患者，不能打印医保结算单", type: "info"});
		return;
	}
	if (!isChgedBill(row.bill)) {
		$.messager.popover({msg: "此账单未结算，不能打印医保结算单", type: "info"});
		return;
	}
	InsuIPJSDPrint(0, PUBLIC_CONSTANT.SESSION.USERID, row.bill, nationalCode, insTypeId, "");
}

function skipClick() {
	var row = GV.PayList.getSelected();
	if (!row) {
		$.messager.popover({msg: "请选择需要过号重打的记录", type: "info"});
		return;
	}
	if (row.TabFlag == "PRT") {
		skipInv(row);
	}else {
		skipSummaryInv(row);
	}
}

function skipInv(row) {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			if (!(row.prtRowId > 0)) {
				$.messager.popover({msg: "账单未结算，不能过号重打", type: "info"});
				return reject();
			}
			var invJson = getPersistClsObj("User.DHCINVPRTZY", row.prtRowId);
			prtInvNo = invJson.PRTinv;
			if (!prtInvNo) {
				$.messager.popover({msg: "发票号为空，不能过号重打", type: "info"});
				return reject();
			}
			if (invJson.PRTUsr != PUBLIC_CONSTANT.SESSION.USERID) {
				$.messager.popover({msg: "非您本人打印的发票，不能过号重打", type: "info"});
				return reject();
			}
			resolve();
		});
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", ($g("是否确认将发票") + "【<font color=\"red\">" + prtInvNo + "</font>】" + $g("过号重打? ")), function (r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	/**
	* 过号重打
	*/
	var _reprint = function() {
		return new Promise(function (resolve, reject) {
			$.m({
				ClassName: "BILL.IP.BL.PrtInv",
				MethodName: "PrtSkipNoReprint",
				prtRowId: row.prtRowId,
				sessionStr: getSessionStr()
			}, function(rtn) {
				var myAry = rtn.split("^");
				if (myAry[0] == 0) {
					$.messager.popover({msg: "过号重打成功", type: "success"});
					return resolve();
				}
				$.messager.popover({msg: "过号重打失败：" + (myAry[1] || myAry[0]), type: "error"});
				return reject();
			});
		});
	};
	
	/**
	* 过号重打成功后重新加载账单列表
	*/
	var _success = function () {
		GV.PayList.reload();
		checkInv();    //设置新的发票号
		var invPrintFlag = getPropValById("DHC_INVPRTZY", row.prtRowId, "PRT_INVPrintFlag");
		if (invPrintFlag == "P") {
			inpatInvPrint(row.prtRowId + "#" + "");
		}
	};
	
	if ($("#btn-skipPrint").linkbutton("options").disabled) {
		return;
	}
	$("#btn-skipPrint").linkbutton("disable");
	
	var prtInvNo = "";
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_reprint)
		.then(function() {
			_success();
		});
}

/**
* 集中打印发票过号重打
*/
function skipSummaryInv(row) {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
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
		GV.PayList.reload();
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
		});
}


/**
* 撤销集中打印
*/
function cancelClick() {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			var row = GV.PayList.getSelected();
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
		GV.PayList.reload();
	};
		
	var spiRowId = "";
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_cancel)
		.then(function() {
			_success();
		});
}

/**
 * 获取账单的费别 ID 和 NationalCode
 */
function getAdmReason(BillNo) {
	if (!BillNo) {
		return new Array("", "", "", "");
	}
	var rtn = $.m({ClassName: "web.UDHCJFPAY", MethodName: "GetBillReaNationCode", BillNo: BillNo}, false);
	return rtn.split("^");
}

/**
* 判断账单是否已结算
*/
function isChgedBill(billId) {
	return ($.m({ClassName: "BILL.IP.COM.Method", MethodName: "GetPrtInvIdByBill", billId: billId}, false) > 0);
}

//是否禁用按钮
function isDisableBtn(row) {
	if (row.invNo){
		enableById("btn-reprint");
		enableById("btn-skipPrint");
		enableById("btn-loseProve");
	}else {
		disableById("btn-reprint");
		disableById("btn-skipPrint");
		disableById("btn-loseProve");
	}
	if (row.TabFlag=="Summary"){
		enableById("btn-canclePrint");
	}else {
		disableById("btn-canclePrint");
	}
}
