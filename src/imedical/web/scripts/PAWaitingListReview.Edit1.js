// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 


function BodyLoadHandler() {
	
	// SA 9.7.02: Log 26442. This component is usually loaded with component 
	// PAWaitingListReview.List whose onload overwrites any onload event called
	// via a custom js. PAWaitingListReview.List will call this onload. Will now
	// in turn will try CustomDocumentLoadHandler.
	try {CustomDocumentLoadHandler();} catch(e) {} 

	obj=document.getElementById('update1')
	if (obj) obj.onclick = UpdateHandler;
	//alert("Edit");
	var obj;
	obj=document.getElementById('REVPatientRespond');	
	if (obj) obj.onchange=PatientRespondChangeHandler;
}

function StatusLookup(str) {
 	var lu = str.split("^");
	var obj;
	obj=document.getElementById("WLRSTDesc");
	if (obj) obj.value = lu[0]
	if (lu[0]="Patient Response") {
		obj=document.getElementById("REVPatientRespond");
		//alert(obj.value);
		if (obj) obj.value = "on"
		//alert(obj.value);
	} else {
		obj=document.getElementById("REVPatientRespond");
		if (obj) obj.value = "off"
	}
}


function PatientRespondChangeHandler(e) {
	var obj1;
	var obj2;
	obj1=document.getElementById("REVPatientRespond");
	obj2=document.getElementById("REVRevStatusDR");
	//alert(obj1.value);
	if (obj1.value="on") {
		obj2.value="Patient Response";
	} else {
		obj2.value="";
	}
	
}


function labelMandatory(fld) {
	var lbl = document.getElementById('c' + fld) 
	if (lbl) {
		lbl=lbl.className = "clsRequired";
	}
}

function labelNormal(fld) {
	var lbl = document.getElementById('c' + fld) 
	if (lbl) {
		lbl=lbl.className = "";
	}
} 

function UpdateHandler() {
	return update1_click();
	if (self == top) {
		var win=window.opener;
		if (win) {
			win.treload('websys.csp');
		}
	}
}


//SA 19.02.02: This code is NEVER to be used.   
//It will give no indication that validation has failed.
//function BodyUnloadHandler(e) {
//	if (self==top) {
//		if (window.opener) {
//			window.close()	
//		}	
//	}
//}


//document.body.onload=Init
document.body.onload=BodyLoadHandler;
//document.body.onunload=BodyUnloadHandler;







