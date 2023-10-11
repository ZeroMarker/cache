//名称	DHCPEOneDayPreItemStatistic.hisui.js
//功能	体检中心每日预约情况统计
//创建	2021.06.28
//创建人  ln

$(function(){
			
	InitCombobox();
	
     
    //查询
	$("#BFind").click(function() {	
		BFind_click();		
        });
      
    //清屏
	$("#BClear").click(function() {	
		BClear_click();		
        });
        
    ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=DHCPEOneDayPreItemStatistic.raq");
})


//清屏
function BClear_click(){
	$("#BeginDate,#EndDate").datebox('setValue')
	$(".hisui-combobox").combobox('setValue',"");
	
	InitCombobox();
	ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=DHCPEOneDayPreItemStatistic.raq");
	//document.getElementById('ReportFile').src = "dhccpmrunqianreport.csp?reportName=DHCPEOneDayPreItemStatistic.raq";
}


//查询
function BFind_click(){
	var BeginDate = "", EndDate = "", VIPLevel="";
	var BeginDate=$("#BeginDate").datebox('getValue');
    var EndDate = $("#EndDate").datebox('getValue');
		
	var VIPLevel=$("#VIPLevel").combobox('getValue');
	if (VIPLevel==undefined) {var VIPLevel="";}
		
	var lnk = "&BeginDate=" + BeginDate
			+ "&EndDate=" + EndDate
			+ "&VIPLevel=" + VIPLevel
			+ "&CurLoc=" + session['LOGON.CTLOCID']
			;
	
	ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=DHCPEOneDayPreItemStatistic.raq" + lnk);
	//document.getElementById('ReportFile').src = "dhccpmrunqianreport.csp?reportName=DHCPEOneDayPreItemStatistic.raq" + lnk;

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
function InitCombobox(){
	
	//VIP等级	
	var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindVIP&ResultSetType=array&LocID="+session['LOGON.CTLOCID'],
		valueField:'id',
		textField:'desc',
		});
		
	
	
}