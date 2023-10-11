/**
 * bcmain.js ���౾����
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2018-08-10
 * 
 */

//ҳ��ȫ�ֱ���
var PageLogicObj = {
	v_MID:"",	//
	m_CHosp:"",
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
	InitCache();
})

function Init(){
	InitHospList();
	PageLogicObj.m_Grid = InitGrid();
	PageLogicObj.m_BTypeGrid = InitBTypeGrid();
}
function InitEvent(){
	$("#BTAdd").click(BTAddHandler);
	$("#BTEdit").click(BTEditHandler);
	$("#BLinkLoc").click(BLinkLocHandler);
	$("#BPatType").click(BPatTypeHandler);
	$("#BRule").click(BRuleHandler);
	$("#BTpl").click(BTplHandler);
	$("#Time-add").click(TimeAddHandler);
	$("#Time-edit").click(TimeEditHandler);
	$("#Translate").click(TranslateHandler);
	//$("#Time-Default").click(TimeDefaultHandler);
	
	$(document.body).bind("keydown",BodykeydownHandler)
}

function PageHandle(){
	
}

function TimeAddHandler () {
	var MID = PageLogicObj.v_MID,
		Hosp = GetHospValue();
	if (MID  == "") {
		$.messager.alert("��ʾ","��ѡ�񽻰����ͣ�","info")
		return false;
	}
	var URL = "dhcdoc.passwork.bctime.csp?MID="+MID+"&Hosp="+Hosp;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-add',
		title:'�������',
		width:450,height:450,
		CallBackFunc:FindBCTime
	})
}
function TimeEditHandler () {
	var selected = PageLogicObj.m_Grid.getSelected();
	if (!selected) {
		$.messager.alert("��ʾ", "��ѡ��һ�У�", "info");
		return false;
	}
	var ID = selected.rowid;
	var MID = PageLogicObj.v_MID,
		Hosp = GetHospValue();
	if (MID  == "") {
		$.messager.alert("��ʾ","��ѡ�񽻰����ͣ�","info")
		return false;
	}
	var URL = "dhcdoc.passwork.bctime.csp?MID="+MID+"&Hosp="+Hosp+"&ID="+ID
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-edit',
		title:'�޸İ��',
		width:450,height:450,
		CallBackFunc:FindBCTime
	})	
}

function TimeDefaultHandler () {
	var MID = PageLogicObj.v_MID,
		Hosp = GetHospValue();
	if (MID  == "") {
		$.messager.alert("��ʾ","��ѡ�񽻰����ͣ�","info")
		return false;
	}
}

function TranslateHandler () {
	var MID = "",
		Hosp = GetHospValue();
	if (Hosp == "") {
		//$.messager.alert("��ʾ","��ѡ��ҽԺ��","info")
		//return false;
	}
	var URL = "dhcdoc.passwork.bctranslate.csp?MID="+MID+"&Hosp="+Hosp;
	websys_showModal({
		url:URL,
		iconCls: 'icon-translate-word',
		title:'����',
		width:1000,height:600,
		
	})

}

/**
 * ������������
 */
function BTAddHandler () {
	var MID = "",
		Hosp = GetHospValue();
	if (Hosp == "") {
		$.messager.alert("��ʾ","��ѡ��ҽԺ��","info")
		return false;
	}
	var URL = "dhcdoc.passwork.bcmain.edit.csp?MID="+MID+"&Hosp="+Hosp;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-add',
		title:'��ӽ�������',
		width:370,height:400,
		CallBackFunc: function (NID) {
			FindBType();
			setTimeout(function () {
				PageLogicObj.m_BTypeGrid.selectRecord(NID);
			},100)
		}
	})
}

function BTEditHandler() {
	var selected = PageLogicObj.m_BTypeGrid.getSelected();
	if (!selected) {
		$.messager.alert("��ʾ", "��ѡ��һ�У�", "info");
		return false;
	}
	var MID = selected.rowid,
		Hosp = GetHospValue();
	if (Hosp == "") {
		$.messager.alert("��ʾ","��ѡ��ҽԺ��","info")
		return false;
	}
	var URL = "dhcdoc.passwork.bcmain.edit.csp?MID="+MID+"&Hosp="+Hosp;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-edit',
		title:'�޸Ľ�������',
		width:370,height:400,
		CallBackFunc:function () {
			FindBType();
			setTimeout(function () {
				PageLogicObj.m_BTypeGrid.selectRecord(PageLogicObj.v_MID);
			},100)
			
		}
	})
}


function FindBType () {
	PageLogicObj.m_BTypeGrid.reload({
		ClassName : "DHCDoc.PW.CFG.BCMain",
		QueryName : "QryBCMain",
		InHosp: GetHospValue()
	});
}

/**
 * ��������
 */
function BLinkLocHandler () {
	var selected = PageLogicObj.m_BTypeGrid.getSelected();
	if (!selected) {
		$.messager.alert("��ʾ", "��ѡ��һ�У�", "info");
		return false;
	}
	if (selected.type!="L") {
		$.messager.alert("��ʾ", "ֻ�С��������͡�������������ң�", "info");
		return false;
	}
	
	var MID = selected.rowid,
		Hosp = GetHospValue();
	if (Hosp == "") {
		$.messager.alert("��ʾ","��ѡ��ҽԺ��","info")
		return false;
	}
	var URL = "dhcdoc.passwork.bcmain.loc.csp?MID="+MID+"&Hosp="+Hosp;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-edit',
		title:'��������',
		width:570,height:600,
		CallBackFunc:FindBType,
		onClose:function () {
			FindBType()
		}
	})
}

function BPatTypeHandler () {
	var selected = PageLogicObj.m_BTypeGrid.getSelected();
	if (!selected) {
		$.messager.alert("��ʾ", "��ѡ��һ�У�", "info");
		return false;
	}
	
	var MID = selected.rowid,
		Hosp = GetHospValue();
	if (Hosp == "") {
		$.messager.alert("��ʾ","��ѡ��ҽԺ��","info")
		return false;
	}
	var URL = "dhcdoc.passwork.bcpattype.csp?MID="+MID+"&Hosp="+Hosp;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-edit',
		title:'��������',
		width:950,height:500
	})
}

function BRuleHandler () {
	var selected = PageLogicObj.m_BTypeGrid.getSelected();
	if (!selected) {
		$.messager.alert("��ʾ", "��ѡ��һ�У�", "info");
		return false;
	}
	var MID = selected.rowid,
		Hosp = GetHospValue();
	if (Hosp == "") {
		$.messager.alert("��ʾ","��ѡ��ҽԺ��","info")
		return false;
	}
	var URL = "dhcdoc.passwork.bcrule.csp?MID="+MID+"&Hosp="+Hosp;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-edit',
		title:'��������',
		width:950,height:500
	})
}

function BTplHandler () {
	var selected = PageLogicObj.m_BTypeGrid.getSelected();
	if (!selected) {
		$.messager.alert("��ʾ", "��ѡ��һ�У�", "info");
		return false;
	}
	
	var MID = selected.rowid,
		Hosp = GetHospValue();
	if (Hosp == "") {
		$.messager.alert("��ʾ","��ѡ��ҽԺ��","info")
		return false;
	}
	var URL = "dhcdoc.passwork.bctpl.csp?MID="+MID+"&Hosp="+Hosp;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-edit',
		title:'ģ�嶨��',
		width:950,height:500
	})
}

function InitBTypeGrid () {
	var columns = [[
		{field:'typeDesc',title:'��������',width:100},
		{field:'desc',title:'��������',width:100},
		{field:'hospDesc',title:'ҽԺ',width:100,hidden:true},
        {field:'active',title:'�Ƿ񼤻�',width:100,
            formatter:function(value,row,index){
                if (value == 1) {
                    return "<span class='c-ok'>��</span>"
                } else {
                    return "<span class='c-no'>��</span>"
                }
            }
        },
        {field:'locDesc',title:'��������',width:100},
        {field:'rowid',title:'ID',width:60,hidden:true}
    ]]
	var DurDataGrid = $HUI.datagrid("#BType", {
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		rownumbers:true,
		//autoRowHeight : false,
		pagination : false,  
		idField:"rowid",
		headerCls:'panel-header-gray',
		//pageSize:14,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "DHCDoc.PW.CFG.BCMain",
			QueryName : "QryBCMain",
			InHosp:session['LOGON.HOSPID']
		},
		onSelect:function(index,data){
			PageLogicObj.v_MID = data.rowid;
			FindBCTime(data.rowid)
		},
		columns :columns,
		toolbar:[{
				text:'����',
				id:'BTAdd',
				iconCls: 'icon-add'
			},{
				text:'�޸�',
				id:'BTEdit',
				iconCls: 'icon-write-order'
            }
            ,{
				text:'��������',
				id:'BPatType',
				iconCls: 'icon-pat-add-red'
			},{
				text:'��������',
				id:'BRule',
				iconCls: 'icon-nail'
			},{
				text:'��������',
				id:'BLinkLoc',
				iconCls: 'icon-compare'
			},{
				text:'ģ�涨��',
				id:'BTpl',
				iconCls: 'icon-cal-pen'
			}
		]
	});
	
	return DurDataGrid;
}

function InitGrid(){
	var columns = [[
		{field:'code',title:'����',width:100},
		{field:'name',title:'���',width:100},
		{field:'seqno',title:'�ڼ����',width:100},
		{field:'sTime',title:'��ʼʱ��',width:100},
		{field:'eTime',title:'����ʱ��',width:100},
        {field:'nextDay',title:'���ձ�־',width:100,
			formatter:function(value,row,index){
                if (value == 2) {
                    return "�����������"
                } else if (value == 1) {
                    return "��������"
                } else {
					return "������"
				}
            }
		},
        {field:'active',title:'�Ƿ񼤻�',width:100,
            formatter:function(value,row,index){
                if (value == 1) {
                    return "<span class='c-ok'>��</span>"
                } else {
                    return "<span class='c-no'>��</span>"
                }
            }
        },
        {field:'note',title:'��ע',width:60},
        {field:'rowid',title:'ID',width:60,hidden:true}
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
			ClassName : "DHCDoc.PW.CFG.BCTime",
			QueryName : "QryBCTime",
			InMID:""
		},
		onUnselect:function(){
		},
		columns :columns,
		toolbar:[{
				text:'����',
				id:'Time-add',
				iconCls: 'icon-add'
			},{
				text:'�޸�',
				id:'Time-edit',
				iconCls: 'icon-write-order'
            }/*,{
				text:'����ʾ�����',
				id:'Time-Default',
				iconCls: 'icon-write-order'
            }*/
		]
	});
	
	return DurDataGrid;
}

//����
function FindBCTime (InMID) {
	PageLogicObj.m_Grid.reload({
		ClassName : "DHCDoc.PW.CFG.BCTime",
		QueryName : "QryBCTime",
		InMID: InMID||PageLogicObj.v_MID
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


function GetHospValue() {
	if (PageLogicObj.m_CHosp == "") {
		return session['LOGON.HOSPID'];
	}
	
	return PageLogicObj.m_CHosp
}

function InitHospList()
{
	var hospComp = GenHospComp("Doc_BaseConfig_CNMedCode");
	hospComp.jdata.options.onSelect = function(rowIndex,data){
		PageLogicObj.m_BTypeGrid.clearSelections();
		PageLogicObj.m_CHosp = data.HOSPRowId;
		PageLogicObj.v_MID = "";
		FindBType();
		FindBCTime();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		//Init();
	}
}

function InitCache () {
	var hasCache = $.DHCDoc.ConfigHasCache();
	if (hasCache!=1) {
		$.DHCDoc.CacheConfigPage();
		$.DHCDoc.storageConfigPageCache();
	}
}

