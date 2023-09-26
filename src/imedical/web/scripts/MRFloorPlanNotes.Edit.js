// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function ValidateUpdate() {
}

function BodyLoadHandler() {
	var obj=document.getElementById('Repeat');
	if (obj) obj.onclick = RepeatClickHandler;
	if (tsc['Repeat']) websys_sckeys[tsc['Repeat']]=RepeatClickHandler;
	// Log 34901 - AI - 10-06-2003 : disable the Repeat button if Editing a specific row from the List. (see Log 32090)
	var objID = document.getElementById('ID');
	if ((objID)&&(objID.value!="")) {
		DisableFields();
	}
	else {
		EnableFields();
	}
}

function DisableFields() {
	var objRepeat = document.getElementById('Repeat');
	if (objRepeat) {
		objRepeat.disabled=true;
		objRepeat.onclick=LinkDisable;
	}
}

function EnableFields()	{
	var objRepeat = document.getElementById('Repeat');
	if (objRepeat) {
		objRepeat.disabled=false;
		objRepeat.onclick=RepeatClickHandler;
	}
}

function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if (el.disabled==true) {
		return false;
	}
	return true;
}
// end Log 34901

function RepeatClickHandler(evt) {
	var frm=document.forms['fMRFloorPlanNotes_Edit'];
	return epr_RepeatClickHandler(evt,frm);
}

function FLOORText_keydownhandler(encmeth) {
	var obj=document.getElementById("FLOORText");
	//lookupqryNURN,jsfuncNURN defined in epr.js
	LocateCode(obj,encmeth,0,lookupqryNURN,jsfuncNURN);
}
function FLOORText_lookupsel(value) {
}

document.body.onload = BodyLoadHandler;
