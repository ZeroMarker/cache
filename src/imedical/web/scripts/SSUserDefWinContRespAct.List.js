// Copyright (c) 2006 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
// ab 4.05.06 52166

function BodyLoadHandler(e) {
	
	var obj=document.getElementById("Control");
	if (obj) obj.onblur=ControlBlurHandler;
	
}

function ControlLookup(str) {
	var lu=str.split("^");
	var obj=document.getElementById("Control");
	var objid=document.getElementById("ControlID");
	if (objid) objid.value=lu[1];
}

function ControlBlurHandler() {
	var obj=document.getElementById("Control");
	var objid=document.getElementById("ControlID");
	if ((obj)&&(obj.value=="")&&(objid)) {
		objid.value="";
	}
}

document.body.onload = BodyLoadHandler;
