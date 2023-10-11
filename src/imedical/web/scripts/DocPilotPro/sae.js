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
			showMask("#i-layout","<span style='color:#F06D55;font-size:20px;'>����Ȩ��ˣ�</span>")
			return false
		}
	}
	return true;
}

function showMask(id,msg){
	//$("<div class=\"datagrid-mask\"></div>").css({display:"block",width:"100%",height:$(window).height()}).appendTo("body"); 
    //$("<div class=\"datagrid-mask-msg\"></div>").html("���ڴ������Ժ򡣡���").appendTo("body").css({display:"block",left:($(document.body).outerWidth(true) - 190) / 2,top:($(window).height() - 45) / 2});
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
			{id:'N',text:$g('�½�')},
			{id:'A',text:$g('����')},
			{id:'R',text:$g('�ܾ�')},
			{id:'U',text:$g('ͬ��')}
		]
	} else {
		defaultVal=["A"]
		data = [
			{id:'A',text:$g('����')},
			{id:'R',text:$g('�ܾ�')},
			{id:'U',text:$g('ͬ��')}
		]
	}
	PLObject.AEStatus_Box = $HUI.combobox("#AEStatus",{
		valueField:'id',
		textField:'text',
		multiple:true,
		rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
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
		rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'F',text:$g('�״α���')},
			{id:'V',text:$g('��ñ���')},
			{id:'S',text:$g('�ܽᱨ��')}
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
		{field:'AEStatus',title:'����״̬',width:100,
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
		{field:'Action',title:'����',width:80,align:'left',
			formatter: function(value,row,index){
				var mRtn = '<a class="editcls c-blue" onclick="SeeDetail_Handler(\'' + row["rowid"] + '\',\''+row["AEStatusCode"]+'\')">'+$g("��")+'</a>';
				mRtn = mRtn+'<a class="editcls c-red" onclick="Process_Handler(\'' + row["rowid"] + '\',\''+row["AEStatusCode"]+'\')">'+$g("��")+'</a>';
				/*if (row["AEStatusCode"] == "R") {
					mRtn = mRtn+'<a class="editcls c-red" onclick="Apply_Handler(\'' + "A" + '\',\''+row["AEStatusCode"]+'\')">��</a>';
				}*/
				return mRtn;
				//return '<a class="editcls" onclick="SeeDetail_Handler(\'' + row["rowid"] + '\',\''+row["AEStatusCode"]+'\')">��</a>';
				
			}
		},
		{field:'AEReportType',title:'��������',width:100},
		{field:'AEReportDate',title:'��������',width:100},
		{field:'AEPatientSpell',title:'����������',width:100},
		{field:'AESex',title:'�������Ա�',width:100},
		{field:'AEDrugNameZN',title:'������ҩ������',width:150},
		{field:'AEDrugNameEN',title:'������ҩӢ����',width:150},
		//{field:'AEStage',title:'�ڱ�',width:50},
		{field:'AEUser',title:'������',width:100},
		{field:'AEAddLoc',title:'�������',width:100},
		{field:'AENote',title:'�ܾ�ԭ��',width:250},
		{field:'AEAuditUser',title:'�����',width:100},
		{field:'AEAuditDate',title:'�������',width:150},
		
		{field:'rowid',title:'rowid',width:50,hidden:true}
	]]
	var toolbar = [],InStatus="";
	if (ServerObj.Type=="A") {
		toolbar = [
				{
						text:'�',
						id:'Add',
						iconCls: 'icon-add'
				},
				{
						text:'�޸�',
						id:'Update',
						iconCls: 'icon-write-order'
				},
				{
						text:'��������',
						id:'Apply',
						iconCls: 'icon-upload-cloud'
				}
				
					
		]
	} else {
		InStatus = "A"
		toolbar = [
				{
						text:'ͬ��',
						id:'Agree',
						iconCls: 'icon-stamp'
				},
				{
						text:'�ܾ�',
						id:'Refuse',
						iconCls: 'icon-audit-x'
				}
				/*,{
						text:'�鿴��ϸ',
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
		$.messager.alert("��ʾ", "�����뿪ʼ���ڣ�", "info");
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
		$.messager.alert("��ʾ", "��ѡ��һ�У�", "info");
		return false;
	}
	
	if (ServerObj.Type=="KS") {
		if (selected.status == "S") {
			$.messager.alert("��ʾ", "��ͬ���˴˷���!", "info");
			return false;
		} else if (selected.status == "RS") {
			$.messager.alert("��ʾ", "�Ѿܾ��˴˷���!", "info");
			return false;
		} else {}
	} else if (ServerObj.Type=="YJK") {
		if (selected.status == "Y") {
			$.messager.alert("��ʾ", "��ͬ���˴˷���!", "info");
			return false;
		} else if (selected.status == "RY") {
			$.messager.alert("��ʾ", "�Ѿܾ��˴˷���!", "info");
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
			$.messager.alert("��ʾ", "����ɹ���", "info", function () {
				findConfig();
			})
		} else {
			$.messager.alert("��ʾ", "����ʧ�ܣ�" + result , "info");
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
		title:'�',
		width:1200,height:800,
		CallBackFunc:findConfig
	})
}

function Process_Handler(MID,StatusCode) {
	
	var URL = "gcp.bs.sae.audit.process.csp?MID="+MID;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-edit',
		title:$g('�����ˮ'),
		width:800,height:600
	})
}

function Apply_Handler(InStatus) {
	//AEStatusCode=AEStatusCode||""
	var selected = PLObject.m_Grid.getSelected();
	if (!selected) {
		$.messager.alert("��ʾ","��ѡ��һ�У�","warning")
		return false;
	}
	
	var MID = selected.rowid,
		Note = "",
		msg = "",
		AEStatusCode = selected.AEStatusCode,
		InPara = session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID']+"^"+InStatus;
	
	if ((InStatus=="U")||(InStatus=="R")) {
		if (AEStatusCode!="A") {
			$.messager.alert("��ʾ","�ü�¼�Ѿ���˹���","warning")
			return false;
		}
		if (InStatus=="U") {msg = "ȷ��ͬ��ô��";}
		if (InStatus=="R") {msg = "ȷ�Ͼܾ�ô��";}
	} else {
		msg = "ȷ�Ϸ�������ô��";
		if ((AEStatusCode!="N")&&(AEStatusCode!="R")) {
			$.messager.alert("��ʾ","��״̬�²��ܷ������룡","warning")
			return false;
		}
	}
	if (InStatus=="R") {
		var URL = "gcp.bs.sae.refuse.csp?MID="+MID+"&InPara="+InPara;
		websys_showModal({
			url:URL,
			iconCls: 'icon-w-edit',
			title:$g('�ܾ�'),
			width:575,height:265,
			CallBackFunc:findConfig
		})
	} else {
		$.messager.confirm("��ʾ", msg,function (r) {
			if (r) {
				$m({
					ClassName:"DHCDoc.GCP.SAE.BS",
					MethodName:"ChangeApply",
					MID:MID,
					InPara:InPara,
					Note:Note
				}, function(result){
					if (result == 0) {
						$.messager.alert("��ʾ", "����ɹ���", "info");
						findConfig();
						return true;
					} else {
						$.messager.alert("��ʾ", "����ʧ�ܣ�" + result , "info");
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
			$.messager.alert("��ʾ","��ѡ��һ�У�","warning")
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
		title:'�鿴��ϸ',
		width:1200,height:800,
		CallBackFunc:function () {
			if (See!=1) findConfig()
		}
	})
}


function Refuse_Handler() {
	var selected = PLObject.m_Grid.getSelected();
	if (!selected) {
		$.messager.alert("��ʾ", "��ѡ��һ�У�", "info");
		return false;
	}
	
	if (ServerObj.Type=="KS") {
		if (selected.status == "S") {
			$.messager.alert("��ʾ", "��ͬ���˴˷���!", "info");
			return false;
		} else if (selected.status == "RS") {
			$.messager.alert("��ʾ", "�Ѿܾ��˴˷���!", "info");
			return false;
		} else {}
	} else if (ServerObj.Type=="YJK") {
		if (selected.status == "Y") {
			$.messager.alert("��ʾ", "��ͬ���˴˷���!", "info");
			return false;
		} else if (selected.status == "RY") {
			$.messager.alert("��ʾ", "�Ѿܾ��˴˷���!", "info");
			return false;
		} else {}
	} else {}
	
	var PDAID=selected.id;
	var LinkPDAID = selected.LinkPDAID
	var URL = "chemo.bs.audit.refuse.csp?PDAID="+PDAID+"&Type="+ServerObj.Type+"&LinkPDAID="+LinkPDAID;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-edit',
		title:'�ܾ�',
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