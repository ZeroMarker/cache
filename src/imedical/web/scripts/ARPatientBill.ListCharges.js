// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
//KK 7/Apr/2003 Log 32814

function ListBodyLoadHandler() {
	try{AddChargesBodyLoadHandler();} catch(e) {}
	ListChargesStatusCheck();
	var objTable=document.getElementById("tARPatientBill_ListCharges"); 
	if (objTable) objTable.onclick=TableClickHandler;
}

//KK 02/10/03 L:38360
function ListChargesStatusCheck(){
	var tbl=document.getElementById("tARPatientBill_ListCharges");
	if (tbl) {
		//for every row of the table
		for (var i=1; i<tbl.rows.length; i++) {
			var StatusCol=document.getElementById("statusz"+i);
			var BillStatus=document.getElementById("BillStatusz"+i);  // log 43623 16.07.04 AJIW

			if (StatusCol && BillStatus) {
				if  ( ((StatusCol.value!="")&&(StatusCol.value=="D")) || (BillStatus.value=="P")) {
					var objDate=document.getElementById("tdatez"+i);
					if (objDate) {
						objDate.disabled=true;
						objDate.onclick=LinkDisable;
					}
				}
			}
		}
	}
}

function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if (el.disabled) {
		return false;
	}
	return true;
}

function TableClickHandler(e) {
	var patientid="",epid="",id="",rowid="";
	var patientid=document.getElementById("PatientID");
	if (patientid) patientid=patientid.value;
	var epid=document.getElementById("EpisodeID");
	if (epid) epid=epid.value;
   	var eSrc = websys_getSrcElement(e);
	if (parent.frames["Charges_edit"]) {
		if (eSrc.tagName=="IMG") { //tagnames like TD, TH etc...
			eSrc=websys_getParentElement(eSrc)
		}
		if (eSrc.tagName=="A") {
			if (eSrc.id.indexOf("tdate")==0) { 
				eSrc.target = "Charges_edit"; //frame target
				var currentlink=eSrc.href.split("?");
				eSrc.href = "websys.default.csp?WEBSYS.TCOMPONENT=ARPatientBill.EditCharges&" + currentlink[1];
				eSrc=websys_getParentElement(eSrc);
				if (selectedRowObj!=eSrc) SelectRow();
			}
		}
	}
}

document.body.onload=ListBodyLoadHandler;
