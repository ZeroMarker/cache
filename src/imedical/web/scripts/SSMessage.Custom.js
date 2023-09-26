// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var win=0;
function bodyLoadHandler() {
	var DateRead=document.getElementById("DateRead").value
	var ID=document.getElementById("ID").value
	var TEVENT=document.getElementById("TEVENT").value
	if (DateRead=="") win=websys_createWindow('ssmessageread.csp?TEVENT='+TEVENT+'&ID='+ID, 'TRAK_hidden','')
}
function unLoadHandler() {
	if (win) window.opener.treload('websys.csp');
}
window.document.body.onload=bodyLoadHandler;
window.onunload=unLoadHandler;