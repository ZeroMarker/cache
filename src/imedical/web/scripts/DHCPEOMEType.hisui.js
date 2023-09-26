
//名称	DHCPEOMEType.hisui.js
//功能	职业病健康检查种类
//创建	2019.05.07
//创建人  xy

$(function(){
		
	InitCombobox();
	
	InitOMETypeDataGrid();
      
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
		$.messager.alert("提示","检查种类不能为空","info");
		return false;
	}
	var PEType=$("#VIPLevel").combobox('getValue');
	if (($("#VIPLevel").combobox('getValue')==undefined)||($("#VIPLevel").combobox('getValue')=="")){var PEType="";}
	if (""==PEType) {
		$("#VIPLevel").focus();
		var valbox = $HUI.combobox("#VIPLevel", {
			required: true,
	   	});
		$.messager.alert("提示","VIP等级不能为空","info");
		return false;
	}

	var ExpInfo=$("#ExpInfo").val();
	var Remark=$("#Remark").val();
	var ID=$("#ID").val();
	var iActive="N";
	var Active=$("#Active").checkbox('getValue');
	if(Active) iActive="Y";
	var Str=Code+"^"+Desc+"^"+iActive+"^"+PEType+"^"+ExpInfo+"^"+Remark;
	//alert(Str)
	if((Type=="1")&&(iActive=="N")){
		var flag=tkMakeServerCall("web.DHCPE.Endanger","IsUseredOMEType",Desc);
		if(flag=="1"){
			$.messager.alert("提示","该检查种类在危害因素检查项目中被使用","info");
			return false;
		}
		}

	var rtn=tkMakeServerCall("web.DHCPE.OMEType","UpdateOMEType",ID,Str);
	var Arr=rtn.split("^");
	if (Arr[0]>0){
		BClear_click();
		if(Type=="1"){$.messager.alert("提示","修改成功","success");}
		if(Type=="0"){$.messager.alert("提示","新增成功","success");}	
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
				$.m({ ClassName:"web.DHCPE.OMEType", MethodName:"OMETypeDelete",ID:RowId},function(ReturnValue){
					
				if (ReturnValue.split("^")[0]=="-1") {
					$.messager.alert("提示","删除失败"+rtn.split("^")[1],"error");
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
	$("#ID,#Code,#Desc,#ExpInfo,#Remark").val("");
	$("#VIPLevel").combobox('setValue',"")
	$(".hisui-checkbox").checkbox('setValue',false);
	var valbox = $HUI.validatebox("#Code,#Desc", {
			required: false,
	   	});
	var valbox = $HUI.combobox("#VIPLevel", {
			required: false,
	   	});
	$("#OMETypeQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.OMEType",
			QueryName:"SearchOMEType",
		});	
} 


function InitCombobox()
{
	 
		 //vip等级
	  var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindVIP&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		})
		
}

function InitOMETypeDataGrid()
{
	$HUI.datagrid("#OMETypeQueryTab",{
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
			ClassName:"web.DHCPE.OMEType",
			QueryName:"SearchOMEType",
		},
		columns:[[
	
		    {field:'TID',title:'TID',hidden: true},
			{field:'TCode',width:'150',title:'代码'},
			{field:'TDesc',width:'250',title:'检查种类'},
			{field:'TVIPLevelDR',title:'TVIPLevelDR',hidden: true},
			{field:'TVIPLevel',width:'150',title:'VIP等级'},
			{field:'TActive',width:'150',title:'激活'},
			{field:'TExpInfo',width:'300',title:'扩展信息'},
			{field:'TRemark',width:'200',title:'备注'},
			
		
		]],
		onSelect: function (rowIndex, rowData) {
			   
				$("#ID").val(rowData.TID);
				$("#Code").val(rowData.TCode);
				$("#Desc").val(rowData.TDesc);
				$("#Severity").val(rowData.TSeverity);
				$("#ExpInfo").val(rowData.TExpInfo);
				$("#Remark").val(rowData.TRemark);
				$("#VIPLevel").combobox('setValue',rowData.TVIPLevelDR);
				if(rowData.TActive=="否"){
					$("#Active").checkbox('setValue',false);
				}if(rowData.TActive=="是"){
					$("#Active").checkbox('setValue',true);
				}			
					
		}
		
			
	})

}


