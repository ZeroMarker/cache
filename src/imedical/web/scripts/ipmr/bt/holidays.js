/**
 * holidays 节假日维护
 * 
 * Copyright (c) 2018-2019 WHui. All rights reserved.
 * 
 * CREATED BY WHui 2019-10-18
 * 
 * 注解说明
 * TABLE: CT.IPMR.BT.Holidays
 */

// 页面全局变量
var globalObj = {
	m_gridDate : '',
	m_gridHolidays : '',
	m_gridWeekend : ''
}

$(function(){
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
})

function Init(){
	$('#dfDateFrom').datebox('setValue', (new Date()).getFullYear()+'-01-01');	// 给日期框赋值
	$('#dfDateTo').datebox('setValue', (new Date()).getFullYear()+'-12-31');	// 给日期框赋值
	globalObj.m_gridDate = InitgridDate();
	globalObj.m_gridHolidays = InitgridHolidays();
	globalObj.m_gridWeekend = InitgridWeekend();
}

function InitEvent(){
	$('#addH_btn').click(function(){addDatesTo('H')});
	$('#addW_btn').click(function(){addDatesTo('WEND')});
	
	$('#update_holiday_btn').click(function(){editDate('H')});
	$('#del_holiday_btn').click(function(){deleteDate('H')});
	
	$('#update_weekend_btn').click(function(){editDate('WEND')});
	$('#del_weekend_btn').click(function(){deleteDate('WEND')});
	
	$('#btnSearch').click(function(){SearchDate()});
	$('#btnInit').click(function(){InitDate()});
}

 /**
 * NUMS: H001
 * CTOR: WHui
 * DESC: 节假日维护
 * DATE: 2019-10-18
 * NOTE: 包括七个方法：InitgridDate,InitgridHolidays,InitgridWeekend,addDatesTo,editDate,deleteDate,saveDate
 * TABLE: CT_IPMR_BT.Holidays
 */

// 初始化待选日期表格
function InitgridDate(){
	var onlyweekendflag=($('#onlyweekendflagF').checkbox('getValue')==true?'Y':'N')  //获取复选框控件的值
	var datefrom=$('#dfDateFrom').datebox('getValue');	//获取日期控件的值
	var dateto=$('#dfDateTo').datebox('getValue');		//获取日期控件的值
	
	var columns = [[
		{field:'myDate',title:'日期',width:180,align:'left'},
		{field:'Weekendflag',title:'是否周末',width:150,align:'left',
			formatter:function(value,row,index){
				if(value=='Y'){
					return "<font color='#21ba45'>是</font>"
				}else if(value=='N'){
					return "<font color='#f16e57'>否</font>"
				}else{return "";}
			}
		},
		{field:'whatDay',title:'星期',width:120,hidden:true,align:'left'},
	]];
	var gridDate = $HUI.datagrid("#gridDate",{
		title:"待选日期",
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true,		//如果为true, 则显示一个行号列
		singleSelect:false,
		autoRowHeight: false,	//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		fitColumns:true,		//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		url:$URL,
		queryParams:{
		    ClassName:"CT.IPMR.BTS.HolidaysSrv",
			QueryName:"QryAllDays",
			aDateFrom:datefrom,
			aDateTo:dateto,
			onlyweekendflag:"",
			rows:10000
		},
		columns :columns,
		frozenColumns:[[ {field:'ck',checkbox:true}]],//多选框,位置固定在最左边
		/* toolbar:[{
			text:'新增到节日',
			id:'addH_btn',
			iconCls: 'icon-add'
		},{
			text:'新增到假日',
			id:'addW_btn',
			iconCls: 'icon-add'
		}] */
	})
	$HUI.checkbox("[id='onlyweekendflagF']",{
		onChecked:function(e,value){
			$('#gridDate').datagrid('load',{ 
				ClassName:"CT.IPMR.BTS.HolidaysSrv",
				QueryName:"QryAllDays",
				aDateFrom:datefrom,
				aDateTo:dateto,
				onlyweekendflag:($('#onlyweekendflagF').checkbox('getValue')==true?'Y':'N'),
				rows:10000
			});
			$('#gridDate').datagrid('unselectAll');
		},
		onUnchecked:function(e,value){
			$('#gridDate').datagrid('load',{
				ClassName:"CT.IPMR.BTS.HolidaysSrv",
				QueryName:"QryAllDays",
				aDateFrom:datefrom,
				aDateTo:dateto,
				onlyweekendflag:($('#onlyweekendflagF').checkbox('getValue')==true?'Y':'N'),
				rows:10000
			});
			$('#gridDate').datagrid('unselectAll');
		}
	});
}

// 初始化节日表格
function InitgridHolidays(){
	var datefrom=$('#dfDateFrom').datebox('getValue');	//获取日期控件的值
	var dateto=$('#dfDateTo').datebox('getValue');		//获取日期控件的值
	
	var columns = [[
		{field:'Date',title:'日期',width:120,align:'left'},
		{field:'Name',title:'名称',width:120,align:'left'},
		{field:'Alias',title:'别名',width:120,align:'left'}
		//,{field:'whatDay',title:'星期',width:120,align:'left'}
	]];
	var gridHolidays = $HUI.datagrid("#gridHolidays",{
		title:"已选节假日列表",
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true,		//如果为true, 则显示一个行号列
		singleSelect:true,
		autoRowHeight: false,	//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		fitColumns:true,		//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		url:$URL,
		queryParams:{
		    ClassName:"CT.IPMR.BTS.HolidaysSrv",
			QueryName:"QryHWend",
			aDateFrom:datefrom,
			aDateTo:dateto,
			aType:"H",
			rows:10000
		},
		columns :columns,
		toolbar:[{
			text:'修改',
			id:'update_holiday_btn',
			iconCls: 'icon-write-order'
		},{
			text:'删除',
			id:'del_holiday_btn',
			iconCls: 'icon-cancel'
		}],
		onDblClickRow:function(rowIndex,rowData){
		    editDate('H');
		}
	})
}

// 初始化假日表格
function InitgridWeekend(){
	var datefrom=$('#dfDateFrom').datebox('getValue');	//获取日期控件的值
	var dateto=$('#dfDateTo').datebox('getValue');		//获取日期控件的值
	
	var columns = [[
		{field:'Date',title:'日期',width:120,align:'left'},
		{field:'Name',title:'名称',width:120,align:'left'},
		{field:'Alias',title:'别名',width:120,align:'left'}
	]];
	var gridWeekend = $HUI.datagrid("#gridWeekend",{
		title:"已选假日(周末...)",
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true,		//如果为true, 则显示一个行号列
		singleSelect:true,
		autoRowHeight: false,	//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		fitColumns:true,		//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		url:$URL,
		queryParams:{
		    ClassName:"CT.IPMR.BTS.HolidaysSrv",
			QueryName:"QryHWend",
			aDateFrom:datefrom,
			aDateTo:dateto,
			aType:"WEND",
			rows:10000
		},
		columns :columns,
		toolbar:[{
			text:'修改',
			id:'update_weekend_btn',
			iconCls: 'icon-write-order'
		},{
			text:'删除',
			id:'del_weekend_btn',
			iconCls: 'icon-cancel'
		}],
		onDblClickRow:function(rowIndex,rowData){
		    editDate('WEND');
		}
	})
}

// 选中待选日期,添加到节日|假日
function addDatesTo(op){
	var rows = $('#gridDate').datagrid('getSelections');  		//取得所有选中行数据，返回元素记录的数组数据
	if (rows.length>0) {
		for (var i = 0; i < rows.length; i++) {
			// rows[i]
			var rowArray = rows[i];
			var id		= '';
			var name	= rowArray.whatDay;
			var date	= rowArray.myDate;
			var type	= op;
			var alias	= rowArray.whatDay;
			
			var inputStr = id;
			inputStr += '^' + name;
			inputStr += '^' + date;
			inputStr += '^' + type;
			inputStr += '^' + alias;
			
			var flg = $m({
				ClassName:"CT.IPMR.BT.Holidays",
				MethodName:"Update",
				aInputStr:inputStr,
				aSeparate:"^"
			},false);
			
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误", "保存失败!", 'error');
				return;
			}
		}
		
		$('#gridDate').datagrid('reload');		// 重新载入当前页面数据  
		$('#gridHolidays').datagrid('reload');
		$('#gridWeekend').datagrid('reload');
		$('#gridDate').datagrid('unselectAll');
		$('#gridHolidays').datagrid('unselectAll');
		$('#gridWeekend').datagrid('unselectAll');
		$.messager.popover({msg: '提交成功！',type:'success',timeout: 1000});
	} else{
		$.messager.popover({msg: '请选择一条记录！',type: 'alert',timeout: 1000});
		return false;
	}
}

// 编辑节|假日
function editDate(op){
	if (op=='H') {
		var selected = $('#gridHolidays').datagrid('getSelected');
	} else{
		var selected = $('#gridWeekend').datagrid('getSelected');
	}
	
	if (!selected) {
		$.messager.popover({msg: '请选择一条记录！',type: 'alert',timeout: 1000});
		return false;
	}
	$('#HWendDialog').css('display','block');
	var _title = "修改节假日",_icon="icon-w-edit"
	
	$("#txtRowId").val(selected.ID);
	$("#hDate").datebox('setValue',selected.Date);
	$("#hName").val(selected.Name);
	$("#hAlias").val(selected.Alias);
	$("#selDateType").combobox('setValue',op);
	
	var HWendDialog = $HUI.dialog('#HWendDialog',{
		title:_title,
		iconCls:_icon,
		modal: true,
		minimizable:false,
		maximizable:false,
		collapsible:false,
		buttons:[{
			text:'保存',
				iconCls:'icon-w-save',
				handler:function(){
					saveDate($('#selDateType').combobox('getValue'));
				}
		},{
			text:'关闭',
			iconCls:'icon-w-close',
			handler:function(){
				$('#HWendDialog').window("close");
			}	
		}]
	});
}

// 删除节|假日
function deleteDate(op){
	if (op=='H') {
		var selected = $('#gridHolidays').datagrid('getSelected');
	} else{
		var selected = $('#gridWeekend').datagrid('getSelected');
	}
	
	if (!selected) {
		$.messager.popover({msg: '请选择一条记录！',type: 'alert',timeout: 1000});
		return false;
	}
	
	var flg = $m({
		ClassName:"CT.IPMR.BT.Holidays",
		MethodName:"DeleteById",
		aId:selected.ID
	},false);

	if (parseInt(flg) <= 0) {
		$.messager.alert("错误", "删除失败!", 'error');
		return;
	}else{
		$('#gridDate').datagrid('reload');		// 重新载入当前页面数据
		$('#gridHolidays').datagrid('reload');
		$('#gridWeekend').datagrid('reload');
		$('#gridDate').datagrid('unselectAll');
		$('#gridHolidays').datagrid('unselectAll');
		$('#gridWeekend').datagrid('unselectAll');
		$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
	}
}

// 编辑日期,保存
function saveDate(op){
	var id		= $("#txtRowId").val();
	var date	= $('#hDate').datebox('getValue');
	var name	= $("#hName").val();
	var alias	= $("#hAlias").val();
	var type	= op;
	
	if (date == '') {
		$.messager.popover({msg: '日期不允许为空！',type: 'alert',timeout: 1000});
		return false;
	}
	if (name == '') {
		$.messager.popover({msg: '名称不允许为空！',type: 'alert',timeout: 1000});
		return false;
	}
	
	var inputStr = id;
	inputStr += '^' + name;
	inputStr += '^' + date;
	inputStr += '^' + type;
	inputStr += '^' + alias;
	
	var flg = $m({
		ClassName:"CT.IPMR.BT.Holidays",
		MethodName:"Update",
		aInputStr:inputStr,
		aSeparate:"^"
	},false);
	
	if (parseInt(flg) <= 0) {
		$.messager.alert("错误", "保存失败!", 'error');
		return;
	}else{
		$.messager.popover({msg: '修改成功！',type:'success',timeout: 1000});
		$('#HWendDialog').window("close");
		// $('#gridDate').datagrid('reload');		// 重新载入当前页面数据
		$('#gridHolidays').datagrid('reload');
		$('#gridWeekend').datagrid('reload');
		$('#gridDate').datagrid('unselectAll');
		$('#gridHolidays').datagrid('unselectAll');
		$('#gridWeekend').datagrid('unselectAll');
	}
}

 /**
 * NUMS: H002
 * CTOR: WHui
 * DESC: 节假日维护
 * DATE: 2019-10-21
 * NOTE: 包括两个方法：SearchDate,InitDate
 * TABLE: CT_IPMR_BT.Holidays
 */
function SearchDate(){
	var datefrom=$('#dfDateFrom').datebox('getValue');	//获取日期控件的值
	var dateto=$('#dfDateTo').datebox('getValue');		//获取日期控件的值
	
	if ((datefrom=="")||(dateto=="")) {
		$.messager.popover({msg: '请选择开始日期和结束日期！',type: 'alert',timeout: 1000});
		return;
	}
	
	// 待选日期列表
	$('#gridDate').datagrid('load',  { 
		ClassName:"CT.IPMR.BTS.HolidaysSrv",
		QueryName:"QryAllDays",
		aDateFrom:datefrom,
		aDateTo:dateto,
		onlyweekendflag:"",
		rows:10000
	});
	$('#gridDate').datagrid('unselectAll');
	// 节日列表
	$('#gridHolidays').datagrid('load',  {
		ClassName:"CT.IPMR.BTS.HolidaysSrv",
		QueryName:"QryHWend",
		aDateFrom:datefrom,
		aDateTo:dateto,
		aType:"H",
		rows:10000
	});
	$('#gridHolidays').datagrid('unselectAll');
	// 假日列表
	$('#gridWeekend').datagrid('load',  {
		ClassName:"CT.IPMR.BTS.HolidaysSrv",
		QueryName:"QryHWend",
		aDateFrom:datefrom,
		aDateTo:dateto,
		aType:"WEND",
		rows:10000
	});
	$('#gridWeekend').datagrid('unselectAll');
}

function InitDate(){
	var flg = $m({
		ClassName:"CT.IPMR.BTS.HolidaysSrv",
		MethodName:"InitDate",
		aYear:''
	},false);
	
	if (parseInt(flg) <= 0) {
		$.messager.alert("错误", "初始化失败!", 'error');
		return;
	}else{
		$('#gridDate').datagrid('reload');		// 重新载入当前页面数据
		$('#gridHolidays').datagrid('reload');
		$('#gridWeekend').datagrid('reload');
		$('#gridDate').datagrid('unselectAll');
		$('#gridHolidays').datagrid('unselectAll');
		$('#gridWeekend').datagrid('unselectAll');
		$.messager.popover({msg: '初始化成功！',type:'success',timeout: 1000});
	}
}