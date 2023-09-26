/**
 * FileName: dhcbill.opbill.refund.paym.js
 * Anchor: ZhYW
 * Date: 2019-04-23
 * Description: 多种支付方式退费
 */
var m_EditIndex = undefined;

/*
 * 验证输入的退费金额
 */
$.extend($.fn.validatebox.defaults.rules, {
	checkRefPMAmt: {
		validator: function (value, param) {
			var curRow = $(this).parents(".datagrid-row").attr("datagrid-row-index") || "";
			if (curRow) {
				var rowData = GV.RefPayMList.getRows()[curRow];
				var paymCode = rowData.CTPMCode;
				var paymSum = getOtherEditIdxPaymSum(curRow, paymCode);
				return (GV[paymCode] && (+GV[paymCode] >= +numCompute(paymSum, value, "+")));
			}
		},
		message: "退费金额不能大于原收费金额"
	}
});

function initWinMenu(oldPrtRowId, refRtn) {
	//确定
	$HUI.linkbutton("#win-btn-ok", {
		onClick: function () {
			confirmClick(oldPrtRowId, refRtn);
		}
	});
	
	//计算器
	$HUI.linkbutton("#win-btn-calc", {
		onClick: function () {
			var calc = new ActiveXObject("WScript.shell");
    		calc.Run("calc");
		}
	});
	
	$("#winPaymList").html($("#paymList").html());
	$("#winPaymList>table").css({"border-spacing": "0 4px"});
	
	var newPrtRowId = "";    //新票RowId
	var strikeRowId = "";    //负票RowId
	var myAry = refRtn.split("^");
	if (myAry.length > 1) {
		newPrtRowId = myAry[1];
		strikeRowId = myAry[2];
	}
	
	initRefPayMList(oldPrtRowId, newPrtRowId);
	
	$.m({
		ClassName: "web.DHCOPBillManyPaymentLogic",
		MethodName: "GetRefundAmtByPrtRowid",
		oldPrtRowid: oldPrtRowId,
		newPrtRowid: newPrtRowId
	}, function(rtn) {
		var myAry = rtn.split("^");
		setValueById("winFactRefundAmt", myAry[3]);
	});
}

function initRefPayMList(oldPrtRowId, newPrtRowId) {
	GV.RefPayMList = $HUI.datagrid("#refPaymList", {
		fit: true,
		title: '退费信息',
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
							valueField: 'CTPMDesc',
							textField: 'CTPMDesc',
							url: $URL + '?ClassName=web.UDHCOPGSConfig&QueryName=ReadGSINSPMList&ResultSetType=array',
							required: false,
							editable: false,
							onBeforeLoad: function (param) {
								param.GPRowID = PUBLIC_CONSTANT.SESSION.GROUPID;
								param.HospID = PUBLIC_CONSTANT.SESSION.HOSPID;
								param.TypeFlag = "REF";
								param.DefFlag = "N";
							},
							onSelect: function (record) {
								paymComboSelect(record, this);
							}
						}
					}},
				   {title: '金额', field: 'CTPMAmt', width: 170, align: 'right',
					editor: {
						type: 'numberbox',
						options: {
							min: 0,
							precision: 2,
							validType: 'checkRefPMAmt'
						}
					}},
				 {title: 'CTPMCode', field: 'CTPMCode', hidden: true},
				 {title: 'CTPMRowID', field: 'CTPMRowID', hidden: true}
			]],
		queryParams: {
			ClassName: "web.DHCOPBillManyPaymentLogic",
			QueryName: "FindInvRefPMAmtList",
			oldPrtRowId: oldPrtRowId,
			newPrtRowId: newPrtRowId,
			rows: 99999999
		},
		onLoadSuccess: function(data) {
			$.each(data.rows, function (index, row) {
				GV.RefPayMList.beginEdit(index);
			});
			$("#refPaymList [field='CTPMAmt'] .datagrid-editable-input,.numberbox-f").on("keydown", function(e) {
				refPaymKeydown(e);
			});
			$("#refPaymList [field='CTPMAmt'] .datagrid-editable-input,.numberbox-f").on("focus", function(e) {
				refPaymFocus(e);
			});
		},
		onClickRow: function (index, row) {
			GV.RefPayMList.beginEdit(index);
			var ed = GV.RefPayMList.getEditor({
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
		if ((record.CTPMCode == "CPP") && (!GV["CPP"])) {
			var row = GV.RefPayMList.getRows()[index];
			$(target).combobox("setValue", row.CTPMDesc);
			$.messager.popover({msg: "非预交金支付发票不能选预交金退费", type: "info"});
			return;
		}
		GV.RefPayMList.getRows()[index]["CTPMCode"] = record.CTPMCode;
		GV.RefPayMList.getRows()[index]["CTPMRowID"] = record.CTPMRowID;
	}
}

function refPaymKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var index = $(e.target).parents("tr").parents("tr").attr("datagrid-row-index");
		if (!index) {
			return;
		}
		if (!GV.RefPayMList.validateRow(index)) {
			return;
		}
		m_EditIndex = index;
		var maxLen = GV.RefPayMList.getData().total;
		var nextIndex = getNextEditRow();
		if (nextIndex < maxLen) {
			var ed = GV.RefPayMList.getEditor({
				index: nextIndex,
				field: "CTPMAmt"
			});
			if (ed) {
				setTimeout(function() {
					$(ed.target).focus();
				});
			}
			var paymCode = GV.RefPayMList.getRows()[nextIndex].CTPMCode;
			var paymSum = numCompute(getValueById("winFactRefundAmt"), getOtherEditIdxPaymSum(nextIndex, ""), "-");
			if (+GV[paymCode] >= +paymSum) {
				setColumnValue(nextIndex, "CTPMAmt", paymSum, "refPaymList");
			}
		}else {
			setTimeout("focusById('win-btn-ok')");
		}
	}
}

function refPaymFocus(e) {
	var index = $(e.target).parents("tr").parents("tr").attr("datagrid-row-index");
	if (!index) {
		return;
	}
	var ed = GV.RefPayMList.getEditor({
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
	var nextIndex = parseInt(m_EditIndex) + 1;
	var maxLen = GV.RefPayMList.getData().total;
	while (nextIndex < maxLen) {
		var row = GV.RefPayMList.getRows()[nextIndex];
		if (row.CTPMCode == "CPP") {    //不能编辑的行
			++nextIndex;
		}else {
			break;
		}
	}
	return nextIndex;
}

function endEditing() {
	if (m_EditIndex == undefined) {
		return true;
	}
	if (GV.RefPayMList.validateRow(m_EditIndex)) {
		GV.RefPayMList.endEdit(m_EditIndex);
		m_EditIndex = undefined;
		return true;
	} else {
		return false;
	}
}

function getOtherEditIdxPaymSum(index, paymCode) {
	var otherPaymSum = 0;
	var paymAmt = 0;
	var rows = GV.RefPayMList.getRows();
	$.each(rows, function (idx, row) {
		if ((idx == index) || (paymCode && (paymCode != row.CTPMCode))) {
			return true;
		}
		paymAmt = getColumnValue(idx, "CTPMAmt", "refPaymList");
		otherPaymSum = numCompute(otherPaymSum, paymAmt, "+");
	});
	return otherPaymSum;
}

/**
* 确认
*/
function confirmClick(oldPrtRowId, refRtn) {
	var validate = true;
	var rows = GV.RefPayMList.getRows();
	$.each(rows, function (index, row) {
		m_EditIndex = index;
		if (!endEditing()) {
			validate = false;
			return false;
		}
	});
	if (!validate) {
		return;
	}
	var newPrtRowId = "";    //新票RowId
	var strikeRowId = "";    //负票RowId
	var myAry = refRtn.split("^");
	if (myAry.length > 1) {
		newPrtRowId = myAry[1];
		strikeRowId = myAry[2];
	}
	var paymSum = 0;
	var paymInfo = getPaymInfo();
	var paymAry = paymInfo.split(PUBLIC_CONSTANT.SEPARATOR.CH2);
	$.each(paymAry, function (index, item) {
		paymSum = numCompute(paymSum, item.split("^")[1], "+");
	});
	if(getValueById("winFactRefundAmt") != paymSum) {
		$.messager.popover({msg: "金额不平，请核实", type: "info"});
		return;
	}
	var expStr = "N^" + PUBLIC_CONSTANT.SESSION.USERID + "^" + PUBLIC_CONSTANT.SESSION.GROUPID;
	$.m({
		ClassName: "web.DHCOPBillManyPaymentLogic",
		MethodName: "UpdateNewInvPayM2",
		refundPayMInfo: paymInfo,
		oldPrtRowid: oldPrtRowId,
		newPrtRowid: newPrtRowId,
		expStr: expStr
	}, function(rtn) {
		if (rtn == "0") {
			//确认完成
			completeCharge(oldPrtRowId, refRtn);
			$("#refPaymWin").dialog("close");
		}
	});
}

/**
* 获取支付方式金额信息
*/
function getPaymInfo() {
	var myAry = [];
	var rows = GV.RefPayMList.getRows();
	$.each(rows, function (index, row) {
		myAry.push(row.CTPMRowID + "^" + row.CTPMAmt);
	});
	return myAry.join(PUBLIC_CONSTANT.SEPARATOR.CH2);
}