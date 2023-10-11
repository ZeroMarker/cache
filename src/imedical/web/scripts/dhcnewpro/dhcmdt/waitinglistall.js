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
	
	/// MDT反馈
	var url = "dhcmdt.waitinglistnew.csp";
	var link = url + "?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm+"&CstID="+ CstID+"&McID="+ McID+"&MWToken="+websys_getMWToken();
	$("#Matreview").attr("src",link)
	
	var link="dhcmdt.folupvis.csp"+ "?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm+"&CstID="+ CstID+"&McID="+ McID+"&MWToken="+websys_getMWToken();
	$("#FloUpFrame").attr("src",link);
	
	return;	
}


/// JQuery 初始化页面
$(function(){ initPageDefault(); })