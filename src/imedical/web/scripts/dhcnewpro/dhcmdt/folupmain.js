//===========================================================================================
// 作者：      yangyongtao
// 编写日期:   2020-03-06
// 描述:	   mdt主管医生随访
//===========================================================================================

var PatientID = "";     /// 病人ID
var EpisodeID = "";     /// 病人就诊ID
var mradm = "";			/// 就诊诊断ID
var CstID = "";         /// 会诊ID
var McID = "";          /// 随访ID
/// 页面初始化函数
function initPageDefault(){
	initMdtFrameSrc();     /// 页面iframe资源
}

/// 页面iframe资源
function initMdtFrameSrc(){
	
	PatientID = getParam("PatientID");   /// 病人ID
	EpisodeID = getParam("EpisodeID");   /// 就诊ID
	mradm = getParam("mradm");           /// 就诊诊断ID
	CstID =getParam("ID");           	 /// 会诊ID
	McID = getParam("McID");             /// 随访ID
	
	
	var link="dhcmdt.matreviewhist.csp?IsConsFolUp=1&EpisodeID="+EpisodeID+"&PatientID="+PatientID+"&ID="+CstID+"&cspflag=1"+"&MWToken="+websys_getMWToken();
	$("#Matreview").attr("src",link)
	
	/// MDT反馈 
	var url = "dhcmdt.folupvis.csp";
	var link = url + "?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm+"&CstID="+ CstID+"&McID="+ McID+"&MWToken="+websys_getMWToken();
	$("#FloUpFrame").attr("src",link);
	return;
	/// MDT申请
	var url = "dhcmdt.write.csp";
	var link = url + "?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm+"&ID="+ CstID+"&MWToken="+websys_getMWToken()
	$("#MdtWinFrame").attr("src",link)
	//MdtWinFrame.window.location.reload()
	
	/// 电子病历
	var link ="emr.interface.browse.category.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&EpisodeLocID="+session['LOGON.CTLOCID']+"&Action="+'externalapp'+"&MWToken="+websys_getMWToken();
	//var link = "websys.chartbook.hisui.csp?&PatientListPanel=emr.browse.episodelist.csp&PatientListPage=emr.browse.patientlist.csp&SwitchSysPat=N&ChartBookID=70&PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm +"&WardID=";
	$("#EmrWinFrame").attr("src",link);
	//EmrWinFrame.window.location.reload()

	/// 治疗时间轴
	var url = "dhcmdt.foluptimeaxis.csp";
	var link = url + "?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm+"&CstID="+ CstID+"&MWToken="+websys_getMWToken()
	$("#TimeAxis").attr("src",link);
	
}


/// JQuery 初始化页面
$(function(){ initPageDefault(); })