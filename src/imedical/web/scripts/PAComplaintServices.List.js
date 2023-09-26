// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function DocumentUnloadHandler() {
	//reloads the page after delete
	var win=window.self;
	if (win) {
		win.treload('websys.csp')
	}
}

function CloseWindow(e) {
	window.close();
	var win=window.opener;
	if (win) {
		win.treload('websys.csp');
	}
}

//var objUpdate=document.getElementById('update1');
//objUpdate.onclick=CloseWindow;