// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

//KK 15.01.04 L:39410
function EXTHospitalDRLookUpSelect(str) {
	//alert(str);
	var lu = str.split("^");
	var obj;
	// Set Hospital Id to hidden field
	var obj=document.getElementById("HospitalID")
	if (obj) obj.value = lu[1]
}
function EXTCTLOCDRLookUpSelect(str) {
	//alert(str);
	var lu = str.split("^");
	var obj;
	// Set Hospital Id to hidden field
	var obj=document.getElementById("HospitalID");
	if (obj) obj.value = lu[7];
	var obj=document.getElementById("EXTHospitalDR");
	if (obj) obj.value = lu[4];

}

function HospitalBlurHandler() {
    var obj=document.getElementById("EXTHospitalDR");
    var objid=document.getElementById("HospitalID");
    if ((obj)&&(obj.value=="")) objid.value="";
}

function DocumentLoadHandler() {
    var obj=document.getElementById("EXTHospitalDR");
    if (obj) obj.onblur=HospitalBlurHandler;
}

document.body.onload=DocumentLoadHandler;