//名称	DHCPEAnnualReport.hisui.js
//功能	体检中心年度统计报表
//创建	2019.09.23
//创建人  ln

$(function(){
		
     
    //查询
	$("#BFind").click(function() {	
		BFind_click();		
        });
      
    //清屏
	$("#BClear").click(function() {	
		BClear_click();		
        });
		
	ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=DHCPEAnnualReports1.raq");
    
})


//清屏
function BClear_click(){
	$("#BeginDate,#EndDate").datebox('setValue')
	$HUI.checkbox("#GroupFlag").setValue(false);
	ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=DHCPEAnnualReports1.raq");
    //BFind_click();
	//document.getElementById('ReportFile').src = "dhccpmrunqianreport.csp?reportName=DHCPEAnnualReports1.raq";
}


//查询
function BFind_click(){
	
	var BeginDate=$("#BeginDate").datebox('getValue');
	var EndDate=$("#EndDate").datebox('getValue');
	/*if ((BeginDate=="")&&(EndDate=="")){
		$.messager.alert("提示","日期不能为空","info");
		return false;
	}*/
	var CurLoc=session['LOGON.CTLOCID'];
	var CurUser=session['LOGON.USERID'];
	var iGroupFlag="N";
	var GroupFlag=$("#GroupFlag").checkbox('getValue');
	if (GroupFlag) {iGroupFlag="Y";} 
	
	if (iGroupFlag=="N"){		
		var ret=tkMakeServerCall("web.DHCPE.Statistic.AnnualReports","SetGlobalNum",BeginDate,EndDate,CurLoc,CurUser);
		var Err=ret.split("^");
		if (Err[0]!="0"){
			$.messager.alert("提示",Err[1],"info");
		    return false;
		}
		var lnk="&BeginDate="+BeginDate+"&EndDate="+EndDate+"&CurUser="+CurUser;
		var reportName = "DHCPEAnnualReports.raq";	
	}else{
		var lnk="&BeginDate="+BeginDate+"&EndDate="+EndDate+"&CurLoc="+CurLoc+"&CurUser="+CurUser;
		var reportName = "DHCPEGroupAnnualReport.raq";	
	}
	ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=" + reportName + lnk);
	//document.getElementById('ReportFile').src = "dhccpmrunqianreport.csp?reportName=" + reportName + lnk;
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
