// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var lstItems=document.getElementById('HL7Segments');
var ackAry = new Array()
Init();

function Init() {
	var obj=document.getElementById('HL7ACKSegment'); if (obj) obj.onfocus=ACKSegmentFocusHandler;
	// Segments: OnChange caters for UP and DOWN arrow key presses in a List Box. OnClick does not.
	var obj=document.getElementById('HL7Segments'); if (obj) obj.onchange=HL7SegmentsChangeHandler;
	var obj=document.getElementById('HL7ACKMandatory'); if (obj) obj.onclick=ACKMandatoryClickHandler;
	var obj=document.getElementById('HL7ACKContainError'); if (obj) obj.onclick=ACKContainErrorClickHandler;
	var obj=document.getElementById('HL7ACKErrorField'); if (obj) obj.onchange=ACKErrorFieldChangeHandler;
	var obj=document.getElementById('up1'); if (obj) obj.onclick=UpClickHandler;
	var obj=document.getElementById('down1'); if (obj) obj.onclick=DownClickHandler;
	var obj=document.getElementById('remove1'); if (obj) obj.onclick=RemoveClickHandler;
	var obj=document.getElementById('update1'); if (obj) obj.onclick=UpdateClickHandler;
	lstItems.multiple=false;
}

//this needs to be called after the captions are dumped.
function BodyLoadHandler() {
	if (tsc['Update']) websys_sckeys[tsc['Update']]=UpdateClickHandler;
	if (tsc['Remove']) websys_sckeys[tsc['Remove']]=RemoveClickHandler;
	DisableSegProperties();
	//
	// Load strAry (built in web.SSHL7Acknowledge.getAcknowledgements) into REAL array.
	var objStrArry=document.getElementById('strAry');
	var str=objStrArry.value;
	if (str!="") {
		var lu = str.split("^");
		for(j=0; j<lu.length; j++) {
			var lu1=lu[j].split("*");
			// lu1[0] is the Sequence Number of the Segment, so use that to store segment details. Subtract 1 as js starts counting at 0 not 1.
			ackAry[lu1[0]-1]=new ackRecord(lu1[0]-1,lu1[1],lu1[2],lu1[3],lu1[4],lu1[5]);
		}
	}
}

function ACKSegmentFocusHandler() {
	DisableSegProperties();
}

function HL7SegmentsChangeHandler() {
	// When Segment item is selected, display all properties for that item.
	if (lstItems.selectedIndex!=-1) {
		var j = lstItems.selectedIndex;
		var obj=document.getElementById('HL7ACKMandatory');
		if (obj) obj.checked=ackAry[j].mand;
		var obj=document.getElementById('HL7ACKContainError');
		if (obj) obj.checked=ackAry[j].conterr;
		var obj=document.getElementById('HL7ACKErrorField');
		if (obj) obj.value=ackAry[j].errfld;
		EnableSegProperties();
	}
}

function HL7ACKSegmentLookUp(str) {
	var lu = str.split("^");
	// Log 39931 - AI - 17-10-2003 : Use the StandardType's StoredValue (lu[2]) instead of the Code (lu[1]) which may be changed by Users.
	if (lu[2]!="") {
		//Check selected segment not already in Listbox.
		for(j=0; j<ackAry.length; j++) {
			// Log 39931 - AI - 17-10-2003 : Use the StandardType's StoredValue (lu[2]) instead of the Code (lu[1]) which may be changed by Users.
			if (ackAry[j].segcode==lu[2]) {
				alert(lu[0] + " " + t['AlreadyExist']);
				// Clear LookUp.
				var obj=document.getElementById('HL7ACKSegment');
				if (obj) obj.value="";
				// Mark the existing list item as the selected one.
				lstItems.selectedIndex=j;
				HL7SegmentsChangeHandler();
				websys_setfocus('HL7Segments');
				return false;
			}
		}
	
  	// Add selected LookUp item into Listbox. seg is the Segment Number index (Segment Number from global - 1).
  	var seg=lstItems.length;
  	// Log 39931 - AI - 17-10-2003 : Use the StandardType's StoredValue (lu[2]) instead of the Code (lu[1]) which may be changed by Users.
  	lstItems[lstItems.length]= new Option(lu[0],lu[2]);
  	// Add selected LookUp item into Array.
  	// Log 39931 - AI - 17-10-2003 : Use the StandardType's StoredValue (lu[2]) instead of the Code (lu[1]) which may be changed by Users.
  	buildAry(seg,lu[2],lu[0],"","","");
  	//
  	// Clear LookUp.
  	var obj=document.getElementById('HL7ACKSegment');
  	if (obj) obj.value="";
  	// make the new entry the selected one.
  	lstItems.selectedIndex=lstItems.length-1;
  	// Clear all Seg Properties for the new Segment Type.
  	var obj=document.getElementById('HL7ACKMandatory');
  	if (obj) obj.checked=false;
  	var obj=document.getElementById('HL7ACKContainError');
  	if (obj) obj.checked=false;
  	var obj=document.getElementById('HL7ACKErrorField');
  	if (obj) obj.value="";
  	EnableSegProperties();
  	// Set focus to Mandatory checkbox.
  	websys_setfocus("HL7ACKMandatory");
  }
}

function ACKMandatoryClickHandler() {
	updateSegmentProp();
}

function ACKContainErrorClickHandler() {
	updateSegmentProp();
	EnableErrFldProperty();
}

function ACKErrorFieldChangeHandler() {
	var obj=document.getElementById("HL7ACKErrorField");
	if ((obj)&&(isNaN(obj.value))) {
		var cap=document.getElementById("cHL7ACKErrorField");
		alert("'"+cap.innerText + "' " + t['NotNumeric']);
		var obj=document.getElementById("HL7ACKErrorField");
		if (obj) obj.className="clsInvalid";
		return false;
	}
	else {
		var obj=document.getElementById("HL7ACKErrorField");
		if (obj) obj.className="";
		updateSegmentProp();
	}
}

function updateSegmentProp() {
	// Every time a Segment property is changed, update the array with latest data.
	var j = lstItems.selectedIndex;
	var ACKMan="";
	var ACKContErr="";
	var ACKErrFld="";
	var obj=document.getElementById('HL7ACKMandatory');
	if (obj) ACKMan=obj.checked;
	var obj=document.getElementById('HL7ACKContainError');
	if (obj) ACKContErr=obj.checked;
	var obj=document.getElementById('HL7ACKErrorField');
	if (obj) ACKErrFld=obj.value;
	buildAry(j,ackAry[j].segcode,lstItems(j).innerText,ACKMan,ACKContErr,ACKErrFld);
}

function UpClickHandler() {
	var i=lstItems.selectedIndex;
	if (i!=-1) {
		var len=lstItems.length;
		if ((len>1)&&(i>0)) {
			Swap(i,i-1);
		}
	}
	return false;
}

function DownClickHandler() {
	var i=lstItems.selectedIndex;
	if (i!=-1) {
		var len=lstItems.length;
		if ((len>1)&&(i<(len-1))) {
			Swap(i,i+1);
	 	}
	}
	return false;
}

function RemoveClickHandler() {
	var j=lstItems.selectedIndex;
	if (j!=-1) {
		// Remove selected item from Array.
		ackAry.splice(j,1);
		// Remove selected item from Listbox.
		lstItems.remove(j);
		DisableSegProperties();
	}
	return false;
}

function Swap(a,b) {
	// Swap position and style of two options.
	// We used to just remove then add - but this didn't work in NS6.
	var opta=lstItems[a];
	var optb=lstItems[b];
	lstItems[a]= new Option(optb.text,optb.value);
	lstItems[a].style.color=optb.style.color;
	lstItems[a].style.backgroundColor=optb.style.backgroundColor;
	lstItems[b]= new Option(opta.text,opta.value);
	lstItems[b].style.color=opta.style.color;
	lstItems[b].style.backgroundColor=opta.style.backgroundColor;
	lstItems.selectedIndex=b;
	swapAry(a,b);
}

function swapAry(a,b) {
	// Keep the Array in sync with lstItem (HL7Segments) Listbox.
	var opta = new Array();
	var optb = new Array();
	opta=new ackRecord(ackAry[a].seqno,ackAry[a].segcode,ackAry[a].segdesc,ackAry[a].mand,ackAry[a].conterr,ackAry[a].errfld);
	optb=new ackRecord(ackAry[b].seqno,ackAry[b].segcode,ackAry[b].segdesc,ackAry[b].mand,ackAry[b].conterr,ackAry[b].errfld);
	ackAry[a] = optb;
	ackAry[b] = opta;
}

function buildAry(seqno,segcode,segdesc,mand,conterr,errfld) {
	tmpAry = new ackRecord(seqno,segcode,segdesc,mand,conterr,errfld);
	ackAry[seqno] = tmpAry;
}

function ackRecord(seqno,segcode,segdesc,mand,conterr,errfld) {
	this.seqno=seqno;
	this.segcode=segcode;
	this.segdesc=segdesc;
	this.mand=mand;
	this.conterr=conterr;
	this.errfld=errfld;
}

function UpdateClickHandler() {
	// Log 48567 - AI - 13-01-2005 : Firstly check if "required" fields are entered.
	var errmsg="";

	// loop through all segment types
	// . if checkbox is checked
	// . . if field is blank -> ERROR

	for(j=0; j<ackAry.length; j++) {
		if ((ackAry[j].conterr==true)&&(ackAry[j].errfld=="")) {
			if (errmsg!="") errmsg=errmsg+"\n"+t['ErrorFieldMandatory']+" "+(j+1);
			if (errmsg=="") errmsg=t['ErrorFieldMandatory']+" "+(j+1);
		}
	}

	if (errmsg!="") {
		alert(errmsg);
		return false;
	}
	// end Log 48567

	var strBuffer="";
	for(j=0; j<ackAry.length; j++) {
		if (strBuffer!="") strBuffer=strBuffer + "^"+ (ackAry[j].segcode) + "*" + ackAry[j].mand + "*" + ackAry[j].conterr + "*" + ackAry[j].errfld;
		if (strBuffer=="") strBuffer=(ackAry[j].segcode) + "*" + ackAry[j].mand + "*" + ackAry[j].conterr + "*" + ackAry[j].errfld;
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
	}
}

function DisableSegProperties() {
	var obj = document.getElementById("HL7ACKMandatory");
	if (obj) {
		obj.checked=false;
		obj.disabled=true;
	}
	var obj = document.getElementById("HL7ACKContainError");
	if (obj) {
		obj.checked=false;
		obj.disabled=true;
	}
	DisableField('HL7ACKErrorField',1);
	lstItems.selectedIndex=-1;
}

function EnableSegProperties() {
	EnableField('HL7ACKMandatory');
	EnableField('HL7ACKContainError');
	EnableErrFldProperty();
}

function EnableErrFldProperty() {
	var obj=document.getElementById('HL7ACKContainError');
	var obj2=document.getElementById('cHL7ACKErrorField');
	if (obj && obj.checked) {
		EnableField('HL7ACKErrorField');
		if (obj2) obj2.className="clsRequired";
	} else {
		DisableField('HL7ACKErrorField',1);
		if (obj2) obj2.className="";
	}
}

document.body.onload=BodyLoadHandler;
