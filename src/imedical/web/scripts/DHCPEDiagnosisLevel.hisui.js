
//名称	DHCPEDiagnosisLevel.hisui.js
//功能	建议级别维护	
//创建	2019.05.17
//创建人  xy

$(function(){
	

	InitDiagnosisLevelDataGrid();
	
	
     //新增
	$("#BAdd").click(function() {	
		BAdd_click();		
        });
        
    //修改
	$("#BUpdate").click(function() {	
		BUpdate_click();		
        });
     
     //删除
	$("#BDelete").click(function() {	
		BDelete_click();		
        });
        
    //清屏
	$("#BClear").click(function() {	
		BClear_click();		
        });
    
	  info();
})

function info()
{
	
	var ID=$("#ID").val()
	if(ID==""){
		$("#BAdd").linkbutton('enable');
		$("#BUpdate").linkbutton('disable');
		$("#BDelete").linkbutton('disable');
	}else{
		$("#BAdd").linkbutton('disable');
		$("#BUpdate").linkbutton('enable');
		$("#BDelete").linkbutton('enable');
	}
	
}



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
	var ID=$("#ID").val();
	
	if(Type=="1"){
		if(ID==""){
			$.messager.alert("提示","请选择待修改的记录","info");
			return false;
		}
	}
	if(Type=="0"){
		if(ID!=""){
			$.messager.alert("提示","新增数据不能选中记录,需先清屏再新增","info");
			return false;
		}
	}
	
	var iLevel=$.trim($("#Level").val());
	if (""==iLevel) {
	    
		$.messager.alert("提示","级别不能为空","info",function(){
		var valbox = $HUI.validatebox("#Level", {
			required: true,
	   	});
			$("#Level").focus();
		});
		return false;

	 }
	 
	var iDesc=$.trim($("#Desc").val());
     if (""==iDesc) {
		$.messager.alert("提示","描述不能为空","info",function(){
			var valbox = $HUI.validatebox("#Desc", {
			required: true,
	   	});
			$("#Desc").focus();
		});
		return false;

	 }

	var iWarnFlag="N"

    if(Type==0){
		var Instring=iLevel+"^"+iDesc+"^"+iWarnFlag;
		var flag=tkMakeServerCall("web.DHCPE.DiagnosisLevel","Insert",'','',Instring);
    }else{
	    var Instring=ID+"^"+iLevel+"^"+iDesc+"^"+iWarnFlag;
		var flag=tkMakeServerCall("web.DHCPE.DiagnosisLevel","Update",'','',Instring);
    }
	   var flag=flag.split("^")
	if (flag[0]==0){
		if(Type=="1"){$.messager.alert("提示","修改成功","success");}
		if(Type=="0"){$.messager.alert("提示","新增成功","success");}
		BClear_click(); 
	
	}else if (flag[0]=="-1"){
		$.messager.alert("提示",flag[1],"info");
	
	}else{
		if(Type=="0"){$.messager.alert("提示","修改错误","error");}
		if(Type=="1"){$.messager.alert("提示","新增错误","error");}
			
	} 


}

function BDelete_click()
{
	var ID=$("#ID").val();
	if(ID==""){
			$.messager.alert("提示","请选择待删除的记录","info");
			return false;
	}
	
	$.messager.confirm("确认", "确定要删除该记录吗？", function(r){
		if (r){
				$.m({ ClassName:"web.DHCPE.DiagnosisLevel", MethodName:"Delete",InString:ID},function(ReturnValue){
				if (ReturnValue!="0") {
					if(ReturnValue.indexOf("^")>0){
						$.messager.alert("提示","删除失败:"+ReturnValue.split("^")[1],"error"); 
					} else{
						$.messager.alert("提示","删除失败","error"); 
					}
 
				}else{
					$.messager.alert("提示","删除成功","success");
					BClear_click();	
				}
				});
		}
	});
	
	
}

//清屏
function BClear_click()
{
	$("#Level,#Desc,#ID").val("");
	var valbox = $HUI.validatebox("#Level,#Desc", {
		required: false,
	  });
	  $("#DiagnosisLevelQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.DiagnosisLevel",
			QueryName:"LevelAll",
		
			});
	info();
	
}


function InitDiagnosisLevelDataGrid(){
		$HUI.datagrid("#DiagnosisLevelQueryTab",{
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
			ClassName:"web.DHCPE.DiagnosisLevel",
			QueryName:"LevelAll",
		
		},
		columns:[[
		    {field:'TRowID',title:'ID',hidden: true},
			{field:'TLevel',width:'400',title:'级别'},
			{field:'TDesc',width:'760',title:'描述'},
			
					
		]],
		onSelect: function (rowIndex, rowData) {
				$("#ID").val(rowData.TRowID);
				$("#Level").val(rowData.TLevel);
				$("#Desc").val(rowData.TDesc);
				$("#BAdd").linkbutton('disable');
				$("#BUpdate").linkbutton('enable');
				$("#BDelete").linkbutton('enable');


		}
			
	})

		
}

