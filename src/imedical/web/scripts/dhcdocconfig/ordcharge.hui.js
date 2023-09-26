/**
 * ordcharge.hui.js �����޸�ҽ���ѱ�
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2018-08-10
 * 
 * ע��˵��
 * TABLE: DHC_Doc_OrdLinked
 */
 
//ҳ��ȫ�ֱ���
var PageLogicObj = {
	m_AdmBox : "",
	m_AdmBoxGrid: "",
	m_Grid: "",
	m_IDS: "",
	m_Win: "",
	m_BBEX: ""
	
}

$(function(){
	//��ʼ��
	Init();
	
	//�¼���ʼ��
	InitEvent();
	
	//ҳ��Ԫ�س�ʼ��
	//PageHandle();
})

function Init(){
	InitSearch();
	InitDataGrid();
}
function InitEvent(){
	$("#i-find").click(findConfig);
	$("#i-edit").click(opDialog);
	$("#i-patno").keydown(function(e){
		if(e.which == 13 || event.which == 9){
			var PatNo = $('#i-patno').val();
			if (PatNo == "") return;
			if (PatNo.length<10) {
				for (var i=(10-PatNo.length-1); i>=0; i--) {
					PatNo="0"+PatNo;
				}
			}
			$('#i-patno').val(PatNo);
			PageLogicObj.m_AdmBox.setValue("");

		}
	})
	$(document.body).bind("keydown",BodykeydownHandler)
}

function PageHandle(){
	//
}

function InitSearch () {
	
	var comboxOBJ = $HUI.combogrid("#i-adm", {
		panelWidth: 600,
		idField: 'RowID',
		textField: 'AdmDate',
		//method: 'get',
		columns: [[
			{field:'AdmDate',title:'��������',width:120},
			{field:'DepDesc',title:'����',width:120},
			{field:'DocDesc',title:'ҽ��',width:120},
			{field:'RowID',title:'ID',width:50}
		]],
		pagination : true,
		url:$URL,
		queryParams:{
			ClassName : 'web.DHCDocOrderMedLeft',
			QueryName : 'GetAdm',
			PapmiNo: ''
		},
		fitColumns: true,
		enterNullValueClear:true,
		onShowPanel: function (rowIndex, rowData) {
			var curInput = $.trim($("#i-patno").val());
			if (curInput == "") {
				return false;
			}
			PageLogicObj.m_AdmBoxGrid.datagrid("reload", {
				ClassName : 'web.DHCDocOrderMedLeft',
				QueryName : 'GetAdm',
				PapmiNo: curInput
			})
			
		}
	});
	
	PageLogicObj.m_AdmBox = comboxOBJ;
	PageLogicObj.m_AdmBoxGrid = comboxOBJ.grid();
}
//
function InitDataGrid(){
	var columns = [[
		//{field:'ck',checkbox:true},
		{field:'PatInfo',title:'������Ϣ',width:200},
		{field:'ArcimDesc',title:'ҽ������',width:150},
		{field:'OrdStartDate',title:'��ʼ����',width:80},
		{field:'OrdStartTime',title:'��ʼʱ��',width:60},
		{field:'QtyPackUOM',title:'����',width:60},
		//{field:'MedLeft',title:'�Ƿ����ʣ��ҩ�� ',width:60},	//���ֶ��Ƴ�QP
		{field:'BBExtCode',title:'�ѱ�',width:60},
		{field:'OEItemID',title:'OEItemID',width:60}
    ]]
	
	PageLogicObj.m_Grid = $HUI.datagrid("#i-grid", {
		fit : true,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : true,
		rownumbers:true,
		//autoRowHeight : false,
		pagination : true,  
		headerCls:'panel-header-gray',
		//pageSize:14,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "web.DHCDocOrderMedLeft",
			QueryName : "GetOrder",
			AdmId: ""
		},
		columns :columns,
		toolbar:[{
				text:'�޸ķѱ�',
				id:'i-edit',
				iconCls: 'icon-edit'
			}
		]
	});
}

//�༭
function opDialog() {
	var selected = PageLogicObj.m_Grid.getSelections();
	if ((!selected)||(selected=="")) {
		$.messager.alert("��ʾ","��ѡ��һ����¼...","info")
		return false;
	}
	var ids = [];
	for (var i=0; i < selected.length; i++) {
		ids.push(selected[i].OEItemID)
	}
	PageLogicObj.m_IDS = ids;
	$("#i-label").html(PageLogicObj.m_IDS.length);
	if($('#i-dialog').hasClass("c-hidden")) {
		$('#i-dialog').removeClass("c-hidden");
	};
	
	//i-bbex
	PageLogicObj.m_BBEX = $HUI.combobox("#i-bbex", {
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CommonFunction&QueryName=QryFeeType&ResultSetType=array",
		valueField:'id',
		textField:'desc'
	})
	
	var cWin = $HUI.window('#i-dialog', {
		title: "�޸ķѱ�",
		iconCls: "icon-w-edit",
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
	var result = 0,oeori="";
	var bbex = PageLogicObj.m_BBEX.getValue();
	if (bbex == "") {
		$.messager.alert('��ʾ','��ѡ��ѱ�лл��',"info");
		return false;
	}
	for (var j=0; j<PageLogicObj.m_IDS.length; j ++) {
		oeori = PageLogicObj.m_IDS[j];
		result = tkMakeServerCall("web.DHCDocOrderMedLeft","UpdateBBExtCode", oeori, bbex);
		if (result != 0) {
			$.messager.alert('��ʾ','����ʧ�ܣ�ҽ��IDΪ��' + oeori,"info");
			return false;
		}
	}
	PageLogicObj.m_Win.close();
	PageLogicObj.m_Grid.reload();
	$.messager.alert('��ʾ','����ɹ�',"info");
	
}

function findConfig () {
	var admid = PageLogicObj.m_AdmBox.getValue();
	if (admid == "") {
		$.messager.alert('��ʾ','��ѡ������¼',"info");
		return false;
	}
	
	PageLogicObj.m_Grid.reload({
		ClassName : "web.DHCDocOrderMedLeft",
		QueryName : "GetOrder",
		AdmId: admid
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


