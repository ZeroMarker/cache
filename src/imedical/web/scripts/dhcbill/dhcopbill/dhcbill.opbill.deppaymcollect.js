/**
 * FileName: dhcbill.opbill.deppaymcollect.js
 * Anchor: ZhYW
 * Date: 2019-12-07
 * Description: 预交金支付方式汇总查询
 */

var GV = {};

$(function () {
	initQueryMenu();
	initPaymList();
});

function initQueryMenu() {
	var today = getDefStDate(0);
	$(".datebox-f").datebox("setValue", today);
	
	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadPaymList();
		}
	});
	
	$HUI.linkbutton("#btn-export", {
		onClick: function () {
			exportClick();
		}
	});
}

function initPaymList() {
	GV.PaymList = $HUI.datagrid("#paymList", {
		fit: true,
		striped: true,
		border: false,
		singleSelect: true,
		rownumbers: true,
		pagination: true,
		pageSize: 20,
		data: [],
		columns:[[{title: '支付方式', field: 'TPayMode', width: 150},
				  {title: '收预交金', field: 'TPayDeposit', width: 200, align: 'right'},
				  {title: '退预交金', field: 'TRefundDeposit', width: 200, align: 'right'},
				  {title: '实收预交金', field: 'TPreDeposit', width: 200, align: 'right'}
			]]
	});
}

function loadPaymList() {
	var queryParams = {
		ClassName: "web.DHCOPBillDepositPaymode",
		QueryName: "DepositQuery",
		StartDate: getValueById("stDate"),
		EndDate: getValueById("endDate"),
		HospId: PUBLIC_CONSTANT.SESSION.HOSPID
	};
	loadDataGridStore("paymList", queryParams);
}

/**
* 导出
*/
function exportClick() {
	var stDate = getValueById("stDate");
	var endDate = getValueById("endDate");
	var curDate = getDefStDate(0);
	var fileName = "DHCBILL-OPBILL-YJJZFFSHZ.rpx&StartDate=" + stDate + "&EndDate=" + endDate;
	fileName += "&CurDate=" + curDate +  "&HospId=" + PUBLIC_CONSTANT.SESSION.HOSPID;

	var maxHeight = ($(window).height() || 550) * 0.8;
	var maxWidth = ($(window).width() || 1366) * 0.8;
	DHCCPM_RQPrint(fileName, maxWidth, maxHeight);
}