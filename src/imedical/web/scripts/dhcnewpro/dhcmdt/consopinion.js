
//===========================================================================================
// 作者：      yangyongtao
// 编写日期:   2020-03-30
// 描述:	   MDT专家会诊意见
//===========================================================================================
var ItmID=""
var CsStatCode=""
var UserID=""
var LocID=""
var CstID=""
var IsCASign=""
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
var LgGroupID = session['LOGON.GROUPID'] /// 安全组ID
var LgParam=LgHospID+"^"+LgLocID+"^"+LgGroupID+"^"+LgUserID
/// 页面初始化函数
function initPageDefault(){
  
  InitParam() 			//参数信息 
  CASginBut()  			//Ca签名按钮显示
  InitCstNOpinion()  	//专家意见
    	
}

/// 初始化加载参数信息 
function InitParam(){
	
  ItmID=$("#ItmID").val();
  IsOutDoc=(ItmID.indexOf("||")>0?"N":"Y");
  CsStatCode=$("#CsStatCode").val();
  UserID=$("#UserID").val();
  LocID=$("#LocID").val();
  CstID=$("#CstID").val();
  IsCaSign = getParam("IsCaSign"); 
  showDom();
}

function showDom(){
	IsCASigned=IsgetsignmdtSIGNID(ItmID)
	if(IsCASigned==1){
		$("#bt_sign").find(".l-btn-text").text("撤销签名") 
	}
	if((IsCASigned==1)||(CONSDISRUL!="1")){
		$("#mdtOpinion").attr("disabled",true)
	}else{
		$("#mdtOpinion").attr("disabled",false)
	}
	if(CONSDISRUL!="1"){
		$("#bt_save").hide();
	}else{
		$("#bt_save").show();
	}
}


//Ca签名按钮显示
function CASginBut(){
	if(IsCaSign){
		$("#bt_sign").show();
	}else{
		$("#bt_sign").hide();
    }
}

//获取每个专家自己意见
function InitCstNOpinion(){
	
	  var mdtOpinion=getCstNOpinion(ItmID)
	  $("#mdtOpinion").val(mdtOpinion);  	/// 会诊意见
   /*
	runClassMethod("web.DHCMDTConsultQuery","getCstNOpinion",{"ItmID":ItmID},function(jsonString){
		if (jsonString != ""){
			$("#mdtOpinion").val($_TrsTxtToSymbol(jsonString));  	/// 会诊意见
		}
	},'',false)
	*/
}

/// 保存
function mdtSave(){
	
	var mdtOpinion = $("#mdtOpinion").val();			///会诊意见
	if (mdtOpinion.replace(/\s/g,'') == ""){
		$.messager.alert("提示:","请填写会诊意见！","warning");
		return;
	}

	mdtOpinion = $_TrsSymbolToTxt(mdtOpinion); /// 处理特殊符号
	
	runClassMethod("web.DHCMDTConsult","UpdConItmOpion",{"ItmID": ItmID,"mdtOpinion": mdtOpinion,"IsOutDoc":IsOutDoc},function(jsonString){
		if (jsonString < 0){
			if(jsonString==-105){
				$.messager.alert("提示:","超出最大字符限制,最大内容限制1500字","warning");
			}else{
				$.messager.alert("提示:","保存失败！","warning");
			}
		}else{
			$.messager.alert("提示:","保存成功！","info");
			//commonParentCloseWin();
			window.parent.ReloadTable();
		}
			
	},'',false)	
	
}

/// 取消
function mdtCancel(){
	
	commonParentCloseWin();
}

/// 签名
function mdtSignCs(){
	
	var flag="OPI"
	if (ItmID == ""){
		$.messager.alert("提示:","mdt会诊专家不能为空！","warning");
		return;
	}
	
	var mdtOpinion=getCstNOpinion(ItmID)
	if (mdtOpinion == ""){
		$.messager.alert("提示:","请先保存会诊意见,然后签名操作！","warning");
		return;
	}
	
	//专家是否已经签过名了
	var IsCASign=IsgetsignmdtSIGNID(ItmID)
	if(IsCASign==1){
		$.messager.alert("提示", "会诊专家已经签名,不能重复签名！","warning")	
	    return;
	}
	
	//InvDigSign(CstID,ItmID,flag); /// 调用数字签名
	isTakeDigSignNew({"callback":mdtSignOk,"modelCode":"MDTCompSign"});
	return;
}

function mdtSignOk(){
	if(IsCA){
		///F:签名 C:撤销签名
		var execFlag = IsCASigned==1?"C":"F";
		InsDigitalSignNew(ItmID,LgUserID,execFlag,"MDT",""); ///保存数字签名日志
		///刷新显示
		showDom();
	}
}

/// 获取专家会诊意见
function getCstNOpinion(ItmID){
	
	var Opinion = ""; /// 专家会诊意见
	runClassMethod("web.DHCMDTConsultQuery","getCstNOpinion",{"ItmID":ItmID,"Type":CONSDISRUL,"IsOutDoc":IsOutDoc},function(jsonString){
		if (jsonString != ""){
			Opinion = jsonString;
		}
	},'',false)
	return Opinion
}

/// xww 2021-01-26 修改意见
function mdtEdit(){
	$("#mdtOpinion").attr("disabled",false)  
}

//专家是否已经签过名了
function IsgetsignmdtSIGNID(ItmID)
{  
    var IsCASign = "";
	runClassMethod("web.DHCMDTSignVerify","IsgetsignmdtSIGNID",{"mdtID":ItmID},function(jsonString){
		IsCASign = jsonString;     
	},'',false)
	return IsCASign;
	
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })