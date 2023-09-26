/**
 * FileName: dhcbill.pkg.refOrderItmDtl.js
 * Anchor: ZhYW
 * Date: 2018-01-07
 * Description: �˷ѵ���ϸ
 */
var PUBLIC_CONSTANT = {
	SESSION: {
		GUSER_ROWID: session['LOGON.USERID'],
		CTLOC_ROWID: session['LOGON.CTLOCID'],
		GROUP_ROWID: session['LOGON.GROUPID'],
		HOSP_ROWID: session['LOGON.HOSPID']
	},
	METHOD: {
		CLS: 'DHCBILL.Package.WebUI.DHCPkgRefundBill',
		QUERY: 'FindPkgRefBillDtl'
	}
};

$(function () {
	initItmList();
	loadItmList();
});

function initItmList() {
	$HUI.datagrid('#refItmList', {
		fit: true,
		border: true,
		bodyCls: 'panel-header-gray',
		striped: true,
		fitColumns: true,
		autoRowHeight: false,
		pagination: true,
		rownumbers: true,
		data: [],
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		columns: [[{
					title: 'refBillDtlRowId',
					field: 'refBillDtlRowId',
					hidden: true
				}, {
					title: 'billDtlDR',
					field: 'billDtlDR',
					hidden: true
				}, {
					title: '��Ʒ',
					field: 'arcimDesc',
					width: 100
				}, {
					title: '��λ',
					field: 'uomDesc',
					width: 70
				}, {
					title: '��׼����',
					field: 'priceperunit',
					align: 'right',
					width: 100
				}, {
					title: '�ۿ۵���',
					field: 'discunit',
					align: 'right',
					width: 100
				}, {
					title: '�Ը�����',
					field: 'patshareunit',
					align: 'right',
					width: 100
				}, {
					title: '��������',
					field: 'quantity',
					width: 100
				}, {
					title: '�˷�����',
					field: 'refundqty',
					width: 100
				}, {
					title: '��׼���',
					field: 'refundamount',
					align: 'right',
					width: 100
				}, {
					title: '�ۿ۽��',
					field: 'disrefundamt',
					align: 'right',
					width: 100
				}, {
					title: '�Ը����',
					field: 'patsharerefundamt',
					align: 'right',
					width: 100
				}, {
					title: '�⳥���',
					field: 'indemnityamount',
					align: 'right',
					width: 100
				}, {
					title: 'ΥԼ���',
					field: 'penaltyamount',
					align: 'right',
					width: 100
				}
			]]
	});
}

function loadItmList() {
	var queryParams = {
		ClassName: PUBLIC_CONSTANT.METHOD.CLS,
		QueryName: PUBLIC_CONSTANT.METHOD.QUERY,
		refBillId: getParam('refBillId')
	}
	loadDataGridStore('refItmList', queryParams);
}