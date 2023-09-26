
//名称	DHCPEILLSAlias.hisui.js
//功能	疾病别名维护
//创建	2019.06.05
//创建人  xy

$(function(){
		
	$("#ILLSName").val(selectrowDesc);
	
	InitILLSAliasDataGrid();
      
    //新增
    $('#add_btn').click(function(e){
    	AddData();
    });
    
    //修改
    $('#update_btn').click(function(){
    	UpdateData();
    });
    
    //删除
    $('#del_btn ').click(function(){
    	DelData();
    });
     
})

//新增
function AddData(){
	Update("0");
}

//修改
function UpdateData(){
	Update("2");
}

//删除
function DelData(){
	Update("1");
}

function Update(Type){
	var ID=$("#AliasRowId").val();
    if((Type=="1")&&(ID=="")){
	     $.messager.alert('提示','请选择待删除的记录',"info");
	     return false;
    }
    if((Type=="2")&&(ID=="")){
	     $.messager.alert('提示','请选择待修改的记录',"info");
	     return false;
    }
    if(Type=="0"){var ID="";}
    var EDId=selectrow;
    var Alias=$("#Alias").val();
	if (Alias=="")
	{
		$.messager.alert('提示','别名不能为空',"info");
	     return false;
	}
	
	
	if(Type=="1"){
		 var DataStr=ID;	
	$.messager.confirm("确认", "确定要删除该记录吗？", function(r){
		if (r){
			$.m({ ClassName:"web.DHCPE.IllnessStandard", MethodName:"UpdateAlias",DataStr:DataStr,isDelete:Type},function(ReturnValue){
				if (ReturnValue!='0') {
					$.messager.alert("提示","删除失败","error");  
				}else{
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					$("#AliasRowId,#Alias").val("");
					$("#ILLSAliasGrid").datagrid('load',{
						ClassName:"web.DHCPE.IllnessStandard",
						QueryName:"FindIllAlias",
						ILLSRowID:selectrow, 
					});	
				}
				});
			
		 }
	 });
	}else{
		var DataStr=ID+"^"+EDId+"^"+Alias;
		var flag=tkMakeServerCall("web.DHCPE.IllnessStandard","UpdateAlias",DataStr,Type);
		if (flag==0)
		{
		if(Type=="2"){$.messager.alert('提示',"修改成功","success");}
		if(Type=="0"){$.messager.alert('提示',"新增成功","success");}
		$("#AliasRowId,#Alias").val("");
		$("#ILLSAliasGrid").datagrid('load',{
			ClassName:"web.DHCPE.IllnessStandard",
			QueryName:"FindIllAlias",
			ILLSRowID:selectrow, 
		});	
	}else{
		$.messager.alert('提示',"操作失败","error");
	}
		
	}

}

function InitILLSAliasDataGrid(){
	$HUI.datagrid("#ILLSAliasGrid",{
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
			ClassName:"web.DHCPE.IllnessStandard",
			QueryName:"FindIllAlias",
			ILLSRowID:selectrow, 
		    
		},
		columns:[[
		    {field:'id',title:'ID',hidden: true},
			{field:'desc',width:'730',title:'别名'},
		
		]],
		onSelect: function (rowIndex, rowData) {
			   
				$("#AliasRowId").val(rowData.id);
				$("#Alias").val(rowData.desc);
				
					
		}
		
			
	})
}