// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 


function BodyLoadHandler() {

	var objUpdate=document.getElementById("Update");

	if (objUpdate) objUpdate.onclick=CancelInvoice;
	if (tsc['Update']) websys_sckeys[tsc['Update']]=CancelInvoice;
}

// Override in Custom Script if other behaviour is required
function ValidateCancelation() {
	return true;
}

function CancelInvoice() {
	if (!ValidateCancelation()) return false;
	
	//Log 64703 - 31.10.2007 - warn if there are linked invoices. Proceed only if OK
	var objLinked=document.getElementById("checkLinked");
	if ((objLinked)&&(objLinked.value!=0)) {
		var result=(objLinked.value).split("^");
		//var invoices=objLinked.value;
		//result=result.split("^");
		var invoices=result[1];
		if (!(confirm(t['LINKED_INVOICES']+invoices+". "+t['LINKED_INVOICES2']))) {
			window.close();
			window.opener.close();
			return false;
		}	
	}
		
	Update_click();
}

document.body.onload=BodyLoadHandler;
