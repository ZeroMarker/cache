
//名称	DHCPEQMType.hisui.js
//功能	质量管理错误类型	
//创建	2019.04.28
//创建人  xy

$(function(){
	

	InitQMTypeDataGrid();
	
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
	var Remark=$("#Remark").val();
	var ExpStr=$("#ExpStr").val();
	if(Type=="1"){
		var ID=$("#ID").val();
		if(ID==""){
			$.messager.alert("提示","请选择待修改的记录","info");
			return false;
		}
	}
	if(Type=="0"){
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
		$.messager.alert("错误提示","代码不能为空","error");
		return false;
	 }
	 
      if (""==Desc) {
		$("#Desc").focus();
		var valbox = $HUI.validatebox("#Desc", {
			required: true,
	   });
	   
		$.messager.alert("错误提示","错误类型不能为空","error");
		return false;
	 }

	if (""==ExpStr) {
		$("#ExpStr").focus();
		var valbox = $HUI.validatebox("#ExpStr", {
			required: true,
	    });
		$.messager.alert("错误提示","扩展信息不能为空","error");
		return false;
	 }

	var SaveInfo=Code+"^"+Desc+"^"+Remark+"^"+ExpStr+"^"+iActiveFlag;
	var Ret=tkMakeServerCall("web.DHCPE.QualityManager","SaveQMType",ID,SaveInfo);
	var Arr=Ret.split("^");
	if (Arr[0]>0){
		if(Type=="1"){$.messager.alert("提示","修改成功","success");}
		if(Type=="0"){$.messager.alert("提示","新增成功","success");}
		BClear_click();
		$("#QMTypeQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.QualityManager",
			QueryName:"SearchQMType"
			});
	
	}else{
		$.messager.alert("提示",Arr[1],"error");
		
	} 

}

//清屏
function BClear_click()
{
	$("#Code,#Desc,#ExpStr,#Remark,#ID").val("");
	$(".hisui-checkbox").checkbox('setValue',false);
	
	var valbox = $HUI.validatebox("#Code,#Desc,#ExpStr", {
		required: false,
	  });
	
}


function InitQMTypeDataGrid(){
		$HUI.datagrid("#QMTypeQueryTab",{
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
			ClassName:"web.DHCPE.QualityManager",
			QueryName:"SearchQMType",
		
		},
		columns:[[
	
		    {field:'ID',title:'ID',hidden: true},
			{field:'Code',width:'200',title:'代码'},
			{field:'Desc',width:'250',title:'错误类型'},
			{field:'ActiveFlag',width:'50',title:'激活'},
			{field:'Remark',width:'350',title:'备注'},
			{field:'ExpStr',width:'350',title:'扩展信息'}
					
		]],
		onSelect: function (rowIndex, rowData) {
				var Code=$("#Code").val(rowData.Code);
				var Desc=$("#Desc").val(rowData.Desc);
				var Remark=$("#Remark").val(rowData.Remark);
				var ExpStr=$("#ExpStr").val(rowData.ExpStr);
				var ID=$("#ID").val(rowData.ID);
				
				if(rowData.ActiveFlag=="否"){
					$("#ActiveFlag").checkbox('setValue',false);
				}if(rowData.ActiveFlag=="是"){
					$("#ActiveFlag").checkbox('setValue',true);
				}


		}
			
	})

		
}

