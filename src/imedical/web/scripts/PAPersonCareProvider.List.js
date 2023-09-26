// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
// ab 16.02.04


function NewClickHander() {
	if ((parent)&&(parent.frames)&&(parent.frames["PAPersonCareProvider_Edit"])) {
		var PARREF=document.getElementById("PARREF");
		if (PARREF) PARREF=PARREF.value;
		var CONTEXT=document.getElementById("CONTEXT")
		if (CONTEXT) CONTEXT=CONTEXT.value;
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=PAPersonCareProvider.Edit&PatientID="+PARREF+"&PARREF="+PARREF+"&CONTEXT="+CONTEXT;
		websys_createWindow(lnk,"PAPersonCareProvider_Edit",""); 
		return false;
	}
}

function TableClickHandler(e) {
	// edit loads in bottom frame, delete reloads frames
	var eSrc = websys_getSrcElement(e);
	if (parent.frames["PAPersonCareProvider_List"]) {
		if (eSrc.tagName=="IMG") {
			eSrc=websys_getParentElement(eSrc)
		}
		if (eSrc.tagName=="A") {
            if (eSrc.id!="") {
			    eSrc.target="PAPersonCareProvider_Edit";
			    if (eSrc.id.indexOf("deletez")==0) eSrc.target="_parent";
            }
		}
	}
	return true;
}

function DocumentLoadHandler() {
	var newlink=document.getElementById("new1");
	if (newlink) newlink.onclick=NewClickHander;
	
	var objTable=document.getElementById("tPAPersonCareProvider_List");
	if (objTable) objTable.onclick=TableClickHandler;
}

document.body.onload=DocumentLoadHandler;