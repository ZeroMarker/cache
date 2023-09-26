//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2019-10-31
// 描述:	   交班本时间轴JS
//===========================================================================================

var PatientID = "";     /// 病人ID
var EpisodeID = "";     /// 就诊ID
var EmType = "";        /// 交班类型
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID

/// 页面初始化函数
function initPageDefault(){
	
	InitParams();      /// 初始华参数
	InitComponents();  /// 初始化界面组件
	InitTimeAxis();    /// 时间轴
}

/// 初始化页面参数
function InitParams(){
	
	PatientID = getParam("PatientID");   /// 病人ID
	EpisodeID = getParam("EpisodeID");   /// 就诊ID
	EmType = getParam("EmType");         /// 交班类型
}

/// 初始化界面组件
function InitComponents(){
	
	$(".timeaxis").on("click","li",timeaxis_click);
	
	if (EmType == "Nur"){
		$("#vitalsigns").hide();	
	}
	if (EmType == "Doc"){
		//$("#background").hide();
		$("#vitalsigns").hide();	
	}
}

/// 时间轴单击
function timeaxis_click(){

	$(this).addClass("li_active").siblings().removeClass("li_active");
	/// 加载病人交班内容
	LoadPatBsContent(this.id);
}

///  时间轴
function InitTimeAxis(){
	
	clearPanel(); /// 清空
	runClassMethod("web.DHCEMBedSideShiftQuery","JsBsTimeAxis",{"PatientID":PatientID, "EpisodeID":EpisodeID, "Type":EmType},function(jsonString){
		
		if (jsonString != null){
			InsTimeAxis(jsonString);
		}
	},'json',false)
}

///  时间轴
function InsTimeAxis(itemArr){
	
	var htmlstr = "";
	for (var i=0; i<itemArr.length; i++){

		htmlstr = htmlstr + '<li id="'+ itemArr[i].bsID +'">';
		htmlstr = htmlstr + '	<div class="circle"></div>';
		htmlstr = htmlstr + '	<div class="txt">'+ itemArr[i].bsSchedule +'<span style="margin-left:10px;">'+ itemArr[i].bsUser +'</span></div>';
		htmlstr = htmlstr + '	<div class="time">'+ itemArr[i].bsDate +'</div>';
		htmlstr = htmlstr + '</li>';
	}

	$(".timeaxis ul").html(htmlstr);
	
	/// 默认选择第一项
	if ($(".timeaxis ul li").length > 0){
		$(".timeaxis ul li").eq(0).addClass("li_active");	
		LoadPatBsContent($(".timeaxis ul li").eq(0).attr("id"));  /// 加载病人交班内容
	}
}

/// 加载病人交班内容
function LoadPatBsContent(bsID){

	runClassMethod("web.DHCEMBedSideShiftQuery","JsBsSchContent",{"BsID":bsID, "EpisodeID":EpisodeID},function(jsonString){
		
		if (jsonString != null){
			InsBsPanel(jsonString);
		}
	},'json',false)
}

/// 更新页面交班内容
function InsBsPanel(itemObj){
	
	$("#bs_schedule").val(itemObj.SchContent);   /// 班次
	$("#bs_user").val(itemObj.User);           /// 交班人
	$("#bs_successor").val(itemObj.Successor); /// 接班人
	$("#bs_date").val(itemObj.Date);           /// 交班日期
	
	$("#background div").html(itemObj.Background);  /// 背景
	$("#assessment div").html(itemObj.Assessment);  /// 评估
	$("#suggest div").html(itemObj.Suggest);        /// 建议
}

/// 清空
function clearPanel(){
	
	$("#bs_schedule").val("");       /// 班次
	$("#bs_user").val("");           /// 交班人
	$("#bs_successor").val("");      /// 接班人
	$("#bs_date").val("");           /// 交班日期
	
	$("#background div").html("");  /// 背景
	$("#assessment div").html("");  /// 评估
	$("#suggest div").html("");        /// 建议
}

/// 外部刷新页面
function refresh(PaAdmID){
	EpisodeID = PaAdmID;
	InitTimeAxis();    /// 时间轴
}

/// 自动设置页面布局
function onresize_handler(){
	
}

/// 页面全部加载完成之后调用(EasyUI解析完之后)
function onload_handler() {

	
	/// 自动设置页面布局
	onresize_handler();
}

window.onload = onload_handler;
window.onresize = onresize_handler;

/// JQuery 初始化页面
$(function(){ initPageDefault(); })