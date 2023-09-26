// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function DocumentLoadHandler() {
	assignClickHandler();

	obj=document.getElementById("new1")
	if (obj) obj.onclick=ClearFields;
}

function ClearFields() {
	var field=document.getElementById("HistID")
	if (field) field.value="";

	var field=document.getElementById("PRESIDesc")
	if (field) field.value="";

	var field=document.getElementById("PRESIBodyPartSymSubsDR")
	if (field) field.value="";

	var field=document.getElementById("PRESIBodyPartsDR")
	if (field) field.value="";

	var field=document.getElementById("PRESIBodyPartsSympDR")
	if (field) field.value="";

	var field=document.getElementById("PRESIDateOnset")
	if (field) field.value="";

	var field=document.getElementById("PRESIEndDate")
	if (field) field.value="";

	var field=document.getElementById("PRESIICDCodeDR")
	if (field) field.value="";

	var field=document.getElementById("PRESIDiagnosStatusDR")
	if (field) field.value="";

	// Log 58610 - GC 20/04/2006 : DS Report Flag is a new field on "edit".
	var field=document.getElementById("PRESIDSReportFlag");
	if ( field ) field.checked=false;
	// end Log 58610

	return false;
}

function assignClickHandler() {
	var tbl=document.getElementById("tepr_HistDiagCurr");
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

		var field=document.getElementById("HistID")
		if (field) field.value=temp[0];

		var field=document.getElementById("PRESIDesc")
		if (field) field.value=temp[1];

		var field=document.getElementById("PRESIICDCodeDR")
		if (field) field.value=temp[2];

		var field=document.getElementById("PRESIDateOnset")
		if (field) field.value=temp[3];

		var field=document.getElementById("PRESIBodyPartsDR")
		if (field) field.value=temp[4];

		var field=document.getElementById("PRESIBodyPartsSympDR")
		if (field) field.value=temp[5];

		var field=document.getElementById("PRESIBodyPartSymSubsDR")
		if (field) field.value=temp[6];

		var field=document.getElementById("PRESIEndDate")
		if (field) field.value=temp[7];

		var field=document.getElementById("PRESIDiagnosStatusDR")
		if (field) field.value=temp[8];

		// Log 58610 - GC 20/04/2006 : DS Report Flag is a new field on "edit".
		var field=document.getElementById("PRESIDSReportFlag");
		if ( field ) {
			field.checked=false;
			if (temp[9]=="Y") field.checked=true;
		}
		// end Log 58610

	}
	return false;
}

function  problemFillBodyPart( str )
{
	var lu = str.split("^");

	var field=document.getElementById("PRESIBodyPartsDR")
	if (field) field.value=lu[2];

	var field=document.getElementById("PRESIBodyPartsSympDR")
	if (field) field.value=lu[0];
}

function  subproblemFillProblemBodyPart( str )
{
	var lu = str.split("^");

	var field=document.getElementById("PRESIBodyPartsDR")
	if (field) field.value=lu[2];

	var field=document.getElementById("PRESIBodyPartsSympDR")
	if (field) field.value=lu[1];

	var field=document.getElementById("PRESIBodyPartSymSubsDR")
	if (field) field.value=lu[0];
}

function LookUpDiagnosCurr(str) {
	var objb=document.getElementById("PRESIICDCodeDR");
	if (objb) objb.value="";

	var ary=str.split("^");
	var ary2=ary[0].split(" | ");
	var obj=document.getElementById("MRDIAICDCodeDR");
	if (objb) objb.value=ary2[0];
}



document.body.onload = DocumentLoadHandler;


