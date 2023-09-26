/**
 * FileName: DHCPEBill.OPBill.DailyInvDetail.js
 * Anchor: xy
 * Date: 2018-05-24
 * Description:门诊与体检日报合并中发票明细
 */
var PUBLIC_CONSTANT = {
	SESSION: {
		GUSER_ROWID: session['LOGON.USERID'],
		GROUP_ROWID: session['LOGON.GROUPID'],
		HOSP_ROWID: session['LOGON.HOSPID']
	},
	METHOD: {
		CLS: "web.DHCPE.DHCPEToOPBillInterface",
		QUERY: "FindInv"
	}
};

$(document).ready(function () {
	initInvListGrid();
});

function initInvListGrid() {
	$.cm({
		ClassName: "web.DHCPE.DHCPEToOPBillInterface",
		MethodName: "GetInvDetColumns"
	}, function (txtData) {
		var columnAry = new Array();
		$.each(txtData, function (index, item) {
			var column = {};
			column["title"] = item.title;
			column["field"] = item.field;
			column["align"] = item.align;
			column["width"] = item.width;
			columnAry.push(column);
		});
		var opbillInvListObj = $HUI.datagrid('#dhcpeInvList', {
				fit: true,
				striped: true,
				singleSelect: true,
				autoRowHeight: false,
				url: $URL,
				pagination: true,
				rownumbers: true,
				pageSize: 20,
				pageList: [20, 30, 40, 50],
				columns: [columnAry],
				queryParams: {
					ClassName: PUBLIC_CONSTANT.METHOD.CLS,
					QueryName: PUBLIC_CONSTANT.METHOD.QUERY,
					stDate: GlobalObj.stDate,
					stTime: GlobalObj.stTime,
					endDate: GlobalObj.endDate,
					endTime: GlobalObj.endTime,
					footId: GlobalObj.footId,
					guser: GlobalObj.guser,
					hospDR: GlobalObj.hospDR
				}
			});
	});
}
