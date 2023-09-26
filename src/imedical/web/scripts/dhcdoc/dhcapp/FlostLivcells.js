
function Init(){
	$("#FrostFlag").checkbox("check")
	GetIsWritePisFlag();
}
function ItemMastOn(itmmastid,TesItemDesc,arDefEmg){
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
	SentOrderpanel.SetEmFlag(0,1,1)
	/*SetPisEmgflag(itmmastid);  /// 设置加急标志
	if (arDefEmg=="Y"){
		$("#EmgFlag").checkbox('check');
	}
	$("#FrostFlag").checkbox("check").checkbox('disable')*/
	//SetPisFrostflag(itmmastid);  /// 设置冰冻标志
}
function ItemMastOff(itmmast){
	$("#TesItemID").val("");
	$("#TesItemDesc").val("");
	$("#recLoc").combobox("setValue","");
	$("#recLoc").combobox("setText","");
	$("#EmgFlag,#FrostFlag").checkbox('uncheck').checkbox('enable');
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
	TakOrdMsg=$.cm({
	    ClassName : "web.DHCAppPisMasterQuery",
	    MethodName : "GetIsWritePisFlag",
	    dataType:"text",
	    "LgGroupID":session['LOGON.GROUPID'],
	    "LgUserID":session['LOGON.USERID'],
	    "LgLocID":session['LOGON.CTLOCID'],
	    "EpisodeID":EpisodeID
    },false);
	if(TakOrdMsg != ""){
		$.messager.alert("提示:",TakOrdMsg);
	}
}