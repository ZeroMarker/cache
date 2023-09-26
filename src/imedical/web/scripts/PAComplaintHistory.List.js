// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function RefreshWindow(e) {
	var win=window.opener;
	if (win) {
		win.treload('websys.csp');
	}
}

var objRefresh=document.getElementById('update1');
objRefresh.onclick=RefreshWindow;