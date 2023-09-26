function Init(){
	GetIsWritePisFlag();      /// 是否可填写判断

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
	
	}
function ItemMastOff(itmmast){
	$("#TesItemID").val("");
	$("#TesItemDesc").val("");
	$("#recLoc").combobox("setValue","");
	$("#recLoc").combobox("setText","");
}
function SaveOtherInfo(){
	return "";
}
function LoadOtherInfo(itemReqJsonStr){
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
         