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
		{field:'ArcimName',title:'ҽ��',width:200},
		{field:'Percent',title:'����ϵ��',width:100},
		{field:'BSAUnitSTD',title:'��׼ֵ',width:100},
		{field:'BSAUnit',title:'������ı�׼ֵ',width:120},
		{field:'FinalDose',title:'����������ռ���',width:125},
		{field:'Reason',title:'����ԭ��',width:200},
		{field:'BSA',title:'BSA',width:100},
		{field:'GFR',title:'GFR',width:100},
		{field:'SC',title:'Ѫ�弡����',width:100},
		{field:'Formula',title:'���㹫ʽ',width:100},
		{field:'Height',title:'���(cm)',width:100},
		{field:'Weight',title:'����(kg)',width:100},
		{field:'IBW',title:'��������(kg)',width:100},
		{field:'UserName',title:'������',width:100},
		{field:'LocName',title:'����',width:100},
		{field:'AdjDate',title:'��������',width:100},
		{field:'AdjTime',title:'����ʱ��',width:100},
		{field:'id',title:'id',width:50,hidden:true}
	]]
	var frozenColumns = [[
		//{field:'ArcimName',title:'ҽ��',width:200}
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




