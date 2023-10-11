/**
 * FileName: dhcbill.ces.explogmain.js
 * Author: xiongwang
 * Date: 2022-07-14
 * Description: 应急系统终端数据同步日志(主界面)
 */

$(function () {
	initQueryMenu();
	initClientList();
});

function initQueryMenu () {
	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadClientList();
		}
	});
}

function initClientList () {
	$HUI.datagrid("#clientList", {
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		fitColumns: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		columns: [[
				   {title: '机器码', field: 'terminalNo', width: 150,
				   	formatter: function(value, row, index) {
						return "<a href='javascript:;' onclick=\"linkExpLog('" + value + "')\">" + value +"</a>";
				    }
				   },
				   {title: '客户端位置', field: 'locAddr', width: 200},
				   {title: 'MAC地址', field: 'macAddr', width: 200},
				   {title: '连接web地址', field: 'webAddr', width: 200},
				   {title: '同步状态', field: 'elStatus', width: 150},
				   {title: '同步时间', field: 'elStDate',width: 150,
				   	formatter: function (value, row, index) {
					   	return value + " " + row.elStTime;
					}
				   },
				   {title: '时长', field: 'takeTime', width: 150},
				   {title: '详情', field: 'elMsg', width: 300}
			]],
		onLoadSuccess: function (data) {
			$(".datagrid-cell-img").tooltip();
		}
	});
}

function loadClientList() {
	var queryParams = {
		ClassName: "BILL.CES.COM.ExpLog",
		QueryName: "QryClientList",
		syncStatus: getValueById("syncStatus"),
		clientCode: getValueById("clientCode")
	};
	loadDataGridStore("clientList", queryParams);
}

function linkExpLog(clientCode) {
	var url = "dhcbill.ces.explog.csp?clientCode=" + clientCode;
	websys_showModal({
		url: url,
		title: '同步记录',
		iconCls: 'icon-w-find',
		width: '90%',
		height: '85%'
	});
}