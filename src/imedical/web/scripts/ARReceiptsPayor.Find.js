// Copyright (c) 2003 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var objInqTypeInvoice = document.getElementById("InqTypeInvoice");
var objInqTypeReceipt = document.getElementById("InqTypeReceipt");
var objFind = document.getElementById("Find");
var objPrinted = document.getElementById("Printed");

function BodyLoadHandler() {
	if (objInqTypeInvoice) {
		objInqTypeInvoice.onclick = InqTypeInvoiceCheck;
	}
	if (objInqTypeReceipt) {
		objInqTypeReceipt.onclick = InqTypeReceiptCheck;
		objInqTypeReceipt.checked = true;
		if (objInqTypeInvoice) objInqTypeInvoice.disabled=true;
		if (objPrinted) objPrinted.disabled=true;
	}
	if (objFind) objFind.onclick = FindClickHandler;
}

function InqTypeInvoiceCheck() {
	if ((objInqTypeInvoice.checked) && (objInqTypeReceipt)) {
		objInqTypeReceipt.disabled=true;
		if (objPrinted) objPrinted.disabled=false;
	}
	else if (objInqTypeReceipt) {
		objInqTypeReceipt.disabled=false;
	}
}

function InqTypeReceiptCheck() {
	if ((objInqTypeReceipt.checked) && (objInqTypeInvoice)) {
		objInqTypeInvoice.disabled=true;
		if (objPrinted) objPrinted.disabled=true;
	}
	else if (objInqTypeInvoice) {
		objInqTypeInvoice.disabled=false;
	}
}

function FindClickHandler() {
	if (objInqTypeInvoice && (objInqTypeInvoice.checked==false)) {
		if (objInqTypeReceipt && (objInqTypeReceipt.checked==false)) {
			alert(t['SelectSearchTypeFirst']);
			return;
		}
	} 
	Find_click();
}

document.body.onload=BodyLoadHandler;
