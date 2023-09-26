// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
// ab 31.01.05

// update to reload in the parent frame
if ((parent)&&(parent.frames)&&(parent.frames["MRPsychTreatmentForm_List"])) {
    var frame=document.getElementById("TFRAME");
    if (frame) frame.value=window.parent.name;
}

function DocumentLoadHandler() {
    var obj=document.getElementById("ConsentMand");
    var objconsent=document.getElementById("TFConsent");
    if ((obj)&&(obj.value=="Y")&&(objconsent)) labelMandatory("TFConsent");
}

document.body.onload=DocumentLoadHandler;

function labelMandatory(fld) {
	var lbl = document.getElementById('c' + fld)
	if (lbl) {
		lbl.className = "clsRequired";
	}
}