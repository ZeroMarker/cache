//===========================================================================================
// ���ߣ�      yangyongtao
// ��д����:   2020-03-10
// ����:	   mdtר�����
//===========================================================================================

var PatientID = "";     /// ����ID
var EpisodeID = "";     /// ���˾���ID
var mradm = "";			/// �������ID
var CstID = "";         /// ����ID
var McID = "";          /// ���ID
/// ҳ���ʼ������
function initPageDefault(){
	initFrameSrc();     /// ҳ��iframe��Դ
}


/// ҳ��iframe��Դ
function initFrameSrc(){
	
	PatientID = getParam("PatientID");   /// ����ID
	EpisodeID = getParam("EpisodeID");   /// ����ID
	mradm = getParam("mradm");           /// �������ID
	CstID =getParam("ID");           	 /// ����ID
	McID = getParam("McID");             /// ���ID
	
	/// ר����� 
	var url = "dhcmdt.reply.csp";
	var link = url + "?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm+"&CstID="+ CstID+"&McID="+ McID+"&MWToken="+websys_getMWToken();
	$("#ReplyFrame").attr("src",link);
	
	var link="dhcmdt.matreviewhist.csp?EpisodeID="+EpisodeID+"&PatientID="+PatientID+"&ID="+CstID+"&MWToken="+websys_getMWToken();
	$("#Matreview").attr("src",link);
	
	return;
	/// MDT����
	var url = "dhcmdt.write.csp";
	var link = url + "?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm+"&ID="+ CstID+"&MWToken="+websys_getMWToken()
	$("#MdtWinFrame").attr("src",link);

	/// ���Ӳ���
	var link ="emr.interface.browse.category.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&EpisodeLocID="+session['LOGON.CTLOCID']+"&Action="+'externalapp'+"&MWToken="+websys_getMWToken();
	$("#newWinFrame").attr("src",link);
	
	/// ����ʱ����
	var url = "dhcmdt.foluptimeaxis.csp";
	var link = url + "?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm+"&CstID="+ CstID+"&MWToken="+websys_getMWToken()
	$("#TimeAxis").attr("src",link);
	
	/// ר����� 
	var url = "dhcmdt.reply.csp";
	var link = url + "?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm+"&CstID="+ CstID+"&McID="+ McID+"&MWToken="+websys_getMWToken();
	$("#ReplyFrame").attr("src",link);
	
}


/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })