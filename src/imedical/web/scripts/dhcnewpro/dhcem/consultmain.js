//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2018-01-22
// ����:	   �������뵥
//===========================================================================================

var PatientID = "";     /// ����ID
var EpisodeID = "";     /// ���˾���ID
var mradm = "";			/// �������ID
var CsType = "";        /// ��������
var LgGroup = session['LOGON.GROUPDESC'];
/// ҳ���ʼ������
function initPageDefault(){

	InitPatEpisodeID();       /// ��ʼ�����ز��˾���ID
	GetPatBaseInfo();         /// ���˾�����Ϣ
	LoadPatientRecord();
}

/// ��ʼ�����ز��˾���ID
function InitPatEpisodeID(){
	
	PatientID = getParam("PatientID");   /// ����ID
	EpisodeID = getParam("EpisodeID");   /// ����ID
	mradm = getParam("mradm ");          /// �������ID
	CsType = getParam("CsType");         /// ��������
}

/// ���˾�����Ϣ
function GetPatBaseInfo(){
	runClassMethod("web.DHCEMConsultQuery","GetPatEssInfo",{"PatientID":"", "EpisodeID":EpisodeID},function(jsonString){
		var jsonObject = jsonString;
		$('.ui-span-m').each(function(){
			$(this).text(jsonObject[this.id]);
			if (jsonObject.PatSex == "��"){
				$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/boy.png");
			}else if (jsonObject.PatSex == "Ů"){
				$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/girl.png");
			}else{
				$("#PatPhoto").attr("src","../images/unman.png");
			}
		})
	},'json',false)
}

/// �����鿴
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

/// ��������
function InsQuote(resQuote, flag){

	frames[0].InsQuote(resQuote, flag); /// ������������
}


/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })