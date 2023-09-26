// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var OldHospitalOnChange;
var objPrint=document.getElementById("Print");
var objHospital=document.getElementById("Hospital");
var objLastBatchStart=document.getElementById("LastBatchStart");
var objLastBatchClose=document.getElementById("LastBatchClose");
var objLastBatchCloseHidden=document.getElementById("LastBatchCloseHidden");
var objCutoffDate=document.getElementById("CutoffDate");
var objCutoffDateHidden=document.getElementById("CutoffDateHidden");
var objDateTo=document.getElementById("DateTo");

function DocumentLoadHandler() {

	if (objPrint) objPrint.onclick=PrePrintCheck;

	if (objHospital) {
		OldHospitalOnChange=objHospital.onchange;
		objHospital.onchange=HospitalChangeHandler;
	}

	// If returning from erred method call, copy hidden fields back 
	// to display only fields.
	if ((objCutoffDate)&&(objCutoffDateHidden)) {
		if (objCutoffDateHidden.value!="") {
			objCutoffDate.value=objCutoffDateHidden.value;
		}
	}

	if ((objLastBatchClose)&&(objLastBatchCloseHidden)) {
		if (objLastBatchCloseHidden.value!="") {
			objLastBatchClose.value=objLastBatchCloseHidden.value;
		}
	}

}

function PrePrintCheck() {

	// Check that if a report number has been entered that all
	// corresponding Month/Year From/To fields have been entered

	var bErr=false;

	for (var i=1; i<=5; i++) {
		if ((document.getElementById("ReportNum"+i))&&(document.getElementById("ReportNum"+i).value!="")) {

			if ((document.getElementById("MonthFrom"+i))&&(document.getElementById("MonthFrom"+i).value=="")) bErr=true;
			if ((document.getElementById("YearFrom"+i))&&(document.getElementById("YearFrom"+i).value=="")) bErr=true;
			if ((document.getElementById("MonthTo"+i))&&(document.getElementById("MonthTo"+i).value=="")) bErr=true;
			if ((document.getElementById("YearTo"+i))&&(document.getElementById("YearTo"+i).value=="")) bErr=true;

			if (bErr) {
				alert(t['MISSING_MONTH_YEAR']);
				return false;
			}
		}
	}


	// Copy display only fields to hidden fields so they are picked up by cache method.
	if ((objCutoffDate)&&(objCutoffDateHidden)) {
		if (objCutoffDate.value!="") {
			objCutoffDateHidden.value=objCutoffDate.value;
		} 
	}

	if ((objLastBatchClose)&&(objLastBatchCloseHidden)) {
		if (objLastBatchClose.value!="") {
			objLastBatchCloseHidden.value=objLastBatchClose.value;
		}
	}

	Print_click();
}

function HospitalChangeHandler() {
	
	if (objLastBatchStart) objLastBatchStart.value="";
	if (objLastBatchClose) objLastBatchClose.innerText="";

	if (typeof OldHospitalOnChange!="function") OldHospitalOnChange=new Function(OldHospitalOnChange);
	return OldHospitalOnChange();

}

function HospitalLookUpHandler(str) {
	var lu = str.split("^");

	//alert(str);

	//if ((objHospital)&&(lu[0])&&(lu[0]!="")) objHospital.value=lu[0];
	if ((objLastBatchStart)&&(lu[5])&&(lu[5]!="")) objLastBatchStart.value=lu[5];
	if ((objLastBatchClose)&&(lu[6])&&(lu[6]!="")) objLastBatchClose.innerText=lu[6];
	if ((objLastBatchCloseHidden)&&(lu[6])&&(lu[6]!="")) objLastBatchCloseHidden.innerText=lu[6];		// cjb 04/11/2004 47312 - need to set up the hidden field too as this is used in web.PAExtract.RunPRS2
	AustinHospitalHandler();
	//alert("objLastBatchStart="+objLastBatchStart.value);
	//alert("objLastBatchClose="+objLastBatchClose.value);
	
}

function AustinHospitalHandler(){
	//dummy function - function AustinHospitalHandler in custom scripts - austin
	return true;
}


document.body.onload=DocumentLoadHandler;