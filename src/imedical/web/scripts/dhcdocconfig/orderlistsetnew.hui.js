/**
 * pageset.message.js
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2019-07-16
 * 
 * 
 */
var PageLogicObj = {
	m_Grid: "",
	m_GridType: ""
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
	InitGrid();
	InitCombox();
	
}

function InitEvent () {
	$("#i-find").click(findColSet);
	$("#i-add").click(function () {
		col_edit("add");
	});
	$("#i-edit").click(function () {
		col_edit("edit");
	});
	$("#i-delete").click(deleteCol);
	document.onkeydown = DocumentOnKeyDown;
}

function InitCombox () {
	PageLogicObj.m_GridType = $HUI.combobox("#gridType", {
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.AdmColSet&QueryName=QryGridType&inPage=&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		onLoadSuccess: function () {
			var data = $(this).combobox('getData');
			$(this).combobox("select",data[0].id);
			findColSet();
		}
		
	});
}

function InitGrid(){
	var columns = [[
		{field:'code',title:'��ID',width:80},
		{field:'desc',title:'������',width:100},
		{field:'colwidth',title:'�п�',width:60},
		{field:'hidden',title:'�Ƿ�����',width:60,
			formatter:function(value,row,index){
				if (value == "Y") {
					return "<span class='c-ok'>��</span>"
				} else {
					return "<span class='c-no'>��</span>"
				}
			}
		},
		{field:'expression',title:'���ʽ',width:200},
		{field:'rowid',title:'rowid',width:100,hidden:true}
    ]]
	PageLogicObj.m_Grid = $HUI.datagrid("#i-grid", {
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
			ClassName : "DHCDoc.DHCDocConfig.AdmColSet",
			QueryName : "GetOrderListSet",
			DOGRowId: "",
			inContent: ""
		},
		onSelect: function (rowIndex,rowData) {
			
		},
		//idField:'Rowid',
		columns :columns,
		toolbar:[{
			text:'����',
			id:'i-add',
			iconCls: 'icon-add'
		},{
			text:'�޸�',
			id:'i-edit',
			iconCls: 'icon-write-order'
		},{
			text:'ɾ��',
			id:'i-delete',
			iconCls: 'icon-cancel'
		}],
	});
}

function findColSet () {
	var gridType = PageLogicObj.m_GridType.getValue()||"";
	var inContent = $.trim($("#content").val())

	PageLogicObj.m_Grid.reload ({
		ClassName : "DHCDoc.DHCDocConfig.AdmColSet",
		QueryName : "GetOrderListSet",
		DOGRowId: gridType,
		inContent: inContent
	});
}

function deleteCol () {
	var 
		selected = PageLogicObj.m_Grid.getSelected();
	
	if (!selected) {
		$.messager.alert('��ʾ','��ѡ��һ����¼��' , "info");
		return false;
	}
		
	$.messager.confirm('��ʾ','ȷ����Ҫɾ��ô��', function(r){  
		if (r){  
			var responseText = $.m({
				ClassName: "web.DHCDocOrderListCommon",
				MethodName: "Del",
				IDs: selected.rowid
			},false);
			
			if (responseText == 0) {
				$.messager.alert('��ʾ','ɾ���ɹ���' , "info");
				PageLogicObj.m_Grid.reload();
				return false;
			}else {
				$.messager.alert('��ʾ','ɾ��ʧ�ܣ�' , "info");
				return false;
			}
		}  
	});  
}

function col_edit (ac) {
	var id = "",
		selected = PageLogicObj.m_Grid.getSelected();
		
	if (ac=="edit") {
		if (!selected) {
			$.messager.alert('��ʾ','��ѡ��һ����¼��' , "info");
			return false;
		}
		id = selected.rowid;
	}
	var dgid = PageLogicObj.m_GridType.getValue()||"";
	if ( (dgid=="") && (ac == "add") ) {
		$.messager.alert('��ʾ','����ѡ�������ͣ�' , "info");
		return false;
	}
	var src="dhcdoc.config.orderlistsetnew.edit.csp?id="+id+"&dgid="+dgid;
    src=('undefined'!==typeof websys_writeMWToken)?websys_writeMWToken(src):src;
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("colEditDiag","���������", 850, 445,"icon-w-edit","",$code,"");
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
		if(SrcObj && SrcObj.id.indexOf("content")>=0){
			findColSet();
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
   $("body").remove("#"+id); 
   $("#"+id).dialog('destroy');
}

