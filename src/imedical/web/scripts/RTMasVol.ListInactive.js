// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function BodyUnloadHandler11(e) {
	if (self == top) {
		var win=window.window.opener;
		if (win) win.location.reload();
		
	}
}

function BodyUnloadHandler() {
	var win=window.opener.parent.frames[1];
	if (win) {
		var formRad=win.document.forms['fRTVolume_List'];
		var formFindRequestVolume=win.document.forms['fRTMasVol_FindRequestVolume'];
		if (formRad||formFindRequestVolume) {
			// ANA Using the URl looses workflow.
			win.treload('websys.csp');			
		}
	} else if (window.opener) {
		//should be from epr chart csp page
		window.opener.history.go(0);
	}
}

document.body.onunload=BodyUnloadHandler;