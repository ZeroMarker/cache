/**
 * mrtype 病案类型维护
 * 
 * Copyright (c) 2018-2019 WHui. All rights reserved.
 * 
 * CREATED BY WHui 2019-10-27
 * 
 * 注解说明
 * TABLE: CT.IPMR.BT.MrType (病案类型)		CT.IPMR.BT.NoType (号码类型)
 * 											CT.IPMR.BT.NoTypeLnk(号码类型关联)
 */

// 页面全局变量
var globalObj = {
	m_gridMrType : ''
}

$(function(){
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
})

function Init(){
	globalObj.m_gridMrType = InitgridMrType();
	globalObj.m_gridNoType = InitgridNoType();
	globalObj.m_gridNoTypeLnked = InitgridNoTypeLnked();
}

function InitEvent(){
	$('#add_btn').click(function(){editMrType('add');});
	$('#edit_btn').click(function(){editMrType('edit');});
	$('#del_btn').click(function(){deleteMrType();});
	
	$('#addNoType_btn').click(function(){editNoType('add');});
	$('#editNoType_btn').click(function(){editNoType('edit');});
	$('#delNoType_btn').click(function(){deleteNoType();});
	
	$('#delNoTyLnk_btn').click(function(){deleteNoTyLnk();});
	$('#addNoTyLnk_btn').click(function(){InitNoTypeLnkWindow();});
}

 /**
 * NUMS: 001
 * CTOR: WHui
 * DESC: 病案类型维护
 * DATE: 2019-10-27
 * NOTE: 包括五个个方法：InitgridMrType,editMrType,InitgridCTHospList,saveMrType,deleteMrType
 * TABLE: CT_IPMR_BT.MrType		CT_IPMR_BT.NoType
 */
function InitgridMrType(){
	var columns = [[
		{field:'MrTypeDesc',title:'病案类型',width:100,align:'left'},
		{field:'ReceiptTypeDesc',title:'接诊类型',width:100,align:'left'},
		{field:'AdmTypeDesc',title:'就诊类型',width:100,align:'left'},
		{field:'AssignTypeDesc',title:'分号方式',width:100,align:'left'},
		{field:'RecycleTypeDesc',title:'病案号回收',width:100,align:'left'},
		{field:'WorkFlowDesc',title:'工作流',width:120,align:'left'},
		{field:'MrClassDesc',title:'病案分类',width:100,align:'left'},
		{field:'MTResume',title:'备注',width:100,align:'left'}
	]];
	
	var gridMrType = $HUI.datagrid("#gridMrType",{
		fit:true,
		title:"病案类型维护",
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		rownumbers: true,		//如果为true, 则显示一个行号列
		singleSelect:true,
		autoRowHeight: false,	//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		fitColumns:false,		//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		url:$URL,
		queryParams:{
		    ClassName:"CT.IPMR.BTS.MrTypeSrv",
			QueryName:"QueryMrType",
			aMrClass:"",
			rows:10000
		},
		columns :columns,
		onClickRow:function(rowIndex,rowData){
			if (rowIndex>-1) {
				globalObj.MrTypeID	= rowData.ID;
				globalObj.HospIDs	= rowData.HospIDs;
        globalObj.AdmType   = rowData.AdmType;
				InitgridNoType(rowData.ID)
				// 选中病案类型时,置号码类型ID为空,并重新加载号码类型已关联
				globalObj.NoTypeID=""
				InitgridNoTypeLnked();
				// end
			}
		}
	});
}

function editMrType(op){
	var selected = $("#gridMrType").datagrid('getSelected');
	if (( op == "edit")&&(!selected)) {
		$.messager.popover({msg: '请选择一条记录！',type: 'alert',timeout: 1000});
		return false;
	}
	$('#MrTypeDialog').css('display','block');
	//1.初始化病案分类
	var cboMrClassObj = $HUI.combobox('#cboMrClass',{
		url:$URL,
		editable: true,
		defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
		valueField: 'ID',
		textField: 'Desc',
		onBeforeLoad:function(param){	//在请求加载数据之前触发，返回 false 则取消加载动?????
			param.ClassName = 'CT.IPMR.BTS.MrClassSrv';
			param.QueryName = 'QueryMrClass';
			param.ResultSetType = 'array';
		}
	});
	Common_ComboToWorkFlow("cboWorkFlow");					// 2.初始化工作流
	Common_ComboToDic("cboReceiptType","ReceiptType","1");	// 3.下拉框,接诊类型
	Common_ComboToDic("cboMrAssignType","AssignType","1");		// 4.下拉框,分号方式
	Common_ComboToDic("cboMrNoFiled","MrNoField","1");		// 5.下拉框,病案号存储字段
	Common_CheckboxToDic("cbgAdmTypeList","AdmType","3");	// 6.多选框,就诊类型
	
	var _title = "修改病案类型",_icon="icon-w-edit"
	if (op == "add") {	//add
		_title = "添加病案类型",_icon="icon-w-add";
		$("#txtMrTypeId").val('');			// 病案类型ID
		$('#cboMrClass').combobox('setValue', '');
		$("#txtMrTypeDesc").val('');
		$('#cboWorkFlow').combobox('setValue', '');
		$('#cboReceiptType').combobox('setValue', '');
		$('#cboMrAssignType').combobox('setValue', '');
		$('#chkRecycleType').checkbox('setValue',false);	// 病案号回收
		$('#chkIsBWMrNo').checkbox('setValue',false);		// 回写
		$('#cboMrNoFiled').combobox('setValue', '');
		// 就诊类型
		$("input[name='cbgAdmTypeList']").each(function () {
			$(this).checkbox('setValue',false);
		})
		InitgridCTHospList("");								// 7.*初始化医院列表*
		$("#txtMrResume").val('');
	} else {
		// ID:MrClassID:MrClassDesc:MrTypeDesc:HospIDs:HospDescs:ReceiptTypeID:ReceiptTypeDesc:AssignTypeID:AssignTypeDesc:
		// RecycleType:RecycleTypeDesc:NoFiledID:NoFiledDesc:WorkFlowID:WorkFlowDesc:IsBWMrNo:IsBWMrNoDesc:AdmType:AdmTypeDesc:MTResume:
		$("#txtMrTypeId").val(selected.ID);			// 病案类型ID
		$('#cboMrClass').combobox('setValue', selected.MrClassID);
		$("#txtMrTypeDesc").val(selected.MrTypeDesc);
		$('#cboWorkFlow').combobox('setValue', selected.WorkFlowID);
		$('#cboReceiptType').combobox('setValue', selected.ReceiptTypeID);
		$('#cboMrAssignType').combobox('setValue', selected.AssignTypeID);
		$('#chkRecycleType').checkbox('setValue',(selected.RecycleType!="0"?true:false));	// 病案号回收
		$('#chkIsBWMrNo').checkbox('setValue',(selected.IsBWMrNo!="0"?true:false));		// 回写
		$('#cboMrNoFiled').combobox('setValue', selected.NoFiledID);
		
		// 就诊类型
		$("input[name='cbgAdmTypeList']").each(function () {
			$(this).checkbox('setValue',false);
		})
		var MTAdmType = selected.AdmType;
		if (MTAdmType != "") {
			MTAdmType	= MTAdmType.split("#")
			for (var i = 0; i < MTAdmType.length; i++) {
				$('#cbgAdmTypeList'+MTAdmType[i]).checkbox('setValue', (MTAdmType[i]!=""?true:false));
			}
		}
		
		InitgridCTHospList(selected);						// 7.*初始化医院列表*
		$("#txtMrResume").val(selected.MTResume);
	}
		
	var MrTypeDialog = $HUI.dialog('#MrTypeDialog',{
		title: _title,
		iconCls: _icon,
		modal: true,
		minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
		buttons:[{
			text:'保存',
				iconCls:'icon-w-save',
				handler:function(){
					saveMrType($("#txtMrTypeId").val());
				}
		},{
			text:'关闭',
			iconCls:'icon-w-close',
			handler:function(){
				$('#MrTypeDialog').window("close");
			}	
		}]
	});
}

function InitgridCTHospList(row){
	var columns = [[
		{field:'IsChecked',checkbox:true},
		{field:'HospDesc',title:'医院',width:'240',align:'left'}
	]];
	
	var MrTypeID	= row.ID;	// 病案类型ID
	var tClassName	= "";
	var tQueryName	= "";
	
	if (!MrTypeID) {
		tClassName	= "MA.IPMR.BTS.HospitalSrv"
		tQueryName	= "QryHosp"
	} else{
		tClassName	= "CT.IPMR.BTS.MrTypeSrv"
		tQueryName	= "QryMTHospList"
	}
	
	var gridCTHospList = $HUI.datagrid("#gridCTHospList",{
		fit:true,
		rownumbers: true,		//如果为true, 则显示一个行号列
		showHeader:true,		//不隐藏表头
		autoRowHeight: false,	//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		// fitColumns:true,		//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		checkOnSelect:true,		//true,击某一行时，选中/取消选中复选框
		selectOnCheck:true,		//true,点击复选框将会选中该行
		url:$URL,
		queryParams:{
		    ClassName:tClassName,
			QueryName:tQueryName,
			aMrTypeID:MrTypeID,
			rows:10000
		},
		columns :columns,
		onLoadSuccess: function (data) {
			if (data) {
				$.each(data.rows, function (index, item) {
					if (item.IsChecked == 1) {
						$('#gridCTHospList').datagrid('checkRow', index);
					}
				});
			}
		},
	});
}

function saveMrType(aMrTypeID){
	var MTMrClass		= $("#cboMrClass").combobox('getValue');
	var MTDesc			= $("#txtMrTypeDesc").val();
	var WorkFlow		= $("#cboWorkFlow").combobox('getValue');
	var MTReceiptType	= $("#cboReceiptType").combobox('getValue');
	var MTAssignType		= $("#cboMrAssignType").combobox('getValue');
	
	var MTRecycleType	= $("#chkRecycleType").checkbox('getValue');
	var MTIsBWMrNo		= $("#chkIsBWMrNo").checkbox('getValue');
	var MTNoFiled		= $("#cboMrNoFiled").combobox('getValue');
	var MTAdmType		= Common_CheckboxValue("cbgAdmTypeList");
	if (MTAdmType != "") MTAdmType = MTAdmType.replace(/,/g,'#');
	var MTResume		= $("#txtMrResume").val();
	
	var rows = $('#gridCTHospList').datagrid('getSelections');	//datagrid('getChecked');
	var HospIDs		= '';
	for (var i = 0; i < rows.length; i++) {
		HospIDs=HospIDs+"#"+rows[i].HospID;
	}
	if (HospIDs != '') HospIDs=HospIDs.substr(1);
	
	if (!MTMrClass) {
		$.messager.popover({msg: '必需选择病案分类！',type: 'alert',timeout: 1000});
		return
	}
	if (!MTDesc) {
		$.messager.popover({msg: '病案类型名称必填！',type: 'alert',timeout: 1000});
		return
	}
	if ((!MTRecycleType)&&(!MTIsBWMrNo)) {
		$.messager.popover({msg: '病案号不回收时,必须回写！',type: 'alert',timeout: 1200});
		return
	}
	var tmp = aMrTypeID + "^";
		tmp += MTMrClass + "^";
		tmp += MTDesc + "^";
		tmp += HospIDs + "^";
		tmp += MTReceiptType + "^";
		tmp += MTAssignType + "^";
		tmp += (MTRecycleType==true?1:0) + "^";
		tmp += MTNoFiled + "^";
		tmp += WorkFlow + "^";
		tmp += (MTIsBWMrNo==true?1:0) + "^";
		tmp += MTAdmType + "^";
		tmp += MTResume + "^";
	
	var flg = $m({
		ClassName:"CT.IPMR.BT.MrType",
		MethodName:"Update",
		aInputStr:tmp,
		aSeparate:"^"
	},false);
	
	if (parseInt(flg) <= 0) {
		$.messager.alert("错误", "保存失败!", 'error');
		return;
	}else{
		globalObj.MrTypeID	= ""	// 保存成功后,病案类型ID置为空,防止新增号码类型关联错误病案类型
		$HUI.dialog('#MrTypeDialog').close();
		$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
		$('#gridMrType').datagrid('reload');
		$('#gridMrType').datagrid('unselectAll');
	}
}

function deleteMrType(){
	var selected = $('#gridMrType').datagrid('getSelected');
	if (!selected) {
		$.messager.popover({msg: '请选择一条记录！',type: 'alert',timeout: 1000});
		return false;
	}
	
	var flg = $m({
		ClassName:"CT.IPMR.BT.MrType",
		MethodName:"DeleteById",
		aId:selected.ID
	},false);
	
	if (parseInt(flg) <= 0) {
		$.messager.alert("错误", "删除失败!", 'error');
		return;
	}else{
		globalObj.MrTypeID	= ""	// 删除成功后,病案类型ID置为空,防止新增号码类型失败
		$('#gridMrType').datagrid('reload');		// 重新载入当前页面数据
		$('#gridMrType').datagrid('unselectAll');
		$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
	}
}

 /**
 * NUMS: 002
 * CTOR: WHui
 * DESC: 号码类型维护
 * DATE: 2019-10-27
 * NOTE: 包括五个个方法：InitgridNoType,editNoType,saveNoType,deleteNoType,CheckNoHead
 * TABLE: CT_IPMR_BT.MrType		CT_IPMR_BT.NoType
 */
function InitgridNoType(op){
	var columns = [[
		{field:'Code',title:'代码',width:60,align:'left'},
		{field:'Desc',title:'描述',width:100,align:'left'},
		{field:'NoHead',title:'类型标记',width:100,align:'left'},
		{field:'NoLen',title:'号码<br>长度',width:50,align:'left'},
		{field:'CurrNo',title:'当前号',width:100,align:'left'},
		{field:'MaxNo',title:'最大号',width:100,align:'left'},
		{field:'MinNo',title:'最小号',width:60,align:'left'},
		{field:'IsDefaultDesc',title:'默认<br>类型',width:50,align:'left'},
		{field:'IsActiveDesc',title:'是否<br>有效',width:50,align:'left'},
		{field:'Resume',title:'备注',width:150,align:'left'}
	]];
	
	var gridNoType = $HUI.datagrid("#gridNoType",{
		fit: true,
		title:"号码类型维护",
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		rownumbers: true,		//如果为true, 则显示一个行号列
		singleSelect:true,
		autoRowHeight: false,	//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		fitColumns:false,		//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		url:$URL,
		queryParams:{
		    ClassName:"CT.IPMR.BTS.NoTypeSrv",
			QueryName:"QryMrNoType",
			aMrTypeID:op,
			rows:10000
		},
		columns :columns,
		onClickRow:function(rowIndex,rowData){
			if (rowIndex>-1) {
				globalObj.NoTypeID	= rowData.ID;
				InitgridNoTypeLnked();
			}
		}
	})
}

function editNoType(op){
	if (!globalObj.MrTypeID) {
		$.messager.popover({msg: '必须选中一条病案类型！',type: 'alert',timeout: 1000});
		return false;
	}
	var ntySelected = $("#gridNoType").datagrid('getSelected');
	if (( op == "edit")&&(!ntySelected)) {
		$.messager.popover({msg: '请选择一条记录！',type: 'alert',timeout: 1000});
		return false;
	}
	$('#NoTypeDialog').css('display','block');
	
	var _title = "修改号码类型",_icon="icon-w-edit"
	if (op == "add") {	//add
		_title = "添加号码类型",_icon="icon-w-add";
		$("#txtNoTypeId").val('');		// 号码类型ID
		$("#txtBNCode").val('');
		$("#txtBNDesc").val('');
		$("#txtBNNoHead").val('');
		$("#txtBNNoLen").val('');
		$("#txtBNCurrNo").val('');
		$("#txtBNMaxNo").val('');
		$("#txtBNMinNo").val('');
		$('#chkBNIsDefault').checkbox('setValue',false);	// 默认类型
		$('#chkBNIsActive').checkbox('setValue',false);		// 是否有效
		$("#txtBNResume").val('');
	} else {
		$("#txtNoTypeId").val(ntySelected.ID);		// 号码类型ID
		$("#txtBNCode").val(ntySelected.Code);
		$("#txtBNDesc").val(ntySelected.Desc);
		$("#txtBNNoHead").val(ntySelected.NoHead);
		$("#txtBNNoLen").val(ntySelected.NoLen);
		$("#txtBNCurrNo").val(ntySelected.CurrNo);
		$("#txtBNMaxNo").val(ntySelected.MaxNo);
		$("#txtBNMinNo").val(ntySelected.MinNo);
		$('#chkBNIsDefault').checkbox('setValue',(ntySelected.IsDefault!="0"?true:false));	// 默认类型
		$('#chkBNIsActive').checkbox('setValue',(ntySelected.IsActive!="0"?true:false));		// 是否有效
		$("#txtBNResume").val(ntySelected.Resume);
	}
	
	var NoTypeDialog = $HUI.dialog('#NoTypeDialog',{
		title: _title,
		iconCls: _icon,
		modal: true,
		minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
		buttons:[{
			text:'保存',
				iconCls:'icon-w-save',
				handler:function(){
					saveNoType($("#txtNoTypeId").val());
				}
		},{
			text:'关闭',
			iconCls:'icon-w-close',
			handler:function(){
				$('#NoTypeDialog').window("close");
			}	
		}]
	});
}

function saveNoType(aNoTypeId){
	// var a = globalObj.MrTypeID;
	var flag = 0;
	var Data = $('#gridNoType').datagrid('getData');
	for (var i = 0; i < Data.total; i++) {
		var row = Data.rows[i];
		if ((row.IsDefault==1)&&(row.ID!=aNoTypeId)){
			flag =1
		}
	}
	
	var errinfo			= "";
	var NoTypeID		= aNoTypeId;
	if (NoTypeID == ""){
		var ChildSub = "";
	} else {
		var ChildSub = NoTypeID.split("||")[1];
	}
	
	var NTCode			= $("#txtBNCode").val();
	if (!NTCode){
		errinfo = errinfo + "代码为空!<br>";
	}
	var NTDesc			= $("#txtBNDesc").val();
	if (!NTDesc){
		errinfo = errinfo + "描述为空!<br>";
	}
	var NTNoLen			= $("#txtBNNoLen").val();
	var NTNoHead		= $("#txtBNNoHead").val();
	if (NTNoHead){
		var Headflag = CheckNoHead(NTNoHead);
		if (!Headflag){
			errinfo = errinfo + "类型标记只能是大写字母!<br>";
		}
	}
	
	var NTCurrNo		= $("#txtBNCurrNo").val();
	if (NTCurrNo==''){
		errinfo = errinfo + "当前号为空!<br>";
	}
	
	var NTMaxNo			= $("#txtBNMaxNo").val();
	var NTMinNo			= $("#txtBNMinNo").val();
	if ((NTMaxNo!="")&&(NTMinNo!="")){
		if (NTMaxNo<NTMinNo){
			errinfo = errinfo + "最大号小于最小号!<br>";
		}
	}
	if (errinfo) {
		$.messager.alert("提示",errinfo,"error");
		return;
	}
	
	var NTIsDefault		= $("#chkBNIsDefault").checkbox('getValue');
	var NTIsActive		= $("#chkBNIsActive").checkbox('getValue');
	if ((flag ==1)&&(NTIsDefault)){
		$.messager.popover({msg: '已设置默认类型，不允许再次设置！',type: 'alert',timeout: 2000});
		return;
	}
	var NTResume		= $("#txtBNResume").val();
	
	var tmp =  globalObj.MrTypeID + "^";
		tmp += ChildSub + "^";
		tmp += NTCode + "^";
		tmp += NTDesc + "^";
		tmp += NTNoLen + "^";
		tmp += NTNoHead + "^";
		tmp += NTCurrNo + "^";
		tmp += NTMaxNo + "^";
		tmp += NTMinNo + "^";
		tmp += (NTIsDefault==true?1:0) + "^";
		tmp += (NTIsActive==true?1:0) + "^";
		tmp += NTResume + "^";
	// debugger
	var flg = $m({
		ClassName:"CT.IPMR.BT.NoType",
		MethodName:"Update",
		aInputStr:tmp,
		aSeparate:"^"
	},false);
	
	if (parseInt(flg) <= 0) {
		$.messager.alert("错误", "保存失败!", 'error');
		return;
	}else{
		globalObj.NoTypeID	= "";		// 新增号码类型号,globalObj.NoTypeID置为空,防止关联科室到错误号码类型
		$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
		$HUI.dialog('#NoTypeDialog').close();
		$('#gridNoType').datagrid('reload');
		$('#gridNoType').datagrid('unselectAll');
	}
}

function deleteNoType(){
	var selected = $("#gridNoType").datagrid('getSelected');
	if (!selected) {
		$.messager.popover({msg: '请选择一条记录！',type: 'alert',timeout: 1000});
		return false;
	}
	
	var flg = $m({
		ClassName:"CT.IPMR.BT.NoType",
		MethodName:"DeleteById",
		aId:selected.ID
	},false);
	
	if (parseInt(flg) <= 0) {
		$.messager.alert("错误", "删除失败!", 'error');
		return;
	}else{
		globalObj.NoTypeID	= "";		// 删除号码类型号,globalObj.NoTypeID置为空,防止号码类型关联科室失败
		$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
		$HUI.dialog('#NoTypeDialog').close();
		$('#gridNoType').datagrid('reload');		// 重新载入当前页面数据
		$('#gridNoType').datagrid('unselectAll');
	}
}

function CheckNoHead(value){
	var strExp=/^[A-Z]+$/;
	if(strExp.test(value)){
		return true;
	}else{
		return false;
	}
}

 /**
 * NUMS: 003
 * CTOR: WHui
 * DESC: 号码类型关联维护
 * DATE: 2019-10-28
 * NOTE: 包括九个方法：InitgridNoTypeLnked,deleteNoTyLnk,InitNoTypeLnkWindow,
 * 		openNoTypeLnkWin,InitNoTypeHosLnk,InitNoTypeLocLnk,saveNoTypeLnk,searchHosp,searchLoc
 * TABLE: CT_IPMR_BT.MrType		CT_IPMR_BT.NoType	CT_IPMR_BT.NoTypeLnk
 */
// 已关联
function InitgridNoTypeLnked(){
	var columns = [[
		{field:'HospDesc',title:'关联医院',width:230,align:"left"},
		{field:'LocDesc',title:'关联科室',width:220,align:"left"}
	]];
	
	var gridNoTypeLnked = $HUI.datagrid("#gridNoTypeLnked",{
		fit:true,
		title:"号码类型关联科室数据",
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true,		//如果为true, 则显示一个行号列
		singleSelect:true,
		autoRowHeight: false,	//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		fitColumns:true,		//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		url:$URL,
		queryParams:{
		   ClassName:"CT.IPMR.BTS.NoTypeLnkSrv",
		   QueryName:"QryNoTpLocList",
		   aNoTypeID:globalObj.NoTypeID,
		   rows:10000
		},
		columns :columns
	});
}

// 删除号码类型关联
function deleteNoTyLnk(){
	var selected = $("#gridNoTypeLnked").datagrid('getSelected');
	if (!selected) {
		$.messager.popover({msg: '请选择一条记录！',type: 'alert',timeout: 1000});
		return false;
	}
	
	var flg = $m({
		ClassName:"CT.IPMR.BT.NoTypeLnk",
		MethodName:"DeleteById",
		aId:selected.ID
	},false);
	
	if (parseInt(flg) <= 0) {
		$.messager.alert("错误", "删除失败!", 'error');
		return;
	}else{
		$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
		$('#gridNoTypeLnked').datagrid('reload');
		$('#gridNoTypeLnked').datagrid('unselectAll');
	}
}

// 新增号码关联按钮控制
function InitNoTypeLnkWindow(){
	var tMrTypeId	= globalObj.MrTypeID;
	var tHospIDs	= globalObj.HospIDs;
	var tNoTypeID	= globalObj.NoTypeID;
	var tAdmType	= globalObj.AdmType;
	
	if (!tMrTypeId) {
		$.messager.popover({msg: '必须选中一条病案类型！',type: 'alert',timeout: 1000});
		return
	}
	if ((tMrTypeId)&&(!tHospIDs)) {
		$.messager.popover({msg: '此病案类型未关联医院,无法关联科室',type: 'alert',timeout: 2000});
		return
	}
	if ((tMrTypeId)&&(tHospIDs)&&(!tAdmType)) {
		$.messager.popover({msg: '此病案类型未关联就诊类型,无法关联科室！',type: 'alert',timeout: 2000});
		return
	}
	if (!tNoTypeID) {
		$.messager.popover({msg: '必须选中一条号码类型！',type: 'alert',timeout: 1000});
		return
	}
	openNoTypeLnkWin(tMrTypeId,tHospIDs,tNoTypeID);
}
// 新增号码关联页面
function openNoTypeLnkWin(aMrTypeId,aHospIDs,aNoTypeID){
	$('#NoTypeLnkWindow').css('display','block');
	$('#NoTypeLnkWindow').window({
		top: 80 + "px"
	});
	var _title = "新增号码类型关联",_icon="icon-w-edit"
	var NoTypeLnkWindow =$HUI.window('#NoTypeLnkWindow',{
		title:_title,
		iconCls:_icon,
		modal:true,
		minimizable:false,
		maximizable:false,
		collapsible:false,
		isTopZindex:true,
		onBeforeOpen: function(){
			$('#hosp-search').click(function(){searchHosp();});
			$('#loc-search').click(function(){searchLoc();});
			
			$('#HospSearch').bind('keyup', function(event) {
			　　if (event.keyCode == "13") {
			　　　　searchHosp();
			　　}
			});
			$('#LocSearch').bind('keyup', function(event) {
			　　if (event.keyCode == "13") {
			　　　　searchLoc();
			　　}
			});
		},
		/* onClose: function () {
		} */
	});
	
	InitNoTypeHosLnk(aHospIDs);
	InitNoTypeLocLnk();
	$('#NoTypeLnkWindow').window('open');
}

// 病案类型所维护的医院列表
function InitNoTypeHosLnk(op){
	var columns = [[
		{field:'IsChecked',checkbox:true},
		{field:'HospDesc',title:'医院名称',width:270,align:"left"}
	]];
	var gridNoTypeHosLnk = $HUI.datagrid("#gridNoTypeHosLnk",{
		fit:true,
		title:"医院列表",
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		rownumbers: true,		//如果为true, 则显示一个行号列
		singleSelect:true,
		autoRowHeight: false,	//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		fitColumns:true,		//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		checkOnSelect:true,		//true,击某一行时，选中/取消选中复选框
		selectOnCheck:true,		//true,点击复选框将会选中该行
		url:$URL,
		queryParams:{
		    ClassName:"CT.IPMR.BTS.NoTypeSrv",
			QueryName:"QryHospByIDs",
			aHospIDs:op,
			rows:10000
		},
		columns :columns,
		onSelect:function(rowIndex,rowData){
			if (rowIndex>-1) {
				globalObj.hospForLocSearch	= rowData.HospID;
				InitNoTypeLocLnk(rowData.HospID);
			}
		}
	})
}

// 科室
function InitNoTypeLocLnk(op){
	var columns = [[
		{field:'IsChecked',checkbox:true},
		{field:'LocDesc',title:'科室描述',width:260,align:"left"}
	]];
	
	var gridNoTypeLocLnk = $HUI.datagrid("#gridNoTypeLocLnk",{
		fit:true,
		title:"科室列表",
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true,		//如果为true, 则显示一个行号列
		singleSelect:true,
		autoRowHeight: false,	//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 10,
		fitColumns:true,		//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		url:$URL,
		queryParams:{
		    ClassName:"CT.IPMR.BTS.NoTypeSrv",
			QueryName:"QryLocByNoType",
			aHospID:op,
			aNoTypeID:globalObj.NoTypeID,
			rows:10000
		},
		columns :columns,
		onSelect:function(rowIndex,rowData){
			if (rowIndex>-1) {
				saveNoTypeLnk(rowData);
			}
		}
	})
}

// 保存号码关联
function saveNoTypeLnk(row){
	var Parref="",HospID="",LocID="",PatType="",errinfo = "";
	var Parref		= globalObj.NoTypeID;
	var ChildSub	= "";
	var HospID		= row.HospID;
	var LocID		= row.LocID;
	if (!HospID){
		errinfo = errinfo + "医院为空!<br>";
	}
	if (!LocID){
		errinfo = errinfo + "科室为空!<br>";
	}
	if (errinfo) {
		$.messager.alert("错误", errinfo, 'error');
		return;
	}
	var tmp =  Parref + "^";
		tmp += ChildSub + "^";
		tmp += HospID + "^";
		tmp += LocID + "^";
		tmp += PatType + "^";
		
	var flg = $m({
		ClassName:"CT.IPMR.BT.NoTypeLnk",
		MethodName:"Update",
		aInputStr:tmp,
		aSeparate:"^"
	},false);
	
	if (parseInt(flg) <= 0) {
		$.messager.alert("错误", "保存失败!", 'error');
		return;
	}else{
		$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
		$('#gridNoTypeLnked').datagrid('reload');
		$('#gridNoTypeLocLnk').datagrid('reload');
		
		$('#gridNoTypeLnked').datagrid('unselectAll');
		$('#gridNoTypeLocLnk').datagrid('unselectAll');
	}
}

// 医院查询
function searchHosp(){
	var alias = $("#HospSearch").val();
	
	if (!globalObj.HospIDs) {
		$.messager.alert("提示", "必须选中一条病案类型才能查询!", 'info');
	}
	
	$("#gridNoTypeHosLnk").datagrid('load',{
		ClassName:"CT.IPMR.BTS.NoTypeSrv",
		QueryName:"QryHospByIDs",
		aHospIDs:globalObj.HospIDs,
		aAlias:alias
	});
}

// 科室查询
function searchLoc(){
	var alias = $("#LocSearch").val();
	
	if (!globalObj.NoTypeID) {
		$.messager.alert("提示", "必须选中一条号码类型才能查询!", 'info');
		return
	}
	if (!globalObj.hospForLocSearch) {
		$.messager.alert("提示", "必须选中一条医院才能查询!", 'info');
		return
	}
	
	$("#gridNoTypeLocLnk").datagrid('load',{
		ClassName:"CT.IPMR.BTS.NoTypeSrv",
		QueryName:"QryLocByNoType",
		aHospID:globalObj.hospForLocSearch,
		aNoTypeID:globalObj.NoTypeID,
		aAlias:alias
	});
}