//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2019-04-16
// ����:	   mdt�������뵥
//===========================================================================================

var PatientID = "";     /// ����ID
var EpisodeID = "";     /// ���˾���ID
/// ҳ���ʼ������
function initPageDefault(){
	
	InitPatEpisodeID(); /// ��ʼ�����ز��˾���ID
	initFrameSrc();     /// ҳ��iframe��Դ
}

/// ��ʼ�����ز��˾���ID
function InitPatEpisodeID(){

	PatientID = getParam("PatientID");   /// ����ID
	EpisodeID = getParam("EpisodeID");   /// ����ID
}

/// ҳ��iframe��Դ
function initFrameSrc(){
	
//	var frm = dhcsys_getmenuform();
//	if (frm) {
//		PatientID = frm.PatientID.value;
//		EpisodeID = frm.EpisodeID.value;
//	}
	var link ="dhcmdt.quote.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&Type=2"+"&MWToken="+websys_getMWToken();
	$("#QuoteFrame").attr("src",link);
}

///��������
function SaveData(){
	
//	var retObj = {};
//	retObj.innertTexts = $("#EditPanel").val();
//	window.returnValue = retObj; 
//	window.close();
    var resQuote = $("#EditPanel").val();  /// ��������
    window.parent.InsQuote(resQuote);      /// ������������
    commonParentCloseWin();  /// �رմ���
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })