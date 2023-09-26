// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var objParentWindow=window.opener;
//var objParentWindow=window.opener.opener; do this if they want View request screen to refresh.

function RefreshHandler() {
	location.reload();
	window.event.cancelBubble;
	return false;
}
//------------------------------------
function BodyUnloadHandler() {

	//alert("BodyUnloadHandler called");

	if (objParentWindow) {
		objParentWindow.location.reload();	
	}
	//alert("BodyUnloadHandler finished");
}

//document.body.onunload=BodyUnloadHandler;
//------------------------------------