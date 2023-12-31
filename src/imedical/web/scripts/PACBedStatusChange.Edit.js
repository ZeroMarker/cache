// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function DocumentLoadHandler() {

	var objUpdRoom = document.getElementById("CloseRoom");
	var objUpdWard = document.getElementById("CloseWard");
	var objRoom = document.getElementById("RoomID");
	var objWard = document.getElementById("WardID");
	var objID = document.getElementById("ID");
	if ((objID) && (objID.value != "")) {
		if (objUpdRoom) {
			objUpdRoom.disabled = true;
			objUpdRoom.onclick = LinkDisable;
		}
		if (objUpdWard) {
			objUpdWard.disabled = true;
			objUpdWard.onclick = LinkDisable;
		}
	}
	if ((objRoom) && (objUpdRoom) && (objRoom.value == "")) DisableField(objUpdRoom);
	if ((objWard) && (objUpdWard) && (objWard.value == "")) DisableField(objUpdRoom);

	var obj = document.getElementById("STATDate");
	if (obj) obj.onblur = StartDateBlurHandler;
	var obj = document.getElementById('update1'); //+ wxl 090616
	if (obj) obj.onclick = UpdateHandler;
	websys_sckeys["U"] = UpdateHandler;
	var obj = document.getElementById('delete1');
	if (obj) obj.onclick = DeleteHandler;
	websys_sckeys["D"] = DeleteHandler;
	var objGetPatBedInfo = document.getElementById("GetPatBedInfo");
	//alert(objGetPatBedInfo+","+objID.value)
	if (objGetPatBedInfo) {
		var objPatOccupy = document.getElementById("PatOccupy");
		var objEpisodeID = document.getElementById("EpisodeID");
		var retStr = cspRunServerMethod(objGetPatBedInfo.value, objID.value);
		if (retStr != "") {
			//alert(retStr);
			objPatOccupy.value = retStr.split("^")[0];
			objEpisodeID.value = retStr.split("^")[3];
		}
	}

}

document.body.onload = DocumentLoadHandler;

function DisableField(fld) {
	var lbl = ('c' + fld);
	if (fld) {
		fld.value = "";
		fld.disabled = true;
		fld.className = "disabledField";
		if (lbl) lbl = lbl.className = "";
	}
}

function StartDateBlurHandler(e) {
	var eobj = websys_getSrcElement(e);
	if (eobj) {
		var obj = document.getElementById("STATDateH");
		if ((obj) && (eobj.value != "")) obj.value = DateStringTo$H(eobj.value);
		if ((obj) && (eobj.value == "")) obj.value = obj.defaultValue;
	}
}

function LinkDisable() {
	return false;
}

function UpdateHandler() {
	var STATRowId = "";
	var objID = document.getElementById("ID");
	if (objID) STATRowId = objID.value;
	var objSTATDate = document.getElementById("STATDate");
	if (objSTATDate) var StartDate = objSTATDate.value;
	var objSTATTime = document.getElementById("STATTime");
	if (objSTATTime) var StartTime = objSTATTime.value;
	var objSTATDateTo = document.getElementById("STATDateTo");
	if (objSTATDateTo) var EndDate = objSTATDateTo.value;
	var objSTATTimeTo = document.getElementById("STATTimeTo");
	if (objSTATTimeTo) var EndTime = objSTATTimeTo.value;
	var objSTATReasonNotAvailDR = document.getElementById("STATReasonNotAvailDR");
	if (objSTATReasonNotAvailDR) var UnavailableReason = objSTATReasonNotAvailDR.value;
	var EpisodeID = "";
	var objEpisodeID = document.getElementById('EpisodeID');
	if (objEpisodeID) EpisodeID = objEpisodeID.value;
	var objUserID = document.getElementById("UserID");
	if (objUserID) var userId = objUserID.value;
	var objWardID = document.getElementById("WardID");
	if (objWardID) var WardID = objWardID.value;
	var objBedID = document.getElementById("BedID");
	if (objBedID) var BedID = objBedID.value;

	var objUpdatePatBedStChange = document.getElementById("UpdatePatBedStChange");
		
		/*if(EndDate!=''){
			if(EndDate<StartDate){
				alert("截止日期应当大于开始日期！");
				return;
			}else if(EndDate==StartDate){
				if(EndTime!=''&&(EndTime<StartTime)){
					alert("截止时间应当大于开始时间！");
					return;
				}
			}
		}*/
		if(IsBedOccupyed(StartDate,StartTime,EndDate,EndTime)){
			alert("该床位当前时间段被占用！")
			return
		}
		
		if ((!IsValidTime(objSTATTime))||(!IsValidTime(objSTATTimeTo))) {
		alert("请输入正确的时间格式!")
		return
	}

	//alert(objUpdatePatBedStChange.value+","+STATRowId+","+StartDate+","+StartTime+","+EndDate+","+EndTime+","+UnavailableReason+","+EpisodeID+","+userId+","+WardID+","+BedID)
	if (objUpdatePatBedStChange) {
		var retStr = cspRunServerMethod(objUpdatePatBedStChange.value, STATRowId, StartDate, StartTime, EndDate, EndTime, UnavailableReason, EpisodeID, userId, WardID, BedID);
		if (retStr != 0) {
			alert(retStr);
			return;
		}
	}
	//var lnk = "websys.reload.csp";
	var lnk="websys.close.csp";
	window.location = lnk;
	if(window.opener){
		window.opener.location.reload();
	}
	if(window.opener.opener){
		window.opener.opener.location.reload();
	}
	//return update1_click();
}

function GetPatInfo(str) {
	var tem = str.split("^");
	var obj = document.getElementById('PatOccupy');
	if (obj) obj.value = tem[0];
	var obj = document.getElementById('EpisodeID');
	if (obj) obj.value = tem[3];
	return;
}

function DeleteHandler() {
	var STATRowId = "";
	var objID = document.getElementById("ID");
	if (objID) STATRowId = objID.value;
	var objDeletePatBedStChange = document.getElementById("DeletePatBedStChange");
	//alert(objDeletePatBedStChange+","+STATRowId)
	if (objDeletePatBedStChange) {
		var retStr = cspRunServerMethod(objDeletePatBedStChange.value, STATRowId);
		if (retStr != 0) {
			alert(retStr);
			return;
		}
	}
	return delete1_click();
}
//判断包床时间段是否被占用:占用-true；未占用-false
function IsBedOccupyed(StartDate,StartTime,EndDate,EndTime){
	var tb_ChangeList = document.getElementById('tPACBedStatusChange_List');
	var s_dateTime = tkMakeServerCall("websys.Conversions","DateHtmlToLogical",StartDate) +' '+StartTime;
	var e_dateTime = tkMakeServerCall("websys.Conversions","DateHtmlToLogical",EndDate)+' '+EndTime;
	//var ocutimes = GetTableColum(tb_ChangeList,2);
	var rows = tb_ChangeList.rows.length;
	
	if(rows>1){
		//var ocudates = GetTableColum(tb_ChangeList,3);
		//var edate = ocudates[ocudates.length-1];
		var selectedFlag = IsTableSelected(tb_ChangeList,'clsRowSelected');
		if (selectedFlag) {
			return false;
		}
			var sdate_list = tb_ChangeList.rows(1).cells(1).innerText;
			var stime_list = tb_ChangeList.rows(1).cells(2).innerText;
			var sdatatime_list = tkMakeServerCall("websys.Conversions","DateHtmlToLogical",sdate_list) + ' ' + stime_list;
			if(s_dateTime>=sdatatime_list){
				var edate_list = tb_ChangeList.rows(1).cells(3).innerText;
				var etime_list = tb_ChangeList.rows(1).cells(4).innerText;				
				if(edate_list!=" "&&etime_list!=" "){
					var edatatime_list = tkMakeServerCall("websys.Conversions","DateHtmlToLogical",edate_list) + ' ' + etime_list;	
					if(s_dateTime>edatatime_list){
						return false;
					}
					else{
						return true;
					}
				}			
				else{
					return true;
				}
			}
			else{
				if(EndDate!=''&&EndTime!=''){
					if(e_dateTime<sdatatime_list){
						return false;
					}else{
						return true;
					}
				}else{
				//alert("该");
					return true;
				}
			}				
		}
		else{
			return false;
		}
		
}
//根据CSS获取选中行
function IsTableSelected(obj,sName)      //-->obj是要获取元素的父级
{        
	var trs = obj.getElementsByTagName("tr");
    for(var i = 1;i<trs.length;i++){
	    if(trs[i].className==sName){
		    return true;
		}
	}
	return false;
}
