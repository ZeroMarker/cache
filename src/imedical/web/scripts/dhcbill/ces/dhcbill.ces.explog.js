/**
 * FileName: dhcbill.ces.explog.js
 * Author: xiongwang
 * Date: 2022-07-14
 * Description: 应急系统终端数据同步日志
 */

$(function () {
	var clientCode = getParam("clientCode");
	setValueById("clientCode", clientCode);
	initQueryMenu();
	initlogList();
});

function initQueryMenu () {
	$(".datebox-f").datebox("setValue", CV.stDate);
	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadlogList();
		}
	});
}

function initlogList () {
	$HUI.datagrid("#logList", {
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		fitColumns: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		columns: [[
				   {title: '开始日期时间', field: 'elStDate', width: 80,
				   	formatter: function (value, row, index) {
					   	return value + " " + row.elStTime;
					}
				   },
				   {title: '结束日期时间', field: 'elEndDate',width: 80,
				   	formatter: function (value, row, index) {
					   	return value + " " + row.elEndTime;
					}
				   },
				   {title: '同步时长', field: 'takeTime', width: 45},			
				   {title: '同步状态', field: 'elStatus', width: 45},
				   {title: '详情', field: 'elMsg', width: 400}
			]]
	});
}

function loadlogList() {
	var queryParams = {
		ClassName: "BILL.CES.COM.ExpLog",
		QueryName: "QryExpLogList",
		stDate: getValueById("stDate"),
		endDate: getValueById("endDate"),
		syncStatus: getValueById("syncStatus"),
		clientCode: getValueById("clientCode")
	};
	loadDataGridStore("logList", queryParams);
}