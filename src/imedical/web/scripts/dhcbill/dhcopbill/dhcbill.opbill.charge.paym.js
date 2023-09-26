/**
 * FileName: dhcbill.opbill.charge.paym.js
 * Anchor: ZhYW
 * Date: 2019-06-19
 * Description: 多种支付方式
 */

var GV = {
	EditRowIndex: undefined
}

/*
 * 验证输入的收费金额
 */
$.extend($.fn.validatebox.defaults.rules, {
	checkBillPMAmt: {
		validator: function (value, param) {
			var curRow = $(this).parents(".datagrid-row").attr("datagrid-row-index") || "";
			if (curRow) {
				var rowData = GV.BillPayMList.getRows()[curRow];
				var paymCode = rowData.CTPMCode;
				var paymSum = getOtherEditIdxPaymSum(curRow, paymCode);
				return (getValueById("winPatShareAmt") >= +numCompute(paymSum, value, "+"));
			}
		},
		message: "支付金额不能大于自付金额"
	}
});

$(function () {
	initWinMenu(getParam("prtRowIdStr"));
});

function initWinMenu(prtRowIdStr) {
	//确定
	$HUI.linkbutton("#win-btn-ok", {
		onClick: function () {
			confirmClick(prtRowIdStr);
		}
	});
	
	//计算器
	$HUI.linkbutton("#win-btn-calc", {
		onClick: function () {
			var calc = new ActiveXObject("WScript.shell");
    		calc.Run("calc");
		}
	});
	
	//实付
	$("#winActualMoney").keydown(function (e) {
		winActualMoneyKeydown(e);
	});
		
	initChargePayMList(prtRowIdStr);
	
	$.m({
		ClassName: "web.DHCOPBillManyPaymentLogic",
		MethodName: "GetPatFeeInfoByPrtRowid",
		prtRowidStr: prtRowIdStr
	}, function(rtn) {
		var myAry = rtn.split("^");
		setValueById("winPatShareAmt", myAry[1]);
	});
}

function initChargePayMList(prtRowIdStr) {
	GV.BillPayMList = $HUI.datagrid("#billPaymList", {
		fit: true,
		title: '支付信息',
		iconCls: 'icon-fee',
		headerCls: 'panel-header-gray',
		checkOnSelect: false,
		selectOnCheck: false,
		singleSelect: true,
		autoRowHeight: false,
		fitColumns: true,
		url: $URL,
		toolbar: [],
		pageSize: 999999999,
		columns: [[{title: '支付方式', field: 'CTPMDesc', width: 150,
					editor: {
						type: 'combobox',
						options: {
							panelHeight: 130,
							valueField: 'CTPMDesc',
							textField: 'CTPMDesc',
							url: $URL + '?ClassName=web.DHCOPBillManyPaymentLogic&QueryName=ReadGSINSPMList&ResultSetType=array',
							required: false,
							editable: false,
							onBeforeLoad: function (param) {
								param.PrtRowIdStr = prtRowIdStr,
								param.GPRowID = PUBLIC_CONSTANT.SESSION.GROUPID;
								param.HospID = PUBLIC_CONSTANT.SESSION.HOSPID;
								param.InsType = "";
							},
							onSelect: function (record) {
								paymComboSelect(record, this);
							}
						}
					}},
				   {title: '金额', field: 'CTPMAmt', width: 180, align: 'right',
					editor: {
						type: 'numberbox',
						options: {
							min: 0,
							precision: 2,
							validType: 'checkBillPMAmt'
						}
					}},
				 {title: 'CTPMCode', field: 'CTPMCode', hidden: true},
				 {title: 'CTPMRowID', field: 'CTPMRowID', hidden: true}
			]],
		queryParams: {
			ClassName: "web.DHCOPBillManyPaymentLogic",
			QueryName: "FindInvGSINSPMList",
			PrtRowIdStr: prtRowIdStr,
			GPRowID: PUBLIC_CONSTANT.SESSION.GROUPID,
			HospID: PUBLIC_CONSTANT.SESSION.HOSPID,
			InsType: "",
			rows: 99999999
		},
		onLoadSuccess: function(data) {
			$.each(data.rows, function (index, row) {
				GV.BillPayMList.beginEdit(index);
			});
			$("#billPaymList [field='CTPMAmt'] .datagrid-editable-input,.numberbox-f").on("keydown", function(e) {
				billPaymKeydown(e);
			});
			$("#billPaymList [field='CTPMAmt'] .datagrid-editable-input,.numberbox-f").on("focus", function(e) {
				billPaymFocus(e);
			});
		},
		onClickRow: function (index, row) {
			GV.BillPayMList.beginEdit(index);
			var ed = GV.BillPayMList.getEditor({
				index: index,
				field: "CTPMAmt"
			});
			if (ed) {
				setTimeout(function() {
					$(ed.target).focus();
				});
			}
		}
	});
}

/**
 * 支付方式下拉框选中事件
 */
function paymComboSelect(record, target) {
	if (record) {
		var index = $(target).parents("tr").parents("tr").attr("datagrid-row-index");
		if (!index) {
			return;
		}
		GV.BillPayMList.getRows()[index]["CTPMCode"] = record.CTPMCode;
		GV.BillPayMList.getRows()[index]["CTPMRowID"] = record.CTPMRowID;
	}
}

function billPaymKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var index = $(e.target).parents("tr").parents("tr").attr("datagrid-row-index");
		if (!index) {
			return;
		}
		if (!GV.BillPayMList.validateRow(index)) {
			return;
		}
		GV.EditRowIndex = index;
		var maxLen = GV.BillPayMList.getData().total;
		var nextIndex = getNextEditRow();
		if (nextIndex < maxLen) {
			var ed = GV.BillPayMList.getEditor({
				index: nextIndex,
				field: "CTPMAmt"
			});
			if (ed) {
				setTimeout(function() {
					$(ed.target).focus();
				});
			}
			var paymCode = GV.BillPayMList.getRows()[nextIndex].CTPMCode;
			var paymSum = numCompute(getValueById("winPatShareAmt"), getOtherEditIdxPaymSum(nextIndex, ""), "-");
			setColumnValue(nextIndex, "CTPMAmt", paymSum, "billPaymList");
		}else {
			setTimeout("focusById('win-btn-ok')");
		}
	}
}

function billPaymFocus(e) {
	var index = $(e.target).parents("tr").parents("tr").attr("datagrid-row-index");
	if (!index) {
		return;
	}
	var ed = GV.BillPayMList.getEditor({
			index: index,
			field: "CTPMAmt"
		});
	if (ed) {
		setTimeout(function() {
			$(ed.target).select();
		});
	}
}

function getNextEditRow() {
	var nextIndex = parseInt(GV.EditRowIndex) + 1;
	var maxLen = GV.BillPayMList.getData().total;
	while (nextIndex < maxLen) {
		var row = GV.BillPayMList.getRows()[nextIndex];
		if (row.CTPMCode == "CPP") {    //不能编辑的行
			++nextIndex;
		}else {
			break;
		}
	}
	return nextIndex;
}

function endEditing() {
	if (GV.EditRowIndex == undefined) {
		return true;
	}
	if (GV.BillPayMList.validateRow(GV.EditRowIndex)) {
		GV.BillPayMList.endEdit(GV.EditRowIndex);
		GV.EditRowIndex = undefined;
		return true;
	} else {
		return false;
	}
}

function getOtherEditIdxPaymSum(index, paymCode) {
	var otherPaymSum = 0;
	var paymAmt = 0;
	var rows = GV.BillPayMList.getRows();
	$.each(rows, function (idx, row) {
		if ((idx == index) || (paymCode && (paymCode != row.CTPMCode))) {
			return true;
		}
		paymAmt = getColumnValue(idx, "CTPMAmt", "billPaymList");
		otherPaymSum = numCompute(otherPaymSum, paymAmt, "+");
	});
	return otherPaymSum;
}

function winActualMoneyKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		if (!$(e.target).val()) {
			return;
		}
		setValueById("winActualMoney", $(e.target).val());  //numberbox 在失去焦点时候才能获取到值，所以这里给其赋值以便能取到
		var actualMoney = getValueById("winActualMoney");
		var change = numCompute(actualMoney, getCashPaymSum(), "-");
		if (+change < 0) {
			$.messager.popover({msg: "实付金额输入错误", type: "info"});
			$(e.target).focus().select();
			return;
		}else {
			setValueById("winChange", change);
			setTimeout(function() {
				focusById("win-btn-ok");
			}, 100);
		}
	}
}

function getCashPaymSum() {
	var cashPaymSum = 0;
	var paymAmt = 0;
	var rows = GV.BillPayMList.getRows();
	$.each(rows, function (idx, row) {
		if (row.CTPMCode != "CASH") {
			return true;
		}
		paymAmt = getColumnValue(idx, "CTPMAmt", "billPaymList");
		cashPaymSum = numCompute(cashPaymSum, paymAmt, "+");
	});
	return cashPaymSum;
}

/**
* 确认
*/
function confirmClick(prtRowIdStr) {
	var validate = true;
	var rows = GV.BillPayMList.getRows();
	$.each(rows, function (index, row) {
		GV.EditRowIndex = index;
		if (!endEditing()) {
			validate = false;
			return false;
		}
	});
	if (!validate) {
		return;
	}
	var paymSum = 0;
	var paymInfo = getPaymInfo();
	var paymAry = paymInfo.split(PUBLIC_CONSTANT.SEPARATOR.CH2);
	$.each(paymAry, function (index, item) {
		paymSum = numCompute(paymSum, item.split("^")[1], "+");
	});
	if(getValueById("winPatShareAmt") != paymSum) {
		$.messager.popover({msg: "金额不平，请核实", type: "info"});
		return;
	}
	var expStr = "N^" + PUBLIC_CONSTANT.SESSION.USERID + "^" + PUBLIC_CONSTANT.SESSION.GROUPID;
	$.m({
		ClassName: "web.DHCOPBillManyPaymentLogic",
		MethodName: "UpdateInvPayM",
		prtRowidStr: prtRowIdStr,
		payMInfo: paymInfo,
		expStr: expStr
	}, function(rtn) {
		websys_showModal("options").callbackFunc(rtn);
		websys_showModal("close");
	});
}

/**
* 获取支付方式金额信息
*/
function getPaymInfo() {
	var myAry = [];
	var rows = GV.BillPayMList.getRows();
	$.each(rows, function (index, row) {
		myAry.push(row.CTPMRowID + "^" + row.CTPMAmt);
	});
	return myAry.join(PUBLIC_CONSTANT.SEPARATOR.CH2);
}