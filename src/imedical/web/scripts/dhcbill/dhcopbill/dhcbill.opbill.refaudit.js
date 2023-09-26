/**
 * FileName: dhcbill.opbill.refaudit.js
 * Anchor: ZhYW
 * Date: 2018-11-14
 * Description: 门诊退费审核
 */

var GV = {
	SelRowIndex: undefined
};

$(function () {
	$(document).keydown(function (e) {
		banBackSpace(e);
	});
	initQueryMenu();
	initInvList();
	for (var i = 1; i <= getTabsLength(); i++) {
		initOrdItmList(i);
	}
});

function initQueryMenu() {
	var defDate = getDefStDate(0);
	$('#stDate, #endDate').datebox('setValue', defDate);

	$HUI.linkbutton('#btn-readCard', {
		onClick: function () {
			readHFMagCardClick();
		}
	});

	$HUI.linkbutton('#btn-find', {
		onClick: function () {
			loadInvList();
		}
	});

	$HUI.linkbutton('#btn-clear', {
		onClick: function () {
			clearClick();
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

	//发票回车查询事件
	$('#invNo').keydown(function (e) {
		invNoKeydown(e);
	});

	$('#more-container').click(function () {
		var t = $(this);
		if (t.find('.arrows-b-text').text() == '更多') {
			t.find('.arrows-b-text').text('收起');
			t.find('.spread-b-down').removeClass('spread-b-down').addClass('retract-b-up');
			$('tr.display-more-tr').slideDown('normal', setHeight(40));
		} else {
			t.find('.arrows-b-text').text("更多");
			t.find('.retract-b-up').removeClass('retract-b-up').addClass('spread-b-down');
			$('tr.display-more-tr').slideUp('fast', setHeight(-40));
		}
	});

	//卡类型
	$HUI.combobox('#cardType', {
		panelHeight: 'auto',
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QCardTypeDefineList&ResultSetType=array',
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
	
	$HUI.tabs('#audit-tabs', {
		onSelect: function(title, index){
			loadOrdItmList();
		}
	});
}

/**
 * 读卡
 * @method readHFMagCardClick
 * @author ZhYW
 */
function readHFMagCardClick() {
	try {
		var cardType = $('#cardType').combobox('getValue');
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
			$('#cardNo').val(myAry[1]);
			$('#patientNo').val(myAry[5]);
			loadInvList();
			break;
		case '-200':
			$.messager.alert('提示', '卡无效', 'info', function () {
				$('#btn-readCard').focus();
			});
			break;
		case '-201':
			$('#cardNo').val(myAry[1]);
			$('#patientNo').val(myAry[5]);
			loadInvList();
			break;
		default:
		}
	} catch (e) {
	}
}

function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		$.m({
			ClassName: 'web.UDHCJFBaseCommon',
			MethodName: 'regnocon',
			PAPMINo: $(e.target).val()
		}, function (patientNo) {
			$(e.target).val(patientNo);
			loadInvList();
		});
	}
}

function cardNoKeydown(e) {
	try {
		var key = websys_getKey(e);
		if (key == 13) {
			var cardNo = $('#cardNo').val();
			if (!cardNo) {
				return;
			}
			var cardType = $('#cardType').combobox('getValue');
			cardNo = formatCardNo(cardType, cardNo);
			var cardTypeAry = cardType.split('^');
			var cardTypeDR = cardTypeAry[0];
			var myRtn = DHCACC_GetAccInfo(cardTypeDR, cardNo, '', 'PatInfo');
			var myAry = myRtn.toString().split('^');
			var rtn = myAry[0];
			switch (rtn) {
			case '0':
				$('#cardNo').val(myAry[1]);
				$('#patientNo').val(myAry[5]);
				loadInvList();
				break;
			case '-200':
				setTimeout(function () {
					$.messager.alert('提示', '卡无效', 'info', function () {
						$('#cardNo').focus();
					});
				}, 300);
				break;
			case '-201':
				$('#cardNo').val(myAry[1]);
				$('#patientNo').val(myAry[5]);
				loadInvList();
				break;
			default:
			}
		}
	} catch (e) {
	}
}

/**
 * 发票号回车查询
 */
function invNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		$.m({
			ClassName: 'web.DHCOPBillRefundRequest',
			MethodName: 'CheckInvIsReqByInvNo',
			invNo: $(e.target).val()
		}, function (rtn) {
			if (rtn == '0') {
				$.messager.alert('提示', '该发票不存在或未作申请.', 'info');
				return;
			}else {
				loadInvList();
			}
		});
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
		} else {
			$('#btn-readCard').linkbutton('enable');
			$('#cardNo').val('');
			$('#cardNo').attr('readOnly', true);
		}
	} catch (e) {
	}
}

/**
 * 重置layout高度
 * @method setHeight
 * @param {int} num
 * @author ZhYW
 */
function setHeight(num) {
	var l = $('#head-menu');
	var n = l.layout('panel', 'north');
	var nh = parseInt(n.outerHeight()) + parseInt(num);
	n.panel('resize', {
		height: nh
	});
	if (+num > 0) {
		$('tr.display-more-tr').show();
	} else {
		$('tr.display-more-tr').hide();
	}
	var c = l.layout('panel', 'center');
	var ch = parseInt(c.panel('panel').outerHeight()) - parseInt(num);
	c.panel('resize', {
		height: ch,
		top: nh
	});
}

function initInvList() {
	$HUI.datagrid('#invList', {
		fit: true,
		border: false,
		striped: true,
		selectOnCheck: true,
		checkOnSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		data: [],
		columns: [[{title: 'ckBox', field: 'ckBox', checkbox: true},
		           {title: '发票号', field: 'invNo', width: 100},
		           {title: '登记号', field: 'patNo', width: 100},
		           {title: '患者姓名', field: 'patName', width: 80},
		           {title: '费用总额', field: 'prtAcount', align: 'right', width: 80},
		           {title: '自付金额', field: 'prtPatShare', align: 'right', width: 80},
		           {title: '收费员', field: 'prtUserName', width: 70},
		           {title: '收费时间', field: 'prtDate', width: 155,
					formatter: function (value, row, index) {
						return value + ' ' + row.prtTime;
					}
				   },
				   {title: 'prtRowId', field: 'prtRowId', hidden: true},
				   {title: 'invFlag', field: 'invFlag', hidden: true}
			]],
		onLoadSuccess: function (data) {
			if (data.rows.length > 0) {
				$(this).datagrid('checkAll');
			}else {
				$(this).datagrid('clearChecked');
			}
		},
		onCheck: function (rowIndex, rowData) {
			loadDefTabContent();
		},
		onUncheck: function (rowIndex, rowData) {
			loadDefTabContent();
		},
		onCheckAll: function (rows) {
			loadDefTabContent();
		},
		onUncheckAll: function (rows) {
			loadDefTabContent();
		}
	});
}

function loadInvList() {
	var expStr = PUBLIC_CONSTANT.SESSION.USERID + '^' + PUBLIC_CONSTANT.SESSION.GROUPID + '^' + PUBLIC_CONSTANT.SESSION.CTLOCID + '^' + PUBLIC_CONSTANT.SESSION.HOSPID;
	var queryParams = {
		ClassName: 'web.DHCOPBillRefundRequest',
		QueryName: 'FindReqInvInfo',
		stDate: getValueById('stDate'),
		endDate: getValueById('endDate'),
		receiptNo: getValueById('invNo'),
		patientNo: getValueById('patientNo'),
		patientName: getValueById('patName'),
		chargeUser: getValueById('userName'),
		expStr: expStr
	}
	loadDataGridStore('invList', queryParams);
}

function initOrdItmList(index) {
	var toolbar = [];
	if (index == 1) {
		toolbar = [{
				text: '审核',
				iconCls: 'icon-stamp-pass',
				handler: function () {
					auditClick();
				}
			}
		];
	}
	if (index == 3) {
		toolbar = [{
				text: '撤销审核',
				iconCls: 'icon-stamp-cancel',
				handler: function () {
					cancelClick();
				}
			}
		];
	};
	
	$HUI.datagrid('#ordItmList-' + index, {
		fit: true,
		striped: true,
		border: false,
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		checkOnSelect: false, //如果为false, 当用户仅在点击该复选框的时候才会被选中或取消
		selectOnCheck: false,
		rownumbers: false,
		pageSize: 999999999,
		toolbar: toolbar,
		data: [],
		columns: [getOrdItmColumns(index)],
		onLoadSuccess: function (data) {
			$(this).datagrid('clearChecked');
		},
		onCheck: function (index, row) {
			if (GV.SelRowIndex !== undefined) {
				return;
			}
			controlCNMedItm(index, row);
		},
		onUncheck: function (index, row) {
			if (GV.SelRowIndex !== undefined) {
				return;
			}
			controlCNMedItm(index, row);
		}
	});
}

/**
 * 判断行能否被勾选
 */
function canCheck(row) {
	var bool = true;
	var reqFlag = row.reqFlag;
	var auditFlag = getAuditFlag();
	if (auditFlag == 'U') {
		var reqQty = (reqFlag == 'P') ? false : true;
	}
	return true;
}

function loadOrdItmList() {
	var invStr = getCheckedInvStr();
	var expStr = PUBLIC_CONSTANT.SESSION.USERID + '^' + PUBLIC_CONSTANT.SESSION.GROUPID + '^' + PUBLIC_CONSTANT.SESSION.CTLOCID + '^' + PUBLIC_CONSTANT.SESSION.HOSPID;
	expStr += '^' + getAuditFlag();
	var index = getSelTabIndex();
	var queryParams = {
		ClassName: 'web.DHCOPBillRefundRequest',
		invStr: invStr,
		expStr: expStr,
		rows: 999999999
	}
	queryParams.QueryName = (index == 2) ? 'FindOrdItm' : 'FindIOASubInfo';
	
	loadDataGridStore('ordItmList-' + index, queryParams);
}

/**
 * 审核
 */
function auditClick() {
	var invSubStr = getCheckedInvSubStr();
	if (invSubStr == '') {
		return;
	}
	var expStr = PUBLIC_CONSTANT.SESSION.GROUPID + '^' + PUBLIC_CONSTANT.SESSION.CTLOCID + '^' + PUBLIC_CONSTANT.SESSION.HOSPID;
	$.m({
		ClassName: 'web.DHCOPBillRefundRequest',
		MethodName: 'RefundAudit',
		guser: PUBLIC_CONSTANT.SESSION.USERID,
		invSubStr: invSubStr,
		expStr: expStr
	}, function (rtn) {
		var myAry = rtn.split('^');
		var err = myAry[0];
		var desc = myAry[1];
		if (err == 0) {
			$.messager.popover({
				msg: desc,
				type: 'success'
			});
			ordItmListObj().reload();
		}else {
			$.messager.popover({
				msg: desc,
				type: 'info'
			});
		}
	});
}

/**
 * 撤销审核
 */
function cancelClick() {
	var invSubStr = getCheckedInvSubStr();
	if (invSubStr == '') {
		return;
	}
	var expStr = PUBLIC_CONSTANT.SESSION.GROUPID + '^' + PUBLIC_CONSTANT.SESSION.CTLOCID + '^' + PUBLIC_CONSTANT.SESSION.HOSPID;
	$.m({
		ClassName: 'web.DHCOPBillRefundRequest',
		MethodName: 'CancelAudit',
		guser: PUBLIC_CONSTANT.SESSION.USERID,
		invSubStr: invSubStr,
		expStr: expStr
	}, function (rtn) {
		var myAry = rtn.split('^');
		var err = myAry[0];
		var desc = myAry[1];
		if (err == 0) {
			$.messager.popover({msg: desc, type: 'success'});
			ordItmListObj().reload();
		}else {
			$.messager.popover({msg: desc, type: 'info'});
		}
	});
}

/**
 * 取勾选中的票据Id串
 */
function getCheckedInvStr() {
	var invAry = new Array();
	var rows = $('#invList').datagrid('getChecked');
	$.each(rows, function (index, row) {
		var prtRowId = row.prtRowId;
		var invFlag = row.invFlag;
		var tmpStr = prtRowId + ':' + invFlag;
		invAry.push(tmpStr);
	});
	var invStr = invAry.join('^');
	return invStr;
}

/**
 * 控制草药按处方退费
 */
function controlCNMedItm(index, row) {
	var prescNo = row.prescNo;
	var isCNMedItem = row.isCNMedItem;
	if ((prescNo == '') || (isCNMedItem != 1)) {
		return;
	}
	var rows = $('#ordItmList-' + getSelTabIndex()).datagrid('getRows');
	$.each(rows, function (idx, row) {
		if ((index == idx) || (prescNo != row.prescNo)) {
			return true;
		}
		setOrdItmRowChecked(idx, getOrdItmRowChecked(index));
	});
}

/**
 * 获取医嘱明细datagrid勾选/不勾选状态
 */
function setOrdItmRowChecked(index, checked) {
	GV.SelRowIndex = index;
	if (checked) {
		$('#ordItmList-' + getSelTabIndex()).datagrid('checkRow', index);
	}else {
		$('#ordItmList-' + getSelTabIndex()).datagrid('uncheckRow', index);
	}
	GV.SelRowIndex = undefined;
}

/**
 * 获取勾选的datagrid行数据
 */
function getCheckedInvSubStr() {
	var invSubAry = [];
	var rows = $('#ordItmList-' + getSelTabIndex()).datagrid('getChecked');
	$.each(rows, function (index, row) {
		invSubAry.push(row.invSubId);
	});
	var invSubStr = invSubAry.join('^');
	return invSubStr;
}

/**
 * 设置医嘱明细datagrid勾选/不勾选状态
 */
function getOrdItmRowChecked(index) {
	return getColumnValue(index, 'ck', 'ordItmList-' + getSelTabIndex()) == 1 ? true : false;
}

/**
 * 获取选中的tabs索引
 */
function getSelTabIndex() {
	var tabsObj = $HUI.tabs('#audit-tabs');
	return tabsObj.getTabIndex(tabsObj.getSelected());
}

/**
 * 加载默认的tabs内容
 */
function loadDefTabContent() {
	var index = 1;
	$HUI.tabs('#audit-tabs').select(index);   //设置选中
	loadOrdItmList();
}

/**
 * 获取当前医嘱明细grid对象
 */
function ordItmListObj() {
	return $HUI.datagrid('#ordItmList-' + getSelTabIndex());
}

/**
 * 获取当前医嘱明细grid对象
 */
function getTabsLength() {
	return $('table[id^="ordItmList"]').length;
}

/**
 * 获取当前tabs下的审核标识
 */
function getAuditFlag() {
	var index = getSelTabIndex();
	var auditFlag = '';
	switch (index) {
	case 1:
		auditFlag = 'U';
		break;
	case 3:
		auditFlag = 'A';
		break;
	}
	return auditFlag;
}

/**
 * 获取医嘱列数组
 */
function getOrdItmColumns(index) {
	var columns = [{title: 'ck', field: 'ck', checkbox: true},
				   {title: '医嘱', field: 'arcimDesc', width: 150},
				   {title: '申请数量', field: 'reqQty', width: 80},
				   {title: '单位', field: 'packUom', width: 60},
				   {title: '金额', field: 'reqAmt', align: 'right', width: 60},
				   {title: '处方号', field: 'prescNo', width: 130},
				   {title: '接收科室', field: 'recDept', width: 100},
				   {title: '申请人', field: 'reqUserName', width: 90},
				   {title: '申请时间', field: 'reqDate', width: 155,
					formatter: function (value, row, index) {
						return value + ' ' + row.reqTime;
					}
				   },
				   {title: '退费原因', field: 'reqReason', width: 80},
				   {title: '审核人', field: 'auditUserName', width: 80},
				   {title: '审核时间', field: 'auditDate', width: 155,
					formatter: function (value, row, index) {
						return value + ' ' + row.auditTime;
					}
				   },
				   {title: '医嘱ID', field: 'oeori', width: 70},
				   {title: 'reqFlag', field: 'reqFlag', hidden: true},
				   {title: 'invSubId', field: 'invSubId',hidden: true},
				   {title: 'isCNMedItem',field: 'isCNMedItem',hidden: true}];
				   
	switch (index) {
	case 1:
		var columnAry = [];
		var str = 'auditUserName^auditDate'; //不显示的列
		$.each(columns, function (index, column) {
			if (column) {
				if (str.indexOf(column.field) == -1) {
					columnAry.push(column);
				}
			}
		});
		columns = columnAry;
		break;
	case 2:
		columns = [{title: '医嘱', field: 'arcimDesc', width: 180},
				   {title: '数量', field: 'billQty', width: 80},
				   {title: '申请数量', field: 'alreadyReqQty', width: 80},
				   {title: '单位', field: 'packUom', width: 60},
				   {title: '金额', field: 'billAmt', align: 'right', width: 60},
				   {title: '处方号', field: 'prescNo', width: 130},
				   {title: '接收科室', field: 'recDept', width: 100},
				   {title: '执行情况', field: 'execInfo', width: 160},
				   {title: '审核人', field: 'auditUserName', width: 80},
				   {title: '审核时间', field: 'auditDate', width: 155,
					formatter: function (value, row, index) {
						return value + ' ' + row.auditTime;
					}
				   },
				   {title: '医嘱ID', field: 'oeori', width: 70}]
		break;
	}
	return columns;
}


/**
 * 清屏
 */
function clearClick() {
	$('#cardType').combobox('reload');
	$('#cardNo').val('');
	$('#invNo').val('');
	$('#patientNo').val('');
	$('#patName').val('');
	$('#userName').val('');
	var defDate = getDefStDate(0);
	$('#stDate').datebox('setValue', defDate);
	$('#endDate').datebox('setValue', defDate);
	$('#invList').datagrid('load', {
		ClassName: 'web.DHCOPBillRefundRequest',
		QueryName: 'FindReqInvInfo',
		stDate: '',
		endDate: '',
		receiptNo: '',
		patientNo: '',
		patientName: '',
		chargeUser: '',
		expStr: ''
	});
	$HUI.tabs('#audit-tabs').select(1);   //设置选中
	for (var i = 1; i <= getTabsLength(); i++) {
		$('#ordItmList-' + i).datagrid('loadData', {
			total: 0,
			rows: []
		});
	}
}