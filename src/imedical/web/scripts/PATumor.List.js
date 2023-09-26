// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var frm = document.forms["fPATumor_List"];

function Init() {
	var objcancerID=document.getElementById("CancerReg");
	var objNew=document.getElementById("new1newwindow");
	var rowid="";
	if (parent.frames["FRAMEPACancerRegLinkAdmList"]) rowid=parent.frames["FRAMEPACancerRegLinkAdmList"].document.getElementById('rowidz1');
	
	if (objNew) {
		// Disable NEW button
		if ((objcancerID)&&(objcancerID.value=="")) {
			//objNew.style.visibility = "hidden";
			objNew.onclick=LinkDisable;
		}
	}
	
	var updateObj=document.getElementById("update1");
	if (updateObj) updateObj.onclick=updateClickHandler;
	
	if (parent.frames["FRAMEPACancerRegEdit"]) var objScrRef=parent.frames["FRAMEPACancerRegEdit"].document.getElementById('RefreshCSP');
	if (objScrRef && objScrRef.value=="1") RefreshCSPage();
}

function updateClickHandler() {
	if (window.name=="FRAMEPATumorList") {
		if (frm.elements['TWKFL'].value!="") frm.elements['TFRAME'].value=window.parent.name;
	}
	
	return update1_click();
	alert(window.name);
}

function LinkDisable(evt) {
	alert(t['NO_CANCER_REGISTRATION_MADE']);
	return false;
}

//RQG 19.09.03 L35869 Refresh the CSP page when tumor details were deleted
function RefreshCSPage() {
	var EpisodeID=""; var objEpisId="";
	var objPatID=document.getElementById("PatientID");
	var CONTEXT=session['CONTEXT'];
	var objTWKFL=document.getElementById('TWKFL');
	var objTWKFLI=document.getElementById('TWKFLI');

	if (parent.frames["FRAMEPACancerRegLinkAdmList"]) var objEpisId=parent.frames["FRAMEPACancerRegLinkAdmList"].document.getElementById('EpisodeID');

	var TWKFL="";
	var TWKFLI="";
	var PatientID="";
	if (objPatID) PatientID=objPatID.value;
	if (objTWKFL) TWKFL=objTWKFL.value;
	if (objTWKFLI) TWKFLI=objTWKFLI.value;
	if (objEpisId) EpisodeID=objEpisId.value;

	var url="pacancerregframe.popup.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&TWKFL="+TWKFL+"&TWKFLI="+TWKFLI+"&CONTEXT="+CONTEXT;
	websys_createWindow(url,"TRAK_main");
}

document.body.onload=Init;