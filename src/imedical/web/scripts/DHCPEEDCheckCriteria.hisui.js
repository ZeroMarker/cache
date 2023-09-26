//名称	DHCPEEDCheckCriteria.hisui.js
//功能	接害种类诊断标准维护
//创建	2020.02.14
//创建人  zhongricheng
//页面 dhcpeedcheckcriteria.hisui.csp

$(function() {
	InitCombobox();
	
	InitEDCheckCriteriaGrid();
	
    // 修改
	$("#BUpd").click(function() {
		BUpd_click();
    });
    
    // 新增
	$("#BAdd").click(function() {
		BAdd_click();
    });
    
    // 删除
	$("#BDel").click(function() {
		BDel_click();
    });
    
    // 清屏
	$("#BClear").click(function() {
		BClear_click();
	});
});

// 修改
function BUpd_click() {
	BSave_click("1");
}

// 新增
function BAdd_click() {
	BSave_click("0");
}

function BSave_click(Type) {
	var ID = $("#ID").val();
	if(Type == "1") {
		if(ID == "") {
			$.messager.alert("提示","请选择待修改的记录","info");
			return false;
		}
	}
	
	if(Type == "0") {
	    if(ID != "") {
		   	$.messager.alert("提示","新增数据不能选中记录,请点击清屏后进行新增", "info");
		   	return false;
		}
	}
	var Code = $("#Code").val();
	
	if(Code == "") {
		var valbox = $HUI.validatebox("#Code", {
			required: true,
	    });
		$.messager.alert("提示","代码不能为空","info");
		return false;
	}
	
	var DCDR = $("#DiagnosticCriteria").combogrid("getValue");
	if(DCDR == "") {
		$.messager.alert("提示","诊断标准不能为空","info");
		return false;
	}
	
	var OMETypeDR = $("#OMEType").combobox('getValue');
	if (OMETypeDR == undefined || OMETypeDR == "") {
		$.messager.alert("提示", "请选择检查种类", "info");
		return false;
	}

	var ExpInfo = $("#ExpInfo").val();
	var Remark = $("#Remark").val();
	var Parref = $.trim(selectrow);
	var iActive = "N";
	var Active = $("#Active").checkbox('getValue');
	if (Active) iActive = "Y";
	
	var Str = Parref + "^" + Code + "^" + DCDR + "^" + OMETypeDR + "^" + iActive + "^" + ExpInfo + "^" + Remark;
	//alert(Str)
	var rtn = tkMakeServerCall("web.DHCPE.Endanger", "EDCheckCriteriaSave", ID, Str);
	var Arr = rtn.split("^");
	if (Arr[0]=="-1"){
		if(Type=="1") $.messager.alert("提示", "修改失败", "error");
		if(Type=="0") $.messager.alert("提示", "新增失败", "error");
	} else {
		BClear_click();
		if(Type=="1") { $.messager.popover({msg: '修改成功！', type:'success', timeout: 1000}); }
		if(Type=="0") { $.messager.popover({msg: '新增成功！', type:'success', timeout: 1000}); }
	}
}

//删除
function BDel_click() {
	var ID = $("#ID").val();
	if (ID == "") {
		$.messager.alert("提示","请选择待删除的记录","info");
		return false;
	}
	$.messager.confirm("确认", "确定要删除该记录吗？", function(r) {
		if (r) {
			$.m({ ClassName:"web.DHCPE.Endanger", MethodName:"EDCheckCriteriaDelete", ID:ID}, function(ReturnValue){
				if (ReturnValue.split("^")[0] == '-1') {
					$.messager.alert("提示","删除失败","error");  
				} else {
					$.messager.popover({msg: '删除成功！', type:'success', timeout: 1000});
					BClear_click();
				}
			});	
		}
	});
}

function BClear_click(){
	$("#ID,#Code,#ExpInfo,#Remark").val("");
	$(".hisui-checkbox").checkbox('setValue',false);
	$(".hisui-combobox").combobox('setValue',"");
	$(".hisui-combogrid").combogrid('setValue',"");

	var valbox = $HUI.validatebox("#Code", { required: false, });
	$("#EDCheckCriteriaGrid").datagrid('reload');	
}

function InitCombobox(){
	//检查种类
	var OMETypeObj = $HUI.combobox("#OMEType",{
		url:$URL+"?ClassName=web.DHCPE.Endanger&QueryName=OMETypeList&ResultSetType=array",
		valueField:'ID',
		textField:'OMET_Desc',
		defaultFilter:4
	});
	
	//诊断标准
	var OMETypeObj = $HUI.combogrid("#DiagnosticCriteria",{
		panelWidth:450,
		url:$URL+"?ClassName=web.DHCPE.Endanger&QueryName=CheckCriteriaList&Active=Y",
		mode:'remote',
		delay:200,
		idField:'TID',
		textField:'TDesc',
		fit:true,
		onBeforeLoad:function(param){
			param.Desc = param.q;
		},
		columns:[[
		    {field:'TID',title:'TID',hidden:true},
			{field:'TCode',title:'代码',width:50},
			{field:'TDesc',title:'诊断标准'} 	
		]],
		onLoadSuccess:function(){
			//$("#Illness").combogrid('setValue',""); 
		},
	});
}

function InitEDCheckCriteriaGrid(){
	$HUI.datagrid("#EDCheckCriteriaGrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.Endanger",
			QueryName:"SearchEDCheckCriteria",
			Parref:$.trim(selectrow),
		},
		border : false,
		striped : true,
		fit:true,
		fitColumns:true,
		animate:true,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: true,
		columns:[[
		    {field:'TID', title:'TID', hidden:true},
		    {field:'TDCDR', title:'TDCDR', hidden:true},
		    
			{field:'TCode', width:'60', title:'代码'},
			{field:'TDiagnosticCriteria', width:'300', title:'诊断标准'},
			{field:'TOMEType', width:'80', title:'检查种类'},
			{field:'TActive', width:'40', title:'激活', align:'center',
				formatter:function (value, rowData, rowIndex) {
					if (value == "Y") { return "是"; }
					else { return "否"; }
				}
			},
			{field:'TExpInfo', width:'100', title:'扩展信息'},
			{field:'TRemark', width:'200', title:'备注'},
		]],
		onSelect: function (rowIndex, rowData) {
		    $("#ID").val(rowData.TID);
			$("#Code").val(rowData.TCode);
			$("#DiagnosticCriteria").combogrid('setValue',rowData.TDCDR);
			$("#OMEType").combobox('setValue',rowData.TOMETypeDR);
			$("#ExpInfo").val(rowData.TExpInfo);
			$("#Remark").val(rowData.TRemark);
			if(rowData.TActive == "Y" || rowData.TActive == "是") {
				$("#Active").checkbox('setValue',true);
			} else {
				$("#Active").checkbox('setValue',false);
			};
		}
	});
}