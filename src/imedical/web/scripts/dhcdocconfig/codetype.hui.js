/**
 * codetype.hui.js �ⲿ���ݶ�������ά��HUI
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2018-08-10
 * 
 * ע��˵��
 * TABLE: 
 * 		DHCDoc_CT_ExtDataType 
 */
 
//ҳ��ȫ�ֱ���
var PageLogicObj = {
	m_TypeCombox : "",
	m_TypeComboxValue : "",
	m_Grid : "",
	m_Diag_HiscodeCombox: "",
	m_Diag_TypeCombox: "",
	m_Win : ""
	
}

$(function(){
	//��ʼ��
	Init();
	
	//�¼���ʼ��
	InitEvent();
	
	//ҳ��Ԫ�س�ʼ��
	PageHandle();
})

function Init(){
	PageLogicObj.m_Grid = InitGrid();
}
function InitEvent(){
	$("#i-add").click(function(){opDialog("add")});
	$("#i-edit").click(function(){opDialog("edit")});
	//$("#i-delete").click(function(){deConfig()});
	$(document.body).bind("keydown",BodykeydownHandler)
}

function PageHandle(){
	
}

function InitGrid(){
	var columns = [[
		{field:'TCTEDTCode',title:'����',width:100},
		{field:'TCTEDTDesc',title:'����',width:100},
		{field:'TCTEDTActive',title:'��Ч��ʶ',width:100},
		//{field:'TCTEDTClassName',title:'����',width:100},
		//{field:'TCTEDTQueryName',title:'Query��',width:100},
		{field:'TCTEDTTable',title:'HIS����',width:100},
		{field:'TCTEDTTableCode',title:'HIS������ֶ�',width:100},
		{field:'TCTEDTTableDesc',title:'HIS�������ֶ�',width:100},
		{field:'TCTEDTRowId',title:'ID',width:60,hidden:false}
    ]]
	var DurDataGrid = $HUI.datagrid("#i-durGrid", {
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
			ClassName : "web.DHCDocCTExtDataType",
			QueryName : "QueryExtDataType"
		},
		columns :columns,
		toolbar:[{
				text:'����',
				id:'i-add',
				iconCls: 'icon-add'
			},{
				text:'�޸�',
				id:'i-edit',
				iconCls: 'icon-write-order'
			}
		]
	});
	
	return DurDataGrid;
}

//�༭������
function opDialog(action) {
	var selected = PageLogicObj.m_Grid.getSelected();
	var tempValue = "",tempValue2 = "";
	var _title = "", _icon = "" ;
	if (action == "add") {
		_title = "����";
		_icon = "icon-w-add";
		$("#i-action").val("add");
		$("#i-id").val("");
	} else {
		if (!selected) {
			$.messager.alert("��ʾ","��ѡ��һ����¼��","info")
			return false;
		}
		_title = "�޸�";
		_icon = "icon-w-edit";
		$("#i-action").val("edit");
		$("#i-id").val(selected.TCTEDTRowId);
	}
	
	if($('#i-dialog').hasClass("c-hidden")) {
		$('#i-dialog').removeClass("c-hidden");
	};
	
	if (action == "add") {
		//$("#i-action").val("add");
		$("#i-diag-code").val("");
		$("#i-diag-name").val("");
		$("#i-diag-table").val("");
		$("#i-diag-tableCode").val("");
		$("#i-diag-tableDesc").val("");
		//$("#i-diag-cls").val("");
		//$("#i-diag-query").val("");
		$("#i-diag-active").checkbox("uncheck")
		
	} else {
		//$("#i-action").val("edit");
		// HISCodeRowId
		$("#i-diag-code").val(selected.TCTEDTCode);
		$("#i-diag-name").val(selected.TCTEDTDesc);
		$("#i-diag-table").val(selected.TCTEDTTable);
		$("#i-diag-tableCode").val(selected.TCTEDTTableCode);
		$("#i-diag-tableDesc").val(selected.TCTEDTTableDesc);
		//$("#i-diag-cls").val(selected.TCTEDTClassName);
		//$("#i-diag-query").val(selected.TCTEDTQueryName);
		if (selected.TCTEDTActive == "��") {
			$("#i-diag-active").checkbox("check")
		} else {
			$("#i-diag-active").checkbox("uncheck")
		}
		
	}
	
	var cWin = $HUI.window('#i-dialog', {
		title: _title,
		iconCls: _icon,
		modal: true,
		minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
		onClose: function () {
			//$(this).window('destroy');
			$('#i-dialog').addClass("c-hidden");
		}
	});
	
	PageLogicObj.m_Win = cWin;
}

//�����ֵ���Ϣ
function saveCfg() {
	var id = $("#i-id").val();
	var action = $("#i-action").val();
	
	var code = $.trim($("#i-diag-code").val());
	var name = $.trim($("#i-diag-name").val());
	//var cls = $.trim($("#i-diag-cls").val());
	//var query = $.trim($("#i-diag-query").val());
	var table = $.trim($("#i-diag-table").val());
	var tableCode = $.trim($("#i-diag-tableCode").val());
	var tableDesc = $.trim($("#i-diag-tableDesc").val());
	var active = $("#i-diag-active").checkbox("getValue");
	if (active) {
		active = "Y"
	} else {
		active = "N"
	}
	var paraInStr = code + "^" + name + "^" + "" + "^" + "" + "^" + active + "^" + table + "^" + tableCode + "^" + tableDesc;
	var paraUpStr = paraInStr;
	if (code == "") {
		$.messager.alert('��ʾ','��������Ч�Ĵ���!',"info");
		return false;
	}
	if (name == "") {
		$.messager.alert('��ʾ','��������Ч������!',"info");
		return false;
	}
	/*if (cls == "") {
		$.messager.alert('��ʾ','��������Ч����!',"info");
		return false;
	}
	if (query == "") {
		$.messager.alert('��ʾ','��������Ч��Query����!',"info");
		return false;
	}*/
	if (table == "") {
		$.messager.alert('��ʾ','��������Ч�ı�!',"info");
		return false;
	}
	if (tableCode == "") {
		$.messager.alert('��ʾ','��������Ч��HIS����!',"info");
		return false;
	}
	if (tableDesc == "") {
		$.messager.alert('��ʾ','��������Ч��HIS����!',"info");
		return false;
	}
	var myoptval=$.cm({
				ClassName:"web.DHCDocExtData",
				MethodName:"CheckforTableexcite",
				dataType:"text",
				Table:table,
				TableCode:tableCode,
				TableDesc:tableDesc
			},false);
	if (myoptval!=0){
		$.messager.alert('��ʾ',myoptval,"info");
		return false;
		}
	var methodName = "UpdateExtDataType";
	if (action == "add") {
		methodName = "InsertExtDataType";
		$.m({
			ClassName:"web.DHCDocCTExtDataType",
			MethodName:methodName,
			Instr:paraInStr
		},function (responseText){
			if(responseText == 0) {
				$.messager.alert('��ʾ','�����ɹ���',"info");
				PageLogicObj.m_Win.close();
				PageLogicObj.m_Grid.reload();
				
			} else {
				$.messager.alert('��ʾ','����ʧ��,�������: '+ responseText , "info");
				return false;
			}	
		})
	} else {
		$.m({
			ClassName:"web.DHCDocCTExtDataType",
			MethodName:methodName,
			InStr:paraUpStr,
			CTEDTRowid:id
		},function (responseText){
			if(responseText == 0) {
				$.messager.alert('��ʾ','�޸ĳɹ���',"info");
				PageLogicObj.m_Win.close();
				PageLogicObj.m_Grid.reload();
				
			} else {
				$.messager.alert('��ʾ','�޸�ʧ��,�������: '+ responseText , "info");
				return false;
			}	
		})
	}
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
	//�������Backspace������  
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


