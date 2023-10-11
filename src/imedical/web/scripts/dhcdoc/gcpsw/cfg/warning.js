/**
 * warning.js
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-04-28
 * 
 * 
 */
PLObject = {
	v_PID:""
}
 
$(function() {
	Init();
	InitEvent();
})


function Init(){
	InitPrjGrid();
	InitDrugGrid();
	InitCombox();
}
function InitEvent () {
	$("#FindPrj").click(Find_PrjList)
	$("#FindDrug").click(Find_DrugList)
	$("#desc").bind('keypress',function(event){
    	if(event.keyCode == "13") {
	    	Find_PrjList();
	    }
            
    });
    
    $("#DrugAdd").click(DrugAdd_Handle)
    $("#DrugEdit").click(DrugEdit_Handle)
    $("#DrugDel").click(DrugDel_Handle)
    $("#View").click(View_Handle)
}
function InitPLObject() {
	PLObject.m_Prj="";
}

function InitCombox() {
	PLObject.m_Type = $HUI.combobox("#type", {
		url:$URL+"?ClassName=DHCDoc.GCPSW.CFG.Warning&QueryName=QryType&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		blurValidValue:true
	});
}

function InitPrjGrid(){
	var columns = [[
		{field:'code',title:'��Ŀ����',width:100},
		{field:'desc',title:'��Ŀ����',width:100},
		{field:'createLoc',title:'�������',width:100},
		{field:'startUser',title:'������',width:100},
		{field:'status',title:'��Ŀ״̬',width:100},
		{field:'IsPITeam',title:'IsPITeam',width:100,hidden:true},
		{field:'id',title:'id',width:100,hidden:true}
	]]
	var toolbar =[	
		] 
	var DataGrid = $HUI.datagrid("#i-prj", {
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
			ClassName : "DHCDoc.GCPSW.CFG.Warning",
			QueryName : "QryGCP",
			UserID:session['LOGON.USERID']
		},
		onSelect: function (rowIndex, rowData) {
			PLObject.v_PID = rowData.id;
			Find_DrugList()
		},
		columns :columns,
		onLoadSuccess: function (data) {
			PLObject.v_PID = "";
			Find_DrugList();
		}

	});
	
	PLObject.m_PrjGrid = DataGrid;
}

function InitDrugGrid(){
	var columns = [[
		{field:'typeDesc',title:'��������',width:60},
		{field:'item',title:'������Ŀ',width:150},
		{field:'msg',title:'Ԥ����Ϣ',width:150},
		{field:'note',title:'��ע',width:50},
		//{field:'PID',title:'PID',width:50},
		{field:'id',title:'id',width:100,hidden:true}
	]]
	var toolbar =[	
			{
				text:'����',
				id:'DrugAdd',
				iconCls: 'icon-add'
			}
			,
			{
				text:'�޸�',
				id:'DrugEdit',
				iconCls: 'icon-write-order'
			}
			,{
				text:'ɾ��',
				id:'DrugDel',
				iconCls: 'icon-cancel'
			},{
				text:'Ԥ��',
				id:'View',
				iconCls: 'icon-write-order'
			}
		] 
	var DataGrid = $HUI.datagrid("#i-drug", {
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
			ClassName : "DHCDoc.GCPSW.CFG.Warning",
			QueryName : "QryMsg"
		},
		onSelect: function (rowIndex, rowData) {
			//PLObject.v_RID = rowData.id;
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
	
	PLObject.m_DrugGrid = DataGrid;
}

function Clear_Handle () {
	PLObject.m_Prj.clear();
	$("#startDate").datebox("setValue","");
	$("#endDate").datebox("setValue","");
	Find_Handle();
}
function Find_DrugList () {
	var InType = PLObject.m_Type.getValue()||"";
	PLObject.m_DrugGrid.reload({
		ClassName : "DHCDoc.GCPSW.CFG.Warning",
		QueryName : "QryMsg",
		PID:PLObject.v_PID,
		InType:InType
	})
}
function Find_PrjList () {
	var InDesc = $.trim($("#desc").val())
	PLObject.m_PrjGrid.reload({
		ClassName : "DHCDoc.GCPSW.CFG.Warning",
		QueryName : "QryGCP",
		InDesc:InDesc,
		UserID:session['LOGON.USERID']
	})
	//PLObject.v_PID = "";
	//Find_DrugList();
}

function DrugAdd_Handle() {
	var PID = PLObject.v_PID;
	if (PID=="") {
		$.messager.alert("��ʾ", "��ѡ����Ŀ��", "info");
		return false;
	}
	var URL = "gcpsw.cfg.warning.edit.csp?PID="+PID;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-add',
		title:'��ӽ���ҩ����',
		width:780,height:400,
		CallBackFunc:Find_DrugList
	})
}
function DrugEdit_Handle() {
	var selected = PLObject.m_DrugGrid.getSelected();
	if (!selected) {
		$.messager.alert("��ʾ", "��ѡ��һ�У�", "info");
		return false;
	}
	var PID = PLObject.v_PID;
	var URL = "gcpsw.cfg.warning.edit.csp?PID="+PID+"&WID="+selected.id;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-edit',
		title:'�޸Ľ���ҩ����',
		width:780,height:400,
		CallBackFunc:Find_DrugList
	})
}
function DrugDel_Handle() {
	var selected = PLObject.m_DrugGrid.getSelected();
	if (!selected) {
		$.messager.alert("��ʾ", "��ѡ��һ�У�", "info");
		return false;
	}
	
	$.messager.confirm("��ʾ", "ȷ��ɾ����",function (r) {
		if (r) {
			$m({
				ClassName:"DHCDoc.GCPSW.CFG.Warning",
				MethodName:"Delete",
				WID:selected.id
			}, function(result){
				if (result == 0) {
					$.messager.alert("��ʾ", "ɾ���ɹ���", "info");
					Find_DrugList();
					return true;
				} else {
					$.messager.alert("��ʾ", "ɾ��ʧ�ܣ�" + result , "info");
					return false;
				}
			});
		}
		
	});
}

function View_Handle() {
	var selected = PLObject.m_DrugGrid.getSelected();
	if (!selected) {
		$.messager.alert("��ʾ", "��ѡ��һ�У�", "info");
		return false;
	}
	var PID = selected.PID,
		WID = selected.id;
	$m({
		ClassName:"DHCDoc.GCPSW.CFG.Warning",
		MethodName:"GetViewInfo",
		PID:PID,
		WID:WID
	}, function(result){
		if (result !="") {
			$.messager.alert("Ԥ��", result, "info");
			
		} 
	});
	
}