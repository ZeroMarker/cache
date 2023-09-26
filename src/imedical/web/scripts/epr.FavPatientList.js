// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
// ab 29.09.03

var ListID=document.getElementById("ListID");
if ((ListID)&&(ListID.value=="")) {
	var obj=document.getElementById("AddPatient");
	if (obj) {
		obj.disabled=true;
		obj.className="clsDisabled";
		obj.onclick=LinkDisable;
	}
}

function LinkDisable() {
	return false;
}

// select a new list from the lookup reloads the page
function NameLookup(str) {
	var lu=str.split("^");
	if (lu[1]!="") window.location="epr.favpatientlist.csp?ListID="+lu[1]+"&CONTEXT="+session["CONTEXT"];
}