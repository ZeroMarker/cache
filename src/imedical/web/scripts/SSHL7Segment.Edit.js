// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var lstItems=document.getElementById('HL7SEGType');
var msgItems=document.getElementById('HL7MessageType');
var msgAry = new Array()
Init();

function Init() {
	var obj=document.getElementById('update1'); if (obj) obj.onclick=UpdateClickHandler;
	var obj=document.getElementById('HL7MessageType'); if (obj) obj.onchange=MsgTypeChangeHandler;
	var obj=document.getElementById('HL7SEGType'); if (obj) obj.onchange=SEGTypeChangeHandler;
	var obj=document.getElementById('HL7SEGMandatory'); if (obj) obj.onclick=SEGMandatoryClickHandler;
	var obj=document.getElementById('HL7SEGRepeatable'); if (obj) obj.onclick=SEGRepeatClickHandler;
	var obj=document.getElementById('HL7SEGMaxNumberOfRepeats'); if (obj) obj.onchange=SEGMaxNoChangeHandler;
	var obj=document.getElementById('remove'); if (obj) obj.onclick=RemoveClickHandler;
	var obj=document.getElementById('Up'); if (obj) obj.onclick=UpClickHandler;
	var obj=document.getElementById('Down'); if (obj) obj.onclick=DownClickHandler;
	lstItems.multiple=false;
	msgItems.multiple=false;
}

//this needs to be called after the captions are dumped.
function BodyLoadHandler() {
	if (tsc['Update']) websys_sckeys[tsc['Update']]=UpdateClickHandler;
	if (tsc['Delete']) websys_sckeys[tsc['Delete']]=DeleteClickHandler;
	DisableField('HL7SEGTypeLU',1);
	objLU=document.getElementById('ld1808iHL7SEGTypeLU');
	if (objLU) objLU.disabled=true;
	DisableSEGProperties();
	//
	// Load strAry (built in web.SSHL7Segment.getSegments) into REAL array.
	var objStrArry=document.getElementById('strAry');
	var str=objStrArry.value;
	var lu = str.split("^");
	for(j=0; j<lu.length; j++) {
		var lu1=lu[j].split("|");
		// lu1[0] is the Message Type code (eg. "ADT_A01").
		msgAry[lu1[0]]=new Array();
		// we don't want lu1[0] (Message Type code) again, so start at k=1.
		for (k=1; k<lu1.length; k++) {
			lu2=lu1[k].split("*");
			// lu2[0] is the Sequence Number of the Segment, so use that to store segment details. Subtract 1 as js starts counting at 0 not 1.
			msgAry[lu1[0]][lu2[0]-1]=new msgRecord(lu2[1],lu2[2],lu2[3],lu2[4],lu2[5]);
		}
	}
}

function MsgTypeChangeHandler() {
	EnableField('HL7SEGTypeLU');
	objLU=document.getElementById('ld1808iHL7SEGTypeLU');
	if (objLU) objLU.disabled=false;
	DisableSEGProperties();
	//
	// Clear all items in Segment Listbox.
	lstItems.options.length=0;
	//
	// List all Segments associated to the selected Message Type.
	var i = msgItems.selectedIndex;
	for(j=0; j<msgAry[msgItems(i).value].length; j++) {
		objMsg=msgAry[msgItems(i).value][j];
		lstItems[lstItems.length]= new Option(objMsg.desc,objMsg.code);
	}
}

function SEGTypeChangeHandler() {
	// When Segment item is selected display all properties for that item.
	if (lstItems.selectedIndex!=-1) {
		var i = msgItems.selectedIndex;
		var j = lstItems.selectedIndex;
		var obj=document.getElementById('HL7SEGMandatory');
		if (obj) obj.checked=msgAry[msgItems(i).value][j].mand;
		var obj=document.getElementById('HL7SEGRepeatable');
		if (obj) obj.checked=msgAry[msgItems(i).value][j].repeat;
		var obj=document.getElementById('HL7SEGMaxNumberOfRepeats');
		if (obj) obj.value=msgAry[msgItems(i).value][j].maxNo;
		EnableSEGProperties();
	}
}

function HL7SEGTypeLookUp(str) {
	var lu = str.split("^");
	// Log 39931 - AI - 17-10-2003 : Use the StandardType's StoredValue (lu[2]) instead of the Code (lu[1]) which may be changed by Users.
	if (lu[2]!="") {
 // No longer require the check for Multiple Segments within Message. Kept code for future reference.
		//Check selected segment not already in Listbox.
 //		var i = msgItems.selectedIndex;
 //		for(j=0; j<msgAry[msgItems(i).value].length; j++) {
 //  // Log 39931 - AI - 17-10-2003 : In case this is ever un-commented : Use the StandardType's StoredValue (lu[2]) instead of the Code (lu[1]) which may be changed by Users.
 //			if (msgAry[msgItems(i).value][j].code==lu[2]) {
 //				alert(lu[0] + " " + t['AlreadyExist']);
 //				return false;
 //			}
 //		}

		// Add selected LookUp item into Listbox. seg is the Sequence Number index (Sequence Number from global - 1).
		var seq=lstItems.length
 		// Log 39931 - AI - 17-10-2003 : Use the StandardType's StoredValue (lu[2]) instead of the Code (lu[1]) which may be changed by Users.
		lstItems[lstItems.length]= new Option(lu[0],lu[2]);
		var i = msgItems.selectedIndex;
		// Add selected LookUp item into Array.
 		// Log 39931 - AI - 17-10-2003 : Use the StandardType's StoredValue (lu[2]) instead of the Code (lu[1]) which may be changed by Users.
		buildAry(msgItems(i).value,seq,lu[2],lu[0],"","","");
		//
		// Clear LookUp.
		var obj=document.getElementById('HL7SEGTypeLU');
		if (obj) obj.value="";
		// make the new entry the selected one.
		lstItems.selectedIndex=lstItems.length-1;
		// Set focus back to LookUp.
		websys_setfocus("HL7SEGTypeLU");
		// Clear all SEG Properties for the new Segment Type.
		var obj=document.getElementById('HL7SEGMandatory');
		if (obj) obj.checked=false;
		var obj=document.getElementById('HL7SEGRepeatable');
		if (obj) obj.checked=false;
		var obj=document.getElementById('HL7SEGMaxNumberOfRepeats');
		if (obj) obj.value="";
		EnableSEGProperties();
	}
}

function SEGMandatoryClickHandler() {
	updateSegmentProp();
}
function SEGRepeatClickHandler() {
	updateSegmentProp();
	EnableMaxNoProperty();
}
function SEGMaxNoChangeHandler() {
	var obj=document.getElementById("HL7SEGMaxNumberOfRepeats");
	if ((obj)&&(isNaN(obj.value))) {
		var cap=document.getElementById("cHL7SEGMaxNumberOfRepeats");
		alert("'"+cap.innerText + "' " + t['NotNumeric']);
		var obj=document.getElementById("HL7SEGMaxNumberOfRepeats");
		if (obj) obj.className="clsInvalid";
		return false;
	}
	else {
		var obj=document.getElementById("HL7SEGMaxNumberOfRepeats");
		if (obj) obj.className="";
		updateSegmentProp();
	}
}

function updateSegmentProp() {
	// Every time a segment property is changed, update the array with latest data.
	var i = msgItems.selectedIndex;
	var j = lstItems.selectedIndex;
	var SEGMan="";
	var SEGRep="";
	var SEGMaxNo="";
	var obj=document.getElementById('HL7SEGMandatory');
	if (obj) SEGMan=obj.checked;
	var obj=document.getElementById('HL7SEGRepeatable');
	if (obj) SEGRep=obj.checked;
	var obj=document.getElementById('HL7SEGMaxNumberOfRepeats');
	if (obj) SEGMaxNo=obj.value;
	buildAry(msgItems(i).value,j,lstItems(j).value,lstItems(j).innerText,SEGMan,SEGRep,SEGMaxNo);
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
	var i=lstItems.selectedIndex;
	if (i!=-1) {
		var type=msgItems(msgItems.selectedIndex).value;
		//
		// Remove selected item from Array.
		msgAry[type].splice(i,1);
		// Remove selected item from Listbox.
		lstItems.remove(i);
		DisableSEGProperties();
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
	// Keep the Array in sync with lstItem (segment) Listbox.
	var type=msgItems(msgItems.selectedIndex).value;
	var opta = new Array();
	var optb = new Array();
	opta=new msgRecord(msgAry[type][a].code,msgAry[type][a].desc,msgAry[type][a].mand,msgAry[type][a].repeat,msgAry[type][a].maxNo,msgAry[type][a].seq);
	optb=new msgRecord(msgAry[type][b].code,msgAry[type][b].desc,msgAry[type][b].mand,msgAry[type][b].repeat,msgAry[type][b].maxNo,msgAry[type][b].seq);
	msgAry[type][a] = optb;
	msgAry[type][b] = opta;
}

// seq is the Sequence Number (Segment Number from global - 1), and seg is the Segment Type code.
function buildAry(type,seq,seg,desc,mand,repeat,maxNo) {
	var tmpAry = new Array();
	tmpAry = new msgRecord(seg,desc,mand,repeat,maxNo);
	msgAry[type][seq] = tmpAry;
}

function msgRecord(code,desc,mand,repeat,maxNo) {
	this.code=code;
	this.desc=desc;
	this.mand=mand;
	this.repeat=repeat;
	this.maxNo=maxNo;
}

function UpdateClickHandler() {
	var strBuffer="";
	for(i=0; i<msgItems.length; i++) {
		if (strBuffer!="") strBuffer=strBuffer + "^";
		strBuffer=strBuffer + msgItems[i].value;
		for(j=0; j<msgAry[msgItems[i].value].length; j++) {
			strBuffer=strBuffer + "|";
			strBuffer=strBuffer + msgAry[msgItems[i].value][j].code + "&";
			strBuffer=strBuffer + msgAry[msgItems[i].value][j].mand + "&" + msgAry[msgItems[i].value][j].repeat + "&" + msgAry[msgItems[i].value][j].maxNo + "&" + j;
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
	}
}

function DisableSEGProperties() {
	var obj = document.getElementById("HL7SEGMandatory");
	if (obj) {
		obj.checked=false;
		obj.disabled=true;
	}
	var obj = document.getElementById("HL7SEGRepeatable");
	if (obj) {
		obj.checked=false;
		obj.disabled=true;
	}
	DisableField('HL7SEGMaxNumberOfRepeats',1);
}

function EnableSEGProperties() {
	EnableField('HL7SEGMandatory');
	EnableField('HL7SEGRepeatable');
	EnableMaxNoProperty();
}

function EnableMaxNoProperty() {
	var obj=document.getElementById('HL7SEGRepeatable');
	if (obj && obj.checked) {
		EnableField('HL7SEGMaxNumberOfRepeats');
	} else {
		DisableField('HL7SEGMaxNumberOfRepeats',1);
	}
}

document.body.onload=BodyLoadHandler;
