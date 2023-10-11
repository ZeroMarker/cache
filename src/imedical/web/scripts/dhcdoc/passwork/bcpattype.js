/**
 * bcpattype.js
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
	InitCombox();
	InitBTypeGrid();
	
}

function InitEvent () {
	$("#dg-pat-save").click(Save)
	//$("#dg-pat-recreate").click(ReCreate)
}

function PageHandle() {
	
}

function InitCombox() {
	PageLogicObj.m_URL = $HUI.combobox("#dg-pat-url", {
		url:$URL+"?ClassName=DHCDoc.PW.CFG.BCTpl&QueryName=QryBCTPL&InActive=1&InMID="+ServerObj.MID+"&ResultSetType=array",
		valueField:'url',
		textField:'name',
		//required:true,
		blurValidValue:true
	});
	
}

function Save() {
	var ID="";
	var selected = PageLogicObj.m_BTypeGrid.getSelected();
	var code = $.trim($("#dg-pat-code").val());
	var desc = $.trim($("#dg-pat-desc").val());
	var isDisplay = $("#dg-pat-isDisplay").checkbox("getValue")?1:0;
	var disNo = $.trim($("#dg-pat-disNo").val());
	var url = PageLogicObj.m_URL.getValue()||"";	//$.trim($("#dg-pat-url").val());
	var wh = $.trim($("#dg-pat-wh").val());
	var isSelected = $("#dg-pat-selected").checkbox("getValue")?1:0;
	if (code == "") {
		$.messager.alert("��ʾ","���벻��Ϊ�գ�","info")
		return false;
	}
	if (desc == "") {
		$.messager.alert("��ʾ","��������Ϊ�գ�","info")
		return false;
	}
	if (disNo == "") {
		$.messager.alert("��ʾ","��ʾ˳����Ϊ�գ�","info")
		return false;
	}
	if (url == "") {
		$.messager.alert("��ʾ","ģ�����Ӳ���Ϊ�գ�","info")
		return false;
	}
	if (wh == "") {
		$.messager.alert("��ʾ","��߲���Ϊ�գ�","info")
		return false;
	}
	if (selected) {
		ID = selected.rowid;
	}
	var inPara = ServerObj.MID+"^"+code+"^"+desc+"^"+isDisplay+"^"+disNo+"^"+wh+"^"+url+"^"+isSelected;
	var responseText = $.m({
		ClassName:"DHCDoc.PW.CFG.BCPatType",
		MethodName:"Save",
		inPara:inPara,
		ID: ID
	},false);
	responseText = responseText.split("^")
	if (responseText[0] > 0) {
		$.messager.popover({msg:"����ɹ���",type:'success'});
		PageLogicObj.m_BTypeGrid.reload();
		$("#dg-pat-code").val("").removeAttr("disabled");
		$("#dg-pat-desc").val("");
		$("#dg-pat-isDisplay").checkbox("uncheck");
		$("#dg-pat-selected").checkbox("uncheck");
		$("#dg-pat-disNo").val("");
		//$("#dg-pat-url").val("");
		PageLogicObj.m_URL.clear();
		$("#dg-pat-wh").val("");
		return true;
	} else {
		$.messager.popover({msg:"����ʧ�ܣ�"+responseText[1],type:'error'});
		return false;
	}
}


function InitBTypeGrid () {
	var columns = [[
		{field:'code',title:'����',width:100},
		{field:'desc',title:'����',width:100},
		{field:'active',title:'�Ƿ���ʾ',width:80,
			formatter:function(value,row,index){
				if (value == 1) {
					return "<span class='c-ok'>��</span>"
				} else {
					return "<span class='c-no'>��</span>"
				}
			}
		},
		{field:'num',title:'��ʾ˳��',width:80},
		{field:'selected',title:'Ĭ��ѡ��',width:80,
			formatter:function(value,row,index){
				if (value == 1) {
					return "<span class='c-ok'>��</span>"
				} else {
					return "<span class='c-no'>��</span>"
				}
			}
		},
		{field:'wh',title:'���',width:80},
		{field:'urlName',title:'ģ��',width:200},
		//{field:'url',title:'ģ������',width:200},
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
			ClassName : "DHCDoc.PW.CFG.BCPatType",
			QueryName : "QryPatType",
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
			$("#dg-pat-code").val("").removeAttr("disabled");
			$("#dg-pat-desc").val("");
			$("#dg-pat-isDisplay").checkbox("uncheck");
			$("#dg-pat-selected").checkbox("uncheck");
			$("#dg-pat-disNo").val("");
			//$("#dg-pat-url").val("");
			PageLogicObj.m_URL.clear();
			$("#dg-pat-wh").val("");
		},
		onSelect: function (rowIndex, rowData) {
			$("#dg-pat-code").val(rowData.code).attr("disabled","disabled");;
			$("#dg-pat-desc").val(rowData.desc);
			$("#dg-pat-disNo").val(rowData.num);
			//$("#dg-pat-url").val(rowData.url);
			PageLogicObj.m_URL.setValue(rowData.url);
			$("#dg-pat-wh").val(rowData.wh);
			if (rowData.active == 1) {$("#dg-pat-isDisplay").checkbox("check")}
			else {$("#dg-pat-isDisplay").checkbox("uncheck")}
			if (rowData.selected == 1) {$("#dg-pat-selected").checkbox("check")}
			else {$("#dg-pat-selected").checkbox("uncheck")}
			
		}
	});
	
	PageLogicObj.m_BTypeGrid =  DurDataGrid;
	return false;
}
