/**
 * FileName: dhcbill.opbill.invoeitm.js
 * Author: ZhYW
 * Date: 2018-12-15
 * Description: 发票医嘱明细
 */

$(function () {
	$HUI.datagrid("#oeitmList", {
		fit: true,
		border: true,
		bodyCls: 'panel-header-gray',
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		className: "web.UDHCOEORDOP1",
		queryName: "ReadOEByINVRowID",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["TOEORIStDate"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if (cm[i].field == "TOEORIStTime") {
					cm[i].formatter = function (value, row, index) {
						return row.TOEORIStDate + " " + value;
					}
				}
				if (cm[i].field == "TCoverMainIns") {
					cm[i].formatter = function (value, row, index) {
						if (row.TOrderRowid) {
							var color = (value == "Y") ? "#21ba45" : "#f16e57";
							return "<font color=\"" + color + "\">" + ((value == "Y") ? $g("是") : $g("否")) + "</font>";
						}
					}
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if (cm[i].field == "TOrder") {
						cm[i].width = 130;
					}
					if (cm[i].field == "TOrderQty") {
						cm[i].width = 60;
					}
					if (cm[i].field == "TPackUOM") {
						cm[i].width = 70;
					}
					if (cm[i].field == "TOEORIStTime") {
						cm[i].width = 155;
					}
					if (cm[i].field == "TOEORILabNo") {
						cm[i].width = 130;
					}
				}
			}
		},
		url: $URL,
		queryParams: {
			ClassName: "web.UDHCOEORDOP1",
			QueryName: "ReadOEByINVRowID",
			invRowId: CV.InvRowId,
			invType: CV.InvType
		}
	});
});