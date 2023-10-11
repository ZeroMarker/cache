/**
 * overview.js
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-04-28
 * 
 * 
 */
$(function() {
	Init();
	InitEvent();
})


function Init(){
	//InitCombox()
	InitGrid();
	
}

function InitEvent () {
	//$("#i-find").click(findConfig);
	
}

function InitCombox() {
	
}

function InitGrid(){
	
	var columnsNew = $cm({
		ClassName:"DHCDoc.Chemo.BS.Ext.OverView",
		MethodName:"GetColumns",
		PSID:ServerObj.PSID
	},false);

	var DataGrid = $HUI.datagrid("#i-list", {
		fit : true,
		striped : true,
		border:true,
		bodyCls:'panel-body-gray',
		singleSelect : true,
		//fitColumns : true,
		rownumbers:false,
		//autoRowHeight : false,
		pagination : true,  
		nowrap:false,
		//headerCls:'panel-header-gray',
		pageSize:20,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "DHCDoc.Chemo.BS.Ext.OverView",
			QueryName : "QryData",
			PSID:ServerObj.PSID
			
		},
		onSelect: function (rowIndex, rowData) {
			
		},
		//frozenColumns:frozenColumns,
		columns :[columnsNew]
	});
	
	PageLogicObj.m_Grid = DataGrid;
}

function findConfig () {
	var TplDR = PLObject.m_TPL.getValue()||"";
	var InFlag = $("#i-flag").checkbox("getValue")?"1":"";
	PLObject.m_Grid.reload({
		ClassName : "DHCDoc.Chemo.CFG.ChgReason",
		QueryName : "QryReason",
		TplDR: TplDR,
		InFlag: InFlag
	});
}
