/**
 * passwork.hui.js ҽ�����Ű�
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2018-08-10
 * 
 * TABL: DHCDoc_ExceedReason
 */

//ҳ��ȫ�ֱ���
var PageLogicObj = {
	m_DurDataGrid : "",
	m_DefaultDate:"",
	m_Type: "",
	m_Win : "",
	m_DMainId: "",
	m_NMainId: "",
	m_BCode: "",
	m_DeafultBCode:"",
	m_SaveDate:""	//�������
}

$(function(){
	//��ʼ��
	Init();
	
	//�¼���ʼ��
	InitEvent();
	
	//ҳ��Ԫ�س�ʼ��
	PageHandle();
})


function Init(){
	extendEY();
	PageLogicObj.m_DefaultDate = GetDefaultDate();
	PageLogicObj.m_DeafultBCode = GetDefaultBCode();
	InitBCLabelTitle(PageLogicObj.m_DefaultDate, PageLogicObj.m_DeafultBCode);	//��ʼ����β�ѯ��ǩtitle
	InitWorkPanel(PageLogicObj.m_DeafultBCode);
	PageLogicObj.m_Type = $HUI.combobox("#i-type", {
		url:$URL+"?ClassName=web.DHCDocPassWork&QueryName=QryPassWorkType&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		onSelect: function (r) {
			findConfig();
		}
		
	
	});	
	$("#i-date").datebox({
		required:true,
		editable:false,
		onSelect: function (date) {
			var curDate = $(this).datebox("getValue");
			var tempFlag = EnableSelectDate(curDate);
			if (!tempFlag) {
				$(this).datebox('setValue', PageLogicObj.m_DefaultDate);
				return false;
			}
			/*
			var editFlag = tkMakeServerCall("web.DHCDocPassWork", "IfEnableEdit", curDate);
			if (editFlag == "NO-ALL") {
				DisableAll();

			} else if (editFlag == "OK-ALL") {
				EnableAll();
			} else if (editFlag == "OK-D") {
				DisableNight();
			}
			*/
			var BCType = GetBCType();
			InitBCLabelTitle(curDate,BCType);
			LoadData();
			findConfig();
		}
	})

	PageLogicObj.m_DurDataGrid = InitDurDataGrid();
	/* $("#bc").keywords({
		items:[{
			text:"���",
			type:"chapter",
			items:[
				
			]
		}]
	});
	$("#kw").keywords({
		items:[{
			text:"��ϸ",
			type:"chapter",
			items:[
			]
		}]
	}); */
	
}
//��ʼ����ѯ��ǩTitle
function InitBCLabelTitle (FindDate, BCode) {
	// $("#i-WorkD").removeClass("selected");
	// $("#i-WorkN").removeClass("selected");
	FindDate = FindDate||($("#i-date").datebox('getValue'));
	var responseText = $.m({
		ClassName:"web.DHCDocPassWork",
		MethodName:"InitBCLabelTitle",
		FindDate: FindDate
	},false);
	var resultArr = responseText.split("^");
	$("#i-WorkD").html(resultArr[0]);
	$("#i-WorkN").html(resultArr[1]);
	if (BCode) {
		SwitchBCType(BCode);
	}
}
function InitWorkPanel(BCode) {
	if (BCode == "D") {
		$("#WorkD-Panel").removeClass("c-hidden");
		$("#WorkN-Panel").addClass("c-hidden");
	} else {
		$("#WorkN-Panel").removeClass("c-hidden");
		$("#WorkD-Panel").addClass("c-hidden");
	}
}
function GetDefaultDate () {
	var ret = tkMakeServerCall("web.DHCDocPassWork", "GetDefaultDate");
	return ret;
}
function GetDefaultBCode() {
	var ret = tkMakeServerCall("web.DHCDocPassWork", "GetWorkType");
	return ret;
}
function EnableSelectDate (SelectDate) {
	var responseText = $.m({
		ClassName:"web.DHCDocPassWork",
		MethodName:"EnableSelectDate",
		SelectDate: SelectDate
	},false);
	if (responseText == 0) {
		return true;
	} else {
		return false;
	}
}
function DisableAll () {
	// $("#work-n").panel({
	// 	headerCls:'panel-header-card-gray'
	// });
	$("input").attr("disabled", "disabled");
	$("#work-n-table input");
	$(".validatebox-text").removeAttr("disabled");
	PageLogicObj.m_Type.disable();
	$(".hisui-linkbutton").linkbutton("disable");
	$(".datagrid-toolbar a").linkbutton("disable");
}
function EnableAll () {
	$("input").removeAttr("disabled");
	PageLogicObj.m_Type.enable();
	$(".hisui-linkbutton").linkbutton("enable");
	$(".datagrid-toolbar a").linkbutton("enable");
}
function DisableNight () {
	EnableAll();
	$("#work-n-table input").attr("disabled", "disabled");
	$("#work-n-save").linkbutton("disable");
}
function InitEditStatus () {
	var editFlag = tkMakeServerCall("web.DHCDocPassWork", "IfEnableEdit", PageLogicObj.m_DefaultDate);
	if (editFlag == "NO-ALL") {
		DisableAll();

	} else if (editFlag == "OK-ALL") {
		EnableAll();
	} else if (editFlag == "OK-D") {
		DisableNight();
	}
}
function InitEvent(){

	$("#i-find").click(findConfig);
	$("#i-add").click(function(){opDialog("add")});
	$("#work-n-save").click(function(){
		SaveBCInfo("N");
	});
	$("#work-d-save").click(function(){
		SaveBCInfo("D")
	});
	$("#i-WorkD").click(function () {
		FindBCInfo("D");
	});
	$("#i-WorkN").click(function () {
		FindBCInfo("N");
	});
	$("#i-selfPeron").click(SelfPersonFind);
	$("#i-selfLoc").click(SelfLocFind);
	$("#i-export").click(exportData);
	$(document.body).bind("keydown",BodykeydownHandler)
	document.onkeydown = DocumentOnKeyDown;
}
function InitDGEvent() {
	$("#dg-patno").keydown(function (event) {
        if (event.which == 13 || event.which == 9) {
            var PatNo = $('#dg-patno').val();
			//if (PatNo=="") return;
			if ((PatNo.length<10)&&(PatNo!="")) {
				for (var i=(10-PatNo.length-1); i>=0; i--) {
					PatNo="0"+PatNo;
				}
			}
			$('#dg-patno').val(PatNo);
        }
    });
}
function SaveBCInfo (BCType) {
	var bT = BCType.toLowerCase();
	var FXMLStr = BulidXMLData(bT);
	var Note = $.trim($("#" + bT + "-Note").val());
	var Pwd = $("#" + bT + "-Pwd").val();
	var LocId = session['LOGON.CTLOCID'];
	var userid = session['LOGON.USERID'];
	var FindDate = PageLogicObj.m_SaveDate; 	//$("#i-date").datebox('getValue');
	var BaseInfo = LocId + "^" + userid + "^" + Pwd + "^" + FindDate + "^" + BCType;
	//web.DHCOEOrdItem.PinNumberValid
	$.m({
		ClassName:"web.DHCDocPassWork",
		MethodName:"SaveBCInfo",
		BaseInfo: BaseInfo,
		XMLStr: FXMLStr,
		Note: Note,
	},function (responseText){
		if(responseText == 0) {
			$.messager.alert('��ʾ',"����ɹ���" , "info");
			findConfig();
			return true;
		} else if (responseText == 2) {
			$.messager.alert('��ʾ','ǩ���������' , "info");
			return false;
		} else if (responseText == 3) {
			$.messager.alert('��ʾ','���ǽ����˲������޸ģ�' , "info");
			return false;
		} else {
			$.messager.alert('��ʾ','����ʧ��: '+ responseText , "info");
			return false;
		}
	})

}

function BulidXMLData (bcType) {
	var PreSum = $("#" + bcType + "-PreSum").val();
	var NowSum = $("#" + bcType + "-NowSum").val();
	var OutHospNum = $("#" + bcType + "-OutHospNum").val();
	var InHospNum = $("#" + bcType + "-InHospNum").val();
	var OutWardNum = $("#" + bcType + "-OutWardNum").val();
	var InWardNum = $("#" + bcType + "-InWardNum").val();
	var OperNum = $("#" + bcType + "-OperNum").val();
	var SeverityNum = $("#" + bcType + "-SeverityNum").val();
	var CritiNum = $("#" + bcType + "-CritiNum").val();
	var DeathNum = $("#" + bcType + "-DeathNum").val();
	var XMLJson = {
		"PreSum" : PreSum,
		"NowSum" : NowSum,
		"OutHospNum" : OutHospNum,
		"InHospNum" : InHospNum,
		"OutWardNum" : OutWardNum,
		"InWardNum" : InWardNum,
		"OperNum" : OperNum,
		"SeverityNum" : SeverityNum,
		"CritiNum" : CritiNum,
		"DeathNum" : DeathNum,
	};
	/*var paraJson = "{ " +
		"PreSum:" + PreSum + 
		", NowSum: " + NowSum + 
		", OutHospNum: " + OutHospNum + 
		", InHospNum: " + InHospNum + 
		", OutWardNum: " + OutWardNum + 
		", InWardNum: " + InWardNum + 
		", OperNum: " + OperNum + 
		", SeverityNum: " + SeverityNum + 
		", CritiNum: " + CritiNum + 
		", DeathNum: " + DeathNum +
		"}"
	*/
	var FXMLStr = "";
	var responseText = $.m({
		ClassName:"web.DHCDocPassWork",
		MethodName:"GetClassPropertyList",
		cls: "web.DHCDocPassWork"
	},false);
	//var responseText = tkMakeServerCall("web.DHCBL.UDHCCommFunLibary", "GetClassPropertyList", "web.DHCDocPassWork");
	var XMLNodes = responseText.split("^");
	for (var i=0; i < XMLNodes.length; i++) {
		var curNode = XMLNodes[i];
		if (FXMLStr == "") {
			FXMLStr = "<PW>" + "<" + curNode + ">" + XMLJson[curNode] + "</" + curNode + ">";
		} else {
			FXMLStr = FXMLStr + "<" + curNode + ">" + XMLJson[curNode] + "</" + curNode + ">"
		}
	}
	if (FXMLStr !="") {
		FXMLStr = FXMLStr + "</PW>";
	} 
	return FXMLStr;
}

function PageHandle(){
	//InitEditStatus();
	$("#i-date").datebox("setValue", PageLogicObj.m_DefaultDate);
	LoadData();
}

function LoadData() {
	var BCType = GetBCType();
	$.m({
		ClassName:"web.DHCDocPassWork",
		MethodName:"GetPWSummary",
		Para: session['LOGON.CTLOCID'] + "^" + PageLogicObj.m_SaveDate + "^" + session['LOGON.USERID'],
		FindType:BCType
	},function (responseText){
		if(responseText != "") {
			//PreSum_"^"_NowSum_"^"_OutHospNum_"^"_InHospNum_"^"_
			//OutWardNum_"^"_InWardNum_"^"_OperNum_"^"_SeverityNum_"^"_CritiNum_"^"_DeathNum
			var workArr = responseText.split("@");
			var workD = workArr[0].split("^");
			var workN = workArr[1].split("^");
			var workType = BCType;
			var mainId = "m_" + workType + "MainId";
			if (workType == "D") {
				var workData = workD;
			} else {
				var workData = workN;
			}
			var _idPrex = "#" + workType.toLowerCase();
			$(_idPrex + "-PreSum").val(workData[0]);
			$(_idPrex + "-NowSum").val(workData[1]);
			$(_idPrex + "-OutHospNum").val(workData[2]);
			$(_idPrex + "-InHospNum").val(workData[3]);
			$(_idPrex + "-OutWardNum").val(workData[4]);
			$(_idPrex + "-InWardNum").val(workData[5]);
			$(_idPrex + "-OperNum").val(workData[6]);
			$(_idPrex + "-SeverityNum").val(workData[7]);
			$(_idPrex + "-CritiNum").val(workData[8]);
			$(_idPrex + "-DeathNum").val(workData[9]);
			$(_idPrex + "-Note").val(workData[10]);
			PageLogicObj[mainId] = workData[11];
		} else {
			//$.messager.alert('��ʾ','����ʧ��: '+ responseText , "info");
			//return false;
		}	
	})
}

function InitDurDataGrid(){
	var BCType = GetBCType();
	var columns = [[
		{field:'PatWorkTypeDesc',title:'����',width:100},
		{field:'FillFlag',title:'��д��־',width:100,
			formatter:function(value,row,index){
				var bol = ((row.DayRemark!="")&&(BCType=="D"))||((row.NightRemark!="")&&(BCType=="N"))
				if (bol) {
					return "<span class='fillspan'>����д</span>";
				} else {
					return "<span class='fillspan-no'>δ��д</span>";
				}
			}
		},
		{field:'PatNo',title:'�ǼǺ�',width:150},
		{field:'PatName',title:'����',width:100},
		{field:'PatSex',title:'�Ա�',width:100},
		{field:'PatAge',title:'����',width:100},
		{field:'AdmDocDesc',title:'����ҽ��',width:100},
		{field:'PatDiagnos',title:'���',width:250},
		{field:'PatOperName',title:'����',width:100},
		{field:'PatMedicareNo',title:'סԺ��',width:100},
		{field:'CurBedCode',title:'����',width:100},
		{field:'DayRemark',title:'�װ�',width:100,
			formatter:function(value,row,index){
				var text = value;
				if ((row.DItemId!="")&&(text == "")) text = "�༭"
				if (row.DItemId == "") text="";
				var s = '<a style="color:#40A2DE; cursor:pointer;" onclick="EditDWork(' + "'" + row.DItemId + "'" + ') ">' + text + '</a>';
				return s;
			}
		},
		{field:'NightRemark',title:'ҹ��',width:100,
			formatter:function(value,row,index){
				var text = value;
				if ( (row.NItemId!="")&&(text == "") ) text = "�༭"
				if (row.NItemId == "") text="";
				var s = '<a style="color:#40A2DE; cursor:pointer;" onclick="EditNWork(' + "'" + row.NItemId + "'" + ') ">' + text + '</a>';
				return s;
			}
		},
		{field:'DayRemarkUser',title:'�װ������',width:100},
		{field:'NightRemarkUser',title:'ҹ�������',width:100},
		{field:'DayRemarkUserID',title:'�װ���ID',width:100,hidden:true},
		{field:'NightRemarkUserID',title:'ҹ����ID',width:100,hidden:true},
		{field:'PatientID',title:'����ID',width:100,hidden:true},
		{field:'EpisodeID',title:'����ID',width:100,hidden:true},
		{field:'DItemId',title:'�װ��ӱ�ID',width:100,hidden:true},
		{field:'NItemId',title:'ҹ���ӱ�ID',width:100,hidden:true}
    ]]
	var DurDataGrid = $HUI.datagrid("#i-durGrid", {
		fit : true,
		border : true,
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
			ClassName : "web.DHCDocPassWork",
			QueryName : "FindPassWorkPatList",
			LocId: session['LOGON.CTLOCID'],
			FindDate: PageLogicObj.m_SaveDate,	//PageLogicObj.m_DefaultDate,
			UserId: '',	//session['LOGON.USERID'],
			FindBCType:BCType
		},
		//idField:'Rowid',
		columns :columns,
		toolbar:[{
				text:'���',
				id:'i-add',
				iconCls: 'icon-add'
			},
			{
				text:'����',
				id:'i-export',
				iconCls: 'icon-export'
			}
		]
	});
	
	return DurDataGrid;
}

//�༭������
function opDialog(action,ItemID) {
	var _title = "", _icon = "" ;
	if (action == "add") {
		_title = "���";
		_icon = "icon-w-add";
		$("#dg-action").val("add");
		$("#dg-id").val("");
	} else {
		_title = "�޸�";
		_icon = "icon-w-edit";
		$("#dg-action").val("edit");
		$("#dg-id").val(ItemID);
	}
	
	if($('#i-dialog').hasClass("c-hidden")) {
		$('#i-dialog').removeClass("c-hidden");
	};
	var PatInfo = "", PatArr = "";
	if (!!ItemID) {
		PatInfo = $.m({
			ClassName:"web.DHCDocPassWork",
			MethodName:"GetPatInfoByItemID",
			ItemID: ItemID
		},false);
	}
	PageLogicObj.m_DG_BC = $HUI.combobox("#dg-bc", {
		url:$URL+"?ClassName=web.DHCDocPassWork&QueryName=QryPassWorkBC&ResultSetType=array",
		valueField:'id',
		textField:'desc'
		
	});	
	PageLogicObj.m_DG_Type = $HUI.combobox("#dg-type", {
		url:$URL+"?ClassName=web.DHCDocPassWork&QueryName=QryPassWorkType&ResultSetType=array",
		valueField:'id',
		textField:'desc'
		
	});	

	if (action == "add") {
		$("#dg-patno").val("");
		$("#dg-content").val("");
		PageLogicObj.m_BCode = "";
	} else {
		PatArr = PatInfo.split(String.fromCharCode(1));
		$("#dg-content").val(PatArr[4]);
		_title = _title + PatArr[0];
		if (PatArr[0] == "�װ�") PageLogicObj.m_BCode = "D";
		else PageLogicObj.m_BCode = "N";
	}
	hiddenItem(action,PatArr);
	var cWin = $HUI.window('#i-dialog', {
		title: _title,
		iconCls: _icon,
		modal: true,
		minimizable:true,
		//maximizable:false,
		maximizable:true,
		collapsible:false,
		onClose: function () {
			//$(this).window('destroy');
			$('#i-dialog').addClass("c-hidden");
		}
	});
	InitDGEvent();
	PageLogicObj.m_Win = cWin;
}

function hiddenItem(action, PatArr) {
	if (action == "add") {
		$("#dg-patinfo").addClass("c-hidden");
		$("#dg-add-tr").removeClass("c-hidden");
		$("#dg-add-tr2").removeClass("c-hidden");
		$("#dg-msg").html("");
		$("#i-pre").addClass("")
		$("#i-pre").addClass("c-hidden");
		$("#i-next").addClass("c-hidden");
	} else {
		$("#dg-add-tr").addClass("c-hidden");
		$("#dg-add-tr2").addClass("c-hidden");
		$("#dg-patinfo").removeClass("c-hidden");
		$("#i-pre").removeClass("c-hidden");
		$("#i-next").removeClass("c-hidden");
		var baseMsg = "<span class='tip'>" + PatArr[0] + "��>" + PatArr[1] + "��>" + PatArr[2] + "��>" + PatArr[3] + "��>" + PatArr[6] + "</span>";
		baseMsg = baseMsg + "<br/><a class='findLab' onclick='seeLabDetail("+ PatArr[5] + ")'>����鿴��������Ϣ</a>";
		$("#dg-msg").html(baseMsg);
	}
}
function deConfig () {
	var selected = PageLogicObj.m_DurDataGrid.getSelected();
	if (!selected) {
		$.messager.alert("��ʾ","��ѡ��һ����¼...","info")
		return false;
	}
	$.m({
			ClassName:"web.DHCDocExceedReason",
			MethodName:"Delete",
			'ID': selected.ExceedID,
		},function (responseText){
			if(responseText == 0) {
				$.messager.alert('��ʾ','ɾ���ɹ�',"info");
				PageLogicObj.m_DurDataGrid.reload();
			} else {
				$.messager.alert('��ʾ','�޸�ʧ��,�������: '+ responseText , "info");
				return false;
			}	
		})
}

function setDurTime() {
	if($('#i-time').hasClass("c-hidden")) {
		$('#i-time').removeClass("c-hidden");
	};
	//��ֵ
	$.m({
		ClassName:"web.DHCDocExceedReason",
		MethodName:"GetExceedDate",
		'AdmType':"O"
	},function (responseText){
		$("#i-time-mz").val(responseText);	
	})
	
	$.m({
		ClassName:"web.DHCDocExceedReason",
		MethodName:"GetExceedDate",
		'AdmType':"E"
	},function (responseText){
		$("#i-time-jz").val(responseText);	
	})
	
	//
	var cWin = $HUI.window('#i-time', {
		title: "�����޶�ʱ��",
		//iconCls: _icon,
		modal: true,
		minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
		onClose: function () {
			//$(this).window('destroy');
			$('#i-time').addClass("c-hidden");
		}
	});
	PageLogicObj.m_TimeWin = cWin;
}

function saveTime () {	
	var mzTime = $.trim($("#i-time-mz").val());	
	var jzTime = $.trim($("#i-time-jz").val());	
	var otn=tkMakeServerCall("web.DHCDocExceedReason","SetExceedDate","O",mzTime);
	var etn=tkMakeServerCall("web.DHCDocExceedReason","SetExceedDate","E",jzTime);
	$.messager.alert('��ʾ','���óɹ�',"info");
	PageLogicObj.m_TimeWin.close();
}

function editCfg (action) {	//��0��ʼ
	//var data = PageLogicObj.m_DurDataGrid.getData();
	//var total = data.total;
	var options = PageLogicObj.m_DurDataGrid.getPager().data("pagination").options;
	var pageSize = options.pageSize;
	//var options = $("#sourceDG" ).datagrid("getPager").data("pagination").options;
	//curr = options.pageNumber;  
	//console.log(curr);
	//size = options.pageSize;
	var selectedOld = PageLogicObj.m_DurDataGrid.getSelected();
	var oldRowIndex = PageLogicObj.m_DurDataGrid.getRowIndex(selectedOld);
	var newIndex = "-1"
	if (action == "next") {
		newIndex = oldRowIndex + 1;
		if (newIndex >= pageSize) {
			$.messager.alert('��ʾ','���ǵ�ǰ���һ��!',"info");
			return false;
		}
	} else {
		newIndex = oldRowIndex - 1
		if (newIndex < 0) {
			$.messager.alert('��ʾ','���ǵ�һ��!',"info");
			return false;
		}
	}

	PageLogicObj.m_DurDataGrid.selectRow(newIndex);
	var selected = PageLogicObj.m_DurDataGrid.getSelected();
	if (!selected) {
		$.messager.alert('��ʾ','���ǵ�ǰ���һ��!',"info");
		return false;
	}
	var _itemStr = PageLogicObj.m_BCode + "ItemId";
	opDialog("edit", selected[_itemStr]);
}
//�����ֵ���Ϣ
function saveCfg() {
	var id = $("#dg-id").val();
	var action = $("#dg-action").val();
	var bcType = PageLogicObj.m_DG_BC.getValue();
	var workType = PageLogicObj.m_DG_Type.getValue();
	var content = $.trim($("#dg-content").val());
	var patno = $.trim($("#dg-patno").val());
	var mainIdStr = "m_" + bcType + "MainId";
	var admId = "", mainId = "", hasFlag = "";
	if ((action == "add")&&(bcType == "")) {
		$.messager.alert('��ʾ','��β���Ϊ��!',"info");
		return false;
	}
	if ((action == "add")&&(workType == "")) {
		$.messager.alert('��ʾ','���Ͳ���Ϊ��!',"info");
		return false;
	}
	if ((action == "add")&&(patno == "")) {
		$.messager.alert('��ʾ','�ǼǺŲ���Ϊ��!',"info");
		return false;
	}
	if ((action == "edit")&&(content == "")) {
		$.messager.alert('��ʾ','�����뽻������!',"info");
		return false;
	}
	if (action == "add") {
		admId = $.m({
			ClassName:"web.DHCDocPassWork",
			MethodName:"GetAdmIdByPatNo",
			PapmiNo: patno
		},false);
		if (admId == "") {
			$.messager.alert('��ʾ','�޷���ȡ�ò��˵ľ�����Ϣ!',"info");
			return false;
		}
		mainId = PageLogicObj[mainIdStr];
		if (mainId == "") {
			$.messager.alert('��ʾ','���ȱ�������Ϣ!',"info");
			return false;
		}
		var hasFlag = $.m({
			ClassName:"web.DHCDocPassWork",
			MethodName:"IfHasPat",
			InPara: mainId + "^" + admId + "^" + session['LOGON.CTLOCID']
		},false);
		if (hasFlag == 1) {
			$.messager.alert('��ʾ','�Ѿ���ӹ��ò�����Ϣ!',"info");
			return false;
		}
		//����^����ID^����ID^��������^������^ID
		var InPara = workType + "^" + admId + "^" + session['LOGON.CTLOCID'] + "^^" + session['LOGON.USERID'] + "^" + id;
		$.m({
			ClassName:"web.DHCDocPassWork",
			MethodName:"SavePWDetail",
			DDPWRowID: mainId,
			PatDetail: InPara,
			BCNote: content
		},function (responseText){
			if(responseText == 0) {
				$.messager.alert('��ʾ','��ӳɹ�',"info");
				PageLogicObj.m_Win.close();
				PageLogicObj.m_DurDataGrid.reload();
			} else if (responseText == "-103") {
				$.messager.alert('��ʾ','���ǽ����˲�������ӣ�' , "info");
				return false;
			} else {
				$.messager.alert('��ʾ','���ʧ��,�������: '+ responseText , "info");
				return false;
			}	
		})
	} else {
		$.m({
			ClassName:"web.DHCDocPassWork",
			MethodName:"EditPWDetail",
			UserId: session['LOGON.USERID'],
			ItemId: id,
			BCNote: content
		},function (responseText){
			if(responseText == 0) {
				
				var selectedOld = PageLogicObj.m_DurDataGrid.getSelected();
				var rowIndexOld = PageLogicObj.m_DurDataGrid.getRowIndex(selectedOld);
				//PageLogicObj.m_Win.close();
				PageLogicObj.m_DurDataGrid.reload();
				$.messager.alert('��ʾ','�޸ĳɹ�',"info",function() {
					PageLogicObj.m_DurDataGrid.selectRow(rowIndexOld);
				});
				
			} else if (responseText == "-103") {
				$.messager.alert('��ʾ','���ǽ����˲������޸ģ�' , "info");
				return false;
			} else {
				$.messager.alert('��ʾ','�޸�ʧ��,�������: '+ responseText , "info");
				return false;
			}	
		})
	}
	
}
//��ѯ�����Ϣ
function FindBCInfo (BCType) {
	SwitchBCType(BCType);
	InitWorkPanel(BCType);
	findConfig();
}
function SwitchBCType(BCType) {
	if (BCType == "D") {
		$("#i-WorkD").addClass("selected");
		$("#i-WorkN").removeClass("selected");
		PageLogicObj.m_SaveDate = $("#BCD-D").text();
	} else {
		$("#i-WorkN").addClass("selected");
		$("#i-WorkD").removeClass("selected");
		PageLogicObj.m_SaveDate = $("#BCD-N").text();
	}
}
/**
 * ��������
 */
function exportData () {
	var userid = session['LOGON.USERID'];
	var selfLocFlag = $("#i-selfLoc").hasClass("selected");
	if (selfLocFlag) {
		userid = "";
	}
	var BCType = GetBCType();
	if (BCType == "") {
		$.messager.alert('��ʾ','��ѡ���Σ�' , "info");
		return false;
	}
	var bcType = BCType.toLowerCase();
	var PreSum = $("#" + bcType + "-PreSum").val();
	var NowSum = $("#" + bcType + "-NowSum").val();
	var OutHospNum = $("#" + bcType + "-OutHospNum").val();
	var InHospNum = $("#" + bcType + "-InHospNum").val();
	var OutWardNum = $("#" + bcType + "-OutWardNum").val();
	var InWardNum = $("#" + bcType + "-InWardNum").val();
	var OperNum = $("#" + bcType + "-OperNum").val();
	var SeverityNum = $("#" + bcType + "-SeverityNum").val();
	var CritiNum = $("#" + bcType + "-CritiNum").val();
	var DeathNum = $("#" + bcType + "-DeathNum").val();
	var Note = $.trim($("#" + bcType + "-Note").val());
	var xmlData = PreSum + "^" + OutHospNum + "^" + InHospNum + "^" + OutWardNum + "^" + InWardNum;
	xmlData = xmlData + "^" + OperNum + "^" + SeverityNum + "^" + CritiNum + "^" + DeathNum + "^" + NowSum;
	var rtn = $cm({
		dataType:'text',
		ResultSetType:'Excel',
		ExcelName:'JBData',
		ClassName:'web.DHCDocPassWork',
		QueryName:'ExportData',
		LocId: session['LOGON.CTLOCID'],
		FindDate: PageLogicObj.m_SaveDate,	//$("#i-date").datebox('getValue'),
		UserId: userid,
		FindPatWorkType:PageLogicObj.m_Type.getValue(),
		FindPatNo:$("#i-patno").val(),
		FindBCType: BCType,
		Note: Note,
		XmlData: xmlData
	}, false);
	location.href = rtn;
}

function findConfig (flag) {
	var userid = session['LOGON.USERID'];
	var selfLocFlag = $("#i-selfLoc").hasClass("selected");
	if (selfLocFlag) {
		userid = "";
	}
	var BCType = GetBCType();
	if (BCType == "") {
		$.messager.alert('��ʾ','��ѡ���Σ�' , "info");
		return false;
	}
	LoadData();
	PageLogicObj.m_DurDataGrid.reload({
		ClassName : "web.DHCDocPassWork",
		QueryName : "FindPassWorkPatList",
		LocId: session['LOGON.CTLOCID'],
		FindDate: PageLogicObj.m_SaveDate,	//$("#i-date").datebox('getValue'),
		UserId: userid,
		FindPatWorkType:PageLogicObj.m_Type.getValue(),
		FindPatNo:$("#i-patno").val(),
		FindBCType: BCType

	});
}
function GetBCType() {
	if ($("#i-WorkD").hasClass("selected")) {
		return "D"
	}
	if ($("#i-WorkN").hasClass("selected")) {
		return "N"
	};
	return "";
}
function extendEY () {
	$.extend($.fn.linkbutton.methods, {
		enable: function(jq){
			return jq.each(function(){
				var state = $.data(this, 'linkbutton');
				if ($(this).hasClass('l-btn-disabled')) {
					var itemData = state._eventsStore;
					if (itemData.href) {
						$(this).attr("href", itemData.href);
					}
					if (itemData.onclicks) {
						for (var j = 0; j < itemData.onclicks.length; j++) {
							$(this).bind('click', itemData.onclicks[j]);
						}
					}
					itemData.target = null;
					itemData.onclicks = [];
					$(this).removeClass('l-btn-disabled');
				}
			});
		},
		disable: function(jq){
			return jq.each(function(){
				var state = $.data(this, 'linkbutton');
				if (!state._eventsStore)
					state._eventsStore = {};
				if (!$(this).hasClass('l-btn-disabled')) {
					var eventsStore = {};
					eventsStore.target = this;
					eventsStore.onclicks = [];
					var strHref = $(this).attr("href");
					if (strHref) {
						eventsStore.href = strHref;
						$(this).attr("href", "javascript:void(0)");
					}
					var onclickStr = $(this).attr("onclick");
					if (onclickStr && onclickStr != "") {
						eventsStore.onclicks[eventsStore.onclicks.length] = new Function(onclickStr);
						$(this).attr("onclick", "");
					}
					var eventDatas = $(this).data("events") || $._data(this, 'events');
					if (eventDatas["click"]) {
						var eventData = eventDatas["click"];
						for (var i = 0; i < eventData.length; i++) {
							if (eventData[i].namespace != "menu") {
								eventsStore.onclicks[eventsStore.onclicks.length] = eventData[i]["handler"];
								$(this).unbind('click', eventData[i]["handler"]);
								i--;
							}
						}
					}
					state._eventsStore = eventsStore;
					$(this).addClass('l-btn-disabled');
				}
			});
		}
	});
}

function SelfPersonFind () {
	$("#i-selfPeron").addClass("selected");
	$("#i-selfLoc").removeClass("selected");
	findConfig();
}

function SelfLocFind () {
	$("#i-selfLoc").addClass("selected");
	$("#i-selfPeron").removeClass("selected");
	findConfig();
}
function EditDWork (ItemID) {
	opDialog("edit", ItemID);
}
function EditNWork (ItemID) {
	opDialog("edit", ItemID);
}
function seeLabDetail(EpisodeID) {
	//epr.newfw.episodelistbrowser.csp
	var lnk= "emr.record.browse.csp?"+"&EpisodeID="+EpisodeID;
   	window.open(lnk,"htm",'toolbar=no,location=no,directories=no,resizable=yes,width=1000,height=1000');
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
		if(SrcObj && SrcObj.id.indexOf("i-patno")>=0){
			var PatNo=$('#i-patno').val();
			//if (PatNo=="") return;
			if ((PatNo.length<10)&&(PatNo!="")) {
				for (var i=(10-PatNo.length-1); i>=0; i--) {
					PatNo="0"+PatNo;
				}
			}
			$('#i-patno').val(PatNo);
			findConfig ();
			return false;
		}
		return true;
	}
}


