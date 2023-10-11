/**
 * volqry 病案回收质控编目统计
 *
 * CREATED BY niepeng 2022-09-14
 * 
 * 注解说明
 * TABLE: 
 */
//页面全局变量对象
var globalObj = {
	m_QryType:'',
	// add for 欢迎界面点击
	m_wHospID	: ServerObj.wHospID,
	m_wMrTypeID	: ServerObj.wMrTypeID,
	m_wDateFrom	: ServerObj.wDateFrom,
	m_wDateTo	: ServerObj.wDateTo,
}

$(function(){
	//初始化
	Init();

	//事件初始化
	InitEvent();
})

function Init(){
	var tdateFrom	= Common_GetDate("","FIRST");
	var tdateTo		= Common_GetDate("","LAST");	
	$('#discDateFrom').datebox('setValue', tdateFrom);		// 给日期框赋值
	$('#discDateTo').datebox('setValue', tdateTo);			// 给日期框赋值
	Common_ComboToHosp("cboHospital",'',Logon.HospID);
	Common_ComboToMrType("cboMrType",ServerObj.MrClass);
	InitgridLateStatis();
}

function InitEvent(){
	$('#btnQry').click(function(){
		ReloadgridLateStatis()
	});
	
	$('#btnExport').click(function(){
		var data = $('#gridLateStatis').datagrid('getData');
		if (data.rows.length==0)
		{
			$.messager.popover({msg: '请先查询再导出！',type: 'alert',timeout: 1000});
			return;
		}
		$('#gridLateStatis').datagrid('Export', {
			filename: '病案回收质控编目统计',
			extension:'xls'
		});
	});
}

function InitgridLateStatis(){
	if (globalObj.m_wFlg==1){
		$('#cboHospital').combobox('setValue',globalObj.m_wHospID);
		$('#cboMrType').combobox('setValue',globalObj.m_wMrTypeID);
		$('#discDateFrom').datebox('setValue', globalObj.m_wDateFrom);
		$('#discDateTo').datebox('setValue', globalObj.m_wDateTo);
	}
	
	var columns = [[
		{field: 'StatLocDesc',title: '科室', width: 150, align: 'left'},
		{field: 'DischCnt',title: '出院人数', width: 60, align: 'left'},
		{field: 'DisBackCnt',title: '回收人数', width: 80,  align: 'left'},
		{field: 'DisCheckCnt',title: '质控人数', width: 80,  align: 'left'},
		{field: 'DisNotFPCnt',title: '未编目人数', width: 80,  align: 'left'},
		{field: 'DisFPCnt',title: '已编人数', width: 80,  align: 'left'},
		{field: 'Resume',title: '备注', width: 80,  align: 'left'}
	]];	
	var gridLateStatis = $HUI.datagrid("#gridLateStatis",{
		fit:true,
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		singleSelect:true,
		pagination: true, 		//如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true,		//如果为true, 则显示一个行号列
		autoRowHeight: false,	//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 50,
		fitColumns:true,		//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		url:$URL,
		queryParams:{
		    ClassName:"MA.IPMR.FPS.DataMasterSrv",
			QueryName:"QryVolList",
			aHospID:$("#cboHospital").combobox('getValue'),
			aMrTypeID:$("#cboMrType").combobox('getValue'),
			aDateFrom:$("#discDateFrom").datebox('getValue'),
			aDateTo:$("#discDateTo").datebox('getValue'),
			rows:10000
		},
		columns :columns
	});
}


function ReloadgridLateStatis(){
	$('#gridLateStatis').datagrid('load',  {
		ClassName:"MA.IPMR.FPS.DataMasterSrv",
		QueryName:"QryVolList",
		aHospID:$("#cboHospital").combobox('getValue'),
		aMrTypeID:$("#cboMrType").combobox('getValue'),
		aDateFrom:$("#discDateFrom").datebox('getValue'),
		aDateTo:$("#discDateTo").datebox('getValue'),
		rows:10000
	});
	$('#gridLateStatis').datagrid('unselectAll');
}

