/**
 * FileName: dhcbill.ipbill.depcollect.js
 * Author: ZhYW
 * Date: 2019-12-06
 * Description: 预交金汇总
 */

$(function () {
	initQueryMenu();
	initDepList();
});

function initQueryMenu() {
	$(".datebox-f").datebox("setValue", CV.DefDate);
	
	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadDepList();
		}
	});
	
	//操作员
	$HUI.combobox("#guser", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryInvUser&ResultSetType=array&invType=I&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5
	});
	
	//支付方式
	$HUI.combobox("#paymode", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryPayMode&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5
	});
}

function initDepList() {
	$HUI.datagrid("#depList", {
		fit: true,
		border: false,
		singleSelect: true,
		rownumbers: true,
		pagination: true,
		pageSize: 20,
		className: "web.UDHCJFDepositSearch",
		queryName: "FindUserDepList",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["Tprtdate"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if ($.inArray(cm[i].field, ["Trowid"]) != -1) {
					cm[i].hidden = true;
				}
				if (cm[i].field == "Tprttime") {
					cm[i].formatter = function (value, row, index) {
						return row.Tprtdate + " " + value;
					}
				}
				if (!cm[i].width) {
					cm[i].width = 120;
					if (cm[i].field == "Tprttime") {
						cm[i].width = 160;
					}
				}
			}
		},
		url: $URL,
		queryParams: {
			ClassName: "web.UDHCJFDepositSearch",
			QueryName: "FindUserDepList",
			stDate: getValueById("stDate"),
			endDate: getValueById("endDate"),
			userId: getValueById("guser") || "",
			flag: getValueById("isRefRcpt") ? 1 : 0,
			paymId: getValueById("paymode") || "",
			hospId: PUBLIC_CONSTANT.SESSION.HOSPID
		},
		rowStyler: function (index, row) {
			if (!(row.Trowid > 0)) {
				return 'font-weight: bold';
			}
		}
	});
}

function loadDepList() {
	var queryParams = {
		ClassName: "web.UDHCJFDepositSearch",
		QueryName: "FindUserDepList",
		stDate: getValueById("stDate"),
		endDate: getValueById("endDate"),
		userId: getValueById("guser") || "",
		flag: getValueById("isRefRcpt") ? 1 : 0,
		paymId: getValueById("paymode") || "",
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	};
	loadDataGridStore("depList", queryParams);
}