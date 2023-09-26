/**
 * FileName: dhcbill.unuseinvlist.js
 * Anchor: ZhYW
 * Date: 2019-12-30
 * Description: 收费员未使用发票查询
 */

var GV = {};

$(function () {
	$(document).keydown(function (e) {
		banBackSpace(e);
	});
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
		defaultFilter: 4,
		selectOnNavigation: false,
		onSelect: function(rec) {
			loadInvList();
		}
	});
}

function initInvList() {
	GV.InvList = $HUI.datagrid("#invList", {
		fit: true,
		striped: true,
		border: false,
		singleSelect: true,
		rownumbers: true,
		pagination: true,
		pageSize: 20,
		data: [],
		columns:[[{title: '收款员', field: 'TCashier', width: 150},
				  {title: '工号', field: 'TCasherNo', width: 150},
				  {title: '张数', field: 'TInvNum', width: 150},
				  {title: '号段', field: 'TInvNo', width: 700}
			]]
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