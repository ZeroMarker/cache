// ��ں���
$(function(){
	setPageLayout(); //��ʼ��ҳ�沼��
	setElementEvent(); //��ʼ��ҳ��Ԫ���¼�
});
//��ʼ��ҳ�沼��
function setPageLayout(){
	$cm({
		ClassName:"BILL.EINV.BL.COM.InvBuyApplyCtl",
		MethodName:"test2"
	},function(jsonData){
		var DataArr=jsonData.stocklist;
		$('#InvBuyStoreView').datagrid({
    		fit:true,
    		fitColumns:true,
    		border:false,
    		striped:true,
    		singleSelect:true,
    		pagination:true,
    		columns:[[   
    			{field:'apply_no',title:'���뵥��',width:100},
    			{field:'invoice_code',title:'����Ʊ�ݴ���',width:100},
    			{field:'invoice_name',title:'����Ʊ������',width:100},
    			{field:'count',title:'����Ʊ������',width:100},
    			{field:'start_no',title:'��ʼ����',width:100},
    			{field:'end_no',title:'��������',width:100},
    			{field:'dis_datetime',title:'��������',width:100}
    		]],
    		data:DataArr
		});
	});
}
//��ʼ��ҳ��Ԫ���¼�
function setElementEvent(){
	
}