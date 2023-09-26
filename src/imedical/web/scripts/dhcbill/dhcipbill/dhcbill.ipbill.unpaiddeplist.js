/**
 * FileName: dhcbill.ipbill.unpaiddeplist.js
 * Anchor: ZhYW
 * Date: 2019-12-05
 * Description: 全院未结算预交金查询
 */

var GV = {};

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
		url: $URL + '?ClassName=web.UDHCJFDepositSearch&QueryName=FindWard&ResultSetType=array&desc=',
		valueField: 'id',
		textField: 'text',
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			param.desc = "";
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		}
	});
}

function initUnPaidDepList() {
	$HUI.datagrid("#unPaidDepList", {
		fit: true,
		striped: true,
		border: false,
		singleSelect: true,
		rownumbers: true,
		pagination: true,
		pageSize: 20,
		columns:[[{title: '姓名', field: 'Tpatname', width: 100},
				  {title: '登记号', field: 'Tregno', width: 100},
				  {title: '收据号', field: 'Trcptno', width: 100},
				  {title: '金额', field: 'Tpayamt', align: 'right', width: 140},
				  {title: '支付方式', field: 'Tpaymode', width: 150},
				  {title: '收据状态', field: 'Tstatus', width: 100},
				  {title: '打印时间', field: 'Tprtdate', width: 150,
					formatter: function (value, row, index) {
						return value + " " + row.Tprttime;
					}
				  },
				  {title: '收款员', field: 'Tuser', width: 100},
				  {title: 'Trowid', field: 'Trowid', hidden: true},
				  {title: '就诊科室', field: 'Tadmloc', width: 120},
				  {title: '支票号', field: 'Tchequeno', width: 100}
			]],
		url: $URL,
		queryParams: {
			ClassName: "web.UDHCJFDepositSearch",
			QueryName: "FindUnPaidDeposit",
			hospId: PUBLIC_CONSTANT.SESSION.HOSPID,
			wardId: getValueById("ward") || ""
		},
		rowStyler: function (index, row) {
			if (row.Tpatname.indexOf("合计") != -1) {
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
	var maxHeight = ($(window).height() || 550) * 0.8;
	var maxWidth = ($(window).width() || 1366) * 0.8;
	DHCCPM_RQPrint(fileName, maxWidth, maxHeight);
}