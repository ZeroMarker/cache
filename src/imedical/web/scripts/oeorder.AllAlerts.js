// Copyright (c) 2003 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var AAForm=document.forms["fOEOrder_AllAlerts"];

function AlertsOnLoadHandler() {
	//alert("hello");
	var AATable=AAForm.document.getElementById("tOEOrder_AllAlerts");
	if (AATable) {
		//alert(AATable.rows.length);
		for (var i=1; i<AATable.rows.length; i++) {
			var ATObj=AAForm.document.getElementById("AlertTypez"+i);
			var ETObj=AAForm.document.getElementById("ErrorTypeDRz"+i);
			var SelObj=AAForm.document.getElementById("AlertSelectz"+i);
			//alert(ATObj.value+" "+i);
			if ((ATObj)&&(ATObj.value=="Allergy")) {
				if (SelObj) SelObj.style.visibility='visible';
			} else if ((ATObj)&&(ETObj)&&(ATObj.value=="DSSMessage")&&(ETObj.value=="W")) {
				if (SelObj) SelObj.style.visibility='visible';
			}
		}
	}
}

document.body.onload=AlertsOnLoadHandler;
