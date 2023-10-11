/**
 * lendqry 病案借阅查询
 * 
 * Copyright (c) 2018-2019 WHui. All rights reserved.
 * 
 * CREATED BY WHui 2020-05-19
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
	var tdateFrom	= Common_GetDate("","FIRST");
	var tdateTo		= Common_GetDate("","LAST");	
	$('#aDateFrom').datebox('setValue', tdateFrom);		// 给日期框赋值
	$('#aDateTo').datebox('setValue', tdateTo);			// 给日期框赋值
	Common_ComboToHosp("cboHospital",'',Logon.HospID);
	Common_ComboToMrType("cboMrType",ServerObj.MrClass);
	Common_ComboGridToUser("cboLendUser","");
	InitgridLendCollect();
	InitgridLendVol();

}

function InitEvent(){
	// 医院、科室联动
    $('#cboHospital').combobox({
	    onSelect:function(rows){
			Common_ComboToLoc('cboLoc','','E',rows["HospID"],ServerObj.MrClass,'');
	    }
	})
	$('#btnQry').click(function(){
		QueryCollect()
	});					

	// 导出汇总
	$('#btnExportCollect').click(function(){
		var data = $('#gridLendCollect').datagrid('getData');
		if (data.rows.length==0)
		{
			$.messager.popover({msg: '请先查询再导出！',type: 'alert',timeout: 1000});
			return;
		}
		$('#gridLendCollect').datagrid('Export', {
			filename: '借阅汇总',
			extension:'xls'
		});
	});	

	// 导出明细
	$('#btnExportVol').click(function(){
		var data = $('#gridLendVol').datagrid('getData');
		if (data.rows.length==0)
		{
			$.messager.popover({msg: '请先查询再导出！',type: 'alert',timeout: 1000});
			return;
		}
		$('#gridLendVol').datagrid('Export', {
			filename: '借阅明细',
			extension:'xls'
		});
	});		

}


/**
 
* NUMS: L001
 
* CTOR: WHui
 
* DESC: 病案借阅汇总
 
* DATE: 2019-11-15
 
* NOTE: 包括方法：InitgridLendCollect
 
* TABLE: 
 
*/
function InitgridLendCollect(){
	var columns = [[
		{field:'LendLocDesc',title:'借阅科室',width:150,align:'left'},
		{field:'LendUserDesc',title:'借阅医生',width:100,align:'left'},
		{field:'LendSum',title:'借阅数量',width:80,align:'left'}
	]];
	
	var gridLendCollect = $HUI.datagrid("#gridLendCollect",{
		fit:true,
		title:"借阅汇总",
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: true,		//如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true,		//如果为true, 则显示一个行号列
		singleSelect:true,
		autoRowHeight: false,	//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		fitColumns:true,		//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		url:$URL,
		queryParams:{
		    ClassName:"MA.IPMR.SSService.VolLendQry",
		    QueryName:"QryLendCollect",
		    aHospID:'',
		    aMrTypeID:'',
		    aDateFrom:'',
			aDateTo:'',
			aLendLocID:'',
			aLendUserID:'',
			aIsBack:'',
			aIsOverDate:'',
		    rows:10000
		},
		columns :columns,
		onClickRow:function(rowIndex,rowData){
			if (rowIndex>-1) {
				QueryDetail();
			}
		}
	});
}
 /**
 
 * NUMS: L002
 
 * CTOR: WHui
 
 * DESC: 病案借阅详情
 
 * DATE: 2019-11-15
 
 * NOTE: 包括方法：InitgridLendCollect
 
 * TABLE: 
 
 */
function InitgridLendVol(){
	var columns = [[
		{field:'PapmiNo',title:'登记号',width:100,align:'left'},
		{field:'PatName',title:'姓名',width:100,align:'left'},
		{field:'MrNo',title:'病案号',width:100,align:'left'},
		{field: 'AdmTimes', title: '住院次数', width: 80, align: 'left'},
		{field: 'DocName', title: '主管医生', width:120, align: 'left'},
		{field:'LendLoc',title:'借阅科室',width:150,align:'left'},
		{field:'LendUser',title:'借阅医生',width:80,align:'left'},
		{field:'LendDate',title:'借阅日期',width:100,align:'left'},
		{field:'UserFrom',title:'操作员',width:80,align:'left'},
		{field:'UserTo',title:'验证用户',width:80,align:'left'},
		{field:'BackDate',title:'归还日期',width:100,align:'left'}
	]];
	
	var gridLendVol = $HUI.datagrid("#gridLendVol",{
		fit:true,
		title:"借阅明细",
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: true,		//如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true,		//如果为true, 则显示一个行号列
		singleSelect:true,
		autoRowHeight: false,	//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		fitColumns:true,		//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		url:$URL,
		toolbar: [],
		queryParams:{
		    ClassName:"MA.IPMR.SSService.VolLendQry",
		    QueryName:"QryLendDetail",
		    ArgInput:'',
		    rows:10000
		},
		columns :columns,
		rowStyler:function(index,row){
			
				if(row.BackDate==""){

					//return 'background-color:#ff0000;';		
			}
		
		},

	});
}

// 查询汇总
function QueryCollect(){
	var HospID		= $('#cboHospital').combobox('getValue');
	var MrTypeID	= $('#cboMrType').combobox('getValue');
	var DateFrom	= $('#aDateFrom').datebox('getValue');
	var DateTo		= $('#aDateTo').datebox('getValue');
	var objLendUser = $('#cboLendUser').combogrid('grid').datagrid('getSelected');
	var LendUser ='';
	if (objLendUser!==null){
		LendUser = objLendUser.ID;
	}
	$('#gridLendCollect').datagrid('reload',  {
		ClassName:"MA.IPMR.SSService.VolLendQry",
		QueryName:"QryLendCollect",
		aHospID:HospID,
		aMrTypeID:MrTypeID,
		aDateFrom:DateFrom,
		aDateTo:DateTo,
		aLendLocID:$('#cboLoc').combobox('getValue'),
		aLendUserID:LendUser,
		aIsBack:$('#cboIsBack').combobox('getValue'),
		aIsOverDate:$('#cboIsOverDate').combobox('getValue'),
		rows:10000
	});
	$('#gridLendCollect').datagrid('unselectAll');
	QueryDetail();

}

// 查询详情
function QueryDetail(){
	var selected = $("#gridLendCollect").datagrid('getSelected');
	if (!selected) {
		$('#gridLendVol').datagrid('reload',  {
			ClassName:"MA.IPMR.SSService.VolLendQry",
			QueryName:"QryLendDetailByIds",
			aLendIds:'',
			rows:10000
		});
	}else{
		$('#gridLendVol').datagrid('reload',  {
			ClassName:"MA.IPMR.SSService.VolLendQry",
			QueryName:"QryLendDetailByIds",
			aLendIds:selected.LendIds,
			rows:10000
		});
	}
}