//Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function BodyLoadHandler() {
	var obj=document.getElementById("Group");
	if (obj) obj.onblur=GroupBlurHandler;
}

function GroupBlurHandler() {
	var obj=document.getElementById("Group");
	var objid=document.getElementById("groups");
	if ((obj)&&(obj.value=="")&&(objid)) objid.value="";
}

function GroupLookup(str) {
	var lu = str.split("^");
	var objid=document.getElementById("groups");
	if (objid) objid.value=lu[1];
}

document.body.onload=BodyLoadHandler;
