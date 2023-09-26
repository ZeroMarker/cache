// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
// Log 53870 - AI - 27-09-2005 : js file for new component. Same as MRDiagnos.Edit except for some same-frame csp handling.

function UpdateClickHandler() {
	var frm = document.forms["fMRDiagnos_EditOp"];

	if (parent.frames["mrdiagnos_editop"]) {
		frm.elements['TFRAME'].value=window.parent.name;
	}
	if (!parent.frames["mrdiagnos_editop"]) {
		var objMulti=document.getElementById("MultiContactFrame");
		if (objMulti) objMulti.value=1;
	}
	
	var obj=frm.elements['TWKFLI'];
	if (!(fMRDiagnos_EditOp_submit())) return false;
	if (obj.value!="") obj.value-=1;
	
	return Update_click();
}

// Log 46427 - AI - 27-10-2004 : Delete button, but only available when CanUserDelete is 1, otherwise disable.
function DeleteClickHandler() {
	var elem = document.getElementById('delete1');
	if ((elem)&&(elem.disabled)) return false;

	var frm=document.forms['fMRDiagnos_EditOp'];

	if (parent.frames["mrdiagnos_editop"]) {
		frm.elements['TFRAME'].value=window.parent.name;
	}
	if (!parent.frames["mrdiagnos_editop"]) {
		var objMulti=document.getElementById("MultiContactFrame");
		if (objMulti) objMulti.value=1;
	}
	
	var obj=frm.elements['TWKFLI'];
	if (!(fMRDiagnos_EditOp_submit())) return false;
	if (obj.value!="") obj.value-=1;

	return delete1_click();
}
// end Log 46427

function BodyLoadHandler() {
	var update = document.getElementById('Update');
	if (update) update.onclick = UpdateClickHandler;
	if (tsc['Update']) websys_sckeys[tsc['Update']]=UpdateClickHandler;

	var obj = document.getElementById('delete1');
	if (obj) obj.onclick = DeleteClickHandler;
	if (tsc['delete1']) websys_sckeys[tsc['delete1']]=DeleteClickHandler;

	//do not call this, sites can use the layout editor's set form size and position
	//if (self==top) websys_reSizeT();
	
	// Log 46427 - AI - 27-10-2004 : Delete button, but only available when CanUserDelete is 1, otherwise disable.
	var objDelete = document.getElementById('delete1');
	if (objDelete) {
		var objCanUserDelete = document.getElementById('CanUserDelete');
		if ((objCanUserDelete)&&(objCanUserDelete.value==1)) {
			objDelete.disabled=false;
			objDelete.onclick=DeleteClickHandler;
		}
		else {
			objDelete.disabled=true;
			objDelete.onclick=LinkDisable;
		}
	}
	// end Log 46427

        var obj=document.getElementById("MRDIAICDCodeDRAltDescAlias");
	if (obj) obj.onblur=AltDescBlurHandler;
	var obj=document.getElementById("MRDIAICDCodeDR");
	if (obj) obj.onblur=DiagnosisBlurHandler;
	var obj=document.getElementById("MRDIAICDCodeDRDescOnly");
	if (obj) obj.onblur=DiagnosisDescBlurHandler;
}

function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if (el.disabled==true) {
		return false;
	}
	return true;
}

function MRDIADesc_keydownhandler(encmeth) {
	var obj=document.getElementById("MRDIADesc");
	//lookupqryNURN,jsfuncNURN defined in epr.js
	LocateCode(obj,encmeth,0,lookupqryNURN,jsfuncNURN);
}
function MRDIADesc_lookupsel(value) {
}

function LookUpDiagnos(str) {
	var ary=str.split("^");
	var ary2=ary[0].split(" | ");
	var obj=document.getElementById("MRDIAICDCodeDR");
	if (obj) obj.value=ary2[0];
	// Log 27059 - AI - 19-08-2002 : Get the RowID to pass to the Lookup.
	var obj2=document.getElementById("MRDIAICDCodeID");
	if (obj2) obj2.value=ary[1];
	var obj3=document.getElementById("MRCIDCode");
	if (obj3) obj3.value=ary[2];
	var obj4=document.getElementById("MRCIDCodeDisplay");
	if (obj4) obj4.innerText=ary[2];    
	PrimaryDiagnChangeHandler();
}

// Log 27059 - AI - 15-08-2002 : Create the following two functions, to cater for the two new versions of Diagnosis.
// 			They are called by the relevant Items in the Component (The Item name is the Element name).
function LookUpDiagnosDescOnly(str) {
	var ary=str.split("^");
	var ary2=ary[0].split(" | ");
	var obj=document.getElementById("MRDIAICDCodeDRDescOnly");
	if (obj) obj.value=ary2[0];
	var obj2=document.getElementById("MRDIAICDCodeID");
	if (obj2) obj2.value=ary[1];
	var obj3=document.getElementById("MRCIDCode");
	if ((obj3)&&(obj3.value=="")) {obj3.value=ary[2];}
	var obj4=document.getElementById("MRCIDCodeDisplay");
	if (obj4) obj4.innerText=ary[2];    
	PrimaryDiagnChangeHandler();
}

function LookUpDiagnosAltDescAlias(str) {
	var ary=str.split("^");
	var ary2=ary[0].split(" | ");
	var obj=document.getElementById("MRDIAICDCodeDRAltDescAlias");
	if (obj) obj.value=ary2[0];
	var obj2=document.getElementById("MRDIAICDCodeID");
	if (obj2) obj2.value=ary[1];
	var obj3=document.getElementById("MRCIDCode");
	if ((obj3)&&(obj3.value=="")) {obj3.value=ary[2];}
	var obj4=document.getElementById("MRCIDCodeDisplay");
	if (obj4) obj4.innerText=ary[2];
	PrimaryDiagnChangeHandler();
}
// end Log 27059

// ab 20.04.05 - 51254 - also changed MRDIAICDCodeID valueget in component
function AltDescBlurHandler(e) {
	// if clearing value, clear the id
	// if just updating where alt desc is blank, dont clear id
	var objprev=document.getElementById("AltDescPrevValue");
	if ((objprev)&&(objprev.value!="")) {
		var obj=document.getElementById("MRDIAICDCodeDRAltDescAlias");
		var obj2=document.getElementById("MRDIAICDCodeID");
		var obj3=document.getElementById("MRCIDCodeDisplay");
		if ((obj)&&(obj2)&&(obj.value=="")) {
			obj2.value="";
			if (obj3) obj3.innerText="";
		}
	}
}

function DiagnosisBlurHandler() {
	var obj=document.getElementById("MRDIAICDCodeDR");
	var obj2=document.getElementById("MRCIDCodeDisplay");
	if ((obj)&&(obj2)&&(obj.value=="")) {
		obj2.innerText="";
	}
}

function DiagnosisDescBlurHandler() {
	var obj=document.getElementById("MRDIAICDCodeDRDescOnly");
	var obj2=document.getElementById("MRCIDCodeDisplay");
	if ((obj)&&(obj2)&&(obj.value=="")) {
		obj2.innerText="";
	}
}

function PrimaryDiagnChangeHandler() {
	//dummy fn for custom script
}

// Log 38654 - AI - 15-04-2004 : Function to use the Description (1) for the field value, not the Code (0).
function HRGLookUp(str) {
	var lu = str.split("^");
	var obj = document.getElementById('HRGDesc')
	if (obj) obj.value=lu[1];
}

document.body.onload = BodyLoadHandler;
