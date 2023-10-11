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

$(function () {
	var toolbar = [{
		text: $g('����'),
		iconCls: 'icon-export',
		handler: function () {
			exportClick();
		}
	},{
		text: $g('��������'),
		iconCls: 'icon-batch-cfg',
		handler: function () {
			configClick();
		}
	}];
	
	$HUI.datagrid('#dhcpeFocusPRTList', {
		url: $URL,
		fit: true,
		striped: true,
		border: false,
		fitColumns: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		toolbar: toolbar,
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
});

/**
 * Creator: xueying
 * CreatDate: 20230420
 * Description: ����
*/
function exportClick() {
	$.cm({
		ResultSetType: "ExcelPlugin",
		localDir: "Self",
		ExcelName: $(".tabs-selected .tabs-title", parent.document).text(),
		PageName: page,
		ClassName: PUBLIC_CONSTANT.METHOD.CLS,
	    QueryName: PUBLIC_CONSTANT.METHOD.QUERY,
	    stDate: GlobalObj.stDate,
		stTime: GlobalObj.stTime,
		endDate: GlobalObj.endDate,
		endTime: GlobalObj.endTime,
		footId: GlobalObj.footId,
		guser: GlobalObj.guser,
		hospDR: GlobalObj.hospDR,
		LocID:session['LOGON.CTLOCID']
	}, false);
}

/**
 * Creator: xueying
 * CreatDate: 20230420
 * Description: ��������
*/
function configClick() {
	var url = "websys.query.customisecolumn.csp?CONTEXT=Kweb.DHCOPBillDailyDetails:FindOPBillInvDetails&PREFID=0&PAGENAME=" + page;
	websys_showModal({
		url: url,
		title: '��������',
		iconCls: 'icon-w-config',
		width: '80%',
		height: '80%'
	});
}



