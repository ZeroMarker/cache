var DateStr = document.getElementById("DischgDate");
var TimeStr = document.getElementById("DischTime");
var curVisitStat = document.getElementById("curVisitStat");
var StatId = document.getElementById("StatId");
var insertch = document.getElementById("InsertVis").value;
var admFinalDischarge = document.getElementById("PAAdmFinalDischarge").value;
var EpisodeID = document.getElementById("EpisodeID").value;
var userId = session['LOGON.USERID'];
var visitStatList, curVisitStatCode;
var emWardId = "";
var bedId = 0;
//var tformName=document.getElementById("TFORM").value; //ypz 070404
var tformName = "DHCADMVisitStat.Edit";
var getComponentIdByName = document.getElementById("GetComponentIdByName").value; //ypz 070404
var componentId; //ypz 070404
componentId = cspRunServerMethod(getComponentIdByName, tformName); //070404

function BodyLoadHandler() {
	var retStr
	var getAdmType = document.getElementById("getAdmType").value;
	//alert(EpisodeID+"/"+getAdmType);
	retStr = cspRunServerMethod(getAdmType, EpisodeID);
	if (retStr != "E") { alert(t['alert:notEmergency']); return; }
	var update = document.getElementById("update1");
	if (update) update.onclick = UpdateClick;
	var patType = document.getElementById("PatType").value
	var GetPatCurStat = document.getElementById("GetPatCurStat").value
	var objUndoDischarge = document.getElementById("btnUndoDischarge");
	if (objUndoDischarge) objUndoDischarge.onclick = UndoDischarge;
	retStr = cspRunServerMethod(GetPatCurStat, EpisodeID);
	if (retStr != "") {
		var tmpList = retStr.split("^");
		//alert(retStr)
		if (tmpList[0].indexOf("Discharge") < 0) {
			objUndoDischarge.style.visibility = "hidden";
		}
		document.getElementById("curVisitStat").value = tmpList[1]
	}
	else objUndoDischarge.style.visibility = "hidden";

	var GetUserAccessStat = document.getElementById("GetUserAccessStat").value
	var objStatDesc = document.getElementById("VisitStat")
	objStatDesc.onchange = statDescDisplay; //onchange=statDescDisplay;
	retStr = cspRunServerMethod(GetUserAccessStat, patType, userId);
	if (retStr != 0) {
		visitStatList = retStr.split("^");
		var tmpList;
		for (var i = 0; i < visitStatList.length; i++) {
			tmpList = visitStatList[i].split("!");
			objStatDesc.options.add(new Option(tmpList[1], tmpList[0]));
		}
	}
	ChangeVisibilityById(componentId, "EmergencyDesc", "none");
	ChangeVisibilityById(componentId, "BedDesc", "none");
	ChangeVisibilityById(componentId, "ld52282iEmergencyDesc", "none");
	ChangeVisibilityById(componentId, "ld52282iBedDesc", "none");

}
function UndoDischarge() {
	var PatientID = document.getElementById('PatientID').value;
	var EpisodeID = document.getElementById('EpisodeID').value;
	var mradm = document.getElementById('mradm').value;

	var resStr = tkMakeServerCall("web.DHCADTDischarge", "GetFinalStat", EpisodeID)
	if (resStr != "0") {
		alert(resStr)
		return;
	}
	//var lnk="websys.default.csp?WEBSYS.TCOMPONENT=MRAdm.ReverseDischargeEdit&PatientID="+PatientID+"&EpisodeID="+EpisodeID+'&mradm='+mradm+'&ID='+mradm
	//alert(PatientID+"/"+EpisodeID+"/"+mradm)
	websys_createWindow("websys.default.csp?WEBSYS.TCOMPONENT=MRAdm.ReverseDischargeEdit&PatientID=" + PatientID + "&EpisodeID=" + EpisodeID + '&mradm=' + mradm + '&ID=' + mradm + "&PatientBanner=0", 'comp', 'top=20,left=20,width=300,height=170,scrollbars=yes,resizable=yes');
	//var ifSuccess=window.showModalDialog(lnk,"","dialogWidth:400px;status:no;dialogHeight:300px");
	//alert(ifSuccess)
	////var undoDischarge=document.getElementById('undoDischarge').value;
	//var undoDischarge=document.getElementById('PatientID').value;
	////var	retStr=cspRunServerMethod(undoDischarge,EpisodeID,userId);
	////if(retStr==0) {alert("OK");}
}
function GetStatId(str) {
	var loc = str.split("^");
	var curVisitStat = document.getElementById("curVisitStat");
	var obj = document.getElementById("StatId");
	obj.value = loc[0];
	curVisitStat.value = loc[1];
}
function UpdateClick() {
	if ((DateStr.value == "") || (TimeStr.value == "")) {
		alert(t['alert:dateOrTimeNull']);
		return;
	}
	var objStatCode = document.getElementById("VisitStat")
	//alert(objStatCode.options.selectedIndex)
	if (objStatCode.options.selectedIndex == -1) {
		alert(t['alert:selPatStat']);
		return;
	}
	var visitStatDesc = objStatCode.options[objStatCode.options.selectedIndex].text;
	var curVisitStatDesc = document.getElementById("curVisitStat").value;
	if (curVisitStatDesc == visitStatDesc) { alert(t['alert:sameStat']); return; }
	var visitStatCode = objStatCode.options[objStatCode.options.selectedIndex].value;

	var wardDesc = document.getElementById("ward").value;
	//alert(visitStatCode+"/"+bedId)
	if (visitStatCode == "Stay" || visitStatCode =="Salvage") {

		var EmergencyDesc = document.getElementById("EmergencyDesc").value;
		if (EmergencyDesc == "") {
			alert("留观请选择病区!")
			return;
		}
		/*if ((visitStatCode == "Stay") && (bedId == 0)) {
			alert(t['alert:selBed']);
			return;
		}*/
		var ret = tkMakeServerCall("web.DHCBillInterface", "GetnotPayOrderByRegno", "", EpisodeID)
		if (ret == 1) {
			alert("病人存在未结算医嘱,不能办理留观");
			return;
		}

		var ret = tkMakeServerCall("web.DHCADMVisitStat", "GetIfStaying", EpisodeID)
		if (ret == 1) {
			alert("病人已经在留观,不能再次办理留观");
			return;
		}

		var ret = tkMakeServerCall("web.DHCADMVisitStat", "GetIfHaveNoPayOrder", EpisodeID)
		if (ret == 1) {
			alert("病人有未结算的急诊留观账单，请先到【急诊留观结算】进行结算");
			return;
		}
		if (bedId !== "") {
			var ret = tkMakeServerCall("web.PACBedStatusChange", "IsUnavailBedStatus", bedId)
			if (ret == 1) {
				alert("该床位无法使用");
				return;
			}
		}


	}
	
	//alert(wardDesc);return;
	if (visitStatCode != "Inhospital") { wardDesc = "" }
	var retStr = cspRunServerMethod(insertch, EpisodeID, visitStatCode, DateStr.value, TimeStr.value, userId, wardDesc);
	if (retStr != 0) {
		alert(retStr);
		//alert(t['alert:insertStatErr']);
		return;
	}
	else {
		if (visitStatCode == "Stay" || visitStatCode =="Salvage") {
			var visitStatList, curVisitStatCode;
			var ctlocId = session['LOGON.CTLOCID'];
			var setStayStatus = document.getElementById("SetStayStatus").value;
			//alert(setStayStatus+" / "+EpisodeID+" / "+userId)
			var emergencyDesc = "";
			var objEmergencyDesc = document.getElementById("EmergencyDesc");
			if (objEmergencyDesc) emergencyDesc = objEmergencyDesc.value;
			var retStr = cspRunServerMethod(setStayStatus, EpisodeID, userId, ctlocId, emWardId, bedId)
			//alert(retStr)
			if (retStr != "0") alert(retStr);
			else {
				alert(t['alert:success']);
				window.location.reload();
			}
		}
		if (visitStatCode.indexOf("Discharge") > -1) {	//alert(admFinalDischarge+"/"+EpisodeID+"/"+userId)
			var retStr = cspRunServerMethod(admFinalDischarge, EpisodeID, userId)
			if (retStr != 0) alert(retStr);
			else {
				alert(t['alert:success']);
				window.location.reload();
			}
		}
		//wxl 081201 Start
		if (visitStatCode.indexOf("Death") > -1) {
			var setDeceasedStatus = document.getElementById("SetDeceasedStatus").value;
			//alert(setDeceasedStatus+" / "+EpisodeID+" / "+userId);
			var retStr = cspRunServerMethod(setDeceasedStatus, EpisodeID, DateStr.value, TimeStr.value)
			//alert(retStr);
			if (retStr != "0") alert(retStr);
			else {
				alert(t['alert:success']);
				window.location.reload();
			}
		}
		//wxl 081201 End
		if ((visitStatCode != "Stay") && (visitStatCode.indexOf("Discharge") < 0) && (visitStatCode.indexOf("Death") < 0)) {
			alert(t['alert:success']);
			window.location.reload();
		}
	}
	//if (retStr==0) alert(t['alert:success'])
	//window.location.reload();
	var userID = session['LOGON.USERID']
	var GetWorkflowID = document.getElementById('GetWorkflowID');
	if (GetWorkflowID) { var encmeth = GetWorkflowID.value } else { var encmeth = "" };
	var TWKFL = cspRunServerMethod(encmeth, userID)
	if (TWKFL != "") {
		var lnk = "websys.csp?TWKFL=" + TWKFL + "&TWKFLI=";
		window.location = lnk;
	}
	//opener.parent.location.reload();
	//window.close();
}


function statDescDisplay() {
	var objStatCode = document.getElementById("VisitStat")
	if (objStatCode.options.selectedIndex < 0) return;
	var visitStatCode = objStatCode.options[objStatCode.options.selectedIndex].value;
	var objEmergencyDesc = document.getElementById("EmergencyDesc")
	var objBedDesc = document.getElementById("BedDesc")
	var objCEmergencyDesc = document.getElementById("cEmergencyDesc")
	var objCBedDesc = document.getElementById("cBedDesc")
	//var objWardi=document.getElementById("ward")
	//alert(visitStatCode)
	if ((visitStatCode == "Stay")||(visitStatCode =="Salvage")) {
		ChangeVisibilityById(componentId, "ld52282iEmergencyDesc", "");
		//ChangeVisibilityById(componentId, "ld52282iBedDesc", "");
		ChangeVisibilityById(componentId, "EmergencyDesc", "");
		//ChangeVisibilityById(componentId, "BedDesc", "");
	}
	else {
		ChangeVisibilityById(componentId, "ld52282iEmergencyDesc", "none");
		ChangeVisibilityById(componentId, "ld52282iBedDesc", "none");
		ChangeVisibilityById(componentId, "EmergencyDesc", "none");
		ChangeVisibilityById(componentId, "BedDesc", "none");
	}
}
function SetLocAcuity(str) {
	var tmpList = str.split("^");
	if (tmpList[1]) {
		emWardId = tmpList[1];
	}
	else {
		return;
	}
	bedId = 0;
	var objBedDesc = document.getElementById("BedDesc");
	if (objBedDesc) objBedDesc.value = "";
	return;
	var objCTACUDesc = document.getElementById("CTACUDesc");
	if (objCTACUDesc) {
		var objEmergencyDesc = document.getElementById("EmergencyDesc");
		var objGetLocAcuity = document.getElementById("GetLocAcuity");
		if ((objGetLocAcuity) && (objEmergencyDesc)) {
			var ctacuDesc = cspRunServerMethod(objGetLocAcuity.value, objEmergencyDesc.value);
			objCTACUDesc.value = ctacuDesc;
		}
	}
}
function GetBedId(str) {
	bedId = 0;
	var tmpList = str.split("^");
	if (tmpList[4]) {
		if ((tmpList[4] == t['val:inuse']) || (tmpList[4] == "包床")) {
			alert(t['alert:inuse']);
			var objBedDesc = document.getElementById("BedDesc");
			if (objBedDesc) objBedDesc.value = "";
			return;
		}
	}
	if (tmpList[5]) {
		bedId = tmpList[5];
	}
}
function ChangeVisibilityById(componentId, id, visibilityStyle) {
	var obj = document.getElementById(id);
	if (obj) obj.style.display = visibilityStyle;
	var obj = document.getElementById("c" + id);
	if (obj) obj.style.display = visibilityStyle;
	if (componentId > 0) {
		obj = document.getElementById("ld" + componentId + "i" + id);
		if (obj) obj.style.display = visibilityStyle;
	}

}

document.body.onload = BodyLoadHandler;
