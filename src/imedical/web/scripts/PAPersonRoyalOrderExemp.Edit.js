// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
// ab 11.11.04


function DocumentLoadHandler() {
	// update to reload in the parent frame
	if ((parent)&&(parent.frames)&&(parent.frames["PAPersonRoyalOrderExemp_List"])) {
		var frame=document.getElementById("TFRAME");
		if (frame) frame.value=window.parent.name;
	}
}
document.body.onload=DocumentLoadHandler;