//===========================================================================================
// 作者：      yangyongtao
// 编写日期:   2020-03-10
// 描述:	   mdt专家意见
//===========================================================================================

var PatientID = "";     /// 病人ID
var EpisodeID = "";     /// 病人就诊ID
var mradm = "";			/// 就诊诊断ID
var CstID = "";         /// 会诊ID
var McID = "";          /// 随访ID
/// 页面初始化函数
function initPageDefault(){
	initFrameSrc();     /// 页面iframe资源
}


/// 页面iframe资源
function initFrameSrc(){
	
	PatientID = getParam("PatientID");   /// 病人ID
	EpisodeID = getParam("EpisodeID");   /// 就诊ID
	mradm = getParam("mradm");           /// 就诊诊断ID
	CstID =getParam("ID");           	 /// 会诊ID
	McID = getParam("McID");             /// 随访ID
	
	/// 专家意见 
	var url = "dhcmdt.reply.csp";
	var link = url + "?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm+"&CstID="+ CstID+"&McID="+ McID+"&MWToken="+websys_getMWToken();
	$("#ReplyFrame").attr("src",link);
	
	var link="dhcmdt.matreviewhist.csp?EpisodeID="+EpisodeID+"&PatientID="+PatientID+"&ID="+CstID+"&MWToken="+websys_getMWToken();
	$("#Matreview").attr("src",link);
	
	return;
	/// MDT申请
	var url = "dhcmdt.write.csp";
	var link = url + "?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm+"&ID="+ CstID+"&MWToken="+websys_getMWToken()
	$("#MdtWinFrame").attr("src",link);

	/// 电子病历
	var link ="emr.interface.browse.category.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&EpisodeLocID="+session['LOGON.CTLOCID']+"&Action="+'externalapp'+"&MWToken="+websys_getMWToken();
	$("#newWinFrame").attr("src",link);
	
	/// 治疗时间轴
	var url = "dhcmdt.foluptimeaxis.csp";
	var link = url + "?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm+"&CstID="+ CstID+"&MWToken="+websys_getMWToken()
	$("#TimeAxis").attr("src",link);
	
	/// 专家意见 
	var url = "dhcmdt.reply.csp";
	var link = url + "?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm+"&CstID="+ CstID+"&McID="+ McID+"&MWToken="+websys_getMWToken();
	$("#ReplyFrame").attr("src",link);
	
}


/// JQuery 初始化页面
$(function(){ initPageDefault(); })