//����	dhcpe/ct/dhcperoomspecimen.hisui.js
//����	���ұ걾ά��
//����	2021.08.07
//������  sxt
var lastIndex = "";
var EditIndex = -1;

var tableName = "DHC_PE_Area";
var RoomtableName = "DHC_PE_Room";
var RoomIPtableName = "DHC_PE_RoomIP";
var roomSpecialRoomtableName = "DHC_PE_RoomSpecialRoom";
var RoomRoomPlaceptableName = "DHCPERoomRoomPlace";
var RoomSpecimentableName = "DHC_PE_RoomSpecimen";
var RoomPlaceptableName = "DHC_PE_RoomSpecimen";  /// ��������λ���ֵ��

var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']



$(function(){
		
	//GetLocComp(SessionStr);
	
	InitCombobox();
	
	Init();
	 
	InitRoomSpecimenGrid();

     //����
    $('#BClear').click(function(e){
    	BClear_click();
    });
     
    //����
    $('#add_btn').click(function(e){
    	AddData();
    });
    
    //�޸�
    $('#update_btn').click(function(e){
    	UpdData();
    });
    
    //ɾ��
    $('#del_btn ').click(function(){
    	DelData();
    });
    
  
})


function Init(){
	
	
	if (RoomType=="IP"){
		$("#Specimen").next(".combo").hide();//combobox����
		$("#CSpecimen").css('display','none');
		
	}else if(RoomType=="RP")
	{
		$("#IP").css('display','none');
		$("#CIP").css('display','none');
		if(RoomType=="RP") {document.getElementById('CSpecimen').innerHTML="����λ��";}
	}else{
		$("#IP").css('display','none');
		$("#CIP").css('display','none');
		if(RoomType=="SR") {document.getElementById('CSpecimen').innerHTML="ǰ������";}
	}
	
}

//ɾ��
function DelData(){

	if (RoomType=="SP"){
		var Specimen=$("#Specimen").combobox('getValue');
  		if (($("#Specimen").combobox('getValue')==undefined)||($("#Specimen").combobox('getValue')=="")){var Specimen="";}
	}else{
		var Specimen=$("#IP").val();
	}
	
	var ID=$("#RowId").val();
	if (ID=="")
	{
		$.messager.alert("��ʾ","��ѡ���ɾ����¼","info");
		return false;
	}
	
	var rtn=tkMakeServerCall("web.DHCPE.CT.RoomManager","DeleteSpecimen",ID,RoomType);
	if (rtn.split("^")[0]=="-1"){
		$.messager.alert('��ʾ',"ɾ��ʧ��"+rtn.split("^")[1],"error");
	}else{
		$.messager.alert('��ʾ',"ɾ���ɹ�","success");
		BClear_click();
	}
}

//����
function BClear_click(){
		$("#RowId,#IP").val("");
		$("#Specimen").combobox('setValue',"");
		$("#RoomSpecimenGrid").datagrid('load',{
			ClassName:"web.DHCPE.CT.RoomManager",
			QueryName:"FindRoomSpecimen",
			Parref:selectrow, 
			Type:RoomType,
			LocID:DefLoc
		});	
	
}
//����
function AddData(){
	Update("0");
}


//����
function UpdData(){
	Update("1");
}

function Update(Type){
	var ID=$("#RowId").val();
	if(Type=="1"){
		if(ID==""){
			$.messager.alert("��ʾ","��ѡ����޸ĵļ�¼","info");
			return false;
		}
	}
	var TableName="";
	if(Type=="0"){
	    if(ID!=""){
		    	$.messager.alert("��ʾ","�������ݲ���ѡ�м�¼,�����������������","info");
		    	return false;
		    }
	}
    if (RoomType=="IP"){
	    TableName=RoomIPtableName;
		var Specimen=$("#IP").val();
		if(Specimen==""){
			$.messager.alert("��ʾ","����IP����Ϊ��","info");
			return false;
		}
		
	}else if(RoomType=="SP")
	{
		var Specimen=$("#Specimen").combobox('getValue');
  		if (($("#Specimen").combobox('getValue')==undefined)||($("#Specimen").combobox('getValue')=="")){var Specimen="";}
  		/*
  		var roomSpecialRoomtableName = "DHC_PE_RoomSpecialRoom";
		var RoomRoomPlaceptableName = "DHCPERoomRoomPlace";
		var RoomSpecimentableName = "DHC_PE_RoomSpecimen";
		*/
  		TableName=RoomSpecimentableName;
		if(Specimen==""){
			$.messager.alert("��ʾ","�걾���Ͳ���Ϊ��","info");
			return false;
		}
	}else if(RoomType=="RP")
	{
		var Specimen=$("#Specimen").combobox('getValue');
  		if (($("#Specimen").combobox('getValue')==undefined)||($("#Specimen").combobox('getValue')=="")){var Specimen="";}
  		TableName=RoomRoomPlaceptableName;
  		
		if(Specimen==""){
			$.messager.alert("��ʾ","����λ�ò���Ϊ��","info");
			return false;
		}
	}else if(RoomType=="SR")
	{
		TableName=roomSpecialRoomtableName;
		var Specimen=$("#Specimen").combobox('getValue');
  		if (($("#Specimen").combobox('getValue')==undefined)||($("#Specimen").combobox('getValue')=="")){var Specimen="";}
		if(Specimen==""){
			$.messager.alert("��ʾ","ǰ�����Ҳ���Ϊ��","info");
			return false;
		}
	}
	
    var Parref=selectrow;
  	if (Parref==Specimen){
		$.messager.alert("��ʾ","��ǰ���Һ��������Ҳ�����ͬ","info");
		return false;
	}
    var Str=Parref+"^"+Specimen;
    //alert(Str)
    
    //var LocID=$("#LocList").combobox('getValue');
	//var UserID=session['LOGON.USERID'];
    
	var rtn=tkMakeServerCall("web.DHCPE.CT.RoomManager","UpdateSpecimen",ID,Str,RoomType);
	//debugger; // rtn
	if (rtn.split("^")[0]=="-1"){
		if(Type=="1"){$.messager.alert('��ʾ',"����ʧ��:"+rtn.split("^")[1],"error");}
		if(Type=="0"){$.messager.alert('��ʾ',"����ʧ��:"+rtn.split("^")[1],"error");}
		
	}else{
		if(Type=="1"){$.messager.alert('��ʾ',"���³ɹ�","success");}
		if(Type=="0"){$.messager.alert('��ʾ',"�����ɹ�","success");}
		BClear_click();
		
	}

}

var columns =[[
			{field:'TID',title:'ID',hidden: true},
		    {field:'TSpecimenDR',title:'SpecimenDR',hidden: true},
			{field:'TSpecimen',width:640,title:title},
						 
		]];
		
function InitRoomSpecimenGrid(){
	
	$HUI.datagrid("#RoomSpecimenGrid",{
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
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.CT.RoomManager",
			QueryName:"FindRoomSpecimen",
			Parref:selectrow, 
			Type:RoomType,
			LocID:DefLoc
		    
		},
		columns:columns,
		onSelect: function (rowIndex, rowData) {
			 
				$("#RowId").val(rowData.TID);
				if(RoomType=="IP"){
					
				$("#IP").val(rowData.TSpecimenDR);
				}
				else
				{
				$("#Specimen").combobox('setValue',rowData.TSpecimenDR);
				}
								
		}
		
			
	})
}


function InitCombobox(){
   
	if(RoomType=="SP"){
		//�걾����
		var SpecimenObj = $HUI.combobox("#Specimen",{
			url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=GetSpecimen&ResultSetType=array&LocID="+DefLoc,
			valueField:'id',
			textField:'desc'
			})
	}else if(RoomType=="RP"){
		//����λ��
		//debugger; //	
		//alert(DefLoc)
		
		var SpecimenObj = $HUI.combobox("#Specimen",{
			url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=GetRoomPlace&ResultSetType=array&LocID="+DefLoc,
			valueField:'id',
			textField:'desc'
			})
	}else if(RoomType=="SR"){
		//ǰ������
		var SpecimenObj = $HUI.combobox("#Specimen",{
			url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=GetRoom&ResultSetType=array",
			valueField:'id',
			textField:'desc'
			})
	}
			
}