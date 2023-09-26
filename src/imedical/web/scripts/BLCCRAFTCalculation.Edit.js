// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

// RQG 22.11.02 - Log29162: This component is created to calculate CRAFT Score for a 
// hypothetical patient episode 

function DocumentLoadHandler() {
	var objCRAFTScore=document.getElementById("CRAFTScore");
	var objViewCRAFTDetails=document.getElementById("ViewCRAFTDetails");
	var objSameDay=document.getElementById("SameDay");
	var objLOS=document.getElementById("LOS");
	var objAdmBarthelScore=document.getElementById("AdmBarthelScore");

	if (objAdmBarthelScore) objAdmBarthelScore.onchange=CheckRangeValues;

	if (objLOS) objLOS.onchange=SetSameDayValue;

	if ((objLOS)&&(objLOS.value==1)) {
		if (objSameDay) objSameDay.disabled=false;
	} else {
		if (objSameDay) objSameDay.disabled=true;
	}

	if ((objCRAFTScore)&&(objCRAFTScore.value!="")) {
		if (objViewCRAFTDetails) objViewCRAFTDetails.disabled=false;
	} else {
		if (objViewCRAFTDetails) {
			objViewCRAFTDetails.disabled=true;
			objViewCRAFTDetails.onclick=LinkDisable;
		}
	}
	websys_setfocus("CRAFTVersion");
}

function SetSameDayValue() {
	var objSameDay=document.getElementById("SameDay");
	var objLOS=document.getElementById("LOS");
	if ((objLOS)&&(objLOS.value==1)) {
		if (objSameDay) objSameDay.disabled=false;
	} else {
		if (objSameDay) {
			objSameDay.checked=false;
			objSameDay.disabled=true;
		}
	}
}
function CheckRangeValues() {
	var objAdmBarthelScore=document.getElementById("AdmBarthelScore");
	if (objAdmBarthelScore) {
		if ((objAdmBarthelScore.value < 0)||(objAdmBarthelScore.value > 100)) {
			alert(t['BARTHELSCORE_INVALID']);
			websys_setfocus("AdmBarthelScore");
			return false;
		}
	}
	return true;
}

function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if (el.disabled) {
		return false;
	}
	return true;
}

document.body.onload=DocumentLoadHandler;
