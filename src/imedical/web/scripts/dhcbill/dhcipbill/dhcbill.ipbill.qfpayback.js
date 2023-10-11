/**
 * FileName: dhcbill.ipbill.qfpayback.js
 * Anchor: ZhYW
 * Date: 2019-01-03
 * Description: 欠费补交
 */

var GV = {};

$(function () {
	initQueryMenu();
	initPayList();
});

function initQueryMenu() {
	var defDate = getDefStDate(0);
	$(".datebox-f").datebox("setValue", defDate);
	
	//登记号
	focusById("patientNo");
	$("#patientNo").keydown(function (e) {
		patientNoKeydown(e);
	});
	
	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadPayList();
		}
	});
	
	$HUI.linkbutton("#btn-save", {
		onClick: function () {
			saveClick();
		}
	});
	
	$HUI.linkbutton("#btn-abort", {
		onClick: function () {
			abortClick();
		}
	});
	
	getCurrentNo();
	
	//标志
	$HUI.combobox("#flag", {
		panelHeight: 'auto',
		editable: false,
		disabled: true,
		valueField: 'id',
		textField: 'text',
		data: [{id: 'B', text: '补交', selected: true},
		       {id: 'T', text: '退回'}
		],
		onSelect: function(rec) {
			$("#backAmt").parent().prev().text(rec.text + "金额");
		}
	});
	
	//支付方式
	$HUI.combobox("#paymode", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.UDHCOPGSConfig&QueryName=ReadGSINSPMList&ResultSetType=array',
		method: 'GET',
		editable: false,
		valueField: 'CTPMRowID',
		textField: 'CTPMDesc',
		onBeforeLoad: function(param) {
			param.GPRowID = PUBLIC_CONSTANT.SESSION.GROUPID;
			param.HospID = PUBLIC_CONSTANT.SESSION.HOSPID;
			param.TypeFlag = "DEP";
		}
	});
}

function getCurrentNo() {
	$.m({
		ClassName: "web.UDHCJFQFDEAL",
		MethodName: "GetCurrentNo",
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	}, function (currNo) {
		if (currNo) {
			disableById("currRcptNo");
			setValueById("currRcptNo", currNo);
		}else {
			enableById("currRcptNo");
		}
	});
}

function initPayList() {
	GV.PayList = $HUI.datagrid("#payList", {
		fit: true,
		striped: true,
		border: false,
		singleSelect: true,
		pagination: true,
		pageSize: 20,
		columns:[[{title: '登记号', field: 'Tpapno', width: 120},
				  {title: '姓名', field: 'Tpapname', width: 100},
				  {title: '性别', field: 'Tsex', width: 80},
				  {title: 'Tadmid', field: 'Tadmid', hidden: true},
				  {title: '就诊费别', field: 'Tadmreason', width: 110},
				  {title: '科室病区', field: 'TAdmDept', width: 180,
				    formatter: function (value, row, index) {
						return value + " " + row.TAdmWard;
					}
				  },
				  {title: '结算时间', field: 'TDate', width: 155,
					formatter: function (value, row, index) {
						return value + " " + row.TTime;
					}
				  },
				  {title: '金额', field: 'Tamount', width: 100, align: 'right'},
				  {title: '标志', field: 'Tflag', width: 100},
				  {title: '支付方式', field: 'Tpaymode', width: 100},
				  {title: '票据号', field: 'Tcurrentno', width: 120},
				  {title: '状态', field: 'Tstatus', width: 100},
				  {title: '备注', field: 'Tcomment', width: 120},
				  {title: 'Trowid', field: 'Trowid', hidden: true},
				  {title: 'TBillRowid', field: 'TBillRowid', hidden: true},
				  {title: 'TARRCP', field: 'TARRCP', hidden: true},
				  {title: 'TQFFlag', field: 'TQFFlag', hidden: true}
			]],
		url: $URL,
		queryParams: {
			ClassName: "web.UDHCJFQFDEAL",
			QueryName: "FindQfDetail",
			stDate: getValueById("stDate"), 
			endDate: getValueById("endDate"),
			patientNo: getValueById("patientNo"),
			hospId: PUBLIC_CONSTANT.SESSION.HOSPID
		},
		onSelect: function(index, row) {
			selectRowHandler(index, row);
		}
	});
}

function selectRowHandler(index, row) {
	var billRowId = row.TBillRowid;
	var QFFlag = row.TQFFlag;
	getQFAmount(billRowId, QFFlag);
}

function getQFAmount(billRowId, QFFlag) {
	$("#backAmt").numberbox("clear");
	
	$.m({
		ClassName: "web.UDHCJFQFDEAL",
		MethodName: "getqfamountbill",
		BillNo: billRowId
	}, function(qfAmt) {
		if ((QFFlag == "Q") || (QFFlag == "B")) {
			$("#qfAmt").parent().prev().text("欠费金额");
			$("#flag").combobox("select", "B");
		}else if ((QFFlag == "C") || (QFFlag == "T")) {
			$("#qfAmt").parent().prev().text("结存金额");
			$("#flag").combobox("select", "T");
		}
		setValueById("qfAmt", Math.abs(qfAmt));
	});
}

function loadPayList() {
	var queryParams = {
		ClassName: "web.UDHCJFQFDEAL",
		QueryName: "FindQfDetail",
		stDate: getValueById("stDate"), 
		endDate: getValueById("endDate"),
		patientNo: getValueById("patientNo"),
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	};
	loadDataGridStore("payList", queryParams);
}

function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		$.cm({
			ClassName: "web.UDHCJFQFDEAL",
			MethodName: "GetPatInfo",
			patientNo: getValueById("patientNo")
		}, function(jsonObj) {
			setValueById("patientNo", jsonObj.patientNo);
			setValueById("patName", jsonObj.patName);
			if (jsonObj.patientId) {
				loadPayList();
			}else {
				$.messager.popover({msg: '患者不存在', type: 'info'});
				focusById("patientNo");
			}
		});
	}
}

/**
* 保存
*/
function saveClick() {
	var row = GV.PayList.getSelected();
	if (!row) {
		$.messager.popover({msg: '请先选择需要补交或退回的记录', type: 'info'});
		return;
	}
	var QFFlag = row.TQFFlag;
	if ("QC".indexOf(QFFlag) == -1) {
		$.messager.popover({msg: '您选择的不是欠费或结存记录', type: 'info'});
		return;
	}
	var adm = row.Tadmid;
	if (!adm) {
		$.messager.popover({msg: '就诊号为空', type: 'info'});
		return;
	}
	var arrcp = row.TARRCP;
	if (!arrcp) {
		$.messager.popover({msg: '发票记录为空', type: 'info'});
		return;
	}
	var billRowId = row.TBillRowid;
	if (!billRowId) {
		$.messager.popover({msg: '账单记录为空', type: 'info'});
		return;
	}
	
	if (!checkData()) {
		return;
	}
	
	var qfAmt = getValueById("qfAmt");
	var backAmt = getValueById("backAmt");
	var flag = getValueById("flag");	
	var paymode = getValueById("paymode");
	var currRcptNo = getValueById("currRcptNo");
	var remark = getValueById("remark");
	
	var insStr = adm + "^" + backAmt + "^" + flag + "^" + paymode;
	insStr += "^" + remark + "^" + currRcptNo + "^" + arrcp + "^" + billRowId;
	$.messager.confirm("确认", "确认保存？", function(r) {
		if (r) {
			$.m({
				ClassName: "web.UDHCJFQFDEAL",
				MethodName: "Insert",
				str: insStr,
				sessionStr: getSessionStr()
			}, function(rtn) {
				var myAry = rtn.split("^");
				switch(myAry[0]) {
				case "0":
					$.messager.popover({msg: '保存成功', type: 'success'});
					GV.PayList.reload();
					getCurrentNo();
					arrBackPrint(myAry[1]);
					break;
				case "-1":
					$.messager.popover({msg: '不能选择' + $("#paymode").combobox("getText") + "支付方式" + $("#flag").combobox("getText"), type: 'info'});
					break;
				case "InvNull":
					$.messager.popover({msg: '对应发票不存在', type: 'error'});
					break;
				default:
					$.messager.popover({msg: '保存失败：' + myAry[0], type: 'error'});
				}
			});
		}
	});
}

function checkData() {
	var bool = true;
	$(".validatebox-text").each(function(index, item) {
		if (!$(this).validatebox("isValid")) {
			bool = false;
			return false;
		}
	});
	if (!bool) {
		return bool;
	}
	
	var flag = getValueById("flag");
	if (!flag) {
		$.messager.popover({msg: '请选择标志', type: 'info'});
		return false;
	}
	var qfAmt = getValueById("qfAmt");
	if (qfAmt == 0) {
		$.messager.popover({msg: '该患者没有' + $("#qfAmt").parent().prev().text().slice(0,2) + '，不需要' + $("#flag").combobox("getText"), type: 'info'});
		return false;
	}

	var backAmt = getValueById("backAmt");
	if (!(+backAmt > 0)) {
		$.messager.popover({msg: '请输入有效的' + $("#backAmt").parent().prev().text(), type: 'info'});
		focusById("backAmt");
		return false;
	}
	if (+backAmt > +qfAmt) {
		$.messager.popover({msg: ($("#backAmt").parent().prev().text() + '不能大于' + $("#qfAmt").parent().prev().text()), type: 'info'});
		focusById("backAmt");
		return false;
	}
	var paymode = getValueById("paymode");
	if (!paymode) {
		$.messager.popover({msg: '请选择支付方式', type: 'info'});
		return false;
	}
	var currRcptNo = getValueById("currRcptNo");
	if (!currRcptNo) {
		$.messager.popover({msg: '当前票号为空，请先维护票号', type: 'info'});
		return false;
	}
	
	return true;
}

/**
* 作废
*/
function abortClick() {
	var row = GV.PayList.getSelected();
	if (!row) {
		$.messager.popover({msg: '请选择要作废的记录', type: 'info'});
		return;
	}
	var rowId = row.Trowid;
	if (!rowId) {
		$.messager.popover({msg: '记录号为空', type: 'info'});
		return;
	}
	$.messager.confirm("确认", "确认作废？", function(r) {
		if (r) {
			$.m({
				ClassName: "web.UDHCJFQFDEAL",
				MethodName: "Abort",
				QFRowId: rowId,
				UserId: PUBLIC_CONSTANT.SESSION.USERID
			}, function(rtn) {
				var myAry = rtn.split("^");
				if (myAry[0] == 0) {
					$.messager.popover({msg: '作废成功', type: 'success'});
					GV.PayList.reload();
				}else {
					$.messager.popover({msg: '作废失败：' + myAry[1], type: 'error'});
				}
			});
		}
	});
}