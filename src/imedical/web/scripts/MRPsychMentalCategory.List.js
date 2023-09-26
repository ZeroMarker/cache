// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
// ab 28.01.05

function NewClickHander() {

	if ((parent)&&(parent.frames)&&(parent.frames["MRPsychMentalCategory_Edit"])) {
		var PARREF=document.getElementById("PARREF");
		if (PARREF) PARREF=PARREF.value;
		var CONTEXT=document.getElementById("CONTEXT")
		if (CONTEXT) CONTEXT=CONTEXT.value;
		var PatientID=document.getElementById("PatientID")
		if (PatientID) PatientID=PatientID.value;
		var EpisodeID=document.getElementById("EpisodeID")
		if (EpisodeID) EpisodeID=EpisodeID.value;
		var mradm=document.getElementById("mradm")
		if (mradm) mradm=mradm.value;        
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=MRPsychMentalCategory.Edit&PatientID="+PatientID+"&PARREF="+PARREF+"&CONTEXT="+CONTEXT+"&mradm="+mradm+"&EpisodeID="+EpisodeID
		
        websys_createWindow(lnk,"MRPsychMentalCategory_Edit",""); 
		return false;
	}
}

function TableClickHandler(e) {
	// edit loads in bottom frame, delete reloads frames
	var eSrc = websys_getSrcElement(e);
	if (parent.frames["MRPsychMentalCategory_List"]) {
		if (eSrc.tagName=="IMG") {
			eSrc=websys_getParentElement(eSrc)
		}
		if (eSrc.tagName=="A") {
            if (eSrc.id!="") {
			    eSrc.target="MRPsychMentalCategory_Edit";
			    if (eSrc.id.indexOf("deletez")==0) eSrc.target="_parent";
            }
		}
	}
	return true;
}

function DocumentLoadHandler() {
	var newlink=document.getElementById("new1");
	if (newlink) newlink.onclick=NewClickHander;
	
	var objTable=document.getElementById("tMRPsychMentalCategory_List");
	if (objTable) objTable.onclick=TableClickHandler;
}

document.body.onload=DocumentLoadHandler;