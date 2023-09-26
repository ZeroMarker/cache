/**
 * FileName: dhcbill.pkg.refund.paym.js
 * Anchor: ZhYW
 * Date: 2019-01-04
 * Description: 套餐退费
 */

var m_EditIndex = undefined;

/*
 * 验证正数
 */
$.extend($.fn.validatebox.defaults.rules, {
	positiveNum: {
		validator: function (value, param) {
			var bool = true;
			var curRow = $(this).parents('.datagrid-row').attr('datagrid-row-index') || '';
			if (curRow != '') {
				var reg = /^(0|([1-9]\d*))(\.\d+)?$/;
				if (!reg.test(value)) {
					bool = false;
				} else {
					var refundamount = $('#winRefundamount').val();
					if (+value > +refundamount) {
						bool = false;
					}
				}
			}
			return bool;
		},
		message: '须为小于等于应退金额的正数'
	}
});

function initPayMList(invprtId, depositId) {
	$HUI.datagrid('#paymList', {
		fit: true,
		border: true,
		title: $('#tipDiv').html(),
		iconCls: 'icon-fee',
		headerCls: 'panel-header-gray',
		fitColumns: true,
		autoRowHeight: false,
		url: $URL,
		toolbar: [],
		data: [],
		pageSize: 999999999,
		columns: [[{
					title: '支付方式',
					field: 'CTPMDesc',
					width: 100,
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
							url: $URL + '?ClassName=web.UDHCOPGSConfig&QueryName=ReadGSINSPMList&GPRowID=' + PUBLIC_CONSTANT.SESSION.GROUP_ROWID + '&InsType=&TypeFlag=FEE&ResultSetType=array',
							editable: false,
							onLoadSuccess: function () {
								$(this).combobox('showPanel');
							},
							onSelect: function (record) {
								if (m_EditIndex != undefined) {
									HISUIDataGrid.setFieldValue('CTPMRowID', record.CTPMRowID, m_EditIndex, 'paymList');
									HISUIDataGrid.setFieldValue('CTPMCode', record.CTPMCode, m_EditIndex, 'paymList');
									HISUIDataGrid.setFieldValue('RPFlag', record.RPFlag, m_EditIndex, 'paymList');
									$('#paymList').datagrid('endEditCell', {
										index: m_EditIndex,
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
					width: 100,
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
							onSelect: function (record) {
								if (m_EditIndex != undefined) {
									payMOnClickCell(m_EditIndex, 'CTPMCheckno', '');
								}
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
			ClassName: 'DHCBILL.Package.WebUI.DHCPkgRefundBill',
			QueryName: 'FindPkgPayMList',
			invprtId: invprtId,
			depositId: depositId
		},
		onLoadSuccess: function (data) {
			//onLoadSuccessPaym();    //不实现编辑
		},
		onClickCell: function (index, field, value) {
			//payMOnClickCell(index, field, value);   //不实现编辑
			//bindGridEvent();
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
		m_EditIndex = index;
		bindGridEvent();
	}
}

/**
 * 金额单元格绑定事件
 */
function bindGridEvent() {
	try {
		var objGrid = $('#paymList');
		var ed = objGrid.datagrid('getEditor', {
				index: m_EditIndex,
				field: 'CTPMAmt'
			});
		var maxLen = objGrid.datagrid('getRows').length;
		$(ed.target).keydown(function (e) {
			var key = websys_getKey(e);
			if (key == 13) {
				if (m_EditIndex != undefined) {
					var nextIndex = getNextEditRow();
					$(ed.target).numberbox('setValue', $(ed.target).val());
					objGrid.datagrid('endEdit', m_EditIndex);
					if (nextIndex < maxLen) {
						payMOnClickCell(nextIndex, 'CTPMAmt', '');
						//bindGridEvent();
					} else {
						//focusById('winPreSum');
					}
				}
			}
		});
	} catch (e) {
	}
}

function getNextEditRow() {
	var nextIndex = m_EditIndex + 1;
	var accMRowId = getValueById('accMRowId');
	if (accMRowId != '') {
		return nextIndex;
	}
	var objGrid = $('#paymList');
	var maxLen = objGrid.datagrid('getRows').length;
	while (nextIndex < maxLen) {
		var row = objGrid.datagrid('getRows')[nextIndex];
		if (row.CTPMCode == 'CPP') {
			nextIndex++;
		}else {
			break;
		}
	}
	return nextIndex;
}

/**
 * 单元格是否可编辑
 */
function canEdit(index, field, value) {
	var bool = true;
	var row = $('#paymList').datagrid('getRows')[index];
	var CTPMCode = row.CTPMCode;
	if ((!getValueById('accMRowId')) && (CTPMCode == 'CPP') && (field != 'CTPMDesc')) {
		bool = false;
	}
	var required = row.RPFlag;
	if (required == 'N') {
		if (field != 'CTPMAmt' && field != 'CTPMDesc') {
			bool = false;
		}
	}
	return bool;
}

function endEditing() {
	if (m_EditIndex == undefined) {
		return true;
	}
	if ($('#paymList').datagrid('validateRow', m_EditIndex)) {
		$('#paymList').datagrid('endEdit', m_EditIndex);
		m_EditIndex = undefined;
		return true;
	} else {
		return false;
	}
}

function setColumnVal() {
	var tipAmt = $('#tipAmt').html();
	if ((m_EditIndex != undefined) && (Number(tipAmt) != 0)) {
		HISUIDataGrid.setFieldValue('CTPMAmt', parseFloat(tipAmt).toFixed(2), m_EditIndex, 'paymList');
	}
}

function onLoadSuccessPaym() {
	var defAmt = getDefPaymSum();
	var rows = $('#paymList').datagrid('getRows');
	$.each(rows, function (index, row) {
		var mySelect = row.selected;
		if (mySelect) {
			HISUIDataGrid.setFieldValue('CTPMAmt', defAmt, index, 'paymList');
		}
	});
}

/**
 * 取默认支付方式费用
 */
function getDefPaymSum() {
	var selfPayAmt = $('#winRefundamount').val();
	var paymTotalAmt = getPayMTotalAmt();
	var balanceAmt = selfPayAmt - paymTotalAmt;
	balanceAmt = parseFloat(balanceAmt).toFixed(2);
	return balanceAmt;
}

function setBalance() {
	setValueById('balance', getDefPaymSum());
}

function getPayMTotalAmt() {
	var totalAmt = 0;
	var rows = $('#paymList').datagrid('getRows');
	$.each(rows, function (index, row) {
		var paymAmt = row.CTPMAmt || 0;
		paymAmt = parseFloat(paymAmt);
		totalAmt = totalAmt + paymAmt;
	});
	totalAmt = parseFloat(totalAmt).toFixed(2);
	return totalAmt;
}

function pkgBillRefund(refBillId) {
	if (refBillId == '') {
		return;
	}
	var payInfo = getPayInfo();
	var accManRowId = getValueById('accMRowId');
	var requirInvFlag = '';
	var expStr = PUBLIC_CONSTANT.SESSION.GROUP_ROWID + '^' + PUBLIC_CONSTANT.SESSION.CTLOC_ROWID + '^' + PUBLIC_CONSTANT.SESSION.HOSP_ROWID;
	expStr += '^' + accManRowId + '^' + requirInvFlag;
	$.m({
		ClassName: PUBLIC_CONSTANT.METHOD.CLS,
		MethodName: 'PkgBillRefund',
		refundBillId: refBillId,
		patType: '',
		refundAmt: getValueById('winRefundamount'),
		payInfo: payInfo,
		guserId: PUBLIC_CONSTANT.SESSION.GUSER_ROWID,
		expStr: expStr
	}, function(rtn) {
		alert(rtn);
	});
}

function pkgDepositRefund(refBillId) {
	if (refBillId == '') {
		return;
	}
	var payInfo = getPayInfo();
	var accManRowId = getValueById('accMRowId');
	var requirInvFlag = '';
	var expStr = PUBLIC_CONSTANT.SESSION.GROUP_ROWID + '^' + PUBLIC_CONSTANT.SESSION.CTLOC_ROWID + '^' + PUBLIC_CONSTANT.SESSION.HOSP_ROWID;
	expStr += '^' + accManRowId + '^' + requirInvFlag;
	$.m({
		ClassName: 'DHCBILL.Package.BusinessLogic.DHCPkgDeposit',
		MethodName: 'PkgDepositCharge',
		billStr: refBillId,
		patType: '',
		patientid: getValueById('papmiId'),
		payType: 'R',
		patPayAmt: getValueById('winRefundamount'),
		payInfo: payInfo,
		guserId: PUBLIC_CONSTANT.SESSION.GUSER_ROWID,
		expStr: expStr
	}, function(rtn){
		alert(rtn);
	});
}

function getPayInfo() {
	var paymAry = [];
	var rows = $('#paymList').datagrid('getRows');
	$.each(rows, function(index, row) {
		var paymAmt = row.CTPMAmt || 0;
		var paymDR = row.CTPMRowID || '';
		var paymCode = row.CTPMCode || '';
		var bankId = row.CTPMBank || '';
		var chequeNo = row.CTPMCheckno || '';
		var payUnit = row.CTPMUnit || '';
		var chequeDate = '';
		var payAccNo = row.CTPMBankNo || '';
		if (+paymAmt != 0) {
			paymAmt = parseFloat(paymAmt).toFixed(2);
			//payMId(支付方式id)^payMAmt(支付金额)^bankId(银行id)^chequeNo(支票号/银行卡号)^patUnit(支付单位id)^chequeDate(支票日期)^payAccNo(支票对方账户号)
			var paymStr = paymDR + '^' + paymAmt + '^' + bankId + '^' + chequeNo + '^' + payUnit + '^' + chequeDate + '^' + payAccNo;
			paymAry.push(paymStr);
		}
	});
	var CH2 = String.fromCharCode(2);
	var paymStr = paymAry.join(CH2);
	
	return paymStr;
}