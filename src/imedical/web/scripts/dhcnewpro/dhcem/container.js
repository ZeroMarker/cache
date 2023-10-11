//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2022-11-10
// 描述:	   HOS 容器页面
//===========================================================================================

var PatientID = "";     /// 病人ID
var EpisodeID = "";     /// 病人就诊ID
var mradm = "";
var LinkUrl = "";
var hosNoPatOpenUrl = "";     /// HOS 患者列表csp
/// 页面初始化函数
function initPageDefault(){

	hosNoPatOpenUrl = getParam("hosNoPatOpenUrl");      // hxy 2011-10-24 st
	hosNoPatOpenUrl?hosOpenPatList(hosNoPatOpenUrl):''; // ed
	
	InitPatEpisodeID();       /// 初始化加载病人就诊ID
}

/// 初始化加载病人就诊ID
function InitPatEpisodeID(){
	
	PatientID = getParam("PatientID");   /// 病人ID
	EpisodeID = getParam("EpisodeID");   /// 就诊ID
	LinkUrl = getParam("LinkUrl");   /// 页面链接
	if ((EpisodeID != "")&(LinkUrl != "")){
		
		if (LinkUrl == "websys.csp"){
			LinkUrl = LinkUrl + "?a=a&TMENU=58310&TPAGID=38304612&SwitchSysPat=N&PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm=&WardID=" //?a=a&TMENU=58310&TPAGID=26821256&SwitchSysPat=N&PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm +"&WardID=";
			//LinkUrl = LinkUrl + "?a=a&TMENU=61125&TPAGID=26823595&SwitchSysPat=N&PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm=&WardID=" //?a=a&TMENU=58310&TPAGID=26821256&SwitchSysPat=N&PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm +"&WardID=";
		}else if (LinkUrl == "dhcemrbrowse"){
			// 电子病历浏览
			//LinkUrl = "websys.chartbook.hisui.csp?ChartBookName=DHC.Doctor.DHCEMRbrowse&PatientListPanel=emr.browse.episodelist.csp&PatientListPage=emr.browse.patientlist.csp&SwitchSysPat=N";
			LinkUrl = "websys.chartbook.hisui.csp?&PatientListPanel=emr.browse.episodelist.csp&PatientListPage=emr.browse.patientlist.csp&SwitchSysPat=N&ChartBookID=70&PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm +"&WardID=";
			//LinkUrl = "websys.csp?a=a&PatientListPanel=emr.browse.episodelist.csp&PatientListPage=emr.browse.patientlist.csp&SwitchSysPat=N&TMENU=58647&TPAGID=26890666&ChartBookID=70&SwitchSysPat=N&PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm=&WardID=&MWToken=B5C5025421E2B3042A9026BCFE34C762"
			//LinkUrl ="https://114.251.235.22:1443/imedical/web/csp/websys.csp?a=a&PatientListPanel=emr.browse.episodelist.csp&PatientListPage=emr.browse.patientlist.csp&SwitchSysPat=N&TMENU=58647&TPAGID=26890666&ChartBookID=70&SwitchSysPat=N&PatientID=416&EpisodeID=1217&mradm=&WardID=&MWToken=B5C5025421E2B3042A9026BCFE34C762"
		}else if (LinkUrl == "ipbookcreate"){
			// 住院证
			LinkUrl = "websys.csp?a=a&IPBKFlag=Booking&TMENU=57589&TPAGID=26959269&SwitchSysPat=N&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm=&WardID=&"; //"websys.csp?a=a&IPBKFlag=Booking&TMENU=57589&TPAGID=26959269&SwitchSysPat=N&WardID=&PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm +"&WardID=";
		}else{
			LinkUrl = LinkUrl + "?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID;
		}
		$("#mainFrame").attr("src",tokenUrl(LinkUrl));
	}else{
		if (LinkUrl=="ipbookcreate"){
			// 住院证
			LinkUrl = "doc.ipbookcreate.hui.csp?a=a&IPBKFlag=Booking"; //"websys.csp?a=a&IPBKFlag=Booking&TMENU=57589&TPAGID=26959269&SwitchSysPat=N&WardID=&PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm +"&WardID=";
		}else{
		//if(LinkUrl=="opdoc.transadmquery.hui"){
			LinkUrl = LinkUrl + "?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID;
			
		//}
		}
		$("#mainFrame").attr("src",tokenUrl(LinkUrl));
	}
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })
