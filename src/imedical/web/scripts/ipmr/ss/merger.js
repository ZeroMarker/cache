/**
 * merger 修改病案号
 * 
 * Copyright (c) 2018-2019 WHui. All rights reserved.
 * 
 * CREATED BY WHui 2019-11-28
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
	
	$HUI.combobox('#cboMrType',{
		onSelect:function(rows){
			var MrTypeId = rows["ID"];
			Common_CombogNoType("cboNoType","号码类型",MrTypeId);
			InitgridVol();
		}
	});
	InitgridVol();
}

function InitEvent(){

	$('#btnQry').click(function(){
		reloadgridVol()
	});

	$('#btnMerger').click(function(){
		Merger()
	});

	$('#btnClear').click(function(){
		Clear()
	});
	
	$('#txtOldMrNo').bind('keyup', function(event) {
	　　if (event.keyCode == "13") {
			reloadgridVol();
	　　}
	});
}
 /**
 * NUMS: M001
 * CTOR: WHui
 * DESC: 卷表格
 * DATE: 2019-11-15
 * NOTE: 包括方法：InitgridVol,reloadgridVol,Merger,Clear
 * TABLE: MA.IPMR.SS.MergerLog
 */
function InitgridVol(){
	var columns = [[
		{field:'PapmiNo',title:'登记号',width:150,align:'left'},
		{field:'MrNo',title:'病案号',width:120,align:'left'},
		{field:'PatName',title:'姓名',width:150,align:'left'},
		{field:'Sex',title:'性别',width:60,align:'left'},
		{field:'Age',title:'年龄',width:60,align:'left'},
		{field:'OrdStep',title:'当前步骤',width:100,align:'left'},
		{field:'VolStausDesc',title:'当前状态',width:100,align:'left'},
		{field:'DischLocDesc',title:'出院科室',width:150,align:'left'},
		{field:'DischWardDesc',title:'出院病区',width:150,align:'left'},
		{field:'AdmDate',title:'就诊日期',width:150,align:'left'},
		{field:'DischDate',title:'出院日期',width:150,align:'left'},
		{field:'BackDate',title:'回收日期',width:150,align:'left'},
		{field:'DeathDate',title:'死亡日期',width:150,align:'left'}
		//{field:'VolID',title:'卷ID',width:100,align:'left'}
	]];
	
	var gridVol = $HUI.datagrid("#gridVol",{
		fit:true,
		//title:"修改病案号",
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true,		//如果为true, 则显示一个行号列
		//singleSelect:true,
		autoRowHeight: false,	//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		fitColumns:true,		//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		url:$URL,
		queryParams:{
		    ClassName:"MA.IPMR.SSService.MergerSrv",
			QueryName:"QryVolumeByMrNo",
			aHospID:$("#cboHospital").combobox('getValue'),
			aMrTypeID:$("#cboMrType").combobox('getValue'),
			aMrNo:$("#txtOldMrNo").val(),
			rows:100
		},
		columns :columns,
		frozenColumns:[[ {field:'ck',checkbox:true}]],	//多选框,位置固定在最左边
	});
}

// 刷新表格数据
function reloadgridVol() {
	$('#gridVol').datagrid('load',  {
		ClassName:"MA.IPMR.SSService.MergerSrv",
		QueryName:"QryVolumeByMrNo",
		aHospID:$("#cboHospital").combobox('getValue'),
		aMrTypeID:$("#cboMrType").combobox('getValue'),
		aMrNo:$("#txtOldMrNo").val(),
		rows:100
	});
	$('#gridVol').datagrid('unselectAll');
}

// 修改病案号
function Merger(){
	var rows = $('#gridVol').datagrid('getSelections');  		//取得所有选中行数据，返回元素记录的数组数据
	if (rows.length==0){
		$.messager.popover({msg: '请选择病历信息！',type: 'alert',timeout: 1000});
		return false;
	}
	$('#MergerDialog').css('display','block');
	vols = '';
	for (var i = 0; i < rows.length; i++) {
		var rowArray = rows[i]
		var vol = rowArray.VolID;
		vols	= vols+","+vol;
	}
	vols	= vols.slice(1);
	
	$("#oldMrNo").val(rows[0].MrNo);
	$("#newMrNo").val('');
	var MergerDialog = $HUI.dialog('#MergerDialog',{
		title:'修改病案号',
		iconCls:'icon-w-edit',
		modal:true,
		minimizable:false,
		maximizable:false,
		collapsible:false,
		buttons:[{
			text:'保存',
				iconCls:'icon-w-save',
				handler:function(){
					var NoTypeID = $("#cboNoType").combobox('getValue');
					var oldMrNo  = $("#oldMrNo").val();
					var newMrNo  = $("#newMrNo").val();
					var aUserID	 = Logon.UserID;
					if (!newMrNo) {
						$.messager.popover({msg: '请输入新病案号！',type: 'alert',timeout: 1000});
						return;
					}
					saveMerger(NoTypeID,oldMrNo,vols,newMrNo,aUserID);
				}
		},{
			text:'关闭',
			iconCls:'icon-w-close',
			handler:function(){
				$('#MergerDialog').window("close");
			}	
		}]
	});
}

// 清空
function Clear(){
	$("#gridVol").datagrid('loadData', { total: 0, rows: [] });
	$("#txtOldMrNo").val('');
}

 /**
 * NUMS: M002
 * CTOR: WHui
 * DESC: 号码修改弹框
 * DATE: 2019-11-15
 * NOTE: 包括方法：saveMerger
 * TABLE: MA.IPMR.SS.MergerLog
 */
// 修改病案号
function saveMerger(NoTypeID,oldMrNo,vols,newMrNo,aUserID){
	$.messager.confirm("确认", "确认进行病案号修改操作?", function (r) {
		if (r) {
			var flg = $m({
				ClassName:"MA.IPMR.SSService.MergerSrv",
				MethodName:"MergerMrNo",
				aNoTypeID:NoTypeID,
				aOldMrNo:oldMrNo,
				aVolumeIDs:vols,
				aNewMrNo:newMrNo,
				aUserID:aUserID
			},false);
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误", flg, 'error');
				return;
			}else{
				$.messager.popover({msg: '修改病案号成功！',type:'success',timeout: 1000});
				$('#MergerDialog').window("close");
				$('#gridVol').datagrid('load',  {
					ClassName:"MA.IPMR.SSService.MergerSrv",
					QueryName:"QryVolumeByMrNo",
					aHospID:$("#cboHospital").combobox('getValue'),
					aMrTypeID:parseInt(NoTypeID),
					aMrNo:newMrNo,
					rows:100
				});
				$('#gridVol').datagrid('unselectAll');
				$("#txtOldMrNo").val('');
			}
		}
		else{
		}
	});
}