// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var OldHospitalOnChange;
var objHospital=document.getElementById("Hospital");
var objEDLB=document.getElementById("EndDateLastBatch");
var objEEDF=document.getElementById("EXTRESISDateFrom");
var objLBNI=document.getElementById("LastBatchNumberInt");
var objLBNE=document.getElementById("LastBatchNumberESIS");

function DocumentLoadHandler() {

	if (objHospital) {
		OldHospitalOnChange=objHospital.onchange;
		objHospital.onchange=HospitalChangeHandler;
	}

}

function HospitalChangeHandler() {

	if (objEDLB) objEDLB.innerText="";
	if (objLBNI) objLBNI.innerText="";
	if (objLBNE) objLBNE.innerText="";
	if (objEEDF) objEEDF.value="";

	if (typeof OldHospitalOnChange!="function") OldHospitalOnChange=new Function(OldHospitalOnChange);
	return OldHospitalOnChange();

}

function HospitalLookUpHandler(str) {
	var lu = str.split("^");
	//alert(str);

	if ((objHospital)&&(lu[0])&&(lu[0]!="")) objHospital.value=lu[0];
	if ((objEDLB)&&(lu[3])&&(lu[3]!="")) objEDLB.innerText=lu[3];
	if ((objEEDF)&&(lu[4])&&(lu[4]!="")) objEEDF.value=lu[4];
	if ((objLBNE)&&(lu[5])&&(lu[5]!="")) objLBNE.innerText=lu[5];
	if ((objLBNI)&&(lu[6])&&(lu[6]!="")) objLBNI.innerText=lu[6];
}



document.body.onload=DocumentLoadHandler;