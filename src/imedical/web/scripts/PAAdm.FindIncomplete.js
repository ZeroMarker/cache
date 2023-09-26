// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function DocumentLoadHandler() {
	//alert("loaded");

	obj=document.getElementById('CurrentPat');
	if (obj) obj.onclick= CurrentPatClickHandler;
	
	obj=document.getElementById('Discharged');
	if (obj) obj.onclick= DischargedClickHandler;
	
}

function CurrentPatClickHandler() {
	obj=document.getElementById('Discharged');
	if (obj) obj.checked=false;	
	//alert("CurrentPatClickHandler");
}

function DischargedClickHandler() {
 	obj=document.getElementById('CurrentPat');
	if (obj) obj.checked=false;
	//alert("DischargedClickHandler");
}

function AdmTypeLookupSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById("selAdmType");
	if (obj) obj.value=lu[2];
}

document.body.onload = DocumentLoadHandler;
