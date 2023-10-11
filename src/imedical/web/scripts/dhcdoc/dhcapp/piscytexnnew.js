var editSelRow = -1;    /// 当前编辑行
var TakOrdMsg = "";
var pid = "";  			 /// 唯一标识
var asStaus=""

function Init(){
	GetIsWritePisFlag();
}
function ItemMastOn(itmmastid,TesItemDesc,arDefEmg){
	ItemMastOn_Map.apply(null, arguments);
	PisSpecpanel.LoadSpecItemList(itmmastid)
	}
function ItemMastOff(itmmast){
	ItemMastOff_Map.apply(null, arguments);
	PisSpecpanel.LoadSpecItemList("")
	}
function SaveOtherInfo(){

	return "";
	}
function LoadOtherInfo(itemReqJsonStr){
	
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