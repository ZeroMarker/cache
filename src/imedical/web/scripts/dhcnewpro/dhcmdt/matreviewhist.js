//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2019-07-10
// ����:	   mdt�������
//===========================================================================================
var EpisodeID = "";     /// ���˾���ID
var CstID = "";         /// ����ID
var DisGrpID = "";      /// ���Ѳ���ID
var mdtID = "";         /// ��������ID
var mdtMakResID = "";   /// ԤԼ��ԴID
var editSelRow = -1;
var editGrpRow = -1;
var editExpRow = -1;
var LType = "CONSULT";  /// ������Ҵ���
var isEditFlag = 0;     /// ҳ���Ƿ�ɱ༭
var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgLocID = session['LOGON.CTLOCID'];  /// ����ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID
var LgGroupID = session['LOGON.GROUPID'] /// ��ȫ��ID
var LgParams=LgHospID+"^"+LgLocID+"^"+LgGroupID+"^"+LgUserID;
var del = String.fromCharCode(2);
var IsHasPlantAut=true;
/// ҳ���ʼ������
function initPageDefault(){
	
	/// ��ʼ��ҳ�����
	InitPatEpisodeID();

	/// ��������tabs
	InitReqMatTabs();
	
	InitPage();
}

/// ��ʼ�����ز��˾���ID
function InitPatEpisodeID(){
	
	DisGrpID = getParam("DisGrpID");    /// ���Ѳ���ID
	EpisodeID = getParam("EpisodeID");  /// ����ID
	mdtID = getParam("ID");             /// ���ﵥ������
	mdtMakResID = getParam("mdtMakResID");  /// ԤԼ��ԴID
	IsConsCentPlan = getParam("IsConsCentPlan");  /// �������İ���
	
	var RetData=$.cm({ 
		ClassName:"web.DHCMDTMatReview",
		MethodName:"GetPageData",
		MdtID:mdtID,
		LgParams:LgParams,
		dataType:"text"
	}, false);
	var RetDataArr=RetData.split("^");
	///������
	IsContact=RetDataArr[1];
	ConsSatatus=RetDataArr[0];
	IsConsExperts=RetDataArr[2];
	
	if (mdtID != ""){
		var Link = "dhcmdt.makeresources.csp?ID="+ mdtID +"&mdtMakResID="+mdtMakResID +"&DisGrpID="+ DisGrpID +"&EpisodeID="+ EpisodeID+"&MWToken="+websys_getMWToken();
		$("#mdtFrame").attr("src",Link);
	}
	
	if($('.tabs-selected').length){
		if($('.tabs-selected').text()===$g("MDT����")){
			if ($("#tab_req").attr("src") == "") $("#tab_req").attr('src',$("#tab_req").attr("data-src"));	
		}
	}
}

/// ��������tabs
function InitReqMatTabs(){
	
	$('#tag_id').tabs({ 
		onSelect:function(title){
			switch (title){
				case "MDT����":
					if ($("#tab_req").attr("src") == "") $("#tab_req").attr('src',$("#tab_req").attr("data-src"));
					break;
				case "���Ӳ���":
					if ($("#tab_emr").attr("src") == "") $("#tab_emr").attr('src',$("#tab_emr").attr("data-src"));
					break;
				case "����ģ��":
					if ($("#tab_model").attr("src") == "") $("#tab_model").attr('src',$("#tab_model").attr("data-src"));
					break;
				case "�ϴ��ļ�":
					if ($("#tab_file").attr("src") == "") $("#tab_file").attr('src',$("#tab_file").attr("data-src"));
					break;
				case "����ʱ����":
					if ($("#tab_axis").attr("src") == "") $("#tab_axis").attr('src',$("#tab_axis").attr("data-src"));
					break;	
				default:
					return;
			}
		}
	}); 
}

/// �رյ�������
function TakClsWin(){

	commonParentCloseWin();        /// �رյ�������
	window.parent.$("#bmDetList").datagrid("reload");
}

function InitPage(){
	if(!IsHasPlantAut){
		//$('#contentLayout').layout('hidden','east');	
	}
	if(ConsSatatus=="����"){
		$(".canPlanArea").hide();
	}else{
		$(".planArea").hide();
	}
	
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
