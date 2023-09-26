//Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
	
function BodyLoadHandler() {
	var objNew=document.getElementById("new1");
	var objwlstatus=document.getElementById("wlStatus");
	if ((objwlstatus)&&(objwlstatus.value=="R")) {
		if (objNew) {
			objNew.disabled=true;
			objNew.onclick=LinkDisable;
		}
	}
}

function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if (el.disabled) {
		return false;
	}
	return true;
}

document.body.onload=BodyLoadHandler;
