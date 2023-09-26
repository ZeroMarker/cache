//Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. w 6.50

//rqg,log24512

var objAddViewExtRefDocLink=document.getElementById("AddViewReferralDoctor");
var objUpdateAddExtRefDocLink=document.getElementById("UpdateAddReferralDoctor");
var objID=document.getElementById("ID");
var objVisStat=document.getElementById("TCIVisitStatus");
var objWLStatus=document.getElementById("WLSCode");
var objWLDate=document.getElementById('WLDate');
var shortnoticeobj=document.getElementById("WLShortNotice");
var shortnoticeflagobj=document.getElementById("WLShortNoticeFlag");
var objWLID=document.getElementById('WaitingListID');
var objCopy=document.getElementById("Copy");
//gr log35892 austin want to be able to edit removed waiting lists
var removed="R"
var LOSobj=document.getElementById('WLEstLengthOfStay');
var planobj=document.getElementById('WLPlannedSameDay');
var LOSvalue=""
var objCTValDate=document.getElementById('CTValDate');
var SPPPDesc=document.getElementById('SPPPDesc');

//Log 63909 - 18.06.2007 
var objRecDate=document.getElementById("RecallDate");
var objAddRecDt=document.getElementById("AddManualRecallDt");

function BodyLoadHandler() {

	// RQG 19.03.03 L33061 - Disable Copy link if New WL entry

	var validstat=1;
	if ((objWLStatus)&&((objWLStatus.value=="D")||(objWLStatus.value=="PRE")) ) validstat=0
	if ( ( (objID)&&(objID.value=="") )||(validstat==1) ) {
		if (objCopy) {
			objCopy.disabled=true;
		      objCopy.onclick=LinkDisable;
		}
	}
	if (objCopy) objCopy.onclick=CopyClickHandler;

	// RQG 11.03.03 L30658
	var objMode=document.getElementById("Mode");
	if ((objMode)&&(objMode.value=='Copy')) SetBlankToDateAndID();

	disableform();
	// Log 41223 BC 10-12-2003 disable added to list date
	if ((objID)&&(objID.value!="")&&(objWLDate)) {
		objWLDate.disabled=true;
		var luWLDate=document.getElementById('ld407iWLDate')
		if (luWLDate){
			luWLDate.disabled=true;
		    luWLDate.onclick=LinkDisable;
		}
	}
	if (objID) {
		if (objID.value=="") {
		   if (objAddViewExtRefDocLink) {
		      objAddViewExtRefDocLink.disabled=true;
		      objAddViewExtRefDocLink.onclick=LinkDisable;
		   }
		   if (objUpdateAddExtRefDocLink) objUpdateAddExtRefDocLink.disabled=false;
		   //RC 07/12/06 61414: Disable link if new WL
	       var obj=document.getElementById('TypeOfferHistory');
		   if (obj) {
		      obj.disabled=true;
		      obj.onclick=LinkDisable;
		   }
		} else {
		   if (objUpdateAddExtRefDocLink) {
			objUpdateAddExtRefDocLink.disabled=true;
			objUpdateAddExtRefDocLink.onclick=LinkDisable;
		   }
		   if (objAddViewExtRefDocLink) objAddViewExtRefDocLink.disabled=false;
		}
	}
	objCTLoc=document.getElementById('CTLOCDesc');
	if (objCTLoc) objCTLoc.onblur=LocationChangeHandler;
	//GR26/02/02 changed to onblur so that broker cna work on this field.
	//setConsultantFilter()
	//obj=document.getElementById('Doctor');
	//if (obj) obj.onchange=CareProvChangeHandler;
	//RQG Log23652,18/03/02: Coming from the Radiology workbench screen will set the
	//list type to the recieving location of the order.
	objLoc=document.getElementById('OEORIRecDep');
	//alert("Location compare: "+objLoc.value+"  ---  "+objCTLoc.value);
	if ((objLoc)&&(objCTLoc)&&(objCTLoc.value=="")){
	//if ((objLoc)&&(objCTLoc.value==""))
		objCTLoc.value=objLoc.value;
	}
	//RQG,Log24183: Disabled Operation Code field
	objOperCode=document.getElementById('OperationCode');
	if (objOperCode) objOperCode.disabled=true;
	var objOperDesc=document.getElementById('WLOperationDR');
	//if (objOperDesc) objOperDesc.onchange=OperationChangeHandler;
	if (objOperDesc) objOperDesc.onblur=OperationChangeHandler;
	//RQG,Log24248: Disable "Reason For Suspension" & "Suspension Date To" fields if status is "Suspended"
	var objSuspReason=document.getElementById('ReasonSuspension');
	var objSuspDateTo=document.getElementById('NADateTo');
	var lblSuspReason = document.getElementById('cReasonSuspension');
	var lblSuspDateTo = document.getElementById('cNADateTo');
	var objStatus=document.getElementById('WLSDesc');
	var objStatusDesc=document.getElementById('SuspStatusDesc');
	if ((objStatus)&&(objStatusDesc)&&(objStatus.value==objStatusDesc.value)) {
		EnableField("ReasonSuspension","ld407iReasonSuspension");
		if (objSuspDateTo) EnableField("NADateTo","");
		if (objSuspReason) objSuspReason.className="clsRequired";
		if (lblSuspReason) lblSuspReason.className = "clsRequired";
		if (lblSuspDateTo) lblSuspDateTo.className = "clsRequired";
	} else {
		DisableField("ReasonSuspension","ld407iReasonSuspension");
		DisableField("NADateTo","");
	}

	//KB 16/Mar/2007 log 62629
	var objPatientType=document.getElementById('WLPatientTypeDR');
	var objStatus=document.getElementById('WLSCode');
	if ((objStatus)&&(objStatus.value!= "I")&&(objStatus.value!= "A")&&(objStatus.value!="S")&&(objStatus.value!="")) {
		DisablePatientType(true);
	}
	else DisablePatientType(false);
	//KK 30/Apr/2002 Log:24008
	var objDeleteDept=document.getElementById('DeleteDept')
	if (objDeleteDept) objDeleteDept.onclick=DeptDeleteClickHandler;
	objUpdate=document.getElementById('update1');
	if (objUpdate) objUpdate.onclick=UpdateAll;
	objUpdateAddBooking=document.getElementById('UpdateAddBooking');
	if (objUpdateAddBooking) objUpdateAddBooking.onclick=UpdateAddBooking;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateAll;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateAll;
	//rqg,log24512
	//var objUpdateAddRefDoc=document.getElementById('UpdateAddReferralDoctor');
	if (objUpdateAddExtRefDocLink) objUpdateAddExtRefDocLink.onclick=UpdateAddRefDocClickHandler;
	if (tsc['UpdateAddReferralDoctor']) websys_sckeys[tsc['UpdateAddReferralDoctor']]=UpdateAddRefDocClickHandler;

	// cjb 17/01/2005 50709 - removed, now done in the component
	/*
	// BC 18-5-2002 Log 25029
	var obj=document.getElementById('REFDDesc');
	if (obj) obj.onkeydown=REFDDesc_lookuphandlerCustom;
	var obj=document.getElementById('ld407iREFDDesc');
	if (obj) obj.onclick=REFDDesc_lookuphandlerCustom;
	*/
	//PrintRefDocClickHandler();
	setSiteFlag("bury");
	var obj=document.getElementById("SiteFlag");
//	alert("siteflag at end of bodyloadhandler is " + obj.value);
	//GR log 29402
	obj=document.getElementById("ID");
	if (obj) {
		if (obj.value=="") {
			var bookobj=document.getElementById('booking');
			if (bookobj) bookobj.disabled=true;
		}
	}
	shortnoticeobj=document.getElementById("WLShortNotice");
	if (shortnoticeobj) {
		shortnoticeobj.onclick=ShortNoticeClickHandler;
	}
	//GR log 32725
	if (objWLDate) objWLDate.onchange=WLDateChangeHandler;
	disablestatuspriority();
	//log 36483
	if (LOSobj) LOSobj.onchange=LOSHandler;

	// these fields are determined in the code tables, cannot edit
	var obj=document.getElementById("CLNAddress1");
	if (obj) obj.readOnly=true;
	var obj=document.getElementById("CLNPhone");
	if (obj) obj.readOnly=true;
	var obj=document.getElementById("CLNCode");
	if (obj) obj.readOnly=true;

	//Log 63909 - 18.06.2007 - enable Recall date if 'Add Manual Recall Date' check box is ticked
	var objIcon=document.getElementById("ld407iRecallDate");
	
	if (objRecDate) objRecDate.readOnly=true;
	if (objIcon) objIcon.style.visibility = "hidden";

	if ((objAddRecDt) && (objAddRecDt.checked)) {
		if (objRecDate) objRecDate.readOnly=false;
		if (objIcon) objIcon.style.visibility = "visible";
	}
	
	if (objAddRecDt) objAddRecDt.onclick=handleRecallDate;
	//End  Log 63909 
	
	var obj=document.getElementById("RecallPeriod");
	if (obj) obj.readOnly=true;

	var obj=document.getElementById("WLConsultCateg");
	if (obj) obj.onblur=WLConsultCategChangeHandler;

	var obj=document.getElementById("WLTDesc");
	if (obj) obj.onblur=WLTDescChangeHandler;

	disablebuttons();
	//GR log 45365
	//HOSPDescloadchange("")

	//SB 20/10/06 (61340): Disable/grey out 'Removed/Remain on List' check box when unchecked
	var obj=document.getElementById('WLRemovedRemainOnList');
	if (obj && !obj.checked) DisableField("WLRemovedRemainOnList","");

	//RC 07/12/06 61414: Bold Link if Offers exist
 	var offlnk=document.getElementById('TypeOfferHistory');
 	var offdata=document.getElementById('PAWLOffData');
  	if ((offlnk)&&(offdata)) {
		if (offdata.value!="") offlnk.style.fontWeight="bold"
  	}

	var obj=document.getElementById("Surgeon");
	if (obj) obj.onblur=GoWithCorectRest;
	var obj=document.getElementById("Doctor");
	if (obj) {
		obj.onblur=GoWithCorectRest;
		obj.onchange(); //log 63144
	}
	GoWithCorectRest();
	DefaultRecallSchema();
	
	//log 63444 TedT
	var obj=document.getElementById("WaitingListID");
	var obj2=document.getElementById("WLScore");
	if (obj && obj2 && obj.value!="" && obj2.value!="") obj2.disabled=true;
}

//Log 63909 - 18.06.2007 - handle enabling/disabling of Recall Date field.
function handleRecallDate() {
	var objIcon=document.getElementById("ld407iRecallDate");
	if ((objAddRecDt) && (objAddRecDt.checked)) {
		if (objRecDate) objRecDate.readOnly=false;
		if (objIcon) objIcon.style.visibility = "visible";
	} else {
		if (objRecDate) objRecDate.readOnly=true;
		if (objIcon) objIcon.style.visibility = "hidden";
	}
}

function WLConsultCategChangeHandler(e) {
	var WLCCobj=document.getElementById("WLConsultCateg");
	if (WLCCobj && WLCCobj.value=="") {
		var obj=document.getElementById("RecallDate");
		if (obj) obj.value="";
		var obj=document.getElementById("RecallPeriod");
		if (obj) obj.value="";
		var obj=document.getElementById("RecallHidden");
		if (obj) obj.value="";
		var obj=document.getElementById("RecallPeriodHidden");
		if (obj) obj.value="";
	}
}

function WLTDescChangeHandler(e) {
	var WLTobj=document.getElementById("WLTDesc");
	if (WLTobj && WLTobj.value=="") {
		var obj=document.getElementById("RecallDate");
		if (obj) obj.value="";
		var obj=document.getElementById("RecallPeriod");
		if (obj) obj.value="";
		var obj=document.getElementById("RecallHidden");
		if (obj) obj.value="";
		var obj=document.getElementById("RecallPeriodHidden");
		if (obj) obj.value="";
	}
}

function EnableField(fldName,icN) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if (fld) {
		fld.disabled = false;
		fld.className = "";
		if (lbl) lbl = lbl.className = "";
	}
	if (icN) {
		var objIcon=document.getElementById(icN);
		if (objIcon) objIcon.style.visibility = "visible";
	}
}


function DisableField(fldName,icN) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if ((fld)&&(fld.tagName=="INPUT")) {
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

// SA 24.1.02 - log 32167: StatusLookUpHandler had been created as an onblur event for ARMC's custom
// I have commented out onblur call. OnBlur Event should not be used.
// The LookUp js function should just be overwritten by the custom js.
// rqg,Log24248:
//function StatusLookUpHandler() {
//	//dummy function
//}

// SA 24.1.02 - log 32167: Beware this function is overwritten by function with same name
// in ARMC's custom js. Any changes made here, may need to be copied over.
function StatusLookUp(str) {
	var lu = str.split("^");
	var objStatusCode=document.getElementById('WLSCode');
	if (objStatusCode) objStatusCode.value=lu[0];
	var objStatus=document.getElementById('WLSDesc');
	if (objStatus) objStatus.value=lu[1];
	var obj=document.getElementById('StatusDesc');
	if (obj) obj.value = lu[1];
  // KB 19.03.07 log 62629
  var objPatientType = document.getElementById('WLPatientTypeDR');
	if ((objStatusCode)&&(objStatusCode.value!="I")&&(objStatusCode.value!="A")&&(objStatusCode.value!="S")&&(objStatusCode.value!="")){
		DisablePatientType(true);
  }
	else DisablePatientType(false);
//The StatusLookUpHandler() has been commented out because it is causing a problem
//StatusLookUpHandler();
}

var obj=document.getElementById('booking');
if (obj) obj.onclick = bookingHandler;

function bookingHandler() {
	var f=document.forms[0];
	var WListID=""
	obj=document.getElementById("ID");
	if (obj) WListID=obj.value;
	if (WListID=="") {
		//alert(t['WL1']);
	} else {
		var ID=""
		var PatientID=""
		var ListType=""
		var Doc=""
		var Loc=""
		var obj=document.getElementById("EpisodeID");
		if (obj) ID=obj.value;
		var obj=document.getElementById("PatientID");
		if (obj) PatientID=obj.value;
		var obj=document.getElementById("WLTDesc");
		if (obj) ListType=obj.value;
		var obj=document.getElementById("CTLOCDesc");
		if (obj) Loc=obj.value;
		var obj=document.getElementById("Doctor");
		if (obj) Doc=obj.value;
		/*
		var ID=f.elements["EpisodeID"].value;
		var PatientID=f.elements["PatientID"].value;
		var ListType=f.elements["WLTDesc"].value;
		var Loc=f.elements["CTLOCDesc"].value;
		var Doc=f.elements["Doctor"].value;
		*/
		url="pawaitinglist.custom.csp?ID="+ID+"&WListID="+WListID+"&PatientID="+PatientID+"&ListType="+ListType+"&CTLOCDesc="+Loc+"&RESDesc="+Doc;
		//websys_createWindow(url, 'TRAK_main', '');
		if (window.opener) { window.opener.location=url; }
		else { window.location = url;}
	}
	return false
}

//JW:removed 3/12/01
/*function ViewDoctorLookUp(str) {
 	var lu = str.split("^");
	var obj;
	// Set Referal Doctor Code to hidden field
	obj=document.getElementById("REFDCode")
	if (obj) obj.value = lu[0]
	obj=document.getElementById("REFDDesc")
	if (obj) obj.value = lu[1]
	//--
	//obj=document.getElementById("doctorCode");
	//if (obj) obj.value = lu[2];
	obj=document.getElementById("CLNCode");
	if (obj) obj.value = lu[3];
	//obj=document.getElementById("PAADMRefDocClinicDR");
	//if (obj) obj.value = lu[6];
} */

function WLTypeLookUpHandler(str) {
 	var lu = str.split("^");
	var obj;
	// SA 10.12.01: Function to default Department and Doctor if one
	// is associated with the Waiting List Type selected.
	if (lu[1]!="") {
		obj=document.getElementById("WLTCode");
		if (obj) obj.value = lu[1];
	}
	if (lu[2]!="") {
		obj=document.getElementById("CTLOCDesc");
		if (obj) obj.value = lu[2];
	}
	if (lu[3]!="") {
		obj=document.getElementById("Doctor");
		if (obj) {
			obj.value = lu[3];
			obj.onchange(); //log63144 TedT
		}
	}
	if (lu[4]!="") {
		obj=document.getElementById("HOSPDesc");
		if (obj) obj.value = lu[4];
	}
	if (lu[5]!="") {
		obj=document.getElementById("LocId");
		if (obj) obj.value = lu[5];
	}

	if (lu[6]!="") {
		obj=document.getElementById("WLTType");
		if (obj) obj.value = lu[6];
	}

	if (lu[7]!="") {
		obj=document.getElementById("RecallHidden");
		if (obj) obj.value = lu[7];
	}

	if (lu[8]!="") {
		obj=document.getElementById("RecallPeriodHidden");
		if (obj) obj.value = lu[8].split("|")[0];
		obj=document.getElementById("RecallPeriod");
		if (obj) obj.value = lu[8].split("|")[1];
	}
	var addDate=document.getElementById("WLDate");
	var recallDate=document.getElementById("RecallDate");
	if (recallDate && addDate && addDate.value!="") recallDate.value=AddToDateStrGetDateStr(addDate.value,lu[8].split("|")[0],parseInt(lu[7]));

}

function CPTypeChangeHandler() {
	var objcptype=document.getElementById('CareProvType')
	if (objcptype && objcptype.value=="") {
		var cp=document.getElementById('CPType')
		if (cp) cp.value=""
	}
}

function CPTypeLookUpHandler(str) {
 	var lu = str.split("^");
	var obj;
	// SB 26/04/06 (52976): Restrict surgeon field
	if (lu[2]!="") {
		obj=document.getElementById("CPType");
		if (obj) {
			if (lu[2]=="A") obj.value = "^Y^^";
			if (lu[2]=="S") obj.value = "^^Y^";
		}
	}
}

function LocationChangeHandler(e) {
	var obj=document.getElementById("'Doctor'")
	if (obj) obj.value="";

}

function CareProvChangeHandler(e) {
	var obj=document.getElementById("CTLOCDesc")
	if (obj) obj.value="";
}
function WLDateChangeHandler(e) {
	WLDate_changehandler(e);
	//GR log 32725
	if (objWLDate) {
		var objNADate=document.getElementById('NADateFrom');
		if (objNADate) objNADate.value=objWLDate.value;
		var wldate=SplitDateStr(objWLDate.value);
		var today,todaystr,wldatestr
		objtoday=document.getElementById('DateToday');
		if (objtoday) {	today=SplitDateStr(objtoday.value); }
		if (wldate!="") wldatestr=new Date(wldate["yr"], wldate["mn"]-1, wldate["dy"]);
		if (today!="") todaystr=new Date(today["yr"], today["mn"]-1, today["dy"]);
		if (wldatestr>todaystr) {
			alert(t['WLFUTUREDATE_ERR']);
			objWLDate.className="clsInvalid";
			if (objNADate) objNADate.value=""
		}
		obj=document.getElementById("RecallHidden");
		if (obj) recall=obj.value;
		obj=document.getElementById("RecallPeriodHidden");
		if (obj) period=obj.value;
		var recallDate=document.getElementById("RecallDate");
		if (recallDate && objWLDate.value!="") recallDate.value=AddToDateStrGetDateStr(objWLDate.value,period,parseInt(recall));
		if (objWLDate.value=="") recallDate.value="";
	}
	SetCTValDate();
}

function OECConsultCategChangeHandler(e) {
	var objSpec=document.getElementById('WLTDesc');
	if (objSpec && objSpec.onchange) objSpec.onchange();
}

function SetCTValDate() {

	// SA 11.9.03 - log 39072. Hidden field CTValDate required to pass internal date to
	// payor/plan lookups. CTValDate will be set to the cache equivalent of WLDate
	if ((objCTValDate)&&(objWLDate)) {
		if ((objWLDate.value!="")&&(objWLDate.className!="clsInvalid")) {
			objCTValDate.value=DateStringTo$H(objWLDate.value);
		} else {
			objCTValDate.value="";
		}
	}

}

function CareProviderLookUp(str) {
 	var lu = str.split("^");
	//alert(str);
	var obj=document.getElementById('Doctor');
	if (obj) obj.value = lu[0];
	var obj=document.getElementById('CTLOCDesc');
	if (obj) obj.value = lu[2];
	var obj=document.getElementById('LocId');
	if (obj) obj.value = lu[4];
	var obj=document.getElementById('HOSPDesc');
	if (obj) obj.value = lu[5];
	//log 63144 TedT
	var obj=document.getElementById('DoctorID');
	if (obj) obj.value = lu[8];
	//
	GoWithCorectRest();
}

function SurgeonSelection(str) {
	var lu = str.split("^");
	var obj=document.getElementById('Surgeon');
	if (obj) obj.value = lu[0];
	GoWithCorectRest();
}


function BodyUnloadHandler(e) {
	if (self == top) {
		var win=window.opener;
		if (win) {
			win.treload('websys.csp');
			//win.treload('websys.default.csp');
			/*
			win.location.reload();
			var path="websys.default.csp?WEBSYS.TCOMPONENT=PAWaitingList.List";
			//alert(path)
			var obj=document.getElementById("PatientID");
			if (obj) path+="&PatientID="+obj.value;
			var obj=document.getElementById("EpisodeID");
			if (obj) path+="&EpisodeID="+obj.value;
			var obj=win.document.getElementById("TWKFL");
			if (obj) path+="&TWKFL="+obj.value;
			var obj=win.document.getElementById("TWKFLI");
			if (obj) path+="&TWKFLI="+(obj.value);
			win.location = path;
			//alert(path)
			*/
		}
	}
}

//RQG,Log23447,03.04.02
function LocationLookUp(str) {
	//alert(str);
	var lu = str.split("^");
	var obj=document.getElementById('CTLOCDesc')
	if (obj) obj.value = lu[1]
	//var obj=document.getElementById('DEPDesc')
	//if (obj) obj.value = lu[2]
	var obj=document.getElementById('LocId');
	if (obj) obj.value=lu[3];
    var obj=document.getElementById('HOSPDesc');
	if (obj) obj.value=lu[6];
}

//GR log 24078 8/4/02
function setConsultantFilter() {
	var conobj=document.getElementById('conFlag');
	if (conobj) conobj.value="Y";
	//alert(conobj.value);
}


//KK 17/Apr/2002 Log 24240
function WardLookUpSelect(str) {
	//dummy function
}

//RQG,Log24183: Populate Operation code field on Operation selection
function OperationLookUpSelect(str) {
	var lu=str.split("^");
	var objOperCode=document.getElementById("OperationCode");
	var objOperDesc=document.getElementById("WLOperationDR");
	var objOperestLOS=document.getElementById("WLEstLengthofStay");

	//if (objOperCode) objOperCode.disabled=false;
	if (objOperDesc) objOperDesc.value = lu[0];
	if (objOperDesc.value=="") {
		if (objOperCode)	objOperCode.value="";
	} else {
		if (objOperCode)	objOperCode.value=lu[2];
		if ((objOperestLOS)&&(objOperestLOS.value=="")) objOperestLOS.value=lu[18];
 	}
	//if (objOperCode) objOperCode.disabled=true;
}

function OperationChangeHandler(e) {
	var objOperDesc=document.getElementById("WLOperationDR")
	var objOperCode=document.getElementById("OperationCode");
	if ((objOperDesc.value=="")&&(objOperCode)) objOperCode.value="";
}


//rqg,Log24184:
function SADDDescLookUpHandler(str) {
	//dummy
	return true;
}

function CheckReasonSuspension() {
	//dummy
	return true;
}

function CheckSourceOfAddition() {
	//dummy
	return true;
}

//rqg,Log25163:
function CheckWLStatus() {
	//dummy
	return true;
}

//rqg,Log24673: Date place on list should not be earlier than dob
function CheckDatePlaceOnList() {
	var wlstr,dobstr,dtdob,dtwl;
	var leapyr = (29 / 365)   //constant value to handle leap year in days
      var convert2yr = (365 * 24 * 3600 * 1000 )  //constant value to convert milliseconds to yr
	var objWLDate=document.getElementById('WLDate');
	var objPAPERDob=document.getElementById('PAPERDob');

	if ((objWLID)&&(objWLID.value!="")) { return true; }
      if (objWLDate) wlstr=SplitDateStr(objWLDate.value);
	if (objPAPERDob) dobstr=SplitDateStr(objPAPERDob.value);

	if (dobstr!="") dtdob=new Date(dobstr["yr"], dobstr["mn"]-1, dobstr["dy"]);
	if (wlstr!="") dtwl=new Date(wlstr["yr"], wlstr["mn"]-1, wlstr["dy"]);
	if ((objWLDate)&&(objPAPERDob)) {
		if (dtwl < dtdob) {
			alert(t['WLDATE_ERR']);
			websys_setfocus("WLDate");
		  	return false;
		}
		//SB 20/07/07 (64416):Changed the logic below to use DateTime function to find the difference
		//between dates rather than convert2yr stuff.
		var dateDiff = DateStringDifference(objPAPERDob.value,objWLDate.value);
		//var dateDiff=(((dtwl - dtdob) / convert2yr) - leapyr) /* values in yr */
		//if ((dateDiff == 0)||(dateDiff == 120)||(dateDiff > 120)) /*120 is date diff in years as per user requirement */
		if ((dateDiff["yr"] == 120)||(dateDiff["yr"] > 120)) /*120 is date diff in years as per user requirement */
		{
		     alert(t['DATEDIFF_ERR']);
		     websys_setfocus("WLDate");
		     return false;
		}
	}
	return true;
}

function SplitDateStr(strDate) {
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
	case "DMMMY":   // AJI 24.9.03 log 38882 : added another format to cater DMMMY eg: 4 Dec 2003
	  var dtArr = strDate.split(' ');
 	  var montharray=session['XMONTHSSHORT'].split(',');
	  var mmm=dtArr[1].toUpperCase();
	  var found;
	  for (var i=0, found=0; (i<12)&&(!found); i++)
	     if (mmm==montharray[i].toUpperCase()) { dtArr[1]=i+1; found=1; }

	  if (found) {
	     arrDateComponents["dy"] = dtArr[0];
     	     arrDateComponents["mn"] = dtArr[1];
	     arrDateComponents["yr"] = dtArr[2];
	  }
	  break;
	default:
   	  arrDateComponents["yr"] = arrDate[2];
   	  arrDateComponents["mn"] = arrDate[1];
   	  arrDateComponents["dy"] = arrDate[0];
   	  break;
 	}
 	return arrDateComponents;
}


////////////////////////////////////////////////////////////////////////////////
//KK 30/Apr/2002 Log:24008
function UpdateAll() {
	if (!UpdateActions()) return false;		// SA 5.5.03 - log 35472: Added return false, errors were appearing without the update quitting
	if (!fPAWaitingList_Edit_submit()) return false; 
	DButOnUpdate();
	return update1_click()
}
//rqg,log24512
function UpdateAddRefDocClickHandler() {
	if (!UpdateActions()) return false;		// SA 5.5.03 - log 35472: Added return false, errors were appearing without the update quitting
	if (!fPAWaitingList_Edit_submit()) return false; 
	DButOnUpdate();
	return UpdateAddReferralDoctor_click();
}
function UpdateAddBooking() {
	if (!UpdateActions()) return false;		// SA 5.5.03 - log 35472: Added return false, errors were appearing without the update quitting
	if (!fPAWaitingList_Edit_submit()) return false; 
	DButOnUpdate();
	return UpdateAddBooking_click();
}
function UpdateActions() {
	var arrItems = new Array();
	var lst = document.getElementById("DPTEntered");
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			arrItems[j] = lst.options[j].value;
		}
		var el = document.getElementById("DPTDescString");
		if (el) el.value = arrItems.join(String.fromCharCode(1));
		//alert(el.value );
	}
	if (objWLDate) {
		if (objWLDate.className=="clsInvalid") {
			websys_setfocus("WLDate");
			return false;
		}
	}
	if (!CheckReasonSuspension()) return false;
	if (!CheckSourceOfAddition()) return false;
	if (!CheckDatePlaceOnList()) return false;
	if (!CheckWLStatus()) return false;
	// GR log 35438 to stop update on invalid status.
	var objstatus=document.getElementById("WLSDesc");
	if (objstatus) {
		if (objstatus.className=="clsInvalid") {
			websys_setfocus("WLSDesc");
			return false;
		}
	}
	//
	var objReferralHosp=document.getElementById('CTRFCDesc');
	var frm = document.forms['fPAWaitingList_Edit'];
	for (i=0; i<frm.elements.length; i++) {
		var el = frm.elements[i];
		if (el) {
			if ((el.className=="clsInvalid")&&(el.name!="PIN")) {
				websys_setfocus(el.name);
				return false;
			}
		}
	}
	LOSHandler()
	AustinDummy();
	//log 63444 TedT
	if(!updateScore()) return false;
	
	return true; // SA 6.5.03 - log 35472/35483

}

//log 63444 TedT
function updateScore() {
	var id=document.getElementById("WaitingListID");
	var obj=document.getElementById('WLScore');
	
	if(id && id!="" && obj && obj.disabled) obj.value="";
	
	if (obj && !obj.disabled) {
		var decimal=(obj.value).split(".")[1];
		if(isNaN(obj.value) || (decimal!="" && decimal!=null && decimal.length>3)) {
			alert(t["INVALID_SCORE"]);
			return false;
		}
			
	}
	return true;
}

function DeptLookupSelect(txt) {
	//Add an item to DPTEnetered when an item is selected from
	//the Lookup, then clears the Item text field.
	//alert(txt);
	var adata=txt.split("^");
	//alert("adata="+adata);
	var obj=document.getElementById("DPTEntered")//Hidden Listbox

	if (obj) {
		//Need to check if Department already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == String.fromCharCode(2)+adata[1]) {
				alert("Department has already been selected");
				var obj=document.getElementById("DPTDesc")//Textbox with lookup for dept
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
			alert("Department has already been selected");
				var obj=document.getElementById("DPTDesc")
				if (obj) obj.value="";
				return;
			}
			//alert(obj.options[i].value+"****"+adata[1])
		}
	}
	AddItemToList(obj,adata[1],adata[0]);
	var obj=document.getElementById("DPTDesc")
	if (obj) obj.value="";
	//alert("adata="+adata);
}

function AddItemToList(list,code,desc) {
	//Add an item to a listbox
	code=String.fromCharCode(2)+code
	list.options[list.options.length] = new Option(desc,code);
}

function DeptDeleteClickHandler() {
	//Delete items from DPTEntered listbox when "Delete" button is clicked.
	var obj=document.getElementById("DPTEntered")
	if (obj)
		RemoveFromList(obj);
	return false;
}

function RemoveFromList(obj) {
	for (var i=(obj.length-1); i>=0; i--) {
		if (obj.options[i].selected)
			obj.options[i]=null;
	}
}

function StatePPPLookUpHandler(str) {
	//alert("str="+str);
 	var lu = str.split("^");
	var PPPcode=document.getElementById('SPPPCode');
	var PPPdesc=document.getElementById('SPPPDesc');
	if (PPPdesc) {
		PPPdesc.value=lu[0];
		if (PPPcode) {
			PPPcode.value=lu[2];
		}
	}
	var natind=document.getElementById('NPPPDesc');
	if (natind) {
		natind.value=lu[5]
		natind.innerText=lu[5]   // Aji log 39524 - Set innerText so displayOnly option will still work
	}
	var objOperestLOS=document.getElementById("WLEstLengthofStay");
	if (objOperestLOS) {
		objOperestLOS.value=lu[7]
		objOperestLOS.innerText=lu[7]
	}
}

// Aji log 39524 - overriden, needs to clear out respective fields if SPPP is empty.
function SPPPDesc_changehandler(encmeth) {

	if (SPPPDesc.value=="") {
		var codeobj=document.getElementById('SPPPCode');
		if (codeobj) codeobj.value="";
		codeobj=document.getElementById('NPPPDesc');
		if (codeobj) {
			codeobj.value="";
			codeobj.innerText="";
		}
	}

	var obj=document.getElementById('SPPPDesc');
	if (obj.value!='') {
		var tmp=document.getElementById('SPPPDesc');
		if (tmp) {var p1=tmp.value } else {var p1=''};
		var tmp=document.getElementById('CTLOCDesc');
		if (tmp) {var p2=tmp.value } else {var p2=''};
		var tmp=document.getElementById('WLTDesc');
		if (tmp) {var p3=tmp.value } else {var p3=''};
		var tmp=document.getElementById('DateActive');
		if (tmp) {var p4=tmp.value } else {var p4=''};
		var tmp=document.getElementById('HidCP');
		var p5=""
		if (tmp) {var p6=tmp.value } else {var p6=''};
		if (cspRunServerMethod(encmeth,'SPPPDesc_lookupsel','StatePPPLookUpHandler',p1,p2,p3,p4,p5,p6)=='0') {
			obj.className='clsInvalid';
			websys_setfocus('SPPPDesc');
			return websys_cancel();
		}
	}
	obj.className='';
}


/////////////////////////////////////////////////////////

// cjb 17/01/2005 50709 - removed, now done in the component
/*
//reload is called in websys.close.csp page
//document.body.onunload=BodyUnloadHandler;
// Log 25029
//BC 17-5-2002: Stolen from PAPerson.Edit It over-writes one from SCRIPTS_GEN so that it can pass in the WEBSYS.TCOMPONENT value:
function REFDDesc_lookuphandlerCustom(e) {
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))) {
		var namevaluepairs="&P1=&P2=&P3=&P5=&P6=&P7=&P8=&P9=&P10=&P11=";
		var obj=document.getElementById('REFDDesc');
		//var obj2=document.getElementById('RefDocRestriction');
		if (obj) {namevaluepairs="&P1="+obj.value+"&P2=&P3=&P5=&P6=&P7=&P8=&P9=&P10=&P11="}
		REFDDesc_lookuphandlerCustom2(namevaluepairs);
	}
}
function REFDDesc_lookuphandlerCustom2(namevaluepairs) {
	var url='websys.lookup.csp';
	url += "?ID=d407iREFDDesc&WEBSYS.TCOMPONENT=PACRefDoctor.CustomFind"+namevaluepairs;
	url += "&CONTEXT=Kweb.PACRefDoctor:LookUpDoctor&TLUJSF=ViewDoctorLookUp";
	var tmp=url.split('%');
	url=tmp.join('%25');
	// Log 59598 - BC - 29-06-2006 : remove statusbar variable (status=) to display the status bar.
	websys_createWindow(url,"lookup","top=30,left=20,width=620,height=420,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
	return websys_cancel();
}
*/
function ViewDoctorLookUp(str) {
	refDocChangeHandler
	//alert(str);
 	var lu = str.split("^");
	var obj;
	//Log 22284 BC 14-Mar-2002

	var fulladdress=""
	// md 21/02/2005 49474 - fulladdress now returned from the query
	if (lu[29]!="") { fulladdress=lu[29]; }
	if (fulladdress=="")
	{
	if (lu[17]!="") {fulladdress=lu[17];}
	if (lu[10]!="") {fulladdress=fulladdress+","+lu[10];}
	if (lu[18]!="") {fulladdress=fulladdress+","+lu[18];}
	if (lu[19]!="") {fulladdress=fulladdress+","+lu[19];}
	}
	// SA 9.9.03 - Found lu[] array index had changed from w642 -> w650
	// while fixing patching problems for 38971. Have updated lu[numbers]

	obj=document.getElementById("GPCode")
	if (obj) obj.value = lu[5];
	//if (obj) obj.value = lu[8];
	obj=document.getElementById("REFDDesc")
	if (obj) obj.value = lu[1];
	//if (obj) obj.value = lu[0];
	//obj=document.getElementById("DoctorCode");
	//if (obj) obj.value = lu[4];
	//if (obj) obj.value = lu[1];
 	obj=document.getElementById("CLNCode");
	if (obj) obj.value = lu[7];
	//if (obj) obj.value = lu[3];
 	obj=document.getElementById("CLNAddress1");
	//if (obj) obj.value = lu[10];
	if (obj) obj.value = fulladdress;
	//if (obj) obj.value = lu[4];
	obj=document.getElementById("WLRefDocClincDR");
	if (obj) obj.value = lu[8];
	//if (obj) obj.value = lu[5];
	obj=document.getElementById("CLNPhone");
	if (obj) obj.value = lu[12];
	//if (obj) obj.value = lu[7];
	obj=document.getElementById("REFDFullName");
	if (obj) obj.innerText=lu[30];
}
function refDocChangeHandler(e) {
	var obj;
	obj=document.getElementById("WLRefDocClincDR")
	if (obj) obj.value = "";
	obj=document.getElementById('CLNAddress1')
	if (obj) obj.value = "";
	obj=document.getElementById('CLNCode')
	if (obj) obj.value = "";
	obj=document.getElementById('CLNPhone')
	if (obj) obj.value = "";
}

function setSiteFlag(str) {
	var objSiteFlag=document.getElementById("SiteFlag");
	if (objSiteFlag) objSiteFlag.value = str;
}

function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if (el.disabled) {
		return false;
	}
	return true;

}

function ShortNoticeClickHandler(e) {
	shortnoticeobj=websys_getSrcElement(e);
	shortnoticeflagobj=document.getElementById("WLShortNoticeFlag");
	if (shortnoticeflagobj) {
		if (shortnoticeobj.checked) {
			shortnoticeflagobj.value="Y"
		} else {
			shortnoticeflagobj.value="N"
		}
	}

}

function disablebuttons(){
	//GR 15/2/05 disabling buttons when form disabled.
	if ((objVisStat)&&(objWLStatus)) {
		if (((objVisStat.value!="N")&&(objVisStat.value!=""))||(objWLStatus.value==removed)){
			objUpdate=document.getElementById('update1');
			if (objUpdate) {
				objUpdate.onclick="";
				objUpdate.disabled=true;
			}
			objUpdateAddBooking=document.getElementById('UpdateAddBooking');
			if (objUpdateAddBooking) objUpdateAddBooking.onclick="";
			if (tsc['update1']) websys_sckeys[tsc['update1']]="";
		}
	}
}

function disableform() {
//GR this is stuff for lothian that needs to go in if they go to 6.5.  log is 55491
//	var apptobj=document.getElementById('apptstatuscode');
//		if (((objVisStat.value!="N")&&(objVisStat.value!=""))||(objWLStatus.value==removed)||((apptobj.value!="N")&&(apptobj.value!="X")&&(apptobj.value!=""))){
	var wlstatus=document.getElementById('DisableForm'); //gr log 50927 if value = "D" then disable form.
	if ((objVisStat)&&(objWLStatus)) {
		if (((objVisStat.value!="N")&&(objVisStat.value!=""))||(objWLStatus.value==removed)||(wlstatus.value=="D")){
			var frm = document.forms['fPAWaitingList_Edit'];
			for (i=0; i<frm.elements.length; i++) {
				var el = frm.elements[i];
				var icn= "ld407i" + el.name
				//var el = frm.elements[arrElem[i]];
				if ((el)&&(el.type!="hidden")) {
					el.disabled=true;
					el.className = "disabledField";
					//alert(icn);
					icon=document.getElementById(icn)
					if (icon) icon.style.visibility = "hidden";
				}
			}
			disablebuttons();
			//disablebutton('delete1');
			disablebutton('DeleteDept');
			disablebutton('UpdateAddReferralDoctor');
		}
	}
}
function disablebutton(button) {
	obj=document.getElementById(button);
	if (obj) {
		obj.onclick=LinkDisable;
		obj.disabled=true;
	}
}

function disablestatuspriority() {
	//log 32923 GR
	var icnWLPDesc=document.getElementById('ld407iWLPDesc');
	var objPriority=document.getElementById('WLPDesc');
	if ((objWLID)&&(objWLID.value!="")) {
		if (objPriority) objPriority.disabled=true;
		if (icnWLPDesc) icnWLPDesc.disabled=true;
	}
}

function SetBlankToDateAndID() {
	// RQG 11.03.03 L30658 - New function to set blank on all date and id fields

	var objID=document.getElementById('ID');
	if (objID) objID.value="";

	var objWLID=document.getElementById('WaitingListID');
	if (objWLID) objWLID.value="";

	var objWLNO=document.getElementById('WLNO');
	if (objWLNO) objWLNO.value="";

	var objTCIStatus=document.getElementById('TCIVisitStatus');
	if (objTCIStatus) objTCIStatus.value="";

	//RQG 03.10.03 L39523
	var objWLInitial=document.getElementById('WLInitialStatus');
	var objWLSDesc=document.getElementById('WLSDesc');
	//if (objWLSDesc) objWLSDesc.value="Initial";
	if (objWLInitial && objWLSDesc) objWLSDesc.value=objWLInitial.value;

	var objWLSCode=document.getElementById('WLSCode');
	if (objWLSCode) objWLSCode.value="I";

	var objReasonSuspension=document.getElementById('ReasonSuspension');
	if (objReasonSuspension) objReasonSuspension.value="";

	var objLastUpdateHospital=document.getElementById('LastUpdateHospital');
	if (objLastUpdateHospital) {
		if (objLastUpdateHospital.tagName=="LABEL") {
			objLastUpdateHospital.innerText="";
		} else {
			objLastUpdateHospital.value="";
		}
	}

	var objWLUpdateUserDR=document.getElementById('WLUpdateUserDR');
	if (objWLUpdateUserDR) {
		if (objWLUpdateUserDR.tagName=="LABEL") {
			objWLUpdateUserDR.innerText="";
		} else {
			objWLUpdateUserDR.value="";
		}
	}

	var objWLUpdateDate=document.getElementById('WLUpdateDate');
	if (objWLUpdateDate) {
		if (objWLUpdateDate.tagName=="LABEL") {
			objWLUpdateDate.innerText="";
		} else {
			objWLUpdateDate.value="";
		}
	}

	var objWLUpdateTime=document.getElementById('WLUpdateTime');
	if (objWLUpdateTime) {
		if (objWLUpdateTime.tagName=="LABEL") {
			objWLUpdateTime.innerText="";
		} else {
			objWLUpdateTime.value="";
		}
	}

	var objNADateTo=document.getElementById('NADateTo');
	if (objNADateTo) objNADateTo.value="";

	var objNADateFrom=document.getElementById('NADateFrom');
	if (objNADateFrom) objNADateFrom.value="";

	var objWLDonationDate=document.getElementById('WLDonationDate');
	if (objWLDonationDate) objWLDonationDate.value="";

	var objWLDate=document.getElementById('WLDate');
	var objDateToday=document.getElementById('DateToday');
	//if (objWLDate) objWLDate.value="";
	if (objWLDate) objWLDate.value=objDateToday.value;

	var objWLDateDecidedToAdmit=document.getElementById('WLDateDecidedToAdmit');
	if (objWLDateDecidedToAdmit) objWLDateDecidedToAdmit.value="";

	var objWLEffectiveRemovalDate=document.getElementById('WLEffectiveRemovalDate');
	if (objWLEffectiveRemovalDate) {
		if (objWLEffectiveRemovalDate.tagName=="LABEL") {
			objWLEffectiveRemovalDate.innerText="";
		} else {
			objWLEffectiveRemovalDate.value="";
		}
	}

	var objWLDeferredDate=document.getElementById('WLDeferredDate');
	if (objWLDeferredDate) {
		if (objWLDeferredDate.tagName=="LABEL") {
			objWLDeferredDate.innerText="";
		} else {
			objWLDeferredDate.value="";
		}
	}


	var objWLDateOfList=document.getElementById('WLDateOfList');
	if (objWLDateOfList) objWLDateOfList.value="";

	var objWLEffectiveDate=document.getElementById('WLEffectiveDate');
	if (objWLEffectiveDate) objWLEffectiveDate.value="";

	var objWLDeferredDate=document.getElementById('WLDeferredDate');
	if (objWLDeferredDate) objWLDeferredDate.value="";

	var objWLEstOperDate=document.getElementById('WLEstOperDate');
	if (objWLEstOperDate) objWLEstOperDate.value="";

	var objWLEstOperTime=document.getElementById('WLEstOperTime');
	if (objWLEstOperTime) objWLEstOperTime.value="";

	var objWLExpectedAdmDate=document.getElementById('WLExpectedAdmDate');
	if (objWLExpectedAdmDate) objWLExpectedAdmDate.value="";

	var objGEDate=document.getElementById('GEDate');
	if (objGEDate) {
		if (objGEDate.tagName=="LABEL") {
			objGEDate.innerText="";
		} else {
			objGEDate.value="";
		}
	}

	var objWLDaysOnList=document.getElementById('WLDaysOnList');
	if (objWLDaysOnList) {
		if (objWLDaysOnList.tagName=="LABEL") {
			objWLDaysOnList.innerText="";
		} else {
			objWLDaysOnList.value="";
		}
	}

	var objWLLastReviewedDate=document.getElementById('WLLastReviewedDate');
	if (objWLLastReviewedDate) objWLLastReviewedDate.value="";

	var objWLPreopDate=document.getElementById('WLPreopDate');
	if (objWLPreopDate) objWLPreopDate.value="";

}

if ((shortnoticeflagobj)&&(shortnoticeobj)) {
	if (shortnoticeflagobj.value=="Y") {
		shortnoticeobj.checked=true
	} else {
		shortnoticeobj.checked=false
	}
}

//RQG 20.03.03 L30658
function CopyClickHandler() {
	alert("Inside CopyClickHandler");
	var WLID=""; var PatientID=""; var ID="";
	if (!CheckCopyWLStatus()) return false;

	var wlobj=document.getElementById('WaitingListID');
	if (wlobj) WLID=wlobj.value;
	var idobj=document.getElementById('ID');
	if (idobj)  ID=idobj.value;
	var objpatientid=document.getElementById('PatientID');
	if (objpatientid) PatientID=objpatientid.value;
	var copy="Copy";
	//var url="websys.default.csp?WEBSYS.TCOMPONENT=PAWaitingList.Edit&ID="+idobj.value+"&PatientID="+patientid.value+"&WaitingListID="+wlobj.value+"&PatientBanner=1"+"&Mode="+copy;
	var url="websys.default.csp?WEBSYS.TCOMPONENT=PAWaitingList.Edit&ID="+"&PatientID="+PatientID+"&WaitingListID="+"&PatientBanner=1"+"&Mode="+copy;

	//alert(url);
	// Log 59598 - BC - 29-06-2006 : remove statusbar variable (status=) to display the status bar.
	websys_createWindow(url,'','top=30,left=20,width=750,height=480,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes');
}

function CheckCopyWLStatus() {
	//This is a dummy function here. Check for QH done via custom js
	return true;
}

function PlannedSameDayLookupSelect(str) {
 	var lu = str.split("^");
	var plan=lu[0];
	if (plan=="Yes") {
		if (LOSobj) {
			LOSobj.value=0
			LOSvalue=LOSobj.value
		}
	} else {
		if (LOSobj) {
			if (LOSobj.value=="0") {
				LOSobj.value=""
				LOSvalue=LOSobj.value
			}
		}
	}
}


function LOSHandler() {
	if (LOSobj) {
		//
		var isValid=0;
		if (IsValidNumber(LOSobj)) {
			isValid=1;
			if (!IsValidNumber(LOSobj)) isValid=0;
		}
		if (!isValid) {
			LOSobj.className='clsInvalid';
			websys_setfocus('WLEstLengthOfStay');
			return websys_cancel();
		} else {
			LOSobj.className='';
		}
		LOSvalue=LOSobj.value
		if (planobj) {
			if (planobj.value=="Yes") {
				if (LOSobj.value!=0) {
					LOSobj.value=0
					LOSobj.className='';
				}
			}else if (planobj.value=="No") {
				if (LOSobj.value<1) LOSobj.className='clsInvalid';
			}
		}

	}
}
function SERDescLookUpSelect(str) {
	var lu = str.split("^");
	//alert(str);
	var obj=document.getElementById('SERDesc');
	if (obj) obj.value=lu[1];
	var obj=document.getElementById('ServId');
	if (obj) obj.value=lu[3];
	//alert(lu[3]);
}
function HospLookup(str) {
	var lu = str.split("^");
	var obj=document.getElementById("HospID");
	if (obj) obj.value=lu[1];
}


function ServiceTextChangeHandler(){
	//dummy function
}


function AustinDummy() {
	//dummyfunction for checks on update for austin
}
function ATTENDDescLookup(str) {
 	var lu = str.split("^");
	var obj=document.getElementById("ATTENDDesc")
	if (obj) obj.value = lu[0];
	//gr log 56277 changed from piece 3
	return true;
}

function GoWithCorectRest() {

	var objSur=document.getElementById("Surgeon");
	var objDoc=document.getElementById("Doctor");
	var objHFL=document.getElementById("HidCP");
	if (objHFL) {
	objHFL.value=""
	if ((objSur)&&(objSur.value!="")) { objHFL.value=objSur.value }
	if ((objDoc)&&(objDoc.value!="")&&(objHFL.value=="")) { objHFL.value=objDoc.value }

	//alert("objHFL.value="+objHFL.value)

	}


}

//KB 19.03.07 log 62629
function WLPatientTypeLookUpHandler(str) {
	var lu = str.split("^");
	var statusCode = document.getElementById("WLSCode");

  if (lu[2]!="") {
	obj=document.getElementById("WLPatientTypeDR");
	if (obj) obj.value = lu[0];

	}
}

//KB 27.03.07 log 62629
function DisablePatientType(status)
{
	var patientTypeObj = document.getElementById("WLPatientTypeDR");
	if (patientTypeObj)
	{
		patientTypeObj.disabled=status;
		patientTypeObj.readOnly=status;
	}
	var patientTypeIcon = document.getElementById("ld407iWLPatientTypeDR");
	if (patientTypeIcon) patientTypeIcon.disabled=status;
}

function DefaultRecallSchema()
{
	var RecallSchedID = document.getElementById("RecallSchedID").value;
	if (RecallSchedID=="") return;
	var RecallSchedHidden = document.getElementById("RecallSchedHidden").value;
	
	if (RecallSchedHidden!="") {
		var RSAry = RecallSchedHidden.split("^");
		var obj = document.getElementById("WLTDesc")
		if (obj && RSAry[0]!="") obj.value=RSAry[0]
		var obj = document.getElementById("WLPDesc")
		if (obj && RSAry[1]!="") obj.value=RSAry[1]
		var obj = document.getElementById("WLSDesc")
		if (obj && RSAry[2]!="") obj.value=RSAry[2]
		var obj = document.getElementById("CTLOCDesc")
		if (obj && RSAry[3]!="") obj.value=RSAry[3]
		var obj = document.getElementById("HOSPDesc")
		if (obj && RSAry[4]!="") obj.value=RSAry[4]
		var obj = document.getElementById("Doctor")
		if (obj && RSAry[5]!="") obj.value=RSAry[5]
		var obj = document.getElementById("WLConsultCateg")
		if (obj && RSAry[6]!="") obj.value=RSAry[6]
		var obj = document.getElementById("WLTCode")
		if (obj && RSAry[7]!="") obj.value=RSAry[7]
		var obj = document.getElementById("RecallDate")
		//Recall Date is now passed into the component
		//if (obj && RSAry[8]!="" && objWLDate.value!="") obj.value=AddToDateStrGetDateStr(objWLDate.value,"D",parseInt(RSAry[8]));
		var obj = document.getElementById("RecallPeriod")
		if (obj && RSAry[10]!="") obj.value=RSAry[10]
	}
	return;
}

function DButOnUpdate() {
	
	var fld=document.getElementsByTagName('A');
	for (var j=0; j<fld.length; j++) {
		fld[j].onclick = LinkDisable;
		fld[j].disabled = true;
	}
}

function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);

	if (el.disabled||el.id=="") return false;

	return true;
}

document.body.onload=BodyLoadHandler;
