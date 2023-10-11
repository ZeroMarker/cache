
function Init(){
	GetIsWritePisFlag();
}
function ItemMastOn(itmmastid,TesItemDesc,arDefEmg){
	ItemMastOn_Map.apply(null, arguments);
	
	SetPisEmgflag(itmmastid);  /// 设置加急标志
	if (arDefEmg=="Y"){
		$("#EmgFlag").checkbox('check');
	}
	sPanel.LoadPisSpecList(itmmastid)
	//SetPisFrostflag(itmmastid);  /// 设置冰冻标志
}
function ItemMastOff(itmmast){
	ItemMastOff_Map.apply(null, arguments);
	$("#EmgFlag,#FrostFlag").checkbox('uncheck').checkbox('enable');
	sPanel.LoadPisSpecList("")
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
	GetIsWritePisFlag_Map.apply(null, arguments);
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
		var PisNameStr=""
		$.each(rowDatas, function(index, item){
			if(trim(item.Name) != ""){
				if ((item.SepDate=="")||(item.FixDate=="")){
					Flag=1
					if (PisNameStr==""){PisNameStr=item.Name}
					else {PisNameStr=PisNameStr+"、"+item.Name}
				}
			}
		})
		if (Flag==1){
			$.messager.alert("提示:",PisNameStr +" 固定时间和离体时间为必填");
			return false;
		}
	}
	return true;
}