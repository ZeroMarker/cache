// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function BodyUnloadHandler(e) {
	if (self == top) {
		var win=window.window.opener;
		if (win) win.location.reload();
		
	}
}

//document.body.onunload=BodyUnloadHandler;