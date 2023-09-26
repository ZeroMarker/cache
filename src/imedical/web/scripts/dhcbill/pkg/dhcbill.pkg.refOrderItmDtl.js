/**
 * FileName: dhcbill.pkg.refOrderItmDtl.js
 * Anchor: ZhYW
 * Date: 2018-01-07
 * Description: 退费单明细
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
					title: '产品',
					field: 'arcimDesc',
					width: 100
				}, {
					title: '单位',
					field: 'uomDesc',
					width: 70
				}, {
					title: '标准单价',
					field: 'priceperunit',
					align: 'right',
					width: 100
				}, {
					title: '折扣单价',
					field: 'discunit',
					align: 'right',
					width: 100
				}, {
					title: '自付单价',
					field: 'patshareunit',
					align: 'right',
					width: 100
				}, {
					title: '订购数量',
					field: 'quantity',
					width: 100
				}, {
					title: '退费数量',
					field: 'refundqty',
					width: 100
				}, {
					title: '标准金额',
					field: 'refundamount',
					align: 'right',
					width: 100
				}, {
					title: '折扣金额',
					field: 'disrefundamt',
					align: 'right',
					width: 100
				}, {
					title: '自付金额',
					field: 'patsharerefundamt',
					align: 'right',
					width: 100
				}, {
					title: '赔偿金额',
					field: 'indemnityamount',
					align: 'right',
					width: 100
				}, {
					title: '违约金额',
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