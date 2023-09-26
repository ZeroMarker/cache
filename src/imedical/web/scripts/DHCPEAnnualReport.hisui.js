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
    
})


//清屏
function BClear_click(){
	$("#BeginDate,#EndDate").datebox('setValue')
	$HUI.checkbox("#GroupFlag").setValue(false);
    //BFind_click();
	document.getElementById('ReportFile').src = "dhccpmrunqianreport.csp?reportName=DHCPEAnnualReports1.raq";
}


//查询
function BFind_click(){
	
	var BeginDate=$("#BeginDate").datebox('getValue');
	var EndDate=$("#EndDate").datebox('getValue');
	/*if ((BeginDate=="")&&(EndDate=="")){
		$.messager.alert("提示","日期不能为空","info");
		return false;
	}*/
	var CTLOCID=session['LOGON.CTLOCID'];
	var USERID=session['LOGON.USERID'];
	var iGroupFlag="N";
	var GroupFlag=$("#GroupFlag").checkbox('getValue');
	if (GroupFlag) {iGroupFlag="Y";} 
	
	if (iGroupFlag=="N"){		
		var ret=tkMakeServerCall("web.DHCPE.Statistic.AnnualReports","SetGlobalNum",BeginDate,EndDate,CTLOCID,USERID);
		var lnk="&BeginDate="+BeginDate+"&EndDate="+EndDate+"&USERID="+USERID;
		var reportName = "DHCPEAnnualReports.raq";	
	}else{
		var lnk="&BeginDate="+BeginDate+"&EndDate="+EndDate+"&CTLOCID="+CTLOCID+"&USERID="+USERID;
		var reportName = "DHCPEGroupAnnualReport.raq";	
	}
	document.getElementById('ReportFile').src = "dhccpmrunqianreport.csp?reportName=" + reportName + lnk;
}

