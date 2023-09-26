//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2019-07-10
// 描述:	   mdt选择会诊模板界面
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
	
	/// 提取备注
	GetNotes();
	
}

/// 初始化加载病人就诊ID
function InitPatEpisodeID(){
	EpisodeID = getParam("EpisodeID");   /// 就诊ID
	DisGrpID = getParam("DisGrpID");   /// 病种ID
	mdtID = getParam("ID");
}

/// 备注
function saveNotes(){
	
	var mdtnote = $("#mdtnote").val();     /// 备注
	if (trim(mdtnote) == ""){
		$.messager.alert("提示:","备注内容不能为空！","warning");
		return;
	}
	var str=0
	runClassMethod("web.DHCMDTConsult","InsConNotes",{"mdtID":mdtID,"mData":mdtnote},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("提示:","会诊申请保存失败，失败原因:"+jsonString,"warning");
		}else{
			str = jsonString;
			$.messager.alert("提示:","保存成功！","info",function(){
				window.parent.QryPatList();
				closewin();  /// 关闭
			});
		}
	},'',false)
}

/// 提取备注
function GetNotes(){
	
	runClassMethod("web.DHCMDTConsult","GetConNotes",{"mdtID":mdtID},function(jsonString){

		$("#mdtnote").val(jsonString);     /// 备注
	},'',false)
}

/// 关闭
function closewin(){
	
	commonParentCloseWin();
}
/// JQuery 初始化页面
$(function(){ initPageDefault(); })