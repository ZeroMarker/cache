/**
 * FileName: dhcpebill.opbill.dailyfocusdetail.js
 * Anchor: xy
 * Date: 2018-05-24
 * Description:����������ձ��ϲ��м��д�ӡ��Ʊ��ϸ
 */
var PUBLIC_CONSTANT = {
	SESSION: {
		GUSER_ROWID: session['LOGON.USERID'],
		GROUP_ROWID: session['LOGON.GROUPID'],
		HOSP_ROWID: session['LOGON.HOSPID']
	},
	METHOD: {
		CLS: "web.DHCPE.DHCPEToOPBillInterface",
		QUERY: "FindFocusReportDetail"
	}
};

$(document).ready(function () {
	initFocusPRTListGrid();
});

function initFocusPRTListGrid() {
	var accPreListObj = $HUI.datagrid('#dhcpeFocusPRTList', {
			fit: true,
			striped: true,
			singleSelect: true,
			selectOnCheck: false,
			fitColumns: true,
			autoRowHeight: false,
			showFooter: true,
			url: $URL,
			pagination: true,
			rownumbers: true,
			pageSize: 20,
			pageList: [20, 30, 40, 50],
			columns: [[{
						title: '��ӡ����',
						field: 'TPrintDate',
						width: 80
					}, {
						title: '��ӡʱ��',
						field: 'TInvTime',
						width: 80
					},{
						title: '��������',
						field: 'TBillDate',
						width: 80
					}, {
						title: '��������',
						field: 'TName',
						width: 80
					}, {
						title: '�ǼǺ�',
						field: 'TRegNo',
						width: 80
					}, {
						title: '���',
						field: 'TInvAmt',
						align: 'right',
						width: 100,
						formatter: formatAmt
					}, {
						title: '��Ʊ��',
						field: 'TInvNo',
						width: 80
					}, {
						title: '��Ʊ����',
						field: 'TInvTypeDesc',
						width: 80
					}
				]],
			queryParams: {
				ClassName: PUBLIC_CONSTANT.METHOD.CLS,
				QueryName: PUBLIC_CONSTANT.METHOD.QUERY,
				stDate: GlobalObj.stDate,
				stTime: GlobalObj.stTime,
				endDate: GlobalObj.endDate,
				endTime: GlobalObj.endTime,
				footId: GlobalObj.footId,
				guser: GlobalObj.guser,
				hospDR: GlobalObj.hospDR
			}
		});
}
