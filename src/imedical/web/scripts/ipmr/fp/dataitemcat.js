/**
 * DataItemCatcat 编目数据项分类
 * 
 * Copyright (c) 2018-2022 LIYI. All rights reserved.
 * 
 * CREATED BY LIYI 2022-02-23
 * 
 * 注解说明
 * TABLE: 
 */

//页面全局变量对象
var globalObj = {
	m_gridCat : ''
}

$(function(){
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
})

function Init(){
	Common_ComboToDic('cboDataType','FPDataType',1,'')
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
	});
	globalObj.m_gridCat = InitgridCat();
}

function InitEvent(){
	$('#add').click(function(){editCat('add');});
	$('#edit').click(function(){editCat('edit');});
	$('#delete').click(function(){deleteCat();});
}
 /**
 * NUMS: D001
 * CTOR: LIYI
 * DESC: 编目数据项分类维护
 * DATE: 2022-02-23
 * NOTE: 包括方法：
 * TABLE: 
 */

 // 初始化表格
function InitgridCat(){
	var columns = [[
		{field:'Code',title:'代码',width:80,align:'left'},
		{field:'Desc',title:'描述',width:200,align:'left'},
		{field:'DataTypeDesc',title:'数据类型',width:80,align:'left'},
		{field:'LinkCode',title:'联动数据项分类',width:120,align:'left'},
		{field:'DicLinkColumn',title:'联动数据项字段',width:120,align:'left'},
		{field:'IsShowCode',title:'显示代码',width:80,align:'left',
			formatter:function(value,row,index) {
            	if (value==1) {
            		return '是';
            	}else{
            		return '否';
            	}         
            }
		},
		{field:'DicType',title:'字典来源',width:100,align:'left'},
		{field:'DicCode',title:'字典名',width:120,align:'left'},
		{field:'DicIDColumn',title:'字典ID字段',width:100,align:'left'},
		{field:'DicCodeColumn',title:'字典代码字段',width:120,align:'left'},
		{field:'DicTextColumn',title:'字典描述字段',width:120,align:'left'},
		{field:'DicDateFrom',title:'字典有效开始日期字段',width:150,align:'left'},
		{field:'DicDateTo',title:'字典有效结束日期字段',width:150,align:'left'},
		{field:'IsNecessaryItem',title:'是否必填项',width:80,align:'left',
			formatter:function(value,row,index) {
            	if (value==1) {
            		return '是';
            	}else{
            		return '否';
            	}         
            }
		},
		{field:'IsItemChar',title:'是否可填-',width:80,align:'left',
			formatter:function(value,row,index) {
            	if (value==1) {
            		return '是';
            	}else{
            		return '否';
            	}         
            }
		},
		{field:'ID',title:'ID',hidden:true,order:'left'}
    ]];
	var gridCat =$HUI.datagrid("#gridCat",{
		fit: true,
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 10,
		fitColumns:false,
	   url:$URL,
	   queryParams:{
		   ClassName:"CT.IPMR.FPS.DataItemCatSrv",
			QueryName:"QrytemCat",
			aAlias:''
	   },
	   columns :columns,
		onClickRow:function(rowIndex,rowData){}
	});
	return gridCat;
}

///查询
$("#c-search").click(function(){
   var InputStr=$("#search").val();
	$("#gridCat").datagrid('load',
	{
	  ClassName:"CT.IPMR.FPS.DataItemCatSrv",
	  QueryName:"QrytemCat",
	  aAlias:InputStr
	});
	  
});

// 新增、修改事件
function editCat(op){
	var selected = $("#gridCat").datagrid('getSelected');
	if (( op == "edit")&&(!selected)) {
		$.messager.popover({msg: '请选择一条记录！',type: 'alert',timeout: 1000});
		return false;
	}
	$('#CatDialog').css('display','block');
	var _title = "修改编目数据项分类",_icon="icon-w-edit"
	if (op == "add") {
		_title = "添加编目数据项分类",_icon="icon-w-add";
		$('#cboFPType').combobox('setValue','');
		$("#txtId").val('');
		$("#txtCode").val('');
		$("#txtDesc").val('');
		$('#cboDataType').combobox('setValue','');
		$("#txtLinkCode").val('');
		$("#chkIsShowCode").checkbox('setValue',false);
		$("#txtDicType").val('');
		$("#txtDicCode").val('');
		$("#txtDicCodeColumn").val('');
		$("#txtDicTextColumn").val('');
		$("#txtDicDateFrom").val('');
		$("#txtDicDateTo").val('');
		$("#txtDicLinkColumn").val('');
		$("#txtDicIDColumn").val('');
		$("#chkIsNecessaryItem").checkbox('setValue',false);
		$("#chkIsItemChar").checkbox('setValue',false);
		
	} else {
		$('#cboFPType').combobox('setValues', selected.FPTypeID.split(','));
		$("#txtId").val(selected.ID);
		$("#txtCode").val(selected.Code);
		$("#txtDesc").val(selected.Desc);
		$('#cboDataType').combobox('setValue',selected.DataTypeID,selected.DataTypeDesc);
		$("#txtLinkCode").val(selected.LinkCode);
		$("#chkIsShowCode").checkbox('setValue',selected.IsShowCode=='1'?true:false);
		$("#txtDicType").val(selected.DicType);
		$("#txtDicCode").val(selected.DicCode);
		$("#txtDicCodeColumn").val(selected.DicCodeColumn);
		$("#txtDicTextColumn").val(selected.DicTextColumn);
		$("#txtDicDateFrom").val(selected.DicDateFrom);
		$("#txtDicDateTo").val(selected.DicDateTo);
		$("#txtDicLinkColumn").val(selected.DicLinkColumn);
		$("#txtDicIDColumn").val(selected.DicIDColumn);
		$("#chkIsNecessaryItem").checkbox('setValue',selected.IsNecessaryItem=='1'?true:false);
		$("#chkIsItemChar").checkbox('setValue',selected.IsItemChar=='1'?true:false);
	}

	var CatDialog = $HUI.dialog('#CatDialog', {
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
					saveCat();
				}
		},{
		text:'关闭',
		iconCls:'icon-w-close',
		handler:function(){
				$('#CatDialog').window("close");
			}	
		}]
	});
}

// 删除事件
function deleteCat(){

	var selected = $("#gridCat").datagrid('getSelected');
	if (!selected) {
		$.messager.popover({msg: '请选择一条记录！',type: 'alert',timeout: 1000});
		return false;
	}
	$.messager.confirm('确认', '确认删除该条数据?', function(r){
    	if (r){
    		var flg = $m({
				ClassName:"CT.IPMR.FP.DataItemCat",
				MethodName:"DeleteById",
				aId:selected.ID
			},false);
			
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误", "删除失败!", 'error');
				return;
			}
			$("#gridCat").datagrid("reload");
    	}
    });
}

// 保存操作
function saveCat(){
	var FPTypeID = $("#cboFPType").combobox('getValues');
	var id = $("#txtId").val();
	var code = $("#txtCode").val();
	var desc = $("#txtDesc").val();
	var DataTypeID = $("#cboDataType").combobox('getValues');
	var Range = '';
	var LinkCode = $("#txtLinkCode").val();
	var DateLimit = '';
	var IsShowCode = $("#chkIsShowCode").checkbox("getValue")?"1":"0";
	var DicType = $("#txtDicType").val();
	var DicCode = $("#txtDicCode").val();
	var DicCodeColumn = $("#txtDicCodeColumn").val();
	var DicTextColumn = $("#txtDicTextColumn").val();
	var DicDateFrom = $("#txtDicDateFrom").val();
	var DicDateTo = $("#txtDicDateTo").val();
	var DicLinkColumn = $("#txtDicLinkColumn").val();
	var DicIDColumn = $("#txtDicIDColumn").val();
	var IsNecessaryItem = $("#chkIsNecessaryItem").checkbox("getValue")?"1":"0";
	var IsItemChar = $("#chkIsItemChar").checkbox("getValue")?"1":"0";
	if (FPTypeID == '') {
		$.messager.popover({msg: '请填写首页类型！',type: 'alert',timeout: 1000});
		return false;
	}
	if (code == '') {
		$.messager.popover({msg: '请填写代码！',type: 'alert',timeout: 1000});
		return false;
	}
	if (desc == '') {
		$.messager.popover({msg: '请填写描述！',type: 'alert',timeout: 1000});
		return false;
	}
	if (DataTypeID == '') {
		$.messager.popover({msg: '请填写数据类型！',type: 'alert',timeout: 1000});
		return false;
	}
	if ($("#cboDataType").combobox('getText')=='字典') {
		if (DicType == '') {
			$.messager.popover({msg: '数据类型为字典，请填写字典来源！',type: 'alert',timeout: 2000});
			return false;
		}
		if (DicCode == '') {
			$.messager.popover({msg: '数据类型为字典，请填写字典名！',type: 'alert',timeout: 2000});
			return false;
		}
		if (DicIDColumn == '') {
			$.messager.popover({msg: '数据类型为字典，请填写字典ID字段！',type: 'alert',timeout: 2000});
			return false;
		}
		if (DicCodeColumn == '') {
			$.messager.popover({msg: '数据类型为字典，请填写字典代码字段！',type: 'alert',timeout: 2000});
			return false;
		}
		if (DicTextColumn == '') {
			$.messager.popover({msg: '数据类型为字典，请填写字典描述字段！',type: 'alert',timeout: 2000});
			return false;
		}
	}
	var inputStr = id;
	inputStr += '^' + code;
	inputStr += '^' + desc;
	inputStr += '^' + DataTypeID;
	inputStr += '^' + Range;
	inputStr += '^' + LinkCode;
	inputStr += '^' + DateLimit;
	inputStr += '^' + IsShowCode;
	inputStr += '^' + DicType;
	inputStr += '^' + DicCode;
	inputStr += '^' + DicCodeColumn;
	inputStr += '^' + DicTextColumn;
	inputStr += '^' + DicDateFrom;
	inputStr += '^' + DicDateTo;
	inputStr += '^' + DicLinkColumn;
	inputStr += '^' + DicIDColumn;
	inputStr += '^' + IsNecessaryItem;
	inputStr += '^' + IsItemChar;
	inputStr += '^' + FPTypeID
	var flg = $m({
		ClassName:"CT.IPMR.FP.DataItemCat",
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
	$('#CatDialog').window("close");
	$("#gridCat").datagrid("reload");

}
