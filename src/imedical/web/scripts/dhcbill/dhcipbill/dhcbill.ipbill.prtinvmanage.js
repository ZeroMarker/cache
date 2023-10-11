/**
 * FileName: dhcbill.ipbill.prtinvmanage.js
 * Author: WangXQ
 * Date: 2023-02-21
 * Description: ��Ʊ��ӡ����
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

	//ԭ�Ų���
	$HUI.linkbutton("#btn-reprint", {
		onClick: function () {
			reprtClick();
		}
	});

	//�����ش�
	$HUI.linkbutton("#btn-skipPrint", {
		onClick: function () {
			skipClick();
		}
	});

	//��ӡ̨��
	$HUI.linkbutton("#btn-PtLedger", {
		onClick: function () {
			printPtLedger();
		}
	});

	//Ʊ����ʧ֤��
	$HUI.linkbutton("#btn-loseProve", {
		onClick: function () {
			loseProveClick();
		}
	});

	//ҽ�����㵥
	$HUI.linkbutton("#btn-printInsuJSD", {
		onClick: function () {
			printInsuJSDClick();
		}
	});
	
	//�������д�ӡ
	$HUI.linkbutton("#btn-canclePrint", {
		onClick: function () {
			cancelClick();
		}
	});

	//�������
	initAdmList();
}

/**
* �����������ݱ��
*/
function initAdmList() {
	$HUI.combogrid("#admList", {
		panelWidth: 530,
		panelHeight: 200,
		idField: 'TAdm',
		textField: 'TDept',
		columns: [[{field: 'TAdm', title: 'TAdm', hidden: true},
				   {field: 'TAdmDate', title: '��Ժʱ��', width: 150,
				    formatter: function(value, row, index) {
					    if (value) {
							return value + " " + row.TAdmTime;
						}
					}
				   },
				   {field: 'TDept', title: '�������', width: 90},
				   {field: 'TWard', title: '���ﲡ��', width: 130},
				   {field: 'TDischDate', title: '��Ժʱ��', width: 150,
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
					cm[i].title = "���Ҳ���";
					cm[i].formatter = function(value, row, index) {
						return value + " " + row.ward;
					};
				}
				if (cm[i].field == "bed") {
					cm[i].title = "����";
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
* ԭ�Ų���
*/
function reprtClick() {
	var row = GV.PayList.getSelected();
	if (!row) {
		$.messager.popover({msg: "��ѡ����Ҫ����ļ�¼", type: "info"});
		return;
	}
	if (row.TabFlag == "Summary") {
		var spiStr = row.spiRowId + "#" + "R";
		$.messager.confirm("ȷ��", "�Ƿ�ȷ�Ͻ���Ʊ���´�ӡ? ", function (r) {
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
 * �Ǽ��д�ӡ��Ʊԭ�Ų���
 */
function rePrintInvClick(row) {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			if (!(row.prtRowId > 0)) {
				$.messager.popover({msg: "�˵�δ���㣬���ܲ���Ʊ", type: "info"});
				return reject();
			}
			var jsonObj = getPersistClsObj("User.DHCINVPRTZY", row.prtRowId);
			if ($.inArray(jsonObj.PRTFlag, ["N", "I"]) == -1) {
				$.messager.popover({msg: "�÷�Ʊ���˷ѣ����ܲ���Ʊ", type: "info"});
				return reject();
			}
			resolve();
		});
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("ȷ��", "ȷ��Ҫ����Ʊ��", function (r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(function() {
			inpatInvPrint(row.prtRowId + "#" + "R");  //RΪ�����ʶ
		});
}

/**
* ��ӡƱ����ʧ֤��
*/
function loseProveClick() {
	var row = GV.PayList.getSelected();
	if (!(row.prtRowId > 0)) {
		$.messager.popover({msg: "�˵�δ���㣬���ܴ�ӡ", type: "info"});
		return;
	}
	var prtInvNo = row.invNo;
	if (!prtInvNo) {
		$.messager.popover({msg: "��Ʊ��Ϊ�գ����ܴ�ӡ", type: "info"});
		return;
	}
	var fileName = "DHCBILL-IPBILL-PJYSZM.rpx" + "&prtRowId="+ row.prtRowId;
	DHCCPM_RQPrint(fileName, 900, 600);
}

/**
 * ��ӡ̨��
 */
function printPtLedger() {
	var row = GV.PayList.getSelected();
	if (!row.bill) {
		$.messager.popover({msg: "��ѡ���˵�", type: "info"});
		return;
	}
	var params = "&billId=" + row.bill;
	var fileName = "DHCBILL-IPBILL-Ledger.rpx" + params;
	DHCCPM_RQPrint(fileName, 900, 600);
}

/**
* ��ӡҽ�����㵥
*/
function printInsuJSDClick() {
	var row = GV.PayList.getSelected();
	if (!row.bill) {
		$.messager.popover({msg: "��ѡ���˵�", type: "info"});
		return;
	}
	var admReaAry = getAdmReason(row.bill);
	var insTypeId = admReaAry[0];
	var nationalCode = admReaAry[1];
	if (!(nationalCode > 0)) {
		$.messager.popover({msg: "��ҽ�����ߣ����ܴ�ӡҽ�����㵥", type: "info"});
		return;
	}
	if (!isChgedBill(row.bill)) {
		$.messager.popover({msg: "���˵�δ���㣬���ܴ�ӡҽ�����㵥", type: "info"});
		return;
	}
	InsuIPJSDPrint(0, PUBLIC_CONSTANT.SESSION.USERID, row.bill, nationalCode, insTypeId, "");
}

function skipClick() {
	var row = GV.PayList.getSelected();
	if (!row) {
		$.messager.popover({msg: "��ѡ����Ҫ�����ش�ļ�¼", type: "info"});
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
				$.messager.popover({msg: "�˵�δ���㣬���ܹ����ش�", type: "info"});
				return reject();
			}
			var invJson = getPersistClsObj("User.DHCINVPRTZY", row.prtRowId);
			prtInvNo = invJson.PRTinv;
			if (!prtInvNo) {
				$.messager.popover({msg: "��Ʊ��Ϊ�գ����ܹ����ش�", type: "info"});
				return reject();
			}
			if (invJson.PRTUsr != PUBLIC_CONSTANT.SESSION.USERID) {
				$.messager.popover({msg: "�������˴�ӡ�ķ�Ʊ�����ܹ����ش�", type: "info"});
				return reject();
			}
			resolve();
		});
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("ȷ��", ($g("�Ƿ�ȷ�Ͻ���Ʊ") + "��<font color=\"red\">" + prtInvNo + "</font>��" + $g("�����ش�? ")), function (r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	/**
	* �����ش�
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
					$.messager.popover({msg: "�����ش�ɹ�", type: "success"});
					return resolve();
				}
				$.messager.popover({msg: "�����ش�ʧ�ܣ�" + (myAry[1] || myAry[0]), type: "error"});
				return reject();
			});
		});
	};
	
	/**
	* �����ش�ɹ������¼����˵��б�
	*/
	var _success = function () {
		GV.PayList.reload();
		checkInv();    //�����µķ�Ʊ��
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
* ���д�ӡ��Ʊ�����ش�
*/
function skipSummaryInv(row) {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			if (!row || !row.spiRowId) {
				$.messager.popover({msg: "��ѡ����Ҫ�������д�ӡ�ļ�¼", type: "info"});
				return reject();
			}
			spiRowId = row.spiRowId;
			var invJson = getPersistClsObj("BILL.IP.SummaryPrtInv", spiRowId);
			receiptNo = invJson.SPIInvNo;
			if (!receiptNo) {
				$.messager.popover({msg: "��Ʊ��Ϊ�գ����ܹ����ش�", type: "info"});
				return reject();
			}
			if (invJson.SPIUserDR != PUBLIC_CONSTANT.SESSION.USERID) {
				$.messager.popover({msg: "�������˴�ӡ�ķ�Ʊ�����ܹ����ش�", type: "info"});
				return reject();
			}
			resolve();
		});
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("ȷ��", ($g("�Ƿ�ȷ�Ͻ���Ʊ") + "��<font color=\"red\">" + receiptNo + "</font>��" + $g("�����ش�? ")), function (r) {
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
					$.messager.popover({msg: "���Ų���Ʊ�ɹ�", type: "success"});	
					return resolve();
				}
				$.messager.popover({msg: "�����ش�ʧ�ܣ�" + (myAry[1] || myAry[0]), type: "error"});
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
* �������д�ӡ
*/
function cancelClick() {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			var row = GV.PayList.getSelected();
			if (!row || !row.spiRowId) {
				$.messager.popover({msg: "��ѡ����Ҫ�������д�ӡ�ļ�¼", type: "info"});
				return reject();
			}
			
			spiRowId = row.spiRowId;
			resolve();
		});
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("ȷ��", "�Ƿ�ȷ�ϳ������д�ӡ? ", function (r) {
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
					$.messager.popover({msg: "�����ɹ�", type: "success"});	
					return resolve();
				}
				$.messager.popover({msg: "����ʧ�ܣ�" + (myAry[1] || myAry[0]), type: "error"});
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
 * ��ȡ�˵��ķѱ� ID �� NationalCode
 */
function getAdmReason(BillNo) {
	if (!BillNo) {
		return new Array("", "", "", "");
	}
	var rtn = $.m({ClassName: "web.UDHCJFPAY", MethodName: "GetBillReaNationCode", BillNo: BillNo}, false);
	return rtn.split("^");
}

/**
* �ж��˵��Ƿ��ѽ���
*/
function isChgedBill(billId) {
	return ($.m({ClassName: "BILL.IP.COM.Method", MethodName: "GetPrtInvIdByBill", billId: billId}, false) > 0);
}

//�Ƿ���ð�ť
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
