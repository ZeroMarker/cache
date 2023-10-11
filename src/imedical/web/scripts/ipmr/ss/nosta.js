/**
 * nosta 号码发放统计
 * 
 * Copyright (c) 2018-2023 liyi. All rights reserved.
 * 
 * CREATED BY liyi 2023-03-28
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
	Common_ComboToHosp("cboHospital",'',Logon.HospID);
	//Common_ComboToHosp("cboHospital",'','');
	Common_ComboToMrType("cboMrType",ServerObj.MrClass);
	InitgridSta();
}

function InitEvent(){
	$('#btnQry').click(function(){
		StaQry()
	});
	$('#btnExport').click(function(){
		var data = $('#gridSta').datagrid('getData');
		if (data.rows.length==0)
		{
			$.messager.popover({msg: '请先查询再导出！',type: 'alert',timeout: 1000});
			return;
		}
		var filename ='号码发放统计';
		$('#gridSta').datagrid('Export', {
			filename: filename,
			extension:'xls'
		});
	});
}
 /**
 * NUMS: M001
 * CTOR: liyi
 * DESC: 号码发放统计
 * DATE: 2023-03-28
 * NOTE: 包括一个方法：InitgridSta
 * TABLE: 
 */
function InitgridSta(){
	var columns = [[
		{field:'locdesc',title:'部门',width:100,align:'left'},
		{field:'Userdesc',title:'用户',width:100,align:'left'},
		{field:'Number',title:'数量',width:100,align:'left'}
	]];
	
	var gridSta = $HUI.datagrid("#gridSta",{
		fit:true,
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true,		//如果为true, 则显示一个行号列
		autoRowHeight: false,	//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		fitColumns:true,		//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		url:$URL,
		columns :columns,
		queryParams:{
		    ClassName:"MA.IPMR.SSService.MrNoSrv",
			QueryName:"QryNoSta",
			aArgInput:'',
			rows:10000
		}
	});
	return gridSta;
}

// 查询
function StaQry(){
	var hospid		= $("#cboHospital").combobox('getValue');
	var mrtype		= $("#cboMrType").combobox('getValue');
	var DateFrom	= $('#dfDateFrom').datebox('getValue');
	var DateTo	= $('#dfDateTo').datebox('getValue');
	if (hospid==''){
		//$.messager.popover({msg: '请选择医院！',type: 'alert',timeout: 1000});
		//return '';
	}
	if (mrtype==''){
		$.messager.popover({msg: '请选择病案类型！',type: 'alert',timeout: 1000});
		return '';
	}
	if (DateFrom==''){
		$.messager.popover({msg: '请选择开始日期！',type: 'alert',timeout: 1000});
		return '';
	}
	if (DateTo==''){
		$.messager.popover({msg: '请选择结束日期！',type: 'alert',timeout: 1000});
		return '';
	}
	$('#gridSta').datagrid('load',  {
		ClassName:"MA.IPMR.SSService.MrNoSrv",
		QueryName:"QryNoSta",
		aHospID:hospid,
		aMrTypeID:mrtype,
		aDateFrom:DateFrom,
		aDateTo:DateTo,
		rows:10000
	});
	$('#gridSta').datagrid('unselectAll');
}