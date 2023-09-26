// Copyright (c) 2005 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function BodyLoadHandler() {
	var obj=document.getElementById("ReportType");
	if (obj) obj.onblur=ReportTypeBlurHandler;
}

function ReportTypeLookupHandler(str) {
	var lu=str.split("^");
	var obj=document.getElementById("TypeHidden");
	if (obj) obj.value=lu[2];
}

function ReportTypeBlurHandler() {
	var obj=document.getElementById("ReportType");
	var obj1=document.getElementById("TypeHidden");
	if ((obj1)&&(obj)&&(obj.value=="")) obj1.value="";
}

document.body.onload=BodyLoadHandler;