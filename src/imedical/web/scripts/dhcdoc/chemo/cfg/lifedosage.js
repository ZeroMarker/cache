/**
 * lifedosage.js
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-04-28
 * 
 * 
 */
PLObject = {
	v_Arcim: ""
}
$(function() {
	Init();
	InitEvent();
})


function Init(){
	InitCombox()
	InitGrid();
	
}

function InitEvent () {
	$("#i-find").click(findConfig);
	$("#i-clear").click(clearConfig)
	$("#i-add").click(addConfig);
	$("#i-edit").click(editConfig);
	$("#i-delete").click(deleteConfig);
}

function InitCombox() {
	Combox_ItemDesc();
}

function Combox_ItemDesc(){
	$("#i-drug").lookup({
		width:300,
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'ArcimDR',
        textField:'ArcimDesc',
        columns:[[  
           {field:'ArcimDesc',title:'����',width:320,sortable:true},
            {field:'ArcimDR',title:'ID',width:70,sortable:true}
        ]],
        pagination:true,
        panelWidth:400,
        panelHeight:400,
        isCombo:true,
        minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'DHCDoc.THPY.COM.Qry',QueryName: 'FindMasterItem'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
	        if (desc=="") return false;
			param = $.extend(param,{arcimdesc:desc});
	    },onSelect:function(ind,item){
		   PLObject.v_Arcim = item.ArcimDR;
		}
    });
}

function InitGrid(){
	var columns = [[
		{field:'arcimDesc',title:'ҽ������',width:300},
		{field:'dosage',title:'����',width:100},
		{field:'uomDesc',title:'������λ',width:100},
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
		pagination : true,  
		//headerCls:'panel-header-gray',
		//pageSize:14,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "DHCDoc.Chemo.CFG.LifeDose",
			QueryName : "QryLifeDosage",
			InArcim: ""
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

function findConfig () {
	PLObject.m_Grid.reload({
		ClassName : "DHCDoc.Chemo.CFG.LifeDose",
		QueryName : "QryLifeDosage",
		InArcim: PLObject.v_Arcim
	});
}

function addConfig () {
	var LDID = ""
	var URL = "chemo.cfg.lifedosage.edit.csp?LDID="+LDID;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-add',
		title:'��ӻ���ҩƷ�������',
		width:400,height:400,
		CallBackFunc:callback
	})
}

function editConfig () {
	var selected = PLObject.m_Grid.getSelected();
	if (!selected) {
		$.messager.alert("��ʾ", "��ѡ��һ�У�", "info");
		return false;
	}
	var URL = "chemo.cfg.lifedosage.edit.csp?LDID="+selected.id;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-edit',
		title:'�޸Ļ���ҩƷ�������',
		width:400,height:400,
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
				ClassName:"DHCDoc.Chemo.CFG.LifeDose",
				MethodName:"Delete",
				LDID:selected.id
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

function clearConfig() {
	PLObject.v_Arcim = "";
	$("#i-drug").lookup("setText","");
	findConfig();
}
