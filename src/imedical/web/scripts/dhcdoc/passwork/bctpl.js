/**
 * bctpl.js
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
	$("#Save").click(Save)
}

function PageHandle() {
	
}

function Save() {
	var ID="";
	var selected = PageLogicObj.m_BTypeGrid.getSelected();
	var url = $.trim($("#url").val());
	var name = $.trim($("#name").val());
	var rpx = $.trim($("#rpx").val());
	var active = $("#active").checkbox("getValue")?1:0;
	
	if (url == "") {
		$.messager.alert("��ʾ","���Ӳ���Ϊ�գ�","info")
		return false;
	}
	if (name == "") {
		$.messager.alert("��ʾ","��������Ϊ�գ�","info")
		return false;
	}
	if (rpx == "") {
		$.messager.alert("��ʾ","������Ϊ�գ�","info")
		return false;
	}
	if (selected) {
		ID = selected.rowid;
	}
	var SP = String.fromCharCode(1);
	var inPara = ServerObj.MID+SP+url+SP+name+SP+active+SP+rpx;
	
	var responseText = $.m({
		ClassName:"DHCDoc.PW.CFG.BCTpl",
		MethodName:"Save",
		ID:ID,
		inPara:inPara
	},false);
	responseText = responseText.split("^")
	
	if (responseText[0] > 0) {
		//$.messager.alert("��ʾ","���벻��Ϊ�գ�","info");
		$.messager.popover({msg:"����ɹ���",type:'success'});
		PageLogicObj.m_BTypeGrid.reload();
		$("#url").val("");
		$("#name").val("");
		$("#rpx").val("");
		$("#active").checkbox("uncheck");
		return true;
	} else {
		$.messager.popover({msg:"����ʧ�ܣ�"+responseText[1],type:'error'});
		return false;
	}
}


function InitBTypeGrid () {
	var columns = [[
		{field:'url',title:'����',width:100},
		{field:'name',title:'����',width:100},
		{field:'rpx',title:'����',width:100},
		{field:'active',title:'����',width:30,
			formatter:function(value,row,index){
				if (value == 1) {
					return "<span class='c-ok'>��</span>"
				} else {
					return "<span class='c-no'>��</span>"
				}
			}
		
		},
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
			ClassName : "DHCDoc.PW.CFG.BCTpl",
			QueryName : "QryBCTPL",
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
			$("#url").val("");
			$("#name").val("");
			$("#rpx").val("");
			$("#active").checkbox("uncheck");
		},
		onSelect: function (rowIndex, rowData) {
			$("#url").val(rowData.url)
			$("#name").val(rowData.name);
			$("#rpx").val(rowData.rpx);
			if (rowData.active == 1) {$("#active").checkbox("check")}
			else {$("#active").checkbox("uncheck")}
		}
	});
	
	PageLogicObj.m_BTypeGrid =  DurDataGrid;
	return false;
}
