// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function DocumentLoadHandler() {

	var obj = document.getElementById("update1")
	//if (obj) obj.onclick = UpdateClickHandler;

}

function UpdateClickHandler() {

 if (CheckMandatoryFields()) {
	var obj = document.getElementById("EpisodeID")
	if (obj) adm=obj.value

	var obj = document.getElementById("PatientID")
	if (obj) pat=obj.value

	var obj = document.getElementById("payorId")
	if (obj) payor=obj.value

	var obj = document.getElementById("planId")
	if (obj) plan=obj.value

	var obj = document.getElementById("ApptID")
	if (obj) ApptID=obj.value

	var obj = document.getElementById("RescID")
	if (obj) RescID=obj.value

	var obj = document.getElementById("date")
	if (obj) date=obj.value

	var obj = document.getElementById("PresentStatus")
	if (obj) PresentStatus=obj.value
	
	var obj = document.getElementById("UserCode")
	if (obj) UserCode=obj.value
	
	var obj = document.getElementById("PIN")
	if (obj) PIN=obj.value

	var itms="&EpisodeID=" + adm + "&PatientID=" + pat + "&Payor=" + payor + "&Plan=" + plan
	itms += "&ApptID=" + ApptID + "&RescID=" + RescID + "&date=" + date + "&PresentStatus=" + PresentStatus 
	itms += "&UserCode=" + UserCode + "&PIN=" + PIN
	//window.location='rbappointment.changestatus.payorplan.csp?' + itms;
	//return false;

	return update1_click();
 }
}

function PlanLookUp(str) {
	var lu = str.split("^");

	var obj = document.getElementById("planId")
	if (obj) obj.value=lu[2]
}

function PayorLookUp(str) {
	var lu = str.split("^");

	var obj = document.getElementById("payorId")
	if (obj) obj.value=lu[1]
}

function CheckMandatoryFields() {

	var msg="";
	var obj = document.getElementById('INSInsAssocDR');
	var cobj = document.getElementById('cINSInsAssocDR');
	if ((obj)&&(obj.value=="")&&(cobj.className=="clsRequired")) {
			msg += "\'" + t['INSInsAssocDR'] + "\' " + t['XMISSING'] + "\n";
	}
	var obj = document.getElementById('INSInsTypeDR');
	var cobj = document.getElementById('cINSInsTypeDR');
	if ((obj)&&(obj.value=="")&&(cobj.className=="clsRequired")) {
			msg += "\'" + t['INSInsTypeDR'] + "\' " + t['XMISSING'] + "\n";
	}
	var obj = document.getElementById('UserCode');
	var cobj = document.getElementById('cUserCode');
	if ((obj)&&(obj.value=="")&&(cobj.className=="clsRequired")) {
			msg += "\'" + t['UserCode'] + "\' " + t['XMISSING'] + "\n";
	}
	var obj = document.getElementById('PIN');
	var cobj = document.getElementById('cPIN');
	if ((obj)&&(obj.value=="")&&(cobj.className=="clsRequired")) {
			msg += "\'" + t['PIN'] + "\' " + t['XMISSING'] + "\n";
	}


	if (msg=="") {
		return true;
	} else {
		alert(msg)
		return false;
	}
}

document.body.onload = DocumentLoadHandler;
