// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

// ab 8.11.05 - 56335

var extsysItems=document.getElementById('MessageTypes');
var formatItems=document.getElementById('ExternalTables');

var extsysAry = new Array();
var extsysformatAry = new Array();

var TRAKRES_CHANGE=null;

Init();


function Init() {
	// ExtSystems and FormatCodes: OnChange caters for UP and DOWN arrow key presses in a List Box. OnClick does not.
	var obj=document.getElementById('MessageTypes'); if (obj) obj.onchange=HL7TFExtSystemsChangeHandler;
	var obj=document.getElementById('ExternalTables'); if (obj) obj.onchange=ExternalTablesChangeHandler;

	var obj=document.getElementById('MessageType'); if (obj) obj.onfocus=MessageTypeFocusHandler;
	var obj=document.getElementById('ExternalTable'); if (obj) obj.onfocus=ExternalTableFocusHandler;


    var obj=document.getElementById("TrakTable");
    if (obj) {
        TRAKRES_CHANGE=obj.onchange;
        obj.onchange=TrakResChangeHandler;
    }

	//var obj=document.getElementById('TrakTable'); if (obj) obj.onblur=TrakTableBlurHandler;

	var obj=document.getElementById('RemoveMsgType'); if (obj) obj.onclick=RemoveMsgTypeClickHandler;

	var obj=document.getElementById('AddExtTable'); if (obj) obj.onclick=AddExtTableClickHandler;
	var obj=document.getElementById('RemoveExtTable'); if (obj) obj.onclick=RemoveExtTableClickHandler;

	var obj=document.getElementById('update1'); if (obj) obj.onclick=UpdateClickHandler;

	extsysItems.multiple=false;
	formatItems.multiple=false;
}

// this needs to be called after the captions are dumped
function BodyLoadHandler() {
	if (tsc['Update']) websys_sckeys[tsc['Update']]=UpdateClickHandler;

	DisableFormatCodeProperties();
	DisableAsciiConProperties();

	// Load strAry (built in web.SSHL7TextFormatCodes.getTextFormatCodes) into External System array first.
	var objStrArry=document.getElementById('strAry');
	var str="";
	if (objStrArry) str=objStrArry.value;
	
	if (str!="") {
		var lu = str.split("^");
		for(j=0; j<lu.length; j++) {
			var lu1=lu[j].split("|");
			var lu2=lu1[0].split("*");
			// lu2[0] is the External System code (eg. "KES"). lu2[1] is the description (eg. "Kestral Lab Systems").
			BuildextsysAry(j,lu2[0],lu2[1],lu2[0].substr(4,6));
		}
	}

	// Load strAry (built in web.SSHL7TextFormatCodes.getTextFormatCodes) into REAL array.
	var objStrArry=document.getElementById('strAry');
	var str="";
	if (objStrArry) str=objStrArry.value;
	if (str!="") {
		var lu = str.split("^");
		for(j=0; j<lu.length; j++) {
			var lu1=lu[j].split("|");
			// lu1[0] is the External System information (see above).
			extsysformatAry[j]=new Array();
			// we do not want lu1[0] (External System code) again, so start at k=1.
			for (k=1; k<lu1.length; k++) {
				var lu2=lu1[k].split("*");

				// we want to use k for the order, instead of the ascii conversion number (which is in order of previous data entry).
				// we want to subtract 1 from k here, as counting starts at 0 not 1.
				// lu2[0] is the External System code (eg. "KES"). lu2[1] is the description (eg. "Kestral Lab Systems").
				BuildextsysformatAry(j,k-1,lu2[0],lu2[1]);
			}
		}
	}
}


function MessageTypeLookUp(str) {
	var lu = str.split("^");
    //alert(lu[2].substr(4,6));
	// Log 39931 - AI - 17-10-2003 : Use the StandardType's StoredValue (lu[2]) instead of the Code (lu[1]) which may be changed by Users.
	if (lu[2]!="") {
		//Check selected External System not already in Listbox.
		for(i=0; i<extsysItems.length; i++) {
			if (extsysItems[i].innerText==lu[0]) {
				alert("'" + lu[0] + "' " + t['AlreadyExists']);
				// Clear LookUp.
				var obj=document.getElementById('MessageType');
				if (obj) obj.value="";
				// Mark the existing list item as the selected one.
				extsysItems.selectedIndex=i;
				HL7TFExtSystemsChangeHandler();
				websys_setfocus('MessageTypes');
				return false;
			}
		}

		// Add selected LookUp item into Listbox.
		var num=extsysItems.length;
		extsysItems[num]= new Option(lu[0]);
 		// Log 39931 - AI - 17-10-2003 : Use the StandardType's StoredValue (lu[2]) instead of the Code (lu[1]) which may be changed by Users.
		// Add selected LookUp item into Array.
		BuildextsysAry(num,lu[2],lu[0],lu[2].substr(4,6));
		// create new blank array in extsysformatAry here too.
		extsysformatAry[num]=new Array();

		// Clear LookUp.
		var obj=document.getElementById('MessageType');
		if (obj) obj.value="";

		// make the new entry the selected one.
		extsysItems.selectedIndex=num;

		HL7TFExtSystemsChangeHandler();

		// Set focus to Segment Field lookup field.
		websys_setfocus("ExternalTable");
	}
}


// User has selected an External System from the ListBox.
function HL7TFExtSystemsChangeHandler() {
	ResetExtSysLookup();
	EnableFormatCodeProperties();
	ClearFormatCodeList();
	BuildFormatCodeList();
	DisableAsciiConProperties();
	SetExtraVal();
}

function SetExtraVal() {
	var obj=document.getElementById('ExtraVal');
	var j=extsysItems.selectedIndex;
	if (obj) obj.value=extsysAry[j].type;
}

// Clear the External System lookup field.
function ResetExtSysLookup() {
	var obj=document.getElementById('MessageType');
	if (obj) obj.value="";
}

// Clear the Format Code Listbox.
function ClearFormatCodeList() {
	formatItems.selectedIndex=-1;
	if (formatItems.length!=0) {
		for (j=formatItems.length;j>0;j--) {
			formatItems.remove(j-1);
		}
	}
}

// Build the list of Format Codes for the selected External System.
function BuildFormatCodeList() {
	var j=extsysItems.selectedIndex;
	if (extsysformatAry[j].length!=0) {
		for(k=0; k<extsysformatAry[j].length; k++) {
			formatItems[k]= new Option(extsysformatAry[j][k].formatcode);
		}
	}
}


// User has selected a Format Code from the ListBox.
function ExternalTablesChangeHandler() {
	ResetFormatCodeBox();
	EnableAsciiConProperties();

	var j=extsysItems.selectedIndex;
	var k=formatItems.selectedIndex;
	if ((j!=-1)&&(k!=-1)) {
		var obj=document.getElementById('TrakTable');
		if (obj) {
			obj.value=extsysformatAry[j][k].asciiconv;
		}
	}
}

// Clear the Format Code field.
function ResetFormatCodeBox() {
	var obj=document.getElementById('ExternalTable');
	if (obj) {
		obj.value="";
		obj.className="";
	}
}


// Add a valid formatting code to the Format Code List.
function AddExtTableClickHandler() {
	var str="";
	var str1=new Array();
	var obj=document.getElementById('ExternalTable');
	if (obj) str=obj.value;
	if ((obj)&&(obj.disabled==false)&&(str!="")) {
		// convert the second character to uppercase, so we have \X or \Z.
        /*
		if (str.length>1) {
			for (i=0; i<str.length; i++) {
				str1[i]=str.substring(i,i+1);
			}
			if (str1[1]!="") str1[1]=str1[1].toUpperCase();
			str=str1.join("");
		}

		if ((str.length < 4) || ((str.substring(0,2) != "\\X") && (str.substring(0,2) != "\\Z")) || (str.substring(str.length-1,str.length) != "\\")) {
			var cap=document.getElementById("cExternalTable");
			alert("'"+cap.innerText + "' " + t['NotValidCode']);
			obj.className="clsInvalid";
			// perform the actual "commit" to the field, so the invalid value is now the "old" value for onchange handler.
			var val=str;
			obj.value=val;
			websys_setfocus("ExternalTable");
			return false;
		}
		*/
        
		// Check entered/added Format Code value not already in Listbox.
		for(i=0; i<formatItems.length; i++) {
			if (formatItems[i].innerText==str) {
				alert("'" + str + "' " + t['AlreadyExists']);
				// Clear LookUp.
				var obj=document.getElementById('ExternalTable');
				if (obj) obj.value="";
				// Mark the existing list item as the selected one.
				formatItems.selectedIndex=i;
				ExternalTablesChangeHandler();
				websys_setfocus('ExternalTables');
				return false;
			}
		}

		// if continuing, treated as the "else" of the above two "if" statements.
		obj.className="";

		// Add selected LookUp item into Listbox.
		var num=formatItems.length;
		formatItems[num]= new Option(str);

		var extsysidx=extsysItems.selectedIndex;
		
		// Add selected LookUp item into Array.
		BuildextsysformatAry(extsysidx,num,str,"");

		// make the new entry the selected one.
		formatItems.selectedIndex=num;

		ExternalTablesChangeHandler();

		// Set focus to Number Type lookup field.
		websys_setfocus("TrakTable");
	}
}


// Remove an entire External System.
function RemoveMsgTypeClickHandler() {
	var j=extsysItems.selectedIndex;
	if (j!=-1) {
		// Remove each Format Code for this External System from extsysformat Array.
		for (k=extsysformatAry[j].length;k>0;k--) {
			extsysformatAry[j].splice((k-1),1);
		}

		// Remove selected extsys from extsysformat Array.
		extsysformatAry.splice(j,1);

		// Remove selected extsys from extsys Array.
		extsysAry.splice(j,1);
		// Remove selected extsys from extsys Listbox.
		extsysItems.remove(j);
		// set the focus to the External System field.
		websys_setfocus("MessageType");
	}

	return false;
}

// Remove a Format Code from within an External System.
function RemoveExtTableClickHandler() {
	var j=extsysItems.selectedIndex;
	var k=formatItems.selectedIndex;
	if ((j!=-1)&&(k!=-1)) {
		// Remove selected Format Code from extsysformat Array.
		extsysformatAry[j].splice(k,1);
		// Remove selected Format Code from Format Code Listbox.
		formatItems.remove(k);
		// set the focus to the Format Code field.
		websys_setfocus("ExternalTable");
	}

	return false;
}


function MessageTypeFocusHandler() {
	DisableFormatCodeProperties();
	DisableAsciiConProperties();
	ClearFormatCodeList();
	extsysItems.selectedIndex=-1;
}


function ExternalTableFocusHandler() {
	DisableAsciiConProperties();
	formatItems.selectedIndex=-1;
}


function TrakResChangeHandler() {
    if (typeof TRAKRES_CHANGE == "function") TRAKRES_CHANGE();
    TrakTableSetAry();
}

function TrakTableSetAry() {
	var obj=document.getElementById("TrakTable");
	var j=extsysItems.selectedIndex;
	var k=formatItems.selectedIndex;
	if ((obj)&&(obj.value=="")) {
		extsysformatAry[j][k].asciiconv="";
	} else if ((obj)&&(obj.value!="")) {
		extsysformatAry[j][k].asciiconv=obj.value;
	}
}

function ExternalTableChangeHandler() {
	var str="";
	var str1=new Array();
	var obj=document.getElementById('ExternalTable');
	if (obj) str=obj.value();
	if ((obj)&&(obj.disabled==false)&&(str!="")) {
		// convert the second character to uppercase, so we have \X or \Z.
		if (str.length>1) {
			for (i=0; i<str.length; i++) {
				str1[i]=str.substring(i,i+1);
			}
			if (str1[1]!="") str1[1]=str1[1].toUpperCase();
			str=str1.join("");
		}
        /*
		if ((str.length < 4) || ((str.substring(0,2) != "\\X") && (str.substring(0,2) != "\\Z")) || (str.substring(str.length-1,str.length) != "\\")) {
			var cap=document.getElementById("cExternalTable");
			alert("'"+cap.innerText + "' " + t['NotValidCode']);
			obj.className="clsInvalid";
			// perform the actual "commit" to the field, so the invalid value is now the "old" value for onchange handler.
			var val=str;
			obj.value=val;
			websys_setfocus("ExternalTable");
			return false;
		}
		else {
        */
			obj.className="";
			var j=extsysItems.selectedIndex;
			extsysformatAry[j].formatcode=str;
		
	}
}


function BuildextsysAry(pos,extsys,extsysdesc,type) {
	tmpAry = new ExtSysRecord(extsys,extsysdesc,type);
	extsysAry[pos] = tmpAry;
}

// The layout of a Segment record.
function ExtSysRecord(extsys,extsysdesc,type) {
	this.extsys=extsys;
	this.extsysdesc=extsysdesc;
	this.type=type;
}


function BuildextsysformatAry(extsyspos,formatpos,formatcode,asciiconv) {
	tmpAry = new ExtSysFormatRecord(formatcode,asciiconv);
	extsysformatAry[extsyspos][formatpos] = tmpAry;
}

// The layout of a (External System - Format Code) record.
function ExtSysFormatRecord(formatcode,asciiconv) {
	this.formatcode=formatcode;
	this.asciiconv=asciiconv;
}


function UpdateClickHandler() {
	// check that at least one Format Code is defined for each External System.
	for(j=0; j<extsysAry.length; j++) {
		if (extsysformatAry[j].length==0) {
			alert(t['AtLeastOne'] + " '" + t['ExternalTable'] + "' " + t['IsRequiredFor'] + " " + t['MessageType'] + " '" + extsysAry[j].innerText + "'");
			return false;
		}
	}

	// check through all extsysformatAry[][] definitions for the Ascii Conversion defined.
    for(j=0; j<extsysAry.length; j++) {
		for(k=0; k<extsysformatAry[j].length; k++) {
			if (extsysformatAry[j][k].asciiconv=="") {
				alert("'" + t['TrakTable'] + "' " + t['IsMandatory'] + " " + t['MessageType'] + " '" + extsysAry[j].innerText + "', " + t['ExternalTable'] + " '" + formatItems[k].innerText + "'");
				return false;
			}
		}
	}

	var strBuffer="";
	for(j=0; j<extsysAry.length; j++) {
		for(k=0; k<extsysformatAry[j].length; k++) {
			if (strBuffer!="") strBuffer=strBuffer + "^"+ extsysAry[j].extsys + "*" + extsysAry[j].extsysdesc + "*" + extsysformatAry[j][k].formatcode + "*" + extsysformatAry[j][k].asciiconv;
			if (strBuffer=="") strBuffer=extsysAry[j].extsys + "*" + extsysAry[j].extsysdesc + "*" + extsysformatAry[j][k].formatcode + "*" + extsysformatAry[j][k].asciiconv;
		}
	}

	var obj = document.getElementById('strAry');
	if (obj) obj.value=strBuffer;
	return update1_click();
}

function DisableField(fldName,vGray) {
	var fld = document.getElementById(fldName);
	if ((fld)&&(fld.tagName=="INPUT")&&(fld.type!="hidden")) {
		fld.disabled = true;
		if (fld.type=="checkbox") fld.checked=false;
		fld.value = "";
		if (vGray) fld.className = "disabledField";
	}
}

function EnableField(fldName) {
	var fld = document.getElementById(fldName);
	if ((fld)&&(fld.tagName=="INPUT")&&(fld.type!="hidden")) {
		fld.disabled = false;
		fld.className = "";
		fld.value = "";
	}
}

function DisableFormatCodeProperties() {
	DisableField('ExternalTable',1);
}

function EnableFormatCodeProperties() {
	EnableField('ExternalTable');
}

function DisableAsciiConProperties() {
	DisableField('TrakTable',1);
}

function EnableAsciiConProperties() {
	EnableField('TrakTable');
}


document.body.onload=BodyLoadHandler;

