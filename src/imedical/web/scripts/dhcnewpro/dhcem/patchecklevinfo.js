
/// ����Ԥ�������Ϣ bianshuai 2016-08-16
var EpisodeID = "";      /// ���˾���ID
var PatientID = "";
/// ҳ���ʼ������
function initPageDefault(){

	InitPatEpisodeID();    /// ��ʼ�����ز��˾���ID
	LoadEmPatInfo();       /// ���ز�����Ϣ
	LoadPatCheckLevInfo(); /// ���ط�����Ϣ
}

/// ��ʼ�����ز��˾���ID
function InitPatEpisodeID(){
	EpisodeID = "" //getParam("EpisodeID");
	PatientID = "13281" //getParam("PatientID");
}

/// ���ز�����Ϣ
function LoadEmPatInfo(){
	runClassMethod("web.DHCEMPatCheckLevQuery","GetEmPatInfo",{"PatientID":PatientID, "EpisodeID":EpisodeID},function(jsonString){
		var jsonObject = jsonString;
		SetPagePatPanelInfo(jsonObject);  /// ����ҳ��������ʾ����
	},'json',false)
}

/// ���ط�����Ϣ
function LoadPatCheckLevInfo(){
	runClassMethod("web.DHCEMPatCheckLevQuery","GetEmPatCheckLevInfo",{"PatientID":PatientID, "EpisodeID":EpisodeID},function(jsonString){
		var jsonObject = jsonString;
		SetPagePatPanelInfo(jsonObject);  /// ����ҳ��������ʾ����
	},'json',false)
}

/// ����ҳ��������ʾ����
function SetPagePatPanelInfo(jsonObject){
	
	$("span").each(function(){
		$(this).text(jsonObject[this.id]);
	})
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })