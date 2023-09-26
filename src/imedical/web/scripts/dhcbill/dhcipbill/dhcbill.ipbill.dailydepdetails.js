/**
 * FileName: dhcbill.ipbill.dailydepdetails.js
 * Anchor: ZhYW
 * Date: 2018-03-16
 * Description: 
 */

$(function () {
	$HUI.datagrid('#depList', {
		fit: true,
		striped: true,
		border: false,
		url: $URL,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		toolbar: [],
		columns: [[{title: '交款日期', field: 'TDepDate', width: 100},
				   {title: '交款时间', field: 'TDepTime', width: 80},
				   {title: '患者姓名', field: 'TPatName', width: 100},
				   {title: '住院号', field: 'TMedicareNo', width: 100},
				   {title: '登记号', field: 'TRegNo', width: 100},
				   {title: '收据号', field: 'TRcptNo', width: 100},
				   {title: '金额', field: 'TDepAmt', align: 'right', width: 100, formatter: formatAmt},
				   {title: '支付方式', field: 'TPaymDesc', width: 100},
				   {title: '状态', field: 'TStatus', width: 100},
				   {title: '科室', field: 'TDepDeptDesc', width: 100},
				   {title: '记录号', field: 'TRowId', width: 100},
				   {title: '结账号', field: 'TDepFootDR', width: 80},
				   {title: '押金类型', field: 'TDepTypeDesc', width: 80},
				   {title: '级别', field: 'TEncryptLevel', width: 80}, 
				   {title: '密级', field: 'TPatLevel', width: 80}
			]],
		queryParams: {
			ClassName: "web.DHCIPBillDailyDetails",
			QueryName: "FindIPDepDetails",
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
