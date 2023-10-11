�1�3/**
 * FileName: dhcbill.ipbill.summaryreprtinv.js
 * Author: ShangXuehao
 * Date: 2021-05-27
 * Description: סԺ���д�ӡ��Ʊԭ�Ų��� �����ش�
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
					cm[i].title = "���Ҳ���";
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
* ԭ�Ų���
*/
function reprtClick() {
	var row = GV.SPIList.getSelected();
	if (!row || !row.spiRowId) {
		$.messager.popover({msg: "��ѡ����Ҫ����ļ�¼", type: "info"});
		return;
	}
	var spiStr = row.spiRowId + "#" + "R";
	$.messager.confirm("ȷ��", "�Ƿ�ȷ�Ͻ���Ʊ���´�ӡ? ", function (r) {
		if (!r) {
			return;
		}
		summaryInvPrint(spiStr);
	});
}

/**
* �������д�ӡ
*/
function cancelClick() {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			var row = GV.SPIList.getSelected();
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
* �����ش�
*/
function skipClick() {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			var row = GV.SPIList.getSelected();
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