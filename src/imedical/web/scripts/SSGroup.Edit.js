// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
// ab 18.01.07 62252


function DocumentLoadHandler(e) {
	var obj=document.getElementById("QuestGroup");
	var objID=document.getElementById("ID");

	if ((objID)&&(objID.value=="")&&(obj)) {
		obj.onclick=LinkDisable;
		obj.disabled=true;
	}
	
	var objbold=document.getElementById("BoldLinks");
	if (objbold) {
		if (objbold.value!="") {
			var obj=document.getElementById("QuestGroup");
			if (obj) obj.style.fontWeight="bold";
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


document.body.onload=DocumentLoadHandler;