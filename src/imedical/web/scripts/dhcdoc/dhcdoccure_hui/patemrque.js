//===========================================================================================
// ���ߣ�      nikang
// ��д����:   2020-10-13
// �ο��²�Ʒ������������ù���scripts/dhcnewpro/dhcem/patemrque.js
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
	var link ="dhcem.quote.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&Type=2";
	if(typeof websys_writeMWToken=='function') link=websys_writeMWToken(link);
	$("#QuoteFrame").attr("src",link);
}

///��������
function SaveData(){

	var resQuote = $("#EditPanel").val();  /// ��������
	//opener.InsQuote(resQuote);      /// ������������
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
		    	window.parent.InsQuote(resQuote ,Flag);      /// ������������
		    }
		}
		commonParentCloseWin();  /// �رմ���
	}
}

function QuoteToText(){
	window.frames[0].quote();
}
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })