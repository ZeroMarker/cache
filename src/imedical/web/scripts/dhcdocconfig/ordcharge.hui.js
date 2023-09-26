/**
 * ordcharge.hui.js 批量修改医嘱费别
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2018-08-10
 * 
 * 注解说明
 * TABLE: DHC_Doc_OrdLinked
 */
 
//页面全局变量
var PageLogicObj = {
	m_AdmBox : "",
	m_AdmBoxGrid: "",
	m_Grid: "",
	m_IDS: "",
	m_Win: "",
	m_BBEX: ""
	
}

$(function(){
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
	
	//页面元素初始化
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
			{field:'AdmDate',title:'就诊日期',width:120},
			{field:'DepDesc',title:'科室',width:120},
			{field:'DocDesc',title:'医生',width:120},
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
		{field:'PatInfo',title:'病人信息',width:200},
		{field:'ArcimDesc',title:'医嘱名称',width:150},
		{field:'OrdStartDate',title:'开始日期',width:80},
		{field:'OrdStartTime',title:'开始时间',width:60},
		{field:'QtyPackUOM',title:'数量',width:60},
		//{field:'MedLeft',title:'是否控制剩余药量 ',width:60},	//该字段移除QP
		{field:'BBExtCode',title:'费别',width:60},
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
				text:'修改费别',
				id:'i-edit',
				iconCls: 'icon-edit'
			}
		]
	});
}

//编辑
function opDialog() {
	var selected = PageLogicObj.m_Grid.getSelections();
	if ((!selected)||(selected=="")) {
		$.messager.alert("提示","请选择一条记录...","info")
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
		title: "修改费别",
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


//保存字典信息
function saveCfg() {
	var result = 0,oeori="";
	var bbex = PageLogicObj.m_BBEX.getValue();
	if (bbex == "") {
		$.messager.alert('提示','请选择费别，谢谢！',"info");
		return false;
	}
	for (var j=0; j<PageLogicObj.m_IDS.length; j ++) {
		oeori = PageLogicObj.m_IDS[j];
		result = tkMakeServerCall("web.DHCDocOrderMedLeft","UpdateBBExtCode", oeori, bbex);
		if (result != 0) {
			$.messager.alert('提示','保存失败！医嘱ID为：' + oeori,"info");
			return false;
		}
	}
	PageLogicObj.m_Win.close();
	PageLogicObj.m_Grid.reload();
	$.messager.alert('提示','保存成功',"info");
	
}

function findConfig () {
	var admid = PageLogicObj.m_AdmBox.getValue();
	if (admid == "") {
		$.messager.alert('提示','请选择就诊记录',"info");
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


