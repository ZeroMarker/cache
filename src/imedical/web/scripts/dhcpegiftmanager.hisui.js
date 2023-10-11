
/*
 * FileName:    dhcpegiftmanager.hisui.js
 * Author:      xy
 * Date:        20221205
 * Description: ��Ʒ����
 */
 
 $(function(){
	 
	 //�����б��
	 InitCombobox();
	
	//��ʼ���б�
	InitGiftManagerGrid();
	
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
     
    //������Ʒ
	$("#BSendGift").click(function() {	
		BSendGift_click();		
     });
	
     
})

//������Ʒ
function BSendGift_click()
{	
	var selected = $('#GiftManagerGrid').datagrid('getSelected');
	if (selected==null){
		$.messager.alert('��ʾ', "��ѡ������ŵ���", 'info');
		return;
	}
    
	var TPEADMID=selected.TPEADM;
	if (TPEADMID=="")
	{
		$.messager.alert("��ʾ","��ѡ������ŵ���","info");
		return false;	
	}
	Update("0",TPEADMID);
	return false;
}

function Update(Type,TPEADMID)
{
	var GiftName="";
	var GiftName=$("#GiftName").val();
	if (GiftName=="")
	{
		$.messager.alert("��ʾ","��Ʒ����Ϊ��","info");
		return false;
	}
	
	var ReturnStr=tkMakeServerCall("web.DHCPE.DietManager","UpdateGift",TPEADMID,Type,GiftName);

	if (ReturnStr=="Success")
	{
		$.messager.popover({msg: "��Ʒ���ųɹ���", type: "success",timeout: 1000});
		BFind_click();
		return true;
	}
	if (ReturnStr=="HadGift")
	{
		$.messager.confirm("ȷ��", "�Ѿ�������Ʒ���Ƿ��ٴη��ţ�", function(r){
		if (r){
				Update("1",TPEADMID)
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
	
	var iGiftFlag="";
	var GiftFlag=$("#GiftFlag").checkbox('getValue');
	if(GiftFlag){iGiftFlag="1";}  
	  
	var iGiftName=$("#GiftName").val();
	
	$("#GiftManagerGrid").datagrid('load',{
		ClassName:"web.DHCPE.DietManager",
		QueryName:"SearchIADMGift",
		BeginDate:$("#BeginDate").datebox('getValue'),
		EndDate:$("#EndDate").datebox('getValue'),
		GroupID:iGroupID,
		VIPLevel:$("#VIPLevel").combobox('getValue'),
		RegNo:iRegNo,
		GiftFlag:iGiftFlag,
		GiftName:iGiftName

	});
}

//����
function BClear_click()
{
	$("#RegNo,#GiftName").val("");
	$("#BeginDate").datebox('setValue',"");
	$("#EndDate").datebox('setValue',"");
	$("#VIPLevel").combobox('select','');
	$("#GroupName").combogrid('setValue',"");
	$(".hisui-checkbox").checkbox('setValue',false);
	BFind_click();
}


function InitGiftManagerGrid(){

	$HUI.datagrid("#GiftManagerGrid",{
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
			QueryName:"SearchIADMGift",
			BeginDate:$("#BeginDate").datebox('getValue'),
			EndDate:$("#EndDate").datebox('getValue')
						
		},
		columns:[[       
		    {field:'TPEADM',title:'IADM',hidden: true},
			{field:'TRegNo',width:140,title:'�ǼǺ�'},
			{field:'TName',width:180,title:'����'},	
			{field:'TGroupDesc',width:200,title:'��������'},
			{field:'TDate',width:120,title:'��������'},
			{field:'TTime',width:120,title:'����ʱ��'},
			{field:'TCount',width:120,title:'���Ŵ���'},
			{field:'TRegDate',width:120,title:'��������'},
			{field:'TVIPDesc',width:100,title:'VIP�ȼ�'},
			{field:'TReason',width:240,title:'��Ʒ'}
			
			
		]],
		onSelect: function (rowIndex, rowData) {
			
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
