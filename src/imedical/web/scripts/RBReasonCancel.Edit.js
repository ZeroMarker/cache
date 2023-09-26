// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function DocumentLoadHandler(e) {

	var obj;
	//alert("here")
	
	
}


function BodyUnloadHandler(e) {
	if (self == top) {
		var win=window.opener;
		if (win) {
			win.location.reload();
		}
	}
}

document.body.onunload=BodyUnloadHandler;

window.onload = DocumentLoadHandler;








