/**
 * menus 菜单维护
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
	m_gridMenus : ''
}

$(function(){
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
})

function Init(){
	globalObj.m_gridMenus = InitgridMenus();
}

function InitEvent(){
	$('#c-add').click(function(){editMenus('add');});
	$('#c-edit').click(function(){editMenus('edit');});
	$('#c-delete').click(function(){deleteMenus();});
}
 /**
 * NUMS: D001
 * CTOR: LIYI
 * DESC: 菜单维护
 * DATE: 2019-09-29
 * NOTE: 包括四个方法：InitgridMenus,editMenus,deleteMenus,saveMenus
 * TABLE: 
 */

 // 初始化菜单表格
function InitgridMenus(){
	var columns = [[
		{field:'Desc',title:'名称',width:180,align:'left'},
		{field:'Code',title:'代码',width:200,align:'left'},
		{field:'LinkUrl',title:'目标地址',width:180,align:'left'},
		{field:'Expression',title:'表达式',width:180,align:'left'},
		{field:'IconClass',title:'图标样式',width:100,align:'left'},
		{field:'ParentMenu',title:'父菜单',width:100,align:'left'},
		{field:'ShowOrder',title:'显示顺序',width:100,align:'left'},
		{field:'ID',title:'操作列表',width:60,align:'left',
			formatter:function(value,row,index){
				if (value=="") return "";
				var MenuID = row["ID"];
				var btn='<a href="#" onclick="InitOperDialog(\'' + MenuID + '\')">维护</a>';
				return btn;
			}
		}
    ]];
	var gridmenus =$HUI.datagrid("#gridmenus",{
		fit: true,
		title: "菜单维护",
		headerCls:'panel-header-gray',
		iconCls:'icon-write-order',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 10,
		fitColumns:true,
	    url:$URL,
	    queryParams:{
		    ClassName:"CT.IPMR.BTS.MenusSrv",
			QueryName:"QueryMenus"
	    },
	    columns :columns,
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
		],
		onClickRow:function(rowIndex,rowData){
			
		}
	});
	return gridmenus;
}

// 菜单新增、修改事件
function editMenus(op){
	var selected = $("#gridmenus").datagrid('getSelected');
	if (( op == "edit")&&(!selected)) {
		$.messager.popover({msg: '请选择一条记录！',type: 'alert',timeout: 1000});
		return false;
	}
	$('#MenusDialog').css('display','block');
	var cboParentMenu = $HUI.combobox("#cboParentMenu", {
		url:$URL+"?ClassName=CT.IPMR.BTS.MenusSrv&QueryName=QueryMenus&ResultSetType=array",
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
		}
	})
	var _title = "修改菜单",_icon="icon-w-edit"
	if (op == "add") {
		_title = "添加菜单",_icon="icon-w-add";
		$("#txtId").val('');
		$("#txtCode").val('');
		$("#txtDesc").val('');
		$("#txtLinkUrl").val('');
		$("#txtExpression").val('');
		$("#txtIconClass").val('');
		$("#txtShowOrder").val('');
		$('#cboParentMenu').combobox('setValue', '');
	} else {
		$("#txtId").val(selected.ID);
		$("#txtCode").val(selected.Code);
		$("#txtDesc").val(selected.Desc);
		$("#txtLinkUrl").val(selected.LinkUrl);
		$("#txtExpression").val(selected.Expression);
		$("#txtIconClass").val(selected.IconClass);
		$("#txtShowOrder").val(selected.ShowOrder);
		$('#cboParentMenu').combobox('setValue', selected.ParentMenuID);
	}

	var MenusDialog = $HUI.dialog('#MenusDialog', {
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
					saveMenus();
				}
		},{
		text:'关闭',
		iconCls:'icon-w-close',
		handler:function(){
				$('#MenusDialog').window("close");
			}	
		}]
	});
}

// 菜单删除事件
function deleteMenus(){

	var selected = $("#gridmenus").datagrid('getSelected');
	if (!selected) {
		$.messager.popover({msg: '请选择一条记录！',type: 'alert',timeout: 1000});
		return false;
	}
	$.messager.confirm('确认', '确认删除该条数据?', function(r){
    	if (r){
    		var flg = $m({
				ClassName:"CT.IPMR.BT.Menus",
				MethodName:"DeleteById",
				aId:selected.ID
			},false);
			
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误", "删除失败!", 'error');
				return;
			}
			$("#gridmenus").datagrid("reload");
    	}
    });
}

// 菜单保存操作
function saveMenus(){
	var id = $("#txtId").val();
	var code = $("#txtCode").val();
	var desc = $("#txtDesc").val();
	var LinkUrl = $("#txtLinkUrl").val();
	var Expression = $("#txtExpression").val();
	var IconClass = $("#txtIconClass").val();
	var ShowOrder = $("#txtShowOrder").val();
	var ParentMenuID = $("#cboParentMenu").combobox('getValue');
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
	inputStr += '^' + LinkUrl;
	inputStr += '^' + Expression;
	inputStr += '^' + ShowOrder;
	inputStr += '^' + IconClass;
	inputStr += '^' + ParentMenuID;
	var flg = $m({
		ClassName:"CT.IPMR.BT.Menus",
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
	$('#MenusDialog').window("close");
	$("#gridmenus").datagrid("reload");

}


function InitOperDialog(MenusID) {
	var selectRowIndex = '';
	var Columns = [[
		{field: 'OperaCode', title: '代码', width: 250, align: 'left'},
		{field: 'OperaName', title: '名称', width: 250, align: 'left'}
	]];
	var gridMenuOper = $HUI.datagrid("#gridMenuOper", {
		fit: true,
		headerCls:'panel-header-gray',
		iconCls:'icon-write-order',
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 100,
		fitColumns:true,
	    url:$URL,
	    queryParams : {
		    ClassName : "CT.IPMR.BTS.MenusSrv",
			QueryName : "QueryMenuOper",
			aMenuID : MenusID
	    },
	    columns : Columns ,
	    onClickRow:function(rowIndex,rowData){
    		if (selectRowIndex!==rowIndex) {
	    		$("#txtOperCode").val(rowData.OperaCode);
	    		$("#txtOperName").val(rowData.OperaName);
				$("#txtOperID").val(rowData.OperID);
				selectRowIndex = rowIndex;
	    	}else{
	    		$("#txtOperCode").val('');
				$("#txtOperName").val('');
				$("#txtOperID").val('');
				$('#gridMenuOper').datagrid('unselectAll');
				selectRowIndex = '';
	    	}
		}
	});

	var OperDialog = $('#OperDialog').dialog({
	    title: '操作列表',
		iconCls: 'icon-w-new',
	    width: 600,
	    height: 500,
	    minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
	    closed: false,
	    cache: false,
	    modal: true,
	    buttons:[{
			text:'保存',
				iconCls:'icon-w-save',
				handler:function(){
					saveOper(MenusID);
				}
		},{text:'删除',
				iconCls:'icon-w-cancel',
				handler:function(){
					delOper(MenusID);
				}
		},{
		text:'关闭',
		iconCls:'icon-w-close',
		handler:function(){
				$('#OperDialog').window("close");
			}	
		}]
	});
}

function saveOper(MenusID) {
	var OperID = $("#txtOperID").val();
	var OperCode = $("#txtOperCode").val();
	var OperName = $("#txtOperName").val();
	var aInputStr = OperID + "^" + MenusID + "^" + OperCode + "^" + OperName;
	var flg = $m({
		ClassName : "CT.IPMR.BT.MenuOper",
		MethodName : "Update",
		aInputStr : aInputStr,
		aSeparate : '^'
	},false);
	if (parseInt(flg) <= 0) {
		$.messager.alert("错误", "保存失败!", 'error');
		return;
	} else {
		$("#txtOperID").val('');
		$("#txtOperCode").val('');
		$("#txtOperName").val('');
		$("#gridMenuOper").datagrid("reload");
	}
}

function delOper(MenusID) {
	var SelectedRow =$('#gridMenuOper').datagrid('getSelected');
	if (SelectedRow==null) {
		$.messager.popover({msg: '请选择要删除数据！',type: 'alert',timeout: 1000});
		return;
	}
	var flg = $m({
		ClassName : "CT.IPMR.BT.MenuOper",
		MethodName : "DeleteById",
		aId : SelectedRow.MenuID+"||"+SelectedRow.OperID
	},false);

	if (parseInt(flg) <= 0) {
		$.messager.alert("错误", "删除失败!", 'error');
		return;
	} else {
		$("#txtOperID").val('');
		$("#txtOperCode").val('');
		$("#txtOperName").val('');
		$("#gridMenuOper").datagrid("reload");
	}
}