// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.


function DocumentLoadHandler() {
	var obj = document.getElementById("MonoGraph");  
	if (obj) {
		obj.onclick = DisabledField;
		obj.onkeydown = DisabledField;
	}
}

function DisabledField () {
	websys_cancel;
	return false;
}

document.body.onload = DocumentLoadHandler;