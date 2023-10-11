//名称	DHCPEWorkType.hisui.js
//功能	工种维护
//创建	2019.05.07
//创建人  xy
AddFlag = "N";
$(function(){
	InitWorkTypeDataGrid();
	
    //查询
	$("#BFind").click(function() {	
		BFind_click();		
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
    
    //清屏
	$("#BClear").click(function() {	
		BClear_click("0");		
    });
});

//查询
function BFind_click() {
	$("#WorkTypeQueryTab").datagrid('load', {
		ClassName:"web.DHCPE.WorkType",
		QueryName:"SearchWorkType",
		Code:$("#Code").val(),
		Desc:$("#Desc").val(),
		Active:$("#Active").checkbox("getValue")?"Y":"N"
	});
}

//修改
function BUpdate_click() {
	BClear_click("1");
	var rowData = $("#WorkTypeQueryTab").datagrid("getSelected");
	if (!rowData) { 
		$.messager.alert("提示","请选择待修改的工种！", "info"); 
		return false; 
	}
	$("#CodeWin").val(rowData.TCode).validatebox("validate");;
	$("#DescWin").val(rowData.TDesc).validatebox("validate");;
	$("#ExpInfoWin").val(rowData.TExpInfo);
	$("#RemarkWin").val(rowData.TRemark);
	$("#ActiveWin").checkbox('setValue', (rowData.TActive=="是"?true:false));	
	
	$("#AddWin").show();
	 
	var myWin = $HUI.dialog("#AddWin",{
		iconCls:'icon-w-update',
		resizable:true,
		title:'修改-' + rowData.TDesc,
		modal:true,
		onClose: function() {
			BClear_click("1");
			if (AddFlag == "Y") {
				$("#WorkTypeQueryTab").datagrid("reload");
			}
		},
		buttonAlign:'center',
		buttons:[{
			text:'修改',
			handler:function(){
				BSave_click("1", rowData.TID);
			}
		},{
			text:'关闭',
			handler:function(){
				myWin.close();
			}
		}]
	});
}

 //新增
function BAdd_click() {
	BClear_click("1");	
	
	$("#AddWin").show();
	 
	var myWin = $HUI.dialog("#AddWin",{
		iconCls:'icon-w-update',
		resizable:true,
		title:'新增',
		modal:true,
		onClose: function() {
			BClear_click("1");
			if (AddFlag == "Y") {
				$("#WorkTypeQueryTab").datagrid("reload");
				AddFlag = "N";
			}
		},
		buttonAlign:'center',
		buttons:[{
			text:'保存',
			handler:function(){
				BSave_click("0", "");
			}
		},{
			text:'关闭',
			handler:function(){
				myWin.close();
			}
		}]
	});
}

//更新
function BSave_click(Type, ID) {
	if (Type == "1" && ID == "") {
		$.messager.alert("提示","请选择待修改的工种！","info");
		return false;
	}
	
	var Code = $("#CodeWin").val();
	if ("" == Code) {
		$("#CodeWin").focus();
		$HUI.validatebox("#CodeWin", { required: true });
		$.messager.alert("提示","编码不能为空","info");
		return false;
	}
	
	var Desc = $("#DescWin").val();
	if ("" == Desc) {
		$("#DescWin").focus();
		var valbox = $HUI.validatebox("#DescWin", { required: true });
		$.messager.alert("提示","工种不能为空","info");
		return false;
	}
	
	var ExpInfo = $("#ExpInfoWin").val();
	var Remark = $("#RemarkWin").val();
	
	var Active = $("#ActiveWin").checkbox("getValue")?"Y":"N";
	
	var Str = Code+"^"+Desc+"^"+Active+"^"+ExpInfo+"^"+Remark;
	
	$.m({
		ClassName:"web.DHCPE.WorkType",
		MethodName:"UpdateWorkType",
		ID:ID,
		InfoStr:Str
	},function(ret){
		var Arr = ret.split("^");
		if (Arr[0] > 0){
			//$.messager.alert("提示", (Type=="0"?"新增":"修改") + "成功", "success");
			$.messager.popover({msg: (Type=="0"?"新增":"修改") + "成功", type: "success", timeout: 2000});
			
			if (Type == "0") BClear_click("1");
			if (Type == "1") {
				$("#AddWin").window("close");
				$("#WorkTypeQueryTab").datagrid("reload");
				AddFlag = "N";
			}
			AddFlag = "Y";
		}else{
			$.messager.alert("提示", Arr[1], "error");	
		}
	});
}

//删除
function BDelete_click() {
	var rowData = $("#WorkTypeQueryTab").datagrid("getSelected");
	if (!rowData) { 
		$.messager.alert("提示","请选择待删除的工种！", "info"); 
		return false; 
	}
	var RowId = rowData.TID;
	if (RowId=="") {
		$.messager.alert("提示","请选择待删除的工种！","info");	
		return false;
	}
	
	var rtn=tkMakeServerCall("web.DHCPE.WorkType","DeleteWorkType",RowId);
	if (rtn.split("^")[0]=="-1"){
		$.messager.alert("提示","删除失败"+rtn.split("^")[1],"error");	
	}else{
		$("#WorkTypeQueryTab").datagrid("reload");
		$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
	}
}

//清屏
function BClear_click(Type) {
	if (Type == "0") {
		$("#Code,#Desc,#ExpInfo,#Remark").val("");
		$("#Active").checkbox('setValue',true);
	} else if (Type == "1") {
		$("#CodeWin,#DescWin").val("").validatebox("validate");
		$("#ExpInfoWin,#RemarkWin").val("");
		$("#ActiveWin").checkbox('setValue',false);
	}
	BFind_click()
}

function InitWorkTypeDataGrid() {
	$HUI.datagrid("#WorkTypeQueryTab",{
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
			ClassName:"web.DHCPE.WorkType",
			QueryName:"SearchWorkType",
			Code:$("#Code").val(),
			Desc:$("#Desc").val(),
			Active:$("#Active").checkbox("getValue")?"Y":"N"
			
		},
		columns:[[
		    {field:'TID',title:'TID',hidden: true},
			{field:'TCode',width:'200',title:'代码'},
			{field:'TDesc',width:'280',title:'工种'},
			{field:'TActive',width:'150',title:'激活'},
			{field:'TExpInfo',width:'300',title:'扩展信息'},
			{field:'TRemark',width:'250',title:'备注'}
		]]
	});
}