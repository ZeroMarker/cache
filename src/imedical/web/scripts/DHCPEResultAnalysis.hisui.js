// DHCPEResultAnalysis.hisui.js
// dhcperesultanalysis.hisui.csp

var ScreenWidth = $(window).width();
var ScreenHeight = $(window).height();

var First = "Y";
var glabalType = "Aud";

$(function() {
	InitCombobox();
	InitData();
	
	$("#BQuery").click(function() {  // ������ѯ
		BQuery_click();
    });
	
	$("#BSearch").click(function() {  // ������ѯ
		BSearch_click();
    });
    
    $("#BClear").click(function() {  // ����ά�� ����
		BClear_click("");
    });
    
    $("#BSave").click(function() {
		BSave_click(); 
    });
    
    $("#BSymptomsEdit").click(function() {
		ShowSymptomsEditWin(); 
    });
    
    $.m({
		ClassName:"web.DHCPE.Statistic.IllnessStatistic",
		MethodName:"GetResultAnalysisErrInfo",
		Type:glabalType
	}, function(data) {
		var ret = data.split("^");
		if (ret[0] == "-1") {
			$.messager.alert("��ʾ", ret[1], "error");
    		$('#BSetAllTarget').linkbutton('enable');
    		$("#BSetAllTarget").click(function() {
				SetAllTarget(); 
		    });
			return false;
		} else {
    		$('#BSetAllTarget').linkbutton('disable');
    		if (ret[0] == "1") {
	    		$.messager.alert("��ʾ", ret[1], "info");
    		}
		}
	});
    
	$(".inherit-border, .inherit-border>div:first-child").css("border-color", borderColor1);
	ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=DHCPEResultAnalysis.raq");
    /*
    // hisui bug tab�µ�layout center �޸߶� ���ύ����
	$HUI.tabs("#TabDiv", {
		onSelect:function(title, index) {
			if (title == "����ά��" && First == "Y") {
				$(".ResizeDiv1").layout("resize");
				First = "N";
			}
		}
	});
    
	$(".ResizeDiv").layout("resize");  // hisui bug ���ύ����
	*/
});

function InitCombobox() {

	// �Ա�	
	$HUI.combobox("#Sex", {
		valueField:"id",
		textField:"text",
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'N',text:$g('����'), selected:'true'},
			{id:'M',text:$g('��')},
			{id:'F',text:$g('Ů')}
		]
	});
	
	// �����
	$HUI.combobox("#AgeGroup", {
		valueField:"id",
		textField:"text",
		panelHeight:"auto",
		editable:false,
		data:[  // id ����:����������ޣ����ұ� 0<age<=15��,���,������������������б��������ɣ�
			{id:'15-65,10,7',text:$g('15-65�� ���10')},
			{id:'20-60,10,6',text:$g('20-60�� ���10')},
			{id:'25-65,10,6',text:$g('25-65�� ���10'), selected:'true'},
			{id:'20-70,10,7',text:$g('20-70�� ���10')},
			{id:'15-55,20,4',text:$g('15-55�� ���20')},
			{id:'20-60,20,4',text:$g('20-60�� ���20')},
			{id:'25-65,20,4',text:$g('25-65�� ���20')},
			{id:'15-75,20,5',text:$g('15-75�� ���20')}
		]
	});
	
	// ��ͬ
	$HUI.combobox("#ContractID", {
		url:$URL+"?ClassName=web.DHCPE.Contract&QueryName=SerchContract&ResultSetType=array",
		valueField:"TID",
		textField:"TName",
		panelHeight:"auto",
		allowNull:true,
		editable:true,
		onSelect:function(record){
			var GBIDesc = $("#GBIDesc").val();
			$("#Groups").datagrid("load", {ClassName:"web.DHCPE.Report.GroupCollect",QueryName:"GADMList",GBIDesc:GBIDesc,ContractID:record.TID});
		},
		onChange:function(newValue, oldValue) {
			if (newValue =="" || newValue == undefined || newValue == "undefined" || newValue == null || newValue =="null" || newValue == "NULL") {
				$("#ContractID").combobox("setValue", "");
				var GBIDesc = $("#GBIDesc").val();
				$("#Groups").datagrid("load", {ClassName:"web.DHCPE.Report.GroupCollect",QueryName:"GADMList",GBIDesc:GBIDesc,ContractID:""});
			} 
		}
		
	});
	
	$HUI.combobox("#UseRange", {
		valueField:"id",
		textField:"text",
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'U',text:$g('����')},
			{id:'S',text:$g('ȫ��'), selected:'true'}
		]
	});
	
	$HUI.combobox("#UseRangeWin", {
		valueField:"id",
		textField:"text",
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'U',text:$g('����')},
			{id:'S',text:$g('ȫ��'), selected:'true'}
		]
	});
}

function InitData() {
	InitSymptomsData();
	InitGroupsListData();
	InitOrdSetsListData();
	InitSymptomsListData();
	InitAnalysisResultCondition();
}

// �����б�
function InitSymptomsData() {
	$HUI.datagrid("#Symptoms", {
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.PositiveRecord",
			QueryName:"FindPositiveRecord",
			Type:"Q"
		},
		
		collapsible: true, //�����������
		lines:true,
		striped:true, // ���ƻ�
		rownumbers:true,
		border:false,
		fit:true,
		fitColumns:true,
		animate:true,
		//pagination:true,   // ���α�� ���ܷ�ҳ
		//pageSize:25,
		//pageList:[10,25,50,100],	
		singleSelect: false,
		checkOnSelect: true, //���Ϊfalse, ���û����ڵ���ø�ѡ���ʱ��Żᱻѡ�л�ȡ��
		selectOnCheck: true,
		
		columns:[[
			{field:'ID', title:'ID', hidden:true},
			{field:'Code', title:'Code', hidden:true},
			{field:'MSeq', title:'MSeq', hidden:true},
			{field:'FSeq' ,title:'FSeq', hidden:true},
			{field:'TUseRange', title:'TUseRange', hidden:true},
			
			{field:'SymptomsID', title:'ѡ��', align:'center', checkbox:true},
			{field:'Name', title:'��������', width:80}
		]],
		
		onClickRow: function (rowIndex, rowData) {  // ѡ�����¼�
		},
		onDblClickRow: function (rowIndex, rowData) {  // ˫�����¼�
		},
		onLoadSuccess:function(data){
		}
	});
}

// �����б�
function InitGroupsListData() {
	$HUI.datagrid("#Groups", {
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.Report.GroupCollect",
			QueryName:"GADMList",
			GBIDesc:"",
			ContractID:""
		},
		collapsible: true, //�����������
		lines:true,
		striped:true, // ���ƻ�
		rownumbers:true,
		border:false,
		fit:true,
		fitColumns:true,
		animate:true,
		//pagination:true,   // ���α�� ���ܷ�ҳ
		//pageSize:25,
		//pageList:[10,25,50,100],	
		singleSelect: false,
		checkOnSelect: true, //���Ϊfalse, ���û����ڵ���ø�ѡ���ʱ��Żᱻѡ�л�ȡ��
		selectOnCheck: true,
		columns:[[
			{field:'TGRowId', title:'TGRowId', hidden:true},
			{field:'TGDesc', title:'TGDesc', hidden:true},
			{field:'TAdmDate', title:'TAdmDate', hidden:true},
			
			{field:'GroupsID', title:'ѡ��', align:'center', checkbox:true},
			{field:'GroupsDesc', title:'��������', width:8, formatter: function(value, rowData, rowIndex) {
				var title="";
				if (rowData.TGRowId == ("ALLI")) {
					title="ȫ������"
				} else if (rowData.TGRowId == ("ALLG")) {
					title="ȫ������"
				} else {
					title="�������ڣ�" + rowData.TAdmDate
				}
				return "<a id='GroupsDesc_" + rowData.TGRowId + "' href='#' title='"
						+ title
						+ "' class='hisui-tooltip' data-options='position:\"right\",showDelay:50' style='text-decoration: none;color: black;'>"
						+ rowData.TGDesc + "</a>";
				}
			}
		]],	
		onClickRow: function (rowIndex, rowData) {  // ѡ�����¼�
		},
		onDblClickRow: function (rowIndex, rowData) {  // ˫�����¼�
		},
		onLoadSuccess:function(data){
		}
	});
}

// �ײ��б�
function InitOrdSetsListData() {
	$HUI.datagrid("#OrdSets", {
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.HISUIOrderSets",
			QueryName:"SearchPEOrderSets",
			UserID:"",
			subCatID:"",
			Conditiones:"",
			Desc:""
		},
		collapsible: true, //�����������
		lines:true,
		striped:true, // ���ƻ�
		rownumbers:true,
		border:false,
		fit:true,
		fitColumns:true,
		animate:true,
		//pagination:true,   // ���α�� ���ܷ�ҳ
		//pageSize:25,
		//pageList:[10,25,50,100],	
		singleSelect: false,
		checkOnSelect: true, //���Ϊfalse, ���û����ڵ���ø�ѡ���ʱ��Żᱻѡ�л�ȡ��
		selectOnCheck: true,
		columns:[[
			{field:'ARCOSRowid', title:'RowId', hidden:true},
			{field:'ARCOSDesc', title:'ARCOSDesc', hidden:true},
			{field:'BreakDesc', title:'BreakDesc', hidden:true},  // ���
			{field:'SexDesc', title:'SexDesc', hidden:true},  // �Ա�
			{field:'VIPDesc',title:'VIPDesc', hidden:true},  
			
			{field:'OrdSetsID', title:'ѡ��', align:'center', checkbox:true},
			{field:'OrdSetsDesc', title:'�ײ�����', width:8, formatter: function(value, rowData, rowIndex) {
				var title = "�Ա�" + rowData.SexDesc + "\r\nVIP�ȼ���" + rowData.VIPDesc;
				return "<a id='OrdSetsDesc_" + rowData.ARCOSRowid + "' href='#' title='"
						+ title
						+ "' class='hisui-tooltip' data-options='position:\"right\",showDelay:50' style='text-decoration: none;color: black;'>"
						+ rowData.ARCOSDesc + "</a>";
				}
			}
			
		]],	
		onClickRow: function (rowIndex, rowData) {  // ѡ�����¼�
		},
		onDblClickRow: function (rowIndex, rowData) {  // ˫�����¼�
		},
		onLoadSuccess:function(data){
		}
	});
}

// ������ѯ
function BQuery_click() {
	var errStr = tkMakeServerCall("web.DHCPE.Statistic.IllnessStatistic", "GetResultAnalysisErrInfo", glabalType);
	var errInfo = errStr.split("^");
	if (errInfo[0] != "0") {
		$.messager.alert("��ʾ", "�޷����沢���£�" + errInfo[1], "info");
		// $.messager.popover({msg:"�޷����沢���£�" + errInfo[1], type:"alert", timeout: 3000, showType:"slide"});
		if (errInfo[0] == "1") {
			$('#BSetAllTarget').linkbutton('disable');
		} else {
			$('#BSetAllTarget').linkbutton('enable');
		}
		return false;
	} else {
		$('#BSetAllTarget').linkbutton('disable');
	}
	
	//var BeginDate = "", EndDate = "", Type = "", AgeRange = "", SexDR = "N", PositiveRecords = "", PGADM = "", Other = ""
	var BeginDate = $("#BeginDate").datebox('getValue');
	if (BeginDate == "") {
		$.messager.alert("��ʾ", "�����뿪ʼ���ڣ�", "info");
		// $.messager.popover({msg:"�����뿪ʼ���ڣ�", type:"alert", timeout: 3000, showType:"slide"});
		return false;
	}
	
	var EndDate = $("#EndDate").datebox('getValue');
	if (EndDate == "") { 
		$.messager.alert("��ʾ", "������������ڣ�", "info");
		// $.messager.popover({msg:"������������ڣ�", type:"alert", timeout: 3000, showType:"slide"});
		return false;
	}
	
	var PositiveRecords = "";  // ����  $ �ָ�
	var SymptomsRows = $("#Symptoms").datagrid("getChecked");  //��ȡ�������飬��������
	for(var i = 0; i <SymptomsRows.length; i++){
		if (PositiveRecords == "") PositiveRecords = SymptomsRows[i].ID;
		else PositiveRecords = PositiveRecords + "$" + SymptomsRows[i].ID;
	}
	if (PositiveRecords == "") {
		$.messager.alert("��ʾ", "��ѡ�������ٲ�ѯ��", "info"); 
		// $.messager.popover({msg:"��ѡ�������ٲ�ѯ��", type:"alert", timeout: 3000, showType:"slide"});
		return false;
	}
	
	var AgeGroup = $("#AgeGroup").combobox('getValue');
	if (AgeGroup == "") { 
		$.messager.alert("��ʾ", "��ѡ��������ٲ�ѯ��", "info"); 
		//$.messager.popover({msg:"��ѡ��������ٲ�ѯ��", type:"alert", timeout: 3000, showType:"slide"}); 
		return false; 
	}
	var AgeNum = AgeGroup.split(",")[2];
	
	var AgeRange = $("#AgeFrom").val() + "-" + $("#AgeTo").val();
	var SexDR = $("#Sex").combobox('getValue');
	
	var GADM = "";  // ����ID DHC_PE_GADM  $ �ָ�
	var GroupsRows = $("#Groups").datagrid("getChecked");  //��ȡ�������飬��������
	for(var i = 0; i < GroupsRows.length; i++) {
		if (GADM == "") GADM = GroupsRows[i].TGRowId;
		else GADM = GADM + "$" + GroupsRows[i].TGRowId;
	}
	
	var PreOrdSets = "";   // �ײ�   $ �ָ�
	var OrdSetsRows = $("#OrdSets").datagrid("getChecked");  //��ȡ�������飬��������
	for(var i = 0; i < OrdSetsRows.length; i++) {
		if (PreOrdSets == "") PreOrdSets = OrdSetsRows[i].ARCOSRowid;
		else PreOrdSets = PreOrdSets + "$" + OrdSetsRows[i].ARCOSRowid;
	}
	
	var Other = AgeGroup + "$" + PreOrdSets;   // ����� ^ �ײ�
	var CurLocDr = session["LOGON.CTLOCID"];
	
	var src = "&BeginDate=" + BeginDate
			+ "&EndDate=" + EndDate
			+ "&Type=" + glabalType
			+ "&AgeRange=" + AgeRange
			+ "&AgeGroup=" + AgeGroup
			+ "&SexDR=" + SexDR
			+ "&PositiveRecords=" + PositiveRecords
			+ "&GADM=" + GADM
			+ "&Other=" + Other
			+ "&ShowList=" + ""
			+ "&CurLocDr=" + CurLocDr
			;
	//alert(src);
	
	ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=DHCPEResultAnalysis" + AgeNum + ".raq" + src);
	// $("#ReportFile").attr("src", "dhccpmrunqianreport.csp?reportName=DHCPEResultAnalysis" + AgeNum + ".raq" + src);
	
}

// ��������ָ��
function SetAllTarget() {
	
	var errStr = tkMakeServerCall("web.DHCPE.Statistic.IllnessStatistic", "GetResultAnalysisErrInfo", glabalType);
	var errInfo = errStr.split("^");
	if (errInfo[0] == "1") {
		$.messager.alert("��ʾ", errInfo[1], "info");
		// $.messager.popover({msg:"�޷����沢���£�" + errInfo[1], type:"alert", timeout: 3000, showType:"slide"});
		return false;
	}
	
	$.messager.confirm("��������ָ��", "������������ָ�꣬���Ȱ����е�ָ��ɾ�����������ɣ��Ƿ������", function (r) {
		if (r) {
			$.m({
				ClassName:"web.DHCPE.Statistic.IllnessStatistic",
				MethodName:"SetAllTarget",
				Type:glabalType
			}, function(ret) {
				if (ret == "OVER") {
					$.messager.alert("��ʾ", "���³ɹ�", "info");
				} else {
		    		$.messager.alert("��ʾ", "����ʧ��", "info");
				}
			});
		}
	});
}

// �����ѯ
function SearchGBIDesc() {
	var ContractID = $("#ContractID").combobox("getValue");
	var GBIDesc = $("#GBIDesc").val();
	
	$("#Groups").datagrid("load", {ClassName:"web.DHCPE.Report.GroupCollect",QueryName:"GADMList",GBIDesc:GBIDesc,ContractID:ContractID});
}

// �ײͲ�ѯ
function SearchOSDesc() {
	var OSDesc = $("#OSDesc").val();
	
	$("#OrdSets").datagrid("load", {ClassName:"web.DHCPE.HISUIOrderSets",QueryName:"SearchPEOrderSets",UserID:"",subCatID:"",Conditiones:"",Desc:OSDesc});
}

// ��ʾ��������ά������
function ShowSymptomsEditWin(){
	var new_Width = ScreenWidth - 100;
	var new_Height = ScreenHeight - 100;
	
    $("#SymptomsEditWin").css("width", new_Width);
    $("#SymptomsEditWin").css("height", new_Height);
    
	//BClear_click("Win");
	$("#SymptomsEditWin").show();

	var myWin = $HUI.dialog("#SymptomsEditWin", {
		iconCls:"icon-w-add",
		resizable:true,
		title:"��������ά��",
		modal:true,
		buttonAlign:"center",
	});
}

// ����ά�� ����
function InitSymptomsListData() {
	$HUI.datagrid("#SymptomsList", {
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.PositiveRecord",
			QueryName:"FindPositiveRecord",
			Type:"Q"
		},
		columns:[[
			{field:'ID', title:'ID', hidden:true},
			
			{field:'Code', title:'��������'},
			{field:'Name', title:'��������'},
			{field:'MSeq', title:'����˳��'},
			{field:'FSeq', title:'Ů��˳��'},  
			{field:'TUseRange', title:'���÷�Χ', formatter: function(value, rowData, rowIndex) {
					if (value == "��") { return "����"; }
					else if (value == "��") { return "ȫ��"; }
					else if (value == "U") { return "����"; }
					else if (value == "S") { return "ȫ��"; }
					return "";
				}
			}
		]],
		collapsible: true, //�����������
		lines:true,
		striped:true, // ���ƻ�
		rownumbers:true,
		border:false,
		fit:true,
		fitColumns:true,
		animate:true,
		//pagination:true,   // ���α�� ���ܷ�ҳ
		//pageSize:25,
		//pageList:[10,25,50,100],
		
		showPageList:false,
		beforePageText:'��',
		afterPageText:'ҳ,��{pages}ҳ',
		pagination:true,
			
		singleSelect:true,
		toolbar: [{
			iconCls: 'icon-add',
			text:'����',
			handler: function(){
				
				BClear_click("Win");
				$("#SymptomsListOptWin").show();
				
				var myWin = $HUI.dialog("#SymptomsListOptWin", {
					iconCls:"icon-w-add",
					resizable:true,
					title:"����",
					modal:true,
					buttonAlign:"center",
					buttons:[{
						text:"����",
						handler:function(){
							BAdd_click();
						}
					},{
						text:"�ر�",
						handler:function(){
							myWin.close();
						}
					}]
				});
			}
		}, {
			iconCls: "icon-write-order",
			text:"�޸�",
			id:"BUpd",
			disabled:true,
			handler: function(){
				$("#SymptomsListOptWin").show();
				
				var SelRowData = $("#SymptomsList").datagrid("getSelected");
				if (!SelRowData) {
					$.messager.alert("��ʾ", "��ѡ����Ҫ�޸ĵ��У�", "info");
					//$.messager.popover({msg: "��ѡ����Ҫ�޸ĵ���", type:"alert"});
					return false;
				}
				$("#SymptomCodeWin").val(SelRowData.Code);  // �������
				$("#SymptomDescWin").val(SelRowData.Name);  // ��������
				$("#SymptomManSeqWin").numberbox("setValue", SelRowData.MSeq);  // ����˳��
				$("#SymptomFemanSeqWin").numberbox("setValue", SelRowData.FSeq);  // Ů��˳��
				if (SelRowData.TUseRange == "��" || SelRowData.TUseRange == "����") { $("#UseRangeWin").combobox("setValue", "U"); }
				else { $("#UseRangeWin").combobox("setValue", "S"); }
				
				var myWin = $HUI.dialog("#SymptomsListOptWin",{
					iconCls:'icon-w-edit',
					resizable:true,
					title:'�޸�',
					modal:true,
					buttonAlign:'center',
					buttons:[{
						text:'�޸�',
						handler:function(){
							BUpd_click();
						}
					},{
						text:'�ر�',
						handler:function(){
							myWin.close();
						}
					}]
				});
			}
		}],
		onClickRow: function (rowIndex, rowData) {  // ѡ�����¼�
			// $("#SymptomCode").val(rowData.Code);  // �������
			// $("#SymptomDesc").val(rowData.Name);  // ��������
			// $("#SymptomManSeq").numberbox("setValue", rowData.MSeq);  // ����˳��
			// $("#SymptomFemanSeq").numberbox("setValue", rowData.FSeq);  // Ů��˳��
			// $("#UseRange").combobox("setValue", rowData.TUseRange);  // ���÷�Χ
			
			$('#BUpd').linkbutton('enable');
			
			$("#AnalysisResultCondition").datagrid("load", {ClassName:"web.DHCPE.ExcuteExpress", QueryName:"FindExpress", ParrefRowId:rowData.ID, Type:"PR", CTLOCID:session["LOGON.CTLOCID"]}); 
			
			ConditioneditIndex = undefined;  // ���ÿɱ༭���к�
			
			$("#NorInfo").val("");
			
		},
		onDblClickRow: function (rowIndex, rowData) {  // ˫�����¼�
			//$("#SymptomsList").datagrid("unselectRow");
		},
		onLoadSuccess:function(data){
		}
	});
}

// ����ά�� ��ѯ
function BSearch_click(){
	var SymptomCode = $("#SymptomCode").val();  // �������
	var SymptomDesc = $("#SymptomDesc").val();  // ��������
	var UserID = session["LOGON.USERID"];
	var SymptomManSeq = $("#SymptomManSeq").val();  // ����˳��
	var SymptomFemanSeq = $("#SymptomFemanSeq").val();  // Ů��˳��
	var UseRange = $("#UseRange").combobox("getValue");  // ���÷�Χ
	if (UseRange == "") { UseRange = "S"; }
	
	$HUI.datagrid("#SymptomsList", {
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.PositiveRecord",
			QueryName:"FindPositiveRecord",
			Type:"Q",
			iCode:SymptomCode,
			iDesc:SymptomDesc,
			iMSeq:SymptomManSeq,
			iFSeq:SymptomFemanSeq,
			iUserRange:UseRange
		}
	});
}

// ����ά�� ����
function BAdd_click() {
	var SymptomCode = $("#SymptomCodeWin").val();  // �������
	if (SymptomCode == "") {
		$.messager.alert("��ʾ", "������������ţ�", "info");
		//$.messager.popover({msg: '������������ţ�',type:'alert'});
		return false;
	}
	
	var SymptomDesc = $("#SymptomDescWin").val();  // ��������
	if (SymptomDesc == "") { $.messager.alert("��ʾ","����������������","info"); return false; }
	
	var UserID = session["LOGON.USERID"];
	if (UserID == "") { $.messager.alert("��ʾ", "δ��ȡ���û���Ϣ�������µ�½��","info"); return false; }
	
	var SymptomManSeq = $("#SymptomManSeqWin").val();  // ����˳��
	var SymptomFemanSeq = $("#SymptomFemanSeqWin").val();  // Ů��˳��
	var UseRange = $("#UseRangeWin").combobox("getValue");  // ���÷�Χ
	if (UseRange == "") { UseRange = "S"; }
	
	var InString = "" + "^" + SymptomCode + "^" + SymptomDesc + "^" + SymptomManSeq + "^" + SymptomFemanSeq + "^" + UseRange + "^" + UserID;
	$.m({
		ClassName:"web.DHCPE.PositiveRecord",
		MethodName:"Update",
		InString:InString,
		Type:"Q"
	},function(ret){
		var Id=ret.split("^")[1];
		ret=ret.split("^")[0];
		if (ret != "0") {
			$.messager.alert("��ʾ", "����ʧ�ܣ�����ԭ��������Ż����������ظ���", "error");
			return false;
		}
		$.messager.alert("��ʾ", "�����ɹ���", "success");
		
		$("#SymptomsList").datagrid("insertRow", {
			index:0,
			row:{
				ID:Id,
				Code:SymptomCode,
				Name:SymptomDesc,
				MSeq:SymptomManSeq,
				FSeq:SymptomFemanSeq,  
				TUseRange:(UseRange="��"?"����":"ȫ��")
			}
		});
		$("#SymptomsListOptWin").window("close");
		$("#SymptomsList").datagrid('load',{
			    ClassName:"web.DHCPE.PositiveRecord",
				QueryName:"FindPositiveRecord",
				Type:"Q",
				iCode:$("#SymptomCode").val(),
				iDesc:$("#SymptomDesc").val(),
				iMSeq:$("#SymptomManSeq").val(),
				iFSeq:$("#SymptomFemanSeq").val(),
				iUserRange:$("#UseRange").combobox("getValue")
			
			    });

		// BClear_click("");
	});			
}

// ����ά�� �޸�
function BUpd_click() {
	var SymptomsId = "";
	var SelRowData = $("#SymptomsList").datagrid("getSelected");
	if (SelRowData) SymptomsId = SelRowData.ID;
	if (SymptomsId == "") { $.messager.alert("��ʾ", "��ѡ����Ҫ�޸ĵ��У�", "info"); return false; }
	
	var SymptomCode = $("#SymptomCodeWin").val();  // �������
	if (SymptomCode == "") { $.messager.alert("��ʾ", "������������ţ�", "info"); return false; }
	
	var SymptomDesc = $("#SymptomDescWin").val();  // ��������
	if (SymptomDesc == "") { $.messager.alert("��ʾ", "����������������", "info"); return false; }
	
	var UserID = session["LOGON.USERID"];
	if (UserID == "") { $.messager.alert("��ʾ", "δ��ȡ���û���Ϣ�������µ�½��", "info"); return false; }
	
	var SymptomManSeq = $("#SymptomManSeqWin").val();  // ����˳��
	var SymptomFemanSeq = $("#SymptomFemanSeqWin").val();  // Ů��˳��
	var UseRange = $("#UseRangeWin").combobox("getValue");  // ���÷�Χ
	if (UseRange == "" || UseRange == "1") { UseRange = "S"; }
	
	var InString = SymptomsId + "^" + SymptomCode + "^" + SymptomDesc + "^" + SymptomManSeq + "^" + SymptomFemanSeq + "^" + UseRange + "^" + UserID;
	
	$.m({
		ClassName:"web.DHCPE.PositiveRecord",
		MethodName:"Update",
		InString:InString,
		Type:"Q"
	},function(ret){
		var Id=ret.split("^")[1];
		ret=ret.split("^")[0];
		if (ret != "0") {
			$.messager.alert("��ʾ", "�޸�ʧ�ܣ�����ԭ��������Ż����������ظ���", "error");
			return false;
		}
		$.messager.alert("��ʾ","�޸ĳɹ���","success");
		
		var SelRowData = $("#SymptomsList").datagrid("getSelected");
		var SelRowIndex = $("#SymptomsList").datagrid("getRowIndex", SelRowData);
		$("#SymptomsList").datagrid("updateRow", {
			index:SelRowIndex,
			row:{
				ID:Id,
				Code:SymptomCode,
				Name:SymptomDesc,
				MSeq:SymptomManSeq,
				FSeq:SymptomFemanSeq,  
				TUseRange:(UseRange=="��"?"����":"ȫ��")
			}
		});
		
		$("#SymptomsListOptWin").window("close");
		$("#SymptomsList").datagrid('load',{
		    ClassName:"web.DHCPE.PositiveRecord",
			QueryName:"FindPositiveRecord",
			Type:"Q",
			iCode:$("#SymptomCode").val(),
			iDesc:$("#SymptomDesc").val(),
			iMSeq:$("#SymptomManSeq").val(),
			iFSeq:$("#SymptomFemanSeq").val(),
			iUserRange:$("#UseRange").combobox("getValue")
		});
	}); 
}

// ����ά�� ����
function BClear_click(Type) {
	if (Type == "Win") {
		$("#SymptomCodeWin").val("");  // �������
		$("#SymptomDescWin").val("");  // ��������
		$("#SymptomManSeqWin").numberbox("setValue", "");  // ����˳��
		$("#SymptomFemanSeqWin").numberbox("setValue", "");  // Ů��˳��
		$("#UseRangeWin").combobox("setValue", "S");  // ���÷�Χ
	} else {
		$("#SymptomCode").val("");  // �������
		$("#SymptomDesc").val("");  // ��������
		$("#SymptomManSeq").numberbox("setValue", "");  // ����˳��
		$("#SymptomFemanSeq").numberbox("setValue", "");  // Ů��˳��
		$("#UseRange").combobox("setValue", "S");  // ���÷�Χ
		//SetRowStyle("#SymptomsList");
	}
}

// ����ά�� ���ʽ
function InitAnalysisResultCondition() {
	$HUI.datagrid("#AnalysisResultCondition",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.ExcuteExpress",
			QueryName:"FindExpress",
			ParrefRowId:"",
			Type:"",
			CTLOCID:session["LOGON.CTLOCID"]
		},
		fit:true,
		border:false,
		striped:true,
		fitColumns:true,
		autoRowHeight:false,
		singleSelect:true,
		selectOnCheck:false,
		columns:[[
		    {field:"TPreBracket", title:"ǰ������", editor:{
					type:"combobox",
					options:{
						valueField:"id",
						textField:"text",
						data:[
							{id:"(",text:"("}, {id:"((",text:"(("}, {id:"(((",text:"((("}, {id:"((((",text:"(((("}, {id:"(((((",text:"((((("}
						]
					}
				}
		    },	
		    {field:"TItemID", title:"��Ŀ", width:130, formatter:function(value,row){
					return row.TItem;
				}, editor:{
					type:'combobox',
					options:{
						valueField:'OD_RowId',
						textField:'OD_Desc',
						method:'get',
						//mode:'remote',
						url:$URL+"?ClassName=web.DHCPE.Report.PosQuery&QueryName=FromDescOrderDetailB&CTLOCID=" + session["LOGON.CTLOCID"] + "&ResultSetType=array",
						onBeforeLoad:function(param){
							//param.Desc = param.q;
						},
						onSelect:function (rowData) {
							var String = "^" + rowData.OD_Code + "^" + rowData.OD_RowId;
							
							var NorInfo = tkMakeServerCall("web.DHCPE.ODStandard", "GetNorInfo", String);
							$("#NorInfo").val(NorInfo);
						}
						
					}
					
					/*
					type:"combogrid",
					options:{
						panelWidth:235,
						url:$URL + "?ClassName=web.DHCPE.Report.PosQuery&QueryName=FromDescOrderDetail",
						mode:"remote",
						delay:200,
						idField:"OD_RowId",
						textField:"OD_Desc",
						onBeforeLoad:function (param) {
							param.Desc = param.q;
						},
						onSelect:function (rowIndex, rowData) {
							var String = "^" + rowData.OD_Code + "^" + rowData.OD_RowId;
							
							var NorInfo = tkMakeServerCall("web.DHCPE.ODStandard", "GetNorInfo", String);
							$("#NorInfo").val(NorInfo);
						},
						columns:[[
							{field:"OD_RowId", title:"ID"},
							{field:"OD_Desc", title:"����", width:120},
							{field:"OD_Code", title:"����", width:100}
						]]
					}
					*/
		    	}
		    },
		    {field:"TOperator", title:"�����", align:"center", formatter: function(value,row){
					return row.TOperatorname;
				}, editor:{
					type:"combobox",
					options:{
						valueField:"id",
						textField:"text",
						data:[
							{id:">",text:"����"}, {id:">=",text:"���ڵ���"}, {id:"<",text:"С��"}, {id:"<=",text:"С�ڵ���"},
							{id:"[",text:"����"}, {id:"'[",text:"������"}, {id:"=",text:"����"}, {id:"'=",text:"������"}
						]
					}
				}
		    },
			{field:"TReference", title:"�ο�ֵ", width:70, editor:"text"},
			{field:"TSex", title:"�Ա�", align:"center", formatter:function(value,row){
					return row.TSexname;
				}, editor:{
					type:"combobox",
					options:{
						valueField:"id",
						textField:"text",
						data:[
							{id:"N",text:"����"}, {id:"M",text:"��"}, {id:"F",text:"Ů"}
						]
					}
				}
			},
			{field:"TNoBloodFlag", title:"��Ѫ", align:"center", editor:{
					type:"icheckbox",
					options:{on:"Y",off:"N"}
				}
			},
			{field:"TAgeRange", title:"����", align:"center", editor:"text"},
			{field:"TAfterBracket", title:"��������", editor:{
					type:"combobox",
					options:{
						valueField:"id",
						textField:"text",
						data:[
							{id:")",text:")"}, {id:"))",text:"))"}, {id:")))",text:")))"}, {id:"))))",text:"))))"}, {id:")))))",text:")))))"}
						]
					}
				}
			},
			{field:"TRelation", title:"��ϵ", align:"center", formatter:function(value,row){
					return row.TRelationname;
				}, editor:{
					type:"combobox",
					options:{
						valueField:"id",
						textField:"text",
						data:[
							{id:"||",text:"����"}, {id:"&&",text:"����"}
						]
					}
				}
			},
			{field:"TAdd", title:"����һ��", align:"center", editor:{
					type:"linkbutton",
					options:{
						text:"����һ��",
						handler:function(){
							var NewConditioneditIndex = ConditioneditIndex + 1;
							ConditionendEditing();
							$("#AnalysisResultCondition").datagrid("insertRow", {
								index: NewConditioneditIndex,
								row: {
									TPreBracket:"",
									TItemID:"",
									TOperator:"",
									TReference:"",
									TSex:"",
									TNoBloodFlag:"",
									TAgeRange:"",
									TAfterBracket:"",
									TRelation:"",
									TAdd:"����һ��",
									TDelete:"ɾ��һ��"
								}
							});
							$("#AnalysisResultCondition").datagrid("selectRow", NewConditioneditIndex).datagrid("beginEdit", NewConditioneditIndex);
							ConditioneditIndex = NewConditioneditIndex;
						}
					}
				}
			},
			{field:"TDelete", title:"ɾ��һ��", align:"center", editor: {
					type:"linkbutton",
					options:{
						text:"ɾ��һ��",
						handler:function() {
							$("#AnalysisResultCondition").datagrid("deleteRow",ConditioneditIndex);
							ConditioneditIndex = undefined;
						}
					}
				}
			}
		]],
		onClickRow: function (rowIndex, rowData) {
			ConditionClickRow(rowIndex);
		},
		onAfterEdit: function (rowIndex,rowData,changes) {
			
		},
		onSelect: function (rowIndex, rowData) {
		}
	});	
}

var ConditioneditIndex = undefined;
function ConditionClickRow(index) {
	if (ConditioneditIndex != index) {
		if (ConditionendEditing()){
			$("#AnalysisResultCondition").datagrid("getRows")[index]["TAdd"] = "����һ��";
			$("#AnalysisResultCondition").datagrid("getRows")[index]["TDelete"] = "ɾ��һ��";
			$("#AnalysisResultCondition").datagrid("selectRow", index).datagrid("beginEdit", index);
						
			ConditioneditIndex = index;
		} else {
			$("#AnalysisResultCondition").datagrid("selectRow", ConditioneditIndex);
		}
	}
}

function ConditionendEditing(){
	if (ConditioneditIndex == undefined) { return true; }
	if ($("#AnalysisResultCondition").datagrid("validateRow", ConditioneditIndex)) {
		
		// ϸ��
		var ed = $("#AnalysisResultCondition").datagrid("getEditor", {index:ConditioneditIndex, field:"TItemID"});
		if (ed == null) { return true; }
		var ItemDesc = $(ed.target).combobox("getText");
		$("#AnalysisResultCondition").datagrid("getRows")[ConditioneditIndex]["TItem"] = ItemDesc;
		
		// ������
		var ed = $("#AnalysisResultCondition").datagrid("getEditor", {index:ConditioneditIndex, field:"TOperator"});
		if (ed == null) { return true; }
		var TOperatorname = $(ed.target).combobox("getText");
		$("#AnalysisResultCondition").datagrid("getRows")[ConditioneditIndex]["TOperatorname"] = TOperatorname;
		
		// �Ա�
		var ed = $("#AnalysisResultCondition").datagrid("getEditor", {index:ConditioneditIndex, field:"TSex"});
		if (ed == null) { return true; }
		var TSexname = $(ed.target).combobox("getText");
		$("#AnalysisResultCondition").datagrid("getRows")[ConditioneditIndex]["TSexname"] = TSexname;
		
		// ��ϵ
		var ed = $("#AnalysisResultCondition").datagrid("getEditor", {index:ConditioneditIndex, field:"TRelation"});
		if (ed == null) { return true; }
		var TRelationname = $(ed.target).combobox("getText");
		$("#AnalysisResultCondition").datagrid("getRows")[ConditioneditIndex]["TRelationname"] = TRelationname;
		
		$("#AnalysisResultCondition").datagrid("endEdit", ConditioneditIndex);
				
		ConditioneditIndex = undefined;
		return true;
	} else {
		return false;
	}
}

// ����ά�� ���ʽ����
function BSave_click() {
	ConditionendEditing();
	
	var ParrefRowId = ""
	var SelRowData = $("#SymptomsList").datagrid("getSelected");
	if (SelRowData) ParrefRowId = SelRowData.ID;
	if (ParrefRowId == "") {
		$.messager.alert("��ʾ", "����ѡ��������ά����Ӧ�ı��ʽ��", "info");
		return false;
	}
	
	$("#ConfirmSaveWin").show();
	
	// �˴������Ӱ�ť��ȡ������¼� ���������ѵ������
	$("#BSaveAndUpdWin").unbind("click");
	$("#BSaveWin").unbind("click");
	$("#BCancelWin").unbind("click");
	
	var myWin = $HUI.dialog("#ConfirmSaveWin", {
		iconCls:"icon-w-star",
		title:"��Ҫ��ʾ",
		modal:true,
		buttonAlign:"center",
		/*
		buttons:[{
			text:"&nbsp;���沢����&nbsp;",
			handler:function() {
				if (Save(ParrefRowId)) {
					var Info = $.m({ClassName:"web.DHCPE.Statistic.IllnessStatistic", MethodName:"SetResultAnalysisTargetByPR", Type:glabalType, PositiveRecord:ParrefRowId}, false);
					if(Info != "") {
						$.messager.alert("��ʾ","" + Info,"info");
					} else {
						$.messager.popover({msg:"��������ָ�ꡣ", type:"success", timeout: 5000, showType:"slide"});
					}
				} else {
					//$.messager.alert("��ʾ","���ʽ����ʧ�ܣ�","info");
				}
				myWin.close();
			}
		},{
			text:"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;",
			handler:function(){
				Save(ParrefRowId);
				myWin.close();
			}
		},{
			text:"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ȡ��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;",
			handler:function(){
				myWin.close();
			}
		}]
		*/
	});
	
	$("#BSaveAndUpdWin").click(function() {  // ���沢����
		var errStr = tkMakeServerCall("web.DHCPE.Statistic.IllnessStatistic", "GetResultAnalysisErrInfo", glabalType);
		var errInfo = errStr.split("^");
		if (errInfo[0] != "0") {
			$.messager.alert("��ʾ", "�޷����沢���£�" + errInfo[1], "info");
			// $.messager.popover({msg:"�޷����沢���£�" + errInfo[1], type:"alert", timeout: 3000, showType:"slide"});
			if (errInfo[0] == "1") {
				$('#BSetAllTarget').linkbutton('disable');
			} else {
				$('#BSetAllTarget').linkbutton('enable');
			}
			return false;
		} else {
			$('#BSetAllTarget').linkbutton('disable');
		}
		
		if (Save(ParrefRowId)) {
			var Info = $.m({ClassName:"web.DHCPE.Statistic.IllnessStatistic", MethodName:"SetResultAnalysisTargetByPR", Type:glabalType, PositiveRecord:ParrefRowId}, false);
			if(Info != "") {
				$.messager.alert("��ʾ","" + Info,"info");
			} else {
				$.messager.popover({msg:"��������ָ�ꡣ", type:"success", timeout: 5000, showType:"slide"});
			}
		} else {
			//$.messager.alert("��ʾ","���ʽ����ʧ�ܣ�","info");
		}
		myWin.close();
	});
	
	$("#BSaveWin").click(function() {  // ����
		Save(ParrefRowId);
		myWin.close();
	});
	
	$("#BCancelWin").click(function() {  // ȡ��
		myWin.close();
	});
		
}

function Save(ParrefRowId) {
	var Char_1 = String.fromCharCode(1);
	var Express = "";
	var rows = $("#AnalysisResultCondition").datagrid("getRows"); 
	
	for(var i=0; i<rows.length; i++){
		var OneRowInfo = "", Select = "N", PreBracket = "", ItemID = "", Operator = "", ODStandardID = "", Reference = "", AfterBracket = "", Relation =" ", Sex = "N";
		
		ItemID = rows[i].TItemID;
		
		if (ItemID == "") {
			//$.messager.alert("��ʾ", "��" + (i+1) + "�У�û�лس�ѡ��������Ŀ��", "info");
			break;
			//return false;
		}
		
		PreBracket = rows[i].TPreBracket;
		AfterBracket = rows[i].TAfterBracket;
		Relation = rows[i].TRelation;
		Operator = rows[i].TOperator;
		Reference = rows[i].TReference;
		Sex = rows[i].TSex;
		if (Sex == "") { Sex = "N"; }
		NoBloodFlag = rows[i].TNoBloodFlag;
		ODStandardID = "";
		AgeRange = rows[i].TAgeRange;
		if(AgeRange != "") {
			if(AgeRange.indexOf("-") == -1) {
				$.messager.alert("��ʾ", "�������䷶Χ��ʽ����ȷ,ӦΪ10-20!", "info");
				return false;
			}
			var AgeMin=AgeRange.split("-")[0];
			var AgeMax=AgeRange.split("-")[1];
			if((isNaN(AgeMin)) || (isNaN(AgeMax))) {
				$.messager.alert("��ʾ","�������䲻������!","info");
				return false;
			}
		}
		OneRowInfo = PreBracket + "^" + ItemID + "^" + Operator + "^" + ODStandardID + "^" + Reference + "^" + Sex + "^" + AfterBracket + "^" + Relation + "^" + NoBloodFlag + "^" + AgeRange;
		
		if (Express != "") {
			Express = Express + Char_1 + OneRowInfo;
		}else{
			Express = OneRowInfo;
		}
	}
	
	var iType = "PR";
	var ret = tkMakeServerCall("web.DHCPE.ExcuteExpress","SaveNewExpress",iType,ParrefRowId,Express);
	
	if (ret == 0){
		$("#AnalysisResultCondition").datagrid("load",{ClassName:"web.DHCPE.ExcuteExpress",QueryName:"FindExpress",ParrefRowId:ParrefRowId,Type:"PR",CTLOCID:session["LOGON.CTLOCID"]});
		return true;
	} else {
		return false;
	}
	return false;
}

function SetRowStyle(tablename) {
	var rows = $(tablename).datagrid("getRows");
	for(var i=0;i<rows.length;i++) {
		var tableDiv = tablename.replace(/List/g, "Div");
		var gridTrbar = $(tableDiv+" .datagrid-btable tbody tr:nth-child(" + ( i + 1 ) + ")");
		if (gridTrbar) {
			if ( (i % 2) == 0) {
				gridTrbar.css("background-color", "#FAFAFA");
			} else {
				gridTrbar.css("background-color", "#FFFFFF");
			}
		}
	}
}

function OnPropChanged(event, Type) {
	if (event.propertyName.toLowerCase() == "value") {
		if (Type == "Groups") {
			SearchGBIDesc();
		} else if (Type == "OrdSets") {
			SearchOSDesc();
		}
	}
}