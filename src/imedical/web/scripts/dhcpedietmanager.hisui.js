
/*
 * FileName:    dhcpedietmanager.hisui.js
 * Author:      xy
 * Date:        20221205
 * Description: �ͻ��Ͳ�
 */
 
 $(function(){
	 
	 //�����б��
	 InitCombobox();
	
	//��ʼ���б�
	InitDietManagerGrid();
	
	$("#RegNo").keydown(function (e) {
		if (e.keyCode == 13) {
			Update(0);
		}
	});
	
	//��ѯ
	$("#BFind").click(function() {	
		BFind_click();		
     });
     
    
	  //����
	 $("#BClear").click(function() {	
		BClear_click();		
     });
     
    //�Ͳ�
	$("#BDiet").click(function() {	
		BDiet_click();		
     });
	
	//ȡ���Ͳ�
	$("#BCancelDiet").click(function() {	
		BCancelDiet_click();		
     });
     
})



//�Ͳ�
function BDiet_click()
{	
	Update("0")
	return false;
}


function Update(Type)  
{
	var selected = $('#DietManagerGrid').datagrid('getSelected');
	if (selected==null){
		$.messager.alert('��ʾ', "����ѡ����Ͳ͵���", 'info');
		return;
	}
	
	var CTLocID=session['LOGON.CTLOCID'];
	var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength",CTLocID);
	var iRegNo=	$("#RegNo").val();
	if (iRegNo.length<RegNoLength && iRegNo.length>0) { 
			iRegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",iRegNo,CTLocID);
			$("#RegNo").val(iRegNo);
	}
	

	var TPEADMID=selected.TPEADM;
	
	if(iRegNo==""){
		var TPEADMID=TPEADMID;
	}else{
		TPEADMID=iRegNo+"^";
	}
	
	if (TPEADMID=="")
	{
		 $.messager.alert("��ʾ","����ѡ����Ͳ͵���","info"); 
		return false; 
	}
	
	var IsDietFlag=tkMakeServerCall("web.DHCPE.DietManager","IsDietFlag",TPEADMID);
	
	if(IsDietFlag=="NCanntDiet")
	{
		 $.messager.alert("��ʾ","û�оͲ�Ȩ��","info"); 
		return true;
	}
	else if(IsDietFlag=="NoPerson")
	{
		 $.messager.alert("��ʾ","û��ѡ��Ͳ���Ա������Աû�е���","info"); 
		return false;
	}else if(IsDietFlag=="CanntDiet"){
		$.messager.alert("��ʾ","��ǰ��Ŀ��δ�����,���ܳԷ�","info");
		return false;
	}else if(IsDietFlag=="HadDiet")
	{
	
		$.messager.confirm("ȷ��", "�Ѿ��Ͳ�,�Ƿ��ٴξͲͣ�", function(r){
		if (r){
			 var ReturnStr=tkMakeServerCall("web.DHCPE.DietManager","UpdateDietNew",TPEADMID,1)
			 if (ReturnStr=="Success")
			 { 
				$.messager.popover({msg: "�Ͳͳɹ���", type: "success",timeout: 1000});
				BFind_click();
				return true;
			}
			
			}
		else{
			
		}
		});

		
	}else{
	

		var ReturnStr=tkMakeServerCall("web.DHCPE.DietManager","UpdateDietNew",TPEADMID,0)
		if (ReturnStr=="Success")
		{ 
	    	$.messager.popover({msg: "�Ͳͳɹ���", type: "success",timeout: 1000});
        	BFind_click();
			return true;
		}
	
	}
	
	return false;
	
	
}

//ȡ���Ͳ�
function BCancelDiet_click()
{
	CancelDiet("0");
	return false;
}

function CancelDiet(Type)
{
	var selected = $('#DietManagerGrid').datagrid('getSelected');
	if (selected==null){
		$.messager.alert('��ʾ', "��ѡ���ȡ���Ͳ͵���", 'info');
		return;
	}
	
	
	var TPEADMID=selected.TPEADM;
	var TCount=selected.TCount;
	if (TPEADMID=="")
	{
		$.messager.alert("��ʾ","��ѡ���ȡ���Ͳ͵���","info");
		return false; 
	}
	
	
	var ReturnStr=tkMakeServerCall("web.DHCPE.DietManager","CancelDiet",TPEADMID,Type,TCount);	
	if (ReturnStr=="NCancelDiet")
	{ 
		$.messager.alert("��ʾ","����ȡ���Ͳ�","info");
		return true;
	}
	if (ReturnStr=="Success")
	{ 
	    $.messager.popover({msg: "ȡ���Ͳͳɹ���", type: "success",timeout: 1000});
	    
		BFind_click();
		return true;
	}
	if (ReturnStr=="CancelDiet")
	{
		$.messager.confirm("ȷ��", "�Ƿ�ȷ��ȡ���Ͳͣ�", function(r){
		if (r){
				CancelDiet("1");
			}
		});
	}
	
	return false;
}


//��ѯ
function BFind_click() {
	
	
	var CTLocID=session['LOGON.CTLOCID'];
	var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength",CTLocID);
	var iRegNo=	$("#RegNo").val();
	if (iRegNo.length<RegNoLength && iRegNo.length>0) { 
			iRegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",iRegNo,CTLocID);
			$("#RegNo").val(iRegNo);
	}
	
	var iGroupID=$("#GroupName").combogrid('getValue');
	if (($("#GroupName").combogrid('getValue')==undefined)||($("#GroupName").combogrid('getValue')=="")){var iGroupID="";} 
	
	var iDietFlag="N";
	var DietFlag=$("#DietFlag").checkbox('getValue');
	if(DietFlag){iDietFlag="Y";}  
	  
	$("#DietManagerGrid").datagrid('load',{
		ClassName:"web.DHCPE.DietManager",
		QueryName:"SearchIADMDiet",
		BeginDate:$("#BeginDate").datebox('getValue'),
		EndDate:$("#EndDate").datebox('getValue'),
		GroupID:iGroupID,
		VIPLevel:$("#VIPLevel").combobox('getValue'),
		RegNo:iRegNo,
		DietFlag:iDietFlag

	});
}

//����
function BClear_click()
{
	$("#RegNo").val("");
	$("#BeginDate").datebox('setValue',"");
	$("#EndDate").datebox('setValue',"");
	$("#VIPLevel").combobox('select','');
	$("#GroupName").combogrid('setValue',"");
	$(".hisui-checkbox").checkbox('setValue',false);
	BFind_click();
}


function InitDietManagerGrid(){

	$HUI.datagrid("#DietManagerGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: true,
		selectOnCheck: false,
		queryParams:{
			ClassName:"web.DHCPE.DietManager",
			QueryName:"SearchIADMDiet",
			BeginDate:$("#BeginDate").datebox('getValue'),
			EndDate:$("#EndDate").datebox('getValue')
						
		},
		columns:[[       
		    {field:'TPEADM',title:'IADM',hidden: true},
			{field:'TRegNo',width:140,title:'�ǼǺ�'},
			{field:'TName',width:200,title:'����'},	
			{field:'TGroupDesc',width:220,title:'��������'},
			{field:'TDate',width:120,title:'�Ͳ�����'},
			{field:'TTime',width:120,title:'�Ͳ�ʱ��'},
			{field:'TCount',width:120,title:'�Ͳʹ���'},
			{field:'TRegDate',width:120,title:'��������'},
			{field:'TVIPDesc',width:100,title:'VIP�ȼ�'},
			{field:'TReason',width:240,title:'ԭ��'}
			
		]],
		onSelect: function (rowIndex, rowData) {
		
			//$("#PAADM").val(rowData.TEpisodeID);
			//$("#ReportStatus").val(rowData.TStatus);
			
		},
		onLoadSuccess: function(data) {
			
		},
			
	})
	
}


function InitCombobox()
{
	// VIP�ȼ�	
	var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindVIP&ResultSetType=array&LocID="+session['LOGON.CTLOCID'],
		valueField:'id',
		textField:'desc'
	});
	
	//����
	var GroupNameObj = $HUI.combogrid("#GroupName",{
		panelWidth:450,
		url:$URL+"?ClassName=web.DHCPE.DHCPEGAdm&QueryName=GADMList",
		mode:'remote',
		delay:200,
		idField:'TRowId',
		textField:'TGDesc',
		onBeforeLoad:function(param){
			param.GBIDesc = param.q;
		},

		columns:[[
			{field:'TRowId',title:'����ID',width:80},
			{field:'TGDesc',title:'��������',width:140},
			{field:'TGStatus',title:'״̬',width:100},
			{field:'TAdmDate',title:'����',width:100}			
			
		]]
	});
	
	
}
