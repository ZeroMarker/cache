/**
 * FileName: dhcbill.pkg.orderItmDtl.js
 * Anchor: ZhYW
 * Date: 2018-01-07
 * Description: ������ϸ
 */

$(function () {
	initItmList();
	loadItmList();
});

function initItmList() {
	$HUI.datagrid('#itmList', {
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
					title: '������',
					field: 'orderNo',
					width: 100
				}, {
					title: '��Ʒ',
					field: 'product',
					width: 80
				}, {
					title: '��λ',
					field: 'uom',
					width: 60
				}, {
					title: '����',
					field: 'quantity',
					width: 60
				}, {
					title: '����',
					field: 'priceperunit',
					align: 'right',
					width: 100
				}, {
					title: '���',
					field: 'baseamount',
					align: 'right',
					width: 100
				}, {
					title: 'Ӧ�����',
					field: 'extendedamount',
					align: 'right',
					width: 100
				}, {
					title: '��Ч��ʼ����',
					field: 'validstartdate',
					width: 100
				}, {
					title: '��Ч��������',
					field: 'validenddate',
					width: 100
				}, {
					title: '�����',
					field: 'salespromotioncode',
					width: 100
				}, {
					title: '�Ż�ȯ',
					field: 'couponcode',
					width: 100
				}
			]]
	});
}

function loadItmList() {
	var queryParams = {
		ClassName: 'BILL.PKG.BL.PatientBill',
		QueryName: 'FindPkgPatBillDtl',
		billIdStr: getParam('billIdStr')
	}
	loadDataGridStore('itmList', queryParams);
}