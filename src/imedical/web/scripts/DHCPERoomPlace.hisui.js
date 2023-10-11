
//����	DHCPERoomPlace.hisui.js
//����	����λ��ά��
//����	2019.07.31
//������  xy
$(function(){
		
	InitCombobox();
	  
    InitRoomPlaceGrid();
    
         
     //����
	$("#BAdd").click(function() {	
		BAdd_click();		
        });  
    
      //�޸�
	$("#BUpdate").click(function() {	
		BUpdate_click();		
        });
        
    //����
	$("#BClear").click(function() {	
		BClear_click();		
        });
    
     
    
})

  //����
function BAdd_click(){
	BSave_click("0");
}

  //�޸�
function BUpdate_click(){
	BSave_click("1");
}
 
 function BSave_click(Type)
 {
	 var CurLoc=session['LOGON.CTLOCID'];
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
	
	var Code=$("#Code").val();
	if(Code==""){
		$("#Code").focus();
		var valbox = $HUI.validatebox("#Code", {
			required: true,
	    });
		$.messager.alert("��ʾ","���벻��Ϊ��","info");
		return false;
		
	}

	var Desc=$("#Desc").val();
	if(Desc==""){
		$("#Desc").focus();
		var valbox = $HUI.validatebox("#Desc", {
			required: true,
	    });
		$.messager.alert("��ʾ","��������Ϊ��","info");
		return false;
		
	}
if(Type=="0"){
    var flags=tkMakeServerCall("web.DHCPE.RoomManagerEx","IsExistRoomPlace",Code,Desc,CurLoc)
    if(flags.split("^")[0]=="1"){
	    $.messager.alert("��ʾ","���������ظ�","info");
		return false;
    }
    if(flags.split("^")[1]=="1"){
	    $.messager.alert("��ʾ","���벻���ظ�","info");
		return false;
    }
    
  }

	var PEType=$("#VIPLevel").combobox('getValue');
	var GIType=$("#GIType").combobox('getValue');
	var Str=Code+"^"+Desc+"^"+PEType+"^"+GIType;
	
	var iNoPrintBlood=0;
	var NoPrintBlood=$("#NoPrintBlood").checkbox('getValue');
	if(NoPrintBlood){iNoPrintBlood="1";}
	
	
    var rtn=tkMakeServerCall("web.DHCPE.RoomManagerEx","SaveRoomPlace",ID,Str,iNoPrintBlood);
	if (rtn.split("^")[0]=="-1"){
		if(Type=="1"){$.messager.alert("��ʾ","�޸�ʧ��"+Arr[1],"error");}
		if(Type=="0"){$.messager.alert("��ʾ","����ʧ��"+Arr[1],"error");}	
	}else{
		BClear_click();
		if(Type=="1"){$.messager.alert("��ʾ","�޸ĳɹ�","success");}
		if(Type=="0"){$.messager.alert("��ʾ","�����ɹ�","success");}	
	}
 }
 
 
 //����
function BClear_click(){
	$("#RowId,#Code,#Desc").val("");
	$(".hisui-checkbox").checkbox('setValue',false);
	$(".hisui-combobox").combobox('setValue','');
	var valbox = $HUI.validatebox("#Code,#Desc", {
			required: false,
	    });
	$("#RoomPlaceGrid").datagrid('load',{
			ClassName:"web.DHCPE.RoomManagerEx",
			QueryName:"RoomPlace",
		});	
}

function InitCombobox(){
	
	
	//VIP�ȼ�	
	var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindVIP&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		});
		
	//�Ƿ�����
	var DietObj = $HUI.combobox("#GIType",{
		valueField:'id',
		textField:'text',
		panelHeight:'100',
		data:[
            {id:'N',text:'����'},
            {id:'I',text:'����'},
            {id:'G',text:'����'},
           
        ]

	});
}


function InitRoomPlaceGrid(){
	$HUI.datagrid("#RoomPlaceGrid",{
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
			ClassName:"web.DHCPE.RoomManagerEx",
			QueryName:"RoomPlace",
		},
		columns:[[
		    {field:'TID',title:'ID',hidden: true},
			{field:'TCode',width:150,title:'����'},
			{field:'TDesc',width:300,title:'����'},
			{field:'TVIPLevelID',title:'ID',hidden: true},
			{field:'TVIPLevelDesc',width:100,title:'VIP�ȼ�'},
			{field:'TGIType',title:'TGIType',hidden: true},
			{field:'TGITypeDesc',width:80,title:'�Ƿ�����'},
			{field:'TNoPrintBlood',width:200,align:'center',title:'ǰ̨����ӡ��Ѫ����',
				formatter: function (value, rec, rowIndex) {
					
						if(value=="1"){
							return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
						}else{
							return '<input type="checkbox" value="" disabled/>';
						}
                        
                    },
			},
			
		]],
		onSelect: function (rowIndex, rowData) {
			   
				$("#RowId").val(rowData.TID);
				$("#Code").val(rowData.TCode);
				$("#Desc").val(rowData.TDesc);
				$("#VIPLevel").combobox('setValue',rowData.TVIPLevelID);
				$("#GIType").combobox('setValue',rowData.TGIType);
				if(rowData.TNoPrintBlood=="1"){
					$("#NoPrintBlood").checkbox('setValue',true);
				}else{
					$("#NoPrintBlood").checkbox('setValue',false);
				}			
						
			
								
					
		}

			
	})
}
