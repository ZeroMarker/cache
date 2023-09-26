// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var lstItems=document.getElementById('OUTOutboundTables');
var outAry = new Array();
Init();

function Init() {
	var obj=document.getElementById('HL7OUTTable'); if (obj) obj.onfocus=HL7OUTTableFocusHandler;
	var obj=document.getElementById('update1'); if (obj) obj.onclick=UpdateClickHandler;
	var obj=document.getElementById('remove1'); if (obj) obj.onclick=RemoveClickHandler;

	lstItems.multiple=false;
}

// this needs to be called after the captions are dumped
function BodyLoadHandler() {
	if (tsc['Update']) websys_sckeys[tsc['Update']]=UpdateClickHandler;
	if (tsc['Delete']) websys_sckeys[tsc['Delete']]=DeleteClickHandler;
	//
	// Load strAry (built in web.SSHL7OutboundTables.getOutboundTables) into REAL array.
	var objStrArry=document.getElementById('strAry');
	var str=objStrArry.value;
	if (str!="") {
		var lu = str.split("^");
		for(j=0; j<lu.length; j++) {
			var lu1=lu[j].split("*");
			outAry[j]=new outRecord(lu1[0],lu1[1]);
		}
	}
}

function HL7OUTTableLookUp(str) {
	var lu = str.split("^");
	if (lu[1]!="") {
		//Check selected Outbound Table not already in Listbox.
		for(i=0; i<outAry.length; i++) {
			if (outAry[i].outtab==lu[1]) {
				alert("'" + lu[0] + "' " + t['AlreadyExists']);
				// Clear LookUp.
				var obj=document.getElementById('HL7OUTTable');
				if (obj) obj.value="";
				// Mark the existing list item as the selected one.
				lstItems.selectedIndex=i;
				return false;
			}
		}

		// Add selected LookUp item into Listbox.
		var num=lstItems.length;
		lstItems[num]= new Option(lu[0],lu[1]);
		// Add selected LookUp item into Array.
		buildAry(lu[1],lu[0]);
		//
		// Clear LookUp.
		var obj=document.getElementById('HL7OUTTable');
		if (obj) obj.value="";
		// make the new entry the selected one.
		lstItems.selectedIndex=num;
	}
}

function HL7OUTTableFocusHandler() {
	lstItems.selectedIndex=-1;
}

function RemoveClickHandler() {
	var j=lstItems.selectedIndex;
	if (j!=-1) {
		// Remove selected item from Array.
		outAry.splice(j,1);
		// Remove selected item from Listbox.
		lstItems.remove(j);
		websys_setfocus('HL7OUTTable');
	}
	return false;
}

function buildAry(outtab,tabdesc) {
	tmpAry = new outRecord(outtab,tabdesc);
	var j=lstItems.selectedIndex;
	if (j==-1) j=lstItems.length-1;
	outAry[j] = tmpAry;
}

// The layout of a record
function outRecord(outtab,tabdesc) {
	this.outtab=outtab;
	this.tabdesc=tabdesc;
}

function UpdateClickHandler() {
	var strBuffer="";
	for(j=0; j<outAry.length; j++) {
		if (strBuffer!="") strBuffer=strBuffer + "^"+ (outAry[j].outtab) + "*" + outAry[j].tabdesc;
		if (strBuffer=="") strBuffer=(outAry[j].outtab) + "*" + outAry[j].tabdesc;
	}
	var obj = document.getElementById('strAry');
	if (obj) obj.value=strBuffer;
	return update1_click();
}

document.body.onload=BodyLoadHandler;

