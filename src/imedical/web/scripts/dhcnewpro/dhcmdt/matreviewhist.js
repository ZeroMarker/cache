//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2019-07-10
// 描述:	   mdt资料审查
//===========================================================================================
var EpisodeID = "";     /// 病人就诊ID
var CstID = "";         /// 会诊ID
var DisGrpID = "";      /// 疑难病种ID
var mdtID = "";         /// 会诊申请ID
var mdtMakResID = "";   /// 预约资源ID
var editSelRow = -1;
var editGrpRow = -1;
var editExpRow = -1;
var LType = "CONSULT";  /// 会诊科室代码
var isEditFlag = 0;     /// 页面是否可编辑
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
var LgGroupID = session['LOGON.GROUPID'] /// 安全组ID
var LgParams=LgHospID+"^"+LgLocID+"^"+LgGroupID+"^"+LgUserID;
var del = String.fromCharCode(2);
var IsHasPlantAut=true;
/// 页面初始化函数
function initPageDefault(){
	
	/// 初始化页面参数
	InitPatEpisodeID();

	/// 申请资料tabs
	InitReqMatTabs();
	
	InitPage();
}

/// 初始化加载病人就诊ID
function InitPatEpisodeID(){
	
	DisGrpID = getParam("DisGrpID");    /// 疑难病种ID
	EpisodeID = getParam("EpisodeID");  /// 就诊ID
	mdtID = getParam("ID");             /// 会诊单据类型
	mdtMakResID = getParam("mdtMakResID");  /// 预约资源ID
	IsConsCentPlan = getParam("IsConsCentPlan");  /// 会诊中心安排
	
	var RetData=$.cm({ 
		ClassName:"web.DHCMDTMatReview",
		MethodName:"GetPageData",
		MdtID:mdtID,
		LgParams:LgParams,
		dataType:"text"
	}, false);
	var RetDataArr=RetData.split("^");
	///联络人
	IsContact=RetDataArr[1];
	ConsSatatus=RetDataArr[0];
	IsConsExperts=RetDataArr[2];
	
	if (mdtID != ""){
		var Link = "dhcmdt.makeresources.csp?ID="+ mdtID +"&mdtMakResID="+mdtMakResID +"&DisGrpID="+ DisGrpID +"&EpisodeID="+ EpisodeID+"&MWToken="+websys_getMWToken();
		$("#mdtFrame").attr("src",Link);
	}
	
	if($('.tabs-selected').length){
		if($('.tabs-selected').text()===$g("MDT申请")){
			if ($("#tab_req").attr("src") == "") $("#tab_req").attr('src',$("#tab_req").attr("data-src"));	
		}
	}
}

/// 申请资料tabs
function InitReqMatTabs(){
	
	$('#tag_id').tabs({ 
		onSelect:function(title){
			switch (title){
				case "MDT申请":
					if ($("#tab_req").attr("src") == "") $("#tab_req").attr('src',$("#tab_req").attr("data-src"));
					break;
				case "电子病历":
					if ($("#tab_emr").attr("src") == "") $("#tab_emr").attr('src',$("#tab_emr").attr("data-src"));
					break;
				case "会议模板":
					if ($("#tab_model").attr("src") == "") $("#tab_model").attr('src',$("#tab_model").attr("data-src"));
					break;
				case "上传文件":
					if ($("#tab_file").attr("src") == "") $("#tab_file").attr('src',$("#tab_file").attr("data-src"));
					break;
				case "治疗时间轴":
					if ($("#tab_axis").attr("src") == "") $("#tab_axis").attr('src',$("#tab_axis").attr("data-src"));
					break;	
				default:
					return;
			}
		}
	}); 
}

/// 关闭弹出窗口
function TakClsWin(){

	commonParentCloseWin();        /// 关闭弹出窗口
	window.parent.$("#bmDetList").datagrid("reload");
}

function InitPage(){
	if(!IsHasPlantAut){
		//$('#contentLayout').layout('hidden','east');	
	}
	if(ConsSatatus=="发送"){
		$(".canPlanArea").hide();
	}else{
		$(".planArea").hide();
	}
	
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })
