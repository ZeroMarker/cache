//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2019-04-16
// ����:	   mdt�������뵥
//===========================================================================================

var PatientID = "";     /// ����ID
var EpisodeID = "";     /// ���˾���ID
/// ҳ���ʼ������
function initPageDefault(){
	InitPageDomHeight();
	InitPatEpisodeID(); /// ��ʼ�����ز��˾���ID
	initFrameSrc();     /// ҳ��iframe��Դ
}

/// ��ʼ�����ز��˾���ID
function InitPatEpisodeID(){

	PatientID = getParam("PatientID");   /// ����ID
	EpisodeID = getParam("EpisodeID");   /// ����ID
	Flag = getParam("Flag");			 /// 
}

function InitPageDomHeight(){
	var domHeight=$("#editPanelDiv").parent().height();
	$("#editPanelDiv").css({"height":domHeight-50});
	var domHeight=$("#quoteFrameDiv").parent().height();
	$("#quoteFrameDiv").css({"height":domHeight-50});
	return true;
}


/// ҳ��iframe��Դ
function initFrameSrc(){
	var link ="dhcmdt.writeepr.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&Type=1";
	$("#QuoteFrame").attr("src",link);
}

///��������
function SaveData(){

	var resQuote = $("#EditPanel").val();  /// ��������
	//opener.InsQuote(resQuote);      /// ������������
	if(window.opener){
    	if(typeof window.parent.opener.InsQuote=="function"){
	    	window.parent.opener.InsQuote(resQuote,Flag);
	    	window.close();
	    }
	}
	if(window.parent){
    	if(typeof window.parent.InsQuote=="function"){
	    	window.parent.InsQuote(resQuote ,Flag);      /// ������������
	    }
	}
	
	var obj = {"text":resQuote,"flag":Flag};
	websys_emit("onMdtRefData",obj);
	commonParentCloseWin();  /// �رմ���
	
	$.messager.show({showType:'slide', showSpeed:'300',msg:'���óɹ�!',title:'С��ʾ'});
	$("#EditPanel").val('');
}

function QuoteToText(){
	window.frames[0].quote();
}
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })