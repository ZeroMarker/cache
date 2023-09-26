// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
// Created 23/06/2005 JPD


function BodyLoadHandler() {
	var flag=document.getElementById("Flagged");
	if (flag.value!="Y"){
		var datelog=document.getElementById("cdate");
		var sessionID=document.getElementById("sessionID");
		var path="oeorder.dietdaysummary.csp?date="+datelog.value+"&sessionID="+sessionID.value;
		window.location=path;
	}
}



document.body.onload = BodyLoadHandler;

	
