// Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

// Log 43168 - AI - 08-04-2004 : Ensure filename entered is NOT "found.txt", as this is the temporary file used in processing.

var objUpdate = document.getElementById("update1"); if (objUpdate) objUpdate.onclick=UpdateClickHandler;

function BodyLoadHandler() {
	var objINTFileName = document.getElementById("INTFileName");
	if (objINTFileName) {
		objINTFileName.className="";
	}

	// Log 62899 - max number records for outbound files
	var objINTDataDirection = document.getElementById("INTDataDirection");
	if ((objINTDataDirection)&&(objINTDataDirection.value == "I")) {
		DisableField("INTNumRecordsPerFile");
	}
	if ((objINTDataDirection)&&(objINTDataDirection.value == "O")) {
		DisableField("INTFileMoveDirectory");
		DisableField("INTFileAction");
		DisableField("INTFileName");
	}
}

// Log 43168 - AI - 08-04-2004 : Ensure filename entered is NOT "found.txt", as this is the temporary file used in processing.
function UpdateClickHandler() {
	var objINTFileName = document.getElementById("INTFileName");
	var upperval=objINTFileName.value.toUpperCase();
	if (upperval=="FOUND.TXT") {
		alert(t['FOUND_TXT']);
		objINTFileName.className="clsInvalid";
		// perform the actual "commit" to the field, so the invalid value is now the "old" value for onchange handler.
		var val=objINTFileName.value;
		objINTFileName.value=val;
		websys_setfocus("INTFileName");
		return false;
	}
	// if continuing, treated as the "else" of the above "if" statement.
	objINTFileName.className="";
	return update1_click();
}
// end Log 43168

document.body.onload=BodyLoadHandler;


function DisableField(fldName) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if ((fld)&&(fld.tagName=="INPUT")) {
		fld.value = "";
		fld.disabled = true;
		fld.className = "disabledField";
		if (lbl) lbl = lbl.className = "";
	}
}