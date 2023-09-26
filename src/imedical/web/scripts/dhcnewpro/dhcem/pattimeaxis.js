//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2019-10-31
// ����:	   ���౾ʱ����JS
//===========================================================================================

var PatientID = "";     /// ����ID
var EpisodeID = "";     /// ����ID
var EmType = "";        /// ��������
var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgLocID = session['LOGON.CTLOCID'];  /// ����ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID

/// ҳ���ʼ������
function initPageDefault(){
	
	InitParams();      /// ��ʼ������
	InitComponents();  /// ��ʼ���������
	InitTimeAxis();    /// ʱ����
}

/// ��ʼ��ҳ�����
function InitParams(){
	
	PatientID = getParam("PatientID");   /// ����ID
	EpisodeID = getParam("EpisodeID");   /// ����ID
	EmType = getParam("EmType");         /// ��������
}

/// ��ʼ���������
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

/// ʱ���ᵥ��
function timeaxis_click(){

	$(this).addClass("li_active").siblings().removeClass("li_active");
	/// ���ز��˽�������
	LoadPatBsContent(this.id);
}

///  ʱ����
function InitTimeAxis(){
	
	clearPanel(); /// ���
	runClassMethod("web.DHCEMBedSideShiftQuery","JsBsTimeAxis",{"PatientID":PatientID, "EpisodeID":EpisodeID, "Type":EmType},function(jsonString){
		
		if (jsonString != null){
			InsTimeAxis(jsonString);
		}
	},'json',false)
}

///  ʱ����
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
	
	/// Ĭ��ѡ���һ��
	if ($(".timeaxis ul li").length > 0){
		$(".timeaxis ul li").eq(0).addClass("li_active");	
		LoadPatBsContent($(".timeaxis ul li").eq(0).attr("id"));  /// ���ز��˽�������
	}
}

/// ���ز��˽�������
function LoadPatBsContent(bsID){

	runClassMethod("web.DHCEMBedSideShiftQuery","JsBsSchContent",{"BsID":bsID, "EpisodeID":EpisodeID},function(jsonString){
		
		if (jsonString != null){
			InsBsPanel(jsonString);
		}
	},'json',false)
}

/// ����ҳ�潻������
function InsBsPanel(itemObj){
	
	$("#bs_schedule").val(itemObj.SchContent);   /// ���
	$("#bs_user").val(itemObj.User);           /// ������
	$("#bs_successor").val(itemObj.Successor); /// �Ӱ���
	$("#bs_date").val(itemObj.Date);           /// ��������
	
	$("#background div").html(itemObj.Background);  /// ����
	$("#assessment div").html(itemObj.Assessment);  /// ����
	$("#suggest div").html(itemObj.Suggest);        /// ����
}

/// ���
function clearPanel(){
	
	$("#bs_schedule").val("");       /// ���
	$("#bs_user").val("");           /// ������
	$("#bs_successor").val("");      /// �Ӱ���
	$("#bs_date").val("");           /// ��������
	
	$("#background div").html("");  /// ����
	$("#assessment div").html("");  /// ����
	$("#suggest div").html("");        /// ����
}

/// �ⲿˢ��ҳ��
function refresh(PaAdmID){
	EpisodeID = PaAdmID;
	InitTimeAxis();    /// ʱ����
}

/// �Զ�����ҳ�沼��
function onresize_handler(){
	
}

/// ҳ��ȫ���������֮�����(EasyUI������֮��)
function onload_handler() {

	
	/// �Զ�����ҳ�沼��
	onresize_handler();
}

window.onload = onload_handler;
window.onresize = onresize_handler;

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })