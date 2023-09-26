/**
 * FileName: dhcbill.ipbill.paymentmonad.js
 * Anchor: Suhuide
 * Date: 2018-06-28
 * Modify: ZhYW 2019-07-12
 * Description: 住院押金催款单
 */

$.extend($.fn.validatebox.defaults.rules, {
	checkMinAmt: {    //校验最小值
	    validator: function(value) {
		    return ((value == "-") || (value > -1000000000));
		},
		message: "金额输入过小"
	},
	checkMaxAmt: {    //校验最大值
	    validator: function(value) {
		    return ((value == "-") || (value < 1000000000));
		},
		message: "金额输入过大"
	}
});

$(function () {
	initQueryMenu();
	initListGrid();
});

var initQueryMenu = function () {
	$HUI.linkbutton("#btnSearch", {
		onClick: function () {
			loadPaymentMonadList();
		}
	});
	$HUI.linkbutton("#btnExport", {
		onClick: function () {
			ExportClick();
		}
	});
	$HUI.linkbutton("#btnPrint", {
		onClick: function () {
			PrintClick();
		}
	});
	$HUI.linkbutton("#btnPrint2", {
		onClick: function () {
			PrintClick2();
		}
	});
	
	$HUI.combobox("#menu-ward", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.UDHCJFCKD&QueryName=FindWard&ResultSetType=array',
		mode: 'remote',
		valueField: 'id',
		textField: 'text',
		//enterNullValueClear: false,				//默认值true。当为false时，在输入框内回车，没有匹配值不清空输入框
		value: PUBLIC_CONSTANT.SESSION.WARDID,      //设置默认本病区
		onBeforeLoad: function (param) {
			param.desc = param.q;
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		}
	});
	
	$HUI.combobox("#menu-feetype", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.UDHCJFCKD&QueryName=FindAdmReason&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		}
	});
}

var initListGrid = function () {
	$HUI.datagrid("#paymentmonadList", {
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		selectOnCheck: false,
		checkOnSelect: false,
		fitColumns: true,
		url: $URL,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		idField: 'TAdm',
		columns: [[{field: 'ok', checkbox: true},
		           {title: '病区', field: 'TWard', width: 150},
		           {title: '床位', field: 'TBedName', width: 80},
		           {title: '姓名', field: 'TPatName', width: 100},
		           {title: '登记号', field: 'TRegNo', width: 120},
		           {title: '押金', field: 'TDeposit', align: 'right', width: 100},
		           {title: '未结算费用', field: 'TTotalAmt', align: 'right', width: 110},
		           {title: '自付金额', field: 'TPatShareAmt', align: 'right', width: 100},
		           {title: '余额', field: 'TBalAmt', align: 'right', width: 100,
					styler: function(value, row, index){
						if (+value < 0){
							return 'color:#FF0000;';
						}
					}
				   },
				   {title: '性别', field: 'TSex', width: 80},
				   {title: '费别', field: 'TAdmReason', width: 80},
				   {title: '入院时间', field: 'TAdmDatTime', width: 155},
				   {title: '担保金额', field: 'TWarrantAmt', align: 'right', width: 100},
				   {title: '住院号', field: 'TMedicareNo', width: 100},
				   {title: '诊断', field: 'TMrDiagnos', width: 200},
				   {title: 'TAdm', field: 'TAdm', hidden: true}
			]],
		queryParams: {
			ClassName: 'web.UDHCJFCKD',
			QueryName: 'getpatient',
			wardId: getValueById('menu-ward') || '',
			balance: getValueById('menu-balance'),
			episodeId: getParam('EpisodeID'),
			admReasonId: getValueById('menu-feetype') || '',
			selAdmStr: ''
		},
		onLoadSuccess: function (data) {
			$(this).datagrid('clearChecked');
		}
	});
}

function loadPaymentMonadList() {
	if (!checkData()) {
		return bool;
	}
	var queryParams = {
		ClassName: 'web.UDHCJFCKD',
		QueryName: 'getpatient',
		wardId: getValueById('menu-ward') || '',
		balance: getValueById('menu-balance'),
		episodeId: getParam('EpisodeID'),
		admReasonId: getValueById('menu-feetype') || '',
		selAdmStr: ''
	};
	loadDataGridStore('paymentmonadList', queryParams);
}

/**
 * 导出催款单明细
 * @method ExportClick
 * @author Suhuide
 */
function ExportClick() {
	if (!checkData()) {
		return bool;
	}
	var wardId = getValueById('menu-ward') || '';
	var balance = getValueById('menu-balance');
	var episodeId = getParam('EpisodeID');
	var admReasonId = getValueById('menu-feetype') || '';
	var selAdmStr = "";
	var fileName = "DHCBILL-IPBill-YJCKD.rpx&wardId=" + wardId + "&balance=" + balance + "&episodeId=" + episodeId + "&admReasonId=" + admReasonId + "&selAdmStr=" + selAdmStr;
	var maxWidth = $(window).width() || 1366;
	var maxHeight = $(window).height() || 550;

	DHCCPM_RQPrint(fileName, maxWidth, maxHeight);
}

/**
 * 打印催款单信息
 * @method PrintClick
 * @author Suhuide
 */
function PrintClick() {
	if (!checkData()) {
		return bool;
	}
	var selAdmStr = getCheckedAdmStr();
	if (selAdmStr == "") {
		$.messager.alert('提示', '请选择要打印的催款明细', 'info');
		return;
	}
	var wardId = getValueById('menu-ward') || '';
	var balance = getValueById('menu-balance');
	var episodeId = getParam('EpisodeID');
	var admReasonId = getValueById('menu-feetype') || '';
	var curDate = getDefStDate(0);
	var fileName = "DHCBILL-IPBill-YJCKD1.rpx&wardId=" + wardId + "&balance=" + balance + "&episodeId=" + episodeId + "&admReasonId=" + admReasonId + "&selAdmStr=" + selAdmStr;
	fileName += "&curDate=" + curDate;
	var maxWidth = $(window).width() || 1366;
	var maxHeight = $(window).height() || 550;

	DHCCPM_RQPrint(fileName, maxWidth, maxHeight);
}

function PrintClick2() {
	if (!checkData()) {
		return bool;
	}
	var selAdmStr = getCheckedAdmStr();
	if (selAdmStr == "") {
		$.messager.alert('提示', '请选择要打印的催款明细', 'info');
		return;
	}
	var wardId = getValueById('menu-ward') || '';
	var balance = getValueById('menu-balance');
	var episodeId = getParam('EpisodeID');
	var admReasonId = getValueById('menu-feetype') || '';
	var curDate = getDefStDate(0);
	var fileName = "DHCBILL-IPBill-YJCKD2.rpx&wardId=" + wardId + "&balance=" + balance + "&episodeId=" + episodeId + "&admReasonId=" + admReasonId + "&selAdmStr=" + selAdmStr;
	fileName += "&curDate=" + curDate;
	var maxWidth = $(window).width() || 1366;
	var maxHeight = $(window).height() || 550;

	DHCCPM_RQPrint(fileName, maxWidth, maxHeight);
}

function getCheckedAdmStr() {
	var myAry = [];
	$.each($('#paymentmonadList').datagrid('getChecked'), function (index, row) {
		var episodeID = row.TAdm;
		if (episodeID) {
			myAry.push(episodeID);
		}
	});
	var eposodeStr = myAry.join('^');
	
	return eposodeStr;
}

function checkData() {
	var bool = true;
	$(".validatebox-text").each(function() {
		if (!$(this).validatebox("isValid")) {
			bool = false;
			return false;
		}
	});
	return bool;
}