/**
 * nur.hisui.nurseplanconfig.js
 * ����ƻ�����
 * 2758853������ƻ����á�ҵ���������
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
			//$.messager.popover({type:'info',msg:'�л�����'+title+'��'});
			/**if(title=="�ƻ�ͨ������"){
				$("#TabComConfig")[0].contentWindow.location.reload(false);
			}else **/if(title=="����/Ƶ������"){
				$("#TabIntervReportFreq")[0].contentWindow.location.reload(false);
			}else if(title=="��ʩ��������"){
				$("#TabIntervReport")[0].contentWindow.location.reload(false);
			}else if(title=="����Ŀ���ʩ"){
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
