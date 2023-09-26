//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2019-07-09
// 描述:	   MDT预约资源
//===========================================================================================

var PatientID = "";     /// 病人ID
var EpisodeID = "";     /// 病人就诊ID
var ID = "";       /// 会诊ID
var DisGrpID = ""; /// 病种ID
var mdtMakResID = "";   /// 预约资源ID
var offset = 0;   /// 偏移量
/// 页面初始化函数
function initPageDefault(){
	
	/// 初始化加载ID
	InitPatEpisodeID(); 
	
	/// 本周安排
	offset = GetWeekOffset(); /// 偏移量
	if (offset != 0){
		$("#LastWeek").linkbutton('enable');   /// 可用
	}
	InitWeekSchedule(offset);
	
	///  页面Button绑定事件
	InitBlButton();

}

/// 初始化加载病人就诊ID
function InitPatEpisodeID(){

	ID = getParam("ID");                /// 会诊ID
	DisGrpID = getParam("DisGrpID");    /// 病种ID
	EpisodeID = getParam("EpisodeID");  /// 就诊ID
	mdtMakResID = getParam("mdtMakResID");  /// 预约资源ID
}

/// 页面 Button 绑定事件
function InitBlButton(){

	$(".week-nav-item").on("click",".week-item-grp",function(){
		if ($(this).hasClass("week-item-disable")) return;   /// 资源是否可用
		$(".week-item-grp").removeClass("item-grp-select");
		$(this).addClass("item-grp-select");
	})
	InitTakMakRes(); /// /// 默认选中 已经选择的资源 
}

/// 默认选中 已经选择的资源 
function InitTakMakRes(){
	
	/// 默认选中 已经选择的资源
	if (mdtMakResID != ""){
		mdtMakResID = mdtMakResID.replace("||","-");
		$("#"+mdtMakResID).addClass("item-grp-select");
	}
}

/// 初始化本周安排
function InitWeekSchedule(offset){
	
	runClassMethod("web.DHCMDTConsultQuery","JsGetResWeekPlan",{"CstID":ID, "DisGrpID":DisGrpID, "offset":offset},function(jsonString){
		
		if (jsonString != null){
			InsWeekSchedule(jsonString);
		}
	},'json',false)
}

/// 待处理申请
function InsWeekSchedule(jsonObject){
	
	$('.week-plan-title [id^="Week"]').each(function(){
		var week_date = typeof jsonObject[this.id] == "undefined"?"":jsonObject[this.id];
		if (week_date != "") week_date = "["+ week_date +"]"; 
		$(this).text(week_date);
	})
	
	$(".week-plan-mon .week-nav-item:not(:nth-child(1)),.week-plan-aft .week-nav-item:not(:nth-child(1))").html("");
	
	var jsonArr = jsonObject.items;
	for(var i=0; i<jsonArr.length; i++){
		var TmpMakResID = jsonArr[i].ASRowId.replace("||","-");
		var disable = "";   /// 资源是否可用
		if (jsonArr[i].Usered == jsonArr[i].AllNum){
			disable = "week-item-disable";
		}
		var htmlstr = "";
		htmlstr = htmlstr + '<div id="'+ TmpMakResID +'" class="week-item-grp '+ disable +'" data-range="'+ jsonArr[i].TRDesc +'" data-date="'+ jsonArr[i].ASDate +'" data-time="'+ jsonArr[i].CsTime +'" data-id="'+ jsonArr[i].ASRowId +'">';
		htmlstr = htmlstr + '	<div class="item-grp-time"><label>'+ jsonArr[i].TRange +'</label></div>';
		htmlstr = htmlstr + '	<div class="item-grp-dis"><label>'+ jsonArr[i].DisGroup +'('+ jsonArr[i].Usered +"/"+ jsonArr[i].AllNum +')</label></div>';
		htmlstr = htmlstr + '</div>';
		$("#"+jsonArr[i].Week).append(htmlstr);
	}
	
	InitTakMakRes(); /// /// 默认选中 已经选择的资源 
}

/// 获取预约信息
function GetPatMakRes(){
	
	if ($(".item-grp-select").length != 0){
		var mdtMakResID=$(".item-grp-select").attr("data-id");       /// 预约资源ID
		var mdtMakResTimes=$(".item-grp-select").attr("data-range"); /// 预约时间范围
		var mdtMakResDate=$(".item-grp-select").attr("data-date");   /// 预约日期
		var mdtMakResTime=$(".item-grp-select").attr("data-time");   /// 预约时间
		
		if (isExistDisGrp(mdtMakResDate)){
			parent.$.messager.alert("提示:","同一个病人同病种组一天之内不允许进行两场会诊！","warning");
			return false;
		}
		
		window.parent.$("#mdtPreDate").val(mdtMakResDate);   /// 预约日期
		window.parent.$("#mdtPreTime").val(mdtMakResTime);   /// 预约时间
		window.parent.$("#mdtPreTimeRange").val(mdtMakResTimes);  /// 预约时间段
		window.parent.$("#mdtMakResID").val(mdtMakResID);    /// 预约资源ID
		return true;
	}else{
		parent.$.messager.alert("提示:","请先选择预约资源！","warning");
		return false;
	}
}

/// 同一个病人同病种组一天之内不允许进行两场会诊
function isExistDisGrp(mdtMakResDate){
	
	var isFlag = false;
	runClassMethod("web.DHCMDTCom","isExistDisGrpCs",{"EpisodeID":EpisodeID, "DisGrpID":DisGrpID, "MakResDate":mdtMakResDate, "mdtID":ID},function(jsonString){
		
		if (jsonString == 1){
			isFlag = true;
		}
	},'',false)

	return isFlag;
}

/// 自动设置图片展示区分布
function onresize_handler(){
	
	var Width = document.body.offsetWidth;
	var Height = document.body.scrollHeight;
//	/// 
//	$(".container").width(Width - 30);

//	/// 本周安排 列宽适应
//	//var imgWidth = ($(".week-plan").width() - 120)/5;
//	if (Width > 900){
//		var imgWidth = ($(".week-plan").width() - 125)/5;
//	}else if ((Width > 800)&(Width < 900)){
//		var imgWidth = ($(".week-plan").width() - 120)/5;
//	}else{
//		var imgWidth = ($(".week-plan").width() - 75)/5;
//	}
//	$(".week-nav-item:not(:nth-child(1))").width(imgWidth);
	
}

/// 翻页
function TurnPages(FlagCode){

	if (FlagCode == "N"){ offset = parseInt(offset) + 1;}
	else{offset = parseInt(offset) - 1;}
	if (offset <= 0){
		$("#LastWeek").linkbutton('disable');  /// 不可用
	}else{
		$("#LastWeek").linkbutton('enable');   /// 可用
	}
	if (offset < 0){
		offset = 0;
		$.messager.alert("提示:","已经是第一页了！");
		return;
	}

	InitWeekSchedule(offset); /// 初始化本周安排
	
}

/// 计算偏移量
function GetWeekOffset(){
	
	var WeekOffset = 0;
	runClassMethod("web.DHCMDTConsultQuery","GetWeekOffset",{"CstID":ID},function(jsonString){
		
		if (jsonString != ""){
			WeekOffset = jsonString;
		}
	},'',false)
	return WeekOffset;
}

/// 页面全部加载完成之后调用(EasyUI解析完之后)
function onload_handler() {
	
	/// 自动分布
	onresize_handler();
}

window.onload = onload_handler;
window.onresize = onresize_handler;

/// JQuery 初始化页面
$(function(){ initPageDefault(); })