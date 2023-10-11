
//名称	DHCPEEDCheckCycle.hisui.js
//功能	危害因素检查周期维护
//创建	2019.06.17
//创建人  xy

$(function(){
	InitCombobox();
	
	InitEDCheckCycleGrid();
	    
    //修改
	$("#update_btn").click(function() {	
		BUpdate_click();		
        });
        
     //新增
	$("#add_btn").click(function() {	
		BAdd_click();		
        }); 
    
    //删除
	$("#del_btn").click(function() {	
		BDel_click();		
        });   
    
    
    //清屏
	$("#BClear").click(function() {	
		BClear_click();		
        });
     
 
   
})


 //修改
function BUpdate_click(){
	BSave_click("1");
}

//新增
function BAdd_click(){
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
	}
	var Code=$("#Code").val();
	
	if(Code==""){
		var valbox = $HUI.validatebox("#Code", {
			required: true,
	    });
		$.messager.alert("提示","编码不能为空","info");
		return false;
	}
	
	var Desc=$("#Desc").val();
	if(Desc==""){
		var valbox = $HUI.validatebox("#Desc", {
			required: true,
	    });
		$.messager.alert("提示","描述不能为空","info");
		return false;
	}
	
	var OMETypeDR=$("#OMEType").combogrid('getValue');
	if (($("#OMEType").combogrid('getValue')==undefined)||($("#OMEType").combogrid('getValue')=="")){var OMETypeDR="";}

	var ExpInfo=$("#ExpInfo").val();
	var Remark=$("#Remark").val();
	var ID=$("#ID").val();
	var Parref=$.trim(selectrow);
	var iActive="N";
	var Active=$("#Active").checkbox('getValue');
	if(Active) iActive="Y";
	var Str=Parref+"^"+Code+"^"+Desc+"^"+OMETypeDR+"^"+iActive+"^"+ExpInfo+"^"+Remark;
	//alert(Str)
	var rtn=tkMakeServerCall("web.DHCPE.Endanger","EDCheckCycleSave",ID,Str);
	var Arr=rtn.split("^");
	if (rtn.split("^")[0]=="-1"){
		$.messager.alert("提示","更新失败"+rtn.split("^")[1],"error");
		
	}else{
		BClear_click();
		if(Type=="1"){$.messager.popover({msg: '修改成功！',type:'success',timeout: 1000});}
		if(Type=="0"){$.messager.popover({msg: '新增成功！',type:'success',timeout: 1000});}
		
	}
	
	
	
}

//删除
//删除
function BDel_click(){
	var ID=$("#ID").val();
	if (ID=="")
	{
		$.messager.alert("提示","请选择待删除的记录","info");
		return false;
	}
	$.messager.confirm("确认", "确定要删除该记录吗？", function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.Endanger", MethodName:"EDCheckCycleDelete",ID:ID},function(ReturnValue){
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

function BClear_click(){
	$("#ID,#Code,#Desc,#ExpInfo,#Remark").val("");
	$("#Active").checkbox('setValue',true);
	$(".hisui-combogrid").combogrid('setValue',"");

	var valbox = $HUI.validatebox("#Code,#Desc", {
			required: false,
	    });
	$("#EDCheckCycleGrid").datagrid('load',{
			ClassName:"web.DHCPE.Endanger",
			QueryName:"SearchEDCheckCycle",
			Parref:$.trim(selectrow),
		});	
}


function InitCombobox(){
	
		
		//检查种类
	   var OMETypeObj = $HUI.combogrid("#OMEType",{
		panelWidth:400,
		url:$URL+"?ClassName=web.DHCPE.Endanger&QueryName=OMETypeList",
		mode:'remote',
		delay:200,
		idField:'ID',
		textField:'OMET_Desc',
		onBeforeLoad:function(param){
			param.Desc = param.q;
		},
		columns:[[
		    {field:'ID',title:'ID',hidden: true},
			{field:'OMET_Code',title:'代码',width:80},
			{field:'OMET_Desc',title:'描述',width:180},	
			{field:'OMET_VIPLevel',title:'VIP等级',width:100},	
					
		]],
		onLoadSuccess:function(){
			$("#OMEType").combogrid('setValue',""); 
		},
		});
}

function InitEDCheckCycleGrid(){
	$HUI.datagrid("#EDCheckCycleGrid",{
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
			ClassName:"web.DHCPE.Endanger",
			QueryName:"SearchEDCheckCycle",
			Parref:$.trim(selectrow),
		},
		columns:[[
	
		    {field:'TID',title:'ID',hidden: true},
			{field:'TCode',width:'200',title:'编码'},
			{field:'TDesc',width:'200',title:'描述'},
			{field:'TOMEType',width:'150',title:'检查种类'},
			{field:'TActive',width:'60',title:'激活'},
			{field:'TExpInfo',width:'130',title:'扩展信息'},
			{field:'TRemark',width:'100',title:'备注'},
			
			
		]],
		onSelect: function (rowIndex, rowData) {
			    $("#ID").val(rowData.TID);
				$("#Code").val(rowData.TCode);
				$("#Desc").val(rowData.TDesc);
				$("#OMEType").combogrid('setValue',rowData.TOMETypeDR);
				$("#ExpInfo").val(rowData.TExpInfo);
				$("#Remark").val(rowData.TRemark);
				if(rowData.TActive=="否"){
					$("#Active").checkbox('setValue',false);
				}if(rowData.TActive=="是"){
					$("#Active").checkbox('setValue',true);
				};
					
												
		}
	})
}