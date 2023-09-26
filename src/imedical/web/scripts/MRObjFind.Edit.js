// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function ValidateUpdate() {
	return true
}

function RepeatClickHandler(evt) {
	if (ValidateUpdate()) {
		var frm=document.forms['fMRObjFind_Edit'];
		return epr_RepeatClickHandler(evt,frm);
	}
	return false;
}

function BodyLoadHandler() {
	var el = document.getElementById('Repeat');
	if (el) el.onclick = RepeatClickHandler;
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

function MROBJDesc_keydownhandler(encmeth) {
	var obj=document.getElementById("MROBJDesc");
	//LocateCode(obj,encmeth);
	//lookupqryNURN,jsfuncNURN defined in epr.js
	LocateCode(obj,encmeth,0,lookupqryNURN,jsfuncNURN);
}

function MROBJDesc_lookupsel(str) {
}

function MROBJNotesOnBlur() {
	var obj=document.getElementById("MROBJDesc");
	var objDesc=document.getElementById("MROBJNotes");
	if (obj && objDesc) {
		objDesc.value = obj.value;
	}
}
function MROBJRTFNotesOnBlur() {
	var objRTF=document.getElementById("MROBJRTFNotes");
	var objDesc=document.getElementById("MROBJNotes");
	if (objRTF && objDesc) {
		objDesc.value = objRTF.Text;
	}
	//alert('rtf' + objDesc.value);
}

document.body.onload = BodyLoadHandler;
var objBlur=document.getElementById("MROBJDesc");
if (objBlur) objBlur.onblur=MROBJNotesOnBlur;

var objRTFBlur=document.getElementById("MROBJRTFNotes");
if (objRTFBlur) objRTFBlur.onblur=MROBJRTFNotesOnBlur;
