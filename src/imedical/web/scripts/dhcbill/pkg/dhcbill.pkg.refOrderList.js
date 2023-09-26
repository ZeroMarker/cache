/**
 * FileName: dhcbill.pkg.refOrderList.js
 * Anchor: ZhYW
 * Date: 2019-01-23
 * Description: �ײ��˷����뵥��ѯ
 */

var PUBLIC_CONSTANT = {
	SESSION: {
		GUSER_ROWID: session['LOGON.USERID'],
		CTLOC_ROWID: session['LOGON.CTLOCID'],
		GROUP_ROWID: session['LOGON.GROUPID'],
		HOSP_ROWID: session['LOGON.HOSPID']
	},
	METHOD: {
		CLS: 'DHCBILL.Package.WebUI.DHCPkgRefundBill'
	}
};

$(function () {
	$(document).keydown(function (e) {
		banBackSpace(e);
	});
	initQueryMenu();
	initRefOrderList();
});

function initQueryMenu() {
	$HUI.linkbutton('#btn-readCard', {
		onClick: function () {
			readHFMagCard_Click();
		}
	});

	//���Żس���ѯ�¼�
	$('#cardNo').keydown(function (e) {
		cardNoKeydown(e);
	});

	//�ǼǺŻس���ѯ�¼�
	$('#patientNo').keydown(function (e) {
		patientNoKeydown(e);
	});
	
	//������
	$HUI.combobox('#cardType', {
		panelHeight: 'auto',
		url: $URL,
		editable: false,
		multiple: false,
		valueField: 'value',
		textField: 'caption',
		onBeforeLoad: function (param) {
			param.ClassName = 'web.DHCBillOtherLB';
			param.QueryName = 'QCardTypeDefineList';
			param.ResultSetType = 'array';
		},
		onLoadSuccess: function () {
			var cardType = $(this).combobox('getValue');
			initReadCard(cardType);
		},
		onSelect: function (record) {
			var cardType = record.value;
			initReadCard(cardType);
		}
	});
}

/**
 * ����
 * @method readHFMagCard_Click
 * @author ZhYW
 */
function readHFMagCard_Click() {
	try {
		var cardType = getValueById('cardType');
		var cardTypeDR = cardType.split('^')[0];
		var myRtn = '';
		if (cardTypeDR == '') {
			myRtn = DHCACC_GetAccInfo();
		} else {
			myRtn = DHCACC_GetAccInfo(cardTypeDR, cardType);
		}
		var myAry = myRtn.toString().split('^');
		var rtn = myAry[0];
		switch (rtn) {
		case '0':
			setValueById('cardNo', myAry[1]);
			setValueById('patientNo', myAry[5]);
			getPatInfo();
			break;
		case '-200':
			$.messager.alert('��ʾ', '����Ч', 'info', function () {
				focusById('btn-readCard');
			});
			break;
		case '-201':
			setValueById('cardNo', myAry[1]);
			setValueById('patientNo', myAry[5]);
			getPatInfo();
			break;
		default:
		}
	} catch (e) {
	}
}

function cardNoKeydown(e) {
	try {
		var key = websys_getKey(e);
		if (key == 13) {
			var cardNo = getValueById('cardNo');
			if (!cardNo) {
				return;
			}
			var cardType = getValueById('cardType');
			cardNo = formatCardNo(cardType, cardNo);
			var cardTypeAry = cardType.split('^');
			var cardTypeDR = cardTypeAry[0];
			var myRtn = DHCACC_GetAccInfo(cardTypeDR, cardNo, '', 'PatInfo');
			var myAry = myRtn.toString().split('^');
			var rtn = myAry[0];
			switch (rtn) {
			case '0':
				setValueById('cardNo', myAry[1]);
				setValueById('patientNo', myAry[5]);
				getPatInfo();
				break;
			case '-200':
				setTimeout(function () {
					$.messager.alert('��ʾ', '����Ч', 'info', function () {
						focusById('cardNo');
					});
				}, 10);
				break;
			case '-201':
				setValueById('cardNo', myAry[1]);
				setValueById('patientNo', myAry[5]);
				getPatInfo();
				break;
			default:
			}
		}
	} catch (e) {
	}
}

/**
 * ��ʼ��������ʱ���źͶ�����ť�ı仯
 * @method initReadCard
 * @param {String} cardType
 * @author ZhYW
 */
function initReadCard(cardType) {
	try {
		var cardTypeAry = cardType.split('^');
		var readCardMode = cardTypeAry[16];
		if (readCardMode == 'Handle') {
			$('#btn-readCard').linkbutton('disable');
			$('#cardNo').attr('readOnly', false);
			focusById('cardNo');
		} else {
			$('#btn-readCard').linkbutton('enable');
			$('#cardNo').val('');
			$('#cardNo').attr('readOnly', true);
			focusById('btn-readCard');
		}
	} catch (e) {
	}
}

function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var patientNo = $(e.target).val();
		if (!patientNo) {
			return;
		}
		$.m({
			ClassName: 'web.UDHCJFBaseCommon',
			MethodName: 'regnoconboe',
			PAPMINo: patientNo,
			HOSPID: PUBLIC_CONSTANT.SESSION.HOSP_ROWID
		}, function (rtn) {
			$(e.target).val(rtn);
			getPatInfo();
		});
	}
}

function orderNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		if ($.trim($(e.target).val())) {
			loadRefOrderList();
		}
	}
}

function initRefOrderList() {
	$HUI.datagrid('#refOrderList', {
		fit: true,
		striped: true,
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		selectOnCheck: true,
		checkOnSelect: false,
		idField: 'rowid',
		pagination: true,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		toolbar: [],
		data: [],
		columns: [[{
					title: 'rowid',
					field: 'rowid',
					hidden: true
				}, {
					title: '�˷ѵ���',
					field: 'refundbillno',
					width: 100,
					formatter: function (value, row, index) {
						if (value) {
							return "<a href='javascript:;' style='text-decoration: underline;' onclick=\"refOrder_Click('" + row.rowid + "')\">" + value + "</a>";
						}
					}
				}, {
					title: 'ʵ���ܽ��',
					field: 'totalrefundamount',
					align: 'right',
					width: 100
				}, {
					title: '����ʵ�˽��',
					field: 'orderrefundamount',
					align: 'right',
					width: 100
				}, {
					title: '�⳥���',
					field: 'indemnityamount',
					align: 'right',
					width: 100
				}, {
					title: '�ύ����',
					field: 'submitdate',
					width: 100
				}, {
					title: '�ύ��',
					field: 'submituser',
					width: 80
				}, {
					title: '�������',
					field: 'finishdate',
					width: 100
				}, {
					title: '�����',
					field: 'finishuser',
					width: 80
				}, {
					title: 'billDR',
					field: 'billDR',
					hidden: true
				}, {
					title: '������',
					field: 'orderNumber',
					width: 100,
					formatter: function (value, row, index) {
						if (value) {
							return "<a href='javascript:;' style='text-decoration: underline;' onclick=\"orderDtl_Click(\'" + row.billDR + "')\">" + value + "</a>";
						}
					}
				}, {
					title: '��ע',
					field: 'remarks',
					width: 100
				}
			]],
		onLoadSuccess: function (data) {
		}
	});
}

function loadRefOrderList() {
	var queryParams = {
		ClassName: PUBLIC_CONSTANT.METHOD.CLS,
		QueryName: 'FindPkgRefBillList',
		papmi: getValueById('papmiId'),
		orderNo: getValueById('orderNo'),
		hospitalId: PUBLIC_CONSTANT.SESSION.HOSP_ROWID
	}
	loadDataGridStore('refOrderList', queryParams);
}

function getPatInfo() {
	var patientNo = getValueById('patientNo');
	$.m({
		ClassName: 'web.UDHCJFBaseCommon',
		MethodName: 'GetCardNOByPAPMI',
		patNO: patientNo,
		papmiDr: '',
		adm: ''
	}, function (rtn) {
		var myAry = rtn.split('^');
		if (!myAry[1]) {
			setValueById('papmiId', '');
			$.messager.alert('��ʾ', '�ǼǺŴ���', 'error');
		} else {
			setValueById('papmiId', myAry[1]);
			refreshBar(myAry[1]);
			loadRefOrderList();
		}
	});
}

function refOrder_Click(refBillId) {
	var url = 'dhcbill.pkg.refOrderItmDtl.csp?&refBillId=' + refBillId;
	var opt = {title: '�˷ѵ���ϸ', iconCls: 'icon-w-list', url: url};
	createModalDialog('refOrderItmDtl', opt);
}

function orderDtl_Click(billId) {
	var url = 'dhcbill.pkg.orderItmDtl.csp?&billIdStr=' + billId;
	var opt = {title: '������ϸ', iconCls: 'icon-w-list', url: url};
	createModalDialog('orderItmDtl', opt);
}