/**
 * chgreason.js
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-04-28
 * 
 * 
 */
PLObject = {
	v_CHosp:""
}

$(function() {
	Init();
	InitEvent();
})


function Init(){
	InitHospList();
	InitCombox()
	InitGrid();
	
}

function InitEvent () {
	$("#i-find").click(findConfig);
	$("#i-clear").click(clearConfig)
	$("#i-add").click(addConfig);
	$("#i-edit").click(editConfig);
	$("#i-delete").click(deleteConfig);
	$("#i-flag").checkbox({
		onChecked:function () {
			PLObject.m_TPL.clear();
			PLObject.m_TPL.disable();
			findConfig();
		},
		onUnchecked:function () {
			PLObject.m_TPL.enable();
			findConfig();
		}
	})
}

function InitCombox() {
	PLObject.m_TPL = $HUI.combobox("#i-tpl", {
		url:$URL+"?ClassName=DHCDoc.Chemo.CFG.Template&QueryName=QryTPL&&InActive=Y&ResultSetType=array&InHosp="+GetHospValue(),
		valueField:'id',
		textField:'name',
		blurValidValue:true,
		onSelect: function () {
			findConfig();
		}
	});
}

function InitGrid(){
	var columns = [[
		{field:'reason',title:'变更原因',width:300},
		{field:'tplName',title:'化疗模板',width:100},
		{field:'active',title:'是否有效',width:50,
			formatter:function(value,row,index){
					if (value == "Y") {
						return "<span class='c-ok'>是</span>"
					} else {
						return "<span class='c-no'>否</span>"
					}
				}
		},
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
			ClassName : "DHCDoc.Chemo.CFG.ChgReason",
			QueryName : "QryReason",
			TplDR: "",
			InFlag:"",
			All:1,
			InHosp: GetHospValue()
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

function findConfig () {
	var TplDR = PLObject.m_TPL.getValue()||"";
	var InFlag = $("#i-flag").checkbox("getValue")?"1":"";
	PLObject.m_Grid.reload({
		ClassName : "DHCDoc.Chemo.CFG.ChgReason",
		QueryName : "QryReason",
		TplDR: TplDR,
		InFlag: InFlag,
		InHosp: GetHospValue(),
		All:1
	});
}

function addConfig () {
	var CRID = ""
	var URL = "chemo.cfg.chgreason.edit.csp?CRID="+CRID+"&InHosp="+GetHospValue();
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-add',
		title:'添加变更原因',
		width:370,height:400,
		CallBackFunc:callback
	})
}

function editConfig () {
	var selected = PLObject.m_Grid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择一行！", "info");
		return false;
	}
	var URL = "chemo.cfg.chgreason.edit.csp?CRID="+selected.id+"&InHosp="+GetHospValue();
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-edit',
		title:'修改变更原因',
		width:370,height:400,
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
				ClassName:"DHCDoc.Chemo.CFG.ChgReason",
				MethodName:"Delete",
				CRID:selected.id
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

function clearConfig() {
	PLObject.m_TPL.clear();
	$("#i-flag").checkbox("uncheck")
	findConfig();
}

function InitHospList()
{
	var hospComp = GenHospComp("Doc_BaseConfig_CNMedCode");
	hospComp.jdata.options.onSelect = function(rowIndex,data){
		PLObject.v_CHosp = data.HOSPRowId;
		$("#i-flag").checkbox("uncheck");
		InitCombox();
		findConfig();
		
		
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		//Init();
	}
}

function GetHospValue() {
	if (PLObject.v_CHosp == "") {
		return session['LOGON.HOSPID'];
	}
	
	return PLObject.v_CHosp
}
