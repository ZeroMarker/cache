/**
 * FileName: dhcbill.pkg.balance.paym.js
 * Anchor: ZhYW
 * Date: 2019-01-04
 * Description: �ײ��շ�
 */

function initBalWinQueryMenu() {
	$('#balWinPreSum').numberbox('clear');
	$('#balWinPreSum').keydown(function (e) {
		getChange(e);
	});
	setBalBalance();
}

function initBalPayMList() {
	$HUI.datagrid('#balPaymList', {
		fit: true,
		border: true,
		title: $('#balTipDiv').html(),
		iconCls: 'icon-fee',
		headerCls: 'panel-header-gray',
		autoRowHeight: false,
		url: $URL,
		toolbar: [],
		data: [],
		pageSize: 999999999,
		columns: [[{
					title: '֧����ʽ',
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
							url: $URL + '?ClassName=web.UDHCOPGSConfig&QueryName=ReadGSINSPMList&GPRowID=' + PUBLIC_CONSTANT.SESSION.GROUPID + '&InsType=&TypeFlag=DEP&ResultSetType=array',
							editable: false,
							onLoadSuccess: function () {
								$(this).combobox('showPanel');
							},
							onSelect: function (record) {
								if (m_EditIndex != undefined) {
									HISUIDataGrid.setFieldValue('CTPMRowID', record.CTPMRowID, m_EditIndex, 'balPaymList');
									HISUIDataGrid.setFieldValue('CTPMCode', record.CTPMCode, m_EditIndex, 'balPaymList');
									HISUIDataGrid.setFieldValue('RPFlag', record.RPFlag, m_EditIndex, 'balPaymList');
									$('#balPaymList').datagrid('endEditCell', {
										index: m_EditIndex,
										field: 'CTPMDesc'
									});
								}
							}
						}
					}
				}, {
					title: '���',
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
					title: '����',
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
									balPayMOnClickCell(m_EditIndex, 'CTPMCheckno', '');
								}
							}
						}
					}
				}, {
					title: '֧��',
					field: 'CTPMBankSub',
					hidden: true
				}, {
					title: '֧Ʊ/����',
					field: 'CTPMCheckno',
					width: 100,
					editor: 'text'
				}, {
					title: '����',
					field: 'CTPMBankNo',
					width: 100,
					editor: 'numberbox'
				}, {
					title: '֧����λ',
					field: 'CTPMUnit',
					width: 100,
					editor: 'text'
				}, {
					title: '�˻�',
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
			onLoadSuccessBalPaym(data);
		},
		onClickCell: function (index, field, value) {
			balPayMOnClickCell(index, field, value);
		},
		onBeginEdit: function (index, row) {
			balPayMBeginEdit(index, row);
    	},
		onAfterEdit: function (index, rowData, changes) {
			setBalBalance();
		}
	});
}

function balPayMOnClickCell(index, field, value) {
	if (!canEdit(index, field, value)) {
		return;
	}
	if (endEditing()) {
		$('#balPaymList').datagrid('selectRow', index)
		.datagrid('editCell', {
			index: index,
			field: field
		});
		var ed = $('#balPaymList').datagrid('getEditor', {
				index: index,
				field: field
			});
		if (ed) {
			$(ed.target).focus();
			$(ed.target).select();
			var balanceAmt = getValueById('balBalance');
			$('#balTipAmt').html(balanceAmt);
		}
		m_EditIndex = index;
	}
}

function balPayMBeginEdit(index, row) {
	var ed = $('#balPaymList').datagrid('getEditor', {index: index, field: 'CTPMAmt'});
	if (ed) {
		var maxLen = $('#balPaymList').datagrid('getData').total;
		$(ed.target).keydown(function(e) {
		  	var key = websys_getKey(e);
			if (key == 13) {
				$(ed.target).numberbox("setValue", $(this).val());
				$('#balPaymList').datagrid('endEdit', index);
				var nextIndex = ++index;
				if (nextIndex < maxLen) {
					balPayMOnClickCell(nextIndex, 'CTPMAmt', '');
				}else {
					focusById("balWinPreSum");
				}
			}
		});
	}
}

function onLoadSuccessBalPaym(data) {
	var defAmt = getDefPaymSum();
	var defRowIndex = 0;
	$.each(data.rows, function (index, row) {
		if (row.selected) {
			defRowIndex = index;
		}
	});
	if (data.rows.length > 0) {
		HISUIDataGrid.setFieldValue('CTPMAmt', defAmt, defRowIndex, 'balPaymList');
	}
}

function setBalBalance() {
	setValueById('balBalance', getDefPaymSum());
}

function pkgDepBalance(billStr) {
	if (!endEditing()) {
		return;
	}
	m_EditIndex = undefined;
	$('#balPaymList').datagrid('acceptChanges');

	var payInfo = getPayBalInfo();
	var receiptNo = getValueById('balWinReceiptNo');
	var preSum = getValueById('balWinPreSum');
	var changeAmt = getValueById('balWinChange');
	var roundErr = '';
	var expStr = PUBLIC_CONSTANT.SESSION.GROUPID + '^' + PUBLIC_CONSTANT.SESSION.CTLOCID + '^' + PUBLIC_CONSTANT.SESSION.HOSPID;
	expStr += '^' + receiptNo + '^' + preSum  + '^' + changeAmt;
	$.m({
		ClassName: 'BILL.PKG.BL.ProductPreSell',
		MethodName: 'PkgBillCharge',
		billStr: billStr,
		patType: '',
		patientId: getValueById('patientId'),
		patPayAmt: getValueById('balWinPayableamount'),
		payInfo: payInfo,
		guserId: PUBLIC_CONSTANT.SESSION.USERID,
		sFlag: 0,
		oldInvId: '',
		expStr: expStr
	}, function(rtn){
		var myAry = rtn.split('^');
		if (myAry[0] == 0) {
			$.messager.alert('��ʾ', '�����ɹ�', 'info', function() {
				$('#balPaymWin').dialog('close');
			});
		}else {
			$.messager.alert('��ʾ', '�����ʧ�ܣ��������:' + myAry[0]);
		}
	});
}

function getPayBalInfo() {
	var paymAry = [];
	var rows = $('#balPaymList').datagrid('getRows');
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
			//payMId(֧����ʽid)^payMAmt(֧�����)^bankId(����id)^chequeNo(֧Ʊ��/���п���)^patUnit(֧����λid)^payAccNo(֧Ʊ�Է��˻���)^chequeDate(֧Ʊ����)
			var paymStr = paymDR + '^' + paymAmt + '^' + bankId + '^' + chequeNo + '^' + payUnit + "^" + payAccNo + "^" + chequeDate;
			paymAry.push(paymStr);
		}
	});
	
	//���붨��֧����Ϣ
	var paymStr = GV.PayModeId + '^' + getValueById('balWinDepositamount');
	paymAry.push(paymStr);
	
	var CH2 = String.fromCharCode(2);
	var paymStr = paymAry.join(CH2);
	
	return paymStr;
}