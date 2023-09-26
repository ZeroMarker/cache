// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var OldHospitalOnChange;
var objLastExtMonth=document.getElementById("LastExtractMonth");
var objLastExtYear=document.getElementById("LastExtractYear");
var objHospital=document.getElementById("Hospital");

function DocumentLoadHandler() {

	if (objHospital) {
		OldHospitalOnChange=objHospital.onchange;
		objHospital.onchange=HospitalChangeHandler;
	}

}

function HospitalChangeHandler() {

	if (objLastExtMonth) objLastExtMonth.innerText="";
	if (objLastExtYear) objLastExtYear.innerText="";

	if (typeof OldHospitalOnChange!="function") OldHospitalOnChange=new Function(OldHospitalOnChange);
	return OldHospitalOnChange();

}

function HospitalLookUpHandler(str) {
	var lu = str.split("^");

	if ((objHospital)&&(lu[0])&&(lu[0]!="")) objHospital.value=lu[0];
	if ((objLastExtMonth)&&(lu[3])&&(lu[3]!="")) objLastExtMonth.innerText=lu[3];
	if ((objLastExtYear)&&(lu[4])&&(lu[4]!="")) objLastExtYear.innerText=lu[4];

}



document.body.onload=DocumentLoadHandler;