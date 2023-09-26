// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var timerenabled=true;
function BodyLoadHandler() {
   	if (self==top) websys_reSizeT();

}
function BodyUnloadHandler(e) {
	alert(e);
	var eSrc=websys_getSrcElement(e)
	alert(eSrc.name);
	if (self == top) {
		var win=window.opener;
		if (win) {
            websys_onunload();
			win.treload('websys.reload.csp');
		}
	}
}

//document.body.onunload=BodyUnloadHandler;
document.body.onload = BodyLoadHandler;
