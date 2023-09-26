
//名称	DHCPEEDKey.hisui.js
//功能	建议关键词维护
//创建	2019.05.05
//创建人  xy

$(function(){
		
	
	InitEDKeyQueryTabDataGrid();
      
    //清屏
	$("#BClear").click(function() {	
		BClear_click();		
        });
    
     
	//修改
	$("#BUpdate").click(function() {	
		BUpdate_click();		
        });
        
     //新增
	$("#BAdd").click(function() {	
		BAdd_click();		
        }); 
          
    //删除
	$("#BDelete").click(function() {	
		BDelete_click();		
        });
})


//修改
function BUpdate_click()
{
	BSave_click("1");
}

 //新增
function BAdd_click()
{
	BSave_click("0");
}



 function BSave_click(Type)
 {	
 	if(Type=="1"){
		var ID=$("#ID").val();
		if(ID==""){
			$.messager.alert("提示","请选择待修改的记录","info");
			return false;
		}
	}
	if(Type=="0"){
		if($("#ID").val()!=""){
		    	$.messager.alert("提示","新增数据不能选中记录,请点击清屏后进行新增","info");
		    	return false;
		    }
		var ID="";
	}
	var ID=$("#ID").val();
	var Desc=$("#Desc").val();
	if (Desc==""){
		$("#Desc").focus();
		var valbox = $HUI.validatebox("#Desc", {
			required: true,
	   	});
		$.messager.alert("提示","请输入关键词","info");
		return false;
	}
	var Color=$("#Color").val();
	if (Color==""){
		$("#Color").focus();
		var valbox = $HUI.validatebox("#Color", {
			required: true,
	   	});
		$.messager.alert("提示","请输入颜色","info");
		return false;
	}
	//alert(ID+"^"+Desc+"^"+Color)
	var ret=tkMakeServerCall("web.DHCPE.EDKey","Update",ID,Desc,Color)
	if (ret=="0"){
	     BClear_click();
	    
		if(Type=="1"){$.messager.alert("提示","修改成功","success");}
		if(Type=="0"){$.messager.alert("提示","新增成功","success");}
		
	}
	else
	{
		$.messager.alert("提示","更新失败","error");
		
	}
 }

 //删除
function BDelete_click()
{

    var ID=$("#ID").val();
    if(ID==""){
	    $.messager.alert("提示","请选择待删除的记录","info");
	    return 
    }
    	$.messager.confirm("确认", "确定要删除该记录吗？", function(r){
		if (r){
				$.m({ ClassName:"web.DHCPE.EDKey", MethodName:"Delete",ID:ID},function(ReturnValue){
				if (ReturnValue!="0") {
					$.messager.alert("提示","删除失败","error");  
				}else{
					BClear_click();
					$.messager.alert("提示","删除成功","success");
				}
				});
		}
	});
	
   	
}


//清屏
function BClear_click()
{
	$("#Desc,#Color,#ID").val("");
	var valbox = $HUI.validatebox("#Desc,#Color", {
			required: false,
	   	});
	 $("#EDKeyQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.EDKey",
			QueryName:"SearchEDKey",
		});
}

function InitEDKeyQueryTabDataGrid()
{
	$HUI.datagrid("#EDKeyQueryTab",{
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
			ClassName:"web.DHCPE.EDKey",
			QueryName:"SearchEDKey",
		},
		columns:[[
	
		    {field:'TID',title:'TID',hidden: true},
			{field:'TDesc',width:'600',title:'关键词'},
			{field:'TColor',width:'600',title:'颜色'},
		
		]],
		onSelect: function (rowIndex, rowData) {
			    
			    $("#ID").val(rowData.TID);
				$("#Desc").val(rowData.TDesc);
				$("#Color").val(rowData.TColor);		
				
			
		}
			
	})

}


