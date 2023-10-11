/**
 * team.js 团队关系维护
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2019-07-16
 * 
 * 
 */
var PageLogicObj = {
	m_CdValue: "3",
	m_PageId: "",
	m_SetGrid: "",
	m_PageGrid:""
	
}

$(function() {
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
	
	//页面元素初始化
	//PageHandle();
})


function Init(){
	PageLogicObj.m_SetGrid = InitSetGrid();
	PageLogicObj.m_PageGrid = InitPageGrid();
	PageLogicObj.m_MessageGrid = InitMessageGrid();
	PageLogicObj.m_KeyGrid = InitKeyGrid();
}

function InitEvent () {
	//页面
	$("#i-find").click(findPage);
	$("#page-add").click(function (){
		page_edit("add")
	});
	$("#page-edit").click(function () {
		page_edit("edit")
	});
	$("#page-delete").click(page_delete);
	$("#page-clear").click(page_clear);
	
	//页面DOM设置
	$("#ps-add").click(function () {
		ps_edit("add");
	});
	$("#ps-edit").click(function () {
		ps_edit("edit");
	});
	$("#ps-delete").click(ps_delete);
	$("#ps-clear").click(ps_clear);
	$("#ps_search").click(ps_search);
	$("#ps-must").click(ps_must);
	$("#ps-jump").click(ps_jump);
	$("#ps-all").click(ps_all);
	
	//页面消息设置
	$("#ms-add").click(function () {
		ms_edit("add");
	});
	$("#ms-edit").click(function () {
		ms_edit("edit");
	});
	$("#ms-delete").click(ms_delete)
	
	//快捷键消息设置
	$("#key-add").click(function () {
		key_edit("add");
	});
	$("#key-edit").click(function () {
		key_edit("edit");
	});
	$("#key-delete").click(key_delete)
	
	
	document.onkeydown = DocumentOnKeyDown;
}

function InitPageGrid(){
	var columns = [[
		{field:'code',title:'代码',width:150},
		{field:'desc',title:'描述',width:100},
		{field:'rowid',title:'rowid',width:100,hidden:true}
    ]]
	var DataGrid = $HUI.datagrid("#i-page", {
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		//rownumbers:true,
		//autoRowHeight : false,
		pagination : true,  
		//headerCls:'panel-header-gray',
		pageSize:14,
		pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "web.DHCDocOrderListCommon",
			QueryName : "GetOrderPage",
			FindCode: '',
			FindDesc: ''
		},
		onSelect: function (rowIndex,rowData) {
			PageLogicObj.m_PageId = rowData.rowid;
			$("#pageCode").val(rowData.code);
			$("#pageName").val(rowData.desc);
			reloadSetGrid(rowData.rowid);
			reloadMessageGrid(rowData.rowid);
			reloadKeyGrid(rowData.rowid);
		},
		onDblClickRow:function (rowIndex, rowData) {
			$('#page').layout('collapse','west');  
		},
		//idField:'Rowid',
		columns :columns,
		toolbar:[{
			text:'新增',
			id:'page-add',
			iconCls: 'icon-add'
		},{
			text:'修改',
			id:'page-edit',
			iconCls: 'icon-write-order'
		},{
			text:'删除',
			id:'page-delete',
			iconCls: 'icon-cancel'
		}],
	});
	
	return DataGrid;
}

function reloadSetGrid (id) {
	PageLogicObj.m_SetGrid.reload({
		ClassName : "web.DHCDocPageDom",
		QueryName : "QryPageSet",
		inPage: id
	})
}
function reloadMessageGrid (id) {
	id = id||PageLogicObj.m_PageId;
	PageLogicObj.m_MessageGrid.reload({
		ClassName : "web.DHCDocOrderListCommon",
		QueryName : "GetOrderMessage",
		DOPRowId: id
	})
}
function reloadKeyGrid (id) {
	id = id||PageLogicObj.m_PageId;
	PageLogicObj.m_KeyGrid.reload({
		ClassName : "web.DHCDocPageDom",
		QueryName : "GetShortcutKey",
		DOPRowId: id
	})
}
function InitSetGrid(){
	var columns = [[
		{field:'domID',title:'元素ID',width:100},
		{field:'domName',title:'元素名',width:100},
		{field:'mustFill',title:'是否必填',width:100,
			formatter:function(value,row,index){
				if (value == "Y") {
					return "<span class='c-ok'>是</span>"
				} else {
					return "<span class='c-no'>否</span>"
				}
			}
		},
		{field:'seqno',title:'跳转顺序',width:100},
		{field:'css',title:'css样式',width:100},
		{field:'domClss',title:'选择器',width:100},
		{field:'componentType',title:'组件类型',width:100},
		{field:'supportJump',title:'支持跳转',width:100,
			formatter:function(value,row,index){
				if (value == "Y") {
					return "<span class='c-ok'>是</span>"
				} else {
					return "<span class='c-no'>否</span>"
				}
			}
		},
		{field:'note',title:'备注',width:100},
		{field:'id',title:'id',width:100,hidden:true}
    ]]
	var DataGrid = $HUI.datagrid("#i-pageset", {
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		//rownumbers:true,
		//autoRowHeight : false,
		pagination : true,  
		//headerCls:'panel-header-gray',
		pageSize:14,
		pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "web.DHCDocPageDom",
			QueryName : "QryPageSet",
			inPage: '',
			inContent:'',
			inCdVal:''
		},
		//idField:'Rowid',
		columns :columns,
		toolbar:[{
			text:'新增',
			id:'ps-add',
			iconCls: 'icon-add'
		},{
			text:'修改',
			id:'ps-edit',
			iconCls: 'icon-write-order'
		},{
			text:'删除',
			id:'ps-delete',
			iconCls: 'icon-cancel'
		},{
			text:'清空',
			id:'ps-clear',
			iconCls: 'icon-clear-screen'
		}],
	});
	
	return DataGrid;
}

function InitKeyGrid () {
	var columns = [[
		{field:'ItemID',title:'元素ID',width:100},
		{field:'ItemDesc',title:'元素描述',width:100},
		{field:'ShortcutKey',title:'快捷键',width:100},
		{field:'callBackFun',title:'调用函数',width:100},
		{field:'rowid',title:'rowid',width:100,hidden:true}
    ]]
	return $HUI.datagrid("#i-key", {
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		//rownumbers:true,
		//autoRowHeight : false,
		pagination : true,  
		//headerCls:'panel-header-gray',
		pageSize:14,
		pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "web.DHCDocPageDom",
			QueryName : "GetShortcutKey",
			DOPRowId: ''
		},
		//idField:'Rowid',
		columns :columns,
		toolbar:[{
			text:'新增',
			id:'key-add',
			iconCls: 'icon-add'
		},{
			text:'修改',
			id:'key-edit',
			iconCls: 'icon-write-order'
		},{
			text:'删除',
			id:'key-delete',
			iconCls: 'icon-cancel'
		}],
	});
}

function InitMessageGrid(){
	var columns = [[
		{field:'code',title:'提示代码',width:100},
		{field:'desc',title:'提示描述',width:300},
		{field:'otherdesc',title:'提示外文描述',width:60},
		{field:'rowid',title:'rowid',width:100,hidden:true}
    ]]
	return $HUI.datagrid("#i-message", {
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		//rownumbers:true,
		//autoRowHeight : false,
		pagination : true,  
		//headerCls:'panel-header-gray',
		pageSize:14,
		pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "web.DHCDocOrderListCommon",
			QueryName : "GetOrderMessage",
			DOPRowId: ''
		},
		//idField:'Rowid',
		columns :columns,
		toolbar:[{
			text:'新增',
			id:'ms-add',
			iconCls: 'icon-add'
		},{
			text:'修改',
			id:'ms-edit',
			iconCls: 'icon-write-order'
		},{
			text:'删除',
			id:'ms-delete',
			iconCls: 'icon-cancel'
		}],
	});
}
//页面
function findPage () {
	var pageCode = $.trim($("#pageCode").val());
	var pageName = $.trim($("#pageName").val());
	
	PageLogicObj.m_PageGrid.reload({
		ClassName : "web.DHCDocOrderListCommon",
		QueryName : "GetOrderPage",
		FindCode: pageCode,
		FindDesc: pageName
	});
}

function page_clear () {
	$("#pageCode").val("");
	$("#pageName").val("");
	findPage();
}
function page_delete () {
	var 
		selected = PageLogicObj.m_PageGrid.getSelected();
	if (!selected) {
		$.messager.alert('提示','请选择一条记录！' , "info");
		return false;
	}
	
	$.messager.confirm('提示','你确定要删除么？', function(r){  
		if (r){  
		
			var responseText = $.m({
				ClassName: "web.DHCDocOrderListCommon",
				MethodName: "DelPage",
				IDs: selected.rowid
			},false);
			if (responseText == 0) {
				$.messager.alert('提示','删除成功！' , "info");
				page_clear();
				return false;
			}  else {
				$.messager.alert('提示','删除失败：' + responseText , "info");
				return false;
			}
			
		}  
	});  
}

function page_edit (ac) {
	var pageid = ""
		selected = PageLogicObj.m_PageGrid.getSelected();
	if (ac == "edit") {
		if (!selected) {
			$.messager.alert('提示','请选择一条记录！' , "info");
			return false;
		}
		pageid = selected.rowid;
	}
	var pageCode = $.trim($("#pageCode").val());
	var pageName = $.trim($("#pageName").val());
	
	if (pageCode == "") {
		$.messager.alert('提示','请填写页面代码！' , "info");
		return false;
	}
	
	if (pageName == "") {
		$.messager.alert('提示','请填写页面名称！' , "info");
		return false;
	}
	
	var responseText = $.m({
		ClassName: "web.DHCDocOrderListCommon",
		MethodName: "UpdatePage",
		id: pageid,
		code: pageCode,
		desc: pageName
	},false);
	if (responseText == 0) {
		$.messager.alert('提示','保存成功！' , "info");
		page_clear();
		return false;
	}  else {
		$.messager.alert('提示','保存失败：' + responseText , "info");
		return false;
	}
		
	
}

//页面快捷键设置
function key_edit (ac) {
	var keyid = "",
		selected = PageLogicObj.m_KeyGrid.getSelected();
		
	if (ac=="edit") {
		if (!selected) {
			$.messager.alert('提示','请选择一条记录！' , "info");
			return false;
		}
		keyid = selected.rowid;
	}
	var psRef = PageLogicObj.m_PageId;
	var src="dhcdoc.config.pageset.key.csp?keyid="+keyid+"&psRef="+psRef;
    src=('undefined'!==typeof websys_writeMWToken)?websys_writeMWToken(src):src;
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("keyEditDiag","页面快捷键设置", 850, 445,"icon-w-edit","",$code,"");
}

function key_delete () {
	var selected = PageLogicObj.m_KeyGrid.getSelected();
	if (!selected) {
		$.messager.alert('提示','请选择一条记录！' , "info");
		return false;
	}
	
	var responseText = $.m({
		ClassName: "web.DHCDocOrderListCommon",
		MethodName: "DelShortcutKey",
		IDs: selected.rowid
	},false);
	
	if (responseText == 0) {
		$.messager.alert('提示','删除成功！' , "info");
		PageLogicObj.m_KeyGrid.reload();
		return false;
	}else {
		$.messager.alert('提示','删除失败！' , "info");
		return false;
	}
}


//页面消息设置
function ms_edit (ac) {
	var msid = "",
		selected = PageLogicObj.m_MessageGrid.getSelected();
		
	if (ac=="edit") {
		if (!selected) {
			$.messager.alert('提示','请选择一条记录！' , "info");
			return false;
		}
		msid = selected.rowid;
	}
	var psRef = PageLogicObj.m_PageId;
	var src="dhcdoc.config.pageset.message.csp?msid="+msid+"&psRef="+psRef;
    src=('undefined'!==typeof websys_writeMWToken)?websys_writeMWToken(src):src;
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("msEditDiag","页面消息设置", 850, 445,"icon-w-edit","",$code,"");
}

function ms_delete () {
	var selected = PageLogicObj.m_MessageGrid.getSelected();
	if (!selected) {
		$.messager.alert('提示','请选择一条记录！' , "info");
		return false;
	}
	
	var responseText = $.m({
		ClassName: "web.DHCDocOrderListCommon",
		MethodName: "DelMessage",
		IDs: selected.rowid
	},false);
	
	if (responseText == 0) {
		$.messager.alert('提示','删除成功！' , "info");
		PageLogicObj.m_MessageGrid.reload();
		return false;
	}else {
		$.messager.alert('提示','删除失败！' , "info");
		return false;
	}
}

//页面DOM设置相关
function ps_edit (ac) {
	var psid = "",
		selected = PageLogicObj.m_SetGrid.getSelected();
		
	if (ac=="edit") {
		if (!selected) {
			$.messager.alert('提示','请选择一条记录！' , "info");
			return false;
		}
		psid = selected.id;
	}
	
	var psid = psid;
	var psRef = PageLogicObj.m_PageId;
	var src="dhcdoc.config.pageset.domset.csp?psid="+psid+"&psRef="+psRef;
    src=('undefined'!==typeof websys_writeMWToken)?websys_writeMWToken(src):src;
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("psEditDiag","页面DOM设置", 850, 445,"icon-w-edit","",$code,"");
	
}

function ps_delete () {
	var selected = PageLogicObj.m_SetGrid.getSelected();
	if (!selected) {
		$.messager.alert('提示','请选择一条记录！' , "info");
		return false;
	}
	
	var responseText = $.m({
		ClassName: "web.DHCDocPageDom",
		MethodName: "DeleteSinglePS",
		psid: selected.id
	},false);
	
	if (responseText == 0) {
		$.messager.alert('提示','删除成功！' , "info");
		PageLogicObj.m_SetGrid.reload();
		return false;
	}else {
		$.messager.alert('提示','删除失败！' , "info");
		return false;
	}
			
	
	
}

function ps_clear () {
	$.messager.confirm('提示','确定需要清空么？', function(r){  
		if (r){  
			var responseText = $.m({
				ClassName: "web.DHCDocPageDom",
				MethodName: "ClearCache",
				PDParRef: PageLogicObj.m_PageId
			},false);
			
			if (responseText == 0) {
				$.messager.alert('提示','清空成功！' , "info");
				PageLogicObj.m_SetGrid.reload();
				return false;
			}else {
				$.messager.alert('提示','清空失败！' , "info");
				return false;
			}
		}  
	});  
	
}

function ps_search () {
	var content = $.trim($("#ps_content").val());
	if (!!!content) {
		//$.messager.alert('提示','请输入要搜索的内容！' , "warning");
		//return false;
	}
	ps_Reload();
	
}

function ps_must () {
	PageLogicObj.m_CdValue = 1;
	$("#ps_condition").find("span.l-btn-text").text("必填")
}

function ps_jump () {
	PageLogicObj.m_CdValue = 2;
	$("#ps_condition").find("span.l-btn-text").text("跳转")
}

function ps_all () {
	PageLogicObj.m_CdValue = 3;
	$("#ps_condition").find("span.l-btn-text").text("全部")
}

function ps_Reload () {
	var content = $.trim($("#ps_content").val());
	
	PageLogicObj.m_SetGrid.reload({
		ClassName : "web.DHCDocPageDom",
		QueryName : "QryPageSet",
		inPage: PageLogicObj.m_PageId,
		inContent: content,
		inCdVal: PageLogicObj.m_CdValue
	});
}

function DocumentOnKeyDown(e){
	if (window.event){
		var keyCode=window.event.keyCode;
		var type=window.event.type;
		var SrcObj=window.event.srcElement;
	}else{
		var keyCode=e.which;
		var type=e.type;
		var SrcObj=e.target;
	}
	if (keyCode==13) {
		if(SrcObj && SrcObj.id.indexOf("ps_content")>=0){
			ps_Reload();
			return false;
		}
		if(SrcObj && SrcObj.id.indexOf("pageCode")>=0){
			findPage();
			return false;
		}
		if(SrcObj && SrcObj.id.indexOf("pageName")>=0){
			findPage();
			return false;
		}
		return true;
	}
}

function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
    $("body").append("<div id='"+id+"' style='overflow:hidden;' class='hisui-dialog'></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;
    $("#"+id).dialog({
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        iconCls: _icon,
        //href: _url,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: true,
        content:_content,
        onClose:function(){
	        destroyDialog(id);
	    }
    });
}

function destroyDialog(id){
   //移除存在的Dialog
   $("body").remove("#"+id); 
   $("#"+id).dialog('destroy');
}
