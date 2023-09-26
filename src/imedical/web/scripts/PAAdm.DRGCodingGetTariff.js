// Copyright (c) 2000 TRAK Systems Pty. ALL RIGHTS RESERVED. 

// SA 10.07.02 - log 24621: Component created for implementation of DRG Inquiry.
// When DRG Code is returned from DRG grouper, the code is required to display
// the tariff codes against the returned DRG code. This component should only 
// ever be run from the hidden frame, to retrieve the relevant tariff fields from 
// the back-end. This javascript code will now copy all codes to their corresponding 
// fields in this component to PAAdm.DRGCoding

var objParent=parent.frames[1];
//KK 05/10/2004 L:44384
var frmTrakmain = window.parent.frames["TRAK_main"];
if (frmTrakmain) {
	var frmDRGCodingDisplay = frmTrakmain.frames["PAAdmDRGCodingDisplay"];
	var frmDrgcoding = frmTrakmain.frames["PAAdmDRGCoding"];
}


function DocumentLoadHandler(e) {
	
	//alert("PAAdm.DRGCodingGetTariff Document Handler loaded");
	PopulateParentFrameFields();

}

function PopulateParentFrameFields() {

	//alert (objParent.name);
	//if (!objParent) return false;	
	if (!frmDrgcoding) return false;

	CopySingleFieldToParent("TARClass1DR");
	CopySingleFieldToParent("TARClass2DR");
	CopySingleFieldToParent("TARClass3DR");
	CopySingleFieldToParent("TARDayHospitalTariff");
	CopySingleFieldToParent("TARDRGTypeDR");
	CopySingleFieldToParent("TARExtraTariffPerDay");
	CopySingleFieldToParent("TARKind");
	CopySingleFieldToParent("TARLimitDay");
	CopyCheckBoxFieldToParent("TARMedTarget");	//TARMedTarget is a check box field
	CopySingleFieldToParent("TARNormalTariff");
	CopySingleFieldToParent("TAROneDayTariff");
	CopySingleFieldToParent("TARReabilitaionExtraTariffPerDay");
	CopySingleFieldToParent("TARReabilitaionLimitDay");
	CopySingleFieldToParent("TARReabilitationTariff");
	CopySingleFieldToParent("TARSameDayOneDay");

}

function CopySingleFieldToParent(fldname) {

	var obj=document.getElementById(fldname);
	//var objPar=objParent.document.getElementById(fldname);
	if (frmDrgcoding) var objPar=frmDrgcoding.document.getElementById(fldname);
	if (frmDRGCodingDisplay) var objParDisp=frmDRGCodingDisplay.document.getElementById("T"+fldname);

	if ((obj)&&(objPar)) {
		if (objPar.tagName=="LABEL") {
			objPar.innerText=obj.value;
			if (objParDisp) objParDisp.innerText=obj.value;
		} else {
			objPar.value=obj.value;
			if (objParDisp) objParDisp.value=obj.value;
		}
	}
}

function CopyCheckBoxFieldToParent(fldname) {

	var obj=document.getElementById(fldname);
	//var objPar=objParent.document.getElementById(fldname);
	if (frmDrgcoding) var objPar=frmDrgcoding.document.getElementById(fldname);

	if ((obj)&&(objPar)) {
		if (obj.checked) objPar.checked=true;
		if (!(obj.checked)) objPar.checked=false;
	}
}

document.body.onload=DocumentLoadHandler;

