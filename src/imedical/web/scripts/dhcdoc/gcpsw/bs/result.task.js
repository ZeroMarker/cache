/**
 * result.task.js
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
	InitGrid();
	InitCombox();
}
function InitEvent () {
	$("#Find").click(Find_Handle)
	$("#Clear").click(Clear_Handle)
}
function InitPLObject() {
	PLObject.m_Prj="";
}

function InitCombox() {
	PLObject.m_Prj = $HUI.combobox("#prj", {
		url:$URL+"?ClassName=DHCDoc.GCPSW.CFG.Prj&QueryName=QryPrj&UserID="+session['LOGON.USERID']+"&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		blurValidValue:true
	});
}

function InitGrid(){
	var columns = [[
		{field:'type',title:'����',width:100},
		{field:'prjDesc',title:'��Ŀ',width:100},
		{field:'startDate',title:'��ʼ����',width:100},
		{field:'startTime',title:'��ʼʱ��',width:100},
		{field:'endDate',title:'�������',width:100},
		{field:'endTime',title:'���ʱ��',width:100},
		{field:'id',title:'id',width:100,hidden:true}
	]]
	var toolbar =[	
				
		] 
	var DataGrid = $HUI.datagrid("#i-list", {
		fit : true,
		striped : true,
		border:false,
		singleSelect : true,
		fitColumns : true,
		rownumbers:false,
		//autoRowHeight : false,
		pagination : true,  
		//headerCls:'panel-header-gray',
		//pageSize:14,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "DHCDoc.GCPSW.BS.TaskLog",
			QueryName : "QryLog"
		},
		onSelect: function (rowIndex, rowData) {
			PLObject.v_RID = rowData.id;
		},
		toolbar:toolbar,
		columns :columns,
		onLoadSuccess: function (data) {
		    if (data.rows.length == 0) {}
		    else {
		        //$(this).datagrid("selectRow", 0);
		    }
		}

	});
	
	PLObject.m_Grid = DataGrid;
}
function Clear_Handle () {
	PLObject.m_Prj.clear();
	$("#startDate").datebox("setValue","");
	$("#endDate").datebox("setValue","");
	Find_Handle();
}
function Find_Handle () {
	var InPrj = PLObject.m_Prj.getValue()||"";
	var InSDate = $("#startDate").datebox("getValue")||"";
	var InEDate = $("#endDate").datebox("getValue")||"";
	PLObject.m_Grid.reload({
		ClassName : "DHCDoc.GCPSW.BS.TaskLog",
		QueryName : "QryLog",
		InPrj:InPrj,
		InSDate:InSDate,
		InEDate:InEDate
	})
}