/**
 * locdischsta 科室病历统计
 * 
 * Copyright (c) 2018-2023 liyi. All rights reserved.
 * 
 * CREATED BY liyi 2023-04-12
 * 
 * 注解说明
 * TABLE: 
 */
//页面全局变量对象
var globalObj = {
}

$(function(){
	//初始化
	Init();

	//事件初始化
	InitEvent();
})

function Init(){
	var tdateFrom	= Common_GetDate(-7,"");
	var tdateTo		= Common_GetDate(0,"");	
	$('#dfDateFrom').datebox('setValue', tdateTo);		// 给日期框赋值
	$('#dfDateTo').datebox('setValue', tdateTo);			// 给日期框赋值
	Common_ComboToHosp("cboHospital",'',Logon.HospID);
	Common_ComboToMrType("cboMrType",ServerObj.MrClass);
	InitgridDischSta();
	InitgridStaDetail();
}

function InitEvent(){
	$('#btnQry').click(function(){
		ReloadDischSta()
	});
	$('#btnExport').click(function(){
		var data = $('#gridDischSta').datagrid('getData');
		if (data.rows.length==0)
		{
			$.messager.popover({msg: '请先查询再导出！',type: 'alert',timeout: 1000});
			return;
		}
		var filename ='出院病历回收统计';
		$('#gridDischSta').datagrid('exportByJsxlsx', {
			filename: filename,
			extension:'xls'
		});
	});
	$('#btnExportDetail').click(function(){
		var data = $('#gridStaDetail').datagrid('getData');
		if (data.rows.length==0)
		{
			$.messager.popover({msg: '请先查询再导出！',type: 'alert',timeout: 1000});
			return;
		}
		var SelectedSta =  $('#gridDischSta').datagrid('getSelected')
		var filename ='出院病历回收统计明细-'+SelectedSta.LocDesc;
		$('#gridStaDetail').datagrid('exportByJsxlsx', {
			filename: filename,
			extension:'xls'
		});
	});
}
 /**
 * NUMS: M001
 * CTOR: liyi
 * DESC: 统计汇总
 * DATE: 2023-04-13
 * NOTE: 包括方法：InitgridDischSta，ReloadDischSta
 * TABLE: 
 */
function InitgridDischSta(){
	var columns = [[
		{field:'LocDesc',title:'科室',width:150,align:'left',sortable:true},
		{field:'NotBackNum',title:'未回收数',width:80,align:'left',sortable:true},
		{field:'BackNum',title:'回收数',width:100,align:'left',sortable:true},
		{field:'DisNum',title:'出院总数',width:100,align:'left',sortable:true}
	]];
	var gridDischSta = $HUI.datagrid("#gridDischSta",{
		fit:true,
		title:"汇总",
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		singleSelect:true,
		pagination: true, 		//如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true,		//如果为true, 则显示一个行号列
		autoRowHeight: false,	//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		fitColumns:true,		//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		url:$URL,
		queryParams:{
		    ClassName:"MA.IPMR.SSService.VolDischQry",
			QueryName:"QryLocDischSta",
			aHospID:$("#cboHospital").combobox('getValue'),
			aMrTypeID:$("#cboMrType").combobox('getValue'),
			aDateFrom:$("#dfDateFrom").datebox('getValue'),
			aDateTo:$("#dfDateTo").datebox('getValue'),
			aLocID:'',
			aLocNotBackFlag:'',
			rows:10000
		},
		onClickRow:function(rowIndex, rowData){
			var LocID = rowData.LocID;
			ReloadStaDetail(LocID,1);
		},
		onDblClickRow:function(rowIndex, rowData){
			var LocID = rowData.LocID;
			ReloadStaDetail(LocID,'');
		},
		columns :columns
	});
}


function ReloadDischSta(){
	var HospID = $("#cboHospital").combobox('getValue');
	if (HospID==''){
		$.messager.popover({msg: '请选择医院！',type: 'alert',timeout: 1000});
		return;
	}
	var MrType = $("#cboMrType").combobox('getValue');
	if (MrType==""){
		$.messager.popover({msg: '请选择病案类型！',type:'alert',timeout: 1000});
		return
	}
	var discDateFrom = $("#dfDateFrom").combobox('getValue');
	if (discDateFrom==""){
		$.messager.popover({msg: '请选择出院日期！',type:'alert',timeout: 1000});
		return
	}
	var discDateTo = $("#dfDateTo").combobox('getValue');
	if (discDateTo==""){
		$.messager.popover({msg: '请选择结束日期！',type:'alert',timeout: 1000});
		return
	}
	$('#gridDischSta').datagrid('load',  {
		ClassName:"MA.IPMR.SSService.VolDischQry",
		QueryName:"QryLocDischSta",
		aHospID:$("#cboHospital").combobox('getValue'),
		aMrTypeID:$("#cboMrType").combobox('getValue'),
		aDateFrom:$("#dfDateFrom").datebox('getValue'),
		aDateTo:$("#dfDateTo").datebox('getValue'),
		aLocID:'',
		aLocNotBackFlag:'',
		rows:10000
	});
	$('#gridDischSta').datagrid('unselectAll');
}

 /**
 * NUMS: M002
 * CTOR: liyi
 * DESC: 科室明细
 * DATE: 2023-04-13
 * NOTE: 包括方法：InitgridStaDetaila，ReloadStaDetail
 * TABLE: 
 */
function InitgridStaDetail(){
	var columns = [[
		{field:'PatName',title:'姓名',width:80,align:'left',sortable:true},
		{field:'PapmiNo',title:'登记号',width:100,align:'left',sortable:true},
		{field:'MrNo',title:'病案号',width:80,align:'left',sortable:true},
		{field:'Sex',title:'性别',width:60,align:'left',sortable:true},
		{field:'Age',title:'年龄',width:60,align:'left',sortable:true},
		{field:'AdmDate',title:'入院日期',width:100,align:'left',sortable:true},
		{field:'DischDate',title:'出院日期',width:100,align:'left',sortable:true},
		{field:'LocDesc',title:'出院科室',width:150,align:'left',sortable:true},
		{field:'BackDate',title:'回收日期',width:100,align:'left',sortable:true}
	]];
	var gridStaDetail = $HUI.datagrid("#gridStaDetail",{
		fit:true,
		title:"明细",
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		singleSelect:true,
		pagination: true, 		//如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true,		//如果为true, 则显示一个行号列
		autoRowHeight: false,	//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		fitColumns:true,		//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		url:$URL,
		queryParams:{
		    ClassName:"MA.IPMR.SSService.VolDischQry",
			QueryName:"QryLocDischSta",
			aHospID:$("#cboHospital").combobox('getValue'),
			aMrTypeID:$("#cboMrType").combobox('getValue'),
			aDateFrom:'',
			aDateTo:'',
			aLocID:'',
			aLocNotBackFlag:'',
			rows:10000
		},
		columns :columns
	});
}


function ReloadStaDetail(LocID,NotBackFlag){
	var HospID = $("#cboHospital").combobox('getValue');
	if (HospID==''){
		$.messager.popover({msg: '请选择医院！',type: 'alert',timeout: 1000});
		return;
	}
	var MrType = $("#cboMrType").combobox('getValue');
	if (MrType==""){
		$.messager.popover({msg: '请选择病案类型！',type:'alert',timeout: 1000});
		return
	}
	var discDateFrom = $("#dfDateFrom").combobox('getValue');
	if (discDateFrom==""){
		$.messager.popover({msg: '请选择出院日期！',type:'alert',timeout: 1000});
		return
	}
	var discDateTo = $("#dfDateTo").combobox('getValue');
	if (discDateTo==""){
		$.messager.popover({msg: '请选择结束日期！',type:'alert',timeout: 1000});
		return
	}
	$('#gridStaDetail').datagrid('load',  {
		ClassName:"MA.IPMR.SSService.VolDischQry",
		QueryName:"QryLocDischSta",
		aHospID:$("#cboHospital").combobox('getValue'),
		aMrTypeID:$("#cboMrType").combobox('getValue'),
		aDateFrom:$("#dfDateFrom").datebox('getValue'),
		aDateTo:$("#dfDateTo").datebox('getValue'),
		aLocID:LocID,
		aLocNotBackFlag:NotBackFlag,
		rows:10000
	});
	$('#gridStaDetail').datagrid('unselectAll');
}