// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function UpdateClickHandler() {
	Update_click();
	RefreshPage();
}

function RefreshPage() {
	var PatObj=document.getElementById("PatientID");
	if (PatObj) PatID=PatObj.value;
	var PatObj=document.getElementById("TWKFL");
	if (PatObj) wkfl=PatObj.value;

	var url="arpatientbill.listreg.csp?PatientID="+PatID+"&TWKFL="+wkfl+"&CONTEXT=W"+wkfl;
	window.opener.top.frames["TRAK_main"].location.href=url;
}

function BodyLoadHandler() {
	obj=document.getElementById("Update")
	//if (obj) obj.onclick=UpdateClickHandler;
}

//document.body.onload=BodyLoadHandler;
