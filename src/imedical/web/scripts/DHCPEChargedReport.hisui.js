// DHCPEChargedReport.hisui.js
// by zhongricheng

$(function() {
	InitCombobox();
	
	$("#BFind").click(function() {  
		BFind_click();
    });
	
	ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=DHCPEChargedReport.raq");
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
		},
		onBeforeLoad: function (param) {
			param.Type="F";
			param.LocID=session['LOGON.CTLOCID'];
			param.hospId = session['LOGON.HOSPID'];		
		}
		
	});
}

// 分析查询
function BFind_click(){
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
	
	ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=DHCPEChargedReport.raq" + src);
	//$("#ReportFile").attr("src", "dhccpmrunqianreport.csp?reportName=DHCPEChargedReport.raq" + src);
	
}
// 解决iframe中 润乾csp 跳动问题
function ShowRunQianUrl(iframeId, url) {
    var iframeObj = document.getElementById(iframeId)
    if (iframeObj) {
	    iframeObj.src=url;
	    //debugger;
	    $(iframeObj).hide();
	    if (iframeObj.attachEvent) {
		    iframeObj.attachEvent("onload", function(){
		        $(this).show();
		    });
	    } else {
		    iframeObj.onload = function(){
		        $(this).show();
		    };
	    }
    }
}