//名称	DHCPECompainStatistic.hisui.js
//功能	体检投诉情况统计
//创建	2023.02.15
//创建人  ln

$(function(){
			
	InitCombobox();
	
     
    //查询
	$("#BFind").click(function() {	
		BFind_click();		
        });
     
    $("#Type").combobox('setValue','C'); 

    //清屏
	$("#BClear").click(function() {	
		BClear_click();		
        });
        
    ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=DHCPEComplainStatistic.raq");
})


//清屏
function BClear_click(){
	$("#BeginDate,#EndDate").datebox('setValue')
	$(".hisui-combobox").combobox('setValue',"");
	
	InitCombobox();
	ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=DHCPEComplainStatistic.raq");
	//document.getElementById('ReportFile').src = "dhccpmrunqianreport.csp?reportName=DHCPEComplainStatistic.raq";
}


//查询
function BFind_click(){
	var BeginDate = "", EndDate = "", Type="";
	var BeginDate=$("#BeginDate").datebox('getValue');
    var EndDate = $("#EndDate").datebox('getValue');
		
	var Type=$("#Type").combobox('getValue');
	if (Type==undefined) {var Type="";}
		
	var lnk = "&BeginDate=" + BeginDate
			+ "&EndDate=" + EndDate
			+ "&Type=" + Type
			+ "&CurLoc=" + session['LOGON.CTLOCID']
			;
	
	ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=DHCPEComplainStatistic.raq" + lnk);
	//document.getElementById('ReportFile').src = "dhccpmrunqianreport.csp?reportName=DHCPEComplainStatistic.raq" + lnk;

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
	
    //类型	
	var TypeObj = $HUI.combobox("#Type",{
        valueField:'id',
        textField:'text',
        panelHeight:'70',
        data:[
           {id:'C',text:$g('投诉')}  
        ]

    });
	
	
	
}