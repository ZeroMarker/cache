// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var VIEWABLE_CLICK="";
var SOURCEATTEND_CHANGE=null;

//md 10/03/2005 structure for HiddenCodes string
//1 = Location ID, 2 = Ward ID, 3 = CareProv Code, 4 = PAAdmRefDocListDR, 5 = PAADMFundingArrangementDR code, 6 = AllowEditLogLoc (sec grp)
//7 = PAADMTreatingDr Code, 8 = pat DVA number, 9 = use discharge date (system param), 10 = Ward Code, 11 = wardmessage (ward ct), 12 = closedwarddesc (ward ct)
//13 = iswardclosed (ward ct), 14 = HOSPMandatoryRefHospital, 15 = CTLOC mental health flag, 16 = ADSOUCode, 17 = Indigenous status, 18 = Patient DOB
//19 = Pat HealthFundNo, 20 = refstat reason id, 21 = snap ward flag, 22 = PAADMRefPeriodDR factor, 23 = Bed ID, 24 = ATTENDMandatoryRefDoctor, 25 = ATTENDMandatoryRefHospital
//26 = PAADMAdmCategDR Code, 27=PAADMAdmReasonDR Code, 28=PAADMEpissubtypeDR Code, 29 = snap bed flag
//to get value use document.getElementById('HiddenCodes').value.split("^")[piece];
//to replace value use ReplaceHiddenCode(piece,value);

var systemconfigs=document.getElementById("PATCF")
var aryPATCF=systemconfigs.value.split("^")

var AdmStatus="",AdmType="",EpisodePayorConfig="",EpisodeID="",obj;

var obj=document.getElementById('VisitStatusCode');
if (obj) var AdmStatus=obj.value;

var obj=document.getElementById('PAADMType');
if (obj) var AdmType=obj.value;

var obj=document.getElementById('EpisodeID');
if (obj) var EpisodeID=obj.value;

var obj=document.getElementById('PatientID');
if (obj) var PatientID=obj.value;

obj=document.getElementById("EpisodePayorConfig");
if (obj) var EpisodePayorConfig=obj.value;

setEstInjFontColour();


//SET CLASSNAME FOR STYLESHEET
function setEstInjFontColour() {
	var est=document.getElementById('PAADM2EstimateDateInjury');
	var inj=document.getElementById('PAADMInjuryIncidentDate');

	if ((inj)&&(est)&&(inj.value!="")) {
		if (est.checked) {
			inj.className="EstInjury";
		} else {
			inj.className="";
		}
	}
}

//md 31/03/2005 log 49633
LinksBeforeLoad();




function Init() {

	//setFamilyDoctor()
	setCheckBoxFlag()
	setSourceOfAttend()
	CheckForMentalHealth();
	var ContrCareObj=document.getElementById("ContractCare");
	if (ContrCareObj) { ContrCareObj.onclick=ContrCareClickHandler; }
	setLinks()

	obj=document.getElementById('PAADM2EstimateDateInjury');
	if (obj) obj.onclick=setEstInjFontColour;
	
	//JW: set bolding of child table links
	objBold=document.getElementById('BoldLinks');
	if (objBold) {
		var BoldLink = objBold.value.split("^");
		obj=document.getElementById('ScanDocuments');
		if ((obj) && (BoldLink[2]=="1")) obj.style.fontWeight="bold";
		obj=document.getElementById('ViewableBy');
		if ((obj) && (BoldLink[3]=="1")) obj.style.fontWeight="bold";
		obj=document.getElementById("EpisodeContactLink");
		if ((obj) && (BoldLink[4]=="1")) obj.style.fontWeight="bold";
		obj=document.getElementById("REFDocs");
		if ((obj) && (BoldLink[5]=="1")) obj.style.fontWeight="bold";
		obj=document.getElementById("SNAPScreen");
		if ((obj) && (BoldLink[6]=="1")) obj.style.fontWeight="bold";
		obj=document.getElementById("ContractCare");
		if ((obj) && (BoldLink[7]=="1")) obj.style.fontWeight="bold";
		obj=document.getElementById("InsurDet");
		if ((obj) && (BoldLink[8]=="1")) obj.style.fontWeight="bold";
		obj=document.getElementById("Unavail");
		if ((obj) && (BoldLink[9]=="1")) obj.style.fontWeight="bold";
		obj=document.getElementById("LetterNotes");
		if ((obj) && (BoldLink[10]=="1")) obj.style.fontWeight="bold";
		obj=document.getElementById("ReferralDetails");
		if ((obj) && (BoldLink[11]=="1")) obj.style.fontWeight="bold";
		obj=document.getElementById("PAADMRefLocation");
		if ((obj) && (BoldLink[12]=="1")) obj.style.fontWeight="bold";
		// cjb 04/02/2004 35528
		obj=document.getElementById("MaternityComplications");
		if ((obj) && (BoldLink[13]=="1")) obj.style.fontWeight="bold";
		// cjb 04/05/2004 43722
		obj=document.getElementById("PalliativeCare");
		if ((obj) && (BoldLink[14]=="1")) obj.style.fontWeight="bold";
		obj=document.getElementById("QualificationHistory");
		if ((obj) && (BoldLink[15]=="1")) obj.style.fontWeight="bold";
		obj=document.getElementById("CompoDetails");
		if ((obj) && (BoldLink[16]=="1")) obj.style.fontWeight="bold";
	}

	// CJB 02/09/2002 26379
	objmradmBold=document.getElementById('mradmBoldLinks');
	if (objmradmBold) {
		var mradmBoldLink = objmradmBold.value.split("^");
		obj=document.getElementById('PsychDetails');
		if ((obj) && (mradmBoldLink[0]=="1")) obj.style.fontWeight="bold";
	}

	//KM Log 24785: If Status is Admitted then do not allow user to edit certain fields.
	// ab 02.08.02 - 27423 - only restrict for inpatient episodes
	if ((AdmType=="I")&&((AdmStatus=="A")||(AdmStatus=="C")||(AdmStatus=="D"))) {
		obj=document.getElementById('CTPCPDesc');
		if (obj) obj.disabled=true;
		obj=document.getElementById('ld251iCTPCPDesc');
		if (obj) obj.disabled=true;
		obj=document.getElementById('CTLOCDesc');
		if (obj) obj.disabled=true;
		obj=document.getElementById('ld251iCTLOCDesc');
		if (obj) obj.disabled=true;
		obj=document.getElementById('PAADMAdmDate');
		if (obj) obj.disabled=true;
		DisableLookup("ld251iPAADMAdmDate");
		obj=document.getElementById('PAADMAdmTime');
		if (obj) obj.disabled=true;
		obj=document.getElementById('HOSPDesc');
		if (obj) obj.disabled=true;
		obj=document.getElementById('ld251iHOSPDesc');
		if (obj) obj.disabled=true;
		obj=document.getElementById('WARDDesc');
		if (obj) obj.disabled=true;
		obj=document.getElementById('ld251iWARDDesc');
		if (obj) obj.disabled=true;
		obj=document.getElementById('BEDCode');
		if (obj) obj.disabled=true;
		obj=document.getElementById('ld251iBEDCode');
		if (obj) obj.disabled=true;
		obj=document.getElementById("TRANSBedTypeDR");
		if (obj) obj.disabled=true;
		obj=document.getElementById("ld251iTRANSBedTypeDR");
		if (obj) obj.disabled=true;
		obj=document.getElementById('PAADMParentWardDR');
		if (obj) obj.disabled=true;
		obj=document.getElementById('ld251iPAADMParentWardDR');
		if (obj) obj.disabled=true;
		obj=document.getElementById('ROOMDesc');
		if (obj) obj.disabled=true;
		obj=document.getElementById('ld251iROOMDesc');
		if (obj) obj.disabled=true;
		obj=document.getElementById('AdmDiagDesc');
		if (obj) obj.disabled=true;
		obj=document.getElementById('ld251iAdmDiagDesc');
		if (obj) obj.disabled=true;
		obj=document.getElementById('AdmDiagType');
		if (obj) obj.disabled=true;
		obj=document.getElementById('ld251iAdmDiagType');
		if (obj) obj.disabled=true;
		obj=document.getElementById('AdmDiagNotes');
		if (obj) obj.disabled=true;
	}

	// ab 30200 5.12.02 - certain fields are ready only for waiting list tci
	var obj=document.getElementById("PAADMWaitListDR");
	if ((AdmType=="I")&&(AdmStatus=="P")&&(obj)&&(obj.value!="")) {
		var editCP=aryPATCF[7];
		if ((editCP)&&(editCP!="Y")) {
			obj=document.getElementById('CTPCPDesc')
			if (obj) obj.disabled=true;
			DisableLookup("ld251iCTPCPDesc");
		}
		var obj=document.getElementById('CTLOCDesc');
		if (obj) obj.disabled=true;
		DisableLookup("ld251iCTLOCDesc");
		var obj=document.getElementById('PAADMAdmDate');
		if (obj) obj.disabled=true;
		DisableLookup("ld251iPAADMAdmDate");
	}
	// these fields are determined in the code tables, cannot edit
	var obj=document.getElementById("CLNAddress1");
	if (obj) obj.readOnly=true;
	var obj=document.getElementById("CLNPhone");
	if (obj) obj.readOnly=true;

	//md 12.02.2003
	UseDischargeOnAdmission();

	// cjb 09/11/2004 46893 - disable the Rank 2 Insurance fields if EpisodePayorConfig is not R or ""
	if ((EpisodePayorConfig=="S")||(EpisodePayorConfig=="M")) DisableInsuranceRank2();

	// cjb 09/11/2004 46893 - disable all the Insurance fields if this is not a new episode
	// cjb 04/01/2005 48649 - allow pre-adm's to be edited
	// cjb 05/01/2005 48679 - allow Single EpisodePayorConfig episodes to be edited
	if ((EpisodeID!="")&&((AdmStatus!="P")&&(EpisodePayorConfig!="S"))) DisableInsurance();

	//Log 25484
	obj=document.getElementById('PAADMAdmDate');
	if (obj) obj.onchange=PAADMAdmDateTimeHandler;

	obj=document.getElementById('PAADMAdmTime');
	if (obj) obj.onchange=PAADMAdmDateTimeHandler;

	obj=document.getElementById('LocalDoctorCB');
	if (obj) obj.onclick=SetReferralSameAsFamilyDoc;

	obj=document.getElementById("IsCaseManager");
	if (obj) obj.onclick=IsCaseManager;

	obj=document.getElementById("CopyAdmission");
	if (obj) obj.onclick=CopyAdmissionClickHandler

	/*if ((CopyAdmisison)&&(AdmStatus)) {
		if (AdmStatus=="D") {
		CopyAdmisison.onclick=CopyAdmisisonClickHandler	;
	} else {
		CopyAdmisison.disabled=true;
		CopyAdmisison.onclick=LinkDisable;
		}
	}	*/

	var obj=document.getElementById("REFDDesc")
	if (obj) obj.onblur=InternalDrChangeHandler;

	var obj=document.getElementById('BedCode');
	if (obj) obj.onblur=BedBlurHandler;

	var obj=document.getElementById('HOSPDesc');
	if (obj) obj.onblur=HospBlurHandler;

	var obj=document.getElementById('WARDDesc');
	if (obj) obj.onblur=WardBlurHandler;

	var obj=document.getElementById('CTLOCDesc');
	if (obj) obj.onblur=LocBlurHandler;

	var obj=document.getElementById('CTPCPDesc');
	if (obj) obj.onblur=CPBlurHandler;

	// cjb 26/08/2005 54051 - copied from PAAdm.EditEmergency.js
	var obj=document.getElementById('RespForPaySelect');
	if (obj) obj.onblur=ResponsibleForPayBlur;

	obj=document.getElementById('update1')
	if (obj) obj.onclick = UpdateAll;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateAll;


	obj=document.getElementById('Delete1')
	if (obj) obj.onclick = DeleteHitter;
	if (tsc['Delete1']) websys_sckeys[tsc['Delete1']]=DeleteHitter;


	obj=document.getElementById('ViewFamilyDrDetails');
	if (obj) obj.onclick=ViewFamDoctorHandler;

	obj=document.getElementById('ViewDoctorDetails');
	if (obj) obj.onclick=ViewDoctorHandler;

	var obj=document.getElementById('REFDDesc');
	//if (obj) obj.onkeydown=REFDDesc_lookuphandlerCustom;
	var obj=document.getElementById('ld251iREFDDesc');
	//if (obj) obj.onclick=REFDDesc_lookuphandlerCustom;

	// GR 29/11 log 20904.  setting chaplain details to disabled.
	// BC 14-Feb-2002 LOG 22887 : Now required to be able to have both options ticked
	chapobj=document.getElementById('PAADMOwnMinisterIndicator');
	if (chapobj) {
		chapobj.onclick=EnableChaplainDetails;
		EnableChaplainDetails();
	}

	hospchapobj=document.getElementById('PAADMHospChaplainVisitReq');
	if (hospchapobj) {
		hospchapobj.onclick=HospitalChaplain;
		HospitalChaplain();
	}
	var objFlag=document.getElementById('PAADMViewablebyEpCareProv');
	if (objFlag) objFlag.onclick=SetViewableLink

	//md 14/08/2003

	var obj=document.getElementById('RSTDesc');
	if (obj) obj.onblur=RefStatChangeHandler;
	var obj=document.getElementById('REFSTREADesc');
	if (obj) obj.onblur=RefStatChangeHandler;

	//md 14/08/2003

	//md 13.08.2004
	var FUNDARObj=document.getElementById("FUNDARDesc");
	if (FUNDARObj) FUNDARObj.onblur=FUNDARBlurHandler;


	//md 13.08.2004


	setCrossValFields();
	setCrossValParams();
	//TN:29-Sep-2004: because CrossValFieldLvl() uses broker call, need to check that all frames are loaded
	// before broker can be called otherwise will get "HTTP Request failed. Unable to process hyperevent" error.
	//CrossValFieldLvl();
	CrossValFieldLvlInit();
	
	
	obj=document.getElementById('PIN');
	if (obj) obj.onblur=RelPin;
	
	obj=document.getElementById('UserCode');
	if (obj) obj.onchange=RelPin;



	//md 16.10.2002 Log 29441 Check Login Location and Edit Flag
	var obj=document.getElementById('CTLOCDesc');
	if ((obj)&&(obj.value!="")) {
		var objL=document.getElementById('LoginLocation');
		if ((objL)&&(objL.value!="")) {
			if (obj.value!=objL.value) {
				//var objC=document.getElementById('AllowEditLogLoc');
				var objC=document.getElementById('HiddenCodes').value.split("^")[5];
				var objID=document.getElementById('ID');
				if ((objC=="Y")&&(objID)&&(objID.value!="")) makeReadOnly()
			}
		}
	}

	// cjb 21/08/2003 35639 disable the Agrees EDD field (pregnancy lookup) if the patient is not female
	var obj=document.getElementById('IsFemale');
	if ((obj)&&(obj.value=="")) {
		obj=document.getElementById('PREGEdcAgreed')
		if (obj) {
			obj.disabled=true;
			obj.className = "disabledField";
		}
		obj=document.getElementById('ld251iPREGEdcAgreed')
		if (obj) {
			obj.disabled=true;
			obj.className = "disabledField";
		}
	}

    // ab - 51833 - if no hospital on screen, don't restrict lookups
    var obj=document.getElementById("HospID");
    var hosp=document.getElementById("HOSPDesc");
    if ((obj)&&(!hosp)) obj.value="";


	//md Logs 53756-53773
	if (EpisodeID=="") { DefaultPAADMAdmDateInitial(); }

    // ab 20.06.05 - 50882
    var obj=document.getElementById("ATTENDDesc");
    if (obj) {
        SOURCEATTEND_CHANGE=obj.onchange;
        obj.onchange=AttendanceChangeHandler;
    }
    //ypz begin
    if (EpisodeID=="") {
	    var objGetMotherLocWard=document.getElementById("GetMotherLocWard");
        if (objGetMotherLocWard){
	        var retStr=cspRunServerMethod(objGetMotherLocWard.value,PatientID);
	        var tmpList=retStr.split("^");
	        if (tmpList[3]){
	        	var objLocID=document.getElementById("LocID");
		        if (objLocID) objLocID.value=tmpList[0];
		        ReplaceHiddenCode(0,tmpList[0]);
		        ReplaceHiddenCode(1,tmpList[2]);
	            var objCTLOCDesc=document.getElementById('CTLOCDesc');
		        if (objCTLOCDesc) objCTLOCDesc.value=tmpList[1];
	            var objWARDDesc=document.getElementById('WARDDesc');
		        if (objWARDDesc) objWARDDesc.value=tmpList[3];
	        }
        }
    }
    //ypz end

	return;
}

//restrict the lookup on careproviders to specialists

function setConsultantFilter() {
	var obj=document.getElementById("conFlag");
	if (obj) obj.value="Y"
}

/*
//KM 20-Nov-2001: over-writes one from SCRIPTS_GEN so that it can pass in the WEBSYS.TCOMPONENT value:
function REFDDesc_lookuphandlerCustom(e) {
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))) {
		var namevaluepairs="&P1=&P2=&P3=&P5";
		var obj=document.getElementById('REFDDesc');
		var obj2=document.getElementById('ATTENDRefType');
		//obj2.value = "GP";
		//alert(obj2.value);
		if ((obj)&&(obj2)) {namevaluepairs="&P1="+obj.value+"&P2=&P3=&P5="+obj2.value;}
		REFDDesc_lookuphandlerCustom2(namevaluepairs);
	}
}


function REFDDesc_lookuphandlerCustom2(namevaluepairs) {
	var url='websys.lookup.csp';
	//url += "?ID=d251iREFDDesc&WEBSYS.TCOMPONENT=PACRefDoctor.CustomFind"+namevaluepairs;
	url += "?ID=d251iREFDDesc&WEBSYS.TCOMPONENT=PACRefDoctor.CustomFind&CONTEXT=Kweb.PACRefDoctor:LookUpDoctor&TLUJSF=ViewDoctorLookUp"+namevaluepairs;
	var tmp=url.split('%');
	url=tmp.join('%25');
	websys_createWindow(url,"lookup","top=30,left=20,width=620,height=420,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes");
	return websys_cancel();
}
*/
function setFamilyDoctor() {
	var str=document.getElementById("FamDoctorDetails")
	var famdr=document.getElementById("REFDDescFam")

	if ((str.value!="")&&(famdr)) {
		var obj=str.value.split("^");

		famdr.innerText=obj[1];
		}
}

function ViewFamDoctorHandler(e) {
	var obj=websys_getSrcElement(e)
	var objid=document.getElementById("FamREFDId")
	var view=document.getElementById("viewDr")
	view.value="1"
	var url="websys.default.csp?WEBSYS.TCOMPONENT=PACRefDoctor.Edit&ID="+objid.value+"&viewDr="+view.value
	websys_lu(url,false,"width=350,height=480")
	return false;
}
function ViewDoctorHandler(evt) {
	var obj=websys_getSrcElement(evt);
	//var objid=document.getElementById("doctorCode");
	var objid=document.getElementById('HiddenCodes').value.split("^")[3];
	var view=document.getElementById("viewDr")
	view.value="1";
		var url="websys.default.csp?WEBSYS.TCOMPONENT=PACRefDoctor.Edit&ID="+objid+"&viewDr="+view.value;
		websys_lu(url,false,"width=350,height=480")
		return false;

}



function ViewDoctorLookUp(str) {
	//structure as on 16/10/2003
	//DocTitle,DocDesc,DocMname,DocFname,refdId,DocCode,DocSpec,ClinCode,clinId,ClinProvNo,ClinAddr,ClinSuburb,tele,clindatefrom,clindateto,expired,type,ClinDesc,ClinCity,ClinZip)
	//  0	     1	     2	     3	      4	     5 	      6	     7         8      9	        10	  11	     12	  13	       14        15    16   17		18	19
	//MD 16/10/2003
 	var lu = str.split("^");
	//md 16/10/2003
	var fulladdress=""
	// cjb 03/02/2005 49474 - fulladdress now returned from the query
	if (lu[29]!="") {fulladdress=lu[29];}
	if (fulladdress=="") {
		if (lu[17]!="") {fulladdress=lu[17];}
		if (lu[10]!="") {fulladdress=fulladdress+","+lu[10];}
		if (lu[18]!="") {fulladdress=fulladdress+","+lu[18];}
		if (lu[19]!="") {fulladdress=fulladdress+","+lu[19];}
	}
	//md 16/10/2003
	// Set Referal Doctor Code to hidden field
	var obj=document.getElementById("REFDCode")
	if (obj) obj.value = lu[5]
	obj=document.getElementById("REFDDesc")
	if (obj) obj.value = lu[1]
	//obj=document.getElementById("doctorCode");
	//if (obj) obj.value = lu[4];
	ReplaceHiddenCode(3,lu[4]);
	obj=document.getElementById("CLNAddress1");
	//if (obj) obj.value = lu[10];
	if (obj) obj.value = fulladdress;
	obj=document.getElementById("CLNPhone");
	if (obj) obj.value = lu[12];
	obj=document.getElementById("CLNProviderNo")
	if (obj) obj.value = lu[9]
 	obj=document.getElementById("PAADMRefDocClinicDR");
	if (obj) obj.value = lu[8];
	obj=document.getElementById("REFDTitle");
	if (obj) obj.value = lu[0];
 	obj=document.getElementById("REFDForename");
	if (obj) obj.value = lu[3];

	obj=document.getElementById("REFDFullName");
	if (obj) obj.innerText=lu[30];

	DocFieldMngr1();

}

// dummy used in ARMC custom script (46981)
function DocFieldMngr1() {
}

function ViewFamilyDrLookUp(str) {
 	var lu = str.split("^");
	// Set Referal Doctor Code to hidden field
	var obj=document.getElementById("FamREFDCode")
	if (obj) obj.value = lu[0]
	obj=document.getElementById("REFDDescFam")
	if (obj) obj.value = lu[1]
 	obj=document.getElementById("FamREFDId")
	if (obj) obj.value = lu[1];
	obj=document.getElementById("FamilyClinicAddress");
	if (obj) obj.value = lu[4];
	obj=document.getElementById("PAPERFamilyDoctorClinicDR");
	if (obj) obj.value = lu[6];
	obj=document.getElementById("FamDoctorDetails");
	if (obj) obj.value = str;

}

function CTPCPDescLookupSelect(str) {
 	var lu = str.split("^");
	//var obj=document.getElementById("CTPCPCode");
	//if (obj) obj.value=lu[1];
	ReplaceHiddenCode(2,lu[1]);
	var obj=document.getElementById("CTLOCDesc");
	if ((obj)&&(lu[2]!="")) obj.value=lu[2];
	if (lu[4]!="") ReplaceHiddenCode(0,lu[4]);
}

function TreatingLookupSelect(str) {
 	var lu = str.split("^");
	//var obj=document.getElementById("PAADMTreatingDrCode");
	//if (obj) obj.value=lu[1];
	ReplaceHiddenCode(6,lu[1]);
}

function internalDrLookUp(str) {
 	var lu = str.split("^");
	var obj=document.getElementById('PAADMInternalRefDr')
	if (obj) obj.value = lu[0]
	obj=document.getElementById('CTPCPSMCNo');
	if (obj) obj.value = lu[3];
}

function InternalDrChangeHandler(e) {
	// clear the ref doctor address fields if blank.
	var obj=document.getElementById("REFDDesc");
	if ((obj)&&(obj.value=="")) {
		obj=document.getElementById('CTPCPSMCNo')
		if (obj) obj.value = "";
		var obj=document.getElementById("CLNAddress1");
		if (obj) obj.value="";
		var obj=document.getElementById("CLNPhone");
		if (obj) obj.value="";
		var obj=document.getElementById("CLNProviderNo");
		if (obj) obj.value="";
		var obj=document.getElementById("REFDCode");
		if (obj) obj.value="";
		var obj=document.getElementById("PAADMRefDocClinicDR");
		if (obj) obj.value="";
		//var obj=document.getElementById("doctorCode");
		//if (obj) obj.value="";
		ReplaceHiddenCode(3,"");
		//md 12/02/2003
		obj=document.getElementById("REFDTitle");
		if (obj) obj.value = "";
 		obj=document.getElementById("REFDForename");
		if (obj) obj.value = "";
		//md 12/02/2003
		obj=document.getElementById("REFDFullName");
		if (obj) obj.innerText="";
	}
}

function LocationChangeHandler(e) {
	var obj=document.getElementById('DEPDesc')
	if (obj) obj.value = "";
}

// ab - not used ?!
function CareProvChangeHandler(e) {
	var obj=document.getElementById('DEPDesc')
	if (obj) obj.value = "";
	var obj=document.getElementById("CTLOCDesc")
	if (obj) obj.value="";
}

function DepartmentLookUp(str) {
	//KM 19-Nov-2001: Edited this after changing which LookUp Queries Location and CareProvider use.
 	var lu = str.split("^");
	var obj=document.getElementById('CTLOCDesc')
	if (obj) obj.value = lu[0]
	var obj=document.getElementById('CTPCPDesc')
	if (obj) obj.value = lu[1]
	var obj=document.getElementById('DEPDesc')
	if (obj) obj.value = lu[5]
}

function ResourceLookUp(str) {
	var lu = str.split("^");
	var obj=document.getElementById('CTPCPDesc')
	if (obj) obj.value = lu[0]

}

function LocationLookUp(str) {
	var lu = str.split("^");
	var obj=document.getElementById('CTLOCDesc');
	if (obj) obj.value = lu[1];
	var obj=document.getElementById('DEPDesc');
	if (obj) obj.value = lu[2];
	ReplaceHiddenCode(0,lu[3]);
	var obj=document.getElementById('LocID');
	if (obj) obj.value = lu[3];

	//var obj=document.getElementById('HOSPMandatoryRefHospital');
	//if (obj) {
	//	obj.value=lu[5];
	//	setSourceOfAttend();
	//}
	ReplaceHiddenCode(13,lu[5]);
	//setSourceOfAttend();

	//var MentalHealthFlag=document.getElementById("mentalhealthunit");
	//if (MentalHealthFlag) {
	//	MentalHealthFlag.value=lu[4];
	//	CheckForMentalHealth();
	//}
	ReplaceHiddenCode(14,lu[4]);
	CheckForMentalHealth();
}

// ab 10.06.04
function ReplaceHiddenCode(piece,val) {
	var obj=document.getElementById('HiddenCodes');
	if (obj) {
		var hiddenCodes=obj.value.split("^");
		hiddenCodes[piece]=val;
		obj.value=hiddenCodes.join("^");
	}
}

// ab 10.12.03 - moved from custom script since the reference was moved here, also changed link to psychdetails.csp
function MentalHealthClickHandler() {
	var id=document.getElementById('ID').value;
	var epi=document.getElementById('EpisodeID').value;
	var pat=document.getElementById('PatientID').value;
	var mradm=document.getElementById('mradm').value;
	var CONTEXT=session["CONTEXT"];
	websys_createWindow("psychdetails.frames.csp?PatientID="+pat+"&EpisodeID="+epi+'&mradm='+mradm+'&CONTEXT='+CONTEXT+'&PatientBanner=1','MentalHealth',"top=30,left=20,width=620,height=420,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes");
	return false;
}

function CheckForMentalHealth()  {
	var MentalHealthLink=document.getElementById("PsychDetails");
	//var MentalHealthFlag=document.getElementById("mentalhealthunit");
	var MentalHealthFlag=document.getElementById('HiddenCodes').value.split("^")[14];
	if (MentalHealthLink) {
		//if ((EpisodeID)&&(EpisodeID.value!="")&&(MentalHealthFlag=="Y")) {
		if ((EpisodeID)&&(EpisodeID.value!="")&&(MentalHealthFlag=="Y")&&(CheckMHAgainstBoarder())) {
			MentalHealthLink.disabled=false;
			MentalHealthLink.onclick=MentalHealthClickHandler;
		} else {
	     		MentalHealthLink.disabled=true;
			try {MentalHealthLink.onclick=LinkDisable;} catch(e) {MentalHealthLink.onclick=FalseLink;}
	     		//MentalHealthLink.onclick=LinkDisable;
		}
	}
}

function CheckMHAgainstBoarder() {
	return true;
}

function FUNDARBlurHandler() {
	var obj=document.getElementById("FUNDARDesc");
	if ((obj)&&(obj.value=="")) { ReplaceHiddenCode(4,""); }

}

function ContrCareClickHandler()	{
	var id="";
	var epi=document.getElementById('EpisodeID').value;
	var pat=document.getElementById('PatientID').value;
	var admdate=document.getElementById('PAADMAdmDate');
	if (admdate) {admd=admdate.value;}
	if (!admdate) {admd="_zz";}
	var disdate=document.getElementById('PAADMDischgDate');
	if (disdate) {disd=disdate.value;}
	if (!disdate) {disd="_zz";}
	var CONTEXT=session["CONTEXT"]
	websys_createWindow('paadmcontractcare.csp?%ID='+id+'&PatientID='+pat+'&EpisodeID='+epi+'&PAADMAdmDate='+admd+'&CONTEXT='+CONTEXT+'&PAADMDischgDate='+disd+'&PatientBanner=1','',"top=30,left=20,width=620,height=420,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes");
	return false;
}

function UpdateAll() {
	//alert(parent.frames)
	// ab 18.03.02 - log 23587 - prompt to update if age is out of room range
	//ab 12.05.03 - 33794 - modified age restrict code and moved to websysSave of PAAdm as cache error messages

	//ab 8.05.03 - modified sex restrict code and moved to websysSave of PAAdm as cache error messages
	if (!CheckInvalidFields())  { return false; }
	// 9/7/02 HP Log#26116: Reload paadm.diagnosis.csp page
	if ((window.top.frames["TRAK_main"])&&(window.top.frames["TRAK_main"].frames["upper"])) {
		var frm = document.forms["fPAAdm_Edit"];
		frm.target = "_parent";
		//obj=document.getElementById('tohidden');
		//if (obj.value==1) {
		//	document.fPAAdm_EditEmergency.target="TRAK_hidden";
		//}
	}
	var objSD=document.getElementById("PAADMFlaggedPatient");
	var objOpDt=document.getElementById("PAADM2OperationDate");
	var objEpDt=document.getElementById("PAADMAdmDate");
	if ((objSD)&&(objOpDt)&&(objEpDt)) {
		if ((objSD.value=="Yes")&&(objEpDt.value!=objOpDt.value)) {
			alert(t['SAME_DAYOP'])
			return false;
		}
	}
	//md 14.03.2003
	//md 16/09/2003
	if (!CheckMandatoryFields()) { return ;}
	//
	CheckInvalid();
	// perform final cross validation before update, if errors then dont allow update
	var objCV=document.getElementById("CrossVal");
	if (objCV) objCV.value=1;
	setCrossValParams();
	CrossVal(0);
	var objCV=document.getElementById("CrossVal");
	if ((objCV)&&(objCV.value==2)) return false;
	// end of cross validation

	//JW: removed.  this function causes the episode id to be lost on workflow for new episodes.
//    	if ((parent)&&(parent.frames)&&(parent.frames['tree_list'])) parent.UpdateTreeClose();


	//md 02/02/2005
	EnableForUpdate();
	//md 02/02/2005
	//if (document.getElementById('payCode')) alert(document.getElementById('payCode').value);
	return update1_click();
	
}
if ((parent)&&(parent.frames)&&(parent.frames['tree_list'])) parent.UpdateTreeClose();

/*function UpdateTree() {
	//dummy for paadm.edittree.csp
	if ((parent)&&(parent.frames)&&(parent.frames['tree_list'])) parent.UpdateTreeClose();
	return update1_click();
} */

//functions used to enable/disable fields and display label as mandatory/non mandatory
//presently called by custom script for Austin, but left here for general use

/*function PayorChangeHandler() {
	var obj=document.getElementById("InsurPlan")
	if (obj) obj.value="";
	obj=document.getElementById("InsurOffice")
	if (obj) obj.value="";
	obj=document.getElementById("InsurCardNo")
	if (obj) obj.value="";
	obj=document.getElementById('payorCategory');
	if (obj) obj.value="";
	obj=document.getElementById('payCode');
	if (obj) obj.value="";

	setLinksAgain();
} */

function DeleteHitter() {

	if(!window.confirm(t['DeleteWarning'])) {
	return false;
	}
	return Delete1_click();
}


function PayorSetHandler(str) {
	var lu = str.split("^");
	var obj=document.getElementById('InsurPayor')
	if (obj) obj.value=lu[0];
	obj=document.getElementById("payorCategory")
	if (obj) obj.value = lu[3];
	var obj=document.getElementById('InsurPlan')
	if (obj) obj.value="";
	var obj=document.getElementById('payCode')
	if (obj) obj.value = lu[2];
	var obj=document.getElementById('InsurPayorID')
	if (obj) obj.value = lu[1];
	//alert("rank1:"+obj.value);
	//md 14.01.2005 Log48892 return follow line
	PayorSelectChangeHandler();
	// 09.10.02 Log#28284 HP: Compensable Details link changed to remains disabled on change of Payor
	//setLinksAgain();
	//md 26/11/2003
	setCrossValParams();
	return true;
}

/*function PayorLookupSelect(str) {
 	var lu = str.split("^");
 	var obj=document.getElementById("InsurPayor")
	if (obj) obj.value = lu[0];
 	obj=document.getElementById("payorCategory")
	if (obj) obj.value = lu[3];
	//setLinksAgain();
 }*/

function PlanLookupSelect(str) {
	//alert(str);
 	var lu = str.split("^");
 	var obj=document.getElementById("InsurPlan")
	if (obj) obj.value = lu[0];
 	obj=document.getElementById("InsurPayor")
	if (obj) obj.value = lu[1];
	obj=document.getElementById("payCode")
	if (obj) obj.value = lu[5];
	// Uncomment the following two lines if you want the Insurance Card Number populated automatically (if it is available)
 	//obj=document.getElementById("InsurCardNo")
	//if (obj) obj.value = lu[4];
 }

 // 6.2.03 HP Log 32231
 function PayorRank2SetHandler(str) {
 	var lu = str.split("^");
	var obj=document.getElementById('InsPayorRank2')
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('InsPlanRank2')
	if (obj) obj.value="";
	var obj=document.getElementById('payCodeRank2')
	if (obj) obj.value = lu[2];
	var obj=document.getElementById('InsurPayorIDRank2')
	if (obj) obj.value = lu[1];
	//alert("rank2:"+obj.value);
}

function PlanRank2LookupSelect(str) {
	//alert(str);
 	var lu = str.split("^");
 	var obj=document.getElementById("InsPlanRank2")
	if (obj) obj.value = lu[0];
 	obj=document.getElementById("InsPayorRank2")
	if (obj) obj.value = lu[1];
	obj=document.getElementById("payCodeRank2")
	if (obj) obj.value = lu[5];
 }

function ReferralStatusLookUp(str) {
	// dummy required to populate field for use in setReasonRejected
}

function ReferralStatusReasonLookUp(str) {
	// dummy function
}

function BedLookUpFill(str) {
	var lu = str.split("^");
	var obj=document.getElementById("BedCode")
	if (obj) obj.value=lu[0];
	//document.getElementById("PAAdmCurrentBedDR").value=lu[3];
	//var obj=document.getElementById('BedID');
	//if (obj) obj.value=lu[5];
	ReplaceHiddenCode(22,lu[5]);
	var obj=document.getElementById("ROOMDesc");
	if (obj) obj.value=lu[2];
	var obj=document.getElementById("TRANSBedTypeDR");
	if (obj) obj.value=lu[3];
	//md SNAP Staff//
	var flag=lu[21]
	if (flag=="") { flag="N" }
	ReplaceHiddenCode(20,flag);
	var flag=lu[22];
	if (flag=="") { flag="N" }
	ReplaceHiddenCode(28,flag);

    // ab 29.07.05 54365
    var obj=document.getElementById("WARDDesc");
    if (obj) obj.value=lu[1];
    ReplaceHiddenCode(1,lu[23]);

	// ab 11.06.04 - removed these fields from the component since the validations are now done in websyssave
	//var obj=document.getElementById('CTLOCAgeFrom');
	//if (obj) obj.value=lu[6];
	//var obj=document.getElementById('CTLOCAgeTo');
	//if (obj) obj.value=lu[7];
	//var obj=document.getElementById("ROOMDifferentSexPatients");
	//if (obj) obj.value=lu[8];
	//var obj=document.getElementById("ROOMSex");
	//if (obj) obj.value=lu[9];
	//var obj=document.getElementById('RoomDiffSexPatDesc');
	//if (obj) obj.value=lu[18];

}

function BedBlurHandler() {
	var obj=document.getElementById('BedCode');
	//var objBedID=document.getElementById('BedID');
	if ((obj)&&(obj.value=="")){
	 ReplaceHiddenCode(22,"");
	 ReplaceHiddenCode(28,"");
				   }
}

function WardLookUpFill(str) {
	var lu = str.split("^");
	var objWard=document.getElementById("WARDDesc");
	if (objWard) objWard.value=lu[0];
	ReplaceHiddenCode(1,lu[2]);
	var obj=document.getElementById("BedCode");
	if (obj) obj.value="";
	//var obj=document.getElementById("BedID");
	//if (obj) obj.value="";
	ReplaceHiddenCode(22,"");
	var obj=document.getElementById("ROOMDesc");
	if (obj) obj.value="";
	//KM 9-May-2002: No longer needed as bed info is now all passed in through BedCode
	//var obj=document.getElementById("PAAdmCurrentBedDR");
	//if (obj) obj.value="&&&"+lu[1]; //KM 30-Apr-2002: this was passing through delimited string but this is build up in PAAdm.websysSave().
	//if (obj) obj.value=""
	//obj=document.getElementById('CTLOCAgeFrom');
	//if (obj) obj.value=lu[3];
	//var obj=document.getElementById('CTLOCAgeTo');
	//if (obj) obj.value=lu[4];
	//md 05/01/2004
	//var obj=document.getElementById('SNAPWardflag');
	//if (obj) obj.value=lu[7];
	ReplaceHiddenCode(20,lu[7]);
	//alert(obj.value);
	//md 05/01/2004
	//md 23/04/2003
	//var objWM=document.getElementById('wardmessage');
	//var objCW=document.getElementById('closedwarddesc');
	//var obj=document.getElementById('IsWardClosed');
	//if (obj) obj.value=lu[5];
	var objWM=document.getElementById('HiddenCodes').value.split("^")[10];
	var objCW=document.getElementById('HiddenCodes').value.split("^")[11];
	ReplaceHiddenCode(12,lu[5]);
	//md 23/04/2003
	if ((lu[5]=="Y")&&(objWM!="Y")&&(objWard)&&(objCW!=(objWard.value))) {WardChangeHandler(lu[5])}
}

// ab 18.07.03 - 36995
function RoomLookUpFill(str) {
	var lu=str.split("^");
	var obj=document.getElementById("BedCode");
	if (obj) obj.value="";
	//var obj=document.getElementById("BedID");
	//if (obj) obj.value="";
	ReplaceHiddenCode(22,"");

    // ab 29.07.05 54365
    var obj=document.getElementById("WARDDesc");
    if (obj) obj.value=lu[1];
    ReplaceHiddenCode(1,lu[9]);
}

//HP 15-Nov-2002 Log#29549: Confirm to continue or not if ward closed - also in ARMC script
function WardChangeHandler(IsWardClosed) {
	//var obj=document.getElementById('IsWardClosed');
	var ward=document.getElementById("WARDDesc");
	var bed=document.getElementById("BedCode");
	//var bedid=document.getElementById("BedID");
	var bedid=document.getElementById('HiddenCodes').value.split("^")[22];
	//md 23/04/2003
	//var objWM=document.getElementById('wardmessage');
	//var objCW=document.getElementById('closedwarddesc');
	var objWM=document.getElementById('HiddenCodes').value.split("^")[10];
	var objCW=document.getElementById('HiddenCodes').value.split("^")[11];

	//md 23/04/2003
	if (IsWardClosed=="Y") {
		window.focus();
		//if (objWM) objWM.value="Y";
		ReplaceHiddenCode(10,"Y");
		if (ward) ReplaceHiddenCode(11,ward.value);
		if(!window.confirm(t['WardClosed'])) {
			if ((ward)&&(ward.value!="")) ward.value="";
			if ((bed)&&(bed.value!="")) bed.value="";
			if (bedid!="") ReplaceHiddenCode(22,"");
			//md 23/04/2003
			//if (objWM) objWM.value="";
			//if (objCW) objCW.value="";
			ReplaceHiddenCode(10,"");
			ReplaceHiddenCode(11,"");
		}
	}
	ward.focus();
}

function setLinks() {
	var objID=document.getElementById('ID');
	var obj=document.getElementById('hiddenLinks');
	if (obj) obj.value="0";
	var obj=document.getElementById('InsurPayor');
	if (obj) var payor=obj.value;
	obj=document.getElementById('EpisodeID');
	if ((obj)&&(obj.value=="")) {
		var obj=document.getElementById('hiddenLinks');
		if (obj) obj.value="1";
		SetupHiddenLink("InsurDet");
		SetupHiddenLink("REFDocs");
		SetupHiddenLink("ApptLetterLink");
		SetupHiddenLink("PAADMRefLocation");
		SetupHiddenLink("CompoDetails");
		SetupHiddenLink("DischargeEpisode");
		SetupHiddenLink("AuditTrailData");
		SetupHiddenLink("AuditTrailLog");
		SetupHiddenLink("BedBooking");
		SetupHiddenLink("Unavail");
		SetupHiddenLink("ScanDocuments");
		SetupHiddenLink("PsychDetails");
		SetupHiddenLink("ViewableBy");
		// HP Log 32422
		SetupHiddenLink("EpisodeContactLink");
		SetupHiddenLink("ReferralDetails");
		// cjb 04/02/2004 35528
		SetupHiddenLink("MaternityComplications");
		SetupHiddenLink("QualificationHistory");
		//md 13.08.2004
		SetupHiddenLink("ContractCare");

	}
	if (AdmStatus!="D") {
	    SetupHiddenLink("CopyAdmission");
	}
	obj=document.getElementById('EpisodeID');
	if ((obj)&&(obj.value!="")) {
		var obj=document.getElementById('payorCategory');
		if ((obj.value!="Auto") && (obj.value!="Labour")&&(obj.value!="Foreign")) {
				SetupHiddenLink("CompoDetails");
			//var obj=document.getElementById('CompoDetails');
			//if (obj) {
				//obj.disabled=true;
				//obj.onclick=LinkDisable;
			//}
		}
		obj=document.getElementById('AddExtRef');
		try {if (obj) DisableField(obj);} catch(e) {}
		//if (obj) DisableField(obj);

		// set the original link to a temp variable, then can enable/disable
		var obj=document.getElementById("ViewableBy");
		if ((obj)&&(VIEWABLE_CLICK=="")) VIEWABLE_CLICK=obj.onclick;
		SetViewableLink();
		var obj=document.getElementById("PAADMViewablebyEpCareProv");
		if (obj) obj.onclick=SetViewableLink;
	}
	obj=document.getElementById('PAADMWaitListDR');
	if ((obj)&&(obj.value=="")){
		SetupHiddenLink('waitinglistdetails');
		//var obj=document.getElementById('waitinglistdetails');
		//if (obj) {
			//obj.disabled=true;
			//obj.onclick=LinkDisable;
		//}
	}
	// 25.03.03 Log 33809 HP: Disable Palliative Care link - used in QH only

	//var PalCareObj=document.getElementById("PalliativeCare");
	//if (PalCareObj) {
		//PalCareObj.disabled=true;
		//PalCareObj.onclick=LinkDisable;
	//}
	// 13.05.03 Log 33816 MD: Disable Contract Care link - used in QH only
	//md 13.08.2004 no any more 44797
	//var ContrCareObj=document.getElementById("ContractCare");
	//if (ContrCareObj) {
	//	ContrCareObj.disabled=true;
	//	ContrCareObj.onclick=LinkDisable;
	//}
	// 14.05.03  MD: Disable SNAP link - used in QH only

	var SNAPObj=document.getElementById("SNAPScreen");
	if (SNAPObj) {
		SNAPObj.disabled=true;
		try {SNAPObj.onclick=LinkDisable;} catch(e) {SNAPObj.onclick=FalseLink;}
		//SNAPObj.onclick=LinkDisable;
	}
}

function SetupHiddenLink(link) {
	var obj=document.getElementById(link);
	if (obj) {
			obj.disabled=true;
			try {obj.onclick=LinkDisable;} catch(e) {obj.onclick=FalseLink;}
			//obj.onclick=LinkDisable;
		}
}

function SetViewableLink() {
	var objFlag=document.getElementById("PAADMViewablebyEpCareProv");
	var obj=document.getElementById("ViewableBy");
	if ((obj)&&((!objFlag)||((objFlag)&&(objFlag.checked==false)))) {
		obj.disabled=true;
		try {obj.onclick=LinkDisable;} catch(e) {obj.onclick=FalseLink;}
		//obj.onclick=LinkDisable;
		//objCheck=0;
	}
	if ((obj)&&(objFlag)&&(objFlag.checked==true)) {
		obj.disabled=false;
		obj.onclick=VIEWABLE_CLICK;
		//objCheck=1;
	}
}

/*function setLinksAgain() {
	obj=document.getElementById('EpisodeID');
	if ((obj)&&(obj.value!="")) {
		var obj=document.getElementById('payorCategory');

		if ((obj.value=="Auto") || (obj.value=="Labour")) {
			var comp=document.getElementById('CompoDetails');
			if (comp) {
				comp.disabled=false;
				comp.onclick=DoLink;
			}
		}
		if ((obj.value!="Auto") && (obj.value!="Labour")) {
			var comp=document.getElementById('CompoDetails');
			if (comp) {
				comp.disabled=true;
				comp.onclick=DoLink
			}
		}
		else {
			var obj=document.getElementById('hiddenLinks');
			if (obj) obj.value="2";
		}
	}
	obj=document.getElementById('ViewableBy');
	objFlag=document.getElementById('PAADMViewablebyEpCareProv');
	objBold=document.getElementById('BoldLinks');
	if ((obj) && (objBold)) {
		var BoldLink = objBold.value.split("^");
		if (BoldLink[3]=="1") {
			obj.style.fontWeight="bold";
			if (objCheck==1) objFlag.checked=true;
		}
	}
}
*/
function DoLink() {
    var code=""
    var payCat=""
    var pay=""
	var comp=document.getElementById('CompoDetails');
	if (comp.disabled) {
		return false;
	} else {
		var obj=document.getElementById('InsurPayor');
		var obj=document.getElementById('InsurPayor')
		if (obj) pay=obj.value
		obj=document.getElementById("payorCategory")
		if (obj) payCat=obj.value
		obj=document.getElementById("payCode")
		if (obj) code=obj.value
		// 21.5.02 HP Log# 24336: Resize frame to fit 800X600.
		websys_createWindow('patrafficaccidentframe.csp?EpisodeID='+EpisodeID+'&PatientID='+PatientID+'&payCategory='+payCat+'&InsurPayor='+pay+'&payCode='+code+'&ID=','comp','top=20,left=20,width=750,height=500,resizable=yes');
		return false;
	}
}

// where is this called?!
/*function ViewCompoDetails(evt) {
	var el = websys_getSrcElement(evt);
	id=document.getElementById("EpisodeID")
	patid=document.getElementById("PatientID")
	TFORM=document.getElementById("TFORM")
	TEVENT=document.getElementById("TEVENT")
	TNAVMARK=document.getElementById("TNAVMARK")
	TPAGID=document.getElementById("TPAGID")
	payorCat=document.getElementById("payorCategory")
	var obj=document.getElementById('InsurPayor');
	if (obj) pay=obj.value;
	obj=document.getElementById("payCode");
	if (obj) code=obj.value;
	var url="patrafficaccidentframe.csp?TFORM="+TFORM.value +"&TEVENT"+TEVENT.value +"&TNAVMARK="+TNAVMARK.value +"&TPAGID="+TPAGID.value +"&EpisodeID="+id.value +"&PatientID="+patid.value+"&ID="+id.value+"&payorCategory="+payorCat.value+'&InsurPayor='+pay+'&payCode='+code;
	websys_lu(url,false,"width=700,height=500")
	return false;
} */

function PAAdm_ChangeStatusHandler(lnk,win) {
	var wlid=""
	var wl=document.getElementById("TCI")
	if ((wl)&&(wl.value!="")) wlid=wl.value
	var obj=document.getElementById("PAADMWaitListDR")
	// cjb 13/10/2003 39474 - pass the context to the change status w/flow
	var CONTEXT=session["CONTEXT"]

	/*if ((obj)&&(obj.value=="")) {
		//websys_createWindow('websys.default.csp?WEBSYS.TCOMPONENT=PAAdm.ChangeStatus&EpisodeID='+ID+'&presentStatus='+Status,'Prompt','top=0,left=0,width=300,height=300');
		if (lnk) lnk += '&EpisodeID='+ID+'&presentStatus='+Status;
	} */
	if ((obj)&&(obj.value!="")&&(AdmStatus=="P")) {
		//websys_createWindow('pawaitlistadm.csp?WEBSYS.TCOMPONENT=PAWaitingListAdm.Edit&PARREF='+obj.value+'&TWKFL='+TWKFL+'&PatientID='+pat+'&ID='+wlid,'Prompt','top=0,left=0,width=600,height=600,scrollbars=yes,resizable=yes');
		if (lnk) lnk += '&TCI=1&PARREF='+obj.value+'&ID='+wlid+'&tempCONTEXT='+CONTEXT;
	} else {
		if (lnk) lnk += '&EpisodeID='+EpisodeID+'&presentStatus='+AdmStatus+'&tempCONTEXT='+CONTEXT;
	}
	websys_createWindow(lnk,'Prompt','top=0,left=0,width=600,height=600,scrollbars=yes,resizable=yes');
}

// cjb 04/08/2003 37101
function PAAdm_ReverseDischargeHandler(lnk,win) {
	var PatientID=document.getElementById('PatientID').value;
	var EpisodeID=document.getElementById('EpisodeID').value;
	var mradm=document.getElementById('mradm').value;
	websys_createWindow("websys.default.csp?WEBSYS.TCOMPONENT=MRAdm.ReverseDischargeEdit&PatientID="+PatientID+"&EpisodeID="+EpisodeID+'&mradm='+mradm+'&ID='+mradm+"&PatientBanner=1",'comp','top=20,left=20,width=300,height=100,scrollbars=yes,resizable=yes');
}

// md 16/09/2004  45816
function PAAdm_ReverseCancellation(lnk,win) {
	var PatientID=document.getElementById('PatientID').value;
	var EpisodeID=document.getElementById('EpisodeID').value;
	var mradm=document.getElementById('mradm').value;
	var Action="C"
	websys_createWindow("websys.default.csp?WEBSYS.TCOMPONENT=MRAdm.ReverseDischargeEdit&PatientID="+PatientID+"&EpisodeID="+EpisodeID+'&mradm='+mradm+'&ID='+mradm+'&Action='+Action+"&PatientBanner=1",'comp','top=20,left=20,width=300,height=100,scrollbars=yes,resizable=yes');
}

function HospitalChaplain() {
	hospchapl=document.getElementById('PAADMHospChaplainVisitReq');
	ownchap=document.getElementById('PAADMOwnMinisterIndicator');
	EnableChaplainDetails()
}

function EnableChaplainDetails() {
	chapaddress=document.getElementById('PAADMChaplainChurchAddress');
	chapname=document.getElementById('PAADMChaplainName');
	chapphone=document.getElementById('PAADMChaplainPhone');
	hospchap=document.getElementById('PAADMHospChaplainVisitReq');
	chapobj=document.getElementById('PAADMOwnMinisterIndicator');
	if ((chapobj)&&(chapobj.checked)) {
		if (chapaddress) EnableField(chapaddress);
		if (chapname) EnableField(chapname);
		if (chapphone) EnableField(chapphone);
	}
	else {
		if (chapaddress) DisableField(chapaddress);
		if (chapname) DisableField(chapname);
		if (chapphone) DisableField(chapphone);
		if (hospchap) EnableField(hospchap);
	}
}

function IsCaseManager() {
	var obj=document.getElementById("IsCaseManager");
	var objCP=document.getElementById("CTPCPDesc");
	var objCM=document.getElementById("CMCTPCPDesc");
	if ((obj)&&(objCP)&&(objCM)) {
		if (obj.checked) {
			objCM.value=objCP.value;
			objCM.readOnly=true;
		} else {
			objCM.value="";
			objCM.readOnly=false;
		}
	}
}

function SetReferralSameAsFamilyDoc(evt) {
	var cbx = websys_getSrcElement(evt);
	var FamDocDet=document.getElementById("FamDoctorDetails").value;
	//doccode_"^"_docdesc_"^"_docid_"^"_clncode_"^"_clnaddr_"^"_clnprovno_"^"_clinicid_"^"_clncitydesc_"^"_clnphone_"^"_docfname_"^"_doctitle_"^"_clndesc_"^"_clnzip
	//0		1	   2		3	   4		5	      6		    7		  8		9	    10		11	   12
	var FamAry = FamDocDet.split("^");
	var famdesc=document.getElementById("REFDDescFam");

	var refby=document.getElementById("REFDDesc");
	var refbylookup=document.getElementById("ld251iREFDDesc");
	//var refbyid=document.getElementById("doctorCode");	//hidden field
	var refbyid=document.getElementById('HiddenCodes').value.split("^")[3];
	var refbycode=document.getElementById("REFDCode");	//hidden field
	var refbyClinicProvNo=document.getElementById("CLNProviderNo");
	var refbyClinicDR=document.getElementById("PAADMRefDocClinicDR");	//hidden field
	var refClinicAddr=document.getElementById("CLNAddress1");
	var refClinicPhone=document.getElementById("CLNPhone");
	var refdocfname=document.getElementById("REFDForename");
	var refdoctitle=document.getElementById("REFDTitle");

	//md 16/10/2003
	var fulladdress=""
	if (FamAry[11]!="") {fulladdress=FamAry[11];}
	if (FamAry[4]!="") {fulladdress=fulladdress+","+FamAry[4];}
	if (FamAry[7]!="") {fulladdress=fulladdress+","+FamAry[7];}
	if (FamAry[12]!="") {fulladdress=fulladdress+","+FamAry[12];}
	//md 16/10/2003

	if (cbx.checked) {
		if (FamAry[1]!="") {
			if ((FamAry[1])&&(refby)) refby.value=FamAry[1];


			if (FamAry[2]) refbyid=FamAry[2];
			else refbyid="";

			if (refbycode) {
				if (FamAry[0]) refbycode.value=FamAry[0];
				else refbycode.value="";
			}
			if (refbyClinicDR) {
				if (FamAry[6]) refbyClinicDR.value=FamAry[6];
				else refbyClinicDR.value="";
			}
			if (refbyClinicProvNo) {
				if (FamAry[5]) refbyClinicProvNo.value=FamAry[5];
				else refbyClinicProvNo.value="";
			}
			if (refClinicAddr) {
				//if (FamAry[4]) refClinicAddr.value=FamAry[4];
				//else refClinicAddr.value="";
				refClinicAddr.value=fulladdress;
			}
			if (refClinicPhone) {
				if (FamAry[8]) refClinicPhone.value=FamAry[8];
				else refClinicPhone.value="";
			}
			if (refdocfname) {
				if (FamAry[9]) refdocfname.value=FamAry[9];
				else refdocfname.value="";
			}
			if (refdoctitle) {
				if (FamAry[10]) refdoctitle.value=FamAry[10];
				else refdocfname.value="";
			}
		}
		if (refby) refby.disabled=true;
		if (refbylookup) refbylookup.disabled=true;
	} else {
		if (refby) refby.value='';
		refbyid.value='';
		if (refbycode) refbycode.value='';
		if (refbyClinicProvNo) refbyClinicProvNo.value="";
		if (refbyClinicDR) refbyClinicDR.value="";
		if (refClinicAddr) refClinicAddr.value="";
		if (refClinicPhone) refClinicPhone.value="";
		if (refby) refby.disabled=false;
		if (refbylookup) refbylookup.disabled=false;
		if (refdocfname) refdocfname.value="";
		if (refdoctitle) refdoctitle.value="";
	}
}

function RefDoctorLookupSelect(txt)
{
 	var lu = txt.split("^");
	// Set Referal Doctor Code to hidden field
	obj=document.getElementById("REFDCode")
	if (obj) obj.value = lu[1]
	obj=document.getElementById("REFDDesc")
	if (obj) obj.value = lu[0]
	//obj=document.getElementById("doctorCode");
	//if (obj) obj.value = lu[1];
	ReplaceHiddenCode(3,lu[1]);
	obj=document.getElementById("ReferralClinicAddress");
	if (obj) obj.value = lu[4];
	obj=document.getElementById("CLNProviderNo")
	if (obj) obj.value = lu[5]
 	obj=document.getElementById("PAADMRefDocClinicDR");
	if (obj) obj.value = lu[6];

}
//JW why can't deceased episodes have new admissions..
/*function CheckForNewDeceasedEpisode(){
	var obj1=document.getElementById("EpisodeID");
	var obj2=document.getElementById("isDeceased");
	if ((obj1.value=="")&&(obj2.value=="Y")) {
		alert("Deceased Patients cannot have new admissions");
	}
}*/

function PAADMAdmDateTimeHandler(e) {

	var eSrc=websys_getSrcElement(e);
	if (eSrc.id=="PAADMAdmDate") {PAADMAdmDate_changehandler(e);}
	if (eSrc.id=="PAADMAdmTime") {PAADMAdmTime_changehandler(e);}

	var objD=document.getElementById('PAADMAdmDate');
	var objT=document.getElementById('PAADMAdmTime');
	var objCT=document.getElementById('CTDate');
	var objCT2=document.getElementById('CodeTableValidationDate');
	if ((objD.defaultValue!=objD.value)||(objT.defaultValue!=objT.value)) {
		var objB=document.getElementById('BEDCode')
		//var objBedID=document.getElementById('BedID');
		/*MD LOG 56971
		if ((objB)&&(objB.value!="")) {
			objB.value="";
			ReplaceHiddenCode(22,"");
			var objBedType=document.getElementById("TRANSBedTypeDR");
			if (objBedType) objBedType.value="";
			alert(t['WardAndBedBlanked']);
		}
		*/
	}

	if ((objD)&&(objD.value!="")) {
		if (IsValidDate(objD)) {
			var objDh=DateStringTo$H(objD.value);
			if (AdmStatus!="D") {
				if (objCT) objCT.value=objDh;
				if (objCT2) objCT2.value=objDh;
			}
		}
	}
	if ((objD)&&(objD.value=="")) {
		if (objCT) objCT.value="";
		if (objCT2) objCT2.value="";
	}

	/* ab - removed this and added above, looks to be duplicate
	if ((objCT2)&&(objCT2.value!="")) {
		if ((objDh)&&(objDh.value!="")) {
			objCT2.value=objDh;
		}
	}
	*/

	// now done in websysBeforeSave.ValidateCodeTableDates
	//obj=document.getElementById('InsurPayor')
	//if (obj) obj.onchange();
	//obj=document.getElementById('InsurPlan');
	//if (obj) obj.onchange();
	//obj=document.getElementById('InsPayorRank2');
	//if (obj) obj.onchange();
	//obj=document.getElementById('InsPlanRank2');
	//if (obj) obj.onchange();

	setCrossValParams();

}

//7.5.2002 HP Log# 24906 Add look up for State Principal Prescribed Procedure description and populate code
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

function internalCPLookUp(str) {
	//dummy
}
function payorByLookUp(str) {
	// a dummy function to allow a custom payorByLookUp funtion to be used
}

function referralPeriodLookUp(str) {
	var lu = str.split("^");
	var obj=document.getElementById("REFPERDesc");
	if (obj) obj.value=lu[2];
}

// 24.07.02 Log#25938 HP
function PayorSelectChangeHandler() {
	// a dummy function to allow custom funtion to be used
}

function HospLookup(str) {
	var lu = str.split("^");
	var obj=document.getElementById("HospID");
	if (obj) obj.value=lu[1];

    ReplaceHiddenCode(13,lu[3]);
    /* ab 17.06.05 50882 - enable this for mandatory referral hospital flag
    if (lu[3]=="Y") {
        labelMandatory("CTRFCDesc");
    } else {
        labelNormal("CTRFCDesc");
    }
    */
}

function HospBlurHandler() {
	var objid=document.getElementById("HospID");
	var obj=document.getElementById("HOSPDesc");
	if ((obj)&&(objid)&&(obj.value=="")) objid.value="";
}

function WardBlurHandler() {
	var objid=document.getElementById("HiddenCodes");
	var obj=document.getElementById("WARDDesc");
	if ((obj)&&(objid)&&(obj.value=="")) ReplaceHiddenCode(1,"");
}

function LocBlurHandler() {
	var objid=document.getElementById("HiddenCodes");
	var obj=document.getElementById("CTLOCDesc");
	var objLocID=document.getElementById("LocID");
	if ((obj)&&(objid)&&(obj.value=="")) {
        ReplaceHiddenCode(0,"");
        if (objLocID) { objLocID.value=""; }
	}

}

function CPBlurHandler() {
	var objid=document.getElementById("HiddenCodes");
	var obj=document.getElementById("CTPCPDesc");
	if ((obj)&&(objid)&&(obj.value=="")) ReplaceHiddenCode(2,"");
}

// removed because checking will only be performed on update and not at field level
// disabling fields happens at field level

function ADSOLookup(str) {
	setCrossValParams();
	// only disable TRDDesc in austin custom script (done by crossval)
	//CrossValFieldLvl();
	return true;
}


function ATTENDDescLookup(str) {
	try {
		CustomATTENDDescLookup(str);
	} catch(e) { }
	finally {
		var lu = str.split("^");
		var obj=document.getElementById("ATTENDRefType")
		if (obj) obj.value = lu[3];
		ReplaceHiddenCode(23,lu[4]);

		//if (obj.value=="Y") {
		if (lu[4]=="Y") {
			labelMandatory("REFDDesc");
		} else {
			labelNormal("REFDDesc");
		}

		var obj=document.getElementById('HiddenCodes').value.split("^")[24];
		//var hosp=document.getElementById('HiddenCodes').value.split("^")[13];
		ReplaceHiddenCode(24,lu[5]);

        // ab 17.06.05 50882
		//if ((hosp=="Y")&&(lu[5]=="Y")) {
        if (lu[5]=="Y") {
			labelMandatory("CTRFCDesc");
		} else {
			labelNormal("CTRFCDesc");
		}
		return true;
	}
}




function IPATLookupSelect(str) {
	setCrossValParams();
	return true;
}

function QUALLookupSelect(str) {
	setCrossValParams();
	return true;
}

function CARETYPLookupSelect(str) {
	setCrossValParams();
	return true;
}

function RCCTDescLookupSelect(str) {
	setCrossValParams();
	return true;
}

function PFSLookupSelect(str) {
	var lu = str.split("^");
	var obj
	obj=document.getElementById('PFSDesc');
	if (obj) obj.value = lu[0];
	//obj=document.getElementById('PFSCode');
	//if (obj) obj.value = lu[2];

	PFSCodechangeHandler(null);
	setCrossValParams();
	return true;
}

function CONTRTYPELookupSelect(str) {
	setCrossValParams();
	return true;
}

function SubtypeLookupSelect(str) {
	setCrossValParams();
	return true;
}

function AdmReasonLookupSel(str){
	setCrossValParams();
	return true;
}

function FundLookupSelect(str){
	var lu = str.split("^");
	var obj
	obj=document.getElementById('FUNDARDesc');
	if (obj) obj.value = lu[0];
	//obj=document.getElementById('FUNDARCode');
	//if (obj) obj.value = lu[2];
	ReplaceHiddenCode(4,lu[2]);
	FUNDARCodechangeHandler(null);
	setCrossValParams();
	return true;
}

function CopyAdmissionClickHandler()	{
		if (AdmStatus=="D") {
		var disrangedate=document.getElementById('datetocopyfrom').value;
		var inrange=DateStringCompareToday(disrangedate)
		if (inrange=="-1") {
			alert(t['NOTCOPY']);
	 		return false;
			}
		var CONTEXT=session["CONTEXT"]
		websys_createWindow('paadm.copyfromdisch.csp?&EpisodeID='+EpisodeID+'&PatientID='+PatientID+'&CONTEXT='+CONTEXT+'&PatientBanner=1','CA2',"top=30,left=20,width=620,height=420,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes");
		return false;
		}
}

// -------------------------------------------- ab 1.08.02 Cross Validation stuff

function CrossVal(skip)
{
	 // runs the cross validation function through a hidden broker
  	var obj=document.getElementById("CrossVal");
	if ((obj)&&(obj.onchange)) {
		 //alert(obj.onchange);
		 obj.onchange();
				   }

	return true;
}

function CrossValFieldLvl() {
	var objCVFL=document.getElementById("CrossValFieldLvl");
	if (objCVFL) {
		//alert(objCVFL.value);
		objCVFL.value=1;
		CrossVal(0);
		objCVFL.value="";
	}

}
//TN:only called on load of page to check all frames are fully loaded before broker can be called otherwise
// will get "HTTP Request failed. Unable to process hyperevent" error
function CrossValFieldLvlInit() {
	var notready=0;
	for (var i=0; i<parent.frames.length; i++) {
		if (parent.frames[i].name=="TRAK_hidden") continue;
		if ((parent.frames[i]!=window)&&(parent.frames[i].document.readyState!='complete')) { notready=1; }
	}
	if (notready) { window.setTimeout(CrossValFieldLvlInit,200); }
	else { CrossValFieldLvl(); }
}

function setCrossValParams() {
  // ab 1.08.02 - sets the hidden ^ string for cross validation function
	var obj=document.getElementById("PAADMAdmDate");
	//alert(obj.tagName);
	//md 45637 additional check for tagName=="INPUT")
	//if ((obj)&&(!(IsValidDate(obj)))) return false
	if ((obj)&&(obj.tagName=="INPUT")&&(!(IsValidDate(obj)))) return false
  var obj=document.getElementById("CrossValExtraParams"),str="";
  if (obj) {

	var objParam=document.getElementById("PatientID");
	if (objParam) str=str+objParam.value;

	str=str+"^";

	var objParam=document.getElementById("ADSOUDesc");
	if (objParam) str=str+objParam.value;
	str=str+"^";
	var objParam=document.getElementById("IPATDesc");
	if (objParam) str=str+objParam.value;
	str=str+"^";
	var objParam=document.getElementById("READesc");
	if (objParam) str=str+objParam.value;
	str=str+"^";
	var objParam=document.getElementById("QUALDesc");
	if (objParam) str=str+objParam.value;
	str=str+"^";
	var objParam=document.getElementById("CARETYPDesc");
	if (objParam) str=str+objParam.value;
	str=str+"^^^^";
	var objParam=document.getElementById("PFSDesc");
	if (objParam) str=str+objParam.value;
	str=str+"^";
	var objParam=document.getElementById("FUNDARDesc");
	if (objParam) str=str+objParam.value;
	str=str+"^^";
	var objParam=document.getElementById("CONTRTYPEDesc");
	if (objParam) str=str+objParam.value;
	str=str+"^";
	var objParam=document.getElementById("SUBTDesc");
	if (objParam) str=str+objParam.value;
	str=str+"^^";
	var objParam=document.getElementById("PAADMAdmDate");
	if (objParam) str=str+objParam.value;
	//md 26/11/2003
	str=str+"^^^"
	var objParam=document.getElementById("InsurPayor");
	if (objParam) str=str+objParam.value;
	str=str+"^";
	var objParam=document.getElementById("RCCTDesc");
	if (objParam) str=str+objParam.value;

	obj.value=str;

  }
  return;
}

function setCrossValFields() {
	// set the onblur functions to set the hidden string

	var obj=document.getElementById('ADSOUDesc');
	if (obj) obj.onblur=setCrossValParams;
	var obj=document.getElementById('IPATDesc');
	if (obj) obj.onblur=setCrossValParams;
	var obj=document.getElementById('READesc');
	if (obj) obj.onblur=setCrossValParams;
	var obj=document.getElementById('QUALDesc');
	if (obj) obj.onblur=setCrossValParams;
	var obj=document.getElementById('CARETYPDesc');
	if (obj) obj.onblur=setCrossValParams;
	var obj=document.getElementById('PFSDesc');
	if (obj) obj.onblur=setCrossValParams;
	var obj=document.getElementById('FUNDARDesc');
	if (obj) obj.onblur=setCrossValParams;
	var obj=document.getElementById('SUBTDesc');
	if (obj) obj.onblur=setCrossValParams;
	var obj=document.getElementById('CONTRTYPEDesc');
	if (obj) obj.onblur=setCrossValParams;
	//md 26/11/2003
	var obj=document.getElementById('InsurPayor');
	if (obj) obj.onblur=setCrossValParams;
	var obj=document.getElementById('RCCTDesc');
	if (obj) obj.onblur=setCrossValParams;

	return;
}

//md 10/07/2003 moved js code from crossval method in web.PAAdm into js function + set onselect function for hidden broker

function ReturnFromCrossVal(str) {
	//alert("rfcval");
	var lu = str.split("^");
	var errmsg=lu[0];
	var errtype=lu[1];
 	var errfield=lu[2];
 	var disable=lu[3];
 	var statistical=lu[4];
 	var objCV=document.getElementById("CrossVal");
 	if (objCV) objCV.value="1";
 	var fieldlvl="";
 	var objCVFL=document.getElementById("CrossValFieldLvl");
 	if ((objCVFL)&&(objCVFL.value=="1")) fieldlvl=1;
    if (disable!="") {
 	var disfields=disable.split("&");
 	var i=0;
 	while (i!=disfields.length) {
 		if (disfields[i]!="") {
 			var dis=disfields[i].split(",");
 			var obj=document.getElementById(dis[0]);
 			var objfrom=document.getElementById(dis[2]);
 			if ((obj)&&(objfrom)&&(objfrom.value!="")) {
	 			if (dis[1]=="0") DisableFldObj(obj);
 				if (dis[1]=="1") {
	 				EnableFldObj(obj);
 					labelMandatory(dis[0]);
 					}
 			}
 		}
 	i=i+1;
 	}
 	}
	if ((errtype=="E")&&(fieldlvl!=1)) {
	var lu1 = errmsg.split("*");
	var m=0;
	var msgalert="";
	while(lu1[m]!="") {
	msgalert+=lu1[m];
	msgalert+="\n"
	m=m+1;
	}
 	if (msgalert!="") {alert(msgalert);}
	if (errfield!="") {
	 	var obj=document.getElementById(errfield);
 		if ((obj)&&(obj.tagName=="INPUT")&&(obj.className!='clsReadOnly')&&(obj.disabled!='true')){
		obj.value="";
 		websys_setfocus(errfield);
		}
 		if (objCV) objCV.value="2";
 	}
	return;
 	}
 	if ((errtype=="W")&&(fieldlvl!=1)) {
 	var clear=!confirm(errmsg);
 	if (errfield!="") {
 		var obj=document.getElementById(errfield);
 		if ((obj)&&(obj.tagName=="INPUT")&&(obj.className!='clsReadOnly')&&(obj.disabled!='true')){
 			if (clear==1) {
 			obj.value="";
 			if (objCV) objCV.value="2";
 			}
 			websys_setfocus(errfield);
 		}
 	}
 	return;
 	}
 	if (statistical=="1") {
 	var objCreateStat=document.getElementById("CreateStat");
 	if (objCreateStat) objCreateStat.value=1;
 	} else if (statistical!="1") {
 	var objCreateStat=document.getElementById("CreateStat");
 	if (objCreateStat) objCreateStat.value=0;
 	}

}


function CrossVal_changehandler(encmeth) {
	evtName='CrossVal';
	
 	//CrossVal_changehandlerX(encmeth);
}

//JW override scripts_gen so that focus is not set on load of page
function CrossVal_lookupsel(value) {
	try {
		var obj=document.getElementById('CrossVal');
		if (obj) {
  			obj.value=unescape(value);
			obj.className='';
		//websys_nextfocus(obj.sourceIndex);
		}
	} catch(e) {};
}


//-------------------------------------------- end cross validation


// ab 5.8.02 - following 2 functions here because need ones that arent overwritten by custom scripts
function DisableFldObj(fld) {
	if (fld) {
		fld.value = "";
		fld.disabled = true;
		fld.className = "disabledField";
		var lbl = document.getElementById('c'+fld.id);
		if (lbl) lbl.className="";
	}
}

function EnableFldObj(fld) {
	if (fld) {
		fld.disabled = false;
		fld.className = "";
		var lbl=document.getElementById('c'+fld.id);
		if (lbl) lbl.className="";
	}
}
//----





function LinkToWLLookupSelect(txt)
{
 	var lu = txt.split("^");

	obj=document.getElementById("LinktoWaitingList");
	if (obj) obj.value = lu[4];
	obj=document.getElementById("PAADMWaitListDR");
	var wl=lu[0];
	if (obj) obj.value = wl;
	obj=document.getElementById("WLId");
	if (obj) obj.value = "link";
}

//md Log 29441 Making Component Read Only

function makeReadOnly() 	{
	var el=document.forms["fPAAdm_Edit"].elements;
	for (var i=0;i<el.length;i++) {
		if (!(el[i].type=="hidden")) {
			el[i].disabled=true
		}
	}

	var arrLookUps=document.getElementsByTagName("IMG");
	for (var i=0; i<arrLookUps.length; i++) {
		if ((arrLookUps[i].id)&&(arrLookUps[i].id.charAt(0)=="l")) arrLookUps[i].disabled=true;
	}

	var obj=document.getElementById('update1');
	if (obj) obj.disabled=false;

	var obj=document.getElementById('Delete1');
	if (obj) obj.disabled=true;

	var obj=document.getElementById('waitinglistdetails');
	if (obj) obj.disabled=true;

	var obj=document.getElementById('PAADMRefLocation');
	if (obj) obj.disabled=true;

	var obj=document.getElementById('AddNewRefDoc');
	if (obj) obj.disabled=true;


	var obj=document.getElementById('ViewDoctorDetails');
	if (obj) obj.disabled=true;

	var obj=document.getElementById('ViewFamilyDrDetails');
	if (obj) obj.disabled=true;

	var obj=document.getElementById('DischargeEpisode');
	if (obj) obj.disabled=true;

	var obj=document.getElementById('InsurDet');
	if (obj) obj.disabled=true;

	var obj=document.getElementById('REFDocs');
	if (obj) obj.disabled=true;

	var obj=document.getElementById('BedBooking');
	if (obj) obj.disabled=true;

	var obj=document.getElementById('AuditTrailData');
	if (obj) obj.disabled=true;

	var obj=document.getElementById('AuditTrailLog');
	if (obj) obj.disabled=true;

	var obj=document.getElementById('ApptLetterLink');
	if (obj) obj.disabled=true

	var obj=document.getElementById('EpisodeContactLink');
	if (obj) obj.disabled=true;

	var obj=document.getElementById('Unavail');
	if (obj) obj.disabled=true;

	var obj=document.getElementById('PsychDetails');
	if (obj) obj.disabled=true;

	var obj=document.getElementById('ScanDocuments');
	if (obj) obj.disabled=true;

	var obj=document.getElementById('ViewableBy');
	if (obj) obj.disabled=true;

	var obj=document.getElementById('ReferralDetails');
	if (obj) obj.disabled=true;
}


function PFSCodechangeHandler(e) {
//dummy function
}

function FUNDARCodechangeHandler(e) {
//dummy function
}

function SameDayLookup(str) {
//dummy function
}
function BookingTypeLookup(str) {
//dummy function
}

function PAADMTransferLookupSelect(str) {
	try {
		Custom_PAADMTransferLookupSelect(str);
	} catch(e) {
		}	finally  {
	}


}
function setCheckBoxFlag() {
	var str=new Array();
	var IsOnForm=document.getElementById('HiddenCheckbox');
	var obj=document.getElementById('PAADMOwnMinisterIndicator');
	if (obj) { str[0]="Y" }
	var obj=document.getElementById('PAADMHospChaplainVisitReq');
	if (obj) { str[1]="Y" }
	var obj=document.getElementById('PAADMConfirmReferral');
	if (obj) { str[2]="Y" }
	var obj=document.getElementById('PAADMPatientContacted');
	if (obj) { str[3]="Y" }
	var obj=document.getElementById('PAADM2DischSumNotRequired');
	if (obj) { str[4]="Y" }
	var obj=document.getElementById('PAADM2OnHold');
	if (obj) { str[5]="Y" }
	var obj=document.getElementById('PAADM2EstimateDateInjury');
	if (obj) { str[6]="Y" }
	var obj=document.getElementById('PAADM2CriteriaTypeC');
	if (obj) { str[7]="Y" }
	var obj=document.getElementById('PAADM2EDIOverride');
	if (obj) { str[8]="Y" }
	var obj=document.getElementById('PAADMSpecialCategory');
	if (obj) { str[9]="Y" }

	IsOnForm.value=str.join("^");
	//alert(IsOnForm.value)

}

function RefStatChangeHandler(e) {
	// clear the ref stat fields on blank.
	var obj=document.getElementById("RSTDesc");
	var obj1=document.getElementById("REFSTREADesc");
	//var obj2=document.getElementById("REARowId");
	if ((obj)&&(obj1)&&(obj.value=="")) {
		obj1.value ="";
		labelNormal('REFSTREADesc');
		obj.defaultValue=obj.value;
	}
	if ((obj1)&&(obj1.value=="")) {ReplaceHiddenCode(19,"");}

}



function CheckMandatoryFields() {
	var msg="";

	var objRefClin=document.getElementById('CTRFCDesc');
	var objRefDoc=document.getElementById('REFDDesc')

	if ((objRefClin)&&(objRefClin.value==""))
	{
		if (CheckMandatory(objRefClin.id)) {

			msg += "\'" + t[objRefClin.id] + "\' " + t['XMISSING'] + "\n";
		}
	}
	if ((objRefDoc)&&(objRefDoc.value==""))
	{
		if (CheckMandatory(objRefDoc.id)) {

			msg += "\'" + t[objRefDoc.id] + "\' " + t['XMISSING'] + "\n";
		}
	}

	//

	if (msg != "") {
		alert(msg)
		return false;
	} else {
		return true;
	}
}

function PAAdm_LinkToWLHandler(lnk,win) {
	var wlid="";
	if ((AdmStatus=="P")||(AdmStatus=="C")) {
		alert(t['INV_WL_STAT']);
		return;
	}
	var visstat="PRE|I"
	if ((AdmStatus=="PRE")||(AdmStatus=="C")) visstat=visstat+"|D"
	var HiddenFindParam ="^^^^^^^^^^^^^^^^visstat^^^^^^^^^^^^^^^^^^"+EpisodeID+":0";
	if (lnk) lnk += '&PatientID='+PatientID+'&EpisodeID='+EpisodeID+'&HiddenFindParam='+HiddenFindParam;
	websys_createWindow(lnk,'Prompt','height=500,width=720,left=35,top=5,scrollbars=yes,resizable=yes');
}
function PAAdm_UnLinkWLHandler(lnk,win) {
	var wlid="";
	var visstat="PRE|D|ADM"
	var HiddenFindParam = "^^^^^^^^^^^^^^^^visstat^^^^^^^^^^^^^^^^^^"+EpisodeID+":1";
	if (lnk) lnk += '&PatientID='+PatientID+'&EpisodeID='+EpisodeID+'&HiddenFindParam='+HiddenFindParam;
	websys_createWindow(lnk,'Prompt','height=500,width=720,left=35,top=5,scrollbars=yes,resizable=yes');
}



function setSourceOfAttend() {
	var objATTEND=document.getElementById("ATTENDDesc");
	var obj=document.getElementById('HiddenCodes').value.split("^")[23];
	if (objATTEND) {
		if (obj == "Y")
			labelMandatory("REFDDesc");
		else
			labelNormal("REFDDesc");
	}
	var objh=document.getElementById('HiddenCodes').value.split("^")[24];
	//var hosp=document.getElementById('HiddenCodes').value.split("^")[13];
    if (objATTEND) {
        if (objh == "Y")
            labelMandatory("CTRFCDesc");
        else
            labelNormal("CTRFCDesc");
    }

	AttendanceChangeHandler();
}

function AttendanceChangeHandler() {
    if (typeof SOURCEATTEND_CHANGE == "function") SOURCEATTEND_CHANGE();

	var obj=document.getElementById("ATTENDDesc");
	if ((obj)&&(obj.value=="")) {
		labelNormal("REFDDesc")
		labelNormal("CTRFCDesc")
	}
}

//md function to check if field on the screen is mandatory
function CheckMandatory(fld) {
	var lbl = document.getElementById('c' + fld)
	if ((lbl)&&(lbl.className=="clsRequired")) return true;
	return false;

}


// cjb 32571 this is called from web.PAAdm.websysSave and is needed to keep the .Edit frame in paadm.edittree.csp after update (with a warning)
function StopFrameJump() {

	var frm=document.forms['fPAAdm_Edit']; frm.TOVERRIDE.value=1;

    	if ((parent)&&(parent.frames)&&(parent.frames['tree_list'])) {parent.UpdateTreeClose();}
	return;

}

function ADMCATSelect(str) {

	var lu = str.split("^");
	var obj=document.getElementById("ADMCATDesc");
	if (obj) obj.value=lu[0];
	ReplaceHiddenCode(25,lu[2]);
}

function UseDischargeOnAdmission() {

	var obj=document.getElementById('HiddenCodes').value.split("^")[8];
	var orgadmstr=document.getElementById("originaldischdetails");
	if (orgadmstr) {
		var orgadmlu = orgadmstr.value.split("^");
		var orgadmid=orgadmlu[0];
		var orgadmtype=orgadmlu[4];
		if ((AdmType=="I")&&(AdmStatus=="P")&&(obj=="Y")&&(orgadmid!=" ")&&(orgadmtype=="E")) {
			var obj=document.getElementById('PAADMAdmDate')
			if (obj) obj.disabled=true;
			DisableLookup("ld251iPAADMAdmDate");
			var obj=document.getElementById('PAADMAdmTime')
			if (obj) obj.disabled=true;
		}
	}

}

// cjb 13/10/2004 44950 - re-instated this function (used from insurance & unavailable screens)
function setBoldLinks(el,state) {
	obj=document.getElementById(el);
	if (obj) {
		if (state==1) obj.style.fontWeight="bold";
		else obj.style.fontWeight="normal";
	}
}

// cjb 09/11/2004 46893 - disable the Insurance fields
function DisableInsurance() {
	obj=document.getElementById('InsurPayor');
	if (obj) obj.disabled=true;
	DisableLookup("ld251iInsurPayor");
	obj=document.getElementById('InsurPlan');
	if (obj) obj.disabled=true;
	DisableLookup("ld251iInsurPlan");
	obj=document.getElementById('InsurDateValFr');
	if (obj) obj.disabled=true;
	obj=document.getElementById('InsurDateValFr');
	if (obj) obj.disabled=true;
	obj=document.getElementById('InsurOffice');
	if (obj) obj.disabled=true;
	DisableLookup("ld251iInsurOffice");
	obj=document.getElementById('INSSafetyNetCardNo');
	if (obj) obj.disabled=true;
	obj=document.getElementById('INSConcessionCardNo');
	if (obj) obj.disabled=true;
	obj=document.getElementById('INSConcessionCardExpDate');
	if (obj) obj.disabled=true;
	obj=document.getElementById('INSSafetyNetCardExpDate');
	if (obj) obj.disabled=true;
	obj=document.getElementById('DVAnumber');
	if (obj) obj.disabled=true;
	obj=document.getElementById('InsurCardType');
	if (obj) obj.disabled=true;
	DisableLookup("ld251iInsurCardType");
	obj=document.getElementById('InsurCardNo');
	if (obj) obj.disabled=true;
	// cjb 04/01/05 48654 - commenting out as it's a paadm field, not paadminsurance
	//obj=document.getElementById('FUNDARDesc');
	//if (obj) obj.disabled=true;
	//DisableLookup("ld251iFUNDARDesc");
	DisableInsuranceRank2();
}

function DisableInsuranceRank2() {
	obj=document.getElementById('InsPayorRank2');
	if (obj) obj.disabled=true;
	DisableLookup("ld251iInsPayorRank2");
	obj=document.getElementById('InsPlanRank2');
	if (obj) obj.disabled=true;
	DisableLookup("ld251iInsPlanRank2");
	obj=document.getElementById('InsurCardNoRank2');
	if (obj) obj.disabled=true;
}
//md 02/02/2005 - enable the Insurance fields
//function where will enable certain fields on update
function EnableForUpdate() {

	try {
		Custom_EnableForUpdate();
	} catch(e) { }
	finally {
	var fields= new Array("InsurPayor","InsurPlan","InsurDateValFr","InsurOffice","INSSafetyNetCardNo","INSConcessionCardNo",
	"INSConcessionCardExpDate","INSSafetyNetCardExpDate","DVAnumber","InsurCardType","InsurCardNo",
	"InsPayorRank2","InsPlanRank2","InsurCardNoRank2","TRD2Desc")
	for (var i=0;i<fields.length;i++) {
		obj=document.getElementById(fields[i]);
		if (obj) EnableField(fields[i]);
	}
	}
}

//md 02/02/2005

function LinksBeforeLoad() {
CheckForMentalHealth();
setLinks();
}
function FalseLink(evt) {
	var el = websys_getSrcElement(evt);
	//if (el.id=="ViewableBy") VIEWABLE=el;
	if (el.disabled) {
		return false;
	}
	return true;
}

//md Logs 53756-53773
function DefaultPAADMAdmDateInitial() {


	var objD=document.getElementById('PAADMAdmDate');
	var objCT=document.getElementById('CTDate');
	var objCT2=document.getElementById('CodeTableValidationDate');


	if ((objD)&&(objD.value!="")) {
		if (IsValidDate(objD)) {
			var objDh=DateStringTo$H(objD.value);
			if (AdmStatus!="D") {
				if (objCT) objCT.value=objDh;
				if (objCT2) objCT2.value=objDh;
			}
		}
	}

}

// cjb 26/08/2005 54051 - copied from PAAdm.EditEmergency.js
function ResponsibleForPaySelect(str) {
	//structrure as on 03/05/2004
	//NOKRowId,NOKChildSub,CTRLTDesc,NOKFirstContact,TTLDesc,NOKName,NOKName2,NOKName3,NOKStNameLine1,NOKTelH,NOKTelO,CTZIPCode,CTCITDesc,NGODesc,PROVDesc,Priority
        //0		1	2		3	  4	   5	   6		7	8	    9	    10		11	12	13	14	15
	//structure changed on 17/06/2004
	//ID,Child,CTRLTDesc,Title,Name,Name2,Name3
	//0, 1,		2,	3,  4,  5	6
	var lu = str.split("^");
	var obj=document.getElementById("paadm2panokdr")
	if (obj) obj.value = lu[0];
 	var obj=document.getElementById("RespForPaySelect")
	//if (obj) obj.value = lu[2];
	var fullrfp=""

	if (lu[4]!="") {fullrfp=lu[4];}
	if (lu[5]!="") {
		if (fullrfp!="") fullrfp=fullrfp+" "+lu[5];
		if (fullrfp=="") fullrfp=lu[5];
			}
	if (lu[6]!="") {
		if (fullrfp!="") fullrfp=fullrfp+" "+lu[6];
		if (fullrfp=="") fullrfp=lu[6];
			}
	if (obj) obj.value = fullrfp;
 }

// cjb 26/08/2005 54051 - copied from PAAdm.EditEmergency.js
function ResponsibleForPayBlur(e) {
	var obj=document.getElementById("RespForPaySelect")
	if ((obj)&&(obj.value=="")) {
	obj=document.getElementById("paadm2panokdr")
	if (obj) obj.value = "";
 	obj=document.getElementById("RespForPayList");
	if (obj) obj.value = "";
	}
}

function CheckInvalid() {

    var REFDDesc=document.getElementById("REFDDesc");
    if ((REFDDesc)&&(REFDDesc.className=="clsInvalid")) {
	    var doctorCode=document.getElementById("REFDCode");
	    if (doctorCode) doctorCode.value="";

    }

}

function CheckInvalidFields() {
	if (evtTimer) {
		setTimeout('CheckInvalidFields()',200)
	} else {
		for (var j=0; j<document.fPAAdm_Edit.elements.length; j++) {
			if (document.fPAAdm_Edit.elements[j].className=='clsInvalid') {
				websys_setfocus(document.fPAAdm_Edit.elements[j].name);
				if (((document.fPAAdm_Edit.elements[j].name)!="PIN" )&&((document.fPAAdm_Edit.elements[j].name)!="UserCode" ))
				{
				alert(t[document.fPAAdm_Edit.elements[j].name]+": "+  t['XINVALID'] + "\n");
				return false;
				}
			}
		}
		return true;
	}
}

function RelPin(evt) {

	var objPIN=websys_getSrcElement(evt)
	if ((objPIN)&&(objPIN.value!="")) objPIN.className=''

}


document.body.onload=Init;

/* ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;*/

//JW removed functions

/*JW//md function for ref clinic/doctor when some fields are cleared
function ATTENDDescHandler() {
	var obj=document.getElementById('ATTENDDesc');
	if ((obj)&&(obj.value==""))
	{
		var objAttendRef=document.getElementById("ATTENDMandatoryRefHospital")
		if (objAttendRef) {objAttendRef.value="";}
		setCTRFCDesc();
		var obj1=document.getElementById("ATTENDMandatoryRefDoctor");
		if (obj1) {obj1.value="";}
		var obj2=document.getElementById("REFDDesc");
		if (obj2) {labelNormal("REFDDesc");}
	}

}

function HOSPDescHandler() {
	var obj=document.getElementById('HOSPDesc');
	var objAttendRef=document.getElementById("HOSPMandatoryRefHospital")
	if ((obj)&&(obj.value=="")&&(objAttendRef)) { objAttendRef.value="";}
	setCTRFCDesc();

}
*/

/* function ATTENDDescLookup(str) {
 	var lu = str.split("^");
	var obj=document.getElementById("ATTENDRefType")
	if (obj) obj.value = lu[3];
	var obj=document.getElementById("ATTENDMandatoryRefDoctor")
	if (obj) {
		if(lu[4]=="Y") {
			//obj.value="on";
			obj.value="Y";
			labelMandatory("REFDDesc");
		}
		else {
			obj.value="";
			labelNormal("REFDDesc");
		}
	}
	var obj=document.getElementById("ATTENDMandatoryRefHospital")
	if (obj) {
		//alert(lu[5]);
		if(lu[5]=="Y") {

			//obj.value="on";
			obj.value="Y";
		}
		else {
			obj.value="";
		}
	}
	setCTRFCDesc();
	return true;
}

function setCTRFCDesc() {

	var objPAADMType=document.getElementById("PAADMType")

	var objHospRef=document.getElementById("HOSPMandatoryRefHospital")

	var objAttendRef=document.getElementById("ATTENDMandatoryRefHospital")

	var objAttendDesc=document.getElementById("ATTENDDesc")

	if (objPAADMType.value=="O") {

		if((objHospRef)&&(objAttendRef)&&(objAttendDesc)) {

			if ((objHospRef.value=="Y")&&(objAttendRef.value=="Y")) {
				labelMandatory("CTRFCDesc");
			} else {
				labelNormal("CTRFCDesc");
			}
		}
	}
}

	//JW var obj=document.getElementById('HOSPDesc')
	//if (obj) obj.onblur=HOSPDescHandler;
	//var obj=document.getElementById('ATTENDDesc')
	//if (obj) obj.onblur=ATTENDDescHandler;

function HospLookup(str) {
	//JW wrong field..
 	var lu = str.split("^");
	var obj=document.getElementById("HOSPMandatoryRefHospital")

	if (obj) obj.value=lu[3]
	setCTRFCDesc();
	return true;
}
*/

//JW moved to websys.Edit.Tools.js
/*
function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	//if (el.id=="ViewableBy") VIEWABLE=el;
	if (el.disabled) {
		return false;
	}
	return true;
}
function labelMandatory(fld) {
	var lbl = document.getElementById('c' + fld)
	if (lbl) {
		lbl.className = "clsRequired";
	}
}

function labelNormal(fld) {
	var lbl = document.getElementById('c' + fld)
	if (lbl) {
		lbl.className = "";
	}
}

function DisableField(fld) {
	var lbl = ('c'+fld);
	if (fld) {
		fld.value = "";
		fld.disabled = true;
		fld.className = "disabledField";
		if (lbl) lbl = lbl.className = "";
	}
}

function EnableField(fld) {
	var lbl = ('c'+fld);
	if (fld) {
		fld.disabled = false;
		fld.className = "";
		if (lbl) lbl = lbl.className = "";
	}
}

function DisableLookup(fldName)
{
	var obj=document.getElementById(fldName);
	if (obj) obj.disabled=true;
}

function EnableLookup(fldName)
{
	var obj=document.getElementById(fldName);
	if (obj) obj.disabled=false;
}
*/
//JW not used





