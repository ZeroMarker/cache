// Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

// Log 61269 - AI - 24-10-2006 : New file for Multi Verify Text Results.
//                             : From OETextResult.Edit.js and WordDocVerify.Link.js

// Log 62065 - AI - 09-01-2007 : "Global" field for Coded Text functionality.
var keycode;


function OETextResultVerifyLoadHandler() {
	var cobj=document.getElementById('Cancel');
	if (cobj) cobj.onclick=CancelClickHandler;

	var nobj=document.getElementById('Next');
	if (nobj) nobj.onclick=NextClickHandler;

	var uobj=document.getElementById("Update");
	if (uobj) {
		uobj.onclick=UpdateClickHandler;
		if (tsc['Update']) websys_sckeys[tsc['Update']]=UpdateClickHandler;	
	}

	// Log 62069 - AI - 20-12-2006 : Save is the same as Update, but the component calls the ClassMethod differently.
	var sobj=document.getElementById("Save");
	if (sobj) {
		sobj.onclick=SaveClickHandler;
		if (tsc['Save']) websys_sckeys[tsc['Save']]=SaveClickHandler;	
	}

	// Disable Next link if no multiple patient OE Id's
	var multipatobj = document.getElementById('multipatOEIDs');
	if (multipatobj && multipatobj.value=="") {
		if (nobj) {nobj.disabled=true; nobj.className = "disabledField";}
	}

	SupplementaryCheck();
}

function OETextResultVerifyUnloadHandler() {
	// If multiple patient OE Ids exist then loop around and process next one.
 	var TWKFL=""
	var TWKFLI=""
	var TWKFLL=""
	var TWKFLJ=""
	var CONTEXT=""
	var multipatOEIDs="",PatientID="",OEOrdItemID=""

	var obj = document.getElementById('multipatOEIDs'); if (obj) multipatOEIDs=obj.value;
	var obj = document.getElementById('OEOrdItemID'); if (obj) OEOrdItemID=obj.value;
	var obj = document.getElementById('PatientID'); if (obj) PatientID=obj.value;
	var obj = document.getElementById('TWKFL'); if (obj) TWKFL=obj.value;
	var obj = document.getElementById('TWKFLI'); if (obj) TWKFLI=obj.value;
	var obj = document.getElementById('TWKFLL'); if (obj) TWKFLL=obj.value;
	var obj = document.getElementById('TWKFLJ'); if (obj) TWKFLJ=obj.value;
	var obj = document.getElementById('Action'); if (obj) Action=obj.value;
	var CONTEXT = session['CONTEXT']

	if (multipatOEIDs!="") {
		var FormStr="epr.verifytextmulti.csp?";
		var InitStr="CONTEXT="+CONTEXT+"&TWKFL="+TWKFL+"&TWKFLI="+TWKFLI+"&TWKFLL="+TWKFLL+"&TWKFLJ="+TWKFLJ
		var lnk=FormStr + InitStr + "&OEOrdItemID="+OEOrdItemID+"&PatientID="+PatientID+"&PatientBanner=1&multipatOEIDs="+multipatOEIDs+"&Action="+Action
		//"&multipatOEIDs=" + multipatOEIDs;
		document.location=lnk;
	}
	return true;
}

function mPiece(s1,sep,n) {
	//Split the array with the passed delimeter
	delimArray = s1.split(sep);

	//If out of range, return a blank string
	if ((n <= delimArray.length-1) && (n >= 0)) {
		return delimArray[n];
	} else {
		return "";
	}
}

// Log 62069 - AI - 20-12-2006 : Save is the same as Update, but the component calls the ClassMethod differently.
function SaveClickHandler() {
	DoUpdate(0);
}

function UpdateClickHandler() {
	DoUpdate(1);
}

function DoUpdate(updateflg) {
	// Log 46533 YC - get rtf editor values
	var i=1;
	var SectionLong=0;
	while(document.getElementById("hiddenSectionz"+i))
	{
		// Log 62363 - Added RTFSectionz
		var RTFobj=document.getElementById('ctlRTFEditorz'+i);
		var sectionobj=document.getElementById('Sectionz'+i);
		var RTFsectionobj=document.getElementById('RTFSectionz'+i);
		if(RTFobj) {
			if(sectionobj) {
				sectionobj.value=RTFobj.Text;
				if(RTFsectionobj)	RTFsectionobj.value=RTFobj.TextRTF;
			}
		}
		// Log 58016 - AI - 30-01-2006 : Make sure sections don't exceed 32K.
		//alert("section " + i + " , length = " + sectionobj.value.length);
		if ((sectionobj.value.length > 30000) || (RTFsectionobj.value.length > 30000)) {
			var alertmsg=t['Section'] + " " + i;
			var label="";
			var labelobj=document.getElementById('cSectionz'+i);
			if (labelobj) {
				label=labelobj.innerHTML;
				alertmsg=alertmsg + " (" + label + ")";
			}
			if (RTFobj) {
				alertmsg=alertmsg + " : " + t['RTFTooLong'];
				alert(alertmsg);
			} else {
				alertmsg=alertmsg + " : " + t['SectionTooLong'];
				alert(alertmsg);
			}
			SectionLong=1;
		}
		i++;
	}
	if (SectionLong) return false;
	// end Log 58016
	if (updateflg==1) return Update_click();
	if (updateflg!=1) return Save_click();
}

function NextClickHandler() {
	var obj = document.getElementById('Next');
	if (obj && obj.disabled==true) return false;
	var mobj = document.getElementById('multipatOEIDs');
	var obj = document.getElementById('OEOrdItemID');

	// LOG 35572 RC 12/05/03 These loops are needed if all the items in a multiple order item set are selected for
	// verification to make sure that when 'next' is selected, it doesn't cycle through the entire collection. If the first
	// item of a collection is only selected, this isn't needed.
	for(var i=0;mPiece(obj.value,"^",i)!="";i++) {
		var val=mPiece(obj.value,"^",i);
		if (val==mPiece(mobj.value,"^",0)) {
			var test="";
			for (var j=1;mPiece(mobj.value,"^",j)!="";j++) {
				test=test+mPiece(mobj.value,"^",j)+"^";
			}
			mobj.value=test;
		}
	}
}

function CancelClickHandler() {
	// Clear out all ID's to kill looping and drop back to Rad workbench.
	var obj = document.getElementById('multipatOEIDs');
	if (obj) obj.value="";
	return Cancel_click();
}

// This is on Verify.
// If PreviousText is blank, we are still a NEW result, so disable the "Reason For Supplementary Result" field.
// If not (the PreviousText exists) do nothing here - will display as last saved (if last saved).
function SupplementaryCheck() {
	var supobj=document.getElementById("TRReasonSuppResultDR");
	if (supobj) {
		// Log 62069 - AI - 10-01-2007 : If 'TextCodes' is set to "1", also keep the "Reason for Supp..." enabled.
		//   NOTE: ONLY ONE [Non-Standard Report changed to a Text Result] can get here at a time :
		//     - "Multiple Result IDs" is the main message.
		//   Therefore, should only have to check against the single value to stop the following logic.
		//     "1" - Non-Standard report exists only (NSR = Current Text)
		//     "2" - Current Text exists only (Current Text)
		//     "3" - Non-Standard report exists and one Text (Current Text and NSR = Previous Text)
		//     "4" - Multiple Text exists (Current Text and Previous Text)

		var objTextNSR=document.getElementById("TextNSRFlags");
		if ((objTextNSR)&&(objTextNSR.value!="1")) {
			// Check PreviousText for BLANK.
			var ptobj=document.getElementById("PreviousText");
			if ((ptobj)&&(ptobj.value=="")) {
				VerifyTextDisableField('TRReasonSuppResultDR',1);
				objLU=document.getElementById('ld1820iTRReasonSuppResultDR');
				if (objLU) objLU.disabled=true;
			}
		}
	}
}

function VerifyTextDisableField(fldName,vGray) {
	var fld = document.getElementById(fldName);
	if ((fld)&&(fld.tagName=="INPUT")&&(fld.type!="hidden")) {
		fld.disabled = true;
		if (fld.type=="checkbox") fld.checked=false;
		fld.value = "";
		if (vGray) fld.className = "disabledField";
	}
}

function VerifyTextEnableField(fldName) {
	var fld = document.getElementById(fldName);
	if ((fld)&&(fld.tagName=="INPUT")&&(fld.type!="hidden")) {
		fld.disabled = false;
		fld.className = "";
		fld.value = "";
	}
}

// Log 62065 - AI - 08-01-2007 : Coded Text functionality.

// This function is set up to be called by class 'web.OETextResult' - method 'GetTranscribeTextSections'.
function Section_keydownhandler(encmeth) {
 // NOTE : Existing W650 logic kept here.
	//alert(encmeth);
	keycode=websys_getKey();
	//alert(keycode);
	eSrc = window.event.srcElement;

	LocateCode(eSrc,encmeth,false,"Kweb.MRCWordResultCode:LookUpByCode","MRCWordResultCode_lookupSelect");

	keycode="";
}

// This function is set up to be called by class 'web.OETextResult' - method 'GetTranscribeTextSections'.
function RTFSection_keydownhandler(encmeth) {
	//alert("encmeth = " + encmeth);
	//window.event.keyCode
	keycode=websys_getKey();
	//alert("keycode = " + keycode);
	eSrc = window.event.srcElement;

	//LocateCode(eSrc,encmeth,false,"Kweb.MRCWordResultCode:LookUpByCode","MRCWordResultCode_lookupSelect");
	OETLocateCode(eSrc,encmeth,true,"Kweb.MRCWordResultCode:LookUpByCode","OETRTFMRCWordResultCode_lookupSelect");
	keycode="";
}

var startDelim;
var endDelim;

try {startDelim=COMPstartDelim; } catch(err) { startDelim="\\"; }
try {endDelim=COMPendDelim; } catch(err) { endDelim=" "; }

var startAscii=startDelim.charCodeAt();
var endAscii=endDelim.charCodeAt();
var enteredField=null;

function OETLocateCode(fld,encmeth,isrtf,lookupqry,execjs) {
 	var code="";
	//alert("Locate "+keycode);
 	if (isrtf) {
 		keychar = keycode;  //window.event.keyCode;
 	} else {
 // NOTE : Existing W650 logic kept here.
 		keychar = websys_getKey(event);
 	}

	//alert('Fld: ' + fld + '\nkeychar: ' + keychar);
	//alert(keychar +":"+endAscii);
	if (keychar == endAscii) {
 		if (isrtf) {
			//alert('Fld: ' + fld + '\nkeychar: ' + keychar);
			code = fld.GetCode(startDelim);
			enteredField = fld;

  		} else {
 // NOTE : Existing W650 logic kept here.
			code = GetCode(fld);
		}
		if (enteredField) {
			//alert("code is: " + code + "\nmeth is: " + encmeth);
			if (isrtf) {
				val=cspRunServerMethod(encmeth,code,1);
			} else {
 // NOTE : Existing W650 logic kept here.
				cspRunServerMethod(encmeth,code);
			}

		}
	}

	if (keychar == 117) {
		if (!lookupqry) return websys_cancel();
		//F6 key for lookup
		if (isrtf) {
			code = fld.GetCode(startDelim);
			enteredField = fld;
			if (code!="") {
		// NOTE the difference to W642L. T6.8 can do it all in websys.ComponentXRef class and websys.lookup.csp.
		//   In W642L, we had to create the file websys.rtflookup.csp to work with the section. In T6.8, we don't.
				// var url = "websys.rtflookup.csp";
				var url = "websys.lookup.csp";
	// **********************************************
	// * Watch out for the hard-coded component ID. *
	// **********************************************
		// NOTE the difference to W642L. T6.8 has websys.ComponentXRef.cls - GenListLookup. W642L does not.
		//   In W642L, we had to build an ID to pull apart in websys.rtflookup.csp. In T6.8, we don't.
				//url += "?ID=2318^*"+"Sections"+"^*"+fld.name.substring(fld.name.length-1);
				url += "?ID=2318iSectionz"+fld.name.substring(fld.name.length-1);
				if (lookupqry) url += "&CONTEXT="+lookupqry;
				if (execjs) url += "&TLUJSF="+execjs;
				url += "&P1=" + code;
				var tmp=url.split('%');
				url=tmp.join('%25');
				websys_lu(url,1,'');
			}
		} else {
			code = GetCode(fld);
			if (enteredField) {
				var url = "websys.lookup.csp";
				//url += "?ID=dXXXiYYY";  XXX=compID,YYY=fieldname
				//url += "?TFORM=" + fld.form.TFORM.value + "^" + fld.name;
				url += "?ID=i"+fld.name;
				if (lookupqry) url += "&CONTEXT="+lookupqry;
				if (execjs) url += "&TLUJSF="+execjs;
				url += "&P1=" + code;
				var tmp=url.split('%');
				url=tmp.join('%25');
				websys_lu(url,1,'');
			}
		}
		return websys_cancel();
	}
}

function OETMRCWordResultCode_lookupSelect(str) {
 // NOTE : Existing W650 logic kept here.
	var lu=str.split("^");
	var txt=lu[1];
	if (!txt) txt=lu[0];
	var arrtxt=txt.split(" | ");
	txt=arrtxt.join("\n");
	OETLookupCode_replace(txt,false);
}

function OETRTFMRCWordResultCode_lookupSelect(str) {
	var lu=str.split("^");
	var txt=lu[1];
	if (!txt) txt=lu[0];
	var arrtxt=txt.split(" | ");
	txt=arrtxt.join("\n");
	OETLookupCode_replace(txt,true);
}

function OETLookupCode_replace(newval,isrtf) {
	if (isrtf==1) {
		enteredField.Replace(newval);
	} else {
 // NOTE : Existing W650 logic kept here.
		if (enteredField) {
			//alert('back with: ' + newval + '\nentered: ' + enteredField
			//+ '\nenteredtextrange: ' + enteredField.createTextRange
			//+ '\nenteredcursor: ' + enteredField.cursorPos);

			var origtxt = enteredField.value;
			if (enteredField.createTextRange && enteredField.cursorPos) {enteredField.cursorPos.text=newval;}
			enteredField.focus();
			enteredField = null;
		}
	}
}

// end Log 62065


// OETextResultVerifyLoadHandler also called from epr.verifytextmulti.csp
document.body.onload=OETextResultVerifyLoadHandler;
document.body.onunload=OETextResultVerifyUnloadHandler;
