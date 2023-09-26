/**
 * FileName: dhcbill.pkg.charge.paym.js
 * Anchor: ZhYW
 * Date: 2019-01-04
 * Description: 套餐支付
 */

function initWinQueryMenu() {
	$('#winPreSum, #winChange').numberbox('clear');
	$('#winPreSum').keydown(function (e) {
		getChange(e);
	});
	setBalance();
}

function initPayMList() {
	$HUI.datagrid('#paymList', {
		fit: true,
		border: true,
		title: $('#tipDiv').html(),
		iconCls: 'icon-fee',
		headerCls: 'panel-header-gray',
		autoRowHeight: false,
		url: $URL,
		toolbar: [],
		data: [],
		pageSize: 999999999,
		columns: [[{
					title: '支付方式',
					field: 'CTPMDesc',
					width: 120,
					editor: {
						type: 'combobox',
						formatter: function (row) {
							var opts = $(this).combobox('options');
							return row[opts.textField];
						},
						options: {
							panelHeight: 'auto',
							valueField: 'CTPMDesc',
							textField: 'CTPMDesc',
							url: $URL + '?ClassName=web.UDHCOPGSConfig&QueryName=ReadGSINSPMList&GPRowID=' + PUBLIC_CONSTANT.SESSION.GROUPID + '&InsType=&TypeFlag=FEE&ResultSetType=array',
							editable: false,
							onLoadSuccess: function () {
								$(this).combobox('showPanel');
							},
							onSelect: function (record) {
								if (GV.EditIndex != undefined) {
									HISUIDataGrid.setFieldValue('CTPMRowID', record.CTPMRowID, GV.EditIndex, 'paymList');
									HISUIDataGrid.setFieldValue('CTPMCode', record.CTPMCode, GV.EditIndex, 'paymList');
									HISUIDataGrid.setFieldValue('RPFlag', record.RPFlag, GV.EditIndex, 'paymList');
									$('#paymList').datagrid('endEditCell', {
										index: GV.EditIndex,
										field: 'CTPMDesc'
									});
								}
							}
						}
					}
				}, {
					title: '金额',
					field: 'CTPMAmt',
					align: 'right',
					width: 120,
					editor: {
						type: 'numberbox',
						options: {
							precision: 2,
							validType: 'positiveNum'
						}
					}
				}, {
					title: '银行',
					field: 'CTPMBank',
					width: 100,
					editor: {
						type: 'combobox',
						options: {
							panelHeight: 'auto',
							valueField: 'caption',
							textField: 'caption',
							url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QBankList&ResultSetType=array',
							editable: false,
							onLoadSuccess: function () {
								$(this).combobox("showPanel");
							},
							onSelect: function (rec) {
								bankComboSelect();
							}
						}
					}
				}, {
					title: '支行',
					field: 'CTPMBankSub',
					hidden: true
				}, {
					title: '支票/卡号',
					field: 'CTPMCheckno',
					width: 100,
					editor: 'text'
				}, {
					title: '卡号',
					field: 'CTPMBankNo',
					width: 100,
					editor: 'numberbox'
				}, {
					title: '支付单位',
					field: 'CTPMUnit',
					width: 100,
					editor: 'text'
				}, {
					title: '账户',
					field: 'CTPMAcount',
					width: 100,
					editor: 'text'
				}, {
					title: 'CTPMRowID',
					field: 'CTPMRowID',
					hidden: true
				}, {
					title: 'CTPMCode',
					field: 'CTPMCode',
					hidden: true
				}, {
					title: 'RPFlag',
					field: 'RPFlag',
					hidden: true
				}
			]],
		queryParams: {
			ClassName: 'web.UDHCOPGSConfig',
			QueryName: 'ReadGSINSPMList',
			GPRowID: PUBLIC_CONSTANT.SESSION.GROUPID,
			InsType: '',
			TypeFlag: 'DEP'
		},
		onLoadSuccess: function (data) {
			onLoadSuccessPaym(data);
		},
		onClickCell: function (index, field, value) {
			payMOnClickCell(index, field, value);
		},
		onBeginEdit: function (index, row) {
			payMBeginEdit(index, row);
    	},
		onAfterEdit: function (index, rowData, changes) {
			setBalance();
		}
	});
}

function payMOnClickCell(index, field, value) {
	if (!canEdit(index, field, value)) {
		return;
	}
	if (endEditing()) {
		$('#paymList').datagrid('selectRow', index)
		.datagrid('editCell', {
			index: index,
			field: field
		});
		var ed = $('#paymList').datagrid('getEditor', {
				index: index,
				field: field
			});
		if (ed) {
			$(ed.target).focus();
			$(ed.target).select();
			var balanceAmt = getValueById('balance');
			$('#tipAmt').html(balanceAmt);
		}
		GV.EditIndex = index;
	}
}

function payMBeginEdit(index, row) {
	var ed = $('#paymList').datagrid('getEditor', {index: index, field: 'CTPMAmt'});
	if (ed) {
		var maxLen = $('#paymList').datagrid('getData').total;
		$(ed.target).keydown(function(e) {
		  	var key = websys_getKey(e);
			if (key == 13) {
				$(ed.target).numberbox("setValue", $(this).val());
				$('#paymList').datagrid('endEdit', index);
				var nextIndex = ++index;
				if (nextIndex < maxLen) {
					payMOnClickCell(nextIndex, 'CTPMAmt', '');
				}else {
					focusById("winPreSum");
				}
			}
		});
	}
}

/**
 * 银行下拉框选中事件
 */
function bankComboSelect() {
	if (GV.EditIndex != undefined) {
		var ed = $('#paymList').datagrid('getEditor',{index: GV.EditIndex, field: 'CTPMBank'});
		if (ed) {
			var text = $(ed.target).combobox("getText");
			GV.PayMList.getRows()[GV.EditIndex]["caption"] = text;
		}
	}
}

function onLoadSuccessPaym(data) {
	var defAmt = getDefPaymSum();
	var defRowIndex = 0;
	$.each(data.rows, function (index, row) {
		if (row.selected) {
			defRowIndex = index;
		}
	});
	if ($('#paymList').datagrid('getData').total > 0) {
		HISUIDataGrid.setFieldValue('CTPMAmt', defAmt, defRowIndex, 'paymList');
	}
}

function setBalance() {
	setValueById('balance', getDefPaymSum());
}

function pkgBillCharge() {
	if (!endEditing()) {
		return;
	}
	GV.EditIndex = undefined;
	$('#orderList').datagrid('acceptChanges');
	
	var payInfo = getPayInfo();
	var receiptNo = getValueById('winReceiptNo');
	var preSum = getValueById('winPreSum');
	var changeAmt = getValueById('winChange');
	var expStr = PUBLIC_CONSTANT.SESSION.GROUPID + '^' + PUBLIC_CONSTANT.SESSION.CTLOCID + '^' + PUBLIC_CONSTANT.SESSION.HOSPID;
	expStr += '^' + receiptNo + '^' + preSum  + '^' + changeAmt;
	$.m({
		ClassName: 'BILL.PKG.BL.ProductPreSell',
		MethodName: 'PkgBillCharge',
		billStr: getCheckedBillIdStr(),
		patType: '',
		patientId: getValueById('patientId'),
		patPayAmt: getValueById('winPayableamount'),
		payInfo: payInfo,
		guserId: PUBLIC_CONSTANT.SESSION.USERID,
		sFlag: 0,
		oldInvId: '',
		expStr: expStr
	}, function(rtn) {
		var myAry = rtn.split('^');
		if (myAry[0] == 0) {
			$.messager.alert('提示', '结算成功', 'info', function() {
				$('#paymWin').dialog('close');
			});
		}else {
			$.messager.alert('提示', '结算失败，错误代码:' + myAry[0]);
		}
	});
}

function pkgDepositCharge() {
	if (!endEditing()) {
		return;
	}
	GV.EditIndex = undefined;
	$('#orderList').datagrid('acceptChanges');
	
	var payInfo = getPayInfo();
	var receiptNo = getValueById('winReceiptNo');
	var preSum = getValueById('winPreSum');
	var changeAmt = getValueById('winChange');
	var roundErr = '';
	var expStr = PUBLIC_CONSTANT.SESSION.GROUPID + '^' + PUBLIC_CONSTANT.SESSION.CTLOCID + '^' + PUBLIC_CONSTANT.SESSION.HOSPID;
	expStr += '^' + receiptNo + '^' + preSum  + '^' + changeAmt   + '^' + roundErr;
	$.m({
		ClassName: 'BILL.PKG.BL.Deposit',
		MethodName: 'PkgDepositCharge',
		billStr: getCheckedBillIdStr(),
		patType: '',
		patientId: getValueById('patientId'),
		payType: 'P',
		patPayAmt: getValueById('winDepositamount'),
		payInfo: payInfo,
		guserId: PUBLIC_CONSTANT.SESSION.USERID,
		expStr: expStr
	}, function(rtn) {
		var myAry = rtn.split('^');
		if (myAry[0] == 0) {
			$.messager.alert('提示', '结算成功', 'success', function() {
				$('#paymWin').dialog('close');
			});
		}else {
			switch (rtn) {
			case '-102':
				$.messager.alert('提示', '结算失败:' + myAry[0] + "，支付金额与实际费用不平", "error");
				break;
			default:
				$.messager.alert('提示', '结算失败:' + myAry[0], "error");
				break;
			}
		}
	});
}

function getPayInfo() {
	var paymAry = [];
	$.each($("#paymList").datagrid("getRows"), function(index, row) {
		var paymAmt = row.CTPMAmt || 0;
		var paymDR = row.CTPMRowID || "";
		var paymCode = row.CTPMCode || "";
		var bankId = row.CTPMBank || "";
		var chequeNo = row.CTPMCheckno || "";
		var payUnit = row.CTPMUnit || "";
		var payAccNo = row.CTPMBankNo || "";
		var chequeDate = "";
		if (+paymAmt != 0) {
			paymAmt = parseFloat(paymAmt).toFixed(2);
			//payMId(支付方式id)^payMAmt(支付金额)^bankId(银行id)^chequeNo(支票号/银行卡号)^patUnit(支付单位id)^payAccNo(支票对方账户号)^chequeDate(支票日期)
			var paymStr = paymDR + "^" + paymAmt + "^" + bankId + "^" + chequeNo + "^" + payUnit + "^" + payAccNo + "^" + chequeDate;
			paymAry.push(paymStr);
		}
	});
	var paymStr = paymAry.join(PUBLIC_CONSTANT.SEPARATOR.CH2);
	
	return paymStr;
}