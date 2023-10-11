/**
 * FileName:dhcbill/outpay/dhcbill.outpay.settlementDetail.js
 * Anchor: lxy
 * Date: 2023-1-04
 * Description: ������ϸ
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
		   {field:'ItmDR',title:'��Ŀid',width:150,},
		   {field:'ItmCode',title:'��Ŀ����',width:150},
		   {field:'ItmDesc',title:'��Ŀ����',width:80},
		   {field:'Price',title:'����',width:130,align: 'right'},
 		   {field:'Qty',title:'����',width:100},
		   {field:'Amt',title:'���',width:100,align: 'right'},
		   {field:'BillDate',title:'���÷�������',width:100},
		   {field:'BillTime',title:'���÷���ʱ��',width:100},
		   {field:'InvDR',title:'��Ʊid',width:100},

		]],
   });
}
	