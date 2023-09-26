/**
 * FileName: dhcbill.recondetails.js
 * Anchor: ZhYW
 * Date: 2018-03-25
 * Description: 第三方对账明细
 */

$(function () {
	initReconListGrid();
});

function initReconListGrid() {
	$HUI.datagrid('#reconList', {
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
		toolbar: [],
		columns: [[{
					title: '登记号',
					field: 'TRegNo',
					width: 100
				}, {
					title: '姓名',
					field: 'TPatName',
					width: 100
				}, {
					title: '银行交易流水号',
					field: 'TBankTradeNo'
				}, {
					title: '交易类型',
					field: 'TBankTradeType'
				}, {
					title: '交易金额',
					field: 'TTradeAmt',
					align: 'right',
					width: 100,
					formatter: formatAmt
				}, {
					title: '操作员',
					field: 'TUserName',
					width: 100
				}, {
					title: '支付渠道',
					field: 'TPaymDesc',
					width: 100
				}, {
					title: '交易日期',
					field: 'TBankTradeDate',
					width: 100
				}, {
					title: '交易时间',
					field: 'TBankTradeTime',
					width: 100
				}, {
					title: '对账结果',
					field: 'TJudgeResult',
					formatter: function (value, row, index) {
						if (row.TResultMsg != "") {
							var content = '<span title="' + row.TResultMsg + '" class="hisui-tooltip">' + value + '</span>';
							return content;
						}
					}
				}, {
					title: '终端号',
					field: 'TTerminalNo',
					width: 120
				}, {
					title: '订单号',
					field: 'THISTradeNo',
					width: 200
				}
			]],
		queryParams: {
			ClassName: "web.DHCBillReconciliations",
			QueryName: "JudgeTradePay",
			stDate: getParam('stDate'),
			endDate: getParam('endDate'),
			transType: getParam('transType'),
			payChannel: getParam('payChannel'),
			result: getParam('result'),
			hospDR: getParam('hospDR')
		},
		rowStyler: function (index, row) {
			if (row.TJudgeResult == 'HIS多') {
				return 'background-color:#F2FEBF;color:#2F0000;';
			} else if (row.TJudgeResult == '第三方多') {
				return 'background-color:#E6FE80;color:#CE0000;';
			}
		},
		onLoadSuccess: function () {
			$('.hisui-tooltip').tooltip({
				position: 'bottom',
				onShow: function () {
					$(this).tooltip('tip').css({
						backgroundColor: '#666',
						borderColor: '#666'
					});
				}
			});
		}
	});
}
