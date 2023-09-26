// DHCPEChargedReport.hisui.js
// by zhongricheng

$(function() {
	InitCombobox();
	
	$("#BSearch").click(function() {  
		BSearch_click();
    });
});

function InitCombobox() {
	// �շ�Ա
	$HUI.combobox("#UserCode", {
		url:$URL+"?ClassName=web.DHCPE.Statistic.Incomes&QueryName=OutChangedUserCode&ResultSetType=array",
		valueField:"UserCode",
		textField:"UserName",
		panelHeight:"auto",
		allowNull:true,
		editable:true,
		onSelect:function(record){
		},
		onChange:function(newValue, oldValue) {
		}
		
	});
}

// ������ѯ
function BSearch_click(){
	//var BeginDate = "", EndDate = "", UserCode = ""
	var BeginDate = $("#BeginDate").datebox('getValue');
	if (BeginDate == "") {
		$.messager.alert("��ʾ","�����������ʼ���ڣ�");
		//$.messager.popover({msg:"�����������ʼ���ڣ�", type:"alert", timeout: 3000, showType:"slide"});
		return false;
	}
	
	var EndDate = $("#EndDate").datebox('getValue');
	if (EndDate == "") {
		$.messager.alert("��ʾ","���������������ڣ�");
		//$.messager.popover({msg:"���������������ڣ�", type:"alert", timeout: 3000, showType:"slide"});
		return false;
	}
	
	var UserCode = $("#UserCode").combobox('getValue');
	if (UserCode == undefined || UserCode == "undefined") { var UserCode = ""; }
	var CurLoc = session["LOGON.CTLOCID"];
	
	var src = "&BeginDate=" + BeginDate
			+ "&EndDate=" + EndDate
			+ "&Type=" + "InvUser"
			+ "&UserCode=" + UserCode
			+ "&CurLoc=" + CurLoc
			;
	//alert(src);
	
	$("#ReportFile").attr("src", "dhccpmrunqianreport.csp?reportName=DHCPEChargedReport.raq" + src);
	
}