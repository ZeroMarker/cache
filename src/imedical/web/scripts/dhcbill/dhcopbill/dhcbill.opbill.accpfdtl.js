/**
 * FileName: dhcbill.opbill.accpfdtl.js
 * Author: ZhYW
 * Date: 2021-12-16
 * Description: 余额汇总合计
 */

$(function () {
	var toolbar = [{
			text: '打印',
			iconCls: 'icon-print',
			handler: function () {
				printClick();
			}
		}
	];
	$HUI.datagrid("#pfDtlList", {
		fit: true,
		border: true,
		bodyCls: 'panel-header-gray',
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		toolbar: toolbar,
		className: "web.UDHCACFinBRFoot1",
		queryName: "ReadFBRAccDetails",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["CADate"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if (cm[i].field == "CATime") {
					cm[i].formatter = function (value, row, index) {
						return row.CADate + " " + value;
					};
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if ($.inArray(cm[i].field, ["CATime"]) != -1) {
						cm[i].width = 155;
					}
				}
			}
		},
		url: $URL,
		queryParams: {
			ClassName: "web.UDHCACFinBRFoot1",
			QueryName: "ReadFBRAccDetails",
			APFRowID: CV.PFRowID
		}
	});
});

function printClick() {
    var lastDateTime = getValueById("lastDateTime");
    var endDateTime = getValueById("endDateTime");
    var fileName = "DHCBILL-OPBILL-YJJSRHZ.rpx&APFRowID=" + CV.PFRowID + "&LastDateTime=" + lastDateTime + "&EndDateTime=" + endDateTime;
    var width = window.screen.width * 0.6;
    var height = window.screen.height * 0.6;
    DHCCPM_RQPrint(fileName, width, height);
}