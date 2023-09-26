//Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. w 6.50

var objAppointmentLink=document.getElementById("Appointment");
var objADMPAADMDR=document.getElementById("ADMPAADMDR");
var objApptUpdateLink=document.getElementById("UpdateAddAppt");
var objUpdateLink=document.getElementById("update1");
var visitstatus=document.getElementById("VisitStatus");
var dnaorigcode="";
var cancorigcode="";
var FutureDate="False";
var confirmationobj=document.getElementById("ADMConfirmation");
var confirmationflagobj=document.getElementById("confirmationflag");
var bloodobj=document.getElementById("WLBloodDonation");
var bloodflagobj=document.getElementById("blooddonationflag");
var CancReasMand=""
var CancInitMand=""
var patflagobj=document.getElementById("ADMFlaggedPatient");
var patflagdataobj=document.getElementById("FlaggedPatientData");
var objOTWLLink=document.getElementById('AddOT');

function BodyLoadHandler() {
	var obj=document.getElementById('ADMAdmDate');
	if (obj) obj.onchange=DateTimeHandler;

	//rqg,Log24863
	CheckPrevTCICancellation();
	//GR 3/4/02.  disabling form if status of admission is discharged.	
	var frm = document.forms['fPAWaitingListAdm_Edit'];
	var wlstatus=document.getElementById('disableform'); //gr log 51231 if value = "D" then disable form.
	if (visitstatus){
		if (((visitstatus.value=="D")||(visitstatus.value=="A"))||(wlstatus.value=="D")) {
			for (i=0; i<frm.elements.length; i++) {
				var el = frm.elements[i];
				//var el = frm.elements[arrElem[i]];
				if (el) {
					el.disabled=true;
					el.className = "disabledField";
				}
			} 
			if (objAppointmentLink) {
				objAppointmentLink.onclick=LinkDisable;
				objAppointmentLink.disabled=true;
			}
			if (objApptUpdateLink) {
				objApptUpdateLink.onclick=LinkDisable;
				objApptUpdateLink.disabled=true;
			}
			if (objUpdateLink) {
				objUpdateLink.onclick=LinkDisable;
				objUpdateLink.disabled=true;
			}
		} else {
			//alert("loading the screen");
			// SA 13.12.01: Disable Appointment Link if no admission has 
		 	// been saved as yet against the waiting list
			//alert("BodyLoadHandler called");
			//KK 06/Mar/2002 Log:23349 Changed "UpdateAddAppt" from Link to Button
			if (objApptUpdateLink) objApptUpdateLink.onclick=UpdateAddApptClickHandler;
			if (objAppointmentLink) {
				objAppointmentLink.onclick=LinkEnable;
				if (objADMPAADMDR) {
					if (objADMPAADMDR.value=="") {
						objAppointmentLink.disabled=true;
						objAppointmentLink.onclick=LinkDisable;
						if (objApptUpdateLink) objApptUpdateLink.disabled=false
					}
					else {
						objAppointmentLink.disabled=false;
						if (objApptUpdateLink) {
						objApptUpdateLink.disabled=true;
						objApptUpdateLink.onclick=LinkDisable;
						}
					}
				}
			}
			uobj=document.getElementById('update1');
			if (uobj) uobj.onclick=UpdateClickHandler;
			if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateClickHandler;
			//KK 22/Mar/2002 Log:23852
			//GR log41223
			var enablepreadobj=document.getElementById("ChangePreadDate");
			if (enablepreadobj) {
				if (enablepreadobj.value!="Y") DisableADMDateandTime(); 
			}
			//KK 28/May/2002 Log:25366 Cancel reason & Cancel initiator
			objCR=document.getElementById("ADMCancelReasonDR")
			if (objCR) {
				cancorigcode=objCR.onchange; 
				objCR.onchange=CancelReason_ChangeHandler;
			}	
			objCRlabel=document.getElementById("cADMCancelReasonDR")
			if (objCRlabel) {
				CancReasMand=objCRlabel.className;
			}
			//KK 28/May/2002 Log:25366 DNA reason & DNA initiator
			objDNA=document.getElementById("READesc")
			if (objDNA) { 
				dnaorigcode=objDNA.onchange; 
				objDNA.onchange=READesc_ChangeHandler;
			}
			//GR log 24897
			revcanobj=document.getElementById("ReverseCancellation");
			if (revcanobj) revcanobj.onclick=ReverseCancellationHandler;
			DNACancelEnableDisable();
			DisableDNA();

			// RQG 25.02.03 L30675 - Disable Booking Date field if cancel pre-adm menu is selected
			var objCancelDate=document.getElementById("ADMCancelDate");
			var objADMBookingDate=document.getElementById("ADMBookingDate");
			//log 62412 TedT chcek if cancel date is empty, hide lookup img if disabled
			if ((objCancelDate)&&(objCancelDate.value!="")&&(objADMBookingDate)) {
				objADMBookingDate.disabled = true;
				var fldnameLookup=document.getElementById("ld1163iADMBookingDate");
				if (fldnameLookup) fldnameLookup.style.visibility="hidden";
			}

		}
	}
	//SB 3/6/06 (58898): ability to change TCI date within x period
	var AllowChangeTCIDays=document.getElementById("AllowChangeTCIDays");
	if ((AllowChangeTCIDays)&&(AllowChangeTCIDays.value!="")) {
		var objADMAdmDate=document.getElementById("ADMAdmDate");
		if (objADMAdmDate) objADMAdmDate.disabled=false;
		var objADMTime=document.getElementById("ADMTime");
		if (objADMTime) objADMTime.disabled=false;
	}
	
	CheckWkOTLink();
	if (objOTWLLink) objOTWLLink.onclick=UpdateAddOTClickHandler;

}

function UpdateClickHandler() {
	// Log 61975 - 19.04.2007
	var dnareason="";
	var cancelreason="";
	var PARREF="";
	var apptpresentobj=document.getElementById("ApptsPresent");
	if (apptpresentobj) var apptpresent=apptpresentobj.value;
	var cancelreasonobj=document.getElementById("ADMCancelReasonDR");
	if (cancelreasonobj)  cancelreason=cancelreasonobj.value;
	var dnareasonobj=document.getElementById("READesc");
	if (dnareasonobj)  dnareason=dnareasonobj.value;

	if (apptpresent!="") {
		if ((dnareason!="")||(cancelreason!="")) {
		 	// Give error message if any of the operation records are "Done"
			var objPARREF=document.getElementById("PARREF");
			if (objPARREF) PARREF=objPARREF.value;
 			if (PARREF!="") {
	 			var result=tkMakeServerCall("web.PAWaitingListAdm","IsWLOTDone",PARREF);
				if (result==0) {
					alert(t['OT_DONE']);
					return false;
				}	
				else if (result!='61'){
					alert(t['OTBookingExist'])
				}	 			
 			}
		}
	}		
	//End Log 61975 
	
	if (!UpdateValidation()) return false;
	//rqg,Log24863: 
	return update1_click()
	//return;
}
//KK 06/Mar/2002 Log:23349 
function UpdateAddApptClickHandler() {
	if (!UpdateValidation()) return false;
	UpdateAddAppt_click();
	return;
}

function UpdateAddOTClickHandler() {
	if (!UpdateValidation()) return false;
	var objCheckWLOT=document.getElementById('CheckWLOT');
	if ((objCheckWLOT)&&(objCheckWLOT.value==0)) {
	return false;
	}
	AddOT_click();
	return;
}
function UpdateValidation() {
	var CreateRequestRules="";
	CreateRequestRules=CheckRequestRules();
	var Prompt="";
	var message="";
	var pObj=document.getElementById("Prompt");
	if (pObj) Prompt=pObj.value;
	var message1=t['PROMPT_CREATEREQ'];
	var mrObj=document.getElementById("MRTypeID");
	var MRTypeid="";
	if (!ValidateFields()) {
		return false;
	} 
	if (CreateRequestRules=="WLRules") {
		var WLType="";
		if (document.getElementById("WLWaitListTypeDR")) {
			var WLTObj=document.getElementById("WLWaitListTypeDR");
			if (WLTObj.tagName=="LABEL") {
				WLType=WLTObj.innerText;
			} else {
				WLType=WLTObj.value;
			}
			if (WLType=="") {
				alert(t['SELECT_WLTYPE']);   
				return true;
			}
		}
	}
	if (CreateRequestRules=="ApptRules") {
		//return ValidateApptRules();
		var dept="";
		var doc="";
		var DeptObj=document.getElementById("Department");
		if (DeptObj) dept=DeptObj.value;
		var DocObj=document.getElementById("Doctor");
		if (DocObj) doc=DocObj.value;

		if ((DeptObj)&&(dept=="")) {
			alert(t['SELECT_DEPT']);	
			return true;
		}
		if ((DocObj)&&(doc=="")) {
			alert(t['SELECT_DOCTOR']);	
			return true;
		}

		if (Prompt!="") {
	
			var promptAry=Prompt.split(",");
			//alert(promptAry.length);
			for (var i=0; i<promptAry.length-1; i++) {
				//alert(mPiece(promptAry[i],"||",0));
				//alert(mPiece(promptAry[i],"||",1));
				message=message1+" "+mPiece(promptAry[i],"||",1)+"?";
				if (confirm(message)) {
					MRTypeid=MRTypeid+mPiece(promptAry[i],"||",0)+","
				
				}
				message="";
			}
		}
		if (mrObj) mrObj.value=MRTypeid;
	}
	//rqg,test for log27102: Dont allow Blood Donation update if its not on the form
	if ((bloodobj)&&(bloodflagobj)) {
		if (bloodobj.checked==true) {
			bloodflagobj.value="True";
			//alert(bloodflagobj.value);
		} else {
			bloodflagobj.value="False";
			//alert(bloodflagobj.value);
		}
		// if (bloodobj.disabled==false) bloodflagobj.value="True";
	}
	if ((confirmationflagobj)&&(confirmationobj)) {
		if (confirmationobj.checked==true) {
			confirmationflagobj.value="True";
			//alert(confirmationflagobj.value);
		}else{
			confirmationflagobj.value="False";
			//alert(confirmationflagobj.value);
		} 
	}
	if ((patflagobj)&&(patflagdataobj)) {
		if (patflagobj.checked==true) {
			patflagdataobj.value="True";
			//alert(confirmationflagobj.value);
		}else{
			patflagdataobj.value="False";
			//alert(confirmationflagobj.value);
		} 
	}
	// RQG 20.01.03 Log31701: Chek that "ADMCancelReasonDR" and "READesc" should not be both blank if exist,
	var objCR=document.getElementById("ADMCancelReasonDR");
	var objDNA = document.getElementById("READesc");
	var objCancelDate = document.getElementById("ADMCancelDate");
	if ((objCancelDate)&&(objCancelDate.value!="")) {
		if ((objCR)&&(objDNA)) {
			if ((objCR.value=="")&&(objDNA.value=="")) {
				alert(t['CANCELREASON_BLANK']);
				websys_setfocus(objCR.id);
				return false;
			}
		} else {
			if ((!(objCR))&&(!(objDNA))) {
				alert(t['FIELD_MISSING']);
				websys_setfocus(objCancelDate.id);
				return false;
			}
		}
	}
	//SB 4/04/07 (63220):ADM_BookingDate on PAWaitingListAdm.Edit - Future Date
	var objBookDate = document.getElementById("ADMBookingDate");
	if (objBookDate && DateStringCompareToday(objBookDate.value)==1) {
		alert(t['NoFutureDate']);
		websys_setfocus(objBookDate.id);
		return false;
	}
	if(!bookingcheck()) return false;
	if(!confirmationcheck()) return false;
	return true;
}

function mPiece(s1,sep,n) {
	//Getting wanted piece, passing (string,separator,piece number)
	//First piece starts from 0
	//Split the array with the passed delimeter
	delimArray = s1.split(sep);
	//If out of range, return a blank string
	if ((n <= delimArray.length-1) && (n >= 0)) return delimArray[n];	
}

function CareProviderLookUp(str) {
 	var lu = str.split("^");
	var obj=document.getElementById('Department');
	if (obj) obj.value = lu[2];
	//var obj=document.getElementById('Doctor');
	//if (obj) obj.value = lu[1];
	var pobj=document.getElementById('Prompt');
	if (pobj) pobj.value = lu[9];
	//alert(pobj.value);


}

function CheckRequestRules() {
	var AdmDate="";
	var AdmTime="";
	var PreAssDate="";
	var PreAssTime="";
	var PreOpDate="";
	var PreOpTime="";
	var Rules="";

	var AdmDateObj=document.getElementById("ADMAdmDate");
	if ((AdmDateObj) && (AdmDateObj.value!=null)) AdmDate=AdmDateObj.value;

	var AdmTimeObj=document.getElementById("ADMTime");
	if ((AdmTimeObj) && (AdmTimeObj.value!=null)) AdmTime=AdmTimeObj.value;	

	var PreADateObj=document.getElementById("APPTDate");
	if ((PreADateObj) && (PreADateObj.value!=null)) PreAssDate=PreADateObj.value;

	var PreATimeObj=document.getElementById("APPTTime");
	if ((PreATimeObj) && (PreATimeObj.value!=null)) PreAssTime=PreATimeObj.value;

	var PreOpDateObj=document.getElementById("WLPreopDate");
	if ((PreOpDateObj) && (PreOpDateObj.value!=null)) PreOpDate=PreOpDateObj.value;

	var PreOpTimeObj=document.getElementById("WLPreopTime");
	if ((PreOpTimeObj) && (PreOpTimeObj.value!=null)) PreOpTime=PreOpTimeObj.value;

	if ((AdmDate!="") && (AdmTime!="") && (PreAssDate!="") && (PreAssTime!="") && (PreOpDate=="") && (PreOpTime=="")) {
		Rules="ApptRules";		
	}
	if ((AdmDate!="") && (AdmTime!="") && (PreOpDate!="") && (PreOpTime!="") && (PreAssDate=="") && (PreAssTime=="")) Rules="WLRules";
	if ((AdmDate!="") && (AdmTime!="") && (PreAssDate=="") && (PreAssTime=="") && (PreOpDate=="") && (PreOpTime=="")) Rules="WLRules";

	//alert(AdmDate+"-"+AdmTime+"-"+PreAssDate+"-"+PreAssTime+"-"+PreOpDate+"-"+PreOpTime);
	//alert("check= "+Rules);
	var CRObj=document.getElementById("CreateRequest");
	if (CRObj) CRObj.value=Rules;

	return Rules;
}

function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if (el.disabled) {
		return false;
	}
	return true;
}


function LinkEnable(evt) {
	//alert("LinkEnable called");
	var el = websys_getSrcElement(evt);
	//alert("el.href="+el.href);
	if (!el.disabled) {
		var obj;
		var PatientID="";
		var EpisodeID="";
		var TWKFLI="";
		var TWKFL="";
		var path="";
		var WLAdmID="";
		obj=document.getElementById("PatientID");
		if (obj) PatientID=obj.value		
		obj=document.getElementById("ADMPAADMDR");
		if (obj) EpisodeID=obj.value
		obj=document.getElementById("TWKFLI");
		if (obj) TWKFLI=obj.value
		obj=document.getElementById("TWKFL");
		if (obj) TWKFL=obj.value
		// ab 29.05.02 - need to pass WL admission id to appt, pass from AdmConflict because ID returns patient banner id
        obj=document.getElementById("AdmConflict");
		if (obj) WLAdmID=obj.value
		path="rbappointmentframe.popup2.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&WLAdmID="+WLAdmID+"&PatientBanner=1&TWKFL="+TWKFL+"&TWKFLI="+TWKFLI+"&PopUp=1";
		//alert("path="+path);
		websys_lu(path,false,"top=30,left=20,width=750,height=480");
		//websys_lu(el.href,false,"top=30,left=20,width=750,height=480");
	}
	return false;
}

function ReasonLookup(str) {
 	var lu = str.split("^");
	var obj;
	obj=document.getElementById("ADMCancelReasonDR")
	if (obj) obj.value = lu[0]
	obj=document.getElementById("WLRGDesc")
	if (obj) obj.value = lu[2]
	//rqg,Log24214:Assign the reason code as well
	obj=document.getElementById("CancelReasonCode")
	if (obj) obj.value=lu[1]
	// RQG 20.01.03 Log31701: Disable DNA Reason field if cancel reason is entered.
	DNACancelEnableDisable();
}
function DNAReasonLookup(str) {
 	var lu = str.split("^");
	var obj;
	obj=document.getElementById("READesc")
	if (obj) obj.value = lu[0]
	obj=document.getElementById("DNAInitiator")
	if (obj) obj.value = lu[2]

	// RQG 20.01.03 Log31701: Disable Cancel Reason field if DNA reason is entered.
	DNACancelEnableDisable();
}
function DNACancelEnableDisable() {
	//GR log 34448
	var objDNAInitiator=document.getElementById('DNAInitiator');
	var objREADesc=document.getElementById('READesc');
	var objWLRGDesc=document.getElementById('WLRGDesc');
	var objCancelReasonDR=document.getElementById('ADMCancelReasonDR');
	if (objDNAInitiator) {
		DNAEnableDisable()  ;
	} else {
		if (objREADesc) DNAEnableDisable()  ;
	}
	if (objWLRGDesc) { 
		CancelEnableDisable()   ;
	} else {
		if (objCancelReasonDR) CancelEnableDisable()  ;
	}
}
function DNAEnableDisable(text) {
// RQG 07.05.03 L35427: Change code to handle cursor movement and disabling/enabling DNA fields
	var objDNAInitiator=document.getElementById('DNAInitiator');        // DNA Initiator
	var objREADesc=document.getElementById('READesc');		        // DNA Reason
	var objWLRGDesc=document.getElementById('WLRGDesc');		        // Cancel Initiator
	var objCancelReasonDR=document.getElementById('ADMCancelReasonDR'); // Cancel Reason
	var objDNAInitiatorLookup=document.getElementById('ld1163iDNAInitiator');
	var objREADescLookup=document.getElementById('ld1163iREADesc');

	if ((objREADesc) && (objREADesc.value=="") && (objCancelReasonDR) && (objCancelReasonDR.value!="")) {
		DisableField('DNAInitiator');
		DisableField('READesc');
		if (objDNAInitiatorLookup) objDNAInitiatorLookup.style.visibility = "hidden";
		if (objREADescLookup) objREADescLookup.style.visibility = "hidden";
		//websys_nextfocus(objCancelReasonDR.sourceIndex);
	} else {
		EnableField('DNAInitiator',"");
		EnableField('READesc',"");
		if (objDNAInitiatorLookup) objDNAInitiatorLookup.style.visibility = "visible";
		if (objREADescLookup) objREADescLookup.style.visibility = "visible";
	}
	DisableDNA()
}

function CancelEnableDisable(text) {
// RQG 07.05.03 L35427: Change code to handle cursor movement and disabling/enabling Cancel fields
	var objDNAInitiator=document.getElementById('DNAInitiator');        // DNA Initiator
	var objREADesc=document.getElementById('READesc');		        // DNA Reason
	var objWLRGDesc=document.getElementById('WLRGDesc');		        // Cancel Initiator
	var objCancelReasonDR=document.getElementById('ADMCancelReasonDR'); // Cancel Reason
	var objWLRGDescLookUp=document.getElementById('ld1163iWLRGDesc');
	var objCancelReasonDRLookUp=document.getElementById('ld1163iADMCancelReasonDR');

	if ((objCancelReasonDR) && (objCancelReasonDR.value=="") && (objREADesc) && (objREADesc.value!="")) {
		DisableField('WLRGDesc');
		DisableField('ADMCancelReasonDR');
		if (objWLRGDescLookUp) objWLRGDescLookUp.style.visibility = "hidden";
		if (objCancelReasonDRLookUp) objCancelReasonDRLookUp.style.visibility = "hidden";
		//websys_nextfocus(objREADesc.sourceIndex);
	} else {
		EnableField('WLRGDesc',CancReasMand);
		EnableField('ADMCancelReasonDR',CancReasMand);
		if (objWLRGDescLookUp) objWLRGDescLookUp.style.visibility = "visible";
		if (objCancelReasonDRLookUp) objCancelReasonDRLookUp.style.visibility = "visible";
	}
	DisableDNA()
}

function InitatorLookUp(str) {

 	var lu = str.split("^");
	var obj;
	obj=document.getElementById("WLRGDesc")
	if (obj) obj.value = lu[0]
	obj=document.getElementById("ADMCancelReasonDR")
	if (obj) obj.value = ""

	// RQG 20.01.03 Log31701: Disable DNA reason
	DNACancelEnableDisable();
}

function DNAInitatorLookUp(str) {

 	var lu = str.split("^");
	var obj;
	obj=document.getElementById("DNAInitiator")
	if (obj) obj.value = lu[0]
	obj=document.getElementById("READesc")
	if (obj) obj.value = ""

	// RQG 20.01.03 Log31701: Disable DNA reason
	DNACancelEnableDisable();
}

//KK 22/Mar/2002 Log:23852 - DISABLE Admission Date and Time if TCI has been allocated
/*
function DisableADMDateandTime() {
	var obj=document.getElementById('ADMAdmDate');
	if ((obj)&&(obj.value!="")) {obj.disabled=true;}
	var obj=document.getElementById('ADMTime');
	if ((obj)&&(obj.value!="")) {obj.disabled=true;}
}
*/

//KK 09/05/2002 Log 24656
function DisableADMDateandTime() {
	var obj=document.getElementById('AdmConflict');
	if ((obj) && (obj.value=="")){
		return false;
	}
	else {
		var obj=document.getElementById('ADMAdmDate');
		if ((obj)&&(obj.value!="")) {obj.disabled=true;}
		var obj=document.getElementById('ADMTime');
		if ((obj)&&(obj.value!="")) {obj.disabled=true;}
	}

}

//KK 17/Apr/2002 Log 24240
function WardLookUpSelect(str) {
	//alert(str);
	//dummy function
}
//KK 6/aug/2002 Log 25255
function BedLookUpSelect(str) {
	//alert(str);
	var lu = str.split("^");
	var Bedcode=document.getElementById('BEDCode');
	if ((Bedcode) && (lu[0])) Bedcode.value=lu[0];
	var Bedid=document.getElementById('BedID');
	if ((Bedid) && (lu[3])) Bedid.value=lu[3];
}
function AdmPointLookup(str) {
	var lu = str.split("^");
	var objadmpoint=document.getElementById('ADMAdmPointLocDR');
	if (objadmpoint) objadmpoint.value=lu[0];
	var objadmpointid=document.getElementById('AdmPointLocID');
	if (objadmpointid) objadmpointid.value=lu[1];
}

function StatePPPLookUpHandler(str) {
 	var lu = str.split("^");
	var PPPcode=document.getElementById('SPPPCode');
	var PPPdesc=document.getElementById('SPPPDesc');
	if (PPPdesc) {
		PPPdesc.value=lu[0];
		if (PPPcode) {
			PPPcode.value=lu[2];
		}
	}
}

function ValidateFields() {
	//RG/SA dummy function for use by custom js
	return true;
}

//KK 28/May/2002 Log:25366 Clear cancel initiator if cancel reason is blank
function CancelReason_ChangeHandler() {
	if (typeof cancorigcode!="function") cancorigcode=new Function(cancorigcode);
	//call the function i.e. the original handler
	cancorigcode();
	objCR=document.getElementById("ADMCancelReasonDR");
	if ((objCR) && (objCR.value=="")) {
		objCI=document.getElementById("WLRGDesc");
		if (objCI) objCI.value ='';
	}
	DNACancelEnableDisable();
}
// Clear DNA initiator if DNA Reason is blank
function READesc_ChangeHandler() {
	if (typeof dnaorigcode!="function") dnaorigcode=new Function(dnaorigcode);
	//call the function i.e. the original handler
	dnaorigcode();
	objDNAR=document.getElementById("READesc");
	if ((objDNAR) && (objDNAR.value=="")) {
		objDNAI=document.getElementById("DNAInitiator");
		if (objDNAI) objDNAI.value ='';
	}	
	DNACancelEnableDisable();
}
function ReverseCancellationHandler() {
	//GR log 24897.  need to set a flag if cancellation is being reversed.
	revcancflagobj=document.getElementById("ReverseCancellationFlag");
	if (revcancflagobj) {
		revcancflagobj.value="T";
		UpdateClickHandler();
	}
}
function DateTimeHandler() {
	ADMAdmDate_changehandler(e);
	var objD=document.getElementById('ADMAdmDate');
	var objT=document.getElementById('ADMTime');
	if ((objD.defaultValue!=objD.value)||(objT.defaultValue!=objT.value)) {
		var objB=document.getElementById('BEDCode')
		var objW=document.getElementById('WLIntendedWardDR')
		var message=0;
		if (objB&&objB.value!="") {objB.value="";message=1;}
		//if (objW&&objW.value!="") {objW.value="";message=1;}
		if (message==1) alert(t['WardAndBedBlanked']);
	}
}

// RQG,Log24863: BAR custom - Display warning message if there's previous TCIs cancelled by 
// Hospital.
function CheckPrevTCICancellation() {
	// This is a dummy function here. Check for BAR done via custom js
	return true;
}

function SplitDateStr(strDate) {
 	var arrDateComponents = new Array(3);
 	var arrDate = strDate.split(dtseparator);
 	switch (dtformat) {
  	case "YMD":
   	arrDateComponents["yr"] = arrDate[0];
   	arrDateComponents["mn"] = arrDate[1];
   	arrDateComponents["dy"] = arrDate[2];
   	break;
  	case "MDY":
   	arrDateComponents["yr"] = arrDate[2];
   	arrDateComponents["mn"] = arrDate[0];
   	arrDateComponents["dy"] = arrDate[1];
   	break;
  	default:
   	arrDateComponents["yr"] = arrDate[2];
   	arrDateComponents["mn"] = arrDate[1];
   	arrDateComponents["dy"] = arrDate[0];
   	break;
 	}
 	return arrDateComponents;
}

function DisableDNA() {
	var Admdate=""
	var today=""
	DNAInitobj=document.getElementById('DNAInitiator');
	DNAReasobj=document.getElementById('READesc');
	if ((DNAReasobj)&&(DNAInitobj)) {
		ADMDateobj=document.getElementById('ADMAdmDate');	
		if (ADMDateobj) {
			var date=ADMDateobj.value;
			if (date!="")  {
				var vdate=SplitDateStr(date)
				if (vdate!="") Admdate=new Date(vdate["yr"], vdate["mn"]-1, vdate["dy"]);
			}
		}
		Todayobj=document.getElementById('DateToday');
		if (Todayobj) {
			var datet=Todayobj.value;
			if (datet!="")  var tdate=SplitDateStr(datet)
			today=new Date(tdate["yr"], tdate["mn"]-1, tdate["dy"]);
		}
		
		//if (Todayobj) today=Todayobj.value
		//if ((today<Admdate)||(today>Admdate)) {
		if (today<Admdate) {
			DNAReasobj.disabled=true
			DNAReasobj.className = "disabledField";
			DNAInitobj.disabled=true
			DNAInitobj.className = "disabledField";
			var reasobj=document.getElementById('ld1163iREADesc');
			if (reasobj) reasobj.style.visibility="hidden";
			var initobj=document.getElementById('ld1163iDNAInitiator');
			if (initobj) initobj.style.visibility="hidden";
			FutureDate="True"
		}
	}
}
function CheckWkOTLink() {

	
	var objCheckWLOT=document.getElementById('CheckWLOT');
	if ((objCheckWLOT)&&(objCheckWLOT.value==0)&&(objOTWLLink)) {
				objOTWLLink.onclick=LinkDisable;
				objOTWLLink.disabled=true;
			}

}
// RQG, 23.01.03 Log32249: This function was moved from RIE custom.
function DisableField(fldName) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if ((fld)&&(fld.tagName=="INPUT")) {
		fld.value = "";
		fld.disabled = true;
		fld.className = "disabledField";
		if (lbl) lbl = lbl.className = "";
	}
}
function EnableField(fldName,clsname) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if ((fld)&&(fld.tagName=="INPUT")) {
		fld.disabled = false;
		if (fld.className != "clsInvalid") fld.className = clsname;
		if (lbl) lbl = lbl.className = clsname;
	}
}
function ChangeSuspension(naid) {
	var PatID=""
	var WLID=""
	obj=document.getElementById("PatientID");
	if (obj) PatID=obj.value	
	obj=document.getElementById("PARREF");
	if (obj) WLID=obj.value
	var frm=document.forms['fPAWaitingListAdm_Edit'];frm.TOVERRIDE.value='';
	if (confirm(t['ConfirmSuspension'])) {
		websys_createWindow('pawaitlistnotavailable.csp?&ID='+naid+'&WaitingListID='+WLID+'&PatientID='+PatID,'suspwin','width=500,height=700,resizable=yes,scrollbars=yes');
	}
	
}
function HospLookup(str) {
	var lu = str.split("^");
	var obj=document.getElementById("HospID");
	if (obj) obj.value=lu[1];
}
//49086
function bookingcheck () {
	return true;
}
//49427
function confirmationcheck() {
	return true;
}
// **log 32408**
if ((bloodobj)&&(bloodflagobj)) {
	if (bloodflagobj.value=="False") bloodobj.checked=false;
}
if ((confirmationobj)&&(confirmationflagobj)) {
	if (confirmationflagobj.value=="False") confirmationobj.checked=false;
}

document.body.onload=BodyLoadHandler;
//alert("Javascript called");
