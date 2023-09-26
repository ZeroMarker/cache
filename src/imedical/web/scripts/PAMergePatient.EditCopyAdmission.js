// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

//CJB 32430 - copied this js from PAMergePatient.Edit

function DocumentLoadHandler() {
	var upd="",DoContinue=true;
	var objUp=document.getElementById("updated");
	if (objUp) upd=objUp.value;
	disableAllFields()
	obj = document.getElementById("update1")
	obj.onclick = UpdateClickHandler;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateClickHandler;
	
	// LOG 26946 BC 25-7-2002 Indicate the same patient has been chosen as both the "TO" and "FROM" patient
	var objpat1 = document.getElementById("TOPatientID");
	var patid1=objpat1.value;
	var objpat2 = document.getElementById("FROMPatientID");
	var patid2=objpat2.value;
	if ((patid1!="")&&(patid2!="")&&(patid1==patid2)) { 
		alert(t['SamePatient']);
		return;
	}

	// End LOG 26946

	// LOG 26038 BC 1-7-2002 Give the option to cancel the merge and hence clear the form
	if (DoContinue==false){
		var TWKFL=document.getElementById("TWKFL").value;
		var TWKFLI=document.getElementById("TWKFLI").value;
		var lnk = "pamergepatient.datacopyadmission.csp?FROMPatientID=&TOPatientID=&TWKFL="+TWKFL+ "&TWKFLI="+TWKFLI;
		top.frames["TRAK_hidden"].location=lnk;	
	}
	
	
	// End LOG 23871
	
}

function UpdateClickHandler(e) {
	//alert("cjb");
	//SelectedEpisodeIDBuilder();
	//alert (codeidsobj.value);
	var objEpisodeIDString=document.getElementById("EpisodeIDString");
	var objMRNumberString=document.getElementById("MRNumberString");
	var MRNumberInactiveString=document.getElementById("MRNumberInactiveString");
	//alert(objEpisodeIDString.value);
	//alert(objMRNumberString.value);
	
	if ((objEpisodeIDString.value=="")&&(objMRNumberString.value=="")&&(MRNumberInactiveString.value=="")) {
		
		alert(t['NothingSelected']);
		
		return false
		
	} else {
		
		//if (objEpisodeIDString) objEpisodeIDString.value=codeidsobj.value;
		
		if (window.name=="CopyAdmission") {
			var frm=document.forms['fPAMergePatient_EditCopyAdmission'];
			// cjb 23/07/2003 37419.  Taken this out as it was opening a new window.  Instead, put escape frames into the workflow
			//if (frm.elements['TWKFL']!="") frm.elements['TFRAME'].value="window.parent.name";
		}
		return update1_click()
	}
}

// cjb 11/04/2006 58847
function CheckTOPatient(TOPatientID) {
	var FROMPatientID=document.getElementById("FROMPatientID").value;
	if ((FROMPatientID!="") && (FROMPatientID==TOPatientID)) {
		alert(t['SamePatient']);
		return false;
	}
	return true;
}
function CheckFROMPatient(FROMPatientID) {
	var TOPatientID=document.getElementById("TOPatientID").value;
	if ((TOPatientID!="") && (TOPatientID==FROMPatientID)) {
		alert(t['SamePatient']);
		return false;
	}
	return true;
}

function TOPAPMIRegNoLookUp(str) {
	var TWKFL=document.getElementById("TWKFL").value;
	var TWKFLI=document.getElementById("TWKFLI").value;
	var frompat=document.getElementById("FROMPatientID").value;
	var frommrn=document.getElementById("FROMMRN");
	if (frommrn) frommrn=frommrn.value;
	var tomrn=document.getElementById("TOMRN");
	if (tomrn) tomrn=tomrn.value;
	var lu = str.split("^");
	if (CheckTOPatient(lu[1])) {
		var lnk = "pamergepatient.datacopyadmission.csp?TOPatientID="+ lu[1] + "&TWKFL="+TWKFL+ "&TWKFLI="+TWKFLI+"&FROMPatientID="+frompat+"&TOMRN="+ tomrn+"&FROMMRN="+frommrn;
		top.frames["TRAK_hidden"].location=lnk;
	}
}

function FROMPAPMIRegNoLookUp(str) {
	var TWKFL=document.getElementById("TWKFL").value;
	var TWKFLI=document.getElementById("TWKFLI").value;
	var topat=document.getElementById("TOPatientID").value;
	var frommrn=document.getElementById("FROMMRN");
	if (frommrn) frommrn=frommrn.value;
	var tomrn=document.getElementById("TOMRN");
	if (tomrn) tomrn=tomrn.value;
	var lu = str.split("^");
	if (CheckFROMPatient(lu[1])) {
		var lnk = "pamergepatient.datacopyadmission.csp?FROMPatientID="+ lu[1] + "&TWKFL="+TWKFL+ "&TWKFLI="+TWKFLI+"&TOPatientID="+topat+"&TOMRN="+ tomrn+"&FROMMRN="+frommrn;
		top.frames["TRAK_hidden"].location=lnk;
	}
}

function TOMRNLookUp(str) {
	var TWKFL=document.getElementById("TWKFL").value;
	var TWKFLI=document.getElementById("TWKFLI").value;
	var frompat=document.getElementById("FROMPatientID").value;
	var frommrn=document.getElementById("FROMMRN").value;
	var lu = str.split("^");
	if (CheckTOPatient(lu[2])) {
		var lnk = "pamergepatient.datacopyadmission.csp?TOPatientID="+ lu[2] + "&TWKFL="+TWKFL+ "&TWKFLI="+TWKFLI+"&FROMPatientID="+frompat+"&TOMRN="+ lu[0]+"&FROMMRN="+frommrn;
		top.frames["TRAK_hidden"].location=lnk;
	}
}


function FROMMRNLookUp(str) {
	var TWKFL=document.getElementById("TWKFL").value;
	var TWKFLI=document.getElementById("TWKFLI").value;
	var topat=document.getElementById("TOPatientID").value;
	var tomrn=document.getElementById("TOMRN").value;
	var lu = str.split("^");
	if (CheckFROMPatient(lu[2])) {
		var lnk = "pamergepatient.datacopyadmission.csp?FROMPatientID="+ lu[2] + "&TWKFL="+TWKFL+ "&TWKFLI="+TWKFLI+"&TOPatientID="+topat+"&FROMMRN="+ lu[0]+"&TOMRN="+tomrn;
		top.frames["TRAK_hidden"].location=lnk;
	}
}


function DisableField(fldName) {
	var fld = document.getElementById(fldName);
	if ((fld)&&(fld.tagName=="INPUT")) {
		fld.disabled = true;
		fld.className = "";
	}
}

function EnableField(fldName) {
	var fld = document.getElementById(fldName);
	if ((fld)&&(fld.tagName=="INPUT")) {
		fld.enabled = true;
		fld.className = "";
	}
}

function enableAllFields() {

	var fields= new Array("FROMCLNAddress1","FROMPAPMIName","FROMPAPMIName2","FROMPAPMIName3",
	"FROMPAPMIDOB","FROMCTSEXDesc","FROMMRNNo","FROMPAPMIMedicare","TOCLNAddress1","TOPAPMIName","TOPAPMIName2","TOPAPMIName3",
	"TOPAPMIMedicare","TOMRNNo","TOCTSEXDesc","TOPAPMIDOB","TOPAPMIRegNo","TOCTCITDesc","TOCTRLGDesc","FROMCTRLGDesc","FROMCTZIPCode",
	"FROMPAPERID","FROMPAPERMobPhone","FROMPAPERNokAddress1","FROMPAPERNokAddress2","FROMPAPERNokCityDR","FROMPAPERNokCTRLTDR",
	"FROMPAPERNokName","FROMPAPERNokPhone","FROMPAPERNokZipDR","FROMPAPERSecondPhone","FROMPAPERStNameLine1",
	"FROMPAPERForeignAddress","TOPAPERForeignAddress","FROMPAPERTelH","FROMPAPERTelO","FROMPROVDesc","FROMREFDCITYDR","FROMREFDDesc",
	"FROMTTLDesc","TOCTCITDesc","TOCTRLGDesc","TOCTZIPCode","TOPAPERID","TOPAPERMobPhone","TOPAPERNokAddress1",
	"TOPAPERNokAddress2","TOPAPERNokCityDR","TOPAPERNokCTRLTDR","TOPAPERNokName","TOPAPERNokPhone","TOPAPERNokZipDR","TOPAPERSecondPhone",
	"TOPAPERStNameLine1","TOPAPERTelH","TOPAPERTelO","TOPROVDesc","TOREFDCITYDR","TOREFDDesc","TOTTLDesc",
	"FROMDentCLNAddress1","TODentCLNAddress1","TODentREFDDesc","FROMDentREFDDesc","FROMDentREFDCITYDR","TODentREFDCITYDR","FROMCTCITDesc",
	"Location","CareProvider","Ward","HOSPDesc","AdmDate","AdmTime","DisDate","DisTime",
	"TOMRNumber","FROMMRNumber");
	
	for (var i=0;i<fields.length;i++) {
		obj=document.getElementById(fields[i]);
		if (obj) EnableField(fields[i]);
	}
}

function disableAllFields() {

	var fields= new Array("FROMCLNAddress1","FROMPAPMIName","FROMPAPMIName2","FROMPAPMIName3",
	"FROMPAPMIDOB","FROMCTSEXDesc","FROMMRNNo","FROMPAPMIMedicare","TOCLNAddress1","TOPAPMIName","TOPAPMIName2","TOPAPMIName3",
	"TOPAPMIMedicare","TOMRNNo","TOCTSEXDesc","TOPAPMIDOB","TOCTCITDesc","TOCTRLGDesc","FROMCTRLGDesc","FROMCTZIPCode",
	"FROMPAPERID","FROMPAPERMobPhone","FROMPAPERNokAddress1","FROMPAPERNokAddress2","FROMPAPERNokCityDR","FROMPAPERNokCTRLTDR",
	"FROMPAPERNokName","FROMPAPERNokPhone","FROMPAPERNokZipDR","FROMPAPERSecondPhone","FROMPAPERStNameLine1",
	"FROMPAPERForeignAddress","TOPAPERForeignAddress","FROMPAPERTelH","FROMPAPERTelO","FROMPROVDesc","FROMREFDCITYDR","FROMREFDDesc",
	"FROMTTLDesc","TOCTCITDesc","TOCTRLGDesc","TOCTZIPCode","TOPAPERID","TOPAPERMobPhone","TOPAPERNokAddress1",
	"TOPAPERNokAddress2","TOPAPERNokCityDR","TOPAPERNokCTRLTDR","TOPAPERNokName","TOPAPERNokPhone","TOPAPERNokZipDR","TOPAPERSecondPhone",
	"TOPAPERStNameLine1","TOPAPERTelH","TOPAPERTelO","TOPROVDesc","TOREFDCITYDR","TOREFDDesc","TOTTLDesc",
	"FROMDentCLNAddress1","TODentCLNAddress1","TODentREFDDesc","FROMDentREFDDesc","FROMDentREFDCITYDR","TODentREFDCITYDR","FROMCTCITDesc",
	"Location","CareProvider","Ward","HOSPDesc","AdmDate","AdmTime","DisDate","DisTime",
	"TOMRNumber","FROMMRNumber");
	
	for (var i=0;i<fields.length;i++) {
		obj=document.getElementById(fields[i]);
		if (obj) DisableField(fields[i]);
	}
}


function PregnancyLink(EpisodeID,admno) {
	
	if (confirm(admno+"   "+t['PregnancyLink'])) {
		var frm=document.forms['fPAMergePatient_EditCopyAdmission'];
		if (frm) frm.TOVERRIDE.value=1;
		var PregnancyLink=document.getElementById("PregnancyLink");
		if (PregnancyLink) {
			PregnancyLink.value+=EpisodeID+"^";
		}
	}
}

function DischSumMsg(MovingEpisodes,NonMovingEpisodes) {
	
	if (confirm(MovingEpisodes+" "+t['DischSum']+" "+NonMovingEpisodes)) {
		var frm=document.forms['fPAMergePatient_EditCopyAdmission'];
		if (frm) frm.TOVERRIDE.value=1;
	}
}




document.body.onload = DocumentLoadHandler;