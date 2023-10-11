//名称	DHCPEEDIllness.hisui.js
//功能	危害因素目标疾病维护
//创建	2019.06.14
//创建人  xy

$(function(){
	InitCombobox();
	
	InitEDIllnessGrid();
	    
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

function BSave_click(Type) {
	if(Type=="1"){
		var ID=$("#ENIllID").val();
		if(ID==""){
			$.messager.alert("提示","请选择待修改的记录","info");
			return false;
		}
	}
	
	if(Type=="0"){
	    if($("#ENIllID").val()!=""){
			$.messager.alert("提示","新增数据不能选中记录,请点击清屏后进行新增","info");
			return false;
		}
	}
	var IllnessDR=$("#Illness").combogrid('getValue');
	if (($("#Illness").combogrid('getValue') == undefined) || ($("#Illness").combogrid('getValue') == "")) { var IllnessDR = ""; }	 
	
	if(Type=="1"){var IllnessDR=$("#IllnessID").val();}
	if(IllnessDR==""){
		$.messager.alert("提示","目标疾病不能为空！","info");
		return false;
	}
	
	if (IllnessDR!=""){
		var ret=tkMakeServerCall("web.DHCPE.DHCPECommon","IsIllness",IllnessDR);
		if(ret=="0"){
			$.messager.alert("提示","请选目标疾病！","info");
			return false;
		}
	}
	
	var OMETypeDR=$("#OMEType").combogrid('getValue');
	if (($("#OMEType").combogrid('getValue')==undefined)||($("#OMEType").combogrid('getValue')=="")){var OMETypeDR="";}
	if(OMETypeDR==""){
		$.messager.alert("提示","请选择检查种类！","info");
		return false;
	}

	var ExpInfo=$("#ExpInfo").val();
	if(ExpInfo==""){
		$.messager.alert("提示","请输入具体疾病！","info");
		return false;
	}
	
	var Remark=$("#Remark").val();
	var ID=$("#ENIllID").val();
	var Parref=$.trim(selectrow);
	var iActive="N";
	var Active=$("#Active").checkbox('getValue');
	if(Active) iActive="Y";
	
	var Str=Parref+"^"+IllnessDR+"^"+OMETypeDR+"^"+iActive+"^"+ExpInfo+"^"+Remark;
	//alert(Str)
	
	var rtn=tkMakeServerCall("web.DHCPE.Endanger","EDIllnessSave",ID,Str);
	var Arr=rtn.split("^");
	if (rtn.split("^")[0]=="-1"){
		$.messager.alert("提示","更新失败","error");
	} else {
		BClear_click();
		if(Type=="1"){$.messager.popover({msg: '修改成功！',type:'success',timeout: 1000});}
		if(Type=="0"){$.messager.popover({msg: '新增成功！',type:'success',timeout: 1000});}
		
	}
}

//删除
function BDel_click(){
	var ID=$("#ENIllID").val();
	if (ID=="")
	{
		$.messager.alert("提示","请选择待删除的记录","info");
		return false;
	}
	$.messager.confirm("确认", "确定要删除该记录吗？", function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.Endanger", MethodName:"EDIllnessDelete",ID:ID},function(ReturnValue){
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
	$("#ENIllID,#ExpInfo,#Remark,#IllnessID").val("");
	$("#Active").checkbox('setValue',true);
	$(".hisui-combogrid").combogrid('setValue',"");

	var valbox = $HUI.combogrid("#OMEType,#Illness", {
			required: false,
	});
	
	$("#EDIllnessGrid").datagrid('load',{
		ClassName:"web.DHCPE.Endanger",
		QueryName:"SearchEDIllness",
		Parref:$.trim(selectrow),
	});	
}

function InitCombobox() {
	//目标疾病
	var IllnessObj = $HUI.combogrid("#Illness",{
		panelWidth:185,
		url:$URL+"?ClassName=web.DHCPE.Endanger&QueryName=IllnessList",
		mode:'remote',
		delay:200,
		idField:'ID',
		textField:'IT_Desc',
		onBeforeLoad:function(param){
			param.Desc = param.q;
		},
		columns:[[
		    {field:'ID',title:'ID',hidden:true},
			{field:'IT_Code',title:'代码',width:50},
			{field:'IT_Desc',title:'描述',width:120},
			{field:'IT_ConclusionDR',title:'结论分类',hidden:true},	 	
		]],
		onLoadSuccess:function(){
			//$("#Illness").combogrid('setValue',""); 
		},
	});
		
	//检查种类
	var OMETypeObj = $HUI.combogrid("#OMEType",{
		panelWidth:325,
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
			{field:'OMET_Code',title:'代码',width:50},
			{field:'OMET_Desc',title:'描述',width:150},	
			{field:'OMET_VIPLevel',title:'VIP等级',width:100},	
					
		]],
		onLoadSuccess:function(){
			$("#OMEType").combogrid('setValue',""); 
		},
	});
}

function InitEDIllnessGrid() {
	$HUI.datagrid("#EDIllnessGrid",{
		url:$URL,
		border : false,
		striped : true,
		fit : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 25,
		pageList : [10,25,50,100,200],
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.Endanger",
			QueryName:"SearchEDIllness",
			Parref:$.trim(selectrow),
		},
		columns:[[
	
		    {field:'TID',title:'ID',hidden: true},
			{field:'TIllnessDesc',width:'110',title:'目标疾病'},
			{field:'TOMEType',width:'110',title:'检查种类'},
			{field:'TExpInfo',width:'200',title:'具体疾病'},
			{field:'TActive',width:'50',title:'激活',align:'center'},
			{field:'TRemark',title:'备注'}
		]],
		onSelect: function (rowIndex, rowData) {
			$("#ENIllID").val(rowData.TID);
			$("#Illness").combogrid('setValue',rowData.TIllnessDR);
			$("#IllnessID").val(rowData.TIllnessDR);
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