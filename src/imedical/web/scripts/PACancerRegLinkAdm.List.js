// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 


function Init() {
	var objID=document.getElementById("CancerReg");
	var objNew=document.getElementById("new1");
	
	if ((objID)&&(objID.value=="")) {
		// Disable NEW button
		if (objNew) {
			//objNew.style.visibility = "hidden";
			objNew.onclick=LinkDisable;

		}
	}
	
}

function LinkDisable(evt) {
	alert(t['NO_CANCER_REGISTRATION_MADE']);
	return false;
}

document.body.onload=Init;