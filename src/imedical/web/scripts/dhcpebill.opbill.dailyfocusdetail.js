/**
 * FileName: dhcpebill.opbill.dailyfocusdetail.js
 * Anchor: xy
 * Date: 2018-05-24
 * Description:门诊与体检日报合并中集中打印发票明细
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
						title: '打印日期',
						field: 'TPrintDate',
						width: 80
					}, {
						title: '打印时间',
						field: 'TInvTime',
						width: 80
					},{
						title: '交款日期',
						field: 'TBillDate',
						width: 80
					}, {
						title: '患者姓名',
						field: 'TName',
						width: 80
					}, {
						title: '登记号',
						field: 'TRegNo',
						width: 80
					}, {
						title: '金额',
						field: 'TInvAmt',
						align: 'right',
						width: 100,
						formatter: formatAmt
					}, {
						title: '发票号',
						field: 'TInvNo',
						width: 80
					}, {
						title: '发票类型',
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
