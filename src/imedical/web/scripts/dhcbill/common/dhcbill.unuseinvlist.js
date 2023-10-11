/**
 * FileName: dhcbill.unuseinvlist.js
 * Author: ZhYW
 * Date: 2019-12-30
 * Description: 收费员未使用发票查询
 */

$(function () {
	initQueryMenu();
	initInvList();
});

function initQueryMenu() {
	//票据类型
	$HUI.combobox("#invType", {
		panelHeight: 150,
		editable: false,
		url: $URL + '?ClassName=web.UDHCJFInvprt&QueryName=FindInvType&ResultSetType=array',
		valueField: 'code',
		textField: 'text',
		defaultFilter: 5,
		selectOnNavigation: false,
		onSelect: function(rec) {
			loadInvList();
		}
	});
}

function initInvList() {
	GV.InvList = $HUI.datagrid("#invList", {
		fit: true,
		border: false,
		singleSelect: true,
		rownumbers: true,
		pagination: true,
		pageSize: 20,
		className: "web.UDHCJFInvprt",
		queryName: "FindInvNum",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if (!cm[i].width) {
					cm[i].width = 100;
				}
			}
		}
	});
}

function loadInvList() {
	var queryParams = {
		ClassName: "web.UDHCJFInvprt",
		QueryName: "FindInvNum",
		type: getValueById("invType"),
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	};
	loadDataGridStore("invList", queryParams);
}