/**
 * copy 病案复印
 * 
 * Copyright (c) 2018-2020 liyi. All rights reserved.
 * 
 * CREATED BY liyi 2020-09-15
 * 
 * 注解说明
 * TABLE: 
 */

//页面全局变量对象
var globalObj = {
	m_WFIConfig			:'',	  // 操作项目配置属性
	m_ToUserID			:'',	  // 验证用户
	m_RecordIDs			:''       // 工作区选中的卷
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
	InitGridWorkList();
}

function InitEvent(){
	$HUI.combobox('#cboMrType',{
		onSelect:function(rows){
			$m({
				ClassName:"CT.IPMR.BT.WorkFItem",
				MethodName:"GetWFItemBySysOpera",
				aMrTypeID:rows["ID"],
				aSysOpera:'C',
				aWorkSubFlow:'C'
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
			var chkRevoke	= $('#chkRevoke').checkbox('getValue');
			if (chkRevoke) {
				RevokeQry();
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
		
	// 病案号|登记号|条码
	$('#txtNumber').bind('keyup', function(event) {					
	　　if (event.keyCode == "13") {
			NumberSearch();
	　　}
	});
	// 姓名
	$('#txtPatName').bind('keyup', function(event) {					
	　　if (event.keyCode == "13") {
			NameSearch();
	　　}
	});
}

 /**
 * NUMS: W001
 * CTOR: WHui
 * DESC: 工作列表模块
 * DATE: 2019-11-15
 * NOTE: 包括方法：InitGridWorkList，ReLoadWorkList
 * TABLE: 
 */

// 初始化工作列表
function InitGridWorkList(){
	var columns = [[
		{field:'workList_ck',title:'sel',checkbox:true},
		{field:'PatName',title:'姓名',width:120,align:'left'},
		{field:'PapmiNo',title:'登记号',width:100,align:'left'},
		{field:'MrNo',title:'病案号',width:100,align:'left'},
		{field:'Sex',title:'性别',width:60,align:'left'},
		{field:'Age',title:'年龄',width:60,align:'left'},
		{field:'FillNo',title:'归档号',width:100,align:'left'},
		{field:'IdentityCode',title:'身份证号',width:100,align:'left'},
		{field:'DocName',title:'住院医师',width:100,align:'left'},
		{field:'VolStatusDesc',title:'当前状态',width:100,align:'left'},
		{field:'StepDesc',title:'当前步骤',width:80,align:'left'},
		{field:'DischLocDesc',title:'出院科室',width:150,align:'left'},
		{field:'DischWardDesc',title:'出院病区',width:150,align:'left'},
		{field:'AdmDate',title:'入院日期',width:100,align:'left'},
		{field:'DischCondit',title:'出院情况',width:80,align:'left'},
		{field:'DischDate',title:'出院日期',width:100,align:'left'}
	]];
	var gridWorkList = $HUI.datagrid("#gridWorkList",{
		fit:true,
		//title:"病案复印",
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
		sortName:'RowIndex',
		sortOrder:'desc',
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
			rows:10000
		},
		columns :columns
	});
}

// 加载工作列表
function ReLoadWorkList(){
	$('#gridWorkList').datagrid('reload',  {
		ClassName:"MA.IPMR.SSService.OperationQry",
		QueryName:"QryOperaVolList",
		aHospID:$('#cboHospital').combobox('getValue'),
		aMrTypeID:parseInt($('#cboMrType').combobox('getValue')),
		aWFItemID:globalObj.m_WFIConfig.WFItemID,
		aDateFrom:'',
		aDateTo:'',
		aDischLoc:'',
		aDischWard:'',
		aUserID:Logon.UserID,
		aOperaFlag:'',
		aUserFrom:'',
		aUserTo:'',
		rows:10000
	});
	$('#gridWorkList').datagrid('unselectAll');
}

 /**
 * NUMS: W002
 * CTOR: WHui
 * DESC: 查询表单模块
 * DATE: 2019-11-15
 * NOTE: 包括方法：NumberSearch
 * TABLE: 
 */

// 通过号码查询
function NumberSearch(){
	$('#txtPatName').val('');
	var chkRevoke	= $('#chkRevoke').checkbox('getValue');
	var MrTypeID	= $('#cboMrType').combobox('getValue');
	var ItemID		= globalObj.m_WFIConfig.ItemID;
	var WFItemID	= globalObj.m_WFIConfig.WFItemID;
	var Number		= $('#txtNumber').val();
	var WFItemDesc	= globalObj.m_WFIConfig.WFItemDesc;
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
	InitGridVolSel(HospID,MrTypeID,globalObj.m_WFIConfig,Number,'');		// 卷选择页面Query
	$('#txtNumber').val('');
}
// 通过姓名查询
function NameSearch(){
	$('#txtNumber').val('');
	var chkRevoke	= $('#chkRevoke').checkbox('getValue');
	var MrTypeID	= $('#cboMrType').combobox('getValue');
	var ItemID		= globalObj.m_WFIConfig.ItemID;
	var WFItemID	= globalObj.m_WFIConfig.WFItemID;
	
	var WFItemDesc	= globalObj.m_WFIConfig.WFItemDesc;
	var HospID		= $('#cboHospital').combobox('getValue');
	var PatName		= $('#txtPatName').val();
	
	var errinfo		= '';
	if (!HospID) {
		errinfo = errinfo + "请选择医院!<br>";
	}
	if (!MrTypeID) {
		errinfo = errinfo + "请选择病案类型!<br>";
	}
	if (!PatName) {
		errinfo = errinfo + "请输入姓名!<br>";
	}
	
	if (errinfo) {
		$.messager.alert("提示",errinfo,"info");
		return;
	}
	InitGridVolSel(HospID,MrTypeID,globalObj.m_WFIConfig,'',PatName);		// 卷选择页面Query
	$('#txtPatName').val('');
}

 /**
 * NUMS: W003
 * CTOR: WHui
 * DESC: 工作列表操作按钮模块
 * DATE: 2019-11-15
 * NOTE: 包括方法：SubmitVols
 * TABLE: 
 */

// 提交卷
function SubmitVols(){
	SaveOpera(1);
}

// 保存操作(附加信息页面调用step=2,校验用户页面调用step=3,主页面"保存"step=1)
function SaveOpera(Step){
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
		$.messager.popover({msg: '工作列表中无需要保存卷信息！',type: 'alert',timeout: 1500});
		return;
	}
	if (selLen==0) {
		$.messager.popover({msg: '请至少勾选一条需要保存卷信息！',type: 'alert',timeout: 1500});
		return;
	}

	var RecordIDs = '';
	for (var i = 0; i < selLen; i++) {
		var selRowArray = selData[i];
		RecordIDs += ',' + selRowArray.RecordID;
	}
	
	if (RecordIDs != '') RecordIDs = RecordIDs.substr(1,RecordIDs.length-1);
	globalObj.m_RecordIDs	= RecordIDs		// 工作区选中的卷
	if (Step<2) {
		InitCopyView('C','C');
		return
	}
	if (Step<3){
		if ((globalObj.m_WFIConfig.CheckUser == '1')&&(ServerObj.EnsSysConfig=='0')){	// 独立服务器部署不校验用户
			InitCheckUser();
			return;
		}
	}
	
	var WFDetail = Copy_ArgsObj.CopyInfo;	 // 附加信息
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

// 移出工作列表
function Detach(){
	var MrTypeID	= $('#cboMrType').combobox('getValue');
	var WFItemID	= globalObj.m_WFIConfig.WFItemID;
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
		$.messager.popover({msg: '请选中数据记录,再点击删除！',type: 'alert',timeout: 1500});
		return;
	}
}

// 清空工作列表
function Clean(){
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