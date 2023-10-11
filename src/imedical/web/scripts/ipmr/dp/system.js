/**
 * system 系统定义
 * 
 * Copyright (c) 2018-2019 LIYI. All rights reserved.
 * 
 * CREATED BY LIYI 2019-09-29
 * 
 * 注解说明
 * TABLE: 
 */

//页面全局变量对象
var globalObj = {
	m_gridsystem : '',
	aSysID:''
}

$(function(){
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
})

function Init(){
	globalObj.m_gridsystem = Initgridsystem();
}

function InitEvent(){
	$('#c-add').click(function(){editsystem('add');});
	$('#c-edit').click(function(){editsystem('edit');});
	$('#c-delete').click(function(){deletesystem();});
	$('#soap-add').click(function() { editsoap('add'); } );
	$('#soap-edit').click(function() { editsoap('edit'); } );
	$('#soap-delete').click(function() { deletesoap(); } );
}
 /**
 * NUMS: D001
 * CTOR: LIYI
 * DESC: 系统定义
 * DATE: 2019-09-29
 * NOTE: 包括四个方法：Initgridsystem,editsystem,deletesystem,savesystem
 * TABLE: CT_IPMR_BT.system
 */
 // 初始化表格
function Initgridsystem(){
	var columns = [[
		{field:'SysCode',title:'系统代码',width:100,align:'left'},
		{field:'SysDesc',title:'系统名称',width:100,align:'left'},
		{field:'ExCode',title:'外部码',width:100,align:'left'},
		//{field:'DataSoap',title:'webservice接口类',width:240,align:'left'},
		{field:'EMRUrl',title:'病历浏览URL',width:180,align:'left'},
		{field:'Resume',title:'备注',width:180,align:'left'},
		{field:'ID',title:'接口维护',width:180,align:'left',
			formatter:function(value,row,index) {
            	var rowid = row.ID;
               	return '<a href="#" class="grid-td-text-gray" onclick = editSoap(' + rowid + ')>' + '接口维护' + '</a>';            
            }
		}
    ]];
	var gridsystem =$HUI.datagrid("#gridsystem",{
		fit: true,
		//title: "系统代码定义",
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 10,
		fitColumns:true,
	    url:$URL,
	    queryParams:{
		    ClassName:"CT.IPMR.DPS.SystemSrv",
			QueryName:"QuerySystem"
	    },
	    columns :columns,
		/*
		toolbar:[{
				text:'新增',
				id:'c-add',
				iconCls: 'icon-add'
			},{
				text:'修改',
				id:'c-edit',
				iconCls: 'icon-edit'
			},{
				text:'删除',
				id:'c-delete',
				iconCls: 'icon-cancel'
			}
		],*/
		onClickRow:function(rowIndex,rowData){
			
		}
	});
	return gridsystem;
}

// 新增、修改事件
function editsystem(op){
	var selected = $("#gridsystem").datagrid('getSelected');
	if (( op == "edit")&&(!selected)) {
		$.messager.popover({msg: '请选择一条记录！',type: 'alert',timeout: 1000});
		return false;
	}
	
	var _title = "修改系统定义",_icon="icon-w-edit"
	if (op == "add") {
		_title = "添加系统定义",_icon="icon-w-add";
		$("#txtId").val('');
		$("#txtSysCode").val('');
		$("#txtSysDesc").val('');
		$("#txtExCode").val('');
		$("#txtDataSoap").val('');
		$("#txtResume").val('');
		$("#txtEMRUrl").val();
	} else {
		$("#txtId").val(selected.ID);
		$("#txtSysCode").val(selected.SysCode);
		$("#txtSysDesc").val(selected.SysDesc);
		$("#txtExCode").val(selected.ExCode);
		$("#txtDataSoap").val(selected.DataSoap);
		$("#txtResume").val(selected.Resume);
		$("#txtEMRUrl").val(selected.EMRUrl);
	}

	var systemDialog = $HUI.dialog('#systemDialog', {
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
					savesystem();
				}
		},{
		text:'关闭',
		iconCls:'icon-w-close',
		handler:function(){
				$('#systemDialog').window("close");
			}	
		}]
	});
}

// 删除事件
function deletesystem(){

	var selected = $("#gridsystem").datagrid('getSelected');
	if (!selected) {
		$.messager.popover({msg: '请选择一条记录！',type: 'alert',timeout: 1000});
		return false;
	}
	$.messager.confirm('确认', '确认删除该条数据?', function(r){
    	if (r){
    		var flg = $m({
				ClassName:"CT.IPMR.DP.System",
				MethodName:"DeleteById",
				aId:selected.ID
			},false);
			if (parseInt(flg) < 0) {
				$.messager.alert("错误", "删除失败!", 'error');
				return;
			}
			$("#gridsystem").datagrid("reload");
    	}
    });
}

// 保存操作
function savesystem(){
	var id = $("#txtId").val();
	var syscode = $("#txtSysCode").val();
	var sysdesc = $("#txtSysDesc").val();
	var excode = $("#txtExCode").val();
	//var datasoap = $("#txtDataSoap").val();
	var EMRUrl = $("#txtEMRUrl").val();
	var resume = $("#txtResume").val();
	if (syscode == '') {
		$.messager.popover({msg: '请填写系统代码！',type: 'alert',timeout: 1000});
		return false;
	}
	if (sysdesc == '') {
		$.messager.popover({msg: '请填写系统名称！',type: 'alert',timeout: 1000});
		return false;
	}
	if (excode == '') {
		$.messager.popover({msg: '请填写外部代码！',type: 'alert',timeout: 1000});
		return false;
	}
	var inputStr = id;
	inputStr += '^' + syscode;
	inputStr += '^' + sysdesc;
	inputStr += '^' + excode;
	inputStr += '^' + '';	//datasoap;
	inputStr += '^' + resume;
	inputStr += '^' + EMRUrl;

	var flg = $m({
		ClassName:"CT.IPMR.DP.System",
		MethodName:"Update",
		aInputStr:inputStr,
		aSeparate:"^"
	},false);
	
	if (parseInt(flg) <= 0) {
		if (parseInt(flg)==-100){
			$.messager.alert("提示", "系统代码重复!", 'info');
		}else if (parseInt(flg)==-101) {
			$.messager.alert("提示", "外部代码重复!", 'info');
		}else if (parseInt(flg)==-102) {
			$.messager.alert("提示", "请填写有效的服务类!", 'info');
		}else{
			$.messager.alert("错误", "保存失败!", 'error');
		}
		return;
	}
	$('#systemDialog').window("close");
	$("#gridsystem").datagrid("reload");

}

/**
 * NUMS: D002
 * CTOR: LIYI
 * DESC: 接口维护
 * DATE: 2021-12-23
 * NOTE: 包括方法：
 * TABLE: 
 */
// 接口列表弹框
function editSoap(aSysID) {
	globalObj.aSysID = aSysID;
	var icdColumns = [[
		{field: 'ID', title: 'ID',hidden:true},
		{field: 'ModelTypeDesc', title: '数据模型', width: 70, align: 'left'},
		{field: 'TargetAddress', title: '目标地址', width: 130, align: 'left'},
		{field: 'TargetMethod', title: '目标方法', width: 100, align: 'left'},
		{field: 'Arguments', title: '参数', width: 100, align: 'left'}
	]];
	var gridSoap= $HUI.datagrid("#gridSoap", {
		fit: true,
		iconCls : 'icon-write-order',
		rownumbers : true, 
		singleSelect : true,
		pagination : true, 
		autoRowHeight : false,
		loadMsg : '数据加载中...',
		pageSize : 10,
		fitColumns : true,
		url : $URL,
	    queryParams : {
		    ClassName : "CT.IPMR.DPS.SystemSrv",
			QueryName : "QuerySoapConfig",
			aSysID :aSysID
	    },
	    columns : icdColumns
	});

    var SoapDialog = $('#SoapDialog').dialog({
	    title: '接口维护',
		iconCls: 'icon-w-new',
	    width: 1200,
        height: 560,
	    minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
	    closed: false,
	    cache: false,
	    modal: true
	});
	return;
}

function editsoap( option ) {
	var selected = $("#gridSoap").datagrid('getSelected');
	if ( ( option == "edit") && (!selected) ) {
		$.messager.popover({msg: '请选择一条记录！',type: 'alert',timeout: 1000});
		return false;
	}
	Common_ComboToDic("cboModelType","ModelType",1,"");
	$('#editSoapDialog').css('display','block');
	
	var _title = "修改接口",_icon="icon-w-edit"
	if (option == "add") {
		_title = "添加接口",_icon="icon-w-add";
		$("#txtSoapID").val('');
		$("#txtTargetAddress").val('');
		$("#txtTargetMethod").val('');
		$("#cboModelType").combobox('setValue','');
		$("#txtArguments").val("");
	} else {
		$("#txtSoapID").val(selected.ID);
		$("#txtTargetAddress").val(selected.TargetAddress);
		$("#txtTargetMethod").val(selected.TargetMethod);
		$("#cboModelType").combobox('setValue',selected.ModelTypeID);
		$("#txtArguments").val(selected.Arguments);
	}
	
	var editSoapDialog = $HUI.dialog('#editSoapDialog', {
		title :  _title,
		iconCls : _icon,
		modal : true,
		minimizable : false,
		maximizable : false,
		maximizable : false,
		collapsible : false,
		buttons : [{
			text : '保存',
			iconCls :'icon-w-save',
			handler : function() {
				saveSoap() ;
			}
		},{
			text : '关闭',
			iconCls : 'icon-w-close',
			handler : function() {
				$('#editSoapDialog').window("close");
			}	
		}]
	});
}

function deletesoap() {
	var selected = $("#gridSoap").datagrid('getSelected');
	if (!selected) {
		$.messager.popover({msg: '请选择一条记录！',type: 'alert',timeout: 1000});
		return false;
	}
	$.messager.confirm('确认', '确认删除该条数据?', function(r){
    	if (r){
    		var flg = $m({
				ClassName:"CT.IPMR.DP.SoapConfig",
				MethodName:"DeleteById",
				aId:selected.ID
			},false);
			if (parseInt(flg) < 0) {
				$.messager.alert("错误", "删除失败!", 'error');
				return;
			}
			$("#gridSoap").datagrid("reload");
    	}
    });
}

function saveSoap() {
	var ID = $("#txtSoapID").val();
	var TargetAddress = $("#txtTargetAddress").val();
	var TargetMethod = $("#txtTargetMethod").val();
	var ModelType = $("#cboModelType").combobox('getValue');
	var Arguments = $("#txtArguments").val();
	if (ModelType == '') {
		$.messager.popover({msg: '请填写数据模型！',type: 'alert',timeout: 1000});
		return false;
	}
	if (ModelType !== '') {
		if (TargetAddress == '') {
			$.messager.popover({msg: '请填写目标地址！',type: 'alert',timeout: 1000});
			return false;
		}
		if (TargetMethod == '') {
			$.messager.popover({msg: '请填写目标方法！',type: 'alert',timeout: 1000});
			return false;
		}
	}
	
	var inputStr = ID;
	inputStr += '^' + globalObj.aSysID;
	inputStr += '^' + TargetAddress;
	inputStr += '^' + TargetMethod;
	inputStr += '^' + ModelType;
	inputStr += '^' + Arguments;
	var flg = $m({
		ClassName:"CT.IPMR.DP.SoapConfig",
		MethodName:"Update",
		aInputStr:inputStr,
		aSeparate:"^"
	},false);
	
	if (parseInt(flg) <= 0) {
		if (parseInt(flg) == -100){
			$.messager.alert("提示", "数据模型重复!", 'info');
		}else if (parseInt(flg) == -102){
			$.messager.alert("提示", "目标地址无效!", 'info');
		}else{
			$.messager.alert("错误", "保存失败!", 'error');
		}
		return;
	}
	$('#editSoapDialog').window("close");
	$("#gridSoap").datagrid("reload");
	return ;
}