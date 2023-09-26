// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
//log 56840

function BodyUnLoadHandler() {
	var parwin=window.opener;
	if(parwin) parwin.treload("websys.reload.csp");
}
document.body.onunload=BodyUnLoadHandler;