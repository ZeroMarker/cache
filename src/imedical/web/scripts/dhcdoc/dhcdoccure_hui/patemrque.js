//===========================================================================================
// 作者：      nikang
// 编写日期:   2020-10-13
// 参考新产品组会诊申请引用功能scripts/dhcnewpro/dhcem/patemrque.js
//===========================================================================================
var PatientID = "";     /// 病人ID
var EpisodeID = "";     /// 病人就诊ID
/// 页面初始化函数
function initPageDefault(){
	InitPageDomHeight();
	InitPatEpisodeID(); /// 初始化加载病人就诊ID
	initFrameSrc();     /// 页面iframe资源
}

/// 初始化加载病人就诊ID
function InitPatEpisodeID(){

	PatientID = getParam("PatientID");   /// 病人ID
	EpisodeID = getParam("EpisodeID");   /// 就诊ID
	Flag = getParam("Flag");			 /// 
}

function InitPageDomHeight(){
	var domHeight=$("#editPanelDiv").parent().height();
	$("#editPanelDiv").css({"height":domHeight-50});
	var domHeight=$("#quoteFrameDiv").parent().height();
	$("#quoteFrameDiv").css({"height":domHeight-50});
	return true;
}


/// 页面iframe资源
function initFrameSrc(){
	var link ="dhcem.quote.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&Type=2";
	if(typeof websys_writeMWToken=='function') link=websys_writeMWToken(link);
	$("#QuoteFrame").attr("src",link);
}

///保存数据
function SaveData(){

	var resQuote = $("#EditPanel").val();  /// 引用内容
	//opener.InsQuote(resQuote);      /// 插入引用内容
	if (websys_showModal("options")) {
		if (websys_showModal("options").InsQuote) {
			websys_showModal("options").InsQuote(resQuote ,Flag);
		}
		websys_showModal("close");
	}else{
		if(window.opener){
	    	if(typeof window.parent.opener.InsQuote=="function"){
		    	window.parent.opener.InsQuote(resQuote,Flag);
		    	window.close();
		    }
		}
		if(window.parent){
	    	if(typeof window.parent.InsQuote=="function"){
		    	window.parent.InsQuote(resQuote ,Flag);      /// 插入引用内容
		    }
		}
		commonParentCloseWin();  /// 关闭窗体
	}
}

function QuoteToText(){
	window.frames[0].quote();
}
/// JQuery 初始化页面
$(function(){ initPageDefault(); })