// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
//log 60114 BoC 28-08-2006

function AdminStatusLookUpHandler(str) {
	var lu=str.split("^");
	var STATDRobj=document.getElementById("STATDR");
	if (STATDRobj) STATDRobj.value=lu[1];
}

function ExecutedByLookUpHandler(str) {
	var lu=str.split("^");
	var CTPCPDRobj=document.getElementById("CTPCPDR");
	if (CTPCPDRobj) CTPCPDRobj.value=lu[1];
}

function updatehandler() {
	var tbl=document.getElementById("tOEOrdExec_Multiple_Edit");
	if (tbl) {
		for (i=1;i<tbl.rows.length ;i++ ) {
			var OEOREQtyOrd=document.getElementById("PhQtyOrdz"+i);
			var OEOREQtyAdmin=document.getElementById("QuantityToAdministerz"+i);
			if (OEOREQtyAdmin && (parseInt(OEOREQtyAdmin.value)>parseInt(OEOREQtyOrd.value))) {
			alert (t['ORDDOSE']);
			return false;
			}
		}
	}
	return update1_click();
}

/*
 * Simple function which inserts the OverSeer User's code rather than
 * Description
 */
function UserLookUpSelect(str) {
	var userLookUpVals = str.split("^");
	document.getElementById("OverseerUser").value=userLookUpVals[2];
}

var updateobj=document.getElementById("update1");
if (updateobj) updateobj.onclick=updatehandler;