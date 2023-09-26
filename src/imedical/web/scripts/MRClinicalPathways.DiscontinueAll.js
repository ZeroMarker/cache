// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function BodyLoadHandler() {
	var update = document.getElementById("update");
	if(update) update.onclick=UpdateClickHandler;
}

function UpdateClickHandler() {
	var par_win=window.opener;
	if (par_win) {
		var warning=document.getElementById("warning");
		if(warning)
			par_win.SetDCFlag(warning.checked);
	}
	window.close();
}

document.body.onload=BodyLoadHandler;
//var rowsel=0;
