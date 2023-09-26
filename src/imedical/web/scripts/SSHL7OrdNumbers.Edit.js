// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

// Log 40498 - AI - 19-11-2003 : File created.

var segItems=document.getElementById('HL7SegTypes');
var fldItems=document.getElementById('HL7FldTypes');

var segAry = new Array();
var segfldAry = new Array();

Init();


function Init() {
	// SegTypes and FldTypes: OnChange caters for UP and DOWN arrow key presses in a List Box. OnClick does not.
	var obj=document.getElementById('HL7SegTypes'); if (obj) obj.onchange=HL7SegTypesChangeHandler;
	var obj=document.getElementById('HL7FldTypes'); if (obj) obj.onchange=HL7FldTypesChangeHandler;

	var obj=document.getElementById('HL7ONSegmentType'); if (obj) obj.onfocus=HL7ONSegmentTypeFocusHandler;
	var obj=document.getElementById('HL7ONSegmentField'); if (obj) obj.onfocus=HL7ONSegmentFieldFocusHandler;

	var obj=document.getElementById('HL7ONNumberType'); if (obj) obj.onblur=HL7ONNumberTypeBlurHandler;

	var obj=document.getElementById('RemoveSeg'); if (obj) obj.onclick=RemoveSegClickHandler;

	var obj=document.getElementById('AddField'); if (obj) obj.onclick=AddFieldClickHandler;
	var obj=document.getElementById('RemoveFld'); if (obj) obj.onclick=RemoveFldClickHandler;

	var obj=document.getElementById('update1'); if (obj) obj.onclick=UpdateClickHandler;

	segItems.multiple=false;
	fldItems.multiple=false;
}

// this needs to be called after the captions are dumped
function BodyLoadHandler() {

	if (tsc['Update']) websys_sckeys[tsc['Update']]=UpdateClickHandler;
	//if (tsc['Delete']) websys_sckeys[tsc['Delete']]=DeleteClickHandler;

	DisableField('HL7ONSegmentField',1);
	DisableNumberTypeProperties();

	// Load strAry (built in web.SSHL7OrdNumbers.getOrdNumbers) into Segment Type array first.
	var objStrArry=document.getElementById('strAry');
	var str="";
	if (objStrArry) str=objStrArry.value;
	if (str!="") {
		var lu = str.split("^");
		for(j=0; j<lu.length; j++) {
			var lu1=lu[j].split("|");
			var lu2=lu1[0].split("*");
			// lu2[0] is the Segment Type code (eg. "OBR"). lu2[1] is the description (eg. "OBR - Observation Request").
			BuildSegAry(j,lu2[0],lu2[1]);
		}
	}

	// Load strAry (built in web.SSHL7OrdNumbers.getOrdNumbers) into REAL array.
	var objStrArry=document.getElementById('strAry');
	var str=objStrArry.value;
	if (str!="") {
		var lu = str.split("^");
		for(j=0; j<lu.length; j++) {
			var lu1=lu[j].split("|");
			// lu1[0] is the Segment information (see above).
			segfldAry[j]=new Array();
			// we don't want lu1[0] (Segment Type code) again, so start at k=1.
			for (k=1; k<lu1.length; k++) {
				var lu2=lu1[k].split("*");
				var lu3=lu1[0].split("*");

				// we want to use k for the order, instead of the field number (which is in order of previous data entry).
				// we want to subtract 1 from k here, as counting starts at 0 not 1.
				// lu2[0] is the Segment Type code (eg. "OBR"). lu2[1] is the description (eg. "OBR - Observation Request").
				BuildSegFldAry(j,k-1,lu2[0],lu2[1],lu2[2]);
			}
		}
	}
}


function HL7ONSegmentTypeLookUp(str) {
	var lu = str.split("^");
	// Log 39931 - AI - 17-10-2003 : Use the StandardType's StoredValue (lu[2]) instead of the Code (lu[1]) which may be changed by Users.
	if (lu[2]!="") {
		//Check selected Segment Type not already in Listbox.
		for(i=0; i<segItems.length; i++) {
			if (segItems[i].innerText==lu[0]) {
				alert("'" + lu[0] + "' " + t['AlreadyExists']);
				// Clear LookUp.
				var obj=document.getElementById('HL7ONSegmentType');
				if (obj) obj.value="";
				// Mark the existing list item as the selected one.
				segItems.selectedIndex=i;
				HL7SegTypesChangeHandler();
				websys_setfocus('HL7SegTypes');
				return false;
			}
		}

		// Add selected LookUp item into Listbox.
		var num=segItems.length;
		segItems[num]= new Option(lu[0]);
 		// Log 39931 - AI - 17-10-2003 : Use the StandardType's StoredValue (lu[2]) instead of the Code (lu[1]) which may be changed by Users.
		// Add selected LookUp item into Array.
		BuildSegAry(num,lu[2],lu[0]);
		// create new blank array in segfldAry here too.
		segfldAry[num]=new Array();

		// Clear LookUp.
		var obj=document.getElementById('HL7ONSegmentType');
		if (obj) obj.value="";

		// make the new entry the selected one.
		segItems.selectedIndex=num;

		HL7SegTypesChangeHandler();

		// Set focus to Segment Field lookup field.
		websys_setfocus("HL7ONSegmentField");
	}
}


function HL7ONNumberTypeLookUp(str) {
	var lu = str.split("^");
	var j=segItems.selectedIndex;
	var k=fldItems.selectedIndex;
	segfldAry[j][k].numtype=lu[1];
	segfldAry[j][k].numdesc=lu[0];
}


// User has selected a Segment Type from the ListBox.
function HL7SegTypesChangeHandler() {
	ResetSegTypeLookup();
	EnableField('HL7ONSegmentField');
	ClearSegmentFieldList();
	BuildSegmentFieldList();
	DisableNumberTypeProperties();
}

// Clear the Segment Type lookup field.
function ResetSegTypeLookup() {
	var obj=document.getElementById('HL7ONSegmentType');
	if (obj) obj.value="";
}

// Clear the Segment Field Listbox.
function ClearSegmentFieldList() {
	fldItems.selectedIndex=-1;
	if (fldItems.length!=0) {
		for (j=fldItems.length;j>0;j--) {
			fldItems.remove(j-1);
		}
	}
}

// Build the list of Segment Fields for the selected Segment Type.
function BuildSegmentFieldList() {
	var j=segItems.selectedIndex;
	if (segfldAry[j].length!=0) {
		for(k=0; k<segfldAry[j].length; k++) {
			fldItems[k]= new Option(segfldAry[j][k].fldnum);
		}
	}
}

// User has selected a Segment Field from the ListBox.
function HL7FldTypesChangeHandler() {
	ResetSegmentFieldBox();
	EnableNumberTypeProperties();

	var j=segItems.selectedIndex;
	var k=fldItems.selectedIndex;
	if ((j!=-1)&&(k!=-1)) {
		var obj=document.getElementById('HL7ONNumberType');
		if (obj) {
			obj.value=segfldAry[j][k].numdesc;
		}
	}
}

// Clear the Segment Field field.
function ResetSegmentFieldBox() {
	var obj=document.getElementById('HL7ONSegmentField');
	if (obj) {
		obj.value="";
		obj.className="";
	}
}


// Add a valid number to the Field List.
function AddFieldClickHandler() {
	var obj=document.getElementById('HL7ONSegmentField');
	if ((obj)&&(obj.disabled==false)&&(obj.value!="")) {

		if ((isNaN(obj.value))||(obj.value<1)) {
			var cap=document.getElementById("cHL7ONSegmentField");
			alert("'"+cap.innerText + "' " + t['NotNumeric']);
			obj.className="clsInvalid";
			// perform the actual "commit" to the field, so the invalid value is now the "old" value for onchange handler.
			var val=obj.value;
			obj.value=val;
			websys_setfocus("HL7ONSegmentField");
			return false;
		}
		
		//Check entered/added SegmentField value not already in Listbox.
		for(i=0; i<fldItems.length; i++) {
			if (fldItems[i].innerText==obj.value) {
				alert("'" + obj.value + "' " + t['AlreadyExists']);
				// Clear LookUp.
				var obj=document.getElementById('HL7ONSegmentField');
				if (obj) obj.value="";
				// Mark the existing list item as the selected one.
				fldItems.selectedIndex=i;
				HL7FldTypesChangeHandler();
				websys_setfocus('HL7FldTypes');
				return false;
			}
		}

		// if continuing, treated as the "else" of the above two "if" statements.
		obj.className="";

		// Add selected LookUp item into Listbox.
		var num=fldItems.length;
		fldItems[num]= new Option(obj.value);

		var segidx=segItems.selectedIndex;
		
		// Add selected LookUp item into Array.
		BuildSegFldAry(segidx,num,obj.value,"","");

		// make the new entry the selected one.
		fldItems.selectedIndex=num;

		HL7FldTypesChangeHandler();

		// Set focus to Number Type lookup field.
		websys_setfocus("HL7ONNumberType");
	}
}


// Remove an entire Segment.
function RemoveSegClickHandler() {
	var j=segItems.selectedIndex;
	if (j!=-1) {
		// Remove each fld for this seg from segfld Array.
		for (k=segfldAry[j].length;k>0;k--) {
			segfldAry[j].splice((k-1),1);
		}

		// Remove selected seg from segfld Array.
		segfldAry.splice(j,1);

		// Remove selected seg from seg Array.
		segAry.splice(j,1);
		// Remove selected seg from seg Listbox.
		segItems.remove(j);
		// set the focus to the Segment Type field.
		websys_setfocus("HL7ONSegmentType");
	}

	return false;
}

// Remove a Field from within a Segment.
function RemoveFldClickHandler() {
	var j=segItems.selectedIndex;
	var k=fldItems.selectedIndex;
	if ((j!=-1)&&(k!=-1)) {
		// Remove selected fld from segfld Array.
		segfldAry[j].splice(k,1);
		// Remove selected fld from fld Listbox.
		fldItems.remove(k);
		// set the focus to the Field Number field.
		websys_setfocus("HL7ONSegmentField");
	}

	return false;
}


function HL7ONSegmentTypeFocusHandler() {
	DisableField('HL7ONSegmentField',1);
	DisableNumberTypeProperties();
	ClearSegmentFieldList();
	segItems.selectedIndex=-1;
}


function HL7ONSegmentFieldFocusHandler() {
	DisableNumberTypeProperties();
	fldItems.selectedIndex=-1;
}


function HL7ONNumberTypeBlurHandler() {
	var obj=document.getElementById("HL7ONNumberType");
	if ((obj)&&((obj.value=="")||(obj.className=="clsInvalid"))) {
		var j=segItems.selectedIndex;
		var k=fldItems.selectedIndex;
		segfldAry[j][k].numtype="";
		segfldAry[j][k].numdesc="";
	}
}

function HL7ONSegmentFieldChangeHandler() {
	var obj=document.getElementById("HL7ONSegmentField");
	if (obj) {
		if ((isNaN(obj.value))||(obj.value<1)) {
			var cap=document.getElementById("cHL7ONSegmentField");
			alert("'"+cap.innerText + "' " + t['NotNumeric']);
			obj.className="clsInvalid";
			// perform the actual "commit" to the field, so the invalid value is now the "old" value for onchange handler.
			var val=obj.value;
			obj.value=val;
			websys_setfocus("HL7ONSegmentField");
			return false;
		}
		else {
			obj.className="";
			var j=lstItems.selectedIndex;
			segfldAry[j].fldnum=obj.value;
		}
	}
}


function BuildSegAry(pos,segtype,segdesc) {
	tmpAry = new SegRecord(segtype,segdesc);
	segAry[pos] = tmpAry;
}

// The layout of a Segment record.
function SegRecord(segtype,segdesc) {
	this.segtype=segtype;
	this.segdesc=segdesc;
}


function BuildSegFldAry(segpos,fldpos,fldnum,numtype,numdesc) {
	tmpAry = new SegFldRecord(fldnum,numtype,numdesc);
	segfldAry[segpos][fldpos] = tmpAry;
}

// The layout of a (Segment-Field) record.
function SegFldRecord(fldnum,numtype,numdesc) {
	this.fldnum=fldnum;
	this.numtype=numtype;
	this.numdesc=numdesc;
}


function UpdateClickHandler() {
	// check that at least one segment field is defined for each segment type.
	for(j=0; j<segAry.length; j++) {
		if (segfldAry[j].length==0) {
			alert(t['AtLeastOne'] + " '" + t['HL7ONSegmentField'] + "' " + t['IsRequiredFor'] + " " + t['HL7ONSegmentType'] + " '" + segItems[j].innerText + "'");
			return false;
		}
	}

	// check through all segfldAry[][] definitions for the number type defined.
	for(j=0; j<segAry.length; j++) {
		for(k=0; k<segfldAry[j].length; k++) {
			if ((segfldAry[j][k].numtype=="")||(segfldAry[j].numdesc=="")) {
				alert("'" + t['HL7ONNumberType'] + "' " + t['IsMandatory'] + " " + t['HL7ONSegmentType'] + " '" + segItems[j].innerText + "', " + t['HL7ONSegmentField'] + " '" + fldItems[k].innerText + "'");
				return false;
			}
		}
	}

	var strBuffer="";
	for(j=0; j<segAry.length; j++) {
		for(k=0; k<segfldAry[j].length; k++) {
			if (strBuffer!="") strBuffer=strBuffer + "^"+ segAry[j].segtype + "*" + segAry[j].segdesc + "*" + segfldAry[j][k].fldnum + "*" + segfldAry[j][k].numtype + "*" + segfldAry[j][k].numdesc;
			if (strBuffer=="") strBuffer=segAry[j].segtype + "*" + segAry[j].segdesc + "*" + segfldAry[j][k].fldnum + "*" + segfldAry[j][k].numtype + "*" + segfldAry[j][k].numdesc;
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

function DisableNumberTypeProperties() {
	DisableField('HL7ONNumberType',1);
	objLU=document.getElementById('ld1899iHL7ONNumberType');
	if (objLU) objLU.disabled=true;
}

function EnableNumberTypeProperties() {
	EnableField('HL7ONNumberType');
	var objLU = document.getElementById("ld1899iHL7ONNumberType");
	if (objLU) objLU.disabled=false;
}

document.body.onload=BodyLoadHandler;

