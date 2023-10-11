/**
 * FileName: dhcbill.ipbill.strikedeplist.js
 * Author: ZhYW
 * Date: 2019-12-05
 * Description: 已冲退预交金查询
 */

$(function () {
	initQueryMenu();
	initStrikeDepList();
});

function initQueryMenu() {
	$(".datebox-f").datebox("setValue", CV.DefDate);
	
	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadStrikeDepList();
		}
	});
	
	$HUI.linkbutton("#btn-export", {
		onClick: function () {
			exportClick();
		}
	});
	
	//操作员
	$HUI.combobox("#guser", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryInvUser&ResultSetType=array&invType=I&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5
	});
}

function initStrikeDepList() {
	$HUI.datagrid("#strikeDepList", {
		fit: true,
		border: false,
		singleSelect: true,
		rownumbers: true,
		pagination: true,
		pageSize: 20,
		className: "web.UDHCJFDepositSearch",
		queryName: "FindDepositByStrike",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["TPrintDate", "TInvPrtDate"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if (cm[i].field == "TPrintTime") {
					cm[i].formatter = function (value, row, index) {
						return row.TPrintDate + " " + value;
					};
				}
				if (cm[i].field == "TInvPrtTime") {
					cm[i].formatter = function (value, row, index) {
						return row.TInvPrtDate + " " + value;
					};
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if ($.inArray(cm[i].field, ["TPrintTime", "TInvPrtTime"]) != -1) {
						cm[i].width = 160;
					}
				}
			}
		},
		url: $URL,
		queryParams: {
			ClassName: "web.UDHCJFDepositSearch",
			QueryName: "FindDepositByStrike",
			StDate: getValueById("stDate"),
			EndDate: getValueById("endDate"),
			Guser: getValueById("guser") || "",
			flag: getValueById("isHandin") ? 1 : 0,
			HospId: PUBLIC_CONSTANT.SESSION.HOSPID
		}
	});
}

function loadStrikeDepList() {
	var queryParams = {
		ClassName: "web.UDHCJFDepositSearch",
		QueryName: "FindDepositByStrike",
		StDate: getValueById("stDate"),
		EndDate: getValueById("endDate"),
		Guser: getValueById("guser") || "",
		flag: getValueById("isHandin") ? 1 : 0,
		HospId: PUBLIC_CONSTANT.SESSION.HOSPID
	};
	loadDataGridStore("strikeDepList", queryParams);
}

/**
* 导出
*/
function exportClick() {
	var fileName = "DHCBILL-IPBILL-YCTYJJMX.rpx" + "&StDate=" + getValueById("stDate") + "&EndDate=" + getValueById("endDate");
	fileName += "&Guser=" + (getValueById("guser") || "") + "&flag=" + (getValueById("isHandin") ? 1 : 0);
	fileName += "&HospId=" + PUBLIC_CONSTANT.SESSION.HOSPID;
	var maxHeight = $(window).height() * 0.8;
	var maxWidth = $(window).width() * 0.8;
	DHCCPM_RQPrint(fileName, maxWidth, maxHeight);
}