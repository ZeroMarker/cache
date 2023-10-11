function Init(){
	GetIsWriteFlag();
}
function ItemMastOn(itmmastid,TesItemDesc,arDefEmg){
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
/// 是否允许填写申请单
function GetIsWritePisFlag(){
	
	GetIsWritePisFlag_Map.apply(null, arguments);
}
/// 是否允许填写尸检申请单
function GetIsWriteFlag(){
	if (PisID != "") return;
	runClassMethod("web.DHCAppPisMasterQuery","isPatDeadFlag",{"EpisodeID":EpisodeID},function(jsonString){
		
		isWriteFlag = jsonString;
		if(isWriteFlag != "Y"){
			$.messager.alert("提示:","仅有死亡患者才能填写尸检申请单！");
		}
	},'text',false)
}