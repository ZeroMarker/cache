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
	
//	var frm = dhcsys_getmenuform();
//	if (frm) {
//		PatientID = frm.PatientID.value;
//		EpisodeID = frm.EpisodeID.value;
//	}
	var link ="dhcem.quote.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&Type=2";
	if ('undefined'!==typeof websys_getMWToken){ //hxy 2023-02-11 Token����
		link += "&MWToken="+websys_getMWToken()
	}
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
	//commonParentCloseWin();  /// �رմ��� //2020-10-13 st
	if (websys_showModal("options")) { 
		if (websys_showModal("options").InsQuote) {
			websys_showModal("options").InsQuote(resQuote ,Flag);
			websys_showModal("close"); //hxy 2021-04-13 ä������ סԺҽ��-��Ϣ����-��������-����ժҪ\�������ɼ�Ҫ��-����-ά�����ݵ����ȷ�����󣬽������������Ҳ�ر���
		}else{
			commonParentCloseWin();
		}
		//websys_showModal("close"); //hxy 2021-04-13 ע�� סԺҽ��-��Ϣ����-��������-����ժҪ\�������ɼ�Ҫ��-����-ά�����ݵ����ȷ�����󣬽������������Ҳ�ر���
	}else{
		commonParentCloseWin();  /// �رմ���
	}//ed

    		
//	if (!isIE()){
//		var resQuote = $("#EditPanel").val();  /// ��������
//    	//opener.InsQuote(resQuote);      /// ������������
//    	if(window.opener){
//	    	if(typeof window.parent.opener.InsQuote=="function"){
//		    	window.parent.opener.InsQuote(resQuote,Flag);
//		    	window.close();
//		    }
//    	}
//    	if(window.parent){
//	    	if(typeof window.parent.InsQuote=="function"){
//		    	window.parent.InsQuote(resQuote);      /// ������������
//		    }
//    	}
//    	commonParentCloseWin();  /// �رմ���
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
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })