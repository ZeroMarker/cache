// Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
//GR 15/9/03 log 37035

function DocumentLoadHandler() {
	DefaultLetterTypes("1");
	DefaultLetterTypes("2");
	DefaultLetterTypes("3");
}



function DefaultLetterTypes(num) {
	//needto check what letter types were clicked in the previous window.
	var report="ReportCode"+num
	var compid="ld1878i"
	var obj=document.getElementById(report);
	if (obj) {
		if (obj.value!="on") {
			var field="LetterType"+num+"Lookup"
			var letobj=document.getElementById(field);
			if (letobj) {
				letobj.value=""
				letobj.disabled=true
				var lookuplet=compid+field
				var lookupLetobj=document.getElementById(lookuplet);
				if (lookupLetobj) lookupLetobj.style.visibility="hidden"
				var rep="Report"+num+"Lookup"
				var repobj=document.getElementById(rep);
				if (repobj) repobj.disabled=true
				var lookupRep=compid+rep		
				var lookupRepobj=document.getElementById(lookupRep);
				if (lookupRepobj) lookupRepobj.style.visibility="hidden"
			}
		}
		obj.value=""
		// using report code fields to enable fields, need to clear them for the print button.
	}
}

function ReportLookup1Handler(str) {
	var lu = str.split("^");
	var obj=document.getElementById("Report1Lookup");
	if ((obj) && (lu[2])) obj.value=lu[2];
	var obj=document.getElementById("ReportCode1");
	if ((obj) && (lu[1])) obj.value=lu[1];
}

function ReportLookup2Handler(str) {
	var lu = str.split("^");
	var obj=document.getElementById("Report2Lookup");
	if ((obj) && (lu[2])) obj.value=lu[2];
	var obj=document.getElementById("ReportCode2");
	if ((obj) && (lu[1])) obj.value=lu[1];
}

function ReportLookup3Handler(str) {
	var lu = str.split("^");
	var obj=document.getElementById("Report3Lookup");
	if ((obj) && (lu[2])) obj.value=lu[2];
	var obj=document.getElementById("ReportCode3");
	if ((obj) && (lu[1])) obj.value=lu[1];
}

document.body.onload = DocumentLoadHandler;

