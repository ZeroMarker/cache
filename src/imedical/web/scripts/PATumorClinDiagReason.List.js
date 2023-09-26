// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
function Init() {
	var objNew=document.getElementById('new1');
	var objTumorID=document.getElementById("Tumor");
	if ((objTumorID)&&(objTumorID.value=="")) {
		// Disable NEW button
		if (objNew) {
			//objNew.style.visibility = "hidden";
			objNew.onclick=LinkDisable;
		}
	}
}

function LinkDisable(evt) {
	return false;
}

document.body.onload=Init;