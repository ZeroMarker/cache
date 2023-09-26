//Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
alert("test1");
function BodyLoadHandler() {
	alert("test2");
	}
document.body.onload=BodyLoadHandler;
