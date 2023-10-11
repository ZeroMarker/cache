/**
 * FileName: dhcbill/outpay/dhcbill.outpay.invdetail.js
 * Anchor: lxy
 * Date: 2022-12-13
 * Description: ��Ʊ��ϸ
 */
$(function () {
	initInvdetailList();
	if ((InvStr!="")&&(typeof InvStr !="undefined")){
		getDataGridData();
	}
});



function getDataGridData(){
   var queryParams = {
	   ClassName: 'BILL.OUTPAY.BL.OPInvAuditCtl',
	   QueryName: 'InvItemListQuery',
	   InvStr: InvStr,
	   AdmReasonDr:AdmReasonDr,
	   ItmName:"",
	   HospDr:session['LOGON.HOSPID']
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
		   {field:'OutFlag',title:'�Ƿ���Ժ��Ʊ',width:100,
		    formatter: function (value, row, index) {
				if (value) {
						return (value == 'Y') ? ('<font color="#21ba45">' + $g('��') + '</font>') : ('<font color="#f16e57">' + $g('��') + '</font>');
					}
			}},
		   {field:'InvDr',title:'��Ʊid',width:150,hidden:true},
		   {field:'ItmDR',title:'��Ŀid',width:150,hidden:true},
		   {field:'ItmCode',title:'��Ŀ����',width:80,hidden:true},
		   {field:'ItmDesc',title:'��Ŀ����',width:130},
		   {field:'Price',title:'����',width:100,align: 'right'},
		   {field:'Qty',title:'����',width:100},
		   {field:'Amt',title:'���',width:100,align: 'right'},
 		   {field:'BillDate',title:'��ϸ��������',width:100},
		   {field:'BillTime',title:'��ϸ����ʱ��',width:100},
		   {field:'HospApprFlag',title:'��˱�ʶ',width:100},
		   {field:'HospApprUserDr',title:'�����Dr',width:100},
		   {field:'HospApprUser',title:'�����',width:100},
		   {field:'HospApprDate',title:'�������',width:100},
		   {field:'HospApprTime',title:'���ʱ��',width:100},
		   {field:'InsuItmCode',title:'ҽ����Ŀ����',width:100},
		   {field:'InsuItmDesc',title:'ҽ����Ŀ����',width:100},
		   {field:'InsuScale',title:'�Ը�����',width:100},
		]],
   });
}
	