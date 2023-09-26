/**
 * FileName: dhcbill.pkg.orderItmDtl.js
 * Anchor: ZhYW
 * Date: 2018-01-07
 * Description: 订单明细
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
					title: '订单号',
					field: 'orderNo',
					width: 100
				}, {
					title: '产品',
					field: 'product',
					width: 80
				}, {
					title: '单位',
					field: 'uom',
					width: 60
				}, {
					title: '数量',
					field: 'quantity',
					width: 60
				}, {
					title: '单价',
					field: 'priceperunit',
					align: 'right',
					width: 100
				}, {
					title: '金额',
					field: 'baseamount',
					align: 'right',
					width: 100
				}, {
					title: '应付金额',
					field: 'extendedamount',
					align: 'right',
					width: 100
				}, {
					title: '有效开始日期',
					field: 'validstartdate',
					width: 100
				}, {
					title: '有效结束日期',
					field: 'validenddate',
					width: 100
				}, {
					title: '促销活动',
					field: 'salespromotioncode',
					width: 100
				}, {
					title: '优惠券',
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