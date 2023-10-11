/**
 * nur.hisui.nurseplanconfig.js
 * 护理计划设置
 * 2758853【护理计划配置】业务界面整合
*/
$(function() {	
	//var Height = document.body.clientHeight;
	//var Width = document.body.clientWidth;
	var Height = window.innerHeight;	    
	var Width = window.innerWidth;
	var tabsheaderHeight = $("#tabs").children(".tabs-header").height();
	$("#tabs").children(".tabs-panels").css('height', Height-tabsheaderHeight);
	$("#tabs").children(".tabs-panels").css('width', '100%');
	$("#tabs").children(".tabs-panels").children(".panel").children(".panel-body").css('width', '100%');
	ResetDomSize();
	setTimeout(setIframeSrc, 8);
	$HUI.tabs("#tabs",{
		onSelect:function(title){
			//$.messager.popover({type:'info',msg:'切换到【'+title+'】'});
			/**if(title=="计划通用配置"){
				$("#TabComConfig")[0].contentWindow.location.reload(false);
			}else **/if(title=="任务/频次配置"){
				$("#TabIntervReportFreq")[0].contentWindow.location.reload(false);
			}else if(title=="措施任务文书"){
				$("#TabIntervReport")[0].contentWindow.location.reload(false);
			}else if(title=="问题目标措施"){
				$("#TabQuestion")[0].contentWindow.location.reload(false);
			}			
		}
	});
	
});
window.addEventListener("resize", ResetDomSize);
function ResetDomSize() {
	setTimeout(function () {
		//var Height = document.body.clientHeight;
		//var Width = document.body.clientWidth;
		var Height = window.innerHeight;	    
	    var Width = window.innerWidth;
	    var tabsheaderHeight = $("#tabs").children(".tabs-header").height();
	    $("#tabs").children(".tabs-panels").css('height', Height-tabsheaderHeight); 
	    $("#tabs").children(".tabs-panels").css('width', '100%');
	    $("#tabs").children(".tabs-panels").children(".panel").children(".panel-body").css('width', '100%');
	    //$("#tabs").css('height', Height); 
    },3);
}
function setIframeSrc() {
	/*
	var s_TabQuestion ="nur.hisui.nursequestiongoalconfig.csp";
    var s_TabIntervReport ="nur.hisui.intervreportconfig.csp";
    var s_TabIntervReportFreq ="nur.hisui.interventionfreqconfig.csp";
    var s_TabComConfig ="nur.hisui.nursequestionplancomconfig.csp";
    */
   	var s_TabQuestion =getIframeUrl("nur.hisui.nursequestiongoalconfig.csp");
    var s_TabIntervReport =getIframeUrl("nur.hisui.intervreportconfig.csp");
    var s_TabIntervReportFreq =getIframeUrl("nur.hisui.interventionfreqconfig.csp");
    var s_TabComConfig =getIframeUrl("nur.hisui.nursequestionplancomconfig.csp");
 
    var TabQuestion = document.getElementById('TabQuestion');
    var TabIntervReport = document.getElementById('TabIntervReport');
    var TabIntervReportFreq = document.getElementById('TabIntervReportFreq');
    var TabComConfig = document.getElementById('TabComConfig');
    if (-1 == navigator.userAgent.indexOf("MSIE")) {
	    TabComConfig.src = s_TabComConfig;
	    TabQuestion.src = s_TabQuestion;
        TabIntervReport.src = s_TabIntervReport;
        TabIntervReportFreq.src = s_TabIntervReportFreq;
    } else {
	    TabComConfig.location = s_TabComConfig;
	    TabQuestion.location = s_TabQuestion;
        TabIntervReport.location = s_TabIntervReport;
        TabIntervReportFreq.location = s_TabIntervReportFreq;
    }
}
function getIframeUrl(url){
	if ('undefined'!==typeof websys_getMWToken){
		if(url.indexOf("?")==-1){
			url = url+"?MWToken="+websys_getMWToken()
		}else{
			url = url+"&MWToken="+websys_getMWToken()
		}
	}
	return url
}
