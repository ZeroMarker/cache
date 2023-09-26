//Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var objPasswordChanged=document.getElementById("PasswordChanged");;
var objSSUSRPassword=document.getElementById("SSUSRPassword");
var objConfirmPassword=document.getElementById("ConfirmPassword");
var objID=document.getElementById("ID")
var objSSUSRInitials=document.getElementById("SSUSRInitials");

if (document.getElementById("CareProvRoundEntered")) {document.getElementById("CareProvRoundEntered").tkItemPopulate=1;}

//KK 11/july/02 Log 23316
function BodyLoadHandler() {
	var obj1=document.getElementById("CTPCPSpecialistYN");
	if (obj1) obj1.onchange=specialistYNchange;
	var obj2=document.getElementById("CTPCPLinkDoctorDR");
	if ((obj1)&&(obj1.checked)&&(obj2)) {
		obj2.value="";
		obj2.className = "disabledField";
		obj2.disabled=true;
		var objCTPCPLinkDoctorDR=document.getElementById("ld1436iCTPCPLinkDoctorDR");
		if (objCTPCPLinkDoctorDR) objCTPCPLinkDoctorDR.disabled=true;
	}

	if (objID) {
		if (objID.value=="") {
			//var objPWD=document.getElementById("cSSUSRPassword");
			//if (objPWD) objPWD.className = "clsRequired" ;
			SetValuesOnNew();
		} else {
			// SA 4.3.03 - log 34563: Disable UserID [SSUSRInitials] field
			// for update. UserID can only be set on insert and cannot be modified once saved.
			if (objSSUSRInitials) objSSUSRInitials.disabled=true;
		}
	}

	// SA: Password fields do not autopopulate via %request.Get. Need to default "********"
	// to give the impression that a password has saved and exists. PasswordPreUpdateCheck
	// will determine whether or not the password has changed, and field will only be updated
	// if it has.
	if (objSSUSRPassword) {
		if ((objID)&&(objID.value!="")) objSSUSRPassword.value="********";
		objSSUSRPassword.onchange = PasswordChangeHandler;
		objSSUSRPassword.onblur = PasswordChangeHandler;
		objSSUSRPassword.onkeyup = passwordKeyUpHandler
		if (objConfirmPassword) {
			objConfirmPassword.onchange=PasswordChangeHandler;
			if ((objID)&&(objID.value!="")) objConfirmPassword.value="********";
		} else {
			alert(t['NO_CONFIRM_PWD_FIELD']);
		}
	}

	//KK 15/jul/02 Enable care provider table fields if there is any value in CTCPTDesc field
	var obj=document.getElementById("CTCPTDesc");
	if ((obj) && (obj.value!="")){
		var objDC=document.getElementById("DoctorCheck")
		if (objDC){objDC.checked=true; }
	}
	var objDC=document.getElementById("DoctorCheck")
	if (objDC) objDC.onclick=DoctorCheckOnClickHandler;

	//rqg,log23367: Disable "View Other User Logon Location" link if "New" button was clicked
	var objOtherLogonLoc=document.getElementById("OtherUserLogonLoc")
	var objCPAdd=document.getElementById("CPAdd")
	var objAppt=document.getElementById("Appt")
	//KK L:42422 : Disable "Assign CP to Location" link if "New" button was clicked
	var objAssignCPLoc=document.getElementById("AssignCPLoc");
	if ((objID)&&(objID.value=="")) {
		if (objOtherLogonLoc) objOtherLogonLoc.disabled=true;
		if (objAssignCPLoc) objAssignCPLoc.disabled=true;
		if (objCPAdd) objCPAdd.disabled=true;
		if (objAppt) objAppt.disabled=true;

		//AJI 11.9.03 Log 37591 - External System Code
		var objExtCode=document.getElementById("CareProvExtCode");
		if (objExtCode){
			objExtCode.disabled=true;
			objExtCode.onclick=LinkDisable;
		}
	}

	var objADDREmail=document.getElementById("SSUSREmail");
	if (objADDREmail) objADDREmail.onchange=isEmail;


	DoctorCheckOnClickHandler();
	//if it is a new entry

	var objUpd=document.getElementById("update11")
	if (objUpd) objUpd.onclick=UpdateClickHandler;
	if (tsc['update11']) websys_sckeys[tsc['update11']]=UpdateClickHandler;

	var objUpdAppt=document.getElementById("UpdAppt")
	if (objUpdAppt) objUpdAppt.onclick=UpdateApptClickHandler;

	var objUpdCPAdd=document.getElementById("UpdCPAdd")
	if (objUpdCPAdd) objUpdCPAdd.onclick=UpdateCPAddClickHandler;

	objDel=document.getElementById("DeleteCareProvRound");
	if (objDel) objDel.onclick=CareProvRoundDeleteClickHandler;

	var obj=document.getElementById("SSUSRTimeSinceLastAppt");
	if (obj) obj.onblur=TimeSinceLastApptBlurHandler;

	var obj=document.getElementById("SSUSRHospitalDR");
	if (obj) obj.onblur=HospLocBlurHandler;
	
	var obj=document.getElementById("CTLOCDesc");
	if (obj) obj.onblur=HospLocBlurHandler;

	//SA 2.6.03 - Log 35979
	SetBoldLinks();
	//objSSUSRPassword.value="";
	//objConfirmPassword.value="";
}

function UpdateClickHandler() {
	if (!(PreUpdate())) return false;
	//alert("Pre Update call");
	//return false;
	return update11_click()
}

function UpdateApptClickHandler() {
	if (!(PreUpdate())) return false;
	return UpdAppt_click()
}

function UpdateCPAddClickHandler() {
	if (!(PreUpdate())) return false;
	return UpdCPAdd_click()
}

function PreUpdate() {
	if (!(CareProvFieldsCheck())) return false;
	if (!(PasswordPreUpdateCheck())) return false;
	if (!(CheckMandatoryFields())) return false;


	EnableFieldsForUpdate();
	UpdateCareProvRound();
	return true;
}

function CheckMandatoryFields() {
	var obj=document.getElementById("SSUSRTimeSinceLastAppt");
	var obj2=document.getElementById("SSUSRTimeSincePeriod");
	if ((obj)&&(obj2)) {
		if ((obj.value!="")&&(obj2.value=="")) {
			alert(t['SSUSRTimeSincePeriod']+" "+t['XMISSING']);
			return false;
		}
	}
	return true;
}

function CareProvFieldsCheck() {

	var ErrMsg="";

	// SA 22.5.03 - log 35889: Care provider type is DB mandatory if "Add to Care Prov" is checked.
	// Alert saved from DB removes password fields, so check must be done here.
	// If at a later stage this field is populated via a site's UDF call, this function will need to be
	// overwritten with a blank return true function in that site's custom js.
	var objCTD=document.getElementById("CTCPTDesc");
	if (objCTD) {
		var lblCTD = document.getElementById("cCTCPTDesc");
		if ((lblCTD)&&(lblCTD.className=="clsRequired")&&(objCTD.value=="")) {
			ErrMsg+="\'"+t['CTCPTDesc']+"\' "+t['XMISSING']+"\n";
			websys_setfocus("CTCPTDesc");
		}
	}

	var obj=document.getElementById("CTPCPDateActiveFrom");
	if (obj) {
		var lbl = document.getElementById("cCTPCPDateActiveFrom");
		if ((lbl)&&(lbl.className=="clsRequired")&&(obj.value=="")) {
			ErrMsg+="\'"+t['CTPCPDateActiveFrom']+"\' "+t['XMISSING']+"\n";
			websys_setfocus("CTPCPDateActiveFrom");
		}
	}

	var obj=document.getElementById("CTPCPCode");
	if (obj) {
		var lbl = document.getElementById("cCTPCPCode");
		if ((lbl)&&(lbl.className=="clsRequired")&&(obj.value=="")) {
			ErrMsg+="\'"+t['CTPCPCode']+"\' "+t['XMISSING']+"\n";
			websys_setfocus("CTPCPCode");
		}
	}

	var obj=document.getElementById("CTPCPDesc");
	if (obj) {
		var lbl = document.getElementById("cCTPCPDesc");
		if ((lbl)&&(lbl.className=="clsRequired")&&(obj.value=="")) {
			ErrMsg+="\'"+t['CTPCPDesc']+"\' "+t['XMISSING']+"\n";
			websys_setfocus("CTPCPDesc");
		}
	}

	if (ErrMsg!="") {
		alert(ErrMsg);
		return false;
	}

	return true;

}

function PasswordPreUpdateCheck() {
	if ((objPasswordChanged)&&(objPasswordChanged.value=="Y")) {
		//增加密码加密程序 2014-10-11 add by wanghc 
		var password = objSSUSRPassword.value;
		var repassword = objConfirmPassword.value;
		var objSMCFPasswordMinLength=document.getElementById("SMCFPasswordMinLength");
		if (objSMCFPasswordMinLength) {
			var PasswordField=objSSUSRPassword.value;
			if (PasswordField.length<objSMCFPasswordMinLength.value) {
				alert(t['SSUSRPassword']+t['MinPasswdLen']+objSMCFPasswordMinLength.value);
				return false;
			}
		}
		if ((objSSUSRPassword)&&(objConfirmPassword)) {
			if (objSSUSRPassword.value!=objConfirmPassword.value) {
				alert(t['PASSWORD_DONT_MATCH']);
				objSSUSRPassword.value="";
				objConfirmPassword.value="";
				websys_setfocus("SSUSRPassword");
				return false;
			}
		}
		var PwdIsContainWordAndNumObj = document.getElementById("PwdContainWordAndNum");
		if (PwdIsContainWordAndNumObj){
			PwdIsContainWordAndNum = PwdIsContainWordAndNumObj.value;
			if (PwdIsContainWordAndNum=="Y"){
			 	if (!(/[0-9]+/.test(password))){
				 	alert("密码中要包含数字!");
					websys_setfocus("SSUSRPassword");
					return false;
			 	}
			 	if (!/[a-zA-Z]/.test(password)){
				 	alert("密码中要包含字母!");
					websys_setfocus("SSUSRPassword");
					return false;
			 	} 	
		 	}
		}
		password = password.replace(/\t|\n|\s|\f|\r|\v/g,"");
		repassword = repassword.replace(/\t|\n|\s|\f|\r|\v/g,"");
		objSSUSRPassword.value = dhc_cacheEncrypt(password);
		objConfirmPassword.value = dhc_cacheEncrypt(repassword);
	}
	return true;
}

function PasswordChangeHandler() {
	if (objPasswordChanged) objPasswordChanged.value="Y";
}
function passwordKeyUpHandler(e){
	var eSrc=websys_getSrcElement(e);
	if ((eSrc)&&(eSrc.value!="")) {
		pwStrength(eSrc.value);
	}
}
function CTCPTDescLookUpSelect(str) {
	//alert(str);
	var lu = str.split("^");
	var obj;
	// Set Care Provider Code to hidden field
	var obj=document.getElementById("CTCPTCode")
	if (obj) obj.value = lu[2]
}

//KK 15.01.04 L:39410
function SSUSRHospitalDRLookUpSelect(str) {
	//alert(str);
	var lu = str.split("^");
	var obj;
	// Set Hospital Id to hidden field
	var obj=document.getElementById("HospitalID")
	if (obj) obj.value = lu[1]
}

function HospLocBlurHandler() {
    //var objID=document.getElementById("HospitalID");
    //var obj=document.getElementById("SSUSRHospitalDR");
    //if ((obj)&&(objID)&&(obj.value=="")) objID.value="";
    
    // ab 10.11.05 - 56554
    var objid=document.getElementById("HospitalID");
    var objld=document.getElementById("CTLOCDesc");
    
    var objhosp=document.getElementById("SSUSRHospitalDR");
    if ((!objhosp)||((objhosp)&&(objhosp.value==""))) {
        if ((objld)&&(objld.value=="")&&(objid)) objid.value="";
    }
}

function CTLOCDescLookUpSelect(str) {
	//alert(str);
	var lu = str.split("^");
	var obj;
	// Set Hospital Id to hidden field
	var obj=document.getElementById("HospitalID");
	if (obj) obj.value = lu[7];
	var obj=document.getElementById("SSUSRHospitalDR");
	if (obj) obj.value = lu[4];
}

//check for a valid email address
//JW called from websys.Edit.Tools.js
/*function isEmail() {
	// SA 15.8.02 - log 23316: This function has been taken from PAPerson.Edit
	//alert("checking email");

	var reEmail = /^.+\@.+\..+$/
	var objADDREmail=document.getElementById("SSUSREmail");
  	if ((objADDREmail)&&(objADDREmail.value!="")) {
  		if (!(reEmail.test(objADDREmail.value))) {
			alert("Not a valid emial address");
			objADDREmail.focus();
			return false;
	    	}
	}
	return true;
} */



function DoctorCheckOnClickHandler(){
	//To check "DoctorCheck" checkbox and show/hide fields accordingly
	var objDC=document.getElementById("DoctorCheck")
	if ((objDC)&& (objDC.checked)){
		EnableFields();
	} else {
		DisableFields();
	}
}


//SA 2.6.03 - Log 35979: Set links bold if child/related table has entries.
//AJI 11.9.03 - Log 37591: Set bold for External System Code for Care Provider
function SetBoldLinks() {

	objBold=document.getElementById('BoldLinks');
	if (objBold) {
		var BoldLink = objBold.value.split("^");
		objOthLogonLoc=document.getElementById("OtherUserLogonLoc");
		objAssignCPLoc=document.getElementById("AssignCPLoc");
		objCareProvExtCode=document.getElementById("CareProvExtCode");
		objSurgicalPref=document.getElementById("SurgPref");
		objPACLogons=document.getElementById("PACLogons");

		if ((objOthLogonLoc)&&(BoldLink[0])&&(BoldLink[0]=="1")) objOthLogonLoc.style.fontWeight="bold";
		if ((objAssignCPLoc)&&(BoldLink[1])&&(BoldLink[1]=="1")) objAssignCPLoc.style.fontWeight="bold";
		if ((objCareProvExtCode)&&(BoldLink[2])&&(BoldLink[2]=="1")) objCareProvExtCode.style.fontWeight="bold";
		if ((objSurgicalPref)&&(BoldLink[3])&&(BoldLink[3]=="1")) objSurgicalPref.style.fontWeight="bold";
		if ((objPACLogons)&&(BoldLink[4])&&(BoldLink[4]=="1")) objPACLogons.style.fontWeight="bold";
	}
}




function EnableFields(){

	//Care Provider Code
	EnableCareProvideField();

	EnableMandatoryField("CTPCPDesc");
	EnableNonMandatoryField("SSUSRDoctorFlag");
	EnableNonMandatoryField("SSUSRNurseFlag");

	// SA 7.7.03 - log 36740: Not sure why this field was being enabled/disabled depending on DoctorCheck
	// but active flag not saving when disabled. Have commented this out.
	//EnableNonMandatoryField("SSUSRActive");

	EnableMandatoryField("CTCPTDesc");
	EnableLookup("ld1436iCTCPTDesc");
	EnableNonMandatoryField("CTPCPAdmittingRights");
	EnableNonMandatoryField("CTPCPSurgeon");
	EnableNonMandatoryField("CTPCPAnaesthetist");
	EnableNonMandatoryField("CTPCPAcceptance");
	EnableNonMandatoryField("CTPCPPrevious");
	EnableNonMandatoryField("CTPCPMantouxTest");
	EnableNonMandatoryField("CTPCPContinuing");
	EnableNonMandatoryField("CTPCPNew");


	//Update and Add Care Provider Addresses
	var objCPA=document.getElementById("UpdCPAdd");
	if (objCPA){
		objCPA.disabled=false;
		objCPA.onclick=UpdCPAddClickHandler;
	}

	EnableNonMandatoryField("CTPCPPrescriberNumber");

	//KK 30/Oct/2002 Log 29266 Assign Care Provider to Location
	//KK 16/Feb/2004 Log 42422 Enable/Disable Link
	var objCareProvID=document.getElementById("CareProvID");
	if ((objCareProvID)&&(objCareProvID=="")) {
		var objCPL=document.getElementById("AssignCPLoc");
		if (objCPL){
			objCPL.disabled=true;
			//objCPL.onclick=AssignCPLocClickHandler;
		}
		var objSP=document.getElementById("SurgPref");
		if (objSP){
			objSP.disabled=true;
		}
	}

	EnableNonMandatoryField("SSUSRRegistrationNumber");
	EnableNonMandatoryField("CTPCPBestContactTime");
	EnableNonMandatoryField("CTPCPReferralDoctorDR");
	EnableLookup("ld1436iCTPCPReferralDoctorDR");

	EnableNonMandatoryField("CTPCPCPGroupDR");
	EnableLookup("ld1436iCTPCPCPGroupDR");
	EnableMandatoryField("CTPCPDateActiveFrom");
	EnableLookup("ld1436iCTPCPDateActiveFrom");
	EnableNonMandatoryField("CTPCPDateActiveTo");
	EnableLookup("ld1436iCTPCPDateActiveTo");
	EnableNonMandatoryField("CTPCPTelH");
	EnableNonMandatoryField("CTPCPTelO");
	EnableNonMandatoryField("CTPCPTelOExt");
	EnableNonMandatoryField("CTPCPSpecDR");
	EnableLookup("ld1436iCTPCPSpecDR");
	EnableNonMandatoryField("CTPCPSubSpecDR");
	EnableLookup("ld1436iCTPCPSubSpecDR");
	EnableNonMandatoryField("CTPCPFirstDigitInQueue");
	EnableNonMandatoryField("CTPCPRespUnitDR");
	EnableLookup("ld1436iCTPCPRespUnitDR");
	EnableNonMandatoryField("CTPCPHospDR");
	EnableLookup("ld1436iCTPCPHospDR");
	EnableNonMandatoryField("CTPCPCTLOCDR");
	EnableLookup("ld1436iCTPCPCTLOCDR");
	EnableNonMandatoryField("CTPCPLinkDoctorDR");
	EnableLookup("ld1436iCTPCPLinkDoctorDR");
	EnableNonMandatoryField("CTPCPMailList");
	EnableNonMandatoryField("CTPCPContactFirstOn");
	EnableLookup("ld1436iCTPCPContactFirstOn");
	EnableNonMandatoryField("CTPCPPrefConMethod");
	EnableLookup("ld1436iCTPCPPrefConMethod");
	EnableNonMandatoryField("CTPCPTextOne");
	EnableNonMandatoryField("CTPCPTextTwo");

	EnableNonMandatoryField("CTPCPAllocatedDoctor");
	EnableNonMandatoryField("CTPCPSpecialistYN");
	EnableNonMandatoryField("CTPCPRadiologist");
	EnableNonMandatoryField("CTPCPNew");
    EnableNonMandatoryField("CTPCPTitleDR");
    EnableLookup("ld1436iCTPCPTitleDR");
    EnableNonMandatoryField("CTPCPFirstName");
    EnableNonMandatoryField("CTPCPOtherName");
    EnableNonMandatoryField("CTPCPSurname");
    EnableNonMandatoryField("CTPCPTitle");

}

function AssignCPLocClickHandler() {
	var objCPA=document.getElementById("AssignCPLoc");
	if (objCPA){
		return AssignCPLoc_click();
	}
}

function UpdCPAddClickHandler() {
	var objCPA=document.getElementById("UpdCPAdd");
	if (objCPA){
		return UpdCPAdd_click();
	}
}
function DisableFields(){

	DisableField("CTPCPCode");
	DisableField("CTPCPDesc");
	DisableField("SSUSRDoctorFlag");
	DisableField("SSUSRNurseFlag");

	// SA 7.7.03 - log 36740: Not sure why this field was being enabled/disabled depending on DoctorCheck
	// but active flag not saving when disabled. Have commented this out.
	//DisableField("SSUSRActive");

	DisableField("CTCPTDesc");
	DisableLookup("ld1436iCTCPTDesc");
	DisableField("CTPCPAdmittingRights");
	DisableField("CTPCPSurgeon");
	DisableField("CTPCPAnaesthetist");
	DisableField("CTPCPAcceptance");
	DisableField("CTPCPPrevious");
	DisableField("CTPCPMantouxTest");
	DisableField("CTPCPContinuing");
	DisableField("CTPCPPrescriberNumber");
	DisableField("SSUSRRegistrationNumber");
	DisableField("CTPCPBestContactTime");
	DisableField("CTPCPReferralDoctorDR");
	DisableLookup("ld1436iCTPCPReferralDoctorDR");

	DisableField("CTPCPCPGroupDR");
	DisableLookup("ld1436iCTPCPCPGroupDR");
	DisableField("CTPCPDateActiveFrom");
	DisableLookup("ld1436iCTPCPDateActiveFrom");
	DisableField("CTPCPDateActiveTo");
	DisableLookup("ld1436iCTPCPDateActiveTo");
	DisableField("CTPCPTelH");
	DisableField("CTPCPTelO");
	DisableField("CTPCPTelOExt");
	DisableField("CTPCPSpecDR");
	DisableLookup("ld1436iCTPCPSpecDR");
	DisableField("CTPCPSubSpecDR");
	DisableLookup("ld1436iCTPCPSubSpecDR");
	DisableField("CTPCPFirstDigitInQueue");
	DisableField("CTPCPRespUnitDR");
	DisableLookup("ld1436iCTPCPRespUnitDR");
	DisableField("CTPCPHospDR");
	DisableLookup("ld1436iCTPCPHospDR");
	DisableField("CTPCPCTLOCDR");
	DisableLookup("ld1436iCTPCPCTLOCDR");
	DisableField("CTPCPLinkDoctorDR");
	DisableLookup("ld1436iCTPCPLinkDoctorDR");
	DisableField("CTPCPMailList");
	DisableField("CTPCPContactFirstOn");
	DisableLookup("ld1436iCTPCPContactFirstOn");
	DisableField("CTPCPPrefConMethod");
	DisableLookup("ld1436iCTPCPPrefConMethod");
	DisableField("CTPCPTextOne");
	DisableField("CTPCPTextTwo");
    DisableField("CTPCPTitleDR");
    DisableLookup("ld1436iCTPCPTitleDR");
    DisableField("CTPCPFirstName");
    DisableField("CTPCPOtherName");
    DisableField("CTPCPSurname");
    DisableField("CTPCPTitle");

	//var objNew=document.getElementById("CTPCPNew");
	//if (objNew) objNew.disabled=true;

	//Update and Add Care Provider Addresses
	var objCPA=document.getElementById("UpdCPAdd");
	if (objCPA){
		objCPA.disabled=true;
		objCPA.onclick=LinkDisable;
	}

	//KK 30/Oct/2002 Log 29266 Assign Care Provider to Location
	var objCPL=document.getElementById("AssignCPLoc");
	if (objCPL){
		objCPL.disabled=true;
		objCPL.onclick=LinkDisable;
	}
	var objSP=document.getElementById("SurgPref");
	if (objSP){
		objSP.disabled=true;
		objSP.onclick=LinkDisable;
	}

	DisableField("CTPCPAllocatedDoctor");
	DisableField("CTPCPSpecialistYN");
	DisableField("CTPCPRadiologist");
	DisableField("CTPCPNew");
}

function SetValuesOnNew() {
	//KK 15/jul/02 Log 23316 - If it is a new entry set the field values accordingly
	var objDL=document.getElementById("SSUSRDefaultLocation");
	if (objDL) objDL.checked=true;
	var objCL=document.getElementById("SSUSRChangeLocation");
	if (objCL) objCL.checked=true;
	var objActive=document.getElementById("SSUSRActive");
	if (objActive) objActive.checked=true;
	//rqg,15Aug02,Log23316: Set "English" to preferred language field
	var objCTLANDesc=document.getElementById("CTLANDesc");
	if (objCTLANDesc) objCTLANDesc.value="English";
}

/*JW moved to websys.Edit.Tools.js - delete post 10/5/04
function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if (el.disabled) {
		return false;
	}
	return true;
} */

function UpdateCareProvRound() {
	var arrItems = new Array();
	var lst = document.getElementById("CareProvRoundEntered");
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			arrItems[j] = lst.options[j].value + String.fromCharCode(2) + lst.options[j].text;
		}
		var el = document.getElementById("CareProvRoundDescString");
		if (el) el.value = arrItems.join(String.fromCharCode(1));
	}
}


function CareProvRoundDeleteClickHandler() {
	//Delete items from CareProvRoundEntered listbox when a "Delete" button is clicked.
	var obj=document.getElementById("CareProvRoundEntered")
	if (obj)
		RemoveFromList(obj);
	return false;
}

function TimeSinceLastApptBlurHandler() {
	var obj=document.getElementById("SSUSRTimeSinceLastAppt");
	if (obj) {
		if (obj.value!="") labelMandatory("SSUSRTimeSincePeriod");
		if (obj.value=="") labelNormal("SSUSRTimeSincePeriod");
	}
}

function CareProvRoundLookupSelect(txt) {
	//Add an item to CareProvRoundEnetered when an item is selected from
	//the Lookup, then clears the Item text field.
	var adata=txt.split("^");
	//alert("adata="+adata);
	var obj=document.getElementById("CareProvRoundEntered")

	if (obj) {
		//Need to check if CareProvRound already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == String.fromCharCode(2)+adata[1]) {
				alert(t['CP_RND_SELECTED']);
				var obj=document.getElementById("CareProvRoundDesc")
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
				alert(t['CP_RND_SELECTED']);
				var obj=document.getElementById("CareProvRoundDesc")
				if (obj) obj.value="";
				return;
			}
			//alert(obj.options[i].value+"****"+adata[1])
		}
	}
	AddItemToList(obj,adata[1],adata[0]);

	var obj=document.getElementById("CareProvRoundDesc")
	if (obj) obj.value="";
	//alert("adata="+adata);
}

//TN: 21-Jun-2002: reload listbox with values from hidden field.
//this is due to page being refreshed upon error message (such as invalid pin)
function CareProvRoundReload() {
	var el = document.getElementById("CareProvRoundDescString");
	var lst = document.getElementById("CareProvRoundEntered");
	if ((lst)&&(el.value!="")) {
		var arrITEM=el.value.split(String.fromCharCode(1));
		for (var i=0; i<arrITEM.length; i++) {
			var arrITEMVAL=arrITEM[i].split(String.fromCharCode(2));
			//don't add ones that have a child rowid as they would already be populated
			if ((arrITEMVAL[0]=="")&&(arrITEMVAL[2]!="")) {
				AddItemToList(lst,arrITEMVAL[1],arrITEMVAL[2]);
			}
		}
	}
}

function AddItemToList(list,code,desc) {
	//Add an item to a listbox
	var frm=document.fSSUser_Edit;
	//TDIRTY=document.getElementById("TDIRTY")
	frm.TDIRTY.value=2
	//alert("and now..."+frm.TDIRTY.value);
	code=String.fromCharCode(2)+code
	list.options[list.options.length] = new Option(desc,code);
}

function RemoveFromList(obj) {
	var frm=document.fSSUser_Edit;
	//TDIRTY=document.getElementById("TDIRTY")
	frm.TDIRTY.value=2
	for (var i=(obj.length-1); i>=0; i--) {
		if (obj.options[i].selected)
			obj.options[i]=null;
	}
}

function EnableCareProvideField() {
	// SA 5.9.02 - log 28250: This function enables the care prov field
	// This function also exists in ARMC custom js which overwrites any functionality here.

	var objCPCode=document.getElementById("CTPCPCode");
	var lblCPCode=document.getElementById("cCTPCPCode");
	if (objCPCode) {
		objCPCode.disabled=false;
		objCPCode.className = "";
		if (lblCPCode) lblCPCode = lblCPCode.className = "clsRequired";
	}

}

function EnableFieldsForUpdate() {
	// SA 10.9.02 - log 28250: Dummy function here.
	// Functionality exists in ARMC custom js.

}

function specialistYNchange() {
	var obj1=document.getElementById("CTPCPSpecialistYN");
	var obj2=document.getElementById("CTPCPLinkDoctorDR");
	if ((obj1)&&(obj1.checked)&&(obj2)) {
		obj2.value="";
		obj2.className = "disabledField";
		obj2.disabled=true;
		var objCTPCPLinkDoctorDR=document.getElementById("ld1436iCTPCPLinkDoctorDR");
		if (objCTPCPLinkDoctorDR) objCTPCPLinkDoctorDR.disabled=true;
	}
	if ((obj1)&&(!obj1.checked)&&(obj2)) {
		obj2.value="";
		obj2.className = "";
		obj2.disabled=false;
		var objCTPCPLinkDoctorDR=document.getElementById("ld1436iCTPCPLinkDoctorDR");
		if (objCTPCPLinkDoctorDR) objCTPCPLinkDoctorDR.disabled=false;
	}
}

// SA 30.7.02 - log 27010: All CareProvRound methods have been copied from
// PAAdm.EditEmergency - Allergy fields. Call this outside onload call so it
// can be called straight away, and not wait till everything has loaded.
CareProvRoundReload();

function EnableMandatoryField(fldName) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if (fld) {
		fld.disabled = false;
		fld.className = "";
		if (lbl) lbl.className = "clsRequired";
	}
}

function EnableNonMandatoryField(fldName) {
	EnableField(fldName);
}


function CheckMandatoryFieldValue(fldName) {
	//alert("Disabling fldName="+fldName);
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if ((fld)&&(fld.tagName=="INPUT")) {
		if ((lbl)&&(lbl.className=="clsRequired")&&(fld.value=="")) return false;
	}
	return true;
}

/*
function DisableField(fldName) {
	alert("Disabling fldName="+fldName);
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if ((fld)&&(fld.tagName=="INPUT")) {
		fld.value = "";
		fld.disabled = true;
		fld.className = "disabledField";
		if (lbl) lbl = lbl.className = "";
	}
}

function DisableLookupIcon(iconName) {

	var obj=document.getElementById(iconName);
	if (obj) obj.disabled=true;
}

function EnableLookupIcon(iconName) {

	var obj=document.getElementById(iconName);
	if (obj) obj.disabled=false;
}
*/

//密码强度
//判断输入密码的类型
function CharMode(iN) {
	if (iN >= 48 && iN <= 57) //数字
	return 1;
	if (iN >= 65 && iN <= 90) //大写
	return 2;
	if (iN >= 97 && iN <= 122) //小写
	return 4;
	else return 8;
} 
//bitTotal函数
//计算密码模式
function bitTotal(num) {
	modes = 0;
	for (i = 0; i < 4; i++) {
		if (num & 1) modes++;
		num >>>= 1;
	}
	return modes;
} //返回强度级别
function checkStrong(sPW) {
	if (sPW.length <= 4) return 0; //密码太短
	Modes = 0;
	for (i = 0; i < sPW.length; i++) { //密码模式
		Modes |= CharMode(sPW.charCodeAt(i));
	}
	return bitTotal(Modes);
} 
//显示颜色
function pwStrength(pwd) {
	O_color = "#eeeeee";
	L_color = "#FF0000";
	M_color = "#FF9900";
	H_color = "#33CC00";
	if (pwd == null || pwd == '') {
		Lcolor = Mcolor = Hcolor = O_color;
	} else {
		S_level = checkStrong(pwd);
		switch (S_level) {
		case 0:
			Lcolor = Mcolor = Hcolor = O_color;
		case 1:
			Lcolor = L_color;
			Mcolor = Hcolor = O_color;
			break;
		case 2:
			Lcolor = Mcolor = M_color;
			Hcolor = O_color;
			break;
		default:
			Lcolor = Mcolor = Hcolor = H_color;
		}
	}
	document.getElementById("strength_L").style.background = Lcolor;
	document.getElementById("strength_M").style.background = Mcolor;
	document.getElementById("strength_H").style.background = Hcolor;
	return;
}
document.body.onload=BodyLoadHandler;
