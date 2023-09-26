// Copyright (c) 2006 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var btnUpdate = document.getElementById("Update");

//Log 62387 - 02.02.2007 
var btnDone = document.getElementById("Done");

function LoadHandler() {

	CoreLoadHandler(); //ARPatBill.DiscAllocCore.js

	var docDiscAlloc;
	if (parent.frames["DiscAlloc"]) docDiscAlloc = parent.frames["DiscAlloc"].document;

	var tbl = document.getElementById("tARPatBill_DiscAllocByPercent");
	for (i = 1; i<tbl.rows.length; i++) {
		var rowElem = document.getElementById("AllocatePercentagez"+i);
		if (rowElem) rowElem.onclick= AllocatePercentageClickHandler;
		if (docDiscAlloc) {
			obj = docDiscAlloc.getElementById("ByPercentage");
			if (obj&&obj.value!="") rowElem.disabled=false;
		}
	}

	if (btnUpdate) {
		btnUpdate.onclick = UpdateDisable;
		btnUpdate.disabled=true;
	}
	
	//Log 62387 - 02.02.2007 
	if (btnDone) {
		btnDone.onclick = DoneClickHandler;
	}
	//End Log 62387	

	if (docDiscAlloc) {
		var objPercent = docDiscAlloc.getElementById("ByPercentage");
		var objDisc=document.getElementById("DiscPercentage");
		if (objPercent&&objPercent.value!="") objDisc.value=objPercent.value;
	}
}

function AllocatePercentageClickHandler(evt) {

	var el = websys_getSrcElement(evt);

	var docDiscAlloc;
	if (parent.frames["DiscAlloc"]) docDiscAlloc = parent.frames["DiscAlloc"].document;
	if (docDiscAlloc) {
		objPercent= docDiscAlloc.getElementById("ByPercentage");

		if (objPercent && objPercent.value!="") {
			if (btnUpdate) {		//Log 61346 - 30/10/2006
				btnUpdate.onclick = UpdateClickHandler;
				btnUpdate.disabled=false;
			}	
			
			//Log 62387 - 02.02.2007 
			if (btnDone) btnDone.disabled=true;
			//End Log 62387	
		}
		else {
			if (btnUpdate) {		//Log 61346 - 30/10/2006
				btnUpdate.onclick = UpdateDisable;
				btnUpdate.disabled=true;
			}	
			
			//Log 62387 - 02.02.2007 
			if (btnDone) btnDone.disabled=false;
			//End Log 62387		
		}
	}
}

function Reload() {

	var url = "websys.default.csp?WEBSYS.TCOMPONENT=ARPatBill.DiscAllocByPercent&ClearAlloc=Y&CONTEXT="+session['CONTEXT'];

	document.getElementById("PatientBanner").value=""; //no patient banner

	document.fARPatBill_DiscAllocByPercent.target="DiscAllocList";
	document.fARPatBill_DiscAllocByPercent.action=url;
	document.fARPatBill_DiscAllocByPercent.submit();
}

function UpdateClickHandler() {

	var tbl = document.getElementById("tARPatBill_DiscAllocByPercent");
	var obj = document.getElementById("DiscAllocRowIDs");
	
	for (i = 1; i<tbl.rows.length; i++) {
		obj.value += document.getElementById("SubRowsz"+i).value + "^";
	}

	var docDiscAlloc;
	if (parent.frames["DiscAlloc"]) docDiscAlloc = parent.frames["DiscAlloc"].document;
	if (docDiscAlloc) {
		objPercent= docDiscAlloc.getElementById("ByPercentage");
		//DiscPercentage must be set in order for everything to work
		document.getElementById("DiscPercentage").value=objPercent.value;
	}

	document.fARPatBill_DiscAllocByPercent.target="_parent";

	return Update_click(); // default call
}

// Log 62387 - 02.02.2007
function DoneClickHandler() {

	var tbl = document.getElementById("tARPatBill_DiscAllocByPercent");
	var obj = document.getElementById("DiscAllocRowIDs");
	
	for (i = 1; i<tbl.rows.length; i++) {
		obj.value += document.getElementById("SubRowsz"+i).value + "^";
	}

	var docDiscAlloc;
	if (parent.frames["DiscAlloc"]) docDiscAlloc = parent.frames["DiscAlloc"].document;
	if (docDiscAlloc) {
		objPercent= docDiscAlloc.getElementById("ByPercentage");
		//DiscPercentage must be set in order for everything to work
		document.getElementById("DiscPercentage").value=objPercent.value;
	}

	document.fARPatBill_DiscAllocByPercent.target="_parent";

	return Done_click(); // default call
}

document.body.onload=LoadHandler;
