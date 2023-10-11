/// ����: bill.einv.balanceday.js
/// ����: ҽ����ѯ
/// ��д�ߣ�������
/// ��д����: 2019-09-27
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
		columns:[
			[
				{title:'������������',colspan:4},
				{title:'His������Ŀ',colspan:4}
			],
			[     
				{field:'BusDate',title:'ҵ������',align:'center',width:120},
				{field:'CopyNum',title:'�ܱ���',align:'center',width:120},
				{field:'AllTotalAmt',title:'�ܽ��',align:'center',width:120},
				{field:'AllTotalNum',title:'�ܿ�Ʊ��',align:'center',width:120},
			
				{field:'HisBusDate',title:'ҵ������',align:'center',width:120},
				{field:'HisCopyNum',title:'�ܱ���',align:'center',width:120},
				{field:'HisAllTotalAmt',title:'�ܽ��',align:'center',width:120},
				{field:'HisAllTotalNum',title:'�ܿ�Ʊ��',align:'center',width:120}
			]
		]
	});
	
	$HUI.datagrid('#Errorgrid',{
		title:'�����쳣����',
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
			{field:'PlaceCodeErr',title:'��Ʊ��',align:'center',width:100},
			{field:'MedicalDrErr',title:'HIS��ϸID',align:'center',width:100},
			{field:'CenterDrErr',title:'��������ϸID',align:'center',width:100},
			{field:'BillBatchCodeErr',title:'Ʊ�ݴ���',align:'center',width:100},
			{field:'BillNoErr',title:'Ʊ�ݺ���',align:'center',width:100},
			{field:'RandomErr',title:'У����',align:'center',width:80,hidden:true},
			{field:'CTTotalAmtErr',title:'�������ܽ��',align:'center',width:120},
			{field:'HISTotalAmtErr',title:'HIS�ܽ��',align:'center',width:100},
			{field:'CommonInfoErr',title:'����˵��',align:'center',width:120},
			{field:'DataTypeErr',title:'��������',align:'center',width:100},
			{field:'iBlanceUserDrErr',title:'������',align:'center',width:100},
			{field:'iBlanceDateErr',title:'��������',align:'center',width:160}
			
		]]
	});
	
	/*$HUI.datagrid('#balancesubdaydatagrid',{
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
		]]
	});
	$HUI.datagrid('#hisdatagrid',{
		title:'His������Ŀ',
		iconCls:'icon-w-cal',
		fitColumns:true,
		fit:true,
		rownumbers:true,
		singleSelect:true,
		pagination:true,
		pageSize:10,
		pageList:[10,20,30],
		columns:[[     
			{field:'1',title:'��ɫ����',width:100},    
			{field:'2',title:'��ɫ������',width:100},
			{field:'3',title:'��ɫ����',width:100},    
			{field:'4',title:'��ɫ������',width:100},
			{field:'5',title:'��ɫ����',width:100},    
			{field:'6',title:'��ɫ������',width:100},
		]]
	});*/
}
//ҳ���¼���ʼ��
function setElementEvent(){
	$('#BusSearchBtn').click(function(){
		loadBalanceDayInfo();
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
	$('#Errorgrid').datagrid('load',{
		ClassName:"BILL.EINV.BL.COM.EInvBalanceCtl",
		QueryName:"QueryBalanceListErr",
		busBgnDate:BusStDate,
		busEndDate:BusEdDate,
		placeCode:""
	});		
}