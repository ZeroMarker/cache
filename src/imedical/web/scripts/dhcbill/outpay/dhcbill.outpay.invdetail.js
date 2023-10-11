/**
 * FileName: dhcbill/outpay/dhcbill.outpay.invdetail.js
 * Anchor: lxy
 * Date: 2022-12-13
 * Description: 发票明细
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
		   {field:'OutFlag',title:'是否外院发票',width:100,
		    formatter: function (value, row, index) {
				if (value) {
						return (value == 'Y') ? ('<font color="#21ba45">' + $g('是') + '</font>') : ('<font color="#f16e57">' + $g('否') + '</font>');
					}
			}},
		   {field:'InvDr',title:'发票id',width:150,hidden:true},
		   {field:'ItmDR',title:'项目id',width:150,hidden:true},
		   {field:'ItmCode',title:'项目编码',width:80,hidden:true},
		   {field:'ItmDesc',title:'项目名称',width:130},
		   {field:'Price',title:'单价',width:100,align: 'right'},
		   {field:'Qty',title:'数量',width:100},
		   {field:'Amt',title:'金额',width:100,align: 'right'},
 		   {field:'BillDate',title:'明细发生日期',width:100},
		   {field:'BillTime',title:'明细发生时间',width:100},
		   {field:'HospApprFlag',title:'审核标识',width:100},
		   {field:'HospApprUserDr',title:'审核人Dr',width:100},
		   {field:'HospApprUser',title:'审核人',width:100},
		   {field:'HospApprDate',title:'审核日期',width:100},
		   {field:'HospApprTime',title:'审核时间',width:100},
		   {field:'InsuItmCode',title:'医保项目编码',width:100},
		   {field:'InsuItmDesc',title:'医保项目名称',width:100},
		   {field:'InsuScale',title:'自付比例',width:100},
		]],
   });
}
	