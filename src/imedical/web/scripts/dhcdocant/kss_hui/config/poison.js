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
	//Ժ��
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
		{field:'phpoDesc',title:'���Ʒ���',width:100},
		{field:'hospName',title:'Ժ��',width:100},
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
						text:'����',
						id:'i-add',
						iconCls: 'icon-add'
				},
				{
						text:'�޸�',
						id:'i-edit',
						iconCls: 'icon-write-order'
				},{
						text:'ɾ��',
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
		title:'��ӹ��Ʒ���',
		width:460,height:400,
		CallBackFunc:callback
	})
}

function editConfig () {
	var selected = PLObject.m_Grid.getSelected();
	if (!selected) {
		$.messager.alert("��ʾ", "��ѡ��һ�У�", "info");
		return false;
	}
	var InHosp = PLObject.m_Hosp.getValue()||session['LOGON.HOSPID'];
	var pid = selected.id;
	var phpo = selected.cPhpo;
	var URL = "dhcant.kss.config.poison.edit.csp?pid="+pid+"&InHosp="+InHosp+"&phpo="+phpo;
	websys_showModal({
		url:URL,
		title:'�޸Ĺ��Ʒ���',
		width:460,height:400,
		CallBackFunc:callback
	})
}

function deleteConfig () {
	var selected = PLObject.m_Grid.getSelected();
	if (!selected) {
		$.messager.alert("��ʾ", "��ѡ��һ�У�", "info");
		return false;
	}
	
	$.messager.confirm("��ʾ", "ȷ��ɾ����",function (r) {
		if (r) {
			$m({
				ClassName:"DHCAnt.KSS.Config.PoisonSet",
				MethodName:"Delete",
				pid:selected.id
			}, function(result){
				if (result == 0) {
					$.messager.alert("��ʾ", "ɾ���ɹ���", "info");
					findConfig();
					return true;
				} else {
					$.messager.alert("��ʾ", "ɾ��ʧ�ܣ�" + result , "info");
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
