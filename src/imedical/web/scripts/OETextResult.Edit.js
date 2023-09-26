// Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

// Log 38063 - AI - 29-10-2004 : File created.
// Log 61269 - AI - 03-01-2007 : New Text Result functionality throughout.
//                               Multiple logs included : 61269, 61270.

// Log 62065 - AI - 09-01-2007 : "Global" field for Coded Text functionality.
var keycode;

function OETextResultEditLoadHandler() {

	// 61270 - New "Mark as Verified" logic.
	var vobj=document.getElementById("MarkAsVerified");
	if (vobj) vobj.onclick=MarkAsVerifiedClickHandler;

	var uobj=document.getElementById("Update");
	
	//log 62487 TedT
	if (document.getElementById('CompDisabled').value==1) {
		if (uobj) {
			uobj.disabled=true; 
			uobj.onclick="";
			if (tsc['Update']) websys_sckeys[tsc['Update']]="";
		}
	}
	else {
		if (uobj) {
			uobj.onclick=UpdateClickHandler;
			if (tsc['Update']) websys_sckeys[tsc['Update']]=UpdateClickHandler;	
		}
	}

	MarkAsVerifiedClickHandler();
	SupplementaryCheck();
}

function UpdateClickHandler() {
	// 61269 - New "Reason for Supplementary Result" logic.
	var errmsg="";

	// Check if the "Reason for Supplementary Result" field is Mandatory or invalid.
	var obj=document.getElementById('TRReasonSuppResultDR');
	var objCap=document.getElementById('cTRReasonSuppResultDR');
	if ((obj)&&(obj.value=="")&&(objCap)&&(objCap.className=="clsRequired")) {
		if (errmsg!="") errmsg=errmsg+"\n"+"'"+t['TRReasonSuppResultDR']+"' "+t['XMISSING'];
		if (errmsg=="") errmsg="'"+t['TRReasonSuppResultDR']+"' "+t['XMISSING'];
		obj.className="clsInvalid";
	} else if ((obj)&&(obj.className=="clsInvalid")) {
		if (errmsg!="") errmsg=errmsg+"\n"+"'"+t['TRReasonSuppResultDR']+"' "+t['XINVALID'];
		if (errmsg=="") errmsg="'"+t['TRReasonSuppResultDR']+"' "+t['XINVALID'];
	} else if (obj) obj.className="";

	// Log 62763 - AI - 21-02-2007 : Check if the "Transcribed By" field is Mandatory or invalid.
	var obj=document.getElementById('TranscribedBy');
	var objCap=document.getElementById('cTranscribedBy');
	if ((obj)&&(obj.value=="")&&(objCap)&&(objCap.className=="clsRequired")) {
		if (errmsg!="") errmsg=errmsg+"\n"+"'"+t['TranscribedBy']+"' "+t['XMISSING'];
		if (errmsg=="") errmsg="'"+t['TranscribedBy']+"' "+t['XMISSING'];
		obj.className="clsInvalid";
	} else if ((obj)&&(obj.className=="clsInvalid")) {
		if (errmsg!="") errmsg=errmsg+"\n"+"'"+t['TranscribedBy']+"' "+t['XINVALID'];
		if (errmsg=="") errmsg="'"+t['TranscribedBy']+"' "+t['XINVALID'];
	} else if (obj) obj.className="";
	// end Log 62763

	if (errmsg!="") {
		alert(errmsg);
		return false;
	}

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
	return Update_click();
}

// 61270 - New "Mark as Verified" logic.
function MarkAsVerifiedClickHandler() {
	var userobj = document.getElementById("cTranscribedBy");
	var vobj=document.getElementById("MarkAsVerified");
	if(userobj && vobj) {
		if(vobj.checked == true) userobj.className = "clsRequired";
		else userobj.className = "";
	}
}

// 61269 - New "Reason for Supplementary Result" logic.
// This is on Transcribe.
// If PreviousText is blank, we are a NEW result, so disable the "Reason For Supplementary Result" field.
// If Item Status is "RESV" (Result Verified), we need to get the NEW Reason. Blank the field and make sure it is enabled.
// If none of these (the PreviousText exists and the Result is not "RESV") do nothing here - will display as last saved (if last saved).
function SupplementaryCheck() {
	var supobj=document.getElementById("TRReasonSuppResultDR");
	var TranscribedBy=document.getElementById("TranscribedBy");
	if (supobj||TranscribedBy) {
		// Log 62069 - AI - 10-01-2007 : If 'TextCodes' is set to "1" or "3", also keep the "Reason for Supp..." enabled.
		//   NOTE: ONLY ONE [Non-Standard Report changed to a Text Result] can get here at a time :
		//     - "Multiple Result IDs" is the main message.
		//   Therefore, should only have to check against the single value to stop the following logic.
		//     "1" - Non-Standard report exists only (NSR = Current Text)
		//     "2" - Current Text exists only (Current Text)
		//     "3" - Non-Standard report exists and one Text (Current Text and NSR = Previous Text)
		//     "4" - Multiple Text exists (Current Text and Previous Text)

		var tcobj=document.getElementById("TextCodes");
		var verobj=document.getElementById("CurrTxtResVerified");
		var ptobj=document.getElementById("PreviousText");
		if (supobj&&(tcobj)&&(tcobj.value!="1")&&(tcobj.value!="3")) {
			// Check PreviousText for BLANK and last entered result is not verified
			if (((ptobj)&&(ptobj.value==""))&&((verobj)&&(verobj.value!=1))) {
				TextDisableField('TRReasonSuppResultDR',1);
				objLU=document.getElementById('ld2011iTRReasonSuppResultDR');
				if (objLU) objLU.disabled=true;
			}
		}
		// Check Item Status for "Result Verified".
		// Log 62370 YC - (fix of 62318) Use "CurrTxtResVerified" instead of "OEItemStatus" to check if the current result has been
		// verified. This is because result can be verified but then reported again and have a status of reported (REP) instead of RESV
		//var statobj=document.getElementById("OEItemStatus");
		//if (((tcobj)&&(tcobj.value=="1"))||((statobj)&&(statobj.value=="RESV"))) {
		if (((tcobj)&&(tcobj.value=="1"||tcobj.value=="3"))||(verobj&&verobj.value==1)||((ptobj)&&(ptobj.value=="1"))) {
			if (TranscribedBy&&((tcobj&&tcobj.value=="1")||(verobj&&verobj.value==1))) TranscribedBy.value="";
			if(supobj) {
				// only clear the value if the result has not been transcribed since it was last verified
				if ((verobj&&verobj.value!=1)||(tcobj&&tcobj.value=="1")) TextEnableField('TRReasonSuppResultDR',0);
				else  TextEnableField('TRReasonSuppResultDR',1);
				var objLU = document.getElementById('ld2011iTRReasonSuppResultDR');
				if (objLU) objLU.disabled=false;
				// Make the caption appear Mandatory.
				objCap=document.getElementById('cTRReasonSuppResultDR');
				if (objCap) objCap.className="clsRequired";
			}
		}
	}
}

function TextDisableField(fldName,vGray) {
	var fld = document.getElementById(fldName);
	if ((fld)&&(fld.tagName=="INPUT")&&(fld.type!="hidden")) {
		fld.disabled = true;
		if (fld.type=="checkbox") fld.checked=false;
		fld.value = "";
		if (vGray) fld.className = "disabledField";
	}
}

function TextEnableField(fldName,clearval) {
	var fld = document.getElementById(fldName);
	if ((fld)&&(fld.tagName=="INPUT")&&(fld.type!="hidden")) {
		fld.disabled = false;
		fld.className = "";
		if (clearval==1) fld.value = "";
	}
}
// end Log 61269

// Log 62065 - AI - 08-01-2007 : Coded Text functionality.

// This function is set up to be called by class 'web.OETextResult' - method 'GetTranscribeTextSections'.
function Section_keydownhandler(encmeth) {
 // NOTE : Existing W650 logic kept here.
	//alert("encmeth = " + encmeth);
	//window.event.keyCode
	keycode=websys_getKey();
	//alert("keycode = " + keycode);
	eSrc = window.event.srcElement;

	//LocateCode(eSrc,encmeth,false,"Kweb.MRCWordResultCode:LookUpByCode","MRCWordResultCode_lookupSelect");
	OETLocateCode(eSrc,encmeth,false,"Kweb.MRCWordResultCode:LookUpByCode","OETMRCWordResultCode_lookupSelect");
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
				//url += "?ID=2011^*"+"Sections"+"^*"+fld.name.substring(fld.name.length-1);
				url += "?ID=2011iSectionz"+fld.name.substring(fld.name.length-1);
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

// OETextResultEditLoadHandler also called from epr.transcribetext.csp
document.body.onload=OETextResultEditLoadHandler;

