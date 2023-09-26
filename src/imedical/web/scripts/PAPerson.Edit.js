// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var EXCESSIVEYEAR=1880,EXCESSIVEAGE=125;
var AskedForSaveAddress=0,AskedForSaveDoc=0,AskedForActiveDoc=0;
var systemconfigs=document.getElementById("PATCF")
var aryPATCF=""
if (systemconfigs) aryPATCF=systemconfigs.value.split("^")
var PatientID = document.getElementById('PatientID').value;
var AnonymousName = document.getElementById('AnonymousName');
if (AnonymousName) AnonymousName=AnonymousName.value
var merged=document.getElementById("IsMerged");
if (merged) merged=merged.value

if (aryPATCF) {
	var inDays=aryPATCF[3]
	var inWeeks=aryPATCF[4]
	var inMonths=aryPATCF[5]
	var confirmAlias=aryPATCF[8]
	var confirmAddress=aryPATCF[9]
}
var SECOND = 1000; // the number of milliseconds in a second
var MINUTE = SECOND * 60; // the number of milliseconds in a minute
var HOUR = MINUTE * 60; // the number of milliseconds in an hour
var DAY = HOUR * 24; // the number of milliseconds in a day
var WEEK = DAY * 7; // the number of milliseconds in a week

var surname=document.getElementById('PAPERName');
var firstname=document.getElementById('PAPERName2');
var middlename=document.getElementById('PAPERName3');
var PAPERName4=document.getElementById('PAPERName4');
var PAPERName5=document.getElementById('PAPERName5');
var PAPERName6=document.getElementById('PAPERName6');
var PAPERName7=document.getElementById('PAPERName7');
var PAPERName8=document.getElementById('PAPERName8');
var defaultname=document.getElementById('PAPERName').value;


setRegistration();
setEstDobFontColour();
setNames();


function DocumentLoadHandler(e) {
	setLinks();
	setCheckBoxFlag() 
	
	var tmpID=document.getElementById('tempPatientID');
	if ((PatientID)&&(tmpID)) {
		if ((PatientID!=tmpID.value)&&(tmpID.value!="")) {
			document.forms['fPAPerson_Edit'].elements['TDIRTY'].value=2;
		}
	}
    var objnNumber=document.getElementById('registrationNumber');                        //20090831 
    if  (objnNumber) objnNumber.readOnly=true;                                          //20090831 
	//KK 28-Feb-2002 Log:23140 hide lookup against Address1
	var obj=document.getElementById('ld49iPAPERStNameLine1');
	if (obj) obj.style.visibility = "hidden";

	// these fields are determined in the code tables, cannot edit
	var obj=document.getElementById("CLNAddress1");
	if (obj) obj.readOnly=true;
	var obj=document.getElementById("DentCLNAddress1");
	if (obj) obj.readOnly=true;
	var obj=document.getElementById('MRADMBloodTypeDR');
	if (obj) {
		obj.readOnly=true;
		obj.className = "disabledField";
	}
	
	// BUILD MERGE REG OR MRN LINK
	var obj=document.getElementById('mergeRego');
	var objMRN=document.getElementById('mergeMRN');
	if (obj) {
		var val=obj.innerHTML;
		var arylink=new Array();
		var multimerge="";
		if (val!="&nbsp;") { //if val does not contain data it contains &nbsp; instead!!
			var ary=val.split("(");
			val=ary.join("");
			ary=val.split(")");
			val=ary.join("");
			ary=val.split(" ");
			
			if (ary.length>1) {
					multimerge=1;
			}
			for (var i=0;i<ary.length;i++) {
				arylink[i]="<A HREF='javascript:goToMergePage("+'"'+ary[i]+'","'+multimerge+'"'+")'>"+ary[i]+"</A>";
			}
			obj.innerHTML="("+arylink.join(",")+")";
		}
	}
	if (objMRN) {
		var val=objMRN.innerHTML;
		var arylink=new Array();
		var multimerge="";
		if (val!="&nbsp;") { //if val does not contain data it contains &nbsp; 
			var ary=val.split("(");
			val=ary.join("");
			ary=val.split(")");
			val=ary.join("");
			ary=val.split(" ");
		
			if (ary.length>1) {
					multimerge=1
			}
			for (var i=0;i<ary.length;i++) {
				arylink[i]="<A HREF='javascript:goToMergePage("+'"'+ary[i]+'","'+multimerge+'"'+")'>"+ary[i]+"</A>";
			}
			objMRN.innerHTML="("+arylink.join(",")+")";
		}
	}
	// ab 12.07.03 - fixed so we dont require the previous patient to have a regno, still can unmerge
	if (merged=="") {
		var lnk=document.getElementById('UnMergePatient');
		if (lnk) {
			lnk.disabled=true;
			lnk.onclick=LinkDisable;
		}
	}
		
	obj=document.getElementById('PAPERDob')
	if (obj) obj.onchange = DOBChangeHandler;
	if (obj) DOBLoadHandler();		// cjb 14/06/2005 52120 - if the age of a new patient is carried from the .find page calculate the age
	obj=document.getElementById('PAPERAge')
	if (obj) obj.onchange = AgeChangeHandler;
	obj=document.getElementById('AgeDynamic')
	if (obj) obj.onchange = AgeChangeHandler2;
	obj=document.getElementById('PAPEREstDOB');
	if (obj) obj.onclick=setEstDobFontColour;
	obj=document.getElementById('PAPERStNameLine1');
	if (obj) {
		obj.onchange=convertAddress;
		obj.onkeydown='';
	}
	obj=document.getElementById('PAPERForeignAddress');
	if (obj) obj.onchange=convertAddress;
	obj=document.getElementById('PAPEREmail');
	if (obj) obj.onblur= isEmail;
	obj=document.getElementById('PAPERName');
	if (obj) obj.onchange = setAlias;
	if (obj) {
		var PAPERName2 = document.getElementById('PAPERName2');
		PAPERName2.value = getPinyin(obj.value);
	}
	obj=document.getElementById('PAPERName2');
	if (obj) obj.onchange = setAlias;
	obj=document.getElementById('PAPERName3');
	if (obj) obj.onchange = setAlias;

	obj=document.getElementById('ViewDentistDetails');
	if (obj) obj.onclick=ViewDentistHandler;
	//md 30/01/2003
	var obj=document.getElementById('REFDDesc');
	if (obj) obj.onblur=InternalDrChangeHandler;
	obj=document.getElementById('ViewDoctorDetails');
	if (obj) obj.onclick=ViewDoctorHandler;
	
	obj=document.getElementById('DentREFDDesc');
	if (obj) obj.onblur=DentREFDDescBlurHandler;
	obj=document.getElementById('EstimDateDeath');
	if (obj) obj.onchange = setEstDeceased;
	obj=document.getElementById('EXREFDGP');
	if (obj) obj.onclick=EXREFDGPHandler;
	//obj=document.getElementById("PAPERDVAExpiryDate");
	obj=document.getElementById("PAPERDVAExpiryDateT");
	if (obj) obj.onblur=ExpiryBlurHandler;
	//obj=document.getElementById("PAPERPensionCardExpiryDate");
	obj=document.getElementById("PAPERPensionCardExpiryDateT");
	if (obj) obj.onblur=ExpiryBlurHandler;
	//obj=document.getElementById("PAPMIHealthCardExpiryDate");
	obj=document.getElementById("PAPMIHealthCardExpiryDateT");
	if (obj) obj.onblur=ExpiryBlurHandler;
	//obj=document.getElementById("SafetyCardExp");
	obj=document.getElementById("SafetyCardExpT");
	if (obj) obj.onblur=ExpiryBlurHandler;
	//md 12/11/2003
	//obj=document.getElementById("MedicareExpDate");
	obj=document.getElementById("MedicareExpDateT");
	if (obj) obj.onblur=ExpiryBlurHandler;
	
	objBold=document.getElementById('BoldLinks');
	if (objBold) {
		var BoldLink = objBold.value.split("^");
		obj=document.getElementById('ContactPerson');
		if ((obj) && (BoldLink[0]=="1")) obj.style.fontWeight="bold";
		obj=document.getElementById('OtherAddresses');
		if ((obj) && (BoldLink[1]=="1")) obj.style.fontWeight="bold";
		obj=document.getElementById('Alias');
		if ((obj) && (BoldLink[2]=="1")) obj.style.fontWeight="bold";
		obj=document.getElementById('PAAlert');
		if ((obj) && (BoldLink[3]=="1")) obj.style.fontWeight="bold";
		obj=document.getElementById('FamDocHist');
		if ((obj) && (BoldLink[4]=="1")) obj.style.fontWeight="bold";
		obj=document.getElementById('MRNumber');
		if ((obj) && (BoldLink[5]=="1")) obj.style.fontWeight="bold";
		obj=document.getElementById('Allergies');
		if ((obj) && (BoldLink[6]=="1")) obj.style.fontWeight="bold";
		obj=document.getElementById('ALGEMRLink');
		if ((obj) && (BoldLink[6]=="1")) obj.style.fontWeight="bold";
		obj=document.getElementById('FamDentHist');
		if ((obj) && (BoldLink[7]=="1")) obj.style.fontWeight="bold";
		obj=document.getElementById('PAPERInsuranceLink');
		if ((obj) && (BoldLink[8]=="1")) obj.style.fontWeight="bold";
		obj=document.getElementById('Exemptions');
		if ((obj) && (BoldLink[9]=="1")) obj.style.fontWeight="bold";
		obj=document.getElementById('FamilyLink');
		if ((obj) && (BoldLink[10]=="1")) obj.style.fontWeight="bold";
		obj=document.getElementById('OrganDonor');
		if ((obj) && (BoldLink[11]=="1")) obj.style.fontWeight="bold";
		obj=document.getElementById('CareProviders');
		if ((obj) && (BoldLink[12]=="1")) obj.style.fontWeight="bold";
		obj=document.getElementById('InsuranceDetails');
		if ((obj) && (BoldLink[13]=="1")) obj.style.fontWeight="bold";
		obj=document.getElementById('MRPsychDetails');
		if ((obj) && (BoldLink[14]=="1")) obj.style.fontWeight="bold";  
		obj=document.getElementById('EmployeeDetails');
		if ((obj) && (BoldLink[15]=="1")) obj.style.fontWeight="bold";        
		obj=document.getElementById('Photo');
		if ((obj) && (BoldLink[16]=="1")) obj.style.fontWeight="bold";        // cjb 14/03/2006 48939
		obj=document.getElementById('TreatmentProgress');
		if ((obj) && (BoldLink[17]=="1")) obj.style.fontWeight="bold";        //log 60102
	}
	
	HiddenGCodeBlurHandler();
	
	obj=document.getElementById('EXTERNALMERGE');			// cjb 09/08/2006 60139
	if ((obj) && (obj.value==1)) {
		var lnk = "paperson.edit.externalmerge.hidden.csp?PatientID="+PatientID;
		top.frames["TRAK_hidden"].location=lnk;	
	}
	
	obj=document.getElementById('CopyDemographics');
	if ((PatientID!="")&&(obj)) {
		obj.disabled=true;
		obj.onclick=LinkDisable;
	}
	
	obj=document.getElementById('CopyID');		// cjb 26/09/2006 56820
	if (obj) obj.onchange = CopyDemographicsChangeHandler;
	
	
	obj=document.getElementById('update1');
	if (obj) obj.onclick = UpdateAll;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateAll;
	obj=document.getElementById('printLabel');
	if (obj) obj.onclick = PrintLabelUpdate;
	
	
		
}

function CopyDemographicsChangeHandler(evt) {
	var eSrc = websys_getSrcElement(evt);
	
	var lnk = "paperson.edit.copydemographics.hidden.csp?CopyID="+eSrc.value;
	top.frames["TRAK_hidden"].location=lnk;	
	
}



function UpdateAll(evt) {
	
	if (!checkRegoLookup()) return false;
	if (!ValidateUpdate(evt)) return false;
	if (!ValidateDeceased(evt)) return false;
	checkIfDirty();

	CheckInvalid();
	EnableNames();
	return update1_click();
}

// cjb 30/05/2006 59363 - need to enable the name fields, so that if there is an error the real names are not displayed.
function EnableNames() {
	 
	if (surname) surname.disabled=false;
	if (firstname) firstname.disabled=false;
	if (middlename) middlename.disabled=false;
	if (PAPERName4) PAPERName4.disabled=false;
	if (PAPERName5) PAPERName5.disabled=false;
	if (PAPERName6) PAPERName6.disabled=false;
	if (PAPERName7) PAPERName7.disabled=false;
	if (PAPERName8) PAPERName8.disabled=false;
	
}

// cjb 15/08/2005 54729 - if the Dr/Dentist field is invalid, set the hidden field to "" so the save displays the error
function CheckInvalid() {
    var REFDDesc=document.getElementById("REFDDesc");
    if ((REFDDesc)&&(REFDDesc.className=="clsInvalid")) {
	    var doctorCode=document.getElementById("doctorCode");
	    if (doctorCode) doctorCode.value="";
	    var PAPERFamilyDoctorClinicDR=document.getElementById("PAPERFamilyDoctorClinicDR");
	    if (PAPERFamilyDoctorClinicDR) PAPERFamilyDoctorClinicDR.value="";
    }
	
    var DentREFDDesc=document.getElementById("DentREFDDesc");
    if ((DentREFDDesc)&&(DentREFDDesc.className=="clsInvalid")) {
	    var dentCode=document.getElementById("dentCode");
	    if (dentCode) dentCode.value="";
	    var PAPMIDentistClinicDR=document.getElementById("PAPMIDentistClinicDR");
	    if (PAPMIDentistClinicDR) PAPMIDentistClinicDR.value="";
    }
	
}


// ab 21.07.05 - 52769 - TDIRTY is not set if hidden fields changed, need to change manually
function checkIfDirty() {
    var TDIRTY=document.getElementById("TDIRTY");
    if (document.forms['fPAPerson_Edit'].elements['TDIRTY'].value!=2) {
        var obj=document.getElementById("GPCode");
        if ((obj)&&(obj.value!=obj.defaultValue))  { document.forms['fPAPerson_Edit'].elements['TDIRTY'].value=2; }
        var obj=document.getElementById("doctorCode");
        if ((obj)&&(obj.value!=obj.defaultValue)) { document.forms['fPAPerson_Edit'].elements['TDIRTY'].value=2; }
        var obj=document.getElementById("PAPERFamilyDoctorClinicDR");
        if ((obj)&&(obj.value!=obj.defaultValue))  { document.forms['fPAPerson_Edit'].elements['TDIRTY'].value=2; }
        var obj=document.getElementById("dentCode");
        if ((obj)&&(obj.value!=obj.defaultValue)) { document.forms['fPAPerson_Edit'].elements['TDIRTY'].value=2; }
        var obj=document.getElementById("PAPMIDentistClinicDR");
        if ((obj)&&(obj.value!=obj.defaultValue)) { document.forms['fPAPerson_Edit'].elements['TDIRTY'].value=2; }
    }
}

function checkRegoLookup() {
	obj=document.getElementById('RegoLookUp')
	if (obj) {
		if ((obj.value)!=(obj.defaultValue)) {
				return false
			}
	} return true
}






//populate epr header with patient selected.
var winf = null;
if (window.parent != window.self) winf = window.parent;
if ((winf)&&(winf.frames['eprmenu'])) {
	var PatientID=document.forms['fPAPerson_Edit'].elements['ID'].value;
	if (PatientID) winf.SetSingleField("PatientID",PatientID);
}

// SET DISABLE REGISTRATION NUMBERS FOR EXISTING PATIENTS
function setRegistration() {
	var obj=document.getElementById('RegNumHidden');
	if ((obj)&&(obj.defaultValue!="")) {
		var objr=document.getElementById('RegistrationNumber');
		if (objr)
			objr.disabled=true;
	}
}

//SET CLASSNAME FOR STYLESHEET
function setEstDobFontColour() {
	var est=document.getElementById('PAPEREstDOB');
	var dob=document.getElementById('PAPERDob');
	if ((dob)&&(est)&&(dob.value!="")) {
		if (est.checked) {
			dob.className="EstDOB";
		} else {
			dob.className="";
		}
	}
}

function setBoldLinks(el,state) {
	obj=document.getElementById(el);
	if (obj) {
		if (state==1) obj.style.fontWeight="bold";
		else obj.style.fontWeight="normal"
	}
}

// Log 60931 - 11/10/2006 - Refresh any field with a given value - now used by papersonadminsurance.csp
function refreshField(field,val) {
	obj=document.getElementById(field);
	if (obj) {
		obj.value=val;
	}
}

// 4/11/02 Log#29405 HP: Disable names if "Anonymous" when not allow to view VIP with status of it.
// ab 27/02/03 32956 - show 'anonymous' for anon patients not dependant on vip flag
// cjb 06/01/2005 55848 - changed from hardcoded "Anonymous" to the AnonymousName hidden field (sys param)
function setNames() {
	var viewVIP=document.getElementById('AllowViewVIP');
	var VIPStat=document.getElementById('VIPStatus');
	 
	if ((VIPStat)&&(VIPStat.value=="A")) {
		if ((surname)&&(surname.defaultValue==AnonymousName)) surname.disabled=true;
		if ((firstname)&&(firstname.defaultValue==AnonymousName)) firstname.disabled=true;
		if ((middlename)&&(middlename.defaultValue==AnonymousName)) middlename.disabled=true;
		if ((PAPERName4)&&(PAPERName4.defaultValue==AnonymousName)) PAPERName4.disabled=true;
		if ((PAPERName5)&&(PAPERName5.defaultValue==AnonymousName)) PAPERName5.disabled=true;
		if ((PAPERName6)&&(PAPERName6.defaultValue==AnonymousName)) PAPERName6.disabled=true;
		if ((PAPERName7)&&(PAPERName7.defaultValue==AnonymousName)) PAPERName7.disabled=true;
		if ((PAPERName8)&&(PAPERName8.defaultValue==AnonymousName)) PAPERName8.disabled=true;
	}
}



function goToMergePage(val,multimerge) {
	var RegistrationNumber=document.getElementById('RegNumHidden').value;
	if (multimerge==0) val=document.getElementById('firstMergeMRN').value;
	if (multimerge==1) {
		websys_createWindow('websys.default.csp?WEBSYS.TCOMPONENT=PAUnMerge.List&&ID='+PatientID+'Rego='+val+'&PatientID='+PatientID+'&PatientBanner=1','merge','top=20,left=20,width=500,height=300,scrollbars=yes,resizable=yes');
	} else {
		websys_createWindow('websys.default.csp?WEBSYS.TCOMPONENT=PAUnMerge.Edit&RegNo='+val+'&ID='+PatientID+'&PatientID='+PatientID+'&PatientBanner=1','merge','top=20,left=20,width=400,height=600,scrollbars=yes,resizable=yes');
	}
}

//JW:used on deceased text field to confirm deceased status.
function setEstDeceased(evt) {
	var eSrc = websys_getSrcElement(evt);
	if (eSrc.value != "") {
		var dec=confirm(t['ConfirmDecease']);
		if (!dec) eSrc.value="";
	}
}


function setAlias(evt) {
	var eSrc = websys_getSrcElement(evt);
	//md 26/09/2003
	var fullname=CreateFullName(evt);
	//md 26/09/2003
	//need to check original name against entered name (especially when called within ValidateUpdate)
	//Log 60483 BoC 12-09-2006: alert if "Never create Alias Name" is not checked in system parameter
	var noAliasObj = document.getElementById("noAlias");

	var noali = "";
	if (noAliasObj)
		var noali = noAliasObj.value;
	if ((PatientID != "") && (eSrc.defaultValue != "") && (eSrc.defaultValue != eSrc.value) && (noali != "Y")) {
		var msg = t[eSrc.id] + ": " + t['ALIAS']// cjb 09/08/2006 60511
			if (confirm(msg)) {
				//websys_createWindow('paperson.aliasname.update.csp?PatientID='+PatientID+'&ComponentItemName='+ComponentItemName+'&DefaultValue='+oldname,'TRAK_hidden','');
				/* Log 62415 Don't use hidden csp anymore, saved in webclass to make the system consistant. So save into database only when clicking "Update"
				websys_createWindow('paperson.aliasname.update.csp?PatientID='+PatientID+'&ComponentItemName='+eSrc.id+'&DefaultValue='+eSrc.defaultValue+'&FullName='+fullname,'TRAK_hidden','');
				 */
				var obj = document.getElementById("ComponentItemName");
				if (obj)
					obj.value = obj.value + "^" + eSrc.id;
				var obj = document.getElementById("ComponentItemDefaultValue");
				if (obj)
					obj.value = obj.value + "^" + eSrc.defaultValue;
				var obj = document.getElementById("FullName");
				if (obj)
					obj.value = fullname;
				var obj = document.getElementById("SaveAlias");
				if (obj)
					obj.value = 1;
				var obj = document.getElementById('PAPERName');
				if (obj) {
					var PAPERName2 = document.getElementById('PAPERName2');
					PAPERName2.value = getPinyin(obj.value);
				}
			} else {
				var obj = document.getElementById('PAPERName');
				obj.value = defaultname;
			}
	}
}

//--------------------------------------

function regoLookupSelect(str) {
 	var lu = str.split("^");
	var obj=document.getElementById("ID")
	//reloadPatient(null)
	if (obj) obj.value = lu[1];
	var path="websys.default.csp?WEBSYS.TCOMPONENT=PAPerson.Edit";
	if (obj) path+="&ID="+obj.value + "&PatientID="+obj.value;
	var obj=document.getElementById("TWKFL");
	if (obj) path+="&TWKFL="+obj.value;
	var obj=document.getElementById("TWKFLI");
	if (obj) path+="&TWKFLI="+(obj.value);
	var obj=session["CONTEXT"]
	if (obj) path+="&CONTEXT="+(obj);
	location.href=path
}


// Age and Date of Birth ------------------------------------

// cjb 14/06/2005 52120 - if the age of a new patient is carried from the .find page calculate the age
function DOBLoadHandler() {
	var eSrc = document.getElementById('PAPERDob');
	
	return DOBChange(eSrc);
}

function DOBChangeHandler(e) {
	//var eSrc = websys_getSrcElement(e);
	var eSrc = document.getElementById('PAPERDob');
	if (eSrc) PAPERDob_changehandler(e)	// cjb 14/06/2005 52120 - moved this here (from DOBChange) as DOBLoadHandler also calls DOBChange but doesn't have e
	//alert("after call PAPERDob_changehandler");
	//var PatientID = document.getElementById('ID').value;
	//var olddob = eSrc.defaultValue;
	//var aliasconfim=document.getElementById('aliasconfirm').value;
	//md 02/07/2003 this code moved in DOBChange() function
	//if ((PatientID != "") && (olddob != "") && (olddob != eSrc.value) && (eSrc.value!="")) {
	//	var ComponentItemName=eSrc.id
	//	if (aliasconfim=="Y") {
	//		if (confirm(t['DOBChange'])) {
	//			eSrc.defaultValue=eSrc.value
	//			websys_createWindow('paperson.aliasname.update.csp?PatientID='+PatientID+'&ComponentItemName='+ComponentItemName+'&DefaultValue='+olddob,'TRAK_hidden','');
	//					     }
	//			       }
	//}
	try {
		Custom_DOBChangeHandler(e);
	} catch(e) { 
		}	finally  {
	}
	return DOBChange(eSrc);
}

// ab 15.05.02 - renovated these functions, now a bit less forgiving but no errors
function DOBChange(eSrc) {
	var msg="";
	var obj = document.getElementById('PAPERDob');
	var objAge = document.getElementById('PAPERAge');
	var objAge2 = document.getElementById('AgeDynamic');
	var objAgeU = document.getElementById('AgeUnits');
	var objAgeF = document.getElementById('AgeFull');
	var objDFlag= document.getElementById('PAPERDeceasedFlag');
	//md 02/07/2003 
	//var PatientID = document.getElementById('ID')
	//var olddob = obj.defaultValue;	
	//var aliasconfim=document.getElementById('aliasconfirm');
	//if (eSrc) PAPERDob_changehandler(e)	// cjb 14/06/2005 52120

	if ((obj)&&(IsValidDate(obj))) {
		{
			//alert(obj.value);
			// this works , otherwise does not evaluate date properly
			//if ((objpat)&&(objpat.value!="")) {PAPERDob_changehandler(e);}
			//PAPERDob_changehandler(e)
			//if (e) {PAPERDeceasedDate_changehandler(e);}
			if (obj.value=="") return true;
			msg = ExcessiveDOB(obj.value);
			if (msg!="") {
				alert(obj.value + '\n' + msg);
				if (objAge) objAge.value = "";
				if (objAge2) objAge2.value="";
				if (objAgeU) objAgeU.value="";
				if (objAgeF) objAgeF.value="";
				obj.value = "";
				websys_setfocus("PAPERDob");
				return false;
			}
			if ((obj.value!="")&&(objDFlag.value!="Y")) {
				if (objAge) objAge.value = CalculateAge(obj.value);
				var dynage=CalculateAgeDynamic(obj.value).split("^");
				if (objAge2) objAge2.value=dynage[0];
				if (objAgeU) objAgeU.innerText=dynage[1];
				if (objAgeF) {
					objAgeF.value=CalculateAgeFull(obj.value);
					/*
					objAgeF.value=obj.value;
					
					var evt = document.createEventObject();
					
					objAgeF.fireEvent('onchange',evt);
					*/
				}
			}
			
			// default age to blank if invalid dob
			
			var dtdob=DateStringToArray(obj.value)
			
			if (((!dtdob["yr"])||(dtdob["yr"]=="NaN"))&&(obj.value!="")) {
				
				if (objAge) objAge.value="";
				if (objAge2) objAge2.value="";
				if (objAgeU) objAgeU.innerText="";
				if (objAgeF) objAgeF.value="";
				obj.value="";
				//websys_setfocus("PAPERDob");
			}
		}
		//alert(obj.value);
		if (!IsAgeRangeValid()) {
			if (objAge) objAge.value = "";
      	    	if (objAge2) objAge2.value="";
            	if (objAgeU) objAgeU.value="";
				if (objAgeF) objAgeF.value="";
			obj.value = "";
			websys_setfocus("PAPERDob");
			return false;
		}
		if (confirmAlias=="Y") {
			if ((PatientID) && (obj.defaultValue != "") && (obj.defaultValue!=obj.value))  {
				if (confirm(t['DOBChange'])) {
					websys_createWindow('paperson.aliasname.update.csp?PatientID='+PatientID+'&ComponentItemName='+obj.id+'&DefaultValue='+obj
					.defaultValue,'TRAK_hidden','');
				}
			}
		}
	}
	//JD 62384
	setEstDobFontColour();

	//md 02/07/2003 move alias confirmation  after validation of the field
	/* JW removed
	if ((PatientID) && (PatientID.value != "") && (olddob != "") && (olddob != obj.value) && (obj.value!="")) {
		var ComponentItemName=obj.id
		if ((aliasconfim)&&(aliasconfim.value=="Y")) {
			if (confirm(t['DOBChange'])) {
				obj.defaultValue=obj.value
				websys_createWindow('paperson.aliasname.update.csp?PatientID='+PatientID.value+'&ComponentItemName='+ComponentItemName+'&DefaultValue='+olddob,'TRAK_hidden','');
				}
			 }
		}
    } */
}

function IsAgeRangeValid() {
	return true;
}

function AgeChangeHandler(e) {
	var eSrc = websys_getSrcElement(e);
	var objDob = document.getElementById("PAPERDob");
	var objAgeU = document.getElementById('AgeUnits');
	var objAge = document.getElementById('PAPERAge');
	var objAge2 = document.getElementById('AgeDynamic');
	var objAgeU = document.getElementById('AgeUnits');	
	var objAgeF = document.getElementById('AgeFull');
	if (!objDob) return;
	// insert age if age field is clear and validate the age field
	if (eSrc.value!="") {
		if (objDob.value != "") {
		 if (eSrc.id!="AgeDynamic")
		 {
			// Clear DOB if age is inputted - it is now calculated on the update event
			objDob.value = "";
		 }	
		}
		//Log 49660 15-09-2006 Boc: clear ageFull if age is inputted
		if ((objAgeF)&&(objAgeF != "")) objAgeF.value = "";
	}
	/* md 56478 if field is cleared then we should't reset it here it will be done on update
   	if (eSrc.value == "") {
           	if (objDob.value != "") {
			//alert(eSrc.id);
			if (eSrc.id=='PAPERAge') {
						eSrc.value = CalculateAge(objDob.value);
							   }
			if (eSrc.id=='AgeDynamic') {
				var dynage=CalculateAgeDynamic(objDob.value).split("^");
				eSrc.value=dynage[0];
				if (objAgeU) { objAgeU.innerText=dynage[1];}
				} 
			}	else {
   			return;
  		}
 	}
	*/
 	if (isNaN(eSrc.value)) {

  		alert(t['PAPERAge']+" "+t['XNUMBER'] + '\n' + eSrc.value);
  		eSrc.value = "";
  		if (objAgeU) objAgeU.innerText="";
 	} else {
  		if (NegativeAge(eSrc.value)) {

   			alert(t['PAPERDob'] + t['FutureAge']);
   			objDob.value = "";
   			eSrc.value = "";
   			if (objAgeU) objAgeU.innerText="";
			//Log 49660 15-09-2006 Boc: clear ageFull if age is inputted
			if ((objAgeF)&&(objAgeF != "")) objAgeF.value = "";
			return;
  		}
		if (eSrc.value > EXCESSIVEAGE) {

   			alert(t['PAPERDob'] + " " + t['XINVALID']);
   			objDob.value = "";
   			eSrc.value = "";
   			if (objAgeU) objAgeU.innerText="";
			//Log 49660 15-09-2006 Boc: clear ageFull if age is inputted
			if ((objAgeF)&&(objAgeF != "")) objAgeF.value = "";
   			return;
		}
 	}
	/*
	if (objDob.value != "") {
	 	// Clear DOB if age is inputted - it is now calculated on the update event
 		objDob.value = "";
	}
	*/
}

function AgeChangeHandler2(e) {
	var eSrc = websys_getSrcElement(e);
	var objAgeU = document.getElementById('AgeUnits');
	var objAge = document.getElementById('PAPERAge');
	if (objAgeU) {
		if (eSrc.value=="") objAgeU.innerText=""
		else if (objAgeU.innerText=="") { objAgeU.innerText=t["UnitYears"]; }
	}
	if (eSrc.value=="") return; 
	AgeChangeHandler(e);
}

function CalculateAge(strDOB) {
	
 	var today = new Date();
	//SB 08/07/02 (25850): Need to add 543 yrs if THAI date.
	if (dtformat=="THAI") today.setYear(today.getFullYear()+543);
 	var thisyear = today.getFullYear();
 	if (thisyear < 100) thisyear += 1900;
 	var arrDate = DateStringToArray(strDOB);
 	var yr = arrDate["yr"];
 	var mn = arrDate["mn"];
 	var dy = arrDate["dy"];
 	var age = thisyear - yr;
 	if (age < 1) return age;
 	if (today.getMonth()+1 < mn) {
  		age -= 1;
	} else if ((today.getMonth()+1 == mn) && (today.getDate() < dy)) {
  		age -= 1;
 	}
 	return age;
}

function CalculateAgeDynamic(strDOB) {
	var unit=""
   	var nDate = new Date();
	var curYear=nDate.getFullYear()
	var curMth=nDate.getMonth()+1
	var curDay=nDate.getDate()
	//var nTime = nDate.getTime(); // current time
	if (curYear < 100) curYear += 1900;
	var nTime = Date.UTC(curYear, curMth-1, curDay); // current time (UTC)
	if (yr < 100) yr += 1900;
	var arrDate = DateStringToArray(strDOB);
	var yr = arrDate["yr"];
	//Log 57142 PeterC 18/01/06
 	if(TK_dtformat=="THAI") yr=yr-543;
	var mn = arrDate["mn"];
	var dy = arrDate["dy"];
	var dTime = Date.UTC(yr, mn-1, dy); // specified time (UTC)
	//var days=Math.floor((nTime-dTime)/ DAY)
    	var bTime = Math.abs(nTime - dTime)  // time difference
	var days=Math.floor(bTime / DAY )
	var weeks=Math.floor(bTime / WEEK )
	var year=Math.round(days/365)
	var inWkDays=inWeeks*7
	var ageDay=curDay-dy
	var ageMth=curMth-mn
	var ageYear=curYear-yr
	if (ageDay<0) {
		ageMth=ageMth-1
	}
	if (ageMth<0) {
		ageMth=ageMth+12
		ageYear=ageYear-1
	}
	var months=((ageYear*12)+ageMth)
	//alert("inWkDays "+inWkDays+" days "+days+" months "+months+" ageDay"+ageDay+" ageMth "+ageMth+" ageYear "+ageYear)
	if (days<=inDays) {
	 	age=days;
      	unit=t["UnitDays"];
	} else if ((days>inDays)&&(days<=inWkDays)){
		age=weeks;
		unit=t["UnitWeeks"];
	} else if (months<=inMonths) {
		age=months;
		unit=t["UnitMonths"];
	} else {
		age=ageYear;
		unit=t["UnitYears"];
	}
	return (age+"^"+unit);
}

//Log 49660 15-09-2006 Boc: calculate ageFull "Y M D"
function CalculateAgeFull (strDOB) {
   	
   	var strAgeF = "";
	var nDate = new Date();
	var curYear=nDate.getYear()
	var curMth=nDate.getMonth()+1
	var curDay=nDate.getDate()
	//alert (nDate.getDate());
	//var nTime = nDate.getTime(); // current time
	if (curYear < 100) curYear += 1900;
	var nTime = Date.UTC(curYear, curMth-1, curDay); // current time (UTC)
	if (yr < 100) yr += 1900;
	var arrDate = DateStringToArray(strDOB);
	var yr = arrDate["yr"];
	//Log 57142 PeterC 18/01/06
 	if(TK_dtformat=="THAI") yr=yr-543;
	var mn = arrDate["mn"];
	var dy = arrDate["dy"];
	var dTime = Date.UTC(yr, mn-1, dy); // specified time (UTC)
	//var days=Math.floor((nTime-dTime)/ DAY)
    	var bTime = Math.abs(nTime - dTime)  // time difference
	var days=Math.floor(bTime / DAY )
	var weeks=Math.floor(bTime / WEEK )
	var year=Math.round(days/365)
	
	//alert(daysInMonth("02","2004"))
	
	var daysInPreviousMonth=daysInMonth(nDate.getMonth()-1,curYear)
	
	var inWkDays=inWeeks*7
	var ageDay=curDay-dy
	var ageMth=curMth-mn
	var ageYear=curYear-yr
	if (ageDay<0) {
		ageDay=ageDay+daysInPreviousMonth
		ageMth=ageMth-1
	}
	if (ageMth<0) {
		ageMth=ageMth+12
		ageYear=ageYear-1
	}
	var dateForm = t['AgeFullTrans'].split(",");
	if ((dateForm)&&(dateForm.length>=3)) return (ageYear+dateForm[0]+" "+ageMth+dateForm[1]+" "+ageDay+dateForm[2]);
 	//alert (ageYear+"/"+ageMth+"/"+ageDay);
}


function daysInMonth(month,year) {
	var dd = new Date(year, month, 0);
	return dd.getDate();
}

function CalculateDOB(age) {
 	var strDOB = "";
 	var today = new Date();
 	var yr = today.getYear();
	if (dtformat=="THAI") yr=yr+543;
 	if (yr < 1900) yr +=1900;
 	yr -= age;
 	switch (dtformat) {
  		case "YMD":
   		strDOB = "" + yr + dtseparator + "1" + dtseparator + "1";
   		break;
  		case "MDY":
   		strDOB = "" + "1" + dtseparator + "1" + dtseparator + yr;;
   		break;
  		default:
   		strDOB = "" + "1" + dtseparator + "1" + dtseparator + yr;
   		break;
 	}
 	return strDOB;
}

function ExcessiveDOB(strDate) {
    	var objAgeU=document.getElementById("AgeUnits");
 	var arrDate = DateStringToArray(strDate);
	var msg="";
	if (arrDate["yr"] < EXCESSIVEYEAR) {
		msg += t['PAPERDob'] + t['XINVALID'] + "\n";
	} else {
	 	var dtEntered = new Date(arrDate["yr"], arrDate["mn"]-1, arrDate["dy"]);
 		var dtNow = new Date();
		//SB 08/07/02 (25850): Need to add 543 yrs if THAI date.
		if (dtformat=="THAI") dtNow.setYear(dtNow.getFullYear()+543);
 		if (dtEntered > dtNow) {
			msg += t['PAPERDob'] + t["FutureAge"];
            	if (objAgeU) objAgeU.innerText="";
		}
	}
	return msg;
}

function NegativeAge(strAge) {
 	if (!isNaN(strAge)) {
	  	return (parseInt(strAge,10) < 0);
 	}
 	return false;
}

// ------------------------------------

function ValidateUpdate(evt) {
	var isvalid=true;
	var msg=""
	var eSrc=websys_getSrcElement(evt);
	//when shortcut key is used after changing name without tabbing out
	switch (eSrc.id) {
		case "PAPERName":
		case "PAPERName2":
		case "PAPERName3":
			setAlias(evt);
			break;
		default: //do nothing
			break;
	}
	//if (!isEmail("PAPEREmail")) isvalid=false;
 	//Calulates DOB if an age is entered
	var objAge = document.getElementById('PAPERAge');
	var objAge2 = document.getElementById('AgeDynamic');
	var objDob = document.getElementById('PAPERDob');
	var objAge2U=document.getElementById('AgeUnits');
	if ((objDob)&&(objDob.value!="")) {
		if (!isNaN(objDob.value)) objDob.value=IsValidDate(objDob);
		if (ExcessiveDOB(objDob.value)) isvalid=false;
	}
 	if ((objDob)&&(objDob.value=="")&&(objAge)&&(objAge.value!="")) {
  		if (!isNaN(objAge.value)) {
   			objDob.value = CalculateDOB(parseInt(objAge.value,10));
  		}
 	}
    	if ((objDob)&&(objDob.value=="")&&(objAge2)&&(objAge2.value!="")&&(objAge2U)&&(objAge2U.innerText==t["UnitYears"])) {
  		if (!isNaN(objAge2.value)) {
   			objDob.value = CalculateDOB(parseInt(objAge2.value,10));

  		}
 	}
		
 	return isvalid;
}

function Name5LookupSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById("PAPERName")
	if (obj) obj.value = lu[2];
 	var obj=document.getElementById("PAPERName5")
	if (obj) obj.value = lu[0];
}
function Name6LookupSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById("PAPERName2")
	if (obj) obj.value = lu[2];
 	var obj=document.getElementById("PAPERName6")
	if (obj) obj.value = lu[0];
}
function Name7LookupSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById("PAPERName3")
	if (obj) obj.value = lu[2];
 	var obj=document.getElementById("PAPERName7")
	if (obj) obj.value = lu[0];
	}
function Name8LookupSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById("PAPERName4")
	if (obj) obj.value = lu[2];
 	var obj=document.getElementById("PAPERName8")
	if (obj) obj.value = lu[0];
}
	
function PrintLabelUpdate() {
	var frm=document.forms['fPAPerson_Edit'];
	var objName = document.getElementById('PAPERName');
	var objSex = document.getElementById('CTSEXDesc');
	var msg = "";
	if (!objName) {
		msg += "\'" + t['PAPERName'] + "\' " + t['LayoutRequired'] + "\n";
	} else if (objName.value=="") {
		msg += "\'" + t['PAPERName'] + "\' " + t['XMISSING'] + "\n";
	}
	if (!objSex) {
		msg += "\'" + t['CTSEXDesc'] + "\' " + t['LayoutRequired'] + "\n";
	} else if (objSex.value=="") {
		msg += "\'" + t['CTSEXDesc'] + "\' " + t['XMISSING'] + "\n";
	}
	if (msg!="") {
		alert(msg);
		return false;
	}
	frm.TEVENT.value='d49iprintLabel';
	frm.submit();
	return false;
}

// ------------------------------------
// Geographic Information

function CityLookupSelect(str) {
       //alert(str);
	//CityChangeHandler();
	//zipcode^suburb^state^address^region
	var lu = str.split("^");
	var obj=document.getElementById("CTZIPCode")
	if (obj) obj.value = lu[0];
 	var obj1=document.getElementById("CTCITDesc")
	if (obj1) obj1.value = lu[1];
	var obj=document.getElementById("PROVDesc")
	if (obj) obj.value = lu[2];
	var obj=document.getElementById("CTRGDesc")
	if (obj) obj.value = lu[4];
	// CJB 13/09/2002 - 28533: When you pick a suburb from lookup, the suburb overwrites address
	//var obj=document.getElementById("PAPERStNameLine1")
	//JW:removed - why is this here?
	//var obj=document.getElementById("PAPERForeignAddress");
	//if ((obj)&&(lu[4])) obj.value = lu[4];
	var obj=document.getElementById("HCADesc")
	if (obj) obj.value = lu[6];
	CTCITDescAndCTZIPCode_BlurHandler2(obj1);

}

function CityAreaLookupSelect(str) {
 	var lu = str.split("^");
	var obj=document.getElementById("CTCITDesc")
	if (obj) obj.value = lu[0];
 	obj=document.getElementById("CTZIPCode")
	if (obj) obj.value = lu[1];
 	obj=document.getElementById("CITAREADesc")
	if (obj) obj.value = lu[2];
 	obj=document.getElementById("PROVDesc")
	if (obj) obj.value = lu[3];
}

function ZipLookupSelect(str) {
	//CityChangeHandler();
	//zipcode^suburb^state^address
 	var lu = str.split("^");
	var obj1=document.getElementById("CTZIPCode")
	if (obj1) obj1.value = lu[0];
 	var obj=document.getElementById("CTCITDesc")
	if (obj) obj.value = lu[1];
	var obj=document.getElementById("PROVDesc")
	if (obj) obj.value = lu[2];
	var obj=document.getElementById("CITAREADesc")
	if (obj) obj.value = lu[3];
	var obj=document.getElementById("CTRGDesc")
	if (obj) obj.value = lu[4];
	var obj=document.getElementById("HCADesc")
	if (obj) obj.value = lu[6];
	CTCITDescAndCTZIPCode_BlurHandler2(obj1)
}

function CityDescLookupSelect(str) {
	//code,descn,prov,cit,cityarea,hca,region
	//alert(str);
 	var lu = str.split("^");
	var obj=document.getElementById("CTZIPDesc")
	if (obj) obj.value = lu[1];
 	var obj1=document.getElementById("CTZIPCode")
	if (obj1) obj1.value = lu[0];
	var obj1=document.getElementById("CTCITDesc")
	if (obj1) obj1.value = lu[3];
	var obj=document.getElementById("PROVDesc")
	if (obj) obj.value = lu[2];
	var obj=document.getElementById("CITAREADesc")
	if (obj) obj.value = lu[4];
	var obj=document.getElementById("CTRGDesc")
	if (obj) obj.value = lu[6];
	//var obj=document.getElementById("HCADesc")
	//if (obj) obj.value = lu[5];
	//CTCITDescAndCTZIPCode_BlurHandler2(obj1)

}

function NOKZipLookupSelect(str) {
 	var lu = str.split("^");
	var obj;
 	obj=document.getElementById("NOKCTZIPCode")
	if (obj) obj.value = lu[0];
 	obj=document.getElementById("NokCTCITDesc")
	if (obj) obj.value = lu[1];
	//obj=document.getElementById("PROVDesc")
	//if (obj) obj.value = lu[2];
}

function ProvinceLookupSelect(str) {
 	var lu = str.split("^");
	var obj=document.getElementById("PROVDesc")
	if (obj) obj.value = lu[0];
	
	CTCITDescAndCTZIPCode_BlurHandler2(obj);
}

function CTCITDescAndCTZIPCode_BlurHandler2(obj) {
	eSrc=obj;
	
	if (eSrc.defaultValue!="") {
		if (!AskedForSaveAddress) {
			if ((eSrc.value!=eSrc.defaultValue)&&(eSrc.value!="")) {
				AskedForSaveAddress=1;
				registeringAddressChange();
			}
		}
	}
	if ((obj)&&(obj.id!="PROVDesc")) { CheckOverseas();}
}

function convertAddress(e) {  //extended function in CUSTOMS
	if ((e)&&(e.id)) var obj=e
	else var obj=websys_getSrcElement(e);
	
	var obj=websys_getSrcElement(e);
	var obj1=document.getElementById("PAPERStNameLine1");
	var obj2=document.getElementById("CTCITDesc");
	var obj3=document.getElementById("CTZIPCode");
	if (((obj1)&&(obj1.defaultValue!=""))||((obj2)&&(obj2.defaultValue!=""))||((obj3)&&(obj3.defaultValue!=""))) {
		if (!AskedForSaveAddress) {
			if (obj.value!=obj.defaultValue) {
				AskedForSaveAddress=1;
				registeringAddressChange();
			}
		}
	}
}

function convertDoc(e) {
	var obj=websys_getSrcElement(e);
	if (obj.defaultValue!="") {
		if (obj.defaultValue!="")	{
		if (!AskedForSaveDoc) {
			if (obj.value!=obj.defaultValue) {
				AskedForSaveDoc=1;
				registeringDocChange();
				}
			}
		}
	}
}


// ------------------------------------
// Referral Doctor

	//structure as on 18/07/2003
	//(DocTitle,DocDesc,DocMname,DocFname,refdId,DocCode,DocSpec,ClinCode,clinId,ClinProvNo,ClinAddr,ClinSuburb,tele,clindatefrom,clindateto,expired,type,ClinDesc,ClinCity,ClinZip)
	// 0       ,1      ,2       ,3       ,4     ,5 	    ,6      ,7       ,8     ,9         ,10      ,11        ,12  ,13          ,14        ,15     ,16  ,17      ,18      ,19
	//MD 18/07/2003
	//structrure as on 29/04/2004
	//(DocTitle,DocDesc,DocMname,DocFname,refdId,DocCode,DocSpec,ClinCode,clinId,ClinProvNo,ClinAddr,ClinSuburb,tele,clindatefrom,clindateto,expired,type,ClinDesc,ClinCity,ClinZip,DoctorProvNo,DocZip,DocHCA)
	// 0       ,1      ,2       ,3       ,4     ,5 	    ,6      ,7       ,8     ,9         ,10      ,11        ,12  ,13          ,14        ,15     ,16  ,17      ,18      ,19,	     20,	     ,21   ,22		
function ViewFamilyDrLookUp(str) {
	//alert(str);
	var lu = str.split("^");
	var fulladdress="";
	// cjb 03/02/2005 49474 - fulladdress now returned from the query
	if (lu[29]!="") {fulladdress=lu[29];}
	if (fulladdress=="") {
		if (lu[17]!="") {fulladdress=lu[17];}
		if (lu[10]!="") {fulladdress=fulladdress+","+lu[10];}
		if (lu[18]!="") {fulladdress=fulladdress+","+lu[18];}	
		if (lu[19]!="") {fulladdress=fulladdress+","+lu[19];}
	}
	var obj;
	obj=document.getElementById("GPCode");
	if (obj) obj.value = lu[5];
	var obj1=document.getElementById("REFDDesc");
	if (obj1) obj1.value = lu[1];
	obj=document.getElementById("DoctorCode");
	if (obj) obj.value = lu[4];
 	obj=document.getElementById("CLNCode");
	if (obj) obj.value = lu[7];
	obj=document.getElementById("CLNAddress1");
	//if (obj) obj.value = lu[10];
	if (obj) obj.value = fulladdress;
	obj=document.getElementById("PAPERFamilyDoctorClinicDR");
	if (obj) obj.value = lu[8];
	obj=document.getElementById("CLNPhone");
	if (obj) obj.value = lu[12];
	//md 29/01/2003
	obj=document.getElementById("REFDTitle");
	if (obj) obj.value = lu[0];
 	obj=document.getElementById("REFDForename");
	if (obj) obj.value = lu[3];
 	obj=document.getElementById("ClinDesc");
	if (obj) obj.value = lu[17];
 	obj=document.getElementById("ClinCity");
	if (obj) obj.value = lu[18];
 	obj=document.getElementById("ClinZip");
	if (obj) obj.value = lu[19];
	
	obj=document.getElementById("GPHCADesc");
	if (obj) obj.value = lu[22];
	if (lu[15]=="Y") setTimeout('alert(\''+t['ExpiredRefDoctor']+'\')',50);
	//md 16/05/2003 do not show confirmation for docchanging if multy active GP 
	//obj=document.getElementById("MultiActiveGP");
	//if (((obj)&&(obj.value!="Y"))||(!obj))
	//{
	//confirmChangeDoc()
	//}	
	confirmChangeDoc();
}

//md 30/-1/2003
function InternalDrChangeHandler(e) {
	// clear the ref doctor address fields if blank.
	var obj=document.getElementById("REFDDesc");
	if ((obj)&&(obj.value=="")) {
		obj=document.getElementById("GPCode")
		if (obj) obj.value ="";
		obj=document.getElementById("DoctorCode");
		if (obj) obj.value ="";
 		obj=document.getElementById("CLNCode");
		if (obj) obj.value ="";
 		obj=document.getElementById("CLNAddress1");
		if (obj) obj.value =""; 
		obj=document.getElementById("PAPERFamilyDoctorClinicDR");
		if (obj) obj.value ="";
		obj=document.getElementById("CLNPhone");
		if (obj) obj.value ="";
		obj=document.getElementById("REFDTitle");
		if (obj) obj.value ="";
 		obj=document.getElementById("REFDForename");
		if (obj) obj.value = "";
		//md 16/10/2003
		obj=document.getElementById("ClinDesc");
		if (obj) obj.value = "";
		obj=document.getElementById("ClinCity");
		if (obj) obj.value = "";
		obj=document.getElementById("ClinZip");
		if (obj) obj.value = "";
		//md 29.04.2004
		obj=document.getElementById("GPHCADesc");
		if (obj) obj.value ="";
	}

}

//md 30/-1/2003
// cjb 25/05/2005 52367 - copied to PAAdm.EditEmergency.js.  Make sure any future changes are aplied to both
function confirmChangeDoc() {
	// ab 17.10.02 - to confirm saving old doctor
	var obj=document.getElementById("REFDDesc")
	var objmagp=document.getElementById("MultiActiveGP");
	var objDrId=document.getElementById("doctorCode");
	var objClinId=document.getElementById("PAPERFamilyDoctorClinicDR");
	
	// cjb 23/05/2005 52370 - ask the question if the Dr or Clinic RowId's have changed (previously only checked the Dr Surname...)
	if ((obj)&&(obj.value!="")   && (((objDrId.value!=objDrId.defaultValue)&&(objDrId.defaultValue!=""))||((objClinId.value!=objClinId.defaultValue)&&(objClinId.defaultValue!="")))  ) {
		if (((objmagp)&&(objmagp.value!="Y"))||(!objmagp)) {
			if (!AskedForSaveDoc) {
			//if ((!AskedForSaveDoc)&&(obj.defaultValue!="")) {
				//if (obj.value!=obj.defaultValue) {
					AskedForSaveDoc=1;
					registeringDocChange();
				//}
			}
		}
		if ((objmagp)&&(objmagp.value=="Y")) {
			if (!AskedForActiveDoc) {
			//if ((!AskedForActiveDoc)&&(obj.defaultValue!="")) {
				//if (obj.value!=obj.defaultValue) {
					AskedForActiveDoc=1;
					registeringDocActiveChange();
				//}
			}
		}
	}
}

function registeringDocChange() {
	if (PatientID!="") {
		document.focus();
		if (confirm(t["SaveDoc"])) {
			document.getElementById("DoctorChanged").value=1;
		} else {
			document.getElementById("DoctorChanged").value=0;
		}
	}
}

//md 15/07/2003 confim box for Keep Active GP 
function registeringDocActiveChange() {
	if (PatientID!="") {
		document.focus();
		//if (!confirm(t["KeepActiveGP"])) {
		//	websys_createWindow('pafamdoctoractive.csp?PatientID='+PatientID,'TRAK_hidden','');
		//}
		if (confirm(t["KeepActiveGP"])) {
			document.getElementById("KeepActiveGP").value=1;
		} else {
			document.getElementById("KeepActiveGP").value=0;
		}
	}

}


/*	LOG 23929 BC 29-APR-2002 Adding a family Dentist*/
function DentLookUp(str) {
	FamDentChangeHandler
 	var lu = str.split("^");
	var obj;
	obj=document.getElementById("DentREFDCode")
	if (obj) obj.value = lu[5];
	obj=document.getElementById("DentREFDDesc")
	if (obj) obj.value = lu[1];
	obj=document.getElementById("dentCode");
	if (obj) obj.value = lu[4];
 	obj=document.getElementById("DentCLNCode");
	if (obj) obj.value = lu[7];
	obj=document.getElementById("PAPMIDentistClinicDR");
	if (obj) obj.value = lu[8];
	obj=document.getElementById("DentCLNPhone");
	if (obj) obj.value = lu[12];
	
	var fulladdress=""
	// cjb 03/02/2005 49474 - fulladdress now returned from the query
	if (lu[29]!="") {fulladdress=lu[29];}
	
	if (fulladdress=="") {
		if (lu[17]!="") {fulladdress=lu[17];}
		if (lu[10]!="") {fulladdress=fulladdress+","+lu[10];}
		if (lu[18]!="") {fulladdress=fulladdress+","+lu[18];}	
		if (lu[19]!="") {fulladdress=fulladdress+","+lu[19];}
		
	}
 	obj=document.getElementById("DentCLNAddress1");
	if (obj) obj.value = fulladdress;
	
	
	//if (lu[11]=="Y") alert(t['ExpiredRefDentist']);
	if (lu[11]=="Y") setTimeout('alert(\''+t['ExpiredRefDentist']+'\')',50);

}

/*	LOG 23929 BC 29-APR-2002 Adding a family Dentist*/
function FamDentChangeHandler(e) {
	var obj;
	obj=document.getElementById("PAPMIDentistClinicDR")
	if (obj) obj.value = "";
	obj=document.getElementById('DentCLNAddress1')
	if (obj) obj.value = "";
	obj=document.getElementById('DentCLNCode')
	if (obj) obj.value = "";
	obj=document.getElementById('DentCLNPhone')
	if (obj) obj.value = "";
}

// cjb 19/08/2005 54775
function DentREFDDescBlurHandler(e) {
	// clear the dentist address fields if blank.
	var obj=document.getElementById("DentREFDDesc");
	if ((obj)&&(obj.value=="")) {
		obj=document.getElementById("DentREFDCode")
		if (obj) obj.value ="";
		obj=document.getElementById("DentCLNCode");
		if (obj) obj.value ="";
 		obj=document.getElementById("DentCLNAddress1");
		if (obj) obj.value ="";
 		obj=document.getElementById("dentCode");
		if (obj) obj.value =""; 
		obj=document.getElementById("DentCLNPhone");
		if (obj) obj.value ="";
		obj=document.getElementById("PAPMIDentistClinicDR");
		if (obj) obj.value ="";
	}
}


/*	LOG 23929 BC 29-APR-2002 Adding a family Dentist*/
function ViewDentistHandler(e) {
	var obj=websys_getSrcElement(e)
	var objid=document.getElementById("dentCode")
	var view=document.getElementById("viewDent")
	//BR 22/08 37903 - Need to pass PatientID so we can show patient banner
	var patid=document.getElementById("PatientID")
	var CONTEXT=session["CONTEXT"]
	var epid=document.getElementById("EpisodeID")
	view.value="1"
	//BR 22/08 37903 - Need to show patient banner on PACRefDoctor.Edit.
	//var url="websys.default.csp?WEBSYS.TCOMPONENT=PACRefDoctor.Edit&ID="+objid.value+"&viewDr="+view.value+"&CONTEXT="+CONTEXT+"&PatientID="+patid.value+"&PatientBanner=1"
	var url="websys.default.csp?WEBSYS.TCOMPONENT=PACRefDoctor.Edit&ID="+objid.value+"&viewDr="+view.value+"&CONTEXT="+CONTEXT+"&PatientID="+patid.value+"&EpisodeID="+epid.value+"&PatientBanner=1"
	websys_lu(url,false,"width=550,height=650,top=10,left=10")
	return false;
}


function ViewDoctorHandler(e) {
	var obj=websys_getSrcElement(e)
	var objid=document.getElementById("doctorCode")
	var view=document.getElementById("viewDr")
	var cliniccode=document.getElementById("CLNCode")
	//BR 22/08 37903 - Need to pass PatientID so we can show patient banner
	var patid=document.getElementById("PatientID")
	var CONTEXT=session["CONTEXT"]
	var epid=document.getElementById("EpisodeID")
	view.value="1"
	//BR 22/08 37903 - Need to show patient banner on PACRefDoctor.Edit.
	//var url="websys.default.csp?WEBSYS.TCOMPONENT=PACRefDoctor.Edit&ID="+objid.value+"&viewDr="+view.value+"&Clincode="+cliniccode.value+"&CONTEXT="+CONTEXT+"&PatientID="+patid.value+"&PatientBanner=1"
	var url="websys.default.csp?WEBSYS.TCOMPONENT=PACRefDoctor.Edit&ID="+objid.value+"&viewDr="+view.value+"&Clincode="+cliniccode.value+"&CONTEXT="+CONTEXT+"&PatientID="+patid.value+"&EpisodeID="+epid.value+"&PatientBanner=1"
	websys_lu(url,false,"width=550,height=650,top=10,left=10")
	return false;
}

function FamDocChangeHandler(e) {
	var obj;
	obj=document.getElementById("PAPERFamilyDoctorClinicDR")
	if (obj) obj.value = "";
	obj=document.getElementById('CLNAddress1')
	if (obj) obj.value = "";
	obj=document.getElementById('CLNCode')
	if (obj) obj.value = "";
	obj=document.getElementById('CLNPhone')
	if (obj) obj.value = "";
	obj=document.getElementById("REFDDesc");
	if ((obj)&&(obj.value=="")) convertDoc();
}


// ------------------------------------
// Payor/plan

function PayorSetHandler(str) {
 	var lu = str.split("^");
	var obj1=document.getElementById('INSTDesc')
	if (obj1) obj1.value=lu[0];

	var obj2=document.getElementById('AUXITDesc')
	if (obj2) obj2.value="";
	//md 02/06/2003
	if ((obj1)&&(obj1.value!=obj1.defaultValue)) {
		var obj3=document.getElementById('PayorChanged')
		if (obj3) obj3.value=1;
		//log 54405
		//md 09/2003
		//md 44104 no longer needed
		//checkHealthFund();
	}	
	//md Log 54405 
	ReplaceHiddenCodeGlobal(4,lu[2],"");
}

function PlanSetHandler(str) {
 	var lu = str.split("^");
	var obj=document.getElementById('INSTDesc')
	if (obj) obj.value=lu[1];

	var obj=document.getElementById('AUXITDesc')
	if (obj) obj.value=lu[0];

}


//CALL CUSTOM LOOKUPS
function suffixLookUp(str) {
        
	try {
		Custom_suffixLookup(str);
	} catch(e) { 
		}	finally  {
	}
	
}
function PREFLDescLookUp(str) {
	var lu = str.split("^");
	var objPREFLDesc=document.getElementById("PREFLDesc");
	if (objPREFLDesc) { objPREFLDesc.value=lu[0]; }	
	ReplaceHiddenCodeGlobal(3,lu[2],lu[3]);
	try {
		Custom_PREFLDescLookUp(str);
	} catch(e) { 
		}	finally  {
	}
}


function InterpreterReqLookUp(str) {
	try {
		Custom_InterpreterReqLookUp(str);
	} catch(e) { 
		}	finally  {
	}
}
//md 44104 no longer needed
//function checkHealthFund(str) {
//	try {
//		Custom_checkHealthFund(str);
//	} catch(e) { 
//		}	finally  {
//	}
//}
function CheckOverseas(str) {
	try {
		Custom_CheckOverseas(str);
	} catch(e) { 
		}	finally  {
	}
}
function CTMARDescLookupSelect(str) {
	var lu = str.split("^");
	var objCTMARDesc=document.getElementById("CTMARDesc");
	if (objCTMARDesc) { objCTMARDesc.value=lu[0]; }
	ReplaceHiddenCodeGlobal(1,lu[2],lu[3]);
	try {
		Custom_CTMARDescLookupSelect(str);
	} catch(e) { 
		}	finally  {
	}
}
function DVACardTypeLookup(str) {
	try {
		Custom_DVACardTypeLookup(str);
	} catch(e) { 
		}	finally  {
	}
}
function PENSTYPEDescLookupSelect(str) {
	try {
		Custom_PENSTYPEDescLookupSelect(str);
	} catch(e) { 
		}	finally  {
	}
}
function CBirthSelect(str) {
	try {
		Custom_CBirthSelect(str);
	} catch(e) { 
		}	finally  {
	}
}
function EthnicSelect(str) {
	var lu = str.split("^");
	var objINDSTDesc=document.getElementById("INDSTDesc");
	if (objINDSTDesc) { objINDSTDesc.value=lu[0]; }
	ReplaceHiddenCodeGlobal(0,lu[2],lu[3]);
	try {
		Custom_EthnicSelect(str);
	} catch(e) { 
		}	finally  {
	}
}
function ASSISelect(str) {
	var lu = str.split("^");
	var objASSISDesc=document.getElementById("ASSISDesc");
	if (objASSISDesc) { objASSISDesc.value=lu[0]; }	
	ReplaceHiddenCodeGlobal(2,lu[2],lu[3]);
	try {
		Custom_ASSISelect(str);
	} catch(e) { 
		}	finally  {
	}
}

function CityBirthLookupSelect(str) {
	try {
		Custom_CityBirthLookupSelect(str);
	} catch(e) { 
		}	finally  {
	}
}

function FeedBackConsentSelect(str) {
	try {
		Custom_FeedBackConsentSelect(str);
	} catch(e) { 
		}	finally  {
	}
}

function SexLookUp(str) {
	/*
	if (confirmAlias=="Y") {
		SexChangeHandler();
	}
       */
	var lu = str.split("^");
	//alert(lu[3]);
	var objSEXG=document.getElementById('HiddenSexG');
	if (objSEXG) { objSEXG.value=lu[3]; }
	
	if (confirmAlias=="Y")
	{
		SexChangeHandler();
	}
	
	try {
		Custom_SexLookUp(str);
	} catch(e) { 
		}	finally  {
	}	
}
function SexChangeHandler() {
	var eSrc= document.getElementById('CTSEXDesc');
	if ((PatientID != "") && (eSrc.defaultValue!= "") && (eSrc.defaultValue != eSrc.value)) {
		if (confirm(t['SexChange'])) {
			websys_createWindow('paperson.aliasname.update.csp?PatientID='+PatientID+'&ComponentItemName='+eSrc.id+'&DefaultValue='+eSrc.defaultValue,'TRAK_hidden','');
		}
	}	
}

function registeringAddressChange() {
	//PAPERStNameLine1 and PAPERForeignAddress: called from onchange event in CUSTOM SCRIPTS.
	//CTCITDesc,CTZIPCode,PROVDesc: called from LookUp Handler events (as onchange events already exists in SCRIPTS_GEN)
	if (confirmAddress=="Y") document.getElementById("AddressChange").value=1
	if (document.getElementById("AddressChange").value==0 && PatientID!="") {
		document.focus();
		if (confirm(t["SAVEADDR"])) document.getElementById("AddressChange").value=1;
	}
}

// ab 37091 - pseudo-datefield handler - used by both dva and pension card expiry fields
function ExpiryBlurHandler(e) {
	var obj=websys_getSrcElement(e);
	if (obj) {
		var valid=IsValidDate(obj);
		if (!valid) {
			obj.className="clsInvalid";
			alert("\'" + t[obj.id] + "\' " + t['XDATE']);
			websys_setfocus(obj.id);
			return websys_cancel();
		} else {
			obj.className="";
		}
	}
}

function MRTypeQuestion(descs,ids) {
	var arrhosp=descs.split('^'); var arrid=ids.split('^');
	for (var i=0; i<arrhosp.length; i++) {
		if ((arrhosp[i]!="")&&(arrid[i]!="")) {
			if (confirm(t["ConfirmMRType"]+arrhosp[i]+'?')) {
				AddMRType(arrid[i])
			}
		}
	}
	var frm=document.forms['fPAPerson_Edit'];frm.TOVERRIDE.value='1';
}

function AddMRType(type) {
	
	var string=document.getElementById("MRTypeString");
	if (string) string.value=string.value+"^"+type
	
}

//md 26/09/2003
//long string=SURNAME_FIRSTNAME_OTHERNAME
function CreateFullName(evt) {
	var sname=""
	var fname=""
	var oname=""
	var eSrc = websys_getSrcElement(evt);
	var surname=document.getElementById('PAPERName');
	//if (surname) {sname=surname.value;}
	if (surname) {sname=surname.defaultValue;}
	var forname=document.getElementById('PAPERName2');
	//if (forname) {fname=forname.value;}
	if (forname) {fname=forname.defaultValue;}
	var othername=document.getElementById('PAPERName3');
	//if (othername) {oname=othername.value;}
	if (othername) {oname=othername.defaultValue;}
	
	//if (eSrc.id=="PAPERName") { sname=eSrc.defaultValue }
	//else if(eSrc.id=="PAPERName2"){ fname=eSrc.defaultValue }
	//else if (eSrc.id=="PAPERName3"){oname=eSrc.defaultValue }
	//alert(sname+"_"+fname+"_"+oname);
	var fullname=sname+"_"+fname+"_"+oname
	
	return fullname;
}

//md 02/12/2003 Log 41090 function created to compare date of birth with deceased date
//and to compare deceased date with patient last discharge date(if exist)
function ValidateDeceased(e) {
	
	var objBorn=document.getElementById('PAPERDob');
	var objDied=document.getElementById('PAPERDeceasedDate');
	var objDischarged=document.getElementById('lastdischargedate');
	var b;
	var objmsg=""
	try {objmsg=CheckDischaregeforDeceased(e)} catch(e) {}
	if ((objBorn)&&(objDied)&&(objBorn.value!="")&&(objDied.value!="")&&(DateStringCompare(objBorn.value,objDied.value)=="1")) {
		objmsg +=t['DOBafterDeceased'] + "\n";
		objDied.className="clsInvalid";
		//return false;
	}
	/* md  21.06.2005 moved to custom QH functionality as per log 52668
	if ((objDied)&&(objDischarged)&&(objDied.value!="")&&(objDischarged.value!="")&&(DateStringCompare(objDischarged.value,objDied.value)=="1"))
	{
	if (objmsg!="") {objmsg +=t['DeceasedBeforeDischarged'] + objDischarged.value;}
	if (objmsg=="") {objmsg=t['DeceasedBeforeDischarged'] + objDischarged.value ;}
	objDied.className="clsInvalid";
	//return false;
	}
	*/
	if (objmsg!="") {
		alert(objmsg);
		return false;
	}
	if (objDied) objDied.className="";
	return true;
}

function setLinks() {
	var obj=document.getElementById('hiddenLinks');
	if (obj) obj.value="0";
	if (PatientID=="") {
		if (obj) obj.value="1";
			
		var obj=document.getElementById('ContactPerson');
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}
		var obj=document.getElementById('OtherAddresses');
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}
		var obj=document.getElementById('Alias');
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}
		var obj=document.getElementById('PAAlert');
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}
		var obj=document.getElementById('MRNumber');
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}
		var obj=document.getElementById('Allergies');
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}

		var obj=document.getElementById('AuditTrailData');
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}
		var obj=document.getElementById('AuditTrailLog');
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}
		var obj=document.getElementById('PAPERInsuranceLink');
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}
		var obj=document.getElementById('Exemptions');
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}
		var obj=document.getElementById('FamilyLink');
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}
		var obj=document.getElementById('OrganDonor');
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}
		var obj=document.getElementById('CareProviders');
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}
		var obj=document.getElementById('FamDocHist');
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}
		var obj=document.getElementById('FamDentHist');
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}
		var obj=document.getElementById('ALGEMRLink');
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}
		var obj=document.getElementById('InsuranceDetails');
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}
		var obj=document.getElementById('MRPsychDetails');
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}
		var obj=document.getElementById("EmployeeDetails");
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}
		var obj=document.getElementById("Photo");		// cjb 14/03/2006 48939
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}
		// 62102
		var obj=document.getElementById("TreatmentProgress");
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}
	}
}

function setCheckBoxFlag() {
	var str=new Array()
	var IsOnForm=document.getElementById('HiddenCheckbox')
	var obj=document.getElementById('PAPERNOKInformed')
	if (obj) { str[0]="Y" } 
	var obj=document.getElementById('PAPERProcuratorFiscalInformed')
	if (obj) { str[1]="Y" } 
	var obj=document.getElementById('PAPERPrevHACCEligible')
	if (obj) { str[2]="Y" } 
	if (IsOnForm) IsOnForm.value=str.join("^")
	
}


//md 4th Of July 2005 LOG 53687
function HiddenGCodeBlurHandler() {

	var fields= new Array("INDSTDesc","CTMARDesc","ASSISDesc","PREFLDesc")
	for (var i=0;i<fields.length;i++) {
		obj=document.getElementById(fields[i]);
		if (obj) obj.onblur=GCodeBhangler;
	}
}

function GCodeBhangler(e) {
	var eSrc=websys_getSrcElement(e);	
	if (eSrc) {
		var obj=document.getElementById(eSrc.id);
		if ((obj)&&(obj.value=="")) {
			switch(eSrc.id) {
				case "INDSTDesc":   ReplaceHiddenCodeGlobal(0,"",""); break
				case "CTMARDesc":   ReplaceHiddenCodeGlobal(1,"",""); break
				case "ASSISDesc":   ReplaceHiddenCodeGlobal(2,"",""); break
				case "PREFLDesc":   ReplaceHiddenCodeGlobal(3,"","");; break
				default :   alert("You have not submitted this form properly\n" +
					"Please fill the form again and retry ERROR: "+eSrc.id);        
			}
		}
	}	
}

function ReplaceHiddenCodeGlobal(piece,val1,val2) {
	var obj=document.getElementById('HiddenCodes');
	if (obj) {
		var hiddenCodes=obj.value.split("^");
		var vsarray=new Array();
		vsarray[0]=val1;
		vsarray[1]=val2;
		var vts=vsarray.join("||");
		hiddenCodes[piece]=vts;
		obj.value=hiddenCodes.join("^");
		//alert("piece="+piece+" hidden value="+obj.value);
	}
}
//md 4th Of July 2005

document.body.onload=DocumentLoadHandler;

//md 29.04.2003 based on TN advise
//md 01.04.2004 reenable this cause it is called from custom scripts (see log 43255)
//JW: removed - again....
/*function SplitDateStr(strDate) {
	return DateStringToArray(strDate);
} */
//--------------------------------------------------------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------------------------------------------------------------------
//JW FUNCTIONS REMOVED

	//JW:set restriction on lookup for referral doctor - should be done in custom script per site
	//var restrictGP=document.getElementById("RefDocRestriction");
	//if (restrictGP) restrictGP.value="GP";
	
	//Log 25343  //JW removed
	//var decobj=document.getElementById("Deceased");
	//if ((decobj)&&(decobj.value=="Y")) alert(t['DeceasedPatient']);
	///////////////////////////////////////////////////////////////////////////////////
	/*
	function checkContactDetails() { // redirects to NOK edit/list depending on existing contacts
	var url, objBold;
	var objParRef = document.getElementById('PatientID');
	var objPatID = objParRef;
	var objHLinks = document.getElementById('hiddenLinks');
	var objcon = document.getElementById('ContactPerson');

	objBold=document.getElementById('BoldLinks');
	if (objBold) var BoldLink = objBold.value.split("^");
	if (BoldLink[0]=="1")
	{
		//url="websys.csp?TEVENT=d49iContactPerson&PARREF="+objParRef.value+"&PatientID="+objPatID.value+"&hiddenLinks="+objHLinks.value+"&PatientBanner=1";
		url="panokframe.csp?PARREF="+objParRef.value+"&PatientID="+objPatID.value+"&hiddenLinks="+objHLinks.value+"&PatientBanner=1";

		websys_lu(url,false,"width=720,height=480,top=20,left=30")
		return false;
	}
	else
	{
		url="websys.default.csp?WEBSYS.TCOMPONENT=PANok.Edit&PARREF="+objParRef.value+"&PAPERFlag=1"+"&PatientID="+objPatID.value+"&hiddenLinks="+objHLinks.value+"&PatientBanner=1&FromLink=1";
		websys_lu(url,false,"width=820,height=480,top=20,left=30")
		return false;
	}
}
 */
//////////////////////////////////////////////////////////////////////////////////////////////////
/*

*/
/*
// ab 18.06.02 - calculates the age in years/months/wks/days for dynamic age field
// to do - account for differing amount of days in months, leap years (considerably more complex)
// at the moment this is just assuming a month=30 days, and year=365 days
// (inconsistencies between days & real days since not every month has 30 days)
// SB 08/07/02: This may not work with THAI dates - Age and DOB should work fine though.

/* function CalculateAgeDynamic(strDOB) {
    var unit=""
   	var nDate = new Date();
	var curYear=nDate.getYear()
	var curMth=nDate.getMonth()+1
	var curDay=nDate.getDate()
	//var nTime = nDate.getTime(); // current time 
	if (curYear < 100) curYear += 1900;
	var nTime = Date.UTC(curYear, curMth-1, curDay); // current time (UTC)
 	if (yr < 100) yr += 1900;
 	var arrDate = DateStringToArray(strDOB);
 	var yr = arrDate["yr"];
 	var mn = arrDate["mn"];
 	var dy = arrDate["dy"];
	var dTime = Date.UTC(yr, mn-1, dy); // specified time (UTC)
	var days=Math.floor((nTime-dTime)/ DAY)
    var bTime = Math.abs(nTime - dTime)  // time difference
	//var days=Math.floor(bTime / DAY )
	var weeks=Math.floor(bTime / WEEK )
	var year=Math.round(days/365)
	var inDays=inWeeks*7
	var ageDay=curDay-dy
	var ageMth=curMth-mn
	var ageYear=curYear-yr
	if (ageDay<0) {
		ageMth=ageMth-1
	}
	if (ageMth<0) {
		ageMth=ageMth+12
		ageYear=ageYear-1
	}
	if (ageYear>=inYears) {
      age=ageYear;
      unit=t["UnitYears"];
	  }
	if (ageYear<inYears) {
		var months=((ageYear*12)+ageMth)
		if (months>=inMonths) {
			 age=months;
             unit=t["UnitMonths"];
		}
		if (months<inMonths) {
			if (days<=inDays) {
				  age=days;
      			  unit=t["UnitDays"];
		    }
			if (days>inDays) {
				age=weeks;
      			unit=t["UnitWeeks"];
    		}
		}
	}

 	return (age+"^"+unit);
} 
*/
/*function DateStringToArrayOld(strDate) {
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
*/
//md 29.04.2003 based on TN advise

function SplitDateStr(strDate) {
	return DateStringToArray(strDate);
}

//function suffixLookUp() {
	// a dummy function to allow a custom suffixByLookUp funtion to be used
//}

//function PREFLDescLookUp() {
	// a dummy function to allow a custom PREFLDescLookUp function to be used
//}


//function InterpreterReqLookUp() {
	// a dummy function to allow a custom InterpreterReqLookUp function to be used
//}

//function checkHealthFund() {
	// a dummy function to allow a custom checkHealthFund() function to be used
//}

//function CheckOverseas() {
	// a dummy function to allow a custom CheckOverseas() function to be used 
//}

//function CTMARDescLookupSelect() {
	//dummy
//}

//function DVACardTypeLookup() {
	// a dummy function to allow a custom DVACardTypeLoookup function to be used
	//alert("msd11");
//}

//function PENSTYPEDescLookupSelect() {
	// a dummy function to allow a custom PENSTYPEDescLookupSelect function to be used
	//alert("msd11");
//}

//md 10/11/2003

//function CBirthSelect(str) {		
	// a dummy function to allow a custom CBirthSelect function to be used
//}

//function EthnicSelect(str) {
	// a dummy function to allow a custom EthnicSelect function to be used	
//}

//function ASSISelect(str) {
	// a dummy function to allow a custom ASSISelect function to be used	
//}

//JW:????? removed
/*function CTCITDesc_lookuphandlerCustom() {
	// a dummy function to allow a custom CTCITDesc_lookuphandlerCustom() funtion to be used
}
function PROVDesc_lookuphandlerCustom() {
	// a dummy function to allow a custom PROVDesc_lookuphandlerCustom() funtion to be used
}
function CTZIPCode_lookuphandlerCustom() {
	// a dummy function to allow a custom CTZIPCode_lookuphandlerCustom() funtion to be used
}
*/
/*function DecDrChangeHandler(e) {
	obj=document.getElementById('CTPCPCode')
	if (obj) obj.value = "";
} 
	//obj=document.getElementById('CTPCPDesc');
	//if (obj) obj.onblur = DecDrChangeHandler;
	function DecDrLookUp(str) {
 	var lu = str.split("^");
	var obj;
	obj=document.getElementById('CTPCPDesc')
	if (obj) obj.value = lu[0]
	obj=document.getElementById('CTPCPCode');
	if (obj) obj.value = lu[2];
} */
/*
function PayorChangeHandler() {
	var obj=document.getElementById('AUXITDesc')
	if (obj) obj.value="";

}
function PlanChangeHandler() {
	var obj=document.getElementById('INSTDesc')
	if (obj) obj.value="";

} */

/* JW removed function SexLookUpOut(str) {
	var obj1=document.getElementById("aliasconfirm");
	if ((obj1)&&(obj1.value=="Y"))
	{
	SexChangeHandlerNew();
	}	
}
*/
/*JW:removed
function SexChangeHandlerNew() {
	//var eSrc = websys_getSrcElement(evt);
	var eSrc= document.getElementById('CTSEXDesc');
	//var PatientID = document.getElementById('ID').value;
	//var oldsex = eSrc.defaultValue;
	//var aliasconfim=document.getElementById('aliasconfirm');
	
	if ((PatientID != "") && (oldsex != "") && (oldsex != eSrc.value)) {
		var ComponentItemName=eSrc.id
		if ((aliasconfim)&&(aliasconfim.value=="Y")) {
			if (confirm(t['SexChange'])) {
				eSrc.defaultValue=eSrc.value
				websys_createWindow('paperson.aliasname.update.csp?PatientID='+PatientID+'&ComponentItemName='+ComponentItemName+'&DefaultValue='+oldsex,'TRAK_hidden','');
				}
	      }	
	  }
}
*/
//***********************T O DO*******************************//


// Log 26052 CHF 17/04/2003 Lookup and checkbox for extra fields
function EXREFDGPHandler(e) {
	var obj=websys_getSrcElement(e)
	var type=document.getElementById("EXREFDType")
	var gp=document.getElementById("EXREFDGP")
	if (gp && type) {
		if (gp.checked) 
			type.value="GP";
		else
			type.value="";
	}
}
function EXRefDocLookUp(str) {
 	var lu = str.split("^");
	var obj=document.getElementById("EXREFDDesc")
	if (obj) obj.value = lu[1]
}
//**************** END OF TO DO *********************************************************************

//log 62392 BoC: add handler to follow the system standard
function PAPERDeceasedDateChangeHandler(e) {
		PAPERDeceasedDate_changehandler(e);
}

function PAPERDeceasedTimeChangeHandler(e) {
		PAPERDeceasedTime_changehandler(e);
}

var PAPERDeceasedDateObj=document.getElementById("PAPERDeceasedDate");
if (PAPERDeceasedDateObj) PAPERDeceasedDateObj.onchange=PAPERDeceasedDateChangeHandler;

var PAPERDeceasedTimeObj=document.getElementById("PAPERDeceasedTime");
if (PAPERDeceasedTimeObj) PAPERDeceasedTimeObj.onchange=PAPERDeceasedTimeChangeHandler;