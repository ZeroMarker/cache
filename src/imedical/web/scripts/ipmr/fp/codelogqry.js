/**
 * codelogqry 编目日志查询
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
	var tdateFrom	= Common_GetDate(-7,"");
	var tdateTo		= Common_GetDate(0,"");	
	$('#DateFrom').datebox('setValue', tdateTo);		// 给日期框赋值
	$('#DateTo').datebox('setValue', tdateTo);			// 给日期框赋值
	Common_ComboToHosp("cboHospital",'',Logon.HospID);
	Common_ComboToMrType("cboMrType",ServerObj.MrClass);
	Common_ComboToLocGroup('cboLocgroup','E','-');
	Common_ComboGridToUser("cboCodeUser","");
	Common_ComboToDicCode("cboOperType","CodeAction",1,'');
	// 医院、科室、病区联动
	$HUI.combobox('#cboHospital',{
		onSelect:function(rows){
			var LocGroup = $("#cboLocgroup").combobox('getValue');
			Common_ComboToLoc("cboDiscLoc","","E",rows["HospID"],ServerObj.MrClass,LocGroup);			// 科室
			Common_ComboToLoc("cboDiscWard","","W",rows["HospID"],'','');			// 病区
		}
	});

	// 科室组、科室联动
	$('#cboLocgroup').combobox({
	    onSelect:function(rows){
	    	var Hosp = $("#cboHospital").combobox('getValue');
			Common_ComboToLoc('cboDiscLoc','','E',Hosp,ServerObj.MrClass,rows["ID"]);
			Common_ComboToLoc("cboDiscWard","","W",Hosp,'','');			// 病区
	    }
	})
	
	// 科室、病区联动
	$('#cboDiscLoc').combobox({
	    onChange:function(newValue,oldValue){
		    var Hosp = $("#cboHospital").combobox('getValue');
			Common_ComboToLoc("cboDiscWard","","W",Hosp,'','',newValue);			// 病区
	    }
	})
	InitgridVol();
}

function InitEvent(){
	$('#btnQry').click(function(){
		ReloadVol();
	});
}

$('#txtMrNo').bind('keyup', function(event) {
	　　if (event.keyCode == "13") {
			ReloadVol();
	　　}
	});


 /**
 * NUMS: M001
 * CTOR: liyi
 * DESC: 编目病历
 * DATE: 2020-05-13
 * NOTE: 包括方法：InitgridVol，ReloadVol
 * TABLE: 
 */
function InitgridVol(){
	var columns = [[
		{field:'PapmiNo',title:'登记号',width:100,align:'left'},
		{field:'MrNo',title:'病案号',width:100,align:'left'},
		{field:'PatName',title:'姓名',width:120,align:'left'},
		{field:'Sex',title:'性别',width:50,align:'left'},
		{field:'Age',title:'年龄',width:50,align:'left'},
		{field:'VolStausDesc',title:'当前状态',width:80,align:'left'},
		{field:'DischLocDesc',title:'出院科室',width:150,align:'left'},
		{field:'DischWardDesc',title:'出院病区',width:150,align:'left'},
		{field:'DischDate',title:'出院日期',width:100,align:'left'},
		{field:'tmp',title:'编目日志',width:100,align:'left',
			formatter:function(value,row,index) {
            	var MasterID = row.MasterID;
				var DateFrom = row.DateFrom;
				var DateTo = row.DateTo;
               	return '<a href="#" class="grid-td-text-gray" onclick = showLog("' + MasterID + '","' + DateFrom + '","' + DateTo + '")>' + $g('编目日志') + '</a>';            
            }
		}
	]];
	
	var gridVol = $HUI.datagrid("#gridVol",{
		fit:true,
		//title:"编目日志查询",
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
		    ClassName:"MA.IPMR.FPS.CodeLogSrv",
			QueryName:"QryLogVol",
			aHospID:$("#cboHospital").combobox('getValue'),
			aMrTypeID:$("#cboMrType").combobox('getValue'),
			aMrNo:$("#txtMrNo").val(),
			aDateFrom:$("#DateFrom").datebox('getValue'),
			aDateTo:$("#DateTo").datebox('getValue'),
			aLocGroup:$("#cboLocgroup").combobox('getValue'),
			aLocID:$("#cboDiscLoc").combobox('getValue'),
			aWardID:$("#cboDiscWard").combobox('getValue'),
			aCodeUser:'',
			aOperType:'',
			rows:10000
		},
		columns :columns
	});
}


function ReloadVol(){
	var CodeUser="";
	var objCodeUser = $('#cboCodeUser').combogrid('grid').datagrid('getSelected');
		if (objCodeUser!==null){
			var CodeUser = objCodeUser.ID;
		}

	$('#gridVol').datagrid('load',  {
		ClassName:"MA.IPMR.FPS.CodeLogSrv",
		QueryName:"QryLogVol",
		aHospID:$("#cboHospital").combobox('getValue'),
		aMrTypeID:$("#cboMrType").combobox('getValue'),
		aMrNo:$("#txtMrNo").val(),
		aDateFrom:$("#DateFrom").datebox('getValue'),
		aDateTo:$("#DateTo").datebox('getValue'),
		aLocGroup:$("#cboLocgroup").combobox('getValue'),
		aLocID:$("#cboDiscLoc").combobox('getValue'),
		aWardID:$("#cboDiscWard").combobox('getValue'),
		aCodeUser:CodeUser,
		aOperType:$("#cboOperType").combobox('getValue'),
		rows:10000
	});
	$('#gridVol').datagrid('unselectAll');
}

 /**
 * NUMS: M002
 * CTOR: liyi
 * DESC: 编目日志
 * DATE: 2020-05-13
 * NOTE: 包括方法：showLog
 * TABLE: 
 */
function showLog(MasterID,DateFrom,DateTo) {
	var columns = [[
		{field: 'OperDate', title: '日期', width: 100, align: 'left'},
		{field: 'OperTime', title: '时间', width: 100, align: 'left'},
		{field: 'OperType', title: '日志类型', width: 100, align: 'left'},
		{field: 'OperUser', title: '编码员', width: 100, align: 'left'},
		{field:'tmp',title:'变动明细',width:100,align:'left',
			formatter:function(value,row,index) {
				var OperType = row.OperType;
            	var LogID = row.LogID;
				if (OperType=='修改'){
					return '<a href="#" class="grid-td-text-gray" onclick = showLogDtl("' + LogID + '")>' + $g('变动明细') + '</a>';            
				}else{
					return '';     
				}
            }
		}
	]];
	var gridLog = $HUI.datagrid("#gridLog", {
		fit: true,
		iconCls : 'icon-write-order',
		rownumbers : true, 
		singleSelect : true,
		pagination : true, 
		autoRowHeight : false,
		loadMsg : '数据加载中...',
		pageSize : 10,
		fitColumns : true,
		url : $URL,
	    queryParams : {
		    ClassName : "MA.IPMR.FPS.CodeLogSrv",
			QueryName : "QryLogByMaster",
			aMasterID :MasterID,
			aDateFrom:DateFrom,
			aDateTo:DateTo
	    },
	    columns : columns
	});
	var LogDialog = $('#LogDialog').dialog({
	    title: '日志列表',
		iconCls: 'icon-w-list',
	    width: 800,
        height: 560,
	    minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
	    closed: false,
	    cache: false,
	    modal: true
	});
    return LogDialog;
}

 /**
 * NUMS: M003
 * CTOR: liyi
 * DESC: 日志明细
 * DATE: 2020-05-13
 * NOTE: 包括方法：showLogDtl
 * TABLE: 
 */
 function showLogDtl(LogID) {
	var columns = [[
		{field: 'ItemDesc', title: '数据项', width: 100, align: 'left'},
		{field: 'PValue', title: '修改前数据', width: 100, align: 'left'},
		{field: 'Value', title: '修改后数据', width: 100, align: 'left'}
	]];
	var gridLogDtl = $HUI.datagrid("#gridLogDtl", {
		fit: true,
		iconCls : 'icon-write-order',
		rownumbers : true, 
		singleSelect : true,
		pagination : true, 
		autoRowHeight : false,
		loadMsg : '数据加载中...',
		pageSize : 10,
		fitColumns : true,
		url : $URL,
	    queryParams : {
		    ClassName : "MA.IPMR.FPS.CodeLogSrv",
			QueryName : "QryLogDtl",
			aLogID :LogID
	    },
	    columns : columns
	});
	var LogDtlDialog = $('#LogDtlDialog').dialog({
	    title: '修改明细',
		iconCls: 'icon-w-list',
	    width: 600,
        height: 400,
	    minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
	    closed: false,
	    cache: false,
	    modal: true
	});
    return LogDialog;
}