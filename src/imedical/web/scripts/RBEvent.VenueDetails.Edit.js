// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var win=window.opener
var form=win.document.getElementById("fRBEvent_Edit")

function DocumentLoadHandler() {
	var obj=document.getElementById("update");
	if (obj) obj.onclick=UpdateClickHandler;

	var obj=document.getElementById("delete");
	if (obj) obj.onclick=DeleteClickHandler;
}

function UpdateClickHandler() {
	var EVVenue="";
	var EVVenueAddress1=""
	var EVVenueAddress2=""
	var EVVenueFax=""
	var EVVenuePhone=""
	var obj=document.getElementById("EVVenue")
	if (obj) EVVenue=obj.value;
	var obj=document.getElementById("EVVenueAddress1")
	if (obj) EVVenueAddress1=obj.value;
	var obj=document.getElementById("EVVenueAddress2")
	if (obj) EVVenueAddress2=obj.value;
	var obj=document.getElementById("EVVenueFax")
	if (obj) EVVenueFax=obj.value;
	var obj=document.getElementById("EVVenuePhone")
	if (obj) EVVenuePhone=obj.value;

	form.elements["EVVenue"].value=EVVenue
	form.elements["EVVenueAddress1"].value=EVVenueAddress1
	form.elements["EVVenueAddress2"].value=EVVenueAddress2
	form.elements["EVVenueFax"].value=EVVenueFax
	form.elements["EVVenuePhone"].value=EVVenuePhone
	return update_click();
}


function DeleteClickHandler() {
	form.elements["EVVenue"].value=""
	form.elements["EVVenueAddress1"].value=""
	form.elements["EVVenueAddress2"].value=""
	form.elements["EVVenueFax"].value=""
	form.elements["EVVenuePhone"].value=""
	return delete_click();
}

document.body.onload=DocumentLoadHandler;