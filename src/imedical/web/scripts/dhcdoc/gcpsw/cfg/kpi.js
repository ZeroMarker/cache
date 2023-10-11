/**
 * kpi.js
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
	PLObject.v_KTID="";
}

function InitTypeGrid(){
	var columns = [[
		{field:'code',title:'代码',width:100},
		{field:'desc',title:'描述',width:150},
		{field:'note',title:'备注',width:100},
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
				,{
						text:'子项设置',
						id:'TypeItem',
						iconCls: 'icon-write-order'
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
			ClassName : "DHCDoc.GCPSW.CFG.KPIType",
			QueryName : "QryKPIType"
		},
		onSelect: function (rowIndex, rowData) {
			hideMask()
			PLObject.v_KTID = rowData.id;
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
		        //$(this).datagrid("selectRow", 0);
		    }
		}

	});
	
	PLObject.m_TypeGrid = DataGrid;
}


function InitKPIGrid(){
	var columns = [[
		{field:'code',title:'指标代码',width:100},
		{field:'name',title:'指标名称',width:150},
		{field:'complex',title:'复合指标',width:100,
			formatter:function(value,row,index){
					if (value == "Y") {
						return "<span class='c-ok'>是</span>"
					} else {
						return "<span class='c-no'>否</span>"
					}
				}
		},
		{field:'express',title:'表达式',width:250},
		{field:'note',title:'解析',width:400},
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
			ClassName : "DHCDoc.GCPSW.CFG.KPI",
			QueryName : "QryKPI",
			KTID: ""
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
	var KTID = ""
	var URL = "gcpsw.cfg.kpitype.edit.csp?KTID="+KTID;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-add',
		title:'添加指标类型',
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
	var URL = "gcpsw.cfg.kpitype.edit.csp?KTID="+selected.id;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-edit',
		title:'修改指标类型',
		width:370,height:400,
		CallBackFunc:function () {
			PLObject.v_KTID="";
			FindKPIType();
			FindKPI();
		}
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
				ClassName:"DHCDoc.GCPSW.CFG.KPIType",
				MethodName:"Delete",
				KTID:selected.id
			}, function(result){
				result = result.split("^");
				if (result[0] == 0) {
					$.messager.alert("提示", "删除成功！", "info");
					PLObject.v_KTID="";
					FindKPIType();
					FindKPI();
			
					return true;
				} else  {
					$.messager.alert("提示", result[1] , "error");
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
	if (selected.code!="Lis") {
		$.messager.alert("提示", "只有检验才需要设置子项！", "warning");
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
		ClassName : "DHCDoc.GCPSW.CFG.KPIType",
		QueryName : "QryKPIType"
	});
}

//指标
function KPIAdd_Handle () {
	var KTID = PLObject.v_KTID,
		KPIID = "";
	var URL = "gcpsw.cfg.kpi.edit.csp?KTID="+KTID+"&KPIID="+KPIID;
	if (KTID == "") {
		$.messager.alert("提示", "请先选择指标类型！", "info");
		return false;
	}
	
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-add',
		title:'添加指标',
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
	var KTID = PLObject.v_KTID;
	var URL = "gcpsw.cfg.kpi.edit.csp?KTID="+KTID+"&KPIID="+selected.id;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-edit',
		title:'修改指标',
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
				ClassName:"DHCDoc.GCPSW.CFG.KPI",
				MethodName:"Delete",
				KPIID:selected.id
			}, function(result){
				result = result.split("^");
				if (result[0] == 0) {
					$.messager.alert("提示", "删除成功！", "info");
					FindKPI();
					return true;
				} else {
					$.messager.alert("提示", result[1] , "error");
					return false;
				}
			});
		}
		
	});
	
}

function FindKPI () {
	var KPIContent = $.trim($("#KPIContent").val());
	PLObject.m_KPIGrid.reload({
		ClassName : "DHCDoc.GCPSW.CFG.KPI",
		QueryName : "QryKPI",
		KTID: PLObject.v_KTID,
		KPIContent:KPIContent
	});
}

