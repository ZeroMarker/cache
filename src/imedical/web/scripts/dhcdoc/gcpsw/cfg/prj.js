/**
 * prj.js
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-09-08
 * 
 * 
 */
$(function() {
	Init();
	InitEvent();
	PageHandle();
})


function Init(){
	//InitCombox()
	InitPLObject();
	InitTypeGrid();
	
	InitKPIGrid();
	InitItemGrid();
	SetTypeButton("init");
	SetKPIButton("init");
	SetItemButton("init");
	
	
}
function InitEvent () {
	$("#FindKPI").click(FindKPI)
	$("#FindItem").click(FindItem)
	
	$("#TypeAdd").click(TypeAdd_Handle)
	$("#TypeEdit").click(TypeEdit_Handle)
	$("#TypeDel").click(TypeDel_Handle)
	$("#TypeOK").click(TypeOK_Handle)
	$("#TypeTeam").click(TypeTeam_Handle)
	
	
	
	$("#KPIAdd").click(KPIAdd_Handle)
	$("#KPIEdit").click(KPIEdit_Handle)
	$("#KPIDel").click(KPIDel_Handle)
	
	$("#ItemAdd").click(ItemAdd_Handle)
	$("#ItemEdit").click(ItemEdit_Handle)
	$("#ItemDel").click(ItemDel_Handle)
	
	$("#KPIContent").keyup(function(event){
		var keyCode = event.which || event.keyCode;
		if (keyCode==13) {
			FindKPI()
		}
	})
	$("#ItemContent").keyup(function(event){
		var keyCode = event.which || event.keyCode;
		if (keyCode==13) {
			FindItem()
		}
	})
	/*$('#i-layout').layout('panel', 'center').panel({
		onResize: function (w,h) { 
			if (PLObject.v_KTID=="") {
				hideMask();
				showMask("#i-center","请选择指标类型...");
			}
			
		}
	});*/
}

function PageHandle() {
	//showMask("#i-center","请选择指标类型...")
}
function InitCombox() {
	PLObject.m_TPL = $HUI.combobox("#i-tpl", {
		url:$URL+"?ClassName=DHCDoc.Chemo.CFG.Template&QueryName=QryTPL&ResultSetType=array",
		valueField:'id',
		textField:'name',
		blurValidValue:true,
		onSelect: function () {
			findConfig();
		}
	});
}

function InitPLObject() {
	PLObject.v_PID="";
	PLObject.v_PKID="";
	PLObject.v_IsEdit="";
}

function SetTypeButton(flag) {
	if (flag == "init") {
		var TypeAddOPT = $("#TypeAdd").linkbutton('options');
		var TypeEditOPT = $("#TypeEdit").linkbutton('options');
		var TypeDelOPT = $("#TypeDel").linkbutton('options');
		var TypeOKOPT = $("#TypeOK").linkbutton('options');
		var TypeTeamOPT = $("#TypeTeam").linkbutton('options');
		TypeAddOPT.stopAllEventOnDisabled=true;	
		TypeEditOPT.stopAllEventOnDisabled=true;
		TypeDelOPT.stopAllEventOnDisabled=true;
		TypeOKOPT.stopAllEventOnDisabled=true;
		TypeTeamOPT.stopAllEventOnDisabled=true;
		
		//$("#TypeAdd").linkbutton('disable');
		$("#TypeEdit").linkbutton('disable');	
		$("#TypeDel").linkbutton('disable');	
		$("#TypeOK").linkbutton('disable');	
		$("#TypeTeam").linkbutton('disable');	
		
	} else if (flag == "disable") {
		$("#TypeAdd").linkbutton('disable');
		$("#TypeEdit").linkbutton('disable');	
		$("#TypeDel").linkbutton('disable');	
		$("#TypeOK").linkbutton('disable');	
		$("#TypeTeam").linkbutton('disable');	
	} else if (flag == "enable") {
		$("#TypeAdd").linkbutton('enable');
		$("#TypeEdit").linkbutton('enable');	
		$("#TypeDel").linkbutton('enable');	
		$("#TypeOK").linkbutton('enable');	
		$("#TypeTeam").linkbutton('enable');	
	} else {}
}

function SetKPIButton(flag) {
	if (flag == "init") {
		var KPIAddOPT = $("#KPIAdd").linkbutton('options');
		var KPIEditOPT = $("#KPIEdit").linkbutton('options');
		var KPIDelOPT = $("#KPIDel").linkbutton('options');
		
		KPIAddOPT.stopAllEventOnDisabled=true;	
		KPIEditOPT.stopAllEventOnDisabled=true;
		KPIDelOPT.stopAllEventOnDisabled=true;
		
		$("#KPIAdd").linkbutton('disable');
		$("#KPIEdit").linkbutton('disable');	
		$("#KPIDel").linkbutton('disable');	
		
		
	} else if (flag == "disable") {
		$("#KPIAdd").linkbutton('disable');
		$("#KPIEdit").linkbutton('disable');	
		$("#KPIDel").linkbutton('disable');	
	} else if (flag == "enable") {
		$("#KPIAdd").linkbutton('enable');
		$("#KPIEdit").linkbutton('enable');	
		$("#KPIDel").linkbutton('enable');	
	} else {}
}

function SetItemButton(flag) {
	if (flag == "init") {
		var ItemAddOPT = $("#ItemAdd").linkbutton('options');
		var ItemEditOPT = $("#ItemEdit").linkbutton('options');
		var ItemDelOPT = $("#ItemDel").linkbutton('options');
		ItemAddOPT.stopAllEventOnDisabled=true;	
		ItemEditOPT.stopAllEventOnDisabled=true;
		ItemDelOPT.stopAllEventOnDisabled=true;
		
		$("#ItemAdd").linkbutton('disable');
		$("#ItemEdit").linkbutton('disable');	
		$("#ItemDel").linkbutton('disable');	
		
		
	} else if (flag == "disable") {
		$("#ItemAdd").linkbutton('disable');
		$("#ItemEdit").linkbutton('disable');	
		$("#ItemDel").linkbutton('disable');	
	} else if (flag == "enable") {
		$("#ItemAdd").linkbutton('enable');
		$("#ItemEdit").linkbutton('enable');	
		$("#ItemDel").linkbutton('enable');	
	} else {}
}

function SetButtonText(id,text) {
	$('#'+id).linkbutton({   
	    iconCls: 'icon-write-order',
	    text:text,
	    stopAllEventOnDisabled:true
	});  

}

function InitTypeGrid(){
	var columns = [[
		{field:'code',title:'代码',width:60},
		{field:'desc',title:'描述',width:100},
		{field:'startDate',title:'开始日期',width:100},
		{field:'endDate',title:'结束日期',width:100},
		{field:'gcpName',title:'科研项目',width:100},
		{field:'addUser',title:'创建人',width:100},
		{field:'addDate',title:'创建日期',width:100},
		{field:'teamView',title:'团队可见',width:100,
			formatter:function(value,row,index){
					if (value == 1) {
						return "<span class='c-ok'>是</span>"
					} else {
						return "<span class='c-no'>否</span>"
					}
				}
		},
		{field:'status',title:'项目状态',width:100},
		{field:'note',title:'备注',width:100},
		//{field:'isEdit',title:'isEdit',width:100},
		{field:'id',title:'id',width:100,hidden:false}
	]]
	var toolbar =[
				{
						text:'新增',
						id:'TypeAdd',
						iconCls: 'icon-add'
				}
				,
				{
						text:'修改',
						id:'TypeEdit',
						iconCls: 'icon-write-order'
				}
				,{
						text:'删除',
						id:'TypeDel',
						iconCls: 'icon-cancel'
				}
				,{
						text:'完成',
						id:'TypeOK',
						iconCls: 'icon-ok'
				}
				,{
						text:'团队可见',
						id:'TypeTeam',
						iconCls: 'icon-write-order'
				}
					
		] 
	var DataGrid = $HUI.datagrid("#list-type", {
		fit : true,
		striped : true,
		border:false,
		singleSelect : true,
		fitColumns : false,
		rownumbers:false,
		//autoRowHeight : false,
		pagination : true,  
		//headerCls:'panel-header-gray',
		//pageSize:14,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "DHCDoc.GCPSW.CFG.Prj",
			QueryName : "QryPrj",
			UserID: session['LOGON.USERID']
		},
		onSelect: function (rowIndex, rowData) {
			//hideMask()
			PLObject.v_IsEdit = rowData.isEdit;
			if (rowData.isEdit==1) {
				SetTypeButton("enable");	
				if (rowData.statusCode == "U") {
					SetKPIButton("disable");
					SetItemButton("disable");
				} else {
					SetKPIButton("enable");
					SetItemButton("enable");
				}
			} else {
				SetTypeButton("disable");
				SetKPIButton("disable");
				SetItemButton("disable");
			}
			
			if (rowData.teamView ==1) {
				SetButtonText("TypeTeam","取消团队可见")
			} else {
				SetButtonText("TypeTeam","团队可见")
			}
			PLObject.v_PID = rowData.id;
			FindKPI();
		},
		toolbar:toolbar,
		columns :columns,
		onLoadSuccess: function (data) {
		    if (data.rows.length == 0) {
		    } else {
		        //$(this).datagrid("selectRow", 0);
		    }
		}
	});
	
	PLObject.m_TypeGrid = DataGrid;
}


function InitKPIGrid(){
	var columns = [[
		{field:'KPIDesc',title:'指标名称',width:80},
		{field:'KPICode',title:'指标代码',width:80},
		{field:'Section',title:'是否区间',width:80,
			formatter:function(value,row,index){
					if (value == "1") {
						return "<span class='c-ok'>是</span>"
					} else {
						return "<span class='c-no'>否</span>"
					}
				}
		},
		{field:'Val',title:'筛选值',width:300},
		{field:'Uom',title:'单位',width:80},
		{field:'KPIType',title:'指标类型',width:80},
		{field:'note',title:'指标备注',width:80},
		{field:'id',title:'id',width:100,hidden:true}
	]]
	var toolbar =[
				{
						text:'新增',
						id:'KPIAdd',
						iconCls: 'icon-add'
				}
				,
				{
						text:'修改',
						id:'KPIEdit',
						iconCls: 'icon-write-order'
				}
				,{
						text:'删除',
						id:'KPIDel',
						iconCls: 'icon-cancel'
				}
					
		] 
	var DataGrid = $HUI.datagrid("#list-kpi", {
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
			ClassName : "DHCDoc.GCPSW.CFG.PrjKPI",
			QueryName : "QryKPI",
			PID: ""
		},
		onSelect: function (rowIndex, rowData) {
			PLObject.v_PKID = rowData.id;
			FindItem();
			if (rowData.KPIType=="检验") {
				$('#i-layout').layout('expand','east');  
			} else {
				$('#i-layout').layout('collapse','east');  
			}
			
		},
		toolbar:toolbar,
		columns :columns
	});
	
	PLObject.m_KPIGrid = DataGrid;
}


function InitItemGrid(){
	var columns = [[
		{field:'kpiType',title:'指标名称',width:80},
		//{field:'kpiName',title:'指标名称',width:80},
		//{field:'kpiCode',title:'指标代码',width:100},
		{field:'section',title:'是否区间',width:80,
			formatter:function(value,row,index){
					if (value == "1") {
						return "<span class='c-ok'>是</span>"
					} else {
						return "<span class='c-no'>否</span>"
					}
				}
		},
		{field:'ruleDesc',title:'匹配规则',width:100},
		{field:'Val',title:'筛选值',width:100},
		{field:'stdVal',title:'标准值',width:100},
		{field:'uom',title:'单位',width:80},
		{field:'note',title:'备注',width:80},
		{field:'id',title:'id',width:100,hidden:true}
	]]
	var toolbar =[
				{
						text:'新增',
						id:'ItemAdd',
						iconCls: 'icon-add'
				}
				,
				{
						text:'修改',
						id:'ItemEdit',
						iconCls: 'icon-write-order'
				}
				,{
						text:'删除',
						id:'ItemDel',
						iconCls: 'icon-cancel'
				}
					
		] 
	var DataGrid = $HUI.datagrid("#list-item", {
		fit : true,
		striped : true,
		border:false,
		singleSelect : true,
		fitColumns : false,
		rownumbers:false,
		//autoRowHeight : false,
		pagination : true,  
		//headerCls:'panel-header-gray',
		//pageSize:14,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "DHCDoc.GCPSW.CFG.PrjKPIItem",
			QueryName : "QryKPI",
			PKID: ""
		},
		onSelect: function (rowIndex, rowData) {
		
		},
		toolbar:toolbar,
		columns :columns
	});
	
	PLObject.m_ItemGrid = DataGrid;
}

//指标类型
function TypeCallBack() {
	FindKPIType();
	PLObject.v_PID="";
	PLObject.v_PKID="";
	FindKPI()
	FindItem();
	SetTypeButton("init");
	SetKPIButton("init");
	SetItemButton("init");
}

function TypeAdd_Handle () {
	var PID = ""
	var URL = "gcpsw.cfg.prj.edit.csp?PID="+PID;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-add',
		title:'添加项目',
		width:380,height:450,
		CallBackFunc:FindKPIType
	})
}


function TypeEdit_Handle () {
	var selected = PLObject.m_TypeGrid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择一行！", "info");
		return false;
	}
	if (selected.statusCode=="U") {
		$.messager.alert("提示", "项目已完成，不能进行修改！", "info");
		return false;
	}
	var URL = "gcpsw.cfg.prj.edit.csp?PID="+selected.id;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-edit',
		title:'修改项目',
		width:380,height:450,
		CallBackFunc: TypeCallBack
	})
}

function TypeDel_Handle () {
	var selected = PLObject.m_TypeGrid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择一行！", "info");
		return false;
	}
	if (selected.statusCode=="U") {
		$.messager.alert("提示", "项目已完成，不能进行删除！", "info");
		return false;
	}
	$.messager.confirm("提示", "确认删除？",function (r) {
		if (r) {
			$m({
				ClassName:"DHCDoc.GCPSW.CFG.Prj",
				MethodName:"Delete",
				PID:selected.id
			}, function(result){
				if (result == 0) {
					$.messager.alert("提示", "删除成功！", "info");
					TypeCallBack();
			
					return true;
				} else {
					$.messager.alert("提示", "删除失败：" + result , "info");
					return false;
				}
			});
		}
		
	});
	
}
function TypeTeam_Handle () {
	var selected = PLObject.m_TypeGrid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择一行！", "info");
		return false;
	}
	var TeamView=1;
	var msg="确认团队所有成员可见？"
	if (selected.teamView=="1") {
		msg = "是否取消团队可见？"
		TeamView = 0;
	}
	$.messager.confirm("提示", msg,function (r) {
		if (r) {
			$m({
				ClassName:"DHCDoc.GCPSW.CFG.Prj",
				MethodName:"TeamView",
				PID:selected.id,
				TeamView:TeamView
			}, function(result){
				if (result == 0) {
					$.messager.alert("提示", "保存成功！", "info");
					
					TypeCallBack();
					
					return true;
				} else {
					$.messager.alert("提示", "保存失败：" + result , "info");
					return false;
				}
			});
		}
		
	});
}
function TypeOK_Handle() {
	var selected = PLObject.m_TypeGrid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择一行！", "info");
		return false;
	}
	if (selected.statusCode=="U") {
		$.messager.alert("提示", "项目已完成！", "info");
		return false;
	}
	
	$.messager.confirm("提示", "确认完成？",function (r) {
		if (r) {
			$m({
				ClassName:"DHCDoc.GCPSW.CFG.Prj",
				MethodName:"OKProject",
				PID:selected.id
			}, function(result){
				if (result == 0) {
					$.messager.alert("提示", "保存成功！", "info");
					TypeCallBack();
					return true;
				} else {
					$.messager.alert("提示", "保存失败：" + result , "info");
					return false;
				}
			});
		}
		
	});
	
	
}
function FindKPIType () {
	PLObject.m_TypeGrid.reload({
		ClassName : "DHCDoc.GCPSW.CFG.Prj",
		QueryName : "QryPrj",
		UserID: session['LOGON.USERID']
	});
}

//指标
function KPIAdd_Handle () {
	var PID = PLObject.v_PID,
		PKID = "";
	var URL = "gcpsw.cfg.prj.kpi.edit.csp?PID="+PID+"&PKID="+PKID;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-add',
		title:'添加指标',
		width:$(window).width()-300,height:600,
		CallBackFunc:FindKPI
	})
}

function KPIEdit_Handle () {
	var selected = PLObject.m_KPIGrid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择一行！", "info");
		return false;
	}
	var PID = PLObject.v_PID;
	var URL = "gcpsw.cfg.prj.kpi.edit.csp?PID="+PID+"&PKID="+selected.id;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-edit',
		title:'修改指标',
		width:$(window).width()-300,height:600,
		CallBackFunc:FindKPI
	})
}

function KPIDel_Handle () {
	var selected = PLObject.m_KPIGrid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择一行！", "info");
		return false;
	}
	
	$.messager.confirm("提示", "确认删除？",function (r) {
		if (r) {
			$m({
				ClassName:"DHCDoc.GCPSW.CFG.PrjKPI",
				MethodName:"Delete",
				PKID:selected.id
			}, function(result){
				if (result == 0) {
					$.messager.alert("提示", "删除成功！", "info");
					FindKPI();
					return true;
				} else {
					$.messager.alert("提示", "删除失败：" + result , "info");
					return false;
				}
			});
		}
		
	});
	
}

function FindKPI () {
	var KPIContent = $.trim($("#KPIContent").val());
	PLObject.m_KPIGrid.reload({
		ClassName : "DHCDoc.GCPSW.CFG.PrjKPI",
		QueryName : "QryKPI",
		PID: PLObject.v_PID,
		KPIContent:KPIContent
	});
}

//子项
function ItemAdd_Handle () {
	var PKID = PLObject.v_PKID,
		PKIID = "";
	var URL = "gcpsw.cfg.prj.item.edit.csp?PKID="+PKID+"&PKIID="+PKIID;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-add',
		title:'添加子项',
		width:400,height:450,
		CallBackFunc:FindItem
	})
}

function ItemEdit_Handle () {
	var selected = PLObject.m_ItemGrid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择一行！", "info");
		return false;
	}
	var PKID = PLObject.v_PKID;
	var URL = "gcpsw.cfg.prj.item.edit.csp?PKID="+PKID+"&PKIID="+selected.id;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-edit',
		title:'修改子项',
		width:400,height:450,
		CallBackFunc:FindItem
	})
}

function ItemDel_Handle () {
	var selected = PLObject.m_ItemGrid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择一行！", "info");
		return false;
	}
	//alert(selected.id)
	$.messager.confirm("提示", "确认删除？",function (r) {
		if (r) {
			$m({
				ClassName:"DHCDoc.GCPSW.CFG.PrjKPIItem",
				MethodName:"Delete",
				PKIID:selected.id
			}, function(result){
				if (result == 0) {
					$.messager.alert("提示", "删除成功！", "info");
					FindItem();
					return true;
				} else {
					$.messager.alert("提示", "删除失败：" + result , "info");
					return false;
				}
			});
		}
		
	});
	
}

function FindItem () {
	var KPIContent = $.trim($("#ItemContent").val());
	PLObject.m_ItemGrid.reload({
		ClassName : "DHCDoc.GCPSW.CFG.PrjKPIItem",
		QueryName : "QryKPI",
		PKID: PLObject.v_PKID,
		KPIContent:KPIContent
	});
}

