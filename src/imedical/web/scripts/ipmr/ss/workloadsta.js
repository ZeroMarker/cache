/**
 * workloadsta 工作量统计
 * 
 * Copyright (c) 2018-2019 liyi. All rights reserved.
 * 
 * CREATED BY liyi 2020-05-13
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
	Common_ComboToMrType("cboMrType",ServerObj.MrClass);
	InitgridWorkLoad();
}

function InitEvent(){
	$HUI.combobox('#cboMrType',{
		onSelect:function(rows){
			InitgridWorkLoad(rows["ID"]);
		}
	});

	$('#btnQry').click(function(){
		ReloadgridWorkLoad()
	});
	
	$('#btnExport').click(function(){
		var data = $('#gridWorkLoad').datagrid('getData');
		if (data.rows.length==0)
		{
			$.messager.popover({msg: '请先查询再导出！',type: 'alert',timeout: 1000});
			return;
		}
		$('#gridWorkLoad').datagrid('Export', {
			filename: '工作量统计',
			extension:'xls'
		});
	});
	$('#dtl_export').click(function(){
		DetailExport();
	});
}
 /**
 * NUMS: M001
 * CTOR: liyi
 * DESC: 迟归统计
 * DATE: 2020-05-13
 * NOTE: 包括方法：InitgridWorkLoad，ReloadgridWorkLoad
 * TABLE: 
 */
function InitgridWorkLoad(aMrType){
	$cm({
    	ClassName:"CT.IPMR.BTS.WorkFlowSrv",
    	QueryName:"QryWFItemList",
		aMrTypeID:aMrType,
		aOperaList:'',
		page:1,					 //可选项，页码，默认1
    	rows:50					 //可选项，获取多少条数据，默认50
    },function(rs){
    	var columns = [[
			{field: 'UserDesc',title: $g('操作员'), width: 150, align: 'left'}
		]]
		for (i=0;i<rs.rows.length ;i++){
			if (rs.rows[i].SysOpera=='I') continue;
			var ItemDesc = rs.rows[i].WFItemDesc
			var ItemID = rs.rows[i].WFItemID
			var ItemIndex = rs.rows[i].ItemIndex
			var colitem  = {field: 'Item'+(ItemIndex),title: ItemDesc,titleID: ItemID, width: 150, align: 'left',
				formatter:function(value,row,index){
					if (value=="") return "";
					var tField	= this.field;
					var tValue	= row[tField];
					var tWFItemID = this.titleID;
					var tUserID = row['UserID'];
					
					var btn='<a href="#" onclick="InitDetails(\'' + tUserID+'\',\''+ tWFItemID + '\')">'+tValue+'</a>';
					return btn;
				}
			}
			/*
			var colitem  = {field: 'Item'+(i+1),title: ItemDesc, width: 150, align: 'left',
				formatter:function(value,row,index) {
					return '<a href="#" class="grid-td-text-gray" onclick = showDtl(' + value + ')>' + value + '</a>'; 
				}
			}
			*/
			columns[0].push(colitem);
		}
		var gridWorkLoad = $HUI.datagrid("#gridWorkLoad",{
			fit:true,
			//title:"工作量统计",
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
				ClassName:"MA.IPMR.SSService.WorkLoadSrv",
				QueryName:"QryWorkLoad",
				aHospID:$("#cboHospital").combobox('getValue'),
				aMrTypeID:$("#cboMrType").combobox('getValue'),
				aDateFrom:$("#dfDateFrom").datebox('getValue'),
				aDateTo:$("#dfDateTo").datebox('getValue'),
				rows:10000
			},
			columns :columns
		});
    });
}


function ReloadgridWorkLoad(){
	$('#gridWorkLoad').datagrid('load',  {
		ClassName:"MA.IPMR.SSService.WorkLoadSrv",
		QueryName:"QryWorkLoad",
		aHospID:$("#cboHospital").combobox('getValue'),
		aMrTypeID:$("#cboMrType").combobox('getValue'),
		aDateFrom:$("#dfDateFrom").datebox('getValue'),
		aDateTo:$("#dfDateTo").datebox('getValue'),
		rows:10000
	});
	$('#gridWorkLoad').datagrid('unselectAll');
	
	globalObj.HospID	= $("#cboHospital").combobox('getValue');
	globalObj.MrTypeID	= $("#cboMrType").combobox('getValue');
	globalObj.DateFrom	= $("#dfDateFrom").datebox('getValue');
	globalObj.DateTo	= $("#dfDateTo").datebox('getValue');
}

function InitDetails(aUser,aWFItemID){
	var columns = [[
		//{field:'IsChecked',checkbox:true},	PapmiNo
		{field:'PapmiNo',title:'登记号',width:160,align:"left"},
		{field:'PatName',title:'姓名',width:100,align:"left"},
		{field:'SMMrNo',title:'病案号',width:160,align:"left"},
		{field:'Sex',title:'性别',width:60,align:"left"},
		{field:'Age',title:'年龄',width:60,align:"left"},
		{field:'AdmitDate',title:'入院日期',width:200,align:"left"},
		{field:'DischDate',title:'出院日期',width:200,align:"left"},
		{field:'BackDate',title:'回收日期',width:120,align:"left"},
		{field:'DischDeptDesc',title:'出院科室',width:180,align:"left"},
		{field:'DischWardDesc',title:'出院病区',width:180,align:"left"},
		{field:'OperDate',title:'操作日期',width:120,align:"left"},
		{field:'OperTime',title:'操作时间',width:120,align:"left"}
	]];
	var gridWorkDetail = $HUI.datagrid("#gridWorkDetail",{
		fit:true,
		title:"",
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		rownumbers: true,		//如果为true, 则显示一个行号列
		singleSelect:true,
		autoRowHeight: false,	//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		fitColumns:true,		//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		checkOnSelect:true,		//true,击某一行时，选中/取消选中复选框
		selectOnCheck:true,		//true,点击复选框将会选中该行
		url:$URL,
		queryParams:{
		    ClassName:"MA.IPMR.SSService.WorkLoadSrv",
			QueryName:"StatWorkloadDtl",
			aHospID		:globalObj.HospID,
			aMrTypeID	:globalObj.MrTypeID,
			aDateFrom	:globalObj.DateFrom,
			aDateTo		:globalObj.DateTo,
			aWFItemID	:aWFItemID,
			aUserID		:aUser,
			rows:10000
		},
		columns :columns
	})
	 var WorkDetailDialog = $('#WorkDetailDialog').dialog({
	    title: '详情',
		iconCls:'icon-w-list',
	    width: 1200,
        height: 560,
	    minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
	    closed: false,
	    cache: false,
	    modal: true
	});
	//$('#WorkDetailWindow').window('open');
}

function DetailExport(){
	var data = $('#gridWorkDetail').datagrid('getData');
	if (data.rows.length==0)
	{
		$.messager.popover({msg: '请先查询再导出！',type: 'alert',timeout: 1000});
		return;
	}
	$('#gridWorkDetail').datagrid('Export', {
		filename: '工作量统计详情',
		extension:'xls'
	});
}