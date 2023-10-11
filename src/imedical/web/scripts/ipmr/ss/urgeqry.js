/**
 * urgeqry 病案逾期统计
 * 
 * Copyright (c) 2018-2023 liyi. All rights reserved.
 * 
 * CREATED BY liyi 2023-03-30
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
	$('#discDateFrom').datebox('setValue', tdateTo);		// 给日期框赋值
	$('#discDateTo').datebox('setValue', tdateTo);			// 给日期框赋值
	Common_ComboToHosp("cboHospital",'',Logon.HospID);
	Common_ComboToMrType("cboMrType",ServerObj.MrClass);
	InitgridResult();
}

function InitEvent(){
	$('#btnQry').click(function(){
		ReloadResult()
	});
	$('#btnExport').click(function(){
		var data = $('#gridResult').datagrid('getData');
		if (data.rows.length==0)
		{
			$.messager.popover({msg: '请先查询再导出！',type: 'alert',timeout: 1000});
			return;
		}
		var filename ='病案逾期统计';
		$('#gridResult').datagrid('Export', {
			filename: filename,
			extension:'xls'
		});
	});
	
	$('#btnPrint').click(function(){
		var data = $('#gridResult').datagrid('getData');
		if (data.rows.length==0)
		{
			$.messager.popover({msg: '请先查询再打印！',type: 'alert',timeout: 1000});
			return;
		}
		var title ='病案逾期统计';
		$('#gridResult').datagrid('print', {
			title: title,
			model: '1',	// 通过后台
			columns:['MrNo','PatName','DischLocDesc','DocName','DischDate','BackDate','Workdays','OverWorkdays','Money']
		});
	});
}
 /**
 * NUMS: M001
 * CTOR: liyi
 * DESC: 出院病历
 * DATE: 2020-05-13
 * NOTE: 包括方法：InitgridDischVol，ReloadVol
 * TABLE: 
 */
function InitgridResult(){
	var columns = [[
		{field:'DischLocDesc',title:'科室',width:120,align:'left',sortable:true},
		{field:'MrNo',title:'病案号',width:80,align:'left',sortable:true},
		{field:'PatName',title:'姓名',width:100,align:'left',sortable:true},
		{field:'DocName',title:'主管医生',width:100,align:'left',sortable:true},		
		{field:'DischDate',title:'出院日期',width:120,align:'left',sortable:true},
		{field:'BackDate',title:'回收日期',width:120,align:'left',sortable:true},
		{field:'Workdays',title:'工作日数',width:100,align:'left',sortable:true},
		{field:'OverWorkdays',title:'逾期工作日数',width:100,align:'left',sortable:true},
		{field:'Money',title:'罚款金额',width:100,align:'left',sortable:true},
		{field:'dischVolCnt',title:'出院人数',width:80,align:'left',sortable:true}
	]];
	var gridResult = $HUI.datagrid("#gridResult",{
		fit:true,
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		singleSelect:false,
		pagination: true, 		//如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true,		//如果为true, 则显示一个行号列
		autoRowHeight: false,	//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		fitColumns:true,		//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		url:$URL,
		queryParams:{
		    ClassName:"MA.IPMR.SSService.UrgeQry",
			QueryName:"QryUrge",
			aHospID:$("#cboHospital").combobox('getValue'),
			aMrTypeID:$("#cboMrType").combobox('getValue'),
			aDateFrom:$("#discDateFrom").datebox('getValue'),
			aDateTo:$("#discDateTo").datebox('getValue'),
			aWorkDays:$("#txtWorkDays").val(),
			aPenalty:$("#txtPenalty").val(),
			aIsRetrieve:$("#cboIsRetrieve").combobox('getValue'),
			rows:10000
		},
		columns :columns
	});
}


function ReloadResult(){
	var MrType = $("#cboMrType").combobox('getValue');
	if (MrType==""){
		$.messager.popover({msg: '请选择病案类型！',type:'alert',timeout: 1000});
		return
	}
	var discDateFrom = $("#discDateFrom").combobox('getValue');
	if (discDateFrom==""){
		$.messager.popover({msg: '请选择出院日期！',type:'alert',timeout: 1000});
		return
	}
	var discDateTo = $("#discDateTo").combobox('getValue');
	if (discDateTo==""){
		$.messager.popover({msg: '请选择结束日期！',type:'alert',timeout: 1000});
		return
	}
	$('#gridResult').datagrid('load',  {
		ClassName:"MA.IPMR.SSService.UrgeQry",
		QueryName:"QryUrge",
		aHospID:$("#cboHospital").combobox('getValue'),
		aMrTypeID:$("#cboMrType").combobox('getValue'),
		aDateFrom:$("#discDateFrom").datebox('getValue'),
		aDateTo:$("#discDateTo").datebox('getValue'),
		aWorkDays:$("#txtWorkDays").val(),
		aPenalty:$("#txtPenalty").val(),
		aIsRetrieve:$("#cboIsRetrieve").combobox('getValue'),
		rows:10000
	});
	$('#gridResult').datagrid('unselectAll');
}
