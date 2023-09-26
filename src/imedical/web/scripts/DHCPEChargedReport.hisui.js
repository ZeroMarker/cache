// DHCPEChargedReport.hisui.js
// by zhongricheng

$(function() {
	InitCombobox();
	
	$("#BSearch").click(function() {  
		BSearch_click();
    });
});

function InitCombobox() {
	// 收费员
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

// 分析查询
function BSearch_click(){
	//var BeginDate = "", EndDate = "", UserCode = ""
	var BeginDate = $("#BeginDate").datebox('getValue');
	if (BeginDate == "") {
		$.messager.alert("提示","请输入结算起始日期！");
		//$.messager.popover({msg:"请输入结算起始日期！", type:"alert", timeout: 3000, showType:"slide"});
		return false;
	}
	
	var EndDate = $("#EndDate").datebox('getValue');
	if (EndDate == "") {
		$.messager.alert("提示","请输入结算截至日期！");
		//$.messager.popover({msg:"请输入结算截至日期！", type:"alert", timeout: 3000, showType:"slide"});
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