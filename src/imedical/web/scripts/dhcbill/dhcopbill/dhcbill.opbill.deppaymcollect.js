/**
 * FileName: dhcbill.opbill.deppaymcollect.js
 * Author: ZhYW
 * Date: 2019-12-07
 * Description: 预交金支付方式汇总查询
 */

$(function () {
	initQueryMenu();
	initPaymList();
});

function initQueryMenu() {
	$(".datebox-f").datebox("setValue", CV.DefDate);
	
	//押金类型
	$HUI.combobox("#depositType", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryGrpDepType&ResultSetType=array&groupId=' + PUBLIC_CONSTANT.SESSION.GROUPID + '&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
		valueField: 'id',
		textField: 'text',
		blurValidValue: true
	});
	
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
		className: "web.DHCOPBillDepositPaymode",
		queryName: "DepositQuery",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if (!cm[i].width) {
					cm[i].width = 100;
				}
			}
		}
	});
}

function loadPaymList() {
	var queryParams = {
		ClassName: "web.DHCOPBillDepositPaymode",
		QueryName: "DepositQuery",
		StartDate: getValueById("stDate"),
		EndDate: getValueById("endDate"),
		HospId: PUBLIC_CONSTANT.SESSION.HOSPID,
		DepTypeId: getValueById("depositType")
	};
	loadDataGridStore("paymList", queryParams);
}

/**
* 导出
*/
function exportClick() {
	var stDate = getValueById("stDate");
	var endDate = getValueById("endDate");
	var depTypeId = getValueById("depositType")
	var fileName = "DHCBILL-OPBILL-YJJZFFSHZ.rpx&StartDate=" + stDate + "&EndDate=" + endDate;
	fileName += "&HospId=" + PUBLIC_CONSTANT.SESSION.HOSPID + "&DepTypeId=" + depTypeId;
	
	var maxHeight = ($(window).height() || 550) * 0.8;
	var maxWidth = ($(window).width() || 1366) * 0.8;
	DHCCPM_RQPrint(fileName, maxWidth, maxHeight);
}