/**
 * FileName: dhcbill.pkg.refOrder.js
 * Anchor: ZhYW
 * Date: 2019-02-13
 * Description: 套餐退费
 */

var PUBLIC_CONSTANT = {
	SESSION: {
		GUSER_ROWID: session['LOGON.USERID'],
		CTLOC_ROWID: session['LOGON.CTLOCID'],
		GROUP_ROWID: session['LOGON.GROUPID'],
		HOSP_ROWID: session['LOGON.HOSPID']
	},
	METHOD: {
		CLS: 'DHCBILL.Package.BusinessLogic.DHCPkgRefundBill'
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

	//卡号回车查询事件
	$('#cardNo').keydown(function (e) {
		cardNoKeydown(e);
	});

	//登记号回车查询事件
	$('#patientNo').keydown(function (e) {
		patientNoKeydown(e);
	});
	
	//订单号回车查询事件
	$('#orderNo').keydown(function (e) {
		orderNoKeydown(e);
	});
	
	//卡类型
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
 * 读卡
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
			$.messager.alert('提示', '卡无效', 'info', function () {
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
					$.messager.alert('提示', '卡无效', 'info', function () {
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
 * 初始化卡类型时卡号和读卡按钮的变化
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
					title: '退费单号',
					field: 'refundbillno',
					width: 100,
					formatter: function (value, row, index) {
						if (value) {
							return "<a href='javascript:;' onclick=\"refOrderDetail('" + row.rowid + "')\">" + value + "</a>";
						}
					}
				}, {
					title: '实退总金额',
					field: 'totalrefundamount',
					align: 'right',
					width: 100
				}, {
					title: '订单实退金额',
					field: 'orderrefundamount',
					align: 'right',
					width: 100
				}, {
					title: '赔偿金额',
					field: 'indemnityamount',
					align: 'right',
					width: 100
				}, {
					title: '提交日期',
					field: 'submitdate',
					width: 100
				}, {
					title: '提交人',
					field: 'submituser',
					width: 80
				}, {
					title: '退费',
					field: 'refund',
					align: 'center',
					width: 80,
					formatter: function (value, row, index) {
						return "<a href='javascript:;' class='editCls' onclick='refund_Click(" + JSON.stringify(row) + ")'>退费</a>";
					}
				}, {
					title: '完成日期',
					field: 'finishdate',
					width: 100
				}, {
					title: '完成人',
					field: 'finishuser',
					width: 80
				}, {
					title: 'billDR',
					field: 'billDR',
					hidden: true
				}, {
					title: '订单号',
					field: 'orderNumber',
					width: 100,
					formatter: function (value, row, index) {
						if (value) {
							return "<a href='javascript:;' onclick=\"orderDtl_Click('" + row.billDR + "')\">" + value + "</a>";
						}
					}
				}, {
					title: 'paymode',
					field: 'paymode',
					hidden: true
				}, {
					title: '支付模式',
					field: 'paymDesc',
					width: 80
				}, {
					title: '收费单ID',
					field: 'invprtDR',
					hidden: true
				}, {
					title: '定金ID',
					field: 'depositDR',
					hidden: true
				}, {
					title: '费用总额',
					field: 'acount',
					align: 'right',
					width: 80
				}, {
					title: '收据号',
					field: 'receiptNo',
					width: 100
				}, {
					title: '备注',
					field: 'remarks',
					width: 100
				}, {
					title: 'accMDR',
					field: 'accMDR',
					hidden: true
				}
			]],
		onLoadSuccess: function (data) {
			$('.editCls').linkbutton({text: '退费'});
		}
	});
}

function loadRefOrderList() {
	var queryParams = {
		ClassName: 'DHCBILL.Package.WebUI.DHCPkgRefundBill',
		QueryName: 'FindPkgRefundBill',
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
			$.messager.alert('提示', '登记号错误', 'error');
		} else {
			setValueById('papmiId', myAry[1]);
			refreshBar(myAry[1]);
			loadRefOrderList();
		}
	});
}

function refOrderDetail(refBillId) {
	var url = 'dhcbill.pkg.refOrderItmDtl.csp?&refBillId=' + refBillId;
	var opt = {title: '退费单明细', iconCls: 'icon-w-list', url: url};
	createModalDialog('refOrderItmDtl', opt);
}

function orderDtl_Click(billId) {
	var url = 'dhcbill.pkg.orderItmDtl.csp?&billIdStr=' + billId;
	var opt = {title: '订单明细', iconCls: 'icon-w-list', url: url};
	createModalDialog('orderItmDtl', opt);
}

function refund_Click(row) {
	var invprtId = row.invprtDR;
	var depositId = row.depositDR;
	$('#paymWin').show();
	$('#paymWin').dialog({
		iconCls: 'icon-w-inv',
		title: '退费',
		draggable: false,
		closable: false,
		modal: true,
		buttonAlign: 'center',
		buttons: [{
			text: '退费',
			id: 'win-btn-refund',
			handler: function () {
				if (invprtId != '') {
					pkgBillRefund(row.rowid);
				}else {
					pkgDepositRefund(row.rowid);
				}
			}
		}, {
			text: '关闭',
			handler: function () {
				$('#paymWin').dialog('close');
			}
		}],
		onClose: function () {
		}
	});
	setValueById('accMRowId', row.accMDR);
	$('#winRefundamount').numberbox('setValue', row.totalrefundamount);
	$('#winTotalamount').numberbox('setValue', row.acount);
	setValueById('winReceiptNo', row.receiptNo);
	initPayMList(invprtId, depositId);
}