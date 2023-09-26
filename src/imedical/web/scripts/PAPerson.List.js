// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var returnSelected="";
var obj=document.getElementById("returnSelected");
if (obj) returnSelected=obj.value;
//Log 61263 - 09.11.2006
var UpdateBooking="";
var obj=document.getElementById("updateBooking");
if (obj) UpdateBooking=obj.value;
//End Log 61263
var patType=document.getElementById("mergePatient").value;
var CopyAdmission=document.getElementById("CopyAdmission").value;
var systemconfigs=document.getElementById("PATCF")
var FirstPatientID=document.getElementById("FirstPatientID")		// cjb 01/03/2006 58375
var CloseIfOneReturned=document.getElementById("CloseIfOneReturned")		// cjb 02/03/2006 58375


function DocumentLoadHandler() {
	setEstDOB();
	MultiMRN();
	//alert(patType+","+UpdateBooking)
	if (patType=="CLIENT") {
		assignClickHandler("client");
	} else if (patType=="RBEventPatientList") {
		assignClickHandler("events");
	} else if (patType=="CopyDemographics") {
		assignClickHandler("CopyDemographics");
	} else if (patType!="") {
		assignClickHandler("merge");
	} else if (UpdateBooking) {		//Log 61263 - 09.11.2006 - if this is set, no need to return anything. Go to the RBAppointment.UpdateBooking component
		document.onclick=gotoUpdateBooking;
	} else {
	    if (returnSelected) {
			document.onclick=RefreshPatientSelected;
		} else {
			document.onclick=StorePatientSelected;
		}
	}

	// cjb 01/11/2005 52820 - opening PAPerson.List (websys.csp) in a new window, from the quick appt screen will kill the session locks.  Running the KeepLock function will re-set them
	if ((window.opener)&&(window.opener.name=="RBServList")&&(window.opener.top.frames["TRAK_main"])&&(window.opener.top.frames["TRAK_main"].frames["RBApptList"])) {
		window.opener.top.frames["TRAK_main"].frames["RBApptList"].KeepLock();
	}

	// cjb 22/02/2006 56793/58375 - If there is only one patient returned, run the function to select them and close the window, etc
	if ((window.opener)&&(FirstPatientID)&&(FirstPatientID.value!="")&&(CloseIfOneReturned)&&(CloseIfOneReturned.value=="Y")) {
		if (patType=="CLIENT") {
			clientHandler2("1");
		} else if (patType=="RBEventPatientList") {
			RBEventsHandler2("1");
		} else if (patType=="CopyDemographics") {
			CopyDemographicsHandler2("1");
		} else if (patType!="") {
			mergePatientHandler2("1");
		} else if (returnSelected) {
			var RegNo="";
			var obj=document.getElementById("RegistrationNoz1");
			if (obj) RegNo=obj.innerText;
			var re = /(\s)+/g ;	//regular expr for removing all spaces
			RegNo=RegNo.replace(re,'');

			RefreshPatientSelected2("1",RegNo)
		}
	}

	// 61985
	var Ext1=document.getElementById("Interface1");
	var Ext2=document.getElementById("Interface2");
	if (Ext1) Ext1.onclick=InterfaceHandler;
	if (Ext2) Ext2.onclick=InterfaceHandler;
	var ExtSearch=document.getElementById("ExtSearch");
	if (ExtSearch) ExtSearch.onclick=SearchClick;
}

// 61985
function InterfaceHandler() {
	var Ext1=document.getElementById("Interface1");
	var Ext2=document.getElementById("Interface2");
	if (Ext1 && Ext2) {
		if ((Ext1.checked==true) && (Ext2.checked==false)) {
			Ext2.disabled=true;
		} else if ((Ext1.checked==false) && (Ext2.checked==true)) {
			Ext1.disabled=true;
		} else {
			Ext1.checked=false;
			Ext2.checked=false;
			Ext1.disabled=false;
			Ext2.disabled=false;
		}
	}
	return;
}

function SearchClick(evt) {
	var eSrc = websys_getSrcElement(evt);
	var Ext1=document.getElementById("Interface1");
	var Ext2=document.getElementById("Interface2");
	if (Ext1 && Ext1.checked) eSrc.href+= "&Interface1=on";
	if (Ext2 && Ext2.checked) eSrc.href+= "&Interface2=on";

	return;
}

//stores the patient selected into the epr headers.
//TN-17/1/2002: must select the registration link to be considered selected
function StorePatientSelected(evt) {
	var eSrc = websys_getSrcElement(evt);
	if (eSrc.tagName=="IMG") eSrc = websys_getParentElement(eSrc);
	if ((eSrc.id)&&(eSrc.id.indexOf("RegistrationNoz")==0)) {
		var eSrcAry=eSrc.id.split("z");
		var row=eSrcAry[eSrcAry.length-1];
		var objID=document.getElementById("IDz"+row);
		// BC 4-4-2002 LOG 23371 Warning about picking a deceased patient
		if (document.getElementById("Deadz"+row)) {
			if (document.getElementById("Deadz"+row).value=="Y") {
				var dec=confirm(t['PatDead'])
				if (!dec) {
					//RefreshPatientSelected(evt)
					return false
				}
			}
		}
		if (document.getElementById("sexCodez"+row)) {
			if ((systemconfigs)&&(systemconfigs.value!="")) {
				var aryPATCF=systemconfigs.value.split("^")
				var validSex=aryPATCF[2]
				if (validSex!="") {
					var checkSex=document.getElementById("sexCodez"+row).value.split("^")
					if ((checkSex[0]!=validSex)&&(checkSex[1]==1)) {
					alert(t['PatSex']);
					return false
					}
				}

			}
		}
		if (objID) {
			var PatientID=objID.value;
			var winf = null;
			if (window.parent != window.self) winf = window.parent;
			if ((winf)&&(winf.frames['eprmenu'])) {
				// ab 60501 - clear all details so they dont get carried to new patient
				//winf.SetSingleField("EpisodeID","");
				winf.MainClearEpisodeDetails();
				winf.SetSingleField("PatientID",PatientID);
			}
		}

	}
}

//used when another screen opens the patient search in a new window and needs to return back to that screen with the patient selected
//must select the registration link to be considered selected
//JW:modifed to display deceased message.
function RefreshPatientSelected(evt) {
	var eSrc = websys_getSrcElement(evt);
	if (eSrc.tagName=="IMG") eSrc = websys_getParentElement(eSrc);
	if ((eSrc.id)&&(eSrc.id.indexOf("RegistrationNoz")==0)) {
		var eSrcAry=eSrc.id.split("z");
		var row=eSrcAry[eSrcAry.length-1];
		var RegNo=eSrc.innerText;
		var re = /(\s)+/g ;	//regular expr for removing all spaces
		RegNo=RegNo.replace(re,'');
		RefreshPatientSelected2(row,RegNo)
	}
}


function RefreshPatientSelected2(row,RegNo) {
	var objID=document.getElementById("IDz"+row);

	//Log 60931 - 18/10/2006
	var objAgr=document.getElementById("ValidAgrz"+row);
	if (objAgr) var valAgr=objAgr.value;
	//End Log 60931

	if (document.getElementById("Deadz"+row)) {
		if (document.getElementById("Deadz"+row).value=="Y") {
			var dec=confirm(t['PatDead'])
			if (!dec) {
				//RefreshPatientSelected(evt)
				return false
			}
		}
	}
	if (document.getElementById("sexCodez"+row)) {
		if ((systemconfigs)&&(systemconfigs.value!="")) {
			var aryPATCF=systemconfigs.value.split("^")
			var validSex=aryPATCF[2]
			if (validSex!="") {
				var checkSex=document.getElementById("sexCodez"+row).value.split("^")
				if ((checkSex[0]!=validSex)&&(checkSex[1]==1)) {
					alert(t['PatSex']);
					return false
				}
			}
		}
	}

	if (objID) {
		var PatientID=objID.value;
		if (window.opener) {
			var obj=window.opener.document.getElementById('RegistrationNo');
			if (obj) obj.value=RegNo;
			var obj=window.opener.document.getElementById('PatientID');
			if (obj) obj.value=PatientID;
			if (window.opener.name=="RBServList") {
			    //should really be it the RBServList script so don't need to keep adding here
				var RowObj=window.opener.document.getElementById('RowNumber');
				if (RowObj) {
					var obj=window.opener.document.getElementById('RegistrationNoz'+RowObj.value);
					if (obj) obj.innerHTML=RegNo;

					// Log 60931 - 12/10/2006
					var objValAgr=window.opener.document.getElementById('ValidAgrz'+RowObj.value);
					if (objValAgr) {
						objValAgr.value=valAgr;
					}
					// End Log 60931

					//Log 60875 - 23/10/2006 - Send Payor/Plan details to parent
					var DefPayor="";
					var objPayor=document.getElementById("DefPayorz"+row);
					if (objPayor) DefPayor=objPayor.value;

					if (DefPayor!="") {	//Log 65390 - only assign it back if there are values
						var objDefPayor=window.opener.document.getElementById('payDescz'+RowObj.value);
						if (objDefPayor) objDefPayor.innerHTML=DefPayor;
					}	

					var DefPayorID="";
					var objPayorID=document.getElementById("DefPayorIdz"+row);
					if (objPayorID) DefPayorID=objPayorID.value;

					if (DefPayorID!="") {	//Log 65390 - only assign it back if there are values
						var objDefPayorId=window.opener.document.getElementById('payIdz'+RowObj.value);
						if (objDefPayorId) objDefPayorId.value=DefPayorID;
					}	

					var DefPlan="";
					var objPlan=document.getElementById("DefPlanz"+row);
					if (objPlan) DefPlan=objPlan.value;

					if (DefPlan!="") {	//Log 65390 - only assign it back if there are values
						var objDefPlan=window.opener.document.getElementById('planDescz'+RowObj.value);
						if (objDefPlan) objDefPlan.innerHTML=DefPlan;
					}	

					var DefPlanId="";
					var objPlanID=document.getElementById("DefPlanIdz"+row);
					if (objPlanID) DefPlanId=objPlanID.value;

					if (DefPlanId!="") {	//Log 65390 - only assign it back if there are values
						var objDefPlanId=window.opener.document.getElementById('planIdz'+RowObj.value);
						if (objDefPlanId) objDefPlanId.value=DefPlanId;
					}	
					//End Log 60875
				}
				window.close();
				return false;
			} else if ((window.opener.name=="appointments")||(window.opener.name=="DaySessionCP")) {		//Log 61263 - 06.11.2006 - Return patient Reg to RBAppointment.FindRescDaySched screen
				var obj=window.opener.document.getElementById('UseURN');
				if (obj) obj.value=RegNo;

				var obj=window.opener.document.getElementById('URNPatID');
				if (obj) obj.value=PatientID;
			}
			window.close();
		}
	}
}

function mergePatientHandler(e) {
	var obj=websys_getSrcElement(e);
	if (obj.tagName=="IMG") obj=websys_getParentElement(obj);
	var rowid=obj.id;
	var rowAry=rowid.split("z");
	mergePatientHandler2(rowAry[1])
}

function mergePatientHandler2(row) {
	var twkfl=window.opener.document.forms[0].TWKFL.value;
	var twkfli=window.opener.document.forms[0].TWKFLI.value;
	var TOPatientID=window.opener.document.forms[0].TOPatientID.value;
	var FROMPatientID=window.opener.document.forms[0].FROMPatientID.value;
	var FROMMRN=""; var TOMRN="";
	if (window.opener.document.forms[0].FROMMRN) var FROMMRN=window.opener.document.forms[0].FROMMRN.value;
	if (window.opener.document.forms[0].TOMRN) var TOMRN=window.opener.document.forms[0].TOMRN.value;

	var patID=document.getElementById("IDz"+row).value;
	if (patType=="FROM") FROMPatientID=patID
	if (patType=="TO") TOPatientID=patID

	if (((patType=="FROM") && (window.opener.CheckFROMPatient(patID))) || ((patType=="TO") && (window.opener.CheckTOPatient(patID)))) { // cjb 11/04/2006 58847
		var lnk = "pamergepatient.data.csp?"+patType+"PatientID="+ patID +"&TOMRN="+ TOMRN +"&FROMMRN="+ FROMMRN+"&TWKFLI="+twkfli+"&TWKFL="+twkfl;
		var CopyAdmission=document.getElementById("CopyAdmission").value;
		if (CopyAdmission=="1") var lnk = "pamergepatient.datacopyadmission.csp?"+patType+"&PatientID="+ patID +"&TOPatientID="+ TOPatientID +"&FROMPatientID="+ FROMPatientID +"&TOMRN="+ TOMRN +"&FROMMRN="+ FROMMRN +"&TWKFLI="+twkfli+"&TWKFL="+twkfl;
		if (window.opener.top.frames["TRAK_hidden"]) window.opener.top.frames["TRAK_hidden"].location=lnk;
		//SB 19/09/02 (23945): Added the following below to retrieve Reg No for Event Booking
		if (window.opener.document.forms[0].PatName) window.opener.document.forms[0].PatName.value=document.getElementById("RegistrationNoz"+row).innerText
	}
	window.close();
}



// ab 23.09.03 39225
function clientHandler(e) {
	var obj=websys_getSrcElement(e);
	if ((obj)&&(obj.tagName=="IMG")) obj=websys_getParentElement(obj);
	if (obj) {
		var rowid=obj.id;
		var rowAry=rowid.split("z");
		clientHandler2(rowAry[1]);
	}
}
// cjb 22/02/2006 56793 - moved this code from the clientHandler function, so it can be called from there and also the load handler if only one patient returned
function clientHandler2(row) {
	var patID=document.getElementById("IDz"+row).value;

	// hidden broker populates PAEnquiryContact.Edit with client details
	if (window.opener.document.forms[0].ENQPAPERDR) window.opener.document.forms[0].ENQPAPERDR.value=patID;
	// ab 27.11.03 - 40139 - also used to choose organ donors on PAPersonOrganDonor.Edit
	if (window.opener.document.forms[0].ORGPAPERDR) window.opener.document.forms[0].ORGPAPERDR.value=patID;
	// ab 12.12.03 - called from PAAdmContactPerson.Edit
	var PersonID=window.opener.document.getElementById("PersonID");
	if (PersonID) PersonID.value=patID;
	var PersonID=window.opener.document.getElementById("NOKPAPERDR");
	if (PersonID) PersonID.value=patID;
	var FillClientDetails=window.opener.document.getElementById("FillClientDetails");
	if (FillClientDetails) FillClientDetails.onchange();
	window.close();
}

function RBEventsHandler(e) {
	var obj=websys_getSrcElement(e);
	if ((obj)&&(obj.tagName=="IMG")) obj=websys_getParentElement(obj);
	if (obj) {
		var rowid=obj.id;
		var rowAry=rowid.split("z");
		RBEventsHandler2(rowAry[1])
	}
}

function RBEventsHandler2(row) {
	var objPatName=window.opener.document.forms[0].PatName;
	var patStr= "" + document.getElementById("RegistrationNoz"+row)
	var patAry=patStr.split("&");
	var RegNoAry=patAry[9].split("="); var RegNo=RegNoAry[1]
	if (objPatName) objPatName.value=RegNo;
	window.close();
}


function assignClickHandler(type) {
	var tbl=document.getElementById("tPAPerson_List");
	for (var i=1;i<tbl.rows.length;i++) {
		var obj=document.getElementById("RegistrationNoz"+i)
		var objMRN=document.getElementById("RTMAS_MRNoz"+i)
		if (type=="client") {
			if (obj) {
				obj.onclick=clientHandler;
			} if (objMRN) {
				objMRN.onclick=clientHandler;
			}
		} else if (type=="events") {
			if (obj) {
				obj.onclick=RBEventsHandler;
			} if (objMRN) {
				objMRN.onclick = RBEventsHandler;
			}
		} else if (type=="CopyDemographics") {
			if (obj) {
				obj.onclick=CopyDemographicsHandler;
			} if (objMRN) {
				objMRN.onclick = CopyDemographicsHandler;
			}
		} else {
			if (obj) {
				obj.onclick = mergePatientHandler;
			} if (objMRN) {
				objMRN.onclick = mergePatientHandler;
			}
		}
	}
	return;
}

function SplitStr(strid) {
 	var arrid = strid.split("z");
	var size=arrid.length
	var reg=arrid[size-1]
	return reg
}

function ContactPersonClickHandler(e) {

	var eSrc = websys_getSrcElement(e);

	if (eSrc.tagName=="IMG") eSrc=websys_getParentElement(eSrc)

	if ((window.opener)&&(window.opener.name=="contactupper")) {

		if ((eSrc.tagName=="A")&&((eSrc.id.indexOf("RegistrationNo")==0)||
			(eSrc.id=="new"))) {

			twkfl=window.opener.document.forms[0].TWKFL.value
			twkfli=window.opener.document.forms[0].TWKFLI.value
			eSrc.target = "contactlower";
			var path = "websys.default.csp?WEBSYS.TCOMPONENT=PAAdmContactPerson.Edit&ID="
			var arrID=eSrc.id.split("z");
			var selectedrow=arrID[arrID.length-1];
			var el =document.getElementById("EpisodeID")
			if (el) path+="&PARREF="+el.value;
			var obj=document.getElementById("IDz"+selectedrow);
			if (obj) path+="&contPatID="+obj.value;
			path+="&TWKFLI="+twkfli+"&TWKFL="+twkfl
			eSrc.href = path
			window.close()
		}
	}
}


function setEstDOB() {
	var tbl=document.getElementById("tPAPerson_List");
	var f=document.getElementById("fPAPerson_List");
	for (var i=1;i<tbl.rows.length;i++) {
		var eSrc=f.elements['PAPEREstDOBz'+i];
		if ((eSrc)&&(eSrc.value=="Y")) {
			var dob=document.getElementById("Dobz"+i)
			if (dob) dob.className="EstDOB"
		}
	}
}

//ab 33281 - 27.03.03 - bold CDN link if patient has multiple MRN's
function MultiMRN() {
	var tbl=document.getElementById("tPAPerson_List");
	var f=document.getElementById("fPAPerson_List");
	for (var i=1;i<tbl.rows.length;i++) {
		var obj=document.getElementById("MultiMRNz"+i);
		var objCDN=document.getElementById("CDNz"+i);
		if ((obj)&&(obj.value!="")&&(objCDN)) {
			objCDN.style.fontWeight="bold";
		}
	}
}

// cjb 26/09/2006 56820
function CopyDemographicsHandler(e) {
	var obj=websys_getSrcElement(e);
	if ((obj)&&(obj.tagName=="IMG")) obj=websys_getParentElement(obj);
	if (obj) {
		var rowid=obj.id;
		var rowAry=rowid.split("z");
		CopyDemographicsHandler2(rowAry[1])
	}
}

function CopyDemographicsHandler2(row) {
	var objCopyID=window.opener.document.forms[0].CopyID;
	var evt = window.opener.document.createEventObject();

	var ID= document.getElementById("IDz"+row).value
	//var patAry=patStr.split("&");
	//var RegNoAry=patAry[9].split("="); var RegNo=RegNoAry[1]
	if (objCopyID) {objCopyID.value=ID; objCopyID.fireEvent('onchange',evt);}
	window.close();
}

//Log 61263 - 09.11.2006
function gotoUpdateBooking(evt) {
	var eSrc = websys_getSrcElement(evt);
	var row=0;
	var PatientID="";
	if (eSrc.tagName=="IMG") eSrc = websys_getParentElement(eSrc);
	if ((eSrc.id)&&(eSrc.id.indexOf("RegistrationNoz")==0)) {
		var eSrcAry=eSrc.id.split("z");
		row=eSrcAry[eSrcAry.length-1];
	}

	if (row>0) {
		var objID=document.getElementById("IDz"+row);
		if (objID) PatientID=objID.value;

		if (PatientID!="") {
			var obj=document.getElementById("params");
			if (obj) {
				var paramList=(obj.value).split("^");
				var locid=paramList[0];
				var resid=paramList[1];
				var schid=paramList[2];
				var date=paramList[3];
				// RC 02/05/07 62697 Changed to csp to accomodate a hidden frame for appointment checks
				var lnk = "rbappointment.updatebooking.popup.csp?PatientBanner=1&PatientID="+PatientID+"&EpisodeID=&locid="+locid+"&resid="+resid+"&SchedID="+schid+"&date="+date;
				websys_createWindow(lnk,"","width=300,height=300,top=150,left=300,resizable=yes,scrollbars=yes")
			}
		}
	}
	return websys_cancel();
}



document.body.onload = DocumentLoadHandler;


