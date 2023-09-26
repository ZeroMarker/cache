// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function DocumentLoadHandler(){
	var obj=document.getElementById("QUALDate");
	if (obj) obj.onblur=DateBlurHandler;
}

function DateBlurHandler() {
	var dateh=document.getElementById("QUALDateH");
	var obj=document.getElementById("QUALDate");
	if ((dateh)&&(obj)) {
		dateh.value=DateStringTo$H(obj.value);
	}
}

document.body.onload = DocumentLoadHandler;
