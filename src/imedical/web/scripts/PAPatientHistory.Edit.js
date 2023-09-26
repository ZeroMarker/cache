// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function FamilyLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('PAHabitQuantity');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('PAHabit');
	if (obj) obj.value=lu[1];
}
function ValidateUpdate() {
	var objDis=document.getElementById('PAFamilyDisease');
	var objRel=document.getElementById('PAFamilyRelation');
	if ((objDis)&&(objDis.value != "")&&(objRel)&&(objRel.value == "")) {
		alert("Required field missing 'Family History Family'\n");
		//websys_returnEvent();
		return false;
	}
	// LOG 26677 - AI - 24/07/2002 : Add the three other checks for missing fields.
	if ((objDis)&&(objDis.value == "")&&(objRel)&&(objRel.value != "")) {
		alert("Required field missing: 'Family History Disease'\n");
		return false;
	}
	var objHab=document.getElementById('PAHabit');
	var objQuan=document.getElementById('PAHabitQuantity');
	if ((objHab)&&(objHab.value != "")&&(objQuan)&&(objQuan.value == "")) {
		alert("Required field missing: 'Social History Quantity'\n");
		return false;
	}
	if ((objHab)&&(objHab.value == "")&&(objQuan)&&(objQuan.value != "")) {
		alert("Required field missing: 'Social History Habit'\n");
		return false;
	}
	// end LOG 26677
	return true;
}
function UpdateClickHandler() {
	if (ValidateUpdate()) {
		return Update_click();
	}
	return false;
}

function LookUpHabit(str) {
	// 25/06/2002 LOG 25874 - AI : Add function to lookup Disease.
	var ary=str.split("^");
	var obj=document.getElementById("PAHabit");
	if (obj) obj.value=ary[0];
	HabitQuantityChangeHandler(1);
}

function HabitQuantityChangeHandler(lookup) {
	var obj=document.getElementById('PAHabitQuantity');
	var objHabit=document.getElementById("PAHabit");
	
	// ab 2.03.06 58274
	if ((!lookup)&&(objHabit)&&(objHabit.value!="")) return;
	
	if (obj) {
		obj.value = "";
		if (objHabit) {
			if (objHabit.value!="") {
				MandatoryField('PAHabitQuantity');
			} else {
				UnMandatoryField('PAHabitQuantity');
			}
		}
	}
}

function MandatoryField(fldName) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if (fld) {
		fld.disabled = false;
		fld.className = "";
		if (lbl) lbl = lbl.className = "clsRequired";
	}
}

function UnMandatoryField(fldName,icN) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if (fld) {
		if (lbl) lbl = lbl.className = "";
	}
}

function RepeatClickHandler() {
	var el=document.getElementById('Repeat');
	if ((el)&&(el.disabled)) {
		return false;
	}
	if (ValidateUpdate()) {
		return epr_RepeatClickHandler();
	}
	return false;
}
function BodyLoadHandler() {
	var obj=document.getElementById('Update');
	if (obj) obj.onclick = UpdateClickHandler;
	if (tsc['Update']) websys_sckeys[tsc['Update']]=UpdateClickHandler;
	var el = document.getElementById('Repeat');
	if (el) el.onclick = RepeatClickHandler;
	if (tsc['Repeat']) websys_sckeys[tsc['Repeat']]=epr_RepeatClickHandler;

	// LOG 26677 - AI - 22/07/2002 : Check if this is a New History or an Update History (HistoryID !="" for an Update).
	// 			If an Update, disable all Types except the one being updated.
	//			NOTE: The second element being disabled within each IF is the element's Search Image.
	// comment out these lines and incorporate within new code.
	// var obj=document.getElementById('PAHabit');
	// if (obj) obj.onchange=HabitQuantityChangeHandler;
	var histid=document.getElementById("HistoryID");
	if ((histid)&&(histid.value!="")) {
		var histtype=document.getElementById("PAHistoryType");
		if (histtype.value!="D") {
			var obj=document.getElementById("PADisease");
			if (obj) obj.disabled=true;
			var obj=document.getElementById("ld295iPADisease");
			if (obj) obj.disabled=true;
		}
		if (histtype.value!="O") {
			var obj=document.getElementById("PAOperation");
			if (obj) obj.disabled=true;
			var obj=document.getElementById("ld295iPAOperation");
			if (obj) obj.disabled=true;
		}
		// Log 28556 - AI - 11-04-2003 : Remove Allergy from this component - now it's own Profile.
		//if (histtype.value!="A") {
		//	if (obj) var obj=document.getElementById("PAAllergy");
		//	obj.disabled=true;
		//	if (obj) var obj=document.getElementById("ld295iPAAllergy");
		//	obj.disabled=true;
		//}
		// end Log 28556
		if (histtype.value!="C") {
			var obj=document.getElementById("PAPastHistoryCondition");
			if (obj) obj.disabled=true;
			var obj=document.getElementById("ld295iPAPastHistoryCondition");
			if (obj) obj.disabled=true;
		}
		// incorporate the commented out lines of code here.
		var obj=document.getElementById("PAHabit");
		if (histtype.value!="S") {
			if (obj) obj.disabled=true;
			var obj=document.getElementById("ld295iPAHabit");
			if (obj) obj.disabled=true;
		}
		else if (obj) obj.onblur=HabitQuantityChangeHandler;
		if (histtype.value!="S") {
			var obj=document.getElementById("PAHabitQuantity");
			if (obj) obj.disabled=true;
			var obj=document.getElementById("ld295iPAHabitQuantity");
			if (obj) obj.disabled=true;
		}
		if (histtype.value!="F") {
			var obj=document.getElementById("PAFamilyDisease");
			if (obj) obj.disabled=true;
			var obj=document.getElementById("ld295iPAFamilyDisease");
			if (obj) obj.disabled=true;
		}
		if (histtype.value!="F") {
			var obj=document.getElementById("PAFamilyRelation");
			if (obj) obj.disabled=true;
			var obj=document.getElementById("ld295iPAFamilyRelation");
			if (obj) obj.disabled=true;
		}
		if (histtype.value!="M") {
			var obj=document.getElementById("PAMedication");
			if (obj) obj.disabled=true;
			var obj=document.getElementById("ld295iPAMedication");
			if (obj) obj.disabled=true;
		}
		if (histtype.value!="MD") {
			var obj=document.getElementById("PAMedicaitonDescription");
			if (obj) obj.disabled=true;
		}
		// and disable the Repeat button for an Edit as well.
		var obj=document.getElementById("Repeat");
		if (obj) obj.disabled=true;
		// end LOG 26677
	} else {
		//clear previous data
		var obj=document.getElementById('PAOnsetDate');
		if (obj) obj.value="";
		var obj=document.getElementById('Duration');
		if (obj) obj.value="";
		var obj=document.getElementById('PADurationYears');
		if (obj) obj.value="";
		var obj=document.getElementById('PADurationMonths');
		if (obj) obj.value="";
		var obj=document.getElementById('PADurationDays');
		if (obj) obj.value="";
		var obj=document.getElementById('PAComments');
		if (obj) obj.value="";
		var obj=document.getElementById('chkInActive');
		if (obj) obj.checked=false;
		var obj=document.getElementById("PAHabit");
		if (obj) {
			obj.onblur=HabitQuantityChangeHandler;
		}
	}
}

function PAComments_keydownhandler(encmeth) {
	var obj=document.getElementById("PAComments");
	//lookupqryNURN,jsfuncNURN defined in epr.js
	LocateCode(obj,encmeth,0,lookupqryNURN,jsfuncNURN);
}
function PAComments_lookupsel(value) {
}
function LookUpDisease(str) {
// 25/06/2002 LOG 25874 - AI : Add function to lookup Disease.
	var ary=str.split("^");
	var ary2=ary[0].split(" | ");
	var obj=document.getElementById("PADisease");
	if (obj) obj.value=ary2[0];
}
function LookUpFamilyDisease(str) {
// 25/06/2002 LOG 25874 - AI : Add function to lookup Family Disease.
	var ary=str.split("^");
	var ary2=ary[0].split(" | ");
	var obj=document.getElementById("PAFamilyDisease");
	if (obj) obj.value=ary2[0];
}

document.body.onload = BodyLoadHandler;
