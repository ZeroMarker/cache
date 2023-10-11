/**
 * patguide.hui.js ���ﵥ����HUI
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2018-08-10
 * 
 */
 
//ҳ��ȫ�ֱ���
var PageLogicObj = {
	m_MainGrid : "",
	m_CenterGrd: "",
	m_CenterWin: "",
	m_seclectId: "",
	cenValue: "",
	cenType: ""
}

$(function(){
	var hospComp = GenHospComp("Doc_Config_PatGuide");
	hospComp.jdata.options.onSelect = function(e,t){
		ShowTip();
		InitFind();
		InitMainGrid();
		//�¼���ʼ��
		InitLeftEvent();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		//��ʼ��
		Init();
		//�¼���ʼ��
		InitEvent();
	}
})

function Init(){
	//init���ﵥ����
	ShowTip();
	InitFind();
	InitMainGrid();
	InitCenterGrid();
	InitArcimList();
}
function InitEvent(){
	InitLeftEvent();
	InitRightEvent();
}
function InitLeftEvent(){
	//���ﵥ��������¼�
	$("#i-find").click(findPatGuide);
	$("#dg1-add").click(function () { dg1Dialog("add"); });
	$("#dg1-edit").click(function () { dg1Dialog("edit"); });
	$("#dg1-delete").click(dg1Delete);
}
function InitRightEvent(){
	//��ܰ��ʾ����¼�
	$("#center-add").click(function(){centerDialog("add")});
	$("#center-edit").click(function(){centerDialog("edit")});
	$("#center-delete").click(function(){deleteCenter()});
	$(document.body).bind("keydown",BodykeydownHandler);
}
function InitFind () {
	//��������
	PageLogicObj.m_find_ordLoc = $HUI.combobox("#i-ordLoc", {
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.PatGuide&QueryName=QryLoc&ResultSetType=array&HospID="+$HUI.combogrid('#_HospList').getValue(),
		valueField:'id',
		textField:'desc',
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

	//���ܿ���
	PageLogicObj.m_find_acceptLoc = $HUI.combobox("#i-acceptLoc", {
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.PatGuide&QueryName=QryLoc&ResultSetType=array&HospID="+$HUI.combogrid('#_HospList').getValue(),
		valueField:'id',
		textField:'desc',
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
}
 /**
 * CTOR: QP
 * DESC: ��ʼ�����ﵥ����
 * DATE: 2018-09-13
 * NOTE: 
 */
function InitMainGrid(){
	//����
	PageLogicObj.m_PrjType = $HUI.combobox("#i-type", {
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.PatGuide&QueryName=QryPrjType&ResultSetType=array",
		valueField:'code',
		textField:'desc'
	})

	var columns = [[
		{field:'PGTypeDesc',title:'����',width:100},
		{field:'PGPrj',title:'��Ŀ',width:100},
		{field:'PGOrdLocDesc',title:'��������',width:100},
		{field:'PGAcceptLocDesc',title:'���տ���',width:100},
		{field:'PGSTime',title:'��ʼʱ��',width:100},
		{field:'PGETime',title:'����ʱ��',width:100},
		{field:'PGSite',title:'����λ��',width:100}/*,
		{field:'PGIsDetail',title:'��ʾ��ϸ',width:100,
			formatter:function(value,row,index){
				if (value == 1) {
					return "<span class='c-ok'>��</span>"
				} else {
					return "<span class='c-no'>��</span>"
				}
			}
		}*/
	]];
	
	PageLogicObj.m_MainGrid = $HUI.datagrid("#i-mGrid", {
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		rownumbers:true,
		pagination : true,  
		headerCls:'panel-header-gray',
		columns :columns,
		url:$URL,
		queryParams:{
			ClassName : "DHCDoc.DHCDocConfig.PatGuide",
			QueryName : "QryPatGuide",
			inType: "",
			HospID:$HUI.combogrid('#_HospList').getValue()
		},
		toolbar:[{
				text:'����',
				id:'dg1-add',
				iconCls: 'icon-add'
			},{
				text:'�޸�',
				id:'dg1-edit',
				iconCls: 'icon-write-order'
			},{
				text:'ɾ��',
				id:'dg1-delete',
				iconCls: 'icon-cancel'
			}
		],

	});
}
/**
 * ���ﵥ���ã�ɾ��
 */
function dg1Delete () {
	var selected = PageLogicObj.m_MainGrid.getSelected();
	if (!selected) {
		$.messager.alert("��ʾ","��ѡ��һ����¼��","info")
		return false;
	};
	//ɾ��
	$.m({
		ClassName:"DHCDoc.DHCDocConfig.PatGuide",
		MethodName:"DBDelete",
		PGId:selected.PGId
	},function (responseText){
		if(responseText == 0) {
			$.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
			PageLogicObj.m_MainGrid.reload();
		} else {
			$.messager.alert('��ʾ', 'ɾ��ʧ��,�������: '+ responseText , "info");
			return false;
		}	
	})

}
/**
 * ���ﵥ���ã�����/�޸�
 * @param {*} ac :�������޸�/����
 */
function dg1Dialog(ac) {
	var selected = PageLogicObj.m_MainGrid.getSelected();
	if (( ac == "edit")&&(!selected)) {
		$.messager.alert("��ʾ","��ѡ��һ����¼��","info")
		return false;
	};
	if($('#dg1').hasClass("c-hidden")) {
		$('#dg1').removeClass("c-hidden");
	};
	var _title = "�޸�", _icon="icon-w-edit";

	//����
	PageLogicObj.m_dg1_type = $HUI.combobox("#dg1-type", {
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.PatGuide&QueryName=QryPrjType&ResultSetType=array",
		valueField:'code',
		textField:'desc',
		onSelect: function (record) {
			var inType = record.code;
			var OECatDR = "";
			PageLogicObj.m_dg1_oecat.clear();
			PageLogicObj.m_dg1_prj.clear();
			$('#dg1-arcitem').val("");
			$('#dg1-arcitem').combogrid("options").value=""
			if (inType == "OEARCItem") {
				$('#dg1-arcitem').combogrid('enable');
				PageLogicObj.m_dg1_oecat.disable();
				PageLogicObj.m_dg1_prj.disable();
			} else {
				$('#dg1-arcitem').combogrid('disable');
				PageLogicObj.m_dg1_oecat.enable();
				PageLogicObj.m_dg1_prj.enable();
			};
			if (inType == "OECatItem") {
				PageLogicObj.m_dg1_oecat.enable();
			} else {
				PageLogicObj.m_dg1_oecat.disable();
			};
			var url = $URL+"?ClassName=DHCDoc.DHCDocConfig.PatGuide&QueryName=QryPrjDesc&inType="+inType+"&OECatDR="+OECatDR+"&ResultSetType=array&HospID="+$HUI.combogrid('#_HospList').getValue();
			PageLogicObj.m_dg1_prj.reload(url);
		}
	})
	//ҽ������
	PageLogicObj.m_dg1_oecat = $HUI.combobox("#dg1-oecat", {
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.PatGuide&QueryName=QryPrjDesc&inType=OECat&ResultSetType=array&HospID="+$HUI.combogrid('#_HospList').getValue(),
		valueField:'id',
		disabled:true,
		textField:'desc',
		onSelect: function (record) {
			PageLogicObj.m_dg1_prj.clear();
			var inType = PageLogicObj.m_dg1_type.getValue()||"";
			var OECatDR = record.id;
			var url = $URL+"?ClassName=DHCDoc.DHCDocConfig.PatGuide&QueryName=QryPrjDesc&inType="+inType+"&OECatDR="+OECatDR+"&ResultSetType=array&HospID="+$HUI.combogrid('#_HospList').getValue();
			PageLogicObj.m_dg1_prj.reload(url);
		}
	})

	//��Ŀ
	PageLogicObj.m_dg1_prj = $HUI.combobox("#dg1-prj", {
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.PatGuide&QueryName=QryPrjDesc&inType=&ResultSetType=array&HospID="+$HUI.combogrid('#_HospList').getValue(),
		valueField:'id',
		textField:'desc'
	})

	//��������
	PageLogicObj.m_dg1_ordLoc = $HUI.combobox("#dg1-ordLoc", {
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.PatGuide&QueryName=QryLoc&ResultSetType=array&HospID="+$HUI.combogrid('#_HospList').getValue(),
		valueField:'id',
		textField:'desc',
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

	//���ܿ���
	PageLogicObj.m_dg1_acceptLoc = $HUI.combobox("#dg1-acceptLoc", {
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.PatGuide&QueryName=QryLoc&ResultSetType=array&HospID="+$HUI.combogrid('#_HospList').getValue(),
		valueField:'id',
		textField:'desc',
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
	if (ac == "add") {
		$("#dg1-action").val("add");
		$("#dg1-id").val("");
		PageLogicObj.m_dg1_type.clear();
		PageLogicObj.m_dg1_prj.clear();
		PageLogicObj.m_dg1_oecat.clear();
		PageLogicObj.m_dg1_ordLoc.clear();
		PageLogicObj.m_dg1_acceptLoc.clear();
		$("#dg1-site").val("");
		$("#dg1-isDetail").checkbox("uncheck");
		$("#dg1-etime").timespinner("clear");
		$("#dg1-stime").timespinner("clear");
		$('#dg1-arcitem').combogrid("setText","");
		$('#dg1-arcitem').combogrid("options").value=""
		$('#dg1-arcitem').combogrid("setValue","");
		_title = "����", _icon="icon-w-add";
	} else {
		$("#dg1-action").val("edit");
		$("#dg1-id").val(selected.PGId);
		var inType = selected.PGType;
		var OECatDR = selected.OECat;
		PageLogicObj.m_dg1_type.setValue(selected.PGType);
		if (inType == "OEARCItem") {
				$('#dg1-arcitem').combogrid('enable');
				PageLogicObj.m_dg1_oecat.disable();
				PageLogicObj.m_dg1_prj.disable();
				$('#dg1-arcitem').combogrid("setValue",selected.PGPrjDR);
				$('#dg1-arcitem').combogrid("setText",selected.PGPrj);
				
				$('#dg1-arcitem').combogrid("options").value=selected.PGPrjDR
			} else {
				$('#dg1-arcitem').combogrid("setText","");
				$('#dg1-arcitem').combogrid("options").value=""
				$('#dg1-arcitem').combogrid("setValue","");
				$('#dg1-arcitem').combogrid('disable');
				PageLogicObj.m_dg1_oecat.enable();
				PageLogicObj.m_dg1_prj.enable();
				var url = $URL+"?ClassName=DHCDoc.DHCDocConfig.PatGuide&QueryName=QryPrjDesc&inType="+inType+"&OECatDR="+OECatDR+"&ResultSetType=array&HospID="+$HUI.combogrid('#_HospList').getValue();
				PageLogicObj.m_dg1_prj.reload(url);
				PageLogicObj.m_dg1_prj.setValue(selected.PGPrjDR);
			};
		//����ҽ������
		if (selected.PGType == "OECatItem") {
			PageLogicObj.m_dg1_oecat.enable();
			PageLogicObj.m_dg1_oecat.setValue(selected.OECat);
		}else {
			PageLogicObj.m_dg1_oecat.disable();
		}
		//������Ŀ
		var inType = selected.PGType;
		var OECatDR = selected.OECat;

		PageLogicObj.m_dg1_ordLoc.setValue(selected.PGOrdLoc);
		PageLogicObj.m_dg1_acceptLoc.setValue(selected.PGAcceptLoc);
		$("#dg1-site").val(selected.PGSite);
		if (selected.PGIsDetail==1) $("#dg1-isDetail").checkbox("check");
		else $("#dg1-isDetail").checkbox("uncheck");
		$("#dg1-etime").timespinner("setValue", selected.PGETime);
		$("#dg1-stime").timespinner("setValue", selected.PGSTime);

	}

	PageLogicObj.m_dg1Win = $HUI.window('#dg1', {
		title: _title,
		iconCls: _icon,
		modal: true,
		minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
		onClose: function () {
			$('#dg1').addClass("c-hidden");
		}
	});
}

function ShowTip () {
	$("#i-tip").removeClass("c-hidden");
	$("#i-search").removeClass("c-hidden");
}

/**
 * ���浼�ﵥ����
 */
function saveDG1 () {
	var ac = $("#dg1-action").val();
	var id = $("#dg1-id").val();
	var type = PageLogicObj.m_dg1_type.getValue()||"";
	var prj = PageLogicObj.m_dg1_prj.getValue()||"";
	var ordLoc = PageLogicObj.m_dg1_ordLoc.getValue()||"";
	var acceptLoc = PageLogicObj.m_dg1_acceptLoc.getValue()||"";
	var stime = $("#dg1-stime").timespinner("getValue")||"";
	var etime = $("#dg1-etime").timespinner("getValue")||"";
	var site = $.trim( $("#dg1-site").val() );
	var isDetail = 0; //$("#dg1-isDetail").checkbox("getValue")?1:0;
	var HospID=$HUI.combogrid('#_HospList').getValue();
	var ArcimRowid = $('#dg1-arcitem').combogrid('getValue'); 
	if (ArcimRowid!="") prj=ArcimRowid
	var inPara = id + "^" + type + "^" + prj + "^" + ordLoc + "^" + acceptLoc + "^" + stime;
	inPara = inPara + "^" + etime + "^" + site + "^" + isDetail +"^"+ HospID;
	if (type == "") {
		$.messager.alert("��ʾ","��ѡ�����ͣ�","info")
		return false;
	}
	if (prj == "") {
		$.messager.alert("��ʾ","��ѡ����Ŀ��","info")
		return false;
	}
	var msg = "����"
	if (ac == "edit") msg = "�޸�";
	//����
	$.m({
		ClassName:"DHCDoc.DHCDocConfig.PatGuide",
		MethodName:"DBSave",
		inPara:inPara
	},function (responseText){
		if(responseText > 0) {
			$.messager.popover({msg: msg + '�ɹ���',type:'success',timeout: 1000});
			PageLogicObj.m_dg1Win.close();
			PageLogicObj.m_MainGrid.reload();
			
		} else {
			$.messager.alert('��ʾ', msg + 'ʧ��,�������: '+ responseText , "info");
			return false;
		}	
	})
}

/**
 * ���ﵥ����-��ѯ
 */
function findPatGuide () {
	var inType = PageLogicObj.m_PrjType.getValue()||"";
	var inText = PageLogicObj.m_PrjType.getText()||"";
	if (inType != "") {
		inType = inType + "^" + inText;
	}
	var inOrdLoc = PageLogicObj.m_find_ordLoc.getValue()||"";
	var inAcceptLoc = PageLogicObj.m_find_acceptLoc.getValue()||"";
	PageLogicObj.m_MainGrid.reload({
		ClassName : "DHCDoc.DHCDocConfig.PatGuide",
			QueryName : "QryPatGuide",
			inType: inType,
			inOrdLoc:inOrdLoc,
			inAcceptLoc:inAcceptLoc,
			HospID:$HUI.combogrid('#_HospList').getValue()
	});
}

function setCenTitle(title) {
	 var centerPanel = $('#i-layout').layout('panel','center');
	 centerPanel.panel('setTitle', "���ﵥ����-" + title);
}

function hideButton(code) {
	var bol = (code != "itemPnt")&&(code != "ordItem")&&(code != "noDispalyOrd")
    var button=$('div.datagrid div.datagrid-toolbar a'); 
    for (var i = 0; i < button.length; i++) {
        var toolbar = button[i];
        var id = toolbar.id;
        if ((id == "center-edit")&&(!bol)) {
            $('div.datagrid div.datagrid-toolbar a').eq(i).hide();
        } else {
			$('div.datagrid div.datagrid-toolbar a').eq(i).show();
		}
    }
}

/**
 * NUMS: C003
 * CTOR: QP
 * DESC: �м�-ģ�����������б�
 * DATE: 2018-09-13
 * NOTE: �����ĸ�������InitCenterGrid��centerDialog��deleteCenter��saveCenter
 * TABLE: 
 */
 //ģ�����������б�
function InitCenterGrid(){
	var columns = [[
		{field:'typeDesc',title:'ҽԺ',width:100},
		{field:'desc',title:'��ܰ��ʾ',width:200},
		{field:'id',title:'ID',width:60,hidden:true}
    ]]
	var DurDataGrid = $HUI.datagrid("#i-c-grid", {
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		rownumbers:true,
		//autoRowHeight : false,
		pagination : false,  
		headerCls:'panel-header-gray',
		//pageSize:14,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "DHCDoc.DHCDocConfig.PatGuide",
			QueryName : "QryTip"
		},
		columns :columns,
		toolbar:[{
				text:'����',
				id:'center-add',
				iconCls: 'icon-add'
			},{
				text:'�޸�',
				id:'center-edit',
				iconCls: 'icon-write-order'
			},{
				text:'ɾ��',
				id:'center-delete',
				iconCls: 'icon-cancel'
			}
		]
	});
	PageLogicObj.m_CenterGrd = DurDataGrid;
}

function centerDialog (ac) {
	var selected = PageLogicObj.m_CenterGrd.getSelected();
	if (( ac == "edit")&&(!selected)) {
		$.messager.alert("��ʾ","��ѡ��һ����¼��","info")
		return false;
	}
	
	if($('#cen').hasClass("c-hidden")) {
		$('#cen').removeClass("c-hidden");
	};

	//ҽԺ
	PageLogicObj.m_dg2_hosp = $HUI.combobox("#cen-hosp", {
		//url:$URL+"?ClassName=DHCDoc.DHCDocConfig.PatGuide&QueryName=QryHosp&ResultSetType=array",
		url:$URL+"?ClassName=DHCDoc.Common.Hospital&QueryName=GetHospDataForCloud&ResultSetType=array&tablename=Doc_Config_PatGuide",
		valueField:'HOSPRowId', //id
		textField:'HOSPDesc' //desc
	})
	
	var _title = "�޸�",_icon="icon-w-edit"
	if (ac == "add") {
		if (PageLogicObj.m_dg2_hosp != "") {
			PageLogicObj.m_dg2_hosp.enable();
		}
		$("#cen-action").val("add");
		$("#cen-id").val("")
		_title = "����",_icon="icon-w-add";
		$("#cen-tip").val("")
	} else {
		$("#cen-action").val("edit");
		$("#cen-id").val(selected.id);
		$("#cen-tip").val(selected.desc);
		if (PageLogicObj.m_dg2_hosp != "") {
			PageLogicObj.m_dg2_hosp.setValue(selected.id);
			PageLogicObj.m_dg2_hosp.disable();
		}
		
	}
	
	var cenWin = $HUI.window('#cen', {
		title: _title,
		iconCls: _icon,
		modal: true,
		minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
		onClose: function () {
			$('#cen').addClass("c-hidden");
		}
	});
	PageLogicObj.m_CenterWin = cenWin;
}

function saveCenter () {
	var id = $("#cen-id").val();
	var action = $("#cen-action").val();
	var hosp = PageLogicObj.m_dg2_hosp.getValue()||"";
	var desc = $("#cen-tip").val();
	if (hosp == "") {
		$.messager.alert("��ʾ","��ѡ��ҽԺ��","info")
		return false;
	}
	if (action == "add") {
		var rtn = tkMakeServerCall("DHCDoc.DHCDocConfig.PatGuide","HasTip", hosp);
		if (rtn == 1) {
			$.messager.alert("��ʾ","�������Ѵ��ڣ�","warning");
			return false;
		}
	}
	var rtn = tkMakeServerCall("DHCDoc.DHCDocConfig.PatGuide","DBSaveTip", hosp, desc);
	if (rtn == 0) {
		PageLogicObj.m_CenterWin.close();
		PageLogicObj.m_CenterGrd.reload();
		$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
	} else {
		$.messager.alert("��ʾ","����ʧ�ܣ�","info")
	}
	
}

function deleteCenter () {
	var selected = PageLogicObj.m_CenterGrd.getSelected();
	if (!selected) {
		$.messager.alert("��ʾ","��ѡ��һ����¼...","info")
		return false;
	}
	var id = selected.id;
	var rtn = tkMakeServerCall("DHCDoc.DHCDocConfig.PatGuide","DBDeleteTip", id);
	if (rtn == 0) {
		$.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
		PageLogicObj.m_CenterGrd.reload();
	} else {
		$.messager.alert("��ʾ","ɾ��ʧ�ܣ�","info")
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
function InitArcimList()
{
	$('#dg1-arcitem').combogrid({
		panelWidth:500,
		panelHeight:400,
		delay: 500,    
		mode: 'remote',    
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.ItemOrderQtyLimit&QueryName=FindItem",
		//url:$URL+"?ClassName=DHCDoc.DHCDocConfig.ArcItemConfig&QueryName=FindAllItem",
		fitColumns: true,   
		striped: true,   
		editable:true,   
		pagination : true,//�Ƿ��ҳ   
		rownumbers:true,//���   
		collapsible:false,//�Ƿ���۵���   
		fit: true,//�Զ���С   
		pageSize: 10,//ÿҳ��ʾ�ļ�¼������Ĭ��Ϊ10   
		pageList: [10],//��������ÿҳ��¼�������б�   
		method:'post', 
		idField: 'ArcimRowID',    
		textField: 'ArcimDesc',    
		columns: [[    
			{field:'ArcimDesc',title:'����',width:400,sortable:true},
			{field:'ArcimRowID',title:'ID',width:120,sortable:true},
			{field:'selected',title:'ID',width:120,sortable:true,hidden:true}
		]],
		onSelect: function (){
			var selected = $('#dg1-arcitem').combogrid('grid').datagrid('getSelected');  
			if (selected) { 
			  $('#dg1-arcitem').combogrid("options").value=selected.ArcimRowID;
			}
		 },
		 onBeforeLoad:function(param){
             var desc=param['q'];
             var HospId=$HUI.combogrid('#_HospList').getValue();
             param = $.extend(param,{Alias:param["q"],HospId:HospId});
         }
	});
};


