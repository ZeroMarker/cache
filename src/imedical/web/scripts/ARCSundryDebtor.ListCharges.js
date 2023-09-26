// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function ListBodyLoadHandler() {
	try{AddChargesBodyLoadHandler();} catch(e) {}
	ListChargesStatusCheck();
	var objTable=document.getElementById("tARCSundryDebtor_ListCharges");
	if (objTable) objTable.onclick=TableClickHandler;
}

function ListChargesStatusCheck(){
	var tbl=document.getElementById("tARCSundryDebtor_ListCharges");
	if (tbl) {
		for (var i=1; i<tbl.rows.length; i++) 
		{
			var objDate=document.getElementById("tdatez"+i);
			var StatusCol=document.getElementById("statusz"+i);
			if (StatusCol) {
				var val=StatusCol.innerText;
				if  (val!="" && val=="D" && objDate) {
					objDate.disabled=true;
					objDate.onclick=LinkDisable;
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
	var patientid=document.getElementById("SundryID");
	if (patientid) patientid=patientid.value;
	var epid=document.getElementById("OrderID");
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
