//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2019-04-16
// 描述:	   mdt会诊申请单
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
	
//	var frm = dhcsys_getmenuform();
//	if (frm) {
//		PatientID = frm.PatientID.value;
//		EpisodeID = frm.EpisodeID.value;
//	}
	var link ="dhcem.quote.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&Type=2";
	$("#QuoteFrame").attr("src",link);
}

///保存数据
function SaveData(){

	var resQuote = $("#EditPanel").val();  /// 引用内容
	//opener.InsQuote(resQuote);      /// 插入引用内容
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
    		
//	if (!isIE()){
//		var resQuote = $("#EditPanel").val();  /// 引用内容
//    	//opener.InsQuote(resQuote);      /// 插入引用内容
//    	if(window.opener){
//	    	if(typeof window.parent.opener.InsQuote=="function"){
//		    	window.parent.opener.InsQuote(resQuote,Flag);
//		    	window.close();
//		    }
//    	}
//    	if(window.parent){
//	    	if(typeof window.parent.InsQuote=="function"){
//		    	window.parent.InsQuote(resQuote);      /// 插入引用内容
//		    }
//    	}
//    	commonParentCloseWin();  /// 关闭窗体
//	}else{
//		var retObj = {};
//		retObj.innertTexts = $("#EditPanel").val();
//		window.returnValue = retObj; 
//		window.close();
//	}
}

function QuoteToText(){
	window.frames[0].quote();
}
/// JQuery 初始化页面
$(function(){ initPageDefault(); })