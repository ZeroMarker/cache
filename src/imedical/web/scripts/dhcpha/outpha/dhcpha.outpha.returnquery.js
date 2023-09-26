/*
ģ��:����ҩ��
��ģ��:����ҩ��-��ҩ����ѯ
createdate:2016-05-24
creator:dinghongying,yunnaibao
*/
var url = "dhcpha.outpha.returnquery.action.csp";
var commonOutPhaUrl = "DHCST.OUTPHA.ACTION.csp";
var gLocId=session['LOGON.CTLOCID'];
$(function(){	
	InitDateBox();
	InitRefundInfoList();	
	InitRefundDetailList();	
	//�������
	$('#BRetrieve').bind('click', Query);	
	$('#BReset').bind('click',Clear);	
	$('#BExport').bind('click',function(){
		ExportAllToExcel("refundinfodg");
	});
	$('#BPrint').bind('click',BPrintHandler);
	$('#BCancelReturn').bind('click',BCancelReturnHandler);
});
function InitDateBox(){
	$("#CDateSt").datebox("setValue", formatDate(0));  //Init��ʼ����
	$("#CDateEnd").datebox("setValue", formatDate(0));  //Init��ֹ����
}
function Clear(){
	InitDateBox();
	$('#refundinfodg').datagrid('loadData',{total:0,rows:[]}); 
	$('#refunddetaildg').datagrid('loadData',{total:0,rows:[]});
	$('#refundinfodg').datagrid('options').queryParams.params = "";  
	$('#refunddetaildg').datagrid('options').queryParams.params = ""; 
}
//��ʼ����ҩ���б�
function InitRefundInfoList(){
	//����columns
	var columnspat=[[
		{field:'TPmiNo',title:'�ǼǺ�',width:80},    
		{field:'TPatName',title:'����',width:80},
		{field:'TRetDate',title:'��ҩ����',width:80},
		{field:'TRetMoney',title:'��ҩ���',width:80,align:'right'},
		{field:'TRetUser',title:'������',width:100},
		{field:'TDoctor',title:'ҽ��',width:100},
		{field:'TLocDesc',title:'����',width:120},
		{field:'TRetReason',title:'��ҩԭ��',width:150},
		{field:'TDispDate',title:'��ҩ����',width:80},
		{field:'TEncryptLevel',title:'�����ܼ�',width:80},
		{field:'TPatLevel',title:'���˼���',width:80},
		{field:'TRetRowid',title:'TRetRowid',width:80,hidden:true}
	]];  

	//����datagrid	
	$('#refundinfodg').datagrid({    
		url:url+'?action=QueryReturn',
		fit:true,
		border:false,
		singleSelect:true,
		nowrap:false,
		rownumbers:true,
		columns:columnspat,
		pageSize:50,  // ÿҳ��ʾ�ļ�¼����
		pageList:[50,100,300,500],   // ��������ÿҳ��¼�������б�
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true ,
		onLoadSuccess: function(){
			//ѡ�е�һ
			if ($('#refundinfodg').datagrid("getRows").length>0){
				$('#refundinfodg').datagrid("selectRow", 0)
				QueryDetail();
			}else{
				$('#refunddetaildg').datagrid('loadData',{total:0,rows:[]}); 
				$('#refunddetaildg').datagrid('options').queryParams.params = ""; 
			}
		},
		onSelect:function(rowIndex,rowData){
			QueryDetail();
		}      
	});
}


//��ʼ����ҩ����ϸ�б�
function InitRefundDetailList(){
	//����columns
	var columnspat=[[
	    {field:'TPhDesc',title:'ҩƷ����',width:300},    
        {field:'TPhUom',title:'��λ',width:125},    
        {field:'TRetQty',title:'��ҩ����',width:125,align:'right'},
        {field:'TPhprice',title:'����',width:125,align:'right'},    
        {field:'TRetMoney',title:'��ҩ���',width:125,align:'right'}
    ]];  
	
   //����datagrid	
   $('#refunddetaildg').datagrid({    
      url:url+'?action=QueryReturnDetail',
      fit:true,
	  border:false,
	  singleSelect:true,
	  rownumbers:true,
      columns:columnspat
   });
}
///����
function Query(){
	var startDate=$('#CDateSt').datebox('getValue');
	if (startDate==""){
		$.messager.alert('������ʾ',"�����뿪ʼ����!","info");
		return;
	}
	var endDate=$('#CDateEnd').datebox('getValue');
	if (endDate==""){
		$.messager.alert('������ʾ',"�����뿪ʼ����!","info");
		return;
	}
	var params=startDate+"^"+endDate+"^"+gLocId;
	$('#refundinfodg').datagrid({
		queryParams:{
			params:params
		}
	});
}
//��ѯ��ϸ
function QueryDetail(){
	var selectdata=$("#refundinfodg").datagrid("getSelected")
	if (selectdata==null){
		$.messager.alert('������ʾ',"ѡ�������쳣!","info");
		return;
	}
	var params=selectdata["TRetRowid"]
	$('#refunddetaildg').datagrid({
		queryParams:{
			params:params
		}	
	});
}
//��ӡ
function BPrintHandler(){
	var selectdata=$("#refundinfodg").datagrid("getSelected");
	if (selectdata==null){
		$.messager.alert('������ʾ',"��ѡ����Ҫ��ӡ����ҩ��!","info");
		return;
	}
	var retrowid=selectdata["TRetRowid"];
	PrintReturn(retrowid,"��");
}
//������ҩ
function BCancelReturnHandler(){
	var selectdata=$("#refundinfodg").datagrid("getSelected");
	if (selectdata==null){
		$.messager.alert('������ʾ',"��ѡ����Ҫ��������ҩ��!","info");
		return;
	}
	var retrowid=selectdata["TRetRowid"];
	var cancelRet=tkMakeServerCall("web.DHCOutPhReturn","CancleReturn",retrowid);
	if (cancelRet == "-1"){
		$.messager.alert("��ʾ","�ǵ������ҩ��¼,���ܳ�����","info")
		return;
	}else if (cancelRet == "-2"){
		$.messager.alert("��ʾ","��ҩ���ݶ�Ӧ�շѼ�¼������,��˶ԣ�","info")
		return;
	}else if (cancelRet == "-3"){
		$.messager.alert("��ʾ","������¼���˷�,���ܳ�����","info")
		return;
	}else if (cancelRet == "-4"){
		$.messager.alert("��ʾ","������¼�ѳ�����ҩ,��˶ԣ�","info")
		return;
	}else if (cancelRet!=0){
		$.messager.alert("��ʾ","����ʧ��,����ϵ�����Ա���д���","info")
		return;
	}else{
		$.messager.alert("��ʾ","�����ɹ���","success")
		Query();
	}
}