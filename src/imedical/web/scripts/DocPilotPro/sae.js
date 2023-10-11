/**
 * audit.js
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-04-28
 * 
 * 
 */
var PLObject = {
	
}
$(function() {
	Init();
	InitEvent();
	//PageHandle();
})


function Init(){
	var mRtn = InitMask();
	if (!mRtn) {return true;}
	InitCombox()
	InitGrid();
	//PageHandle();
	//SetButton();
	//LoadDept();
	
}
function InitMask() {
	if (ServerObj.Type=="U") {
		var result = $cm({
			ClassName:"DHCDoc.GCP.CFG.Auth",
			MethodName:"HasSAEAuth",
			InHosp:session['LOGON.HOSPID'],
			InGroup:session['LOGON.GROUPID'],
			InLoc:session['LOGON.CTLOCID'],
			InUser:session['LOGON.USERID'],
			dataType:"text"
		},false);
		if (result==0) {
			showMask("#i-layout","<span style='color:#F06D55;font-size:20px;'>你无权审核！</span>")
			return false
		}
	}
	return true;
}

function showMask(id,msg){
	//$("<div class=\"datagrid-mask\"></div>").css({display:"block",width:"100%",height:$(window).height()}).appendTo("body"); 
    //$("<div class=\"datagrid-mask-msg\"></div>").html("正在处理，请稍候。。。").appendTo("body").css({display:"block",left:($(document.body).outerWidth(true) - 190) / 2,top:($(window).height() - 45) / 2});
    if (msg!="") {
		msg="<label style='color:#509DE1;'>"+msg+"</lable>" ;  
	}
    $("<div class=\"datagrid-mask\"></div>").css({display:"block",width:$(document).width(),height:$(id).height()}).appendTo(id); 
    $("<div class=\"datagrid-mask-msg\"></div>").html(msg).appendTo(id).css({display:"block",left:($(document).outerWidth(true)-100) / 2,top:($(document).height() - 45) / 2}); 
}
function hideMask(){
    $(".datagrid-mask").hide();
    $(".datagrid-mask-msg").hide();
}


function SetButton() {
	var AgreeOPT = $("#Agree").linkbutton('options');
	var RefuseOPT = $("#Refuse").linkbutton('options');
	AgreeOPT.stopAllEventOnDisabled=true;	
	RefuseOPT.stopAllEventOnDisabled=true;
}

function InitCombox() {
	var data = [],defaultVal=[];
	if (ServerObj.Type=="A") {
		data = [
			{id:'N',text:$g('新建')},
			{id:'A',text:$g('申请')},
			{id:'R',text:$g('拒绝')},
			{id:'U',text:$g('同意')}
		]
	} else {
		defaultVal=["A"]
		data = [
			{id:'A',text:$g('申请')},
			{id:'R',text:$g('拒绝')},
			{id:'U',text:$g('同意')}
		]
	}
	PLObject.AEStatus_Box = $HUI.combobox("#AEStatus",{
		valueField:'id',
		textField:'text',
		multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
		data:data,
		value:defaultVal
	});
	
	PLObject.AEReportType_Box = $HUI.combobox("#AEReportType",{
		valueField:'id',
		textField:'text',
		multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'F',text:$g('首次报告')},
			{id:'V',text:$g('随访报告')},
			{id:'S',text:$g('总结报告')}
		]
	});
	
		
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
	$("#Add").click(Add_Handler)
	$("#SeeDetail").click(function(){SeeDetail_Handler("","")})
	$("#Find").click(findConfig);
	$("#Clear").click(clearConfig)
	$("#Apply").click(function(){Apply_Handler("A")})
	$("#Agree").click(function(){Apply_Handler("U")})
	$("#Refuse").click(function(){Apply_Handler("R")})
	$("#Update").click(function(){SeeDetail_Handler("","")})
	return
	
	document.onkeydown = DocumentOnKeyDown;
}
function PageHandle() {
	if (ServerObj.Type=="A") {Add_Handler();}
	
}

function InitGrid(){
	var frozenColumns = [[
		
	]]
	var columns = [[
		{field:'EpisodeID',title:'',checkbox:true},
		{field:'AEStatus',title:'报告状态',width:100,
			styler: function(value,row,index){
				if (row.AEStatusCode == "R"){
					return 'background-color:#f16e57;color:#fff;';
				} else if (row.AEStatusCode == "U") {
					return 'background-color:#21ba45;color:#fff;';
				} else if (row.AEStatusCode == "N") {
					return 'background-color:#FF9C00;color:#fff;';
				} else if (row.AEStatusCode == "A") {
					return 'background-color:#0C8EB9;color:#fff;';
				} else {}
			}

		},
		{field:'Action',title:'链接',width:80,align:'left',
			formatter: function(value,row,index){
				var mRtn = '<a class="editcls c-blue" onclick="SeeDetail_Handler(\'' + row["rowid"] + '\',\''+row["AEStatusCode"]+'\')">'+$g("详")+'</a>';
				mRtn = mRtn+'<a class="editcls c-red" onclick="Process_Handler(\'' + row["rowid"] + '\',\''+row["AEStatusCode"]+'\')">'+$g("审")+'</a>';
				/*if (row["AEStatusCode"] == "R") {
					mRtn = mRtn+'<a class="editcls c-red" onclick="Apply_Handler(\'' + "A" + '\',\''+row["AEStatusCode"]+'\')">申</a>';
				}*/
				return mRtn;
				//return '<a class="editcls" onclick="SeeDetail_Handler(\'' + row["rowid"] + '\',\''+row["AEStatusCode"]+'\')">详</a>';
				
			}
		},
		{field:'AEReportType',title:'报告类型',width:100},
		{field:'AEReportDate',title:'报告日期',width:100},
		{field:'AEPatientSpell',title:'受试者姓名',width:100},
		{field:'AESex',title:'受试者性别',width:100},
		{field:'AEDrugNameZN',title:'试验用药中文名',width:150},
		{field:'AEDrugNameEN',title:'试验用药英文名',width:150},
		//{field:'AEStage',title:'期别',width:50},
		{field:'AEUser',title:'报告人',width:100},
		{field:'AEAddLoc',title:'报告科室',width:100},
		{field:'AENote',title:'拒绝原因',width:250},
		{field:'AEAuditUser',title:'审核人',width:100},
		{field:'AEAuditDate',title:'审核日期',width:150},
		
		{field:'rowid',title:'rowid',width:50,hidden:true}
	]]
	var toolbar = [],InStatus="";
	if (ServerObj.Type=="A") {
		toolbar = [
				{
						text:'填报',
						id:'Add',
						iconCls: 'icon-add'
				},
				{
						text:'修改',
						id:'Update',
						iconCls: 'icon-write-order'
				},
				{
						text:'发起申请',
						id:'Apply',
						iconCls: 'icon-upload-cloud'
				}
				
					
		]
	} else {
		InStatus = "A"
		toolbar = [
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
				/*,{
						text:'查看明细',
						id:'SeeDetail',
						iconCls: 'icon-search'
				}*/
					
		]
	}
	var DataGrid = $HUI.datagrid("#i-list", {
		fit : true,
		striped : true,
		border:false,
		singleSelect : true,
		fitColumns : false,
		rownumbers:false,
		nowrap:true,
		//autoRowHeight : false,
		pagination : true,  
		//headerCls:'panel-header-gray',
		//pageSize:14,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "DHCDoc.GCP.SAE.BS",
			QueryName : "QrySAE",
			InType:ServerObj.Type,
			InUser: session['LOGON.USERID'],
			InStatus:InStatus,
			InGroupID:session['LOGON.GROUPID'],
			InHosp:session['LOGON.HOSPID']
			
		},
		onSelect: function (rowIndex, rowData) {
			
		},
		onLoadSuccess : function (data) {
			//PageHandle();
		},
		frozenColumns:frozenColumns,
		columns :columns,
		onDblClickRow: function(rowIndex, rowData) {
			//' + row.PLID + ", '" + row.LinkPDAID + "', '" + row.id  + "', '" + row.patientDR + "', '" + row.admid 
			//SeeDetail_Handler (rowData.rowid,"") 	
			//SeeDetail_Handler("","")
		},
		toolbar:toolbar
		/*,rowStyler: function(index,row){
			if (row.AEStatusCode=="R"){
				return 'background-color:#f16e57;color:#fff;';
				//return 'color:red;';
			} else if (row.AEStatusCode=="N") {
				//return 'background-color:#FFB746;color:#fff;';
			} else{}
		}*/

	});
	
	PLObject.m_Grid = DataGrid;
}


function findConfig () {
	var StartDate = $("#StartDate").datebox("getValue")||"";
	var EndDate = $("#EndDate").datebox("getValue")||"";
	var InStatus = PLObject.AEStatus_Box.getValues().join(",")
	var InReportType = PLObject.AEReportType_Box.getValues().join(",")
	if ((EndDate!="")&&(StartDate=="")) {
		$.messager.alert("提示", "请输入开始日期！", "info");
		return false;
	}
	//var HasPass = $("#HasPass").checkbox("getValue")?1:0;
	//var LocID=$("#RLocdesc").combobox('getValue')
	PLObject.m_Grid.reload({
		ClassName : "DHCDoc.GCP.SAE.BS",
		QueryName : "QrySAE",
		InType: ServerObj.Type,
		InUser: session['LOGON.USERID'],
		StartDate:StartDate,
		EndDate:EndDate,
		InStatus:InStatus,
		InReportType:InReportType,
		InGroupID:session['LOGON.GROUPID'],
		InHosp:session['LOGON.HOSPID']
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

function Add_Handler () {
	var MID=""
	var URL = "gcp.bs.sae.report.csp";
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-add',
		title:'填报',
		width:1200,height:800,
		CallBackFunc:findConfig
	})
}

function Process_Handler(MID,StatusCode) {
	
	var URL = "gcp.bs.sae.audit.process.csp?MID="+MID;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-edit',
		title:$g('审核流水'),
		width:800,height:600
	})
}

function Apply_Handler(InStatus) {
	//AEStatusCode=AEStatusCode||""
	var selected = PLObject.m_Grid.getSelected();
	if (!selected) {
		$.messager.alert("提示","请选择一行！","warning")
		return false;
	}
	
	var MID = selected.rowid,
		Note = "",
		msg = "",
		AEStatusCode = selected.AEStatusCode,
		InPara = session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID']+"^"+InStatus;
	
	if ((InStatus=="U")||(InStatus=="R")) {
		if (AEStatusCode!="A") {
			$.messager.alert("提示","该记录已经审核过！","warning")
			return false;
		}
		if (InStatus=="U") {msg = "确认同意么？";}
		if (InStatus=="R") {msg = "确认拒绝么？";}
	} else {
		msg = "确认发起申请么？";
		if ((AEStatusCode!="N")&&(AEStatusCode!="R")) {
			$.messager.alert("提示","该状态下不能发起申请！","warning")
			return false;
		}
	}
	if (InStatus=="R") {
		var URL = "gcp.bs.sae.refuse.csp?MID="+MID+"&InPara="+InPara;
		websys_showModal({
			url:URL,
			iconCls: 'icon-w-edit',
			title:$g('拒绝'),
			width:575,height:265,
			CallBackFunc:findConfig
		})
	} else {
		$.messager.confirm("提示", msg,function (r) {
			if (r) {
				$m({
					ClassName:"DHCDoc.GCP.SAE.BS",
					MethodName:"ChangeApply",
					MID:MID,
					InPara:InPara,
					Note:Note
				}, function(result){
					if (result == 0) {
						$.messager.alert("提示", "保存成功！", "info");
						findConfig();
						return true;
					} else {
						$.messager.alert("提示", "保存失败：" + result , "info");
						return false;
					}
				});
			}
		});	
	}
	
}

function SeeDetail_Handler (MID,AEStatusCode,See) {
	MID=MID||"",See=See||"",AEStatusCode=AEStatusCode||""
	if (MID=="") {
		var selected = PLObject.m_Grid.getSelected();
		if (!selected) {
			$.messager.alert("提示","请选择一行！","warning")
			return false;
		}
		
		MID=selected.rowid;
		var AEStatusCode = selected.AEStatusCode
		if ((AEStatusCode!="N")&&(AEStatusCode!="R")) {
			See=1
		}
	} else {
		if ((AEStatusCode!="N")&&(AEStatusCode!="R")) {
			See=1
		}
	}
	var IsAddUser = $cm({
		ClassName: "DHCDoc.GCP.SAE.BS",
		MethodName: "IsAddUser",
		InUser: session['LOGON.USERID'],
		MID:MID
	},false)
	
	if (IsAddUser!=1) {
		See=1
	}
	
	var URL = "gcp.bs.sae.report.csp?MID="+MID+"&See="+See;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-find',
		title:'查看明细',
		width:1200,height:800,
		CallBackFunc:function () {
			if (See!=1) findConfig()
		}
	})
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
	$("#StartDate").datebox("setValue","");
	$("#EndDate").datebox("setValue","");
	//PLObject.AEStatus_Box.clear();
	//PLObject.AEReportType_Box.clear();
	if (ServerObj.Type=="U") {
		PLObject.AEStatus_Box.setValues(["A"])
	} else {
		PLObject.AEStatus_Box.setValues([])
	}
	PLObject.AEReportType_Box.setValues([])
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