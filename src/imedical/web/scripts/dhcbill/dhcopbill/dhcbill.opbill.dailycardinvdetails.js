/**
 * FileName: dhcbill.opbill.dailycardinvdetails.js
 * Anchor: ZhYW
 * Date: 2018-03-08
 * Description: 卡费用明细
 */

$(function () {
	$HUI.datagrid('#cardInvList', {
		fit: true,
		striped: true,
		border: false,
		url: $URL,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		toolbar: [],
		columns: [[{title: '交款日期', field: 'TCardInvDate', width: 100},
				   {title: '交款时间', field: 'TCardInvTime', width: 100},
				   {title: '患者姓名', field: 'TPatName', width: 100},
				   {title: '登记号', field: 'TRegNo', width: 100},
				   {title: '金额', field: 'TCardInvSum', align: 'right', width: 100, formatter: formatAmt},
				   {title: '支付方式', field: 'TPaymDesc', width: 100},
				   {title: '状态', field: 'TStatus', width: 100},
				   {title: '记录号', field: 'TCardInvId', width: 100},
				   {title: '结账号', field: 'TCardInvFootDR', width: 100},
				   {title: '级别', field: 'TEncryptLevel', width: 100},
				   {title: '密级', field: 'TPatLevel', width: 100}
			]],
		queryParams: {
			ClassName: "web.DHCOPBillDailyDetails",
			QueryName: "FindCardInvDetails",
			stDate: GV.stDate,
			stTime: GV.stTime,
			endDate: GV.endDate,
			endTime: GV.endTime,
			footId: GV.footId,
			guser: GV.guser,
			hospDR: GV.hospDR
		}
	});
});