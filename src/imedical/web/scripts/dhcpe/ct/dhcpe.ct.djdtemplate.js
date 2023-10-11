// dhcpe.ct.djdtemplate.js
// dhcpe.ct.djdtemplate.csp
// 导检单格式预览

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
	// Head  加了数据 dhcpe/ct/viplevel.js 也要修改
	$HUI.combobox("#DJDHead", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'H-Simple',text:'简单'},
			{id:'H-General',text:'常规'},
			{id:'H-Fully',text:'全面'},
			{id:'H-Custom',text:'自定义'}
		],
		onSelect:function(record) {   // 选中
			var Part = record.id;
			SelTemplate("H", Part + "^^");
		},
		onLoadSuccess:function(data) {
		}
	});
	
	// Body  加了数据 dhcpe/ct/viplevel.js 也要修改
	$HUI.combobox("#DJDBody", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'B-Formatter1',text:'项目格式1'},
			{id:'B-Formatter2',text:'项目格式2'},
			{id:'B-Formatter3',text:'项目格式3'},
			{id:'B-Formatter4',text:'项目格式4'},
			{id:'B-Custom',text:'自定义'}
		],
		onSelect:function(record) {   // 选中
			var Part = record.id;
			SelTemplate("B", "^" + Part + "^");
		},
		onLoadSuccess:function(data) {
		}
	});
	
	// Foot  加了数据 dhcpe/ct/viplevel.js 也要修改
	$HUI.combobox("#DJDFoot", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'F-NoFooter',text:'无页脚'},
			{id:'F-Pagination',text:'仅页码'},
			{id:'F-Tips',text:'仅提示'},
			{id:'F-PageAndTips',text:'页码+提示'},
			{id:'F-Receive',text:'领取信息'},
			{id:'F-Custom',text:'自定义'}
		],
		onSelect:function(record) {   // 选中
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
	var ExStrs = "Y^";  // 自定义扩展信息   已打印的是否继续打印
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
			$.messager.alert("提示", "断开连接或数据出错！", "error");
		}
	});
}

function Save() {
	var ID = $("#ID").val();
	if (ID == "") {
		$.messager.alert("提示", "请选择科室VIP等级！", "info");
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
			$.messager.alert("提示", jsonData.msg, "info");
			websys_cancel();
		} else {
			$.messager.alert("提示", jsonData.msg, "info");
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