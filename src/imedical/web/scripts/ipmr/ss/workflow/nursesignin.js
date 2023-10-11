/**
 * nursesignin 护士送交
 * 
 * Copyright (c) 2018-2023 cpj. All rights reserved.
 * 
 * CREATED BY cpj 2023-04-10
 * 
 * 注解说明
 * TABLE: 
 */

//页面全局变量对象
var globalObj = {
	m_WFIConfig			:'',	  // 操作项目配置属性
	m_QryType			:'',	  // 待送交按钮点击标记
	m_ToUserID			:'',	  // 验证用户
	m_RecordIDs			:''       // 工作区选中的卷
}

$(function(){
	//初始化
	Init();
	
	//事件初始化
	InitEvent();

})

function Init() {
	$('#chkRevoke').checkbox('setValue',false);
	$('#btnRevoke').linkbutton("disable");
	$('#btnRevokeQry').linkbutton("disable");
	Common_ComboToHosp("cboHospital",'',Logon.HospID);
	Common_ComboToMrType("cboMrType",ServerObj.MrClass);
	var tdateFrom	= Common_GetDate(-30,"");
	var tdateTo		= Common_GetDate(0,"");	
	$('#dfDateFrom').datebox('setValue', tdateFrom);		// 给日期框赋值
	$('#dfDateTo').datebox('setValue', tdateTo);			// 给日期框赋值
	
	// 科室和病区下拉权限控制
	if (ServerObj.AdminCode == 0) {
		Common_ComboToLoc("cboDiscLoc","","E",Logon.HospID,'','',"");			// 科室
		Common_ComboToLoc("cboDiscWard","","W",Logon.HospID,'','','',Logon.WardID);			// 病区
		$("#cboHospital").combobox({disabled: true})
		$("#cboDiscLoc").combobox({disabled: true})
		$("#cboDiscWard").combobox({disabled: true})
	} else {
		Common_ComboToLoc("cboDiscLoc","","E",Logon.HospID,'I','');			// 科室
		Common_ComboToLoc("cboDiscWard","","W",Logon.HospID,'','');			// 病区
	}
	InitGridWorkList();
}

function InitEvent() {	
	$HUI.combobox('#cboMrType',{
		onSelect:function(rows) {
			$m({
				ClassName:"CT.IPMR.BT.WorkFItem",
				MethodName:"GetWFItemBySysOpera",
				aMrTypeID:rows["ID"],
				aSysOpera:'NI'
			},function(rtn){
				if (rtn==''){
					$.messager.alert("提示", "工作流维护错误，请检查工作流配置!", 'info');
					return;
				}
				rtn = JSON.parse(rtn);
				globalObj.m_WFIConfig = {
					WFItemID 	: rtn.ID,
					WFItemDesc	: rtn.BWAlias,
					ItemID		: rtn.BWItem,
					ItemType	: rtn.BWType,
					SubFlow		: rtn.BWSubFlow,
					SysOpera	: rtn.BWSysOpera,
					PreStep		: rtn.BWPreStep,
					PreItems	: rtn.BWPreItems,
					PostStep	: rtn.BWPostStep,
					CheckUser	: rtn.BWCheckUser,
					BeRequest	: rtn.BWBeRequest,
					BatchOper	: rtn.BWBatchOper,
					MRCategory	: rtn.BWMRCategory
				}
				ReLoadWorkList();
			});
		}
	});
	
	$HUI.combobox('#cboHospital',{
		onSelect:function(rows){
			if (ServerObj.AdminCode == 0) {
				Common_ComboToLoc("cboDiscLoc","","E",rows["HospID"],'','',"");			// 科室
				Common_ComboToLoc("cboDiscWard","","W",rows["HospID"],'','','',Logon.WardID);			// 病区
			} else {
				Common_ComboToLoc("cboDiscLoc","","E",rows["HospID"],'I','');			// 科室
				Common_ComboToLoc("cboDiscWard","","W",rows["HospID"],'','');			// 病区
			}
			var chkRevoke	= $('#chkRevoke').checkbox('getValue');
			if (chkRevoke) {
				//RevokeQry();
			} else{
				$('#txtNumber').val('');
				ReLoadWorkList();
			}
		}
	});
	// 保存
	$('#btnSubmit').click(function(){
		SubmitVols();
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
				$('#btnRevokeQry').linkbutton("enable");		// 已送交按钮
				$('#btnTodoQry').linkbutton("disable");			// 待送交按钮
				$('#btnSubmit').linkbutton("disable");			// 保存
				$('#btnDetach').linkbutton("disable");			// 删除
				$('#btnClean').linkbutton("disable");			// 清空
				$('#btnRevoke').linkbutton("enable");
				$('#txtNumber').val('');
				$("#dfDateFromid").html($g('送交日期'));
				var tdateFrom	= Common_GetDate(0,"");
				var tdateTo		= Common_GetDate(0,"");	
				$('#dfDateFrom').datebox('setValue', tdateFrom);		// 给日期框赋值
				$('#dfDateTo').datebox('setValue', tdateTo);			// 给日期框赋值
				if (ServerObj.AdminCode == 1) {
					$('#cboDiscLoc').combobox('setValue','') ;
					$('#cboDiscWard').combobox('setValue','') ;
				}
				globalObj.m_QryType = '2';
				$('#gridWorkList').datagrid('loadData',{"total":0,"rows":[]});
			} else{
				$('#btnRevokeQry').linkbutton("disable");		// 已送交按钮
				$('#btnTodoQry').linkbutton("enable");			// 待送交按钮
				$('#btnSubmit').linkbutton("enable");			// 保存
				$('#btnDetach').linkbutton("enable");			// 删除
				$('#btnClean').linkbutton("enable");			// 清空
				$('#btnRevoke').linkbutton("disable");
				$('#txtNumber').val('');
				$("#dfDateFromid").html($g('出院日期'));
				var tdateFrom	= Common_GetDate(-30,"");
				var tdateTo		= Common_GetDate(0,"");	
				$('#dfDateFrom').datebox('setValue', tdateFrom);		// 给日期框赋值
				$('#dfDateTo').datebox('setValue', tdateTo);			// 给日期框赋值
				if (ServerObj.AdminCode == 1) {
					$('#cboDiscLoc').combobox('setValue','') ;
					$('#cboDiscWard').combobox('setValue','') ;
				}
				globalObj.m_QryType = '1';
				ReLoadWorkList();		// 取消勾选撤销操作-加载待操作
			}
		}
	});
	
	// 未送交查询
	$('#btnTodoQry').click(function(){
		TodoQry();
	});	

	// 已送交查询
	$('#btnRevokeQry').click(function(){
		RevokeQry();
	});	
	
	$('#btnExport').click(function(){
		var data = $('#gridWorkList').datagrid('getData');
		if (data.rows.length==0)
		{
			$.messager.popover({msg: '请先查询再导出！',type: 'alert',timeout: 1000});
			return;
		}
		
		var filename ='';
		switch (globalObj.m_QryType)
		{
			case "2":
				filename='已送交病历'
				break;
			case "1":
				filename='未送交病历';
				break;
			default:
				filename='未送交病历';
				break;
		}
		$('#gridWorkList').datagrid('exportByJsxlsx', {
			filename: filename,
			extension:'xls'
		});
	});
	$('#btnPrint').click(function(){
		var data = $('#gridWorkList').datagrid('getData');
		if (data.rows.length==0)
		{
			$.messager.popover({msg: '请先查询再打印！',type: 'alert',timeout: 1000});
			return;
		}
		var title ='';
		switch (globalObj.m_QryType)
		{
			case "2":
				title='已送交病历'
				break;
			case "1":
				title='未送交病历';
				break;
			default:
				title='未送交病历';
				break;
		}
		$('#gridWorkList').datagrid('print', {
			title: title,
			model: '1',	// 通过后台
			columns:['PatName','MrNo','DischLocDesc','DischDate','DocName','HappenUserDesc','HappenDate']
		});
	});
	// 病案号|登记号|条码
	$('#txtNumber').bind('keyup', function(event) {					
	　　if (event.keyCode == "13") {
			NumberSearch();
	　　}
	});
}

 /**
 * NUMS: W001
 * CTOR: cpj
 * DESC: 工作列表模块
 * DATE: 2021-07-03
 * NOTE: 包括方法：
 * TABLE: 
 */

// 初始化工作列表
function InitGridWorkList(){
	var columns = [[
		{field:'workList_ck',title:'sel',checkbox:true},
		/*{field:'ProblemDesc',title:'标记',width:100,align:'center'},*/
		{field:'ProblemDesc',title:'标记',width:40,align:'center',
			formatter: function(value,row,index){
				if (value==''){
					return '';
				}else{
					return "<span title='" + value + "'>" + "<img src='../scripts/ipmr/img/error.png'>" + "</span>";
				}
			}
		},
		{field:'PatName',title:'姓名',width:60,align:'left'},
		{field:'MrNo',title:'病案号',width:80,align:'left'},
		{field:'DischLocDesc',title:'出院科室',width:100,align:'left'},
		{field:'DischWardDesc',title:'出院病区',width:120,align:'left'},
		{field:'DischDate',title:'出院日期',width:80,align:'left'},
		{field:'DocName',title:'主管医师',width:80,align:'left'},
		{field:'EmrComplete',title:'医生提交',width:60,align:'left',
			formatter: function(value,row,index){
				if (value==1) {
					return $g('是');
				}else{
					return $g('否');
				}
			}
		},
		{field:'HappenUserDesc',title:'送交人',width:60,align:'left'},
		{field:'HappenDate',title:'送交日期',width:80,align:'left'}
	]];
	var gridWorkList = $HUI.datagrid("#gridWorkList",{
		fit:true,
		title:'病案送交',
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: true, 		//如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false,		//如果为true, 则显示一个行号列
		//sortOrder:'asc',  //asc  desc
		//sortName:'RowIndex',
		singleSelect:false,
		autoRowHeight: false,	//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 500,
		pageList:[100,200,500,1000],
		fitColumns:true,		//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		striped:false,			//设置为 true，则把行条纹化。（即奇偶行使用不同背景色）  默认为false
		checkOnSelect:true,		//true,击某一行时，选中/取消选中复选框
		selectOnCheck:true,		//true,点击复选框将会选中该行
		url:$URL,
		queryParams:{
			ClassName:"MA.IPMR.SSService.OperationQry",
		    QueryName:"QryOperaVolList",
			aHospID:'',
			aMrTypeID:'',
			aWFItemID:'',
			aDateFrom:'',
			aDateTo:'',
			aDischLoc:'',
			aDischWard:'',
			aUserID:'',
			aOperaFlag:'',
			aUserFrom:'',
			aUserTo:'',
			aEmrComplete:'',
			rows:10000
		},
		columns :columns,
		rowStyler:function(index,row){
			if(row.ProblemCode!=='1'){
				return 'background-color:#BEBEBE;color:#fff;';
			}
		},
		onLoadSuccess: function(data){
			if (data.rows.length > 0) {
				for (var i = 0; i < data.rows.length; i++) {
					if (data.rows[i].ProblemCode !== '1') {			// 根据ProblemCode让某些行不可选
						$("#main input:checkbox[name='workList_ck']")[i].disabled = true;
					}
				} 
			}
		},
		onClickRow: function(rowIndex, rowData){
			if (rowData.ProblemCode!=='1'){
				$('#gridWorkList').datagrid('unselectRow', rowIndex)
			}
		},
		onCheckAll: function(){
			var ProblemCount = 0;  //不可操作记录条数
			var data   = $("#gridWorkList").datagrid('getData');
			for (var i = 0; i < data.rows.length; i++) {
				if (data.rows[i].ProblemCode !== '1') {			// 根据ProblemCode让某些行不可选
					$('#gridWorkList').datagrid('unselectRow', i);
					ProblemCount++;
				}
			} 
			if(ProblemCount>0) {
				$.messager.alert("提示", "存在" + ProblemCount + "条不可操作的病案卷!", 'info');
			}
		}
		/*
		onBeforeSelect:function(rowIndex,rowData) { //撤销之前检查是否已经送交，送交了以后，不允许在撤销
			if ($('#chkRevoke').checkbox('getValue')) {	//勾选了撤销框
				var BackUser = rowData.BackUserName;
				if (BackUser) {
					$.messager.alert("提示","病案室已回收，不允许在撤销","info");
					return false;
				}
			}
			else{   //控制没有医师提交的话，不允许护士提交
				var SubmitDocName = rowData.DocSubmitDocName;
				if (SubmitDocName=="") {
					$.messager.alert("提示","医生还未提交，不允许送交病案","info");
					return false;
				}
			}
		},
		onBeforeCheck:function(ind,rowData) {
			if ($('#chkRevoke').checkbox('getValue')) {	//勾选了撤销框
				var BackUser = rowData.BackUserName;
				if (BackUser) {
					$.messager.alert("提示","病案室已回收，不允许在撤销","info");
					return false;
				}
			}
		}*/
	});
}

// 加载工作列表
function ReLoadWorkList(){
	var NurName = ServerObj.NurName;
	if ($('#chkRevoke').checkbox('getValue')) {
		$('#gridWorkList').datagrid('reload', {
			ClassName:"MA.IPMR.SSService.OperationQry",
			QueryName:"QryUpdoVolList",
			aHospID:$('#cboHospital').combobox('getValue'),
			aMrTypeID:parseInt($('#cboMrType').combobox('getValue')),
			aWFItemID:globalObj.m_WFIConfig.WFItemID,
			aUserFrom:Logon.UserID,
			aInputNo:$('#txtNumber').val(),
			aDateFrom:$('#dfDateFrom').datebox('getValue'),
			aDateTo:$('#dfDateTo').datebox('getValue'),
			aUserTo:'',
			aDischLoc:$('#cboDiscLoc').combobox('getValue'),
			aDischWard:$('#cboDiscWard').combobox('getValue'),
			aPatName:'',
			rows:10000
		});
		$('#gridWorkList').datagrid('unselectAll');
	} else{
		$('#gridWorkList').datagrid('reload',  {
			ClassName:"MA.IPMR.SSService.OperationQry",
			QueryName:"QryOperaVolList",
			aHospID:$('#cboHospital').combobox('getValue'),
			aMrTypeID:parseInt($('#cboMrType').combobox('getValue')),
			aWFItemID:globalObj.m_WFIConfig.WFItemID,
			aDateFrom:$('#dfDateFrom').datebox('getValue'),
			aDateTo:$('#dfDateTo').datebox('getValue'),
			aDischLoc:$('#cboDiscLoc').combobox('getValue'),
			aDischWard:$('#cboDiscWard').combobox('getValue'),
			aUserID:Logon.UserID,
			aOperaFlag:globalObj.m_QryType,
			aUserFrom:'',
			aUserTo:'',
			aEmrComplete:$('#cboEmrComplete').combobox('getValue'),
			rows:10000
		});
		$('#gridWorkList').datagrid('unselectAll');
	}
}

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
		InitGridVolSel(HospID,MrTypeID,globalObj.m_WFIConfig,Number);		// 卷选择页面Query
		$('#txtNumber').val('');
	} else{
		RevokeQry();		// 由号码查询送交记录
		$('#txtNumber').val('');
	}
}

// 查询待送交卷列表
function TodoQry(){
	var HospID		= $('#cboHospital').combobox('getValue');
	var MrTypeID	= $('#cboMrType').combobox('getValue');
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
	if (DateFrom==''){
		$.messager.popover({msg: '请选择出院日期！',type: 'alert',timeout: 1000});
		return;
	}
	if (DateTo==''){
		$.messager.popover({msg: '请选择结束日期！',type: 'alert',timeout: 1000});
		return;
	}
	globalObj.m_QryType = 1;
	ReLoadWorkList();
}

// 已送交查询
function RevokeQry(){
	var chkRevoke	= $('#chkRevoke').checkbox('getValue');
	
	if (!chkRevoke) {return;}
	ReLoadWorkList();
}

 // 保存
function SubmitVols() {
	//需求，护士在14：30 到16：00 不允许保存
	var nowDateTime = new Date();
	var nowH = nowDateTime.getHours();
	var nowM = nowDateTime.getMinutes();
	var nowAllM = parseInt(nowH * 60 + nowM);
	var minM = 14 * 60 + 30;
	var maxM = 16 * 60 ;
	if ((nowAllM > minM ) && (nowAllM < maxM)) {
		//$.messager.popover({msg: '14:30 至 16:00 期间不允许送交操作，请重新安排时间！',type: 'alert',timeout: 2000});
		//return ;	
	}
	var MrTypeID	= $('#cboMrType').combobox('getValue');
	var WFItemID	= globalObj.m_WFIConfig.WFItemID;
	var SubFlow		= globalObj.m_WFIConfig.SubFlow;	// 操作流程, 顺序O、质控Q、借阅L、复印C、封存S
	var	SysOpera	= globalObj.m_WFIConfig.SysOpera;	// 病案回收RC,病案编目FP,病历质控QC,归档上架S...
	if (!MrTypeID) {
		$.messager.popover({msg: '请选择病案类型！',type: 'alert',timeout: 1000});
		return;
	}
	
	var data	= $("#gridWorkList").datagrid("getData");
	var selData	= $('#gridWorkList').datagrid('getSelections');
	var length	= data.total;
	var selLen	= selData.length;

	if (length<1) {
		$.messager.popover({msg: '工作列表中无需要保存卷信息！',type: 'alert',timeout: 1000});
		return;
	}
	
	if (selLen == 0) {
		$.messager.popover({msg: '请至少勾选一条需要保存卷信息！',type: 'alert',timeout: 1000});
		return;
	}

	var RecordIDs = '';
	for (var i = 0; i < selLen; i++) {
		var selRowArray = selData[i];
		RecordIDs += ',' + selRowArray.RecordID;
	}
	
	if (RecordIDs != '') RecordIDs = RecordIDs.substr(1,RecordIDs.length-1);
	
	var WFDetail	= '';	// 附加信息
	var flg = $m({
		ClassName:"MA.IPMR.SSService.OperationWL",
		MethodName:"WorkFlowOpera",
		aMrTypeID:MrTypeID,
		aWFItemID:WFItemID,
		aWFDetail:WFDetail,
		aUserID:Logon.UserID,
		aToUserID:globalObj.m_ToUserID,
		aRecordIDs:RecordIDs
	},false);
	
	if (parseInt(flg) <= 0) {
		$.messager.alert("错误", flg.split('^')[1], 'error');
		return;
	}else{
		globalObj.m_ToUserID='';
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
	var WFItemID	= globalObj.m_WFIConfig.WFItemID;
	
	var rows = $('#gridWorkList').datagrid('getSelections');  		//取得所有选中行数据，返回元素记录的数组数据
	if (rows.length>0) {
		$.messager.confirm('确认', '确认移除选中数据?', function(r){
			if (r) {
				for (var i = 0; i < rows.length; i++) {
					var rowArray = rows[i];
					var RecordID = rowArray.RecordID;
					
					var flg = $m({
						ClassName:"MA.IPMR.SSService.OperationWL",
						MethodName:"DelVolume",
						aMrTypeID:MrTypeID,
						aWFItemID:WFItemID,
						aRecordIDs:RecordID,
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
		$.messager.popover({msg: '请选中数据记录,再点击删除！',type: 'alert',timeout: 1000});
		return;
	}
}

// 清空
function Clean() {
	var MrTypeID	= $('#cboMrType').combobox('getValue');
	var WFItemID	= globalObj.m_WFIConfig.WFItemID;
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
					ClassName:"MA.IPMR.SSService.OperationWL",
					MethodName:"ClearVolume",
					aMrTypeID:MrTypeID,
					aWFItemID:WFItemID,
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
	var WFItemID	= globalObj.m_WFIConfig.WFItemID;
	var SubFlow		= globalObj.m_WFIConfig.SubFlow;	// 操作流程, 顺序O、质控Q、借阅L、复印C、封存S
	var	SysOpera	= globalObj.m_WFIConfig.SysOpera;	// 病案回收RC,病案编目FP,病历质控QC,归档上架S...
	
	if (!MrTypeID) {
		$.messager.popover({msg: '请选择病案类型！',type: 'alert',timeout: 1000});
		return;
	}
	
	var data	= $("#gridWorkList").datagrid("getData");
	var selData	= $('#gridWorkList').datagrid('getSelections');
	var length	= data.total;
	var selLen	= selData.length;
	
	var RecordIDs = '';
	for (var i = 0; i < selLen; i++) {
		var selRowArray = selData[i];
		RecordIDs += ',' + selRowArray.RecordID;
	}
	if (RecordIDs != '') RecordIDs = RecordIDs.substr(1,RecordIDs.length-1);
	
	if (RecordIDs == ''){
		$.messager.popover({msg: '请选择需撤销的操作记录！',type: 'alert',timeout: 1000});
		return false;
	}
	
	$.messager.prompt("提示", "输入撤销原因:", function (r) {
		if (r) {
			var flg = $m({
				ClassName:"MA.IPMR.SSService.OperationWL",
				MethodName:"UpdoWorkFlowOpera",
				aRecordIDs:RecordIDs,
				aUserID:Logon.UserID,
				aUpdoReason:r
			},false);
			
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误", "撤销失败!" + '<br>' + flg, 'error');
			} else {
				$('#gridWorkList').datagrid('reload');
				$('#gridWorkList').datagrid('unselectAll');
				$("#gridWorkList").datagrid("clearSelections");
			}
		} else {
			if (r=='') {
				$.messager.popover({msg: '输入信息为空，未做任何操作！',type: 'alert',timeout: 1000});
			}
		}
	});
}
