/**
 * FileName: dhcbill.ipbill.dailyipbillinvdetails.js
 * Anchor: ZhYW
 * Date: 2018-03-16
 * Description: 出院结算收费明细
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
			var str = "TInvRoundErrSum";    //不显示的列
			if (str.search(item.field) == -1) {
				columnAry.push(column);
			}
		});

		$HUI.datagrid('#ipbillInvList', {
			fit: true,
			striped: true,
			border: false,
			url: $URL,
			pagination: true,
			rownumbers: true,
			pageSize: 20,
			pageList: [20, 30, 40, 50],
			toolbar: [],
			columns: [columnAry],
			queryParams: {
				ClassName: "web.DHCIPBillDailyDetails",
				QueryName: "FindIPBillInvDetails",
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
