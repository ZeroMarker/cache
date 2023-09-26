// Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
var ALGForm=document.forms["fOEOrder_Allergy"];
var MSGForm=document.forms["fOEOrder_OEMessages"];
var QUESForm=document.forms["fOEORDER_Questions"];	
var DSSForm=document.forms["fOEOrder_DSSMessage"];	
if (DSSForm) {
	var ORObj=DSSForm.document.getElementById("DSSOverReason");
	var ORIDObj=DSSForm.document.getElementById("DSSOverReasonID");
}
function SelectReasonLookUp(str){
	var strArry=str.split("^");
	if (ORObj) ORObj.value=strArry[0];
	if (ORIDObj) ORIDObj.value=strArry[1];
	//SetSelectedRowString();
	//if (ARCIMRowIDS=="") {
	//	alert("Select an allergy before entering the reason.");
	//} else {
	if (DSSForm) {
		SetSelectedRowString();
	}
	//}
}
function UpdateClickHandler() {
	return Update_click();
	//return false;
}
function BodyLoadHandler() {
	var DSSTable=document.getElementById("tOEOrder_DSSMessage");
	if (DSSTable&&DSSForm) {
		for (var i=1; i<DSSTable.rows.length; i++) {
			var SelObj=DSSForm.document.getElementById("DSSSelectz"+i);
			var ErrObj=DSSForm.document.getElementById("ErrorTypeCodez"+i);
			if ((SelObj)&&(ErrObj)) {
				if ((ErrObj.value=="E")||(ErrObj.value=="I")) {
					SelObj.disabled = true;
				}
			}			
		}
	}
}
function SetSelectedRowString() {
	// LOG 25687 ANA This will insert the selected reason for override into the "reason "column for selected Decision Support items.
	var DSSTable=document.getElementById("tOEOrder_DSSMessage");
	var flag;
	if (DSSTable) {
		for (var i=1; i<DSSTable.rows.length; i++) {
			var SelObj=DSSForm.document.getElementById("DSSSelectz"+i);
			var arcimObj=DSSForm.document.getElementById("DSSARCIMRowIdz"+i);
			var oriObj=DSSForm.document.getElementById("DSSORIRowIdz"+i);
			var ReasObj=DSSForm.document.getElementById("DSSReasonz"+i);
			var ReasIDObj=DSSForm.document.getElementById("DSSReasonIDz"+i);
			if ((SelObj)&&(SelObj.checked)&&(ReasObj)&&(ReasIDObj)&&(ORObj)&&(ORObj.value!="")&&(ORIDObj)&&(ORIDObj.value!="")) {
				ReasObj.innerText=ORObj.value;
				ReasIDObj.value=ORIDObj.value;
				flag=true;
			}			
		}
		if (flag=="") alert("Select a Warning before entering the OverRide reason.");
		//else return;
		UnselectItems();
	}
}
function UnselectItems(){
	if (ORObj&&(ORIDObj)) {
		ORObj.value="";
		ORIDObj.value="";
	}
	var DSSTable=document.getElementById("tOEOrder_DSSMessage");
	if (DSSTable) {
		for (var i=1; i<DSSTable.rows.length; i++) {
			var SelObj=DSSForm.document.getElementById("DSSSelectz"+i);
			if (SelObj) SelObj.checked=false;
		}
	}
}
document.body.onload=BodyLoadHandler;