var editSelRow = -1;    /// 当前编辑行
var TakOrdMsg = "";
var pid = "";  			 /// 唯一标识
var asStaus=""

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
	PisSpecpanel.LoadSpecItemList(itmmastid)
	}
function ItemMastOff(itmmast){
	$("#TesItemID").val("");
	$("#TesItemDesc").val("");
	$("#recLoc").combobox("setValue","");
	$("#recLoc").combobox("setText","");
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
	
	runClassMethod("web.DHCAppPisMasterQuery","GetIsWritePisFlag",{"LgGroupID":session['LOGON.GROUPID'],"LgUserID":session['LOGON.USERID'],"LgLocID":session['LOGON.CTLOCID'],"EpisodeID":EpisodeID},function(jsonString){
		TakOrdMsg = jsonString;
		if(TakOrdMsg != ""){
			$.messager.alert("提示:",TakOrdMsg);
		}
	},'text',false)
}