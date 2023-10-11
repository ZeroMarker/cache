/**
 * find.js
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-04-28
 * 
 * 
 */
 $(function() {
	Init();
	InitEvent();
	//PageHandle();
})


function Init(){
	InitCombox()
	InitGrid();
	InitDefault();
	
}

function InitEvent () {
	
	$("#Find").click(findConfig);
	$("#Clear").click(clearConfig)
	document.onkeydown = DocumentOnKeyDown;
}
function PageHandle() {
	setTimeout(function(){
		$(".m-button").linkbutton({
			plain:true,
			iconCls:'icon-search'
			
		});
	},100)
}
function InitDefault () {
	setTimeout(function(){
		PLObject.m_OrderLoc.select(session['LOGON.CTLOCID']);
	},200)
}
function InitCombox() {
	PLObject.m_OrderLoc = $HUI.combobox("#orderLoc", {
		url:$URL+"?ClassName=DHCDoc.Chemo.COM.Qry&QueryName=QryGetdep&InHosp="+session['LOGON.HOSPID']+"&ResultSetType=array",
		valueField:'id',
		textField:'text',
		blurValidValue:true,
		mode:'remote',
		onBeforeLoad:function(param){
			param.Desc = param["q"];
		},
		onSelect: function (r) {
			/* PLObject.m_OrderDoc = $HUI.combobox("#orderDoc", {
				url:$URL+"?ClassName=DHCDoc.Chemo.COM.Qry&QueryName=QryHisDoc&LocId="+r.id+"&ResultSetType=array",
				valueField:'id',
				textField:'text',
				blurValidValue:true,
				mode:'remote',
				onBeforeLoad:function(param){
					param.Desc = param["q"];
				}
			}); */
			var url = $URL+"?ClassName=DHCDoc.Chemo.COM.Qry&QueryName=QryHisDoc&LocId="+r.id+"&ResultSetType=array";
			PLObject.m_OrderDoc.reload(url);
		},
		onHidePanel:function () {
			var val = $(this).combobox("getValue")||""
			if (val == "") {
					var url=$URL+"?ClassName=DHCDoc.Chemo.COM.Qry&QueryName=QryHisDoc&InHosp="+session['LOGON.HOSPID']+"&LocId=&ResultSetType=array";
					PLObject.m_OrderDoc.reload(url)
			}
		}
	});
	
	PLObject.m_OrderDoc = $HUI.combobox("#orderDoc", {
		url:$URL+"?ClassName=DHCDoc.Chemo.COM.Qry&QueryName=QryHisDoc&InHosp="+session['LOGON.HOSPID']+"&ResultSetType=array",
		valueField:'id',
		textField:'text',
		blurValidValue:true,
		mode:'remote',
		onBeforeLoad:function(param){
			param.Desc = param["q"];
		},
		onSelect: function () {
			
		}
	});
	
}

function InitGrid(){
	var PatNo = "",
		PatName = "",
		StartDate = "",
		EndDate = "",
		OrderLoc = session['LOGON.CTLOCID'],
		OrderDoc = "",
		PlanName = "",
		SP = String.fromCharCode(1);
	var ParaList = PatNo + SP + PatName + SP + StartDate + SP + EndDate + SP + OrderLoc + SP + OrderDoc + SP + PlanName;
	var columns = [[
		{field:'PatName',title:'姓名',width:100},
		{field:'PatNo',title:'登记号',width:100},
		{field:'PLName',title:'化疗方案',width:100},
		{field:'DepDesc',title:'科室',width:100},
		{field:'UserName',title:'医生',width:100},
		{field:'Status',title:'方案状态',width:100},
		{field:'StatusCode',title:'方案状态代码',width:100,hidde:true},
		{field:'PLDate',title:'生成日期',width:100},
		{field:'PLTime',title:'生成时间',width:100},
		{field:'Detail',title:'明细',width:100,
			formatter:function(value,row,index){
				var s = '<a class="hisui-linkbutton m-button" data-options="iconCls:'+"'icon-icon-attachment'"+'" style="color:#40A2DE;" onclick="seeDetail(' + row.id + ", '" + row.StatusCode + "', '" + row.PatDR + "', '" + row.Adm + "'" + ')"></a>';
				return s;
			}
		},
		{field:'id',title:'id',width:100,hidden:true}
	]]
	var DataGrid = $HUI.datagrid("#i-list", {
		fit : true,
		striped : false,
		border:false,
		singleSelect : true,
		fitColumns : true,
		rownumbers:false,
		//autoRowHeight : false,
		pagination : true,  
		//headerCls:'panel-header-gray',
		//pageSize:14,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "DHCDoc.Chemo.BS.Find",
			QueryName : "QryPlan",
			ParaList: ParaList,
			InHosp:session['LOGON.HOSPID']
		},
		onSelect: function (rowIndex, rowData) {
			
		},
		onLoadSuccess : function (data) {
			PageHandle();
		},
		columns :columns
	});
	
	PLObject.m_Grid = DataGrid;
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
	var PatNo = $.trim($("#patNo").val());
	var PatName = $.trim($("#patName").val());
	var StartDate = $("#startDate").datebox("getValue")||"";
	var EndDate = $("#endDate").datebox("getValue")||"";
	var OrderLoc = PLObject.m_OrderLoc.getValue()||"";
	var OrderDoc = PLObject.m_OrderDoc.getValue()||"";
	var PlanName = $.trim($("#planName").val());
	var SP = String.fromCharCode(1);
	var ParaList = PatNo + SP + PatName + SP + StartDate + SP + EndDate + SP + OrderLoc + SP + OrderDoc + SP + PlanName;
	
	PLObject.m_Grid.reload({
		ClassName : "DHCDoc.Chemo.BS.Find",
		QueryName : "QryPlan",
		ParaList: ParaList,
		InHosp:session['LOGON.HOSPID']
	});
}


function clearConfig() {
	$("#patNo").val("");
	$("#patName").val("");
	$("#startDate").datebox("setValue");
	$("#endDate").datebox("setValue")
	//PLObject.m_OrderLoc.clear()
	PLObject.m_OrderLoc.select(session['LOGON.CTLOCID']);
	PLObject.m_OrderDoc.clear();
	$("#planName").val("");
	var url=$URL+"?ClassName=DHCDoc.Chemo.COM.Qry&QueryName=QryHisDoc&InHosp="+session['LOGON.HOSPID']+"&LocId=&ResultSetType=array";
	PLObject.m_OrderDoc.reload(url)
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