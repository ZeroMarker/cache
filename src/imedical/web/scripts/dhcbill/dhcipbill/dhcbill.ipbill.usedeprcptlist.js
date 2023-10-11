/**
 * FileName: dhcbill.ipbill.usedeprcptlist.js
 * Author: ZhYW
 * Date: 2019-12-06
 * Description: 收费员已使用押金收据查询
 */

$(function () {
	initQueryMenu();
	initDepRcptList();
});

function initQueryMenu() {
	$(".datebox-f").datebox("setValue", CV.DefDate);
	
	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadDepRcptList();
		}
	});
	
	$HUI.linkbutton("#btn-export", {
		onClick: function () {
			exportClick();
		}
	});
}

function initDepRcptList() {
	$HUI.datagrid("#depRcptList", {
		fit: true,
		striped: true,
		border: false,
		singleSelect: true,
		rownumbers: true,
		pagination: true,
		pageSize: 20,
		className: "web.UDHCJFReceipt",
		queryName: "Findrcptsum",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["TrcptNo", "Trcptnozf"]) != -1) {
					cm[i].showTip = true;
				}
				if (!cm[i].width) {
					cm[i].width = 130;
				}
			}
		},
		url: $URL,
		queryParams: {
			ClassName: "web.UDHCJFReceipt",
			QueryName: "Findrcptsum",
			grp: 3,
			type: "I",
			stdate: getValueById("stDate"),
			enddate: getValueById("endDate"),
			stnum: getValueById("stNo"),
			endnum: getValueById("endNo"),
			title: getValueById("title"),
			hospId: PUBLIC_CONSTANT.SESSION.HOSPID
		},
		rowStyler: function (index, row) {
			if (row.TCashier.indexOf("合计") != -1) {
				return 'font-weight: bold';
			}
		}
	});
}

function loadDepRcptList() {
	var queryParams = {
		ClassName: "web.UDHCJFReceipt",
		QueryName: "Findrcptsum",
		grp: 3,
		type: "I",
		stdate: getValueById("stDate"),
		enddate: getValueById("endDate"),
		stnum: getValueById("stNo"),
		endnum: getValueById("endNo"),
		title: getValueById("title"),
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	};
	loadDataGridStore("depRcptList", queryParams);
}

/**
* 导出
*/
function exportClick() {
	var fileName = "DHCBILL-IPBILL-YSYYJSJMX.rpx" + "&grp=3" + "&type=I";
	fileName += "&stdate=" + getValueById("stDate") + "&enddate=" + getValueById("endDate");
	fileName += "&stnum=" + getValueById("stNo") + "&endnum=" + getValueById("endNo");
	fileName += "&title=" + getValueById("title") + "&hospId=" + PUBLIC_CONSTANT.SESSION.HOSPID;
	var maxHeight = ($(window).height() || 550) * 0.8;
	var maxWidth = ($(window).width() || 1366) * 0.8;
	DHCCPM_RQPrint(fileName, maxWidth, maxHeight);
}