// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var EXCESSIVEYEAR=1880;
var EXCESSIVEAGE=121;
var AskedForSaveDoc=0,AskedForActiveDoc=0;
var frm = document.forms["fPAAdm_EditEmergency"];
var systemconfigs=document.getElementById("PATCF")
var aryPATCF=systemconfigs.value.split("^")
var PatientID=document.getElementById('PatientID').value;
var confirmAlias=aryPATCF[8]
var AnonymousName = document.getElementById('AnonymousName').value;

//Log 64901 PeterC 17/09/07
var InsurPayor2="";
var obj=document.getElementById('InsurPayor2')
if (obj) InsurPayor2=obj.value;

var InsurPayor="";
var obj=document.getElementById('InsurPayor')
if (obj) InsurPayor=obj.value;

setNames();


if (parent.frames["discharge_top"]) {
		if (parent.refreshTopRequired==1) frm.TDIRTY.value=2
		parent.refreshTopRequired=0;
		parent.frames["diagnos_list"].location.reload();
	}

// SET DISABLE REGISTRATION DECEASED DATE AND TIME FOR DECEASED PATIENTS
function setDeceased() {
	var obj=document.getElementById('PAPERDeceasedFlag');
	if ((obj)&&(obj.value=="Y")) {
		var objd=document.getElementById('PAPERDeceasedDate');
		if(objd)
			objd.disabled=true;
		var objt=document.getElementById('PAPERDeceasedTime');
		if(objt)
			objt.disabled=true;
	}
}

// ab 29.01.04 - 41939 moved this outside of the update handler, so it runs when a warning message displays
if (window.name=="discharge_top") {
	if (frm.elements['TWKFL']!="") frm.elements['TFRAME'].value=window.parent.name;
}

if (document.getElementById("ALGEntered")) {document.getElementById("ALGEntered").tkItemPopulate=1;}
if (document.getElementById("EMCDesc")) {document.getElementById("EMCDesc").tkItemPopulate=1;}
function Init() {
	setDeceased();
	//alertIfFA();
	setLock()
	setLinks();
	setCheckBoxFlag();
	setTrisymp();

//07/12/2006 EZ LOG 49183 episode alerts displayed depending on EpisodeDate and security group settings
	CheckEpisodeAlerts()
	
	var obj;

	//ALIAS

	obj=document.getElementById('PAPERName');
	if (obj) obj.onchange = setAlias;
	obj=document.getElementById('PAPERName2');
	if (obj) obj.onchange = setAlias;
	obj=document.getElementById('PAPERName3');
	if (obj) obj.onchange = setAlias;

	// cjb 10/09/2003 39031

	//ADMISSION, DISCHARGE AND TRIAGE DATE AND TIME
	//obj=document.getElementById('PAADMAdmDate');		// cjb 17/05/2006 54485 - moved this out of Init so if the layout has a default date this change handler will run
	//if (obj) obj.onchange=PAADMAdmDateTimeHandler;

	obj=document.getElementById('PAADMDischgDate');
	if (obj) obj.onblur=PAADMDischgDateChange;
	if ((obj)&&(obj.value=="")) {
		DisableCheckbox('DiscontAll');
	}

	//DIAGNOSIS
    obj=document.getElementById('MRCIDDesc');
    //if (obj) obj.onchange=PrimaryDiagnChange;
    if (obj) obj.onblur=PrimaryDiagnChange;

	obj=document.getElementById('MRCIDDescOnly');
    //if (obj) obj.onchange=PrimaryDiagnChange;
         if (obj) obj.onblur=PrimaryDiagnChange;

	obj=document.getElementById('MRCIDAlternateDesc');
	//if (obj) obj.onchange=PrimaryDiagnChange;
	if (obj) obj.onblur=PrimaryDiagnChange;

	//AGE AND DOB
	obj=document.getElementById('PAPERDob');
	if (obj) obj.onchange=DOBChangeHandler;

	obj=document.getElementById('PAPERAge')
	if (obj) {
		obj.onchange=AgeChangeHandler;
	}

	 // CARE PROVIDER, GP AND REFERAL DOCTOR
	obj=document.getElementById('REFDDesc')
	if (obj) obj.onblur= RefDocChangeHandler;

	obj=document.getElementById('REFDDescFam')
	//if (obj) obj.onchange= FamDocChangeHandler;
	//md LOG 56263
	if (obj) obj.onblur= FamDocChangeHandler;

	obj=document.getElementById('AddNewRefDoc');
	if (obj) obj.onclick=AddNewReferralDoctor;

	obj=document.getElementById('ViewDoctorDetails');
	if (obj) obj.onclick=ViewDoctorHandler;

	obj=document.getElementById('ViewFamilyDrDetails');
	if (obj) obj.onclick=ViewFamilyDrHandler;

	//DISCHARGE CONDITION CHECKBOXES
	obj=document.getElementById('DISCON1');
	if (obj) obj.onclick=SetDischargeConditionCheckbox;
	obj=document.getElementById('DISCON2');
	if (obj) obj.onclick=SetDischargeConditionCheckbox;
	obj=document.getElementById('DISCON3');
	if (obj) obj.onclick=SetDischargeConditionCheckbox;
	obj=document.getElementById('DISCON4');
	if (obj) obj.onclick=SetDischargeConditionCheckbox;
	obj=document.getElementById('DISCON5');
	if (obj) obj.onclick=SetDischargeConditionCheckbox;
	obj=document.getElementById('DISCON6');
	if (obj) obj.onclick=SetDischargeConditionCheckbox;
	obj=document.getElementById('DISCON7');
	if (obj) obj.onclick=SetDischargeConditionCheckbox;
	obj=document.getElementById('DISCON8');
	if (obj) obj.onclick=SetDischargeConditionCheckbox;

	// cjb 21/08/2003 35639 disable the Agreed EDD field (pregnancy lookup) if the patient is not female
	obj=document.getElementById('IsFemale');
	if ((obj)&&(obj.value=="")) {
		obj=document.getElementById('PREGEdcAgreed')
		if (obj) {
			obj.disabled=true;
			obj.className = "disabledField";
		}
		obj=document.getElementById('ld191iPREGEdcAgreed')
		if (obj) {
			obj.disabled=true;
			obj.className = "disabledField";
		}
	}

	//BOLD LINKS
	// cjb 30/09/2003 39351
	var objBold=document.getElementById('BoldLinks');
	if (objBold) {
		var BoldLink = objBold.value.split("^");
		obj=document.getElementById("InsurDet");
		if ((obj) && (BoldLink[8]=="1")) obj.style.fontWeight="bold";
		// cjb 04/02/2004 35528
		obj=document.getElementById("MaternityComplications");
		if ((obj) && (BoldLink[13]=="1")) obj.style.fontWeight="bold";
		obj=document.getElementById("TriageCatLink");
		if ((obj) && (BoldLink[17]=="1")) obj.style.fontWeight="bold";
		obj=document.getElementById("PAPersonPatMas");
		if ((obj) && (BoldLink[18]=="1")) obj.style.fontWeight="bold";
		if ((obj) && (BoldLink[18]=="0")) SetupHiddenLink("PAPersonPatMas");
	}

	var objPtBold=document.getElementById('BoldPtLinks');
	if (objPtBold) {
		var BoldPtLink = objPtBold.value.split("^");
		obj=document.getElementById("ALGEMRLink");
		if ((obj) && (BoldPtLink[6]=="1")) obj.style.fontWeight="bold";
	}
	//
	var obj=document.getElementById("TriageSymptoms");
	var objSymHidden=document.getElementById("SympProID");
		if ((obj) && (objSymHidden)&&(objSymHidden.value!="")) {
		//alert("bolding slow");
		obj.style.fontWeight="bold";
		}
	
	//
	//DISCHARGE LETTER
	var obj=document.getElementById('OpenWordDoc');
	if (obj) obj.onclick=UpdateAndOpenWordDoc;

	//LINKS AND BUTTONS
	var obj=document.getElementById('DeleteAllergy');
	if (obj) obj.onclick=AllergyDeleteClickHandler;

	var obj=document.getElementById('update1');
	if (obj) obj.onclick=UpdateAll;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateAll;

	var obj=document.getElementById('Delete');
	if (obj) obj.onclick=DeleteClickHandler;

	var obj=document.getElementById('Injury');
	var objh=document.getElementById('InjuryExist');
	if ((obj)&&(objh)) { objh.value="1" }

	var obj=document.getElementById('RespForPaySelect');
	if (obj) obj.onblur=ResponsibleForPayBlur;

	var obj=document.getElementById("CTPCPDesc");
	if (obj) obj.onblur=CTPCPDescBlurHandler;
	
	// cjb 07/01/2005 45882
	obj=document.getElementById('MRADMGlasgowComaScore')
	if (obj) obj.onblur= MRADMGlasgowComaScoreChangeHandler;
	
	obj=document.getElementById('MRADMPainScore')
	if (obj) obj.onblur= MRADMPainScoreChangeHandler;
	
	obj=document.getElementById("FamilyClinicAddress");
	if (obj) obj.readOnly=true;
	
	
	//md LOG 54261
	obj=document.getElementById("InsurPayor");
	if (obj) obj.onblur=REClearInsurPayor;
	//md LOG 54261
	
	obj=document.getElementById("TriageSymptoms");
	if (obj) obj.onclick=TriageSymptomsClickHandler;
		
	// cjb 24/01/2005 48979 - now done in the component
	// cjb 11/01/2005 48571 - use the 'custom find' lookup
	/*
	var obj=document.getElementById('REFDDesc');
	if (obj) obj.onkeydown=REFDDesc_lookuphandlerCustom;
	var obj=document.getElementById('ld191iREFDDesc');
	if (obj) obj.onclick=REFDDesc_lookuphandlerCustom;
	*/
	SyncCTdates();
	
	obj=document.getElementById('PIN');
	if (obj) obj.onblur=RelPin;
	
	obj=document.getElementById('UserCode');
	if (obj) obj.onchange=RelPin;
	
	CheckROONLoad();
}


function UpdateAll() {
	//log 61673 EZ 22/11/2006 VALIDATION OF fields
	if (!CheckInvalidFields())  { return false; }
	if (!CheckRequiredFields()) { return false; }
	UpdateEmerCond();
	UpdateAllergies();
	UpdateDobFromAge();
	alertIfFA();
	return update1_click();
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

}

function CheckRequiredFields() {
	var msg="";
	var obj=document.getElementById('PAADMType');
	var dis=document.getElementById('PAADMDischgDate');
	if ((dis)&&(dis.value!="")) {
		if (obj.value!="E") {
			msg += t['NotCorrectAdmType'] + "\n";
			}
			// 24/09/02 Log#28003 HP: Check that financial discharge field is ticked when system parameter 			//(AllowDisWOFin) is not
			var objFD=document.getElementById('PAADMBillFlag');
			if ((objFD)&&(objFD.checked==false)) {
				var objAllowFD=document.getElementById('AllowDisWOFin');
				if ((objAllowFD)&&(objAllowFD.value!="Y")) {
					msg += t['FinDisMandatory'] + "\n";
				}
			}
		}
	if (msg != "") {
		alert(msg)
		return false;
	} else {
		return true;
	}
}

function setLock() {
	var obj=document.getElementById('hiddenLock');
	if (obj.value!="1") {
		obj=document.getElementById('PAPERName')
		if (obj) {
		alert(t['RecordLocked'])
			obj.disabled=true
		}
		obj=document.getElementById('PAPERName2')
		if (obj) obj.disabled=true
		obj=document.getElementById('PAPERName3')
		if (obj) obj.disabled=true
		obj=document.getElementById('CTSEXDesc')
		if (obj) obj.disabled=true
		obj=document.getElementById('PAPERDob')
		if (obj) obj.disabled=true
		obj=document.getElementById('PAPERAge')
		if (obj) obj.disabled=true
	}
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
function PayorSetHandler(str) {

	//alert(str);
 	var lu = str.split("^");
	var obj=document.getElementById('InsurPayor')
	if (obj) obj.value=lu[0];
	obj=document.getElementById("payorCategory")
	if (obj) obj.value = lu[3];
	var obj=document.getElementById('InsurPlan')
	//Log 64901 PeterC 17/09/07
	if ((obj)&&(InsurPayor!=lu[0])) obj.value="";
	//md LOG 54261
	obj=document.getElementById("payCode")
	if (obj) obj.value = lu[2];
	obj=document.getElementById("InsurPayorID")
	if (obj) obj.value = lu[1];
	//Log 64901 PeterC 17/09/07
	InsurPayor=lu[0];
	//md LOG 54261
	setLinksAgain();
}

function PrimaryDiagnChange(){
	var pobj=document.getElementById('MRCIDDesc');
	var poobj=document.getElementById('MRCIDDescOnly');
	var paobj=document.getElementById('MRCIDAlternateDesc');
	if (((pobj)&&(pobj.value==""))||((poobj)&&(poobj.value==""))||((paobj)&&(paobj.value==""))) {
		obj=document.getElementById('MRCIDRowId');
		if (obj) obj.value="";
		//md 11/12/2003 need to do same for MRCICCode
		obj=document.getElementById('MRCIDCode');
		if (obj) obj.value="";
	}
}

function setLinks() {

	var obj=document.getElementById('hiddenLinks');
	if (obj) obj.value="0";
	var obj=document.getElementById('InsurPayor');
	if (obj) payor=obj.value;
	var obj=document.getElementById('EpisodeID');
	if ((obj)&&(obj.value=="")) {
		var obj=document.getElementById('hiddenLinks');
		if (obj) obj.value="1";
		var obj=document.getElementById('CompoDetails');
		if (obj) {
			obj.disabled=true;
			obj.onclick=DoLink;
		}
		// cjb 30/09/2003 39351
		SetupHiddenLink("InsurDet");
		SetupHiddenLink("EpisodeContactLink");
		// cjb 04/02/2004 35528
		SetupHiddenLink("MaternityComplications");
	}

	var obj=document.getElementById('PatientID');
	if ((obj)&&(obj.value=="")) {
		// ab 21.05.04 - 43080
		SetupHiddenLink("ALGEMRLink");
	}

	var obj=document.getElementById('EpisodeID');
	if ((obj)&&(obj.value!="")) {
		var pay=document.getElementById('payorCategory');
		//alert(obj.value + " " + payor)
		if (pay) {
			if ((pay.value!="Auto") && (pay.value!="Labour") && (pay.value!="Foreign")) {
				var obj=document.getElementById('CompoDetails');
				if (obj) {
					obj.disabled=true;
					obj.onclick=DoLink;
				}
			}
			if ((pay.value=="Auto") || (pay.value=="Labour") || (pay.value=="Foreign")) {
				var obj=document.getElementById('CompoDetails');
				if (obj) {
					obj.disabled=false;
					obj.onclick=DoLink;
				}
			}
		}
	}
}

function setLinksAgain() {

	var obj=document.getElementById('EpisodeID');
	var pay=document.getElementById('InsurPayor');
	if (pay) var payor=pay.value;

	if ((obj)&&(obj.value!="")) {
		var pay=document.getElementById('payorCategory');
		if (pay) {
		//alert("pay cat"+obj.value)
		if ((pay.value=="Auto") || (pay.value=="Labour") || (pay.value=="Foreign")) {
			var comp=document.getElementById('CompoDetails');
			if (comp) {

				comp.disabled=false;
				comp.onclick=DoLink;
				}
		}
		if ((pay.value!="Auto") && (pay.value!="Labour") && (pay.value!="Foreign")) {
			var comp=document.getElementById('CompoDetails');
			if (comp) {
				comp.disabled=true;
				comp.onclick=DoLink
			}
		}

		}

	}
}

function DoLink() {
	var pay=""
	var payCat=""
	var code=""

	var comp=document.getElementById('CompoDetails');
	if (comp.disabled) {

		return false;
	} else {
		//window.open(lnk.href);

	var val=document.getElementById('EpisodeID').value;
	var pat=document.getElementById('PatientID').value;
	var obj=document.getElementById('InsurPayor')
	if (obj) pay=obj.value
	obj=document.getElementById("payorCategory")
	if (obj) payCat=obj.value
	obj=document.getElementById("payCode")
	if (obj) code=obj.value
	obj=document.getElementById("hiddenLinks")
	if (obj) hidden=obj.value

	websys_createWindow('patrafficaccidentframe.csp?EpisodeID='+val+'&PatientID='+pat+'&InsurPayor='+pay+'&payCode='+code+'&payCategory='+payCat+'&hiddenLinks='+hidden+'&ID=','comp','top=20,left=20,width=900,height=600,resizable=yes');
		return false;

	}
}

function SetupHiddenLink(link) {
	var obj=document.getElementById(link);
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}
}





//function ValidateUpdate() {
//	var isValid=true;
//	obj=document.getElementById('PAADMTriageDate');
//	if ((obj)&&(FutureTriageDate(obj.value))) {
//		alert("\'" + t['PAADMTriageDate'] + "\' " + t['XINVALID'] + "\n");
//		isValid=false;
//	}
//	if ((obj)&&(TriageTimeHandler())) {
//		alert("\'" + t['PAADMTriageTime'] + "\' " + t['XINVALID'] + "\n");
//		isValid=false;
// 	}
// 	return isValid;
//}

/*function checkListBoxExists() {
	var exists=false;
	var obj=document.getElementById('ALGEntered');
	if (obj) {
		exists=true;
	}
	obj=document.getElementById('EMCDesc');
	if (obj) {
		exists=true;
 	}

 	return exists;
} */

function MRCIDDescLookUpSelect(str) {
	var lu=str.split("^");
	var arrICD=lu[0].split(" | ");
	var obj=document.getElementById("MRCIDDesc");
	if (obj) obj.value=arrICD[0];
	var obj=document.getElementById('MRCIDRowId');
	if (obj) obj.value=lu[1];
}

// 16/09/02 Log# 27697 HP: Following 2 functions added to cater for the two new versions of Diagnosis
function MRCIDDescOnlyLookUp(str) {
	var ary=str.split("^");
	var ary2=ary[0].split(" | ");
	var obj=document.getElementById("MRCIDDescOnly");
	if (obj) obj.value=ary2[0];
	var obj2=document.getElementById("MRCIDRowId");
	if (obj2) obj2.value=ary[1];
}

function MRCIDAltDescLookUp(str) {
	//alert(str);
	var ary=str.split("^");
	var ary2=ary[0].split(" | ");
	var obj=document.getElementById("MRCIDAlternateDesc");
	if (obj) obj.value=ary2[0];
	var obj2=document.getElementById("MRCIDRowId");
	if (obj2) obj2.value=ary[1];
}

function ReveiwStatusLookUpSelect(str) {
	var lu=str.split("^");
	var obj=document.getElementById("MRSysReviewRowID");
	if (obj) obj.value=lu[1];
	var obj=document.getElementById('STATDesc');
	if (obj) obj.value=lu[0];

}

function OLDUsualAccomSelect() {
	// a dummy function to allow a custom UsualAccomSelect() function to be used
}

function UsualAccomSelect(str) {
	var lu = str.split("^");
	var objUSACCDesc=document.getElementById("USACCDesc");
	if (objUSACCDesc) { objUSACCDesc.value=lu[0]; }	
	ReplaceHiddenCodeGlobal(7,lu[2],lu[3]);	
	try {
		Custom_UsualAccomSelect(str);
	} catch(e) { 
		}	finally  {
	}
}



function OLDTriageCatSelect() {
// a dummy function to allow a custom TriageCatSelect() function to be used
}

function TriageCatSelect(str) {
	//alert(str);
	var lu = str.split("^");
	var objCTACUDesc=document.getElementById("CTACUDesc");
	if (objCTACUDesc) { objCTACUDesc.value=lu[0]; }	
	ReplaceHiddenCodeGlobal(3,lu[2],lu[3]);	
	try {
		Custom_TriageCatSelect(str);
	} catch(e) { 
		}	finally  {
	}
}

//standard change handlers to clear associated fields

function LookUpLocation(val) {
//KM 18Dec2001: Did it this way so that LookUpBroker would work on the onchange event
	var ary=val.split("^");
	var obj=document.getElementById("CTLOCDesc");
	if (document.getElementById("CTLOCDesc").defaultValue!=ary[0]) {
		var obj=document.getElementById("CTPCPDesc")
		if (obj) obj.value="";
	}
}

function PayorChangeHandler() {
	var obj=document.getElementById("InsurPlan")
	if (obj) obj.value="";
	obj=document.getElementById("InsurOffice")
	if (obj) obj.value="";
}

function Payor2ChangeHandler(str) {
	var lu = str.split("^");

	var obj=document.getElementById("InsurPlan2")
	//Log 64901 PeterC 17/09/07
	if ((obj)&&(InsurPayor2!=lu[0])) obj.value="";
	//md Log 54405/54621
	var obj=document.getElementById("InsurPayor2Code")
	if (obj) obj.value=lu[2];
	//Log 64901 PeterC 17/09/07
	InsurPayor2=lu[0];

	//No office exists for Payor2/Plan2
	//obj=document.getElementById("InsurOffice")
	//if (obj) obj.value="";
}

function RemoveFromList(obj) {
	var frm=document.fPAAdm_EditEmergency;
	//TDIRTY=document.getElementById("TDIRTY")
	frm.TDIRTY.value=2
	for (var i=(obj.length-1); i>=0; i--) {
		if (obj.options[i].selected)
			obj.options[i]=null;
	}
}

//Emergency Conditions List

function UpdateEmerCond() {
	var arrItems = new Array();
	var lst = document.getElementById("EMCDesc");
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			//TN:21-Jun-2002:need to pass description for reloading when update error occurs
			arrItems[j] = lst.options[j].value + String.fromCharCode(2) + lst.options[j].text;
		}
		var el = document.getElementById("EMCDescString");
		if (el) el.value = arrItems.join(String.fromCharCode(1));
	}
}


function DeleteClickHandler() {
	//Delete items from EMCDesc listbox when a "Delete" button is clicked.
	var obj=document.getElementById("EMCDesc")
	if (obj)
		RemoveFromList(obj);
	return false;
}

function EmergCondLookupSelect(txt) {
	//Add an item to EMCDesc when an item is selected from
	//the Lookup, then clears the Item text field.
	var adata=txt.split("^");
	//alert("adata="+adata);
	var obj=document.getElementById("EMCDesc")

	if (obj) {
		//Need to check if Condition already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == String.fromCharCode(2)+adata[1]) {
				alert("Emergency Condition has already been selected");
				var obj=document.getElementById("EmergCondItem")
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
			alert("Emergency Condition has already been selected");
				var obj=document.getElementById("EmergCondItem")
				if (obj) obj.value="";
				return;
			}
			//alert(obj.options[i].value+"****"+adata[1])
		}
	}
	AddItemToList(obj,adata[1],adata[0]);

	var obj=document.getElementById("EmergCondItem")
	if (obj) obj.value="";
	//alert("adata="+adata);
}

//TN: 21-Jun-2002: reload listbox with values from hidden field.
//this is due to page being refreshed upon error message (such as invalid pin)
function EmergCondReload() {
	var el = document.getElementById("EMCDescString");
	var lst = document.getElementById("EMCDesc");
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
	var frm=document.fPAAdm_EditEmergency;
	//TDIRTY=document.getElementById("TDIRTY")
	frm.TDIRTY.value=2
	//alert("and now..."+frm.TDIRTY.value);
	code=String.fromCharCode(2)+code
	list.options[list.options.length] = new Option(desc,code);
}

//Alllergies

function UpdateAllergies() {
	var arrItems = new Array();
	var lst = document.getElementById("ALGEntered");
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			//TN:21-Jun-2002:need to pass description for reloading when update error occurs
			arrItems[j] = lst.options[j].value + String.fromCharCode(2) + lst.options[j].text;
		}
		var el = document.getElementById("ALGDescString");
		if (el) el.value = arrItems.join(String.fromCharCode(1));
	}
}


function AllergyDeleteClickHandler() {
	//Delete items from ALGEntered listbox when a "Delete" button is clicked.
	var obj=document.getElementById("ALGEntered")
	if (obj)
		RemoveFromList(obj);
	return false;
}

function AllergyLookupSelect(txt) {
	//Add an item to ALGEnetered when an item is selected from
	//the Lookup, then clears the Item text field.
	var adata=txt.split("^");
	//alert("adata="+adata);
	var obj=document.getElementById("ALGEntered")

	if (obj) {
		//Need to check if Allergy already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == String.fromCharCode(2)+adata[1]) {
				alert("Allergy has already been selected");
				var obj=document.getElementById("ALGDesc")
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
			alert("Allergy has already been selected");
				var obj=document.getElementById("ALGDesc")
				if (obj) obj.value="";
				return;
			}
			//alert(obj.options[i].value+"****"+adata[1])
		}
	}
	AddItemToList(obj,adata[1],adata[0]);

	var obj=document.getElementById("ALGDesc")
	if (obj) obj.value="";
	//alert("adata="+adata);
}

//TN: 21-Jun-2002: reload listbox with values from hidden field.
//this is due to page being refreshed upon error message (such as invalid pin)
function AllergyReload() {
	var el = document.getElementById("ALGDescString");
	var lst = document.getElementById("ALGEntered");
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



// Age and Date of Birth

function DOBChangeHandler(e) {
	var eSrc = websys_getSrcElement(e);
	DOBChange(eSrc);
	
	try {
		Custom_DOBChangeHandler(e);
	} catch(e) { 
		}	finally  {
	}
	
}

function DOBChange(eSrc) {
	var objAge = document.getElementById('PAPERAge');
	if (!eSrc) return;
	if (!objAge) return;
        if (!IsValidDate(eSrc)) {
      		alert('invalid date format\n' + eSrc.value);
      		if (objAge) objAge.value = "";
      		eSrc.value = "";
      	} else {
		if (eSrc.value=="") return;
		var msg = ExcessiveDOB(eSrc.value);
		if (msg!="") {
         		alert(eSrc.value + '\n' + msg);
         		if (objAge) objAge.value = "";
   	 		eSrc.value = "";
   	 		return;
  	 	}
		if (PriorBirthDate(eSrc.value)) {
			alert(eSrc.value + '\nBirth date cannot be before Admission date');
			return;
		}
		if (eSrc.value != "") {
			if (objAge) objAge.value = CalculateAge(eSrc.value);
  			}
	//}
	////////////////////
	if (confirmAlias=="Y") {
			if ((PatientID) && (eSrc.defaultValue != "") && (eSrc.defaultValue!=eSrc.value))  {
					if (confirm(t['AliasConfirm'])) {
					websys_createWindow('paperson.aliasname.update.csp?PatientID='+PatientID+'&ComponentItemName='+eSrc.id+'&DefaultValue='+eSrc.defaultValue,'TRAK_hidden','');
			}
		}
	}
}
//////////////////////////////////////////////////////////////
 }

function AgeChangeHandler(e) {
   	var eSrc = websys_getSrcElement(e);
	var objDob = document.getElementById("PAPERDob")
	if (!objDob) return;
   	// insert age if age field is clear and validate the age field
   	if (eSrc.value == "") {
           	if (objDob.value != "") {
   			eSrc.value = CalculateAge(objDob.value);
   		} else {
   			return;
  		}
 	}
 	if (isNaN(eSrc.value)) {
  		alert('invalid number\n' + eSrc.value);
  		eSrc.value = "";
 	} else {
  		if (NegativeAge(eSrc.value)) {
   			alert('\n' + t['PAPERDob'] + " cannot be in the future");
   			objDob.value = "";
   			eSrc.value = "";
   			return;
  		}
		if (eSrc.value > EXCESSIVEAGE) {
   			alert('\n' + t['PAPERDob'] + " " + t['XINVALID']);
   			objDob.value = "";
   			eSrc.value = "";
   			return;
		}
 	}
	if (objDob.value != "") {
	 	// Clear DOB if age is inputted - it is now calculated on the update event
 		objDob.value = "";
	}
}


function UpdateDobFromAge() {
 	// Calulates DOB if an age is entered as DOB currently is mandatory in Database
	var objAge = document.getElementById('PAPERAge');
	var objDob = document.getElementById('PAPERDob');
 	if ((objDob)&&(objDob.value=="")&&(objAge)&&(objAge.value!="")) {
  		if (!isNaN(objAge.value)) {
   			objDob.value = CalculateDOB(parseInt(objAge.value,10));
  		}
 	}
}

function CalculateAge(strDOB) {
 	var today = new Date();
	//MD 29/09/003 (39337): Need to add 543 yrs if THAI date.
	if (dtformat=="THAI") today.setYear(today.getFullYear()+543);
 	var thisyear = today.getYear();
	if (thisyear < 100) thisyear += 1900;
 		var arrDate = SplitDateStr(strDOB);
 		var yr = arrDate["yr"];
		var mn = arrDate["mn"];
 		var dy = arrDate["dy"];
 		var age = thisyear - yr;
 	if (age < 1)
 		 return age;
 	if (today.getMonth()+1 < mn) {
  		age -= 1;
	} else if ((today.getMonth()+1 == mn) && (today.getDate() < dy)) {
  		age -= 1;
 	}
 	return age;
}

//function CalculateDOB(age) {
 	//var strDOB = "";
 	//var today = new Date();
 	//var yr = today.getYear();
 	//if (yr < 1900) yr +=1900;
 		//yr -= age;
 		//switch (dtformat) {
  		//case "YMD":
   		//strDOB = "" + yr + dtseparator + (1+today.getMonth()) + dtseparator + today.getDate();
   		//break;
  		//case "MDY":
   		//strDOB = "" + (1+today.getMonth()) + dtseparator + yr + dtseparator + today.getDate();
   		//break;
  		//default:
   		//strDOB = "" + today.getDate() + dtseparator + (1+today.getMonth()) + dtseparator + yr;
   		//break;
 		//}
 	//return strDOB;
//}

function CalculateDOB(age) {
 	var strDOB = "";
 	var today = new Date();
 	var yr = today.getYear();
 	if (yr < 1900) yr +=1900;
 		yr -= age;
 		switch (dtformat) {
  		case "YMD":
   		strDOB = "" + yr + dtseparator + "1" + dtseparator + "1";
   		break;
  		case "MDY":
   		strDOB = "" + "1" + dtseparator + yr + dtseparator + "1";
   		break;
  		default:
   		strDOB = "" + "1" + dtseparator + "1" + dtseparator + yr;
   		break;
 		}
 	return strDOB;
}
function SplitDateStr(strDate) {
	return DateStringToArray(strDate,dtseparator,dtformat);
}

function ExcessiveDOB(strDate) {
 	var arrDate = SplitDateStr(strDate);
	//alert(arrDate)
	var msg="";
	if (arrDate["yr"] < EXCESSIVEYEAR) {
		msg += t['PAPERDob'] + " " + t['XINVALID'] + "\n";
	} else {
	 	var dtEntered = new Date(arrDate["yr"], arrDate["mn"]-1, arrDate["dy"]);
		var dtNow = new Date();
		//MD 29/09/003 (39337): Need to add 543 yrs if THAI date.
		if (dtformat=="THAI") dtNow.setYear(dtNow.getFullYear()+543);
 		if (dtEntered > dtNow) {
			msg += t['PAPERDob'] + " cannot be in the future\n";
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


function setAlias(evt) {
	var eSrc = websys_getSrcElement(evt);
	if ((PatientID != "") && (eSrc.defaultValue != "") && (eSrc.defaultValue != eSrc.value)) {
			if (confirm(t['ALIAS'])) {
			websys_createWindow('paperson.aliasname.update.csp?PatientID='+PatientID+'&ComponentItemName='+eSrc.id+'&DefaultValue='+eSrc.defaultValue,'TRAK_hidden','');
		}
	}
}
function SexLookUp(str) {
 	var lu = str.split("^");
	ReplaceHiddenCodeGlobal(20,lu[3],"");
	
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
				if (confirm(t['AliasConfirm'])) {
								websys_createWindow('paperson.aliasname.update.csp?PatientID='+PatientID+'&ComponentItemName='+eSrc.id+'&DefaultValue='+eSrc.defaultValue,'TRAK_hidden','');
				}
	      }
}

//check that triage date is after admission date
//function TriageChangeHandler(e) {
//	var eSrc = websys_getSrcElement(e);
//	TriageChange(eSrc);
//}

/*function TriageChange(e) {

		var eSrc = websys_getSrcElement(e);
		PAADMTriageDate_changehandler(eSrc)
         	if (FutureTriageDate(eSrc.value)) {
         	alert(eSrc.value + '\nTriage Date cannot be prior to Admission Date');
         	}
}*/

function FutureTriageDate(strDate) {

 	var triDate = SplitDateStr(strDate);
	var obj = document.getElementById('PAADMAdmDate')
	//note use of innerText to grab admiss date is not compatible with netscape
	if (obj) {
		var admDate = SplitDateStr(obj.innerText)

 	var dtTriage = new Date(triDate["yr"], triDate["mn"]-1, triDate["dy"]);
	var dtAdmiss = new Date(admDate["yr"], admDate["mn"]-1, admDate["dy"]);
	if (dtAdmiss > dtTriage) return true;
 	return false;
	}
}

/*function TriageTimeChange() {
	PAADMTriageTime_changehandler()
	if (TriageTimeHandler()) {
		alert('\nTriage Time can not be prior to Admission Time')
	}
}

//check that triage time is not before admission time
function TriageTimeHandler(e) {
	//PAADMTriageTime_changehandler()
	var triageTime = document.getElementById('PAADMTriageTime')
	var obj = document.getElementById('PAADMAdmTime')
	if (obj) {
		var admTime = obj.innerText
	}
	if (triageTime) {
		var triTime = triageTime.value
	}

	var objTri = document.getElementById('PAADMTriageDate')
	if (objTri) {
		var triDate = SplitDateStr(objTri.value);
	}
	var objAdmiss = document.getElementById('PAADMAdmDate')
	if (objAdmiss) {
		var admDate = SplitDateStr(objAdmiss.innerText)
	}
	if ((triDate)&&(admDate)) {
 	var dtTriage = new Date(triDate["yr"], triDate["mn"]-1, triDate["dy"]);
	var dtAdmiss = new Date(admDate["yr"], admDate["mn"]-1, admDate["dy"]);

	if (dtTriage <= dtAdmiss) {
		if (triTime < admTime) return true
		return false;
	//alert(triTime + '\nTriage Time can not be prior to Admission Time')
		}
	}
}
*/


// check that admission date if equal to or later than birth date
function PriorBirthDate(strDate) {
	var birthDate = SplitDateStr(strDate);
	var obj = document.getElementById('PAADMAdmDate')
	//md 30/09/2003 check status of the field(display only/editable) to get the value from correct property
	var objAdmDate=""
	if ((obj)&&(obj.innerText!="")) {objAdmDate=obj.innerText;}
	if ((obj)&&(obj.value!="")) {objAdmDate=obj.value;}
	// note: innerText not compatible with netscape
	if (obj) {
		//var admDate = SplitDateStr(obj.innerText)
		var admDate = SplitDateStr(objAdmDate)
	 	var dtBirth = new Date(birthDate["yr"], birthDate["mn"]-1, birthDate["dy"]);
		var dtAdmiss = new Date(admDate["yr"], admDate["mn"]-1, admDate["dy"]);
 		if (dtBirth > dtAdmiss) return true;
 		return false;
	}
}

function AddNewReferralDoctor() {
}

// dummy look up functions required to allow the use of a custom look up function,
// necessary to grab fields for conditional testing

function OLDreferralByLookUp() {
	// a dummy function to allow a custom referralByLookUp funtion to be used
}

function referralByLookUp(str) {
	var lu = str.split("^");
	var objCTRFCDesc=document.getElementById("CTRFCDesc");
	if (objCTRFCDesc) { objCTRFCDesc.value=lu[0]; }	
	ReplaceHiddenCodeGlobal(9,lu[2],lu[3]);
	try {
		Custom_referralByLookUp(str);
	} catch(e) { 
		}	finally  {
	}
}

function OLDreferredToLookUp(str) {
	// a dummy function to allow a custom referralToLookUp funtion to be used
}

function referredToLookUp(str) {
	var lu = str.split("^");
	var objREFDEPDesc=document.getElementById("REFDEPDesc");
	if (objREFDEPDesc) { objREFDEPDesc.value=lu[0]; }	
	ReplaceHiddenCodeGlobal(16,lu[2],lu[3]);
	try {
		Custom_referredToLookUp(str);
	} catch(e) { 
		}	finally  {
	}
}

function OLDvisitLookUp() {
	// a dummy function to allow a custom visitByLookUp funtion to be used
}

function visitLookUp(str) {
	var lu = str.split("^");
	var objVSTDesc=document.getElementById("VSTDesc");
	if (objVSTDesc) { objVSTDesc.value=lu[0]; }	
	ReplaceHiddenCodeGlobal(15,lu[2],lu[3]);
	try {
		Custom_visitLookUp(str);
	} catch(e) { 
		}	finally  {
	}
}

function OLDdepartureByLookUp() {
	// a dummy function to allow a custom departureByLookUp funtion to be used
}

function departureByLookUp(str) {
	var lu = str.split("^");
	var objDSCLDesc=document.getElementById("DSCLDesc");
	if (objDSCLDesc) { objDSCLDesc.value=lu[0]; }	
	ReplaceHiddenCodeGlobal(10,lu[2],lu[3]);
	try {
		Custom_departureByLookUp(str);
	} catch(e) { 
		}	finally  {
	}
}

function payorByLookUp() {
	// a dummy function to allow a custom payorByLookUp funtion to be used
}

function OLDarrivalTransLookUp(str) {
	// HP 9/10/02 - Already in custom script as discussed with AB, leave as dummy function
	// ab 2.04.02 - switch focus to ambulance case if enabled
	//var objAmb=document.getElementById('MRADMAmbulanceCase');
	//if ((objAmb)&&(objAmb.disabled==false)) objAmb.focus()
	//else websys_nextfocus(obj.sourceIndex);
}

function arrivalTransLookUp(str) {
	var lu = str.split("^");
	var objTRANSMDesc=document.getElementById("TRANSMDesc");
	if (objTRANSMDesc) { objTRANSMDesc.value=lu[0]; }	
	ReplaceHiddenCodeGlobal(14,lu[2],lu[3]);
	try {
		Custom_arrivalTransLookUp(str);
	} catch(e) { 
		}	finally  {
	}
}

function OLDdepartureTransLookUp() {
	// a dummy function to allow a custom departureTransLookUp funtion to be used
}

function departureTransLookUp(str) {
	var lu = str.split("^");
	var objTRANSPDesc=document.getElementById("TRANSPDesc");
	if (objTRANSPDesc) { objTRANSPDesc.value=lu[0]; }	
	ReplaceHiddenCodeGlobal(12,lu[2],lu[3]);
	try {
		Custom_departureTransLookUp(str);
	} catch(e) { 
		}	finally  {
	}
}

//md Created bunch of js selectehandlers

function ReasonDelayDischargeSelect(str) {
	var lu = str.split("^");
	var objREADELDesc=document.getElementById("READELDesc");
	if (objREADELDesc) { objREADELDesc.value=lu[0]; }	
	ReplaceHiddenCodeGlobal(8,lu[2],lu[3]);
	try {
		Custom_ReasonDelayDischargeSelect(str);
	} catch(e) { 
		}	finally  {
	}

}

function DispositSelect(str) {
	var lu = str.split("^");
	var objCTDSPDesc=document.getElementById("CTDSPDesc");
	if (objCTDSPDesc) { objCTDSPDesc.value=lu[0]; }	
	ReplaceHiddenCodeGlobal(18,lu[2],lu[3]);
	try {
		Custom_DispositSelect(str);
	} catch(e) { 
		}	finally  {
	}

}

function DischConditSelect(str) {
	var lu = str.split("^");
	var objDISCONDesc=document.getElementById("DISCONDesc");
	if (objDISCONDesc) { objDISCONDesc.value=lu[0]; }	
	ReplaceHiddenCodeGlobal(17,lu[2],lu[4]);
	try {
		Custom_DischConditSelect(str);
	} catch(e) { 
		}	finally  {
	}

}

function SourceOfAttendanceSelect(str) {
	var lu = str.split("^");
	var objATTENDDesc=document.getElementById("ATTENDDesc");
	if (objATTENDDesc) { objATTENDDesc.value=lu[0]; }	
	ReplaceHiddenCodeGlobal(6,lu[1],lu[6]);
	try {
		Custom_SourceOfAttendanceSelect(str);
	} catch(e) { 
		}	finally  {
	}

}

function AdmSourceSelect(str) {
	var lu = str.split("^");
	var objADSOUDesc=document.getElementById("ADSOUDesc");
	if (objADSOUDesc) { objADSOUDesc.value=lu[0]; }	
	ReplaceHiddenCodeGlobal(5,lu[1],lu[3]);
	try {
		Custom_AdmSourceSelect(str);
	} catch(e) { 
		}	finally  {
	}

}

function PreferredLanguageSelect(str) {
	var lu = str.split("^");
	var objPREFLDesc=document.getElementById("PREFLDesc");
	if (objPREFLDesc) { objPREFLDesc.value=lu[0]; }	
	ReplaceHiddenCodeGlobal(1,lu[2],lu[3]);
	try {
		Custom_PreferredLanguageSelect(str);
	} catch(e) { 
		}	finally  {
	}

}

function TransferDestination2Select(str) {
	var lu = str.split("^");
	var objTRD2Desc=document.getElementById("TRD2Desc");
	if (objTRD2Desc) { objTRD2Desc.value=lu[0]; }	
	ReplaceHiddenCodeGlobal(13,lu[2],lu[3]);
	try {
		Custom_TransferDestination2Select(str);
	} catch(e) { 
		}	finally  {
	}

}

function MaritalSelect(str) {
	var lu = str.split("^");
	var objCTMARDesc=document.getElementById("CTMARDesc");
	if (objCTMARDesc) { objCTMARDesc.value=lu[0]; }	
	ReplaceHiddenCodeGlobal(0,lu[2],lu[3]);
	try {
		Custom_MaritalSelect(str);
	} catch(e) { 
		}	finally  {
	}

}

function TransferDestinationSelect(str) {
	var lu = str.split("^");
	var objTRDDesc=document.getElementById("TRDDesc");
	if (objTRDDesc) { objTRDDesc.value=lu[0]; }	
	ReplaceHiddenCodeGlobal(11,lu[2],lu[3]);
	try {
		Custom_TransferDestinationSelect(str);
	} catch(e) { 
		}	finally  {
	}

}

function AdmReasonSelect(str) {
	var lu = str.split("^");
	var objREADesc=document.getElementById("READesc");
	if (objREADesc) { objREADesc.value=lu[0]; }	
	ReplaceHiddenCodeGlobal(4,lu[2],lu[3]);
	try {
		Custom_AdmReasonSelect(str);
	} catch(e) { 
		}	finally  {
	}
}

function ReferralTypeSelect(str) {
	var lu = str.split("^");
	var objREFTDesc=document.getElementById("REFTDesc");
	if (objREFTDesc) { objREFTDesc.value=lu[0]; }	
	ReplaceHiddenCodeGlobal(2,lu[2],lu[3]);
	try {
		Custom_ReferralTypeSelect(str);
	} catch(e) { 
		}	finally  {
	}
}

//md Created bunch of js selectehandlers

function CareProvLookUpSelect(str) {

}

//populate the hidden field "doctor code" with the row_id of referring doctor to pass to
//view details

function ViewDoctorHandler(e) {

	var obj=websys_getSrcElement(e)
	var objid=document.getElementById("doctorCode")
	var view=document.getElementById("viewDr")
	view.value="1"
	var url="websys.default.csp?WEBSYS.TCOMPONENT=PACRefDoctor.Edit&ID="+objid.value+"&viewDr="+view.value
	websys_lu(url,false,"width=350,height=480")
	return false;
}

function ViewDoctorLookUp(str) {
	//structure as on 16/10/2003
	//DocTitle,DocDesc,DocMname,DocFname,refdId,DocCode,DocSpec,ClinCode,clinId,ClinProvNo,ClinAddr,ClinSuburb,tele,clindatefrom,clindateto,expired,type,ClinDesc,ClinCity,ClinZip)
	//  0	     1	     2	     3	      4	     5 	      6	     7         8      9	        10	  11	     12	  13	       14        15    16   17		18	19
	// MD 16.10.2003
	var lu = str.split("^");
	var obj;
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
	// Set Referal Doctor Code to hidden field
	obj=document.getElementById("REFDCode")
	if (obj) obj.value = lu[5]
	obj=document.getElementById("REFDDesc")
	if (obj) obj.value = lu[1]
	//--
	obj=document.getElementById("doctorCode");
	if (obj) obj.value = lu[4];
	obj=document.getElementById("ReferralClinicAddress");
	if (obj) {
		//obj.value = lu[7];
		obj.value = fulladdress;
		//obj.disabled=true
	}
 	obj=document.getElementById("PAADMRefDocClinicDR");
	if (obj) obj.value = lu[8];
	obj=document.getElementById("REFDTitle");
	if (obj) obj.value = lu[0];
 	obj=document.getElementById("REFDForename");
	if (obj) obj.value = lu[3];

}

function RefDocChangeHandler(e) {
	var obj;
	var obj2;
	var obj2=document.getElementById("REFDDesc")
	if ((obj2)&&(obj2.value=="")) {
		var obj=document.getElementById("PAADMRefDocClinicDR")
		if (obj) obj.value = "";
		var obj=document.getElementById("ReferralClinicAddress")
		if (obj) obj.value = "";
		var obj=document.getElementById("REFDCode")
		if (obj) obj.value = "";
		var obj=document.getElementById("REFDForename")
		if (obj) obj.value="";
		var obj=document.getElementById("REFDTitle")
		if (obj) obj.value="";
	}
}


//populate the hidden field "familyDrCode" with the row_id of family doctor to pass to
//view details

function ViewFamilyDrHandler(e) {
	var obj=websys_getSrcElement(e)
	//var url="websys.default.csp?WEBSYS.TCOMPONENT=PACRefDoctor.Edit&ID="
	var objid=document.getElementById("FamREFDId")
	//url += objid.value
	var view=document.getElementById("viewDr")
	view.value="1"
	//url += view.value
	var url="websys.default.csp?WEBSYS.TCOMPONENT=PACRefDoctor.Edit&ID="+objid.value+"&viewDr="+view.value
	//alert(url)
	websys_lu(url,false,"width=350,height=480")
	return false;
}

function ViewFamilyDrLookUp(str) {
	//alert(str);
 	var lu = str.split("^");
	var obj;
	obj=document.getElementById("FamREFDCode")
	if (obj) obj.value = lu[5]
	obj=document.getElementById("REFDDescFam")
	if (obj) obj.value = lu[1]
	obj=document.getElementById("REFDTitleFam")
	if (obj) obj.value = lu[0]
	obj=document.getElementById("REFDFnameFam")
	if (obj) obj.value = lu[3]
	
 	obj=document.getElementById("FamREFDId")
	if (obj) obj.value = lu[4];
	
	obj=document.getElementById("FamilyClinicAddress");
	if (obj) obj.value = lu[29];
	obj=document.getElementById("PAPERFamilyDoctorClinicDR");
	if (obj) obj.value = lu[8];
	
	confirmChangeDoc();
	
	/*
	obj=document.getElementById("FamREFDCode")
	if (obj) obj.value = lu[0]
	obj=document.getElementById("REFDDescFam")
	if (obj) obj.value = lu[1]
	//--
 	obj=document.getElementById("familyDrCode")
	if (obj) obj.value = lu[2];
	obj=document.getElementById("FamilyClinicAddress");
	if (obj) obj.value = lu[4];
	obj=document.getElementById("PAPERFamilyDoctorClinicDR");
	if (obj) obj.value = lu[6];
	*/
	
}

// cjb 24/05/2005 52367 - copied these functions here, from PAPerson.Edit.js
function confirmChangeDoc() {
	// ab 17.10.02 - to confirm saving old doctor
	var obj=document.getElementById("REFDDescFam")
	var objmagp=document.getElementById("MultiActiveGP");
	var objDrId=document.getElementById("FamREFDId");
	var objClinId=document.getElementById("PAPERFamilyDoctorClinicDR");
	
	// cjb 23/05/2005 52370 - ask the question if the Dr or Clinic RowId's have changed (previously only checked the Dr Surname...)
	if ((obj)&&(obj.value!="")&&((objDrId.value!=objDrId.defaultValue)||(objClinId.value!=objClinId.defaultValue))) {
		if (((objmagp)&&(objmagp.value!="Y"))||(!objmagp)) {
			if ((!AskedForSaveDoc)&&(obj.defaultValue!="")) {
				AskedForSaveDoc=1;
				registeringDocChange();
			}
		}
		if ((objmagp)&&(objmagp.value=="Y")) {
			if ((!AskedForActiveDoc)&&(obj.defaultValue!="")) {
				AskedForActiveDoc=1;
				registeringDocActiveChange();
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
		if (confirm(t["KeepActiveGP"])) {
			document.getElementById("KeepActiveGP").value=1;
		} else {
			document.getElementById("KeepActiveGP").value=0;
		}
	}

}


function FamDocChangeHandler(e) {
	var obj;
	var obj2;
	obj2=document.getElementById("REFDDescFam")
	if ((obj2)&&(obj2.value==""))
	{
	obj=document.getElementById("PAPERFamilyDoctorClinicDR")
	if (obj) obj.value = "";
	obj=document.getElementById("FamilyClinicAddress")
	if (obj) obj.value = "";
	obj=document.getElementById("FamREFDCode")
	if (obj) obj.value = "";
	}
}

var selectedDISCON="";
function SetDischargeConditionCheckbox(e) {
	var obj=document.getElementById('DISCONDesc');
	if (!obj) {alert(t['DISCONDesc']+" "+t['XMISSING']);return;}
	var eSrc=websys_getSrcElement(e);
	//21/1/2002: if unchecking don't do anything;
	if (!eSrc.checked) return;
	if ((selectedDISCON!="")&&(selectedDISCON!=eSrc.id)) {
		var cbx=document.getElementById(selectedDISCON);
		if (cbx) cbx.checked=false;
	}
	selectedDISCON=eSrc.id;
	obj.value = t[eSrc.id];
}

//functions used to enable/disable fields and display label as mandatory/non mandatory
//presently called by custom script for Austin, but left here for general use



function UpdateAndOpenWordDoc() {
	var obj=document.getElementById('PAADMType');
	if (obj.value!="E") {alert(t['InvalidAdmType']); return false;}
	//log 61673 EZ 22/11/2006 VALIDATION OF LOCATION
	var obj=document.getElementById('CTLOCDesc');
	alert (obj.className)
	if (obj.className="clsInvalid") {alert(t['InvalidAdmType']); return false;}
	
	if (!CheckRequiredFields()) { return false; }
	UpdateEmerCond();
	UpdateAllergies();
	UpdateDobFromAge();
	if (window.name=="discharge_top") {
		if (frm.elements['TWKFL']!="") frm.elements['TFRAME'].value=window.parent.name;
	}
	return OpenWordDoc_click();
}

function OpenWordDoc() {

	var objWrdApp = new ActiveXObject("Word.Application");
	//var objWrdDoc = new ActiveXObject("Word.Document");

	objWrdApp.visible=true;

	if (objWrdApp) {
		//var wrdDoc=wrdApp.documents.Add();
		var objTemplatePath=document.getElementById('TemplatePath');
		//var template=document.getElementById("TemplateName")
		if (objTemplatePath) {
			var strTemplatePath = objTemplatePath.value+"/"
			var objWrdDoc = objWrdApp.Documents.Add(strTemplatePath+"ARMC.dot");
			if (objWrdDoc) {
				var objEpisodeID=document.getElementById('EpisodeID');
				if (objEpisodeID) {
					var strEpisodeID=objEpisodeID.value
					objWrdDoc.Variables.Add("EpisodeID",strEpisodeID);
					objWrdApp.Run("Medtrak");
					var FileSavePath=FilePathAndName()
					if (FileSavePath!="") {
						objWrdDoc.SaveAs(FileSavePath);
					}
				}
			}
		}
	}

	//Close word with the Quit method on the Application object.
	//objWrdApp.Application.Quit();

}

function FilePathAndName() {
	var obj=document.getElementById('SaveFilePath');
	if (obj) var strSaveFilePath=obj.value

	obj=document.getElementById('SaveFileSubDir');
	if (obj) var strSaveFileSubDir=obj.value

	obj=document.getElementById('SaveFileName');
	if (obj) var strSaveFileName=obj.value

	if ((strSaveFilePath!="") && (strSaveFileSubDir!="") && (strSaveFileName!="")) {
		//.doc extension hardcoded to be saved for word documents only
		strFilePathAndName = strSaveFilePath+strSaveFileSubDir+strSaveFileName+".doc"
		strFilePath = strSaveFilePath+strSaveFileSubDir
	}
	CreateFilePath(strFilePath)
	return strFilePathAndName
}

function CreateFilePath(FilePath) {
	var objFileSys = new ActiveXObject("Scripting.FileSystemObject");

	// SA: Check if directory for document to be saved exists. If not,create it.
	// A single backslash is a specific character in JS, so directory path must
	// have a second backslash for each backslash. Comparison also requires "\\"
	// when comparing "\"

	for (var i=0; i<FilePath.length; i++) {
	strFilePath+=FilePath.charAt(i);
	if (FilePath.charAt(i)=="\\") strFilePath+="\\";
	}

	//alert(strFilePath)

	if (!objFileSys.FolderExists(FilePath)) {
		objFileSys.CreateFolder(FilePath);
	}
}

/*function CheckForNewDeceasedEpisode(){
	//alert("checking");
	var obj1=document.getElementById("EpisodeID");
	//if (obj1) alert(obj1.value);
	var obj2=document.getElementById("isDeceased");
	//if (obj2) alert(obj2.value);
	if ((obj1.value=="")&&(obj2.value=="Y")) {
		alert("Deceased Patients cannot have new admissions");
	}
} */
function PAADMDischgDateChange(){
	var pobj=document.getElementById('PAADMDischgDate');
	if ((pobj)&&(pobj.value=="")) {
		DisableCheckbox('DiscontAll');
	} else {
		EnableField('DiscontAll');
	}
	//
	var pobj=document.getElementById('PAADMDischgDate');
	var objCT=document.getElementById("CodeTableValidationDate");
	if ((pobj)&&(objCT)) {
		if (pobj.value!="") {
			objCT.value=DateStringTo$H(pobj.value);
			//EnableField('DiscontAll');
			//alert(objCT.value);
		} else {
			objCT.value=objCT.defaultValue;
			//DisableField('DiscontAll');
			//alert(objCT.value);
		}
	
	//
}
}

// cjb 04/08/2003 37101
function PAAdm_ReverseDischargeHandler(lnk,win) {
	var PatientID=document.getElementById('PatientID').value;
	var EpisodeID=document.getElementById('EpisodeID').value;
	var mradm=document.getElementById('mradm').value;
	websys_createWindow("websys.default.csp?WEBSYS.TCOMPONENT=MRAdm.ReverseDischargeEdit&PatientID="+PatientID+"&EpisodeID="+EpisodeID+'&mradm='+mradm+'&ID='+mradm+"&PatientBanner=1",'comp','top=20,left=20,width=300,height=100,scrollbars=yes,resizable=yes');
}

function PAAdm_ChangeStatusHandler() {
	var pat=document.getElementById("PatientID")
	if (pat) pat=pat.value;
	var ID=document.getElementById("EpisodeID")
	if (ID) ID=ID.value;
	var Status=document.getElementById("PAADMVisitStatus")
	if (Status) Status=Status.value;

	if ((ID)&&(Status)) websys_createWindow('websys.default.csp?WEBSYS.TCOMPONENT=PAAdm.ChangeStatus&EpisodeID='+ID+'&PatientID='+pat+'&presentStatus='+Status+'&PatientBanner=1','Prompt','top=0,left=0,width=300,height=300');
}

//TN: 21-Jun-2002: reload listboxes with values in hidded fields.
//this is due to page being refreshed upon error message (such as invalid pin)
function ReloadListBoxes() {
	AllergyReload();
	EmergCondReload();
}
//TN: 21-Jun-2002: call this outside onload call so it can be called straight away, and not wait till everything has loaded.
ReloadListBoxes();

// cjb 10/09/2003 39031
function PAADMAdmDateTimeHandler(e) {
	PAADMAdmDate_changehandler(e);
	var objD=document.getElementById('PAADMAdmDate');

	if ((objD)&&(objD.value!="")) {
		var objDh=DateStringTo$H(objD.value);
		//alert("objDh="+objDh);
	}

	var obj=document.getElementById('CodeTableValidationDate');
	if ((obj)&&(obj.value!="")) {
		if ((objDh)&&(objDh.value!="")) {
			obj.value=objDh;
		}
	}
	
	try {
		Custom_PAADMAdmDateTimeHandler(e);
	} catch(e) { 
		}	finally  {
	}
	
	//obj=document.getElementById('InsurPayor')
	//if (obj) obj.onchange();
	//obj=document.getElementById('InsurPlan')
	//if (obj) obj.onchange();
}

// cjb 17/05/2006 54485 - moved this out of Init so if the layout has a default date this change handler will run
obj=document.getElementById('PAADMAdmDate');
if (obj) obj.onchange=PAADMAdmDateTimeHandler;


// cjb 10/09/2003 39031
function PlanLookupSelect(str) {
	//alert(str);
 	var lu = str.split("^");
 	var obj=document.getElementById("InsurPlan")
	if (obj) obj.value = lu[0];
 	obj=document.getElementById("InsurPayor")
	if (obj) obj.value = lu[1];
	//md LOG 54261
	obj=document.getElementById("payCode")
	if (obj) obj.value = lu[5];
	obj=document.getElementById("InsurPayorID")
	if (obj) obj.value = lu[3];
	//md LOG 54261
	
 }

//md 03/05/2004 Log 43244
function ResponsibleForPaySelect(str) {
	//MD
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
function ResponsibleForPayBlur(e) {
	//MD
	var obj=document.getElementById("RespForPaySelect")
	if ((obj)&&(obj.value=="")) {
	obj=document.getElementById("paadm2panokdr")
	if (obj) obj.value = "";
 	obj=document.getElementById("RespForPayList");
	if (obj) obj.value = "";

	}

}

function CTPCPDescLookupSelect(str) {
	try {
		Custom_CTPCPDescLookupSelect(str);
	} catch(e) {
	} finally  {
		var lu=str.split("^");
		var obj=document.getElementById("CTPCPCode");
		if (obj) obj.value=lu[2];
	}
}

function CTPCPDescBlurHandler() {
	var objcode=document.getElementById("CTPCPCode");
	var obj=document.getElementById("CTPCPDesc");
	if ((obj)&&(objcode)&&(obj.value=="")) objcode.value="";
}

// cjb 07/01/2005 45882
function MRADMGlasgowComaScoreChangeHandler() {
	obj=document.getElementById('MRADMGlasgowComaScore')
	if ((obj)&&(obj.value>15)) {
		alert("\'" + t['MRADMGlasgowComaScore'] + "\' " + t['XINVALID'] + "\n");
		obj.className="clsInvalid"
		websys_setfocus('MRADMGlasgowComaScore');
		//obj.value="";
	}
	if ((obj)&&(obj.value<0)) {
		alert("\'" + t['MRADMGlasgowComaScore'] + "\' " + t['XINVALID'] + "\n");
		obj.className="clsInvalid"
		websys_setfocus('MRADMGlasgowComaScore');
		//obj.value="";
	}
}

function MRADMPainScoreChangeHandler() {
	obj=document.getElementById('MRADMPainScore')
	if ((obj)&&(obj.value>10)) {
		alert("\'" + t['MRADMPainScore'] + "\' " + t['XINVALID'] + "\n");
		obj.className="clsInvalid"
		websys_setfocus('MRADMPainScore');
		//obj.value="";
	}
	if ((obj)&&(obj.value<0)) {
		alert("\'" + t['MRADMPainScore'] + "\' " + t['XINVALID'] + "\n");
		obj.className="clsInvalid"
		websys_setfocus('MRADMPainScore');
		//obj.value="";
	}
}

function TriageSymptomsClickHandler() {
	var epi=document.getElementById('EpisodeID').value;
	var pat=document.getElementById('PatientID').value;
	var CONTEXT=session["CONTEXT"];
	var SympProID=document.getElementById('SympProID').value;
	websys_createWindow("paadm.TriageSympFull.csp?PatientID="+pat+"&EpisodeID="+epi+"&SympProID="+SympProID+'&CONTEXT='+CONTEXT+'&PatientBanner=1','MentalHealth',"top=30,left=20,width=620,height=420,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes");
	return false;
}

function setTrisymp() {
	var obj=document.getElementById('HiddenCodes');
	if (obj) {
		var hiddenCodes=obj.value.split("^");
		var objTriSympID=document.getElementById('SympProID');
		if ((objTriSympID)&&(hiddenCodes[19])) { objTriSympID.value=hiddenCodes[19]; }
		}

}

function REClearInsurPayor() {
	var obj=document.getElementById('InsurPayor')
	if ((obj)&&(obj.value==""))
	{
	obj=document.getElementById("payorCategory")
	if (obj) obj.value = ""
	var obj=document.getElementById('InsurPlan')
	if (obj) obj.value="";
	obj=document.getElementById("payCode")
	if (obj) obj.value = ""
	obj=document.getElementById("InsurPayorID")
	if (obj) obj.value = "";
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
//md 15th Of Augustius 2005


// cjb 09/01/2005 55848 - copied from PAPerson.Edit.js
function setNames() {
	//var viewVIP=document.getElementById('AllowViewVIP');
	var VIPStat=document.getElementById('VIPStatus');
	var surname=document.getElementById('PAPERName');
	var firstname=document.getElementById('PAPERName2');
	var middlename=document.getElementById('PAPERName3');
	var PAPERName4=document.getElementById('PAPERName4');
	var PAPERName5=document.getElementById('PAPERName5');
	var PAPERName6=document.getElementById('PAPERName6');
	var PAPERName7=document.getElementById('PAPERName7');
	var PAPERName8=document.getElementById('PAPERName8');
	 
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

function SyncCTdates() {

	var obj=document.getElementById('CodeTableValidationDate');
	var obj1=document.getElementById('CTDate');
	if ((obj)&&(obj1)) {
	if (obj1.value!="") { obj.value=obj1.value }
	
	}
}
///LOG 61673 EZ 22/11/2006 Extra validation is created to prevent Users from entering a non valid fields 
function CheckInvalidFields() {
	if (evtTimer) {
		setTimeout('CheckInvalidFields()',200)
	} else {
		for (var j=0; j<document.fPAAdm_EditEmergency.elements.length; j++) {
			if (document.fPAAdm_EditEmergency.elements[j].className=='clsInvalid') {
				websys_setfocus(document.fPAAdm_EditEmergency.elements[j].name);
				if (((document.fPAAdm_EditEmergency.elements[j].name)!="PIN" )&&((document.fPAAdm_EditEmergency.elements[j].name)!="UserCode" ))
				{
				alert(t[document.fPAAdm_EditEmergency.elements[j].name]+": "+  t['XINVALID'] + "\n");
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

//07/12/2006 EZ LOG 49183 episode alerts displayed depending on EpisodeDate and security group settings
function CheckEpisodeAlerts() {
	var obj=document.getElementById("CheckAlerts");
	//alert (obj.value)
	if ((obj)&&(obj.value!="")) {
//		var obj1=document.getElementById("PAADMConfidentMessage");
//		if ((obj1)&&(obj1.value!="")) {
			alert (obj.value);
//		}
	}
	
}

function alertIfFA() {
  var visit=document.getElementById('PAADMVisitStatus').value;
 var fastring=""
 var faparams=document.getElementById('FAparams');
 if  (faparams) fastring=faparams.value;
 if ((visit!="")&&(visit!="A")) return true;
 var obj=document.getElementById('EpisodeID');
 if ((obj)&&(obj.value!="")) return true;
 var obj=document.getElementById("IsPatientFA");
 var frm=document.fPAAdm_EditEmergency;
 if ((obj)&&(obj.value==1))
  {
 //if ((frm)&&(frm.TDIRTY.value==1)) {
 var fastingspl=fastring.split("^");
 var valuestr="";
 if (fastingspl[5]=="M")  valuestr=t['UnitMonths']
 if (fastingspl[5]=="D")  valuestr=t['UnitDays']
 if (fastingspl[5]=="Y")  valuestr=t['UnitYears']
 
  alert(t['FAAlert']+ "\n"+fastingspl[3]+" "+t['FAAlert2']+fastingspl[4]+" "+valuestr)
  //}
  //objul.value=1;
    }
}
//log 62402
function PAADMAdmTimeChangeHandler(e) {
	PAADMAdmTime_changehandler(e) 
}

function PAADMDischgDateChangeHandler(e) {
	PAADMDischgDate_changehandler(e) 
}

function PAADMDischgTimeChangeHandler(e) {
	PAADMDischgTime_changehandler(e) 
}

function INSSafetyNetCardExpDateChangeHandler(e) {
	INSSafetyNetCardExpDate_changehandler(e) 
}

function MarkRO() {
     //alert("It will mark as RO");
      DisableAllFields("",",update1,tbM2149,tbM2151,","",1);
      var obj=document.getElementById('PAADMReadOnly');
      if (obj) { obj.value='Y' }
}

function UNMarkRO() {
     //alert("It will UNmark as RO");
     NEnableAllFields(1,"","",1)
     var obj=document.getElementById('PAADMReadOnly');
      if (obj) { obj.value='N' }
}

function CheckROONLoad() {

	var obj=document.getElementById('PAADMReadOnly');
      if ((obj)&&(obj.value=='Y')) 
      {
      MarkRO();
      }

}

var PAADMAdmTimeObj=document.getElementById("PAADMAdmTime");
if (PAADMAdmTimeObj) PAADMAdmTimeObj.onchange=PAADMAdmTimeChangeHandler;
var PAADMDischgDateObj=document.getElementById("PAADMDischgDate");
if (PAADMDischgDateObj) PAADMDischgDateObj.onchange=PAADMDischgDateChangeHandler;
var PAADMDischgTimeObj=document.getElementById("PAADMDischgTime");
if (PAADMDischgTimeObj) PAADMDischgTimeObj.onchange=PAADMDischgTimeChangeHandler;
var INSSafetyNetCardExpDateObj=document.getElementById("INSSafetyNetCardExpDate");
if (INSSafetyNetCardExpDateObj) INSSafetyNetCardExpDateObj.onchange=INSSafetyNetCardExpDateChangeHandler;

document.body.onload=Init;

