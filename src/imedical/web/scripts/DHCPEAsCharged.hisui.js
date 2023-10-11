//名称	DHCPEAsCharged.hisui.js
//功能	视同收费未交费查询（个人）
//创建	2021.01.19
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
		
    ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=DHCPEAsCharged.raq");
})


//清屏
function BClear_click(){
	$("#BeginDate,#EndDate").datebox('setValue')
		BFind_click()
}


//查询
function BFind_click(){
	
	var BeginDate = "", EndDate = "";
	var BeginDate=$("#BeginDate").datebox('getValue');
	var EndDate=$("#EndDate").datebox('getValue');

	var lnk = "&BeginDate=" + BeginDate
			+ "&EndDate=" + EndDate
			+ "&CTLOCID=" + session['LOGON.CTLOCID']
			;
	ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=DHCPEAsCharged.raq" + lnk);
	//document.getElementById('ReportFile').src="dhccpmrunqianreport.csp?reportName=DHCPEAsCharged.raq"+lnk;

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
