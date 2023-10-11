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
			//$.messager.alert("建议:","成年女性才可填写妇科TCT检查申请！");
			//$('a:contains("保存")').linkbutton('disable');	
		}
	},'json',false)
	ItemMastOn_Map.apply(null, arguments);
	
	}
function ItemMastOff(itmmast){
	ItemMastOff_Map.apply(null, arguments);
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
		if((isWriteFlagTCT != 0)){
			websys_getTop().$.messager.alert("建议","只有成年女性才可填写妇科TCT检查申请！", 'info');
			//$('a:contains("保存")').linkbutton('disable');	
		}
	},'json',false)
}
/// 病人就诊信息
function GetPatBaseInfo(){
	/*runClassMethod("web.DHCAppPisMasterQuery","GetPatEssInfo",{"PatientID":"", "EpisodeID":EpisodeID, "LocID":session['LOGON.CTLOCID'], "UserID":session['LOGON.USERID']},function(jsonString){
		var jsonObject = jsonString;
		if (jsonObject.PatSex == "男"){
			$("label:contains('妇科信息')").parent().hide();
		}
	},'json',false)*/
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
	
	GetIsWritePisFlag_Map.apply(null, arguments);
}
function CheckSaveInfo(){
	if (ServerObj.TCTWomen=="0") return true;
	var MensDate=$HUI.datebox("#MensDate").getValue(); 
	var UnknownFlag=$("#UnknownFlag").is(":checked") 
	var PauFlag=$("#PauFlag").is(":checked") 
	if ((MensDate=="")&&(UnknownFlag==false)&&(PauFlag==false)){
		websys_getTop().$.messager.alert("提示","妇科信息必须填写", 'info');
		return false;
		}
	return true;
	}