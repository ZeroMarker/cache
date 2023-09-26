// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
// pjc 16.10.06 60087


function BodyLoadHandler() {
	var obj=document.getElementById("User");
	if (obj) obj.onblur=UserBlurHandler;

	var obj=document.getElementById("Location");
	if (obj) obj.onblur=LocationBlurHandler;

	var obj=document.getElementById("Group");
	if (obj) obj.onblur=GroupBlurHandler;
}

function UserBlurHandler() {
	var obj=document.getElementById("User");
	var objid=document.getElementById("UserID");
	if ((obj)&&(objid)&&(obj.value=="")) objid.value="";
}

function GroupBlurHandler() {
	var obj=document.getElementById("Group");
	var objid=document.getElementById("GroupID");
	if ((obj)&&(objid)&&(obj.value=="")) objid.value="";
}

function LocationBlurHandler() {
	var obj=document.getElementById("Location");
	var objid=document.getElementById("LocID");
	if ((obj)&&(objid)&&(obj.value=="")) objid.value="";
}

function UserLookup(str) {
	var lu=str.split("^");
	var objid=document.getElementById("UserID");
	if (objid) objid.value=lu[1];
}

function LocationLookup(str) {
	var lu=str.split("^");
	var objid=document.getElementById("LocID");
	if (objid) objid.value=lu[1];
}

function GroupLookup(str) {
	var lu=str.split("^");
	var objid=document.getElementById("GroupID");
	if (objid) objid.value=lu[1];
}

document.body.onload = BodyLoadHandler;
