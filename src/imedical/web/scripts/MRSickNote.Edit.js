// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
// ab 13.09.06 60406

function BodyLoadHandler() {

	// if authorised, all fields read only
	var obj=document.getElementById("StatusCode");
	if ((obj)&&(obj.value=="A")) {
		DisableAllFields("",",update1,NOTStatus,");
	}

} 

document.body.onload=BodyLoadHandler;
