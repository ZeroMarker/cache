/**
 * FileName: dhcbill.opbill.accpaylist.js
 * Author: ZhYW
 * Date: 2021-07-19
 * Description: 账户支付明细
 */

$(function () {
	GV.PayList = $HUI.datagrid("#payList", {
		fit: true,
		border: true,
		bodyCls: 'panel-header-gray',
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		columns: [[{title: '医嘱明细', field: 'OPRTRowID', align: 'center', width: 80,
					formatter: function (value, row, index) {
					   	return "<a href='javascript:;' onclick='openDtlView(" + JSON.stringify(row) + ")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png'/></a>";
					}
				   },
				   {title: '支付号码', field: 'OBillNo', width: 170},
				   {title: '患者姓名', field: 'OPAName', width: 100},
				   {title: '登记号', field: 'OPAPMINo', width: 120},
				   {title: '操作员', field: 'OSSUDesc', width: 100},
				   {title: '收费时间', field: 'OPayDate', width: 155,
					formatter: function (value, row, index) {
						return value + " " + row.OPayTime;
					}
				   },
				   {title: '支付额', field: 'OPayNum', align: 'right', width: 100},
				   {title: '余额', field: 'OPayLeft', align: 'right', width: 100},
				   {title: '支付位置', field: 'OLocDesc', width: 140},
				   {title: 'OInvType', field: 'OInvType', hidden: true},
				   {title: 'PLRowID', field: 'PLRowID', hidden: true}
			]],
		url: $URL,
		queryParams: {
			ClassName: "web.UDHCACPayList",
			QueryName: "ReadAccPayList",
			AccRowID: CV.AccMRowID,
			SessionStr: getSessionStr()
		}
	});
});

function openDtlView(row) {
	var argObj = {
		invRowId: row.OPRTRowID,
		invType: row.OInvType
	};
	BILL_INF.showOPChgOrdItm(argObj);
}