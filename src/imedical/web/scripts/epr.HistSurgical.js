// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function DocumentLoadHandler() {
	assignClickHandler();
	
	obj=document.getElementById("new1")
	if (obj) obj.onclick=ClearFields;
}

function ClearFields() {
	var field=document.getElementById("HistoryID")
	if (field) field.value="";
	
	var field=document.getElementById("PAoperation")
	if (field) field.value="";
	
	var field=document.getElementById("PAOnsetDate")
	if (field) field.value="";
	
	var field=document.getElementById("PAComments")
	if (field) field.value="";

	var field=document.getElementById("PALaterality")
	if (field) field.value="";
	
	// Log 58610 - GC - 24-04-2006 : New field DS Report Flag
	var field=document.getElementById("OPERDSReportFlag");
	if (field) field.checked=false;
	// End Log 58610

	return false;
}

function assignClickHandler() {
	var tbl=document.getElementById("tepr_HistSurgical");
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
		
		var field=document.getElementById("HistoryID")
		if (field) field.value=temp[0];
		
		var field=document.getElementById("PAOperation")
		if (field) field.value=temp[1];
		
		var field=document.getElementById("PAOnsetDate")
		if (field) field.value=temp[3];
		
		var field=document.getElementById("PAComments")
		if (field) field.value=temp[7];

		var field=document.getElementById("PALaterality")
		if (field) field.value=temp[8];

		// Log 58610 - GC - 24-04-2006 : New field DS Report Flag
		var field=document.getElementById("OPERDSReportFlag")
		if (field) {
			field.checked=false;
			if (temp[9] == "Y") field.checked=true
		}
		// end Log 58610		

		//alert(unescape(temp[7]));
		//alert(HIDDENType);
	}
	return false;
}


document.body.onload = DocumentLoadHandler;


