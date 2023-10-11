//名称	DHCPEPreAsCharged.hisui.js
//功能	定额卡支付统计
//创建	2021.07.27
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
    
	ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=DHCPEPreAsCharged.raq");
})


//清屏
function BClear_click(){
	$("#BeginDate,#EndDate").datebox('setValue')
		BFind_click()
}


//查询
function BFind_click(){
	
	var BeginDate = "", EndDate = "", GroupDR = ""
	var BeginDate=$("#BeginDate").datebox('getValue');
	var EndDate=$("#EndDate").datebox('getValue');

	var lnk = "&BeginDate=" + BeginDate
			+ "&EndDate=" + EndDate
			+ "&CTLOCID=" + session['LOGON.CTLOCID']
			;
			
	ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=DHCPEPreAsCharged.raq" + lnk);
	//document.getElementById('ReportFile').src="dhccpmrunqianreport.csp?reportName=DHCPEPreAsCharged.raq"+lnk;

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