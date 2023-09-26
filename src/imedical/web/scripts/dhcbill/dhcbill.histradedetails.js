/**
 * FileName: dhcbill.histradedetails.js
 * Anchor: ZhYW
 * Date: 2018-03-25
 * Description: HIS业务明细
 */
 
$(function () {
	initHISTradeListGrid();
});

function initHISTradeListGrid() {
	$HUI.datagrid('#hisTradeList', {
		fit: true,
		striped: true,
		border: false,
		singleSelect: true,
		fitColumns: false,
		autoRowHeight: false,
		url: $URL,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		toolbar: '#tb',
		columns: [[{
					title: '登记号',
					field: 'TRegNo',
					width: 100
				}, {
					title: '姓名',
					field: 'TPatName',
					width: 100
				}, {
					title: '交易状态',
					field: 'TTradeMsg',
					width: 100
				}, {
					title: '银行交易流水号',
					field: 'TBankTradeNo',
					width: 200
				}, {
					title: '交易金额',
					field: 'TTradeAmt',
					align: 'right',
					width: 100,
					formatter: formatAmt
				}, {
					title: '支付渠道',
					field: 'TPaymDesc',
					width: 100
				}, {
					title: '交易类型',
					field: 'TTradeType',
					width: 120
				}, {
					title: '操作员',
					field: 'TUserName',
					width: 100
				}, {
					title: '交易日期',
					field: 'TTradeDate',
					width: 100
				}, {
					title: '交易时间',
					field: 'TTradeTime',
					width: 100
				}, {
					title: '订单号',
					field: 'THISTradeNo',
					width: 200
				}
			]],
		queryParams: {
			ClassName: "web.DHCBillReconciliations",
			QueryName: "FindHISTradeDetail",
			stDate: getParam('stDate'),
			endDate: getParam('endDate'),
			transType: getParam('transType'),
			payChannel: getParam('payChannel'),
			patientNo: $('#ss').searchbox('getValue'),
			hospDR: getParam('hospDR')
		}
	});
}

function doSearch(value, name) {
	$.m({
		ClassName: "web.UDHCJFBaseCommon",
		MethodName: "regnocon",
		PAPMINo: value
	}, function (patientNo) {
		$('#ss').searchbox('setValue', patientNo);
		var queryParams = {
			ClassName: "web.DHCBillReconciliations",
			QueryName: "FindHISTradeDetail",
			stDate: getParam('stDate'),
			endDate: getParam('endDate'),
			transType: getParam('transType'),
			payChannel: getParam('payChannel'),
			patientNo: patientNo,
			hospDR: getParam('hospDR')
		}
		loadDataGridStore('hisTradeList', queryParams);
	});
}