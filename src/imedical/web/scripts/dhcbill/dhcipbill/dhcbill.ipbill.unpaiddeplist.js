/**
 * FileName: dhcbill.ipbill.unpaiddeplist.js
 * Author: ZhYW
 * Date: 2019-12-05
 * Description: 全院未结算预交金查询
 */

$(function () {
	initQueryMenu();
	initUnPaidDepList();
});

function initQueryMenu() {
	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadUnPaidDepList();
		}
	});
	
	$HUI.linkbutton("#btn-export", {
		onClick: function () {
			exportClick();
		}
	});
	
	//病区
	$HUI.combobox("#ward", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryWard&ResultSetType=array&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		defaultFilter: 5,
		filter: function(q, row) {
			var opts = $(this).combobox("options");
			var mCode = false;
			if (row.contactName) {
				mCode = row.contactName.toUpperCase().indexOf(q.toUpperCase()) >= 0
			}
			var mValue = row[opts.textField].toUpperCase().indexOf(q.toUpperCase()) >= 0;
			return mCode || mValue;
		}
	});
}

function initUnPaidDepList() {
	$HUI.datagrid("#unPaidDepList", {
		fit: true,
		border: false,
		singleSelect: true,
		rownumbers: true,
		pagination: true,
		pageSize: 20,
		className: "web.UDHCJFDepositSearch",
		queryName: "FindUnPaidDeposit",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["Tprtdate"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if (cm[i].field == "Trowid") {
					cm[i].hidden = true;
				}
				if (cm[i].field == "Tprttime") {
					cm[i].formatter = function (value, row, index) {
						return row.Tprtdate + " " + value;
					}
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if (cm[i].field == "Tprttime") {
						cm[i].width = 160;
					}
				}
			}
		},
		url: $URL,
		queryParams: {
			ClassName: "web.UDHCJFDepositSearch",
			QueryName: "FindUnPaidDeposit",
			hospId: PUBLIC_CONSTANT.SESSION.HOSPID,
			wardId: getValueById("ward") || ""
		},
		rowStyler: function (index, row) {
			if (row.Trowid == "") {
				return 'font-weight: bold';
			}
		}
	});
}

function loadUnPaidDepList() {
	var queryParams = {
		ClassName: "web.UDHCJFDepositSearch",
		QueryName: "FindUnPaidDeposit",
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID,
		wardId: getValueById("ward") || ""
	};
	loadDataGridStore("unPaidDepList", queryParams);
}

/**
* 导出
*/
function exportClick() {
	var fileName = "DHCBILL-IPBILL-QYWJSDEP.rpx" + "&hospId=" + PUBLIC_CONSTANT.SESSION.HOSPID;
	fileName += "&wardId=" + (getValueById("ward") || "");
	var maxHeight = $(window).height() * 0.8;
	var maxWidth = $(window).width() * 0.8;
	DHCCPM_RQPrint(fileName, maxWidth, maxHeight);
}