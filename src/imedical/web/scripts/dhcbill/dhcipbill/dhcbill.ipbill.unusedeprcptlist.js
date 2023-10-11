/**
 * FileName: dhcbill.ipbill.unusedeprcptlist.js
 * Author: ZhYW
 * Date: 2019-12-30
 * Description: 收费员未使用押金收据查询
 */

$(function () {
	//收费员
	$HUI.combobox("#guser", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryInvUser&ResultSetType=array&invType=' + CV.RcptType + '&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5,
		selectOnNavigation: false,
		onChange: function(newValue, oldValue) {
			GV.RcptList.load({
				ClassName: "web.UDHCJFReceipt",
				QueryName: "FindrcptNum",
				type: CV.RcptType,
				hospId: PUBLIC_CONSTANT.SESSION.HOSPID,
				userId: newValue
			});
		}
	});
	
	GV.RcptList = $HUI.datagrid("#rcptList", {
		fit: true,
		border: false,
		rownumbers: true,
		pagination: true,
		pageSize: 20,
		className: "web.UDHCJFReceipt",
		queryName: "FindrcptNum",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if (!cm[i].width) {
					cm[i].width = 200;
				}
			}
		},
		url: $URL,
		queryParams: {
			ClassName: "web.UDHCJFReceipt",
			QueryName: "FindrcptNum",
			type: CV.RcptType,
			hospId: PUBLIC_CONSTANT.SESSION.HOSPID,
			userId: getValueById("guser")
		}
	});
});