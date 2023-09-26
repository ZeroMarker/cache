// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

// *** cjb 30/08/2004 46002 - removed old redundant code.  Check wombat for the old version ***

var objdec=document.getElementById("deceased");
var objautop=document.getElementById("PACRAutopsyHeld");
var objcause=document.getElementById("PACRCauseOfDeath");
var lookupautop = document.getElementById("ld1555iPACRAutopsyHeld");
var lblautop = document.getElementById("cPACRAutopsyHeld");
var lblcause = document.getElementById("cPACRCauseOfDeath");

function Init() {
	
	websys_firstfocus();
	
	EnableOrDisabeFields();
	
	var obj=document.getElementById("update1");
	if (obj) obj.onclick=UpdateHandler;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateHandler;
	
	var objDelete=document.getElementById("delete1");
	if (objDelete) objDelete.onclick=DeleteHandler;
	if (tsc['delete1']) websys_sckeys[tsc['delete1']]=DeleteHandler;
	
}

// cjb 01/09/2004 45933 - rewritten and moved out of Init.  If the patient is dead, AutopsyHeld & CauseOfDeath are Mandatory.  Otherwise disabled.  (uses standard .js functions in websys.Edit.Tools.js)
function EnableOrDisabeFields() {
	if (objdec && objdec.value=="Y") {
		if (objautop) EnableField("PACRAutopsyHeld");
		if (lookupautop) EnableLookup("ld1555iPACRAutopsyHeld");
		if (objcause) EnableField("PACRCauseOfDeath");
		if (objautop) labelMandatory("PACRAutopsyHeld");
		if (objcause) labelMandatory("PACRCauseOfDeath");
	} else {
		if (objautop) DisableField("PACRAutopsyHeld");
		if (lookupautop) DisableLookup("ld1555iPACRAutopsyHeld");
		if (objcause) DisableField("PACRCauseOfDeath");
		if (objautop) labelNormal("PACRAutopsyHeld");
		if (objcause) labelNormal("PACRCauseOfDeath");
	}
}

function UpdateHandler() {
	
	// cjb 01/09/2004 45933 - this check on mandatory fields should take place regardless of whether the patient is dead.  (If they're alive the fields won't be required)
	// cjb 30/08/2004 46002 - now uses t['XMISSING'], etc
	//START - AJI 28.10.03 - L35869
	//if (objdec && objdec.value=="Y") {
		if ((objautop && objautop.value=="" && lblautop.className=="clsRequired") || (objcause && objcause.value=="" && lblcause.className=="clsRequired")) {
			var msg=t['DEATH_WARNING'] + "\n";
			if (objautop && objautop.value=="") msg = msg + t['PACRAutopsyHeld'] + " " + t['XMISSING']+ "\n";
			if (objcause && objcause.value=="") msg = msg + t['PACRCauseOfDeath'] + " " + t['XMISSING']+ "\n";
			alert(msg);
			if (objautop && objautop.value=="") {
				websys_setfocus(objautop.id);
				return false;
			}
			if (objcause && objcause .value=="") websys_setfocus(objcause.id);
			return false;
		}
	//}
	//END - AJI 28.10.03 - L35869	
	
	// cjb 06/05/2004 43234
	var frm = document.forms["fPACancerReg_Edit"];
	if (parent.frames["FRAMEPACancerRegEdit"]) {
		frm.elements['TFRAME'].value=window.parent.name;
	}
	if (!(fPACancerReg_Edit_submit())) return false
		
	return update1_click();
}

function DeleteHandler() {
	var frm = document.forms["fPACancerReg_Edit"];
	frm.target = "_parent";  //"FRAMEPACancerRegEdit";    the target must be parent because PACancerReg.Edit page is part of a workflow
	
	return delete1_click();
}

document.body.onload=Init;