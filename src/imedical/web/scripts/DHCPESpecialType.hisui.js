
//名称	DHCPESpecialType.hisui.js
//功能	体检特殊客户管理	
//创建	2021.07.27
//创建人  xy
$(function(){

	InitSpecialTypeGrid();
	
	//修改
	$("#BUpdate").click(function() {	
		BUpdate_click();		
        });
        
     //新增
	$("#BAdd").click(function() {	
		BAdd_click();		
        });
        
    //清屏
	$("#BClear").click(function() {	
		BClear_click();		
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

//更新
function BSave_click(Type)
{
	
	var Code=$("#Code").val();
	var Desc=$("#Desc").val();
	if(Type=="1"){
		var ID=$("#ID").val();
		if(ID==""){
			$.messager.alert("提示","请选择待修改的记录","info");
			return false;
		}
	}
	if(Type=="0"){
		
		if($("#ID").val()!=""){
			$.messager.alert("提示","新增数据不能选中记录,请先清屏再新增","info");
			return false;
		}
		var ID="";
	}

	var iActiveFlag="N";
	var ActiveFlag=$("#ActiveFlag").checkbox('getValue');
	if(ActiveFlag) iActiveFlag="Y";
   
    if (""==Code) {
	    
		$("#Code").focus();
		var valbox = $HUI.validatebox("#Code", {
			required: true,
	  });
		$.messager.alert("错误提示","编码不能为空","error");
		return false;
	 }
	 
      if (""==Desc) {
		$("#Desc").focus();
		var valbox = $HUI.validatebox("#Desc", {
			required: true,
	   });
	   
		$.messager.alert("错误提示","描述不能为空","error");
		return false;
	 }


	var SaveInfo=Code+"^"+Desc+"^"+iActiveFlag;
	//alert(SaveInfo)
	//alert(ID)
	var Ret=tkMakeServerCall("web.DHCPE.SpecialType","SaveSPType",ID,SaveInfo);
	var Arr=Ret.split("^");
	if (Arr[0]>0){
		if(Type=="1"){$.messager.alert("提示","修改成功","success");}
		if(Type=="0"){$.messager.alert("提示","新增成功","success");}
		BClear_click();
	   $("#SpecialTypeGrid").datagrid('reload');
	}else{
		$.messager.alert("提示",Arr[1],"error");
		
	} 
	

}

//清屏
function BClear_click()
{
	$("#Code,#Desc,#ID").val("");
	$(".hisui-checkbox").checkbox('setValue',true);
	
	var valbox = $HUI.validatebox("#Code,#Desc", {
		required: false,
	  });
	 $("#SpecialTypeGrid").datagrid('reload');
	
}

function InitSpecialTypeGrid(){
	
		$HUI.datagrid("#SpecialTypeGrid",{
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
			ClassName:"web.DHCPE.SpecialType",
			QueryName:"SearchSPType",

		},
		columns:[[
		    {field:'ID',title:'ID',hidden: true},
			{field:'Code',width:'200',title:'编码'},
			{field:'Desc',width:'250',title:'描述'},
			{field:'ActiveFlag',width:'50',title:'激活'}
					
		]],
		onSelect: function (rowIndex, rowData) {
				var Code=$("#Code").val(rowData.Code);
				var Desc=$("#Desc").val(rowData.Desc);
				var ID=$("#ID").val(rowData.ID);
				
				if(rowData.ActiveFlag=="否"){
					$("#ActiveFlag").checkbox('setValue',false);
				}if(rowData.ActiveFlag=="是"){
					$("#ActiveFlag").checkbox('setValue',true);
				}


		}
			
	})

		
}
