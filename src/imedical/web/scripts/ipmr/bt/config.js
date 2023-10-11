/**
 * config 参数配置
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
	m_gridConfig : ''
}

$(function(){
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
})

function Init(){
	globalObj.m_gridConfig = InitgridConfig();
}

function InitEvent(){
	$('#c-add').click(function(){editConfig('add');});
	$('#c-edit').click(function(){editConfig('edit');});
	$('#c-delete').click(function(){deleteConfig();});
}
 /**
 * NUMS: D001
 * CTOR: LIYI
 * DESC: 参数配置
 * DATE: 2019-09-29
 * NOTE: 包括四个方法：InitgridConfig,editConfig,deleteConfig,saveConfig
 * TABLE: CT_IPMR_BT.Config
 */

 // 初始化字典类型表格
function InitgridConfig(){
	var columns = [[
		{field:'Code',title:'代码',width:200,align:'left'},
		{field:'Desc',title:'名称',width:180,align:'left'},
		{field:'Val',title:'配置值',width:100,align:'left'},
		{field:'ValDesc',title:'值说明',width:180,align:'left'},
		{field:'HospDesc',title:'医院',width:180,align:'left',hidden:true},
		{field:'Resume',title:'备注',width:100,align:'left'},
		{field:'ID',title:'ID',hidden:true,order:'asc'}
    ]];
	var gridConfig =$HUI.datagrid("#gridConfig",{
		fit: true,
		//title: "参数配置",
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
		    ClassName:"CT.IPMR.BTS.ConfigSrv",
			QueryName:"QueryConfig",
			aAlias:''
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
	return gridConfig;
}
///查询
$("#c-search").click(function(){
   var InputStr=$("#search").val();
	$("#gridConfig").datagrid('load',
	{
	  ClassName:"CT.IPMR.BTS.ConfigSrv",
	  QueryName:"QueryConfig",
	  aAlias:InputStr
	}); 
});
// 字典类型新增、修改事件
function editConfig(op){
	var selected = $("#gridConfig").datagrid('getSelected');
	if (( op == "edit")&&(!selected)) {
		$.messager.popover({msg: '请选择一条记录！',type: 'alert',timeout: 1000});
		return false;
	}
	$('#ConfigDialog').css('display','block');
	var cboHosp = $HUI.combobox("#cboHosp", {
		url:$URL+"?ClassName=MA.IPMR.BTS.HospitalSrv&QueryName=QryHosp&ResultSetType=array",
		valueField:'HospID',
		textField:'HospDesc',
		mode: "local",
		filter: function(q, row){
			var ops = $(this).combobox('options');  
			var mCode = false;
			if (row.ContactName) {
				mCode = row.ContactName.toUpperCase().indexOf(q.toUpperCase()) >= 0
			}
			var mValue = row[ops.textField].indexOf(q) >= 0;
			return mCode||mValue;  
		}
	})
	var _title = "修改参数配置",_icon="icon-w-edit"
	if (op == "add") {
		_title = "添加参数配置",_icon="icon-w-add";
		$("#txtId").val('');
		$("#txtCode").val('');
		$("#txtDesc").val('');
		$("#txtVal").val('');
		$("#txtValDesc").val('');
		$('#cboHosp').combobox('setValue', '');
		$("#txtResume").val('');
	} else {
		$("#txtId").val(selected.ID);
		$("#txtCode").val(selected.Code);
		$("#txtDesc").val(selected.Desc);
		$("#txtVal").val(selected.Val);
		$("#txtValDesc").val(selected.ValDesc);
		$('#cboHosp').combobox('setValue', selected.HospID);
		$("#txtResume").val(selected.Resume);
	}

	var ConfigDialog = $HUI.dialog('#ConfigDialog', {
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
					saveConfig();
				}
		},{
		text:'关闭',
		iconCls:'icon-w-close',
		handler:function(){
				$('#ConfigDialog').window("close");
			}	
		}]
	});
}

// 字典类型删除事件
function deleteConfig(){

	var selected = $("#gridConfig").datagrid('getSelected');
	if (!selected) {
		$.messager.popover({msg: '请选择一条记录！',type: 'alert',timeout: 1000});
		return false;
	}
	$.messager.confirm('确认', '确认删除该条数据?', function(r){
    	if (r){
    		var flg = $m({
				ClassName:"CT.IPMR.BT.Config",
				MethodName:"DeleteById",
				aId:selected.ID
			},false);
			
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误", "删除失败!", 'error');
				return;
			}
			$("#gridConfig").datagrid("reload");
    	}
    });
}

// 字典类型保存操作
function saveConfig(){
	var id = $("#txtId").val();
	var code = $("#txtCode").val();
	var desc = $("#txtDesc").val();
	var Val = $("#txtVal").val();
	var ValDesc = $("#txtValDesc").val();
	var HospID = $("#cboHosp").combobox('getValue');
	var resume = $("#txtResume").val();
	if (code == '') {
		$.messager.popover({msg: '请填写代码！',type: 'alert',timeout: 1000});
		return false;
	}
	if (desc == '') {
		$.messager.popover({msg: '请填写名称！',type: 'alert',timeout: 1000});
		return false;
	}
	var inputStr = id;
	inputStr += '^' + code;
	inputStr += '^' + desc;
	inputStr += '^' + Val;
	inputStr += '^' + ValDesc;
	inputStr += '^' + HospID;
	inputStr += '^' + resume;

	var flg = $m({
		ClassName:"CT.IPMR.BT.Config",
		MethodName:"Update",
		aInputStr:inputStr,
		aSeparate:"^"
	},false);
	
	if (parseInt(flg) <= 0) {
		if (parseInt(flg)==-100){
			$.messager.alert("提示", "代码重复!", 'info');
		}else{
			$.messager.alert("错误", "保存失败!", 'error');
		}
		return;
	}
	$('#ConfigDialog').window("close");
	$("#gridConfig").datagrid("reload");

}
