// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

// Script created for pharmacy returns screens.
// makes sure no invalid data in fields on update.
function BodyLoadHandler(){
	var objUpdate=document.getElementById("Update");
	if (objUpdate) objUpdate.onclick=CheckFields;

	var eTABLE=document.getElementById("tPharmacy_ReturnPart_Edit");
	if (document.getElementById("ByPass") && (document.getElementById("ByPass").value=="Y")) { var bypass="Y"; } else { var bypass="N"; }

	if (eTABLE && (bypass=="Y")){
		for (var i=1; i<eTABLE.rows.length; i++) {
			var obj=document.getElementById("locReturnz"+i);
			if (obj) { 
				obj.disabled=true;
				obj.style.visibility="hidden";
				document.getElementById("lt2017ilocReturnz"+i).disabled=true;
				document.getElementById("lt2017ilocReturnz"+i).style.visibility="hidden";
			}
		}
	}
}

function CheckFields(){
	var oktosave=1
	var objReason=document.getElementById("ReasonForRefund");
	if (objReason && (objReason.className=='clsInvalid')) {
		oktosave=0;
		alert(t['ReasonForRefund'] + " " + t['INVALID']);
	}
	var eTABLE=document.getElementById("tPharmacy_ReturnPart_Edit");
	if ((oktosave==1) && eTABLE){
		for (var i=1; i<eTABLE.rows.length; i++) {
			var objQty=document.getElementById("ReturnQtyz"+i);
			// Qty too large already checked in PAQue1
			if ((objQty && (objQty.value!="")) && ((isNaN(objQty.value))||(objQty.value<0))) {
				oktosave=0;
				alert(t['RETURNQUAN'] + " " + t['INVALID']);
			}
		}
	}

	if (oktosave==1) return Update_click();
}


document.body.onload = BodyLoadHandler;