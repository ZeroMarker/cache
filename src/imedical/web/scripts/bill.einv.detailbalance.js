/// ����: bill.einv.detailbalance.js
/// ����: ���ӷ�Ʊ��ϸ����
/// ��д�ߣ�xubaobao
/// ��д����: 2020-09-14

var UserID = session['LOGON.USERID'];
var Hospital = session['LOGON.HOSPID'];
var Group=session['LOGON.GROUPID']
var Loc=session['LOGON.CTLOCID']

$(function(){
	setPageLayout(); //ҳ�沼�ֳ�ʼ��
	setElementEvent(); //ҳ���¼���ʼ��
});

//ҳ�沼�ֳ�ʼ��
function setPageLayout(){
	//��ȡ��ʼ����
	var StDate = new Date().getFullYear() + "-" + (new Date().getMonth() + 1) + "-" + (new Date().getDate()-1);
	//��ȡ��������
	var EdDate = new Date().getFullYear() + "-" + (new Date().getMonth() + 1) + "-" + (new Date().getDate()-1);
	//���ÿ�ʼ����ֵ
	$('#BusStDate').datebox('setValue', StDate);
	//���ý�������ֵ
	$('#BusEdDate').datebox('setValue', EdDate);
	$HUI.datagrid('#Centergrid',{
		title:'����������Ʊ����ϸ',
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
				{field:'CTBalanceFlag',title:'���˱�ʶ',align:'center',width:80},
				{field:'CTBusNo',title:'ҵ����ˮ��',align:'center',width:120},
				{field:'CTPlaceCode',title:'��Ʊ��',align:'center',width:80},
				{field:'CTBillBatchCode',title:'Ʊ�ݴ���',align:'center',width:100},
				{field:'CTBillNo',title:'Ʊ�ݺ���',align:'center',width:100},
				{field:'CTRandom',title:'У����',align:'center',width:80,hidden:true},
				{field:'CTTotalAmt',title:'�ܽ��',align:'center',width:80},
				{field:'CTBusDate',title:'ҵ������',align:'center',width:140},
				{field:'CTBillName',title:'Ʊ����������',align:'center',width:120}
			]]
	});
	
	$HUI.datagrid('#Hisgrid',{
		title:'HIS����Ʊ����ϸ',
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
				{field:'HISBalanceFlag',title:'���˱�ʶ',align:'center',width:80},
				{field:'HISBusNo',title:'ҵ����ˮ��',align:'center',width:120},
				{field:'HISPlaceCode',title:'��Ʊ��',align:'center',width:80},
				{field:'HISBillBatchCode',title:'Ʊ�ݴ���',align:'center',width:100},
				{field:'HISBillNo',title:'Ʊ�ݺ���',align:'center',width:100},
				{field:'HISRandom',title:'У����',align:'center',width:80,hidden:true},
				{field:'HISTotalAmt',title:'�ܽ��',align:'center',width:80},
				{field:'HISBusDate',title:'ҵ������',align:'center',width:140},
				{field:'HISBillName',title:'Ʊ����������',align:'center',width:120}
			]]
	});
	
	$HUI.datagrid('#CenterErrorgrid',{
		title:'�����������쳣����',
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
			{field:'CTPlaceCodeErr',title:'��Ʊ��',align:'center',width:120},
			{field:'CTMedicalDrErr',title:'HIS��ϸID',align:'center',width:100},
			{field:'CTCenterDrErr',title:'��������ϸID',align:'center',width:100},
			{field:'CTBillBatchCodeErr',title:'Ʊ�ݴ���',align:'center',width:100},
			{field:'CTBillNoErr',title:'Ʊ�ݺ���',align:'center',width:100},
			{field:'CTRandomErr',title:'У����',align:'center',width:80,hidden:true},
			{field:'CTTotalAmtErr',title:'�ܽ��',align:'center',width:80},
			{field:'CTDataTypeErr',title:'��������',align:'center',width:80},
			{field:'CTiBlanceDateErr',title:'��������',align:'center',width:140},
			{field:'CTiBlanceUserDrErr',title:'������',align:'center',width:100}
		]]
	});
	$HUI.datagrid('#HisErrorgrid',{
		title:'HIS�����쳣����',
		iconCls:'icon-w-cal',
		fitColumns:true,
		fit:true,
		rownumbers:true,
		singleSelect:true,
		pagination:true,
		pageSize:10,
		pageList:[10,20,30],
		columns:[[     
			{field:'HISPlaceCodeErr',title:'��Ʊ��',align:'center',width:120},
			{field:'HISMedicalDrErr',title:'HIS��ϸID',align:'center',width:100},
			{field:'HISCenterDrErr',title:'��������ϸID',align:'center',width:100},
			{field:'HISBillBatchCodeErr',title:'Ʊ�ݴ���',align:'center',width:100},
			{field:'HISBillNoErr',title:'Ʊ�ݺ���',align:'center',width:100},
			{field:'HISRandomErr',title:'У����',align:'center',width:80,hidden:true},
			{field:'HISTotalAmtErr',title:'�ܽ��',align:'center',width:80},
			{field:'HISDataTypeErr',title:'��������',align:'center',width:80},
			{field:'HISiBlanceDateErr',title:'��������',align:'center',width:140},
			{field:'HISiBlanceUserDrErr',title:'������',align:'center',width:100}
		]]
	})
}

//ҳ���¼���ʼ��
function setElementEvent(){
	
	//��ѯ
	$('#BusSearchBtn').click(function(){
		loadCenterEInvInfo();
		loadHISEInvInfo();
		loadErrorEInvInfo()
	});
	
	//����
	$('#BalanceBtn').click(function(){
		EInvBalance();
	});
	
	//ͬ��HIS��ϸ����
	$('#HISLoadBtn').click(function(){
		HISEInvDataLoad();
	});
	
}


//ͬ��HIS��ϸ����
function HISEInvDataLoad(){
	var BusStDate = $('#BusStDate').datebox('getValue');
	var BusEdDate = $('#BusEdDate').datebox('getValue');
	
	if(BusStDate!=BusEdDate){
		alert("��ȡ��ϸ���ݲ��ܿ��������");
		return;
	}
	
	$m({
		ClassName:"BILL.EINV.BL.COM.EInvBalanceCtl",
		MethodName:"DLMedicalEInvInfo",
		busBgnDate:BusStDate,
		busEndDate:BusEdDate
	},function(rtn){
		if(rtn!= "0"){
			$.messager.alert("��ʾ","ͬ������ʧ��");
		}else{
			$.messager.alert("��ʾ","ͬ�����ݳɹ�");
			//$('#Centergrid').datagrid('reload');
			//$('#Hisgrid').datagrid('reload');
			//loadErrorEInvInfo();
		}
	});
}

//��ȡ����������Ʊ������
function loadCenterEInvInfo(){
	var BusStDate = $('#BusStDate').datebox('getValue');
	var BusEdDate = $('#BusEdDate').datebox('getValue');
	var placeCode=$('#placeCode').val();
	
	if(BusStDate!=BusEdDate){
		alert("��ȡ��ϸ���ݲ��ܿ��������");
		return;
	}
	
	$('#Centergrid').datagrid('load',{
		ClassName:"BILL.EINV.BL.COM.EInvBalanceCtl",
		QueryName:"QueryCenterEInvInfo",
		busBgnDate:BusStDate,
		busEndDate:BusEdDate,
		placeCode:placeCode,
		BalanceFlag:""
	});	
}

//��ȡHIS����Ʊ������
function loadHISEInvInfo(){
	var BusStDate = $('#BusStDate').datebox('getValue');
	var BusEdDate = $('#BusEdDate').datebox('getValue');
	var placeCode=$('#placeCode').val();
	
	if(BusStDate!=BusEdDate){
		alert("��ȡ��ϸ���ݲ��ܿ��������");
		return;
	}
	
	$('#Hisgrid').datagrid('load',{
		ClassName:"BILL.EINV.BL.COM.EInvBalanceCtl",
		QueryName:"QueryHISEInvInfo",
		busBgnDate:BusStDate,
		busEndDate:BusEdDate,
		placeCode:placeCode,
		BalanceFlag:""
	});	
}

// �쳣����
function loadErrorEInvInfo(){
	var BusStDate = $('#BusStDate').datebox('getValue');
	var BusEdDate = $('#BusEdDate').datebox('getValue');
	var placeCode=$('#placeCode').val();
	
	if(BusStDate!=BusEdDate){
		alert("��ȡ��ϸ���ݲ��ܿ��������");
		return;
	}
	
	$('#CenterErrorgrid').datagrid('load',{
		ClassName:"BILL.EINV.BL.COM.EInvBalanceCtl",
		QueryName:"QueryCTBalanceListErr",
		busBgnDate:BusStDate,
		busEndDate:BusEdDate,
		placeCode:placeCode
	});	
	
	$('#HisErrorgrid').datagrid('load',{
		ClassName:"BILL.EINV.BL.COM.EInvBalanceCtl",
		QueryName:"QueryHISBalanceListErr",
		busBgnDate:BusStDate,
		busEndDate:BusEdDate,
		placeCode:placeCode
	});	
}


//����
function EInvBalance(){
	
	var BusStDate = $('#BusStDate').datebox('getValue');
	var BusEdDate = $('#BusEdDate').datebox('getValue');
	var placeCode=$('#placeCode').val();
	var Exstr=UserID+"^"+Hospital;			//������^Ժ��^��������
	
	if(BusStDate!=BusEdDate){
		alert("��ȡ��ϸ���ݲ��ܿ��������");
		return;
	}
	
	$m({
		ClassName:"BILL.EINV.BL.COM.EInvBalanceCtl",
		MethodName:"EInvDetailBalance",
		busBgnDate:BusStDate,
		busEndDate:BusEdDate,
		placeCode:placeCode,
		Exstr:Exstr
	},function(rtn){
		if(rtn!= "0"){
			$.messager.alert("��ʾ","����ʧ��");
		}else{
			$.messager.alert("��ʾ","���˳ɹ�");
			$('#Centergrid').datagrid('reload');
			$('#Hisgrid').datagrid('reload');
			loadErrorEInvInfo();
		}
	});
}
