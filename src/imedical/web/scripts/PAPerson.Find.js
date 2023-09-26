// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var EXCESSIVEYEAR=1880;
var EXCESSIVEAGE=121;
var systemconfigs=document.getElementById("PATCF")
var aryPATCF=systemconfigs.value.split("^")
var objAgeSearch=aryPATCF[0]
var ADMDATA= new Array();	// used to collect the id's for the 'admission' fields to set in hiddenstring

function DocumentLoadHandler() {
	//JW:removed - this will not work with sticky search
	//setCheckBox()
	setHiddenFields();
	setListboxes();
	
	//var obj=document.getElementById('HospMRType')
	//var objMR=document.getElementById('MRType')
	//if ((obj)&&(objMR)) objMR.value=obj.value

	var tempDOB=document.getElementById('DateOfBirth');
	if (tempDOB) tempDOB.onchange = FindDOB;

	var obj=document.getElementById('Age')
	if (obj) obj.onchange = FindDOBAge;
	
	var obj=document.getElementById('AgeSearchType');
	if (obj) obj.onblur=BlurHandlerAgeSearchType;

	var obj=document.getElementById("RegistrationNo");
	if (obj) obj.onkeydown=RegistrationEnter;
	
	//var obj=document.getElementById("AdmissionType");
	//if (obj) obj.onblur=BlurHandlerAdmissionType;
	
	var obj=document.getElementById("VisitStatus");
	if (obj) obj.onblur=BlurHandlerVisitStatus;
	
	// cjb 03/03/2005 47477 - changed from onblur to onchange
	var obj=document.getElementById("AdmDateFrom");
	if (obj) obj.onchange=ChangeHandlerAdmDateFrom;
	
	var obj=document.getElementById("AdmDateTo");
	if (obj) obj.onchange=ChangeHandlerAdmDateTo;

	var obj=document.getElementById("AdmDateFrom2");
	if (obj) obj.onchange=ChangeHandlerAdmDateFrom2;

	var obj=document.getElementById("AdmDateTo2");
	if (obj) obj.onchange=ChangeHandlerAdmDateTo2;

	var obj=document.getElementById("AdmDoc");
	if (obj) obj.onblur=BlurHandlerAdmDoc;

	var obj=document.getElementById("AdmLoc");
	if (obj) obj.onblur=BlurHandlerAdmLoc;

	var obj=document.getElementById("AdmRespUnit");
	if (obj) obj.onblur=BlurHandlerAdmRespUnit;

	var obj=document.getElementById("AdmWard");
	if (obj) obj.onblur=BlurHandlerAdmWard;
	
	//var obj=document.getElementById("Hospital");
	//if (obj) obj.onchange=SetSelectedHospital;
	var obj=document.getElementById("HospRemove");
	if (obj) obj.onclick=HospRemove;
   
	var obj=document.getElementById("AdmHospitalRemove");
	if (obj) obj.onclick=AdmHospRemove;
	
	SetSelectedHospital();

	var obj=document.getElementById("AdmissionType");
	if (obj) obj.onchange=SetAdmissionType;
	SetAdmissionType();
	
	var obj=document.getElementById("ExpAdmDateFrom");
	if (obj) obj.onchange=ChangeHandlerExpAdmDateFrom;
	
	var obj=document.getElementById("ExpAdmDateTo");
	if (obj) obj.onchange=ChangeHandlerExpAdmDateTo;
	
	var obj=document.getElementById("BookingType");
	if (obj) obj.onchange=SetBookingType;
	SetBookingType();
	
	var obj=document.getElementById("AdmissionPoint");
	if (obj) obj.onblur=BlurHandlerAdmissionPoint;
	
	var obj=document.getElementById("SignificantFacility");
	if (obj) obj.onblur=BlurHandlerSignificantFacility;
	
	// cjb 03/01/2006 50115
	var obj=document.getElementById("CTZIPCode");
	if (obj) obj.onblur=BlurHandlerCTZIPCode;
	
	var obj=document.getElementById("CTCITDesc");
	if (obj) obj.onblur=BlurHandlerCTCITDesc;
	
	// cjb 04/01/2005 56833
	var obj=document.getElementById("CTOCCDesc");
	if (obj) obj.onblur=BlurHandlerCTOCCDesc;
	
	var obj=document.getElementById('PAPERName');
	if (obj) obj.onblur=BlurHandlerPAPERName;
	
	BlurHandlerPAPERName();
	
	obj=document.getElementById('find1');
	if (obj) obj.onclick= FindClickHandler;
	if (tsc['find1']) websys_sckeys[tsc['find1']]=FindShortcutKeyHandler;

}

// ab 2.12.03 41048
function HospLookupSelect(str) {
	lu=str.split("^");
	var obj=document.getElementById("HospLookup");
	if (obj) obj.value="";
	var obj=document.getElementById("Hospital");
	if (obj) {
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value==lu[0]) return false;
		}
		AddItemToList(obj,lu[1],lu[0]);
		SetSelectedHospital();
	}
}

// ab 46341
function AdmHospLookupSelect(str) {
	lu=str.split("^");

	var obj=document.getElementById("AdmHospital");
	if (obj) obj.value="";
	var obj=document.getElementById("AdmHospitalList");
	if (obj) {
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value==lu[0]) return false;
		}
		AddItemToList(obj,lu[0],lu[1]);
		SetSelectedHospital();
	}
}

function HospRemove() {
	var obj=document.getElementById("Hospital");
	if (obj) RemoveFromList(obj);
	SetSelectedHospital();
	return false;
}

function AdmHospRemove() {
	var obj=document.getElementById("AdmHospitalList");
	if (obj) RemoveFromList(obj);
	SetSelectedHospital();
	return false;
}

function SetSelectedHospital() {
	var arrItems = new Array();
	var hospitals="";
	var lst = document.getElementById("Hospital");
	
	var numberchosen=0
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			// ab 2.12.03 41048 different style listbox, all options must be passed through
			//if (lst.options[j].selected) {
			if (lst.options[j].value!="") {
				numberchosen++;
				hospitals = hospitals + lst.options[j].value + "|"
			}
		}
		//if none is chosen, all are returned
		// ab 4.06.03 - send 'SelHospital' as blank if none chosen
		//if (numberchosen == 0) {
		//	for (var j=0; j<lst.options.length; j++) {
		//		hospitals=hospitals+lst.options[j].value+"|";
		//	}
		//}
		hospitals=hospitals.substring(0,(hospitals.length-1));
		var objSelHosp = document.getElementById("SelHospital");
		if (objSelHosp) objSelHosp.value=hospitals;
		//if search on urn, ignore hospital restriction and search enterprise log 47415
		var obj=document.getElementById("RegistrationNo")
		if ((obj)&&(obj.value!="")&&(objSelHosp)) objSelHosp.value=""
	}
    
	// ab 46341
	hospitals="";
	var lst = document.getElementById("AdmHospitalList");
	var numberchosen=0
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			if (lst.options[j].value!="") {
				numberchosen++;
				hospitals = hospitals + lst.options[j].value + "|"
			}
		}
		hospitals=hospitals.substring(0,(hospitals.length-1));
		var objSelHosp = document.getElementById("SelAdmHospital");
		if (objSelHosp) objSelHosp.value=hospitals;
	}
}

function SetAdmissionType() {
	var arrItems = new Array();
	var types="";
	var lst = document.getElementById("AdmissionType");
	var objappts=document.getElementById("CurrAppts");
	var numberchosen=0
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			if (lst.options[j].selected) {
				numberchosen++;
				types = types + lst.options[j].value + "|"
				//JW: moved back to custom qh script, so all outpatient episodes returned in standard search.
				//if ((objappts)&&(lst.options[j].value=="O")) {
					//objappts.value=1;
				//} else {
                    //objappts.value="";
                //}
			}
		}
		types=types.substring(0,(types.length-1));
		var obj=document.getElementById("SelAdmissionType");
		if (obj) obj.value=types;
	}
}

function SetBookingType() {
	var arrItems = new Array();
	var types="";
	var lst = document.getElementById("BookingType");
	var numberchosen=0
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			if (lst.options[j].selected) {
				numberchosen++;
				types = types + lst.options[j].value + "|"
			}
		}
		types=types.substring(0,(types.length-1));
		var obj=document.getElementById("SelBookingType");
		if (obj) obj.value=types;
	}
}



// Age and Date of Birth


function FindDOB(updateflag) {
  var msg=""
	if (!updateflag) DateOfBirth_changehandler();
	// updateflag to discriminate between tabbing and alt-f
	var age=document.getElementById('Age');
	var obj=document.getElementById('DateOfBirth');
	var objDOB=document.getElementById('PAPERDob');
	
	if ((age)&&(obj)&&(age.value!="")&&(obj.value!="")) {
		obj.value=CalculateDOBYR(obj);
		return true;		// cjb 12/11/2003 - 40662.  changed from 'return' to 'return true'
	}
	if ((objDOB)&&(obj)) objDOB.value=obj.value;

	// ab 6.03.03 - check for dob > today
	if ((obj)&&(obj.value!="")) {
		//var msg=ExcessiveDOB(obj.value);
		if (DateStringCompareToday(obj.value)==1) msg = t['DateOfBirth'] + t["FutureDOB"];
		if (msg!="") {
			alert(msg);
			obj.value="";
			websys_setfocus("DateOfBirth");
			return false;
		}
	}
	return true;
}

function FindDOBAge() {
	var age=document.getElementById('Age');
	var obj=document.getElementById('DateOfBirth');
	var objDOB=document.getElementById('PAPERDob');

	validateAge()

	if ((age)&&(obj)&&(age.value!="")&&(obj.value!="")) {
		obj.value=CalculateDOBYR(obj);
		return;
	}
	if (obj.value!="") {
		objDOB.value=obj.value;
	}

}

//very ugly quick conversion to send date string to PAPERSON.find
//i'll make it better later
// (no you won't;)

function CalculateDOBYR() {
	var temp
	var aryPATCF=systemconfigs.value.split("^")
	var objAgeSearch=aryPATCF[0]
	//var dtseparator="/"
 	var strDOB = "";
	var today= new Date()
	var yr=today.getYear()
	var iSpan = 2;
 	var DOBStr="";

	var obj=document.getElementById('DateOfBirth')
	var objDOB=document.getElementById('PAPERDob')
	var age=document.getElementById('Age')

	var objAgeSearch=aryPATCF[0]
	if (objAgeSearch) iSpan=objAgeSearch
	iSpan=parseInt(iSpan,10)

	if (age) yrage=age.value
	if (obj) strDate=obj.value

	//md to add functionality for DateFormat "DMMMY"
	var CD_dtsepartor="/"; try {CD_dtsepartor=dtseparator} catch(err) {};
	var CD_dtformat="DMY"; try {CD_dtformat=dtformat} catch(err) {};
	if (CD_dtformat=="DMMMY") CD_dtsepartor=" ";
	var arrDate = strDate.split(CD_dtsepartor);

		
	var day=""
	var mth=""
	// cjb 12/11/2003 40662.  get the day/mth depending on the date format
	switch (CD_dtformat) {
		case "YMD":
   			day=arrDate[2]
   			mth=arrDate[1]
			break;
  		case "MDY":
   			day=arrDate[1]
   			mth=arrDate[0]
   			break;
		default:
   			day=arrDate[0]
   			mth=arrDate[1]
   			break;
 	}

	
	
	
	if ((day!="")&&(mth!="")) {
		var yr = today.getYear();
		if (yr < 1900) yr +=1900;
 		yr -= yrage;
		switch (dtformat) {
			case "YMD":
				temp = "" + yr + CD_dtsepartor + (mth) + CD_dtsepartor + day;
				break;
  			case "MDY":
   				temp = "" + (mth) + CD_dtsepartor + yr + CD_dtsepartor + day;
   				break;
			case "DMMMY":
   				temp = "" + day + CD_dtsepartor + (mth) + CD_dtsepartor + yr;
   				break;
			default:
   				temp = "" + day + CD_dtsepartor + (mth) + CD_dtsepartor + yr;
   				break;
 		}
		//alert(temp);
		DOBStr = temp;
		for (x=-1*iSpan;x<=iSpan;x=x+1) {
			if (x!=0) {
				switch (dtformat) {
  				case "YMD":
    					DOBStr = DOBStr + "^" + yr+x + CD_dtsepartor + (mth) + CD_dtsepartor + day;
   					break;
		  		case "MDY":
   					DOBStr = DOBStr + "^" + (mth) + CD_dtsepartor + (yr+x) + CD_dtsepartor + day;
   					break;
				case "DMMMY":
   					DOBStr = DOBStr + "^" + day + CD_dtsepartor + (mth) + CD_dtsepartor + (yr+x);
   					break;	
  				default:
 		   			DOBStr = DOBStr + "^" + day + CD_dtsepartor + (mth) + CD_dtsepartor + (yr+x);
   					break;
				}
		 	}
		}
		
		if (objDOB) objDOB.value=DOBStr;
		//alert(objDOB.value)
 		return temp;
	}
}

/*function ExcessiveDOB(strDate) {
 	var arrDate = DateStringToArray(strDate);
	var msg="";
	var dtEntered = new Date(arrDate["yr"], arrDate["mn"]-1, arrDate["dy"]);
 	var dtNow = new Date();
	//SB 08/07/02 (25850): Need to add 543 yrs if THAI date.
	if (dtformat=="THAI") dtNow.setYear(dtNow.getFullYear()+543);
 	if (dtEntered > dtNow) {
		msg += t['DateOfBirth'] + t["FutureDOB"];
	}
	return msg;
} */



// ab 17.04.02 - to fix weird way the DOB is treated differently between click/key
function FindShortcutKeyHandler(e)
{
	var objDOB=document.getElementById('DateOfBirth');
	
	BlurHandlerVisitStatus();
	BlurHandlerAdmDateFrom();
	BlurHandlerAdmDateTo();
	BlurHandlerAdmDateFrom2();
	BlurHandlerAdmDateTo2();
	BlurHandlerAdmDoc();
	BlurHandlerAdmLoc();
	BlurHandlerAdmRespUnit();
	BlurHandlerAdmWard();
	BlurHandlerExpAdmDateFrom();
	BlurHandlerExpAdmDateTo();
	BlurHandlerAdmissionPoint();
	BlurHandlerSignificantFacility();
	BlurHandlerCTZIPCode();
	BlurHandlerCTCITDesc();
	BlurHandlerCTOCCDesc();
	
	FindClickHandler();
}

// limit of 16 parameters can be passed to find query.
// create hidden field to pass 16 + parameters
// It passes two flags and the Medical Record Type
function FindClickHandler() {
	
	SetSelectedHospital();
	SetAdmissionType();
	SetBookingType();
	
	if (!MinimumSearch()) return false;		// cjb 16/02/2007 61903
	
	//wait for broker to finish
	if (evtTimer) {
		setTimeout('FindClickHandler();',200)
	} else {
		var objFlag=document.getElementById('hiddenFlag');
		var aryPATCF=systemconfigs.value.split("^");	
		var reg=cur=MRType=age=exact=dva=secgrp=allnames=mrn=name4=soundex=mobile=SafetyCard=EmployeeNo=PassportNumber="";
		var objDVA=document.getElementById('DVANumber');
		var objReg=document.getElementById('regoflag');
		var objage=document.getElementById('Age');
		var objCur=document.getElementById('current');
		var objMRType=document.getElementById('MRType');
		var objEx=document.getElementById('exact');
		var objSecGrp=document.getElementById('secgrp');
		var objAll=document.getElementById('allnames');
		var objSelHosp=document.getElementById("SelHospital");
		var objName4=document.getElementById("PAPERName4");
		var objMob=document.getElementById("PAPERMobPhone");
		var objSoundex=document.getElementById('soundex');
		var objExMRN=aryPATCF[1];
 		var objSearch=aryPATCF[6];
		var objSafetyCard=document.getElementById("SafetyCardNo");
		var objEmployeeNo=document.getElementById("PAPEREmployeeNo");
		var objPassportNumber=document.getElementById("PAPERPassportNumber");
		
		if ((objReg)&&(objReg.checked==true)) reg="On";
		if ((objCur)&&(objCur.checked==true)) cur="On";
		if ((objEx)&&(objEx.checked==true)) exact="On";
		if ((objAll)&&(objAll.checked==true)) allnames="On";
		if ((objSoundex)&&(objSoundex.checked==true)) soundex="On";
		if (objExMRN=="Y") mrn="On";
		if (objMRType) MRType=objMRType.value;
		if (objage) age=objage.value;
		var objagetype=document.getElementById("AgeSearchTypeID");
		if ((objagetype)&&(age!="")) {
			if ((objagetype.value=="M")||(objagetype.value=="D")) age=age+"|"+objagetype.value;
		}
		if (objDVA) dva=objDVA.value;
		if (objName4) name4=objName4.value;
		if (objMob) mobile=objMob.value;
		if (objSecGrp) secgrp=objSecGrp.value;
		if (objSelHosp) hospitals=objSelHosp.value;
		if (objSafetyCard) SafetyCard=objSafetyCard.value;
		if (objEmployeeNo) EmployeeNo=objEmployeeNo.value;
		if (objPassportNumber) PassportNumber=objPassportNumber.value;
		
		//NB: objFlag should always be there as it is a hidden field...
		if (objFlag) {
			objFlag.value=cur+"^"+reg+"^"+MRType+"^"+age+"^"+exact+"^"+dva+"^"+secgrp+"^"+allnames+"^"+mrn+"^"+hospitals;
			var obj=document.getElementById("SelAdmissionType");
			var admToDate
			if (obj) objFlag.value=objFlag.value+"^"+obj.value;
			//if (ADMDATA["AdmissionType"]) objFlag.value=objFlag.value+"^"+ADMDATA["AdmissionType"]
			//else objFlag.value=objFlag.value+"^";
			if (ADMDATA["VisitStatus"]) objFlag.value=objFlag.value+"^"+ADMDATA["VisitStatus"]
			else objFlag.value=objFlag.value+"^";
			if (ADMDATA["AdmDateFrom"]) objFlag.value=objFlag.value+"^"+ADMDATA["AdmDateFrom"]
			else objFlag.value=objFlag.value+"^";
			//if (ADMDATA["AdmDateTo"]) objFlag.value=objFlag.value+"^"+ADMDATA["AdmDateTo"]
			//else objFlag.value=objFlag.value+"^";
			if (ADMDATA["AdmDateTo"]) admToDate=ADMDATA["AdmDateTo"]
			
			if ((ADMDATA["AdmDateFrom"])&&(objSearch!="")) {
				if (ADMDATA["AdmDateTo"]) {
					var dtrange=DateStringDifference(ADMDATA["AdmDateFrom"],ADMDATA["AdmDateTo"])
					if (dtrange["dy"]>objSearch) {
						admToDate=AddToDateStrGetDateStr(ADMDATA["AdmDateFrom"],"D",objSearch)
					}
				}
				if (!(ADMDATA["AdmDateTo"])) {
					admToDate=AddToDateStrGetDateStr(ADMDATA["AdmDateFrom"],"D",objSearch)
				}
				
			}
			if (admToDate) objFlag.value=objFlag.value+"^"+admToDate
			else objFlag.value=objFlag.value+"^";
			if (ADMDATA["AdmDoc"]) objFlag.value=objFlag.value+"^"+ADMDATA["AdmDoc"]
			else objFlag.value=objFlag.value+"^";
			if (ADMDATA["AdmLoc"]) objFlag.value=objFlag.value+"^"+ADMDATA["AdmLoc"]
			else objFlag.value=objFlag.value+"^";
			if (ADMDATA["AdmRespUnit"]) objFlag.value=objFlag.value+"^"+ADMDATA["AdmRespUnit"]
			else objFlag.value=objFlag.value+"^";
			if (ADMDATA["AdmWard"]) objFlag.value=objFlag.value+"^"+ADMDATA["AdmWard"]
			else objFlag.value=objFlag.value+"^";
			if (ADMDATA["ExpAdmDateFrom"]) objFlag.value=objFlag.value+"^"+ADMDATA["ExpAdmDateFrom"]
			else objFlag.value=objFlag.value+"^";
			if (ADMDATA["ExpAdmDateTo"]) objFlag.value=objFlag.value+"^"+ADMDATA["ExpAdmDateTo"]
			else objFlag.value=objFlag.value+"^";
			var obj=document.getElementById("SelBookingType");
			if (obj) objFlag.value=objFlag.value+"^"+obj.value;
			else objFlag.value=objFlag.value+"^";
			if (ADMDATA["AdmissionPoint"]) objFlag.value=objFlag.value+"^"+ADMDATA["AdmissionPoint"]
			else objFlag.value=objFlag.value+"^";
			if (ADMDATA["SignificantFacility"]) objFlag.value=objFlag.value+"^"+ADMDATA["SignificantFacility"]
			else objFlag.value=objFlag.value+"^";
			var obj=document.getElementById("CurrAppts");
			if (obj) objFlag.value=objFlag.value+"^"+obj.value;
			else objFlag.value=objFlag.value+"^";
			// ab 3.08.04 - 44105
			if (ADMDATA["AdmDateFrom2"]) objFlag.value=objFlag.value+"^"+ADMDATA["AdmDateFrom2"]
			else objFlag.value=objFlag.value+"^";
			if (ADMDATA["AdmDateTo2"]) objFlag.value=objFlag.value+"^"+ADMDATA["AdmDateTo2"]
			else objFlag.value=objFlag.value+"^";
			
			var objSelHosp=document.getElementById("SelAdmHospital");
			if (objSelHosp) objFlag.value=objFlag.value+"^"+objSelHosp.value
			else objFlag.value=objFlag.value+"^";
			
			var obj=document.getElementById("GroupNo");
			if (obj) objFlag.value=objFlag.value+"^"+obj.value;
			else objFlag.value=objFlag.value+"^";
			
			// ab 2.02.04 - give 'admdata' upto piece 30 if needed in the future
			objFlag.value=objFlag.value+"^^";
			//objFlag.value=objFlag.value+"^^^^^^";
			
			var obj=document.getElementById("PENSTYPEDesc");
			if (obj) objFlag.value=objFlag.value+"^"+obj.value;
			else objFlag.value=objFlag.value+"^";
			objFlag.value=objFlag.value+"^"+name4;
			objFlag.value=objFlag.value+"^"+soundex;
			objFlag.value=objFlag.value+"^"+mobile;
			
			// cjb 03/01/2005 50115
			if (ADMDATA["ziprowid"]) objFlag.value=objFlag.value+"^"+ADMDATA["ziprowid"]
			else objFlag.value=objFlag.value+"^";
			
			// cjb 05/01/2005 56833
			objFlag.value=objFlag.value+"^"+PassportNumber;
			objFlag.value=objFlag.value+"^"+SafetyCard;
			if (ADMDATA["CTOCCDesc"]) objFlag.value=objFlag.value+"^"+ADMDATA["CTOCCDesc"]
			else objFlag.value=objFlag.value+"^";
			objFlag.value=objFlag.value+"^"+EmployeeNo;
			
			objFlag.value=objFlag.value+"^"+aryPATCF[10]		// cjb 05/07/2006 59758
			
		}
		
		//alert(objFlag.value); 
		
		if (!FindDOB(1)) return false;
		
		return find1_click();
	}
}

function setHiddenFields() {
	var f=document.getElementById("fPAPerson_Find");
	var obj
	obj=document.getElementById('PAPERDob')
	if (obj.value!="") {
		var aryDOB=obj.value.split("^")
		var objDOB=document.getElementById('DateOfBirth')
		if ((objDOB)&&(aryDOB[0])) objDOB.value=aryDOB[0]
		
	}
	var obj=document.getElementById('hiddenFlag')
	if (obj.value!="") {
		var aryVars=obj.value.split("^")
		var objcurrent=document.getElementById('current')
		if (objcurrent) {
			if (aryVars[0]=="On") {
				objcurrent.checked=true;
			}
		}
		var objregoflag=document.getElementById('regoflag')
		if (objregoflag) {
			if (aryVars[1]=="On") {
				objregoflag.checked=true;
			}
		}
		var objMRType=document.getElementById('MRType')
		if (objMRType) objMRType.value=aryVars[2];
		
		// ab 4.06.03 - added age search type
		aryVars[3]=aryVars[3].split("|");
		var objAge=document.getElementById('Age')
		if (objAge) objAge.value=aryVars[3][0];
		//var objAgeT=document.getElementById('AgeSearchType')
		//if ((objAgeT)&&(aryVars[3][1])) objAgeT.value=aryVars[3][1];

		var objexact=document.getElementById('exact');
		if (objexact) {
			if (aryVars[4]=="On") {
				objexact.checked=true;
			}
		}
		var objDVANumber=document.getElementById('DVANumber');
		if (objDVANumber) objDVANumber.value=aryVars[5];

		var objallnames=document.getElementById('allnames');
		if (objallnames) {
			if (aryVars[7]=="On") {
				objallnames.checked=true;
			}
		}
		var objsoundex=document.getElementById('soundex');
		if (objsoundex) {
			if (aryVars[32]=="On") {
				objsoundex.checked=true;
			}
		}
		//ADMDATA["AdmissionType"]=aryVars[10];
		ADMDATA["VisitStatus"]=aryVars[11];
		ADMDATA["AdmDateFrom"]=aryVars[12];
		ADMDATA["AdmDateTo"]=aryVars[13];
		ADMDATA["AdmDoc"]=aryVars[14];
		ADMDATA["AdmLoc"]=aryVars[15];
		ADMDATA["AdmRespUnit"]=aryVars[16];
		ADMDATA["AdmWard"]=aryVars[17];
		ADMDATA["ExpAdmDateFrom"]=aryVars[18];
		ADMDATA["ExpAdmDateTo"]=aryVars[19];
		ADMDATA["AdmissionPoint"]=aryVars[21];
		ADMDATA["SignificantFacility"]=aryVars[22];
		ADMDATA["AdmDateFrom2"]=aryVars[24];
		ADMDATA["AdmDateTo2"]=aryVars[25];
		ADMDATA["ziprowid"]=aryVars[34];
		ADMDATA["CTOCCDesc"]=aryVars[37];
	}
}

// ab 28.09.04 46476 - populates the listboxes with previous values
function setListboxes() {
    var obj=document.getElementById("HiddenHosps");
    var objcode=document.getElementById("hiddenFlag");
    if ((obj)&&(obj.value!="")&&(objcode)&&(objcode.value!="")) {
        // mr type hospital
        var objlist=document.getElementById("Hospital");
        var hosps=obj.value.split("^")[0];
        hosps=hosps.split("|");
        var hospcode=objcode.value.split("^")[9];
        hospcode=hospcode.split("|");
        for (var i=0;i<hosps.length;i++) {
            if ((objlist)&&(hosps[i]!="")) {
                if (!isInList(hosps[i],objlist)) AddItemToList(objlist,hosps[i],hospcode[i]);
            }
        }
        
        // adm hospital
        var objlist=document.getElementById("AdmHospitalList");
        var hosps=obj.value.split("^")[1];
        hosps=hosps.split("|");
        var hospcode=objcode.value.split("^")[26];
        hospcode=hospcode.split("|");
        for (var i=0;i<hosps.length;i++) {
            if ((objlist)&&(hosps[i]!="")) {
                // ab 47259 - only add if not defaulted from layout
                if (!isInList(hosps[i],objlist)) AddItemToList(objlist,hosps[i],hospcode[i]);
            }
        }
    }
    // select previous episode types
    if ((objcode)&&(objcode.value!="")) {
        var type=objcode.value.split("^")[10];
        type=type.split("|");
        var objlist=document.getElementById("AdmissionType");
        if ((objlist)&&(type[i]!="")) {
            for (var i=0;i<objlist.options.length;i++) {
                for (var j=0;j<type.length;j++) {
                    if (type[j]==objlist.options[i].value) objlist.options[i].selected=true;
                }
            }
        }
    }
}

function setCheckBox() {
	var objReg=document.getElementById('regoflag')
	if (objReg) {
		objReg.checked=true
	}
}


function RegistrationEnter(e) {
	var key = websys_getKey(e);
	var obj = websys_getSrcElement(e);
	if ((obj)&&(obj.value!="")&&(key==13)) {
		var obj=document.getElementById("find1");
		if (obj) obj.focus();
	}
}

function validateAge() {
	var age=document.getElementById('Age');

	if ((age)&&(age.value!="")) {
		if (isNaN(age.value)) {
			alert(t['Age']+" "+t['XNUMBER']);
			age.value="";
			return false;
		} else if (age.value > EXCESSIVEAGE) {
			alert(t['Age']+" "+t['XINVALID']);
			age.value="";
			return false;
		}
	}
	return;
}

//-----------------------
// ab 2.06.03 - 30971 - lookup functions/blur handlers for admission fields, age search type

function LookupAgeSearchType(str) {
	var lu=str.split("^");
	var obj=document.getElementById("AgeSearchTypeID");
	if (obj) obj.value=lu[2];
}

//function LookupAdmissionType(str) {
//	lu=str.split("^");
//	ADMDATA["AdmissionType"]=lu[2];
//}

function LookupVisitStatus(str) {
	lu=str.split("^");
	ADMDATA["VisitStatus"]=lu[2];
}

function LookupAdmDoc(str) {
	lu=str.split("^");
	ADMDATA["AdmDoc"]=lu[8];
	// ab 24.06.04 - 44754
	if (lu[4]!="") ADMDATA["AdmLoc"]=lu[4];
	var obj=document.getElementById("AdmLoc")
	if ((obj)&&(lu[2]!="")) obj.value = lu[2];
}

function LookupAdmLoc(str) {
	lu=str.split("^");
	ADMDATA["AdmLoc"]=lu[1];
}

function LookupAdmRespUnit(str) {
	lu=str.split("^");
	ADMDATA["AdmRespUnit"]=lu[1];
}

function LookupAdmWard(str) {
	lu=str.split("^");
	ADMDATA["AdmWard"]=lu[2];
}

function LookupAdmissionPoint(str) {
	lu=str.split("^");
	ADMDATA["AdmissionPoint"]=lu[1];
}

function LookupSignificantFacility(str) {
	lu=str.split("^");
	ADMDATA["SignificantFacility"]=lu[1];
}

function LookupCTOCCDesc(str) {
	lu=str.split("^");
	ADMDATA["CTOCCDesc"]=lu[1];
}


//function BlurHandlerAdmissionType() {
//	var obj=document.getElementById("AdmissionType");
//	if ((obj)&&(obj.value=="")) ADMDATA["AdmissionType"]="";
//}

function BlurHandlerVisitStatus() {
	var obj=document.getElementById("VisitStatus");
	if ((obj)&&(obj.value=="")) ADMDATA["VisitStatus"]="";
}

function ChangeHandlerAdmDateFrom() {
	AdmDateFrom_changehandler();
	var obj=document.getElementById("AdmDateFrom");
	if (obj) ADMDATA["AdmDateFrom"]=obj.value;
}
function BlurHandlerAdmDateFrom() {
	var obj=document.getElementById("AdmDateFrom");
	if (obj) ADMDATA["AdmDateFrom"]=obj.value;
}

function BlurHandlerAdmDateTo() {
	var obj=document.getElementById("AdmDateTo");
	if (obj) ADMDATA["AdmDateTo"]=obj.value;
}

function BlurHandlerAdmDateFrom2() {
	var obj=document.getElementById("AdmDateFrom2");
	if (obj) ADMDATA["AdmDateFrom2"]=obj.value;
}

function BlurHandlerAdmDateTo2() {
	var obj=document.getElementById("AdmDateTo2");
	if (obj) ADMDATA["AdmDateTo2"]=obj.value;
}

function BlurHandlerAdmDoc() {
	var obj=document.getElementById("AdmDoc");
	if ((obj)&&(obj.value=="")) ADMDATA["AdmDoc"]="";
}

function BlurHandlerAdmLoc() {
	var obj=document.getElementById("AdmLoc");
	if ((obj)&&(obj.value=="")) ADMDATA["AdmLoc"]="";
}

function BlurHandlerAdmRespUnit() {
	var obj=document.getElementById("AdmRespUnit");
	if ((obj)&&(obj.value=="")) ADMDATA["AdmRespUnit"]="";
}

function BlurHandlerAdmWard() {
	var obj=document.getElementById("AdmWard");
	if ((obj)&&(obj.value=="")) ADMDATA["AdmWard"]="";
}

function BlurHandlerAgeSearchType() {
	var obj=document.getElementById("AgeSearchType");
	var objID=document.getElementById("AgeSearchTypeID");
	if ((obj)&&(obj.value=="")&&(objID)) objID.value="";
}

function BlurHandlerExpAdmDateFrom() {
	var obj=document.getElementById("ExpAdmDateFrom");
	if (obj) ADMDATA["ExpAdmDateFrom"]=obj.value;
}

function BlurHandlerExpAdmDateTo() {
	var obj=document.getElementById("ExpAdmDateTo");
	if (obj) ADMDATA["ExpAdmDateTo"]=obj.value;
}

function BlurHandlerAdmissionPoint() {
	var obj=document.getElementById("AdmissionPoint");
	if ((obj)&&(obj.value=="")) ADMDATA["AdmissionPoint"]="";
}

function BlurHandlerSignificantFacility(e) {
	var obj=document.getElementById("SignificantFacility");
	if ((obj)&&(obj.value=="")) ADMDATA["SignificantFacility"]="";
}

// cjb 03/01/2006 50115 - coped from PAPerson.Edit.js
function BlurHandlerCTZIPCode(e) {
	var obj=document.getElementById("CTZIPCode");
	if ((obj)&&(obj.value=="")) ADMDATA["ziprowid"]="";
}

function BlurHandlerCTCITDesc(e) {
	var obj=document.getElementById("CTCITDesc");
	if ((obj)&&(obj.value=="")) ADMDATA["ziprowid"]="";
}

function BlurHandlerCTOCCDesc(e) {
	var obj=document.getElementById("CTOCCDesc");
	if ((obj)&&(obj.value=="")) ADMDATA["CTOCCDesc"]="";
}



// cjb 03/03/2005 47477
function ChangeHandlerAdmDateFrom() {
	AdmDateFrom_changehandler();
	var obj=document.getElementById("AdmDateFrom");
	if (obj) ADMDATA["AdmDateFrom"]=obj.value;
}
function ChangeHandlerAdmDateTo() {
	AdmDateTo_changehandler();
	var obj=document.getElementById("AdmDateTo");
	if (obj) ADMDATA["AdmDateTo"]=obj.value;
}
function ChangeHandlerAdmDateFrom2() {
	AdmDateFrom2_changehandler();
	var obj=document.getElementById("AdmDateFrom2");
	if (obj) ADMDATA["AdmDateFrom2"]=obj.value;
}
function ChangeHandlerAdmDateTo2() {
	AdmDateTo2_changehandler();
	var obj=document.getElementById("AdmDateTo2");
	if (obj) ADMDATA["AdmDateTo2"]=obj.value;
}
function ChangeHandlerExpAdmDateFrom() {
	ExpAdmDateFrom_changehandler();
	var obj=document.getElementById("ExpAdmDateFrom");
	if (obj) ADMDATA["ExpAdmDateFrom"]=obj.value;
}
function ChangeHandlerExpAdmDateTo() {
	ExpAdmDateTo_changehandler();
	var obj=document.getElementById("ExpAdmDateTo");
	if (obj) ADMDATA["ExpAdmDateTo"]=obj.value;
}



//-----------------------

// from websys.ListBoxes
function selectOptions(obj,arysel) {
	for (var i=0;i<obj.length;i++) {
		if (arysel[i]=="false") arysel[i]=false;
		if (arysel[i]=="true") arysel[i]=true;
		obj.options[i].selected=arysel[i];
	}
}

function AddItemToList(list,desc,code) {
	list.options[list.options.length] = new Option(desc,code);
}

function RemoveFromList(obj) {
	for (var i=(obj.length-1); i>=0; i--) {
		if (obj.options[i].selected)
			obj.options[i]=null;
	}
}

function isInList(text,objlist) {
    var exists=false;
	for (var i=0;i<objlist.length;i++) {
        if (objlist[i].text==text) exists=true;
	}
    return exists;
}

// cjb 03/01/2006 50115 - coped from PAPerson.Edit.js
function ZipLookupSelect(str) {
 	var lu = str.split("^");
	var obj1=document.getElementById("CTZIPCode")
	if (obj1) obj1.value = lu[0];
 	var obj=document.getElementById("CTCITDesc")
	if (obj) obj.value = lu[1];
 	ADMDATA["ziprowid"]=lu[7];
}

function CityLookupSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById("CTZIPCode")
	if (obj) obj.value = lu[0];
 	var obj1=document.getElementById("CTCITDesc")
	if (obj1) obj1.value = lu[1];
 	ADMDATA["ziprowid"]=lu[7];
 	
}

// cjb 16/02/2007 61903
function MinimumSearch() {
	var MinimumSearchFields=document.getElementById("MinimumSearchFields")
	if ((MinimumSearchFields)&&(MinimumSearchFields.value!="")) {
		var aryMinimumSearchFields=MinimumSearchFields.value.split("^")
		var MinimumSearchFieldsOK=0
		var MinimumSearchMessage=""
		for (var i=0;i<aryMinimumSearchFields.length;i++) {
			var field=aryMinimumSearchFields[i];
			var fieldvalue=""
			var objfield=document.getElementById(field)
			if (objfield) fieldvalue=objfield.value;
			if (fieldvalue!="") MinimumSearchFieldsOK=1
			if (MinimumSearchMessage=="") {
				MinimumSearchMessage=t[field];
			} else {
				MinimumSearchMessage=MinimumSearchMessage+", "+t[field]
			}
		}
		if (MinimumSearchFieldsOK==0) {alert(t['MinimumSearch']+"\n"+MinimumSearchMessage); return false;}
	}
	return true;
}

function BlurHandlerPAPERName(e) {

	var obj=document.getElementById('PAPERName');
	var objPT=document.getElementById('PTYPEDesc');
	if (obj&&objPT) 
	{
		if (obj.value!="") 
			{
			EnableField('PTYPEDesc');
			EnableLookup('ld48iPTYPEDesc');
		}
		if (obj.value=="") 
			{
			DisableField('PTYPEDesc');
			DisableLookup('ld48iPTYPEDesc');
			}
	}

}




document.body.onload = DocumentLoadHandler;

