/**
 * FileName: dhcbill.opbill.billoeitm.js
 * Author: ZhYW
 * Date: 2018-19-20
 * Description: 账单医嘱明细
 */

$(function () {
	$HUI.datagrid("#oeitmList", {
		fit: true,
		bodyCls: 'panel-header-gray',
		fitColumns: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		className: "web.UDHCJFITM",
		queryName: "FindOrdDetail",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if (!cm[i].width) {
					cm[i].width = 100;
				}
			}
		},
		url: $URL,
		queryParams: {
			ClassName: "web.UDHCJFITM",
			QueryName: "FindOrdDetail",
			BillNo: CV.BillId
		}
	});
});