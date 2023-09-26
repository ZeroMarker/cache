/**
 * FileName: dhcbill.opbill.billoeitm.js
 * Anchor: ZhYW
 * Date: 2018-19-20
 * Description: 账单医嘱明细
 */

$(function () {
	$HUI.datagrid('#oeitmList', {
		fit: true,
		bodyCls: 'panel-header-gray',
		striped: true,
		fitColumns: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		columns: [[{title: '医嘱名称', field: 'Torder', width: 180},
				   {title: '医嘱序号', field: 'Tseqno', width: 70},
				   {title: '日期', field: 'Tdate', width: 100},
				   {title: '数量', field: 'Tqty', width: 60},
				   {title: '单位', field: 'TBaseUom', width: 60},
				   {title: '单价', field: 'Tunitprice', align: 'right', width: 80},
				   {title: '状态', field: 'Tbillflag', hidden: true},
				   {title: '总金额', field: 'Tprice', align: 'right', width: 80},
				   {title: '折扣金额', field: 'Tdiscount', align: 'right', width: 80},
				   {title: '记账金额', field: 'Tpayorshare', align: 'right', width: 80},
				   {title: '自付金额', field: 'Tpatshare', align: 'right', width: 80},
				   {title: '账单医嘱ID', field: 'Trowid', width: 100}
			]],
		url: $URL,
		queryParams: {
			ClassName: "web.UDHCJFITM",
			QueryName: "FindOrdDetail",
			BillNo: getParam('billId')
		}
	});
});