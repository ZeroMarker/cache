//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2019-11-01
// 描述:	   交班本内容JS
//===========================================================================================

var PatientID = "";     /// 病人ID
var EpisodeID = "";     /// 病人就诊ID
var mradm = "";         /// ID
var bsItemID = "";      /// 交班子表ID
var Pid = "";           /// 进程ID
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID

/// 页面初始化函数
function initPageDefault(){

	InitParams();      /// 初始华参数
	InitComponents();  /// 初始化界面组件
	InitCkEditor();    /// 初始化界面编辑器
	LoadPatBsContent();/// 加载病人交班内容
}

/// 初始化页面参数
function InitParams(){
	
	BsID = getParam("BsID");           /// 交班ID
	bsItemID = getParam("bsItemID");   /// 交班子表ID
	EpisodeID = getParam("EpisodeID"); /// 就诊ID
	Pid = getParam("Pid");   /// 进程号
}

/// 初始化界面组件
function InitComponents(){
	

}

/// 初始化界面编辑器
function InitCkEditor(){
	
	ckEditor=CKEDITOR.replace( 'bs_suggest' ,{
			height:100,
			toolbar:[
			['Bold','Italic','Underline','Strike','-','Subscript','Superscript'],
			['TextColor','BGColor'],
			['FontSize'],  /// 'Format','Font',
			['HorizontalRule','SpecialChar','-','Outdent','Indent'],
			['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],['Maximize']
			],	
			resize_enabled:false, //去除底部标签控件
			removePlugins:'elementspath'
	});
}

/// 加载病人交班内容
function LoadPatBsContent(){
	
	runClassMethod("web.DHCEMBedSideShiftQuery","JsBsSchContent",{"BsID":BsID, "EpisodeID":EpisodeID, "Pid":Pid},function(jsonString){
		
		if (jsonString != null){
			InsBsPanel(jsonString);
		}
	},'json',false)
}

/// 更新页面交班内容
function InsBsPanel(itemObj){
	
	EpisodeID = itemObj.EpisodeID;         /// 就诊ID
	PatientID =  itemObj.PatientID;        /// 病人ID
	mradm =  itemObj.mradm;                /// 病人ID
	$("#bs_patname").val(itemObj.PatName); /// 姓名
	$("#bs_patsex").val(itemObj.PatSex);   /// 性别
	$("#bs_bedno").val(itemObj.PatBed);    /// 年龄
	$("#bs_patage").val(itemObj.PatAge);   /// 床号
	$("#bs_patno").val(itemObj.PatNo);     /// 登记号
	$("#bs_chklev").val(itemObj.Priority); /// 级别
	$("#bs_type").val(itemObj.Type);       /// 类型
	$("#bs_diag").val(itemObj.PatDiag);    /// 诊断
	$("#bs_ObsTime").val(itemObj.ObsTime); /// 滞留时间
	
	$("#bs_background").html(itemObj.Background);  /// 背景
	$("#bs_assessment").html(itemObj.Assessment);  /// 评估
	
	/// 编辑框赋值
	CKEDITOR.instances.bs_suggest.setData(itemObj.Suggest); /// 建议
	
	SwitchButton(itemObj.SwitchFlag);  /// 交班项目切换按钮控制
}

/// 上一例
function prev_click(){
	
	switchPat(-1);  /// 切换交班填写病人
}

/// 下一例
function next_click(){
	
	switchPat(1);  /// 切换交班填写病人
}

/// 病历浏览
function docemr_click(){
	openPatEmr(PatientID, EpisodeID, mradm);
}

/// 护理病历
function nuremr_click(){
	$.messager.alert("提示","需提供链接！","info");
}

/// 引用:无法兼容谷歌浏览器
function quote_click(){
	
	var Link="dhcem.patemrque.csp?EpisodeID="+EpisodeID+"&PatientID="+PatientID;
	window.parent.commonShowWin({
		url: Link,
		title: "引用",
		width: 1280,
		height: 600
	})
//	var result = window.open(url,"_blank",'dialogWidth:'+ (window.screen.availWidth - 200) +'px;DialogHeight='+ (window.screen.availHeight - 200) +'px;center=1'); 
//	return;	
}

///引用回调函数
function InsQuote(innertTexts, flag){
	var bs_suggest = ckEditor.getData();  /// 建议 编辑框取值
	/// 编辑框赋值
	CKEDITOR.instances.bs_suggest.setData(bs_suggest  +"\r\n"+ innertTexts); /// 建议
	return;
}

/// 模板
function temp_click(){
	
	
}

/// 保存
function save_click(){
	
	var bs_background = $("#bs_background").val();  /// 背景
	var bs_assessmen = $("#bs_assessment").val();   /// 评估
	var bs_suggest = ckEditor.getData();  /// 建议 编辑框取值
	if ((trim(bs_assessmen) == "")&(trim(bs_suggest) == "")){
		$.messager.alert("提示:","评估和建议不能同时为空！","warning");
		return;
	}
	var mListData = bs_background +"^"+ bs_assessmen +"^"+ bs_suggest +"^"+ EpisodeID;
	
	runClassMethod("web.DHCEMBedSideShift","saveBsItem",{"BsID": BsID, "BsItmID": bsItemID, "mListData": mListData},function(jsonString){
		
		if (jsonString < 0){
			$.messager.alert("提示","保存失败，失败原因:"+jsonString,"warning");
		}else{
			bsItemID = jsonString;
			$.messager.alert("提示","保存成功！","info");
			LoadPatBsContent(); /// 重新加载数据
			window.parent.parent.refresh();
		}
	},'',false)	
}

/// 切换交班填写病人
function switchPat(direc){
	
	runClassMethod("web.DHCEMBedSideShiftQuery","JsBsSwitchPat",{"BsID": BsID, "EpisodeID":EpisodeID, "Pid":Pid, "direc":direc},function(jsonObj){
		
		if (jsonObj != null){
			bsItemID = jsonObj.bsItemID;    /// 交班子表ID
			EpisodeID = jsonObj.EpisodeID;  /// 就诊ID
			LoadPatBsContent();             /// 重新加载数据
			window.parent.frames[0].refresh(EpisodeID);
		}
	},'json',false)
}

/// 切换交班填写病人
function switchPatOLD(direc){
	
	runClassMethod("web.DHCEMBedSideShiftQuery","JsBsSwitchPat",{"bsItemID":bsItemID, "direc":direc},function(jsonObj){
		
		if (jsonObj != null){
			bsItemID = jsonObj.bsItemID;  /// 交班子表ID
			LoadPatBsContent();           /// 重新加载数据
			window.parent.frames[0].refresh(EpisodeID);
		}
	},'json',false)
}

/// 交班项目切换按钮控制
function SwitchButton(BTFlag){
	
	if (BTFlag == -1){
		$("#bt_prev").linkbutton('disable');  /// 上一例按钮
		$("#bt_next").linkbutton('disable');  /// 下一例按钮
	}
	if (BTFlag == 0){
		$("#bt_prev").linkbutton('enable');   /// 上一例按钮
		$("#bt_next").linkbutton('enable');   /// 下一例按钮
	}
	if (BTFlag == 1){
		$("#bt_prev").linkbutton('disable');  /// 上一例按钮
		$("#bt_next").linkbutton('enable');   /// 下一例按钮
	}
	if (BTFlag == 2){
		$("#bt_prev").linkbutton('enable');   /// 上一例按钮
		$("#bt_next").linkbutton('disable');  /// 下一例按钮
	}
}
/// 病历查看
function openPatEmr(PatientID, EpisodeID, mradm){
	
	if (EpisodeID == ""){
		$.messager.alert("提示","请先选择病人！","warning");
		return;
	}
	/// 旧版病历
	/// window.open("emr.record.browse.patient.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID, 'newWin', 'height='+ (window.screen.availHeight-200) +', width='+ (window.screen.availWidth-200) +', top=100, left=100, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
	
	/// 新版病历
	var link = "websys.chartbook.hisui.csp?&PatientListPanel=emr.browse.episodelist.csp&PatientListPage=emr.browse.patientlist.csp&SwitchSysPat=N&ChartBookID=70&PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm +"&WardID=";
	window.open(link, 'newWin', 'height='+ (window.screen.availHeight-100) +', width='+ (window.screen.availWidth-100) +', top=50, left=50, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
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