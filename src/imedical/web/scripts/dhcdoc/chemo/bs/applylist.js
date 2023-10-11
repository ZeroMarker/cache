/**
 * audit.js
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
	//InitCombox()
	InitGrid();
	
}

function InitEvent () {
	
	//$("#Find").click(findConfig);
	//$("#Clear").click(clearConfig)
	//document.onkeydown = DocumentOnKeyDown;
}
function PageHandle() {
	
}
function InitCombox() {
	PLObject.m_OrderLoc = $HUI.combobox("#orderLoc", {
		url:$URL+"?ClassName=DHCDoc.Chemo.COM.Qry&QueryName=QryGetdep&ResultSetType=array",
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
	
	PLObject.m_OrderDoc = $HUI.combobox("#orderDoc", {
		url:$URL+"?ClassName=DHCDoc.Chemo.COM.Qry&QueryName=QryHisDoc&ResultSetType=array",
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

function Cancel_Handle (PDAID,LinkPDAID) {
	
	$.messager.confirm("提示", "您确认撤销么？",function (r) {
		if (r) {
		
			
			$m({
					ClassName: "DHCDoc.Chemo.BS.Ext.Plan",
					MethodName: "CancelChemoPlan",
					PDAID:PDAID,
					LinkPDAID:LinkPDAID,
					UserID: session['LOGON.USERID'],
					InLoc: session['LOGON.CTLOCID'],
					type:"text"
				},function(result){
					var resultArr = result.split("^")
					if(resultArr[0]==0){
						$.messager.alert("提示",resultArr[1],"warning");
						findConfig();
						return false;
					}else{
						$.messager.alert("提示",resultArr[1],"warning");
						return false;
					}
			});
		}
		
	})
	
	
	
	
	
	
	
}

function InitGrid(){
	
	var mList = ServerObj.Type+"^"+session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+0+"^"+session['LOGON.HOSPID']
	
	var columns = [[
		{field:'PLName',title:'方案',width:100},
		{field:'patName',title:'姓名',width:100},
		{field:'appUser',title:'申请医生',width:100},
		{field:'appLoc',title:'申请科室',width:100},
		{field:'appDT',title:'申请时间',width:100},
		{field:'chemoDate',title:'化疗日期',width:100},
		{field:'statusDesc',title:'状态',width:100},
		{field:'LinkPDAID',title:'LinkPDAID',width:50,hidden:false},
		{field:'id',title:'id',width:100,hidden:false}
		/*{field:'action',title:'操作',width:50,align:'center',
			formatter:function(value,row,index){
				var s = '<span style="color:#40A2DE;cursor:pointer;" onclick="Cancel_Handle(' + "'" +row.id+ "','"+row.LinkPDAID+"'"+ ')">撤销</span>';
				return s;
			}
		},*/
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
		//pageSize:14,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "DHCDoc.Chemo.BS.Ext.Audit",
			QueryName : "QryList",
			mList:mList
		},
		onSelect: function (rowIndex, rowData) {
			
		},
		onLoadSuccess : function (data) {
		},
		columns :columns,
		toolbar:[
				
					
		]
	});
	
	PLObject.m_Grid = DataGrid;
}

function seeDetail (PLID,PatientID,EpisodeID) {
	var URL = "chemo.bs.nurse.csp?PLID="+PLID+"&EpisodeID="+EpisodeID+"&PatientID="+PatientID;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-list',
		title:'化疗单明细',
		width:$(window).width()-100,height:$(window).height()-100
	})
}

function findConfig () {
	var mList = ServerObj.Type+"^"+session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+0+"^"+session['LOGON.HOSPID']
	
	PLObject.m_Grid.reload({
		ClassName : "DHCDoc.Chemo.BS.Ext.Audit",
		QueryName : "QryList",
		mList: mList
	});
}


function clearConfig() {
	$("#patNo").val("");
	$("#patName").val("");
	$("#startDate").datebox("setValue");
	$("#endDate").datebox("setValue")
	PLObject.m_OrderLoc.clear()
	PLObject.m_OrderDoc.clear();
	$("#planName").val("");
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