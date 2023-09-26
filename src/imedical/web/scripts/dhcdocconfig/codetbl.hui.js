/**
 * codetbl.hui.js ҽ��վ������ⲿ����
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2018-08-10
 * 
 * ע��˵����
 * 		TABLE: DHC_DocExtData
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
	PageLogicObj.m_TypeCombox = $HUI.combobox("#i-type", {
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CommonFunction&QueryName=QueryExtDataType&ResultSetType=array",
		valueField:'TCTEDTRowId',
		textField:'TCTEDTDesc',
		editable:false,
		onLoadSuccess: function () {
			var data = $(this).combobox('getData');
			$(this).combobox("select",data[0].TCTEDTRowId);
			PageLogicObj.m_TypeComboxValue = data[0].TCTEDTRowId;
		},
		onSelect: function () {
			findConfig();
		}
	});
	PageLogicObj.m_Grid = InitGrid();
}
function InitEvent(){
	$("#i-find").click(findConfig);
	$("#i-add").click(function(){opDialog("add")});
	$("#i-edit").click(function(){opDialog("edit")});
	$("#i-delete").click(function(){deConfig()});
	$(document.body).bind("keydown",BodykeydownHandler)
}

function PageHandle(){
	
}

function InitGrid(){
	var columns = [[
		{field:'THISCode',title:'HIS����',width:100},
		{field:'THISDesc',title:'HIS����',width:100},
		{field:'TMUCCode',title:'�ⲿ����',width:100},
		{field:'TMUCDesc',title:'�ⲿ����',width:100},
		{field:'TActiveFlag',title:'���ñ�ʶ',width:100},
		{field:'HidRowid',title:'ID',width:60,hidden:true}
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
			ClassName : "web.DHCDocExtData",
			QueryName : "ExtDataQuery",
			SelectTypeCode: PageLogicObj.m_TypeComboxValue
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
			},{
				text:'ɾ��',
				id:'i-delete',
				iconCls: 'icon-cancel'
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
		$("#i-id").val(selected.HidRowid);
	}
	
	if($('#i-dialog').hasClass("c-hidden")) {
		$('#i-dialog').removeClass("c-hidden");
	};
	var type = PageLogicObj.m_TypeCombox.getValue();
	PageLogicObj.m_Diag_TypeCombox = $HUI.combobox("#i-diag-type", {
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CommonFunction&QueryName=QueryExtDataType&ResultSetType=array",
		valueField:'TCTEDTRowId',
		textField:'TCTEDTDesc',
		value:type,
		disabled:true
	});
	
	PageLogicObj.m_Diag_HiscodeCombox = $HUI.combobox("#i-diag-hiscode", {
		url:$URL+"?ClassName=web.DHCDocExtData&QueryName=HisCodeQuery&SelectType="+type+"&SelectHISCode=&ResultSetType=array",
		valueField:'HISRowid',
		textField:'HISCode',
		onSelect: function (record) {
			$("#i-diag-hisname").val(record.HISDesc);	//attr("disabled","disabled");
		}
	});
	if (action == "add") {
		//$("#i-action").val("add");
		PageLogicObj.m_Diag_HiscodeCombox.setValue("");
		$("#i-diag-hisname").val("");
		$("#i-diag-wbcode").val("");
		$("#i-diag-wbname").val("");
		$("#i-diag-active").checkbox("uncheck")
		
	} else {
		//$("#i-action").val("edit");
		// HISCodeRowId
		PageLogicObj.m_Diag_HiscodeCombox.setValue(selected.HISCodeRowId);
		$("#i-diag-hisname").val(selected.THISDesc);
		$("#i-diag-wbcode").val(selected.TMUCCode);
		$("#i-diag-wbname").val(selected.TMUCDesc);
		if (selected.TActiveFlag == "��") {
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

function deConfig () {
	var selected = PageLogicObj.m_Grid.getSelected();
	if (!selected) {
		$.messager.alert("��ʾ","��ѡ��һ����¼��","info")
		return false;
	}
	$.m({
			ClassName:"web.DHCDocExtData",
			MethodName:"DeleteExtData",
			MUCRowid: selected.HidRowid
		},function (responseText){
			if(responseText == 0) {
				$.messager.alert('��ʾ','ɾ���ɹ���',"info");
				PageLogicObj.m_Grid.reload();
			} else {
				$.messager.alert('��ʾ','�޸�ʧ��,�������: '+ responseText , "info");
				return false;
			}	
		})
}


//�����ֵ���Ϣ
function saveCfg() {
	var id = $("#i-id").val();
	var action = $("#i-action").val();
	var type = PageLogicObj.m_TypeCombox.getValue();
	var hisCodeId = PageLogicObj.m_Diag_HiscodeCombox.getValue();
	var hisCode = PageLogicObj.m_Diag_HiscodeCombox.getText();
	var hisname = $("#i-diag-hisname").val();
	var wbcode = $("#i-diag-wbcode").val();
	var wbname = $("#i-diag-wbname").val();
	var active = $("#i-diag-active").checkbox("getValue");
	if (active) {
		active = "Y"
	} else {
		active = "N"
	}
	var paraInStr = type + "^" + hisCodeId + "^" + hisCode + "^" + hisname + "^" + wbcode + "^" + wbname + "^" + active;
	var paraUpStr = hisCodeId + "^" + hisCode + "^" + hisname + "^" + wbcode + "^" + wbname + "^" + active;
	if (hisCodeId == "") {
		$.messager.alert('��ʾ','HIS���벻��Ϊ��!',"info");
		return false;
	}
	/*if (wbcode == "") {
		$.messager.alert('��ʾ','�ⲿ���벻��Ϊ��!',"info");
		return false;
	}
	if (wbname == "") {
		$.messager.alert('��ʾ','�ⲿ���Ʋ���Ϊ��!',"info");
		return false;
	}*/
	
	var methodName = "ModifyExtData";
	if (action == "add") {
		rpResult = tkMakeServerCall("web.DHCDocExtData","RepeatExtData",type,hisCodeId);
		if ( rpResult == "R") {
			$.messager.alert('��ʾ','��¼�Ѵ���!',"info");
			return false;
		}
		methodName = "InsertExtData";
		$.m({
			ClassName:"web.DHCDocExtData",
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
		rpResult = tkMakeServerCall("web.DHCDocExtData","RepeatExtData",type,hisCodeId,id);
		if ( rpResult == "R") {
			$.messager.alert('��ʾ','��¼�Ѵ���!',"info");
			return false;
		}
		$.m({
			ClassName:"web.DHCDocExtData",
			MethodName:methodName,
			InStr:paraUpStr,
			MUCRowid:id
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

//����
function findConfig () {
	//var text = PageLogicObj.m_ArcimCombox.getText();
	var SelectTypeCode = PageLogicObj.m_TypeCombox.getValue();
	
	PageLogicObj.m_Grid.reload({
		ClassName : "web.DHCDocExtData",
		QueryName : "ExtDataQuery",
		SelectTypeCode: SelectTypeCode
	});
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


