// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
// ab 27.11.03


function NewClickHander() {
	if ((parent)&&(parent.frames)&&(parent.frames["PAPersonOrganDonor_Edit"])) {
		var PARREF=document.getElementById("PARREF");
		if (PARREF) PARREF=PARREF.value;
		var CONTEXT=document.getElementById("CONTEXT")
		if (CONTEXT) CONTEXT=CONTEXT.value;
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=PAPersonOrganDonor.Edit&PatientID="+PARREF+"&PARREF="+PARREF+"&CONTEXT="+CONTEXT
		websys_createWindow(lnk,"PAPersonOrganDonor_Edit",""); 
		return false;
	}
}

function TableClickHandler(e) {
	// edit loads in bottom frame, delete reloads frames
	var eSrc = websys_getSrcElement(e);
	if (parent.frames["PAPersonOrganDonor_List"]) {
		if (eSrc.tagName=="IMG") {
			eSrc=websys_getParentElement(eSrc)
		}
		if (eSrc.tagName=="A") {
            if (eSrc.id!="") {
			    eSrc.target="PAPersonOrganDonor_Edit";
			    if (eSrc.id.indexOf("deletez")==0) eSrc.target="_parent";
            }
		}
	}
	return true;
}

function DocumentLoadHandler() {
	var newlink=document.getElementById("new1");
	if (newlink) newlink.onclick=NewClickHander;
	
	var objTable=document.getElementById("tPAPersonOrganDonor_List");
	if (objTable) objTable.onclick=TableClickHandler;
}

document.body.onload=DocumentLoadHandler;