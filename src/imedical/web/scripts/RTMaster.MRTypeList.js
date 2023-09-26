// Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 



function BodyLoadHandler() {
	
	// cjb 31/07/2003 33208
	var DisableNew=document.getElementById('DisableNew');
	if (DisableNew.value=="1") {
		obj=document.getElementById('New')
		if (obj) {
			obj.disabled=true;
			
			// cjb 13/10/2004 46309 - don't need an onclick, just set the href to # (so you can't right click, open
			//obj.onclick=checklinkHandler;
			obj.href="#";
		}
	}
}


function checklinkHandler(evt) {
	// cjb 14/09/2004 46309
	return false;
	
	var eSrc=websys_getSrcElement(evt);
	if (eSrc.tagName=="IMG") var eSrc=websys_getParentElement(eSrc);
	eSrc.href="#";
	if (eSrc.disabled==true) return false;
}




if (window.opener) {
	try {
		window.opener.setBoldLinks("MRNumber",document.getElementById("PatientHasMRN").value);
	}
	catch(e) {}
}


document.body.onload=BodyLoadHandler;