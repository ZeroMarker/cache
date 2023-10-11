<!--js  bill.einv.centereinvinfo.js -->
<!-- ��ں��� -->
$(function(){
	setPageLayout();
	setElementEvent();	
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
	$('#BusEDate').datebox('setValue', EdDate);
	
	$('#CetaList').datagrid({
		pagination:'true', // ��ҳ������
		pageSize:'10',
		pageList:[10,20,30],
		singleSelect:'true',
		striped:'true', // ��ʾ������Ч��
		height: 600,
		//rownumbers:true,
		fit:true,
		url:$URL,
		queryParams: {
			ClassName:"BILL.EINV.BL.COM.CenterEInvInfoCtl",
			QueryName:"QueryCenterEInvInfo"
		},
		columns:[[
			{field:'ID',title:'ID'},
			{field:'checkbox',checkbox:true},
			{field:'BusNo',title:'ҵ����ˮ��',width:300,hidden:true},
			{field:'PlaceCode',title:'��Ʊ�����',width:100},
			{field:'BillName',title:'Ʊ����������',width:270},
			{field:'BillBatchCode',title:'Ʊ�ݴ���',width:100},
			{field:'BillNo',title:'Ʊ�ݺ���',width:100},
			{field:'Random',title:'У����',width:100},
			{field:'TotalAmt',title:'�ܽ��',width:100},
			{field:'BusDate',title:'ҵ������',width:100},
			{field:'BusTime',title:'ҵ��ʱ��',width:100},
			{field:'IvcDate',title:'��Ʊ����',width:100},
			{field:'IvcTime',title:'��Ʊʱ��',width:100},
			{field:'DataType',title:'��������',width:100},
			{field:'State',title:'״̬',width:100},
			{field:'RelateBillBatchCode',title:'��������Ʊ�ݴ���',width:120},
			{field:'RelateBillNo',title:'��������Ʊ�ݺ���',width:120},
			{field:'InvFactoryCD',title:'�����̱���',width:100},
			{field:'InvFactoryNM',title:'���������� ',width:100},
			{field:'XStr1',title:'����1 ',width:60,hidden:true},
			{field:'XStr2',title:'����2 ',width:60,hidden:true},
			{field:'XStr3',title:'����3 ',width:60,hidden:true},
			{field:'XStr4',title:'����4 ',width:60,hidden:true},
			{field:'XStr5',title:'����5 ',width:60,hidden:true}
		]],
		onBeforeLoad:function(param){
			param.rows='';
		}
	});
}	
	


function setElementEvent(){
	$('#searchBtn').click(function(){
		SearchBtn();
	});
	$('#DownLoadBtn').click(function(){
		DownBillData();
	});
}
//��ѯ
function SearchBtn(){
	var PlaceCode=$('#PlaceCode').val();
	var BillBatchCode="";
	var BillNo="";
	var BusDate=$('#BusStDate').datebox('getValue');
	var EdDate=$('#BusEDate').datebox('getValue');
	//alert(BusDate+"^"+EdDate+"^"+PlaceCode)
	$('#CetaList').datagrid('load',{
			ClassName:"BILL.EINV.BL.COM.CenterEInvInfoCtl",
			QueryName:"QueryCenterEInvInfo",
			PlCode:PlaceCode,
			BBatchCode:BillBatchCode,
			BiNo:BillNo,
			stDate:BusDate,
			edDate:EdDate
	});
	
}

//����Ʊ������
function DownBillData(){
	var BusStDate =$('#BusStDate').datebox('getValue');
	var BusEdDate =$('#BusEDate').datebox('getValue');
	
	var InputPam=BusStDate+"^"+BusEdDate+"^^^1^200"
	//alert(InputPam)
	$m({
		ClassName:"BILL.EINV.BL.EInvoiceLogic",
		MethodName:"DLEInvBillMXList",
		InputPam:InputPam
	},function(rtn){
		if(rtn=="0"){
			SearchBtn();
		}else{
			$.messager.alert("��ʾ","��������ʧ��");
		}
	});
}




