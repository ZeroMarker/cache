//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2019-11-01
// 描述:	   增加交班病人JS
//===========================================================================================

var PatientID = "";     /// 病人ID
var EpisodeID = "";     /// 就诊ID
var BsID = "";          /// 交班ID
var Pid = "";           /// 进程ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID //hxy 2020-06-02

/// 页面初始化函数
function initPageDefault(){
	
	InitParams();      /// 初始华参数
	InitComponents();  /// 初始化界面组件

}

/// 初始化页面参数
function InitParams(){
	
	BsID = getParam("BsID");   /// 交班ID
	Pid = getParam("Pid");     /// 进程ID 
}

/// 初始化界面组件
function InitComponents(){
	
	/// 登记号
	$("#PatNo").bind('keypress',PatNo_KeyPress);
}

/// 登记号
function PatNo_KeyPress(e){
	
	if(e.keyCode == 13){
		var PatNo = $("#PatNo").val();
		if (!PatNo.replace(/[\d]/gi,"")&(PatNo != "")){
			///  登记号补0
			var PatNo = GetWholePatNo(PatNo);
			$("#PatNo").val(PatNo);
			GetPatBaseInfo(PatNo);  /// 查询
		}
	}
}

/// 确认
function sure(){
	
	var EpisodeID = $("#EpisodeID").text();     /// 就诊ID
	if (EpisodeID == ""){
		$.messager.alert("提示:","请先选择病人！","warning");
		return;
	}
	
	var BedID = $("#BedID").text();            /// 床号ID
	var mListData = EpisodeID +"^"+ BedID;
	runClassMethod("web.DHCEMBedSideShift","InsPatToShift",{ "BsID":BsID , "mListData":mListData, "Pid":Pid},function(jsonString){
		
		if (jsonString == -1){
			window.parent.$.messager.alert("提示:","该病人已经在当前交班记录中，不允许重复添加！","warning");
			return;
		}
		if (jsonString < 0){
			window.parent.$.messager.alert("提示:","添加失败！","warning");
		}else{
			window.parent.$.messager.alert("提示:","添加成功！","warning");
			 closewin(); /// 关闭
			 window.parent.refresh();
		}
	},'',false)
}

/// 关闭
function closewin(){
	
	commonParentCloseWin();
}

/// 病人就诊信息
function GetPatBaseInfo(PatNo){

	runClassMethod("web.DHCEMBedSideShiftQuery","GetPatBaseInfo",{"PatientNo":PatNo,"LgHospID":LgHospID},function(jsonString){ //hxy 2020-06-02
		var jsonObject = jsonString;
		if (typeof jsonObject.ErrCode != "undefined"){
			$.messager.alert('错误提示',jsonObject.ErrMsg +"，请核实后重试！");
			return;	
		}
		if (JSON.stringify(jsonObject) != '{}'){
			$('.td-span-m').each(function(){
				$(this).html(jsonObject[this.id]);
			})
		}else{
			$.messager.alert('错误提示',"病人信息不存在或病人非留观病人，请核实后重试！");
			return;	
		}
	},'json',false)
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