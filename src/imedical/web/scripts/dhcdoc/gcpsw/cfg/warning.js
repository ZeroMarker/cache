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
		{field:'code',title:'项目代码',width:100},
		{field:'desc',title:'项目名称',width:100},
		{field:'createLoc',title:'立项科室',width:100},
		{field:'startUser',title:'负责人',width:100},
		{field:'status',title:'项目状态',width:100},
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
		{field:'typeDesc',title:'禁用类型',width:60},
		{field:'item',title:'禁用项目',width:150},
		{field:'msg',title:'预警信息',width:150},
		{field:'note',title:'备注',width:50},
		//{field:'PID',title:'PID',width:50},
		{field:'id',title:'id',width:100,hidden:true}
	]]
	var toolbar =[	
			{
				text:'新增',
				id:'DrugAdd',
				iconCls: 'icon-add'
			}
			,
			{
				text:'修改',
				id:'DrugEdit',
				iconCls: 'icon-write-order'
			}
			,{
				text:'删除',
				id:'DrugDel',
				iconCls: 'icon-cancel'
			},{
				text:'预览',
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
		$.messager.alert("提示", "请选择项目！", "info");
		return false;
	}
	var URL = "gcpsw.cfg.warning.edit.csp?PID="+PID;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-add',
		title:'添加禁用药设置',
		width:780,height:400,
		CallBackFunc:Find_DrugList
	})
}
function DrugEdit_Handle() {
	var selected = PLObject.m_DrugGrid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择一行！", "info");
		return false;
	}
	var PID = PLObject.v_PID;
	var URL = "gcpsw.cfg.warning.edit.csp?PID="+PID+"&WID="+selected.id;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-edit',
		title:'修改禁用药设置',
		width:780,height:400,
		CallBackFunc:Find_DrugList
	})
}
function DrugDel_Handle() {
	var selected = PLObject.m_DrugGrid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择一行！", "info");
		return false;
	}
	
	$.messager.confirm("提示", "确认删除？",function (r) {
		if (r) {
			$m({
				ClassName:"DHCDoc.GCPSW.CFG.Warning",
				MethodName:"Delete",
				WID:selected.id
			}, function(result){
				if (result == 0) {
					$.messager.alert("提示", "删除成功！", "info");
					Find_DrugList();
					return true;
				} else {
					$.messager.alert("提示", "删除失败：" + result , "info");
					return false;
				}
			});
		}
		
	});
}

function View_Handle() {
	var selected = PLObject.m_DrugGrid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择一行！", "info");
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
			$.messager.alert("预览", result, "info");
			
		} 
	});
	
}