//名称	DHCPEHandlingOpinions.hisui.js
//功能	危害因素诊断标准维护
//创建	2020.02.17
//创建人  zhongricheng
//页面 dhcpehandlingopinions.hisui.csp

$(function () {
	InitCombobox();
	InitDataGrid();
	
	$("#BSearch").click(function() {
		BSearch_click();
    });
    
    $("#BClear").click(function() {
		BClear_click("0");
    });
});

function InitCombobox() {
	//检查种类
	$HUI.combobox("#OMEType, #OMETypeWin", {
		url:$URL+"?ClassName=web.DHCPE.Endanger&QueryName=OMETypeList&ResultSetType=array",
		valueField:'ID',
		textField:'OMET_Desc',
	    panelHeight:'auto', //自动高度
	    panelMaxHeight:200, //最大高度
		defaultFilter:4
	});
	
	// 检查结论
	$HUI.combogrid("#Conclusion, #ConclusionWin", {
		url:$URL+"?ClassName=web.DHCPE.Conclusion&QueryName=FindConclusion&Active=Y&ResultSetType=array",
		panelWidth: 350,
        blurValidValue:true,
		delay:200,
        idField: 'TRowId',
        textField: 'TDesc',
        method: 'remote',
		columns:[[
		    {field:'TRowId',title:'ITRowIdD',hidden: true},
			{field:'TCode',title:'代码',width:70},
			{field:'TDesc',title:'描述',width:180},	
			{field:'TVIPLevel',title:'VIP等级',width:100}
		]]
	});
}

function InitDataGrid() {
	$HUI.datagrid("#HandlingOpinions", {
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.HandlingOpinions",
			QueryName:"QueryHO",
			Code:"",
			Conclusion:"",
			OMEType:""
		},
		method: 'get',
		idField: 'ARCOSRowid',
		treeField: 'ARCOSOrdSubCat',
		columns:[[
			{field:'TId', title:'TId', hidden:true},
			{field:'TConclusion', title:'TConclusion', hidden:true},
			{field:'TOMEType', title:'TOMEType', hidden:true},
			
			{field:'TCode', title:'代码', align:'center', width:80},
			{field:'TConclusionDesc', title:'检查结论', width:100},
			{field:'TOMETypeDesc', title:'检查种类', width:100},
			{field:'TDesc', title:'处理意见', width:500},
			
			{field:'TSort', title:'顺序', align:'center', width:40},
			{field:'TActive', title:'激活', align:'center', width:40,
				formatter:function(value, rowData, rowIndex) {
					if (value == "Y") return "是";
					else return "否";
				}
			},
			{field:'TRemark', title:'备注', width:200}
		]],
		collapsible: true, //收起表格的内容
		lines:true,
		striped:true, // 条纹化
		rownumbers:true,
		fit:true,
		fitColumns:true,
		animate:true,
		pagination:true,   // 树形表格 不能分页
		pageSize:25,
		pageList:[10,25,50,100],
		singleSelect:true,
		toolbar: [{
			iconCls: 'icon-add',
			text:'新增',
			handler: function(){
				BClear_click("1");
				$("#HOWin").show();
					 
				var myWin = $HUI.dialog("#HOWin",{
					iconCls:'icon-w-add',
					resizable:true,
					title:'新增',
					modal:true,
					buttonAlign:'center',
					buttons:[{
						text:'保存',
						handler:function(){
							BAdd_click("Add");
						}
					},{
						text:'关闭',
						handler:function(){
							myWin.close();
						}
					}]
				});
			}
		},{
			iconCls: 'icon-write-order',
			text:'修改',
			id:'BUpd',
			disabled:true,
			handler: function(){
				BClear_click("1");
				$("#HOWin").show();
				
				var SelRowData = $("#HandlingOpinions").datagrid("getSelected");
				$("#CodeWin").val(SelRowData.TCode).validatebox("validate");
				$("#ConclusionWin").combogrid("setValue",SelRowData.TConclusion);
				$("#SortWin").numberbox("setValue",SelRowData.TSort).validatebox("validate");
				$("#OMETypeWin").combobox("setValue",SelRowData.TOMEType);
				$("#RemarkWin").val(SelRowData.TRemark);
				$("#HanlingOpinionsWin").val(SelRowData.TDesc);
				
				var active=false;
				if (SelRowData.TActive == "Y") active=true;
				$("#ActiveWin").checkbox("setValue",active);
				
				var myWin = $HUI.dialog("#HOWin",{
					iconCls:'icon-w-edit',
					resizable:true,
					title:'修改',
					modal:true,
					buttonAlign:'center',
					buttons:[{
						text:'修改',
						handler:function() {
							BAdd_click("Upd");
						}
					},{
						text:'关闭',
						handler:function() {
							myWin.close();
						}
					}]
				});
			}
		}],		
		onClickRow: function (rowIndex, rowData) {  // 选择行事件
			$('#BUpd').linkbutton('enable');
		},
		onDblClickRow: function (rowIndex, rowData) {  // 双击行事件
		},
		onLoadSuccess:function(data) {
			
		}
	});
}

function BAdd_click(Type) {
	if (Type == "Add") {
		var Id = "";
		var Al = "保存";
		var Opt = "insertRow";
		var OptIndex = 0;
	} else if (Type == "Upd") {
		var SelRowData = $("#HandlingOpinions").datagrid("getSelected");
		if ( !SelRowData ) { $.messager.alert("提示","请选择处理意见后再进行修改！", "info"); return false; }
		var Id = SelRowData.TId;
		var Al = "修改";
		var Opt = "updateRow";
		var OptIndex = $("#HandlingOpinions").datagrid("getRowIndex", SelRowData);
	} else {
		return false;
	}
	
	var Code = $("#CodeWin").val().replace(/(^\s*)|(\s*$)/g,"").toUpperCase();
	if (Code == "") { $.messager.alert("提示", "请输入代码！", "info"); return false; }
	
	var Conclusion = $("#ConclusionWin").combogrid("getValue");
	if (Conclusion == "") { $.messager.alert("提示", "请选择检查结论！", "info"); return false; }
	
	var Sort = $("#SortWin").numberbox("getValue");
	if (Sort == "") { $.messager.alert("提示", "请输入顺序！", "info"); return false; }
	
	var Desc = $("#HanlingOpinionsWin").val().replace(/(^\s*)|(\s*$)/g,"");
	if (Desc == "") { $.messager.alert("提示", "请输入处理意见！", "info"); return false; }
	
	var OMEType = $("#OMETypeWin").combobox("getValue");
	var Remark = $("#RemarkWin").val();
	
	var Active = "N";
	var cActive=$("#ActiveWin").checkbox("getValue");
	if (cActive) { Active = "Y"; }
	
	var OMETypeDesc = $("#OMETypeWin").combobox("getText");
	var ConclusionDesc = $("#ConclusionWin").combogrid("getText");
	
	var SplitChar = "^";
	var DataStr = Code + SplitChar + OMEType + SplitChar + Conclusion + SplitChar + Desc + SplitChar + Sort + SplitChar + Active + SplitChar + Remark;  // 代码^检查种类^检查结论^处理意见^顺序^激活^备注

	$.m({
		ClassName:"web.DHCPE.HandlingOpinions",
		MethodName:"HOSave",
		Id:Id,
		DataStr:DataStr,
		SplitChar:SplitChar
	}, function(ret) { 
		if (ret.split("^")[0] == "-1") {
			$.messager.alert("提示", Al + "失败！" + ret.split("^")[1], "info");
			return false;
		}
		
		$.messager.alert("提示", Al + "成功！", "info");
		$("#HandlingOpinions").datagrid(Opt, {
			index:OptIndex,
			row:{
				TId:ret,
				TConclusion:Conclusion,
				TOMEType:OMEType,
				
				TCode:Code,
				TConclusionDesc:ConclusionDesc,
				TOMETypeDesc:OMETypeDesc,
				TDesc:Desc,
				
				TSort:Sort, 
				TActive:(Active=="Y"?"是":"否"),
				TRemark:Remark
			}
		});
		$("#HOWin").window("close");
	});
}

function BSearch_click() {
	$("#HandlingOpinions").datagrid('clearSelections'); //取消选中状态
    $("#BUpd").linkbutton('disable');

	$HUI.datagrid("#HandlingOpinions",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.HandlingOpinions",
			QueryName:"QueryHO",
			Code:$("#Code").val(),
			Conclusion:$("#Conclusion").combogrid("getValue"),
			OMEType:$("#OMEType").combobox("getValue")
		}
	});
}

function BClear_click(Type) {
	if (Type == "0") {
		$("#Code").val("");
		$("#Conclusion").combogrid("setValue","");
		$("#OMEType").combobox("setValue","");
	} else if (Type == "1") {
		$("#CodeWin").val("").validatebox("validate");;
		$("#ConclusionWin").combogrid("setValue","");
		$("#OMETypeWin").combobox("setValue","");
		$("#SortWin").numberbox("setValue","").validatebox("validate");;
		$("#ActiveWin").checkbox("setValue","true");
		$("#HanlingOpinionsWin").val("");
	}
}