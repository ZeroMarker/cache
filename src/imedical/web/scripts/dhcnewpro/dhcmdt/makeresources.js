//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2019-07-09
// ����:	   MDTԤԼ��Դ
//===========================================================================================

var PatientID = "";     /// ����ID
var EpisodeID = "";     /// ���˾���ID
var ID = "";       /// ����ID
var DisGrpID = ""; /// ����ID
var mdtMakResID = "";   /// ԤԼ��ԴID
var offset = 0;   /// ƫ����
/// ҳ���ʼ������
function initPageDefault(){
	
	/// ��ʼ������ID
	InitPatEpisodeID(); 
	
	/// ���ܰ���
	offset = GetWeekOffset(); /// ƫ����
	if (offset != 0){
		$("#LastWeek").linkbutton('enable');   /// ����
	}
	InitWeekSchedule(offset);
	
	///  ҳ��Button���¼�
	InitBlButton();

}

/// ��ʼ�����ز��˾���ID
function InitPatEpisodeID(){

	ID = getParam("ID");                /// ����ID
	DisGrpID = getParam("DisGrpID");    /// ����ID
	EpisodeID = getParam("EpisodeID");  /// ����ID
	mdtMakResID = getParam("mdtMakResID");  /// ԤԼ��ԴID
}

/// ҳ�� Button ���¼�
function InitBlButton(){

	$(".week-nav-item").on("click",".week-item-grp",function(){
		if ($(this).hasClass("week-item-disable")) return;   /// ��Դ�Ƿ����
		$(".week-item-grp").removeClass("item-grp-select");
		$(this).addClass("item-grp-select");
	})
	InitTakMakRes(); /// /// Ĭ��ѡ�� �Ѿ�ѡ�����Դ 
}

/// Ĭ��ѡ�� �Ѿ�ѡ�����Դ 
function InitTakMakRes(){
	
	/// Ĭ��ѡ�� �Ѿ�ѡ�����Դ
	if (mdtMakResID != ""){
		mdtMakResID = mdtMakResID.replace("||","-");
		$("#"+mdtMakResID).addClass("item-grp-select");
	}
}

/// ��ʼ�����ܰ���
function InitWeekSchedule(offset){
	
	runClassMethod("web.DHCMDTConsultQuery","JsGetResWeekPlan",{"CstID":ID, "DisGrpID":DisGrpID, "offset":offset},function(jsonString){
		
		if (jsonString != null){
			InsWeekSchedule(jsonString);
		}
	},'json',false)
}

/// ����������
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
		var disable = "";   /// ��Դ�Ƿ����
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
	
	InitTakMakRes(); /// /// Ĭ��ѡ�� �Ѿ�ѡ�����Դ 
}

/// ��ȡԤԼ��Ϣ
function GetPatMakRes(){
	
	if ($(".item-grp-select").length != 0){
		var mdtMakResID=$(".item-grp-select").attr("data-id");       /// ԤԼ��ԴID
		var mdtMakResTimes=$(".item-grp-select").attr("data-range"); /// ԤԼʱ�䷶Χ
		var mdtMakResDate=$(".item-grp-select").attr("data-date");   /// ԤԼ����
		var mdtMakResTime=$(".item-grp-select").attr("data-time");   /// ԤԼʱ��
		
		if (isExistDisGrp(mdtMakResDate)){
			parent.$.messager.alert("��ʾ:","ͬһ������ͬ������һ��֮�ڲ���������������","warning");
			return false;
		}
		
		window.parent.$("#mdtPreDate").val(mdtMakResDate);   /// ԤԼ����
		window.parent.$("#mdtPreTime").val(mdtMakResTime);   /// ԤԼʱ��
		window.parent.$("#mdtPreTimeRange").val(mdtMakResTimes);  /// ԤԼʱ���
		window.parent.$("#mdtMakResID").val(mdtMakResID);    /// ԤԼ��ԴID
		return true;
	}else{
		parent.$.messager.alert("��ʾ:","����ѡ��ԤԼ��Դ��","warning");
		return false;
	}
}

/// ͬһ������ͬ������һ��֮�ڲ����������������
function isExistDisGrp(mdtMakResDate){
	
	var isFlag = false;
	runClassMethod("web.DHCMDTCom","isExistDisGrpCs",{"EpisodeID":EpisodeID, "DisGrpID":DisGrpID, "MakResDate":mdtMakResDate, "mdtID":ID},function(jsonString){
		
		if (jsonString == 1){
			isFlag = true;
		}
	},'',false)

	return isFlag;
}

/// �Զ�����ͼƬչʾ���ֲ�
function onresize_handler(){
	
	var Width = document.body.offsetWidth;
	var Height = document.body.scrollHeight;
//	/// 
//	$(".container").width(Width - 30);

//	/// ���ܰ��� �п���Ӧ
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

/// ��ҳ
function TurnPages(FlagCode){

	if (FlagCode == "N"){ offset = parseInt(offset) + 1;}
	else{offset = parseInt(offset) - 1;}
	if (offset <= 0){
		$("#LastWeek").linkbutton('disable');  /// ������
	}else{
		$("#LastWeek").linkbutton('enable');   /// ����
	}
	if (offset < 0){
		offset = 0;
		$.messager.alert("��ʾ:","�Ѿ��ǵ�һҳ�ˣ�");
		return;
	}

	InitWeekSchedule(offset); /// ��ʼ�����ܰ���
	
}

/// ����ƫ����
function GetWeekOffset(){
	
	var WeekOffset = 0;
	runClassMethod("web.DHCMDTConsultQuery","GetWeekOffset",{"CstID":ID},function(jsonString){
		
		if (jsonString != ""){
			WeekOffset = jsonString;
		}
	},'',false)
	return WeekOffset;
}

/// ҳ��ȫ���������֮�����(EasyUI������֮��)
function onload_handler() {
	
	/// �Զ��ֲ�
	onresize_handler();
}

window.onload = onload_handler;
window.onresize = onresize_handler;

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })