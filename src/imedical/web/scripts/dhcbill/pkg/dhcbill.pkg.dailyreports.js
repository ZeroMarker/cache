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
			striped: true, //�Ƿ���ʾ������Ч��
			singleSelect: true,
			selectOnCheck: false,
			fitColumns: true,
			autoRowHeight: false,
			showFooter: true,
			url: $URL,
			pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
			rownumbers: true, //���Ϊtrue, ����ʾһ���к���
			pageSize: 10,
			pageList: [10, 20, 30, 40],
			columns: [[{
						title: '��������',
						field: 'TDate',
						width: 100
					}, {
						title: '����ʱ��',
						field: 'TTime',
						width: 100
					}, {
						title: '������',
						field: 'TUserName',
						width: 100
					}, {
						title: '��ʼ����',
						field: 'TStDate',
						width: 100
					}, {
						title: '��ʼʱ��',
						field: 'TStTime',
						width: 100
					}, {
						title: '��������',
						field: 'TEndDate',
						width: 100
					}, {
						title: '����ʱ��',
						field: 'TEndTime',
						width: 100
					}, {
						title: '���˺�',
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
