//===========================================================================================
// ���ߣ�      yangyongtao
// ��д����:   2020-03-06
// ����:	   mdt����ҽ�����
//===========================================================================================

var PatientID = "";     /// ����ID
var EpisodeID = "";     /// ���˾���ID
var mradm = "";			/// �������ID
var CstID = "";         /// ����ID
var McID = "";          /// ���ID
/// ҳ���ʼ������
function initPageDefault(){
	initMdtFrameSrc();     /// ҳ��iframe��Դ
}

/// ҳ��iframe��Դ
function initMdtFrameSrc(){
	
	PatientID = getParam("PatientID");   /// ����ID
	EpisodeID = getParam("EpisodeID");   /// ����ID
	mradm = getParam("mradm");           /// �������ID
	CstID =getParam("ID");           	 /// ����ID
	McID = getParam("McID");             /// ���ID
	
	/// MDT����
	var url = "dhcmdt.waitinglistnew.csp";
	var link = url + "?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm+"&CstID="+ CstID+"&McID="+ McID+"&MWToken="+websys_getMWToken();
	$("#Matreview").attr("src",link)
	
	var link="dhcmdt.folupvis.csp"+ "?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm+"&CstID="+ CstID+"&McID="+ McID+"&MWToken="+websys_getMWToken();
	$("#FloUpFrame").attr("src",link);
	
	return;	
}


/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })