/**
 * 多版本ICD
 * 
 * Copyright (c) 2018-2022 LIYI. All rights reserved.
 * 
 * CREATED BY LIYI 2022-03-17
 * 
 * 注解说明
 * TABLE: 
 */
// 页面全局变量对象
var globalObj = {
	diagEditIndex:'',
	operEditIndex:'',
	MasterID:'',
	FCICDVer2:'',
	FCOprVer:'',
	FCICDVer:''
}
// 页面入口
$(function(){
	if (ServerObj.DefaultMasterID=='') {
		$.messager.alert("提示","请先进行编目再进行多版本编目....","info")
	}
	InitgridDiag('');
	InitgridOper('');
	$('#cboMultiVer').combobox({
	 	url: $URL,
		editable: true,
		defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
		valueField: 'ID',
		textField: 'CodeMultiVerDesc',
		panelWidth:200,
		onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
			param.ClassName = 'CT.IPMR.FPS.ConfigSrv';
			param.QueryName = 'QryMultiVer';
			param.aWorkFItemID   = ServerObj.WorkFItemID;
			param.ResultSetType = 'array';
		},		
		onLoadSuccess:function(data){   //初始加载赋值
			if (data.length>0){
				$(this).combobox('select',data[0]['ID']);
			}
		},
		onSelect:function(record){
			$m({
				ClassName:"MA.IPMR.FP.DataMaster",
				MethodName:"GetIdByConfig",
				aVolumeId:ServerObj.VoumeID,
				aConfigID:record.ID
			},function(txtData){
				globalObj.MasterID=txtData;
				InitgridDiag(record.ID);
				InitgridOper(record.ID);
			});
	    }
	});

	// 新增诊断
	$('#DiagNew').click(function(){
		if (!checkDiag1()) return false;
		if (globalObj.diagEditIndex!=='') {
			$("#gridDiag").datagrid('endEdit', globalObj.diagEditIndex);
		}
		insertRow('','new','gridDiag');
		globalObj.diagEditIndex = $("#gridDiag").datagrid('getData').rows.length-1;
	});

	// 诊断上移
	$('#DiagUp').click(function(e){
		var row = $("#gridDiag").datagrid('getSelected');
	    var index = $("#gridDiag").datagrid('getRowIndex', row);
	    moveRow(index, 'up', 'gridDiag');
	    globalObj.diagEditIndex='';
	});

	// 诊断下移
	$('#DiagDown').click(function(){
		var row = $("#gridDiag").datagrid('getSelected');
	    var index = $("#gridDiag").datagrid('getRowIndex', row);
	    moveRow(index, 'down', 'gridDiag');
	    globalObj.diagEditIndex='';
	});

	// 复制诊断
	$('#DiagCopy').bind('click', function() {
		if (!checkDiag()) return false;
		var row = $("#gridDiag").datagrid('getSelected');
		if (row==null) {	
			$.messager.popover({msg: '请选择一条诊断数据！',type: 'alert',timeout: 1000});
			return false;
		}
		var index = $("#gridDiag").datagrid('getRowIndex', row);
		insertRow(index,'copy','gridDiag');
		globalObj.diagEditIndex = index+1;
	});

	// 删除诊断
	$('#DiagCancel').click(function(){
		CancelDiag();
	});

	// 新增手术
	$('#OperNew').click(function(){
		if (!checkOper()) return false;
		if (globalObj.operEditIndex!=='') {
			$("#gridOper").datagrid('endEdit', globalObj.operEditIndex);
		}
		insertRow('','new','gridOper');
		globalObj.operEditIndex = $("#gridOper").datagrid('getData').rows.length-1;
	});

	// 手术上移
	$('#OperUp').click(function(e){
		var row = $("#gridOper").datagrid('getSelected');
	    var index = $("#gridOper").datagrid('getRowIndex', row);
	    moveRow(index, 'up', 'gridOper');
	    globalObj.operEditIndex='';
	});

	// 手术下移
	$('#OperDown').click(function(){
		var row = $("#gridOper").datagrid('getSelected');
	    var index = $("#gridOper").datagrid('getRowIndex', row);
	    moveRow(index, 'down', 'gridOper');
	    globalObj.operEditIndex='';
	});

	// 复制手术
	$('#OperCopy').bind('click', function() {
		if (!checkOper()) return false;
		var row = $("#gridOper").datagrid('getSelected');
		if (row==null) {
			$.messager.popover({msg: '请选择一条手术数据！',type: 'alert',timeout: 1000});
			return false;
		}
		var index = $("#gridOper").datagrid('getRowIndex', row);
		insertRow(index,'copy','gridOper');
		globalObj.operEditIndex = index+1;
	});

	// 删除手术
	$('#OperCancel').click(function(){
		CancelOper();
	});

	// 保存按钮
	$('#btnSave').click(function(){
		SaveResult("C");
	});

})

/**
 * NUMS: D001
 * CTOR: LIYI
 * DESC: 诊断列表模块
 * DATE: 2022-03-17
 * NOTE: 诊断列表模块相关方法
 * TABLE: 
 */
 function InitgridDiag(fpConfigId){
 	var ICDVer 	= '';
 	if (fpConfigId!='') {
 		var ret = $cm({
			ClassName:"CT.IPMR.FP.Config",
			MethodName:"GetObjById",
			aId:fpConfigId
		},false)
		ICDVer 	= ret.FCICDVer;
		globalObj.FCICDVer = ret.FCICDVer;
		globalObj.FCOprVer = ret.FCOprVer;
		globalObj.FCICDVer2= ret.FCICDVer2;
 	}
	$('#gridDiag').datagrid({
		url:$URL,
		queryParams:{
			ClassName:"MA.IPMR.FPS.CodeDiagSrv",
			QueryName:"QryDiag",
			aVolumeID:ServerObj.VoumeID,
			aFPConfig:fpConfigId
		},
		method: 'post',
		rownumbers: true,
		fitColumns: true,
		singleSelect: true,
		scrollbarSize: 0,
		fit:true,
		columns: [[
			{field:'TypeDesc',title:'诊断类型',width:50,align:'left',
				editor:{
					type: 'combogrid',
					options: ComboDIC('TypeID','TypeCode','TypeDesc',ServerObj.FPTypeDesc=='中医首页'?'CMDiagType':'DiagType',1,'D')
				}
			},
			{field:'MapToICD10',title:'疾病编码',width:50,align:'left'},
			{field:'MapToICDDesc',title:'疾病名称',width:150,align:'left',
				formatter: function(value,row,index) {
					var MapToICDVerID = row["MapToICDVerID"];
					if (MapToICDVerID==''){
						return "<span style='color: #BB0000'>" + row.MapToICDDesc + "</span>";	
					}
					return row.MapToICDDesc;
				},
				editor:{
					type: 'combogrid',
					options: ComboICD(ICDVer,1,'D','MapToICDVerID','MapToICDID','MapToICD10','MapToICDDesc','MapToICDinPair')
				}
			},
			{field:'AdmitCondDesc',title:'入院病情',width:50,align:'left',
				editor:{
					type: 'combogrid',
					options: ComboDIC('AdmitCondID','','AdmitCondDesc','DiseaseResult',1,'D')
				}
			}
		]],
		onDblClickRow: function(index,row) {
			if ((globalObj.diagEditIndex==='')|(globalObj.diagEditIndex===index)) {
				$(this).datagrid('beginEdit', index);
				globalObj.diagEditIndex = index;
			}else{
				if (checkDiag()) {
					$(this).datagrid('endEdit', globalObj.diagEditIndex);
					$(this).datagrid('beginEdit', index);
					globalObj.diagEditIndex = index;
				}
			}
		},
		onSelect: function(index,row) {
			if ((globalObj.diagEditIndex!==index)&&(globalObj.diagEditIndex!=='')) {
				if (checkDiag()) {
					$(this).datagrid('endEdit', globalObj.diagEditIndex);
					globalObj.diagEditIndex='';
				}
			}
		}
	});
}

// 删除诊断
function CancelDiag(){
	var target = $('#gridDiag');
	var select = target.datagrid('getSelected');
	if (select==null) {	
		$.messager.popover({msg: '请选择一条诊断数据！',type: 'alert',timeout: 1000});
		return false;
	}else{
		var rowindex = target.datagrid('getRowIndex',select)
		if ((globalObj.diagEditIndex!=='')&&(globalObj.diagEditIndex!==rowindex)) {
			$.messager.popover({msg: '请完善诊断编码！',type:'alert',timeout: 1000});
			return;
		}
		var RowNumber = rowindex+1;	//诊断的序号
		$.messager.confirm('删除','确定删除第'+RowNumber+'条诊断?',function(r){
		    if (r){
				target.datagrid('deleteRow',rowindex);
				var gridDiagData = target.datagrid('getData'); 
				for (var i = 0 ;i<gridDiagData.total; i ++ ) {
					var rowdata = gridDiagData.rows[i];
					if (i<rowindex) continue
					rowdata.Index =(i+1);
					target.datagrid('getData').rows[i] = rowdata;
            		target.datagrid('refreshRow', i);
				}
				if ((globalObj.diagEditIndex!=='')&&(globalObj.diagEditIndex!==rowindex)) {
					var temIndex = (globalObj.diagEditIndex>rowindex)?globalObj.diagEditIndex-1:globalObj.diagEditIndex;
					target.datagrid('beginEdit', temIndex);
					globalObj.diagEditIndex=temIndex;
				}
		    }
		});
	}
}

// 简单校验诊断数据
function checkDiag() {
	var data = $('#gridDiag').datagrid('getData')
	var flg =true;
	var MainDiagErr=0;
	var AdmitCondErr=0;
	var DiagNull = 0;
	for (var ind = 0; ind < data.total; ind++){
		var strTemp = '';
		var record = data.rows[ind];
		if (record.MapToICDID=='') DiagNull = 1;
		if ((record.TypeCode==4)&&(record.AdmitCondID=='')) AdmitCondErr++;
		if ((record.TypeCode==3)&&(record.AdmitCondID=='')) AdmitCondErr++;
		if (record.TypeCode==3) MainDiagErr++;
	}
	if (DiagNull==1) {
		$.messager.popover({msg: '请完善诊断编码！',type:'alert',timeout: 1000});
		return false;
	}
	if (MainDiagErr==0) {
		$.messager.popover({msg: '缺少主要诊断！',type:'alert',timeout: 1000});
		return false;
	}
	if (MainDiagErr>1) {
		$.messager.popover({msg: '主要诊断只能有一个！',type:'alert',timeout: 1000});
		return false;
	}
	if (AdmitCondErr>0) {
		$.messager.popover({msg: '主要诊断、其他诊断必须录入入院病情！',type:'alert'});
		return false;
	}
	return flg;
}
// 新增简单校验诊断数据
function checkDiag1() {
	var data = $('#gridDiag').datagrid('getData')
	var flg =true;
	var MainDiagErr=0;
	var AdmitCondErr=0;
	var DiagNull = 0;
	for (var ind = 0; ind < data.total-1; ind++){
		var strTemp = '';
		var record = data.rows[ind];
		if (record.MapToICDID=='') DiagNull = 1;
		if ((record.TypeCode==4)&&(record.AdmitCondID=='')) AdmitCondErr++;
		if ((record.TypeCode==3)&&(record.AdmitCondID=='')) AdmitCondErr++;
		if (record.TypeCode==3) MainDiagErr++;
	}
	if (DiagNull==1) {
		$.messager.popover({msg: '请完善诊断编码！',type:'alert',timeout: 1000});
		return false;
	}
	if (MainDiagErr>1) {
		$.messager.popover({msg: '主要诊断只能有一个！',type:'alert',timeout: 1000});
		return false;
	}
	if (AdmitCondErr>0) {
		$.messager.popover({msg: '主要诊断、其他诊断必须录入入院病情！',type:'alert'});
		return false;
	}
	return flg;
}

// 组织编目诊断数据
 function getDiag(status){
 	var data = $('#gridDiag').datagrid('getData')
 	var strResult = '';
	for (var ind = 0; ind < data.total; ind++){
		var strTemp = '';
		var record = data.rows[ind];
		if (strResult != '') strResult += CHR_1
		strResult += CHR_2 + (ind+1)
		strResult += CHR_2 + record.MapToICDID
		strResult += CHR_2 + record.TypeID
		strResult += CHR_2 + record.AdmitCondID
		strResult += CHR_2 + record.DischCondID
		strResult += CHR_2 + record.IsDefiniteID
		strResult += CHR_2 + strTemp
	}
	return strResult;
 }

/**
 * NUMS: D002
 * CTOR: LIYI
 * DESC: 手术列表模块
 * DATE: 2022-03-17
 * NOTE: 手术列表模块相关方法
 * TABLE: 
 */
// 初始化手术列表
function InitgridOper(fpConfigId){
	var ICDVer 	= '';
 	if (fpConfigId!='') {
 		var ret = $cm({
			ClassName:"CT.IPMR.FP.Config",
			MethodName:"GetObjById",
			aId:fpConfigId
		},false)
		ICDVer 	= ret.FCOprVer;
 	}
	$('#gridOper').datagrid({
		url:$URL,
		queryParams:{
			ClassName:"MA.IPMR.FPS.CodeOperSrv",
			QueryName:"QryOper",
			aVolumeID:ServerObj.VoumeID,
			aFPConfig:fpConfigId
		},
		method: 'post',
		rownumbers: true,
		fitColumns: true,
		singleSelect: true,
		scrollbarSize: 0,
		fit:true,
		columns: [[
			{field:'TypeDesc',title:'手术类型',width:80,align:'left',
				editor:{
					type: 'combogrid',
					options: ComboDIC('TypeID','TypeCode','TypeDesc','OperType',1,'O')
				}
			},
			{field:'MapToICD10',title:'手术编码',width:80,align:'left'},		
			{field:'MapToICDDesc',title:'手术名称',width:200,align:'left',
				formatter:function(value,row,index)
				{
					var MapToICDVerID = row["MapToICDVerID"];
					if (MapToICDVerID==''){
						return "<span style='color: #BB0000'>" + row.MapToICDDesc + "</span>";	
					}
					return row.MapToICDDesc;	
				},
				editor:{
					type: 'combogrid',
					options: ComboICD(ICDVer,1,'O','MapToICDVerID','MapToICDID','MapToICD10','MapToICDDesc','MapToICDinPair')
				}
			},			
			{field:'SttDate',title:'手术日期',width:100,align:'left',
				editor:{
					type:'datebox'
				}
			},
			{field:'Operator',title:'术者',width:80,align:'left',
				editor:{
					type: 'combogrid',
					options: ComboUser('OPRDOC','OperatorID','Operator')
				}
			},
			{field:'Assistant1',title:'Ⅰ助',width:80,align:'left',
				editor:{
					type: 'combogrid',
					options: ComboUser('OPRASS','Assistant1ID','Assistant1')
				}
			},
			{field:'Assistant2',title:'Ⅱ助',width:80,align:'left',
				editor:{
					type: 'combogrid',
					options: ComboUser('OPRASS','Assistant2ID','Assistant2')
				}
			},
			{field:'NarcosisTypeDesc',title:'麻醉方式',width:80,align:'left',
				editor:{
					type: 'combogrid',
					options: ComboDIC('NarcosisTypeID','','NarcosisTypeDesc','NarcosisType',1,'O')
				}
			},
			{field:'NarcosisDoc',title:'麻醉医师',width:80,align:'left',
				editor:{
					type: 'combogrid',
					options: ComboUser('NARDOC','NarcosisDocID','NarcosisDoc')
				}
			},
			{field:'CutTypeDesc',title:'切口类型',width:80,align:'left',
				editor:{
					type: 'combogrid',
					options: ComboDIC('CutTypeID','','CutTypeDesc','CutType',1,'O')
				}
			},
			{field:'HealingDesc',title:'愈合情况',width:80,align:'left',
				editor:{
					type: 'combogrid',
					options: ComboDIC('HealingID','','HealingDesc','Healing',1,'O')
				}
			},
			{field:'OperLevelDesc',title:'手术级别',width:80,align:'left',
				editor:{
					type: 'combogrid',
					options: ComboDIC('OperLevelID','','OperLevelDesc','OperationRank',1,'O')
				}
			},
			/*{field:'MainOperDesc',title:'主手术',width:80,align:'left',
				editor:{
					type: 'combogrid',
					options: ComboDIC('MainOperID','','MainOperDesc','MainOper',1,'O')
				}
			},*/
			{field:'AisOperID',title:'手术ID',width:80,align:'left'}
		]],
		onDblClickRow: function(index,row) {
			if ((globalObj.operEditIndex==='')|(globalObj.operEditIndex===index)) {
				$(this).datagrid('beginEdit', index);
				globalObj.operEditIndex = index;
			}else{
				if (checkDiag()) {
					$(this).datagrid('endEdit', globalObj.operEditIndex);
					$(this).datagrid('beginEdit', index);
					globalObj.operEditIndex = index;
				}
			}
		},
		onSelect: function(index,row) {
			if ((globalObj.operEditIndex!==index)&&(globalObj.operEditIndex!=='')) {
				if (checkOper()) {
					$(this).datagrid('endEdit', globalObj.operEditIndex);
					globalObj.operEditIndex='';
				}
			}
		}
	});
}

// 删除手术
function CancelOper(){
	var target = $('#gridOper');
	var select = target.datagrid('getSelected');
	if (select==null) {	
		$.messager.popover({msg: '请选择一条手术数据！',type: 'alert',timeout: 1000});
		return false;
	}else{
		var rowindex = target.datagrid('getRowIndex',select)
		if ((globalObj.operEditIndex!=='')&&(globalObj.operEditIndex!==rowindex)) {
			$.messager.popover({msg: '请完善手术编码！',type:'alert',timeout: 1000});
			return;
		}
		var RowNumber = rowindex+1;	//手术的序号
		$.messager.confirm('删除','确定删除第'+RowNumber+'条手术?',function(r){
		    if (r){
				target.datagrid('deleteRow',rowindex);
				var gridOperData = target.datagrid('getData'); 
				for (var i = 0 ;i<gridOperData.total; i ++ ) {
					var rowdata = gridOperData.rows[i];
					if (i<rowindex) continue
					rowdata.Index =(i+1);
					target.datagrid('getData').rows[i] = rowdata;
            		target.datagrid('refreshRow', i);
				}
				if ((globalObj.operEditIndex!=='')&&(globalObj.operEditIndex!==rowindex)) {
					var temIndex = (globalObj.operEditIndex>rowindex)?globalObj.operEditIndex-1:globalObj.operEditIndex;
					target.datagrid('beginEdit', temIndex);
					globalObj.operEditIndex=temIndex;
				}
		    }
		});
	}
}

 // 简单校验诊断数据
 function checkOper() {
	var data = $('#gridOper').datagrid('getData')
	var flg =true;
	var OperNull = 0;
	for (var ind = 0; ind < data.total; ind++){
		var strTemp = '';
		var record = data.rows[ind];
		if (record.MapToICDID=='') OperNull = 1;
	}
	if (OperNull==1) {
		$.messager.popover({msg: '请完善手术编码！',type:'alert',timeout: 1000});
		return false;
	}
	return flg;
}

 // 组织编目手术数据
 function getOper(status){
 	var data = $('#gridOper').datagrid('getData')
 	var strResult = '';
	for (var ind = 0; ind < data.total; ind++){
		var strTemp = '';
		var record = data.rows[ind];
		if (strResult != '') strResult += CHR_1
		strResult += CHR_2 + (ind+1)
		strResult += CHR_2 + record.MapToICDID
		strResult += CHR_2 + record.TypeID
		strResult += CHR_2 + record.SttDate
		strResult += CHR_2 + record.SttTime
		strResult += CHR_2 + record.EndDate
		strResult += CHR_2 + record.EndTime
		strResult += CHR_2 + record.OperatorID
		strResult += CHR_2 + record.Operator
		strResult += CHR_2 + record.Assistant1ID
		strResult += CHR_2 + record.Assistant1
		strResult += CHR_2 + record.Assistant2ID
		strResult += CHR_2 + record.Assistant2
		strResult += CHR_2 + record.NarcosisTypeID
		strResult += CHR_2 + record.NarcosisDocID
		strResult += CHR_2 + record.NarcosisDoc
		strResult += CHR_2 + record.CutTypeID
		strResult += CHR_2 + record.HealingID
		strResult += CHR_2 + record.OperLevelID
		strResult += CHR_2 + record.MainOperID
		strResult += CHR_2 + strTemp
		strResult += CHR_2 + ''
		strResult += CHR_2 + record.AisOperID	// 手术申请ID
	}
	return strResult;
 }

// 数据保存方法
function SaveResult(status){
	openWinTip('数据保存中...');
	var MasterInfo = globalObj.MasterID;
	MasterInfo += CHR_1 + ServerObj.VoumeID; 
	MasterInfo += CHR_1 + ServerObj.MasterTypeID;  	//首页类型
	MasterInfo += CHR_1 + status;  					//状态
	MasterInfo += CHR_1 + Logon.UserID;   			//操作用户
	MasterInfo += CHR_1 + '';  						//备注
	MasterInfo += CHR_1 + ServerObj.WorkFItemID;  
	MasterInfo += CHR_1 + $("#cboMultiVer").combobox('getValue');  // 编目配置ID
	if (checkDiag()) {
		endGridEdit('gridDiag');
	}else{
		closeWinTip();
		return false;
	}
	if (checkOper()) {
		endGridEdit('gridOper');
	}else{
		closeWinTip();
		return false;
	}
	var Patinfo ='';
	var DiagInfo =getDiag(status);
	var OperInfo = getOper(status);
	if ((DiagInfo=='')&&(status=='C')){
		$.messager.popover({msg: '诊断信息为空！',type:'alert',timeout: 1000});
		closeWinTip();
		return false;
	}
	$m({
		ClassName:"MA.IPMR.FPS.DataMasterSrv",
		MethodName:"SaveResult",
		aMasterInfo:MasterInfo,
		aDiagInfo:DiagInfo,
		aOperInfo:OperInfo,
		aPatInfo:Patinfo,
		aAttDiagInfo:''
	},function(txtData){
		closeWinTip();
		globalObj.diagEditIndex='';
		globalObj.operEditIndex
		var arrtxtdata = txtData.split(CHR_1);
		if (arrtxtdata.length==1){		// 非质控失败
			$.messager.alert("错误","保存失败","error")
		}else if (arrtxtdata.length==3){
			var errcode = arrtxtdata[0];
			var ForceInfo = arrtxtdata[1];
			var TipInfo = arrtxtdata[2];
			if (parseInt(errcode) > 0){
				if (TipInfo!='')
				{
					var arrtip = TipInfo.split('^');
					var info='';
					for (i=0;i<arrtip.length ;i++ ){
						if (arrtip[i]=='') continue;
						for (j=0;j<arrtip[i].split('#').length ;j++ ){
							if (arrtip[i].split('#')[j]=='') continue;
							if (info==''){
								info=arrtip[i].split('#')[j];
							}else{
								info=info+'<br/>'+arrtip[i].split('#')[j];
							}
						}
					}
					$.messager.show({
						title:'提示性质控',
						width:500,
						height:400,
						msg:info,
						timeout:6000,
						showType:'slide'
					});
				}
				$.messager.popover({msg: '保存成功！',type: 'success',timeout: 1000});
				return true;
			}else{
				if (TipInfo!='')
				{
					var arrtip = TipInfo.split('^');
					var info='';
					for (i=0;i<arrtip.length ;i++ ){
						if (arrtip[i]=='') continue;
						for (j=0;j<arrtip[i].split('#').length ;j++ ){
							if (arrtip[i].split('#')[j]=='') continue;
							if (info==''){
								info=arrtip[i].split('#')[j];
							}else{
								info=info+'<br/>'+arrtip[i].split('#')[j];
							}
						}
					}
					$.messager.show({
						title:'提示性质控',
						width:500,
						height:400,
						msg:info,
						timeout:6000,
						showType:'slide'
					});
				}
				if (ForceInfo!=''){
					var arrforce = ForceInfo.split('^');
					var info='';
					for (i=0;i<arrforce.length ;i++ ){
						if (arrforce[i]=='') continue;
						for (j=0;j<arrforce[i].split('#').length ;j++ ){
							if (arrforce[i].split('#')[j]=='') continue;
							if (info==''){
								info=arrforce[i].split('#')[j];
							}else{
								info=info+'<br/>'+arrforce[i].split('#')[j];
							}
						}
					}
					$.messager.alert("强制性质控",info,"info")
				}
			}
		}
	});
}

// 表格插入数据
function insertRow(index, type, gridname){
	var queryParams=$('#' + gridname).datagrid('options').queryParams;
    var PropertyStr = $m({
    	ClassName:'MA.IPMR.SSService.CommonSrv',
		MethodName:'GetQryProperties',
		aClassName:queryParams.ClassName,
		aQueryName:queryParams.QueryName
    },false);
    var propertyArr = PropertyStr.split('^');
    var row='{'
    for (i=0;i<propertyArr.length;i++){
    	if (i==0) {
    		row = row + '"' + propertyArr[i] + '":' + '""';
    	}else{
    		row = row + ',"' + propertyArr[i] + '":' + '""';
    	}
    }
    row+='}';
    row = JSON.parse(row)
	if (type=='copy') {
		var copyrow = $('#' + gridname).datagrid('getData').rows[index];
		for(var i in copyrow){ 
			row[i]=copyrow[i];
		} 
		row.ICDVerID='';
		row.ICDID='';
		row.ICD10='';
		row.ICDDesc='';
		row.MainOperID='';
		row.MapToICD10='';
		row.MapToICDDesc='';
		row.MapToICDID='';
		row.MapToICDVerID='';
		row.MapToICDinPair='';
    	$('#' + gridname).datagrid('insertRow',{
			index: index+1,
			row: row
		});
	} else if (type == 'new') {
		$('#' + gridname).datagrid('insertRow',{row: row});
	}
	if (type=='copy') {
		$('#' + gridname).datagrid('selectRow',index+1);
		$('#' + gridname).datagrid('beginEdit',index+1);
	}else if (type == 'new') {
		$('#' + gridname).datagrid('selectRow',$('#' + gridname).datagrid('getData').total-1);
		$('#' + gridname).datagrid('beginEdit',$('#' + gridname).datagrid('getData').total-1);
	}
}

// 结束表格编辑
function endGridEdit(gridname)
{
	var editIndex = $('#' + gridname).datagrid('getEditingIndex');
	if (typeof(editIndex)!='undefined') $('#' + gridname).datagrid('endEdit',editIndex);
}

// 表格行移动
function moveRow(index, type, gridname){
	if ("up" == type) {
        if (index != 0) {
            var toup = $('#' + gridname).datagrid('getData').rows[index];
            var todown = $('#' + gridname).datagrid('getData').rows[index - 1];
            var tmpOrder = toup.Index ;
            toup.Index = todown.Index;
            todown.Index = tmpOrder;
            $('#' + gridname).datagrid('getData').rows[index] = todown;
            $('#' + gridname).datagrid('getData').rows[index - 1] = toup;
            $('#' + gridname).datagrid('refreshRow', index);
            $('#' + gridname).datagrid('refreshRow', index - 1);
            $('#' + gridname).datagrid('selectRow', index - 1);
        }
    } else if ("down" == type) {
        var rows = $('#' + gridname).datagrid('getRows').length;
        if (index != rows - 1) {
            var todown = $('#' + gridname).datagrid('getData').rows[index];
            var toup = $('#' + gridname).datagrid('getData').rows[index + 1];
            var tmpOrder = toup.Index ;
            toup.Index = todown.Index;
            todown.Index = tmpOrder;
            $('#' + gridname).datagrid('getData').rows[index + 1] = todown;
            $('#' + gridname).datagrid('getData').rows[index] = toup;
            $('#' + gridname).datagrid('refreshRow', index);
            $('#' + gridname).datagrid('refreshRow', index + 1);
            $('#' + gridname).datagrid('selectRow', index + 1);
        }
    }
}

/**
 * 可编辑表格字典下拉框定义
 * @param {arguments[0]} 下拉对应的表格中字典id列代码
 * @param {arguments[1]} 下拉对应的表格中字典code列代码
 * @param {arguments[2]} 下拉对应的表格中字典desc列代码
 * @param {arguments[3]} 字典类型
 * @param {arguments[4]} 是否有效
 * @param {arguments[5]} 医院ID
 * @return {cmp}下拉组件
 */
function ComboDIC() {
	var idRow		= arguments[0];
	var codeRow		= arguments[1];
	var descRow		= arguments[2];
	var dicType		= arguments[3];
	var isActive	= arguments[4];
	var gridType	= arguments[5];
	var hospId      = arguments[6];
	if (typeof(idRow)=='undefined') idRow='';
	if (typeof(codeRow)=='undefined') codeRow='';
	if (typeof(descRow)=='undefined') descRow='';
	if (typeof(dicType)=='undefined') dicType='';
	if (typeof(isActive)=='undefined') isActive='';
	if (typeof(gridType)=='undefined') gridType='';
	if (typeof(hospId)=='undefined') hospId='';
	var cbg = {
		url: $URL,
		idField:'Desc',
		textField: 'Desc',
		method:'Post',
		mode:'remote',
		multiple: false,
		enterNullValueClear:false,
		fitColumns:true,
		hasDownArrow: true,
		panelWidth:300,
		panelHeight:250,
		editable: false,
		defaultFilter:4, 
		delay:200,
		queryParams:{
		    ClassName:'CT.IPMR.BTS.DictionarySrv',
			QueryName:'QryDictionary',
			aDicType:dicType,
			aIsActive:isActive,
			aHospID:hospId,
			aAlias:'',
			rows:1000
		},
		columns: [[
			{field:'Code',title:'代码',width:50},
		    {field:'Desc',title:'名称',width:200}
		]],
		onSelect:function(index,row){
			if (gridType=='D') {
				var EditIndex = globalObj.diagEditIndex;
				var gridRows = $('#gridDiag').datagrid('getRows');
			}
			if (gridType=='O') {
				var EditIndex = globalObj.operEditIndex;
				var gridRows = $('#gridOper').datagrid('getRows');
			}
			if (idRow!="") gridRows[EditIndex][idRow] = row.ID;
			if (codeRow!="") gridRows[EditIndex][codeRow] = row.Code;
			if (descRow!="") gridRows[EditIndex][descRow] = row.Desc;
		}
	}
	return cbg;
}


/**
 * 可编辑表格ICD下拉框定义
 * @param {arguments[0]} ICD版本ID
 * @param {arguments[1]} 有效标志
 * @param {arguments[2]} ICD类型（诊断D，手术O）
 * @param {arguments[3]} 下拉对应的表格中ICD版本列代码
 * @param {arguments[4]} 下拉对应的表格中ICD编码id列代码
 * @param {arguments[5]} 下拉对应的表格中ICD编码ICD编码列代码
 * @param {arguments[6]} 下拉对应的表格中ICD编码ICD描述列代码
 * @param {arguments[7]} 下拉对应的表格中ICD编码ICD副码列代码
 * @return {cmp}下拉组件
 */
function ComboICD(){
	var icdVer	 	= arguments[0];
	var isActive 	= arguments[1];
	var icdType  	= arguments[2];
	var icdVerIdRow	= arguments[3];
	var icdIdRow    = arguments[4];
	var icd10Row	= arguments[5];
	var icdDescRow	= arguments[6];
	var icdInPairRow= arguments[7];
	if (typeof(icdVer)=='undefined') icdVer='';
	if (typeof(isActive)=='undefined') isActive='';
	if (typeof(icdType)=='undefined') icdType='';
	if (typeof(icdVerIdRow)=='undefined') icdVerIdRow='';
	if (typeof(icdIdRow)=='undefined') icdIdRow='';
	if (typeof(icd10Row)=='undefined') icd10Row='';
	if (typeof(icdDescRow)=='undefined') icdDescRow='';
	if (typeof(icdInPairRow)=='undefined') icdInPairRow='';
	var cbg = {
		url: $URL,
		idField:'Desc',
		textField: 'Desc',
		method:'Post',
		mode:'remote',
		multiple: false,
		enterNullValueClear:false,
		fitColumns:true,
		hasDownArrow: true,
		panelWidth:550,
		panelHeight:350,
		editable: true,
		defaultFilter:4, 
		delay:'500',
		sortName:'Count',
		sortOrder:'asc',
		columns:[[
		    {field:'ICD10',title:'ICD编码'},
		    {field:'InPairCode',title:'副码'},
		    {field:'Desc',title:'名称'},
		    {field:'OperTypeDesc',title:'手术类型'},
		    {field:'OperLevelDesc',title:'手术级别'},
		    {field:'Count',title:'序号',hidden:'true'}
		]],
		queryParams:{
		   ClassName:'CT.IPMR.FPS.ICDDxSrv',
			QueryName:'QryICDDx',
			aVerID:icdVer,
			aTypeID:'',  //Common_GetValue(LinkItem),
			aAlias:'' ,
			aIsActive:isActive,
			aICDDxID:'',
			rows:50
		},
		onLoadSuccess:function(data){
			if (icdType=='O'){
				$(this).combogrid('grid').datagrid("hideColumn", "InPairCode");
			}
			if (icdType=='D'){
				$(this).combogrid('grid').datagrid("hideColumn", "OperTypeDesc");
				$(this).combogrid('grid').datagrid("hideColumn", "OperLevelDesc");
			}
			if ($(this).combogrid('grid').datagrid('getRows').length == 0) {
				return;
			}else {
				$(this).combogrid('grid').datagrid('selectRow',0);
			}
		},
		onSelect:function(index,row){
			if (icdType=='O'){
				var target = $('#gridOper');
				var EditIndex = globalObj.operEditIndex;
			}
			if (icdType=='D'){
				var target = $('#gridDiag');
				var EditIndex = globalObj.diagEditIndex;
			}
			if (icdVerIdRow!="") target.datagrid('getRows')[EditIndex][icdVerIdRow] = row.VerID;
			if (icdIdRow!="") target.datagrid('getRows')[EditIndex][icdIdRow] = row.ID;
			if (icd10Row!="") target.datagrid('getRows')[EditIndex][icd10Row] = row.ICD10;
			if (icdDescRow!="") target.datagrid('getRows')[EditIndex][icdDescRow] = row.Desc;
			if (icdInPairRow!="") target.datagrid('getRows')[EditIndex][icdInPairRow] = row.InPairCode;
		},
		keyHandler: {
			up: function(e) {
				navcbg(this,'prev');
				e.preventDefault();
			},
			down: function(e) {
				navcbg(this,'next');
				e.preventDefault();
			},
			enter: function(e) {
				var pClosed = $(this).combogrid("panel").panel("options").closed;
				if (!pClosed) {
					$(this).combogrid("hidePanel");
				}
				var record = $(this).combogrid("grid").datagrid("getSelected");var tValue=$(this).combobox('getValue');
				if (record == null || record == undefined) return;
				if ((tValue!='')&&((record == null || record == undefined))) return;	// 有值,但未获取id,继续执行将造成值存空
				/*
				var inputEles = $("td > input[type='text']");
				for(var i=0;i<inputEles.length;i++){
					if ($(inputEles[i]).is($(this))) { //判断两个jQuery对象是否相等用is
						//校验数据，回车到下一个录入框
						if(i == inputEles.length-1){
							// 保存
						}else{
							// 判断下一个表单类型
							if ($(inputEles[i+1]).hasClass('combogrid-f')) {
								$(inputEles[i+1]).next().children(":first").focus();
							}else if ($(inputEles[i+1]).hasClass('datebox-f')||$(inputEles[i+1]).hasClass('datetimebox-f')) {
								$(inputEles[i+1]).next().children(":first").focus();
							}else{
								$(inputEles[i+1]).focus();
							}
						}
					} 
				}
				*/
			},
			query: function(q,e) {
				if (icdType=='O'){
					var EditIndex = globalObj.operEditIndex;
					var datagrid =  $('#gridOper').datagrid('getRows');
				}
				if (icdType=='D'){
					var EditIndex = globalObj.diagEditIndex;
					var datagrid =  $('#gridDiag').datagrid('getRows');
				}
				if (icdVerIdRow!="") datagrid[EditIndex][icdVerIdRow] = '';
				if (icdIdRow!="") datagrid[EditIndex][icdIdRow] = '';
				if (icd10Row!="") datagrid[EditIndex][icd10Row] = '';
				if (icdDescRow!="") datagrid[EditIndex][icdDescRow] = '';
				if (icdInPairRow!="") datagrid[EditIndex][icdInPairRow] = '';
				
				if (q=="") {
					$(this).combogrid("clear");
					$(this).combogrid("hidePanel");
					return;
				}else{
					if (q.length==1) {
						$(this).combogrid("grid").datagrid("loadData",{"total": 0, "rows": []});
						$(this).combogrid("setValue", q);
						return;
					}
				}
				if (icdType=='D'){
					var TypeCode = datagrid[EditIndex]['TypeCode'];
					if ((TypeCode==10)||(TypeCode==11)||(TypeCode==12)||(TypeCode==13)||(TypeCode==14)) {	// 中医编码
						Qrycbglink(this,q,icdType,EditIndex,globalObj.FCICDVer2);
					}else{
						Qrycbglink(this,q,icdType,EditIndex,globalObj.FCICDVer);
					}
				}else if (icdType=='O'){
					Qrycbglink(this,q,icdType,EditIndex,globalObj.FCOprVer);
				}
			}
		}
	}
	return cbg;
}

/**
 * 可编辑表格用户下拉框定义
 * @param {arguments[0]} 用户类型
 * @param {arguments[1]} id列代码
 * @param {arguments[2]} 描述列代码
 * @return {cmp}下拉组件
 */
function ComboUser(){
	var TypeCode = arguments[0];
	var idRow    = arguments[1];
	var descRow  = arguments[2];
	if (typeof(TypeCode)=='undefined') TypeCode='';
	if (typeof(idRow)=='undefined') idRow='';
	if (typeof(descRow)=='undefined') descRow='';
	var cbg = {
		url: $URL,
		idField:'Desc',
		textField: 'Desc',
		method:'Post',
		mode:'remote',
		multiple: false,
		enterNullValueClear:false,
		fitColumns:true,
		hasDownArrow: true,
		panelWidth:550,
		panelHeight:350,
		editable: true,
		defaultFilter:4, 
		delay:200,
		//sortName:'Count',
		sortOrder:'asc',
		columns:[[
		    {field:'Code',title:'工号',width:120},
		    {field:'Desc',title:'姓名',width:120},
		    {field:'CPTDesc',title:'医护人员类型',width:120}
		]],
		queryParams:{
			ClassName:'MA.IPMR.BTS.SSUserSrv',
			QueryName:'QueryUser',
			aAlias:'',
			aTypeCode:TypeCode,
			aUserID:'' ,
			aIsActive:1,
			rows:50
		},
		onSelect:function(index,row){
			var gridRows = $('#gridOper').datagrid('getRows');
			if (idRow!="") gridRows[globalObj.operEditIndex][idRow] = row.ID;
			if (descRow!="") gridRows[globalObj.operEditIndex][descRow] = row.Desc;
		},
		keyHandler: {
			up: function(e) {
				navcbg(this,'prev');
				e.preventDefault();
			},
			down: function(e) {
				navcbg(this,'next');
				e.preventDefault();
			},
			enter: function(e) {
				var pClosed = $(this).combogrid("panel").panel("options").closed;
				if (!pClosed) {
					$(this).combogrid("hidePanel");
				}
				var record = $(this).combogrid("grid").datagrid("getSelected");var tValue=$(this).combobox('getValue');
				if (record == null || record == undefined) return;
				if ((tValue!='')&&((record == null || record == undefined))) return;	// 有值,但未获取id,继续执行将造成值存空
			},
			query: function(q,e) {
				if (q=="") {
					$(this).combogrid("clear");
					$(this).combogrid("hidePanel");
					return;
				}
				qrycbg(this,q);
			}
		}
	}
	return cbg;
}

function qrycbg(target,q) {
	var state = $.data(target,"combogrid");
	var opts = state.options;
	var grid = state.grid;
	state.remainText = true;
	if(opts.multiple&&!q){
		_1ag(target,[],true);
	}
	else{
		_1ag(target,[q],true);
	}
	if(opts.mode=="remote"){
		grid.datagrid("clearSelections");
		grid.datagrid("load",$.extend({},opts.queryParams,{aAlias:q}));
	}
	else{
		if(!q){
			return;
		}
		grid.datagrid("clearSelections").datagrid("highlightRow",-1);
		var _2b = grid.datagrid("getRows");
		var qq = opts.multiple?q.split(opts.separator):[q];
		$.map(qq,function(q){
			q=$.trim(q);
			if(q){
				$.map(_2b,function(row,i){
					if(q==row[opts.textField]){
						grid.datagrid("selectRow",i);
					}
					else{
						if(opts.filter.call(target,q,row)){
							grid.datagrid("highlightRow",i);
						}
					}
				});
			}
		});
	}
	state.remainText = false;
}

function navcbg(target,dir) {
	var state = $.data(target,"combogrid");
	var opts = state.options;
	var grid = state.grid;
	var _18 = grid.datagrid("getRows").length;
	if (!_18) {
		return;
	}
	var tr = opts.finder.getTr(grid[0],null,"highlight");
	if (!tr.length) {
		tr = opts.finder.getTr(grid[0],null,"selected");
	}
	var _19;
	if (!tr.length) {
		_19 = (dir=="next"?0:_18-1);
	} else {
		var _19 = parseInt(tr.attr("datagrid-row-index"));
		_19 += (dir=="next"?1:-1);
		if (_19 < 0) {
			_19 = _18-1;
		}
		if	(_19 >= _18)	{
			_19 = 0;
		}
	}
	grid.datagrid("highlightRow",_19);
	if(opts.selectOnNavigation){
		state.remainText = false;
		grid.datagrid("selectRow",_19);
	}
}

function Qrycbglink(target,q,type,num,VerID) {
	var state = $.data(target,"combogrid");
	var opts = state.options;
	var grid = state.grid;
	state.remainText = true;
	if(opts.multiple&&!q){
		_1ag(target,[],true);
	}
	else{
		_1ag(target,[q],true);
	}
	if(opts.mode=="remote"){
		grid.datagrid("clearSelections");
		if (type=='O'){
			var typeID= ''; //$('#gridOper').datagrid('getRows')[num]['TypeID'];
		}
		if (type=='D'){
			var typeID= $('#gridDiag').datagrid('getRows')[num]['TypeID'];
		}
		grid.datagrid("load",$.extend({},opts.queryParams,{aVerID:VerID,aAlias:q,aTypeID:typeID}));
	}
	else{
		if(!q){
			return;
		}
		grid.datagrid("clearSelections").datagrid("highlightRow",-1);
		var _2b = grid.datagrid("getRows");
		var qq = opts.multiple?q.split(opts.separator):[q];
		$.map(qq,function(q){
			q=$.trim(q);
			if(q){
				$.map(_2b,function(row,i){
					if(q==row[opts.textField]){
						grid.datagrid("selectRow",i);
					}
					else{
						if(opts.filter.call(target,q,row)){
							grid.datagrid("highlightRow",i);
						}
					}
				});
			}
		});
	}
}


function _1ag(_1b,_1c,_1d){
	var _1e=$.data(_1b,"combogrid");
	var _1f=_1e.options;
	var _20=_1e.grid;
	var _21=_20.datagrid("getRows");
	var ss=[];
	var _22=$(_1b).combo("getValues");
	var _23=$(_1b).combo("options");
	var _24=_23.onChange;
	_23.onChange=function(){
	};
	_20.datagrid("clearSelections");
	for(var i=0;i<_1c.length;i++){
		var _25=_20.datagrid("getRowIndex",_1c[i]);
		if(_25>=0){
			_20.datagrid("selectRow",_25);
			ss.push(_21[_25][_1f.textField]);
		}else{
			ss.push(_1c[i]);
		}
	}
	$(_1b).combo("setValues",_22);
	_23.onChange=_24;
	$(_1b).combo("setValues",_1c);
	if(!_1d){
		var s=ss.join(_1f.separator);
		if($(_1b).combo("getText")!=s){
			$(_1b).combo("setText",s);
		}
	}
}

// 弹出提示框
function openWinTip(aTitle){
	var _title=aTitle;
	$('#wintip').dialog({
	    title: _title,
	    width: 250,
	    height: 10,
	    closable:false,
	    closed: false,
	    cache: false,
	    modal: true
	});
}
// 关闭提示框
function closeWinTip(){
	$('#wintip').window("close");
}