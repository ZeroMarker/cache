/**
 * visit.js
 * 
 * Copyright (c) 2021-2022 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2021-01-15
 * 
 * 
 */
var PLObject = {
	v_DefaultDate:''
}
$(function() {
	Init();
	InitEvent();
})


function Init(){
	InitGrid();
	
}

function InitEvent () {
	$("#Add").click(Add_Handle)
}

function InitGrid(){
	var columns = [[
		{field:'ck',checkbox:true},
		{field:'PPFRowId',hidden:true,title:''},
		{field:'PPFStageDesc',title:'�׶�',width:100},
		{field:'Arcimdesc',title:'ҽ������',width:200},
		{field:'PPFFreeNum',title:'��Ѵ���',width:100,hidden:true},
		{field:'PPFSttDate',title:'��ʼ����',width:100},
		{field:'PPFSttTime',title:'��ʼʱ��',width:100},
		{field:'PPFEndDate',title:'��������',width:100},
		{field:'PPFEndTime',title:'����ʱ��',width:100},
		{field:'PPFLimitEntryAfterNoFreeNum',title:'��Ѵ����þ�������¼��',width:200,hidden:true}
	]]
	var DataGrid = $HUI.datagrid("#VisitGrid", {
		fit : true,
		striped : true,
		border:false,
		singleSelect : false,
		fitColumns : true,
		rownumbers:false,
		//autoRowHeight : false,
		//pagination : true,  
		//headerCls:'panel-header-gray',
		//pageSize:14,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "web.PilotProject.Extend.Visit",
			QueryName : "QryFreeOrd",
			PPRowId: ServerObj.PPRowId,
			InStage: ServerObj.InStage
		},
		onSelect: function (rowIndex, rowData) {
			
		},
		/*toolbar:[
				{
						text:'����',
						id:'Add',
						iconCls: 'icon-add'
				}
					
		],*/
		columns :columns
	});
	
	PLObject.m_Grid = DataGrid;
}
function Find_Handle () {
	var SelectDate = $("#ChemoDate").datebox("getValue")||""
	PLObject.m_Grid.reload({
		ClassName : "DHCDoc.Chemo.BS.Bed.AppList",
		QueryName : "QryAppList",
		SelectDate:SelectDate
	});
}

function Add_Handle () {
	var selectArr = PLObject.m_Grid.getSelections()
	if (selectArr.length == 0) {
		$.messager.alert("��ʾ","��ѡ��һ�м�¼��","warning")
		return false;
	}
	var ArcimList=[];
	for (var i=0; i<selectArr.length; i++) {
		ArcimList.push(selectArr[i].ArcimRowId)	
	}
	ArcimList = ArcimList.join(",")
	websys_showModal("hide");
	websys_showModal('options').CallBackFunc(ArcimList);
	websys_showModal("close");	
}
