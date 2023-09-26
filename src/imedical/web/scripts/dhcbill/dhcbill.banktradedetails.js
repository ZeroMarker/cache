/**
 * FileName: dhcbill.banktradedetails.js
 * Anchor: ZhYW
 * Date: 2018-03-25
 * Description: 第三方交易明细
 */

$(function () {
	initBankTradeListGrid();
});

function initBankTradeListGrid() {
	$HUI.datagrid('#bankTradeList', {
		fit: true,
		striped: true,
		border: false,
		singleSelect: true,
		fitColumns: true,
		autoRowHeight: false,
		url: $URL,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		toolbar: [],
		columns: [[{
					title: '银行交易流水号',
					field: 'TBankTradeNo',
					width: 150
				}, {
					title: '终端号',
					field: 'TTerminalNo',
					width: 120
				}, {
					title: '交易类型',
					field: 'TBankTradeType',
					width: 100
				}, {
					title: '交易金额',
					field: 'TBankTradeAmt',
					align: 'right',
					width: 100,
					formatter: formatAmt
				},{
					title: '交易日期',
					field: 'TBankTradeDate',
					width: 100
				}, {
					title: '交易时间',
					field: 'TBankTradeTime',
					width: 100
				}, {
					title: '订单号',
					field: 'THISTradeNo',
					width: 150
				}
			]],
		queryParams: {
			ClassName: "web.DHCBillReconciliations",
			QueryName: "FindBankTradeDetails",
			stDate: getParam('stDate'),
			endDate: getParam('endDate'),
			hospDR: getParam('hospDR')
		}
	});
}