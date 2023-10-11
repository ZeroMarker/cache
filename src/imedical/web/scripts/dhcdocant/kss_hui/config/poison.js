/**
 * poison.js
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2019-07-16
 * 
 * 
 */
 
$(function() {
	Init();
	InitEvent();
})


function Init(){
	InitCombox();
	InitGrid();
	InitHospList();
	InitCache();
}
function InitCache () {
	var hasCache = $.DHCDoc.ConfigHasCache();
	if (hasCache!=1) {
		$.DHCDoc.CacheConfigPage();
		$.DHCDoc.storageConfigPageCache();
	}
}
function InitEvent () {
	$("#i-find").click(findConfig);
	$("#i-add").click(addConfig);
	$("#i-edit").click(editConfig);
	$("#i-delete").click(deleteConfig);
}

function InitCombox() {
	//院区
	/* PLObject.m_Hosp = $HUI.combobox("#i-hosp", {
		url:$URL+"?ClassName=DHCAnt.KSS.Config.Authority&QueryName=QryHosp&ResultSetType=array",
		valueField:'id',
		textField:'text',
		value:session['LOGON.HOSPID'],
		blurValidValue:true,
		onSelect: function () {
			findConfig();
		}
	}); */	
}

function InitGrid(){
	var columns = [[
		{field:'phpoDesc',title:'管制分类',width:100},
		{field:'hospName',title:'院区',width:100},
		{field:'id',title:'id',width:100,hidden:true}
	]]
	var DataGrid = $HUI.datagrid("#i-list", {
		fit : true,
		striped : true,
		border:false,
		singleSelect : true,
		fitColumns : true,
		rownumbers:false,
		//autoRowHeight : false,
		//pagination : true,  
		//headerCls:'panel-header-gray',
		//pageSize:14,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "DHCAnt.KSS.Config.PoisonSet",
			QueryName : "QryPoison",
			InHosp: session['LOGON.HOSPID']
		},
		onSelect: function (rowIndex, rowData) {
			
		},
		toolbar:[
				{
						text:'新增',
						id:'i-add',
						iconCls: 'icon-add'
				},
				{
						text:'修改',
						id:'i-edit',
						iconCls: 'icon-write-order'
				},{
						text:'删除',
						id:'i-delete',
						iconCls: 'icon-cancel'
				}
					
		],
		columns :columns
	});
	
	PLObject.m_Grid = DataGrid;
}


function clearCondition() {
	
	PageLogicObj.m_obj.select("");
	PageLogicObj.m_level.setValue("");
	PageLogicObj.m_item.setValue("");
	PageLogicObj.m_type.setValue("");
	PageLogicObj.m_arcim.setValue("");
	$("#i-hidden-arcim").val("");
	$("#i-active").checkbox("check");
	
}

function findConfig () {
	var InHosp = PLObject.m_Hosp.getValue()||"";
	PLObject.m_Grid.reload({
		ClassName : "DHCAnt.KSS.Config.PoisonSet",
		QueryName : "QryPoison",
		InHosp:InHosp
	});
}

function addConfig () {
	var InHosp = PLObject.m_Hosp.getValue()||session['LOGON.HOSPID'];
	var URL = "dhcant.kss.config.poison.edit.csp?InHosp="+InHosp;
	websys_showModal({
		url:URL,
		title:'添加管制分类',
		width:460,height:400,
		CallBackFunc:callback
	})
}

function editConfig () {
	var selected = PLObject.m_Grid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择一行！", "info");
		return false;
	}
	var InHosp = PLObject.m_Hosp.getValue()||session['LOGON.HOSPID'];
	var pid = selected.id;
	var phpo = selected.cPhpo;
	var URL = "dhcant.kss.config.poison.edit.csp?pid="+pid+"&InHosp="+InHosp+"&phpo="+phpo;
	websys_showModal({
		url:URL,
		title:'修改管制分类',
		width:460,height:400,
		CallBackFunc:callback
	})
}

function deleteConfig () {
	var selected = PLObject.m_Grid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择一行！", "info");
		return false;
	}
	
	$.messager.confirm("提示", "确认删除？",function (r) {
		if (r) {
			$m({
				ClassName:"DHCAnt.KSS.Config.PoisonSet",
				MethodName:"Delete",
				pid:selected.id
			}, function(result){
				if (result == 0) {
					$.messager.alert("提示", "删除成功！", "info");
					findConfig();
					return true;
				} else {
					$.messager.alert("提示", "删除失败：" + result , "info");
					return false;
				}
			});
		}
		
	});
	
}

function callback () {
	findConfig();
}

function InitHospList() {
	PLObject.m_Hosp = GenHospComp("Ant_Config_Func_PoisonSet");
	PLObject.m_Hosp.jdata.options.onSelect = function(rowIndex,data){
		findConfig();
		//InitData(data.HOSPRowId);
	}
	PLObject.m_Hosp.jdata.options.onLoadSuccess= function(data){
		findConfig();
		//InitData(session['LOGON.HOSPID']);
	}
}
