﻿/**
 * FileName: dhcbill.opbill.dailyopbillinvdetails.js
 * Anchor: ZhYW
 * Date: 2018-03-08
 * Description: 门诊收费明细
 */

$(function () {
	$.cm({
		ClassName: "web.DHCBillGroupConfig",
		MethodName: "GetInvDetColumns"
	}, function (txtData) {
		var columnAry = new Array();
		$.each(txtData, function (index, item) {
			var column = {};
			column["title"] = item.title;
			column["field"] = item.field;
			column["align"] = item.align;
			column["width"] = item.width;
			var str = "TMedicareNo^TCTDepSum^TCTDepRcptNoStr";    //不显示的列
			if (str.search(item.field) == -1) {
				columnAry.push(column);
			}
		});
		$HUI.datagrid('#opbillInvList', {
			fit: true,
			striped: true,
			border: false,
			autoRowHeight: false,
			url: $URL,
			pagination: true,
			rownumbers: true,
			pageSize: 20,
			pageList: [20, 30, 40, 50],
			columns: [columnAry],
			toolbar: [],
			queryParams: {
				ClassName: "web.DHCOPBillDailyDetails",
				QueryName: "FindOPBillInvDetails",
				stDate: GV.stDate,
				stTime: GV.stTime,
				endDate: GV.endDate,
				endTime: GV.endTime,
				footId: GV.footId,
				guser: GV.guser,
				hospDR: GV.hospDR
			}
		});
	});
});
