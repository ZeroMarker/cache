/**
 * FileName: dhcbill.ipbill.charge.paym.js
 * Anchor: ZhYW
 * Date: 2019-03-18
 * Description: 住院收费支付方式弹窗
 */﻿

$(function () {
	refreshBar("", getParam("EpisodeID"));
	setGlobalValue("EpisodeID", getParam("EpisodeID"));
	setGlobalValue("BillID", getParam("BillID"));
	
	//初始化查询菜单
	initQueryMenu();
	
	//初始化Grid
	initPayMList();
	initDepositList();
	
	setPayMPanelTitle();   //设置支付方式列表title
	setDepPanelTitle();    //设置押金列表title
	checkInv();            //设置默认发票号
	
	loadGridData();
	
	initPatFeeInfo();
});

function initQueryMenu() {
	//结算
	$HUI.linkbutton("#btn-disCharge", {
		onClick: function () {
			disChargeClick();
		}
	});
	
	//打印费用清单
	$HUI.linkbutton("#btn-prtFeeDtl", {
		onClick: function () {
			printFeeDtlClick();
		}
	});
	
	//打印医保结算单
	$HUI.linkbutton("#btn-prtInsuJSD", {
		onClick: function () {
			printInsuJSDClick();
		}
	});
	
	//打印收据
	$HUI.linkbutton("#btn-prtInv", {
		onClick: function () {
			printFPClick();
		}
	});
	
	//作废收据
	$HUI.linkbutton("#btn-abortInv", {
		onClick: function () {
			abortFPClick();
		}
	});
	
	//实付回车
	$("#patPaidAmt").keydown(function (e) {
		patPaidAmtKeydown(e);
	});
}

/**
* 初始化押金Grid
*/
function initDepositList() {
	GV.DepositList = $HUI.datagrid("#tDepositList", {
		fit: true,
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		title: '押金列表',
		checkOnSelect: false,
		selectOnCheck: false,
		singleSelect: true,
		autoRowHeight: false,
		fitColumns: true,
		toolbar: [],
		rownumbers: true,
		pageSize: 99999999,
		loadMsg: '',
		columns: [[{title: 'ck', field: 'ck', checkbox: true},
				   {title: '金额', field: 'TDepAmt', align: 'right', width: 80},
				   {title: '押金单号', field: 'TDepNO', width: 100},
				   {title: '支付方式', field: 'TDepPayM', width: 100,
			   		formatter: function (value, row, index) {
						if (row.TBillFlag == "0") {
							return value + " ( <span style='color:#ff0000'>未到账</span> )";
						}else {
							return value;
						}
					}
				   },
				   {title: '交款日期', field: 'TDepPrtDate', width: 90},
				   {title: '收费员', field: 'TUser', width: 80},
				   {title: '状态', field: 'TPrtStatus', width: 60},
				   {title: '支票到账标识', field: 'TBillFlag', hidden: true},
				   {title: 'TPayMRowid', field: 'TPayMRowid', hidden: true},
				   {title: 'TRcptRowid', field: 'TRcptRowid', hidden: true},
				   {title: 'TBankBackFlag', field: 'TBankBackFlag',hidden: true},
				   {title: 'TRefundNo', field: 'TRefundNo', hidden: true},
				   {title: 'TPrtStatusFlag', field: 'TPrtStatusFlag',hidden: true},
				   {title: 'PAPMIRowID', field: 'patientid',hidden: true},
				   {title: 'TARRCPTDR', field: 'TARRCPTDR', hidden: true}
			]],
		onLoadSuccess: function (data) {
			onLoadSuccessDepList(data);
		},
		onCheckAll: function (rows) {
			onCheckAllDepList(rows);
		},
		onUncheckAll: function (rows) {
			onUncheckAllDepList();
		},
		onCheck: function (index, rowData) {
			onCheckDepList(index, rowData);
		},
		onUncheck: function (index, rowData) {
			onUncheckDepList(index, rowData);
		}
	});
}

/**
* 加载界面Grid数据
*/
function loadGridData() {
	loadPayMList();
	loadDepositList();
}

/**
* 押金支付方式汇总金额
*/
function setDepPanelTitle() {
	$m({
		ClassName: "web.UDHCJFBaseCommon",
		MethodName: "GetDepositPayM",
		adm: getGlobalValue("EpisodeID")
	}, function (txt) {
		if (txt) {
			txt = txt.replace(/\^/g, "：").replace(/!/g, " ");
			GV.DepositList.getPanel().panel("setTitle", "押金列表<span style='margin-left:30px;'>" + txt + "</span>");
		}
	});
}

/**
* 结算
*/
function disChargeClick() {
	$.messager.confirm("确认", "是否确认结算?", function (r) {
		if (r) {
			charge();
		}
	});
}

/**
* 打印费用清单
*/
function printFeeDtlClick() {
	var admInDaysStr = $.m({ClassName: "web.UDHCJFBaseCommon", MethodName: "GetPatAdmInDays", PAADMRowID: getGlobalValue("EpisodeID"), BillNo: getGlobalValue("BillID")}, false);
	var myAry = admInDaysStr.split("^");
	var stDate = myAry[0];
	var endDate = myAry[1];
	var tarCateId = "";
	$.m({
		ClassName: "web.DHCBillDtlListPrtLog",
		MethodName: "SavePrtLog",
		userId: PUBLIC_CONSTANT.SESSION.USERID,
		invStr: getGlobalValue("BillID") + ":" + "IP"
	}, function (rtn) {
		if (rtn != 0) {
			$.messager.popover({msg: '保存日志失败', type: 'error'});
			return;
		}
		var parameter = "billId=" + getGlobalValue("BillID") + ";" + "stDate=" + stDate + ";" + "endDate=" + endDate + ";" + "tarCateId=" + tarCateId;
		var fileName = "{DHCBILL-IPBILL-FYQD.rpx(" + parameter + ")}";
		DHCCPM_RQDirectPrint(fileName);
	});
}