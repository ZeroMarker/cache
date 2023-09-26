/**
 * dhcant.kss.business.apply.js 抗菌药物申请列表
 * 
 * Copyright (c) 2016-2017 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2016-08-20
 * 
 */
 var PageLogicObj = {
	m_LeftGrid: '',
	m_CenterGrid:''
	
}

$(function(){
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
	
	//页面元素初始化
	//PageHandle();
	
	
});

function Init(){
	PageLogicObj.m_LeftGrid = InitGrid();
	PageLogicObj.m_CenterGrid = InitCenterGrid();
}

function InitEvent () {
	$("#i-add").click(function () {
		var selected = PageLogicObj.m_CenterGrid.getSelected();
		if (!selected) {
			$.messager.alert("提示","请选择要开具的医嘱项","warning")
			return false;
		}
		
		closeWin(selected.id)
		return false;
	})
	$("#i-cancel").click(function () {
		closeWin("")
		return false;
	})
}

function InitGrid(){
	var columns = [[
		{field:'text',title:'切口类型',width:100},
		{field:'id',title:'id',width:100,hidden:true}
    ]]
	var DataGrid = $HUI.datagrid("#i-left", {
		fit : true,
		border : false,
		striped : true,
		nowrap:false,   
		singleSelect : true,
		fitColumns : true,
		//rownumbers:true,
		//autoRowHeight : false,
		//pagination : true,  
		//headerCls:'panel-header-gray',
		//pageSize:14,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "DHCAnt.Hosp.AH.AYSFY",
			QueryName : "QryDatatType"
		},
		//idField:'Rowid',
		columns :columns,
		onSelect: function (rowIndex, rowData) {
			reloadCenterGrid(rowData.id)
		}
	});
	
	return DataGrid;
}

function InitCenterGrid(){
	var columns = [[
		{field:'text',title:'医嘱项',width:100},
		{field:'id',title:'id',width:100,hidden:true}
    ]]
	var DataGrid = $HUI.datagrid("#i-center", {
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		//rownumbers:true,
		//autoRowHeight : false,
		//pagination : true,  
		//headerCls:'panel-header-gray',
		//pageSize:14,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "DHCAnt.Hosp.AH.AYSFY",
			QueryName : "QryOPArcim",
			OPCut: ''
		},
		//idField:'Rowid',
		columns :columns,
		toolbar:[{
			text:'确定',
			id:'i-add',
			iconCls: 'icon-add'
		},{
			text:'取消',
			id:'i-cancel',
			iconCls: 'icon-cancel'
		}],
	});
	
	return DataGrid;
}


function reloadCenterGrid (OPCut) {
	PageLogicObj.m_CenterGrid.reload({
		ClassName : "DHCAnt.Hosp.AH.AYSFY",
		QueryName : "QryOPArcim",
		OPCut: OPCut

	});
}

function closeWin (returnValue) {
	if (window.opener) {
		window.opener.returnValue = returnValue;
	} else {
		window.returnValue = returnValue;
	}
	window.close();
}