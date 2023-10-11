/**
 * dictionary 基础字典维护
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
	m_gridDicType : '',
	m_gridDicItem : ''
}

$(function(){
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
})

function Init(){
	globalObj.m_gridDicType = InitgridDicType();
	globalObj.m_gridDicItem = InitgridDicItem();
}

function InitEvent(){
	$('#t-add').click(function(){editDicType('add');});
	$('#t-edit').click(function(){editDicType('edit');});
	$('#t-delete').click(function(){deleteDicType();});
	$('#i-add').click(function(){editDicItem('add');});
	$('#i-edit').click(function(){editDicItem('edit');});
	$('#i-delete').click(function(){deleteDicItem();});
}
 /**
 * NUMS: D001
 * CTOR: LIYI
 * DESC: 字典类型维护
 * DATE: 2019-09-29
 * NOTE: 包括四个方法：InitgridDicType,editDicType,deleteDicType,saveDicType
 * TABLE: CT_IPMR_BT.Dictionary
 */

 // 初始化字典类型表格
function InitgridDicType(){
	var columns = [[
		{field:'Code',title:'代码',width:120,align:'left'},
		{field:'Desc',title:'名称',width:200,align:'left'},
		{field:'IsActive',title:'是否生效',width:100,align:'left'},
		{field:'ID',title:'ID',hidden:true,order:'asc'}
    ]];
	var gridDicType =$HUI.datagrid("#gridDicType",{
		fit: true,
		title: "字典类型",
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
		    ClassName:"CT.IPMR.BTS.DictionarySrv",
			QueryName:"QryDictionary",
			aDicType:"SYS",
			aIsActive:"",
			aHospID:""
	    },
	    columns :columns,
		/*
		toolbar:[{
				text:'新增',
				id:'t-add',
				iconCls: 'icon-add'
			},{
				text:'修改',
				id:'t-edit',
				iconCls: 'icon-edit'
			}
			// ,{
			// 	text:'删除',
			// 	id:'t-delete',
			// 	iconCls: 'icon-cancel'
			// }
		],*/
		onClickRow:function(rowIndex,rowData){
			if (rowIndex>-1) { 
				InitgridDicItem(rowData.Code)
			}
		}
	});
	return gridDicType;
}

function searchType(value,name) {
	
		$("#gridDicType").datagrid('load',
		{
			ClassName:"CT.IPMR.BTS.DictionarySrv",
			QueryName:"QryDictionary",
			aDicType:"SYS",
			aIsActive:"",
			aHospID:"",
			aAlias:value
		}); 
}
// 字典类型新增、修改事件
function editDicType(op){
	var selected = $("#gridDicType").datagrid('getSelected');
	if (( op == "edit")&&(!selected)) {
		$.messager.popover({msg: '请选择一条记录！',type: 'alert',timeout: 1000});
		return false;
	}
	$('#DicTypeDialog').css('display','block');
	var _title = "修改字典类型",_icon="icon-w-edit"
	if (op == "add") {
		_title = "添加字典类型",_icon="icon-w-add";
		$("#txtTypeId").val('');
		$("#txtTypeCode").val('');
		$("#txtTypeDesc").val('');
		$("#txtTypeResume").val('');
		$("#chkTypeActive").checkbox("setValue",false);
	} else {
		$("#txtTypeId").val(selected.ID);
		$("#txtTypeCode").val(selected.Code);
		$("#txtTypeDesc").val(selected.Desc);
		$("#txtTypeResume").val(selected.Resume);
		$("#chkTypeActive").checkbox("setValue",selected.IsActive=='是'?true:false);
	}

	var DicTypeDialog = $HUI.dialog('#DicTypeDialog', {
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
					saveDicType();
				}
		},{
		text:'关闭',
		iconCls:'icon-w-close',
		handler:function(){
				$('#DicTypeDialog').window("close");
			}	
		}]
	});
}

// 字典类型删除事件
function deleteDicType(){

	var selected = $("#gridDicType").datagrid('getSelected');
	if (!selected) {
		$.messager.popover({msg: '请选择一条记录！',type: 'alert',timeout: 1000});
		return false;
	}
	$.messager.confirm('确认', '确认删除该条数据?', function(r){
    	if (r){
    		var flg = $m({
				ClassName:"CT.IPMR.BT.Dictionary",
				MethodName:"DeleteById",
				aId:selected.ID
			},false);
			
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误", "删除失败!", 'error');
				return;
			}
			$("#gridDicType").datagrid("reload");
    	}
    });
}

// 字典类型保存操作
function saveDicType(){
	var id = $("#txtTypeId").val();
	var code = $("#txtTypeCode").val();
	var desc = $("#txtTypeDesc").val();
	var resume = $("#txtTypeResume").val();
	var IsActive = $("#chkTypeActive").checkbox("getValue")?"1":"0";
	if (code == '') {
		$.messager.popover({msg: '请填写代码！',type: 'alert',timeout: 1000});
		return false;
	}
	if (desc == '') {
		$.messager.popover({msg: '请填写名称！',type: 'alert',timeout: 1000});
		return false;
	}
	var inputStr = id;
	inputStr += '^' + 'SYS';
	inputStr += '^' + code;
	inputStr += '^' + desc;
	inputStr += '^' + '';
	inputStr += '^' + '';
	inputStr += '^' + '';
	inputStr += '^' + '';
	inputStr += '^' + '';
	inputStr += '^' + '';
	inputStr += '^' + IsActive;
	inputStr += '^' + resume;

	var flg = $m({
		ClassName:"CT.IPMR.BT.Dictionary",
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
	$('#DicTypeDialog').window("close");
	$("#gridDicType").datagrid("reload");

}

 /**
 * NUMS: D002
 * CTOR: LIYI
 * DESC: 字典项维护
 * DATE: 2019-09-29
 * NOTE: 包括四个方法：InitgridDicItem,deleteDicItem,editDicItem,saveDicItem
 * TABLE: CT_IPMR_BT.Dictionary
 */
 // 初始化字典项表格
function InitgridDicItem(DicTypeCode){
	if (globalObj.m_gridDicItem) {
		$("#gridDicItem").datagrid("reload", {
			ClassName:"CT.IPMR.BTS.DictionarySrv",
			QueryName:"QryDictionary",
			aDicType: DicTypeCode,
			aIsActive:"",
			aHospID:""
		})
		return;
	}
	var columns = [[
		{field:'Code',title:'代码',width:100,align:'left'},
		{field:'Desc',title:'名称',width:150,align:'left'},
		{field:'OrderNo',title:'排序码',width:50,align:'left'},
		{field:'PYAlias',title:'检索码',width:50,align:'left'},
		{field:'IsActive',title:'是否生效',width:80,align:'left'},
		{field:'HospDesc',title:'医院',width:150,align:'left',hidden:true},
		{field:'Resume',title:'备注',width:100,align:'left'}
	]];
	var gridDicItem =$HUI.datagrid("#gridDicItem",{
		fit: true,
		title: "字典项",
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 10,
		fitColumns:true,
		//pageList : [20,50,100,200],
	    url:$URL,
	    queryParams:{
		    ClassName:"CT.IPMR.BTS.DictionarySrv",
			QueryName:"QryDictionary",
			aDicType: DicTypeCode,
			aIsActive:"",
			aHospID:""
	    },
		columns:columns,
		toolbar:[{
				text:'新增',
				id:'i-add',
				iconCls: 'icon-add'
			},{
				text:'修改',
				id:'i-edit',
				iconCls: 'icon-edit'
			}
			// ,{
			// 	text:'删除',
			// 	id:'i-delete',
			// 	iconCls: 'icon-cancel'
			// }
		],
		onDblClickRow:function(rowIndex,rowData){
			editDicItem('edit');
		}
	});
	return gridDicItem;
}

// 字典项删除事件
function deleteDicItem(){
	var selected = $('#gridDicItem').datagrid('getSelected');
	if (!selected) {
		$.messager.popover({msg: '请选择一条记录！',type: 'alert',timeout: 1000});
		return false;
	}
	$.messager.confirm('确认', '确认删除该条数据?', function(r){
    	if (r){
    		var flg = $m({
				ClassName:"CT.IPMR.BT.Dictionary",
				MethodName:"DeleteById",
				aId:selected.ID
			},false);

			if (parseInt(flg) <= 0) {
				$.messager.alert("错误", "删除失败!", 'error');
				return;
			}
			$("#gridDicItem").datagrid("reload");
    	}
    });
}

// 字典项新增，修改事件
function editDicItem(op){
	if (op=='add') {
		var selectedDic = $('#gridDicType').datagrid('getSelected');
		if (!selectedDic){
			$.messager.popover({msg: '请选择一条字典类型！',type: 'alert',timeout: 1000});
			return false;
		}
	}
	var selected = $('#gridDicItem').datagrid('getSelected');
	if (( op == "edit")&&(!selected)) {
		$.messager.popover({msg: '请选择一条记录！',type: 'alert',timeout: 1000});
		return false;
	}
	$('#DicItemDialog').css('display','block');
	var cboHosp = $HUI.combobox("#cboItemHosp", {
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

	var _title = "修改字典项",_icon="icon-w-edit"
	if (op == "add") {
		_title = "添加字典项",_icon="icon-w-add";
		$("#txtItemId").val('');
		$("#txtItemCode").val('');
		$("#txtItemDesc").val('');
		$("#txtItemResume").val('');
		$("#txtItemOrderNo").val('');
		$("#txtPYAlias").val('');
		$('#cboItemHosp').combobox('setValue', '');
		$("#chkItemActive").checkbox("setValue",false);
	} else {
		$("#txtItemId").val(selected.ID);
		$("#txtItemCode").val(selected.Code);
		$("#txtItemDesc").val(selected.Desc);
		$("#txtItemResume").val(selected.Resume);
		$("#txtItemOrderNo").val(selected.OrderNo);
		$("#txtPYAlias").val(selected.PYAlias);
		$('#cboItemHosp').combobox('setValue', selected.HospID);
		$("#chkItemActive").checkbox("setValue",selected.IsActive=='是'?true:false);
	}

	var DicItemDialog = $HUI.dialog('#DicItemDialog',{
		title: _title,
		iconCls: _icon,
		width:420,
		modal: true,
		minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
		buttons:[{
			text:'保存',
				iconCls:'icon-w-save',
				handler:function(){
					saveDicItem();
				}
		},{
		text:'关闭',
		iconCls:'icon-w-close',
		handler:function(){
				$('#DicItemDialog').window("close");
			}	
		}]
	});
}


// 字典项目存储方法
function saveDicItem(){
	var id = $("#txtItemId").val();
	var code = $("#txtItemCode").val();
	var OrderNo = $("#txtItemOrderNo").val();
	var PYAlias = $("#txtPYAlias").val();
	var desc = $("#txtItemDesc").val();
	var resume = $("#txtItemResume").val();
	var HospID = $("#cboItemHosp").combobox('getValue');
	var IsActive = $("#chkItemActive").checkbox("getValue")?"1":"0";
	if (code == '') {
		$.messager.popover({msg: '请填写代码！',type: 'alert',timeout: 1000});
		return false;
	}
	if (desc == '') {
		$.messager.popover({msg: '请填写名称！',type: 'alert',timeout: 1000});
		return false;
	}
	var inputStr = id;
	inputStr += '^' + $('#gridDicType').datagrid('getSelected').Code;
	inputStr += '^' + code;
	inputStr += '^' + desc;
	inputStr += '^' + OrderNo;
	inputStr += '^' + HospID;
	inputStr += '^' + '';
	inputStr += '^' + '';
	inputStr += '^' + '';
	inputStr += '^' + '';
	inputStr += '^' + IsActive;
	inputStr += '^' + resume;
	inputStr += '^' + PYAlias;

	var flg = $m({
		ClassName:"CT.IPMR.BT.Dictionary",
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
	$('#DicItemDialog').window("close");
	$("#gridDicItem").datagrid("reload");	
}
