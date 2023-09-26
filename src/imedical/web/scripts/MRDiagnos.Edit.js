// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

// Log 64759 YC
function updatecheck() {
	// declare vars & make sure they are all not clsInvalid
	var durobj=document.getElementById("DurationNum");
	if (durobj)	durobj.className="";
	var durunitobj=document.getElementById("DurationUnit");
	if (durunitobj) durunitobj.className="";
	var ODobj=document.getElementById("MRDIAOnsetDate");
	if (ODobj) ODobj.className="";
	var OTobj=document.getElementById("MRDIAOnsetTime");
	if (OTobj) OTobj.className="";
	var EDobj=document.getElementById("MRDIAEndDate");
	if (EDobj) EDobj.className="";
	var ETobj=document.getElementById("MRDIAEndTime");
	if (ETobj) ETobj.className="";
	var objd=document.getElementById("MRDIADateDiagnosisIdentif");
	if (objd) objd.className="";
	var objt=document.getElementById("MRDIATimeDiagnosisIdentif");
	if (objt) objt.className="";
	
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
				alert(t['MRDIAOnsetDate']+" & "+t['MRDIAOnsetTime']+" "+t['NOT_IN_FUTURE']);
				ODobj.className="clsInvalid";
				OTobj.className="clsInvalid";
				return false;
			}
		}
		if (DateStringCompareToday(ODobj.value)==1) {
			alert(t['MRDIAOnsetDate']+" "+t['NOT_IN_FUTURE']);
			ODobj.className="clsInvalid";
			return false;
		}
	}
	
	// checks that end date/time is not in the future
	if(EDobj && EDobj.value!="") {
		if(ETobj && ETobj.value!="") {
			if (DateTimeStringCompareToday(EDobj.value,ETobj.value)==1) {
				alert(t['MRDIAEndDate']+" & "+t['MRDIAEndTime']+" "+t['NOT_IN_FUTURE']);
				EDobj.className="clsInvalid";
				ETobj.className="clsInvalid";
				return false;
			}
		}
		if (DateStringCompareToday(EDobj.value)==1) {
			alert(t['MRDIAEndDate']+" "+t['NOT_IN_FUTURE']);
			EDobj.className="clsInvalid";
			return false;
		}
	}
	
	// checks that date/time diagnos identif is not in the future
	if(objd && objd.value!="") {
		if(objt && objt.value!="") {
			if (DateTimeStringCompareToday(objd.value,objt.value)==1) {
				alert(t['MRDIADateDiagnosisIdentif']+" & "+t['MRDIATimeDiagnosisIdentif']+" "+t['NOT_IN_FUTURE']);
				objd.className="clsInvalid";
				objt.className="clsInvalid";
				return false;
			}
		}
		if (DateStringCompareToday(objd.value)==1) {
			alert(t['MRDIADateDiagnosisIdentif']+" "+t['NOT_IN_FUTURE']);
			objd.className="clsInvalid";
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
	
	// checks that d/t diagnosis identif is after onset d/t
	if (objd && ODobj && objd.value!="" && ODobj.value!="") {
		if(objt && OTobj && objt.value!="" && OTobj.value!="") {
			if(DateTimeStringCompare(ODobj.value,OTobj.value,objd.value,objt.value)==1) {
				// Onset Date & Onset Time must be before Date Diagnosis Identified & Time Diagnosis Identified
				alert(t['MRDIAOnsetDate']+" & "+t['MRDIAOnsetTime']+" "+t['DT_BEFORE']+" "+t['MRDIADateDiagnosisIdentif']+" & "+t['MRDIATimeDiagnosisIdentif']);
				ODobj.className="clsInvalid";
				objd.className="clsInvalid";			
				OTobj.className="clsInvalid";
				objt.className="clsInvalid";	
				return false;
			}
		}
		else if(DateStringCompare(ODobj.value,objd.value)==1) {
			// Onset Date must be before Date Diagnosis Identified
			alert(t['MRDIAOnsetDate']+" "+t['DT_BEFORE']+" "+t['MRDIADateDiagnosisIdentif']);
			ODobj.className="clsInvalid";
			objd.className="clsInvalid";
			return false;
		}
	}
	
	return true;
}

function UpdateClickHandler() {
	if(!updatecheck()) return false;
	if (window.opener) {
		//10.07.02 Log#26116 HP: Used for CSP page "paadm.diagnosis.csp" to reload the lower frame with "MRDiagnos.ListEMR"
		//26.07.02 Log#24836 HP: Used for CSP page "dischargediagnosis.csp" to reload top and lower frames
		// 3/9/02 Log#27280 cont. Log#24836 HP: Reload top frame of CSP page "dischargediagnosis.csp" by reloading lower frame first to get the changes to pass to top frame
		// 20/09/02 Log#27697 HP: Reload now called from MRDiagnos.ListEMR.js
		//if edit screen pop up from lower frame of CSP page "dischargediagnosis.csp", set flag to reload top frame
		if (window.opener.parent.frames["discharge_top"]) window.opener.parent.refreshTopRequired=1;
	}
	return Update_click();
}
function RepeatClickHandler(evt)	{
	var elem = document.getElementById('Repeat');
	if ((elem)&&(elem.disabled)) return false;
	if(!updatecheck()) return false;
	var frm=document.forms['fMRDiagnos_Edit'];
	return epr_RepeatClickHandler(evt,frm);
}

// Log 46427 - AI - 27-10-2004 : Delete button, but only available when CanUserDelete is 1, otherwise disable.
function DeleteClickHandler() {
	var elem = document.getElementById('delete1');
	if ((elem)&&(elem.disabled)) return false;
	var frm=document.forms['fMRDiagnos_Edit'];
	return delete1_click();
}
// end Log 46427


function BodyLoadHandler() {
	var update = document.getElementById('Update');
	if (update) update.onclick = UpdateClickHandler;
	if (tsc['Update']) websys_sckeys[tsc['Update']]=UpdateClickHandler;
	var update = document.getElementById('Repeat');
	if (update) update.onclick = RepeatClickHandler;
	if (tsc['Repeat']) websys_sckeys[tsc['Repeat']]=RepeatClickHandler;
	var update = document.getElementById('delete1');
	if (update) update.onclick = DeleteClickHandler;
	if (tsc['delete1']) websys_sckeys[tsc['delete1']]=DeleteClickHandler;

	// 4/9/02 Log# 27280 HP: Disable repeat button when open from edit button of MRDiagnos_ListEMR
	var objID = document.getElementById('ID');
	if ((objID)&&(objID.value!="")) {
		DisableFields();
	}
	else {
		EnableFields();
	}

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
	// Log 50771 - AI - 26-05-2006 : Create Blur handler for new ALL field.
	var obj=document.getElementById("MRDIAICDCodeDRAll");
	if (obj) obj.onblur=DiagnosisAllBlurHandler;
	// end Log 50771
	
	obj=document.getElementById('MRDIADateDiagnosisIdentif');
	if (obj) obj.onchange = MRDIADateDiagnosisIdentifChanger;
	
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
	
	SetupDiagFavs();
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

// ab 18.10.06 48212
function SetupDiagFavs() {
	var params="";
	var obj=document.getElementById("DiagParams");
	if (obj) params=obj.value;

	if (params!="") {
		params=params.split(String.fromCharCode(1));
		var obj=document.getElementById("FavDiagDesc1");
		if (obj) obj.innerText=params[0];
		var obj=document.getElementById("FavDiagDesc2");
		if (obj) obj.innerText=params[1];
	}
	
	var obj=document.getElementById("FavDiagList1");
	if (obj) obj.onchange=SelectDiagHandler;
	var obj=document.getElementById("FavDiagList2");
	if (obj) obj.onchange=SelectDiagHandler;
	
}

// ab 18.10.06 48212
function SelectDiagHandler(e) {
	var eSrc=websys_getSrcElement(e);
	// deselect options on other list
	if ((eSrc)&&(eSrc.id=="FavDiagList1")) {
		var obj=document.getElementById("FavDiagList2");
		if (obj) selectOptions(obj,"");
	} else {
		var obj=document.getElementById("FavDiagList1");
		if (obj) selectOptions(obj,"");
	}
	
	if (eSrc) {
		// deselect all other options (cant use 'multiple' as this doesnt allow deselection)
		for (var i=0;i<eSrc.length;i++) {
			if (i!=eSrc.selectedIndex) eSrc.options[i].selected=false;
		}
		
		// set ICD code and disable normal diagnosis fields
		if (eSrc.selectedIndex!=-1) {
			var objcode=document.getElementById("MRCIDCodeDisplay");
			if (objcode) objcode.innerText=eSrc.options[eSrc.selectedIndex].value;
			var objcode=document.getElementById("MRCIDCode");
			if (objcode) objcode.innerText=eSrc.options[eSrc.selectedIndex].value;
			DisableField("MRDIAICDCodeDR");
			DisableField("MRDIAICDCodeDRAll");
			DisableField("MRDIAICDCodeDRAltDescAlias");
			DisableField("MRDIAICDCodeDRDescOnly");
			DisableLookup("ld291iMRDIAICDCodeDRDescOnly");
			DisableLookup("ld291iMRDIAICDCodeDRAltDescAlias");
			DisableLookup("ld291iMRDIAICDCodeDRAll");
			DisableLookup("ld291iMRDIAICDCodeDR");
		} else {
			var objcode=document.getElementById("MRCIDCodeDisplay");
			if (objcode) objcode.innerText="";
			var objcode=document.getElementById("MRCIDCode");
			if (objcode) objcode.innerText="";
			EnableField("MRDIAICDCodeDR");
			EnableField("MRDIAICDCodeDRAll");
			EnableField("MRDIAICDCodeDRAltDescAlias");
			EnableField("MRDIAICDCodeDRDescOnly");
			EnableLookup("ld291iMRDIAICDCodeDRDescOnly");
			EnableLookup("ld291iMRDIAICDCodeDRAltDescAlias");
			EnableLookup("ld291iMRDIAICDCodeDRAll");
			EnableLookup("ld291iMRDIAICDCodeDR");
		}
	}
}

// cjb 31/05/2006 59454
function MRDIADateDiagnosisIdentifChanger() {
  var msg=""
	MRDIADateDiagnosisIdentif_changehandler();
	var obj=document.getElementById('MRDIADateDiagnosisIdentif');
	if ((obj)&&(obj.value!="")) {
		if (DateStringCompareToday(obj.value)==1) msg = t['MRDIADateDiagnosisIdentif'] +" : "+ t["FutureDate"];
		if (msg!="") {
			alert(msg);
			obj.value="";
			websys_setfocus("MRDIADateDiagnosisIdentif");
			return false;
		}
	}
	return true;
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

function MRDIADesc_keydownhandler(encmeth) {
	var obj=document.getElementById("MRDIADesc");
	//lookupqryNURN,jsfuncNURN defined in epr.js
	LocateCode(obj,encmeth,0,lookupqryNURN,jsfuncNURN);
}
function MRDIADesc_lookupsel(value) {
}


function LookUpDiagnos(str) {
	// Log 50771 - AI - 26-05-2006 : Add logic to cater for the other "Diagnosis..." lookup fields.
	var objb=document.getElementById("MRDIAICDCodeDRDescOnly");
	if (objb) objb.value="";
	var objc=document.getElementById("MRDIAICDCodeDRAltDescAlias");
	if (objc) objc.value="";
	var objd=document.getElementById("MRDIAICDCodeDRAll");
	if (objd) objd.value="";
	// end Log 50771

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
	// Log 50771 - AI - 26-05-2006 : Add logic to cater for the other "Diagnosis..." lookup fields.
	var obja=document.getElementById("MRDIAICDCodeDR");
	if (obja) obja.value="";
	var objc=document.getElementById("MRDIAICDCodeDRAltDescAlias");
	if (objc) objc.value="";
	var objd=document.getElementById("MRDIAICDCodeDRAll");
	if (objd) objd.value="";
	// end Log 50771

	var ary=str.split("^");
	var ary2=ary[0].split(" | ");
	var obj=document.getElementById("MRDIAICDCodeDRDescOnly");
	if (obj) obj.value=ary2[0];
	var obj2=document.getElementById("MRDIAICDCodeID");
	if (obj2) obj2.value=ary[1];
	var obj3=document.getElementById("MRCIDCode");
	if (obj3) {obj3.value=ary[2];}
	var obj4=document.getElementById("MRCIDCodeDisplay");
	if (obj4) obj4.innerText=ary[2];

	PrimaryDiagnChangeHandler();
}

function LookUpDiagnosAltDescAlias(str) {
	// Log 50771 - AI - 26-05-2006 : Add logic to cater for the other "Diagnosis..." lookup fields.
	var obja=document.getElementById("MRDIAICDCodeDR");
	if (obja) obja.value="";
	var objb=document.getElementById("MRDIAICDCodeDRDescOnly");
	if (objb) objb.value="";
	var objd=document.getElementById("MRDIAICDCodeDRAll");
	if (objd) objd.value="";
	// end Log 50771

	var ary=str.split("^");
	var ary2=ary[0].split(" | ");
	var obj=document.getElementById("MRDIAICDCodeDRAltDescAlias");
	if (obj) obj.value=ary2[0];
	var obj2=document.getElementById("MRDIAICDCodeID");
	if (obj2) obj2.value=ary[1];
	var obj3=document.getElementById("MRCIDCode");
	if (obj3) {obj3.value=ary[2];}
	var obj4=document.getElementById("MRCIDCodeDisplay");
	if (obj4) obj4.innerText=ary[2];

	PrimaryDiagnChangeHandler();
}
// end Log 27059

// Log 50771 - AI - 15-05-2006 : Include the new "Look Up On All" option.
function LookUpDiagnosAll(str) {
	// Log 50771 - AI - 26-05-2006 : Add logic to cater for the other "Diagnosis..." lookup fields.
	var obja=document.getElementById("MRDIAICDCodeDR");
	if (obja) obja.value="";
	var objb=document.getElementById("MRDIAICDCodeDRDescOnly");
	if (objb) objb.value="";
	var objc=document.getElementById("MRDIAICDCodeDRAltDescAlias");
	if (objc) objc.value="";
	// end Log 50771

	var ary=str.split("^");
	var ary2=ary[0].split(" | ");
	var obj=document.getElementById("MRDIAICDCodeDRAll");
	if (obj) obj.value=ary2[0];
	var obj2=document.getElementById("MRDIAICDCodeID");
	if (obj2) obj2.value=ary[1];
	var obj3=document.getElementById("MRCIDCode");
	if (obj3) {obj3.value=ary[2];}
	var obj4=document.getElementById("MRCIDCodeDisplay");
	if (obj4) obj4.innerText=ary[2];

	PrimaryDiagnChangeHandler();
}
// end Log 50771


function DiagnosisBlurHandler() {
	// Log 50771 - AI - 26-05-2006 : Add logic to cater for the other "Diagnosis..." lookup fields.
	var flgOKToBlank=1;

	var objb=document.getElementById("MRDIAICDCodeDRDescOnly");
	if ((objb)&&(objb.value!="")) flgOKToBlank=0;
	var objc=document.getElementById("MRDIAICDCodeDRAltDescAlias");
	if ((objc)&&(objc.value!="")) flgOKToBlank=0;
	var objd=document.getElementById("MRDIAICDCodeDRAll");
	if ((objd)&&(objd.value!="")) flgOKToBlank=0;
	// end Log 50771

	var obj=document.getElementById("MRDIAICDCodeDR");
	var obj2=document.getElementById("MRCIDCodeDisplay");
	var obj3=document.getElementById("MRCIDCode");
	// Log 50771 - AI - 26-05-2006 : Add logic to cater for the other "Diagnosis..." lookup fields.
	if ((obj)&&(obj2)&&(obj.value=="")&&(flgOKToBlank)) {
		obj2.innerText="";
		if (obj3) obj3.value="";
	}
}

function DiagnosisDescBlurHandler() {
	// Log 50771 - AI - 26-05-2006 : Add logic to cater for the other "Diagnosis..." lookup fields.
	var flgOKToBlank=1;
	var obja=document.getElementById("MRDIAICDCodeDR");
	if ((obja)&&(obja.value!="")) flgOKToBlank=0;
	var objc=document.getElementById("MRDIAICDCodeDRAltDescAlias");
	if ((objc)&&(objc.value!="")) flgOKToBlank=0;
	var objd=document.getElementById("MRDIAICDCodeDRAll");
	if ((objd)&&(objd.value!="")) flgOKToBlank=0;
	// end Log 50771

	var obj=document.getElementById("MRDIAICDCodeDRDescOnly");
	var obj2=document.getElementById("MRCIDCodeDisplay");
	var obj3=document.getElementById("MRCIDCode");
	// Log 50771 - AI - 26-05-2006 : Add logic to cater for the other "Diagnosis..." lookup fields.
	if ((obj)&&(obj2)&&(obj.value=="")&&(flgOKToBlank)) {
		obj2.innerText="";
		if (obj3) obj3.value="";
	}
}

// ab 20.04.05 - 51254 - also changed MRDIAICDCodeID valueget in component
function AltDescBlurHandler(e) {
	// Log 50771 - AI - 26-05-2006 : Add logic to cater for the other "Diagnosis..." lookup fields.
	var flgOKToBlank=1;
	var obja=document.getElementById("MRDIAICDCodeDR");
	if ((obja)&&(obja.value!="")) flgOKToBlank=0;
	var objb=document.getElementById("MRDIAICDCodeDRDescOnly");
	if ((objb)&&(objb.value!="")) flgOKToBlank=0;
	var objd=document.getElementById("MRDIAICDCodeDRAll");
	if ((objd)&&(objd.value!="")) flgOKToBlank=0;
	// end Log 50771

	// if clearing value, clear the id
	// if just updating where alt desc is blank, dont clear id
	var objprev=document.getElementById("AltDescPrevValue");
	if ((objprev)&&(objprev.value!="")) {
	        var obj=document.getElementById("MRDIAICDCodeDRAltDescAlias");
	        var obj2=document.getElementById("MRDIAICDCodeID");
	        var obj3=document.getElementById("MRCIDCodeDisplay");
	        var obj4=document.getElementById("MRCIDCode");
		// Log 50771 - AI - 26-05-2006 : Add logic to cater for the other "Diagnosis..." lookup fields.
	        if ((obj)&&(obj2)&&(obj.value=="")&&(flgOKToBlank)) {
			obj2.value="";
			if (obj3) obj3.innerText="";
			if (obj4) obj4.value="";
		}
	}
}

// Log 50771 - AI - 26-05-2006 : Create Blur handler for new ALL field.
function DiagnosisAllBlurHandler() {
	// Log 50771 - AI - 26-05-2006 : Add logic to cater for the other "Diagnosis..." lookup fields.
	var flgOKToBlank=1;
	var obja=document.getElementById("MRDIAICDCodeDR");
	if ((obja)&&(obja.value!="")) flgOKToBlank=0;
	var objb=document.getElementById("MRDIAICDCodeDRDescOnly");
	if ((objb)&&(objb.value!="")) flgOKToBlank=0;
	var objc=document.getElementById("MRDIAICDCodeDRAltDescAlias");
	if ((objc)&&(objc.value!="")) flgOKToBlank=0;
	// end Log 50771

	var obj=document.getElementById("MRDIAICDCodeDRAll");
	var obj2=document.getElementById("MRCIDCodeDisplay");
	var obj3=document.getElementById("MRCIDCode");
	// Log 50771 - AI - 26-05-2006 : Add logic to cater for the other "Diagnosis..." lookup fields.
	if ((obj)&&(obj2)&&(obj.value=="")&&(flgOKToBlank)) {
		obj2.innerText="";
		if (obj3) obj3.value="";
	}
}
// end Log 50771


function PrimaryDiagnChangeHandler() {
	//dummy fn for custom script
}

// Log 38654 - AI - 15-04-2004 : Function to use the Description (1) for the field value, not the Code (0).
function HRGLookUp(str) {
	var lu = str.split("^");
	var obj = document.getElementById('HRGDesc')
	if (obj) obj.value=lu[1];
}

// log 64759 YC - clears duration unit if duration num is deleted
function DurationNumChangeHandler() {
	var objN=document.getElementById("DurationNum");
	var objU=document.getElementById("DurationUnit");
	if (objN && objU && objN.value=="") objU.selectedIndex=-1;
	
	return DurationNum_changehandler();
}

document.body.onload = BodyLoadHandler;
