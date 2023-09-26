// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function DocumentLoadHandler() {
	assignClickHandler();
	
	var field=document.getElementById("ALMClosedFlag");
	var chkobj=document.getElementById("ClosedOn");
	if (!field) chkobj.value="N";

	obj=document.getElementById("new1");
	if (obj) obj.onclick=ClearFields;
}

function ClearFields() {
	var field=document.getElementById("ID");
	if (field) field.value="";
	
	var field=document.getElementById("ALMMessage");
	if (field) field.value="";
	
	var field=document.getElementById("ALMAlertDR");
	if (field) field.value="";
	
	var field=document.getElementById("AlertCat");
	if (field) field.value="";

	var field=document.getElementById("ALMOnsetDate");
	if (field) field.value="";

	var field=document.getElementById("ALMStatus");
	if (field) field.value="";

	var field=document.getElementById("StatusUpdate");
	if (field) field.value="";

	var field=document.getElementById("ALMExpiryDate");
	if (field) field.value="";

	var field=document.getElementById("ALMClosedFlag");
	if (field) field.checked=false;

	// Log 58610 - GC - 27-04-2006 : New field ALMDSReportFlag
	var field=document.getElementById("ALMDSReportFlag");
	if (field) field.checked=false;
	// end Log 58610

	return false;
}

function assignClickHandler() {
	var tbl=document.getElementById("tepr_HistAlerts");
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
		
		var field=document.getElementById("ID");
		if (field) field.value=temp[0];

		var field=document.getElementById("ALMClosedFlag");
		if (field) field.checked=false;
		if ((field) && (temp[1]=="Y")) field.checked=true;

		var field=document.getElementById("ALMAlertDR");
		if (field) field.value=temp[2];
	
		var field=document.getElementById("AlertCat");
		if (field) field.value=temp[4];

		var field=document.getElementById("ALMOnsetDate");
		if (field) field.value=temp[5];

		var field=document.getElementById("StatusUpdate");
		if (field) field.value=temp[6];

		var field=document.getElementById("ALMMessage");
		if (field) field.value=temp[7];

		var field=document.getElementById("ALMStatus");
		if (field) field.value=temp[8];

		var field=document.getElementById("ALMExpiryDate");
		if (field) field.value=temp[9];

		// Log 58610 - GC - 27-04-2006 : New field ALMDSReportFlag
		var field=document.getElementById("ALMDSReportFlag");
		if (field) {
			field.checked=false;
			if (temp[10]=="Y") field.checked=true
		}
		// End Log 58610

	}
	return false;
}

function AlertLookUpHandler(str) {
 	var lu = str.split("^");
	
	var alertdesc=document.getElementById('ALMAlertDR');
	var alertcat=document.getElementById('AlertCat');
	if (alertdesc) {
		alertdesc.value=lu[0];
		}
	if (alertcat) {
		alertcat.value=lu[3];
	}
}

document.body.onload = DocumentLoadHandler;


