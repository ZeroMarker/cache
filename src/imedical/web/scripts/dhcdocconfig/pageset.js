/**
 * team.js �Ŷӹ�ϵά��
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
	//��ʼ��
	Init();
	
	//�¼���ʼ��
	InitEvent();
	
	//ҳ��Ԫ�س�ʼ��
	//PageHandle();
})


function Init(){
	PageLogicObj.m_SetGrid = InitSetGrid();
	PageLogicObj.m_PageGrid = InitPageGrid();
	PageLogicObj.m_MessageGrid = InitMessageGrid();
	PageLogicObj.m_KeyGrid = InitKeyGrid();
}

function InitEvent () {
	//ҳ��
	$("#i-find").click(findPage);
	$("#page-add").click(function (){
		page_edit("add")
	});
	$("#page-edit").click(function () {
		page_edit("edit")
	});
	$("#page-delete").click(page_delete);
	$("#page-clear").click(page_clear);
	
	//ҳ��DOM����
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
	
	//ҳ����Ϣ����
	$("#ms-add").click(function () {
		ms_edit("add");
	});
	$("#ms-edit").click(function () {
		ms_edit("edit");
	});
	$("#ms-delete").click(ms_delete)
	
	//��ݼ���Ϣ����
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
		{field:'code',title:'����',width:150},
		{field:'desc',title:'����',width:100},
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
			text:'����',
			id:'page-add',
			iconCls: 'icon-add'
		},{
			text:'�޸�',
			id:'page-edit',
			iconCls: 'icon-write-order'
		},{
			text:'ɾ��',
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
		{field:'domID',title:'Ԫ��ID',width:100},
		{field:'domName',title:'Ԫ����',width:100},
		{field:'mustFill',title:'�Ƿ����',width:100,
			formatter:function(value,row,index){
				if (value == "Y") {
					return "<span class='c-ok'>��</span>"
				} else {
					return "<span class='c-no'>��</span>"
				}
			}
		},
		{field:'seqno',title:'��ת˳��',width:100},
		{field:'css',title:'css��ʽ',width:100},
		{field:'domClss',title:'ѡ����',width:100},
		{field:'componentType',title:'�������',width:100},
		{field:'supportJump',title:'֧����ת',width:100,
			formatter:function(value,row,index){
				if (value == "Y") {
					return "<span class='c-ok'>��</span>"
				} else {
					return "<span class='c-no'>��</span>"
				}
			}
		},
		{field:'note',title:'��ע',width:100},
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
			text:'����',
			id:'ps-add',
			iconCls: 'icon-add'
		},{
			text:'�޸�',
			id:'ps-edit',
			iconCls: 'icon-write-order'
		},{
			text:'ɾ��',
			id:'ps-delete',
			iconCls: 'icon-cancel'
		},{
			text:'���',
			id:'ps-clear',
			iconCls: 'icon-clear-screen'
		}],
	});
	
	return DataGrid;
}

function InitKeyGrid () {
	var columns = [[
		{field:'ItemID',title:'Ԫ��ID',width:100},
		{field:'ItemDesc',title:'Ԫ������',width:100},
		{field:'ShortcutKey',title:'��ݼ�',width:100},
		{field:'callBackFun',title:'���ú���',width:100},
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
			text:'����',
			id:'key-add',
			iconCls: 'icon-add'
		},{
			text:'�޸�',
			id:'key-edit',
			iconCls: 'icon-write-order'
		},{
			text:'ɾ��',
			id:'key-delete',
			iconCls: 'icon-cancel'
		}],
	});
}

function InitMessageGrid(){
	var columns = [[
		{field:'code',title:'��ʾ����',width:100},
		{field:'desc',title:'��ʾ����',width:300},
		{field:'otherdesc',title:'��ʾ��������',width:60},
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
			text:'����',
			id:'ms-add',
			iconCls: 'icon-add'
		},{
			text:'�޸�',
			id:'ms-edit',
			iconCls: 'icon-write-order'
		},{
			text:'ɾ��',
			id:'ms-delete',
			iconCls: 'icon-cancel'
		}],
	});
}
//ҳ��
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
		$.messager.alert('��ʾ','��ѡ��һ����¼��' , "info");
		return false;
	}
	
	$.messager.confirm('��ʾ','��ȷ��Ҫɾ��ô��', function(r){  
		if (r){  
		
			var responseText = $.m({
				ClassName: "web.DHCDocOrderListCommon",
				MethodName: "DelPage",
				IDs: selected.rowid
			},false);
			if (responseText == 0) {
				$.messager.alert('��ʾ','ɾ���ɹ���' , "info");
				page_clear();
				return false;
			}  else {
				$.messager.alert('��ʾ','ɾ��ʧ�ܣ�' + responseText , "info");
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
			$.messager.alert('��ʾ','��ѡ��һ����¼��' , "info");
			return false;
		}
		pageid = selected.rowid;
	}
	var pageCode = $.trim($("#pageCode").val());
	var pageName = $.trim($("#pageName").val());
	
	if (pageCode == "") {
		$.messager.alert('��ʾ','����дҳ����룡' , "info");
		return false;
	}
	
	if (pageName == "") {
		$.messager.alert('��ʾ','����дҳ�����ƣ�' , "info");
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
		$.messager.alert('��ʾ','����ɹ���' , "info");
		page_clear();
		return false;
	}  else {
		$.messager.alert('��ʾ','����ʧ�ܣ�' + responseText , "info");
		return false;
	}
		
	
}

//ҳ���ݼ�����
function key_edit (ac) {
	var keyid = "",
		selected = PageLogicObj.m_KeyGrid.getSelected();
		
	if (ac=="edit") {
		if (!selected) {
			$.messager.alert('��ʾ','��ѡ��һ����¼��' , "info");
			return false;
		}
		keyid = selected.rowid;
	}
	var psRef = PageLogicObj.m_PageId;
	var src="dhcdoc.config.pageset.key.csp?keyid="+keyid+"&psRef="+psRef;
    src=('undefined'!==typeof websys_writeMWToken)?websys_writeMWToken(src):src;
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("keyEditDiag","ҳ���ݼ�����", 850, 445,"icon-w-edit","",$code,"");
}

function key_delete () {
	var selected = PageLogicObj.m_KeyGrid.getSelected();
	if (!selected) {
		$.messager.alert('��ʾ','��ѡ��һ����¼��' , "info");
		return false;
	}
	
	var responseText = $.m({
		ClassName: "web.DHCDocOrderListCommon",
		MethodName: "DelShortcutKey",
		IDs: selected.rowid
	},false);
	
	if (responseText == 0) {
		$.messager.alert('��ʾ','ɾ���ɹ���' , "info");
		PageLogicObj.m_KeyGrid.reload();
		return false;
	}else {
		$.messager.alert('��ʾ','ɾ��ʧ�ܣ�' , "info");
		return false;
	}
}


//ҳ����Ϣ����
function ms_edit (ac) {
	var msid = "",
		selected = PageLogicObj.m_MessageGrid.getSelected();
		
	if (ac=="edit") {
		if (!selected) {
			$.messager.alert('��ʾ','��ѡ��һ����¼��' , "info");
			return false;
		}
		msid = selected.rowid;
	}
	var psRef = PageLogicObj.m_PageId;
	var src="dhcdoc.config.pageset.message.csp?msid="+msid+"&psRef="+psRef;
    src=('undefined'!==typeof websys_writeMWToken)?websys_writeMWToken(src):src;
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("msEditDiag","ҳ����Ϣ����", 850, 445,"icon-w-edit","",$code,"");
}

function ms_delete () {
	var selected = PageLogicObj.m_MessageGrid.getSelected();
	if (!selected) {
		$.messager.alert('��ʾ','��ѡ��һ����¼��' , "info");
		return false;
	}
	
	var responseText = $.m({
		ClassName: "web.DHCDocOrderListCommon",
		MethodName: "DelMessage",
		IDs: selected.rowid
	},false);
	
	if (responseText == 0) {
		$.messager.alert('��ʾ','ɾ���ɹ���' , "info");
		PageLogicObj.m_MessageGrid.reload();
		return false;
	}else {
		$.messager.alert('��ʾ','ɾ��ʧ�ܣ�' , "info");
		return false;
	}
}

//ҳ��DOM�������
function ps_edit (ac) {
	var psid = "",
		selected = PageLogicObj.m_SetGrid.getSelected();
		
	if (ac=="edit") {
		if (!selected) {
			$.messager.alert('��ʾ','��ѡ��һ����¼��' , "info");
			return false;
		}
		psid = selected.id;
	}
	
	var psid = psid;
	var psRef = PageLogicObj.m_PageId;
	var src="dhcdoc.config.pageset.domset.csp?psid="+psid+"&psRef="+psRef;
    src=('undefined'!==typeof websys_writeMWToken)?websys_writeMWToken(src):src;
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("psEditDiag","ҳ��DOM����", 850, 445,"icon-w-edit","",$code,"");
	
}

function ps_delete () {
	var selected = PageLogicObj.m_SetGrid.getSelected();
	if (!selected) {
		$.messager.alert('��ʾ','��ѡ��һ����¼��' , "info");
		return false;
	}
	
	var responseText = $.m({
		ClassName: "web.DHCDocPageDom",
		MethodName: "DeleteSinglePS",
		psid: selected.id
	},false);
	
	if (responseText == 0) {
		$.messager.alert('��ʾ','ɾ���ɹ���' , "info");
		PageLogicObj.m_SetGrid.reload();
		return false;
	}else {
		$.messager.alert('��ʾ','ɾ��ʧ�ܣ�' , "info");
		return false;
	}
			
	
	
}

function ps_clear () {
	$.messager.confirm('��ʾ','ȷ����Ҫ���ô��', function(r){  
		if (r){  
			var responseText = $.m({
				ClassName: "web.DHCDocPageDom",
				MethodName: "ClearCache",
				PDParRef: PageLogicObj.m_PageId
			},false);
			
			if (responseText == 0) {
				$.messager.alert('��ʾ','��ճɹ���' , "info");
				PageLogicObj.m_SetGrid.reload();
				return false;
			}else {
				$.messager.alert('��ʾ','���ʧ�ܣ�' , "info");
				return false;
			}
		}  
	});  
	
}

function ps_search () {
	var content = $.trim($("#ps_content").val());
	if (!!!content) {
		//$.messager.alert('��ʾ','������Ҫ���������ݣ�' , "warning");
		//return false;
	}
	ps_Reload();
	
}

function ps_must () {
	PageLogicObj.m_CdValue = 1;
	$("#ps_condition").find("span.l-btn-text").text("����")
}

function ps_jump () {
	PageLogicObj.m_CdValue = 2;
	$("#ps_condition").find("span.l-btn-text").text("��ת")
}

function ps_all () {
	PageLogicObj.m_CdValue = 3;
	$("#ps_condition").find("span.l-btn-text").text("ȫ��")
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
   //�Ƴ����ڵ�Dialog
   $("body").remove("#"+id); 
   $("#"+id).dialog('destroy');
}
