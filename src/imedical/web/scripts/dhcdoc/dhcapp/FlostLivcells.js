
function Init(){
	$("#FrostFlag").checkbox("check")
	GetIsWritePisFlag();
}
function ItemMastOn(itmmastid,TesItemDesc,arDefEmg){
	ItemMastOn_Map.apply(null, arguments);
	SentOrderpanel.SetEmFlag(0,1,1)
	FLostBBPanel.LoadPisSpecList(itmmastid)
	/*SetPisEmgflag(itmmastid);  /// 设置加急标志
	if (arDefEmg=="Y"){
		$("#EmgFlag").checkbox('check');
	}
	$("#FrostFlag").checkbox("check").checkbox('disable')*/
	//SetPisFrostflag(itmmastid);  /// 设置冰冻标志
}
function ItemMastOff(itmmast){
	ItemMastOff_Map.apply(null, arguments);
	$("#EmgFlag,#FrostFlag").checkbox('uncheck').checkbox('enable');
	FLostBBPanel.LoadPisSpecList("")
}
function SaveOtherInfo(){

}
function LoadOtherInfo(itemReqJsonStr){

}
// 取医嘱的加急标志
function SetPisEmgflag(arcimid){
	var jsonString=tkMakeServerCall("web.DHCAPPExaReportQuery","GetItmEmFlag",arcimid);
	//runClassMethod("web.DHCAPPExaReportQuery","GetItmEmFlag",{"arcimid":arcimid},function(jsonString){
		if (jsonString == "Y"){
			$("#EmgFlag").checkbox('enable');    /// 加急
		}else{
			$("#EmgFlag").checkbox('uncheck').checkbox('disable');
		}
	//},'json',false)
	
}

/// 取医嘱的冰冻标志
function SetPisFrostflag(arcimid){
	var jsonString=tkMakeServerCall("web.DHCAppPisMasterQuery","GetItmFrostFlag",arcimid);
	//runClassMethod("web.DHCAppPisMasterQuery","GetItmFrostFlag",{"arcimid":arcimid},function(jsonString){
		if (jsonString == "Y"){
			$("#FrostFlag").checkbox("check").checkbox("disable");
		}else{
			$("#FrostFlag").checkbox("uncheck").checkbox("enable");
		}
	//},'text',false)
	
}

/// 是否允许填写申请单
function GetIsWritePisFlag(){
	GetIsWritePisFlag_Map.apply(null, arguments);
}