var isWriteFlagTCT = "-1";
var TakOrdMsg = "";
var DocMainFlag=0
function Init(){
	GetPatBaseInfo();
	if (Oeori==""){GetIsWriteFlagTCT();}
	GetIsWritePisFlag();
}

function ItemMastOn(itmmastid,TesItemDesc,arDefEmg){
	runClassMethod("web.DHCAppPisMasterQuery","GetIsWriteFlagTCT",{"EpisodeID":EpisodeID},function(jsonString){
		isWriteFlagTCT = jsonString;
		if((isWriteFlagTCT != 0)&&(DocMainFlag != 1)){
			$.messager.alert("提示:","只有成年女性才可填写妇科TCT检查申请！");
			$('a:contains("保存")').linkbutton('disable');	
		}
	},'json',false)
	$("#TesItemID").val(itmmastid);
	$("#TesItemDesc").val(TesItemDesc);
	var LocID = ""; var LocDesc = "";
	var OpenForAllHosp=0,LogLoc="";
	var OrderOpenForAllHosp=parent.$HUI.checkbox("#OrderOpenForAllHosp").getValue();
	var FindByLogDep=parent.$HUI.checkbox("#FindByLogDep").getValue();
	if (OrderOpenForAllHosp==true){OpenForAllHosp=1}
	if (FindByLogDep==true){LogLoc=session['LOGON.CTLOCID']}
	runClassMethod("web.DHCAPPExaReportQuery","jsonItmDefaultRecLoc",{"EpisodeID":EpisodeID, "ItmmastID":itmmastid,"OrderDepRowId":LogLoc,"OpenForAllHosp":OpenForAllHosp},function(jsonString){
		
		if (jsonString != ""){
			var jsonObjArr = jsonString;
			LocID = jsonObjArr[0].value;
			LocDesc = jsonObjArr[0].text;
		}
	},'json',false)

	$("#recLoc").combobox("setValue",LocID);
	$("#recLoc").combobox("setText",LocDesc);
	
	}
function ItemMastOff(itmmast){
	$("#TesItemID").val("");
	$("#TesItemDesc").val("");
	$("#recLoc").combobox("setValue","");
	$("#recLoc").combobox("setText","");
}
function SaveOtherInfo(){
	return ""
}
function LoadOtherInfo(itemReqJsonStr){
}
/// 是否允许填写妇科TCT
function GetIsWriteFlagTCT(){
	
	runClassMethod("web.DHCAppPisMasterQuery","GetIsWriteFlagTCT",{"EpisodeID":EpisodeID},function(jsonString){
		isWriteFlagTCT = jsonString;
		if((isWriteFlagTCT != 0)&&(DocMainFlag != 1)){
			$.messager.alert("提示:","只有成年女性才可填写妇科TCT检查申请！");
			$('a:contains("保存")').linkbutton('disable');	
		}
	},'json',false)
}
/// 病人就诊信息
function GetPatBaseInfo(){
	runClassMethod("web.DHCAppPisMasterQuery","GetPatEssInfo",{"PatientID":"", "EpisodeID":EpisodeID, "LocID":session['LOGON.CTLOCID'], "UserID":session['LOGON.USERID']},function(jsonString){
		var jsonObject = jsonString;
		if (jsonObject.PatSex == "男"){
			$("label:contains('妇科信息')").parent().hide();
		}
	},'json',false)
}
window.onbeforeunload = function(event) { 
	if (PisID != ""){
		var RtnFlag="1"
		runClassMethod("web.DHCAppPisMaster","InsCheckSend",{"Pid":PisID},function(jsonString){
			RtnFlag=jsonString;
		},'json',false)
		if (RtnFlag == "0"){
				return "还未发送申请单，是否离开此界面"
			}else{
				return;	
		}
	}else{ return;}
}
/// 是否允许填写申请单
function GetIsWritePisFlag(){
	
	runClassMethod("web.DHCAppPisMasterQuery","GetIsWritePisFlag",{"LgGroupID":session['LOGON.GROUPID'],"LgUserID":session['LOGON.USERID'],"LgLocID":session['LOGON.CTLOCID'],"EpisodeID":EpisodeID},function(jsonString){
		TakOrdMsg = jsonString;
		if(TakOrdMsg != ""){
			$.messager.alert("提示:",TakOrdMsg);
		}
	},'text',false)
}
function CheckSaveInfo(){
	if (ServerObj.TCTWomen=="0") return true;
	var MensDate=$HUI.datebox("#MensDate").getValue(); 
	var UnknownFlag=$("#UnknownFlag").is(":checked") 
	var PauFlag=$("#PauFlag").is(":checked") 
	if ((MensDate=="")&&(UnknownFlag==false)&&(PauFlag==false)){
		$.messager.alert("提示:","妇科信息必须填写");
		return false;
		}
	return true;
	}