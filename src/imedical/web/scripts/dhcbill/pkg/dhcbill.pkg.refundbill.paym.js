/**
 * FileName: dhcbill.pkg.refundbill.paym.js
 * Anchor: tangzf
 * Date: 2019-09-23
 * Description: �ײͶ���
 */

function initPaymWinMenu() {
	$HUI.linkbutton("#win-btn-refund", {
		onClick: function () {
			winRefundClick();
		}
	});
	enableById("win-btn-refund");
	
	//�ر�
	$HUI.linkbutton("#win-btn-close", {
		onClick: function () {
			$("#paymWin").dialog("close");
		}
	});
}

function initPayMList() {
	GV.PayMList = $HUI.datagrid('#paymList', {
		fit: true,
		border: true,
		title: $("#tipDiv").html(),
		iconCls: 'icon-fee',
		headerCls: 'panel-header-gray',
		singleSelect: true,
		autoRowHeight: false,
		url: $URL,
		toolbar: [],
		pageSize: 999999999,
		columns: [[{
					title: '֧����ʽ',
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
							url: $URL + '?ClassName=web.UDHCOPGSConfig&QueryName=ReadGSINSPMList&GPRowID=' + PUBLIC_CONSTANT.SESSION.GROUPID + '&InsType=&TypeFlag=DEP&ResultSetType=array',
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
					title: '���',
					field: 'CTPMAmt',
					align: 'right',
					width: 120,
					editor: {
						type: 'numberbox',
						options: {
							precision: 2
						}
					}
				}, {
					title: '����',
					field: 'CTPMBank',
					width: 120,
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
								if (GV.EditIndex != undefined) {
									payMOnClickCell(GV.EditIndex, 'CTPMCheckno', '');
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
			ClassName: "web.UDHCOPGSConfig",
			QueryName: "ReadGSINSPMList",
			GPRowID: PUBLIC_CONSTANT.SESSION.GROUPID,
			InsType: "",
			TypeFlag: "DEP"
		},
		onLoadSuccess: function (data) {
			onLoadSuccessPaym(data);
		},
		onClickCell: function (index, field, value) {
			paymClickCell(index, field, value);
		},
		onAfterEdit: function (index, rowData, changes) {
			paymAfterEdit();
		}
	});
}

/**
 * ֧����ʽ�б���سɹ�
 */
function onLoadSuccessPaym(data) {
	var defAmt = getValueById("winRefundAmt");
	var defRowIndex = 0;
	$.each(data.rows, function (index, row) {
		if (row.selected) {
			defRowIndex = index;
			return false;
		}
	});
	
	GV.PayMList.updateRow({
		index: defRowIndex,
		row: {
			CTPMAmt: defAmt
		}
	});
	//�ı�ƽ�����ֵ(֧����ʽ)
	setBalance();
}

/**
 * ֧����ʽGrid��Ԫ�񵥻��¼�
 */
function paymClickCell(index, field, value) {
	paymEditCell(index, field, value);
}

/**
* ����֧����ʽ��Ԫ��
*/
function paymEditCell(index, field, value) {
	GV.PayMList.selectRow(index);   //ѡ���趨��
	var isEdit = isCellAllowedEdit(index, field, value);
	if (!isEdit) {
		return;
	}
	if (endEditing()) {
		GV.PayMList.editCell({
			index: index,
			field: field
		});
		var ed = GV.PayMList.getEditor({
				index: index,
				field: field
			});
		if (ed) {
			$(ed.target).focus().select();
		}
		GV.EditIndex = index;
		setTipAmt();
		bindGridEvent();
	}
}

/**
* ��Ԫ���Ƿ�ɱ༭
* true: �ɱ༭, false: ���ɱ༭
*/
function isCellAllowedEdit(index, field, value) {
	var row = GV.PayMList.getRows()[index];
	//������ ֧����ʽ���ܱ༭
	if ((field != "CTPMAmt") && (field != "CTPMDesc")) {
		var flag = isPaymRequired(row.CTPMRowID);
		if (flag == 0) {
			return false;
		}
	}
	return true;
}

/**
* ȡ֧����ʽ�Ƿ��б����� 1:���� 0��
*/
function isPaymRequired(paymId) {
	return $.m({ClassName: "web.DHCIPBillCashier", MethodName: "IsRequiredInfo", group: PUBLIC_CONSTANT.SESSION.GROUPID, pmId: paymId}, false);
}

function endEditing() {
	if (GV.EditIndex == undefined) {
		return true;
	}
	if (GV.PayMList.validateRow(GV.EditIndex)) {
		var ed = GV.PayMList.getEditor({
				index: GV.EditIndex,
				field: "CTPMBank"
			});
		if (ed) {
			var text = $(ed.target).combobox("getText");
			GV.PayMList.getRows()[GV.EditIndex]["CTPMBank"]["caption"] = text;
		}
		GV.PayMList.endEdit(GV.EditIndex);
		GV.EditIndex = undefined;
		return true;
	} else {
		return false;
	}
}

/**
 * ��Ԫ����¼�
 */
function bindGridEvent() {
	try {
		var ed = GV.PayMList.getEditor({
				index: GV.EditIndex,
				field: "CTPMAmt"
			});
		var maxLen = GV.PayMList.getData().total;
		$(ed.target).keydown(function (e) {
			var key = websys_getKey(e);
			if (key == 13) {
				if (GV.EditIndex != undefined) {
					var nextIndex = getNextEditRow();
					$(ed.target).numberbox("setValue", $(ed.target).val());
					GV.PayMList.endEdit(GV.EditIndex);
					if (nextIndex < maxLen) {
						paymEditCell(nextIndex, "CTPMAmt", "");
					}else {
						focusById("win-btn-refund");
					}
				}
			}
		});
	} catch (e) {
		$.messager.popover({msg: e.message, type: "info"});
	}
}

function getNextEditRow() {
	var nextIndex = GV.EditIndex + 1;
	return nextIndex;
}

/**
* ����Ӧ����
*/
function setTipAmt() {
	if (GV.EditIndex == undefined) {
		return;
	}
	var ed = GV.PayMList.getEditor({
		index: GV.EditIndex,
		field: "CTPMAmt"
	});
	if (ed) {
		var row = GV.PayMList.getSelected();
		var paymAmt = row.CTPMAmt;
		var balanceAmt = getGlobalValue("BalanceAmt");
		var tipAmt = numCompute(paymAmt, balanceAmt, "+");
		$("#tipAmt").html(tipAmt);
	}
}

/**
* ֧����ʽ�����༭
*/
function paymAfterEdit() {
	GV.EditIndex = undefined;
	setBalance();
}

/**
 * ����ƽ����
 */
function setBalance() {
	var payAmt = getValueById("winRefundAmt");
	var pmAll = getPayMAll();
	var pmBalance = numCompute(payAmt, pmAll, "-");
	setGlobalValue("BalanceAmt", pmBalance);
}

/**
* ��ȡ��ǰ����֧����ʽ�ĺ�
*/
function getPayMAll() {
	var paymAll = 0;
	$.each(GV.PayMList.getRows(), function (index, row) {
		var paymAmt = row.CTPMAmt;
		paymAll = numCompute(paymAll, paymAmt, "+");
	});
	return paymAll;
}

/**
* ���Ӧ����ʱ �Զ���䵽���ڱ༭�ĵ�Ԫ��
*/
function setColumnVal() {
	if (GV.EditIndex == undefined) {
		return;
	}
	var tipAmt = $("#tipAmt").text() || 0;
	if (+tipAmt != 0) {
		var ed = GV.PayMList.getEditor({
				index: GV.EditIndex,
				field: "CTPMAmt"
			});
		if (ed) {
			$(ed.target).numberbox("setValue", tipAmt);
		} else {
			GV.PayMList.updateRow({
				index: GV.EditIndex,
				row: {
					CTPMAmt: tipAmt
				}
			});
		}
	}
}

function setGlobalValue(key, value) {
	GV["" + key + ""] = value;
}

function getGlobalValue(key) {
	return GV["" + key + ""] || "";
}

/**
* �˷�
*/
function winRefundClick() {
	if (!endEditing()) {
		return;
	}
	if(getGlobalValue("BalanceAmt")!=0){
		$.messager.alert('��ʾ', "ƽ���Ϊ0�������˷�:", 'info');	
		return;	
	}
	disableById("win-btn-refund");
	var accManRowId='';
	var requirInvFlag='';
	var preSum='';
	var changeAmt='';
	var roundErr='';
	//					(��ȫ��id)						(��¼����id)^					(Ժ��id)^
	var ExpStr=PUBLIC_CONSTANT.SESSION.GROUPID+'^'+PUBLIC_CONSTANT.SESSION.CTLOCID+'^'+PUBLIC_CONSTANT.SESSION.HOSPID
						//(�˻�id)^		(�Ƿ��ӡ��Ʊ)^(ʵ��)^		(����)^		(�ֱ����)
	ExpStr=ExpStr+'^'+accManRowId+'^'+requirInvFlag+'^'+preSum+'^'+changeAmt+'^'+roundErr;
	var PayInfo= getPayModeList();
	$.messager.confirm("ȷ��", "ȷ���˷ѣ�", function(r) {
		if (r) {
			$.m({
				ClassName: "BILL.PKG.BL.RefundBill",
				MethodName: "RefundProduct",
				ProRowId: GV.PACKAGEID,
				PatDr:GV.PAPMI, 
				UserDr:PUBLIC_CONSTANT.SESSION.USERID,
				PatType:GV.ADMTYPE, 
				RefundAtm:getValueById('RefundAmt'), 
				PayInfo:PayInfo, 
				ExpStr:ExpStr
			}, function(rtn) {
				if(rtn.split('^')[0]=='0'){
					$.messager.alert('��ʾ', "�˷ѳɹ�", 'info',function(){
						$("#paymWin").dialog("close");
						initLoadGrid();
					});
				}else{
					$.messager.alert('��ʾ', "�˷�ʧ��:"+rtn, 'info');	
				}
			});
		}else {
			enableById("win-btn-refund");
		}
	});
}

function getPayModeList() {
	var paymAry = [];
	$.each(GV.PayMList.getRows(), function(index, row) {
		var paymAmt = row.CTPMAmt || 0;
		var paymDR = row.CTPMRowID || "";
		var paymCode = row.CTPMCode || "";
		var bankId = row.CTPMBank || "";
		var chequeNo = row.CTPMCheckno || "";
		var payUnit = row.CTPMUnit || "";
		var payAccNo = row.CTPMBankNo || "";
		var chequeDate = "";
		if (+paymAmt != 0) {
			paymAmt = toNumber(paymAmt).toFixed(2);
			//payMId(֧����ʽid)^payMAmt(֧�����)^bankId(����id)^chequeNo(֧Ʊ��/���п���)^patUnit(֧����λid)^payAccNo(֧Ʊ�Է��˻���)^chequeDate(֧Ʊ����)
			var paymStr = paymDR + "^" + paymAmt ;//+ "^" + bankId + "^" + chequeNo + "^" + payUnit + "^" + payAccNo + "^" + chequeDate;
			paymAry.push(paymStr);
		}
	});
	var paymStr = paymAry.join(PUBLIC_CONSTANT.SEPARATOR.CH2);
	
	return paymStr;
}

function toNumber (val) {
  var n = parseFloat(val);
  return isNaN(n) ? val : n;
}
function setGloablValue(){
	
}