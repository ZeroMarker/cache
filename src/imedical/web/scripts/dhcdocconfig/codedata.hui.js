/**
 * codedata.hui.js 代码模块数据维护HUI
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2018-08-10
 * 
 * 注解说明
 * TABLE: 
 */
 
//页面全局变量
var PageLogicObj = {
	m_MainGrid : "",
	m_CenterGrd: "",
	m_CenterWin: "",
	m_CmdWin : "",
	m_CmdGrid: "",
	m_CmdGridWin: "",
	m_DataWin: "",
	m_DataModuleBox: "",
	m_seclectId: ""
}

$(function(){
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
	
	//页面元素初始化
	//PageHandle();
	InitCache();
})
function InitCache(){
	var hasCache = $.DHCDoc.hasCache();
	if (hasCache!=1) {
		$.DHCDoc.CacheConfigPage();
		$.DHCDoc.storageConfigPageCache();
	}
}
function Init(){
	PageLogicObj.m_MainGrid = InitMainGrid();
	LoadCenMainPage();
}
function InitEvent(){
	$("#i-add").click(function(){cmdDataDialog("add")});
	$("#i-edit").click(function(){cmdDataDialog("edit")});
	$("#i-delete").click(function(){deleteCmdData()});
	$("#i-codeModule").click(function() {cmdDialog()});
	$("#Instructions").click(function(){$("#InstrWin").window("open")})
	$(document.body).bind("keydown",BodykeydownHandler)
}

function InitCmdEvent(){
	$("#cmd-add").click(function(){cmdGridDialog("add")});
	$("#cmd-edit").click(function(){cmdGridDialog("edit")});
	$("#cmd-delete").click(function(){deleteCmd()});
}

function InitCenterEvent(){
	$("#center-add").click(function(){centerDialog("add")});
	$("#center-edit").click(function(){centerDialog("edit")});
	$("#center-delete").click(function(){deleteCenter()});
}

function PageHandle(){
	//
}


 /**
 * NUMS: C001
 * CTOR: QP
 * DESC: 左侧-代码模块数据维护
 * DATE: 2018-09-13
 * NOTE: 包括四个方法：cmdDataDialog、deleteCmdData、InitMainGrid、saveCmdData
 * TABLE: DHCDoc_CT_Define、DHCDoc_CT_DefineData
 */
 
function InitMainGrid(){
	var columns = [[
		{field:'DefineCode',title:'代码表代码',width:200},
		{field:'DefineDesc',title:'代码表名称',width:200},
		{field:'ModuleDesc',title:'模块名称',width:200},
		{field:'ModuleDR',title:'ModuleDR',width:60,hidden:true},
		{field:'DefineRowID',title:'ID',width:60,hidden:true}
    ]]
	var DurDataGrid = $HUI.datagrid("#i-mGrid", {
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		rownumbers:true,
		//autoRowHeight : false,
		pagination : true,  
		headerCls:'panel-header-gray',
		//pageSize:14,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "web.DHCDocCTCommon",
			QueryName : "LookUpDHCDocCTDefine"
		},
		columns :columns,
		toolbar:[{
				text:'添加',
				id:'i-add',
				iconCls: 'icon-add'
			},{
				text:'修改',
				id:'i-edit',
				iconCls: 'icon-edit'
			},{
				text:'删除',
				id:'i-delete',
				iconCls: 'icon-cancel'
			},{
				text:'模块维护',
				id:'i-codeModule',
				iconCls: 'icon-set-paper'
			}
		],
		onSelect: function (rowIndex, rowData) {
			hiddenMainPage();
			InitCenterGrid(rowData.DefineRowID);
		}
	});
	
	return DurDataGrid;
}

//代码数据维护-添加、更新事件
function cmdDataDialog(ac) {
	var selected = PageLogicObj.m_MainGrid.getSelected();
	if (( ac == "edit")&&(!selected)) {
		$.messager.alert("提示","请选择一条记录...","info")
		return false;
	}
	
	if($('#cmdData').hasClass("c-hidden")) {
		$('#cmdData').removeClass("c-hidden");
	};
	var moduleBox = $HUI.combobox("#data-module", {
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CommonFunction&QueryName=QryCodeModule&ResultSetType=array",
		valueField:'ModuleRowId',
		textField:'ModuleDesc'
	})
	var _title = "修改模块代码",_icon="icon-w-edit"
	if (ac == "add") {
		$("#data-action").val("add");
		$("#data-id").val("")
		$("#data-name").val("");
		$("#data-code").val("");
		moduleBox.setValue("");
		_title = "添加模块代码",_icon="icon-w-add";
	} else {
		
		$("#data-action").val("edit");
		$("#data-id").val(selected.DefineRowID)
		$("#data-name").val(selected.DefineDesc);
		$("#data-code").val(selected.DefineCode);
		moduleBox.setValue(selected.ModuleDR);
	}
	PageLogicObj.m_DataModuleBox = moduleBox;
	var cmdDataWin = $HUI.window('#cmdData', {
		title: _title,
		iconCls: _icon,
		modal: true,
		minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
		onClose: function () {
			$('#cmdData').addClass("c-hidden");
		}
	});
	PageLogicObj.m_DataWin = cmdDataWin;
	
}


//LEFT-保存左侧模块代码
function saveCmdData () {
	var id = $("#data-id").val();
	var action = $("#data-action").val();
	var code = $.trim($("#data-code").val());
	var name = $.trim($("#data-name").val());
	var moduleDR = PageLogicObj.m_DataModuleBox.getValue();
	
	if (code == "") {
		$.messager.alert("提示","代码表代码不得为空...","info")
		return false;
	}
	if (name == "") {
		$.messager.alert("提示","代码表名称不得为空...","info")
		return false;
	}
	if (moduleDR == "") {
		$.messager.alert("提示","模块名称不得为空...","info")
		return false;
	}
	
	var rtn = 0;
	if (action == "add") {
		var rtn=tkMakeServerCall("web.DHCDocCTCommon","InsertDHCDocCTDefine",code,name,moduleDR)
	} else {
		var rtn=tkMakeServerCall("web.DHCDocCTCommon","UpdateDHCDocCTDefine",id,code,name,moduleDR)
	}
	if (rtn == 0) {
		$.messager.alert("提示","保存成功...","info")
		PageLogicObj.m_DataWin.close();
		PageLogicObj.m_MainGrid.reload();
		showMainPage();
	} else {
		$.messager.alert("提示","保存失败...","info")
	}
	
}
//删除模块代码
function deleteCmdData () {
	var selected = PageLogicObj.m_MainGrid.getSelected();
	if (!selected) {
		$.messager.alert("提示","请选择一条记录...","info")
		return false;
	}
	var rtn=tkMakeServerCall("web.DHCDocCTCommon","DelDHCDocCTDefine",selected.DefineRowID)
	if (rtn == 0) {
		$.messager.alert("提示","删除成功...","info")
		PageLogicObj.m_MainGrid.reload();
		showMainPage();
	} else {
		$.messager.alert("提示","删除失败...","info")
	}

}


 
 /**
 * CTOR: QP
 * NUMS: C002
 * DESC: 代码模块维护
 * DATE: 2018-09-13
 * NOTE: 包括四个方法：deleteCmd、cmdDialog、cmdGridDialog、saveCmd
 * TABLE: DHCDoc_CT_Module
 */
 
//代码模块维护
function cmdDialog () {
	if($('#cmd').hasClass("c-hidden")) {
		$('#cmd').removeClass("c-hidden");
	};
	
	var columns = [[
		{field:'ModuleDesc',title:'模块名称',width:200},
		{field:'ModuleRowId',title:'ID',width:60}
    ]]
	
	var cmdGrid = $HUI.datagrid("#cmd-grid", {
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		rownumbers:true,
		//autoRowHeight : false,
		pagination : true,  
		headerCls:'panel-header-gray',
		//pageSize:14,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "web.DHCDocCTCommon",
			QueryName : "GetDHCDocCTModule"
		},
		columns :columns,
		toolbar:[{
				text:'添加',
				id:'cmd-add',
				iconCls: 'icon-add'
			},{
				text:'修改',
				id:'cmd-edit',
				iconCls: 'icon-edit'
			},{
				text:'删除',
				id:'cmd-delete',
				iconCls: 'icon-cancel'
			}
		]
	})
	
	var cmdWin = $HUI.window('#cmd', {
		title: "代码模块维护",
		iconCls: "icon-w-config",
		modal: true,
		height:400,
		minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
		onClose: function () {
			$('#cmd').addClass("c-hidden");
			cmdGrid.destroy();
			PageLogicObj.m_CmdGrid = "";
		}
	});
	
	PageLogicObj.m_CmdWin = cmdWin;
	PageLogicObj.m_CmdGrid = cmdGrid
	InitCmdEvent();
}

//代码模块维护-表格中的增加、删除事件
function cmdGridDialog(ac) {
	var selected = PageLogicObj.m_CmdGrid.getSelected();
	if (( ac == "edit")&&(!selected)) {
		$.messager.alert("提示","请选择一条记录...","info")
		return false;
	}
	
	if($('#cmd-dg').hasClass("c-hidden")) {
		$('#cmd-dg').removeClass("c-hidden");
	};
	
	var _title = "修改代码模块",_icon="icon-w-edit"
	if (ac == "add") {
		$("#cmd-action").val("add");
		$("#cmd-name").val("");
		$("#cmd-id").val("")
		_title = "添加代码模块",_icon="icon-w-add";
	} else {
		$("#cmd-action").val("edit");
		$("#cmd-id").val(selected.ModuleRowId)
		$("#cmd-name").val(selected.ModuleDesc);
	}
	
	var cmdGridWin = $HUI.window('#cmd-dg', {
		title: _title,
		iconCls: _icon,
		modal: true,
		minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
		onClose: function () {
			$('#cmd-dg').addClass("c-hidden");
		}
	});
	PageLogicObj.m_CmdGridWin = cmdGridWin;
}

//保存代码模块
function saveCmd () {
	var id = $("#cmd-id").val();
	var action = $("#cmd-action").val();
	var name = $.trim($("#cmd-name").val());
	if (name == "") {
		$.messager.alert("提示","模块名称不得为空...","info")
		return false;
	}
	var rtn = 0;
	if (action == "add") {
		rtn = tkMakeServerCall("web.DHCDocCTCommon","InsertDHCDocCTModule",name);
	} else {
		rtn = tkMakeServerCall("web.DHCDocCTCommon","UpdateDHCDocCTModule",id,name)
	}
	if (rtn == 0) {
		$.messager.alert("提示","保存成功...","info")
		PageLogicObj.m_CmdGridWin.close();
		PageLogicObj.m_CmdGrid.reload();
	} else if (rtn =="repeat"){
		$.messager.alert("提示","保存失败!模块名称重复!","info",function(){
			$("#cmd-name").focus();
		})
	}else {
		$.messager.alert("提示","保存失败...","info",function(){
			$("#cmd-name").focus();
		})
	}
	
}
//删除代码模块
function deleteCmd () {
	var selected = PageLogicObj.m_CmdGrid.getSelected();
	if (!selected) {
		$.messager.alert("提示","请选择一条记录...","info")
		return false;
	}
	var rtn = tkMakeServerCall("web.DHCDocCTCommon","DelDHCDocCTModule",selected.ModuleRowId)
	if (rtn == 0) {
		$.messager.alert("提示","删除成功...","info")
	} else {
		$.messager.alert("提示","删除失败...","info")
	}
	PageLogicObj.m_CmdGrid.reload();
	
}

/**
 * NUMS: C003
 * CTOR: QP
 * DESC: 中间-模块代码表数据列表
 * DATE: 2018-09-13
 * NOTE: 包括四个方法：InitCenterGrid、centerDialog、deleteCenter、saveCenter
 * TABLE: 
 */
 //模块代码表数据列表
function InitCenterGrid(defineId){
	PageLogicObj.m_seclectId = defineId; 
	
	if (PageLogicObj.m_CenterGrd !="") {
		$("#i-c-grid").datagrid("reload", {
			ClassName : "web.DHCDocCTCommon",
			QueryName : "LookUpDHCDocCTDefineData",
			DefineRowID: defineId
		})
		return false;
	}
	var columns = [[
		{field:'SubCode',title:'代码',width:200},
		{field:'SubDesc',title:'描述',width:200},
		{field:'SubStDate',title:'开始日期',width:200},
		{field:'SubEndDate',title:'结束日期',width:200},
		{field:'SubRowID',title:'ID',width:60}
    ]]
	var DurDataGrid = $HUI.datagrid("#i-c-grid", {
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		rownumbers:true,
		//autoRowHeight : false,
		pagination : true,  
		headerCls:'panel-header-gray',
		//pageSize:14,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "web.DHCDocCTCommon",
			QueryName : "LookUpDHCDocCTDefineData",
			DefineRowID: defineId
		},
		columns :columns,
		toolbar:[{
				text:'添加',
				id:'center-add',
				iconCls: 'icon-add'
			},{
				text:'修改',
				id:'center-edit',
				iconCls: 'icon-edit'
			},{
				text:'删除',
				id:'center-delete',
				iconCls: 'icon-cancel'
			}
		]
	});
	PageLogicObj.m_CenterGrd = DurDataGrid;
	InitCenterEvent();
}

function centerDialog (ac) {
	var selected = PageLogicObj.m_CenterGrd.getSelected();
	if (( ac == "edit")&&(!selected)) {
		$.messager.alert("提示","请选择一条记录...","info")
		return false;
	}
	
	if($('#cen').hasClass("c-hidden")) {
		$('#cen').removeClass("c-hidden");
	};
	
	var _title = "修改",_icon="icon-w-edit"
	if (ac == "add") {
		$("#cen-action").val("add");
		$("#cen-id").val("")
		$("#cen-name").val("");
		$("#cen-code").val("").focus();
		$("#data-sd").datebox("setValue", ServerObj.CurDate);
		$("#data-ed").datebox("setValue", "");
		_title = "添加",_icon="icon-w-add";
	} else {
		$("#cen-action").val("edit");
		$("#cen-id").val(selected.SubRowID)
		$("#cen-code").val(selected.SubCode).focus();
		$("#cen-name").val(selected.SubDesc);
		$("#data-sd").datebox("setValue", selected.SubStDate);
		$("#data-ed").datebox("setValue", selected.SubEndDate);
		
	}
	
	var cenWin = $HUI.window('#cen', {
		title: _title,
		iconCls: _icon,
		modal: true,
		minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
		onClose: function () {
			$('#cen').addClass("c-hidden");
		},
		onShow:function(){
			$("#cen-code").focus();
		}
	});
	PageLogicObj.m_CenterWin = cenWin;
}

function saveCenter () {
	var id = $("#cen-id").val();
	var action = $("#cen-action").val();
	var name = $.trim($("#cen-name").val());
	var code = $.trim($("#cen-code").val());
	var sdate = $("#data-sd").datebox("getValue");
	var edate = $("#data-ed").datebox("getValue");
	if (code == "") {
		$.messager.alert("提示","数据代码不得为空...","info",function(){
			$("#cen-code").focus();
		})
		return false;
	}
	if (name == "") {
		$.messager.alert("提示","数据描述不得为空...","info",function(){
			$("#cen-name").focus();
		})
		return false;
	}
	if (sdate ==""){
		$.messager.alert("提示","请选择开始日期！","info",function(){
			$("#data-sd").next('span').find('input').focus();
		})
		return false;
	}
	var result = CompareDate(sdate,edate)
	if (!result) {
		$.messager.alert("提示","请重新选择有效的日期...","info")
		return;
	}
	
	var rtn = 0;
	if (action == "add") {
		var rtn=tkMakeServerCall("web.DHCDocCTCommon","InsertDHCDocCTDefineData",PageLogicObj.m_seclectId, code, name, sdate, edate)
	} else {
		var rtn=tkMakeServerCall("web.DHCDocCTCommon","UpdateDHCDocCTDefineData",PageLogicObj.m_seclectId, id, code, name, sdate, edate)
	}
	if (rtn == 0) {
		$.messager.alert("提示","保存成功...","info")
		PageLogicObj.m_CenterWin.close();
		PageLogicObj.m_CenterGrd.reload();
	} else {
		$.messager.alert("提示","保存失败...","info")
	}
	
}

function deleteCenter () {
	var selected = PageLogicObj.m_CenterGrd.getSelected();
	if (!selected) {
		$.messager.alert("提示","请选择一条记录...","info")
		return false;
	}
	var rtn=tkMakeServerCall("web.DHCDocCTCommon","DelDHCDocCTDefineData",PageLogicObj.m_seclectId, selected.SubRowID);
	if (rtn == 0) {
		$.messager.alert("提示","删除成功...","info")
		PageLogicObj.m_CenterGrd.reload();
	} else {
		$.messager.alert("提示","删除失败...","info")
	}
	
}

function LoadCenMainPage () {
	showMainPage();
	var cenPanel = $HUI.panel("#cenPanel",{
		title:"操作提醒",
		fit:true,
		iconCls:'icon-w-edit',
		collapsible:false
	});
}

function hiddenMainPage() {
	var hasHidden = $("#main").hasClass("c-hidden");
	if (!hasHidden) {
		$("#main").addClass("c-hidden");
	}
	$("#c-con").removeClass("c-hidden");
}

function showMainPage() {
	var hasHidden = $("#main").hasClass("c-hidden");
	if (hasHidden) {
		$("#main").removeClass("c-hidden");
	};
	
	$("#c-con").addClass("c-hidden");
}

//对比日期
function CompareDate(DateFrom,DateTo)
{
	DateFrom=DateFrom.replace(/(^\s*)|(\s*$)/g, "")
	DateTo=DateTo.replace(/(^\s*)|(\s*$)/g, "")
	if ((DateFrom=="")||(DateTo=="")) {return true}
	var FlagCompare=tkMakeServerCall('web.DHCDocOrderCommon','CompareDate',DateFrom,DateTo);
	if  ((FlagCompare==1)||(FlagCompare==2)){return true}
	else{return false}
}

function BodykeydownHandler(e){
	if (window.event){
		var keyCode=window.event.keyCode;
		var type=window.event.type;
		var SrcObj=window.event.srcElement;
	}else{
		var keyCode=e.which;
		var type=e.type;
		var SrcObj=e.target;
	}
	//浏览器中Backspace不可用  
   var keyEvent;   
   if(e.keyCode==8){   
       var d=e.srcElement||e.target;
        if(d.tagName.toUpperCase()=='INPUT'||d.tagName.toUpperCase()=='TEXTAREA'){   
            keyEvent=d.readOnly||d.disabled;   
        }else{   
            keyEvent=true;   
        }   
    }else{   
        keyEvent=false;   
    }   
    if(keyEvent){   
        e.preventDefault();   
    }   
}



