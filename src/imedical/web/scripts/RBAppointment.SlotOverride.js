// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
var f=document.getElementById("fRBAppointment_SlotOverride");

function DocumentLoadHandler() {
	//var obj=document.getElementById("SGDesc")
	//if (obj) obj.onblur=SGDescBlurHandler;

	var obj=document.getElementById("Update")
	if (obj) obj.onclick=UpdateClickHandler;

	var obj=document.getElementById("Add")
	if (obj) obj.onclick=AddClickHandler;

	checkRowDisabled();
}

function checkRowDisabled() {
	var tbl=document.getElementById("tRBAppointment_SlotOverride");
	for (var i=1;i<tbl.rows.length;i++) {
		if (f.elements['DayOverridez'+i].value=='N') {
			tbl.rows[i].className="clsRowDisabled";
		}
	}
	return;
}

function AddClickHandler() {
	var obj=document.getElementById("load")
	if (obj) load=obj.value;

	var obj=document.getElementById("SOVNumberOfServices")
	if (obj) NoServ=obj.value;

	if (parseInt(NoServ)>parseInt(load)) {
		alert(t['ServOverLoadLevel1'] + " (" + NoServ + ") " + t['ServOverLoadLevel2'] + " (" + load + ").");
		return 0;
	}
	return Add_click();
}

function UpdateClickHandler() {
	// SB 09/01/02: The following reload needs to be used so that the workload list refreshes cleanly
	//window.opener.location.reload()
	// SB 19/04/02: Do not change the following line of code without asking me first.
	// SB 01/05/02: Modified.
	if (top.window.opener.top.frames["TRAK_main"]) {
		top.window.opener.top.frames["TRAK_main"].treload('websys.csp')
	} else {
		if (window.opener) window.opener.treload('websys.csp')
	}
	//window.opener.treload('websys.csp');
	//return Update_click();
}

function DocumentUnloadHandler() {
	//window.opener.location.reload()
}
//JW:19/4/02 removed call to this OnBlurHandler, as it was causing errors.
function SGDescBlurHandler() {
	var tbl=document.getElementById("tRBAppointment_SlotOverride")
	var clm=document.getElementById("SOV_ServiceGroup_DRz1")
	var val=document.getElementById("SGDesc")
	if (tbl && clm && val) {
		var val=val.value;
		for (var i=0;i<tbl.rows.length;i++) {
			if (document.getElementById("SOV_ServiceGroup_DRz"+i)) {
				if (val==document.getElementById("SOV_ServiceGroup_DRz"+i).innerText) tbl.rows[i].click();
			}
		}
	}
}
function SelectRowHandler() {
	var row=selectedRowObj.rowIndex;
	var obj=document.getElementById("SOVNumberOfServices")
	if (obj) obj.value=document.getElementById("SOV_NumberOfServicesz"+row).innerText;
	var obj=document.getElementById("SGDesc")
	if (obj) obj.value=document.getElementById("SOV_ServiceGroup_DRz"+row).innerText;
	var obj=document.getElementById("SOVMessage")
	if (obj) obj.value=document.getElementById("SOV_Messagez"+row).innerText;
	var obj=document.getElementById("SOVRowID")
	if (obj) obj.value=document.getElementById("IDz"+row).value;
}

document.body.onload = DocumentLoadHandler;
document.body.onunload = DocumentUnloadHandler;