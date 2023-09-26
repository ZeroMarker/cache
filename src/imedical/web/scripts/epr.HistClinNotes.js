// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function DocumentLoadHandler() {
	assignClickHandler();
	
	obj=document.getElementById("new1");
	if (obj) obj.onclick=ClearFields;
}

function ClearFields() {
	var field=document.getElementById("ID")
	if (field) field.value="";
	
	var field=document.getElementById("NOTNotes")
	if (field) field.value="";
	var field=document.getElementById("NOTDesc");
	if (field) field.value="";
	
	var field=document.getElementById("NOTType")
	if (field) field.value="";
	
	var field=document.getElementById("NOTStatus")
	if (field) field.value="";

	var field=document.getElementById("NewFlag")
	if (field) field.value="Y";

	// Log 58610 - GC - 27-04-2006 : New Field NOTDSReportFlag
	var field=document.getElementById("NOTDSReportFlag")
	if (field) field.checked=false;
	// End Log 58610

	return false;
}

function assignClickHandler() {
	var tbl=document.getElementById("tepr_HistClinNotes");
	for (var i=1;i<tbl.rows.length;i++) {
		var objEdit=document.getElementById("Amend1z"+i)
		if (objEdit) objEdit.onclick=ClickHandler;
	}
	return false;
}

function ClickHandler(e) {
	var obj=websys_getSrcElement(e);
	if ((obj)&&(obj.tagName=="IMG")) obj=websys_getParentElement(obj);
	if (obj) {
		var rowid=obj.id;
		var rowAry=rowid.split("z");
		var HIDDEN=document.getElementById("HIDDENz"+rowAry[1]).value;
		var temp=HIDDEN.split("^");
		
		var field=document.getElementById("ID")
		if (field) field.value=temp[0];

		var field=document.getElementById("NOTNotes")
		if (field) {
			field.value=temp[3];
			NOTNotesOnBlur();
		}
	
		var field=document.getElementById("NOTType")
		if (field) field.value=temp[2];
	
		var field=document.getElementById("NOTStatus")
		if (field) field.value=temp[1];

		var field=document.getElementById("NewFlag")
		if (field) field.value="N";

		// Log 58610 - GC - 27-04-2006 : New Field NOTDSReportFlag
		var field=document.getElementById("NOTDSReportFlag")
		if (field) {
			field.checked=false;
			if (temp[4]=="Y") field.checked=true;
		}
		// End Log 58610		
	}
	return false;
}

function NOTNotesOnBlur() {
	var obj=document.getElementById("NOTNotes");
	var objDesc=document.getElementById("NOTDesc");
	if (obj && objDesc) {
		objDesc.value = obj.value;
	}
	//alert("in plain text.., hidden is: " + obj.value);
}

var objBlur=document.getElementById("NOTNotes");
if (objBlur) objBlur.onblur=NOTNotesOnBlur;
document.body.onload = DocumentLoadHandler;