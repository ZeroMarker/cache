//Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var OldCheckClick=""
var objDefLoginLoc=document.getElementById("DefLoginLoc");
var objNewStaffOnly=document.getElementById("NewStaffOnly");
var DefaultLoc=""

function BodyLoadHandler() {
	//alert("body load");
	if (objNewStaffOnly) {
		OldCheckClick=objNewStaffOnly.onclick;
		objNewStaffOnly.onclick=NewStaffOnClick;
	}
	//objDefLoginLoc.disabled=true;
	if (objDefLoginLoc) {
	//if ((objDefLoginLoc)&&(objDefLoginLoc.disabled)) {
		DefaultLoc=objDefLoginLoc.value;
	}
}

function NewStaffOnClick() {
	
	if (typeof OldCheckClick!="function") OldCheckClick=new Function(OldCheckClick); 
	//call the function i.e. the original handler
	if(OldCheckClick()==false) return false;

	// SA 3.7.02 - log 23316 FROM SPEC: "If the "New Staff Only" is set to "yes", then 
	// only display records with a blank Default Location." Field will be cleared out and disabled 
	// when checkbox is checked.
	if (objDefLoginLoc) {
		if ((objNewStaffOnly)&&(objNewStaffOnly.checked==true)) {
			DisableField("DefLoginLoc","ld1434iDefLoginLoc");
			objDefLoginLoc.value="";
		} else {
			EnableField("DefLoginLoc","ld1434iDefLoginLoc");
			objDefLoginLoc.value=DefaultLoc;
		}
	}
}

function EnableField(fldName,icN) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if (fld) {
		fld.disabled = false;
		fld.className = "";
		if (lbl) lbl = lbl.className = "";
	}
	if (icN) {
		var objIcon=document.getElementById(icN);
		if (objIcon) objIcon.style.visibility = "visible";
	}
}


function DisableField(fldName,icN) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if ((fld)&&(fld.tagName=="INPUT")) {
		fld.value = "";
		fld.disabled = true;
		fld.className = "disabledField";
		if (lbl) lbl = lbl.className = "";
	}
	if (icN) {
		var objIcon=document.getElementById(icN);
		if (objIcon) objIcon.style.visibility = "hidden";
	}

}

document.body.onload=BodyLoadHandler;
