/**
 * FileName: dhcbill.opbill.invoeitm.js
 * Anchor: ZhYW
 * Date: 2018-12-15
 * Description: 发票医嘱明细
 */

$(function () {
	$HUI.datagrid('#oeitmList', {
		fit: true,
		border: true,
		striped: true,
		bodyCls: 'panel-header-gray',
		fitColumns: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		columns: [[{title: '医嘱名称', field: 'TOrder', width: 100},
				   {title: '金额', field: 'TOrderSum', align: 'right', width: 60},
				   {title: '数量', field: 'TOrderQty', width: 60},
				   {title: '单位', field: 'TPackUOM', width: 70},
				   {title: '接收科室', field: 'TRecloc', width: 100},
				   {title: '就诊医生', field: 'TAdmDoctorName', width: 80},
				   {title: '医嘱状态', field: 'TStatDesc', width: 80},
				   {title: '开单医生', field: 'TCareProDesc', width: 80},
				   {title: '折扣金额', field: 'TDiscSum', align: 'right', width: 80},
				   {title: '记账金额', field: 'TPayorSum', align: 'right', width: 80},
				   {title: '医嘱开始时间', field: 'TOEORIStartTime', width: 150},
				   {title: '处方号', field: 'TOEORIPresNo', width: 100},
				   {title: '检验标本号', field: 'TOEORILabNo', width: 100}
			]],
		url: $URL,
		queryParams: {
			ClassName: "web.UDHCOEORDOP1",
			QueryName: "ReadOEByINVRowID",
			invRowId: getParam("invRowId"),
			invType: getParam("invType")
		}
	});
});