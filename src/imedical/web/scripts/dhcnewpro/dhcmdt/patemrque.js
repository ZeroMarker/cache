//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2019-04-16
// 描述:	   mdt会诊申请单
//===========================================================================================

var PatientID = "";     /// 病人ID
var EpisodeID = "";     /// 病人就诊ID
/// 页面初始化函数
function initPageDefault(){
	
	InitPatEpisodeID(); /// 初始化加载病人就诊ID
	initFrameSrc();     /// 页面iframe资源
}

/// 初始化加载病人就诊ID
function InitPatEpisodeID(){

	PatientID = getParam("PatientID");   /// 病人ID
	EpisodeID = getParam("EpisodeID");   /// 就诊ID
}

/// 页面iframe资源
function initFrameSrc(){
	
//	var frm = dhcsys_getmenuform();
//	if (frm) {
//		PatientID = frm.PatientID.value;
//		EpisodeID = frm.EpisodeID.value;
//	}
	var link ="dhcmdt.quote.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&Type=2"+"&MWToken="+websys_getMWToken();
	$("#QuoteFrame").attr("src",link);
}

///保存数据
function SaveData(){
	
//	var retObj = {};
//	retObj.innertTexts = $("#EditPanel").val();
//	window.returnValue = retObj; 
//	window.close();
    var resQuote = $("#EditPanel").val();  /// 引用内容
    window.parent.InsQuote(resQuote);      /// 插入引用内容
    commonParentCloseWin();  /// 关闭窗体
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })