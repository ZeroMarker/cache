// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function ValidateUpdate() {
}
function BodyLoadHandler() {
	//var el=document.getElementById('CRITDesc');
	//if (el) el.onblur=CRITDescBlurHandler;
	//var el=document.getElementById('REPDesc');
	//if (el) el.onblur=REPDescBlurHandler;
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

function RepeatClickHandler(evt) {
	var frm=document.forms['fMRRiskEvaluation_Edit'];
	return epr_RepeatClickHandler(evt,frm);
}

function RISKDesc_keydownhandler(encmeth) {
	var obj=document.getElementById("RISKDesc");
	LocateCode(obj,encmeth,0,lookupqryNURN,jsfuncNURN);
}
function RISKDesc_lookupsel(value) {
}

function MRCRiskParamCritEvalLookUpSelect(str) {
	var lu = str.split("^");
	var el = document.getElementById("EVALDesc");
	if (el) el.value = lu[0];
	var el = document.getElementById("CRITDesc");
	if (el) el.value = lu[2];
	var el = document.getElementById("REPDesc");
	if (el) el.value = lu[3];
}
function MRCRiskEvalParamCriteriaLookUpSelect(str) {
	CRITDescBlurHandler()
	var lu = str.split("^");
	var el = document.getElementById("CRITDesc");
	if (el) el.value = lu[0];
	var el = document.getElementById("REPDesc");
	if (el) el.value = lu[2];
}
function MRCRiskEvalParamLookUpSelect(str) {
	REPDescBlurHandler()
}
function CRITDescBlurHandler() {
	var el = document.getElementById("EVALDesc");
	if (el) el.value = "";
}
function REPDescBlurHandler() {
	var el = document.getElementById("EVALDesc");
	if (el) el.value = "";
	var el = document.getElementById("CRITDesc");
	if (el) el.value = "";
}
document.body.onload = BodyLoadHandler;