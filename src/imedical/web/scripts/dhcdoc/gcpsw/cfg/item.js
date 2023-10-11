/**
 * item.js
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
	PageHandle();
})


function Init(){
	//InitCombox()
	InitPLObject();
	InitTypeGrid();
	InitKPIGrid();
	
	
}
function InitEvent () {
	$("#FindKPI").click(FindKPI)
	
	$("#TypeAdd").click(TypeAdd_Handle)
	$("#TypeEdit").click(TypeEdit_Handle)
	$("#TypeDel").click(TypeDel_Handle)
	$("#TypeItem").click(TypeItem_Handle)
	
	$("#KPIAdd").click(KPIAdd_Handle)
	$("#KPIEdit").click(KPIEdit_Handle)
	$("#KPIDel").click(KPIDel_Handle)
	
	$("#KPIContent").keyup(function(event){
		var keyCode = event.which || event.keyCode;
		if (keyCode==13) {
			FindKPI()
		}
	})
	
	/*$('#i-layout').layout('panel', 'center').panel({
		onResize: function (w,h) { 
			if (PLObject.v_KTID=="") {
				hideMask();
				showMask("#i-center","请选择子项类型...");
			}
			
		}
	});*/
}

function PageHandle() {
	//showMask("#i-center","请选择子项类型...")
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
	PLObject.v_ITID="";
}

function InitTypeGrid(){
	var columns = [[
		{field:'code',title:'代码',width:150},
		{field:'desc',title:'描述',width:150},
		//{field:'arcim',title:'医嘱项',width:600},
		//{field:'note',title:'备注',width:50},
		/*{field:'active',title:'是否有效',width:50,
			formatter:function(value,row,index){
					if (value == "Y") {
						return "<span class='c-ok'>是</span>"
					} else {
						return "<span class='c-no'>否</span>"
					}
				}
		},*/
		{field:'id',title:'id',width:100,hidden:true}
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
					
		] 
	var DataGrid = $HUI.datagrid("#list-type", {
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
			ClassName : "DHCDoc.GCPSW.CFG.Item",
			QueryName : "QryItem",
			KTID: ServerObj.KTID
		},
		onSelect: function (rowIndex, rowData) {
			hideMask()
			PLObject.v_ITID = rowData.id;
			FindKPI();
		},
		toolbar:toolbar,
		columns :columns,
		onLoadSuccess: function (data) {
		    if (data.rows.length == 0) {
		        //var body = $(this).data().datagrid.dc.body2;
		        //body.find('table tbody').append('<tr><td width="' + body.width() + '" style="height: 25px; text-align: center;" colspan="6">没有数据</td></tr>');
		    }
		    else {
		        $(this).datagrid("selectRow", 0);
		    }
		}
	});
	
	PLObject.m_TypeGrid = DataGrid;
}


function InitKPIGrid(){
	var columns = [[
		{field:'code',title:'指标代码',width:100},
		{field:'name',title:'指标名称',width:150},
		{field:'arcim',title:'医嘱项',width:200},
		{field:'complex',title:'复合指标',width:100,
			formatter:function(value,row,index){
					if (value == "Y") {
						return "<span class='c-ok'>是</span>"
					} else {
						return "<span class='c-no'>否</span>"
					}
				}
		},
		{field:'express',title:'表达式',width:150},
		{field:'note',title:'备注',width:100},
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
		fitColumns : false,
		rownumbers:false,
		//autoRowHeight : false,
		pagination : true,  
		//headerCls:'panel-header-gray',
		//pageSize:14,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "DHCDoc.GCPSW.CFG.ItemKPI",
			QueryName : "QryKPI",
			ITID: PLObject.v_IDID
		},
		onSelect: function (rowIndex, rowData) {
			
		},
		toolbar:toolbar,
		columns :columns
	});
	
	PLObject.m_KPIGrid = DataGrid;
}


//指标类型
function TypeAdd_Handle () {
	var KTID = ServerObj.KTID;
	var URL = "gcpsw.cfg.item.edit.csp?KTID="+KTID;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-add',
		title:'添加子项类型',
		width:370,height:400,
		CallBackFunc:FindKPIType
	})
}

function TypeEdit_Handle () {
	var selected = PLObject.m_TypeGrid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择一行！", "info");
		return false;
	}
	var URL = "gcpsw.cfg.item.edit.csp?KTID="+ServerObj.KTID+"&ITID="+selected.id;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-edit',
		title:'修改子项类型',
		width:370,height:400,
		CallBackFunc:FindKPIType
	})
}

function TypeDel_Handle () {
	var selected = PLObject.m_TypeGrid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择一行！", "info");
		return false;
	}
	
	$.messager.confirm("提示", "确认删除？",function (r) {
		if (r) {
			$m({
				ClassName:"DHCDoc.GCPSW.CFG.Item",
				MethodName:"Delete",
				ITID:selected.id
			}, function(result){
				if (result == 0) {
					$.messager.alert("提示", "删除成功！", "info");
					FindKPIType();
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

function TypeItem_Handle () {
	var selected = PLObject.m_TypeGrid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择一行！", "info");
		return false;
	}
	var URL = "gcpsw.cfg.item.csp?KTID="+selected.id;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-edit',
		title:'子项设置',
		width:$(window).width()-300,height:$(window).height()-200
	})
}

function FindKPIType () {
	PLObject.m_TypeGrid.reload({
		ClassName : "DHCDoc.GCPSW.CFG.Item",
		QueryName : "QryItem",
		KTID:ServerObj.KTID
	});
}

//指标
function KPIAdd_Handle () {
	var ITID = PLObject.v_ITID,
		IKID = "";
	if (ITID == "") {
		$.messager.alert("提示", "请先选择子项类型！", "info");
		return false;
	}
	var URL = "gcpsw.cfg.itemkpi.edit.csp?ITID="+ITID+"&IKID="+IKID;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-add',
		title:'添加子项指标',
		width:380,height:400,
		CallBackFunc:FindKPI
	})
}

function KPIEdit_Handle () {
	var selected = PLObject.m_KPIGrid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择一行！", "info");
		return false;
	}
	var ITID = PLObject.v_ITID;
	if (ITID == "") {
		$.messager.alert("提示", "请先选择子项类型！", "info");
		return false;
	}
	
	var URL = "gcpsw.cfg.itemkpi.edit.csp?ITID="+ITID+"&IKID="+selected.id;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-edit',
		title:'修改子项指标',
		width:380,height:400,
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
				ClassName:"DHCDoc.GCPSW.CFG.ItemKPI",
				MethodName:"Delete",
				IKID:selected.id
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
		ClassName : "DHCDoc.GCPSW.CFG.ItemKPI",
		QueryName : "QryKPI",
		ITID: PLObject.v_ITID,
		KPIContent:KPIContent
	});
}

