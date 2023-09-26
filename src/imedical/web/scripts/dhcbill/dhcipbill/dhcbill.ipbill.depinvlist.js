/**
 * FileName: dhcbill.ipbill.depinvlist.js
 * Anchor: ZhYW
 * Date: 2019-11-28
 * Description: 押金发票明细查询
 */

var GV = {};

$(function () {
	initQueryMenu();
	initDepInvList();
});

function initQueryMenu() {
	var today = getDefStDate(0);
	$(".datebox-f").datebox("setValue", today);
	
	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadDepInvList();
		}
	});
	
	$HUI.linkbutton("#btn-export", {
		onClick: function () {
			exportClick();
		}
	});
	
	$HUI.linkbutton("#btn-clear", {
		onClick: function () {
			clearClick();
		}
	});
	
	//病案号查询事件
	$("#medicareNo").keydown(function (e) {
		medicareNoKeydown(e);
	});
	
	//收据号查询事件
	$("#receiptNo").keydown(function (e) {
		receiptNoKeydown(e);
	});
	
	//操作员
	$HUI.combobox("#guser", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.UDHCJFDepositSearch&QueryName=FindIPCashier&ResultSetType=array&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
		valueField: 'id',
		textField: 'text',
		defaultFilter: 4
	});
	
	//支付方式
	$HUI.combobox("#paymode", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.UDHCOPOtherLB&QueryName=ReadCTPayMode&ResultSetType=array',
		valueField: 'CTPM_RowId',
		textField: 'CTPM_Desc',
		defaultFilter: 4
	});
	
	//票据状态
	$HUI.combobox("#rcptStatus", {
		panelHeight: 'auto',
		data: [{value: 'N', text: '正常'},
			   {value: 'I', text: '中途结算'},
			   {value: 'A', text: '作废'},
			   {value: 'BS', text: '已冲红'},
			   {value: 'S', text: '冲红'}
		],
		valueField: 'value',
		textField: 'text',
		defaultFilter: 4
	});
	
	//票据类型
	$HUI.combobox("#rcptType", {
		panelHeight: 'auto',
		data: [{value: 'Y', text: '押金收据'},
		       {value: 'N', text: '住院发票'}
		],
		valueField: 'value',
		textField: 'text'
	});
	
	//患者类型
	$HUI.combobox("#patType", {
		panelHeight: 'auto',
		data: [{value: 'Y', text: '医保患者'},
		       {value: 'N', text: '非医保患者'}
		],
		valueField: 'value',
		textField: 'text',
		onChange: function(newValue, oldValue) {
			$("#admReason").combobox("clear").combobox("reload");
		}
	});
	
	//费别
	$HUI.combobox("#admReason", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCIPBillInvDetailSearch&QueryName=FindAdmReason&ResultSetType=array',
		valueField: 'rowId',
		textField: 'admReaDesc',
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			param.insuFlag = getValueById("patType");
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		}
	});
	
	//押金类型
	$HUI.combobox("#depositType", {
		panelHeight: 'auto',
		url: $URL + '?ClassName=web.DHCIPBillDeposit&QueryName=FindGrpDepType&ResultSetType=array',
		method: 'GET',
		valueField: 'id',
		textField: 'text',
		defaultFilter: 4,
		onBeforeLoad: function(param) {
			param.groupId = PUBLIC_CONSTANT.SESSION.GROUPID;
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		}
	});
}

function initDepInvList() {
	$HUI.datagrid("#depInvList", {
		fit: true,
		striped: true,
		border: false,
		singleSelect: true,
		rownumbers: true,
		pagination: true,
		pageSize: 20,
		data: [],
		columns:[[{title: '收费员', field: 'addUser', width: 80},
				  {title: '票据类型', field: 'invType', width: 100},
				  {title: '票据号', field: 'invNo', width: 100},
				  {title: '患者姓名', field: 'name', width: 100},
				  {title: '登记号', field: 'ipNo', width: 100},
				  {title: '病案号', field: 'TzyNO', width: 100},
				  {title: '收据日期', field: 'invDate', width: 100},
				  {title: '金额', field: 'amount', align: 'right', width: 100},
				  {title: '退费人员', field: 'user', width: 100},
				  {title: '退费日期', field: 'backDate', width: 100},
				  {title: '票据状态', field: 'invStatus', width: 70},
				  {title: '原发票号', field: 'oldInvNo', width: 100},
				  {title: '支付方式', field: 'TPayMode', width: 150},
				  {title: '费别', field: 'Tybtype', width: 80},
				  {title: '医保卡号', field: 'TInsuCardNo', width: 100},
				  {title: '个人账户支付', field: 'TZHPay', align: 'right', width: 100},
				  {title: '统筹支付', field: 'TTCPay', align: 'right', width: 100}
			]]
	});
}

function loadDepInvList() {
	var expStr = PUBLIC_CONSTANT.SESSION.GROUPID + "!" + PUBLIC_CONSTANT.SESSION.CTLOCID + "!" + PUBLIC_CONSTANT.SESSION.HOSPID;
	var queryParams = {
		ClassName: "web.DHCIPBillInvDetailSearch",
		QueryName: "FindInvDetail",
		stDate: getValueById("stDate"),
		endDate: getValueById("endDate"),
		guser: getValueById("guser") || "",
		rcptStatus: getValueById("rcptStatus") || "",
		rcptType: getValueById("rcptType") || "",
		PayMode: getValueById("paymode") || "",
		InvNo: getValueById("receiptNo"),
		zyno: getValueById("medicareNo"),
		PatType: getValueById("patType") || "",
		AdmReason: getValueById("admReason") || "",
		depositType: getValueById("depositType") || "",
		expStr: expStr
	};
	loadDataGridStore("depInvList", queryParams);
}

/**
* 病案号回车查询
*/
function medicareNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		loadDepInvList();
	}
}

/**
* 收据号回车查询
*/
function receiptNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		loadDepInvList();
	}
}

/**
* 清屏
*/
function clearClick() {
	$(":text:not(.pagination-num)").val("");
	$(".combobox-f:not(#depositType)").combobox("clear");
	$("#depositType").combobox("reload");
	var today = getDefStDate(0);
	$(".datebox-f").datebox("setValue", today);
	loadDepInvList();
}

/**
* 导出
*/
function exportClick() {
	var expStr = PUBLIC_CONSTANT.SESSION.GROUPID + "!" + PUBLIC_CONSTANT.SESSION.CTLOCID + "!" + PUBLIC_CONSTANT.SESSION.HOSPID;
	
	var fileName = "DHCBILL-IPBILL-YJJFPMX.rpx" + "&stDate=" + getValueById("stDate") + "&endDate=" + getValueById("endDate");
	fileName += "&guser=" + (getValueById("guser") || "") + "&rcptStatus=" + (getValueById("rcptStatus") || "") + "&rcptType=" + (getValueById("rcptType") || "");
	fileName += "&PayMode=" + (getValueById("paymode") || "") + "&InvNo=" + getValueById("receiptNo") + "&zyno=" + getValueById("medicareNo");
	fileName += "&PatType=" + (getValueById("patType") || "") + "&AdmReason=" + (getValueById("admReason") || "") + "&depositType=" + (getValueById("depositType") || "");
	fileName += "&expStr=" + expStr;
	
	var maxHeight = ($(window).height() || 550) * 0.8;
	var maxWidth = ($(window).width() || 1366) * 0.8;
	DHCCPM_RQPrint(fileName, maxWidth, maxHeight);
}