/**
 * find.js
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-04-28
 * 
 * 
 */
var PageLogicObj = {
	v_DefaultDate:""
}
$(function() {
	Init();
	InitEvent();
	//PageHandle();
})


function Init(){
	InitCombox();
	InitDefault();
	InitGrid();
	InitLocGrid();
	
}

function InitEvent () {
	
	$("#Find").click(findConfig);
	$("#Clear").click(clearConfig)
	document.onkeydown = DocumentOnKeyDown;
}
function PageHandle() {
}
function InitDefault () {
	var result = $cm({
		ClassName:"DHCDoc.Chemo.BS.Bed.Manage",
		MethodName:"GetDefaultDate",
		dataType:"text"
	},false);
	PageLogicObj.v_DefaultDate = result;
	$("#StartDate").datebox("setValue",result)
	$("#EndDate").datebox("setValue",result)
}

function InitCombox() {
	PageLogicObj.m_Hosp = $HUI.combobox("#Hosp", {
		url:$URL+"?ClassName=DHCDoc.PW.COM.Query&QueryName=QryHosp&ResultSetType=array",
		valueField:'id',
		textField:'text',
		disabled:true,
		value:session['LOGON.HOSPID'],
		blurValidValue:true

	});
}
function InitGrid(){
	var columns = [[
		{field:'ShowDate',title:'日期',width:100},
		{field:'AMCount',title:'上午预约数量',width:100},
		{field:'PMCount',title:'下午预约数量',width:100},
		{field:'id',title:'id',width:100,hidden:true}
	]]
	var DataGrid = $HUI.datagrid("#i-list", {
		fit : true,
		striped : true,
		border:false,
		singleSelect : true,
		fitColumns : true,
		rownumbers:false,
		//autoRowHeight : false,
		pagination : true,  
		//headerCls:'panel-header-gray',
		pageSize:20,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "DHCDoc.Chemo.BS.Bed.Manage",
			QueryName : "AppointNum",
			StartDate: PageLogicObj.v_DefaultDate,
			EndDate:   PageLogicObj.v_DefaultDate,
			InHosp: session['LOGON.HOSPID'],
			IsCount:1
		},
		onSelect: function (rowIndex, rowData) {
			//if (rowData.id!="") {
				if (rowData.IsTotalRow==1) {
					FindLocConfig("total")
				} else {
					FindLocConfig(rowData.ShowDate)
				}
				
			//}
		},
		onLoadSuccess : function (data) {
			PageHandle();
		},
		columns :columns
	});
	
	PageLogicObj.m_Grid = DataGrid;
}

function InitLocGrid(){
	var columns = [[
		{field:'ShowDate',title:'日期',width:100},
		{field:'BAdmLocDesc',title:'科室',width:100},
		{field:'AMCount',title:'上午预约数量',width:100},
		{field:'PMCount',title:'下午预约数量',width:100},
		{field:'BAdmLoc',title:'id',width:100,hidden:true}
	]]
	var DataGrid = $HUI.datagrid("#Loclist", {
		fit : true,
		striped : true,
		border:false,
		singleSelect : true,
		fitColumns : true,
		rownumbers:false,
		//autoRowHeight : false,
		pagination : true,  
		//headerCls:'panel-header-gray',
		pageSize:20,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "DHCDoc.Chemo.BS.Bed.Manage",
			QueryName : "LocAppointNum",
			InDate: ""
		},
		onSelect: function (rowIndex, rowData) {
			
		},
		onLoadSuccess : function (data) {
			PageHandle();
		},
		columns :columns
	});
	
	PageLogicObj.m_LocGrid = DataGrid;
}

function seeDetail (PLID,StatusCode,PatientID,EpisodeID) {
	var URL = "chemo.bs.nurse.csp?PLID="+PLID+"&EpisodeID="+EpisodeID+"&PatientID="+PatientID+"&StatusCode="+StatusCode;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-list',
		title:'化疗单明细',
		width:$(window).width()-100,height:$(window).height()-100
	})
}

function findConfig () {
	
	var StartDate = $("#StartDate").datebox("getValue")||"";
	var EndDate = $("#EndDate").datebox("getValue")||"";
	if (StartDate=="") {
		$.messager.alert('提示',"开始日期不能为空！","warning");
		return false;
	}
	if (EndDate=="") {
		$.messager.alert('提示',"结束日期不能为空！","warning");
		return false;
	}
	PageLogicObj.m_Grid.reload({
		ClassName : "DHCDoc.Chemo.BS.Bed.Manage",
		QueryName : "AppointNum",
		StartDate: StartDate,
		EndDate:   EndDate,
		InHosp: session['LOGON.HOSPID'],
		IsCount:1
	});
}

function FindLocConfig (InDate) {
	var 
		StartDate = "",
		EndDate = "";
	
	if (InDate=="total") {
		var StartDate = $("#StartDate").datebox("getValue")||"";
		var EndDate = $("#EndDate").datebox("getValue")||"";
		if (StartDate=="") {
			$.messager.alert('提示',"开始日期不能为空！","warning");
			return false;
		}
		if (EndDate=="") {
			$.messager.alert('提示',"结束日期不能为空！","warning");
			return false;
		}
	}
	
	PageLogicObj.m_LocGrid.reload({
		ClassName : "DHCDoc.Chemo.BS.Bed.Manage",
		QueryName : "LocAppointNum",
		InDate: InDate,
		InHosp: session['LOGON.HOSPID'],
		StartDate: StartDate,
		EndDate:   EndDate
	});
}


function clearConfig() {
	
	$("#StartDate").datebox("setValue",PageLogicObj.v_DefaultDate);
	$("#EndDate").datebox("setValue",PageLogicObj.v_DefaultDate)
	FindLocConfig("")
	findConfig();
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
		if(SrcObj && SrcObj.id.indexOf("patNo")>=0){
			var PatNo=$('#patNo').val();
			//if (PatNo=="") return;
			if ((PatNo.length<11)&&(PatNo!="")) {
				for (var i=(10-PatNo.length-1); i>=0; i--) {
					PatNo="0"+PatNo;
				}
			}
			$('#patNo').val(PatNo);
			findConfig();
			return false;
		}
		if(SrcObj && SrcObj.id.indexOf("planName")>=0){
			findConfig();
			return false;
		}
		if(SrcObj && SrcObj.id.indexOf("patName")>=0){
			findConfig();
			return false;
		}
		return true;
	}
}