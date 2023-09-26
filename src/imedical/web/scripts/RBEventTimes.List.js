// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function DocumentLoadHandler() {
	//var obj = document.getElementById("CreateAppt")
	//if (obj) obj.onclick=CreateClickHandler;
}

function CreateClickHandler() {
	var objdate = document.getElementById("TIME_Datez1")
	var obj = document.getElementById("CreateAppt")
	if (obj && !objdate) alert("No Event Times exist.");
}

document.body.onload = DocumentLoadHandler;