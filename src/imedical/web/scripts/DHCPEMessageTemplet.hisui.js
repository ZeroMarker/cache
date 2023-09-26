
//名称	DHCPEMessageTemplet.hisui.js
//功能	短信模板维护
//创建	2019.05.13
//创建人  xy

$(function(){
		
	InitCombobox();
	
	InitMessageTempletDataGrid();
   
    //查询
	$("#BFind").click(function() {	
		BFind_click();		
        });
      
    //清屏
	$("#BClear").click(function() {	
		BClear_click();		
        });
        
    //新增
    $('#add_btn').click(function(e){
    	AddData();
    });
    
    //修改
    $('#update_btn').click(function(){
    	UpdateData();
    });
    
    //删除
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
			title:'新增',
			modal:true,
			buttonAlign : 'center',
			
			buttons:[{
				text:'保存',
				id:'save_btn',
			   
				handler:function(){
					SaveForm("")
				}
			},
			{
				text:'关闭',
				handler:function(){
					myWin.close();
				}
			}]
		});
		$('#form-save').form("clear");
		//默认选中
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
			$.messager.alert('错误提示','短信类型不能为空!',"error");
			return;
		}
		
		var VIPLevel=$('#PDVIPLevel').combobox('getValue');
		if (($('#PDVIPLevel').combobox('getValue')==undefined)||($('#PDVIPLevel').combobox('getValue')=="")){var VIPLevel="";}
		if (VIPLevel=="")
		{
			var valbox = $HUI.combobox("#PDVIPLevel", {
				required: true,
	   		});
			$.messager.alert('错误提示','VIP等级不能为空!',"error");
			return;
		}
		var Templet=$.trim($('#PDTemplet').val());
		if (Templet=="")
		{
			var valbox = $HUI.validatebox("#PDTemplet", {
				required: true,
	   		});
			$.messager.alert('错误提示','短信内容不能为空!',"error");
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
		    $.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
		    $("#MessageTempletGrid").datagrid('load',{
			    ClassName:"web.DHCPE.MessageTemplet",
			    QueryName:"FindMessageTemplet",
			    Active:$("#Active").checkbox('getValue'),
			    }); 
			$('#myWin').dialog('close'); 
	    }else{
		    $.messager.alert('操作提示',"保存失败","error");
	    }
		
	}
	
function UpdateData()
{
	
	var ID=$("#ID").val();
	if(ID==""){
		$.messager.alert('操作提示',"请选择待修改的记录","info");
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
				title:'修改',
				modal:true,
				buttons:[{
					text:'保存',
					id:'save_btn',
					handler:function(){
						SaveForm(ID)
					}
				},{
					text:'关闭',
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
		$.messager.alert('操作提示',"请选择待删除的记录","info");
		return
	}
	$.messager.confirm("确认", "确定要删除该记录吗？", function(r){
		if (r){
			$.m({ ClassName:"web.DHCPE.MessageTemplet", MethodName:"Delete", itmjs:'',itmjsex:'',InString:ID },function(ReturnValue){
				if (ReturnValue!='0') {
					$.messager.alert("提示","删除失败","error");  
				}else{
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
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
 //查询
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


//删除
function BDelete_click()
{
	var RowId=$("#ID").val();
	if (RowId=="")
	{
		$.messager.alert("提示","请先选择待删除的记录","info");	
		return false;
	}
	var rtn=tkMakeServerCall("web.DHCPE.OMEType","OMETypeDelete",RowId);
	if (rtn.split("^")[0]=="-1"){
		$.messager.alert("提示","删除失败"+rtn.split("^")[1],"error");	
	}else{
		BClear_click();
		$.messager.alert("提示","删除成功","success");
	}
	
	
}

//清屏
function BClear_click()
{
	$("#ID,#Templet").val("");
	$("#VIPLevel").combobox('setValue',"");
	$("#Type").combobox('setValue',"");
	$(".hisui-checkbox").checkbox('setValue',false);
	
} 


function InitCombobox()
{
	 
		 //vip等级
	  var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindVIP&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		});
		
		//短信类型
	var TypeObj = $HUI.combobox("#Type",{
		valueField:'id',
		textField:'text',
		panelHeight:'130',
		data:[
            {id:'老年短信',text:'老年短信'},
            {id:'普通短信',text:'普通短信'},
            {id:'VIP短信',text:'VIP短信'},
            {id:'高危短信',text:'高危短信'}
        ]

		});
		
		//vip等级
	  var PDVIPObj = $HUI.combobox("#PDVIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindVIP&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		panelHeight:'130',
		});
		
		//短信类型
	var PDTypeObj = $HUI.combobox("#PDType",{
		valueField:'id',
		textField:'text',
		panelHeight:'130',
		data:[
            {id:'老年短信',text:'老年短信'},
            {id:'普通短信',text:'普通短信'},
            {id:'VIP短信',text:'VIP短信'},
            {id:'高危短信',text:'高危短信'}
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
			{field:'NMT_Type',width:'150',title:'短信类型'},
			{field:'NMT_Templet',width:'750',title:'短信内容'},
			{field:'NMT_Active',width:'50',title:'激活'},
			{field:'NMT_VIPLevel',width:'150',title:'VIP等级'},
			
			
		
		]],
		onSelect: function (rowIndex, rowData) {
			   
				$("#ID").val(rowData.ID);
				
					
		}
		
			
	})

}


