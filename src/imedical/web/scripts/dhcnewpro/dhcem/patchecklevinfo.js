
/// 病人预检分诊信息 bianshuai 2016-08-16
var EpisodeID = "";      /// 病人就诊ID
var PatientID = "";
/// 页面初始化函数
function initPageDefault(){

	InitPatEpisodeID();    /// 初始化加载病人就诊ID
	LoadEmPatInfo();       /// 加载病人信息
	LoadPatCheckLevInfo(); /// 加载分诊信息
}

/// 初始化加载病人就诊ID
function InitPatEpisodeID(){
	EpisodeID = "" //getParam("EpisodeID");
	PatientID = "13281" //getParam("PatientID");
}

/// 加载病人信息
function LoadEmPatInfo(){
	runClassMethod("web.DHCEMPatCheckLevQuery","GetEmPatInfo",{"PatientID":PatientID, "EpisodeID":EpisodeID},function(jsonString){
		var jsonObject = jsonString;
		SetPagePatPanelInfo(jsonObject);  /// 设置页面数据显示内容
	},'json',false)
}

/// 加载分诊信息
function LoadPatCheckLevInfo(){
	runClassMethod("web.DHCEMPatCheckLevQuery","GetEmPatCheckLevInfo",{"PatientID":PatientID, "EpisodeID":EpisodeID},function(jsonString){
		var jsonObject = jsonString;
		SetPagePatPanelInfo(jsonObject);  /// 设置页面数据显示内容
	},'json',false)
}

/// 设置页面数据显示内容
function SetPagePatPanelInfo(jsonObject){
	
	$("span").each(function(){
		$(this).text(jsonObject[this.id]);
	})
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })