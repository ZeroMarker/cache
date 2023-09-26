
function Init(){
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
	
	SetPisEmgflag(itmmastid);  /// 设置加急标志
	if (arDefEmg=="Y"){
		$("#EmgFlag").checkbox('check');
	}
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
			//$("#EmgFlag").checkbox('enable');    /// 加急
			SentOrderpanel.SetEmFlag(1,1,0)
		}else{
			SentOrderpanel.SetEmFlag(0,0,0)
			//$("#EmgFlag").checkbox('uncheck').checkbox('disable');
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
function CheckSaveInfo(){
	if (ServerObj.LIVSpecFix="1"){
		var rows = $('#PisSpecList').datagrid('getRows');
		//删除前结束所有的编辑行
		$.each(rows,function(index,data){
	         $("#PisSpecList").datagrid('endEdit', index); 
		});
		var rowDatas = $('#PisSpecList').datagrid('getRows');
		var Flag=0
		$.each(rowDatas, function(index, item){
			if(trim(item.Name) != ""){
				if ((item.SepDate=="")||(item.FixDate=="")){
					Flag=1
				}
			}
		})
		if (Flag==1){
			$.messager.alert("提示:","固定时间和离体时间为必填");
			return false;
		}
	}
	return true;
}