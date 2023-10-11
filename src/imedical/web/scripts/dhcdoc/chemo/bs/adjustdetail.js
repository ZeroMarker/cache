/**
 * adjustdetail.js
 * 
 * Copyright (c) 2018-2050 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-08-13
 * 
 * 
 */
$(function() {
	Init();
	InitEvent();
})

function Init(){
	InitGrid()
}

function InitEvent () {
	
}

function InitGrid(){
	var columns = [[
		{field:'ArcimName',title:'医嘱',width:200},
		{field:'Percent',title:'调整系数',width:100},
		{field:'BSAUnitSTD',title:'标准值',width:100},
		{field:'BSAUnit',title:'调整后的标准值',width:120},
		{field:'FinalDose',title:'调整后的最终剂量',width:125},
		{field:'Reason',title:'调整原因',width:200},
		{field:'BSA',title:'BSA',width:100},
		{field:'GFR',title:'GFR',width:100},
		{field:'SC',title:'血清肌酸酐',width:100},
		{field:'Formula',title:'计算公式',width:100},
		{field:'Height',title:'身高(cm)',width:100},
		{field:'Weight',title:'体重(kg)',width:100},
		{field:'IBW',title:'理想体重(kg)',width:100},
		{field:'UserName',title:'调整人',width:100},
		{field:'LocName',title:'科室',width:100},
		{field:'AdjDate',title:'调整日期',width:100},
		{field:'AdjTime',title:'调整时间',width:100},
		{field:'id',title:'id',width:50,hidden:true}
	]]
	var frozenColumns = [[
		//{field:'ArcimName',title:'医嘱',width:200}
	]]
	var DataGrid = $HUI.datagrid("#i-list", {
		fit : true,
		striped : true,
		border:true,
		nowrap:false,
		singleSelect : true,
		headerCls:'panel-header-gray',
		//fitColumns : true,
		rownumbers:false,
		//autoRowHeight : false,
		pagination : true,  
		//headerCls:'panel-header-gray',
		//pageSize:14,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "DHCDoc.Chemo.BS.Ext.ItemAdj",
			QueryName : "QryAdjDetail",
			PLID: ServerObj.PLID
			
		},
		onSelect: function (rowIndex, rowData) {
			
		},
		onLoadSuccess : function (data) {
			PageHandle();
		},
		//frozenColumns:frozenColumns,
		columns :columns
		
	});
	
	PLObject.m_Grid = DataGrid;
}




