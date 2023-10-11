/**
 * FileName:dhcbill/outpay/dhcbill.outpay.settlementDetail.js
 * Anchor: lxy
 * Date: 2023-1-04
 * Description: 结算明细
 */
$(function () {
	initInvdetailList();
	if ((InvRowid!="")&&(typeof InvRowid !="undefined")){
		getDataGridData();
	}
});



function getDataGridData(){
   var queryParams = {
	   ClassName: 'BILL.OUTPAY.BL.InvPrtCtl',
	   QueryName: 'OutPayInvPrtDetailInfoQuery',
	   InvPrtRowid: InvRowid,
	}
	loadDataGridStore('InvdetailList',queryParams);	
}

function initInvdetailList(){
	$('#InvdetailList').datagrid({
		autoSizeColumn:false,
		fit: true,
		border: false,
		bodyCls: 'panel-header-gray',
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 10,
		columns:[[
		   {field:'ItmDR',title:'项目id',width:150,},
		   {field:'ItmCode',title:'项目编码',width:150},
		   {field:'ItmDesc',title:'项目名称',width:80},
		   {field:'Price',title:'单价',width:130,align: 'right'},
 		   {field:'Qty',title:'数量',width:100},
		   {field:'Amt',title:'金额',width:100,align: 'right'},
		   {field:'BillDate',title:'费用发生日期',width:100},
		   {field:'BillTime',title:'费用发生时间',width:100},
		   {field:'InvDR',title:'发票id',width:100},

		]],
   });
}
	