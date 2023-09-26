// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function ValidateUpdate() {
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
	
	// disable multiple select for listboxes
	obj=document.getElementById("BodySite");
	if (obj) {
		obj.multiple=false;
		obj.onmousedown=setorigval;
		obj.onchange=checkorigval;
	}

	obj=document.getElementById("Laterality");
	if (obj) {
		obj.multiple=false;
		obj.onmousedown=setorigval;
		obj.onchange=checkorigval;
	}

	obj=document.getElementById("Severity");
	if (obj) {
		obj.multiple=false;
		obj.onmousedown=setorigval;
		obj.onchange=checkorigval;
	}

	obj=document.getElementById("DurationUnit");
	if (obj) {
		obj.multiple=false;
		obj.onmousedown=setorigval;
		obj.onchange=checkorigval;
	}
	
	obj=document.getElementById("DurationNum");
	if(obj) obj.onchange=DurationNumChangeHandler;
	
	var updobj=document.getElementById("update1");
	if(updobj) {
		updobj.onclick=update1ClickHandler;
		if (tsc['update1']) websys_sckeys[tsc['update1']]=update1ClickHandler;
	}
}

// Log 64253 YC - this combo of functions allows users to deselect from a listbox when they click a selected option
function setorigval(evt) {
	var obj=websys_getSrcElement(evt);
	origval=obj.selectedIndex;
	obj.selectedIndex=-1;
}

function checkorigval(evt) {
	var obj=websys_getSrcElement(evt);
	if(obj.selectedIndex==origval) obj.selectedIndex=-1;
}
// END Log 64253

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
	var frm=document.forms['fMRSubjectFindings_Edit'];
	if(!updatecheck()) return false;
	return epr_RepeatClickHandler(evt,frm);
}

function SUBFText_keydownhandler(encmeth) {
	var obj=document.getElementById("SUBFText");
	LocateCode(obj,encmeth,0,lookupqryNURN,jsfuncNURN);
}
function SUBFText_lookupsel(value) {
}

function SUBFRTFNotesOnBlur() {
	var objRTF=document.getElementById("SUBFRTFNotes");
	var objDesc=document.getElementById("SUBFNotes");
	if (objRTF && objDesc) {
		objDesc.value = objRTF.Text;
	}
	//alert('rtf value: ' + objDesc.value);
}
function SUBFTextOnBlur() {
	var obj=document.getElementById("SUBFText");
	var objDesc=document.getElementById("SUBFNotes");
	if (obj && objDesc) {
		objDesc.value = obj.value;
	}
}

function update1ClickHandler() {
	if(!updatecheck()) return false;
	return update1_click();
}

// Log 64759 YC
function updatecheck() {
	// declare vars & make sure they are all not clsInvalid
	var durobj=document.getElementById("DurationNum");
	if (durobj)	durobj.className="";
	var durunitobj=document.getElementById("DurationUnit");
	if (durunitobj) durunitobj.className="";
	var ODobj=document.getElementById("OnsetDate");
	if (ODobj) ODobj.className="";
	var OTobj=document.getElementById("OnsetTime");
	if (OTobj) OTobj.className="";
	var EDobj=document.getElementById("EndDate");
	if (EDobj) EDobj.className="";
	var ETobj=document.getElementById("EndTime");
	if (ETobj) ETobj.className="";
	
	// check that both duration and duration unit are entered (must be entered as pairs)
	if (durobj && durobj.value!="") {
		if (!durunitobj) {
			alert(t['DUR_MISSING']);
			return false;
		}
		else if(durunitobj.value=="") {
			durunitobj.className="clsInvalid";
			alert(t['DUR_MISSING']);
			return false;
		}		
	}
	if (durunitobj) {
		if (durunitobj.value!="") {
			if (!durobj) {
				alert(t['DUR_MISSING']);
				return false;
			}
			else if (durobj.value=="") {
				durobj.className="clsInvalid";
				alert(t['DUR_MISSING']);
				return false;
			}
		}
	}

	// checks that onset date/time is not in the future
	if(ODobj && ODobj.value!="") {
		if (OTobj && OTobj.value!="") {
			if (DateTimeStringCompareToday(ODobj.value,OTobj.value)==1) {
				alert(t['OnsetDate']+" & "+t['OnsetTime']+" "+t['NOT_IN_FUTURE']);
				ODobj.className="clsInvalid";
				OTobj.className="clsInvalid";
				return false;
			}
		}
		if (DateStringCompareToday(ODobj.value)==1) {
			alert(t['OnsetDate']+" "+t['NOT_IN_FUTURE']);
			ODobj.className="clsInvalid";
			return false;
		}
	}
	
	// checks that end date/time is not in the future
	if(EDobj && EDobj.value!="") {
		if(ETobj && ETobj.value!="") {
			if (DateTimeStringCompareToday(EDobj.value,ETobj.value)==1) {
				alert(t['EndDate']+" & "+t['EndTime']+" "+t['NOT_IN_FUTURE']);
				EDobj.className="clsInvalid";
				ETobj.className="clsInvalid";
				return false;
			}
		}
		if (DateStringCompareToday(EDobj.value)==1) {
			alert(t['EndDate']+" "+t['NOT_IN_FUTURE']);
			EDobj.className="clsInvalid";
			return false;
		}
	}

	// check if onset date/time is before end date/time
	var compare=0;
	if (ODobj && EDobj && ODobj.value!="" && EDobj.value!="") {
		if (OTobj && ETobj && OTobj.value!="" && ETobj.value!="") {
			compare=DateTimeStringCompare(ODobj.value,OTobj.value,EDobj.value,ETobj.value);
		}
		else {
			compare=DateStringCompare(ODobj.value,EDobj.value);
		}
		if (compare==1) {
			alert(t['ONSET_AFTER_END']);
			ODobj.className="clsInvalid";
			EDobj.className="clsInvalid";
			if (OTobj) OTobj.className="clsInvalid";
			if (ETobj) ETobj.className="clsInvalid";		
			return false;
		}
	}
	
	return true;
}

// log 64759 YC - clears duration unit if duration num is deleted
function DurationNumChangeHandler() {
	var objN=document.getElementById("DurationNum");
	var objU=document.getElementById("DurationUnit");
	if (objN && objU && objN.value=="") objU.selectedIndex=-1;
	
	return DurationNum_changehandler();
}

document.body.onload = BodyLoadHandler;
var objRTFBlur=document.getElementById("SUBFRTFNotes")
if (objRTFBlur) objRTFBlur.onblur=SUBFRTFNotesOnBlur;
var objBlur=document.getElementById("SUBFText")
if (objBlur) objBlur.onblur=SUBFTextOnBlur;