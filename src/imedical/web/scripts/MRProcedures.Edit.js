// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function MRProcedures_Edit_BodyLoadHandler() {
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

function RepeatClickHandler(evt) {
	var frm=document.forms['fMRProcedures_Edit'];
	return epr_RepeatClickHandler(evt,frm);
}

//md 05/11/2003 log 40433
function ProcedureSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById("PROCOperationDR")
	if (obj) obj.value = lu[0];
	var obj=document.getElementById("PROCOperationid")
	if (obj) obj.value = lu[1];
	
}

document.body.onload = MRProcedures_Edit_BodyLoadHandler;