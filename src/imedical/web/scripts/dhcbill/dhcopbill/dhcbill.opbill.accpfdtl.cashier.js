/**
 * FileName: dhcbill.opbill.accpfdtl.cashier.js
 * Author: ZhYW
 * Date: 2021-12-14
 * Description: 按收费员汇总预交金明细账
 */

$(function () {
	$HUI.datagrid('#pfDtlList', {
		fit: true,
		border: true,
		bodyCls: 'panel-header-gray',
		fitColumns: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		className: "web.UDHCACFinBRRSQuery",
		queryName: "FootDeposit",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["StTime", "EndTime"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if (!cm[i].width) {
					cm[i].width = 100;
				}
			}
		},
		url: $URL,
		queryParams: {
			ClassName: "web.UDHCACFinBRRSQuery",
			QueryName: "FootDeposit",
			PFRowID: CV.PFRowID
		}
	});
});