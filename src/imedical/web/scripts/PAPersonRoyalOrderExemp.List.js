// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
// ab 11.11.04


function NewClickHander() {
	if ((parent)&&(parent.frames)&&(parent.frames["PAPersonRoyalOrderExemp_Edit"])) {
		var PARREF=document.getElementById("PARREF");
		if (PARREF) PARREF=PARREF.value;
		var PatientID=document.getElementById("PatientID");
		if (PatientID) PatientID=PatientID.value;
        var CONTEXT=document.getElementById("CONTEXT")
		if (CONTEXT) CONTEXT=CONTEXT.value;
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=PAPersonRoyalOrderExemp.Edit&PatientID="+PatientID+"&PARREF="+PARREF+"&CONTEXT="+CONTEXT;
		websys_createWindow(lnk,"PAPersonRoyalOrderExemp_Edit",""); 
		return false;
	}
}

function TableClickHandler(e) {
	// edit loads in bottom frame, delete reloads frames
	var eSrc = websys_getSrcElement(e);
	if (parent.frames["PAPersonRoyalOrderExemp_List"]) {
		if (eSrc.tagName=="IMG") {
			eSrc=websys_getParentElement(eSrc);
		}
        //alert(eSrc.tagName);
		if (eSrc.tagName=="A") {
			eSrc.target="PAPersonRoyalOrderExemp_Edit";
			if (eSrc.id.indexOf("deletez")==0) eSrc.target="_parent";
		}
	}
	return true;
}

function DocumentLoadHandler() {
	var newlink=document.getElementById("new1");
	if (newlink) newlink.onclick=NewClickHander;
	
	var objTable=document.getElementById("tPAPersonRoyalOrderExemp_List");
	if (objTable) objTable.onclick=TableClickHandler;
}

document.body.onload=DocumentLoadHandler;