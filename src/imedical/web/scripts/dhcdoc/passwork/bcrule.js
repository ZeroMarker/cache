/**
 * bcrule.js
 * 
 * Copyright (c) 2020-2090 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-09-02
 * 
 * 
 */

var PageLogicObj = {
	m_Loc:""
}

$(function() {
	Init();
	InitEvent();
	//PageHandle();
})


function Init(){
	InitBTypeGrid();
	
}

function InitEvent () {
	$("#dg-rule-save").click(Save)
}

function PageHandle() {
	
}

function Save() {
	var ID="";
	var selected = PageLogicObj.m_BTypeGrid.getSelected();
	var code = $.trim($("#dg-rule-code").val());
	var desc = $.trim($("#dg-rule-desc").val());
	var value = $.trim($("#dg-rule-value").val());
	var note = $.trim($("#dg-rule-note").val());
	if (code == "") {
		$.messager.alert("提示","代码不能为空！","info")
		return false;
	}
	if (desc == "") {
		$.messager.alert("提示","描述不能为空！","info")
		return false;
	}
	if (selected) {
		ID = selected.rowid;
	}
	var SP = String.fromCharCode(1);
	var inPara = ServerObj.MID+SP+code+SP+desc+SP+value+SP+note
	
	var responseText = $.m({
		ClassName:"DHCDoc.PW.CFG.BCRule",
		MethodName:"Save",
		ID:ID,
		inPara:inPara
	},false);
	responseText = responseText.split("^")
	
	if (responseText[0] > 0) {
		//$.messager.alert("提示","代码不能为空！","info");
		$.messager.popover({msg:"保存成功！",type:'success'});
		PageLogicObj.m_BTypeGrid.reload();
		$("#dg-rule-code").val("").removeAttr("disabled");
		$("#dg-rule-desc").val("");
		$("#dg-rule-value").val("");
		$("#dg-rule-note").val("");
		return true;
	} else {
		$.messager.popover({msg:"保存失败："+responseText[1],type:'error'});
		return false;
	}
}


function InitBTypeGrid () {
	var columns = [[
		{field:'code',title:'代码',width:50},
		{field:'desc',title:'描述',width:100},
		{field:'value',title:'数值',width:200},
		{field:'note',title:'备注',width:100},
        {field:'rowid',title:'ID',width:60,hidden:true}
    ]]
	var DurDataGrid = $HUI.datagrid("#List", {
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		rownumbers:true,
		//autoRowHeight : false,
		pagination : true,  
		headerCls:'panel-header-gray',
		//pageSize:14,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "DHCDoc.PW.CFG.BCRule",
			QueryName : "QryBCRule",
			InMID:ServerObj.MID
		},
		onUnselect:function(){
		},
		columns :columns,
		onBeforeSelect:function(index, row){
			var selrow = PageLogicObj.m_BTypeGrid.getSelected();
			if (selrow){
				var oldIndex = PageLogicObj.m_BTypeGrid.getRowIndex(selrow);
				if (oldIndex == index){
					PageLogicObj.m_BTypeGrid.unselectRow(index);
					return false;
				}
			}
		},
		onUnselect: function (rowIndex, rowData) {
			$("#dg-rule-code").val("").removeAttr("disabled");
			$("#dg-rule-desc").val("");
			$("#dg-rule-value").val("");
			$("#dg-rule-note").val("");
		},
		onSelect: function (rowIndex, rowData) {
			$("#dg-rule-code").val(rowData.code).attr("disabled","disabled");
			$("#dg-rule-desc").val(rowData.desc);
			$("#dg-rule-value").val(rowData.value);
			$("#dg-rule-note").val(rowData.note);
		}
	});
	
	PageLogicObj.m_BTypeGrid =  DurDataGrid;
	return false;
}
