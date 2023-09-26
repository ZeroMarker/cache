// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

// Log 42683 - AI - 15-03-2004 : Create file solely to disable the first "Time" link on the list.

function BodyLoadHandler() {
	var obj=document.getElementById('Timez1');
	if (obj) {
		obj.disabled = true;
		obj.onclick="";
	}
}

document.body.onload=BodyLoadHandler;
