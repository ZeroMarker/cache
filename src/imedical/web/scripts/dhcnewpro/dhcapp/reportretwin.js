/// ������洰��
showItmAppRetWin = function(Oeori, TraType){

	/// �򿪱��洰��
	LinkOpenWin(EpisodeID, Oeori, TraType);
	
	/*
	if($('#newRetWin').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�

	$('body').append('<div id="newRetWin"></div>');
	$("#newRetWin").append('<div id="retWin"></div>');

	/// ԤԼ���鴰��
	var option = {
		collapsible:true,
		border:true,
		closed:"true"
	};
	*/
	/*
	if (retIP == ""){
		var iframe="<h1>����ƽ̨IP��ַΪ�գ�����ά����ȷ��IP��ַ�����ԣ�</h1>";
	}else{	
		//var url = "http://172.19.91.17/hip/emrviewdoctor/csp/PacsLISReport.csp?keycard=HNSRMYY^1^^"+EpisodeID;
		var url = "http://"+retIP+"/hip/emrviewdoctor/csp/PacsLISReport.csp?keycard=HNSRMYY^1^^"+EpisodeID;
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="'+url+'"></iframe>';
	}

	var url = "dhcpha.comment.risquery.csp";
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="'+url+'?EpisodeID='+EpisodeID+'&Oeori='+Oeori+'"></iframe>';
	new WindowUX('�����', 'newRetWin', '1200', '600', option).Init();
	
	
	$("#retWin").html(iframe);
	*/
}

/// �򿪴���
function LinkOpenWin(EpisodeID, Oeori, TraType){
	
	var link = "";
	/// ȡPAC���鱨������
	runClassMethod("web.DHCEMInterface","GetRepLinkUrl",{"EpisodeID":EpisodeID,"Oeori":Oeori,"TraType":TraType},function(LinkUrl){

		if (LinkUrl != ""){
			link = LinkUrl;
		}

		window.open(link,"_blank","height=600, width=1200, top=30, left=50,toolbar=no, menubar=no, scrollbars=yes, resizable=no, location=no, status=no");
	},'',false)
}