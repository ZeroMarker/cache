/**
 * FileName: dhcbill.ipbill.unhandlist.js
 * Author: ZhYW
 * Date: 2022-01-14
 * Description: 收费员未结算查询
 */

$(function () {
	initQueryMenu();
	initUnHandList();
});

function initQueryMenu() {
	$(".datebox-f").datebox("setValue", CV.DefDate);
	
	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadUnHandList();
		}
	});
	
	$HUI.linkbutton("#btn-print", {
		onClick: function () {
			printClick();
		}
	});
	
	//收费员
	$HUI.combobox("#userName", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryInvUser&ResultSetType=array&invType=I&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5
	});
}

function initUnHandList() {
	GV.UnHandList = $HUI.datagrid("#unHandList", {
		fit: true,
		striped: true,
		border: false,
		singleSelect: true,
		rownumbers: true,
		pagination: true,
		pageSize: 20,
		className: "web.UDHCJFDailyHand",
		queryName: "FindNotHandin",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if (cm[i].field == "UserName") {
					cm[i].title = "收费员";
				}
				if (!cm[i].width) {
					cm[i].width = 110;
				}
			}
		}
	});
}

function loadUnHandList() {
	var queryParams = {
		ClassName: "web.UDHCJFDailyHand",
		QueryName: "FindNotHandin",
		EndDate: getValueById("endDate"),
		UserId: getValueById("userName") || "",
		HospId: PUBLIC_CONSTANT.SESSION.HOSPID
	};
	loadDataGridStore("unHandList", queryParams);
}

/**
 * 打印
 */
function printClick() {
	var endDate = getValueById("endDate");
	var userId = getValueById("userName");
	var fileName = "DHCBILL-IPBILL-WJSCX.rpx&EndDate=" +endDate + "&UserId=" + userId + "&HospId=" + PUBLIC_CONSTANT.SESSION.HOSPID;
	var width = $(window).width() * 0.8;
	var height  = $(window).height() * 0.8;
	DHCCPM_RQPrint(fileName, width, height);
}