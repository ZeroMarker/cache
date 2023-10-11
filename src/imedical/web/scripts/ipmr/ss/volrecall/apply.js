/**
 * apply 召回申请
 * 
 * Copyright (c) 2018-2019 LIYI. All rights reserved.
 * 
 * CREATED BY LIYI 2021-05-24
 * 
 * 注解说明
 * TABLE: 
 */

//页面全局变量对象
var globalObj = {
	m_gridApply : ''
}

$(function(){
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
})

function Init(){
	InitgridVolList();
	InitgridEmrList();
	InitgridExpand();
	Common_ComboToDic('cboReCallReason','ReCallReason',1,'');
	Common_ComboToDicCode('cboStatus','ReCallStatus',1,'');
	var tdateFrom	= Common_GetDate(0,"");
	var tdateTo		= Common_GetDate(0,"");	
	$('#dfDateFrom').datebox('setValue', tdateFrom);		// 给日期框赋值
	$('#dfDateTo').datebox('setValue', tdateTo);			// 给日期框赋值
	InitgridApply();
	setTimeout(function(){
		$('#cboStatus').combobox('select','R');
		loadgridApply();
	},300)
}

function InitEvent(){
	// 病案号|登记号|条码
	$('#txtNumber').bind('keyup', function(event) {					
	　　if (event.keyCode == "13") {
			var Number = $('#txtNumber').val();
			loadgridVolList(Number);
			$("#txtNumber").val('');
	　　}
	});

	// 提交申请
	$('#btnApply').click(function(){
		SaveApply(1);
	});	
	
	// 查询
	$('#btnQry').click(function(){
		loadgridApply();
	});	

	// 病案号|登记号|条码
	$('#txtqNumber').bind('keyup', function(event) {					
	　　if (event.keyCode == "13") {
			var Number = $('#txtqNumber').val();
			loadgridApply();
			$("#txtqNumber").val('');
	　　}
	});


}
 /**
 * NUMS: D001
 * CTOR: LIYI
 * DESC: 申请表单模块
 * DATE: 2021-05-11
 * NOTE: 包括方法：
 * TABLE: 
 */
// 初始化就诊列表
function InitgridVolList() {
	var columns = [[
		{field:'MrNo',title:'病案号',width:80,align:'left'},
		{field:'PatName',title:'姓名',width:80,align:'left'},
		{field:'DischLocDesc',title:'出院科室',width:150,align:'left'},
		{field:'DischDate',title:'出院日期',width:100,align:'left'},
		{field:'DocName',title:'主治医师',width:80,align:'left'},
		{field:'BackDate',title:'回收日期',width:100,align:'left'}
	]];
	var gridVolList =$HUI.datagrid("#gridVolList",{
		fit:true,
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false,		//如果为true, 则显示一个行号列
		singleSelect:true,
		autoRowHeight: false,	//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 500,
		fitColumns:false,		//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		checkOnSelect:true,		//true,击某一行时，选中/取消选中复选框
		selectOnCheck:false,		//true,点击复选框将会选中该行
	    url:$URL,
	    queryParams:{
		    ClassName:"MA.IPMR.SSService.VolReCallSrv",
			QueryName:"QryVolListToReCall",
			aHospID:Logon.HospID,
			aMrTypeID:Logon.MrTypeID,
			aDicLocID:Logon.LocID,
			aNumber:''
	    },
	    onSelect:function(rowIndex, rowData){
	    	var episodeid = rowData.EpisodeID;
	    	loadgridEmrList(episodeid);
	    },
		columns:columns
	});
	return gridVolList;
}
// 刷新就诊列表数据
function loadgridVolList(Number) {
	$("#gridVolList").datagrid("reload", {
		ClassName:"MA.IPMR.SSService.VolReCallSrv",
		QueryName:"QryVolListToReCall",
		aHospID:Logon.HospID,
		aMrTypeID:Logon.MrTypeID,
		aDicLocID:Logon.LocID,
		aNumber:Number
	})
	$('#gridVolList').datagrid('unselectAll');
}

// 提交申请信息
function SaveApply(type) {
	var selectData	= $('#gridVolList').datagrid('getSelections');
	if (selectData.length==0){
		$.messager.popover({msg: '请选择需召回病历的就诊记录！',type: 'alert',timeout: 1500});
		return false;
	}
	if (selectData.length>1){
		$.messager.popover({msg: '一次只能对一份病案进行召回！',type: 'alert',timeout: 1500});
		return false;
	}
	var volid = selectData[0].VolID;

	var IsReCallAll = $("#chkReCallAll").checkbox("getValue")?"1":"0";
	if ((type==1)&&(IsReCallAll==0)) {	// 【申请】 非整份召回
		openEmrListDiag();
		return;
	}
	var EmrInstanceIDs='';
	if (type==0) { // 【确定】 非整份召回
		var selectEmrListData	= $('#gridEmrList').datagrid('getSelections');
		for (var i = 0; i < selectEmrListData.length; i++) {
			var selRow = selectEmrListData[i];
			if (EmrInstanceIDs=='') {
				EmrInstanceIDs = selRow.InstanceID;		
			}else{
				EmrInstanceIDs += ',' + selRow.InstanceID;
			}
		}
		if (EmrInstanceIDs=='') {
			$.messager.popover({msg: '请选择召回的病历文书！',type: 'alert',timeout: 1000});
			return;
		}
	}
	var ReCallReasonID = $("#cboReCallReason").combobox('getValue');
	if (ReCallReasonID==''){
		$.messager.popover({msg: '请选择召回原因！',type: 'alert',timeout: 1000});
		return
	}
	var Resume =  $("#txtResume").val();
	var flg = $m({
		ClassName:"MA.IPMR.SSService.VolReCallSrv",
		MethodName:"ApplyReCall",
		aVolID:volid,
		aReCallReasonID:ReCallReasonID,
		aApplyUserID:Logon.UserID,
		aResume:Resume,
		aIsReCallAll:IsReCallAll,
		aEmrInstanceIDs:EmrInstanceIDs
	},false);
	if (parseInt(flg) <= 0) {
		$.messager.alert("错误", "申请失败!", 'error');
		return;
	}
	clearInput();
	loadgridApply();
	if (type==0) { // 【确定】 非整份召回
		$('#EmrListDialog').window("close");
	}
}

// 清空登记区域表单
function clearInput () {
	$("#txtNumber").val('');
	loadgridVolList('');
	$('#cboReCallReason').combobox('setValue', '');
	$("#txtResume").val('');
	$("#chkReCallAll").checkbox("setValue",false);
}
// 初始化病历文书表格
function InitgridEmrList(){
	var columns = [[
		{field:'workList_ck',title:'sel',checkbox:true},
		{field:'Title',title:'标题',width:120,align:'left'},
		{field:'CreateDate',title:'创建日期',width:100,align:'left'},
		{field:'CreateTime',title:'创建时间',width:100,align:'left'},
		{field:'CreateUser',title:'创建人',width:100,align:'left'},
		{field:'Status',title:'状态',width:80,align:'left'}
	]];
	var gridEmrList =$HUI.datagrid("#gridEmrList",{
		fit:true,
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false,		//如果为true, 则显示一个行号列
		singleSelect:false,
		autoRowHeight: false,	//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 500,
		fitColumns:true,		//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		checkOnSelect:true,		//true,击某一行时，选中/取消选中复选框
		selectOnCheck:true,		//true,点击复选框将会选中该行
	    url:$URL,
	    queryParams:{
		    ClassName:"MA.IPMR.SSService.VolReCallExpandSrv",
			QueryName:"QryEmrInstance",
			aEpisodeID:''
	    },
		columns:columns
	});
	return gridEmrList;
}
// 刷新历文书表格数据
function loadgridEmrList(episodeid) {
	$("#gridEmrList").datagrid("reload", {
		ClassName:"MA.IPMR.SSService.VolReCallExpandSrv",
		QueryName:"QryEmrInstance",
		aEpisodeID:episodeid
	})
	$('#gridEmrList').datagrid('unselectAll');
}

function openEmrListDiag() {
	var EmrListDialog =$HUI.dialog('#EmrListDialog',{
		title:'病历文书',
		iconCls:'icon-w-edit',
		modal:true,
		minimizable:false,
		maximizable:false,
		collapsible:false,
	    buttons:[{
			text:'确定',
			iconCls:'icon-w-add',
			handler:function(){
				SaveApply(0);
			}
		},{
			text:'关闭',
			iconCls:'icon-w-close',
			handler:function(){
				$('#EmrListDialog').window("close");
			}	
		}]
	});
	$('#EmrListDialog').window('open');
}

/**
 * NUMS: D002
 * CTOR: LIYI
 * DESC: 申请记录模块
 * DATE: 2021-05-11
 * NOTE: 包括方法：
 * TABLE: 
 */

 // 初始化申请记录表格
function InitgridApply(){
	var columns = [[
		{field:'MrNo',title:'病案号',width:80,align:'left'},
		{field:'PatName',title:'姓名',width:80,align:'left'},
		{field:'DischLocDesc',title:'出院科室',width:150,align:'left'},
		{field:'DischDate',title:'出院日期',width:100,align:'left'},
		{field:'ApplyUser',title:'申请人',width:80,align:'left'},
		{field:'ApplyDate',title:'申请时间',width:160,align:'left',
			formatter: function(value,row,index){
				return row.ApplyDate+ ' ' + row.ApplyTime;
			}
		},
		{field:'StatusDesc',title:'状态',width:100,align:'left'},
		{field:'ReCallReasonDesc',title:'召回原因',width:150,align:'left'},
		{field:'IsReCallAll',title:'全部召回',width:80,align:'left',
			formatter:function(value,row,index){
				var IsReCallAll	= row.IsReCallAll;
				var ReCallID	= row.ReCallID;
				if (IsReCallAll == '1'){
					return $g('是');
				} else {
					return "<a href='#' onclick='openExpandDialog(\"" + ReCallID +"\""+");'>"+$g('否')+"</a>";
				}
			}
		},
		{field:'Resume',title:'备注',width:100,align:'left'}
	]];
	var gridApply =$HUI.datagrid("#gridApply",{
		fit: true,
		title: "申请记录",
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		fitColumns:false,
		pageList : [20,50,100,200],
	    url:$URL,
	    queryParams:{
		    ClassName:"MA.IPMR.SSService.VolReCallSrv",
			QueryName:"QryVolReCall",
			aHospID: '',
			aMrTypeID:'',
			aStatusCode:'',
			aDateFrom:'',
			aDateTo:'',
			aUserID:Logon.UserID,
			aNumber:''
	    },
		columns:columns
	});
	return gridApply;
}

// 刷新申请记录数据
function loadgridApply(Number) {
	$("#gridApply").datagrid("reload", {
		ClassName:"MA.IPMR.SSService.VolReCallSrv",
		QueryName:"QryVolReCall",
		aHospID: Logon.HospID,
		aMrTypeID:Logon.MrTypeID,
		aStatusCode:$("#cboStatus").combobox('getValue'),
		aDateFrom:$('#dfDateFrom').datebox('getValue'),
		aDateTo:$('#dfDateTo').datebox('getValue'),
		aUserID:Logon.UserID,
		aNumber:$('#txtqNumber').val()
	})
	$('#gridApply').datagrid('unselectAll');
}

// 撤销申请记录
$('#btnCancel').click(function(){
	var selectData	= $('#gridApply').datagrid('getSelections');
	if (selectData.length==0){
		$.messager.popover({msg: '请选择需作废的申请记录！',type: 'alert',timeout: 1000});
		return false;
	}
	$.messager.prompt("提示", "输入作废原因:", function (r) {
		if (r) {
			var flg = $m({
				ClassName:"MA.IPMR.SSService.VolReCallSrv",
				MethodName:"CancelReCall",
				aReCallID:selectData[0].ReCallID,
				aUserID:Logon.UserID,
				aResume:r
			},false);
			if (parseInt(flg) <= 0) {
				if (parseInt(flg)==-101) {
					$.messager.alert("提示", "病案室已审核通过不允许撤销!");	
				}else{
					$.messager.alert("错误", "作废失败!" + '<br>' + flg, 'error');
				}
			} else {
				loadgridApply();
			}
		} else {
			if (r=='') {
				$.messager.popover({msg: '输入信息为空，未做任何操作！',type: 'alert',timeout: 1000});
			}
		}
	});
});

// 初始化召回文书表格
function InitgridExpand(){
	var columns = [[
		{field:'Title',title:'标题',width:120,align:'left'},
		{field:'CreateDate',title:'创建日期',width:100,align:'left'},
		{field:'CreateTime',title:'创建时间',width:100,align:'left'},
		{field:'CreateUser',title:'病历创建人',width:100,align:'left'},
		{field:'Status',title:'状态',width:80,align:'left'}
	]];
	var gridExpand =$HUI.datagrid("#gridExpand",{
		fit:true,
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false,		//如果为true, 则显示一个行号列
		singleSelect:false,
		autoRowHeight: false,	//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 500,
		fitColumns:false,		//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		checkOnSelect:true,		//true,击某一行时，选中/取消选中复选框
		selectOnCheck:true,		//true,点击复选框将会选中该行
	    url:$URL,
	    queryParams:{
		    ClassName:"MA.IPMR.SSService.VolReCallExpandSrv",
			QueryName:"QryVolReCallExpand",
			aReCallIDs:''
	    },
		columns:columns
	});
	return gridExpand;
}
// 刷新历文书表格数据
function loadgridExpand(ReCallID) {
	$("#gridExpand").datagrid("reload", {
		ClassName:"MA.IPMR.SSService.VolReCallExpandSrv",
		QueryName:"QryVolReCallExpand",
		aReCallIDs:ReCallID
	})
	$('#gridExpand').datagrid('unselectAll');
}

//单项召回明细
function openExpandDialog(ReCallID){
	loadgridExpand(ReCallID);
	var ExpandDialog =$HUI.dialog('#ExpandDialog',{
		title:'召回文书',
		iconCls:'icon-w-edit',
		modal:true,
		minimizable:false,
		maximizable:false,
		collapsible:false,
	    buttons:[{
			text:'关闭',
			iconCls:'icon-w-close',
			handler:function(){
				$('#ExpandDialog').window("close");
			}	
		}]
	});
	$('#ExpandDialog').window('open');
}