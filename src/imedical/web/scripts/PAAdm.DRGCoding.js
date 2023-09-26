// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
//W650
/* Enter your change details here:

	DATE		LOG		DEVELOPER	REMARKS
	========	=======	=========	========================================================
			25259		RQG		Make Admission Weight field mandatory if patient age is less than 29 days
	22.04.03	32787		RQG		Update hyperlink to interface to grouper.
	30.04.03	32768		RQG		PAAdm.DRGCoding auto cancer registration.
	28.05.03	35988		RQG		Grouping episode where a dx desc been deleted is
							deleting all codes.
	28.05.03	35990		RQG		Episode should not be Grouped if no diagnosis entries
	13.06.03	32790		RQG		ICD Coding Edits
	23.06.03	36636		KK		Delete coding details
	07.07.03	35047		KK		DRG Coding Page changed to frames. Modified scripts to work with frames.
	07.07.03	36701		RQG		Modifications for Coding for 1st July changes - CPAP hours  
	08.07.03	34036		RQG		Hperlink for copying coding details to another episode
	11.07.03	32777		RQG		new hyperlink to display contract details PAAdmDRGCoding
	14.07.03	32802		AJI		Added new hyperlink to instantiate 3M Encoder Program
	05.08.03	37996		RQG		Deleting 2 or more codes is giving an incorrect error message
	13.08.03	32803		RQG		Grouper Interface
	09.09.03	32770		RQG		New column/ functionality for prod date field PAAdm.DRGCoding
	10.09.03	39021		SA		Fixed to pass Workflow Item from Next/Previous Ep links.
	15.09.03	32776		KK		Functions AssignDiagnosis and AssignProcedures fixed to populate the fields correctly.
	19.09.03    39205       AJI		Added new function -> CreateInquiryProcDateFields()
							Also modified Load3MEncoder() 
							and fixed CreateInquiryDiagFields() & CreateInquiryProcFields()
	24.09.03	39253		RQG		To make PIN mandatory for other hyperlinks except for Visasys Grouper hyperlink
	23.10.03    40122       AJI		Shouldn't check admission weight & MV.Hours when update if diag codes are empty
	19.11.03    40633       AJI		Fixed CheckforHiddenDiagnosisFields() and CheckforHiddenProcedureFields()
							to dynamically add new rows depending on the number of diag. or proc. codes
							Also changed ReloadDRGCodingCSP(): adding a new Parameter -> for invalid password
	05.07.04	44240		KK		AssignProcedures function updates ProcDateMandatory filed also.
	09.08.04	44082		KK		Allow Duplicate codes to be entered if falg set in CT
	09.09.04	44777		cjb		re-written the contract care stuff
	18.01.05	48760		KK		update without any icd edit check after delete coding details
	21.01.05 	48931		KK		Check for Unacceptable Primary Diagnosis
  	09.02.05 	49009		KK		Set focus to the first row(Prefix) in MRDiagnos.EditDRG
	18.02.05 	50202		KK 		Procedure date defaulted from LookUpDRGCodingSelect if sameday episode
	08/06/05	53036		cjb		new function CommonUpdateFunctions called from SubmitForms, Open3MGrouper, UpdateWithVisGrouper & OpenVisasys functions to remove duplication
									removed the following redundant functions: SubmitBeforeGrouper, CallGrouper
	29/07/05	53229		md		new function ValidateAccDate									
	
	
*/

var objUpdate=document.getElementById("DRGupdate");
var obj3MGrouper=document.getElementById("B3MGrouper");
var objUpdateVisasys=document.getElementById("UpdateVisasys");  // L32787
var objUpdateWithVisGrouper=document.getElementById("UpdateWithVisGrouper");  // L32787
var objICUHours=document.getElementById("ICUHours");
var objCCUHours=document.getElementById("CCUHours");
var objMechVentHours=document.getElementById("MechVentHours");
var objCPAPHours=document.getElementById("CPAPHours");
var objAge=document.getElementById("Age");
var objMRADMWeight=document.getElementById("MRADMWeight");
var lblMRADMWeight=document.getElementById("cMRADMWeight");
var objNextEpisode=document.getElementById("NextEpisode");
var objPreviousEpisode=document.getElementById("PreviousEpisode");
var objNextEpisodeID=document.getElementById("NextEpisodeID");
var objPreviousEpisodeID=document.getElementById("PreviousEpisodeID");
var objDRGInquiry=document.getElementById("DRGInquiry")
var objINQLeaveDays=document.getElementById("INQLeaveDays")
var objINQDiags=document.getElementById("INQDiags")
var objINQProcs=document.getElementById("INQProcs")
var objINQProcDates=document.getElementById("INQProcDates")
var objTARMedTarget=document.getElementById("TARMedTarget")
var objBoldCancerLink=document.getElementById("BoldCancerLink")
var objCancerReg=document.getElementById("CancerReg")
var objDischargeDate=document.getElementById("DischargeDate");
var objAdmDate=document.getElementById("AdmDate");
if (objAdmDate) admdate=objAdmDate.value;
var objGrouperType=document.getElementById("GrouperType");
var objFollowupReason=document.getElementById("FollowUpReason")  //rqg,log24386:Highlight selected followup reasons
var objFollowupReasonStr=document.getElementById("FollowUpReasonString")
if ((objFollowupReasonStr)&&(objFollowupReasonStr.value!="")) {
	var arrayItem = new Array();
	arrayItem = objFollowupReasonStr.value.split('|');
	if (objFollowupReason) {
	   for (var i=0; i<arrayItem.length; i++) {
	      for (var j=0; j<objFollowupReason.options.length; j++) {
		   if (objFollowupReason.options[j].text == arrayItem[i]) {
			objFollowupReason.options[j].selected=true;
		   }
		}
	   }	
	}
}
var objPatientID=document.getElementById("PatientID");
var objEpisodeID=document.getElementById("EpisodeID");
if (objEpisodeID) var EpisodeID=objEpisodeID.value;
if (objPatientID) var PatientID=objPatientID.value;
objBold=document.getElementById('BoldLinks');

var CONTEXT=session['CONTEXT'];
var objTWKFL=document.getElementById('TWKFL');
var objTWKFLI=document.getElementById('TWKFLI');
var TWKFL="";
var TWKFLI="";
if (objTWKFL)   TWKFL=objTWKFL.value;
if (objTWKFLI)  TWKFLI=objTWKFLI.value;

var objTWKFLL=document.getElementById("TWKFLL");
var objTWKFLJ=document.getElementById("TWKFLJ");
var objmradm=document.getElementById("mradm");
var objTransID=document.getElementById("TRANSID");
var mradm="";
var TransID="";
var TWKFLJ="";
var TWKFLL="";
if (objTWKFLL) TWKFLL=objTWKFLL.value;
if (objTWKFLJ) TWKFLJ=objTWKFLJ.value;
if (objmradm) mradm=objmradm.value;
if (objTransID) TransID=objTransID.value;


//KK 12/May/2003 Log 35005
var objRFU=document.getElementById('RequiresFollowUpList');
if ((objFollowupReasonStr)&&(objFollowupReasonStr.value!="")) {
	var arrayItem = new Array();
	arrayItem = objFollowupReasonStr.value.split('|');
	if (objRFU) {
		for (var i=0; i<arrayItem.length; i++) {
			if(arrayItem[i]!="") objRFU.options[objRFU.options.length] = new Option(arrayItem[i]);
	   	}	
	}
}

// cjb - cancer reg 24388 - bold cancer link if the patient has a cancer registration
if ((objBoldCancerLink.value=="1") && (objCancerReg)) objCancerReg.style.fontWeight="bold";

// RGQ - L32773
if ((objAge)&&(objAge.value!="")&&(objAge.value<29)) {
	if (objMRADMWeight) objMRADMWeight.className="clsRequired";
	if (lblMRADMWeight) lblMRADMWeight.className="clsRequired";
}

// rqg,Log27337: 
if ((objAge)&&(objAge.value!="N")) {
	if(parent.frames["MRDiagnosEditDRG"]) var frm = parent.frames["MRDiagnosEditDRG"].document.forms["fMRDiagnos_EditDRG"];
	if (frm) {
		frm.PatAge.value=objAge.value;
	}
	if(parent.frames["MRProceduresEditDRG"]) var frmproc=parent.frames["MRProceduresEditDRG"].document.forms["fMRProcedures_EditDRG"];
	if (frmproc) {
		frmproc.PatAge.value=objAge.value;
	}
}
var objPatSex=document.getElementById("PatSex");
if (objPatSex) {
	if(parent.frames["MRDiagnosEditDRG"]) var frm = parent.frames["MRDiagnosEditDRG"].document.forms["fMRDiagnos_EditDRG"];
	if (frm) {
		frm.PatSex.value=objPatSex.value;
	}
	//RQG 18.07.03 L32790
	if(parent.frames["MRProceduresEditDRG"]) var frmproc=parent.frames["MRProceduresEditDRG"].document.forms["fMRProcedures_EditDRG"];
	if (frmproc) {
		frmproc.PatSex.value=objPatSex.value;  // procsex is defined in MRProcedures.EditDRG.js file
	}
}

// rqg,Log27545
// kk log 33703 to set dischdate in MRProcedures.EditDRG
// RQG 25.06.03 L32770: set the admdate to admission date in MRProcedures.EditDRG
if(parent.frames["MRDiagnosEditDRG"]) var frm = parent.frames["MRDiagnosEditDRG"].document.forms["fMRDiagnos_EditDRG"];
if(parent.frames["MRProceduresEditDRG"]) var frmproc=parent.frames["MRProceduresEditDRG"].document.forms["fMRProcedures_EditDRG"];
if (frm) {
	var objINQDischargeDate=document.getElementById("INQDischargeDate");
	if (objINQDischargeDate) objINQDischargeDate.onblur = SetMRDiagnosDischargeDate;
	if (objDischargeDate) {
		dischdate="";
		//if ((objDischargeDate.tagName=="LABEL")&&(objDischargeDate.innerText!="")) {
		// KK 37933 - Eventhough objDischargeDate is LABEL it is not recognising innerText.
		if (objDischargeDate.value!="") {
			if (frm.MRDischargeDate) {
				frm.MRDischargeDate.value=objDischargeDate.innerText;
				if ((frmproc)&&(frmproc.DischDate)) frmproc.DischDate.value=objDischargeDate.innerText;  //discharge date in MRProcedures.EditDRG
				dischdate=frm.MRDischargeDate.value; // dischdate is defined in MRDiagnos.EditDRG
				if (dischdate.length==1) dischdate="";
			}
		}
	}
}

//rqg 22.11.02 - Log29161: Make CRAFT details link hidden if mode="INQUIRY"
//rqg 12.11.02 - Log28511: Make WEIS details link hidden if mode="INQUIRY"
var objMode=document.getElementById("Mode");
if ((objMode)&&(objMode.value=="INQUIRY")) {
	var objViewWEISDetails=document.getElementById("ViewWEISDetails");
	if ((objViewWEISDetails)) objViewWEISDetails.style.visibility = "hidden";
	var objViewCRAFTDetails=document.getElementById("ViewCRAFTDetails");
	if ((objViewCRAFTDetails)) objViewCRAFTDetails.style.visibility = "hidden";
}
//KK 23/jun/2003 Log 36636 
var ICUHours="";
var CCUHours="";
if (objICUHours) ICUHours=objICUHours.value;
if (objCCUHours) CCUHours=objCCUHours.value;
//md 51522
//
var frm = document.forms["fPAAdm_DRGCoding"];
if (parent.frames["PAAdmDRGCoding"]) {
	frm.elements['TFRAME'].value=window.parent.name;
}

function PAAdmDRGBodyLoadHandler() {
	var obj=parent.frames["PAAdmDRGCodingDisplay"];
	if (obj==null) ReloadDRGCodingCSP();  //To load all the frames, due to invalid error

	// RQG 15.11.02 - Log27337: The warning message for assigned DRG codes of "960Z","961Z","962Z"
	// is now displayed here. This is also displayed in PAAdmCoding.Edit3MDRG - Inquiry process.
	// Related Log 25417
	var objDRGCode=document.getElementById("DRGCode");
	if (objDRGCode) {
		if ((objDRGCode.value=="960Z")||(objDRGCode.value=="961Z")||(objDRGCode.value=="962Z")) {
			alert(t['DRG_MESS']);
		}
		//KK 13/July/2004 - L:44923
		if (objDRGCode.value=="XXX"){
			objDRGCode.innerText="";
			objDRGCode.value="";
			var objDRGDesc=document.getElementById("DRGDesc");
			if (objDRGDesc) {
				objDRGDesc.innerText="";
				objDRGDesc.value="";
			}
			alert(t['DRG_NOT_VALID']);
		}
	}
	if ((objNextEpisode)&&(objNextEpisodeID)) {
		if (objNextEpisodeID.value=="") {
			objNextEpisode.disabled=true;
			objNextEpisode.onclick=LinkDisable;
		} else {
			objNextEpisode.onclick=LoadNextEpisode;
		}
	}
	if ((objPreviousEpisode)&&(objPreviousEpisodeID)) {
		if (objPreviousEpisodeID.value=="") {
			objPreviousEpisode.disabled=true;
			objPreviousEpisode.onclick=LinkDisable;
		} else {
			objPreviousEpisode.onclick=LoadPreviousEpisode;
		}
	}
	//rqg,Log28511/02.10.02	
	CheckWEISScore();
	var objViewWEISDetails=document.getElementById("ViewWEISDetails");
	if (objViewWEISDetails) objViewWEISDetails.onclick=ViewWEISDetailsSCR;
	//rqg 22.11.02 - Log29161
	CheckCRAFTScore();
	var objViewCRAFTDetails=document.getElementById("ViewCRAFTDetails");
	if (objViewCRAFTDetails) objViewCRAFTDetails.onclick=ViewCRAFTDetailsSCR;
	CheckforHiddenDiagnosisFields();
	CheckforHiddenProcedureFields();

	if (objUpdate && !objUpdate.disabled) objUpdate.onclick = SubmitForms;
	else {
		if (objUpdate) objUpdate.onclick=LinkDisable;
	}
	
	if (obj3MGrouper && !obj3MGrouper.disabled) obj3MGrouper.onclick = Open3MGrouper;
	else {
		if (obj3MGrouper) obj3MGrouper.onclick=LinkDisable;
	}

	if (objUpdateVisasys && !objUpdateVisasys.disabled) objUpdateVisasys.onclick = OpenVisasys;   // L32787
	else {
		if (objUpdateVisasys) objUpdateVisasys.onclick=LinkDisable;
	}
	
	if (objUpdateWithVisGrouper) objUpdateWithVisGrouper.onclick=UpdateWithVisGrouper;
	 
	if (objDRGInquiry) objDRGInquiry.onclick=Open3MGrouperForInquiry;
	if (objTARMedTarget) objTARMedTarget.disabled=true;

	// RQG 29.01.03 Log28510
	var objWIESInquiry=document.getElementById("WIESInquiry");
	if (objWIESInquiry) objWIESInquiry.onclick=RunWIESInquiry;

	//KK 2.4.03 Log 32776 - Disable DRGCoding field if there is any Diagnosis or Procedure data appears on the table
	var objDRGCoding=document.getElementById("MRCDRGCoding");
	if (parent.frames["MRDiagnosEditDRG"]) var objDT=parent.frames["MRDiagnosEditDRG"].document.getElementById('DiagnosTotal');
	if (objDT) var diagtotal=objDT.innerText;
	if (parent.frames["MRProceduresEditDRG"]) var objPT=parent.frames["MRProceduresEditDRG"].document.getElementById("TotalProcedures");
	if (objPT) var proctotal=objPT.innerText;
	if ((diagtotal>0)||(proctotal>0)){
		if (objDRGCoding) {
			objDRGCoding.disabled=true;
			// cjb 01/03/2005 50075 - commented out as not needed and when you delete the coding F6 lookup doesn't work
			//objDRGCoding.onkeydown='';
			var objLUp=document.getElementById("ld1242iMRCDRGCoding");
			if(objLUp) objLUp.style.visibility = "hidden";
		}
	}
	var objDelCoding=document.getElementById("DeleteCoding");
	if (objDelCoding) objDelCoding.onclick=DeleteCodingDetails;
	var objUpdCodeSet=document.getElementById("updatecodeset");
	if (objUpdCodeSet) objUpdCodeSet.onclick=UpdateCodeSetParent;
	//GR 32786
	var objVerifyIcon=document.getElementById("VerifiedStatus");
	if (objVerifyIcon) objVerifyIcon.onclick=IconClick;
	// cjb 29/045/2004 36149
	var objIncompleteDischargeSummary=document.getElementById("IncompleteDischargeSummary");
	if (objIncompleteDischargeSummary) objIncompleteDischargeSummary.onclick=IconClick;
	var objDRFU=document.getElementById("DeleteRFU");
	if(objDRFU) objDRFU.onclick=DeleteRFUClickHandler;

	//KK 19/Jun/2003 Log 35045
	var AvgLOS=0;
	if (parent.frames["PAAdmDRGCodingDisplay"]) var objALOS=parent.frames["PAAdmDRGCodingDisplay"].document.getElementById("TTARDayHospitalTariff");
	if ((objALOS)&&(objALOS.value!="")) AvgLOS=objALOS.value;
	if (AvgLOS==0) {
		var objAvgLOS=document.getElementById("TARDayHospitalTariff");
		if ((objAvgLOS)&&(objAvgLOS.tagName=="LABEL")&&(objAvgLOS.innerText!="")&&(objAvgLOS.innerText!=" ")) AvgLOS=objAvgLOS.innerText;
	}
	var TLOS=0;
	var objTotalLengthOfStay=document.getElementById("TotalLengthOfStay");
	TLOS = objTotalLengthOfStay.value;
	var objVarLOS=document.getElementById("VarianceLOS");
	var varlos= TLOS - AvgLOS;
	if (varlos<0) varlos=(varlos)*(-1);
	var tmp=""+varlos;
	var t1=tmp.split(".");
	var tvariance="";
	if (t1[0]) tvariance=t1[0];
	if (t1[1]) tvariance=tvariance+"."+t1[1].substring(0,2);
	if (varlos<0) varlos=(varlos)*(-1);
	if (objVarLOS) objVarLOS.innerText=tvariance;  // TLOS - AvgLOS;
	if (parent.frames["PAAdmDRGCodingDisplay"]) var objVariance=parent.frames["PAAdmDRGCodingDisplay"].document.getElementById("Variance");
	if (objVariance) objVariance.innerText=tvariance;
	// RQG L34036
	var objCopyWin=document.getElementById("COPYWindow");
	var objEpisodeList=document.getElementById("EpisodeList");
	if ((objCopyWin)&&(objCopyWin.value=="COPY")) {
		// Disable Update3MGrouper and VISASys buttons
		if (obj3MGrouper)	{
			obj3MGrouper.disabled=true;
			obj3MGrouper.onclick=LinkDisable;
		}
		if (objUpdateVisasys) {
			objUpdateVisasys.disabled=true;
			objUpdateVisasys.onclick=LinkDisable;
		}
		if (objPreviousEpisode) {
			objPreviousEpisode.disabled=true;
			objPreviousEpisode.onclick=LinkDisable;
		}
		if (objNextEpisode) {
			objNextEpisode.disabled=true;
			objNextEpisode.onclick=LinkDisable;
		}
		if (objEpisodeList) {
			objEpisodeList.disabled=true;
			objEpisodeList.onclick=LinkDisable;
		}
	}

	// RQG L32777
	var objContractCare=document.getElementById("ContractCare");
	if (objContractCare) { objContractCare.onclick=ContrCareClickHandler; }
	var objIsContract=document.getElementById("IsContracted");
	
	// cjb 08/09/2004 44777 - this should be done in the custom script...
	// standard functionality - bold if there are contracted care rows
	//Log 66165 PeterC 21/01/08 PeterC
	if ((objBold)&&(objContractCare)&&(objBold.value!="")&&(mPiece(objBold.value,"^",7)=="1")) objContractCare.style.fontWeight="bold";
	BoldContractCareLink();
	
	// AJI Log32802
	var encoder3M = document.getElementById("Encoder3M");
	if (encoder3M && !encoder3M.disabled) encoder3M.onclick = Load3MEncoder;
	else {
		if (encoder3M) encoder3M.onclick = LinkDisable;
	}

	//AJI Log40633
	var objPIN = document.getElementById("InvalidPIN");
	if (objPIN && objPIN.value=="Y") {
		window.setTimeout('PINSetFocus();',200);
	}else {
		//RQG 21.07.03 L32790: Set focus on MRDIAICDCodeDRDesc field in MRDiagnos.EditDRG frame;
		window.setTimeout('DiagSetFocus();',200);
	}

	// RQG 31.07.03 L37856
	var objINQDateOfBirth=document.getElementById("INQDateOfBirth");
	if (objINQDateOfBirth) objINQDateOfBirth.onblur=CheckEnteredDates;
	
}

function CheckEnteredDates() {
	var dobdate=""; var admdate="";
	var objINQAdmissionDate=document.getElementById("INQAdmissionDate");
	if (objINQAdmissionDate && objINQAdmissionDate.value!="") {
		admdate = DateStringToDateObj(objINQAdmissionDate.value);
	}
	var objINQDateOfBirth=document.getElementById("INQDateOfBirth");
	if (objINQDateOfBirth && objINQDateOfBirth.value!="") {
		dobdate = DateStringToDateObj(objINQDateOfBirth.value);

	}
	if (dobdate !="" && admdate !="") {
		if (dobdate > admdate) {
			alert(t['ADMDATE_PRE_DOB'])
			websys_setfocus("INQAdmissionDate");
			return false;
		}
	}
}

//AJI log 40633
function PINSetFocus() {
	var objPIN = document.getElementById("PIN");
	if (objPIN) {
		objPIN.focus();
		objPIN.className="clsInvalid";
	}
}

function DiagSetFocus() {
	var fra="";
	var objCopyWin=document.getElementById("COPYWindow");
	if ((objCopyWin)&&(objCopyWin.value!="COPY")) {
		fra=top.frames["TRAK_main"].frames["MRDiagnosEditDRG"]
	} else {
		fra=window.parent.opener.frames["MRDiagnosEditDRG"]
	}
	//KK  09.02.05 L49009: No need to set focus to the last blank row any more. 
	if(parent.frames["MRDiagnosEditDRG"]) var frmdia=parent.frames["MRDiagnosEditDRG"].document.forms["fMRDiagnos_EditDRG"];
	if (frmdia.MRDIAPrefixz1) {
		frmdia.MRDIAPrefixz1.focus();
	}else if(frmdia.MRDIAICDCodeDRDescz1){
		frmdia.MRDIAICDCodeDRDescz1.focus();
	}
	try {Custom_DiagSetFocus(); } catch(e) {}
}
	
// Author: Aji  Log32802
function Load3MEncoder() {
	var objCoderFlag = top.frames["TRAK_hidden"].document.getElementById("IsCoderRunning");
	if (objCoderFlag && objCoderFlag.value == "1") {
		alert("Cannot activate a new Coding Session.\nYou must close existing session to do so\n");
		return false;
	}
	else {
		if (PatientID !="" && EpisodeID !="") {
			
		//start Log39205
			if (!ValidateProcDate())
				return false;
			
			CreateHiddenDiagFields();
			CreateHiddenProcFields();

			CreateInquiryDiagFields();
			CreateInquiryProcFields();
			CreateInquiryProcDateFields();

			var errMsg=""; var diags=""; var procs=""; var hmv=""; var weight=""; var procDates=""; var extraDiag=""; var extraProc="";

			var objDiag=document.getElementById("DIAGFields");
			var objProc=document.getElementById("PROCFields");
			
			if (objDiag) extraDiag=objDiag.value;
			if (objProc) extraProc=objProc.value;
			if (objINQDiags) diags=objINQDiags.value;
			if (objINQProcs) procs=objINQProcs.value;
			if (objINQProcDates) procDates=objINQProcDates.value;

			if (objMechVentHours && objMechVentHours.value!="") {
				if (isNaN(objMechVentHours.value))
					errMsg += t['MECH_VENT_HOURS']+" "+t['INVALID']+"\n";
				else
					hmv = objMechVentHours.value;
			}
			if (objMRADMWeight && objMRADMWeight.value!="") {
				var temp=objMRADMWeight.value;
				if ((isNaN(temp))||(temp>9999))
					errMsg += t['MRADMWeight']+" "+t['XINVALID']+"\n";
				else
					weight=temp;
			}
			if (errMsg!="") {
				alert(errMsg);
				return false;
			}

			var link = "websys.default.csp?WEBSYS.TCOMPONENT=PAAdmCoding.Edit3MCoder";
			link += "&PatientID=" + PatientID + "&EpisodeID=" + EpisodeID + "&DIAGCodes=" + diags + "&PROCCodes=" + procs + "&PROCDates=" + procDates;
			link += "&HMV=" + hmv + "&AdmWeight=" + weight + "&TWKFL="+TWKFL+"&TWKFLI="+TWKFLI+"&CONTEXT="+CONTEXT;

			websys_createWindow(link,"TRAK_hidden");
		}
	}
}

// SA 5.7.02 - log 24580. Method created.
function LoadNextEpisode() {
	var EpisodeID="";

	if (objNextEpisodeID) EpisodeID=objNextEpisodeID.value;

	// SA 11.9.03 - log 39021: Previous/Next Episode Links weren't keeping workflow, 
	// which meant post grouping was showing blank page.
	
	var url="paadm.drgcoding.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID + "&TWKFL="+TWKFL+"&TWKFLI="+TWKFLI+"&CONTEXT="+CONTEXT;

	websys_createWindow(url,"TRAK_main");
	return false;
}

// SA 5.7.02 - log 24580. Method created.
function LoadPreviousEpisode() {

	var EpisodeID="";

	if (objPreviousEpisodeID) EpisodeID=objPreviousEpisodeID.value;

	// SA 11.9.03 - log 39021: Previous/Next Episode Links weren't keeping workflow, which meant post grouping was showing blank page.
	
	var url="paadm.drgcoding.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID + "&TWKFL="+TWKFL+"&TWKFLI="+TWKFLI+"&CONTEXT="+CONTEXT;

	websys_createWindow(url,"TRAK_main");
	return false;
}

function HourFieldsPreUpdateCheck() {

	var errMsg="";
	var temp="";	

	if ((objICUHours)&&(objICUHours.value!="")) {
		temp=objICUHours.value;
		if (isNaN(temp)) {
			errMsg += t['ICU_HOURS']+" "+t['INVALID']+"\n";
		}
	}

	if ((objCCUHours)&&(objCCUHours.value!="")) {
		temp=objCCUHours.value;
		if (isNaN(temp)) {
			errMsg += t['CCU_HOURS']+" "+t['INVALID']+"\n";
		}
	}

	if (objMechVentHours) {
		if (objMechVentHours.value!="") {
			temp=objMechVentHours.value;
			if (isNaN(temp)) {
				errMsg += t['MECH_VENT_HOURS']+" "+t['INVALID']+"\n";
			} else {			
		
				// SA 11.6.02 - log 24015.
				if ((!CheckMechVentHoursRequired())&&(temp>0)) {
					var OKToContinue=1;
					OKToContinue=confirm(t['MECH_VENT_NOT_REQD']+"\n"+t['OK_CANCEL']);
					if (!(OKToContinue)) {
						return false;
					}
				}
		
				// SA 11.6.02 - log 24015.
				if ((CheckMechVentHoursRequired())&&(temp==0)) {
					var OKToContinue=1;
					OKToContinue=confirm(t['MECH_VENT_REQD']+"\n"+t['OK_CANCEL']);
					if (!OKToContinue) {
						return false;
					}
				}

			}
		} else {
			// SA 11.6.02 - log 24015.
			if (CheckMechVentHoursRequired()) {
				var OKToContinue=1;
				OKToContinue=confirm(t['MECH_VENT_REQD']+"\n"+t['OK_CANCEL']);
				if (!OKToContinue) {
					return false;
				}
			}
		}
	}

	if ((objCPAPHours)&&(objCPAPHours.value!="")) {
		temp=objCPAPHours.value;
		if (isNaN(temp)) {
			errMsg += t['CPAP_HOURS']+" "+t['INVALID']+"\n";
		}
		// RQG 07.07.03 L36701: Round CPAP to the nearest hour
		objCPAPHours.value=Math.round(objCPAPHours.value);
	}

	// AI 17-06-2002 - Log 24579: Add checks for duplicate Diagnosis and Procedure Codes.
	if (!(CheckForDuplicateDRGCode())) {
		return false;
	}

	if (errMsg!="") {
		alert(errMsg);
		return false;
	} else {
		return true;
	}
}

function SubmitForms() {
	
	if (parent.frames["PAAdmDRGCoding"]) var frm=parent.frames["PAAdmDRGCoding"].document.forms["fPAAdm_DRGCoding"];
	if (frm) {
		if (frm.target=="TRAK_hidden") {
			frm.target=window.name;
			frm.action="websys.csp"; 
		}
	}
	// cjb 06/05/2004 43816
	var frm = document.forms["fPAAdm_DRGCoding"];
	if (parent.frames["PAAdmDRGCoding"]) {
		frm.elements['TFRAME'].value=window.parent.name;
	}
	
	//KK L:48760
	if (parent.frames["MRDiagnosEditDRG"]) var objDT=parent.frames["MRDiagnosEditDRG"].document.getElementById('DiagnosTotal');
	if (objDT) var diagtotal=objDT.innerText;
	if (parent.frames["MRProceduresEditDRG"]) var objPT=parent.frames["MRProceduresEditDRG"].document.getElementById("TotalProcedures");
	if (objPT) var proctotal=objPT.innerText;
	if (diagtotal=="0"){
		if (proctotal=="0"){
			if (!CheckDiagnosisCode()) return false;
			if (!HourFieldsPreUpdateCheck()) return false;
			return DRGupdate_click();
		}
	}
	

	// cjb 31/05/2004 44201 - warning message when the age at admission is 28 days or over and the NIV Hours (CPAPHours) is greater than 300 hours
	if (!(CheckCPAPHoursAgainstAge())) {
		return false;
	}
	// cjb 31/05/2004 44201 - warning message when the CCU Hours is greater than 300 hours
	if (!(CheckCCUHours())) {
		return false;
	}
	// cjb 31/05/2004 44201 - warning message when the age at admission is less than 365 days (or 366 if a leap year) and the admission weight (MRADMWeight) is less than 400 grams
	if (!(CheckMRADMWeightAgainstAge())) {
		return false;
	}
	// cjb 01/06/2004 44201 - warning message when the Admission Source (ADSOUDesc) is TE, TJ, TW or TX and there is 0 hours in CCU hours (CCUHours) or ICU hours (ICUHours)
	if (!(CheckPAADMAdmSrc())) {
		return false;
	}

	if (!(DiagnosesEnteredWithProcsCheck())) {
		return false;
	}

	//AJI 23/10/03 - log 40122: should check only if diag codes are not empty
	if (!CheckForAllDiagEmpty()) {
		if ((objAge)&&(objAge.value!="")&&(objAge.value<365)) {
			if (!(CheckAdmissionWeightField())) {
				return false;
			}
		}
	}
	// RQG 15.04.03 L33658: If no Diagnosis code is entered, uncheck Verified flag
	if (!(CheckDiagnosisCode())) {
		return false;
	}
	
	// cjb 08/06/2005 53036
	if (!(CommonUpdateFunctions())) {
		return false;
	}
	
	// L32787
	DisplayEpisodesRequireFU();
	// L32774
	if (!(DisplayPatientReadmitted())) {
		return false;
	}
	// L32768
	DisplayCancerRegDetailsMsg();
	// RQG 08.07.03 L34036
	var objCopyWin=document.getElementById("COPYWindow");
	if ((objCopyWin)&&(objCopyWin.value=="COPY")) {
		DRGupdate_click();
		window.location="websys.close.csp";
		window.location="websys.reload.csp";
		return false;
	}		
	
	// cjb 06/05/2004 43816
	var frm = document.forms["fPAAdm_DRGCoding"];
	if (parent.frames["PAAdmDRGCoding"]) {
		frm.elements['TFRAME'].value=window.parent.name;
	}
	if (!(fPAAdm_DRGCoding_submit())) return false
	//var frm = document.forms["fPAAdm_DRGCoding"];
	//frm.target = "_parent";  // the target must be parent because paadmdrgcoding page is part of a workflow
	
	return DRGupdate_click();
	//return false;
}

function Open3MGrouper() {

	if (objGrouperType) objGrouperType.value="3M";

	if (!(FindDiagnosisEntries())) {
		return false;
	}
	if ((objAge)&&(objAge.value!="")&&(objAge.value<365)) {
		if (!(CheckAdmissionWeightField())) {
			return false;
		}
	}

	// RQG 15.04.03 L33658: If no Diagnosis code is entered, uncheck Verified flag
	if (!(CheckDiagnosisCode())) {
		return false;
	}
	
	// cjb 08/06/2005 53036
	if (!(CommonUpdateFunctions())) {
		return false;
	}
	
	// cjb 06/05/2004 43816
	var frm = document.forms["fPAAdm_DRGCoding"];
	if (parent.frames["PAAdmDRGCoding"]) {
		frm.elements['TFRAME'].value=window.parent.name;
	}
	
	if (!(fPAAdm_DRGCoding_submit())) return false
	//var frm = document.forms["fPAAdm_DRGCoding"];
	//frm.target = "_parent";  // the target must be parent because paadmdrgcoding page is part of a workflow
	
	return B3MGrouper_click();
}

function UpdateWithVisGrouper() {
	//RQG 24.09.03 L32787: This will update the coding details and will run the Visasys Grouper. The difference between
	//this function and 'OpenVisasys' is after the update the page will go to Start Page.
	if (objGrouperType) objGrouperType.value="Visasys";

	DisplayEpisodesRequireFU();

	if (!(DisplayPatientReadmitted())) {
		return false;
	}

	if (!(FindDiagnosisEntries())) {
		return false;
	}

	if ((objAge)&&(objAge.value!="")&&(objAge.value<365)) {
		if (!(CheckAdmissionWeightField())) {
			return false;
		}
	}

	// RQG 15.04.03 L33658: If no Diagnosis code is entered, uncheck Verified flag
	if (!(CheckDiagnosisCode())) {
		return false;
	}

	// cjb 08/06/2005 53036
	if (!(CommonUpdateFunctions())) {
		return false;
	}
	
	// L32768
	DisplayCancerRegDetailsMsg();

	// cjb 06/05/2004 43816
	var frm = document.forms["fPAAdm_DRGCoding"];
	if (parent.frames["PAAdmDRGCoding"]) {
		frm.elements['TFRAME'].value=window.parent.name;
	}
	if (!(fPAAdm_DRGCoding_submit())) return false
	
	// RQG 17.10.03 L34036
	var objCopyWin=document.getElementById("COPYWindow");
	if ((objCopyWin)&&(objCopyWin.value=="COPY")) {
		UpdateWithVisGrouper_click();
		window.parent.opener.location.reload();
		return false;
	}
	return UpdateWithVisGrouper_click();
}

function OpenVisasys() {
	// L32787 new function created
	// L32803
	if (objGrouperType) objGrouperType.value="Visasys";
	DisplayEpisodesRequireFU();

	if (!(DisplayPatientReadmitted())) {
		return false;
	}
	if (!(FindDiagnosisEntries())) {
		return false;
	}
	if ((objAge)&&(objAge.value!="")&&(objAge.value<365)) {
		if (!(CheckAdmissionWeightField())) {
			return false;
		}
	}
	// RQG 15.04.03 L33658: If no Diagnosis code is entered, uncheck Verified flag
	if (!(CheckDiagnosisCode())) {
		return false;
	}

	// cjb 08/06/2005 53036
	if (!(CommonUpdateFunctions())) {
		return false;
	}
	
	// cjb 06/05/2004 43816
	var frm = document.forms["fPAAdm_DRGCoding"];
	if (parent.frames["PAAdmDRGCoding"]) {
		frm.elements['TFRAME'].value=window.parent.name;
	}
	//if (!(fPAAdm_DRGCoding_submit())) return false
	return UpdateVisasys_click();	
}

// cjb 08/06/2005 53036 - new function called from SubmitForms, Open3MGrouper, UpdateWithVisGrouper & OpenVisasys functions to remove duplication
function CommonUpdateFunctions() {
	
	if (!(CheckForBlankDiagDescription())) {
		return false;
	}

	if (!(CheckForBlankProcDescription())) {
		return false;
	}
	if (!(HourFieldsPreUpdateCheck())) {
		return false;
	}
	//KK 21/01/05 L:48931
	if (!(CheckUnacceptablePDx())) {
		return false;
	}
	if (!(DiagnosesEnteredWithPrefixCheck())) {
		return false;
	}
	
	MultipleFUReasons();	//rqg Log24386:
	
		
	// RQG,Log25417: ARMC custom - Validate fields before update
	if (!(ValidateDRGFields())) {
		return false;
	}
	
	// RQG 23.01.03 Log27337: Validate Additional Code Requirement
	if (!(ValidateDiagAddCodeReqmt())) {
		return false;
	}
	if (!(ValidateProcAddCodeReqmt())) {
		return false;
	}
	// RQG 17.02.03 LOG32517: Check Procedure date if its between Admission date and Discharge date
	if (!(ValidateProcDate())) {
		return false;
	}
	
	CreateHiddenDiagFields();
	CreateHiddenProcFields();
	
	// cjb 0909/2004 44777 - IsContracted now done in the custom script
	if (IsContracted()==1) {
			if (!(ValidateContractFlag())) {
			return false;
		}	
	}
	
	//md LOG 53229  29/07/2005
	
	if (!ValidateAccDate()) { return false; }
	
	return true;
}



function Open3MGrouperForInquiry() {

	if (!(InquiryFieldsCheck())) {
		return false;
	}

	// rqg Log24573: ARMC custom - Diagnoses cannot be entered without prefixes.
	//if (!(DiagnosesEnteredWithPrefixCheck())) {
	//	return false;
	//}

	CreateInquiryDiagFields();
	CreateInquiryProcFields();
	CallGrouperForInquiry();
	return false;
}

function CallGrouperForInquiry() {
	// SA 10.7.02 - implemented for log 24621.
	var objDRGPath=document.getElementById("DRGPath");
	var objINQAdmissionDate=document.getElementById("INQAdmissionDate");
	var objINQAdmissionTime=document.getElementById("INQAdmissionTime");
	var objINQDischargeDate=document.getElementById("INQDischargeDate");
	var objINQDischargeTime=document.getElementById("INQDischargeTime");
	var objINQDateOfBirth=document.getElementById("INQDateOfBirth");
	var objINQSex=document.getElementById("INQSex");
	var objINQDischargeType=document.getElementById("INQDischargeType");
	var objMode=document.getElementById("Mode");

	var DRGPath=""; var INQAdmissionDate=""; var INQAdmissionTime=""; var INQDischargeDate=""; var INQDischargeTime=""; var INQDateOfBirth="";
	var INQSex=""; var INQDischargeType=""; var INQDiags=""; var INQProcs=""; var MRADMWeight=""; var INQLeaveDays=""; var Mode="";
	
	if (objDRGPath) DRGPath=objDRGPath.value;
	if (objINQAdmissionDate) INQAdmissionDate=objINQAdmissionDate.value;
	if (objINQAdmissionTime) INQAdmissionTime=objINQAdmissionTime.value;
	if (objINQDischargeDate) INQDischargeDate=objINQDischargeDate.value;
	if (objINQDischargeTime) INQDischargeTime=objINQDischargeTime.value;
	if (objINQDateOfBirth) INQDateOfBirth=objINQDateOfBirth.value;
	if (objINQSex) INQSex=objINQSex.value;
	if (objINQDischargeType) INQDischargeType=objINQDischargeType.value;
	if (objMRADMWeight) MRADMWeight=objMRADMWeight.value;
	if (objINQLeaveDays) INQLeaveDays=objINQLeaveDays.value;
	if (objINQDiags) INQDiags=objINQDiags.value;
	if (objINQProcs) INQProcs=objINQProcs.value;
	//if (objMode) Mode=objMode.value;
	Mode="INQUIRY";
	var url="websys.default.csp?WEBSYS.TCOMPONENT=PAAdmCoding.Edit3MDRG&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&DRGPath="+DRGPath;		
	url += "&INQAdmissionDate="+INQAdmissionDate+"&INQAdmissionTime="+INQAdmissionTime+"&INQDischargeDate="+INQDischargeDate;
	url += "&INQDischargeTime="+INQDischargeTime+"&INQDateOfBirth="+INQDateOfBirth+"&INQSex="+INQSex+"&INQDischargeType="+INQDischargeType;
	url += "&INQDiags="+INQDiags+"&INQProcs="+INQProcs+"&MRADMWeight="+MRADMWeight+"&INQLeaveDays="+INQLeaveDays+"&Mode="+Mode;

	websys_createWindow(url,"TRAK_hidden");
	//return DRGupdate_click();
}

function InquiryFieldsCheck() {

	var errMsg="";
	var temp="";	

	if ((objINQLeaveDays)&&(objINQLeaveDays.value!="")) {
		temp=objINQLeaveDays.value;
		if (isNaN(temp)) {
			errMsg += t['INQLeaveDays']+" "+t['XINVALID']+"\n";
		}
	}

	if ((objMechVentHours)&&(objMechVentHours.value!="")) {
		temp=objMechVentHours.value;
		if (isNaN(temp)) {
			errMsg += t['MechVentHours']+" "+t['INVALID']+"\n";
		}
	}

	if ((objMRADMWeight)&&(objMRADMWeight.value!="")) {
		temp=objMRADMWeight.value;
		if ((isNaN(temp))||(temp>999)) {
			errMsg += t['MRADMWeight']+" "+t['XINVALID']+"\n";
		}
	}

	if (errMsg!="") {
		alert(errMsg);
		return false;
	} else {
		return true;
	}

}

// SA 11.6.02 - These updates were being called by submitting each component to the hidden frame.
// Lack of synchronisation using the hidden frame meant subsequent submits were not allowing the 
// initial submit/save to finish. All saves will now be called from PAAdm.websysSaveDRGGrouping.
// All fields from MRDiagnos.EditDRG used in the save method must be copied over as hidden fields 
// to PAAdm.DRGCoding component, for save to succeed.
function CreateHiddenDiagFields() {

	if (parent.frames["MRDiagnosEditDRG"]) var tbl=parent.frames["MRDiagnosEditDRG"].document.getElementById("tMRDiagnos_EditDRG");
	var TempVar="";
	if (tbl) {	
		var arrInput=tbl.getElementsByTagName("INPUT");
		for (var i=0; i<arrInput.length; i++) {
			//Add the new hidden field and set the properties
			var NewElement=document.createElement("INPUT");
			//alert(arrInput[i].id);
		        //alert(arrInput[i].value);
			NewElement.id = arrInput[i].id;
			NewElement.name = arrInput[i].id;
			NewElement.value = arrInput[i].value;
			NewElement.type = "HIDDEN";
			//add the element to the document order doesn't matter as long as its within the form tags
			document.fPAAdm_DRGCoding.EpisodeID.insertAdjacentElement("afterEnd",NewElement);
			TempVar=TempVar + NewElement.id + "^" + NewElement.value + "||"
		}
		var objDiag=document.getElementById("DIAGFields");
		if (objDiag) objDiag.value=TempVar;
		//alert(TempVar);
	}
}

// SA 11.6.02 - These updates were being called by submitting each component to the hidden frame.
// Lack of synchronisation using the hidden frame meant subsequent submits were not allowing the 
// initial submit/save to finish. All saves will now be called from PAAdm.websysSaveDRGGrouping.
// All fields from MRProcedures.EditDRG used in the save method must be copied over as hidden fields
// to PAAdm.DRGCoding component, for save to succeed.
function CreateHiddenProcFields() {
	
	var TempVar="";
	if(parent.frames["MRProceduresEditDRG"]) var tbl=parent.frames["MRProceduresEditDRG"].document.getElementById("tMRProcedures_EditDRG");
	
	if (tbl) {
		var arrInput=tbl.getElementsByTagName("INPUT");
		for (var i=0; i<arrInput.length; i++) {
			//Add the new hidden field and set the properties
			var NewElement=document.createElement("INPUT");
			NewElement.id = arrInput[i].id;
			NewElement.name = arrInput[i].id;
			NewElement.value = arrInput[i].value;
			NewElement.type = "HIDDEN";

			//add the element to the document order doesn't matter as long as its within the form tags
			document.fPAAdm_DRGCoding.EpisodeID.insertAdjacentElement("afterEnd",NewElement);
			//document.fPAAdm_DRGCoding.insertAdjacentElement("afterEnd",NewElement);
			TempVar=TempVar + NewElement.id + "^" + NewElement.value + "||"
		}
		var objProc=document.getElementById("PROCFields");
		if (objProc) objProc.value=TempVar;
	}
}

// SA 10.7.02 - implemented for log 24621. All selected diagnosis descriptions will be 
// concatenated into one string, separated by "^", to be retrieved by cache method web.PAAdmCoding.Create3MDRGInquiry
function CreateInquiryDiagFields() {
	
	if (parent.frames["MRDiagnosEditDRG"]) var tbl=parent.frames["MRDiagnosEditDRG"].document.getElementById("tMRDiagnos_EditDRG");
	if (tbl) {
		var DiagStr="";
		var arrInput=tbl.getElementsByTagName("INPUT");
		for (var i=0; i<arrInput.length; i++) {
			//alert("adding diag:"+arrInput[i].id+":"+arrInput[i].name+":"+arrInput[i].value);
			var arrId=arrInput[i].id.split('z');
			if (arrInput[i].value!="") {	
				//alert("arrId[0]="+arrId[0]+" arrInput[i].value="+arrInput[i].value);
				if (arrId[0]=="MRDIAICDCodeDRCode") DiagStr += arrInput[i].value + "^";
				if (arrId[0]=="CodeExt1") DiagStr += arrInput[i].value + "^";
				if (arrId[0]=="CodeExt2") DiagStr += arrInput[i].value + "^";
				if (arrId[0]=="CodeExt3") DiagStr += arrInput[i].value + "^";
			}
		}
		objINQDiags.value=DiagStr;
	}
}

// SA 10.7.02 - implemented for log 24621. All selected procedure codes will be 
// concatenated into one string, separated by "^", to be retrieved by cache method
// web.PAAdmCoding.Create3MDRGInquiry. Order will be as entered.
function CreateInquiryProcFields() {

	if(parent.frames["MRProceduresEditDRG"]) var tbl=parent.frames["MRProceduresEditDRG"].document.getElementById("tMRProcedures_EditDRG");
	if (tbl) {
		var ProcStr="";
		var arrInput=tbl.getElementsByTagName("INPUT");
		for (var i=0; i<arrInput.length; i++) {
			var arrId=arrInput[i].id.split('z');
			if ((arrId[0]=="PROCOperationDRCode")&&(arrInput[i].value!="")) {
				ProcStr += arrInput[i].value + "^";
			}
		}
		objINQProcs.value=ProcStr;		
	}
}

// AJI 19.11.03 log 39205 : New function
// This function is similar to functionality with CreateInquiryProcFields() except this one passes the proc. date
function CreateInquiryProcDateFields() {

	if(parent.frames["MRProceduresEditDRG"]) var tbl=parent.frames["MRProceduresEditDRG"].document.getElementById("tMRProcedures_EditDRG");
	if (tbl) {
		var drgcode="";
		var procdate="";
		var arrInput=tbl.getElementsByTagName("INPUT");
		for (var i=0; i<arrInput.length; i++) {
			var arrId=arrInput[i].id.split('z');
			
			if (arrId[0]=="PROCOperationDRCode") 
				drgcode = arrInput[i].value;

			if (arrId[0]=="PROCProcDate" && drgcode!="") 
				procdate += arrInput[i].value + "^";			
		}
		objINQProcDates.value=procdate;
	}
}

// SA 11.6.02 - log 24015: Method created to check whether a procedure has been 
// selected which requires the Mechanical ventilation hours to be entered. This method returns true if so.
function CheckMechVentHoursRequired() {
	
	//AJI 23/10/03 - log 40122: shouldn't check if all codes are empty
	if (CheckForAllDiagEmpty())
		return false;

	if (parent.frames["MRProceduresEditDRG"]) var tbl=parent.frames["MRProceduresEditDRG"].document.getElementById("tMRProcedures_EditDRG");
	if (tbl) {
		var arrInput=tbl.getElementsByTagName("INPUT");
		for (var i=0; i<arrInput.length; i++) {
			var arrId=arrInput[i].id.split('z');
			if (arrId[0]=="OPERMechVentilCode") {
				if (arrInput[i].value=="Y") {
					return true;
				}
			}
		}		
	}
	return false;
}

function CheckAdmissionWeightField() {
	// code moved to QH custom script
	return true;
}

// SA 29.7.02 - Log 24579: Check whether a Diagnosis Code has been entered more than once
// with the same Prefix. User has the option to stop the save, or continue.
function CheckForDuplicateDRGCode() {

	if (parent.frames["MRDiagnosEditDRG"]) var tbl=parent.frames["MRDiagnosEditDRG"].document.getElementById("tMRDiagnos_EditDRG");
	//MD 18.05.2005 52361
	var tempcont1=""
	var ddwarn=""
	// MD 18.05.2005 52361	
	if (tbl) {
		var DiagStr=""; var CurrPrefix=""; var CurrICD=""; var morphology=""; var extcause=""; var addreq=""; var cont=""; var allowdup="";
		var arrInput=tbl.getElementsByTagName("INPUT");
		for (var i=0; i<arrInput.length; i++) {
			//alert("adding diag:"+arrInput[i].id+":"+arrInput[i].name+":"+arrInput[i].value);
			var arrId=arrInput[i].id.split('z');
			if (arrInput[i].value!="") {
				//Prefix applies to entire row.
				if (arrId[0]=="MRDIAPrefix") CurrPrefix = arrInput[i].value;
				// RQG - L32790
				if (arrId[0]=="MRCIDMorphologyCode") morphology = arrInput[i].value;
				if (arrId[0]=="MRCIDExternalCause") extcause = arrInput[i].value;
				if (arrId[0]=="AddCodeRqmt") addreq = arrInput[i].value;
				if (arrId[0]=="MRCIDAllowToDuplicate") allowdup= arrInput[i].value;
				if ((arrId[0]=="MRDIAICDCodeDRCode")||(arrId[0]=="CodeExt1")||(arrId[0]=="CodeExt2")||(arrId[0]=="CodeExt3")) {
					if (DiagStr=="") {
						DiagStr = CurrPrefix + "^" + arrInput[i].value + "^" + morphology + "^" + extcause + "^" + addreq + "^" + allowdup + "|";
					} else {
						DiagStr = DiagStr + CurrPrefix + "^" + arrInput[i].value + "^" + morphology + "^" + extcause + "^" + addreq + "^" + allowdup + "|";
					}
				}
			}
		}
					
		for (var j=0; mPiece(DiagStr,"|",j)!=""; j++) {
			var str=mPiece(DiagStr,"|",j);
			CurrPrefix = mPiece(str,"^",0);
			CurrICD = mPiece(str,"^",1);
			morphology = mPiece(str,"^",2);
			extcause = mPiece(str,"^",3);
			addreq = mPiece(str,"^",4);
			allowdup = mPiece(str,"^",5);
			//alert("CurrPrefix=" + CurrPrefix + "  CurrICD=" + CurrICD + "  morphology=" + morphology + "  extcause=" + extcause + "  addreq=" + addreq + "  allowdup ="+ allowdup );
			var nextPrefix=""; var nextICD=""; var nextStr="";
			for (var k=j+1; mPiece(DiagStr,"|",k)!=""; k++) {
				nextStr=mPiece(DiagStr,"|",k)
				nextPrefix=mPiece(nextStr,"^",0);
				nextICD=mPiece(nextStr,"^",1);
				//KK 9/7/04 L:44082
				if (allowdup =="Y" && CurrICD == nextICD) {
					cont=1;
					//MD 18.05.2005 52361 only 1 warning per case
					ddwarn=t['ICD_CODE']+CurrICD+t['ENTERED_TWICE']+t['CONTINUE'];
					if (ddwarn!=tempcont1) {
						tempcont1=ddwarn;
						cont=confirm(t['ICD_CODE']+CurrICD+t['ENTERED_TWICE']+t['CONTINUE']);
						if (!cont) {
							return false;
						}
					}
				} else {
					if (CurrPrefix == nextPrefix && CurrICD == nextICD) {
						if (((morphology=="") || (morphology=="N")) && ((extcause=="") || (extcause=="N")) && (addreq != 4)) {
							alert(t['ICD_CODE']+CurrICD+t['ENTERED_TWICE_PREFIX']);
							return false;
						} else {
							cont=1;
							//MD 18.05.2005 52361 only 1 warning per case
							ddwarn=t['ICD_CODE']+CurrICD+t['ENTERED_TWICE_PREFIX']+t['CONTINUE'];
							if (ddwarn!=tempcont1) {
								tempcont1=ddwarn;
								cont=confirm(t['ICD_CODE']+CurrICD+t['ENTERED_TWICE_PREFIX']+t['CONTINUE']);
								if (!cont) {
									return false;
								}
							}
						}
					}
				}
			}
		}
	}
	return true;
}

// AI 17-06-2002 - Log 24579: Method created to check whether a Procedures Code has been entered more than once
// 			for the current Episode. This method returns true if so.
function CheckForDuplicateProceduresCode() {
	if (parent.frames["MRProceduresEditDRG"]) var tbl=parent.frames["MRProceduresEditDRG"].document.getElementById("tMRProcedures_EditDRG");
	if (tbl) {
		var arrInput=tbl.getElementsByTagName("INPUT");
		// start at the first Procedures Code and work through each row
		for (var x=0; x<arrInput.length-1; x++) {
			var xarrId=arrInput[x].id.split('z');
			// making sure the row's Procedures Code has a value
			if ((xarrId[0]=="PROCOperationDRCode")&&(arrInput[x].value!="")) {
				for (var y=x+1; y<arrInput.length; y++) {
					var yarrId=arrInput[y].id.split('z');
					if (yarrId[0]=="PROCOperationDRCode") {
						// compare the Procedures Codes
						// if the Procedures Codes match a duplicate has been found
						if (arrInput[y].value==arrInput[x].value) {
							var ProcDuplicateOK=1;
							ProcDuplicateOK=confirm(t['PROC_CODE']+arrInput[y].value+t['ENTERED_TWICE']+t['CONTINUE']);
							if (!ProcDuplicateOK) {
								return false;
							}
						}
					}
				}
			}
		}
	}
	return true;
}

function DiagnosesEnteredWithProcsCheck() {
	// SA 24114: ARMC custom - Procedures cannot be entered without diagnoses.
	// This is a dummy function here. Checks for ARMC done via custom js
	return true;
}

function DiagnosesEnteredWithPrefixCheck() {
	// rqg Log24573: ARMC custom - Diagnoses cannot be entered without prefixes.
	// This is a dummy function here. Checks for ARMC done via custom js
	return true;
}
function IconClick(evt) {
	return false;
}

//L32790
//function ValidateDiagPairCode() {
//	// This is a dummy function here. Checks for QH done via custom js
//	return true;
//}

function DisplayEpisodesRequireFU() {
	// This is a dummy function here. Checks for QH done via custom js
	return true;
}

function DisplayPatientReadmitted() {
	// This is a dummy function here. Checks for QH done via custom js
	return true;
}

function DisplayCancerRegDetailsMsg() {
	// This is a dummy function here. Checks for QH done via custom js
	return true;
}

// * 35988
// cjb 10/02/2006 57307 - also check for invalid field and delete it
function CheckForBlankDiagDescription() {
	var blankrow=0; var filledrow=0; var lastblankrow=0; var invalid=0;
	if (parent.frames["MRDiagnosEditDRG"]) var frm = parent.frames["MRDiagnosEditDRG"].document.forms["fMRDiagnos_EditDRG"];
	if (frm) {
		var tbl=frm.document.getElementById("tMRDiagnos_EditDRG");
		if (tbl) {
			var arrInput=tbl.getElementsByTagName("INPUT");
			for (var i=1; i<tbl.rows.length; i++) {
				var diag=""; var del="";
				var arrfld=tbl.rows[i].getElementsByTagName('INPUT');
				for (var j=0; j<arrfld.length; j++) {
					if (arrfld[j].id.indexOf("MRDIAICDCodeDRDescz")==0) diag=arrfld[j];
				}
				if ((diag)&&(diag.value!="")) {
					filledrow=i;
					lastblankrow=blankrow;
				} else {
					blankrow=i;
				}
				if ((diag)&&(diag.value!="")&&(diag.className=="clsInvalid")) {	// cjb 10/02/2006 57307 - if the description is invalid delete the row
					//del=parent.frames["MRDiagnosEditDRG"].document.getElementById('MRDIAdeletez'+i);
					//if (del) del.click();
					invalid=i;
				}
			}
		}
		if ( (lastblankrow > 0) && (filledrow > 0) && (filledrow > lastblankrow) ) {
			alert(t['DIAG_BLANK_ROW']);
			websys_setfocus("MRDIAICDCodeDRDescz"+lastblankrow);
			return false;
		}
		if (invalid!=0) {
			alert(t['INVALID_CODE']);
			websys_setfocus("MRDIAICDCodeDRDescz"+invalid);
			return false;
		}
	}
	return true;
}



// cjb 10/02/2006 57307 - also check for invalid field and delete it
function CheckForBlankProcDescription() {
	var blankrow=0; var filledrow=0; var lastblankrow=0; var invalid=0;
	if (parent.frames["MRProceduresEditDRG"]) var frm = parent.frames["MRProceduresEditDRG"].document.forms["fMRProcedures_EditDRG"];
	if (frm) {
		var tbl=frm.document.getElementById("tMRProcedures_EditDRG");
		if (tbl) {
			var arrInput=tbl.getElementsByTagName("INPUT");
			for (var i=1; i<tbl.rows.length; i++) {
				var proc=""; var del="";
				var arrfld=tbl.rows[i].getElementsByTagName('INPUT');
				for (var j=0; j<arrfld.length; j++) {
					if (arrfld[j].id.indexOf("PROCOperationDRDescz")==0) proc=arrfld[j];
				}
				if ((proc)&&(proc.value!="")) {
					filledrow=i;
					lastblankrow=blankrow;
				} else {
					blankrow=i;
				}
				if ((proc)&&(proc.value!="")&&(proc.className=="clsInvalid")) {	// cjb 10/02/2006 57307 - if the description is invalid delete the row
					//del=parent.frames["MRProceduresEditDRG"].document.getElementById('PROCdeletez'+i);
					//if (del) del.click();
					invalid=i;
				}
			}
		}
		if ( (lastblankrow > 0) && (filledrow > 0) && (filledrow > lastblankrow) ) {
			alert(t['PROC_BLANK_ROW']);
			websys_setfocus("PROCOperationDRDescz"+lastblankrow);
			return false;
		}
		if (invalid!=0) {
			alert(t['INVALID_CODE']);
			websys_setfocus("MRDIAICDCodeDRDescz"+invalid);
			return false;
		}
	}
	return true;
}

//Aji - 23/10/03 - log 40122
function CheckForAllDiagEmpty() {
	var frm = null;
	if (parent.frames["MRDiagnosEditDRG"]) frm = parent.frames["MRDiagnosEditDRG"].document.forms["fMRDiagnos_EditDRG"];
	if (frm == null) return true;
		
	var tbl=frm.document.getElementById("tMRDiagnos_EditDRG");
	if (tbl) {
		var arrInput=tbl.getElementsByTagName("INPUT");
		for (var i=0; i<arrInput.length; i++) {
			var arrId=arrInput[i].id.split('z');
			if (arrId[0]=="MRDIAICDCodeDRDesc") {
				if (arrInput[i].value!="") {
					return false;
				}
			}
		}
	}
	return true;
}

// * L35990
function FindDiagnosisEntries() {
	var entry="No"; var rowLen=0;
	if (parent.frames["MRDiagnosEditDRG"]) var frm = parent.frames["MRDiagnosEditDRG"].document.forms["fMRDiagnos_EditDRG"];
	if (frm) {
		var tblDiag=frm.document.getElementById("tMRDiagnos_EditDRG");
		
		if (tblDiag) {
			rowLen=tblDiag.rows.length;
			for (var i=0;i<rowLen;i++) {
				var objDiagDesc=frm.document.getElementById("MRDIAICDCodeDRDescz"+i);
				if ((objDiagDesc)&&(objDiagDesc.value!="")) {
					entry="Yes";
					break;
				}
			}
		}
		if (entry=="No") {
			alert(t['NO_DIAG_ENTRIES_FOUND']);
			websys_setfocus("MRDIAICDCodeDRDescz1");
			return false;
		}
	}
	return true;
}

//rqg Log24386
function MultipleFUReasons() {
	var objFUpReasonStr=document.getElementById("FollowUpReasonString")
	var FURCode="";
	if (objFollowupReason) {
		for (var i=(objFollowupReason.length-1); i>=0; i--) {
			if (objFollowupReason.options[i].selected) {
				FURCode=FURCode+objFollowupReason.options[i].text+"|";
			}
		}
	}
	//KK 12/May/2003 Log 35005
	if (FURCode==""){
		var objRFU=document.getElementById('RequiresFollowUpList');
		if (objRFU) {
			for (var i=(objRFU.length-1); i>=0; i--) {
				FURCode=FURCode+objRFU.options[i].text+"|";
			}
		}
	}
	if (objFUpReasonStr) objFUpReasonStr.value=FURCode;
}

// RQG,Log25417: ARMC custom - Validate fields before update
function ValidateDRGFields() {
	// This is a dummy function here. Check for ARMC done via custom js
	return true;
}
function CheckCodePrefix() {
	// This is a dummy function here. Check for ARMC done via custom js
	return true;
}
// RQG 23.01.03 Log27337: ARMC Custom - Validate Additional Code Requirements
function ValidateDiagAddCodeReqmt() {
	// This is a dummy function here. Check for ARMC done via custom js
	return true;
}
function ValidateProcAddCodeReqmt() {
	// This is a dummy function here. Check for ARMC done via custom js
	return true;
}
function ValidateContractFlag() {
	// This is a dummy function here. Check for QH done via custom js
	return true;
}
function CheckDiagnosisCode() {
	// This is a dummy function here. Check for QH done via custom js
	return true;
}
// cjb 31/05/2004 44201
function CheckCPAPHoursAgainstAge() {
	// This is a dummy function here. Check for ARMC done via custom js
	return true;
}
function CheckCCUHours() {
	// This is a dummy function here. Check for ARMC done via custom js
	return true;
}
function CheckMRADMWeightAgainstAge() {
	// This is a dummy function here. Check for ARMC done via custom js
	return true;
}
function CheckPAADMAdmSrc() {
	// This is a dummy function here. Check for ARMC done via custom js
	return true;
}

function ValidateAccDate() {
      // This is a dummy function here. Check for stge done via custom js
      return true;
}


function mPiece(s1,sep,n) {
	//Split the array with the passed delimeter
      delimArray = s1.split(sep);
	//If out of range, return a blank string
      if ((n <= delimArray.length-1) && (n >= 0)) {
        return delimArray[n];
	} else {
	  return ""					
      }
}

//KK 10/Sep/2002 Log 28290
//AJI 14.11.03 Log 40633
function CheckforHiddenDiagnosisFields() {
	var tempstr="";
	var objDia=document.getElementById("DIAGFields");
	if (objDia) tempstr=objDia.value;	
	if (tempstr=="") return;
	var lu=tempstr.split("||");
	if (parent.frames["MRDiagnosEditDRG"]== null) return;
	var frm = parent.frames["MRDiagnosEditDRG"].document.forms["fMRDiagnos_EditDRG"];
	if (frm==null) return;
	var tbl=frm.document.getElementById("tMRDiagnos_EditDRG");
	if (tbl==null) return;
	var arrInput=tbl.getElementsByTagName("INPUT");
	
	//need to delete existing rows, except the first
	//KK 25.10.04 L:46995 - commented deletetion of rows
	//for (var i=tbl.rows.length-1; i>1; i--) {
	//	tbl.deleteRow(i);
	//}
	for (var i=0; i<arrInput.length; i++) {
		var arrId=arrInput[i].id.split('z');
		if (arrId[0]!="LineNo")
			arrInput[i].value="";
	}

	for (var i=0; ; i++) {
		if (lu[i] && lu[i]!="") {
			if (arrInput[i]) {
				if (arrInput[i].id == mPiece(lu[i],"^",0) && mPiece(lu[i],"^",1)!="")
					arrInput[i].value = mPiece(lu[i],"^",1);
			}
			else AddRow(tbl);
		}
		else return;
	}
}

//KK 12/Sep/2002 Log 28290
//AJI 14.11.03 Log 40633
function CheckforHiddenProcedureFields() {
	var tempstr="";
	var objProc=document.getElementById("PROCFields");
	if (objProc) tempstr=objProc.value;
	if (tempstr=="") return;
	var lu=tempstr.split("||");
	if (parent.frames["MRProceduresEditDRG"]==null) return;
	var frm = parent.frames["MRProceduresEditDRG"].document.forms["fMRProcedures_EditDRG"];
	if (frm==null) return;
	var tbl=frm.document.getElementById("tMRProcedures_EditDRG");
	if (tbl==null) return;
	var arrInput=tbl.getElementsByTagName("INPUT");	
	
	//need to delete existing rows, except the first
	//KK 25.10.04 L:46995 - commented deletetion of rows
	//for (var i=tbl.rows.length-1; i>1; i--) {
	//	tbl.deleteRow(i);
	//}
	for (var i=0; i<arrInput.length; i++) {
		var arrId=arrInput[i].id.split('z');
		if (arrId[0]!="ProcLine")
			arrInput[i].value="";
	}

	for (var i=0; ; i++) {
		if (lu[i] && lu[i]!="") {
			if (arrInput[i]) {
				if (arrInput[i].id == mPiece(lu[i],"^",0) && mPiece(lu[i],"^",1)!="") {
					arrInput[i].value = mPiece(lu[i],"^",1);
				}
			}
			else AddRow(tbl);
		}
		else return;
	}

}

// rqg,Log27545 11/sep/2002
// kk 20/5/2003 Log 33703
function SetMRDiagnosDischargeDate() {
	dischdate="";
	if (parent.frames["MRDiagnosEditDRG"]) {	
		var frm = parent.frames["MRDiagnosEditDRG"].document.forms["fMRDiagnos_EditDRG"];
		var frmproc= parent.frames["MRProceduresEditDRG"].document.forms["fMRProcedures_EditDRG"];
		if ((frm)&&(frmproc)){
			if ((objEpisodeID) && (objEpisodeID.value=="INQUIRY")) {
				if ((frm.MRDischargeDate)&&(objINQDischargeDate)) {
					if (objINQDischargeDate.value!="") {
						frm.MRDischargeDate.value=objINQDischargeDate.value;
						dischdate=frm.MRDischargeDate.value; // dischdate is defined in MRDiagnos.EditDRG
						if ((frmproc)&&(frmproc.DischDate)) frmproc.DischDate.value=dischdate; //discharge date in MRProcedures.EditDRG
		
					}
				}
			}
		}
	}
}

//rqg, 21.11.02 - Log28511: Enable 'View WEIS Details'link if WIES score has been calculated
function CheckWEISScore() {
	var objWEISScore=document.getElementById("MRADMTotalWIESScore");
	var objViewWEISDetails=document.getElementById("ViewWEISDetails");

	if ((objWEISScore)&&(objWEISScore.tagName=="LABEL")&&(objWEISScore.innerText!="")&&(objWEISScore.innerText!=" ")) {
		if (objViewWEISDetails) {
			objViewWEISDetails.disabled=false;
		}
	} else {
		if (objViewWEISDetails) {
			objViewWEISDetails.disabled=true;
			objViewWEISDetails.onclick=LinkDisable;
		}
	}
	return true;
}

function ViewWEISDetailsSCR(evt) {
	var el = websys_getSrcElement(evt);
	if (!el.disabled) {
		var MRAdmID; var DischDate;
		var objmradmid=document.getElementById("mradm");
		if (objmradmid) MRAdmID=objmradmid.value;
		if (objDischargeDate) DischDate=objDischargeDate.value;

		var url="websys.default.csp?WEBSYS.TCOMPONENT=PAAdm.DRGCodingWEISDetails"+"&episodeid="+EpisodeID+"&mradmid="+MRAdmID+"&DischDate="+DischDate;
		websys_lu(url,false,"width=650,height=460,top=30,left=60");
	}
	return false;
}

//rqg, 22.11.02 - Log29161: Enable 'View CRAFT Details'link if CRAFT score has been calculated
function CheckCRAFTScore() {
	var objCRAFTScore=document.getElementById("CRAFTScore");
	var objViewCRAFTDetails=document.getElementById("ViewCRAFTDetails");

	if ((objCRAFTScore)&&(objCRAFTScore.tagName=="LABEL")&&(objCRAFTScore.innerText!="")&&(objCRAFTScore.innerText!=" ")) {
		if (objViewCRAFTDetails) {
			objViewCRAFTDetails.disabled=false;
		}
	} else {
		if (objViewCRAFTDetails) {
			objViewCRAFTDetails.disabled=true;
			objViewCRAFTDetails.onclick=LinkDisable;
		}
	}
	return true;
}

function ViewCRAFTDetailsSCR(evt) {
	var el = websys_getSrcElement(evt);
	if (!el.disabled) {
		var CRAFTCategory; var CRAFTStayStatus; var TotalLengthOfStay; var CRAFTScore; var CRAFTPrice; var CRAFTPaymentRate; var SameDay;
		var LowInlierBoundary; var HighInlierBoundary; var SameDayWeight; var ShortStayWeight;
		var LowOutlierPerDiem; var InlierWeight; var HighOutlierDays; var HighOutlierPerDiem; var CRAFTCDHSAverageLOS;

		var objCRAFTCategory=document.getElementById("CRAFTCategory");
		if (objCRAFTCategory) CRAFTCategory=objCRAFTCategory.value;

		var objCRAFTStayStatus=document.getElementById("CRAFTStayStatus");
		if (objCRAFTStayStatus) CRAFTStayStatus=objCRAFTStayStatus.value;

		var objTotalLengthOfStay=document.getElementById("TotalLengthOfStay");
		if (objTotalLengthOfStay) TotalLengthOfStay=objTotalLengthOfStay.value; 

		var objCRAFTScore=document.getElementById("CRAFTScore");
		if (objCRAFTScore) CRAFTScore=objCRAFTScore.value;

		var objCRAFTPrice=document.getElementById("CRAFTPrice");
		if (objCRAFTPrice) CRAFTPrice=objCRAFTPrice.value;

		var objCRAFTPaymentRate=document.getElementById("CRAFTPaymentRate");
		if (objCRAFTPaymentRate) CRAFTPaymentRate=objCRAFTPaymentRate.value;

		var objSameDay=document.getElementById("SameDay");
		if (objSameDay) SameDay=objSameDay.value;

		var objLowInlierBoundary=document.getElementById("LowInlierBoundary");
		if (objLowInlierBoundary) LowInlierBoundary=objLowInlierBoundary.value;

		var objHighInlierBoundary=document.getElementById("HighInlierBoundary");
		if (objHighInlierBoundary) HighInlierBoundary=objHighInlierBoundary.value;

		var objSameDayWeight=document.getElementById("SameDayWeight");
		if (objSameDayWeight) SameDayWeight=objSameDayWeight.value;

		var objShortStayWeight=document.getElementById("ShortStayWeight");
		if (objShortStayWeight) ShortStayWeight=objShortStayWeight.value;

		var objLowOutlierPerDiem=document.getElementById("LowOutlierPerDiem");
		if (objLowOutlierPerDiem) LowOutlierPerDiem=objLowOutlierPerDiem.value;

		var objInlierWeight=document.getElementById("InlierWeight");
		if (objInlierWeight) InlierWeight=objInlierWeight.value;

		var objHighOutlierDays=document.getElementById("HighOutlierDays");
		if (objHighOutlierDays) HighOutlierDays=objHighOutlierDays.value;

		var objHighOutlierPerDiem=document.getElementById("HighOutlierPerDiem");
		if (objHighOutlierPerDiem) HighOutlierPerDiem=objHighOutlierPerDiem.value;

		var objCRAFTCDHSAverageLOS=document.getElementById("CRAFTCDHSAverageLOS");
		if (objCRAFTCDHSAverageLOS) CRAFTCDHSAverageLOS=objCRAFTCDHSAverageLOS.value;

		//var url="websys.default.csp?WEBSYS.TCOMPONENT=BLCCRAFTDetails.Custom"+"&episodeid="+EpisodeID+"&CRAFTCategory="+CRAFTCategory+"&CRAFTStayStatus="+CRAFTStayStatus+"&CRAFTPrice="+CRAFTPrice+"&CRAFTScore="+CRAFTScore+"&LOS="+TotalLengthOfStay;
		//var url="websys.default.csp?WEBSYS.TCOMPONENT=BLCCRAFTDetails.Custom"+"&episodeid="+EpisodeID+"&CRAFTCategory="+CRAFTCategory+"&CRAFTStayStatus="+CRAFTStayStatus+"&CRAFTPrice="+CRAFTPrice+"&CRAFTScore="+CRAFTScore+"&LOS="+TotalLengthOfStay+"&CRAFTPaymentRate="+CRAFTPaymentRate+"&HighOutlierDays="+HighOutlierDays+"&SameDay="+SameDay+"&LowInlierBoundary="+LowInlierBoundary+"&HighInlierBoundary="+HighInlierBoundary+"&SameDayWeight="+SameDayWeight+"&ShortStayWeight="+ShortStayWeight+"&LowOutlierPerDiem="+LowOutlierPerDiem+"&InlierWeight="+InlierWeight+"&HighOutlierDays="+HighOutlierDays+"&HighOutlierPerDiem="+HighOutlierPerDiem;
		var url="websys.default.csp?WEBSYS.TCOMPONENT=BLCCRAFTDetails.Custom"+"&episodeid="+EpisodeID+"&CRAFTCategory="+CRAFTCategory+"&CRAFTStayStatus="+CRAFTStayStatus+"&CRAFTPrice="+CRAFTPrice+"&CRAFTScore="+CRAFTScore+"&LOS="+TotalLengthOfStay+"&CRAFTPaymentRate="+CRAFTPaymentRate+"&HighOutlierDays="+HighOutlierDays+"&SameDay="+SameDay+"&LowInlierBoundary="+LowInlierBoundary+"&HighInlierBoundary="+HighInlierBoundary+"&SameDayWeight="+SameDayWeight+"&ShortStayWeight="+ShortStayWeight+"&LowOutlierPerDiem="+LowOutlierPerDiem+"&InlierWeight="+InlierWeight+"&HighOutlierPerDiem="+HighOutlierPerDiem+"&CRAFTCDHSAverageLOS="+CRAFTCDHSAverageLOS; 

		websys_lu(url,false,"width=650,height=310,top=30,left=60");
	}
	return false;
}

// RQG 29.01.03 Log 28510
function RunWIESInquiry(evt) {
	var el = websys_getSrcElement(evt);
	if (!el.disabled) {
		var drgcode; var drgdesc;
		var objDRGCode=document.getElementById("DRGCode");
		if (objDRGCode) drgcode=objDRGCode.innerText;
		var objDRGDesc=document.getElementById("DRGDesc");
		if (objDRGDesc) drgdesc=objDRGDesc.innerText;
		var url="websys.default.csp?WEBSYS.TCOMPONENT=WIESInquiry.Custom"+"&DRGCode="+drgcode+"&DRGDesc="+drgdesc;
		websys_createWindow(url,false,"width=650,height=460,top=30,left=60");
	}
	return false;
}

// RQG 17.02.03 LOG32517: New function to sanity check Pocedure date against admission and discharge dates
// RQG 24.06.03 L32770:	Allow any date before admission date and after discharged date if episode is contracted
function ValidateProcDate() {
	
	var objIsContracted=document.getElementById("IsContracted");
	if ((objIsContracted)&&(objIsContracted.value==1)) return true;
	
	var frmproc= parent.frames["MRProceduresEditDRG"].document.forms["fMRProcedures_EditDRG"];
	if (frmproc) {
		var objProcCode1=frmproc.document.getElementById("PROCOperationDRDescz1");
		var objWarnProcDate=frmproc.document.getElementById("WarnProcDate");
		var tbl=frmproc.document.getElementById("tMRProcedures_EditDRG");
		if (tbl) {
			var arrInput=tbl.getElementsByTagName("INPUT");
			// start at the first Procedures Date and work through each row
			for (var i=0; i<arrInput.length-1; i++) {
				var arrId=arrInput[i].id.split('z');
				if (arrId[0]=="ProcDateMandatory") datemandatory=arrInput[i].value;
				if (arrId[0]=="PROCProcDate") {
					var procdate="";
					procdate=arrInput[i].value;
					// RQG 25.06.03 L32770: Display message if procedure code is mandatory and date is left blank
					if ((objProcCode1)&&(objProcCode1.value!="")) {
						if ((procdate.length==0)&&(datemandatory=="Y")) {
							alert(t['PROCDATE_MANDATORY']);
							arrInput[i].focus();
							return false;
						}
						// RQG 15.07.03 L32770: The code below was commented out as it should not display the
						// message when the procedure code date is not mandatory. For CANTECH site, needs to
						// make the procedure code date mandatory in the 'Operation/Procedures CT'.
				   		//if ((arrId[1]==1)&&(procdate.length==0)) {
						//	alert(t['PROCDATE_BLANK']);
						//	//websys_setfocus(arrInput[i].id);
						//	arrInput[i].focus();
						//	return false;
						//}
					}
					var compstr="";
					
					if (procdate!="") compstr = DateStringCompare(procdate,objAdmDate.value);
					
					if (compstr == -1) {
						// cjb 18/10/2004 46434 - if the system param is not on, use alert, otherwise use confirm instead
						if (objWarnProcDate.value!="Y") {
							// Procedure Date is less than Admission Date
							alert(t['PROCDATE_LESS_ADMDATE']);
							arrInput[i].focus();
							return false;
						} else {
							if (!(confirm(t['PROCDATE_LESS_ADMDATE']))) {
								arrInput[i].focus();
								return false;
							} 
						}
					}

					if (procdate!="") compstr = DateStringCompare(procdate,objDischargeDate.value);
					if (compstr == 1) {
						// cjb 18/10/2004 46434 - if the system param is not on, use alert, otherwise use confirm instead
						if (objWarnProcDate.value!="Y") {
							// Procedure Date is greater than Discharged Date
							alert(t['PROCDATE_GREATER_DISCHDATE']);
							arrInput[i].focus();
							return false;
						} else {
							if (!(confirm(t['PROCDATE_GREATER_DISCHDATE']))) {
								arrInput[i].focus();
								return false;
							} 
						}
					}
				}
			}
		}
	}
	return true;
}

function SplitDateStr(strDate) {
 	
 	// cjb 13/07/2004 - use the function in websys.DateTime.Tools.js
 	return DateStringToArray(strDate);
 	
}

//KK 02/Apr/2003 Log 32776
function LookUpDRGCodingSelect(str){
	var tlu=str.split("^");
	parent.frames["MRDiagnosEditDRG"].ClearDiagnoses();
	parent.frames["MRProceduresEditDRG"].ClearProcedures();
	//To add Diagnosis desc and code
	if (tlu[2]) {
		var tempstr=tlu[2];
		AssignDiagnosis(tempstr);
	}
	if (tlu[3]) {
		var tempstr=tlu[3];
		AssignProcedures(tempstr);
	}
}

// cjb 30/06/2006 56092
function LookUpDRGGrouperVersionSelect(str){
	var lu=str.split("^");
	var obj=document.getElementById("DRGGrouperVersionID");
	
	if (obj) obj.value=lu[1];
}


//KK 15/9/03 L:32776 - Functions AssignDiagnosis & AssignProcedures modified to populate fields irrespective of the order of the fields in the table.
function AssignDiagnosis(tempstr){
	if (tempstr!=""){
		var lu=tempstr.split("||");
		var tbl=parent.frames["MRDiagnosEditDRG"].document.getElementById("tMRDiagnos_EditDRG");
		if (tbl) {	
			var count=0;
			var arrInput=tbl.getElementsByTagName("INPUT");
			for (var i=1; i<tbl.rows.length; i++) {
				var arrfld=tbl.rows[i].getElementsByTagName('INPUT');
				for (var j=0; j<arrfld.length; j++) {
					if (lu[count]){
						if (arrfld[j].id.indexOf("MRDIAICDCodeDRDescz")==0) {		// cjb 28/06/2005 53040.  Default the code into the description field then run the broker (which triggers the validation)
							arrfld[j].value=mPiece(lu[count],"~",0);
							var evt = parent.frames["MRDiagnosEditDRG"].document.createEventObject();
							arrfld[j].fireEvent("onchange",evt);
						}
						//if (arrfld[j].id.indexOf("MRDIAICDCodeDRDescz")==0) arrfld[j].value=mPiece(lu[count],"~",1);
						//if (arrfld[j].id.indexOf("MRDIAICDCodeDRCodez")==0) arrfld[j].value=mPiece(lu[count],"~",0);
					}
				}
				count=count+1;
			}
			var tmp=parent.frames["MRDiagnosEditDRG"].SetDiagnosTotal();
		}
	}
}

function AssignProcedures(tempstr){
	if (tempstr!=""){
		var lu=tempstr.split("||");
		var tbl=parent.frames["MRProceduresEditDRG"].document.getElementById("tMRProcedures_EditDRG");
		if (tbl) {	
			var count=0;
			var arrInput=tbl.getElementsByTagName("INPUT");
			for (var i=1; i<tbl.rows.length; i++) {
				var arrfld=tbl.rows[i].getElementsByTagName('INPUT');
				for (var j=0; j<arrfld.length; j++) {
					if (lu[count]){
						
						if (arrfld[j].id.indexOf("PROCOperationDRDescz")==0) {		// cjb 28/06/2005 53040.  Default the code into the description field then run the broker (which triggers the validation)
							arrfld[j].value=mPiece(lu[count],"~",0);
							var evt = parent.frames["MRProceduresEditDRG"].document.createEventObject();
							arrfld[j].fireEvent("onchange",evt);
						}
						
						//if (arrfld[j].id.indexOf("PROCOperationDRDescz")==0) arrfld[j].value=mPiece(lu[count],"~",1);
						//if (arrfld[j].id.indexOf("PROCOperationDRCodez")==0) arrfld[j].value=mPiece(lu[count],"~",0);
						//if (arrfld[j].id.indexOf("ProcDateMandatoryz")==0) arrfld[j].value=mPiece(lu[count],"~",2);    //KK L:44240
						//KK 18/2/05 L:50202
						if (mPiece(lu[count],"~",2)=="Y"){
							if (objAdmDate.value==objDischargeDate.value){
								if (arrfld[j].id.indexOf("PROCProcDatez")==0) arrfld[j].value=objDischargeDate.value;
							}
						}
					}
				}
				count=count+1;
			}
		}
	}
}

//KK 3/Apr/2003 Log 32789
function DeleteCodingDetails(){
	parent.frames["MRDiagnosEditDRG"].ClearDiagnoses();
	parent.frames["MRProceduresEditDRG"].ClearProcedures();
	var objDRGCode=document.getElementById("DRGCode");
	if (objDRGCode) objDRGCode.innerText="";
	var objDRGDesc=document.getElementById("DRGDesc");
	if (objDRGDesc) objDRGDesc.innerText="";	
	if (objMRADMWeight) objMRADMWeight.value="";
	if (objFollowupReasonStr) objFollowupReasonStr.value="";
	if(objFollowupReason){
		objFollowupReasonStr.value="";
		for(var i=0; i<objFollowupReason.length-1; i++) {
      		objFollowupReason.options[i].selected=false;
	   	}
	}
	var objRFUpList=document.getElementById("RequiresFollowUpList");
	if (objRFUpList){
		for(var j=(objRFUpList.length-1); j>=0; j--) {
			objRFUpList.options[j]=null;
		}
	}
	//KK 13/12/04 L:47874 - clear EpisodesReqFollowUp field on Delete coding details
	var objERFU=document.getElementById("EpisodesReqFollowUp");
	if (objERFU) objERFU.value="";
	var objVerified=document.getElementById("Verified");
	if (objVerified) objVerified.checked=false;
	var objMDC=document.getElementById("MDC");
	if (objMDC) objMDC.innerText="";
	var objURAdm=document.getElementById("UnplannedReadmission");
	if (objURAdm) objURAdm.value="";
	//Enable lookup for DRGCoding field and enable field
	var objDRGCoding=document.getElementById("MRCDRGCoding");
	if (objDRGCoding) objDRGCoding.disabled=false;
	var objLUp=document.getElementById("ld1242iMRCDRGCoding");
	if(objLUp) objLUp.style.visibility = "visible";
	var objDRGCodeSet=document.getElementById("DRGCodeSet");
	if (objDRGCodeSet) objDRGCodeSet.value="";
	var objWIESPrice=document.getElementById("MRADMTotalWIESPrice");
	if (objWIESPrice) objWIESPrice.innerText="";
	var objWIESScore=document.getElementById("MRADMTotalWIESScore");
	if (objWIESScore) objWIESScore.innerText="";

	// RQG 01.09.03 L32803
	var objPCCL=document.getElementById("PCCL");
	if (objPCCL) objPCCL.innerText="";

	//KK Log 35894,36636 - to clear fields in PAAdm.DRGCodingDisplay
	var tframe=parent.frames["PAAdmDRGCodingDisplay"]
	if (tframe) {
		var objTDRGCode=tframe.document.getElementById("TDRGCode");
		if (objTDRGCode) objTDRGCode.innerText="";
		var objTDRGDesc=tframe.document.getElementById("TDRGDesc");
		if (objTDRGDesc) objTDRGDesc.innerText="";	
		var objTWIESPrice=tframe.document.getElementById("TMRADMTotalWIESPrice");
		if (objTWIESPrice) objTWIESPrice.innerText="";
		var objTWIESScore=tframe.document.getElementById("TMRADMTotalWIESScore");
		if (objTWIESScore) objTWIESScore.innerText="";
		var objTTARDayHospitalTariff=tframe.document.getElementById("TTARDayHospitalTariff");
		if (objTTARDayHospitalTariff) objTTARDayHospitalTariff.innerText="";
		var objTTARNormalTariff=tframe.document.getElementById("TTARNormalTariff");
		if (objTTARNormalTariff) objTTARNormalTariff.innerText="";
		var objTTAROneDayTariff=tframe.document.getElementById("TTAROneDayTariff");
		if (objTTAROneDayTariff) objTTAROneDayTariff.innerText="";
		var objTTARReabilitaionLimitDay=tframe.document.getElementById("TTARReabilitaionLimitDay");
		if (objTTARReabilitaionLimitDay) objTTARReabilitaionLimitDay.innerText="";
		var objTMDC=tframe.document.getElementById("TMDC");
		if (objTMDC) objTMDC.innerText="";
		var objVariance=tframe.document.getElementById("Variance");
		if (objVariance) objVariance.innerText="";
		var objTTARExtraHighTrimPoint=tframe.document.getElementById("TTARExtraHighTrimPoint");
		if (objTTARExtraHighTrimPoint) objTTARExtraHighTrimPoint.innerText="";
		// cjb 03/06/2005 52800
		var objMRADMPCCL=tframe.document.getElementById("MRADMPCCL");
		if (objMRADMPCCL) objMRADMPCCL.innerText="";
	}	
		//KK 12/jan/04 L:41061
		var objTemp=document.getElementById("TARClass1DR");
		if (objTemp) objTemp.innerText="";
		var objTemp=document.getElementById("TARClass2DR");
		if (objTemp) objTemp.innerText="";
		var objTemp=document.getElementById("TARClass3DR");
		if (objTemp) objTemp.innerText="";
		var objTemp=document.getElementById("TARDayHospitalTariff");
		if (objTemp) objTemp.innerText="";
		var objTemp=document.getElementById("TARDRGTypeDR");
		if (objTemp) objTemp.innerText="";
		var objTemp=document.getElementById("TARExtraTariffPerDay");
		if (objTemp) objTemp.innerText="";
		var objTemp=document.getElementById("TARKind");
		if (objTemp) objTemp.innerText="";
		var objTemp=document.getElementById("TARLimitDay");
		if (objTemp) objTemp.innerText="";
		var objTemp=document.getElementById("TARMedTarget");
		if (objTemp) objTemp.innerText="";
		var objTemp=document.getElementById("TARNormalTariff");
		if (objTemp) objTemp.innerText="";
		var objTemp=document.getElementById("TAROneDayTariff");
		if (objTemp) objTemp.innerText="";
		var objTemp=document.getElementById("TARReabilitaionExtraTariffPerDay");
		if (objTemp) objTemp.innerText="";
		var objTemp=document.getElementById("TARReabilitaionLimitDay");
		if (objTemp) objTemp.innerText="";
		var objTemp=document.getElementById("TARReabilitationTariff");
		if (objTemp) objTemp.innerText="";
		var objTemp=document.getElementById("TARSameDayOneDay");
		if (objTemp) objTemp.innerText="";
		var objTemp=document.getElementById("TARCostWeight");
		if (objTemp) objTemp.innerText="";
		var objTemp=document.getElementById("TARDRGCategDR");
		if (objTemp) objTemp.innerText="";
		var objTemp=document.getElementById("TTARExtraHighTrimPoint");
		if (objTemp) objTemp.innerText="";
	
	//L:36636 - Clear CPAP Hours and MV Hours and set ICU and CCU Hours back to the calculated hours not the hours the user has modified them to.
	if (objICUHours) objICUHours.value=ICUHours;
	if (objCCUHours) objCCUHours.value=CCUHours;
	if (objCPAPHours) objCPAPHours.value="";
	if (objMechVentHours) objMechVentHours.value="";
	// to clear fields returned after grouping - DRG Tariff table fields
	var objTemp=document.getElementById("VarianceLOS");
	if (objTemp) objTemp.innerText="";
	alert(t['DELETE_COD_DETAILS']);
	return false;
}
//KK 16/Apr/2003 Log 32794
function UpdateCodeSetParent(){
	CreateHiddenDiagFields();
	CreateHiddenProcFields();
	var objDiag=document.getElementById("DIAGFields");
	var objProc=document.getElementById("PROCFields");
	/*
	var objParentWindow=window.opener;
	if (objParentWindow) {
		var diagfld = objParentWindow.document.getElementById("DiagFields");
		if (diagfld) diagfld.value=objDiag.value;
		var procfld = objParentWindow.document.getElementById("ProcFields");
		if (procfld) procfld.value=objProc.value;
	}
	return updatecodeset_click();
	*/
	return true;
}

//KK 12/May/2003 Log 35005
function RFULookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('RequiresFollowUp');
	if (obj) obj.value=lu[0];
	var objList=document.getElementById('RequiresFollowUpList');
	if (objList) {
		var txtField='RequiresFollowUp';
		var lstField='RequiresFollowUpList';
		LookupSelectforList(txtField,lstField,str);
	}
}
function LookupSelectforList(tfield,lfield,txt) {
	//Add an item to List when an item is selected from the Lookup, then clears the text field.
	var adata=txt.split("^");
	var obj=document.getElementById(lfield);  //Listbox
	if (obj) {
		//Need to check if text already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == String.fromCharCode(2)+adata[1]) {
				alert( adata[0] + " has already been selected");
				var obj=document.getElementById(tfield);  //Textbox with lookup 
				if (obj) obj.value="";
				return;
			}
			if  ((adata[2] != "") && (obj.options[i].text == adata[0])) {
				alert( adata[0] + " has already been selected");
				var obj=document.getElementById(tfield);
				if (obj) obj.value="";
				return;
			}
		}
	}
	AddItemToList(obj,adata[2],adata[0]);
	var obj=document.getElementById(tfield);
	if (obj) obj.value="";
}

//Add an item to a listbox
function AddItemToList(list,code,desc) {
	//code=String.fromCharCode(2)+code
	list.options[list.options.length] = new Option(desc,code);
}

//Delete items from Entered listbox when "Delete" button is clicked.
function DeleteRFUClickHandler() {
	var obj=document.getElementById("RequiresFollowUpList");
	if (obj)
	RemoveFromList(obj);
	if (obj.length==0) RemoveEpisodeFromList();   // cjb 27/05/2004 44223
	return false;
}

function RemoveFromList(obj) {
	for (var i=(obj.length-1); i>=0; i--) {
		if (obj.options[i].selected)
			obj.options[i]=null;
	}
}

// cjb 27/05/2004 44223 - if all the FollowUpReason's have been deleted, remove the episode from the EpisodesReqFollowUp list
function RemoveEpisodeFromList() {
	var Episode=document.getElementById("EpisodeNumHidden")
	var EpisodesReqFollowUp=document.getElementById("EpisodesReqFollowUp")
	if ((Episode)&&(EpisodesReqFollowUp)) {
		array = EpisodesReqFollowUp.value.split(',');
		for (var i=0; i<array.length; i++) {
			if (array[i]==Episode.value) {
				delete array[i]
			}
		}
		EpisodesReqFollowUp.value=array.join()
	}
}

function BuildIDsfromList(){
	//RequiresFollowUp
	var objList=document.getElementById('RequiresFollowUpList');
	if (objList) {
		var IDfield='RequiresFollowUpString';
		var lstfield='RequiresFollowUpList';
		UpdatewithIDs(lstfield,IDfield);
	}
}

function UpdatewithIDs(lstfield,IDfield) {
	var arrItems = new Array();
	var lst = document.getElementById(lstfield);
	var SlectedIDs="";
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			SlectedIDs=SlectedIDs + lst.options[j].value + "|";
		}
		SlectedIDs=SlectedIDs.substring(0,(SlectedIDs.length-1));
		var el = document.getElementById(IDfield);
		if (el) el.value = SlectedIDs;
		alert(SlectedIDs);
	}
}

//KK 10/Jul/2003 Log 35047  To reload csp if the page is reloaded because of invalid password error
function ReloadDRGCodingCSP(){

	var PageType="";
	var Action="";

	var url="paadm.drgcoding.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&CONTEXT="+CONTEXT+"&mradm="+mradm;
	url = url +"&TRANSID="+TransID+"&TWKFL="+TWKFL+"&TWKFLI="+TWKFLI+"&TWKFLL="+TWKFLL+"&TWKFLJ="+TWKFLJ + "&InvalidPasswd=Y";

	//AJI 19.11.03 Log 40633 - added new parameter to url -> InvalidPasswd. Why it's needed? see paadm.drgcoding2.csp

	websys_createWindow(url,"TRAK_main");
}


function ContrCareClickHandler()	{
	var id="";
	if (objAdmDate) {admd=objAdmDate.value;}
	if (!objAdmDate) {admd="_zz";}
	if (objDischargeDate) {disd=objDischargeDate.value;}
	if (!objDischargeDate) {disd="_zz";}
	websys_createWindow('paadmcontractcare.csp?%ID='+id+'&PatientID='+PatientID+'&EpisodeID='+EpisodeID+'&PAADMAdmDate='+admd+'&CONTEXT='+CONTEXT+'&PAADMDischgDate='+disd+'&PatientBanner=1','',"top=30,left=20,width=620,height=420,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
	return false;
}

// cjb 09/09/2004 44777 - This is a dummy function here. Check for QH done via custom js
function BoldContractCareLink() {
	return true;
}

// cjb 09/09/2004 44777 - This is a dummy function here. Check for QH done via custom js
function IsContracted() {
	return;
}

//KK 21/01/05 L:48931
function CheckUnacceptablePDx(){
	if (parent.frames["MRDiagnosEditDRG"]) {
		var CodPrac="";
		var PDx="";
		var objPDx=parent.frames["MRDiagnosEditDRG"].document.getElementById('MRDIAICDCodeDRCodez1');
		if (objPDx) PDx=objPDx.value;
		var objCodPrac=parent.frames["MRDiagnosEditDRG"].document.getElementById('MRCIDCodingPracticesz1');
		if (objCodPrac) CodPrac=objCodPrac.value;
		if ((PDx!="")&&(CodPrac=="1")){
			alert(PDx + " - " + t['CODEPRAC_UNACCEPTABLE']);
			return false;
		}
	}
	return true;
}


// cjb 08/06/2005 52799 - copied this function from scripts_gen but commented out fPAAdm_DRGCoding_submit() as we don't need to check the password
function UpdateVisasys_click() {
	if (evtTimer) {
		setTimeout('UpdateVisasys_click();',200)
	} else {
		websys_setfocus('UpdateVisasys');
		var frm=document.fPAAdm_DRGCoding;
		websys_isInUpdate=true;
		//if (fPAAdm_DRGCoding_submit()) {
			var obj=document.getElementById('UpdateVisasys');
			if (obj) {obj.disabled=true;obj.onclick=function() {return false};}
			frm.TEVENT.value='d1242iUpdateVisasys';
			frm.submit();
		//}
		return false;
	}
}


document.body.onload=PAAdmDRGBodyLoadHandler;
