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
	
	
	var link="dhcmdt.matreviewhist.csp?IsConsFolUp=1&EpisodeID="+EpisodeID+"&PatientID="+PatientID+"&ID="+CstID+"&cspflag=1"+"&MWToken="+websys_getMWToken();
	$("#Matreview").attr("src",link)
	
	/// MDT���� 
	var url = "dhcmdt.folupvis.csp";
	var link = url + "?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm+"&CstID="+ CstID+"&McID="+ McID+"&MWToken="+websys_getMWToken();
	$("#FloUpFrame").attr("src",link);
	return;
	/// MDT����
	var url = "dhcmdt.write.csp";
	var link = url + "?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm+"&ID="+ CstID+"&MWToken="+websys_getMWToken()
	$("#MdtWinFrame").attr("src",link)
	//MdtWinFrame.window.location.reload()
	
	/// ���Ӳ���
	var link ="emr.interface.browse.category.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&EpisodeLocID="+session['LOGON.CTLOCID']+"&Action="+'externalapp'+"&MWToken="+websys_getMWToken();
	//var link = "websys.chartbook.hisui.csp?&PatientListPanel=emr.browse.episodelist.csp&PatientListPage=emr.browse.patientlist.csp&SwitchSysPat=N&ChartBookID=70&PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm +"&WardID=";
	$("#EmrWinFrame").attr("src",link);
	//EmrWinFrame.window.location.reload()

	/// ����ʱ����
	var url = "dhcmdt.foluptimeaxis.csp";
	var link = url + "?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm+"&CstID="+ CstID+"&MWToken="+websys_getMWToken()
	$("#TimeAxis").attr("src",link);
	
}


/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })