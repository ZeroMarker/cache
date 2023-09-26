var preobj=document.getElementById('fOEOrdItem_PreExam');
var preLMP=preobj.elements('OEORILMPDate');
if (preLMP) preLMP.onblur=DateBlurHandler;

function DateBlurHandler() {
	var preobj=document.getElementById('fOEOrdItem_PreExam');
	var postobj=document.getElementById('fOEOrdItem_PostExam');
	var preLMP=preobj.elements('OEORILMPDate');
	var preLMPval=preLMP.value
	var postLMP=postobj.elements('OEORILMPDate');
	if ((preLMP) && (postLMP)) {
		postLMP.value=preLMPval;
		postLMP.disabled=true;
		if (preLMPval=="") postLMP.disabled=false;
	}
}

function PreUserNameSelectHandler(str) {
	var lu = str.split("^");
	var obj=document.getElementById("PreExamUserName")
	if (obj) obj.innerText = lu[1];

}

function OEORIPreExamUser_changehandler(encmeth) {	//have to have for broker only!!!
	var obj=document.getElementById('OEORIPreExamUser');
	var p1='';
	if (obj) p1=obj.value;
	var obj=document.getElementById('OEORIPreExamUser');
	if (cspRunServerMethod(encmeth,'','PreUserNameSelectHandler',p1)=='0') {
		obj.className='clsInvalid';  ///generic name to check all fields.
		obj.focus();
		return websys_cancel();
	} else {
		obj.className='';
	}
}


function DisableFemaleField(fldName,icN) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if ((fld)&&(fld.tagName=="INPUT")) {
		//alert("ok Disabling fldName="+fldName);
		//alert("flddis")
		fld.value = "";
		fld.disabled = true;
		fld.className = "disabledField";
		if (lbl) lbl = lbl.className = "";
	}
	if (icN) {
		var objIcon=document.getElementById(icN);
		if (objIcon) objIcon.style.visibility = "hidden";
	}
}

function EnableFemaleField(fldName) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if (fld) {
		fld.disabled = false;
		fld.className = "";
		if (lbl) lbl = lbl.className = "clsRequired";
	}
}

function DisableField(fldName,icN) {
	var fld = document.getElementById(fldName);
	if (fld) {
		fld.disabled = true;
	}
	if (icN) {
		var objIcon=document.getElementById(icN);
		if (objIcon) objIcon.style.visibility = "hidden";
	}

}

function DisablePostExamField(fldName,icN) {
	var fld = eval("document.fOEOrdItem_PostExam." + fldName);
	if (fld) {
		fld.disabled = true;
	}
	if (icN) {
		var objIcon=eval("document.fOEOrdItem_PostExam." + icN);
		if (objIcon) objIcon.style.visibility = "hidden";
	}

}

function Disable_Handler() {

	DisableField("OEORIDepProcNotes","ld1310iOEORIDepProcNotes");
	DisableField("OEORIAssistantDR","ld1310iOEORIAssistantDR");
	DisableField("OEORIPersonInjectDR","ld1310iOEORIPersonInjectDR");
	DisableField("OEORIDepProcNotesLast","ld1310iOEORIExamStartTime");
	DisableField("OEORIQty","ld1310iOEORIQty");
	DisableField("OEORIPostExamStartTime","ld1310iOEORIPostExamStartTime");
	DisableField("OEORIPreExamUserLast","ld1310iOEORIExamStartTime");
	DisableField("OEORILMPDate","ld1310iOEORILMPDate");
	DisableField("ARCIMDesc","ld1310iARCIMDesc");
	DisableField("PINPre","ld1310iPINPre");
	DisableField("OEORIPatientIDChecked","ld1310iOEORIPatientIDChecked");
	DisableField("OEORIPregnancyCheck","ld1310iOEORIPregnancyCheck");
	DisableField("OEFilmItems","ld1310iOEFilmItems");
	DisableField("OEORIRBResourceDR","ld1310iOEORIRBResourceDR");
	DisableField("OEORIPreExamUser","ld1310iOEORIPreExamUser");

	DisablePostExamField("OEORIDepProcNotes","ld1234iOEORIDepProcNotes");
	DisablePostExamField("OEORIAssistantDR","ld1234iOEORIAssistantDR");
	DisablePostExamField("OEORIDoctorExecutedDR","ld1234iOEORIDoctorExecutedDR");
	DisablePostExamField("OEORIPersonInjectDR","ld1234iOEORIPersonInjectDR");
	DisablePostExamField("OEORIContrastBatchNumber","ld1234iOEORIContrastBatchNumber");
	DisablePostExamField("OEORIContrastExpiryDate","ld1234iOEORIContrastExpiryDate");
	DisablePostExamField("OEORIContrastTypeDR","ld1234iOEORIContrastTypeDR");
	DisablePostExamField("OEORIContrastVolume","ld1234iOEORIContrastVolume");
	DisablePostExamField("OEORIDepProcNotesLast","ld1234iOEORIDepProcNotesLast");
	DisablePostExamField("OEORIDateExecuted","ld1234iOEORIDateExecuted");

	DisablePostExamField("OEORIQty","ld1234iOEORIQty");
	DisablePostExamField("OEORIExamStartTime","ld1234iOEORIExamStartTime");
	DisablePostExamField("OEORIExposureKV","ld1234iOEORIExposureKV");
	DisablePostExamField("OEORIExposuremAs","ld1234iOEORIExposuremAs");
	DisablePostExamField("FilmsRejectedList","ld1234iFilmsRejectedList");
	DisablePostExamField("FilmsUsedList","ld1234iFilmsUsedList");
	DisablePostExamField("OEORIInjectionTime","ld1234iOEORIInjectionTime");
	DisablePostExamField("FilmIsotopeDose","ld1234iFilmIsotopeDose");
	DisablePostExamField("OEORIPostExamUserLast","ld1234iOEORIPostExamUserLast");
	DisablePostExamField("OEORILMPDate","ld1234iOEORILMPDate");

	DisablePostExamField("FilmsRejectedNumber","ld1234iFilmsRejectedNumber");
	DisablePostExamField("FilmsUsedNumber","ld1234iFilmsUsedNumber");
	DisablePostExamField("PINPost","ld1234iPINPost");
	DisablePostExamField("FilmIsotopePharmac","ld1234iFilmIsotopePharmac");
	DisablePostExamField("FilmIsotopeList","ld1234iFilmIsotopeList");
	DisablePostExamField("FilmsRejectedReason","ld1234iFilmsRejectedReason");
	DisablePostExamField("OEORIRBResourceDR","ld1234iOEORIRBResourceDR");
	DisablePostExamField("OEORIScreeningTime","ld1234iOEORIScreeningTime");
	DisablePostExamField("OEORIConsultDrDR","ld1234iOEORIConsultDrDR");
	DisablePostExamField("OEORITimeExecuted","ld1234iOEORITimeExecuted");

	DisablePostExamField("FilmsRejectedType","ld1234iFilmsRejectedType");
	DisablePostExamField("FilmsUsedType","ld1234iFilmsUsedType");
	DisablePostExamField("OEORIPostExamUser","ld1234iOEORIPostExamUser");
	DisablePostExamField("FilmIsotopeAdd","ld1234iFilmIsotopeAdd");
	DisablePostExamField("FilmsUsedDelete","ld1234iFilmsUsedDelete");
	DisablePostExamField("FilmsRejectedAdd","ld1234iFilmsRejectedAdd");
	DisablePostExamField("FilmsRejectedDelete","ld1234iFilmsRejectedDelete");
	DisablePostExamField("FilmIsotopeAdd","ld1234iFilmIsotopeAdd");
	DisablePostExamField("FilmIsotopeDelete","ld1234iFilmIsotopeDelete");

}

function CheckFemaleHandler() {
	var RFobj=document.getElementById("RestrictFemale");
	//LOG 36495 RC 17/06/03 Make a check to see if it's disabled before enabling or disabling
	if (RFobj && RFobj.disabled!=true) {
		if (RFobj.value=="Y") {
			//alert("Female");
			var preobj=document.getElementById("OEORIPregnancyCheck");
			var lmpobj=document.getElementById("OEORILMPDate");
			if (preobj && preobj.value=="") {
				alert(t['PRECHECK_MAN']);
				return false;
			} else if (lmpobj && lmpobj.value=="") {
				alert(t['LMPDATE_MAN']);
				return false;
			} else {
				return updatePre_click();
			}
		} else {
			return updatePre_click();
		}
	} else {
		return updatePre_click();
	}
}

function setBoldLinks(el,state) {
	obj=document.getElementById('PAAlertMsg');
	if ((obj) && (state=="1")) obj.style.fontWeight="bold";
	var alobj=document.getElementsByName("PAAlertMsg")[1];
	if ((alobj) && (state=="1")) alobj.style.fontWeight="bold";
}

function LoadHandler() {
	var preobj=document.getElementById('fOEOrdItem_PreExam');
	var postobj=document.getElementById('fOEOrdItem_PostExam');
	var preLMP=preobj.elements('OEORILMPDate');
	if (preLMP) var preLMPval=preLMP.value
	var postLMP=postobj.elements('OEORILMPDate');
	if ((preLMP) && (postLMP)) {
		postLMP.value=preLMPval;
		postLMP.disabled=true;
		if (preLMPval=="") postLMP.disabled=false;
	}

	var UPDATE=document.getElementById("updatePre");
	var stat=document.getElementById("OSTATCode").value;
	if (UPDATE) {
		if (stat!="E") {
			UPDATE.onclick=CheckFemaleHandler;
		} else {
			UPDATE.disabled=true;
			UPDATE.onclick="";
		}
	}

	var RFobj=document.getElementById("RestrictFemale");
	//LOG 36495 RC 17/06/03 Make a check to see if it's disabled before enabling or disabling
	//alert(RFobj.value+","+RFobj.disabled)
	if (RFobj && RFobj.disabled!=true) {
		if (RFobj.value=="Y"){
			//alert("Female");
			EnableFemaleField("OEORILMPDate");
			EnableFemaleField("OEORIPregnancyCheck");
		}
		else if(RFobj.value!="Y"){
			//alert("Male");
			DisableFemaleField("OEORILMPDate","ld1310iOEORILMPDate");
			DisableFemaleField("OEORIPregnancyCheck","ld1310iOEORIPregnancyCheck");
		}
	}

	var objBold=document.getElementById('BoldLinks');
	if (objBold) {
		var BoldLink = objBold.value.split("^");
		var obj=document.getElementById('PAAllergy');
		if ((obj) && (BoldLink[6]=="1")) obj.style.fontWeight="bold";
		var alobj=document.getElementsByName("PAAllergy")[1];
		if ((alobj) && (BoldLink[6]=="1")) alobj.style.fontWeight="bold";
		obj=document.getElementById('PAAlertMsg');
		if ((obj) && (BoldLink[3]=="1")) obj.style.fontWeight="bold";
		var alobj=document.getElementsByName("PAAlertMsg")[1];
		if ((alobj) && (BoldLink[3]=="1")) alobj.style.fontWeight="bold";
		var obj=document.getElementById('AllergyEMR');
		if ((obj) && (BoldLink[6]=="1")) obj.style.fontWeight="bold";
	}
	
	//log 61398 TedT
	var change=document.getElementById("ItemDetails");
	if(change && changeItem==0) {
		change.disabled=true;
		change.onclick=function() {return false;};
	}
}

document.body.onload=LoadHandler;