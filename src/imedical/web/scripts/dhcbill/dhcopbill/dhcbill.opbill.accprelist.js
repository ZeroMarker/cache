/**
 * FileName: dhcbill.opbill.accprelist.js
 * Anchor: ZhYW
 * Date: 2021-07-19
 * Description: 门诊预交金明细
 */

$(function () {
	GV.PreList = $HUI.datagrid("#preList", {
		fit: true,
		border: true,
		bodyCls: 'panel-header-gray',
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		columns: [[{title: '交款时间', field: 'Tdate', width: 155,
					formatter: function (value, row, index) {
						return value + " " + row.Ttime;
					}
				   },
				   {title: '预交金号码', field: 'Treceiptsno', width: 150},
				   {title: '交款类型', field: 'Ttype', width: 100},
				   {title: '交款方式', field: 'Tpaymode', width: 100},
				   {title: '操作员', field: 'Tuser', width: 100},
				   {title: '金额', field: 'Tamt', align: 'right', width: 110},
				   {title: '当时账户余额', field: 'Taccleft', align: 'right', width: 110},
				   {title: '支票号码', field: 'Tchequeno', width: 140},
				   {title: '押金类型', field: 'TDepType', width: 100}
			]],
		url: $URL,
		queryParams: {
			ClassName: "web.UDHCAccAddDeposit",
			QueryName: "AccDepDetail",
			AccMRowID: CV.AccMRowID,
			DepTypeId: "",
			SessionStr: getSessionStr()
		}
	});
});