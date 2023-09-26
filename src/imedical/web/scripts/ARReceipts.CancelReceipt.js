// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
//KK 28/Apr/2003 Log 30029
//alert("js loaded");

var objUpdate=document.getElementById("update1");
if (objUpdate) objUpdate.onclick=UpdateClickHandler;

// Override in Custom Script if other behaviour is required
function ValidateCancelation() {
	return true;
}

function UpdateClickHandler(){
	//Log 46809
	if (!ValidateCancelation()) return false;
	
	// SA 30.4.03 - 32817: If payment allocation exists for bill which hasn't been receipted, 
	// cancelling the receipt will cause the "Amount Previously Allocated" in ARReceipts.ListPayAlloc 
	// to become incorrect. Will need to clear paym allocs if the receipt is cancelled. Confirm with user first.
	var objPaymAllocExists=document.getElementById("PaymAllocExists");
	if ((objPaymAllocExists)&&(objPaymAllocExists.value=="Y")) {
		var bConfirm=1;
		bConfirm=confirm(t['PAYM_ALLOC_EXISTS']+"\n"+t['CONTINUE']);
		if (!bConfirm) {
			return false;
		}
	}
	
	//KK 24/Apr/2003 Log 33029
	var win=window.opener.parent.frames[1];
	if (win) {
		var formtot=win.document.forms['fARPatientBill_ListTotals'];
		if (formtot) {
			formtot.elements["RefreshCSP"].value="1";
			//alert("value set");
		}
	}
	update1_click();
}
