// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var frm = document.forms["fCTCarPrvAnaPref_Edit"];
if (self != window.parent) frm.elements['TFRAME'].value=window.parent.name;
//alert(window.parent.name);


function DocumentLoadHandler() {
	var obj=document.getElementById("Update");
	if (obj) obj.onclick=UpdateClickHandler;
	var stat=document.getElementById("Stat").value;
	if (stat=="Edit") {
		var obj=document.getElementById("CTCareProv");
		if (obj) {obj.disabled=true; obj.className="disabledField";}
		var objlu=document.getElementById("ld2108iCTCareProv");
		if (objlu) {objlu.disabled=true;}
	}
	if (document.getElementById("ReadOnly").value==1) ReadOnly();
}

function ReadOnly() {
	DisableField("ANMETDesc"); DisableField("ld2112iANMETDesc");
	DisableField("Update");
	DisableField("UpdateClose");
}

function DisableField(fldName) {
	var fld = document.getElementById(fldName);
	if (fld) {
		fld.disabled = true;
		fld.className = "clsDisabled";
		if (fld.onclick!="") fld.onclick=LinkDisabled;
	}
}

function LinkDisabled() {
	return false;
}

function UpdateClickHandler() {
	return Update_click();
}

function CarPrvLookUpSelect(txt) {
	var adata=txt.split("^");
	var obj=document.getElementById("CTPCPDesc")
	if (obj) obj.value=adata[0];
	var obj=document.getElementById("ORPParRef")
	if (obj) obj.value=adata[1];
}

document.body.onload=DocumentLoadHandler;