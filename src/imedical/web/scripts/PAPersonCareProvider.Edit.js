// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
// ab 16.02.04


function DocumentLoadHandler() {
	// update to reload in the parent frame
	if ((parent)&&(parent.frames)&&(parent.frames["PAPersonCareProvider_List"])) {
		var frame=document.getElementById("TFRAME");
		if (frame) frame.value=window.parent.name;
	}

}

document.body.onload=DocumentLoadHandler;