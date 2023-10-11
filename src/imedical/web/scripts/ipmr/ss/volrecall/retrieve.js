﻿/**
 * retrieve 单项召回回收
 * 
 * Copyright (c) 2018-2021 liyi. All rights reserved.
 * 
 * CREATED BY liyi 2022-12-07
 * 
 * 注解说明
 * TABLE: 
 */

//页面全局变量对象
var globalObj = {
	m_OperaFlag			:'',	  // 待回收按钮点击标记
	m_RecordIDs			:''       // 工作区选中的卷
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
	$('#dfDateFrom').datebox('setValue', tdateTo);		// 给日期框赋值
	$('#dfDateTo').datebox('setValue', tdateTo);			// 给日期框赋值
	$('#chkRevoke').checkbox('setValue', false);
	$('#btnRevoke').linkbutton("disable");
	$('#btnRevokeQry').linkbutton("disable");
	$('#cboRetrieveUser').combo('disable');
	Common_ComboToHosp("cboHospital",'',Logon.HospID);
	Common_ComboToMrType("cboMrType",ServerObj.MrClass);
	Common_ComboToDicCode('cboDateType','ReCallRetireDateType',1,'');
	Common_ComboGridToUser("cboRetrieveUser","");
	setTimeout(function(){
		$('#cboDateType').combobox('select',2);
	},200)
	InitGridWorkList();
}

function InitEvent(){
	$HUI.combobox('#cboMrType',{
		onSelect:function(rows){
			ReLoadWorkList();
		}
	});

	$HUI.combobox('#cboHospital',{
		onSelect:function(rows){
			Common_ComboToLoc("cboDiscLoc","","E",rows["HospID"],'I','');			// 科室
			Common_ComboToLoc("cboDiscWard","","W",rows["HospID"],'','');			// 病区
			var chkRevoke	= $('#chkRevoke').checkbox('getValue');
			if (chkRevoke) {
				//RevokeQry();
			} else{
				$('#txtNumber').val('');
				ReLoadWorkList();
			}
		}
	});
	// 科室、病区联动
	$('#cboDiscLoc').combobox({
	    onChange:function(newValue,oldValue){
		    var Hosp = $("#cboHospital").combobox('getValue');
			Common_ComboToLoc("cboDiscWard","","W",Hosp,'','',newValue);			// 病区
	    }
	})
	// 保存
	$('#btnSubmit').click(function(){
		SubmitRetrieve();
	});
	
	// 删除
	$('#btnDetach').click(function(){
		Detach();
	});	

	// 清空
	$('#btnClean').click(function(){
		Clean();
	});			
	
	// 撤销
	$('#btnRevoke').click(function(){
		if ($(this).hasClass("l-btn-disabled")) return;
		Revoke();
	});	
	$HUI.checkbox('#chkRevoke',{
		onCheckChange:function(e,value){
			if (value) {
				$('#btnRevokeQry').linkbutton("enable");		// 已回收按钮
				$('#btnTodoQry').linkbutton("disable");			// 待回收按钮
				$('#btnSubmit').linkbutton("disable");			// 保存
				$('#btnNote').linkbutton("disable");			// 催交
				$('#btnDetach').linkbutton("disable");			// 删除
				$('#btnClean').linkbutton("disable");			// 清空
				$('#btnRevoke').linkbutton("enable");
				$('#txtNumber').val('');
				$('#dfDateFrom').datebox('setValue','');
				$('#dfDateTo').datebox('setValue','');
				$('#cboDiscLoc').combobox('setValue','')
				$('#cboDiscWard').combobox('setValue','')
				$('#cboRetrieveUser').combogrid('clear');
				$('#gridWorkList').datagrid('showColumn','RetrieveDateTime');
				$('#gridWorkList').datagrid('showColumn','ReTrieveUser');
				$('#cboRetrieveUser').combo('enable');
				globalObj.m_OperaFlag = '';
				$('#gridWorkList').datagrid('loadData',{"total":0,"rows":[]});
			} else{
				$('#btnRevokeQry').linkbutton("disable");		// 已回收按钮
				$('#btnTodoQry').linkbutton("enable");			// 待回收按钮
				$('#btnSubmit').linkbutton("enable");			// 保存
				$('#btnNote').linkbutton("enable");				// 催交
				$('#btnDetach').linkbutton("enable");			// 删除
				$('#btnClean').linkbutton("enable");			// 清空
				$('#btnRevoke').linkbutton("disable");
				$('#txtNumber').val('');
				$('#dfDateFrom').datebox('setValue','');
				$('#dfDateTo').datebox('setValue','');
				$('#cboDiscLoc').combobox('setValue','')
				$('#cboDiscWard').combobox('setValue','')
				$('#cboRetrieveUser').combogrid('clear');
				$('#gridWorkList').datagrid('hideColumn','RetrieveDateTime');
				$('#gridWorkList').datagrid('hideColumn','ReTrieveUser');
				$('#cboRetrieveUser').combo('disable');
				globalObj.m_OperaFlag3 = '';
				ReLoadWorkList();		// 取消勾选撤销操作-加载待回收
			}
		}
	});
	// 待回收查询
	$('#btnTodoQry').click(function(){
		$('#cboRetrieveUser').combogrid('clear');
		TodoQry();
	});	

	// 已回收查询
	$('#btnRevokeQry').click(function(){
		RevokeQry();
	});	
	// 病案号|登记号|条码
	$('#txtNumber').bind('keyup', function(event) {					
	　　if (event.keyCode == "13") {
			globalObj.m_OperaFlag = 0;
			NumberSearch();
	　　}
	});
}

 /**
 * NUMS: W001
 * CTOR: liyi
 * DESC: 工作列表模块
 * DATE: 2021-05-13
 * NOTE: 包括方法：
 * TABLE: 
 */

// 初始化工作列表
function InitGridWorkList(){
	var columns = [[
		{field:'workList_ck',title:'sel',checkbox:true},
		{field:'PatName',title:'姓名',width:120,align:'left'},
		{field:'PapmiNo',title:'登记号',width:100,align:'left'},
		{field:'MrNo',title:'病案号',width:100,align:'left'},
		{field:'DischLocDesc',title:'出院科室',width:150,align:'left'},
		{field:'DischWardDesc',title:'出院病区',width:150,align:'left'},
		{field:'DischDate',title:'出院日期',width:100,align:'left'},
		{field:'Title',title:'病历文书',width:150,align:'left'},
		{field:'DocName',title:'主治医师',width:120,align:'left'},
		{field:'ApplyUser',title:'申请人',width:120,align:'left'},
		{field:'ApplyDate',title:'申请时间',width:160,align:'left',
			formatter: function(value,row,index){
				return row.ApplyDate+ ' ' + row.ApplyTime;
			}
		},
		{field:'DurationTimeDesc',title:'授权时长',width:120,align:'left'},
		{field:'RetrieveDateTime',title:$g('回收时间'),width:180,align:'left',hidden:true,
			formatter: function(value,row,index){
				return row.ReTrieveDate+ ' ' + row.ReTrieveTime;
			}},
		{field:'ReTrieveUser',title:$g('回收人员'),width:100,align:'left',hidden:true}
	]];
	var gridWorkList = $HUI.datagrid("#gridWorkList",{
		fit:true,
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true,		//如果为true, 则显示一个行号列
		singleSelect:false,
		autoRowHeight: false,	//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 500,
		pageList:[100,200,500,1000],
		fitColumns:false,		//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		checkOnSelect:true,		//true,击某一行时，选中/取消选中复选框
		selectOnCheck:true,		//true,点击复选框将会选中该行
		url:$URL,
		queryParams:{
			ClassName:"MA.IPMR.SSService.VolReCallExpandSrv",
			QueryName:"QryToRetrieveList",
			aHospID:$('#cboHospital').combobox('getValue'),
			aMrTypeID:parseInt($('#cboMrType').combobox('getValue')),
			aDateType:$('#cboDateType').combobox('getValue'),
			aDateFrom:$('#dfDateFrom').datebox('getValue'),
			aDateTo:$('#dfDateTo').datebox('getValue'),
			aDischLoc:$('#cboDiscLoc').combobox('getValue'),
			aDischWard:$('#cboDiscWard').combobox('getValue'),
			aUserID:Logon.UserID,
			aOperFlg:globalObj.m_OperaFlag,
			rows:10000
		},
		columns :columns
	});
}

// 加载工作列表
function ReLoadWorkList(){
	if ($('#chkRevoke').checkbox('getValue')) {
		var RetrieveUser = "";
		var objRetrieveUserUser = $('#cboRetrieveUser').combogrid('grid').datagrid('getSelected');
		if (objRetrieveUserUser!==null){
			var RetrieveUser = objRetrieveUserUser.ID;
		}
		$('#gridWorkList').datagrid('reload',  {
			ClassName:"MA.IPMR.SSService.VolReCallExpandSrv",
			QueryName:"QryExpand",
			aHospID:$('#cboHospital').combobox('getValue'),
			aMrTypeID:$('#cboMrType').combobox('getValue'),
			aDateType:$('#cboDateType').combobox('getValue'),
			aDateFrom:$('#dfDateFrom').datebox('getValue'),
			aDateTo:$('#dfDateTo').datebox('getValue'),
			aDisLocID:$('#cboDiscLoc').combobox('getValue'),
			aDisWardID:$('#cboDiscWard').combobox('getValue'),
			aRegUserID:'',
			aNumber:$('#txtNumber').val(),
			aIsRetrieve:'1',
			aRetrieveUserID:RetrieveUser,
			rows:10000
		});
		$('#gridWorkList').datagrid('unselectAll');
	} else{
		$('#gridWorkList').datagrid('reload',  {
			ClassName:"MA.IPMR.SSService.VolReCallExpandSrv",
			QueryName:"QryToRetrieveList",
			aHospID:$('#cboHospital').combobox('getValue'),
			aMrTypeID:parseInt($('#cboMrType').combobox('getValue')),
			aDateType:$('#cboDateType').combobox('getValue'),
			aDateFrom:$('#dfDateFrom').datebox('getValue'),
			aDateTo:$('#dfDateTo').datebox('getValue'),
			aDischLoc:$('#cboDiscLoc').combobox('getValue'),
			aDischWard:$('#cboDiscWard').combobox('getValue'),
			aUserID:Logon.UserID,
			aOperFlg:globalObj.m_OperaFlag,
			rows:10000
		});
		$('#gridWorkList').datagrid('unselectAll');
	}
}
 /**
 * NUMS: W002
 * CTOR: liyi
 * DESC: 查询表单模块
 * DATE: 2021-05-13
 * NOTE: 包括方法：
 * TABLE: 
 */
// 通过号码查询
function NumberSearch(){
	var chkRevoke	= $('#chkRevoke').checkbox('getValue');
	var MrTypeID	= $('#cboMrType').combobox('getValue');
	var Number		= $('#txtNumber').val();
	var HospID		= $('#cboHospital').combobox('getValue');
	
	var errinfo		= '';
	if (!HospID) {
		errinfo = errinfo + "请选择医院!<br>";
	}
	if (!MrTypeID) {
		errinfo = errinfo + "请选择病案类型!<br>";
	}
	if (!Number) {
		errinfo = errinfo + "请输入病案号!<br>";
	}
	
	if (errinfo) {
		$.messager.alert("提示",errinfo,"info");
		return;
	}
	if (!chkRevoke) {
		InitgridReCallExpand(HospID,MrTypeID,Number);		// 记录弹框
		$('#txtNumber').val('');
	} else{
		RevokeQry();		// 由号码查询回收记录
		$('#txtNumber').val('');
	}
}
// 查询待回收卷列表
function TodoQry(){
	var HospID		= $('#cboHospital').combobox('getValue');
	var MrTypeID	= $('#cboMrType').combobox('getValue');
	var DateType	= $('#cboDateType').combobox('getValue');
	var DateFrom    = $('#dfDateFrom').datebox('getValue');
	var DateTo      = $('#dfDateTo').datebox('getValue'); 
	var DischLoc	= $('#cboDiscLoc').combobox('getValue');
	var DischWard	= $('#cboDiscWard').combobox('getValue');
	$('#txtNumber').val('');
	if (HospID==''){
		$.messager.popover({msg: '请选择医院！',type: 'alert',timeout: 1000});
		return;
	}
	if (MrTypeID==''){
		$.messager.popover({msg: '请选择病案类型！',type: 'alert',timeout: 1000});
		return;
	}
	if (DateType==''){
		$.messager.popover({msg: '请选择日期类型！',type: 'alert',timeout: 1000});
		return;
	}
	if (DateFrom==''){
		$.messager.popover({msg: '请选择开始日期！',type: 'alert',timeout: 1000});
		return;
	}
	if (DateTo==''){
		$.messager.popover({msg: '请选择结束日期！',type: 'alert',timeout: 1000});
		return;
	}
	globalObj.m_OperaFlag = 1;
	ReLoadWorkList();
}
// 已回收查询
function RevokeQry(){
	var chkRevoke	= $('#chkRevoke').checkbox('getValue');
	if (!chkRevoke) {return;}
	ReLoadWorkList();
}
 /**
 * NUMS: W003
 * CTOR: liyi
 * DESC: 工作列表操作按钮模块
 * DATE: 2021-05-13
 * NOTE: 包括方法：
 * TABLE: 
 */

 // 保存
function SubmitRetrieve() {
	var data	= $("#gridWorkList").datagrid("getData");
	var selData	= $('#gridWorkList').datagrid('getSelections');
	var length	= data.total;
	var selLen	= selData.length;

	if (length<1) {
		$.messager.popover({msg: '工作列表中无需要保存记录！',type: 'alert',timeout: 1500});
		return;
	}
	if (selLen==0) {
		$.messager.popover({msg: '请至少勾选一条需要保存的记录！',type: 'alert',timeout: 1500});
		return;
	}

	var ExpandIDs = '';
	for (var i = 0; i < selLen; i++) {
		var selRowArray = selData[i];
		ExpandIDs += ',' + selRowArray.ExpandID;
	}
	
	if (ExpandIDs != '') ExpandIDs = ExpandIDs.substr(1,ExpandIDs.length-1);
	
	var flg = $m({
		ClassName:"MA.IPMR.SS.VolReCallExpand",
		MethodName:"Retrieve",
		aExpandIDs:ExpandIDs,
		aUserID:Logon.UserID
	},false);
	
	if (parseInt(flg) <= 0) {
		$.messager.alert("错误", flg, 'error');
		return;
	}else{
		ReLoadWorkList();	// 重新加载工作列表
	}
	
}

// 删除
function Detach() {
	var MrTypeID	= $('#cboMrType').combobox('getValue');
	if (!MrTypeID) {
		$.messager.popover({msg: '请选择病案类型！',type: 'alert',timeout: 1000});
		return;
	}
	var rows = $('#gridWorkList').datagrid('getSelections');  		//取得所有选中行数据，返回元素记录的数组数据
	if (rows.length>0) {
		$.messager.confirm('确认', '确认移除选中数据?', function(r){
			if (r) {
				for (var i = 0; i < rows.length; i++) {
					var rowArray = rows[i];
					var ExpandID = rowArray.ExpandID;
					
					var flg = $m({
						ClassName:"MA.IPMR.SSService.VolReCallExpandSrv",
						MethodName:"DelWorkList",
						aMrTypeID:MrTypeID,
						aExpandIDs:ExpandID,
						aUserID:Logon.UserID
					},false);
					
					if (parseInt(flg) <= 0) {
						var rowIndex = $('#gridWorkList').datagrid('getRowIndex',rowArray)+1;  //获取行号
						$.messager.alert("错误", "删除行 " + rowIndex + " 数据错误!Error=" + flg, 'error');
					} else {
						var rowindex = $('#gridWorkList').datagrid('getRowIndex', rows[i]);
						$('#gridWorkList').datagrid('deleteRow',rowindex);
						$('#gridWorkList').datagrid('unselectAll');
						$("#gridWorkList").datagrid("clearSelections");
					}
				}
			}
		});
	}else{
		$.messager.popover({msg: '请选中数据记录,再点击删除！',type: 'alert',timeout: 1500});
		return;
	}
}

// 清空
function Clean() {
	var MrTypeID	= $('#cboMrType').combobox('getValue');
	if (!MrTypeID) {
		$.messager.popover({msg: '请选择病案类型！',type: 'alert',timeout: 1000});
		return;
	}
	
	var data	= $("#gridWorkList").datagrid("getData");
	var length	= data.total;
	
	if (length>0) {
		$.messager.confirm('确认', '确认清空列表?', function(r){
			if (r){
				var flg = $m({
					ClassName:"MA.IPMR.SSService.VolReCallExpandSrv",
					MethodName:"ClearWorkList",
					aMrTypeID:MrTypeID,
					aUserID:Logon.UserID
				},false);
				
				if (parseInt(flg) <= 0) {
					$.messager.alert("错误", "清空失败!" + flg, 'error');
				} else {
					$('#gridWorkList').datagrid('loadData',{"total": 0, "rows": []});
					$('#gridWorkList').datagrid('unselectAll');
					$("#gridWorkList").datagrid("clearSelections");
				}
			}
		});
	} else{
		$.messager.popover({msg: '列表中无数据！',type: 'alert',timeout: 1000});
	}
}

// 撤销
function Revoke(){
	var UpdoFlag	= $('#chkRevoke').checkbox('getValue');
	if (!UpdoFlag) {return;}
	var MrTypeID	= $('#cboMrType').combobox('getValue');
	if (!MrTypeID) {
		$.messager.popover({msg: '请选择病案类型！',type: 'alert',timeout: 1000});
		return;
	}
	
	var data	= $("#gridWorkList").datagrid("getData");
	var selData	= $('#gridWorkList').datagrid('getSelections');
	var length	= data.total;
	var selLen	= selData.length;
	
	var ExpandIDs = '';
	for (var i = 0; i < selLen; i++) {
		var selRowArray = selData[i];
		ExpandIDs += ',' + selRowArray.ExpandID;
	}
	if (ExpandIDs != '') ExpandIDs = ExpandIDs.substr(1,ExpandIDs.length-1);
	
	if (ExpandIDs == ''){
		$.messager.popover({msg: '请选择需撤销的记录！',type: 'alert',timeout: 1000});
		return false;
	}
	$.messager.confirm('提示', '请确认是否撤销?', function(r){
		if (r){
			var flg = $m({
				ClassName:"MA.IPMR.SS.VolReCallExpand",
				MethodName:"UnRetrieve",
				aExpandIDs:ExpandIDs,
				aUserID:Logon.UserID,
				aResume:r
			},false);
			
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误", "撤销失败!" + '<br>' + flg, 'error');
			} else {
				$('#gridWorkList').datagrid('reload');
				$('#gridWorkList').datagrid('unselectAll');
				$("#gridWorkList").datagrid("clearSelections");
			}
		}
	});
}

 /**
 * NUMS: W004
 * CTOR: liyi
 * DESC: 记录选择弹框模块
 * DATE: 2021-05-13
 * NOTE: 包括方法：
 * TABLE: 
 */
// 初始化弹框
function InitExpandSelView(HospID,MrTypeID,Number){
	var ReCallExpandDialog =$HUI.dialog('#ReCallExpandDialog',{
		title:'记录列表',
		iconCls:'icon-w-edit',
		modal:true,
		minimizable:false,
		maximizable:false,
		collapsible:false,
	    buttons:[{
			text:'添加',
			iconCls:'icon-w-add',
			handler:function(){
				var selData	= $('#gridReCallExpand').datagrid('getSelections');
				var selLen	= selData.length;
				// 被勾选信息
				var ExpandIDs = '';
				for (var i = 0; i < selLen; i++) {
					var selRowArray = selData[i];
					ExpandIDs += ',' + selRowArray.ExpandID;
				}
				if (ExpandIDs != '') ExpandIDs = ExpandIDs.substr(1,ExpandIDs.length-1);
				if (ExpandIDs==''){
					$.messager.popover({msg: '请选择至少一条记录！',type: 'alert',timeout: 1000});
					return;
				}
				var MrTypeID=$('#gridReCallExpand').datagrid('options').queryParams['aMrTypeID'];
				SaveInWorkList(MrTypeID,ExpandIDs);
				$('#ReCallExpandDialog').window("close");		// 关闭页面
				Common_Focus('txtNumber');
			}
		},{
			text:'关闭',
			iconCls:'icon-w-close',
			handler:function(){
				$('#ReCallExpandDialog').window("close");		// 关闭页面
			}	
		}]
	});
	$('#ReCallExpandDialog').window('open');
	
}
// 初始化弹框表格
function InitgridReCallExpand(HospID,MrTypeID,Number){
	var columns = [[
		{field:'gVolSel_ck',checkbox:true},
		{field:'PatName',title:'姓名',width:120,align:'left'},
		{field:'PapmiNo',title:'登记号',width:100,align:'left'},
		{field:'MrNo',title:'病案号',width:100,align:'left'},
		{field:'DischLocDesc',title:'出院科室',width:150,align:'left'},
		{field:'DischWardDesc',title:'出院病区',width:150,align:'left'},
		{field:'DischDate',title:'出院日期',width:100,align:'left'},
		{field:'Title',title:'病历文书',width:150,align:'left'},
		{field:'DocName',title:'主治医师',width:120,align:'left'},
		{field:'ApplyUser',title:'申请人',width:120,align:'left'},
		{field:'ApplyDate',title:'申请时间',width:160,align:'left',
			formatter: function(value,row,index){
				return row.ApplyDate+ ' ' + row.ApplyTime;
			}
		}
	]];
	var gridReCallExpand = $HUI.datagrid("#gridReCallExpand",{
		fit:true,
		title:"",
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false,		//如果为true, 则显示一个行号列
		singleSelect:false,
		autoRowHeight: false,	//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		fitColumns:false,		//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		checkOnSelect:true,		//true,击某一行时，选中/取消选中复选框
		selectOnCheck:true,		//true,点击复选框将会选中该行
		url:$URL,
		queryParams:{
			ClassName:"MA.IPMR.SSService.VolReCallExpandSrv",
			QueryName:"QryExpand",
			aHospID:HospID,
			aMrTypeID:MrTypeID,
			aDateType:'',
			aDateFrom:'',
			aDateTo:'',
			aDisLocID:'',
			aDisWardID:'',
			aRegUserID:'',
			aNumber:Number,
			aIsRetrieve:'0',
			rows:100
		},
		columns :columns,
		onLoadSuccess: function(data){
			if (data.rows.length==1){	// 只有一条记录直接加入列表
				SaveInWorkList(MrTypeID,data.rows[0].ExpandID);
			}else{
				if (data.rows.length > 0) {
					InitExpandSelView();		//显示弹框
				}
			}
		}
	});
}

// 将选中记录加到工作列表
function SaveInWorkList(MrTypeID,ExpandIDs){
	var flg = $m({
		ClassName:"MA.IPMR.SSService.VolReCallExpandSrv",
		MethodName:"SetWorkList",
		aMrTypeID:MrTypeID,
		aExpandIDs:ExpandIDs,
		aUserID:Logon.UserID
	},false);
	if (parseInt(flg) <= 0) {
		$.messager.alert("错误", "添加失败!", 'error');
		return;
	}else{
		ReLoadWorkList();	// 重新加载工作列表
		Common_Focus('txtNumber');
	}
}