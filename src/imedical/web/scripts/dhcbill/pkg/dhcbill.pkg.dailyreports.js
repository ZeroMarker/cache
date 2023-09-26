/**
 * FileName: dhcbill.opbill.dailyreports.js
 * Anchor: ZhYW
 * Date: 2018-03-05
 * Description:
 */
var PUBLIC_CONSTANT = {
	SESSION: {
		HOSP_ROWID: session['LOGON.HOSPID']
	},
	METHOD: {
		CLS: "DHCBILL.Package.BusinessLogic.DHCPkgDailyHandin",
		QUERY: "FindPkgReportsInfo"
	}
};

$(function () {
	initReportsGrid();
});

function initReportsGrid() {
	var reportsObj = $HUI.datagrid('#reportsList', {
			fit: true,
			striped: true, //是否显示斑马线效果
			singleSelect: true,
			selectOnCheck: false,
			fitColumns: true,
			autoRowHeight: false,
			showFooter: true,
			url: $URL,
			pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
			rownumbers: true, //如果为true, 则显示一个行号列
			pageSize: 10,
			pageList: [10, 20, 30, 40],
			columns: [[{
						title: '结账日期',
						field: 'TDate',
						width: 100
					}, {
						title: '结账时间',
						field: 'TTime',
						width: 100
					}, {
						title: '结账人',
						field: 'TUserName',
						width: 100
					}, {
						title: '开始日期',
						field: 'TStDate',
						width: 100
					}, {
						title: '开始时间',
						field: 'TStTime',
						width: 100
					}, {
						title: '结束日期',
						field: 'TEndDate',
						width: 100
					}, {
						title: '结束时间',
						field: 'TEndTime',
						width: 100
					}, {
						title: '结账号',
						field: 'TRowId'
					}
				]],
			queryParams: {
				ClassName: PUBLIC_CONSTANT.METHOD.CLS,
				QueryName: PUBLIC_CONSTANT.METHOD.QUERY,
				stDate: getParam('stDate'),
				endDate: getParam('endDate'),
				guser: getParam('guser')
			},
			onDblClickRow: function (rowIndex, rowData) {
				var rowId = rowData.TRowId;
				var stDate = rowData.TStDate;
				var stTime = rowData.TStTime;
				var endDate = rowData.TEndDate;
				var endTime = rowData.TEndTime;
				var guser = GlobalObj.guser;
				var stDateTime = stDate + " " + stTime;
				var endDateTime = endDate + " " + endTime;
				window.parent.$('#stDateTime').datetimebox('setValue', stDateTime);
				window.parent.$('#endDateTime').datetimebox('setValue', endDateTime);
				window.parent.$('#footId').val(rowId);
				window.parent.loadSelDetails();
				window.parent.m_WinObj.close();
			}
		});
}
