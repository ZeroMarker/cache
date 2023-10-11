/**
 * ordtoord.hui.js ����ҽ���迪����/����ҽ������
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
	m_ArcimCombox : "",
	m_SearchGrid: "",
	m_DiagArcimCombox: "",
	m_DiagArcimGrid: "",
	m_NeedArcimCombox: "",
	m_NeedArcimGrid: "",
	m_DurDataGrid : "",
	m_SDateBox : "",
	m_EDateBox : "",
	m_Win : "",
	m_TarcimIDOld: "",
	m_TlinkArcimIDOld: ""
	
}
$(function(){
	InitHospList();	
	//ҳ��Ԫ�س�ʼ��
	//PageHandle();
	InitCache();
})
function InitCache(){
	var hasCache = $.DHCDoc.ConfigHasCache();
	if (hasCache!=1) {
		$.DHCDoc.CacheConfigPage();
		$.DHCDoc.storageConfigPageCache();
	}
}
function InitHospList()
{
	var hospComp = GenHospComp("DHC_Doc_OrdLinked");
	hospComp.jdata.options.onSelect = function(e,t){
		PageLogicObj.m_ArcimCombox.grid().datagrid('loadData',{total:0,rows:[]});
		PageLogicObj.m_ArcimCombox.setValue("");
		findConfig();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		//��ʼ��
		Init();
		//�¼���ʼ��
		InitEvent();
	}
}
function Init(){
	PageLogicObj.m_DurDataGrid = InitDurDataGrid();
	//ҽ������
	PageLogicObj.m_ArcimCombox = $HUI.combogrid("#i-aricm", {
		panelWidth: 500,
		delay:500,
		mode:'remote',
		idField: 'ArcimDR',
		textField: 'ArcimDesc',
		columns: [[
			{field:'ArcimDesc',title:'��Ŀ����',width:100},
			{field:'ArcimDR',title:'��ĿID',width:30}
		]],
		pagination : true,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CommonFunction&QueryName=FindMasterItem&arcimdesc=",
		fitColumns: true,
		enterNullValueClear:true,
		onBeforeLoad:function(param){
			if (param['q']) {
				var desc=param['q'];
			}
			param = $.extend(param,{arcimdesc:desc,HospId:$HUI.combogrid('#_HospList').getValue()});
		}
	});
	PageLogicObj.m_SearchGrid = PageLogicObj.m_ArcimCombox.grid();
	//
	PageLogicObj.m_DiagArcimCombox = $HUI.combogrid("#i-diag-arcim", {
		panelWidth: 500,
		idField: 'ArcimDR',
		textField: 'ArcimDesc',
		delay:500,
		mode:'remote',
		columns: [[
			{field:'ArcimDesc',title:'��Ŀ����',width:100},
			{field:'ArcimDR',title:'��ĿID',width:30}
		]],
		pagination : true,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CommonFunction&QueryName=FindMasterItem",
		fitColumns: true,
		enterNullValueClear:false,
		onBeforeLoad:function(param){
			if (param['q']) {
				var desc=param['q'];
			}
			param = $.extend(param,{arcimdesc:desc,HospId:$HUI.combogrid('#_HospList').getValue()});
		}
	});
	PageLogicObj.m_DiagArcimGrid = PageLogicObj.m_DiagArcimCombox.grid();
	
	//
	PageLogicObj.m_NeedArcimCombox = $HUI.combogrid("#i-diag-needarcim", {
		panelWidth: 500,
		idField: 'ArcimDR',
		textField: 'ArcimDesc',
		delay:500,
		mode:'remote',
		columns: [[
			{field:'ArcimDesc',title:'��Ŀ����',width:100},
			{field:'ArcimDR',title:'��ĿID',width:30}
		]],
		pagination : true,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CommonFunction&QueryName=FindMasterItem",
		fitColumns: true,
		enterNullValueClear:false,
		onBeforeLoad:function(param){
			if (param['q']) {
				var desc=param['q'];
			}
			param = $.extend(param,{arcimdesc:desc,HospId:$HUI.combogrid('#_HospList').getValue()});
		}
	});
	PageLogicObj.m_NeedArcimGrid = PageLogicObj.m_NeedArcimCombox.grid();
}
function InitEvent(){
	$("#i-find").click(findConfig);
	$("#i-add").click(function(){opDialog("add")});
	$("#i-edit").click(function(){opDialog("edit")});
	$("#i-delete").click(function(){deConfig()});
	$(document.body).bind("keydown",BodykeydownHandler)
}

function PageHandle(){
	//
}

function InitDurDataGrid(){
	//TABLE: DHCDocIPBDictory
	var columns = [[
		{field:'TArcimDesc',title:'ҽ����',width:200},
		{field:'TlinkArcimDesc',title:'�迪ҽ����',width:200},
		{field:'TStDate',title:'��ʼ����',width:60},
		{field:'TEndDate',title:'��������',width:60},
		{field:'LRowid',title:'ID',width:60,hidden:true}
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
			ClassName : "web.DHCDocOrdLinkContr",
			QueryName : "FindOrdLink",
			arcimID: "",
			HospId:$HUI.combogrid('#_HospList').getValue()
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
	var selected = PageLogicObj.m_DurDataGrid.getSelected();
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
		$("#i-id").val(selected.Rowid);
		tempValue = selected.TArcimDesc;
		tempValue2 = selected.TlinkArcimDesc;
		PageLogicObj.m_TlinkArcimIDOld = selected.TlinkArcimID;
		PageLogicObj.m_TarcimIDOld = selected.TarcimID;
	}
	
	if($('#i-dialog').hasClass("c-hidden")) {
		$('#i-dialog').removeClass("c-hidden");
	};
	
	
	
	//����
	var sDateBox = $HUI.datebox("#i-diag-sdate",{
		//required:true  
	});
	
	var eDateBox = $HUI.datebox("#i-diag-edate",{
		//required:true  
	});
	PageLogicObj.m_NeedArcimCombox.grid().datagrid("loadData",{"total":0,"rows":[]});
	PageLogicObj.m_DiagArcimCombox.grid().datagrid("loadData",{"total":0,"rows":[]});
	PageLogicObj.m_SDateBox = sDateBox;
	PageLogicObj.m_EDateBox = eDateBox;
	if (action == "add") {
		sDateBox.setValue("");
		eDateBox.setValue("");
		PageLogicObj.m_NeedArcimCombox.setValue("");
		PageLogicObj.m_DiagArcimCombox.setValue("");
		$("#i-id").val("");
		$("#i-action").val("add");
	} else {
		$("#i-id").val(selected.LRowid);
		$("#i-action").val("edit");
		sDateBox.setValue(selected.TStDate);
		eDateBox.setValue(selected.TEndDate);
		//setTimeout(function () {
			PageLogicObj.m_NeedArcimCombox.setValue(selected.TlinkArcimID);
			PageLogicObj.m_NeedArcimCombox.setText(selected.TlinkArcimDesc);
			PageLogicObj.m_DiagArcimCombox.setValue(selected.TarcimID);
			PageLogicObj.m_DiagArcimCombox.setText(selected.TArcimDesc);
		//},800)
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
	var selected = PageLogicObj.m_DurDataGrid.getSelected();
	if (!selected) {
		$.messager.alert("��ʾ","��ѡ��һ����¼��","info")
		return false;
	}
	$.messager.confirm("��ʾ", "ȷ��ɾ����", function(r) {
		if (r){
			$.m({
					ClassName:"web.DHCDocOrdLinkContr",
					MethodName:"LinkOrdDel",
					arcim: selected.TarcimID,
					linkarcim:selected.TlinkArcimID,
					LRowid:selected.LRowid
				},function (responseText){
					if(responseText == 0) {
						$.messager.alert('��ʾ','ɾ���ɹ���',"info");
						PageLogicObj.m_DurDataGrid.reload();
					} else {
						$.messager.alert('��ʾ','�޸�ʧ��,�������: '+ responseText , "info");
						return false;
					}	
				})
		}
	})
}


//�����ֵ���Ϣ
function saveCfg() {
	var id = $("#i-id").val();
	var action = $("#i-action").val();
	var arcim = PageLogicObj.m_DiagArcimCombox.getValue();
	if (arcim==undefined) arcim="";
	var needarcim = PageLogicObj.m_NeedArcimCombox.getValue();
	if (needarcim==undefined) needarcim="";
	var sDate = PageLogicObj.m_SDateBox.getValue();
	var eDate = PageLogicObj.m_EDateBox.getValue();
	var paraStr = id + "^" + arcim + "^" + needarcim + "^" + sDate + "^" + eDate
	
	if (arcim == "") {
		$.messager.alert('��ʾ','ҽ�����Ϊ��!',"info");
		return false;
	}
	if (needarcim == "") {
		$.messager.alert('��ʾ','�迪ҽ�����Ϊ��!',"info");
		return false;
	}
	if (sDate == "") {
		$.messager.alert('��ʾ','��ʼʱ�䲻��Ϊ��!',"info");
		return false;
	}
	if (arcim == needarcim) {
		$.messager.alert('��ʾ','�迪ҽ�����ҽ����Ŀ������ͬ!',"info");
		return false;
	}
	//LinkOrdInsert,LinkOrdUpdate,LinkOrdDel
	var methodName = "LinkOrdUpdate";
	if (action == "add") {
		methodName = "LinkOrdInsert";
		$.m({
			ClassName:"web.DHCDocOrdLinkContr",
			MethodName:methodName,
			arcim:arcim,
			linkarcim:needarcim,
			stdate:sDate,
			enddate:eDate,
			HospId:$HUI.combogrid('#_HospList').getValue()
		},function (responseText){
			if(responseText == 0) {
				$.messager.popover({msg: '�����ɹ���',type:'success',timeout: 1000});
				PageLogicObj.m_Win.close();
				PageLogicObj.m_DurDataGrid.reload();
			} else {
				$.messager.alert('��ʾ','����ʧ��,�������: '+ responseText , "info");
				return false;
			}	
		})
	} else {
		$.m({
			ClassName:"web.DHCDocOrdLinkContr",
			MethodName:methodName,
			arcim:arcim,
			linkarcim:needarcim,
			stdate:sDate,
			enddate:eDate,
			TarcimIDOld:PageLogicObj.m_TarcimIDOld,
			TlinkArcimIDOld:PageLogicObj.m_TlinkArcimIDOld,
			LRowid:id
		},function (responseText){
			if(responseText == 0) {
				$.messager.alert('��ʾ','�޸ĳɹ���',"info");
				PageLogicObj.m_Win.close();
				PageLogicObj.m_DurDataGrid.reload();
				
			} else {
				$.messager.alert('��ʾ','�޸�ʧ��,�������: '+ responseText , "info");
				return false;
			}	
		})
	}
}
function findConfig () {
	//var text = PageLogicObj.m_ArcimCombox.getText();
	var arcimID = PageLogicObj.m_ArcimCombox.getValue();
	
	PageLogicObj.m_DurDataGrid.reload({
		ClassName : "web.DHCDocOrdLinkContr",
		QueryName : "FindOrdLink",
		arcimID: arcimID,
		HospId:$HUI.combogrid('#_HospList').getValue()
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

