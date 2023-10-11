/**
 * FileName: dhcbill.skipinvdtllist.js
 * Author: ZhYW
 * Date: 2018-06-28
 * Description: 跳号查询
 */

var initQueryMenu = function () {
	setValueById("menu-stDate", CV.DefDate);
	setValueById("menu-endDate", CV.DefDate);

	$HUI.linkbutton("#btnSearch", {
		onClick: function () {
			loadInvList();
		}
	});
	
	$HUI.linkbutton("#btnPrint", {
		onClick: function () {
			printClick();
		}
	});
	
	$HUI.combobox("#menu-invType", {
		panelHeight: 'auto',
		editable: false,
		valueField: 'value',
		textField: 'text',
		data: [{value: 'OP', text: $g('门诊发票')},
			   {value: 'ID', text: $g('住院押金')},
			   {value: 'IP', text: $g('住院发票')}],
		value: (CV.InvType.indexOf("O") != -1) ? "OP" : "IP",
		loadFilter: function(data) {
			if (CV.InvType) {
				data = data.filter(function (item) {
			   		return item.value.indexOf(CV.InvType) != -1;
			  	});
			}
			return data;
		},
		onSelect: function () {
			$("#menu-guser").combobox("clear").combobox("reload");
		}
	});
	
	$HUI.combobox("#menu-guser", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryInvUser&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5,
		onBeforeLoad: function (param) {
			param.invType = getValueById("menu-invType").charAt(0);
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		}
	});
}

var initInvList = function () {
	$HUI.datagrid("#skipInvList", {
		fit: true,
		border: false,
		singleSelect: true,
		fitColumns: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		className: "web.DHCBillSkipInvoice",
		queryName: "FindSkipInv",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["TDate"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if (cm[i].field == "TTime") {
					cm[i].formatter = function(value, row, index) {
					   	return row.TDate + " " + value;
					};
				}
				if (cm[i].field == "THandinFlag") {
					cm[i].formatter = function(value, row, index) {
					   	if (value) {
						   	var color = (value == "Y") ? "#21ba45" : "#f16e57";
							return "<font color=\"" + color + "\">" + ((value == "Y") ? $g("是") : $g("否")) + "</font>";
						}
					};
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if (cm[i].field == "TTime") {
						cm[i].width = 160;
					}
				}
			}
		}
	});
}

/**
 * 加载明细grid
 * @method loadInvList
 * @author ZhYW
 */
function loadInvList() {
	var queryParams = {
		ClassName: "web.DHCBillSkipInvoice",
		QueryName: "FindSkipInv",
		stDate: getValueById("menu-stDate"),
		endDate: getValueById("menu-endDate"),
		invType: getValueById("menu-invType"),
		guser: getValueById("menu-guser") || "",
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	};
	loadDataGridStore("skipInvList", queryParams);
}

/**
 * 打印
 * @method printClick
 * @author ZhYW
 */
function printClick() {
	var stDate = getValueById("menu-stDate");
	var endDate = getValueById("menu-endDate");
	var invType = getValueById("menu-invType");
	var guser = getValueById("menu-guser") || "";
	var fileName = "DHCBILL-THPJMX.rpx" + "&stDate=" + stDate + "&endDate=" + endDate;
	fileName += "&invType=" + invType + "&guser=" + guser + "&hospId=" + PUBLIC_CONSTANT.SESSION.HOSPID;

	var maxWidth = $(window).width() * 0.8;
	var maxHeight = $(window).height() * 0.8;
	DHCCPM_RQPrint(fileName, maxWidth, maxHeight);
}

$(function () {
	initQueryMenu();
	initInvList();
});