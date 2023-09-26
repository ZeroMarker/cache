// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function BodyUnloadHandler(e) {
	if (self == top) {
		var win=window.opener;
		if (win) win.location.reload();
		
	}
}
//Log 66227 PeterC 31/01/08
function OEORIDepProcNotes_keydownhandler(encmeth) {
	var obj=document.getElementById("OEORIDepProcNotes");
	//LocateCode(obj,encmeth);
	LocateCode(obj,encmeth,false,"Kweb.MRCWordResultCode:LookUpByCode","MRCWordResultCode_lookupSelect");
}

function OETLookupCode_replace(newval,isrtf) {
	if (isrtf==1) {
		enteredField.Replace(newval);
	} else {
 	// NOTE : Existing W650 logic kept here.
		if (enteredField) {
			//alert('back with: ' + newval + '\nentered: ' + enteredField
			//+ '\nenteredtextrange: ' + enteredField.createTextRange
			//+ '\nenteredcursor: ' + enteredField.cursorPos);

			var origtxt = enteredField.value;
			if (enteredField.createTextRange && enteredField.cursorPos) {enteredField.cursorPos.text=newval;}
			enteredField.focus();
			enteredField = null;
		}
	}
}


document.body.onunload=BodyUnloadHandler;
