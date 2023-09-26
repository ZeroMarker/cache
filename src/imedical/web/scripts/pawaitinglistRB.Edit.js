// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.


function Init() {
	//alert("in Init()");

	var obj;

	obj=document.getElementById('InsurPayor');
	if (obj) obj.onblur=PayorChangeHandler;

	//obj=document.getElementById('CTLOCDesc');
	//if (obj) obj.onchange=LocationChangeHandler;

	//obj=document.getElementById('CTPCPDesc');
	//if (obj) obj.onchange=CareProvChangeHandler;

	obj=document.getElementById("REFDDesc")
	if (obj) obj.onchange=InternalDrChangeHandler;

	obj=document.getElementById('update1')
	if (obj) obj.onclick = UpdateAll;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateAll;

	obj=document.getElementById('ViewFamilyDrDetails');
	if (obj) obj.onclick=ViewFamDoctorHandler;

	obj=document.getElementById('ViewDoctorDetails');
	if (obj) obj.onclick=ViewDoctorHandler;

	var obj=document.getElementById('REFDDesc');
	if (obj) obj.onkeydown=REFDDesc_lookuphandlerCustom;
	var obj=document.getElementById('ld251iREFDDesc');
	if (obj) obj.onclick=REFDDesc_lookuphandlerCustom;

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

	//if (chapobj) chapobj.onclick=EnableChaplainDetails;
	setLinks()
	//objBold=document.getElementById('BoldLinks');
	//if (objBold) {
		//var BoldLink = objBold.value.split("^");
		//obj=document.getElementById('ContactPerson');

	//}

}


function BodyUnloadHandler() {
/*
	if (top.window.opener.top.frames["TRAK_main"]) {
		top.window.opener.top.frames["TRAK_main"].treload('websys.csp')
	} else {
		if (window.opener) window.opener.treload('websys.csp')
	}
	top.location="websys.close.csp"
*/

	var obj=document.getElementById('refresh');
	if ((obj) && (obj.value==0)) {
		return false;
	}
	else {
		if (self == top) {
			var win=window.opener;
			if (win) {
				win.treload('websys.csp');
				websys_onunload();
			}
		}
	}
}


//KM 20-Nov-2001: over-writes one from SCRIPTS_GEN so that it can pass in the WEBSYS.TCOMPONENT value:
function REFDDesc_lookuphandlerCustom(e) {
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))) {
		var namevaluepairs="&P1=&P2=&P3=";
		var obj=document.getElementById('REFDDesc');
		if (obj) {namevaluepairs="&P1="+obj.value+"&P2=&P3=";}
		REFDDesc_lookuphandlerCustom2(namevaluepairs);
	}
}
function REFDDesc_lookuphandlerCustom2(namevaluepairs) {
	var url='websys.lookup.csp';
	url += "?ID=d251iREFDDesc&WEBSYS.TCOMPONENT=PACRefDoctor.CustomFind"+namevaluepairs;
	var tmp=url.split('%');
	url=tmp.join('%25');
	// Log 59598 - BC - 29-06-2006 : remove statusbar variable (status=) to display the status bar.
	websys_createWindow(url,"lookup","top=30,left=20,width=620,height=420,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
	return websys_cancel();
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
	var objid=document.getElementById("doctorCode");
	var view=document.getElementById("viewDr")
	view.value="1";
	var url="websys.default.csp?WEBSYS.TCOMPONENT=PACRefDoctor.Edit&ID="+objid.value+"&viewDr="+view.value;
	websys_lu(url,false,"width=350,height=480")
	return false;
}
function ViewDoctorLookUp(str) {
 	var lu = str.split("^");
	var obj;
	//alert(str);
	// Set Referal Doctor Code to hidden field
	obj=document.getElementById("REFDCode")
	if (obj) obj.value = lu[0]
	obj=document.getElementById("REFDDesc")
	if (obj) obj.value = lu[1]
	//--
	obj=document.getElementById("doctorCode");
	if (obj) obj.value = lu[2];
	obj=document.getElementById("ReferralClinicAddress");
	if (obj) {
		obj.value = lu[4];
		//obj.disabled=true
	}
	obj=document.getElementById("CLNProviderNo")
	if (obj) obj.value = lu[5]
 	obj=document.getElementById("PAADMRefDocClinicDR");
	if (obj) obj.value = lu[6];
	//var obj=document.getElementById('LocalDoctorCB');
	//if (obj) obj.checked = false
	//EnableField("PAADMInternalRefDr");
}


function ViewFamilyDrLookUp(str) {

 	var lu = str.split("^");
	var obj;
	//alert(str)
	// Set Referal Doctor Code to hidden field
	obj=document.getElementById("FamREFDCode")
	if (obj) obj.value = lu[0]
	obj=document.getElementById("REFDDescFam")
	if (obj) obj.value = lu[1]
	//--
 	obj=document.getElementById("FamREFDId")
	if (obj) obj.value = lu[2];
	obj=document.getElementById("FamilyClinicAddress");
	if (obj) {
		obj.value = lu[4];
		//obj.disabled=true
	}
	//obj=document.getElementById("CLNProviderNo")
	//if (obj) obj.value = lu[5]
	//obj=document.getElementById("FamilyClinicAddress");
	//if (obj) obj.value = lu[4];
	obj=document.getElementById("PAPERFamilyDoctorClinicDR");
	if (obj) obj.value = lu[6];
	obj=document.getElementById("FamDoctorDetails");
	if (obj) obj.value = str;
	//RefChangeHandler();

}


function RefDocChangeHandler(e) {
	var obj;
	var obj2;
	obj2=document.getElementById("REFDDesc")
	obj=document.getElementById("PAADMRefDocClinicDR")
	if (obj) obj.value = "";
	obj=document.getElementById("ReferralClinicAddress")
	if (obj) obj.value = "";
	obj=document.getElementById("REFDCode")
	if (obj) obj.value = "";
	//alert("hello");
}

function internalDrLookUp(str) {
 	var lu = str.split("^");
	var obj;

	obj=document.getElementById('PAADMInternalRefDr')
	if (obj) obj.value = lu[0]

	obj=document.getElementById('CTPCPSMCNo');
	if (obj) obj.value = lu[3];

}

function InternalDrChangeHandler(e) {
	obj=document.getElementById('CTPCPSMCNo')
	if (obj) obj.value = "";

}


function LocationChangeHandler(e) {
	var obj=document.getElementById('DEPDesc')
	if (obj) obj.value = "";
	//var obj=document.getElementById("CTPCPDesc")
	//if (obj) obj.value="";

}
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
	var obj=document.getElementById('CTLOCDesc')
	if (obj) obj.value = lu[1]
	var obj=document.getElementById('DEPDesc')
	if (obj) obj.value = lu[2]
}

function UpdateAll() {

	return update1_click();
}

function AdmissionSourceLookUp(str) {
	var lu = str.split("^");
	var obj=document.getElementById('ADSOUDesc')
	if (obj) obj.value = lu[1]

}


//functions used to enable/disable fields and display label as mandatory/non mandatory
//presently called by custom script for Austin, but left here for general use

function EnableField(fldName) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if (fld) {
		fld.disabled = false;
		fld.className = "";
		if (lbl) lbl = lbl.className = "clsRequired";
	}
}
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
function labelMandatory(fld) {
	var lbl = document.getElementById('c' + fld)
	if (lbl) {
		lbl=lbl.className = "clsRequired";
	}
}

function labelNormal(fld) {
	var lbl = document.getElementById('c' + fld)
	if (lbl) {
		lbl=lbl.className = "";
	}
}


function PayorChangeHandler() {
	//var obj=document.getElementById("InsurPlan")
	var obj=document.getElementById("RBAuxInsTypeDR")

	//if (obj) obj.value="";
	//obj=document.getElementById("InsurOffice")
	//if (obj) obj.value="";
	//obj=document.getElementById("InsurCardNo")
	if (obj) obj.value="";
	//obj=document.getElementById('payorCategory');
	obj=document.getElementById('Payor');
	if (obj) obj.value="";

	setLinksAgain();
}
function PayorSetHandler(str) {
 	var lu = str.split("^");
	//alert(str);
	//var obj=document.getElementById('InsurPayor')
	var obj=document.getElementById('RBInsTypeDR')
	if (obj) obj.value=lu[0];
	//obj=document.getElementById("payorCategory")
	obj=document.getElementById("Payor")
	if (obj) obj.value = lu[3];
	//var obj=document.getElementById('InsurPlan')
	var obj=document.getElementById('RBAuxInsTypeDR')
	if (obj) obj.value="";
	setLinksAgain();

}
function RBPayorLookupSelect(str) {
 	var lu = str.split("^");
	var obj;
 	//obj=document.getElementById("InsurPayor")
	obj=document.getElementById("RBInsTypeDR")

	if (obj) obj.value = lu[0];
 	//obj=document.getElementById("payorCategory")
	obj=document.getElementById("Payor")

	if (obj) obj.value = lu[3];
	setLinksAgain();
 }

function RBPlanLookupSelect(str) {
 	var lu = str.split("^");
	var obj;
 	//obj=document.getElementById("InsurPlan")
	obj=document.getElementById("RBAuxInsTypeDR")

	if (obj) obj.value = lu[0];
 	//obj=document.getElementById("InsurPayor")
	obj=document.getElementById("RBInsTypeDR")

	if (obj) obj.value = lu[1];
 }


function BedLookUpFill(str) {
	var lu = str.split("^");
	var bed=document.getElementById("BedCode")
	if (bed) bed.value=lu[0];
	var ward=document.getElementById("WARDDesc")
	if (ward) ward.value=lu[1];
	document.getElementById("PAAdmCurrentBedDR").value=lu[3];
        //alert(document.getElementById("PAAdmCurrentBedDR").value);
}

function WardLookUpFill(str) {
	var lu = str.split("^");
	document.getElementById("WARDDesc").value=lu[0];
	document.getElementById("BedCode").value="";
	document.getElementById("PAAdmCurrentBedDR").value="&&&"+lu[1];
	//alert(document.getElementById("PAAdmCurrentBedDR").value);

}


function internalCPLookUp(str) {
 	//var lu = str.split("^");
	//var obj;
	//obj=document.getElementById('PAADMInternalRefDr')
	//if (obj) obj.value = lu[0]

}
function payorByLookUp() {
	// a dummy function to allow a custom payorByLookUp funtion to be used
}


function referralPeriodLookUp(str) {
// dummy function to allow custom lookup
}


function setLinks() {
	var obj=document.getElementById('hiddenLinks');
	if (obj) obj.value="0";
	var obj=document.getElementById('InsurPayor');
	//if (obj=="") {
	//  var payor = "";
	//}
	//else {
	// var payor=obj;
	//}
	if (obj) {
	var payor=obj.value;
	}

	obj=document.getElementById('EpisodeID');
	if ((obj)&&(obj.value=="")) {
		var obj=document.getElementById('hiddenLinks');
		if (obj) obj.value="1";
		//alert(obj.value)
		var obj=document.getElementById('PAADMRefLocation');
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}
		var obj=document.getElementById('CompoDetails');
		if (obj) {
			obj.disabled=true;
			obj.onclick=DoLink;
		}
		var obj=document.getElementById('DischargeEpisode')
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}
	}
	obj=document.getElementById('EpisodeID');
	if ((obj)&&(obj.value!="")) {
		var obj=document.getElementById('payorCategory');
		if ((obj.value!="Auto") && (obj.value!="Labour")) {
			var obj=document.getElementById('CompoDetails');
			if (obj) {
				//alert("here")
				obj.disabled=true;
				obj.onclick=LinkDisable;
			}
		}
	}
	obj=document.getElementById('PAADMWaitListDR');
	if ((obj)&&((obj.value==" ")||(obj.value==""))) {
		//alert("in first loop");
		var obj=document.getElementById('waitinglistdetails');
		if (obj) {
			//alert("in second loop");
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}
	}
}


function setLinksAgain() {
	//alert("start")
	obj=document.getElementById('EpisodeID');
	if ((obj)&&(obj.value!="")) {
		var obj=document.getElementById('payorCategory');
		//alert("pay cat"+obj.value)
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
}
function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if (el.disabled) {
		return false;
	}
	return true;
}

function DoLink() {

	var comp=document.getElementById('CompoDetails');
	if (comp.disabled) {

		return false;
	} else {
		//window.open(lnk.href);

	var val=document.getElementById('EpisodeID').value;
	var pat=document.getElementById('PatientID').value;
	websys_createWindow('trafficaccidentframe.csp?EpisodeID='+val+'&PatientID='+pat+'&ID=','comp','top=20,left=20,width=900,height=600');
		return false;

	}
}



function ViewCompoDetails(evt) {
	var el = websys_getSrcElement(evt);
	id=document.getElementById("EpisodeID")
	patid=document.getElementById("PatientID")
	TFORM=document.getElementById("TFORM")
	TEVENT=document.getElementById("TEVENT")
	TNAVMARK=document.getElementById("TNAVMARK")
	TPAGID=document.getElementById("TPAGID")
	payorCat=document.getElementById("payorCategory")
	var url="trafficaccidentframe.csp?TFORM="+TFORM.value +"&TEVENT"+TEVENT.value +"&TNAVMARK="+TNAVMARK.value +"&TPAGID="+TPAGID.value +"&EpisodeID="+id.value +"&PatientID="+patid.value+"&ID="+id.value+"&payorCategory="+payorCat.value
	websys_lu(url,false,"width=700,height=500")
	return false;
}
//function BodyUnloadHandler(e) {
	//if (window.opener) window.close()
//}
function PAAdm_ChangeStatusHandler() {
	var ID=document.getElementById("EpisodeID").value;
	var Status=document.getElementById("VisitStatusCode").value;
	var pat=document.getElementById("PatientID").value;
	//websys_createWindow('websys.default.csp?WEBSYS.TCOMPONENT=PAAdm.ChangeStatus&EpisodeID='+ID+'&presentStatus='+Status,'Prompt','top=0,left=0,width=300,height=300');
	websys_createWindow('websys.default.csp?WEBSYS.TCOMPONENT=PAAdm.ChangeStatus&EpisodeID='+ID+'&PatientID='+pat+'&presentStatus='+Status+'&PatientBanner=1','Prompt','top=0,left=0,width=300,height=300');
}

function HospitalChaplain() {
	hospchapl=document.getElementById('PAADMHospChaplainVisitReq');
	ownchap=document.getElementById('PAADMOwnMinisterIndicator');
	// BC 14-Feb-2002 LOG 22887 : Now required to be able to have both options ticked
	/*if (hospchapl.checked) {
		ownchap.checked=false;
	}*/
	EnableChaplainDetails()
}

function EnableChaplainDetails() {
	chapaddress=document.getElementById('PAADMChaplainChurchAddress');
	chapname=document.getElementById('PAADMChaplainName');
	chapphone=document.getElementById('PAADMChaplainPhone');
	hospchap=document.getElementById('PAADMHospChaplainVisitReq');
	if (chapobj.checked) {
		if (chapaddress) EnableField(chapaddress);
		if (chapname) EnableField(chapname);
		if (chapphone) EnableField(chapphone);
		// BC 14-Feb-2002 LOG 22887 : Now required to be able to have both options ticked
		//if (hospchap) {
		//	hospchap.checked=false;
		//}
	}
	else {
		if (chapaddress) DisableField(chapaddress);
		if (chapname) DisableField(chapname);
		if (chapphone) DisableField(chapphone);
		if (hospchap) EnableField(hospchap);
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

function SetReferralSameAsFamilyDoc(evt) {
	//var cbx=document.getElementById('LocalDoctorCB');
	var cbx = websys_getSrcElement(evt);

	var FamDocDet=document.getElementById("FamDoctorDetails").value;
	//doccode_"^"_docdesc_"^"_docid_"^"_clncode_"^"_clnaddr_"^"_clnprovno_"^"_clinicid_"^"_clncitydesc
	var FamAry = FamDocDet.split("^");
	var famdesc=document.getElementById("REFDDescFam");

	var refby=document.getElementById("REFDDesc");
	var refbyid=document.getElementById("doctorCode");	//hidden field
	var refbycode=document.getElementById("REFDCode");	//hidden field
	var refbyClinicProvNo=document.getElementById("CLNProviderNo");
	var refbyClinicDR=document.getElementById("PAADMRefDocClinicDR");	//hidden field

	if (cbx.checked) {
		if ((famdesc)&&(famdesc.value!="")) {
			if ((FamAry[1])&&(refby)) {
				refby.value=FamAry[1];
			}
			if ((FamAry[2])&&(refbyid)) {
				refbyid.value = FamAry[2];
			} else {
				refbyid.value="";
			}
			if ((FamAry[0])&&(refbycode)) {
				refbycode.value = FamAry[0];
			} else {
				refbycode.value="";
			}
			if ((FamAry[6])&&(refbyClinicProvNo)) {
				refbyClinicDR.value=FamAry[6]
				refbyClinicProvNo.value=FamAry[5];
			} else {
				refbyClinicProvNo.value="";
				refbyClinicDR.value=""
			}
		}
	} else {
		if (refby) refby.value='';
		if (refbyid) refbyid.value='';
		if (refbycode) refbycode.value='';
		if (refbyClinicProvNo) refbyClinicProvNo.value="";
		if (refbyClinicDR) refbyClinicDR.value="";
	}
}
var obj=document.getElementById('LocalDoctorCB')
if (obj) obj.onclick=SetReferralSameAsFamilyDoc;


//Init();
document.body.onload=Init;
document.body.onunload=BodyUnloadHandler;



