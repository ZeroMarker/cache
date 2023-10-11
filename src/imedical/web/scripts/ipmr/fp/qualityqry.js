/**
 * fpinfoqry 编目质控查询
 * 
 * Copyright (c) 2018-2020 liyi. All rights reserved.
 * 
 * CREATED BY likai 2022-12-29
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
	var tdateFrom	= Common_GetDate(-10,"");
	var tdateTo		= Common_GetDate(0,"");	
	$('#DateFrom').datebox('setValue', tdateFrom);		// 给日期框赋值
	$('#DateTo').datebox('setValue', tdateTo);			// 给日期框赋值
	
	Common_ComboToHosp("cboHospital",'',Logon.HospID);
	Common_ComboToMrType("cboMrType",ServerObj.MrClass);
	Common_ComboToLocGroup('cboLocgroup','E','-');
	Common_ComboGridToUser("cboCodeUser","");
	//Common_ComboToDic('cboCodeUser',"CreatUser",1,'');
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
	    onSelect:function(rows){
	    	var Hosp = $("#cboHospital").combobox('getValue');
			Common_ComboToLoc("cboDiscWard","","W",Hosp,'','',rows["ID"]);			// 病区
	    },
	    onChange:function(rows){
	    	var Hosp = $("#cboHospital").combobox('getValue');
	    	var LocID = $("#cboDiscLoc").combobox('getValue');
			Common_ComboToLoc("cboDiscWard","","W",Hosp,'','',LocID);			// 病区
	    }
	})
	Common_ComboToDic("cboDateType","QualityLogDateType",1,'');
	InitgridVol();
}

function InitEvent(){
	// 查询
	$('#btnQry').click(function(){
		ReloadVol();
	});
	$('#btnExport').click(function(){
		var data = $('#gridVol').datagrid('getData');
		if (data.rows.length==0)
		{
			$.messager.popover({msg: '请先查询在导出！',type: 'alert',timeout: 1000});
			return;
		}
		$('#gridVol').datagrid('Export', {
			filename: '编码质控',
			extension:'xls'
		});
	});
	
	// 病案号回车事件
	$('#txtInputNo').keyup(function(e){
		if(event.keyCode == 13) {
	      ReloadVol();
	    }
	});
}
/**
 * NUMS: M001
 * CTOR: likai
 * DESC: 编目质控数据
 * DATE: 2022-12-29
 * NOTE: 包括方法：InitgridVol，ReloadVol
 * TABLE: 
 */
function InitgridVol(){
	var columns = [[
		{field:'MrNo',title:'病案号',width:100,align:'left',sortable:'true'},
		{field:'PapmiNo',title:'登记号',width:100,align:'left'},
		{field:'PatName',title:'姓名',width:90,align:'left'},
		//{field:'EpisodeID',title:'就诊号',width:90,align:'left'},
		{field:'DischLocDesc',title:'出院科室',width:150,align:'left'},
		{field:'DischWardDesc',title:'出院病区',width:150,align:'left'},
		{field:'DischDate',title:'出院日期',width:100,align:'left'},
		{field:'ActUser',title:'编码员',width:90,align:'left'},
		{field:'ActDate',title:'质控日期',width:150,align:'left',
			formatter:function(value,row,index){
				var ret='';
				var ActDate	 = row["ActDate"];
				var ActTime	 = row["ActTime"];
				ret = ActDate+' '+ActTime;
				return ret;
			}
		},
		{field:'ForceInfo',title:'强制质控',width:300,align:'left'},
		{field:'TipInfo',title:'提示质控',width:300,align:'left'}
	]];
	var gridVol = $HUI.datagrid("#gridVol",{
		fit:true,
		//title:"编目质控查询",
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		//singleSelect:true,
		pagination: true, 		//如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true,		//如果为true, 则显示一个行号列
		autoRowHeight: true,	//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 500,
		pageList:[100,200,500,1000],
		fitColumns:false,		//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		checkOnSelect:true,		//true,击某一行时，选中/取消选中复选框
		selectOnCheck:true,		//true,点击复选框将会选中该行
		url:$URL,
		queryParams:{
		    ClassName:"MA.IPMR.FPS.DataMasterSrv",
			QueryName:"QryQualityInfo",
			aHospID:$("#cboHospital").combobox('getValue'),
			aMrTypeID:$("#cboMrType").combobox('getValue'),
			aDateType: $('#cboDateType').combobox('getValue'),
			aDateFrom:$("#DateFrom").datebox('getValue'),
			aDateTo:$("#DateTo").datebox('getValue'),
			aLocGroup:$("#cboLocgroup").combobox('getValue'),
			aLocID:$("#cboDiscLoc").combobox('getValue'),
			aWardID:$("#cboDiscWard").combobox('getValue'),
			aCodeUser:$("#cboCodeUser").combobox('getValue'),
			aInputNo:$("#txtInputNo").val(),
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
		ClassName:"MA.IPMR.FPS.DataMasterSrv",
		QueryName:"QryQualityInfo",
		aHospID:$("#cboHospital").combobox('getValue'),
		aMrTypeID:$("#cboMrType").combobox('getValue'),
		aDateType: $('#cboDateType').combobox('getValue'),
		aDateFrom:$("#DateFrom").datebox('getValue'),
		aDateTo:$("#DateTo").datebox('getValue'),
		aLocGroup:$("#cboLocgroup").combobox('getValue'),
		aLocID:$("#cboDiscLoc").combobox('getValue'),
		aWardID:$("#cboDiscWard").combobox('getValue'),
		aCodeUser:CodeUser,
		aInputNo:$("#txtInputNo").val(),
		rows:10000
	}); 
	$('#gridVol').datagrid('unselectAll');
}

					