/**
 * receiptqry 接诊日志
 * 
 * Copyright (c) 2018-2019 WHui. All rights reserved.
 * 
 * CREATED BY WHui 2019-11-25
 * 
 * 注解说明
 * TABLE: 
 */

//页面全局变量对象
var globalObj = {
	m_gridReceipt		: ''
}

$(function(){
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
})

function Init(){
	var tdateFrom	= Common_GetDate(-30,"");
	var tdateTo		= Common_GetDate(0,"");	
	$('#dfDateFrom').datebox('setValue', tdateTo);		// 给日期框赋值
	$('#dfDateTo').datebox('setValue', tdateTo);			// 给日期框赋值
	Common_ComboToHosp('cboHospital','',Logon.HospID);
	Common_ComboToDicCode("cboAdmType","AdmType",1,"");
	$('#cboAdmType').combobox('setValue',ServerObj.MrClass)
	$('#cboAdmType').combobox('disable');
	globalObj.m_gridReceipt = InitgridReceipt();
}

function InitEvent(){
	// 医院、科室联动
    $('#cboHospital').combobox({
	    onSelect:function(rows){
			Common_ComboToLoc('cboLoc','','E',rows["HospID"],ServerObj.MrClass,'');
	    }
	})

	$('#btnReceiptQry').click(function(){
		ReceiptQry();
		$('#txtMrNo').val('');
		$('#txtRegNo').val('');
	});
	$('#btnNotReceiptQry').click(function(){NotReceiptQry()});
	$('#btnExport').click(function(){Export()});
	
	$('#txtRegNo').bind('keyup', function(event) {
	　　if (event.keyCode == "13") {
	　　　　ReceiptQry();
			$('#txtMrNo').val('');
			$('#txtRegNo').val('');
	　　}
	});
	$('#txtMrNo').bind('keyup', function(event) {
	　　if (event.keyCode == "13") {
	　　　　ReceiptQry();
			$('#txtMrNo').val('');
			$('#txtRegNo').val('');
	　　}
	});
}
 /**
 * NUMS: R001
 * CTOR: WHui
 * DESC: 接诊日志
 * DATE: 2019-11-15
 * NOTE: 包括一个方法：InitgridReceipt
 * TABLE: CT_IPMR_BT.Holidays
 */
function InitgridReceipt(){
	var datefrom=$('#dfDateFrom').datebox('getValue');	//获取日期控件的值
	var dateto=$('#dfDateTo').datebox('getValue');		//获取日期控件的值
	
	var columns = [[
		{field:'PapmiNo',title:'登记号',width:120,align:'left'},
		{field:'MrNo',title:'病案号',width:120,align:'left',
			styler: function(value,row,index){
				var VolumeID	= row.VolumeID;
				var MrNo		= row.MrNo;
				var MrClass		= row.MrClass;
				var ReceiptType	= row.ReceiptType;
				var MainID		= row.MainID;
				
				if (VolumeID==''){
					if ((MrClass == 'O')&&(ReceiptType == 'M')&&(MainID != '')){
						// 门诊病案按病人分号，不需要重复接诊
					} else {
						return 'background-color:pink;';
					}
				}else{
					return MrNo;
				}
			}
		},
		{field:'PatName',title:'姓名',width:120,align:'left'},
		{field:'EpisodeID',title:'操作',width:80,align:'left',type:'btn',
			formatter:function(value,row,index){
				var VolumeID	= row.VolumeID;
				var EpisodeID	= row.EpisodeID;
				var MrNo		= row.MrNo;
				var MrClass		= row.MrClass;
				var ReceiptType	= row.ReceiptType;
				var MainID		= row.MainID;
				
				if (VolumeID == ''){
					if ((MrClass == 'O')&&(ReceiptType == 'M')&&(MainID != '')){
						return "";
					} else {	// GroupReceipt
						return "<a href='#' onclick='GroupReceiptHN(\"" + EpisodeID + "\",\"" + MrNo + "\");'><b>"+$g('接诊')+"</b></a>";
					}
				} else {
					//return "<a href='#' onclick='GroupUnReceipt(\"" + EpisodeID + "\");'>取消接诊</a>";	//屏蔽取消接诊功能
					return "";
				}
			}
		},
		{field:'Sex',title:'性别',width:80,align:'left'},
		{field:'AdmType',title:'就诊类型',width:80,align:'left'},
		{field:'RegDate',title:'登记日期',width:120,align:'left'},
		{field:'RegTime',title:'登记时间',width:120,align:'left'},
		{field:'AdmLoc',title:'入院科室',width:150,align:'left'},
		{field:'AdmWard',title:'入院病区',width:150,align:'left'},
		{field:'AdmDate',title:'入院日期',width:120,align:'left'},
		{field:'AdmTime',title:'入院时间',width:120,align:'left'},
		{field:'VolumeID',title:'VolumeID',hidden:true,order:'asc'}
	]];
	
	var gridReceipt = $HUI.datagrid("#gridReceipt",{
		view: detailview,	// *显示细节*
		fit:true,
		//title:"接诊日志查询",
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
		    ClassName:"MA.IPMR.SSService.ReceiptQry",
			QueryName:"QuryReceiptByDate",
			aHospID:$("#cboHospital").combobox('getValue'),
			aAdmType:$("#cboAdmType").combobox('getValue'),
			aDateFrom:datefrom,
			aDateTo:dateto,
			aLocID:'',
			aRegNo:'',
			rows:10000
		},
		columns :columns,
		detailFormatter:function(index,row){	// *显示细节*
			return '<div style="padding:10px"><table id="ddv-' + index + '"></table></div>';
		},
		onExpandRow:function(index,row){		// *显示细节*
			$('#ddv-'+index).datagrid({
				fit:false,
				rownumbers: true,
				fitColumns:true,		//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
				singleSelect:true,
				height:'auto',
				url:$URL,
				queryParams:{
				    ClassName:"MA.IPMR.SSService.ReceiptLogSrv",
					QueryName:"QryReceiptLog",
					aEpisodeID:row.EpisodeID,
					rows:100
				},
				columns:[[
					{field:'MrTypeDesc',title:'病案类型',width:120,align:'left'},
					{field:'MrNo',title:'病案号',width:120,align:'left'},
					{field:'OperType',title:'操作类别',width:120,align:'left'},
					{field:'RecDateTime',title:'操作时间',width:150,align:'left'},
					{field:'VolumeID',title:'卷ID',width:80,align:'left'}
				]],
				onResize:function(){
					$('#gridReceipt').datagrid('fixDetailRowHeight',index);
				},
				onLoadSuccess:function(){
					setTimeout(function(){
						$('#gridReceipt').datagrid('fixDetailRowHeight',index);
					},0);
				}
			});
			$('#gridReceipt').datagrid('fixDetailRowHeight',index);
		}
	});
}
// 通过查询条件查找
function ReceiptQry(){
	var datefrom	= $('#dfDateFrom').datebox('getValue');	//获取日期控件的值
	var dateto		= $('#dfDateTo').datebox('getValue');		//获取日期控件的值
	var loc			= $("#cboLoc").combobox('getValue');
	var RegNo		= $("#txtRegNo").val();
	var MrNo		= $("#txtMrNo").val();
	
	$('#gridReceipt').datagrid('reload',  {
		ClassName:"MA.IPMR.SSService.ReceiptQry",
		QueryName:"QuryReceiptByDate",
		aHospID:$("#cboHospital").combobox('getValue'),
		aAdmType:$("#cboAdmType").combobox('getValue'),
		aDateFrom:datefrom,
		aDateTo:dateto,
		aLocID:loc,
		aRegNo:RegNo,
		aMrNo:MrNo,
		rows:10000
	});
	$('#gridReceipt').datagrid('unselectAll');
}

// 漏诊查询
function NotReceiptQry(){
	var datefrom	= $('#dfDateFrom').datebox('getValue');		//获取日期控件的值
	var dateto		= $('#dfDateTo').datebox('getValue');		//获取日期控件的值
	var loc			= $("#cboLoc").combobox('getValue');
	$('#txtRegNo').val('');
	$('#txtMrNo').val('');

	$('#gridReceipt').datagrid('load',  {
		ClassName:"MA.IPMR.SSService.ReceiptQry",
		QueryName:"QuryReceiptByDate",
		aHospID:$("#cboHospital").combobox('getValue'),
		aAdmType:$("#cboAdmType").combobox('getValue'),
		aDateFrom:datefrom,
		aDateTo:dateto,
		aLocID:loc,
		aRegNo:'',
		aMrNo:'',
		isMissRec:'1',
		rows:10000
	});
	$('#gridReceipt').datagrid('unselectAll');
}

// 导出
function Export(){
	var data = $('#gridReceipt').datagrid('getData');
	if (data.rows.length==0)
	{
		$.messager.popover({msg: '请先查询再导出！',type: 'alert',timeout: 1000});
		return;
	}
	$('#gridReceipt').datagrid('Export', {
		filename: '接诊日志',
		extension:'xls'
	});
}

// add 接诊手工输入病案号
function GroupReceiptHN(aEpisodeID,aMrNo){
	if (!aEpisodeID) return;
	if (aMrNo==""){	// 点击接诊,无病案号可以输入
		$.messager.prompt("提示", "输入病案号:", function (r) {
			if (typeof r == "undefined"){
			}else{
				aMrNo = r;
				GroupReceipt(aEpisodeID,aMrNo);
			}
		});
	}else{			// 点击接诊,有病案号直接接诊
		GroupReceipt(aEpisodeID,aMrNo)
	}
}

// 接诊程序
function GroupReceipt(aEpisodeID,aMrNo){
	if (!aEpisodeID) return;
	var result = IGroupReceipt(aEpisodeID,aMrNo,Logon.LocID,Logon.UserID);
	var err = result.split('^')[0];
	if ((err*1)<0){
		$.messager.alert("错误", result.split('^')[1], 'error');
		return;
	}else{
		$('#gridReceipt').datagrid('reload');
		$('#gridReceipt').datagrid('unselectAll');
	}
}

// 取消接程序
function GroupUnReceipt(aEpisodeID){
	if (!aEpisodeID) return;
	
	$.messager.confirm("取消接诊", "取消接诊将造成此病人无病案号,确认要取消接诊吗?", function (r) {
		if (r) {
			var result = IGroupUnReceipt(aEpisodeID,Logon.LocID,Logon.UserID);
			var err = result.split('^')[0];
			if ((err*1)<0){
				$.messager.alert("错误", err, 'error');
				return;
			}else{
				$('#gridReceipt').datagrid('reload');
				$('#gridReceipt').datagrid('unselectAll');
			}
		}else{
		}
	});
}