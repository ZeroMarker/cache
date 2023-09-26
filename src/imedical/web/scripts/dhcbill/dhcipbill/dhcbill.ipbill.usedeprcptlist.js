/**
 * FileName: dhcbill.ipbill.usedeprcptlist.js
 * Anchor: ZhYW
 * Date: 2019-12-06
 * Description: 收费员已使用押金收据查询
 */

var GV = {};

$(function () {
	initQueryMenu();
	initDepRcptList();
});

function initQueryMenu() {
	var today = getDefStDate(0);
	$(".datebox-f").datebox("setValue", today);
	
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
		columns:[[{title: '收费员', field: 'TCashier', width: 100},
				  {title: '工号', field: 'TCasherNo', width: 100},
				  {title: '票据号段', field: 'TrcptNo', width: 260},
				  {title: '张数', field: 'TrcptNum', width: 100},
				  {title: '金额总计', field: 'Trcptsum', align: 'right', width: 120},
				  {title: '作废票据', field: 'Trcptnozf', width: 280},
				  {title: '作废张数', field: 'Trcptnumzf', width: 100},
				  {title: '当前票号', field: 'Tcurrno', width: 100}
			]],
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
			hospId:PUBLIC_CONSTANT.SESSION.HOSPID,
			title:getValueById("invTitle")
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
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID,
		title:getValueById("invTitle")
	};
	loadDataGridStore("depRcptList", queryParams);
}

/**
* 导出
*/
function exportClick() {
	var fileName = "DHCBILL-IPBILL-收费员已使用押金收据明细.rpx" + "&grp=3" + "&type=I";
	fileName += "&stdate=" + getValueById("stDate") + "&enddate=" + getValueById("endDate");
	fileName += "&stnum=" + getValueById("stNo") + "&endnum=" + getValueById("endNo");
	fileName += "&hospId=" + PUBLIC_CONSTANT.SESSION.HOSPID + "&title=" + getValueById("invTitle")  ;
	var maxHeight = ($(window).height() || 550) * 0.8;
	var maxWidth = ($(window).width() || 1366) * 0.8;
	DHCCPM_RQPrint(fileName, maxWidth, maxHeight);
}