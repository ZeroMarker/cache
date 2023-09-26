
//名称	DHCPEConclusion.hisui.js
//功能	职业病结论分类
//创建	2019.05.06
//创建人  xy

$(function(){
		
	InitCombobox();
	
	InitConclusionDataGrid();
      
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
		$.messager.alert("提示","结论分类不能为空","info");
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
	var Severity=$("#Severity").val();
	var re = /^[0-9]+[0-9]*]*$/;
	if(Severity!=""){
		if (!re.test(Severity))
	 	{
		 	$("#Severity").focus();
		 	$.messager.alert("提示","严重程度请输入相应数字","info");
			return false;
		}
	}
	
	var ID=$("#ID").val();
	var iActive="N";
	var Active=$("#Active").checkbox('getValue');
	if(Active) iActive="Y";
	var Str=Code+"^"+Desc+"^"+iActive+"^"+PEType+"^"+ExpInfo+"^"+Severity+"^"+Remark;
	//alert(Str)
	var rtn=tkMakeServerCall("web.DHCPE.Conclusion","UpdateConclusion",ID,Str);
	var Arr=rtn.split("^");
	if (Arr[0]>0){
		if(Type=="1"){$.messager.alert("提示","修改成功","success");}
		if(Type=="0"){$.messager.alert("提示","新增成功","success");}
		BClear_click();		
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
	
	var flag=tkMakeServerCall("web.DHCPE.Conclusion","IsUseConclusion",RowId);
	if(flag=="1"){
		var str="该结论分类在目标疾病中已使用, "
	}else{
		var str=""
	}
	
	$.messager.confirm("确认", "确定要删除该记录吗？", function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.Conclusion", MethodName:"DeleteConclusion",ID:RowId},function(rtn){
				if (rtn.split("^")[0]=="-1") {
					$.messager.alert("提示","删除失败:"+rtn.split("^")[1],"error");  
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
	$("#ID,#Code,#Desc,#ExpInfo,#Severity,#Remark").val("");
	$("#VIPLevel").combobox('setValue',"")
	$(".hisui-checkbox").checkbox('setValue',false);
	var valbox = $HUI.validatebox("#Code,#Desc", {
			required: false,
	   	});
	var valbox = $HUI.combobox("#VIPLevel", {
			required: false,
	   	});
	$("#ConclusionQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.Conclusion",
			QueryName:"FindConclusion",
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

function InitConclusionDataGrid()
{
	$HUI.datagrid("#ConclusionQueryTab",{
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
			ClassName:"web.DHCPE.Conclusion",
			QueryName:"FindConclusion",
		},
		columns:[[
	
		    {field:'TRowId',title:'TRowId',hidden: true},
			{field:'TCode',width:'150',title:'代码'},
			{field:'TDesc',width:'200',title:'结论分类'},
			{field:'TVIPLevelDR',title:'TVIPLevelDR',hidden: true},
			{field:'TVIPLevel',width:'150',title:'VIP等级'},
			{field:'TSeverity',width:'150',title:'严重程度'},
			{field:'TActive',width:'150',title:'激活'},
			{field:'TExpInfo',width:'250',title:'扩展信息'},
			{field:'TRemark',width:'150',title:'备注'},
			
		
		]],
		onSelect: function (rowIndex, rowData) {
			   
				$("#ID").val(rowData.TRowId);
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


