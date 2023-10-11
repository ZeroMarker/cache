//����	DHCPEChangeRoomPlace.hisui.js
//����	����λ�øı�
//����	2020.12.19
//������  xy

$(function(){
			
	InitCombobox();
	
	Info();
	
	InitChangeRoomPlaceGrid(); 

	//��ѯ
	$("#BFind").click(function() {	
		BFind_click();		
        });  
        
     //����
	$("#BSave").click(function() {	
		BSave_click();		
        }); 
        
         
     $("#RegNo").keydown(function(e) {
			
			if(e.keyCode==13){
				PreIADM="";
				$("#Name,#Sex,#IDCard,#GDesc,#TeamDesc,#VIPLevel,#HPNo,#OldRoomPlace").val("");

				BFind_click();
			}
			
        }); 
        
    
})


function Info(){
	var HospID=session['LOGON.HOSPID']
	
	var BaseInfo=tkMakeServerCall("web.DHCPE.PreIADMReplace","GetPreInfo",PreIADM,HospID);
	var Arr=BaseInfo.split("^");
		
	$("#Status").val(Arr[0]);
	$("#GDesc").val(Arr[1]);
	$("#TeamDesc").val(Arr[2]);
	$("#VIPLevel").val(Arr[3]);
	$("#HPNo").val(Arr[4]);
	$("#OldRoomPlace").val(Arr[5]);
	$("#RegNo").val(Arr[7]);
	$("#Name").val(Arr[8]);
	$("#Sex").val(Arr[9]);
	$("#IDCard").val(Arr[11]); 

}
function BFind_click() {
	
	
	var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength");
	var iRegNo=	$("#RegNo").val();
	if (iRegNo.length<RegNoLength && iRegNo.length>0) { 
			iRegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",iRegNo);
			$("#RegNo").val(iRegNo);
	}
	
	var HospID=session['LOGON.HOSPID'];
	$("#ChangeRoomPlaceGrid").datagrid('load',{
			ClassName:"web.DHCPE.PreIADM",
			QueryName:"SearchPreIADM",
			RegNo:iRegNo,
			HospID:HospID
			
			
			})
 	
	
}

function BSave_click(){
	
	//alert(PreIADM)
	if (PreIADM==""){
		$.messager.alert("��ʾ","����ѡ�������¼","info");
		return false;
	}
	var RoomPlace=$("#RoomPlace").combobox('getValue');
	if((RoomPlace=="undefined")||(RoomPlace=="")){
		$.messager.alert("��ʾ","��ѡ������λ��","info");
		return false;
		}


	var rtn=tkMakeServerCall("web.DHCPE.PreIADM","UpdateRoomPlace","I",PreIADM,RoomPlace)

	if (rtn.split("^")[0]=="-1"){
		$.messager.alert("��ʾ","����ʧ��"+rtn.split("^")[1],"info");
	}else{
		var DeleteOldRoom=tkMakeServerCall("web.DHCPE.RoomManager","NeedDeleteOldRoom",PreIADM);
		
		if (DeleteOldRoom==1){
			
			
			$.messager.confirm("������ʾ", "�Ƿ���Ҫ��ԭ�����ң��������·���������?", function (data) {
            		if (data) {
	        		var ret=tkMakeServerCall("web.DHCPE.RoomManager","DeleteOldRoom",PreIADM);
					$.messager.alert("��ʾ",ret.split("^")[1],"info");
	        		
	        		}
            		else {
                		return false;
            		}
        			});
			
		}
		PreIADM="";
		BFind_click();
	}
	
}

function InitChangeRoomPlaceGrid()
{
	
	$HUI.datagrid("#ChangeRoomPlaceGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : false,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: true,
		checkOnSelect: true, //���Ϊfalse, ���û����ڵ���ø�ѡ���ʱ��Żᱻѡ�л�ȡ��
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.PreIADM",
			QueryName:"SearchPreIADM",
			RegNo:$("#RegNo").val(),
			HospID:session['LOGON.HOSPID']
		},
		
		columns:[[
		
			{field:'PIADM_RowId',title:'PIADM',hidden: true},
			{field:'PIADM_PIBI_DR_RegNo',width:110,title:'�ǼǺ�'},
			{field:'PIADM_PIBI_DR_Name',width:110,title:'����'},
			{field:'TNewHPNo',width:110,title:'����'},
			{field:'PIADM_VIP',width:80,title:'VIP�ȼ�'},
			{field:'TRoomPlace',width:130,title:'����λ��'},
			{field:'PIADM_PEDateBegin',width:100,title:'�������'},
			{field:'PIADM_Status_Desc',width:60,title:'״̬'},
			{field:'PIBI_IDCard',width:160,title:'֤����'},
			{field:'TPACCardType',width:100,title:'֤������'},
			{field:'PIADMPIBI_DR_SEX',width:60,title:'�Ա�'},
			{field:'TAge',width:60,title:'����'},
			{field:'PIADM_PGADM_DR_Name',width:130,title:'��������'},
			{field:'PIADM_PGTeam_DR_Name',title:'����',hidden: true},
				
			
		]],
			onSelect: function (rowIndex, rowData) {
				
			  if(rowData.PIADM_RowId==""){
				  PreIADM=""
				  $("#RegNo,#Name,#Sex,#IDCard,#GDesc,#TeamDesc,#VIPLevel,#HPNo,#OldRoomPlace").val("");	
			  }else{
				  PreIADM=rowData.PIADM_RowId;
				 
				  $("#RegNo").val(rowData.PIADM_PIBI_DR_RegNo);
				  $("#Name").val(rowData.PIADM_PIBI_DR_Name);
				  $("#Sex").val(rowData.PIADMPIBI_DR_SEX+"/"+rowData.TAge);
				  $("#IDCard").val(rowData.PIBI_IDCard);
				  $("#GDesc").val(rowData.PIADM_PGADM_DR_Name);
				  $("#TeamDesc").val(rowData.PIADM_PGTeam_DR_Name);
				  $("#VIPLevel").val(rowData.PIADM_VIP);
				  $("#HPNo").val(rowData.TNewHPNo);
				  $("#OldRoomPlace").val(rowData.TRoomPlace)
		
			  }
			
		}
			
	});
}

function InitCombobox()
{
	//����λ��
        var RoomPlaceObj = $HUI.combobox("#RoomPlace",{
	        panelWidth:200,
	     	url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=GetRoomPlace&ResultSetType=array",
        	valueField:'id',
        	textField:'desc'
        })
}