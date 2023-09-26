
//����	DHCPEMessageTemplet.hisui.js
//����	����ģ��ά��
//����	2019.05.13
//������  xy

$(function(){
		
	InitCombobox();
	
	InitMessageTempletDataGrid();
   
    //��ѯ
	$("#BFind").click(function() {	
		BFind_click();		
        });
      
    //����
	$("#BClear").click(function() {	
		BClear_click();		
        });
        
    //����
    $('#add_btn').click(function(e){
    	AddData();
    });
    
    //�޸�
    $('#update_btn').click(function(){
    	UpdateData();
    });
    
    //ɾ��
    $('#del_btn').click(function(e){
    	DelData();
    });
   
})

function AddData()
{
	$("#myWin").show();
	 
		var myWin = $HUI.dialog("#myWin",{
			iconCls:'icon-w-add',
			resizable:true,
			title:'����',
			modal:true,
			buttonAlign : 'center',
			
			buttons:[{
				text:'����',
				id:'save_btn',
			   
				handler:function(){
					SaveForm("")
				}
			},
			{
				text:'�ر�',
				handler:function(){
					myWin.close();
				}
			}]
		});
		$('#form-save').form("clear");
		//Ĭ��ѡ��
		$HUI.checkbox("#PDActive").setValue(true);	
	
}

SaveForm=function(id)
	{
		//alert(flag)
	   
		var Type=$('#PDType').combobox('getValue');	
		if (($('#PDType').combobox('getValue')==undefined)||($('#PDType').combobox('getValue')=="")){var Type="";}
		if (Type=="")
		{
			var valbox = $HUI.combobox("#PDType", {
				required: true,
	   		});
			$.messager.alert('������ʾ','�������Ͳ���Ϊ��!',"error");
			return;
		}
		
		var VIPLevel=$('#PDVIPLevel').combobox('getValue');
		if (($('#PDVIPLevel').combobox('getValue')==undefined)||($('#PDVIPLevel').combobox('getValue')=="")){var VIPLevel="";}
		if (VIPLevel=="")
		{
			var valbox = $HUI.combobox("#PDVIPLevel", {
				required: true,
	   		});
			$.messager.alert('������ʾ','VIP�ȼ�����Ϊ��!',"error");
			return;
		}
		var Templet=$.trim($('#PDTemplet').val());
		if (Templet=="")
		{
			var valbox = $HUI.validatebox("#PDTemplet", {
				required: true,
	   		});
			$.messager.alert('������ʾ','�������ݲ���Ϊ��!',"error");
			return;
		}
		var iPDActive="0";
		 var PDActive=$("#PDActive").checkbox('getValue');
	    if(PDActive) {iPDActive="1";}
		
	   if(id==""){
			var Instring=Type+"^"+Templet+"^"+iPDActive+"^"+"0"+"^"+VIPLevel;
			var flag=tkMakeServerCall("web.DHCPE.MessageTemplet","Add",'','',Instring);
	   }else{
		   var Instring=id+"^"+Type+"^"+Templet+"^"+iPDActive+"^"+"0"+"^"+VIPLevel;
		   
		   var flag=tkMakeServerCall("web.DHCPE.MessageTemplet","Update",'','',Instring);
		   
	   }
	    if(flag==0){
		    $.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
		    $("#MessageTempletGrid").datagrid('load',{
			    ClassName:"web.DHCPE.MessageTemplet",
			    QueryName:"FindMessageTemplet",
			    Active:$("#Active").checkbox('getValue'),
			    }); 
			$('#myWin').dialog('close'); 
	    }else{
		    $.messager.alert('������ʾ',"����ʧ��","error");
	    }
		
	}
	
function UpdateData()
{
	
	var ID=$("#ID").val();
	if(ID==""){
		$.messager.alert('������ʾ',"��ѡ����޸ĵļ�¼","info");
		return
	}
	if(ID!="")
	{	
	      var MessageInfoStr=tkMakeServerCall("web.DHCPE.MessageTemplet","GetMessageTempletByID",ID);
		   var MessageInfo=MessageInfoStr.split("^");
		   $('#PDType').combobox('setValue',MessageInfo[0]);
		   $('#PDVIPLevel').combobox('setValue',MessageInfo[4]);
		   $('#PDTemplet').val(MessageInfo[2]);
		   if(MessageInfo[1]=="1"){
			    $("#PDActive").checkbox('setValue',true);
		   }else{
			   $("#PDActive").checkbox('setValue',false);
		   }
			$("#myWin").show();
			
			var myWin = $HUI.dialog("#myWin",{
				iconCls:'icon-w-edit',
				resizable:true,
				title:'�޸�',
				modal:true,
				buttons:[{
					text:'����',
					id:'save_btn',
					handler:function(){
						SaveForm(ID)
					}
				},{
					text:'�ر�',
					handler:function(){
						myWin.close();
					}
				}]
			});							
	}
}

function DelData()
{
	
	var ID=$("#ID").val();
	if(ID==""){
		$.messager.alert('������ʾ',"��ѡ���ɾ���ļ�¼","info");
		return
	}
	$.messager.confirm("ȷ��", "ȷ��Ҫɾ���ü�¼��", function(r){
		if (r){
			$.m({ ClassName:"web.DHCPE.MessageTemplet", MethodName:"Delete", itmjs:'',itmjsex:'',InString:ID },function(ReturnValue){
				if (ReturnValue!='0') {
					$.messager.alert("��ʾ","ɾ��ʧ��","error");  
				}else{
					$.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
					$("#ID").val(""); 
					
					$("#MessageTempletGrid").datagrid('load',{
						ClassName:"web.DHCPE.MessageTemplet",
						QueryName:"FindMessageTemplet",
		   				 Active:$("#Active").checkbox('getValue'),
					}); 
	
			        $('#myWin').dialog('close'); 
				}
			});	
		}
	});
}
 //��ѯ
function BFind_click()
{
	if (($("#VIPLevel").combobox('getValue')==undefined)||($("#VIPLevel").combobox('getValue')=="")){var  VIPLevel="";}
	else{var VIPLevel=$("#VIPLevel").combobox('getValue');}
	
	if (($("#Type").combobox('getValue')==undefined)||($("#Type").combobox('getValue')=="")){var  Type="";}
	else{var Type=$("#Type").combobox('getValue');}
	
	$("#MessageTempletGrid").datagrid('load',{
			ClassName:"web.DHCPE.MessageTemplet",
			QueryName:"FindMessageTemplet",
			Type:Type,
		    VIPLevel:VIPLevel,
			Templet:$.trim($("#Templet").val()),
		    Active:$("#Active").checkbox('getValue'),
		});	
}


//ɾ��
function BDelete_click()
{
	var RowId=$("#ID").val();
	if (RowId=="")
	{
		$.messager.alert("��ʾ","����ѡ���ɾ���ļ�¼","info");	
		return false;
	}
	var rtn=tkMakeServerCall("web.DHCPE.OMEType","OMETypeDelete",RowId);
	if (rtn.split("^")[0]=="-1"){
		$.messager.alert("��ʾ","ɾ��ʧ��"+rtn.split("^")[1],"error");	
	}else{
		BClear_click();
		$.messager.alert("��ʾ","ɾ���ɹ�","success");
	}
	
	
}

//����
function BClear_click()
{
	$("#ID,#Templet").val("");
	$("#VIPLevel").combobox('setValue',"");
	$("#Type").combobox('setValue',"");
	$(".hisui-checkbox").checkbox('setValue',false);
	
} 


function InitCombobox()
{
	 
		 //vip�ȼ�
	  var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindVIP&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		});
		
		//��������
	var TypeObj = $HUI.combobox("#Type",{
		valueField:'id',
		textField:'text',
		panelHeight:'130',
		data:[
            {id:'�������',text:'�������'},
            {id:'��ͨ����',text:'��ͨ����'},
            {id:'VIP����',text:'VIP����'},
            {id:'��Σ����',text:'��Σ����'}
        ]

		});
		
		//vip�ȼ�
	  var PDVIPObj = $HUI.combobox("#PDVIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindVIP&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		panelHeight:'130',
		});
		
		//��������
	var PDTypeObj = $HUI.combobox("#PDType",{
		valueField:'id',
		textField:'text',
		panelHeight:'130',
		data:[
            {id:'�������',text:'�������'},
            {id:'��ͨ����',text:'��ͨ����'},
            {id:'VIP����',text:'VIP����'},
            {id:'��Σ����',text:'��Σ����'}
        ]

		});
		
		
}

function InitMessageTempletDataGrid()
{
	if (($("#VIPLevel").combobox('getValue')==undefined)||($("#VIPLevel").combobox('getValue')=="")){var  VIPLevel="";}
	else{var VIPLevel=$("#VIPLevel").combobox('getValue');}
	
	if (($("#Type").combobox('getValue')==undefined)||($("#Type").combobox('getValue')=="")){var  Type="";}
	else{var Type=$("#Type").combobox('getValue');}
	
	$HUI.datagrid("#MessageTempletGrid",{
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
			ClassName:"web.DHCPE.MessageTemplet",
			QueryName:"FindMessageTemplet",
			Type:Type,
		    VIPLevel:VIPLevel,
			Templet:$.trim($("#Templet").val()),
		    Active:$("#Active").checkbox('getValue'),
		},
		columns:[[
	
		    {field:'ID',title:'ID',hidden: true},
			{field:'NMT_Type',width:'150',title:'��������'},
			{field:'NMT_Templet',width:'750',title:'��������'},
			{field:'NMT_Active',width:'50',title:'����'},
			{field:'NMT_VIPLevel',width:'150',title:'VIP�ȼ�'},
			
			
		
		]],
		onSelect: function (rowIndex, rowData) {
			   
				$("#ID").val(rowData.ID);
				
					
		}
		
			
	})

}


