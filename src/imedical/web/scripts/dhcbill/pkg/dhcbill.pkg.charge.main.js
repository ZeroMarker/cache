/**
 * FileName: dhcbill.pkg.charge.main.js
 * Anchor: ZhYW
 * Date: 2019-01-04
 * Description: �ײ�֧��
 */

var GV = {
	EditIndex: undefined,
	PayModeId: $.m({ClassName: "BILL.PKG.BL.InvPrt", MethodName: "GetPayModeId"}, false),
};

/*
 * ��֤����
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
					var myVal = $("#paymWin").is(":visible") ? $('#winPayableamount').val() : $('#balWinBalamount').val();
					if (+value > +myVal) {
						bool = false;
					}
				}
			}
			return bool;
		},
		message: '�������Ƿ�'
	}
});

$(function () {
	$(document).keydown(function (e) {
		banBackSpace(e);
	});
	initQueryMenu();
	initOrderList();
	initDepositList();
	initInvPrtList();
});

function initQueryMenu() {
	setDefaultValue();
	
	$HUI.linkbutton('#btn-readCard', {
		onClick: function () {
			readHFMagCard_Click();
		}
	});

	$HUI.linkbutton('#btn-charge', {
		onClick: function () {
			charge_Click();
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
	
	//�����Żس���ѯ�¼�
	$('#orderNo').keydown(function (e) {
		orderNoKeydown(e);
	});
		
	//Ԥ��ģʽ
	$HUI.combobox('#sellMode', {
		panelHeight: 'auto',
		data: [{value: '5', text: 'ȫ��֧��', selected: true},
			   {value: '10', text: '����֧��'}
		],
		editable: false,
		valueField: 'value',
		textField: 'text',
		onSelect: function(rec) {
			loadOrderList();
		}
	});
	
	//������
	$HUI.combobox('#cardType', {
		panelHeight: 'auto',
		url: $URL + "?ClassName=web.DHCBillOtherLB&QueryName=QCardTypeDefineList&ResultSetType=array",
		editable: false,
		multiple: false,
		valueField: 'value',
		textField: 'caption',
		onLoadSuccess: function () {
			var cardType = $(this).combobox('getValue');
			initReadCard(cardType);
		},
		onSelect: function (record) {
			var cardType = record.value;
			initReadCard(cardType);
		}
	});
	
	$HUI.tabs('.hisui-tabs', {
		onSelect: function(title, index) {
			loadSelList();
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
			setValueById('accMRowId', myAry[7]);
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
			var myRtn = DHCACC_GetAccInfo(cardTypeDR, cardNo, '', '');
			var myAry = myRtn.toString().split('^');
			var rtn = myAry[0];
			switch (rtn) {
			case '0':
				setValueById('cardNo', myAry[1]);
				setValueById('patientNo', myAry[5]);
				setValueById('accMRowId', myAry[7]);
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

function setDefaultValue() {
	setValueById('totalamount', '0.00');
	setValueById('discountamount', '0.00');
	setValueById('payableamount', '0.00');
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
			MethodName: 'regnocon',
			PAPMINo: patientNo,
			HOSPID: PUBLIC_CONSTANT.SESSION.HOSPID
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
			loadOrderList();
		}
	}
}

function initOrderList() {
	$HUI.datagrid('#orderList', {
		fit: true,
		striped: true,
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		idField: 'rowid',
		singleSelect: true,
		pageSize: 999999999,
		toolbar: '#orderListTb',
		data: [],
		columns: [[{
					title: 'ck',
					field: 'ck',
					checkbox: true
				}, {
					title: 'rowid',
					field: 'rowid',
					hidden: true
				}, {
					title: '������',
					field: 'orderNumber',
					width: 190,
					formatter: function (value, row, index) {
						if (value) {
							return "<a href='javascript:;' style='text-decoration: underline;' onclick=\"orderDtl_Click(\'" + row.rowid + "\')\">" + value + "</a>";
						}
					}
				}, {
					title: '�ܽ��',
					field: 'totalamount',
					align: 'right',
					width: 100
				}, {
					title: '�Żݽ��',
					field: 'discountamount',
					align: 'right',
					width: 100
				}, {
					title: 'Ӧ�����',
					field: 'payableamount',
					align: 'right',
					width: 100
				}, {
					title: '������',
					field: 'depositamt',
					align: 'right',
					width: 100
				}, {
					title: '��������',
					field: 'submitdate',
					width: 100
				}, {
					title: '����ʱ��',
					field: 'submittime',
					width: 100
				}, {
					title: '������',
					field: 'owner',
					width: 80
				}, {
					title: '������',
					field: 'creator',
					width: 80
				}
			]],
		onLoadSuccess: function (data) {
			$(this).datagrid('clearChecked');
		},
		onCheck: function (rowIndex, rowData) {
			calcBillAmt();
		},
		onUncheck: function (rowIndex, rowData) {
			calcBillAmt();
		},
		onCheckAll: function (rows) {
			calcBillAmt();
		},
		onUncheckAll: function (rows) {
			calcBillAmt();
		}
	});
}

function calcBillAmt() {
	var rows = $('#orderList').datagrid('getChecked');
	var totalamount = 0;
	var discountamount = 0;
	var payableamount = 0;
	var depositamount = 0;
	$.each(rows, function (index, row) {
		totalamount = eval(parseFloat(totalamount) + parseFloat(row.totalamount));
		discountamount = eval(parseFloat(discountamount) + parseFloat(row.discountamount));
		payableamount = eval(parseFloat(payableamount) + parseFloat(row.payableamount));
		depositamount = eval(parseFloat(depositamount) + parseFloat(row.depositamt));
	});
	$('#totalamount, #winTotalamount').numberbox('setValue', parseFloat(totalamount).toFixed(2));
	$('#discountamount, #winDiscountamount').numberbox('setValue', parseFloat(discountamount).toFixed(2));
	$('#payableamount, #winPayableamount').numberbox('setValue', parseFloat(payableamount).toFixed(2));
	$('#depositamount, #winDepositamount').numberbox('setValue', parseFloat(depositamount).toFixed(2));
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
			setValueById('patientId', '');
			$.messager.alert('��ʾ', '�ǼǺŴ���', 'error');
		} else {
			setValueById('patientId', myAry[1]);
			refreshBar(myAry[1], getValueById('accMRowId'));
			loadSelList();
		}
	});
}

/**
 * ����
 */
function charge_Click() {
	var patientId = getValueById('patientId');
	if (!patientId) {
		return;
	}
	var billIdStr = getCheckedBillIdStr();
	if (!billIdStr) {
		$.messager.popover({msg: '��ѡ����Ҫ����Ķ���', type: "info"});
		return;
	}
	//disableById('btn-charge');
	$('#paymWin').show();
	$('#paymWin').dialog({
		iconCls: 'icon-w-inv',
		title: '����',
		draggable: false,
		closable: false,
		modal: true,
		buttonAlign: 'center',
		buttons: [{
			text: '����',
			id: 'win-btn-charge',
			handler: function () {
				if (getValueById('sellMode') == 5) {
					pkgBillCharge();
				}else {
					pkgDepositCharge();
				}
			}
		}, {
			text: '�ر�',
			handler: function () {
				$('#paymWin').dialog('close');
			}
		}],
		onClose: function () {
			$('#orderList').datagrid('reload');
			//enableById('btn-charge');
			//$('#paymWin').dialog('close');
		}
	});
	GV.EditIndex = undefined;
	initWinQueryMenu();
	initPayMList();
}

function getCheckedBillIdStr() {
	var myAry = [];
	var rows = $('#orderList').datagrid('getChecked');
	$.each(rows, function (index, row) {
		myAry.push(row.rowid);
	});
	var billIdStr = myAry.join('^');
	return billIdStr;
}

function initDepositList() {
	$HUI.datagrid('#depositList', {
		fit: true,
		striped: true,
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		singleSelect: true,
		idField: 'rowid',
		pageSize: 999999999,
		toolbar: [],
		data: [],
		columns: [[{
					title: 'rowid',
					field: 'rowid',
					hidden: true
				}, {
					title: '�տ���',
					field: 'amt',
					width: 100
				}, {
					title: '�տ�����',
					field: 'date',
					width: 100
				}, {
					title: '�տ�ʱ��',
					field: 'time',
					width: 100
				}, {
					title: '�տ���Ա',
					field: 'userName',
					width: 100
				}, {
					title: 'Ʊ�ݺ�',
					field: 'receiptNo',
					width: 100
				}, {
					title: '����',
					field: 'operate',
					align: 'center',
					width: 80,
					formatter: function (value, row, index) {
						if (row.rowid) {
							return "<a href='javascript:;' class='editCls' onclick='balanceClick(" + JSON.stringify(row) + ")'></a>";
						}
					}
				}, {
					title: '�����ܶ�',
					field: 'orderTotalSum',
					align: 'right',
					width: 100
				}, {
					title: '�����Ż��ܶ�',
					field: 'orderDiscSum',
					align: 'right',
					width: 100
				}, {
					title: '����Ӧ���ܶ�',
					field: 'orderPayAbleSum',
					align: 'right',
					width: 100
				}, {
					title: '������ϸ',
					field: 'billIdStr',
					width: 80,
					align: 'center',
					formatter:function(value, row, index) {
						if (value) {
							return "<img class='myTooltip' title='������ϸ' onclick=\"orderDtl_Click('" + value + "')\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png' style='border:0px;cursor:pointer'>";
						}
					}
      			}, {
					title: '�Ƿ��ս�',
					field: 'handin',
					width: 80,
					formatter: function (value, row, index) {
						if (row.reportDR) {
							return (row.reportDR) ? '<font color="#21ba45">��</font>' : '<font color="#f16e57">��</font>';
						}
					}
				}, {
					title: 'reportDR',
					field: 'reportDR',
					hidden: true
				}
			]],
		onLoadSuccess: function (data) {
			$('.editCls').linkbutton({text: '�����'});
			$('.myTooltip').tooltip({
				trackMouse: true,
				onShow: function (e) {
					$(this).tooltip('tip').css({});
				}
			});
		}
	});
}

function initInvPrtList() {
	$HUI.datagrid('#invPrtList', {
		fit: true,
		striped: true,
		singleSelect: true,
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		pageSize: 999999999,
		toolbar: [],
		data: [],
		columns: [[{
					title: 'rowid',
					field: 'rowid',
					hidden: true
				}, {
					title: '�շ�����',
					field: 'date',
					width: 100
				}, {
					title: '�շ�ʱ��',
					field: 'time',
					width: 100
				}, {
					title: '���',
					field: 'acount',
					align: 'right',
					width: 100
				}, {
					title: 'userdr',
					field: 'userdr',
					hidden: true
				}, {
					title: '�շ�Ա',
					field: 'username',
					width: 100
				}, {
					title: '����',
					field: 'operate',
					align: 'center',
					width: 80,
					formatter: function (value, row, index) {
						if (row.rowid) {
							return "<a href='javascript:;' class='editCls1' onclick=\"abortClick('" + row.rowid + "')\"></a>";
						}
					}
				}, {
					title: '�Ƿ��ս�',
					field: 'handin',
					width: 80,
					formatter: function (value, row, index) {
						if (value) {
							return (value == 'Y') ? '<font color="#21ba45">��</font>' : '<font color="#f16e57">��</font>';
						}
					}
				}, {
					title: '�ս�����',
					field: 'handindate',
					width: 100
				}, {
					title: '�ս�ʱ��',
					field: 'handintime',
					width: 100
				}, {
					title: '֧����ʽ',
					field: 'paymstr',
					width: 200
				}, {
					title: '������ϸ',
					field: 'orderDtl',
					align: 'center',
					width: 80,
					formatter: function (value, row, index) {
						if (row.billdrstr) {
							return "<img class='myTooltip' title='������ϸ' onclick=\"orderDtl_Click('" + row.billdrstr + "')\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png' style='border:0px;cursor:pointer'>";
						}
					}
				}, {
					title: 'billdrstr',
					field: 'billdrstr',
					hidden: true
				}
			]],
		onLoadSuccess: function (data) {
			$('.editCls1').linkbutton({text: '����'});
			$('.myTooltip').tooltip({
				trackMouse: true,
				onShow: function (e) {
					$(this).tooltip('tip').css({});
				}
			});
		}
	});
}

function loadOrderList() {
	var queryParams = {
		ClassName: 'BILL.PKG.BL.ProductPreSell',
		QueryName: 'FindPkgPatBill',
		papmi: getValueById('patientId'),
		sellMode: getValueById('sellMode'),
		orderNo: getValueById('orderNo'),
		hospitalId: PUBLIC_CONSTANT.SESSION.HOSPID,
		rows: 99999999
	}
	loadDataGridStore('orderList', queryParams);
}

function loadDepositList() {
	var queryParams = {
		ClassName: 'BILL.PKG.BL.Deposit',
		QueryName: 'FindPkgDeposit',
		papmi: getValueById('patientId'),
		hospitalId: PUBLIC_CONSTANT.SESSION.HOSPID,
		rows: 99999999
	}
	loadDataGridStore('depositList', queryParams);
}

function loadInvPrtList() {
	var queryParams = {
		ClassName: 'BILL.PKG.BL.InvPrt',
		QueryName: 'FindPkgInvList',
		papmi: getValueById('patientId'),
		hospitalId: PUBLIC_CONSTANT.SESSION.HOSPID,
		rows: 99999999
	}
	loadDataGridStore('invPrtList', queryParams);
}

function loadSelList() {
	switch (getSelTabIndex()) {
	case 0:
		loadOrderList();
		break;
	case 1:
		loadDepositList()
		break;
	case 2:
		loadInvPrtList()
		break;
	case defalut:
		break;
	}
}

/**
 * ��ȡѡ�е�tabs����
 */
function getSelTabIndex() {
	var tabsObj = $HUI.tabs('.hisui-tabs');
	return tabsObj.getTabIndex(tabsObj.getSelected());
}

/**
 * ����
 */
function getChange(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var cashPayAmt = getCashAmt();
		var preSum = $(e.target).val();
		switch (getSelTabIndex()) {
		case 0:
			var change = preSum - cashPayAmt;
			$('#winChange').numberbox('setValue', parseFloat(change).toFixed(2));
			break;
		case 1:
			var change = preSum - cashPayAmt;
			$('#balWinChange').numberbox('setValue', parseFloat(change).toFixed(2));
			break;
		}
	}
}

/**
 * ��ȡ�����ֽ��
 */
function getCashAmt() {
	var cashAmt = 0;
	var objGrid = {};
	switch (getSelTabIndex()) {
	case 0:
		objGrid = $('#paymList');
		break;
	case 1:
		objGrid = $('#balPaymList');
		break;
	}
	var rows = [];
	if (objGrid.length > 0) {
		rows = objGrid.datagrid('getRows');
	}
	$.each(rows, function (index, row) {
		var paymAmt = row.CTPMAmt || 0;
		var paymDr = row.CTPMRowID || '';
		var paymCode = row.CTPMCode || '';
		if ((+paymAmt != 0) && (paymCode == 'CASH')) {
			cashAmt += parseFloat(paymAmt);
		}
	});
	cashAmt = parseFloat(cashAmt).toFixed(2);
	return cashAmt;
}

function endEditing() {
	if (GV.EditIndex == undefined) {
		return true;
	}
	var objGrid = {};
	switch (getSelTabIndex()) {
	case 0:
		objGrid = $('#paymList');
		break;
	case 1:
		objGrid = $('#balPaymList');
		break;
	}
	if (objGrid.datagrid('validateRow', GV.EditIndex)) {
		objGrid.datagrid('endEdit', GV.EditIndex);
		GV.EditIndex = undefined;
		return true;
	} else {
		return false;
	}
}

/**
 * ��Ԫ���Ƿ�ɱ༭
 */
function canEdit(index, field, value) {
	var bool = true;
	var objGrid = {};
	switch (getSelTabIndex()) {
	case 0:
		objGrid = $('#paymList');
		break;
	case 1:
		objGrid = $('#balPaymList');
		break;
	}
	var row = objGrid.datagrid('getRows')[index];
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

function getNextEditRow() {
	var nextIndex = GV.EditIndex + 1;
	var accMRowId = getValueById('accMRowId');
	if (accMRowId != '') {
		return nextIndex;
	}
	var objGrid = {};
	switch (getSelTabIndex()) {
	case 0:
		objGrid = $('#paymList');
		break;
	case 1:
		objGrid = $('#balPaymList');
		break;
	}
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

function setColumnVal() {
	switch (getSelTabIndex()) {
	case 0:
		var tipAmt = $('#tipAmt').html();
		if ((GV.EditIndex != undefined) && (Number(tipAmt) != 0)) {
			HISUIDataGrid.setFieldValue('CTPMAmt', parseFloat(tipAmt).toFixed(2), GV.EditIndex, 'paymList');
		}
		break;
	case 1:
		var tipAmt = $('#balTipAmt').html();
		if ((GV.EditIndex != undefined) && (Number(tipAmt) != 0)) {
			HISUIDataGrid.setFieldValue('CTPMAmt', parseFloat(tipAmt).toFixed(2), GV.EditIndex, 'balPaymList');
		}
		break;
	}
}

/**
 * ȡĬ��֧����ʽ����
 */
function getDefPaymSum() {
	var paymTotalAmt = getPayMTotalAmt();
	var selfPayAmt = 0;
	switch (getSelTabIndex()) {
	case 0:
		selfPayAmt = (getValueById('sellMode') == 5) ? getValueById('winPayableamount') : getValueById('winDepositamount');
		break;
	case 1:
		selfPayAmt = $('#balWinBalamount').val();
		break;
	}
	var balanceAmt = selfPayAmt - paymTotalAmt;
	balanceAmt = parseFloat(balanceAmt).toFixed(2);
	return balanceAmt;
}

function getPayMTotalAmt() {
	var totalAmt = 0;
	var objGrid = {};
	switch (getSelTabIndex()) {
	case 0:
		objGrid = $('#paymList');
		break;
	case 1:
		objGrid = $('#balPaymList');
		break;
	}
	var rows = objGrid.datagrid('getRows');
	$.each(rows, function (index, row) {
		var paymAmt = row.CTPMAmt || 0;
		paymAmt = parseFloat(paymAmt);
		totalAmt = totalAmt + paymAmt;
	});
	totalAmt = parseFloat(totalAmt).toFixed(2);
	return totalAmt;
}
/**
 * �����
 */
function balanceClick(row) {
	var billStr = row.billIdStr;
	if (!billStr) {
		return;
	}
	var depositAmt = row.amt;
	var orderTotalSum = row.orderTotalSum;
	var orderDiscSum = row.orderDiscSum;
	var orderPayAbleSum = row.orderPayAbleSum;
	
	$('#balPaymWin').show();
	$('#balPaymWin').dialog({
		iconCls: 'icon-w-inv',
		title: '�����',
		draggable: false,
		closable: false,
		modal: true,
		buttonAlign: 'center',
		buttons: [{
			text: '�����',
			id: 'win-btn-balance',
			handler: function () {
				pkgDepBalance(billStr);
			}
		}, {
			text: '�ر�',
			handler: function () {
				$('#balPaymWin').dialog('close');
			}
		}],
		onClose: function () {
			$('#depositList').datagrid('reload');
		}
	});
	$('#balWinDepositamount').numberbox('setValue', depositAmt);
	$('#balWinTotalamount').numberbox('setValue', orderTotalSum);
	$('#balWinDiscountamount').numberbox('setValue', orderDiscSum);
	$('#balWinPayableamount').numberbox('setValue', orderPayAbleSum);
	$('#balWinBalamount').numberbox('setValue', parseFloat(orderPayAbleSum - depositAmt).toFixed(2));
	GV.EditIndex = undefined;
	initBalWinQueryMenu();
	initBalPayMList();
}

/**
* ���Ϸ�Ʊ
*/
function abortClick(prtRowId) {
	$.messager.confirm('ȷ��', '��ȷ��Ҫ���ϴ˷�Ʊ��', function (r) {
		if (r) {
			var expStr = PUBLIC_CONSTANT.SESSION.GROUPID + '^' + PUBLIC_CONSTANT.SESSION.CTLOCID + '^' + PUBLIC_CONSTANT.SESSION.HOSPID;
			$.m({
				ClassName: 'BILL.PKG.BL.InvPrt',
				MethodName: 'AbortReceipt',
				prtRowId: prtRowId,
				sFlag: 'A',
				guserId: PUBLIC_CONSTANT.SESSION.USERID,
				expStr: expStr
			}, function (rtn) {
				var myAry = rtn.split('^');
				if (myAry[0] == 0) {
					$.messager.alert('��ʾ', '���ϳɹ�', 'info', function() {
						$('#invPrtList').datagrid('reload');
					});
				}else {
					$.messager.alert('��ʾ', '����ʧ�ܣ��������:' + myAry[0]);
				}
			});
		}
	});
}

function orderDtl_Click(billIdStr) {
	var url = 'dhcbill.pkg.orderItmDtl.csp?&billIdStr=' + billIdStr;
	websys_showModal({
		url: url,
		title: '������ϸ',
		iconCls: 'icon-w-list'
	});
}