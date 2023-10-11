/**
 * audit 病案借阅审核
 * 
 * Copyright (c) 2018-2021 liyi. All rights reserved.
 * 
 * CREATED BY liyi 2021-09-09
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
	InitgridLendRequest();
	loadgridLendRequest();
}

function InitEvent(){
	
}

/**
 * NUMS: D001
 * CTOR: LIYI
 * DESC: 待审核申请记录模块
 * DATE: 2021-05-11
 * NOTE: 包括方法：
 * TABLE: 
 */
 // 初始化待审核申请记录表格
function InitgridLendRequest(){
	var columns = [[
		{field:'LendTypeDesc',title:'借阅病历类型',width:100,align:'left'},
		{field:'UserDesc',title:'申请人',width:100,align:'left'},
		{field:'Unit',title:'医生资格证书号',width:100,align:'left'},
		{field:'LocDesc',title:'申请科室',width:100,align:'left'},
		{field:'StatusDesc',title:'申请状态',width:100,align:'left'},
		{field:'RequestDate',title:'申请日期',width:100,align:'left'},
		{field:'PDFModelDesc',title:'浏览模式',width:100,align:'left'},
		{field:'LendPurposeDesc',title:'借阅目的',width:100,align:'left'},
		{field:'ExpBackDate',title:'预计归还日期',width:100,align:'left'},
		{field:'VolCount',title:'病历数',width:80,align:'left',
			formatter:function(value,row,index) {
            	var RequestID = row.ID;
				var VolCount = row.VolCount;
               	return '<a href="#" class="grid-td-text-gray" onclick = showRequestVol(' + RequestID + ')>' + VolCount + '</a>';            
            }
		},
		{field:'Resume',title:'申请备注',width:300,align:'left'}
	]];
	var gridLendRequest =$HUI.datagrid("#gridLendRequest",{
		fit: true,
		title: "病案借阅申请审核",
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		fitColumns:true,
		checkOnSelect:true,		//true,击某一行时，选中/取消选中复选框
		selectOnCheck:true,		//true,点击复选框将会选中该行
		pageList : [20,50,100,200],
	    url:$URL,
	    queryParams:{
		    ClassName:"MA.IPMR.SSService.VolLendRequestSrv",
			QueryName:"QryLendRequest",
			aLendTypeID: '',
			aDateFrom:'',
			aDateTo:'',
			aStatusID:'',
			aHospID:'',
			aUserID:'',
			aLocID:''
	    },
		columns:columns
	});
	return gridLendRequest;
}

// 刷新申请记录数据
function loadgridLendRequest() {
	$("#gridLendRequest").datagrid("reload", {
		ClassName:"MA.IPMR.SSService.VolLendRequestSrv",
			QueryName:"QryLendRequest",
			aLendTypeID: '',
			aDateFrom:'',
			aDateTo:'',
			aStatusID:ServerObj.AuditStatusID,
			aHospID:Logon.HospID,
			aUserID:'',
			aLocID:Logon.LocID
	})
	$('#gridLendRequest').datagrid('unselectAll');
}

// 审核通过
$('#btnPass').click(function(){
	var selectData	= $('#gridLendRequest').datagrid('getSelections');
	if (selectData.length==0){
		$.messager.popover({msg: '请选择需操作的申请记录！',type: 'alert',timeout: 1000});
		return false;
	}
	var RequestIDs = '';
	for (var i = 0; i <  selectData.length; i++) {
		var selRowArray = selectData[i];
		RequestIDs += ',' + selRowArray.ID;
	}
	if (RequestIDs != '') RequestIDs = RequestIDs.substr(1,RequestIDs.length-1);
	$.messager.confirm('确认', '确认审核通过选择的记录？', function(r){
    	if (r) {
			var inputStr = RequestIDs;
			inputStr = inputStr + '^' + ServerObj.PassCode;
			inputStr = inputStr + '^' + Logon.UserID;
			inputStr = inputStr + '^' + '';
			var flg = $m({
				ClassName:"MA.IPMR.SSService.VolLendRequestSrv",
				MethodName:"RequestOper",
				aInputStr:inputStr
			},false);
			if (parseInt(flg.split('^')[0]) <= 0) {
				$.messager.alert("错误", "审核失败!", flg.split('^')[1]);
			} else {
				loadgridLendRequest();
			}
		} 
    });
});

// 审核不通过
$('#btnUnPass').click(function(){
	var selectData	= $('#gridLendRequest').datagrid('getSelections');
	if (selectData.length==0){
		$.messager.popover({msg: '请选择需操作的申请记录！',type: 'alert',timeout: 1000});
		return false;
	}
	var RequestIDs = '';
	for (var i = 0; i <  selectData.length; i++) {
		var selRowArray = selectData[i];
		RequestIDs += ',' + selRowArray.ID;
	}
	if (RequestIDs != '') RequestIDs = RequestIDs.substr(1,RequestIDs.length-1);
	$.messager.prompt("提示", "输入审核不通过原因:", function (r) {
		if (r) {
			var inputStr = RequestIDs;
			inputStr = inputStr + '^' + ServerObj.UnPassCode;
			inputStr = inputStr + '^' + Logon.UserID;
			inputStr = inputStr + '^' + r;
			var flg = $m({
				ClassName:"MA.IPMR.SSService.VolLendRequestSrv",
				MethodName:"RequestOper",
				aInputStr:inputStr
			},false);
			if (parseInt(flg.split('^')[0]) <= 0) {
				$.messager.alert("错误", "审核不通过失败!", flg.split('^')[1]);
			} else {
				loadgridLendRequest();
			}
		} else {
			if (r=='') {
				$.messager.popover({msg: '输入信息为空，未做任何操作！',type: 'alert',timeout: 1000});
			}
		}
	});
});


/**
 * NUMS: D002
 * CTOR: LIYI
 * DESC: 申请病历列表
 * DATE: 2021-09-11
 * NOTE: 包括方法：
 * TABLE: 
 */
function showRequestVol(RequestID) {
	var Columns = [[
		{field: 'MrNo', title: '病案号', width: 100, align: 'left'},
		{field: 'PapmiNo', title: '登记号', width: 120, align: 'left'},
		{field: 'PatName', title: '姓名', width: 100, align: 'left'},
		{field: 'AdmTimes', title: '住院次数', width: 80, align: 'left'},
		{field: 'Sex', title: '性别', width: 80, align: 'left'},
		{field: 'Age', title: '年龄', width: 80, align: 'left'},
		{field: 'AdmDate', title: '入院日期', width: 150, align: 'left'},
		{field: 'DisDate', title: '出院日期', width: 150, align: 'left'},
		{field: 'AdmLoc', title: '入院科室', width: 150, align: 'left'},
		{field: 'DisLoc', title: '出院科室', width: 150, align: 'left'},
		{field:'VolStatusDesc',title:'病历状态',width:120,align:'left'}
	]];
	var gridRequestVol = $HUI.datagrid("#gridRequestVol", {
		fit: true,
		headerCls:'panel-header-gray',
		iconCls:'icon-write-order',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 100,
		pageList:[100,200,500,1000],
		fitColumns:true,
	    url:$URL,
	    queryParams : {
		    ClassName : "MA.IPMR.SSService.VolLendRequestSrv",
			QueryName : "QryRequestVol",
			aRequestID : RequestID
	    },
	    columns : Columns
	});
	var RequestVolDialog = $('#RequestVolDialog').dialog({
	    title: '借阅病历列表',
		iconCls: 'icon-w-edit',
	    minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
	    closed: false,
	    cache: false,
	    modal: true,
		onClose:function(){
		}
	});
    return RequestVolDialog;
}