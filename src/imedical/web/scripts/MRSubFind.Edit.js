// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function BodyPartSymSubsLookUpSelect(str) {
	var lu = str.split("^");
	var el = document.getElementById("MRSUBBodyPartSymSubs");
	if (el) el.value = lu[0];
	var el = document.getElementById("MRSUBBodyPartsSympDR");
	if (el) el.value = lu[1];
	var el = document.getElementById("MRSUBBodyPartsDR");
	if (el) el.value = lu[2];
}
function BodyPartSympLookUpSelect(str) {
	BodyPartSympChangeHandler()
}
function BodyPartLookUpSelect(str) {
	BodyPartChangeHandler()
}
function BodyPartSympChangeHandler() {
	var el = document.getElementById("MRSUBBodyPartSymSubs");
	if (el) el.value = "";
}
function BodyPartChangeHandler() {
	var el = document.getElementById("MRSUBBodyPartsSympDR");
	if (el) el.value = "";
	var el = document.getElementById("MRSUBBodyPartSymSubs");
	if (el) el.value = "";
}
function ValidateUpdate() {
	var el = document.getElementById("MRSUBBodyPartsDR");
	if ((el)&&(el.value == "")) {
		var elSymp = document.getElementById("MRSUBBodyPartsSympDR");
		var elSympSub = document.getElementById("MRSUBBodyPartSymSubs");
		var elComm = document.getElementById("MRSUBDesc");
		var elDate = document.getElementById("MRSUBDateStarted");
		var elDays = document.getElementById("MRSUBDurationDays");
		var elMonth = document.getElementById("MRSUBDurationMonth");
		var elYear = document.getElementById("MRSUBDurationYear");
		if ( ((elSymp)&&(elSymp.value != "")) ||
		 ((elSympSub)&&(elSympSub.value != "")) ||
		 ((elComm)&&(elComm.value != "")) ||
		 ((elDate)&&(elDate.value != "")) ||
		 ((elDays)&&(elDays.value != "")) ||
		 ((elMonth)&&(elMonth.value != "")) ||
		 ((elYear)&&(elYear.value != "")) ) {
			alert("\'" + t['MRSUBBodyPartsDR'] + "\' " + t['XMISSING'] + "\n");
			return false;
		}
	}
	return true;
}
function UpdateClickHandler() {
	if (ValidateUpdate()) {
		//document.getElementById("fMRSubFind_Edit").target=setTargetWindow(document.getElementById('ChartID').value);
		return Update_click();
	}
	return false;
}
function RepeatClickHandler(evt) {
	if (ValidateUpdate()) {
		var frm=document.forms['fMRSubFind_Edit'];
		return epr_RepeatClickHandler(evt,frm);
	}
	return false;
}

function BodyPartLoadHandler() {
	var el=document.getElementById('MRSUBBodyPartsSympDR');
	if (el) el.onchange=BodyPartSympChangeHandler;
	var el=document.getElementById('MRSUBBodyPartsDR');
	if (el) el.onchange=BodyPartChangeHandler;

	var el=document.getElementById('Update');
	if (el) el.onclick = UpdateClickHandler;
	if (tsc['Update']) websys_sckeys[tsc['Update']]=UpdateClickHandler;
	var el=document.getElementById('Repeat');
	if (el) el.onclick = RepeatClickHandler;
	if (tsc['Repeat']) websys_sckeys[tsc['Repeat']]=RepeatClickHandler;
	// Log 34901 - AI - 06-06-2003 : disable the Repeat button if Editing a specific row from the List. (see Log 32090)
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

function MRSUBDesc_keydownhandler(encmeth) {
	var obj=document.getElementById("MRSUBDesc");
	//lookupqryNURN,jsfuncNURN defined in epr.js
	LocateCode(obj,encmeth,0,lookupqryNURN,jsfuncNURN);
}
function MRSUBDesc_lookupsel(value) {
}

document.body.onload = BodyPartLoadHandler;
