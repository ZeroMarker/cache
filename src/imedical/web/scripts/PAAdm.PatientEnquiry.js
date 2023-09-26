// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var VHFrom="";
var VHTo="";
var RPFrom="";
var RPTo="";
var WVR=""
var objWard=document.getElementById('WARDDesc');
var objLoc=document.getElementById('CTLOCDesc');

function DocumentLoadHandler() {

	var obj=document.getElementById('PAADMType');
	if (obj&&obj.value!="I")  {
		alert(t['NotCorrectAdmType']); 
		DisableAllFields();
		return false; 
	}

	// 11/9/02 Log#27892 HP: When CTLOCDesc is empty populates visit and rest time with that of the ward's.
	if ((objWard)&&(objWard.value!="")) {
		SetWardVisitRestTime();
	//md 04/09/2003
	var objMVRH=document.getElementById('VisitHRange');
	var objMVR=document.getElementById('MRADMMultiVisitingHoursRanges');
	if ((objMVRH)&&(objMVR)&&(objMVR.value=="")) {
	objMVR.value=objMVRH.value;
	}
	if (objMVR) {objMVR.disabled=true;}
	//md	
	}
	var obj=document.getElementById('CTLOCDesc');
	if (obj) obj.onblur=LocationChangeHandler;
	
	var objBold=document.getElementById('BoldLinks');
	if (objBold) {
		var BoldLink = objBold.value.split("^");
		obj=document.getElementById('ContactPerson');
		if ((obj) && (BoldLink[0]=="1")) obj.style.fontWeight="bold";
		obj=document.getElementById('OtherAddresses');
		if ((obj) && (BoldLink[1]=="1")) obj.style.fontWeight="bold";
	}
	
	var objmradmBold=document.getElementById('mradmBoldLinks');
	if (objmradmBold) {
		var mradmBoldLink = objmradmBold.value.split("^");
		obj=document.getElementById('PsychDetails');
		if ((obj) && (mradmBoldLink[0]=="1")) obj.style.fontWeight="bold";
	}
	//md 25/08-003 
	var objpaadmBold=document.getElementById('paadmBoldLinks');
	if (objpaadmBold) {
		var paadmBoldLink = objpaadmBold.value.split("^");
		obj=document.getElementById('SNAPScreen');
		if ((obj) && (paadmBoldLink[6]=="1")) obj.style.fontWeight="bold";
		obj=document.getElementById('ContractCare');
		if ((obj) && (paadmBoldLink[7]=="1")) obj.style.fontWeight="bold";
	}
	//25/08-003
	//md 10.04.2003
	var obj=document.getElementById("REFDDesc")
	if (obj) obj.onblur=InternalDrChangeHandler;
	// cjb 24/01/2005 48979 - now done in the component
	/*
	var obj=document.getElementById('REFDDesc');
	if (obj) obj.onkeydown=REFDDesc_lookuphandlerCustom;
	var obj=document.getElementById('ld1250iREFDDesc');
	if (obj) obj.onclick=REFDDesc_lookuphandlerCustom;
	*/
	//md 10.04.2003
	
	var MentalHealthLink=document.getElementById("PsychDetails");
	if (MentalHealthLink) CheckForMentalHealth();
	
	var obj=document.getElementById('Update')
	if (obj) obj.onclick = UpdateHandler;
	if (tsc['Update']) websys_sckeys[tsc['Update']]=UpdateHandler;
	
	//md 13.08.2004
	var ContrCareObj=document.getElementById("ContractCare");
	if (ContrCareObj)  { ContrCareObj.onclick=ContrCareClickHandler; }
	// 13.08.2004
	SetLinks()

}

function UpdateHandler() {
    var obj=document.getElementById('Update')
	if (obj&&obj.disabled==true) return false;
	// HP Log 32495
	if (!(InquiryFieldsCheck())) return false;
	
	return Update_click();
}

// ab 1.07.04 - 44997
function CheckForMentalHealth()  {
	
	var MentalHealthLink=document.getElementById("PsychDetails");
	//var MentalHealthFlag=document.getElementById("mentalhealthunit");
	var MentalHealthFlag=document.getElementById('HiddenCodes').value.split("^")[14];
	var episodeID=document.getElementById("EpisodeID");

	if (MentalHealthLink) {
		//if ((episodeID)&&(episodeID.value!="")&&(MentalHealthFlag=="Y")) {
		if ((episodeID)&&(episodeID.value!="")&&(MentalHealthFlag=="Y")&&(CheckMHAgainstBoarder())) {
			MentalHealthLink.disabled=false;
			//MentalHealthLink.onclick=MentalHealthClickHandler;
		} else {
	     		MentalHealthLink.disabled=true;
	     		MentalHealthLink.onclick=LinkDisable;
		}
	}
}

function CheckMHAgainstBoarder() {
	return true;
}

function SetWardVisitRestTime()	{
	var objVHF=document.getElementById('VisitHoursFrom');
	if (objVHF) { VHFrom=objVHF.value;	}
	var objVHT=document.getElementById('VisitHoursTo');
	if (objVHT) { VHTo=objVHT.value;	}
	var objRPF=document.getElementById('RestPeriodFrom');
	if (objRPF) { RPFrom=objRPF.value;	}
	var objRPT=document.getElementById('RestPeriodTo');
	if (objRPT) { RPTo=objRPT.value;	}
	var objWVR=document.getElementById('wardvisitingrange');
	if (objWVR) { WVR=objWVR.value;	}
}

function LocationChangeHandler() {
	var objLoc=document.getElementById('CTLOCDesc');
	if ((objLoc)&&(objLoc.value=="")) {
			var objVHF=document.getElementById('VisitHoursFrom');
			if (objVHF) { objVHF.value=VHFrom; }
			var objVHT=document.getElementById('VisitHoursTo');
			if (objVHT) { objVHT.value=VHTo;	}
			var objRPF=document.getElementById('RestPeriodFrom');
			if (objRPF) { objRPF.value=RPFrom;	}
			var objRPT=document.getElementById('RestPeriodTo');
			if (objRPT) { objRPT.value=RPTo; }
			var objVR=document.getElementById('VisitHRange');
			if (objVR) { objVR.value=WVR; }
			CheckMultiVisit();
		
	
		}
		
} 

// LOG 24234 BC Restrict certain fields based on usergroup.  At present calls 
// dummy function which is overwritten in a custom field
function RingLookUp(str) {

}


function LocationLookUp(str) {
	var lu = str.split("^");
	obj=document.getElementById('VisitHoursFrom');
	if (obj) obj.value=lu[4]
	obj=document.getElementById('VisitHoursTo');
	if (obj) obj.value=lu[5]
	obj=document.getElementById('RestPeriodFrom');
	if (obj) obj.value=lu[6]
	obj=document.getElementById('RestPeriodTo');
	if (obj) obj.value=lu[7]
	obj=document.getElementById('VisitHRange');
	if (obj) obj.value=lu[8]
	CheckMultiVisit();
	} 

function SetLinks() {
	var obj=document.getElementById('EpisodeID');
	if ((obj)&&(obj.value=="")) {
		SetupHiddenLink("PsychDetails");
		}
	SetupHiddenLink("SNAPScreen");
	//SetupHiddenLink("ContractCare");
}

function SetupHiddenLink(link) {
	var obj=document.getElementById(link);
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}
}

function InquiryFieldsCheck() {

	var errMsg="";
	var temp="";	
	var MRADMWeightObj=document.getElementById("MRADMWeight");
	var MRADMHeightObj=document.getElementById("MRADMHeight");

	if ((MRADMWeightObj)&&(MRADMWeightObj.value!="")) {
		temp=MRADMWeightObj.value;
		if ((isNaN(temp))||(temp>999)) {
			errMsg += t['MRADMWeight']+" "+t['XINVALID']+"\n";
		}
	}
	
	if ((MRADMHeightObj)&&(MRADMHeightObj.value!="")) {
		temp=MRADMHeightObj.value;
		if ((isNaN(temp))||(temp>999)) {
			errMsg += t['MRADMHeight']+" "+t['XINVALID']+"\n";
		}
	}

	if (errMsg!="") {
		alert(errMsg);
		return false;
	} else {
		return true;
	}

}
//md 10.04.2002
function ViewDoctorLookUp(str) {
 	var lu = str.split("^");
	// Set Referal Doctor Code to hidden field
	var obj=document.getElementById("REFDCode")
	if (obj) obj.value = lu[4]
	obj=document.getElementById("REFDDesc")
	if (obj) obj.value = lu[1]
	obj=document.getElementById("doctorCode");
	if (obj) obj.value = lu[3];
	obj=document.getElementById("CLNAddress1");
	if (obj) obj.value = lu[6];
	obj=document.getElementById("CLNPhone");
	if (obj) obj.value = lu[9];
	obj=document.getElementById("CLNProviderNo")
	if (obj) obj.value = lu[7]
 	obj=document.getElementById("PAADMRefDocClinicDR");
	if (obj) obj.value = lu[11];
	//md 12/02/2003
	obj=document.getElementById("REFDTitle");
	if (obj) obj.value = lu[0];
 	obj=document.getElementById("REFDForename");
	if (obj) obj.value = lu[2];
	//md 12/02/2003
}
// cjb 24/01/2005 48979 - now done in the component
/*
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
	//url += "?ID=d1250iREFDDesc&WEBSYS.TCOMPONENT=PACRefDoctor.CustomFind"+namevaluepairs;
	url += "?ID=d1250iREFDDesc&WEBSYS.TCOMPONENT=PACRefDoctor.CustomFind&CONTEXT=Kweb.PACRefDoctor:LookUpDoctor&TLUJSF=ViewDoctorLookUp"+namevaluepairs;
	var tmp=url.split('%');
	url=tmp.join('%25');
        //Log 59598 - BC - 30-06-2006 : remove statusbar variable (status=) to display the status bar.
	websys_createWindow(url,"lookup","top=30,left=20,width=620,height=420,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
	return websys_cancel();
}
*/
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
		var obj=document.getElementById("REDCode");
		if (obj) obj.value="";
		var obj=document.getElementById("PAADMRefDocClinicDR");
		if (obj) obj.value="";
		var obj=document.getElementById("doctorCode");
		if (obj) obj.value="";
		//md 12/02/2003
		obj=document.getElementById("REFDTitle");
		if (obj) obj.value = "";
 		obj=document.getElementById("REFDForename");
		if (obj) obj.value = "";
		//md 12/02/2003
	}

}


function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	//if (el.id=="ViewableBy") VIEWABLE=el;
	if (el.disabled) {
		return false;
	}
	return true;
}

function CheckMultiVisit() {
	var objH=document.getElementById('VisitHRange');
	var obj=document.getElementById('MRADMMultiVisitingHoursRanges');	
	if ((obj)&&(obj.disabled==true)&&(objH)) {obj.value=objH.value}
}

function ContrCareClickHandler()	{
	var id="";
	var epi=document.getElementById("EpisodeID").value;
	var pat=document.getElementById('PatientID').value;
	var admd="";
	var dischd="";	
	var admdate=document.getElementById('PAADMAdmDate');
	if (admdate) {admd=admdate.value;}
	if (!admdate) {admd="_zz";}
	var disdate=document.getElementById('PAADMDischgDate');
	if (disdate) {disd=disdate.value;}
	if (!disdate) {disd="_zz";}
	var CONTEXT=session["CONTEXT"]
	//alert(admd);
        //Log 59598 - BC - 30-06-2006 : remove statusbar variable (status=) to display the status bar.
	websys_createWindow('paadmcontractcare.csp?%ID='+id+'&PatientID='+pat+'&EpisodeID='+epi+'&PAADMAdmDate='+admd+'&CONTEXT='+CONTEXT+'&PAADMDischgDate='+disd+'&PatientBanner=1','',"top=30,left=20,width=620,height=420,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
	return false;
}

document.body.onload = DocumentLoadHandler;