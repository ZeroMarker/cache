/**
 * vollatepapersta 出院患者病历归档完整率统计
 * 
 * Copyright (c) 2018-2019 liyi. All rights reserved.
 * 
 * CREATED BY liyi 2021-05-13
 * 
 * 注解说明
 * TABLE: 
 */
//页面全局变量对象
var globalObj = {
	m_QryType:''
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
	Common_ComboToLocGroup('cboLocgroup','E','-');
	
	// 医院、科室、病区联动
	$HUI.combobox('#cboHospital',{
		onSelect:function(rows){
			var LocGroup = $("#cboLocgroup").combobox('getValue');
			Common_ComboToLoc("cboDiscLoc","","E",rows["HospID"],ServerObj.MrClass,LocGroup);			// 科室
		}
	});

	// 科室组、科室联动
	$('#cboLocgroup').combobox({
	    onSelect:function(rows){
	    	var Hosp = $("#cboHospital").combobox('getValue');
			Common_ComboToLoc('cboDiscLoc','','E',Hosp,ServerObj.MrClass,rows["ID"]);
	    }
	})
	
	InitgridLatePaperSta();
}

function InitEvent(){
	$('#btnQry').click(function(){
		ReloadgridLatePaperSta()
	});
	
	$('#btnExport').click(function(){
		var data = $('#gridLatePaperSta').datagrid('getData');
		if (data.rows.length==0)
		{
			$.messager.popover({msg: '请先查询再导出！',type: 'alert',timeout: 1000});
			return;
		}
		$('#gridLatePaperSta').datagrid('Export', {
			filename: '出院患者病历归档完整率',
			extension:'xls'
		});
	});

}
 /**
 * NUMS: M001
 * CTOR: liyi
 * DESC: 出院患者病历归档完整率
 * DATE: 2021-05-13
 * NOTE: 包括方法：
 * TABLE: 
 */
function InitgridLatePaperSta(){
	var columns = [[
		{field: 'StatLocDesc',title: '科室', width: 150, align: 'left'},
		{field: 'DischCnt',title: '同期出院患者病历总数', width: 60, align: 'left'},
		{field: 'NotLateCnt',title: '归档病历内容完整的出院患者病历数', width: 80,  align: 'left'},
		{field: 'NotLateRatio', title: '出院患者病历归档完整率', width: 80, align: 'left'}
	]];	
	var gridLatePaperSta = $HUI.datagrid("#gridLatePaperSta",{
		fit:true,
		//title:"出院患者病历归档完整率",
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
		    ClassName:"MA.IPMR.SSService.VolLatePaperSrv",
			QueryName:"QryLatePaperSta",
			aHospID:$("#cboHospital").combobox('getValue'),
			aMrTypeID:$("#cboMrType").combobox('getValue'),
			aDateFrom:$("#discDateFrom").datebox('getValue'),
			aDateTo:$("#discDateTo").datebox('getValue'),
			aLocGrpID:$("#cboLocgroup").combobox('getValue'),
			aLocID:$("#cboDiscLoc").combobox('getValue'),
			rows:10000
		},
		columns :columns
	});
}


function ReloadgridLatePaperSta(){
	$('#gridLatePaperSta').datagrid('load',  {
		ClassName:"MA.IPMR.SSService.VolLatePaperSrv",
		QueryName:"QryLatePaperSta",
		aHospID:$("#cboHospital").combobox('getValue'),
		aMrTypeID:$("#cboMrType").combobox('getValue'),
		aDateFrom:$("#discDateFrom").datebox('getValue'),
		aDateTo:$("#discDateTo").datebox('getValue'),
		aLocGrpID:$("#cboLocgroup").combobox('getValue'),
		aLocID:$("#cboDiscLoc").combobox('getValue'),
		rows:10000
	});
	$('#gridLatePaperSta').datagrid('unselectAll');
}