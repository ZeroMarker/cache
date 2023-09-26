// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
// ab 25.01.05


function DocumentLoadHandler() {
	// update to reload in the parent frame
	if ((parent)&&(parent.frames)&&(parent.frames["MRPsychTribunal_List"])) {
		var frame=document.getElementById("TFRAME");
		if (frame) frame.value=window.parent.name;
	}
}

function AppealTypeLookup(str) {
    var lu=str.split("^");
    var obj=document.getElementById("APPEALDesc");
    if (obj) obj.value=lu[3];
}


document.body.onload=DocumentLoadHandler;