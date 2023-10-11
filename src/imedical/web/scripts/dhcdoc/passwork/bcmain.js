/**
 * bcmain.js 交班本配置
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2018-08-10
 * 
 */

//页面全局变量
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
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
	
	//页面元素初始化
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
		$.messager.alert("提示","请选择交班类型！","info")
		return false;
	}
	var URL = "dhcdoc.passwork.bctime.csp?MID="+MID+"&Hosp="+Hosp;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-add',
		title:'新增班次',
		width:450,height:450,
		CallBackFunc:FindBCTime
	})
}
function TimeEditHandler () {
	var selected = PageLogicObj.m_Grid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择一行！", "info");
		return false;
	}
	var ID = selected.rowid;
	var MID = PageLogicObj.v_MID,
		Hosp = GetHospValue();
	if (MID  == "") {
		$.messager.alert("提示","请选择交班类型！","info")
		return false;
	}
	var URL = "dhcdoc.passwork.bctime.csp?MID="+MID+"&Hosp="+Hosp+"&ID="+ID
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-edit',
		title:'修改班次',
		width:450,height:450,
		CallBackFunc:FindBCTime
	})	
}

function TimeDefaultHandler () {
	var MID = PageLogicObj.v_MID,
		Hosp = GetHospValue();
	if (MID  == "") {
		$.messager.alert("提示","请选择交班类型！","info")
		return false;
	}
}

function TranslateHandler () {
	var MID = "",
		Hosp = GetHospValue();
	if (Hosp == "") {
		//$.messager.alert("提示","请选择医院！","info")
		//return false;
	}
	var URL = "dhcdoc.passwork.bctranslate.csp?MID="+MID+"&Hosp="+Hosp;
	websys_showModal({
		url:URL,
		iconCls: 'icon-translate-word',
		title:'翻译',
		width:1000,height:600,
		
	})

}

/**
 * 新增交班类型
 */
function BTAddHandler () {
	var MID = "",
		Hosp = GetHospValue();
	if (Hosp == "") {
		$.messager.alert("提示","请选择医院！","info")
		return false;
	}
	var URL = "dhcdoc.passwork.bcmain.edit.csp?MID="+MID+"&Hosp="+Hosp;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-add',
		title:'添加交班类型',
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
		$.messager.alert("提示", "请选择一行！", "info");
		return false;
	}
	var MID = selected.rowid,
		Hosp = GetHospValue();
	if (Hosp == "") {
		$.messager.alert("提示","请选择医院！","info")
		return false;
	}
	var URL = "dhcdoc.passwork.bcmain.edit.csp?MID="+MID+"&Hosp="+Hosp;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-edit',
		title:'修改交班类型',
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
 * 关联科室
 */
function BLinkLocHandler () {
	var selected = PageLogicObj.m_BTypeGrid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择一行！", "info");
		return false;
	}
	if (selected.type!="L") {
		$.messager.alert("提示", "只有【科室类型】才允许关联科室！", "info");
		return false;
	}
	
	var MID = selected.rowid,
		Hosp = GetHospValue();
	if (Hosp == "") {
		$.messager.alert("提示","请选择医院！","info")
		return false;
	}
	var URL = "dhcdoc.passwork.bcmain.loc.csp?MID="+MID+"&Hosp="+Hosp;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-edit',
		title:'关联科室',
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
		$.messager.alert("提示", "请选择一行！", "info");
		return false;
	}
	
	var MID = selected.rowid,
		Hosp = GetHospValue();
	if (Hosp == "") {
		$.messager.alert("提示","请选择医院！","info")
		return false;
	}
	var URL = "dhcdoc.passwork.bcpattype.csp?MID="+MID+"&Hosp="+Hosp;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-edit',
		title:'病人类型',
		width:950,height:500
	})
}

function BRuleHandler () {
	var selected = PageLogicObj.m_BTypeGrid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择一行！", "info");
		return false;
	}
	var MID = selected.rowid,
		Hosp = GetHospValue();
	if (Hosp == "") {
		$.messager.alert("提示","请选择医院！","info")
		return false;
	}
	var URL = "dhcdoc.passwork.bcrule.csp?MID="+MID+"&Hosp="+Hosp;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-edit',
		title:'规则配置',
		width:950,height:500
	})
}

function BTplHandler () {
	var selected = PageLogicObj.m_BTypeGrid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择一行！", "info");
		return false;
	}
	
	var MID = selected.rowid,
		Hosp = GetHospValue();
	if (Hosp == "") {
		$.messager.alert("提示","请选择医院！","info")
		return false;
	}
	var URL = "dhcdoc.passwork.bctpl.csp?MID="+MID+"&Hosp="+Hosp;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-edit',
		title:'模板定义',
		width:950,height:500
	})
}

function InitBTypeGrid () {
	var columns = [[
		{field:'typeDesc',title:'交班类型',width:100},
		{field:'desc',title:'类型描述',width:100},
		{field:'hospDesc',title:'医院',width:100,hidden:true},
        {field:'active',title:'是否激活',width:100,
            formatter:function(value,row,index){
                if (value == 1) {
                    return "<span class='c-ok'>是</span>"
                } else {
                    return "<span class='c-no'>否</span>"
                }
            }
        },
        {field:'locDesc',title:'关联科室',width:100},
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
				text:'新增',
				id:'BTAdd',
				iconCls: 'icon-add'
			},{
				text:'修改',
				id:'BTEdit',
				iconCls: 'icon-write-order'
            }
            ,{
				text:'病人类型',
				id:'BPatType',
				iconCls: 'icon-pat-add-red'
			},{
				text:'规则配置',
				id:'BRule',
				iconCls: 'icon-nail'
			},{
				text:'关联科室',
				id:'BLinkLoc',
				iconCls: 'icon-compare'
			},{
				text:'模版定义',
				id:'BTpl',
				iconCls: 'icon-cal-pen'
			}
		]
	});
	
	return DurDataGrid;
}

function InitGrid(){
	var columns = [[
		{field:'code',title:'代码',width:100},
		{field:'name',title:'班次',width:100},
		{field:'seqno',title:'第几班次',width:100},
		{field:'sTime',title:'起始时间',width:100},
		{field:'eTime',title:'结束时间',width:100},
        {field:'nextDay',title:'跨日标志',width:100,
			formatter:function(value,row,index){
                if (value == 2) {
                    return "横跨今天和明天"
                } else if (value == 1) {
                    return "单跨明天"
                } else {
					return "不跨日"
				}
            }
		},
        {field:'active',title:'是否激活',width:100,
            formatter:function(value,row,index){
                if (value == 1) {
                    return "<span class='c-ok'>是</span>"
                } else {
                    return "<span class='c-no'>否</span>"
                }
            }
        },
        {field:'note',title:'备注',width:60},
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
				text:'新增',
				id:'Time-add',
				iconCls: 'icon-add'
			},{
				text:'修改',
				id:'Time-edit',
				iconCls: 'icon-write-order'
            }/*,{
				text:'生成示例班次',
				id:'Time-Default',
				iconCls: 'icon-write-order'
            }*/
		]
	});
	
	return DurDataGrid;
}

//查找
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
	//浏览器中Backspace不可用  
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

