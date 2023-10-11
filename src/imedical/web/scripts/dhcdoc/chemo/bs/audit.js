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
	InitDate();
	InitGrid();
	SetButton();
	LoadDept();
	
}

function SetButton() {
	var AgreeOPT = $("#Agree").linkbutton('options');
	var RefuseOPT = $("#Refuse").linkbutton('options');
	AgreeOPT.stopAllEventOnDisabled=true;	
	RefuseOPT.stopAllEventOnDisabled=true;
}

function InitDate() {
	var result = $cm({
		ClassName:"DHCDoc.Chemo.COM.Func2",
		MethodName:"GetDateboxDefaultDate",
		dataType:"text"
	},false);
	PLObject.v_DefaultDate = result;
	$("#startDate").datebox("setValue",result)
	$("#endDate").datebox("setValue",result)
}

function InitEvent () {
	
	$("#Find").click(findConfig);
	$("#Clear").click(clearConfig)
	$("#Agree").click(Agree_Handler)
	$("#Refuse").click(Refuse_Handler)
	$("#HasPass").checkbox({
		onChecked:function () {
			$("#Agree").linkbutton('disable');
			$("#Refuse").linkbutton('disable');
			findConfig()
		},
		onUnchecked: function () {
			$("#Agree").linkbutton('enable');
			$("#Refuse").linkbutton('enable');
			findConfig()
		}
	})
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

function InitGrid(){
	var mList = ServerObj.Type+"^"+session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+0+"^"+session['LOGON.HOSPID'];
	var columns = [[
		{field:'patName',title:'姓名',width:100},
		{field:'appUser',title:'申请医生',width:100},
		{field:'appLoc',title:'申请科室',width:100},
		{field:'appDT',title:'申请时间',width:100},
		{field:'PLName',title:'方案名称',width:200},
		{field:'LinkDate',title:'化疗日期',width:100},
		{field:'statusDesc',title:'状态',width:100},
		{field:'Detail',title:'化疗单明细',width:100,
			formatter:function(value,row,index){
				var s = '<a class="hisui-linkbutton m-button" data-options="iconCls:'+"'icon-icon-attachment'"+'" style="color:#40A2DE;" onclick="seeDetail(' + row.PLID + ", '" + row.LinkPDAID + "', '" + row.id  + "', '" + row.patientDR + "', '" + row.admid + "', '" + row.chemoDate + "'" + ')"></a>';
				return s;
			}
		},
		{field:'LinkPDAID',title:'LinkPDAID',width:50,hidden:true},
		{field:'id',title:'id',width:50,hidden:true}
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
			StartDate:PLObject.v_DefaultDate,
			EndDate: PLObject.v_DefaultDate,
			mList: mList
			
		},
		onSelect: function (rowIndex, rowData) {
			
		},
		onLoadSuccess : function (data) {
			PageHandle();
		},
		columns :columns,
		onDblClickRow: function(rowIndex, rowData) {
			//' + row.PLID + ", '" + row.LinkPDAID + "', '" + row.id  + "', '" + row.patientDR + "', '" + row.admid 
			seeDetail (rowData.PLID,rowData.LinkPDAID,rowData.id,rowData.patientDR,rowData.admid,rowData.chemoDate) 	
		},
		toolbar:[
				{
						text:'同意',
						id:'Agree',
						iconCls: 'icon-stamp'
				},
				{
						text:'拒绝',
						id:'Refuse',
						iconCls: 'icon-audit-x'
				}
					
		]
	});
	
	PLObject.m_Grid = DataGrid;
}

function seeDetail (PLID,LinkPDAID,PDAID,PatientID,EpisodeID,ChemoDate) {
	var PTW = $(top).width();
	var PH = $(window.parent.window).height();	//$(window).height()
	var PTH = $(top).height();
	
	var URL = "chemo.bs.nurse.csp?PLID="+PLID+"&EpisodeID="+EpisodeID+"&PatientID="+PatientID+"&PDAID="+PDAID+"&ChemoDate="+ChemoDate+"&LinkPDAID="+LinkPDAID+"&Type="+ServerObj.Type;
	//alert(URL)
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-list',
		title:'化疗单明细',
		maximizable:true,
		//maximized:true,
		width:PTW,height:PTH,
		CallBackFunc:findConfig
	})
}

function findConfig () {
	
	var StartDate = $("#startDate").datebox("getValue")||"";
	var EndDate = $("#endDate").datebox("getValue")||"";
	var HasPass = $("#HasPass").checkbox("getValue")?1:0;
	//var LocID=$("#RLocdesc").combobox('getValue')
	var mList = ServerObj.Type+"^"+session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+HasPass+"^"+session['LOGON.HOSPID'];
	//var mList = ServerObj.Type+"^"+session['LOGON.USERID']+"^"+LocID+"^"+HasPass;
	PLObject.m_Grid.reload({
		ClassName : "DHCDoc.Chemo.BS.Ext.Audit",
		QueryName : "QryList",
		StartDate: StartDate,
		EndDate: EndDate,
		mList: mList
	});
}

function Agree_Handler() {
	var selected = PLObject.m_Grid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择一行！", "info");
		return false;
	}
	
	if (ServerObj.Type=="KS") {
		if (selected.status == "S") {
			$.messager.alert("提示", "已同意了此方案!", "info");
			return false;
		} else if (selected.status == "RS") {
			$.messager.alert("提示", "已拒绝了此方案!", "info");
			return false;
		} else {}
	} else if (ServerObj.Type=="YJK") {
		if (selected.status == "Y") {
			$.messager.alert("提示", "已同意了此方案!", "info");
			return false;
		} else if (selected.status == "RY") {
			$.messager.alert("提示", "已拒绝了此方案!", "info");
			return false;
		} else {}
	} else {}
	
	
	var PDAID = selected.id
	var LinkPDAID = selected.LinkPDAID
	var Status=""
	if (ServerObj.Type=="KS") {
		Status="S"	
	} else {
		Status="Y"	
	}
	var mList=Status+"^"+session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID'];
	
	$m({
		ClassName:"DHCDoc.Chemo.BS.Ext.Audit",
		MethodName:"Verify",
		PDAID:PDAID,
		Type:ServerObj.Type,
		mList: mList,
		LinkPDAID:LinkPDAID
	}, function(result){
		if (result == 0) {
			$.messager.alert("提示", "保存成功！", "info", function () {
				findConfig();
			})
		} else {
			$.messager.alert("提示", "保存失败：" + result , "info");
			return false;
		}
	});
	
			
	
	
	
}
function Refuse_Handler() {
	var selected = PLObject.m_Grid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择一行！", "info");
		return false;
	}
	
	if (ServerObj.Type=="KS") {
		if (selected.status == "S") {
			$.messager.alert("提示", "已同意了此方案!", "info");
			return false;
		} else if (selected.status == "RS") {
			$.messager.alert("提示", "已拒绝了此方案!", "info");
			return false;
		} else {}
	} else if (ServerObj.Type=="YJK") {
		if (selected.status == "Y") {
			$.messager.alert("提示", "已同意了此方案!", "info");
			return false;
		} else if (selected.status == "RY") {
			$.messager.alert("提示", "已拒绝了此方案!", "info");
			return false;
		} else {}
	} else {}
	
	var PDAID=selected.id;
	var LinkPDAID = selected.LinkPDAID
	var URL = "chemo.bs.audit.refuse.csp?PDAID="+PDAID+"&Type="+ServerObj.Type+"&LinkPDAID="+LinkPDAID;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-edit',
		title:'拒绝',
		width:570,height:500,
		CallBackFunc:Callback_Refuse
	})
}

function Callback_Refuse() {
	findConfig();	
}

function clearConfig() {
	$("#startDate").datebox("setValue","");
	$("#endDate").datebox("setValue","");
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
function LoadDept(){
	$.cm({
		ClassName:"web.DHCExamPatList",
		QueryName:"ctloclookup",
	   	desc:"",
		rows:99999
	},function(GridData){
		var cbox = $HUI.combobox("#RLocdesc", {
				valueField: 'ctlocid',
				textField: 'ctloc', 
				editable:true,
				data: GridData["rows"],
				filter: function(q, row){
					return (row["ctloc"].toUpperCase().indexOf(q.toUpperCase()) >= 0) ||(row["Alias"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				},
				onSelect: function(rec){  
					LoadDoc(); 
					LoadWard(); 
				},
				onChange:function(newValue,oldValue){
					if (newValue==""){
						LoadDoc();
						LoadWard();
					}
				}
		 });
	});
}