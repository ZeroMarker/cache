/**
 * appoint.js
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-04-28
 * 
 * 
 */
var PLObject = {
	v_DefaultDate:''
}
$(function() {
	Init();
	InitEvent();
})


function Init(){
	InitGlobal();
	InitDate();
	InitGrid();
	
}

function InitEvent () {
	$("#i-find").click(Find_Handle);
	$("#i-print").click(Print_Handle)
	$("#BL").click(BL_Handle)
	//$(document.body).bind("keydown",BodykeydownHandler)
}

function InitDate() {
	$("#ChemoDate").datebox({
		value:PLObject.v_DefaultDate,
		editable:false,
		onSelect: function (date) {
			var curDate = $(this).datebox("getValue");
			Find_Handle();
		}
	})
	//$("#ChemoDate").datebox("setValue",result);
	
}
function InitGlobal () {
	var result = tkMakeServerCall("DHCDoc.Chemo.BS.Bed.Manage", "GetDefaultDate");
	PLObject.v_DefaultDate = result;
	
}

function InitGrid(){
	var columns = tkMakeServerCall("DHCDoc.Chemo.BS.Bed.AppList","GetColumns");
	var columnsArr = columns.split(String.fromCharCode(1));
	for (var i=0; i<columnsArr.length; i++) {
		var json = JSON.parse(columnsArr[i]);
		columnsArr[i] = json;
	}
	var columnsNew = [];
	columnsNew.push(columnsArr);
	
	var frozenColumns= [[
		{field:'patName',title:'姓名'},
	]]
	var DataGrid = $HUI.datagrid("#i-list", {
		fit : true,
		striped : true,
		border:false,
		singleSelect : true,
		//fitColumns : true,
		rownumbers:false,
		//autoRowHeight : false,
		pagination : true,  
		//headerCls:'panel-header-gray',
		//pageSize:14,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "DHCDoc.Chemo.BS.Bed.AppList",
			QueryName : "QryAppList",
			SelectDate:$("#ChemoDate").datebox("getValue")||""
		},
		onSelect: function (rowIndex, rowData) {
			
		},
		//frozenColumns:frozenColumns,
		toolbar:[
				{
						text:'病历',
						id:'BL',
						iconCls: 'icon-emr-cri'
				},
				{
						text:'患者费用',
						id:'i-edit',
						iconCls: 'icon-pat-fee-det'
				},{
						text:'化验结果',
						id:'i-delete',
						iconCls: 'icon-write-order'
				},{
						text:'检查结果',
						id:'i-delete',
						iconCls: 'icon-end-adm'
				}
					
		],
		columns :columnsNew
	});
	
	PLObject.m_Grid = DataGrid;
}

function Find_Handle () {
	var SelectDate = $("#ChemoDate").datebox("getValue")||""
	PLObject.m_Grid.reload({
		ClassName : "DHCDoc.Chemo.BS.Bed.AppList",
		QueryName : "QryAppList",
		SelectDate:SelectDate
	});
}

function Print_Handle () {
	var SelectDate = $("#ChemoDate").datebox("getValue")||"",IsTitle=1
	// 加载XML
	DHCP_GetXMLConfig("InvPrintEncrypt","ChemoAppointList")
	var LODOP = getLodop();
	LODOP.PRINT_INIT(""); //清除上次打印元素
	
	LODOP.ADD_PRINT_TEXT(11,23,98,19,"签名医生")
	//LODOP.ADD_PRINT_TEXT(11,23,98,19,"<table><tr><td>1</td></tr></table>")
	//LODOP.PRINT();
	var param = "SelectDate="+SelectDate+"&IsTitle="+IsTitle
	websys_printout("ChemoAppointList","isLodop=1&showPrintBtn=1&"+param,"width=830,height=660,top=20,left=100");
}

function clearConfig() {
	//PLObject.v_Arcim = "";
	//$("#i-drug").lookup("setText","");
	$("#i-drug").val("");
	findConfig();
}

function DatatLoad(){
	$.cm({
	    ClassName : PageLogicObj.m_ClassName,
	    QueryName : "FindUPLSClassProperty",
		ClsName:$("#ClassListSearch").combobox("getValue"),
	    rows:99999
	},function(GridData){
		$("#DataList").datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
		$("#DataList").datagrid("clearSelections")
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
	if (keyCode==13) {
		if(SrcObj && SrcObj.id.indexOf("i-drug")>=0){
			findConfig();
		}
		return true;
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

function BL_Handle (EpisodeID) {
	var selected = PLObject.m_Grid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择一行！", "info");
		return false;
	}
	//var EpisodeID = "";
	var lnk= "emr.record.browse.csp?"+"EpisodeID="+selected.EpisodeID;
	
	//var lnk= "websys.chartbook.hisui.csp?"+"EpisodeID="+EpisodeID;
	//lnk = lnk +"&PatientListPanel=emr.browse.episodelist.csp&PatientListPage=emr.browse.patientlist.csp&SwitchSysPat=N&ChartBookName=DHC.Doctor.DHCEMRbrowse"
	
	websys_showModal({
		url:lnk,
		iconCls: 'icon-w-list',
		title:'病历浏览',
		width:$(window).width()-100,height:$(window).height()-100
	})
	return false;
}
