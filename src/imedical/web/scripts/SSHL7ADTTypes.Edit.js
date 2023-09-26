// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function BodyLoadHandler() {
	obj=document.getElementById('update1');
	if (obj) obj.onclick=UpdateClickHandler;
}

function UpdateClickHandler() {
	SetSelectedHospital()
	return update1_click();
}

function SetSelectedHospital() {
	var messages="";
	var lst = document.getElementById("HL7ADTType");
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			if (lst.options[j].selected) {
				messages = messages + lst.options[j].value + "|"
			}
		}
		var objSelADT = document.getElementById("selectedADT");
		if (objSelADT) objSelADT.value=messages;
	}
}

document.body.onload=BodyLoadHandler;
