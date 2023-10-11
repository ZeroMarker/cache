/**
 * apply 病案借阅申请
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
	var tdateFrom	= Common_GetDate(-7,"");
	var tdateTo		= Common_GetDate(0,"");	
	$('#RequestDateFrom').datebox('setValue', tdateTo);		// 给日期框赋值
	$('#RequestDateTo').datebox('setValue', tdateTo);			// 给日期框赋值
	Common_ComboToDicCode('cboDataSource','MQDataSource',1,'');
	Common_ComboToDicCode('cboSex','CodeSex',1,'')
	Common_ComboToLoc("cboAdmLoc","","E",Logon.HospID,'I','');
	Common_ComboToLoc("cboDisLoc","","E",Logon.HospID,'I','');
	
	var cboDiagICD = $HUI.combogrid("#cboDiagICD", {
		url: $URL,
		panelWidth:450,
		panelHeight:300,
		editable: true,
		defaultFilter:4, 
		idField: 'ICD10',
		textField: 'ICD10',
		method:'Post',
		mode:'remote',
		multiple: false,
		enterNullValueClear:false,
		fitColumns:true,
		delay:500,
		sortName:'Count',
		sortOrder:'asc',
		columns:[[
		    {field:'ICD10',title:'ICD-10',width:130},
		    {field:'InPairCode',title:'副码',width:100},
		    {field:'Desc',title:'名称',width:370},
		   // {field:'OperTypeDesc',title:'手术类型',width:100},
		    {field:'Count',title:'序号',width:100,hidden:'true'}
		   ]]
		,queryParams:{
		    ClassName:'CT.IPMR.FPS.ICDDxSrv',
			QueryName:'QryICDDx',
			aVerID:ServerObj.ICD10Ver,
			aTypeID:'',
			aAlias:'' ,
			aIsActive:1,
			aICDDxID:'',
			rows:50
		},
		keyHandler: {
			query: function (q) {
				var queryParams=$("#cboDiagICD").combogrid('options').queryParams;
				$("#cboDiagICD").combogrid("grid").datagrid('load', {
					ClassName:queryParams.ClassName,
					QueryName:queryParams.QueryName,
					aVerID:queryParams.aVerID,
					aTypeID:queryParams.aTypeID,
					aAlias:q ,
					aIsActive:queryParams.aIsActive,
					aICDDxID:'',
					rows:50
				});
				$("#cboDiagICD").combogrid("setValue",q);
			}
		}
	});
	var cboOperICD = $HUI.combogrid("#cboOperICD", {
		url: $URL,
		panelWidth:450,
		panelHeight:300,
		editable: true,
		defaultFilter:4, 
		idField: 'ICD10',
		textField: 'ICD10',
		method:'Post',
		mode:'remote',
		multiple: false,
		enterNullValueClear:false,
		fitColumns:true,
		delay:500,
		sortName:'Count',
		sortOrder:'asc',
		columns:[[
		    {field:'ICD10',title:'ICD-9',width:130},
		    //{field:'InPairCode',title:'副码',width:100},
		    {field:'Desc',title:'名称',width:370},
		    {field:'OperTypeDesc',title:'手术类型',width:130},
		    {field:'Count',title:'序号',width:100,hidden:'true'}
		   ]]
		,queryParams:{
		    ClassName:'CT.IPMR.FPS.ICDDxSrv',
			QueryName:'QryICDDx',
			aVerID:ServerObj.ICD9Ver,
			aTypeID:'',
			aAlias:'' ,
			aIsActive:1,
			aICDDxID:'',
			rows:50
		},
		keyHandler: {
			query: function (q) {
				var queryParams=$("#cboOperICD").combogrid('options').queryParams;
				$("#cboOperICD").combogrid("grid").datagrid('load', {
					ClassName:queryParams.ClassName,
					QueryName:queryParams.QueryName,
					aVerID:queryParams.aVerID,
					aTypeID:queryParams.aTypeID,
					aAlias:q ,
					aIsActive:queryParams.aIsActive,
					aICDDxID:'',
					rows:50
				});
				$("#cboOperICD").combogrid("setValue",q);
			}
		}
	});
	Common_ComboGridToUser("cboDoc",'DOCTOR');
	Common_ComboToDic("cboPurpose","LendPurpose",1,'');
	Common_ComboToDic("cboPDFModel","PDFScanModel",1,'');
	InitgridVolume();
	InitgridICD();

	if (ServerObj.NoPaperSysSetting=='0'){
		var button=$('div.datagrid div.datagrid-toolbar a'); 
		for (var i = 0; i < button.length; i++) {
			var toolbar = button[i];
			var id = toolbar.id;
			 if (id == "btnApply2") {  //隐藏按钮
				$('div.datagrid div.datagrid-toolbar a').eq(i).hide();
			}
		}
		$("#lendtypelabel").remove();
		$("#lendtypeinput").remove();
	}
	Common_ComboToDic("cboLendTypeQ","LendType",1,'');
	Common_ComboToDic("cboStatusQ","LendRequestStatus",1,'');
	InitgridLendRequest()
}

function InitEvent(){
	$('#cboDataSource').combobox({
		onLoadSuccess:function(data){   //初始加载赋值
			if (data.length>0){
				$(this).combobox('select',data[0]['Code']);
			}
		}
	});
	$('#cboLendTypeQ').combobox({
		onLoadSuccess:function(data){   //初始加载赋值
			if (data.length>0){
				$(this).combobox('select',data[0]['ID']);
			}
		},
		onSelect:function(record){
			if (record.Code=='2')	// 电子病案
			{
				$('#gridLendRequest').datagrid('showColumn','PDFModelDesc');
				$('#gridLendRequest').datagrid('hideColumn','ExpBackDate');
			}
			if (record.Code=='1')	// 纸张病案
			{
				$('#gridLendRequest').datagrid('showColumn','ExpBackDate');
				$('#gridLendRequest').datagrid('hideColumn','PDFModelDesc');
			}
			reLoadGridLendRequest();
		}
	});
	if (ServerObj.NoPaperSysSetting==0){
		$('#gridLendRequest').datagrid('showColumn','ExpBackDate');
		$('#gridLendRequest').datagrid('hideColumn','PDFModelDesc');
		$('#edit_tabs').tabs('getTab','电子病案浏览').panel('options').tab.hide();
	}
}

 /**
 * NUMS: W001
 * CTOR: LIYI
 * DESC: 借阅申请-表单录入模块
 * DATE: 2021-09-09
 * NOTE: 包括方法：
 * TABLE: 
 */
$('#btnFind').click(function(){
	var DataSource = $('#cboDataSource').combobox('getValue');
	var MrNo = $('#txtMrNo').val();
	var PapmiNo = $('#txtPapmiNo').val();
	var PatName = $('#txtPatName').val();
	var Sex = $('#cboSex').combobox('getText');
	var AdmDateFrom = $('#AdmDateFrom').datebox('getValue');
	var AdmDateTo = $('#AdmDateTo').datebox('getValue');
	var AdmLoc = $('#cboAdmLoc').combobox('getText');
	var DisDateFrom = $('#DisDateFrom').datebox('getValue');
	var DisDateTo = $('#DisDateTo').datebox('getValue');
	var DisLoc = $('#cboDisLoc').combobox('getText');
	var IsMainDiag = $('#chkIsMainDiag').checkbox('getValue');
	IsMainDiag = IsMainDiag?1:0;
	var DiagICD = $('#cboDiagICD').combobox('getValue');
	var DiagDesc = $('#txtDiagDesc').val();
	var IsMainOper = $('#chkIsMainOper').checkbox('getValue');
	IsMainOper = IsMainOper?1:0;
	var OperICD = $('#cboOperICD').combobox('getValue');
	var OperDesc = $('#txtOperDesc').val();
	var DocID = $('#cboDoc').combobox('getValue');
	var DocDesc = $('#cboDoc').combobox('getText');
	if (DataSource==''){
		$.messager.popover({msg: '请选择数据源！',type: 'alert',timeout: 1000});
		return
	}
	if (((DisDateFrom=='')||(DisDateTo==''))&&(MrNo=='')&&(PapmiNo=='')&&(PatName==''))
	{
		$.messager.popover({msg: '请选择出院日期或录入病案号、登记号、姓名！',type: 'alert',timeout: 2000});
		return
	}
	var InputCondition = Logon.HospID;
	InputCondition = InputCondition + '^' + MrNo;
	InputCondition = InputCondition + '^' + PapmiNo;
	InputCondition = InputCondition + '^' + PatName;
	InputCondition = InputCondition + '^' + Sex;
	InputCondition = InputCondition + '^' + AdmDateFrom;
	InputCondition = InputCondition + '^' + AdmDateTo;
	InputCondition = InputCondition + '^' + DisDateFrom;
	InputCondition = InputCondition + '^' + DisDateTo;
	InputCondition = InputCondition + '^' + AdmLoc;
	InputCondition = InputCondition + '^' + DisLoc;
	InputCondition = InputCondition + '^' + DataSource;
	InputCondition = InputCondition + '^' + IsMainDiag;
	InputCondition = InputCondition + '^' + DiagICD;
	InputCondition = InputCondition + '^' + DiagDesc;
	InputCondition = InputCondition + '^' + IsMainOper;
	InputCondition = InputCondition + '^' + OperICD;
	InputCondition = InputCondition + '^' + OperDesc;
	InputCondition = InputCondition + '^' + DocID;
	InputCondition = InputCondition + '^' + DocDesc;
	InputCondition = InputCondition + '^' + ServerObj.ICD10Ver;
	InputCondition = InputCondition + '^' + ServerObj.ICD9Ver;
	$('#gridVolume').datagrid('reload',  {
		ClassName:"MA.IPMR.SSService.VolLendRequestSrv",
		QueryName:"QryVolume",
		aInput:InputCondition,
		rows:10000
	});
	$('#gridVolume').datagrid('unselectAll');
	$('#gridICD').datagrid('reload',  {
		ClassName:"MA.IPMR.SSService.VolLendRequestSrv",
		QueryName:"QryCodeICD",
		aVolumeID:'',
		rows:10000
	});
});

$('#btnClean').click(function(){
	$('#txtMrNo').val('');
	$('#txtPapmiNo').val('');
	$('#txtPatName').val('');
	$('#cboSex').combobox('setValue','');
	$('#AdmDateFrom').datebox('setValue','');
	$('#AdmDateTo').datebox('setValue','');
	$('#cboAdmLoc').combobox('setValue','');
	$('#DisDateFrom').datebox('setValue','');
	$('#DisDateTo').datebox('setValue','');
	$('#cboDisLoc').combobox('setValue','');
	$('#chkIsMainDiag').checkbox('setValue',false);
	$('#cboDiagICD').combobox('setValue','');
	$('#txtDiagDesc').val('');
	$('#chkIsMainOper').checkbox('setValue',false);
	$('#cboOperICD').combobox('setValue','');
	$('#txtOperDesc').val('');
	$('#cboDoc').combobox('setValue','');
});
 /**
 * NUMS: W002
 * CTOR: LIYI
 * DESC: 借阅申请-病案列表模块
 * DATE: 2021-09-09
 * NOTE: 包括方法：
 * TABLE: 
 */
// 初始化病案列表
function InitgridVolume(){
	var columns = [[
		{field:'workList_ck',title:'sel',checkbox:true},
		{field:'MrNo',title:'病案号',width:80,align:'left'},
		{field:'PapmiNo',title:'登记号',width:100,align:'left'},
		{field:'AdmTimes',title:'住院次数',width:80,align:'left'},
		{field:'PatName',title:'姓名',width:80,align:'left'},
		{field:'Sex',title:'性别',width:60,align:'left'},
		{field:'Age',title:'年龄',width:60,align:'left'},
		{field:'AdmDateTime',title:'入院日期',width:100,align:'left'},
		{field:'DisDateTime',title:'出院日期',width:100,align:'left'},
		{field:'AdmLoc',title:'入院科室',width:150,align:'left'},
		{field:'DisLoc',title:'出院科室',width:150,align:'left'},
		{field:'VolStatusDesc',title:'病历状态',width:100,align:'left'}
	]];
	var gridVolume = $HUI.datagrid("#gridVolume",{
		title:'病案列表',
		fit:true,
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true,		//如果为true, 则显示一个行号列
		singleSelect:true,
		autoRowHeight: false,	//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 500,
		pageList:[100,200,500,1000],
		fitColumns:true,		//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		checkOnSelect:false,		//true,击某一行时，选中/取消选中复选框
		selectOnCheck:false,		//true,点击复选框将会选中该行
		url:$URL,
		queryParams:{
			ClassName:"MA.IPMR.SSService.VolLendRequestSrv",
		    QueryName:"QryVolume",
			aInput:'',
			rows:10000
		},
		columns :columns
	});
}

// 病历列表选择事件
$('#gridVolume').datagrid({
	onSelect: function(rowIndex, rowData){
		if (rowData.DataSource=='EmrData'){
			$('#gridICD').datagrid('reload',  {
				ClassName:"MA.IPMR.SSService.VolLendRequestSrv",
				QueryName:"QryEmrICD",
				aVolumeID:rowData.VolumeID,
				rows:10000
			});
		}
		if (rowData.DataSource=='CodeData'){
			$('#gridICD').datagrid('reload',  {
				ClassName:"MA.IPMR.SSService.VolLendRequestSrv",
				QueryName:"QryCodeICD",
				aVolumeID:rowData.VolumeID,
				rows:10000
			});
		}
		$('#gridICD').datagrid('unselectAll');
	}
});
function saveRequest(requestid,admstr,lendtypecode) {
	var PDFModel = $('#cboPDFModel').combobox('getValue');
	var Purpose = $('#cboPurpose').combobox('getValue');
	var ExpBackDate = $('#ExpBackDate').datebox('getValue');
	var Resume = $('#txtResume').val();
	if (Purpose==''){
		$.messager.popover({msg: '请选择借阅目的！',type: 'alert',timeout: 1000});
		return
	}
	if (lendtypecode==1){
		if (ExpBackDate==''){
			$.messager.popover({msg: '请选择预计归还日期！',type: 'alert',timeout: 1000});
			return
		}
		var tExpBackDate = $m({
			ClassName:"MA.IPMR.IO.FromHisSrv",
			MethodName:"DateHtmlToLogical",
			aDate:ExpBackDate
		},false);
		if (tExpBackDate<ServerObj.NowDate)
		{
			$.messager.popover({msg: '预计归还日期不能小于当前日期！',type: 'alert',timeout: 1000});
			return
		}
		if (ExpBackDate==''){
			$.messager.popover({msg: '请选择预计归还日期！',type: 'alert',timeout: 1000});
			return
		}
	}
	if (lendtypecode==2){
		if (PDFModel==''){
			$.messager.popover({msg: '请选择浏览模式！',type: 'alert',timeout: 1000});
			return
		}
	}
	var inputstr = requestid;
	inputstr=inputstr+'^'+lendtypecode;
	inputstr=inputstr+'^'+Purpose;
	inputstr=inputstr+'^'+ExpBackDate;
	inputstr=inputstr+'^'+PDFModel;
	inputstr=inputstr+'^'+admstr;
	inputstr=inputstr+'^'+Logon.LocID;
	inputstr=inputstr+'^'+Logon.UserID;
	inputstr=inputstr+'^'+0;
	inputstr=inputstr+'^'+Resume;
	var ret = $m({
		ClassName:"MA.IPMR.SSService.VolLendRequestSrv",
		MethodName:"Request",
		aInputStr:inputstr
	},false);
	if (parseInt(ret) <= 0) {
		$.messager.alert("错误", '申请失败！', 'error');
		return;
	}else{
		// 取消选择
		$('#cboPurpose').combobox('setValue','')
		$('#ExpBackDate').datebox('setValue','');
		$('#txtResume').val('');
		$('#cboPDFModel').combobox('setValue','')
		$('#gridVolume').datagrid('uncheckAll');
		$('#RequestDialog').window("close");
	}
}
// 显示申请表单
function showReuestDialog(type) {
	var data	= $("#gridVolume").datagrid("getData");
	if (data.total==0){
		$.messager.popover({msg: '请先查询病历再申请！',type: 'alert',timeout: 1000});
		return
	}
	var chkData	= $('#gridVolume').datagrid('getChecked');
	var chkLen	= chkData.length;
	var AdmStr = '';
	for (var i = 0; i < chkLen; i++) {
		var chkRow = chkData[i];
		AdmStr += ',' + chkRow.EpisodeID;
	}
	if (AdmStr != '') AdmStr = AdmStr.substr(1,AdmStr.length-1);
	if (AdmStr==''){
		$.messager.popover({msg: '请选择需要借阅的病历！',type: 'alert',timeout: 1000});
		return
	}
	$('#RequestDialog').css('display','block');
	if (type==1) {
		var title = $g('纸质病案借阅申请');
		document.getElementById("trPDFModel").style.display = 'none';
		document.getElementById("trExpBackDate").style.display = 'table-row'; 
	}else{
		var title = $g('电子病案借阅申请');
		document.getElementById("trPDFModel").style.display = 'table-row';
		document.getElementById("trExpBackDate").style.display = 'none';
	}
	var RequestDialog = $HUI.dialog('#RequestDialog', {
		title: title,
		iconCls: 'icon-w-edit',
		modal: true,
		minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
		buttons:[{
			text:'提交',
				iconCls:'icon-w-save',
				handler:function(){
					var requestid = '';
					saveRequest(requestid,AdmStr,type);
				}
		}]
	});
}
// 申请浏览电子病案
$('#btnApply2').click(function(){
	showReuestDialog(2); 
});

// 申请借阅纸质病案
$('#btnApply1').click(function(){
	showReuestDialog(1); 
});

 /**
 * NUMS: W003
 * CTOR: LIYI
 * DESC: 借阅申请-诊断手术列表模块
 * DATE: 2021-09-09
 * NOTE: 包括方法：
 * TABLE: 
 */
// 初始化ICD列表
function InitgridICD(){
	var columns = [[
		{field:'TypeDesc',title:'类型',width:100,align:'left'},
		{field:'ICD',title:'编码',width:100,align:'left'},
		{field:'ICDDesc',title:'名称',width:300,align:'left'}
	]];
	var gridICD = $HUI.datagrid("#gridICD",{
		fit:true,
		title:'诊断手术',
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		//pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true,		//如果为true, 则显示一个行号列
		singleSelect:true,
		autoRowHeight: false,	//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 500,
		//pageList:[100,200,500,1000],
		fitColumns:true,		//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		checkOnSelect:false,		//true,击某一行时，选中/取消选中复选框
		selectOnCheck:false,		//true,点击复选框将会选中该行
		url:$URL,
		toolbar: [] ,
		queryParams:{
			ClassName:"MA.IPMR.SSService.VolLendRequestSrv",
		    QueryName:"QryEmrICD",
			aInput:'',
			rows:10000
		},
		columns :columns
	});
}

 /**
 * NUMS: W004
 * CTOR: LIYI
 * DESC: 申请列表-表单录入模块
 * DATE: 2021-09-09
 * NOTE: 包括方法：
 * TABLE: 
 */
$('#btnFindRequest').click(function(){
	if (ServerObj.NoPaperSysSetting=='1'){
		var LendType = $('#cboLendTypeQ').combobox('getValue');
	}else{
		var LendType = ServerObj.PaperLendTypeID
	}
	
	var RequestDateFrom = $('#RequestDateFrom').datebox('getValue');
	var RequestDateTo = $('#RequestDateTo').datebox('getValue');
	var Status = $('#cboStatusQ').combobox('getValue');
	if (LendType==''){
		if (ServerObj.NoPaperSysSetting=='1'){
			$.messager.popover({msg: '请选择借阅病历类型！',type: 'alert',timeout: 1000});
			return
		}else{
			$.messager.alert("提示", "请检查字典项：【借阅】借阅病案类型!", 'info');
			return
		}
	}
	if (RequestDateFrom==''){
		$.messager.popover({msg: '请选择申请日期！',type: 'alert',timeout: 1000});
		return
	}
	if (RequestDateTo==''){
		$.messager.popover({msg: '请选择申请结束日期！',type: 'alert',timeout: 1000});
		return
	}
	$('#gridLendRequest').datagrid('reload',  {
		ClassName:"MA.IPMR.SSService.VolLendRequestSrv",
		QueryName:"QryLendRequest",
		aLendTypeID:LendType,
		aDateFrom:RequestDateFrom,
		aDateTo:RequestDateTo,
		aStatusID:Status,
		aHospID:Logon.HospID,
		aUserID:Logon.UserID,
		rows:10000
	});
	$('#gridLendRequest').datagrid('unselectAll');
});

  /**
 * NUMS: W005
 * CTOR: LIYI
 * DESC: 申请列表-申请列表
 * DATE: 2021-09-09
 * NOTE: 包括方法：
 * TABLE: 
 */

function reLoadGridLendRequest() {
	$('#gridLendRequest').datagrid('reload',  {
		ClassName:"MA.IPMR.SSService.VolLendRequestSrv",
		QueryName:"QryLendRequest",
		aLendTypeID:'',
		aDateFrom:'',
		aDateTo:'',
		aStatusID:'',
		aHospID:'',
		aUserID:'',
		rows:10000
	});
	$('#gridLendRequest').datagrid('unselectAll');
}

function InitgridLendRequest(){
	var columns = [[
		{field:'LendTypeDesc',title:'借阅病历类型',width:120,align:'left'},
		{field:'UserDesc',title:'申请人',width:120,align:'left'},
		{field:'Unit',title:'医生资格证书号',width:120,align:'left'},
		{field:'LocDesc',title:'申请科室',width:150,align:'left'},
		{field:'StatusDesc',title:'申请状态',width:120,align:'left'},
		{field:'RequestDate',title:'申请日期',width:120,align:'left'},
		{field:'PDFModelDesc',title:'浏览模式',width:120,align:'left'},
		{field:'LendPurposeDesc',title:'借阅目的',width:150,align:'left'},
		{field:'ExpBackDate',title:'预计归还日期',width:120,align:'left'},
		{field:'VolCount',title:'病历数',width:100,align:'left',
			formatter:function(value,row,index) {
            	var RequestID = row.ID;
				var VolCount = row.VolCount;
               	return '<a href="#" class="grid-td-text-gray" onclick = showRequestVol(' + RequestID + ')>' + VolCount + '</a>';            
            }
		},
		{field:'Resume',title:'申请备注',width:300,align:'left'}
	]];
	var gridLendRequest = $HUI.datagrid("#gridLendRequest",{
		fit:true,
		//title:'借阅申请列表',
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		//pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true,		//如果为true, 则显示一个行号列
		singleSelect:true,
		autoRowHeight: false,	//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 500,
		//pageList:[100,200,500,1000],
		fitColumns:false,		//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		checkOnSelect:false,		//true,击某一行时，选中/取消选中复选框
		selectOnCheck:false,		//true,点击复选框将会选中该行
		url:$URL,
		queryParams:{
			ClassName:"MA.IPMR.SSService.VolLendRequestSrv",
		    QueryName:"QryLendRequest",
			aLendTypeID:'',
			aDateFrom:'',
			aDateTo:'',
			aStatusID:'',
			aHospID:'',
			aUserID:'',
			rows:10000
		},
		columns :columns
	});
	return gridLendRequest;
}

// 撤销申请
$('#btnRevoke').click(function(){
	var data	= $("#gridLendRequest").datagrid("getData");
	if (data.total==0){
		$.messager.popover({msg: '请先查询再撤销！',type: 'alert',timeout: 1000});
		return
	}
	var selData	= $('#gridLendRequest').datagrid('getSelected');
	if (selData==null){
		$.messager.popover({msg: '请选择需要撤销的申请记录！',type: 'alert',timeout: 1000});
		return
	}
	var ReqID = selData.ID;
	var InputStr = ReqID;
	InputStr = InputStr + '^' + 2;
	InputStr = InputStr + '^' + Logon.UserID;
	InputStr = InputStr + '^' + '';

	$.messager.confirm("确认", "确认进行撤销申请?", function (r) {
		if (r) {
			var flg = $m({
				ClassName:"MA.IPMR.SSService.VolLendRequestSrv",
				MethodName:"RequestOper",
				aInputStr:InputStr
			},false);
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误", '撤销失败！', 'error');
				return;
			}else{
				$('#gridLendRequest').datagrid('load');
				$('#gridLendRequest').datagrid('unselectAll');
			}
		}
		else{
		}
	});
});

/**
 * NUMS: D006
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
			$("#txtAliasID").val('');
			$("#txtAlias").val('');
			$("#txtAliasICDVerID").val('');
		}
	});
    return RequestVolDialog;
}