// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
var days=""
var StatePPPObj=document.getElementById("StatePPP");

function DocumentLoadHandler() {
	obj=document.getElementById('find1');
	if (obj) obj.onclick= FindClickHandler;
	if (tsc['find1']) websys_sckeys[tsc['find1']]=FindClickHandler;
	//setConsultantFilter()
	
	//AJI log 39524 - 14/10/03
//	if (StatePPPObj) StatePPPObj.onchange = StatePPPCustomChangeHandler;
}

// limit of 16 parameters can be passed to find query.
// create hidden field "objFindParam" to pass 16 + parameters
// It passes two flags and the Medical Record Type
function FindClickHandler(e) {
	document.focus();
	var GuarExcDesc=""
	var EpSubTypeDesc=""
	var AnaesMethDesc=""
	var IntWardDesc=""
	var ShowUnavail=""
	var UnavailReasonDesc=""
	var UnavailReasGrpDesc=""
	var ExceededGuarDate=""
	var DaysBeforeGuarDate=""
	var TCICancReasDesc=""
	var PreAssessOCDesc=""
	var TCIConf=""
	var TCIDateFrom=""
	var TCIDateTo=""
	var TCICancInitDesc=""
	var DaysWaiting=""
	var ReviewStatus=""
	var TCIStatus=""	
	var WLDateFrom=""
	var WLDateTo=""
	var StatePPP=""
	var MultipleWLStatus=""
	var WLNo=""
	var SuspDateFlag=""
	var expectdateadmfrom=""
	var expectdateadmto=""
	var MultipleReviewStatus=""
	var NationalPPP=""
	var StandbyStat=""
	var Service=""
	var NRReminder=""
	var NRContact=""
	var RefPriority=""
	var WksBeforeAppt=""
	var ConsultCateg=""
	var RecallFr=""
	var RecallTo=""

	//ElenaZ 10/04/2007 Log 60785 (8 new search fields to be added to PAWaitingListInquiry.List
	var WL_WaitingTimeStandard_DR=""
	var APTOF_Outcome_DR=""
	var NoOfDaysSinceAPTOF_Date=""
	var WL_SuitabilityOfPatient=""
	var WL_PatWillChangeClinician=""
	var WL_PatWillChangeNHSBoard=""
	var NoOfDaysNA_ReviewDate=""
	var WL_RemovedRemainOnList=""
	//end of Log 60785 additions

	// RQG 25.02.03 LOG30657
	var zone=""; var district=""; var postcode=""; var excludepcode="";
	var objzone=document.getElementById("Zone");
	var objdistrict=document.getElementById("District");
	var objpostcode=document.getElementById("PostCode");
	var objexcludepcode=document.getElementById("ExcludePostCode");
	if (objzone) zone=objzone.value;
	if (objdistrict) district=objdistrict.value;
	if (objpostcode) postcode=objpostcode.value;
	if ((objexcludepcode)&&(objexcludepcode.checked==true)) excludepcode="Y";
	//alert("zone="+zone+"  district="+district+"  postcode="+postcode+" excludepcode="+excludepcode); 

	// RQG 12.09.03 L37892
	var TheatreType=""; var AdmissionPoint=""; var SourceofReferral=""; var Accomodation=""; var ExpLengthOfStay=""; var AdmTransport=""; 
	var objTheatreType=document.getElementById("TheatreType");
	if (objTheatreType) TheatreType=objTheatreType.value;
	var objAdmissionPoint=document.getElementById("AdmissionPoint");
	if (objAdmissionPoint) AdmissionPoint=objAdmissionPoint.value;
	var objSourceOfReferral=document.getElementById("SourceOfReferral");
	if (objSourceOfReferral) SourceofReferral=objSourceOfReferral.value;
	var objAccomodation=document.getElementById("Accomodation");
	if (objAccomodation) Accomodation=objAccomodation.value;
	var objExpLengthOfStay=document.getElementById("ExpLengthOfStay");
	if (objExpLengthOfStay) ExpLengthOfStay=objExpLengthOfStay.value;
	var objAdmissionTransport=document.getElementById("AdmissionTransport");
	if (objAdmissionTransport) AdmTransport=objAdmissionTransport.value;

	var objGuarExcDesc=document.getElementById("GuarExcDesc")
	var objEpSubTypeDesc=document.getElementById("EpSubTypeDesc")
	var objAnaesMethDesc=document.getElementById("AnaesMethDesc")
	var objIntWardDesc=document.getElementById("IntWardDesc")
	//var objShowUnavail=document.getElementById("ShowUnavail")
	// removed from component for log 22402 GR
	var objUnavailReasonDesc=document.getElementById("UnavailReasonDesc")
	var objUnavailReasGrpDesc=document.getElementById("UnavailReasGrpDesc")
	var objExceededGuarDate=document.getElementById("ExceededGuarDate")
	var objDaysBeforeGuarDate=document.getElementById("DaysBeforeGuarDate")
	var objTCICancReasDesc=document.getElementById("TCICancReasDesc")
	var objPreAssessOCDesc=document.getElementById("PreAssessOCDesc")
	var objTCIConf=document.getElementById("TCIConf")
	var objTCIDateFrom=document.getElementById("TCIDateFrom")
	var objTCIDateTo=document.getElementById("TCIDateTo")
	var objTCICancInitDesc=document.getElementById("TCICancInitDesc")
	var objDaysWaiting=document.getElementById("DaysWaiting")
	var objReviewStatus=document.getElementById("ReviewStatus")
	var objTCIStatus=document.getElementById("HiddenTCIStatusCode")
	var objWLDateFrom=document.getElementById("DateFrom")
	var objWLDateTo=document.getElementById("DateTo")
	var objStatePPP=document.getElementById("StatePPP")
	var objWLNo=document.getElementById("WaitingListNo")
	//vars objSuspEndDate and objSuspNoEndDate set at form level
	var objexpectdateadmfrom=document.getElementById("ExpectedAdmissionFrom")
	var objexpectdateadmto=document.getElementById("ExpectedAdmissionTo")
	var objService=document.getElementById("Service")
	var objNRReminder=document.getElementById("NotRespondReminder")
	var objNRContact=document.getElementById("NotRespondContact")
	var objRefPriority=document.getElementById("RefPriority")
	var objWksBeforeAppt=document.getElementById("WksBeforeApptDate")

	//ElenaZ 10/04/2007 Log 60785 (8 new search fields to be added to PAWaitingListInquiry.List
	var objWL_WaitingTimeStandard_DR=document.getElementById("WaitTimeStd")
	var objAPTOF_Outcome_DR=document.getElementById("OutcomeOfOffer")
	var objNoOfDaysSinceAPTOF_Date=document.getElementById("DaysSinceOffer")
	var objWL_SuitabilityOfPatient=document.getElementById("SuitabilityPool")
	var objWL_PatWillChangeClinician=document.getElementById("PatientChangeConsult")
	var objWL_PatWillChangeNHSBoard=document.getElementById("PatientChangeNHS")
	var objNoOfDaysNA_ReviewDate=document.getElementById("DaysBeforeReviewDate")
	var objWL_RemovedRemainOnList=document.getElementById("CodeDenotingRemovedReinstate")
			
	if (objWL_WaitingTimeStandard_DR) WL_WaitingTimeStandard_DR=objWL_WaitingTimeStandard_DR.value
	if (objAPTOF_Outcome_DR) APTOF_Outcome_DR=objAPTOF_Outcome_DR.value
	if (objNoOfDaysSinceAPTOF_Date) NoOfDaysSinceAPTOF_Date=objNoOfDaysSinceAPTOF_Date.value
	if (objWL_SuitabilityOfPatient) WL_SuitabilityOfPatient=objWL_SuitabilityOfPatient.value
	if (objWL_PatWillChangeClinician) WL_PatWillChangeClinician=objWL_PatWillChangeClinician.value
	if (objWL_PatWillChangeNHSBoard) WL_PatWillChangeNHSBoard=objWL_PatWillChangeNHSBoard.value
	if (objNoOfDaysNA_ReviewDate) NoOfDaysNA_ReviewDate=objNoOfDaysNA_ReviewDate.value
	if (objWL_RemovedRemainOnList) WL_RemovedRemainOnList=objWL_RemovedRemainOnList.value
	if ((objWL_RemovedRemainOnList)&&(objWL_RemovedRemainOnList.checked==false)) WL_RemovedRemainOnList="Off";
		
	//end of Log 60785 additions
		

	
	if (objGuarExcDesc) GuarExcDesc=objGuarExcDesc.value
	if (objEpSubTypeDesc) EpSubTypeDesc=objEpSubTypeDesc.value
	if (objAnaesMethDesc) AnaesMethDesc=objAnaesMethDesc.value
	if (objIntWardDesc) IntWardDesc=objIntWardDesc.value
	//if (objShowUnavail) ShowUnavail=objShowUnavail.value
	if (objUnavailReasonDesc) UnavailReasonDesc=objUnavailReasonDesc.value
	if (objUnavailReasGrpDesc) UnavailReasGrpDesc=objUnavailReasGrpDesc.value
	if (objExceededGuarDate) ExceededGuarDate=objExceededGuarDate.value;
	if (objDaysBeforeGuarDate) DaysBeforeGuarDate=objDaysBeforeGuarDate.value;
	if (objTCICancReasDesc) TCICancReasDesc=objTCICancReasDesc.value
	if (objPreAssessOCDesc) PreAssessOCDesc=objPreAssessOCDesc.value
	if (objTCIConf) TCIConf=objTCIConf.value
	if (objTCIDateFrom) {
		IsValidDate(objTCIDateFrom);
		TCIDateFrom=objTCIDateFrom.value;
	}
	if (objTCIDateTo) {
		IsValidDate(objTCIDateTo);
		TCIDateTo=objTCIDateTo.value;
	}
	if (objTCICancInitDesc) TCICancInitDesc=objTCICancInitDesc.value
	if (objDaysWaiting) DaysWaiting=objDaysWaiting.value+":"+days
//alert(objDaysWaiting.value);
	if (objReviewStatus) ReviewStatus=objReviewStatus.value
	if (objTCIStatus) TCIStatus=objTCIStatus.value
	if (objWLDateFrom) {
		IsValidDate(objWLDateFrom);
		WLDateFrom=objWLDateFrom.value;
	}
	if (objWLDateTo) { 
		IsValidDate(objWLDateTo);
		WLDateTo=objWLDateTo.value;
	}
	if (objStatePPP) StatePPP=objStatePPP.value
	if (objWLNo) WLNo=objWLNo.value
	//can only have one flag for suspension.  log 25253 GR
	if (objSuspEndDate) {
		if (objSuspEndDate.checked==true) SuspDateFlag="END";
	}
	if (objSuspNoEndDate) {
		if ((SuspDateFlag=="")&&(objSuspNoEndDate.checked==true)) SuspDateFlag="NOEND";
	}
	if (objexpectdateadmfrom) {
		IsValidDate(objexpectdateadmfrom);
		expectdateadmfrom=objexpectdateadmfrom.value;
	}
	if (objexpectdateadmto) {
		IsValidDate(objexpectdateadmto);
		expectdateadmto=objexpectdateadmto.value;
	}
	MultipleReviewStatus=MultipleReviewStatusBuilder()
	//log 24858
	MultipleWLStatus=MultipleWLStatusBuilder();
	//KK 12/Mar/2003 Log 32885
	var objNPPP=document.getElementById("NationalPPP");
	if ((objNPPP)&&(objNPPP.value!="")){
		var objNPPPID=document.getElementById("NationalPPPID");
		if ((objNPPPID)&&(objNPPPID.value!="")) NationalPPP=objNPPPID.value;
	}
	var objStandbyStat=document.getElementById("StandbyStatus");
	if (objStandbyStat) StandbyStat=objStandbyStat.value;
	var EpisId=""
	if (objService) Service=objService.value
	//need to pass blank as this is used for unlinking waiting lists
	//NB: objFlag should always be there as it is a hidden field...
	if (objNRReminder) NRReminder=objNRReminder.value;
	if (objNRContact) NRContact=objNRContact.value;
	if (objRefPriority) RefPriority=objRefPriority.value;
	if (objWksBeforeAppt) {
		//if ((Service=="")&&(objWksBeforeAppt.value!="")) {
		if (objWksBeforeAppt.value!="") {
			if (Service!="") {
				message1=t['weeks_chosen'] + objWksBeforeAppt.value + t['weeks'];
				if (confirm(message1)) {
					WksBeforeAppt=objWksBeforeAppt.value;
					//WksBeforeAppt=WksBeforeAppt*7;
					//alert(WksBeforeAppt);
				} else {
					return;
				}
			} else {
				alert(t['NEED_SERVICE']);
				return;
			}
		}
	}
	var objConsultCateg=document.getElementById("WLConsultCateg");
	var objConsultCategID=document.getElementById("ConsultCatID");
	if ((objConsultCateg)&&(objConsultCategID)&&(objConsultCateg.value!="") ) { ConsultCateg=objConsultCategID.value ; }
	var objRecallFr=document.getElementById("RecallDateFrom");
	if (objRecallFr) RecallFr=objRecallFr.value;
	var objRecallTo=document.getElementById("RecallDateTo");
	if (objRecallTo) RecallTo=objRecallTo.value;
	var objFindParam=document.getElementById("HiddenFindParam");
	//if (objFindParam) objFindParam.value=GuarExcDesc+"^"+EpSubTypeDesc+"^"+AnaesMethDesc+"^"+IntWardDesc+"^"+"^"+UnavailReasonDesc+"^"+UnavailReasGrpDesc+"^"+ExceededGuarDate+"^"+DaysBeforeGuarDate+"^"+TCICancReasDesc+"^"+PreAssessOCDesc+"^"+TCIConf+"^"+TCIDateFrom+"^"+TCIDateTo+"^"+TCICancInitDesc+"^"+DaysWaiting+"^"+MultipleWLStatus+"^"+ReviewStatus+"^"+TCIStatus+"^"+WLDateFrom+"^"+WLDateTo+"^"+StatePPP+"^"+WLNo+"^"+SuspDateFlag+"^"+expectdateadmfrom+"^"+expectdateadmto+"^"+MultipleReviewStatus+"^"+order;
	//if (objFindParam) objFindParam.value=field1+"^"+    field2"^"+        field3+"^"+       field4+"^"+"^"+    field5 +"^"+          field6+"^"+            field7+"^"+          field8+"^"+            field9+"^"+         field10+"^"+        field11+"^"+field12+"^"+   field13+"^"+   field14+"^"+        field15+"^"+    field16+"^"+         field17+"^"+     field18+"^"+  field19+"^"+   field20+"^"+ field21+"^"+field22+"^"field23+"^"+    field24+"^"+          field25+"^"+        field26+"^"+             field27+"^"field28"^"field29+"^"+field30+"^"+field31+"^"      field32"^"      field33+"^"+    field34
	if (objFindParam) objFindParam.value=GuarExcDesc+"^"+EpSubTypeDesc+"^"+AnaesMethDesc+"^"+IntWardDesc+"^"+"^"+UnavailReasonDesc+"^"+UnavailReasGrpDesc+"^"+ExceededGuarDate+"^"+DaysBeforeGuarDate+"^"+TCICancReasDesc+"^"+PreAssessOCDesc+"^"+TCIConf+"^"+TCIDateFrom+"^"+TCIDateTo+"^"+TCICancInitDesc+"^"+DaysWaiting+"^"+MultipleWLStatus+"^"+ReviewStatus+"^"+TCIStatus+"^"+WLDateFrom+"^"+WLDateTo+"^"+StatePPP+"^"+WLNo+"^"+SuspDateFlag+"^"+expectdateadmfrom+"^"+expectdateadmto+"^"+MultipleReviewStatus+"^"+order+"^"+zone+"^"+district+"^"+postcode+"^"+excludepcode+"^"+NationalPPP+"^"+StandbyStat+"^"+EpisId+"^"+TheatreType+"^"+AdmissionPoint+"^"+SourceofReferral+"^"+Accomodation+"^"+ExpLengthOfStay+"^"+AdmTransport+"^"+Service+"^"+NRReminder+"^"+NRContact+"^"+RefPriority+"^"+WksBeforeAppt+"^"+ConsultCateg+"^"+RecallFr+"^"+RecallTo+"^"+NoOfDaysNA_ReviewDate+"^"+WL_WaitingTimeStandard_DR+"^"+APTOF_Outcome_DR+"^"+NoOfDaysSinceAPTOF_Date+"^"+WL_SuitabilityOfPatient+"^"+WL_PatWillChangeClinician+"^"+WL_PatWillChangeNHSBoard+"^"+WL_RemovedRemainOnList;
	//if (objFindParam) alert (objFindParam.value)

	//md orde as on 11/05/2006		1			2	     3			4	  5	6			7			8		 9		 	10			11		   12		  13	 14		15		   16			17	     	18			19	20		21		22	    23		24		25		 26			 27		        28	 29	   30		31		32	      33	  	34		35	 36			37		38		39		40			41		42		43	44		45		46			47	  48		49		50  				51			52			53			54				55				56			57
	//
	//ElenaZ 10/04/2007 Log 60785  THE LINE BELOW IS REPLACED WITH THE NEXT ONE
	//if (objFindParam) objFindParam.value=GuarExcDesc+"^"+EpSubTypeDesc+"^"+AnaesMethDesc+"^"+IntWardDesc+"^"+"^"+UnavailReasonDesc+"^"+UnavailReasGrpDesc+"^"+ExceededGuarDate+"^"+DaysBeforeGuarDate+"^"+TCICancReasDesc+"^"+PreAssessOCDesc+"^"+TCIConf+"^"+TCIDateFrom+"^"+TCIDateTo+"^"+TCICancInitDesc+"^"+DaysWaiting+"^"+MultipleWLStatus+"^"+ReviewStatus+"^"+TCIStatus+"^"+WLDateFrom+"^"+WLDateTo+"^"+StatePPP+"^"+WLNo+"^"+SuspDateFlag+"^"+expectdateadmfrom+"^"+expectdateadmto+"^"+MultipleReviewStatus+"^"+order+"^"+EpisId+"^"+Flds+"^"+NRReminder+"^"+NRContact+"^"+RefPriority+"^"+WksBeforeAppt;
	//if (objFindParam) objFindParam.value=GuarExcDesc+"^"+EpSubTypeDesc+"^"+AnaesMethDesc+"^"+IntWardDesc+"^"+"^"+UnavailReasonDesc+"^"+UnavailReasGrpDesc+"^"+ExceededGuarDate+"^"+DaysBeforeGuarDate+"^"+TCICancReasDesc+"^"+PreAssessOCDesc+"^"+TCIConf+"^"+TCIDateFrom+"^"+TCIDateTo+"^"+TCICancInitDesc+"^"+DaysWaiting+"^"+MultipleWLStatus+"^"+ReviewStatus+"^"+TCIStatus+"^"+WLDateFrom+"^"+WLDateTo+"^"+StatePPP+"^"+WLNo+"^"+SuspDateFlag+"^"+expectdateadmfrom+"^"+expectdateadmto+"^"+MultipleReviewStatus+"^"+order+"^"+EpisId+"^"+Flds+"^"+NRReminder+"^"+NRContact+"^"+RefPriority+"^"+WksBeforeAppt+"^"+WL_WaitingTimeStandard_DR+"^"+APTOF_Outcome_DR+"^"+NoOfDaysSinceAPTOF_Date+"^"+WL_SuitabilityOfPatient+"^"+WL_PatWillChangeClinician+"^"+WL_PatWillChangeNHSBoard+"^"+NoOfDaysNA_ReviewDate+"^"+WL_RemovedRemainOnList;
	//field 17 is blank to allow for PAWaitingList.Transfer.Find.js 
	//field 17 is now used to pass Multiple WaitingList Statuses KK 16/5/2002 Log 24858
	//alert(objFindParam.value)	
	//return false
	return find1_click();
}

function WListTypeLookUpHandler(str) {
 	var lu = str.split("^");
	var obj;
	// SA 10.12.01: Function to default Department and Doctor if one 
	// is associated with the Waiting List Type selected.
	if (lu[0]!="") {
		obj=document.getElementById("ListTypeDesc");
		if (obj) obj.value = lu[0];
	}
	if (lu[1]!="") {
		obj=document.getElementById("ListTypeCode");
		if (obj) obj.value = lu[1];
	}
	obj=document.getElementById("LocDesc");
	if (obj) obj.value = "";
	if (lu[2]!="") {
		if (obj) obj.value = lu[2];
	}
	obj=document.getElementById("CareProvDesc");
	if (obj) obj.value = "";
	if (lu[3]!="") {
		if (obj) obj.value = lu[3];
	}
	obj=document.getElementById("HospDesc");
	//if (obj) obj.value = "";
	if (lu[4]!="") {
		if (obj) obj.value = lu[4];
	}
}

function TCIStatusLookUpHandler(str) {
	var lu = str.split("^");

	if (lu.length>0) {
		var tciobj=document.getElementById("TCIStatus");
		if (tciobj) tciobj.value = lu[0];

		var scobj=document.getElementById("HiddenTCIStatusCode")
		if (scobj) scobj.value=lu[1];
	}
}

function HospitalLookUpHandler(str) {
	var lu = str.split("^");
	obj=document.getElementById("HospDesc");
	if ((obj)&&(lu[0]!="")) obj.value=lu[0];
	var obj=document.getElementById("HospID");
	if (obj) obj.value=lu[1];
/*
	//strange code, commented out for log 36226 10/6/03 GR
	var obj;
	var obj2;
	var obj3;
	obj2=document.getElementById("CareProvDesc");
	obj3=document.getElementById("LocDesc");
	if ((obj2)&&(obj3)) {
		if ((obj2.value!="")&&(obj3.value!="")) {
			if (lu[1]!="") {
				obj=document.getElementById("ListTypeDesc");
				if (obj) obj.value = lu[1];
			}
			obj=document.getElementById("LocDesc");
			if (obj) obj.value = "";
			if (lu[2]!="") {
				if (obj) obj.value = lu[2];
			}
			obj=document.getElementById("CareProvDesc");
			if (obj) obj.value = "";
			//if (lu[3]!="") {
			//	if (obj) obj.value = lu[3];
			//}
		
		}
	}
*/
	//if (obj) obj.value = "";
	//if (lu[0]!="") {
	//	if (obj) obj.value = lu[0];
	//}

}

function NAReasonLookupHandler(str) {
 	var lu = str.split("^");
	var obj;
	obj=document.getElementById("UnavailReasonDesc");
	if (obj) obj.value = lu[0];
	obj=document.getElementById("UnavailReasGrpDesc");
	if (obj) obj.value = lu[2];
}


function NAInitatorLookUpHandler(str) {

 	var lu = str.split("^");
	var obj;
	var obj;
	obj=document.getElementById("UnavailReasGrpDesc");
	if (obj) obj.value = lu[0];
	obj=document.getElementById("UnavailReasonDesc");
	if (obj) obj.value = "";
}

function TCICancReasonLookupHandler(str) {
 	var lu = str.split("^");
	var obj;
	obj=document.getElementById("TCICancReasDesc");
	if (obj) obj.value = lu[0];
	obj=document.getElementById("TCICancInitDesc");
	if (obj) obj.value = lu[2];
}

function TCICancInitLookUpHandler(str) {

 	var lu = str.split("^");
	var obj;
	obj=document.getElementById("TCICancInitDesc");
	if (obj) obj.value = lu[0];
	obj=document.getElementById("TCICancReasDesc");
	if (obj) obj.value = "";
}

//RQG,Log23447,03.04.02
function LocationLookUp(str) {
	var lu = str.split("^");
	var obj=document.getElementById('LOCDesc');
	if (obj) obj.value = lu[1];
	//var obj=document.getElementById('DEPDesc');
	//if (obj) obj.value = lu[2];
}

// ab 24.06.04 - 44754
function CareProvLookup(str) {
	var lu = str.split("^");
	var obj=document.getElementById('LOCDesc');
	if (obj) obj.value = lu[2];
}

//GR 8/4/02 log 24078
function setConsultantFilter() {
	var conobj=document.getElementById('conFlag'); 
	if (conobj) conobj.value="Y";
	//alert(conobj.value);
}

//KK 16/5/02 Log 24858
function MultipleWLStatusBuilder() {
	var objMultipleWLStatus=document.getElementById("MultipleWLStatuses")
	var WLStatuses="";
	if (objMultipleWLStatus) {
		for (var i=(objMultipleWLStatus.length-1); i>=0; i--) {
			if (objMultipleWLStatus.options[i].selected) {
				WLStatuses=WLStatuses+objMultipleWLStatus.options[i].value+"|";
			}
		}
	}
	WLStatuses=WLStatuses.substring(0,(WLStatuses.length-1));
	//alert(WLStatuses);
	return WLStatuses;
}
// log 25253 GR
function EndDateClickHandler() {
	if ((objSuspEndDate)&&(objSuspNoEndDate)) {
		if (objSuspEndDate.checked==true) {
			objSuspNoEndDate.checked=false;
		}
	}		
	//SuspendWithEndDate_click()
}
// log 25253 GR
function NoEndDateClickHandler() {
	if ((objSuspEndDate)&&(objSuspNoEndDate)) {
		if (objSuspNoEndDate.checked==true) {
			objSuspEndDate.checked=false;
		}
	}		
	//SuspendNoEndDate_click()
}

function MultipleReviewStatusBuilder() {
	var objMultipleReviewStatus=document.getElementById("MultipleReviewStatus")
	var ReviewStatuses="";
	if (objMultipleReviewStatus) {
		for (var i=(objMultipleReviewStatus.length-1); i>=0; i--) {
			if (objMultipleReviewStatus.options[i].selected) {
				ReviewStatuses=ReviewStatuses+objMultipleReviewStatus.options[i].value+"|";
			}
		}
	}
	ReviewStatuses=ReviewStatuses.substring(0,(ReviewStatuses.length-1));
	//alert(ReviewStatuses);
	return ReviewStatuses;
}
function SortHandler() {
	//dummy function
}
function StatusLookUp(str) {
	var lu = str.split("^");
	var obj=document.getElementById('StatusDesc');
	if (obj) obj.value = lu[1];

}

function StatePPPLookUpSelect(str) {
	//alert("AJI " + str);
	var lu = str.split("^");
	var obj=document.getElementById("StatePPP");
	if ((obj)&&(lu[0])) obj.value=lu[0];
	var obj=document.getElementById("NationalPPP");
	if ((obj)&&(lu[5])) {
		obj.value=lu[5];
		obj.innerText=lu[5];  // Aji log 39524 - Set innerText so displayOnly option will still work
	}
	
	var obj=document.getElementById("NationalPPPID");
	if ((obj)&&(lu[4])) obj.value=lu[4];
}

// Aji log 39524 - override the one in script_gen
function StatePPP_changehandler(encmeth) {
	var obj=document.getElementById('StatePPP');
	
	//needs to clear out respective fields if SPPP is empty.
	if (obj.value=="") {
		var natobj=document.getElementById("NationalPPPID");
		if (natobj) natobj.value="";
		natobj=document.getElementById("NationalPPP");
		if (natobj) {
			natobj.value="";
			natobj.innerText="";
		}
	}

	if (obj.value!='') {
		var tmp=document.getElementById('StatePPP');
		if (tmp) {var p1=tmp.value } else {var p1=''};
		var tmp=document.getElementById('LocDesc');
		if (tmp) {var p2=tmp.value } else {var p2=''};
		if (cspRunServerMethod(encmeth,'StatePPP_lookupsel','StatePPPLookUpSelect',p1,p2)=='0') {
			obj.className='clsInvalid';
			websys_setfocus('StatePPP');
			return websys_cancel();
		}
	}
	obj.className='';
}

function SERDescLookUpSelect(str) {
	var lu = str.split("^");
	//alert(str);
	var obj=document.getElementById('Service');
	if (obj) obj.value=lu[1];
	var obj=document.getElementById('ServiceID');
	if (obj) obj.value=lu[2];
	
}

function ConsCatSelect(str) {

	var lu = str.split("^");
	//alert(str);
	var obj=document.getElementById('WLConsultCateg');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('ConsultCatID');
	if (obj) obj.value=lu[1];


}


document.body.onload = DocumentLoadHandler;

// log 25253 GR
var objSuspEndDate=document.getElementById("SuspendWithEndDate");
if (objSuspEndDate) objSuspEndDate.onclick=EndDateClickHandler
var objSuspNoEndDate=document.getElementById("SuspendNoEndDate");
if (objSuspNoEndDate) objSuspNoEndDate.onclick=NoEndDateClickHandler
var order="Days:D";
//LOG 26467.GR 23/8/02  MCKesson want to sort all entries in chronological order.  
//Austin want the reverse.  need this param to allow sorting for MCKesson
//which is overwritten in their custom javascript.