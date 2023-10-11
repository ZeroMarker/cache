//����	dhcpe/ct/dhcperoomitem.hisui.js
//����	������Ŀά��
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
var RoomItemtableName = "DHC_PE_RoomItem";  /// ����������Ŀ�ֵ��

var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']

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
	
	$.messager.confirm("ȷ��", "ȷ��Ҫɾ����", function(r){
    	if(r){ 
    		
			var rtn=tkMakeServerCall("web.DHCPE.CT.RoomManager","DeleteSpecimen",ID,RoomType);
			if (rtn.split("^")[0]=="-1"){
				$.messager.alert('��ʾ',"ɾ��ʧ��"+rtn.split("^")[1],"error");
			}else{
				$.messager.popover({msg: 'ɾ���ɹ�',type:'success',timeout: 1000});
				BClear_click();
			}
          }
	})
}

//����
function BClear_click(){
		$("#RowId,#IP,#ItemTime").val("");
		$("#ItemDesc").combogrid('setValue',"");
		$("#RoomItemGrid").datagrid('load',{
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
	debugger; //2
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
	}else if(RoomType=="RI")
	{
		TableName=RoomItemtableName;
		var Item=$("#ItemDesc").combobox('getValue');
  		if (($("#ItemDesc").combobox('getValue')==undefined)||($("#ItemDesc").combobox('getValue')=="")){var Item="";}
		if(Item==""){
			$.messager.alert("��ʾ","������Ŀ����Ϊ��","info");
			return false;
		}
	}
	
    var Parref=selectrow;
  	var Time=$("#ItemTime").val();
    var Str=Parref+"^"+Item+"^"+Time;
   
    
	var rtn=tkMakeServerCall("web.DHCPE.CT.RoomManager","UpdateSpecimen",ID,Str,RoomType);
	
	if (rtn.split("^")[0]=="-1"){
		if(Type=="1"){$.messager.alert('��ʾ',"����ʧ��:"+rtn.split("^")[1],"error");}
		if(Type=="0"){$.messager.alert('��ʾ',"����ʧ��:"+rtn.split("^")[1],"error");}
		
	}else{
		if(Type=="1"){$.messager.popover({msg: '���³ɹ�',type:'success',timeout: 1000});}
		if(Type=="0"){$.messager.popover({msg: '�����ɹ�',type:'success',timeout: 1000});}
		BClear_click();
		
	}

}

var columns =[[
			{field:'TID',title:'ID',hidden: true},
		    {field:'TSpecimenDR',title:'SpecimenDR',hidden: true},
			{field:'TSpecimen',width:300,title:title},
			{field:'TExInfo',width:100,title:"ʱ��"},
						 
		]];
		
function InitRoomSpecimenGrid(){
	
	$HUI.datagrid("#RoomItemGrid",{
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
				else if(RoomType=="RI"){
					
					$("#ItemDesc").combogrid('setValue',rowData.TSpecimenDR);
					$("#Specimen").combogrid('setText',rowData.TSpecimen);
					$("#ItemTime").val(rowData.TExInfo);
					}
				else
				{
				$("#Specimen").combobox('setValue',rowData.TSpecimenDR);
				}
								
		}
		
			
	})
}


function InitCombobox(){
   
   
    var LocID=session['LOGON.CTLOCID']
	
	var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);
	 
	 
	//ҽ������
	var ArcItemObj = $HUI.combogrid("#ItemDesc",{
		panelWidth:500,
		url:$URL+"?ClassName=web.DHCPE.CT.StationOrder&QueryName=FindLocAllOrder",
		mode:'remote',
		delay:200,
		pagination : true, 
		pageSize: 20,
		pageList : [20,50,100],
		idField:'TARCIMDR',
		textField:'TARCIMDesc',
		onBeforeLoad:function(param){
	  			
				param.ARCIMDesc= param.q;
				param.Type="B";
				param.LocID=LocID;
				param.hospId =hospId;
				param.tableName="DHC_PE_StationOrder"

		},
		columns:[[
		    {field:'TOrderID',title:'OrderID',hidden: true},
		    {field:'TARCIMDR',title:'ID',width:100},
			{field:'TARCIMDesc',title:'ҽ������',width:200},
			{field:'TARCIMCode',title:'ҽ������',width:150},
			
				
		]]
	});
   
	
			
}