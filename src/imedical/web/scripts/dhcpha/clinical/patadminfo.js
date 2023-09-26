var EpisodeID = "";
var AdmType = "";
var PcntItmID = "";
$(function(){

	EpisodeID=getParam("EpisodeID");  ///����ID
	AdmType=getParam("AdmType");      ///��������
	PcntItmID=getParam("PcntItmID");  ///��������ϸID
	InitTabs(EpisodeID,AdmType,PcntItmID);
})

/// ��ʼ����ǩ����
function InitTabs(EpisodeID,AdmType,PcntItmID){
	if(AdmType == "In"){
		$('#ptab').append('<div id="icmt" title="����סԺ"></div>');
	}else{
		$('#ptab').append('<div id="ocmt" title="��������"></div>');
	}
	$('#ptab').append('<div id="pal" title="������¼"></div>');
	$('#ptab').append('<div id="ris" title="����¼"></div>');
	$('#ptab').append('<div id="lab" title="�����¼"></div>');
	$('#ptab').append('<div id="epl" title="�������"></div>');
	$('#ptab').append('<div id="ord" title="����ҽ��"></div>');
	$('#ptab').append('<div id="opr" title="������Ϣ"></div>');
	if(AdmType == "In"){
		$('#ptab').append('<div id="tmp" title="���µ�"></div>');
	}

	$('#ptab').tabs({    
	    border:false,
	    fit:true, 
	    onSelect:function(title){
	        var tab = $('#ptab').tabs('getSelected');  // ��ȡѡ������
	        var tbId = tab.attr("id");
	        var maintab="";
	        switch(tbId){
		        case "icmt":
					maintab="dhcpha.comment.inpatadminfo.csp";  //��������
					break;
		        case "ocmt":
					maintab="dhcpha.comment.outpatadminfo.csp";  //��������
					break;
	            case "pal":
					maintab="dhcpha.comment.paallergy.csp";  //������¼
					break;
				case "ris":
					maintab="dhcpha.comment.risquery.csp";   //����¼
					break;
				case "lab":
					maintab="dhcpha.comment.labquery.csp";   //�����¼
					break;
				case "epl":
					maintab="dhcpha.clinical.jhepisodebrowser.csp";  //�������
					break;
				case "ord":
					maintab="dhcpha.comment.queryorditemds.csp";  //����ҽ��
					break;
				case "opr":
					maintab="dhcpha.clinical.operquery.csp";  //������Ϣ
					break;
				case "tmp":
					maintab="dhcnurtempature.csp";    //���µ�
					break;
			}
			//iframe ����
	        var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="'+maintab+'?PatientID='+''+'&EpisodeID='+EpisodeID+'&PcntItmID='+PcntItmID+'"></iframe>';
	        tab.html(iframe);
	    }
	});

	if(AdmType == "In"){
		$('#ptab').tabs('select','����סԺ'); //Ĭ��ѡ����
	}else{
		$('#ptab').tabs('select','��������'); //Ĭ��ѡ����
	}
	
}

/// ���¼��ز�����Ϣ
function refreshTabs(EpisodeID,AdmType,PcntItmID,PatName){
	InitTabs(EpisodeID,AdmType,PcntItmID);
	window.parent.updTabsTitle(PatName);
}