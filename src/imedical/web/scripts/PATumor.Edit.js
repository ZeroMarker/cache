// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function Init() {
	//var objTumor=document.getElementById('Tumor');
	//if (objTumor) alert("Tumor="+objTumor.value);

	//if (window.parent.opener.parent.frames["FRAMEPACancerRegEdit"]) var win = window.parent.opener.parent.frames["FRAMEPACancerRegEdit"]);

	var PatientID=""; var CancerReg="";	var Tumor="";
	var objPatientID = document.getElementById('PatientID');
	if (objPatientID) PatientID=objPatientID.value;
	var objCancerReg = document.getElementById('CancerReg');
	if (objCancerReg) CancerReg=objCancerReg.value;
	var objTumor=document.getElementById('Tumor');
	if (objTumor) Tumor=objTumor.value;

	websys_firstfocus();
	//assignClickHandler();
	if (window.name == "FRAMEPATumorEdit") document.forms['fPATumor_Edit'].elements['TFRAME'].value=window.parent.name;
	var obj;
	
	setLinks()
		
	//KK 30.01.04 L:41881
	var objDiagDate=document.getElementById('TUMFirstDiagnosisDate');
	if (objDiagDate) objDiagDate.onchange = DiagnosisDateChangeHandler;
	if ((objDiagDate)&&(objDiagDate.value=="")) {
		var objSub=document.getElementById("CTCITDesc");
		if (objSub) objSub.value="";
		var objPCode=document.getElementById("CTZIPCode");
		if (objPCode) objPCode.value="";
	}
	
	// CJB 09/12/2002
	var objBold=document.getElementById('BoldLinks');
	if (objBold) {
		var BoldLink = objBold.value.split("^");
		obj=document.getElementById('HistoryOfTreatment1');
		if ((obj) && (BoldLink[0]=="1")) obj.style.fontWeight="bold";
	}
	var objupdate=document.getElementById("update1")
	if (objupdate) objupdate.onclick=UpdateHandler;

	var objCloseWin=document.getElementById("closewindow")
	if (objCloseWin) objCloseWin.onclick=CloseWindow;
	
	// cjb 12/09/2003 39073
	obj=document.getElementById('TUMFirstAdmDate');
	if (obj) obj.onchange=CodeTableValidationDate;

	// RQG 19.09.03 L35869
	obj=document.getElementById('delete1');
	if (obj) obj.onclick=DeleteClickHandler;
	if (tsc['delete1']) websys_sckeys[tsc['delete1']]=DeleteClickHandler;

	var cdrDesc = document.getElementById("CLDRDesc");
	if (cdrDesc) cdrDesc.onblur=CLDRDescChangeHandler;  //AJI 5.11.03 35869	...	cjb 07/02/2005 49759 - changed from onchange to onblur so the broker is called

	DisableClinDiagReason();  //AJI 5.11.03 35869
	
}

	//KK 30.01.04 L:41881
	//To hold the suburb and postcode once the component is loaded.
	var objSub=document.getElementById("CTCITDesc");
	if (objSub) var OriginalSuburb=objSub.defaultValue;
	var objPCode=document.getElementById("CTZIPCode");
	if (objPCode) var OriginalPCode=objPCode.defaultValue;
	//KK 24.09.04 L:44785
	var objDMOCDesc=document.getElementById("DMOCDesc");
	if (objDMOCDesc) var OrigDMOCDesc=objDMOCDesc.defaultValue;

function CLDRDescChangeHandler(e) {
}
//35869 - This is done in custom script for QH  
function DisableClinDiagReason() {
}
//35869 - This is done in custom script for QH  
function DMOCDescLookupSelect(str) {
}
//35869 - This is done in custom script for QH  
function ClinicalDiagReasonSelect(str) {
}
//35869 - This is done in custom script for QH  
function IsCommentRequired() {
	return false;
}
//35869 - This is done in custom script for QH 
// JW this should be standard functionality
function IsClinicalDiagReasonRequired() {
	
	var cdrFlag = document.getElementById("CDRRequired");
	var cdrDesc = document.getElementById("CLDRDesc");
	if ((cdrDesc && cdrDesc.value=="") && (cdrFlag && cdrFlag.value =="Y")) {
		var msg = t['CANNOT_UPDATE'] + "\n" + t["CLINBASISDIAG"] + "\n" + t["CLINDIAGREASON_REQD"]
		alert(msg);
		return true;
	}
	return false;
}

function assignClickHandler() {

	var objupdate=document.getElementById("update1")
	var objpoptumor = document.getElementById('PopUpTumor');
	if (objpoptumor) PopUpTumor=objpoptumor.value;
	;
	if (PopUpTumor=="1") {
		objupdate.onclick = UpdateHandler;
	}
	return;
}

// Morphology
function LookUpByMorphologySelect(str) {
 	var lu = str.split("^");
	//alert("hello^" + str + "end||start" + lu[0] + ":" + lu[1] + ":" + lu[2] + ":" + lu[3] + ":" + lu[4]);
	var obj=document.getElementById("MRCIDCode")
	if (obj && lu[0]) obj.value = lu[0];
	
	var obj=document.getElementById("TUMMorphologyText")
	if (obj) {
		if (lu[1]) {
			obj.value = lu[1];
			obj.innerText = lu[1];
		}
		else {
			obj.value = "";
			obj.innerText = "";
		}
	}
	
	// cjb 01/10/2004 44078
	var obj=document.getElementById("ICDMorphDesc")
	if (obj) {
		if (lu[1]) {
			obj.value = lu[1];
			obj.innerText = lu[1];
		}
		else {
			obj.value = "";
			obj.innerText = "";
		}
	}
	
	// cjb 01/10/2004 44078 - set the rowid so the save knows which row to save.  Can have more than one row with the same code...
	var obj=document.getElementById("TUMMorphologyDR")
	if (obj) {
		if (lu[1]) {
			obj.value = lu[3];
			obj.innerText = lu[3];
		}
		else {
			obj.value = "";
			obj.innerText = "";
		}
	}
}

function MorphologyChangeHandler() {
	var objMRCIDCode=document.getElementById("MRCIDCode")
	var objTUMMorphologyText=document.getElementById("TUMMorphologyText")
	if (objMRCIDCode && objMRCIDCode.value=="") {
		if (objTUMMorphologyText) objTUMMorphologyText.value="";
	}
}

// Primary
function LookUpByCancerSelect(str) {
 	var lu = str.split("^");
	//alert("hello^" + str + " || " + lu[0] + ":" + lu[1] + ":" + lu[2]);
	var obj=document.getElementById("PathologicDiagnosis")
	if (obj && lu[0]) obj.value = lu[0];
	
	obj=document.getElementById("TUMPrimarySiteCancer")
	if (obj) {
		if (lu[1]){
			obj.value = lu[1];
			obj.innerText = lu[1];
		}
		else {
			obj.value = "";
			obj.innerText = "";
		}
	}
	
	// cjb 01/10/2004 44078
	obj=document.getElementById("PrimSiteICDDesc")
	if (obj) {
		if (lu[1]){
			obj.value = lu[1];
			obj.innerText = lu[1];
		}
		else {
			obj.value = "";
			obj.innerText = "";
		}
	}
	
	// cjb 01/10/2004 44078 - set the rowid so the save knows which row to save.  Can have more than one row with the same code...
	obj=document.getElementById("TUMPathologicDiagnosisDR")
	if (obj) {
		if (lu[1]){
			obj.value = lu[3];
			obj.innerText = lu[3];
		}
		else {
			obj.value = "";
			obj.innerText = "";
		}
	}
}

function CancerChangeHandler() {
	var objPathologicDiagnosis=document.getElementById("PathologicDiagnosis")
	var objTUMPrimarySiteCancer=document.getElementById("TUMPrimarySiteCancer")
	if (objPathologicDiagnosis && objPathologicDiagnosis.value=="") {
		if (objTUMPrimarySiteCancer) objTUMPrimarySiteCancer.value="";
	}
}

function CityLookupSelect(str) {
	//CityChangeHandler();
	//zipcode^suburb^state^address
 	var lu = str.split("^");
	//alert("hello^" + str + "||" + lu[0] + ":" + lu[1] + ":" + lu[2] + ":" + lu[3] + ":" + lu[4]);
	var obj=document.getElementById("CTZIPCode")
	if (obj) obj.value = lu[0];
 	var obj=document.getElementById("CTCITDesc")
	if (obj) obj.value = lu[1];
}


function ZipLookupSelect(str) {
	//zipcode^suburb^state^address
 	var lu = str.split("^");
	//alert("hello^" + str + "||" + lu[0] + ":" + lu[1] + ":" + lu[2]);
	var obj=document.getElementById("CTZIPCode")
	if (obj) obj.value = lu[0];
 	var obj=document.getElementById("CTCITDesc")
	if (obj) obj.value = lu[1];
}


function UpdateHandler() {
	websys_isInUpdate=true;
	var PatientID=""; var CancerReg=""; var ID=""; var BasisOfDiagcode=""; var Tumor="";
	var objpoptumor = document.getElementById('PopUpTumor');
	var objID = document.getElementById('ID');
	if (objID) ID=objID.value;
	var objPatientID = document.getElementById('PatientID');
	if (objPatientID) PatientID=objPatientID.value;
	var objCancerReg = document.getElementById('CancerReg');
	if (objCancerReg) CancerReg=objCancerReg.value;
	if (objpoptumor) PopUpTumor=objpoptumor.value;
	var objDMOCDesc = document.getElementById('DMOCDesc');
	if (objDMOCDesc) BasisOfDiagcode=objDMOCDesc.value.toUpperCase();
	// KK  10/01/2005 48657 - moved First Diagnosis Date edit check to custom script...	
	if (!(CheckFirstDiagnosisDate())) {
		return false;
	}
	/*
	// KK  10/01/2005 48657 - moved the following lines of code to custom script...
	// RQG 30.06.03 L35869: Validate Date of First Diagnosis which should not be greater than the discharge date.
	var objFirstDiagDate = document.getElementById('TUMFirstDiagnosisDate');
	var objLinkedAdmDisDate = document.getElementById('LinkedAdmDisDate');
	if ((objFirstDiagDate)&&(objFirstDiagDate.value!="")&&(objLinkedAdmDisDate)&&(objLinkedAdmDisDate.value!="")) {
		//var compstr = DateStringCompare(objFirstDiagDate.value,objLinkedAdmDisDate.value);
		var compstr = DateStringAndCacheCompare(objFirstDiagDate.value,objLinkedAdmDisDate.value);
		if (compstr == 1) {
			// First Diagnosis Date is greater than Dishcarged Date
			alert(t['FIRSTDIAGDATE_GREATER_DISCHDATE']);
			return false;
		}
	}
	*/
	/*
	if (PopUpTumor=="1") {
		// SB 09/01/02: The following reload needs to be used so that the workload list refreshes cleanly
		if (top.window.opener.top.frames["TRAK_main"]) {
			top.window.opener.top.frames["TRAK_main"].treload('websys.csp')
		} else {
			//if (window.opener) window.opener.treload('websys.csp')
		}
		top.location="websys.reload.csp"
	} else {
		//top.location="patumorframe.popup.csp"
	}
	*/
	
	if (IsClinicalDiagReasonRequired())
		return false;	

	if (IsCommentRequired())  //AJI 5.11.03 log 35869
		return false;
	
	// cjb 14/07/2004 45090 - check if the ICD fields are invalid
	var msg="";
	var obj=document.getElementById('PathologicDiagnosis');
	if ((obj)&&(obj.className=="clsInvalid")) {
		msg += "\'" + t['PathologicDiagnosis'] + "\' " + t['XINVALID'] + "\n";
	}
	var obj=document.getElementById('MRCIDCode');
	if ((obj)&&(obj.className=="clsInvalid")) {
		msg += "\'" + t['MRCIDCode'] + "\' " + t['XINVALID'] + "\n";
	}
	if (msg != "") {alert(msg);return false;}

	//KK 29/09/04 L:44785 
	DeleteReasonforClinicalDiag();
	
	return update1_click();
}


function setLinks() {
	obj=document.getElementById('ID');
	if ((obj)&&(obj.value=="")) {
		SetupHiddenLink("HistoryOfTreatment1");
	}
}

function SetupHiddenLink(link) {
	var obj=document.getElementById(link);
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}
}

// RQG 13.02.03 LOG30883
function SpecialtyLookUp(str) {
	var lu = str.split("^");
	var obj=document.getElementById('CTLOCDesc')
	if (obj) obj.value = lu[1]
}

function CloseWindow() {
	
	var msg="";
	var obj=document.getElementById('PathologicDiagnosis');
	if ((obj)&&(obj.className=="clsInvalid")) {
		msg += "\'" + t['PathologicDiagnosis'] + "\' " + t['XINVALID'] + "\n";
	}
	var obj=document.getElementById('MRCIDCode');
	if ((obj)&&(obj.className=="clsInvalid")) {
		msg += "\'" + t['MRCIDCode'] + "\' " + t['XINVALID'] + "\n";
	}
	if (msg != "") {alert(msg);return false;}
	
	
	websys_closeWindows();
	return true;
}

function CodeTableValidationDate(e) {
	
	var eSrc=websys_getSrcElement(e);
	if (eSrc.id=="TUMFirstAdmDate") {TUMFirstAdmDate_changehandler(e);}
	
	var TUMFirstAdmDate;
	var obj;
	
	obj=document.getElementById('TUMFirstAdmDate');
	if ((obj)&&(obj.value!="")) {
		var TUMFirstAdmDate=DateStringTo$H(obj.value);
	}
	
	obj=document.getElementById('CodeTableValidationDate');
	//have to initiate CTVdate to $h in case of clearing values in target date fields
	if (obj) { obj.value=DateStringTo$HToday() };
	if ((obj)&&(obj.value!="")) {
		if ((TUMFirstAdmDate)&&(TUMFirstAdmDate.value!="")) {
			obj.value=TUMFirstAdmDate;
		}
	}
	/*
	obj=document.getElementById('CTZIPCode')
	if (obj) obj.onchange();
	obj=document.getElementById('CTCITDesc')
	if (obj) obj.onchange();
	obj=document.getElementById('FVPDesc')
	if (obj) obj.onchange();
	obj=document.getElementById('HOTDesc')
	if (obj) obj.onchange();
	obj=document.getElementById('TUMTDesc')
	if (obj) obj.onchange();
	obj=document.getElementById('CANTTDesc')
	if (obj) obj.onchange();
	obj=document.getElementById('DEGDIFDesc')
	if (obj) obj.onchange();
	obj=document.getElementById('DEGPRODesc')
	if (obj) obj.onchange();
	obj=document.getElementById('HISTDDesc')
	if (obj) obj.onchange();
	obj=document.getElementById('LATERDesc')
	if (obj) obj.onchange();
	obj=document.getElementById('HOSPDesc')
	if (obj) obj.onchange();
	obj=document.getElementById('DMOCDesc')
	if (obj) obj.onchange();
	*/
}

function DeleteClickHandler() {

	if (window.parent.opener.parent.frames["FRAMEPACancerRegEdit"]) {
		var canregedit=window.parent.opener.parent.frames["FRAMEPACancerRegEdit"].document.getElementById("RefreshCSP");
		if (canregedit) canregedit.value="1";
	}
	return delete1_click();
}

//KK 30.01.04 L:41881
function DiagnosisDateChangeHandler(e){
	var eSrc = document.getElementById('TUMFirstDiagnosisDate');
	var objDiagDate=document.getElementById('TUMFirstDiagnosisDate');
	if (objDiagDate) TUMFirstDiagnosisDate_changehandler(e);
	if ((objDiagDate)&&(IsValidDate(objDiagDate))){
		var objSP=document.getElementById("SuburbandPostCode");
		if ((objSP)&&(objSP.onchange)) {
			objSP.value="1";
			objSP.onchange();
		}
	}
}

function SuburbandPostCodeLookUpSelect(str) {
	//alert(str);
	var lu = str.split("^");
	//if (lu[0]=="") return true;
	var obj=document.getElementById('CTCITDesc');
	if (obj){
		if (lu[0]!="") {
			obj.value = lu[0];
		} else {
			obj.value = OriginalSuburb;
		}
		obj.onchange();
	}
	var obj=document.getElementById('CTZIPCode');
	if (obj){
		if (lu[2]!="") {
			obj.value = lu[2];
		} else {
			obj.value = OriginalPCode;
		}
		obj.onchange();
	}
}

function HospChangeHandler(str) {
	var lu = str.split("^");
	
	var obj=document.getElementById("Hospital");
	if (obj) obj.value=lu[1];
}

//KK 24.09.04 L:44785
function DeleteReasonforClinicalDiag() {
	if (parent.frames["FRAMEPATumorClinDiagReasonList"]) {
		var tframe=parent.frames["FRAMEPATumorClinDiagReasonList"];
		if (tframe) var objrowid=tframe.document.getElementById("rowidz1");
	}
	//show warning msg only if there is any clinical dia reason in the list
	if (objrowid){
		var objDeleteCDReason=document.getElementById("DeleteCDReason");
		if (objDeleteCDReason) objDeleteCDReason.value="N";
		var objDMOCDesc=document.getElementById("DMOCDesc");
		if ((objDMOCDesc)&&(objDMOCDesc.value!="")){
			var cdrFlag = document.getElementById("CDRRequired");
			if ((cdrFlag)&&(cdrFlag.value=="N")){
				var warn=confirm(t["DELETE_CDR"]);
				if (warn){
					if (objDeleteCDReason) objDeleteCDReason.value="Y";
				}else{
					if (objDMOCDesc) objDMOCDesc.value=OrigDMOCDesc;
					if (objDeleteCDReason) objDeleteCDReason.value="N";
				}
				return false;
			}
		}
		return true;
	}
}
// KK  10/01/2005 48657 
function CheckFirstDiagnosisDate() {
	// This is a dummy function here. Check for QH done via custom js
	return true;
}


document.body.onload=Init;
