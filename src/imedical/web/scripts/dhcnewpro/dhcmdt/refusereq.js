//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2020-08-04
// 描述:	   驳回界面
//===========================================================================================
var DisGrpID = ""; /// 病种ID
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
var LgGroupID = session['LOGON.GROUPID'] /// 安全组ID
var LgParam=LgHospID+"^"+LgLocID+"^"+LgGroupID+"^"+LgUserID
/// 页面初始化函数
function initPageDefault(){
	
	/// 初始化加载病人就诊ID
	InitPatEpisodeID();
	
}

/// 初始化加载病人就诊ID
function InitPatEpisodeID(){
	EpisodeID = getParam("EpisodeID");   /// 就诊ID
	DisGrpID = getParam("DisGrpID");     /// 病种ID
	mdtID = getParam("ID");
}

/// 保存
function saveRefuses(){
	
	var refReason = $("#refreason").val();  /// 驳回理由
	if (trim(refReason) == ""){
		$.messager.alert("提示:","驳回理由不能为空！","warning");
		return;
	}
	var str=0
	runClassMethod("web.DHCMDTConsult","InsRefReason",{"mdtID":mdtID,"refReason":refReason,"userID":LgUserID},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("提示:","驳回理由保存失败，失败原因:"+jsonString,"warning");
		}else{
			str = jsonString;
			$.messager.alert("提示:","保存成功！","info",function(){
				//window.parent.QryPatList();
				window.parent.TakClsWin();
			});
		}
	},'',false)
}

/// 关闭
function closewin(){
	parent.$(".panel-tool-close").click();
	//commonParentCloseWin();
	//window.parent.TakClsWin();
}
/// JQuery 初始化页面
$(function(){ initPageDefault(); })