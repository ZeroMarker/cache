//����	DHCPERoomSpecimen.hisui.js
//����	���ұ걾ά��
//����	2019.07.04
//������  xy


$(function(){
		
	
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
	
	var rtn=tkMakeServerCall("web.DHCPE.RoomManager","DeleteSpecimen",ID,RoomType);
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
			ClassName:"web.DHCPE.RoomManager",
			QueryName:"FindRoomSpecimen",
			Parref:selectrow, 
			Type:RoomType,
			LocID:session['LOGON.CTLOCID']
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
	
	if(Type=="0"){
	    if(ID!=""){
		    	$.messager.alert("��ʾ","�������ݲ���ѡ�м�¼,�����������������","info");
		    	return false;
		    }
	}
    if (RoomType=="IP"){
		var Specimen=$("#IP").val();
		if(Specimen==""){
			$.messager.alert("��ʾ","����IP����Ϊ��","info");
			return false;
		}
		
	}else if(RoomType=="SP")
	{
		var Specimen=$("#Specimen").combobox('getValue');
  		if (($("#Specimen").combobox('getValue')==undefined)||($("#Specimen").combobox('getValue')=="")){var Specimen="";}
		if(Specimen==""){
			$.messager.alert("��ʾ","�걾���Ͳ���Ϊ��","info");
			return false;
		}
	}else if(RoomType=="RP")
	{
		var Specimen=$("#Specimen").combobox('getValue');
  		if (($("#Specimen").combobox('getValue')==undefined)||($("#Specimen").combobox('getValue')=="")){var Specimen="";}
		if(Specimen==""){
			$.messager.alert("��ʾ","����λ�ò���Ϊ��","info");
			return false;
		}
	}else if(RoomType=="SR")
	{
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
	var rtn=tkMakeServerCall("web.DHCPE.RoomManager","UpdateSpecimen",ID,Str,RoomType);
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
			ClassName:"web.DHCPE.RoomManager",
			QueryName:"FindRoomSpecimen",
			Parref:selectrow, 
			Type:RoomType,
			LocID:session['LOGON.CTLOCID']	    
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
			url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=GetSpecimen&ResultSetType=array&LocID="+session['LOGON.CTLOCID'],
			valueField:'id',
			textField:'desc'
			})
	}else if(RoomType=="RP"){
		//����λ��
		var SpecimenObj = $HUI.combobox("#Specimen",{
			url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=GetRoomPlace&ResultSetType=array",
			valueField:'id',
			textField:'desc'
			})
	}else if(RoomType=="SR"){
		//ǰ������
		var SpecimenObj = $HUI.combobox("#Specimen",{
			url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=GetRoom&ResultSetType=array",
			valueField:'id',
			textField:'desc'
			})
	}
			
}