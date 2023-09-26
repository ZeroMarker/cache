/**
 * FileName: dhcbill/pkg/dhcbill.pkg.InvPrtList.js
 * Anchor: 王明龙
 * Date: 2019-02-22
 * Description: 套餐收费单查询
 */

var PUBLIC_CONSTANT = {
	SESSION: {
		GUSER_ROWID: session['LOGON.USERID'],
		CTLOC_ROWID: session['LOGON.CTLOCID'],
		GROUP_ROWID: session['LOGON.GROUPID'],
		HOSP_ROWID: session['LOGON.HOSPID']
	},
	METHOD: {
		CLS: 'DHCBILL.Package.WebUI.DHCPkgInvprt'
	}
};

$(function () {
	$(document).keydown(function (e) {
		banBackSpace(e);
	});
	initQueryMenu();
	initInvprtList();
});

function initQueryMenu() {
	$HUI.linkbutton('#btn-readCard', {
		onClick: function () {
			readHFMagCard_Click();
		}
	});
	
	//点击查询
	$HUI.linkbutton('#btn-find', {
		onClick: function () {
			Find_Click();
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
			loadInvprtList();
		}
	}
}

function exportInvDtl(){
	var papmi = getValueById('papmiId');
	var orderNo = getValueById('orderNo');
	var startdate = getValueById('startdate');
	var enddate = getValueById('enddate');
	var hospitalId = getValueById('enddate');
	var fileName = 'DHCPkgInvprt.raq' + '&papmi=' + papmi + '&orderNo=' + orderNo + '&startdate=' + startdate;
	fileName += '&enddate=' + enddate + '&hospitalId=' + hospitalId ;
	var maxHeight = ($(window).height() || 550) * 0.8;
	var maxWidth = ($(window).width() || 1366) * 0.8;
	DHCCPM_RQPrint(fileName, maxWidth, maxHeight);	
}


function initInvprtList() {
	var toolbar = [{
			id: 'btn-export',
			text: '导出',
			iconCls: 'icon-export',
			handler: function () {
				exportInvDtl();
			}
		}
	];
	
	$.cm({
		ClassName: "web.DHCBillGroupConfig",
		MethodName: "GetInvprtListColumns"
	}, function (txtData) {
		var columnAry = new Array();
		$.each(txtData, function (index, item) {
			var column = {};
			column["title"] = item.title;
			column["field"] = item.field;
			column["align"] = item.align;
			column["halign"] = item.halign;
			column["width"] = item.width;
			if (item.field == "billdr") {
				column["formatter"] = testFormatter;
			}
			columnAry.push(column);
		});
		
	$HUI.datagrid('#invprtList', {
		fit: true,
		border: false,
		striped: true,
		headerCls: 'panel-header-gray',
		autoRowHeight: false,
		pagination: true,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		toolbar: toolbar,
		data: [],
		columns: [columnAry],
		/*
		columns: [[{
					title: '导航号',
					field: 'rowid',
					align: 'center',
					width: 100,
				}
				, {
					title: '订单ID',
					field: 'billdr',
					align: 'center',
					width: 80,
					formatter: testFormatter;
				}
				, {
					title: '患者姓名',
					field: 'prtpatientname',
					align: 'center',
					width: 100
				}
				, {
					title: '票据金额',
					field: 'prtacount',
					align: 'center',
					width: 100
				}, {
					title: '收费日期',
					field: 'prtdate',
					align: 'center',
					width: 100
				}, {
					title: '收费时间',
					field: 'prttime',
					align: 'center',
					width: 100
				}, {
					title: '日结账ID',
					field: 'prtreportdr',
					align: 'center',
					width: 100
				}, {
					title: '收据状态',
					field: 'prtflag',
					align: 'center',
					width: 80
				}, {
					title: '结账标志',
					field: 'prthandin',
					align: 'center',
					width: 100
				}, {
					title: '结账日期',
					field: 'prthandindate',
					align: 'center',
					width: 100
				}, {
					title: '结账时间',
					field: 'prthandintime',
					align: 'center',
					width: 100
				}, {
					title: '冲红',
					field: 'prtinitinvdr',
					align: 'center',
					width: 100
				}, {
					title: '原发票',
					field: 'prtoldinvdr',
					align: 'center',
					width: 100
				}, {
					title: '票据号',
					field: 'prtinv',
					align: 'center',
					width: 100
				}, {
					title: '收费员',
					field: 'prtusrname',
					align: 'center',
					width: 100
				}, {
					title: '打印标志',
					field: 'prtinvprintflag',
					align: 'center',
					width: 100
				}, {
					title: '支付方式',
					field: 'paymode',
					align: 'center',
					width: 200,
				}
			]],
			*/
		onLoadSuccess: function (data) {
		}
	});
	});
}

function Find_Click(){
	 loadInvprtList()
}

function loadInvprtList() {
	var queryParams = {
		ClassName: PUBLIC_CONSTANT.METHOD.CLS,
		QueryName: 'FindPkgInvPrtList',
		papmi: getValueById('papmiId'),
		orderNo: getValueById('orderNo'),
		startdate: getValueById('startdate'),
		enddate: getValueById('enddate'),
		hospitalId: PUBLIC_CONSTANT.SESSION.HOSP_ROWID
	}
	loadDataGridStore('invprtList', queryParams);
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
			loadInvprtList();
		}
	});
}

function refOrder_Click(refBillId) {
	var url = 'dhcbill.pkg.refOrderItmDtl.csp?&refBillId=' + refBillId;
	var opt = {title: '退费单明细', iconCls: 'icon-w-list', url: url};
	createModalDialog('refOrderItmDtl', opt);
}

function orderDtl_Click(billId) {
	var url = 'dhcbill.pkg.orderItmDtl.csp?&billIdStr=' + billId;
	var opt = {title: '订单明细', iconCls: 'icon-w-list', url: url};
	createModalDialog('orderItmDtl', opt);
}

function testFormatter(value, row, index) {
	if (value) {
		return "<a href='javascript:;' style='text-decoration: underline;' onclick=\"orderDtl_Click(\'" + value + "')\">" + value + "</a>";
	}
}