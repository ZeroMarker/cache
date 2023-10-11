// dhcpe.ct.djdtemplate.js
// dhcpe.ct.djdtemplate.csp
// ���쵥��ʽԤ��

$(function(){
	InitCombo();
	
	$("#Btn-Save").click(function() {
		Save();
	});
	
	$("#Btn-Reset").click(function() {
		Reset();
	});
	
	$("#Btn-Print").click(function() {
		Print();
	});
	Reset();
});

function InitCombo() {
	// Head  �������� dhcpe/ct/viplevel.js ҲҪ�޸�
	$HUI.combobox("#DJDHead", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'H-Simple',text:'��'},
			{id:'H-General',text:'����'},
			{id:'H-Fully',text:'ȫ��'},
			{id:'H-Custom',text:'�Զ���'}
		],
		onSelect:function(record) {   // ѡ��
			var Part = record.id;
			SelTemplate("H", Part + "^^");
		},
		onLoadSuccess:function(data) {
		}
	});
	
	// Body  �������� dhcpe/ct/viplevel.js ҲҪ�޸�
	$HUI.combobox("#DJDBody", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'B-Formatter1',text:'��Ŀ��ʽ1'},
			{id:'B-Formatter2',text:'��Ŀ��ʽ2'},
			{id:'B-Formatter3',text:'��Ŀ��ʽ3'},
			{id:'B-Formatter4',text:'��Ŀ��ʽ4'},
			{id:'B-Custom',text:'�Զ���'}
		],
		onSelect:function(record) {   // ѡ��
			var Part = record.id;
			SelTemplate("B", "^" + Part + "^");
		},
		onLoadSuccess:function(data) {
		}
	});
	
	// Foot  �������� dhcpe/ct/viplevel.js ҲҪ�޸�
	$HUI.combobox("#DJDFoot", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'F-NoFooter',text:'��ҳ��'},
			{id:'F-Pagination',text:'��ҳ��'},
			{id:'F-Tips',text:'����ʾ'},
			{id:'F-PageAndTips',text:'ҳ��+��ʾ'},
			{id:'F-Receive',text:'��ȡ��Ϣ'},
			{id:'F-Custom',text:'�Զ���'}
		],
		onSelect:function(record) {   // ѡ��
			var Part = record.id;
			SelTemplate("F", "^^" + Part);
		},
		onLoadSuccess:function(data) {
		}
	});
}

function SelTemplate(PageType, ShowPart) {
	var UserID = session["LOGON.USERID"];
	var LocID = session["LOGON.CTLOCID"];
	var HospID = session["LOGON.HOSPID"];
	var ExStrs = "Y^";  // �Զ�����չ��Ϣ   �Ѵ�ӡ���Ƿ������ӡ
	var url = "dhcpe.ct.djdtemplate.temporary.csp?PAADM=Temporary"
							
			+ "&Part=" + ShowPart
							
			+ "&ExStrs=" + ExStrs
			+ "&UserID=" + UserID
			+ "&LocID=" + LocID
			+ "&HospID=" + HospID
			;
	
	$.ajax({
		url:url,
		success: function (html) {
			var pHtml = $(html).find("#" + PageType + "-Div-Temporary").html();
			$("#" + PageType + "-Div-Temporary").html(pHtml);
		},
		error: function () {
			$.messager.alert("��ʾ", "�Ͽ����ӻ����ݳ���", "error");
		}
	});
}

function Save() {
	var ID = $("#ID").val();
	if (ID == "") {
		$.messager.alert("��ʾ", "��ѡ�����VIP�ȼ���", "info");
		return false;
	}
	var head = $("#DJDHead").combobox("getValue");
	var body = $("#DJDBody").combobox("getValue");
	var foot = $("#DJDFoot").combobox("getValue");
	
	$cm({
		ClassName:"web.DHCPE.CT.VIPLevel",
		MethodName:"UpdDJDDataForVIP",
		ID:ID,
		DJDData:head+"$"+body+"$"+foot+"^",
		UserID:session["LOGON.USERID"]
	},function(jsonData){
		if(jsonData.code == "0") {
			$.messager.alert("��ʾ", jsonData.msg, "info");
			websys_cancel();
		} else {
			$.messager.alert("��ʾ", jsonData.msg, "info");
			return false;
		}
	});
}

function Reset() {
	var HT = $("#HT").val();
	var BT = $("#BT").val();
	var FT = $("#FT").val();
	
	$("#DJDHead").combobox("setValue",(HT=="")?"H-General":HT);
	$("#DJDBody").combobox("setValue",(BT=="")?"B-Formatter1":BT);
	$("#DJDFoot").combobox("setValue",(FT=="")?"F-NoFooter":FT);
}

function Print() {
	var Id = $("#ID").val();
	PrintDJDByType(Id, "LocVIPLevel", "V", "", "Y^");  // DHCPEPrintDJDCommon.js
}