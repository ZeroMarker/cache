/**
 * dataitem 编目数据项
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
	m_gridDataItem : ''
}

$(function(){
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
})

function Init(){
	globalObj.m_gridDataItem = InitgridDataItem();
}

function InitEvent(){
	$('#add').click(function(){editDataItem('add');});
	$('#edit').click(function(){editDataItem('edit');});
	$('#delete').click(function(){deleteDataItem();});
}
 /**
 * NUMS: D001
 * CTOR: LIYI
 * DESC: 编目数据项维护
 * DATE: 2019-09-29
 * NOTE: 包括四个方法：InitgridDataItem,editDataItem,deleteDataItem,saveDataItem
 * TABLE: CT.IPMR.FP.DataItem
 */

 // 初始化编目数据项表格
function InitgridDataItem(){
	var columns = [[
		{field:'FPTypeDesc',title:'首页类型',width:200,align:'left'},
		{field:'Code',title:'代码',width:200,align:'left'},
		{field:'Desc',title:'名称',width:200,align:'left'},
		{field:'CatDesc',title:'分类',width:200,align:'left'},
		{field:'Resume',title:'备注',width:200,align:'left'},
		{field:'FPTypeID',title:'FPTypeID',hidden:true},
		{field:'ID',title:'ID',hidden:true,order:'left'}
    ]];
	var gridDataItem =$HUI.datagrid("#gridDataItem",{
		fit: true,
		//title: "编目数据项",
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
		    ClassName:"CT.IPMR.FPS.DataItemSrv",
			QueryName:"QueryDataItem",
			aFPTypeID:'',
			aAlias:''
	    },
	    columns :columns,
		/*
		toolbar:[{
				text:'新增',
				id:'add',
				iconCls: 'icon-add'
			},{
				text:'修改',
				id:'edit',
				iconCls: 'icon-edit'
			},{
				text:'删除',
				id:'delete',
				iconCls: 'icon-cancel'
			}
		],*/
		onClickRow:function(rowIndex,rowData){
			
		}
	});
	return gridDataItem;
}

///查询
$("#c-search").click(function(){
   var InputStr=$("#search").val();
	$("#gridDataItem").datagrid('load',
	{
	  ClassName:"CT.IPMR.FPS.DataItemSrv",
	  QueryName:"QueryDataItem",
	  aFPTypeID:'',
	  aAlias:InputStr
	});
	  
});

// 编目数据项新增、修改事件
function editDataItem(op){
	var selected = $("#gridDataItem").datagrid('getSelected');
	if (( op == "edit")&&(!selected)) {
		$.messager.popover({msg: '请选择一条记录！',type: 'alert',timeout: 1000});
		return false;
	}
	$('#DataItemDialog').css('display','block');
	var cboFPType = $HUI.combobox("#cboFPType", {
		url:$URL,
		valueField:'ID',
		textField:'Desc',
		multiple:true,
		mode: "local",
		rowStyle:'checkbox', //显示成勾选行形式
		filter: function(q, row){
			var ops = $(this).combobox('options');  
			var mCode = false;
			if (row.ContactName) {
				mCode = row.ContactName.toUpperCase().indexOf(q.toUpperCase()) >= 0
			}
			var mValue = row[ops.textField].indexOf(q) >= 0;
			return mCode||mValue;  
		},
		onBeforeLoad: function (param) {
			param.ClassName = 'CT.IPMR.BTS.DictionarySrv';
			param.QueryName = 'QryDictionary';
			param.ResultSetType = 'array';
			param.aDicType = 'FrontPageType';
			param.aIsActive = 1;
			param.aHospID = '';
		}
	})
	var cboCat = $HUI.combobox("#cboCat", {
		url:$URL,
		valueField:'ID',
		textField:'Desc',
		mode: "local",
		filter: function(q, row){
			var ops = $(this).combobox('options');  
			var mCode = false;
			if (row.ContactName) {
				mCode = row.ContactName.toUpperCase().indexOf(q.toUpperCase()) >= 0
			}
			var mValue = row[ops.textField].indexOf(q) >= 0;
			return mCode||mValue;  
		},
		onBeforeLoad: function (param) {
			param.ClassName = 'CT.IPMR.FPS.DataItemCatSrv';
			param.QueryName = 'QryDataItemCat';
			param.ResultSetType = 'array';
			param.aAlias = '';
		}
	})

	var _title = "修改编目数据项",_icon="icon-w-edit"
	if (op == "add") {
		_title = "添加编目数据项",_icon="icon-w-add";
		$("#txtId").val('');
		//$('#cboFPType').combobox('enable');
		$('#cboFPType').combobox('setValue','');
		//$("#txtCode").validatebox("setDisabled",false);
		$("#txtCode").attr("disabled", false);
		$("#txtCode").val('');
		$("#txtDesc").val('');
		$("#cboCat").combobox('setValue','');
		$("#txtResume").val('');
	} else {
		$("#txtId").val(selected.ID);
		$('#cboFPType').combobox('setValues', selected.FPTypeID.split(','));
		//$('#cboFPType').combobox('disable');
		//$("#txtCode").validatebox("setDisabled",true);
		$("#txtCode").attr("disabled", true);
		$("#txtCode").val(selected.Code);
		$("#txtDesc").val(selected.Desc);
		$('#cboCat').combobox('setValue', selected.CatID);
		$("#txtResume").val(selected.Resume);
	}

	var DataItemDialog = $HUI.dialog('#DataItemDialog', {
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
					saveDataItem();
				}
		},{
		text:'关闭',
		iconCls:'icon-w-close',
		handler:function(){
				$('#DataItemDialog').window("close");
			}	
		}]
	});
}

// 编目数据项删除事件
function deleteDataItem(){

	var selected = $("#gridDataItem").datagrid('getSelected');
	if (!selected) {
		$.messager.popover({msg: '请选择一条记录！',type: 'alert',timeout: 1000});
		return false;
	}
	$.messager.confirm('确认', '确认删除该条数据?', function(r){
    	if (r){
    		var flg = $m({
				ClassName:"CT.IPMR.FP.DataItem",
				MethodName:"DeleteById",
				aId:selected.ID
			},false);
			
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误", "删除失败!", 'error');
				return;
			}
			$("#gridDataItem").datagrid("reload");
    	}
    });
}

// 编目数据项保存操作
function saveDataItem(){
	var id = $("#txtId").val();
	var FPTypeID = $("#cboFPType").combobox('getValues');
	var code = $("#txtCode").val();
	var desc = $("#txtDesc").val();
	var CatID = $("#cboCat").combobox('getValue');
	var resume = $("#txtResume").val();
	if (FPTypeID == '') {
		$.messager.popover({msg: '请填写首页类型！',type: 'alert',timeout: 1000});
		return false;
	}
	if (code == '') {
		$.messager.popover({msg: '请填写代码！',type: 'alert',timeout: 1000});
		return false;
	}
	if (desc == '') {
		$.messager.popover({msg: '请填写名称！',type: 'alert',timeout: 1000});
		return false;
	}
	var inputStr = id;
	inputStr += '^' + FPTypeID;
	inputStr += '^' + code;
	inputStr += '^' + desc;
	inputStr += '^' + CatID;
	inputStr += '^' + resume;

	var flg = $m({
		ClassName:"CT.IPMR.FP.DataItem",
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
	$('#DataItemDialog').window("close");
	$("#gridDataItem").datagrid("reload");

}