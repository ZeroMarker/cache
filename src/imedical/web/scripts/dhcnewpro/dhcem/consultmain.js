//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2018-01-22
// 描述:	   会诊申请单
//===========================================================================================

var PatientID = "";     /// 病人ID
var EpisodeID = "";     /// 病人就诊ID
var mradm = "";			/// 就诊诊断ID
var CsType = "";        /// 会诊类型
var LgGroup = session['LOGON.GROUPDESC'];
/// 页面初始化函数
function initPageDefault(){

	InitPatEpisodeID();       /// 初始化加载病人就诊ID
	GetPatBaseInfo();         /// 病人就诊信息
	LoadPatientRecord();
}

/// 初始化加载病人就诊ID
function InitPatEpisodeID(){
	
	PatientID = getParam("PatientID");   /// 病人ID
	EpisodeID = getParam("EpisodeID");   /// 就诊ID
	mradm = getParam("mradm ");          /// 就诊诊断ID
	CsType = getParam("CsType");         /// 会诊类型
}

/// 病人就诊信息
function GetPatBaseInfo(){
	runClassMethod("web.DHCEMConsultQuery","GetPatEssInfo",{"PatientID":"", "EpisodeID":EpisodeID},function(jsonString){
		var jsonObject = jsonString;
		$('.ui-span-m').each(function(){
			$(this).text(jsonObject[this.id]);
			if (jsonObject.PatSex == "男"){
				$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/boy.png");
			}else if (jsonObject.PatSex == "女"){
				$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/girl.png");
			}else{
				$("#PatPhoto").attr("src","../images/unman.png");
			}
		})
	},'json',false)
}

/// 病历查看
function LoadPatientRecord(){
	
	var frm = dhcsys_getmenuform();
	if (frm) {
		PatientID = frm.PatientID.value;
		EpisodeID = frm.EpisodeID.value;
		mradm = frm.mradm.value;
	}
	
	var link ="emr.interface.browse.category.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&EpisodeLocID="+session['LOGON.CTLOCID']+"&Action="+'externalapp';
	$("#newWinFrame").attr("src",link);
	
	var url = "dhcem.consultwrite.csp";
	if (CsType == "Nur"){
		url = "dhcem.consultnur.csp";
	}
	var link = url + "?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm+"&seeCstType=2";
	$("#ConsultFrame").attr("src",link);
}

/// 引用内容
function InsQuote(resQuote, flag){

	frames[0].InsQuote(resQuote, flag); /// 插入引用内容
}


/// JQuery 初始化页面
$(function(){ initPageDefault(); })