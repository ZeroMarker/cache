/*
סԺҩ����ҩ����
createdate:2016-04-22
creator:yunhaibao
*/
var commonUrl = "DHCST.INPHA.ACTION.csp";
var gLocId=session['LOGON.CTLOCID'];
var gUserId=session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var inciRowId="";
$(function(){
	InitDateBox(); 		//��ʼ������
	InitPhaLoc(); 		//��ʼ��ҩ��
	InitWardList(); 	//��ʼ������
	InitReturnTotalList(); //��ʼ���б�
	$('#inciName').bind('keypress',function(event){
	 	if(event.keyCode == "13")    
	 	{
		 var input=$.trim($("#inciName").val());
		 if (input!=""){
			var mydiv = new IncItmDivWindow($("#inciName"), input,getDrugList);
            mydiv.init();
		 }else{
			inciRowId="";
		 }	
	 }
	});
	$('#btnFind').bind("click",Query);  //�����ѯ
	$('#btnExport').bind("click",btnExportHandler); //����
    $('#returntotalgrid').datagrid('loadData',{total:0,rows:[]});
	$('#returntotalgrid').datagrid('options').queryParams.params = "";  
});
function InitDateBox(){
	$("#startDate").datebox("setValue", formatDate(0));  //Init��ʼ����
	$("#endDate").datebox("setValue", formatDate(0));  //Init��������	
}
function InitPhaLoc(){
	$('#phaLoc').combobox({  
		width:225,
		panelWidth: 225,
		url:commonUrl+'?action=GetStockPhlocDs&groupId='+gGroupId,  
		valueField:'RowId',  
		textField:'Desc',
		onLoadSuccess: function(){
			var data = $('#phaLoc').combobox('getData');
            if (data.length > 0) {
                  $('#phaLoc').combobox('select', gLocId);
              }            
	    }
	});
}
function InitWardList()
{
	$('#wardLoc').combobox({  
		width:225,
		panelWidth: 225,
		url:commonUrl+'?action=GetWardLocDs',  
		valueField:'RowId',  
		textField:'Desc',
		onLoadSuccess: function(){         
	    }
	});

}
function InitDrugList(alias)
{
		$('#inciName').combobox({
			width:370,
			panelWidth:370,    
			valueField:'RowId',  
			textField:'Desc',  
			Delay:200000, 
			url:commonUrl+'?action=GetInciListByAlias&alias='+alias   , 
			//keyHandler: {  //�س�����
			//	enter: function(){
			//		}
			//}
			//,
			onShowPanel:function(){ //��������
				var inputtxt=$('#inciName').combobox("getText");
				InitDrugList(inputtxt)
			}
		});

}
function InitReturnTotalList(){
	//����columns
	var columns=[[
		{field:"Inci",title:'Inci',hidden:true},
		{field:'inciCode',title:'ҩƷ����',width:100},
		{field:'inciDesc',title:'ҩƷ����',width:250},
		{field:'retQty',title:'��ҩ����',width:80,align:'right'},
		{field:'retUomDesc',title:'��λ',width:80},
		{field:'sp',title:'�ۼ�',width:200,hidden:true},
		{field:'spAmt',title:'�ۼ۽��',width:150,align:'right'},
		{field:'rp',title:'����',width:200,hidden:true},
		{field:'rpAmt',title:'���۽��',width:150,align:'right'},
		
	]];
	
	//����datagrid
	$('#returntotalgrid').datagrid({
		border:false,
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:100,  // ÿҳ��ʾ�ļ�¼����
		pageList:[100,300,500],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		selectOnCheck: true, 
		checkOnSelect: true,
		pagination:true

	});

}
function Query(){
	$('#returntotalgrid').datagrid('loadData',{total:0,rows:[]}); 
	var startDate=$('#startDate').datebox('getValue');   //��ʼ����
	var endDate=$('#endDate').datebox('getValue'); //��ֹ����
    if ($('#inciName').val()==""){inciRowId=""}
	var phaLoc=$('#phaLoc').combobox("getValue"); 
	if($.trim($('#phaLoc').combobox("getText"))==""){
		phaLoc="";
	}
	var wardLoc=$('#wardLoc').combobox("getValue");
	if($.trim($('#wardLoc').combobox("getText"))==""){
		wardLoc="";
	} 
	var params=startDate+"^"+endDate+"^"+phaLoc+"^"+wardLoc+"^"+inciRowId;
	$('#returntotalgrid').datagrid({
		url:commonUrl+'?action=jsQueryInPhaRetTotal',	
		queryParams:{
			params:params},
		onLoadSuccess: function(){
          
	    }
	});
}
function btnExportHandler(){
	ExportAllToExcel("returntotalgrid")
}
function getDrugList(returndata){
	if (returndata["Inci"]>0){
		$("#inciName").val(returndata["InciDesc"]);
		inciRowId=returndata["Inci"];
	}
	else{
		$("#inciName").val("");
		inciRowId="";
	}
}