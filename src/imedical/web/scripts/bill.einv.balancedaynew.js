/// ����: bill.einv.balancedaynew.js
/// ����: ҽ����ѯ
/// ��д�ߣ�������
/// ��д����: 2019-09-29
$(function(){
	setPageLayout(); //ҳ�沼�ֳ�ʼ��
	setElementEvent(); //ҳ���¼���ʼ��
});
//ҳ�沼�ֳ�ʼ��
function setPageLayout(){
	//��ȡ��ʼ����
	var StDate = new Date().getFullYear() + "-" + (new Date().getMonth() + 1) + "-" + (new Date().getDate()-1);
	//��ȡ��������
	var EdDate = new Date().getFullYear() + "-" + (new Date().getMonth() + 1) + "-" + new Date().getDate();
	//���ÿ�ʼ����ֵ
	$('#BusStDate').datebox('setValue', StDate);
	//���ý�������ֵ
	$('#BusEdDate').datebox('setValue', EdDate);
	
	$HUI.datagrid('#balancedaydatagrid',{
		title:'�ն����˽��',
		iconCls:'icon-w-cal',
		fitColumns:true,
		fit:true,
		rownumbers:true,
		singleSelect:true,
		pagination:true,
		pageSize:10,
		pageList:[10,20,30],
		url:$URL,
		columns:[[     
				{field:'BusDate',title:'ҵ������',align:'center',width:120},
				{field:'CopyNum',title:'�ܱ���',align:'center',width:120},
				{field:'AllTotalAmt',title:'�ܽ��',align:'center',width:120},
				{field:'AllTotalNum',title:'�ܿ�Ʊ��',align:'center',width:120}
		]],
		onLoadSuccess:function(){
		}
	});
	$HUI.datagrid('#balancesubdaydatagrid',{
		title:'������������',
		iconCls:'icon-w-cal',
		fitColumns:true,
		fit:true,
		rownumbers:true,
		singleSelect:true,
		pagination:true,
		pageSize:10,
		pageList:[10,20,30],
		url:$URL,
		columns:[[     
			{field:'BusDate',title:'ҵ������',width:100},    
			{field:'BillBatchCode',title:'����Ʊ�ݴ���',width:100},
			{field:'BillName',title:'Ʊ����������',width:100},    
			{field:'BgnNo',title:'��ʼ����',width:100},
			{field:'EndNo',title:'��ֹ����',width:100},    
			{field:'CopyNum',title:'Ʊ�Ŷ����ܿ�Ʊ��',width:100},
			{field:'TotalAmt',title:'Ʊ�Ŷ����ܽ��',width:100}
		]],
		onLoadSuccess:function(){
		}
	});
}
//ҳ���¼���ʼ��
function setElementEvent(){
	$('#BusSearchBtn').click(function(){
		loadBalanceDayInfo();
	});
	$('#DownLoadBtn').click(function(){
		DowncheckTotalData();
	});
}
function loadBalanceDayInfo(){
	//�ն�����
	var BusStDate = $('#BusStDate').datebox('getValue');
	var BusEdDate = $('#BusEdDate').datebox('getValue');
	$('#balancedaydatagrid').datagrid('load',{
		ClassName:"BILL.EINV.BL.COM.BalanceDayCtl",
		QueryName:"QueryBalanceDayInfo",
		BusStDate:BusStDate,
		BusEdDate:BusEdDate
	});	
	//������������
	$('#balancesubdaydatagrid').datagrid('load',{
		ClassName:"BILL.EINV.BL.COM.BalanceDayCtl",
		QueryName:"QueryBalanceSubDayInfo",
		BusStDate:BusStDate,
		BusEdDate:BusEdDate
	});		
}

//�����ܱ����˶�����
function DowncheckTotalData(){
	var BusStDate = $('#BusStDate').datebox('getValue');
	var BusEdDate = $('#BusEdDate').datebox('getValue');
	if (BusStDate!=BusEdDate){
		$.messager.alert('��ʾ', 'ֻ������ĳһ��ĺ˶�����.��ѡ����Ҫ���ص�����');
		return;
	}
	
	var InputPam=BusStDate+"^^^1^1^200"
	alert(InputPam)
	$m({
		ClassName:"BILL.EINV.BL.EInvoiceLogic",
		MethodName:"DLEInvBillList",
		InputPam:InputPam
	},function(rtn){
		if(rtn=="0"){
			loadBalanceDayInfo();
		}else{
			$.messager.alert("��ʾ","��������ʧ��");
		}
	});
}