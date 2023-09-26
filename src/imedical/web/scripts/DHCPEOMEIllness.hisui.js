
//名称	DHCPEOMEIllness.hisui.js
//功能	目标疾病维护
//创建	2019.05.07
//创建人  xy

$(function(){
		
	InitCombobox();
	
	InitOMEIllnessDataGrid();
      
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
	var Code=$("#Code").val();
	if (""==Code) {
		$("#Code").focus();
		var valbox = $HUI.validatebox("#Code", {
			required: true,
	   	});
		$.messager.alert("提示","编码不能为空","info");
		return false;
	}
	var Desc=$("#Desc").val();
	if (""==Desc) {
		$("#Desc").focus();
		var valbox = $HUI.validatebox("#Desc", {
			required: true,
	   	});
		$.messager.alert("提示","目标疾病不能为空","info");
		return false;
	}
	
    var Conclusion=$("#Conclusion").combogrid('getValue');
  
    if (($("#Conclusion").combogrid('getValue')==undefined)||($("#Conclusion").combogrid('getValue')=="")){var Conclusion="";}
    if (""==Conclusion) {
		$("#Conclusion").focus();
		var valbox = $HUI.combogrid("#Conclusion", {
			required: true,
	   	});
		$.messager.alert("提示","结论分类不能为空","info");
		return false;
	}
	var ExpInfo=$("#ExpInfo").val();
	var Remark=$("#Remark").val();
	var ID=$("#ID").val();
	var iActive="N";
	var Active=$("#Active").checkbox('getValue');
	if(Active) iActive="Y";
	
	var Str=Code+"^"+Desc+"^"+iActive+"^"+Conclusion+"^"+ExpInfo+"^"+Remark;
	var rtn=tkMakeServerCall("web.DHCPE.OMEIllness","UpdateOMEIllness",ID,Str);
	var Arr=rtn.split("^");
	if (Arr[0]>0){
		BClear_click();
		if(Type=="1"){$.messager.popover({msg: '修改成功！',type:'success',timeout: 1000});}
		if(Type=="0"){$.messager.popover({msg: '新增成功！',type:'success',timeout: 1000});}		
	}else{
		$.messager.alert("提示",Arr[1],"error");	
	} 	
	
	
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
	$.messager.confirm("确认", "确定要删除该记录吗？", function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.OMEIllness", MethodName:"OMEIllnessDelete",ID:RowId},function(ReturnValue){
				if (ReturnValue.split("^")[0]=='-1') {
					$.messager.alert("提示","删除失败","error");  
				}else{
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					BClear_click();

				}
			});	
		}
	});
	
		
}

//清屏
function BClear_click()
{
	$("#ID,#Code,#Desc,#ExpInfo,#Remark").val("");
	$(".hisui-checkbox").checkbox('setValue',false);
	$("#Conclusion").combogrid('setValue',"");
	var valbox = $HUI.validatebox("#Code,#Desc", {
			required: false,
	   	});
	 var valbox = $HUI.combogrid("#Conclusion", {
			required: false,
	   	});
	$("#OMEIllnessQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.OMEIllness",
			QueryName:"SearchOMEIllness",
		});	
} 



function InitCombobox()
{
	  //结论分类
	   var ConclusionObj = $HUI.combogrid("#Conclusion",{
		panelWidth:670,
		url:$URL+"?ClassName=web.DHCPE.OMEIllness&QueryName=ConclusionList",
		mode:'remote',
		delay:200,
		idField:'ID',
		textField:'C_Desc',
		onBeforeLoad:function(param){
			param.Desc = param.q;
		},
		columns:[[
		    {field:'ID',title:'ID',width:40},
		    {field:'C_Code',title:'编码',width:100},
			{field:'C_Desc',title:'描述',width:100},
			{field:'C_VIPLevel',title:'VIP等级',width:100},
			{field:'C_ExpInfo',title:'扩展信息',width:100},
			{field:'C_Severity',title:'严重程度',width:100},
			{field:'C_Remark',title:'备注',width:100},	
		]],
		onLoadSuccess:function(){
			$("#Conclusion").combogrid('setValue',"")
			
		},
		});
}

function InitOMEIllnessDataGrid()
{
	$HUI.datagrid("#OMEIllnessQueryTab",{
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
			ClassName:"web.DHCPE.OMEIllness",
			QueryName:"SearchOMEIllness",
		},
		columns:[[
	
		    {field:'TID',title:'TID',hidden: true},
		    {field:'TConclusionDR',title:'TConclusionDR',hidden: true},
			{field:'TCode',width:'150',title:'代码'},
			{field:'TDesc',width:'250',title:'目标疾病'},
			{field:'TConclusion',width:'280',title:'结论分类'},
			{field:'TActive',width:'150',title:'激活'},
			{field:'TExpInfo',width:'200',title:'扩展信息'},
			{field:'TRemark',width:'150',title:'备注'},
			
		
		]],
		onSelect: function (rowIndex, rowData) {
				$("#ID").val(rowData.TID);
				$("#Code").val(rowData.TCode);
				$("#Desc").val(rowData.TDesc);
				$("#ExpInfo").val(rowData.TExpInfo);
				$("#Remark").val(rowData.TRemark);
				$("#Conclusion").combogrid('setValue',rowData.TConclusionDR);
				if(rowData.TActive=="否"){
					$("#Active").checkbox('setValue',false);
				}if(rowData.TActive=="是"){
					$("#Active").checkbox('setValue',true);
				}			
					
		}
		
			
	})

}


