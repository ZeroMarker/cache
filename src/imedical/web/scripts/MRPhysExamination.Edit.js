// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function BodyAreaProbSubLookUpSelect(str) {
    var lu = str.split("^");
    var elPHYSBodyAreaDR = document.getElementById('PHYSBodyAreaDR');
    var elPHYSMRCBodyAreProbDR = document.getElementById('PHYSMRCBodyAreProbDR');
    var elPHYSMRCBodyAreaProbSubDR = document.getElementById('PHYSMRCBodyAreaProbSubDR');

    if (elPHYSMRCBodyAreaProbSubDR) elPHYSMRCBodyAreaProbSubDR.value=lu[0];
    if (elPHYSMRCBodyAreProbDR) elPHYSMRCBodyAreProbDR.value=lu[1];
    if (elPHYSBodyAreaDR) elPHYSBodyAreaDR.value=lu[2];
}

function BodyAreaProbLookUpSelect(str) {
    var lu = str.split("^");
    var elPHYSBodyAreaDR = document.getElementById('PHYSBodyAreaDR');
    var elPHYSMRCBodyAreProbDR = document.getElementById('PHYSMRCBodyAreProbDR');

    if (elPHYSMRCBodyAreProbDR) elPHYSMRCBodyAreProbDR.value=lu[0];
    if (elPHYSBodyAreaDR) elPHYSBodyAreaDR.value=lu[1];

	BodyAreaProbChangeHandler();
}

function BodyAreaProbChangeHandler() {
    var elPHYSMRCBodyAreaProbSubDR = document.getElementById('PHYSMRCBodyAreaProbSubDR');
    if (elPHYSMRCBodyAreaProbSubDR) elPHYSMRCBodyAreaProbSubDR.value = "";
}

function BodyAreaLookUpSelect(str) {
	var lu = str.split("^");
	BodyAreaChangeHandler();
}
function BodyAreaChangeHandler() {
    var elPHYSMRCBodyAreProbDR = document.getElementById('PHYSMRCBodyAreProbDR');
    var elPHYSMRCBodyAreaProbSubDR = document.getElementById('PHYSMRCBodyAreaProbSubDR');
    if (elPHYSMRCBodyAreProbDR) elPHYSMRCBodyAreProbDR.value = "";
    if (elPHYSMRCBodyAreaProbSubDR) elPHYSMRCBodyAreaProbSubDR.value = "";
}
function ValidateUpdate() {
	var elPHYSBodyAreaDR = document.getElementById('PHYSBodyAreaDR');
	var elPHYSMRCBodyAreProbDR = document.getElementById('PHYSMRCBodyAreProbDR');
	var elPHYSMRCBodyAreaProbSubDR = document.getElementById('PHYSMRCBodyAreaProbSubDR');
	var elPHYSDesc = document.getElementById('PHYSDesc');
	var msg = "";
		
	if ( ((elPHYSBodyAreaDR)&&(elPHYSBodyAreaDR.value==""))
	   && ( ((elPHYSMRCBodyAreProbDR)&&(elPHYSMRCBodyAreProbDR.value!=""))
	      || ((elPHYSMRCBodyAreaProbSubDR)&&(elPHYSMRCBodyAreaProbSubDR.value!=""))
	      || ((elPHYSDesc)&&(elPHYSDesc.value!="")) ) ) {
		msg+="\'" + t['PHYSBodyAreaDR'] + "\' " + t['XMISSING'] + "\n";
	}
	if (msg != "") {
		alert(msg);
		return false;
	}
	return true;
}

function UpdateClickHandler() {
	if (ValidateUpdate()) {
		return Update_click();
	}
	return false;
}
function RepeatClickHandler(evt) {
	if (ValidateUpdate()) {	
		var frm=document.forms['fMRPhysExamination_Edit'];
		return epr_RepeatClickHandler(evt,frm);
	}
	return false;
}

function BodyLoadHandler() {
	var el;
	//el = document.getElementById('PHYSMRCBodyAreProbDR');
	//if (el) el.onchange=BodyAreaProbChangeHandler;
	//el = document.getElementById('PHYSBodyAreaDR');
	//if (el) el.onchange=BodyAreaChangeHandler;

	el = document.getElementById('Update');
	if (el) el.onclick = UpdateClickHandler;
	if (tsc['Update']) websys_sckeys[tsc['Update']]=UpdateClickHandler;
	var el = document.getElementById('Repeat');
	if (el) el.onclick = RepeatClickHandler;
	if (tsc['Repeat']) websys_sckeys[tsc['Repeat']]=RepeatClickHandler;
	// Log 32090 - AI - 16-04-2003 : disable the Repeat button if Editing a specific row from the List. (see Log 27280)
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
// end Log 32090

function PHYSDesc_keydownhandler(encmeth) {
	var obj=document.getElementById("PHYSDesc");
	//lookupqryNURN,jsfuncNURN defined in epr.js
	LocateCode(obj,encmeth,0,lookupqryNURN,jsfuncNURN);
}
function PHYSDesc_lookupsel(value) {
}

document.body.onload = BodyLoadHandler;
