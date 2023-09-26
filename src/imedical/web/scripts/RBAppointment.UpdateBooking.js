// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

//LOG 49444 RC 15/04/05 Allow selection of service for walkin patients
function SERDescLookUpSelect(str) {
	var lu = str.split("^");
	var char4=String.fromCharCode(4)
	var SScheck=""
	var obj=document.getElementById('SERDesc');
	if (obj) obj.value=lu[1];
	// SB 02/04/04 (42622): Param order changed, so we need to redirect the array pieces.
	SScheck=mPiece(lu[3],char4,1)

	//if (lu[4]=="SS") {	//Log 42622
	if (SScheck=="SS") {
		var obj=document.getElementById('SS_ServId');
		if (obj) obj.value=mPiece(lu[3],char4,0)
		//if (obj) obj.value=lu[3]; 		//Log 42622
	} else {
		var obj=document.getElementById('ServID');
		if (obj) obj.value=mPiece(lu[3],char4,0);
		// LOG 40311 BC 4-12-2003 service set error on find
		var obj=document.getElementById('SS_ServId');
		if (obj) obj.value="";
	}
}
var obj=document.getElementById("update1");
if (obj) obj.onclick=CheckBeforeUpdate

//copied from RBAppointment.Find.js
function CheckBeforeUpdate(e) {
	var TDIRTY=document.getElementById("TDIRTY");

	var str=""; var sched="";
	var overbook=""
	str=document.getElementById("date").value+"**"+document.getElementById("SchedId").value+"*"+document.getElementById("ServID").value+"**"+document.getElementById("LocId").value+"***";
	var date=document.getElementById("date").value;
	var PatientID=""; if (document.getElementById("PatientID")) PatientID=document.getElementById("PatientID").value;
	var UserCode=""; if (document.getElementById("UserCode")) UserCode=document.getElementById("UserCode").value;
	var PIN=""; if (document.getElementById("PIN")) PIN=document.getElementById("PIN").value;
	var EpisodeID=""; if (document.getElementById("EpisodeID")) EpisodeID=document.getElementById("EpisodeID").value;
	var lnk = "rbappointment.checkbeforeupdatebooking.csp?PatientID="+PatientID+"&Str="+str+"&EpisodeID="+EpisodeID+"&date="+date+"&UserCode="+UserCode+"&PIN="+PIN+"&TDIRTY="+TDIRTY.value;
	websys_createWindow(lnk,"TRAK_hidden");
}

function UpdateClickHandler(e) {
	return update1_click();
}

function ServiceTextChangeHandler() {}

