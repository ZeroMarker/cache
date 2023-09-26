// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var debug="N"  //"Y" = alerts and stuff, "N" = alert free
//populate epr header with patient selected.
var winf = null;
if (window.parent != window.top) winf = window.top;
if ((winf)&&(winf.frames['eprmenu'])) {
	var PatientID=document.forms['fRBAppointment_Find'].elements['PatientID'].value;
	if ((PatientID)&&(winf.frames["eprmenu"].fEPRMENU.PatientID.value=="")) {
		winf.MainClearEpisodeDetails();
		winf.SetSingleField("PatientID",PatientID);
	}
}
var frameset=top.frames["TRAK_main"].frames["fApptFrame"];
var fsrows="";
if (frameset!=null) fsrows = frameset.rows;

document.forms['fRBAppointment_Find'].elements['TFRAME'].value=parent.name;
function DocumentLoadHandler() {
	//alert("This page is currently under re-construction, AGAIN. So if you see any weird happenings, stay calm, count to 10 and try again, and again, and again, until it's fixed.\n\nThanks for your patience.")

	//SB 30/07/02 (26711): Need to pass apptid from worklist to followUp appt to get correct appt details
	// LOG 27222 BC 6-8-2002 Error when transfering an appointment when using the
	// link from the appointment list. Found to be working here so copying this code across to ADEV

	//LOG 57800 RC 07/02/06 Added this little bit in to clear the hospitals if transferring. If defaulting hospital in,
	//it seems to then make the loc/res invalid and the autofind unable to work if they are from a different hospitals.
	var obj = document.getElementById('TransAppt');
	if (obj) BulkApptList=obj.value;
	//alert(BulkApptList);
	if (BulkApptList=="") {
		var obj = document.getElementById('BulkApptList');
		if (obj) BulkApptList=obj.value;
	}
	if (BulkApptList!="") {
		var obj=document.getElementById("HOSPEntered")
		if (obj) {
			for (var i=(obj.length-1); i>=0; i--) {
				obj.options[i].selected=true;
			}
			RemoveFromList(obj);
			UpdateHospitals();
		}
	}

	//LOG 30495 BC 27-11-2002 Hospital list for the search
	obj=document.getElementById('DeleteHospital');
	if (obj) obj.onclick=HospitalDeleteClickHandler;

	//BC 16/5/02 Log 36469

	var objSESSDesc=document.getElementById("SESSDesc")
	if (objSESSDesc) {
		AddItemToList(objSESSDesc,"B",t['RBBlankSession']);
		var objsesstypes=document.getElementById("sesstypedesc")
		if ((objsesstypes)&&(objsesstypes.value!="")) PopulateSessionType(objsesstypes.value)
	}

	var win=top.frames['eprmenu']
	if (win) {
	  var doc=win.document.forms['fEPRMENU']
	  if (doc) {
	    // SA 20.8.02 - log 27659: doc.FollowUpAppt causing RTE when undefined.
	    if (doc.FollowUpAppt) {
	      var fuapptobj=doc.FollowUpAppt;
			if (fuapptobj) {
	  	  		var obj=document.getElementById('FollowUpApptID');
	  	  		if (fuapptobj && obj) obj.value=fuapptobj.value
	  		}
	    }
	  }
	}
	//ClearHospitalList()
	//log 37672 BC 31-7-2003 websys_firstfocus() doesn't need to be used
	//websys_firstfocus();
	InitDefaults();

	obj=document.getElementById('Find');
	if (obj) obj.onclick= FindClickHandler;
	if (tsc['Find']) websys_sckeys[tsc['Find']]=FindClickHandler;

	//start log 66154 EZ 21/01/08 new 'find external' button added
	obj=document.getElementById('FindExternal');
	if (obj) obj.onclick= FindExternalClickHandler;
	//if (tsc['Find']) websys_sckeys[tsc['Find']]=FindExternalClickHandler;
	//end log 66154 EZ 21/01/08 new 'find external' button added

	obj=document.getElementById('Add');
	if (obj) obj.onclick= AddClickHandler;

	//LOG 39806 BC 22-10-2003 Need for Alt-A to add to service list properly
	if (tsc['Add']) websys_sckeys[tsc['Add']]=AddClickHandler;

	obj=document.getElementById('Delete');
	if (obj) obj.onclick= DeleteClickHandler;

	obj=document.getElementById('Clear');
	if (obj) obj.onclick= ClearClickHandler;

	//SB 12/06/02: Change handlers overwrite brokers, change handler now called from broker.
	obj=document.getElementById('CTLOCDesc');
	if (obj) obj.onblur = LocTextBlurHandler;
	//if (obj) obj.onchange= LocationTextChangeHandler;

	obj=document.getElementById('RESDesc');
	if (obj) obj.onblur = ResTextBlurHandler;
	//if (obj) obj.onchange= ResourceTextChangeHandler;

	obj=document.getElementById('SERDesc');
	if (obj) obj.onblur = SerTextBlurHandler;
	//if (obj) obj.onchange= ServiceTextChangeHandler;

	var obj=document.getElementById("AllResFlag");
	if (obj) obj.onclick = AllResClickHandler;

	obj=document.getElementById('EpGrpLoc');
	if (obj) obj.onblur = EpGrpNoOnBlur;

	//RC Log 60263
	var RBApptGroup=document.getElementById("RBApptGroup");
	if (RBApptGroup) RBApptGroup.onblur=GroupOnBlur;
	var EpGrpNo=document.getElementById("EpisodeGroupNumber");
	if (EpGrpNo) EpGrpNo.onclick = EpGrpNoClickHandler

	//Log 31104 RC 22/01/03
	objIReq=document.getElementById('IntReq');
	objDisI=document.getElementById('disInt');
	if (objIReq && objIReq.disabled==true) objDisI.value=1;
	if (objIReq) objIReq.onclick=SetCheckBox;
	SetCheckBox();

	objInt=document.getElementById('Interpreter');
	if ((objInt && objIReq) && ((objIReq.checked==false) || (objIReq.disabled==true))) objInt.disabled=true;
	if (objInt && objIReq && objIReq.checked==true) {
		objInt.disabled=false;
		objInt.className="disabledField";
		objInt.onblur=IntTextBlurHandler;
	}

	objTReq=document.getElementById('TransReq');
	objDisT=document.getElementById('disTrans');
	if (objTReq && objTReq.disabled==true) objDisT.value=1;
	if (objTReq) objTReq.onclick=SetCheckBox;

	SetCheckBox();


	objTra=document.getElementById('Transport');
	if ((objTra && objTReq) && ((objTReq.checked==false) || (objTReq.disabled==true))) objTra.disabled=true;
	if (objTra && objTReq && objTReq.checked==true) {
		objTra.disabled=false;
		objTra.className="disabledField";
		objTra.onblur=TransTextBlurHandler;
	}
	//End Log 31104


	obj=document.getElementById('HCA');
	if (obj) obj.onblur = HCATextBlurHandler;

	var obj=document.getElementById('InsurPayor');
	if (obj) obj.onblur = InsurPayorBlurHandler;

	var obj=document.getElementById('InsurPlan');
	if (obj) obj.onblur = InsurPlanBlurHandler;

	//obj=document.getElementById('HOSPDesc');
	//objb=document.getElementById('HOSPEntered');
	//if ((obj)&&!(objb)) obj.onblur = HOSPTextBlurHandler;

	obj=document.getElementById('Update');
	if (obj) obj.onclick= CheckBeforeUpdate;
	if (tsc['Update']) {
		tsc['Update']="U"
		//alert("tsc[Update] found  "+tsc['Update'])
		websys_sckeys[tsc['Update']]=CheckBeforeUpdate;
	}

	//obj=document.getElementById('UpdateIns');
	//if (obj) obj.onclick= UpdateInsClickHandler;
	//LOG 2..... BC 30-April-2002  Part of a UDF for ARMC the field will only be populated
	// when their UDFARMCRBAppointment1.MAC is set up on the OnNew
	obj=document.getElementById('ARMCApptMessage');
	if (obj) {
		var message=obj.value
		var lu = message.split("|");
		if ((message!="")&&(message!="1")) {
			var totalmessage="This Patient has the following PreAdmission Appointments within the last 60 days: " + "\n "
			for (var i=0;i<lu.length;i++) {
				totalmessage+=lu[i]+"\n";
				//alert(lu[i]);
			}

			alert(totalmessage);
		}
	}

	// ab 29.05.02 - choose which date of surgery to display
	obj=document.getElementById('DateSurgery');
	if (obj)
	{
	var objDSWL=document.getElementById('WLOperDate');
	var objDSWLAdm=document.getElementById('WLAdmOperDate');

	//if ((objDSWL)&&(objDSWL.value!="")) obj.innerText=objDSWL.value;
	if ((objDSWLAdm)&&(objDSWLAdm.value!="")) obj.innerText=objDSWLAdm.value;

    	}

	//SB: The onchange even was overwriting generic date functions. Moved this function to the Find Click handler.
	//obj=document.getElementById('Date');
	//if (obj) obj.onchange= CheckDateAgainstAdm;

	//Log 30886 BC 9-12-2002
	setAllTimes()
	var STobj=document.getElementById('SameTime');
	if (STobj) STobj.onclick=setSameTimes
	var CTobj=document.getElementById('ConsecutiveTimes');
	if (CTobj) CTobj.onclick=setConsecutiveTimes
	var CTRobj=document.getElementById('ConsecTimesRes');
	if (CTRobj) CTRobj.onclick=setConsecTimesRes
	var ATobj=document.getElementById('AllTimes');
	if (ATobj) ATobj.onclick=setAllTimes

	//TN: need to send up to parent main frame upon update
	//TN: nasty check for popup appt frame
	/*if (window.top.name == "frmAppointmentFrame") {
		document.forms['fRBAppointment_Find'].elements['TFRAME'].value='frmAppointmentFrame';
	} else {
		document.forms['fRBAppointment_Find'].elements['TFRAME'].value=window.parent.name;
	}*/
	if ((window.top.frames['eprmenu'])||(window.top.frames['TRAK_menu'])) {
		document.forms['fRBAppointment_Find'].elements['TFRAME'].value=window.parent.name;
		//alert("window.parent.name; "+window.parent.name)
	} else {
		document.forms['fRBAppointment_Find'].elements['TFRAME'].value=window.top.name;
		//alert("window.top.name: "+window.top.name)
	}
	obj=document.getElementById('AddToWL');
	if (obj) obj.onclick=WLPassValue;

	//log61362 TEdT
	obj=document.getElementById('groupNumExist');
	if(obj) GroupNumberLink(obj.value);

	obj=document.getElementById('DiaryMode');
	if (obj) obj.onclick= DiaryModeClickHandler;
	DiaryModeClickHandler();

	var ret=tkMakeServerCall("web.RBApptSchedule","KillSessVars")
}

//RC Log 60263
function GroupNumberLookupHandler(str) {
	var strArr=str.split("^");
	var grpid=document.getElementById("GRPRowID");
	if (grpid) grpid.value=strArr[1];
	var grp=document.getElementById("RBApptGroup");
	if (grp) grp.value=strArr[0];
	//log 61362 TedT
	if(strArr[1]=="EXIST") {
		alert(t['GROUP_EXIST']);
		if (grp) grp.value="";
	}
}

function GroupOnBlur() {
	if(this.value=="") {
		var grpid=document.getElementById("GRPRowID");
		if (grpid) grpid.value="";
	}
}

function EpGrpNoOnBlur() {
	if(this.value=="") {
		var obj=document.getElementById('EpGrpLocId');
		if (obj) obj.value="";
		var obj=document.getElementById('RBApptGroup');
		if (obj) obj.className="";
		var obj=document.getElementById('cRBApptGroup');
		if (obj) obj.className="";
	}
}

function EpGrpNoClickHandler() {
	var epid=document.getElementById("EpisodeID");
	var patid=document.getElementById("PatientID");
	if ((epid)&&(patid)) {
		var lnk="paadm2groupnumber.csp?CONTEXT="+session["CONTEXT"]+"&EpisodeID="+epid.value+"&PatientID="+patid.value+"&PARREF="+epid.value+"&ID="
		websys_createWindow(lnk,"GroupNumber","top=0,left=0,width=780,height=540,resizable=yes,scrollbars=yes")
	}
	return false;

}


function SetCheckBox() {
	//Log 31104 RC 22/01/03
	var trans=document.getElementById("TransReq");
	var inter=document.getElementById("IntReq");
	var transport=document.getElementById("Transport");
	var translup=document.getElementById("ld570iTransport");
	var interpreter=document.getElementById("Interpreter");
	var interlup=document.getElementById("ld570iInterpreter");

	if (trans && transport && translup) {
		if (trans.checked==true) {
			trans.value="on";
			transport.disabled=false;
			translup.disabled=false;
			transport.className="";
		}
		if (trans.checked==false) {
			trans.value="";
			transport.disabled=true;
			translup.disabled=true;
			transport.value="";
			transport.className="disabledField";
		}
	}
	if (inter && interpreter && interlup) {
		if (inter.checked==true) {
			inter.value="on";
			interpreter.disabled=false;
			interlup.disabled=false;
			interpreter.className="";
		}
		if (inter.checked==false) {
			inter.value="";
			interpreter.disabled=true;
			interlup.disabled=true;
			interpreter.value="";
			interpreter.className="disabledField";
		}
	}
}

function DocumentUnloadHandler() {
	var BulkApptList=""
	var obj = document.getElementById('BulkApptList');
	if (obj) BulkApptList=obj.value;
	var trans = document.getElementById('TransAppt');
	if (trans) TransAppt=trans.value;
	var objpop = document.getElementById('PopUp');
	if (objpop) PopUp=objpop.value;

	if ((TransAppt!="") || (PopUp=="1")) {
		if (BulkApptList=="") {
			// SB 09/01/02: The following reload needs to be used so that the workload list refreshes cleanly
			// SB 19/04/02: Do not change the following line of code without asking me first.
			// SB 01/05/02: Modified.
			//alert('BulkApptList==""');
			if (top.window.opener.top.frames["TRAK_main"]) {
				//alert('top.window.opener.top.frames["TRAK_main"]');
				//SP//top.window.opener.top.frames["TRAK_main"].treload('websys.csp')
			} else {
				//alert('window.opener');
				//SP//if (window.opener) window.opener.treload('websys.csp')
			}
			top.location="websys.close.csp"
		} else {
			//alert('BulkApptList!=""');
			top.location="rbappointmentframe.popup.csp?BulkApptList="+BulkApptList;
		}
	}
	if (PopUp=="2") {
		if (BulkApptList=="") {
			// RC 16/01/03 This extra popup is needed for the booking of appointments from
			// the multireferral screen. It works the same way as above.
			if (top.window.opener.top.frames["TRAK_main"]) {
				top.window.opener.top.frames["TRAK_main"].treload('websys.csp')
			} else {
				if (window.opener) window.opener.treload('websys.csp')
			}
			top.location="websys.reload.csp"
		} else {
			top.location="rbappointmentframe.popup3.csp?BulkApptList="+BulkApptList;
		}
	}
}

function InitDefaults() {
	//GR log 52559
	if (disableform()==1) return;
	var objAdmType=document.getElementById("AdmsnType");
	var objWaitID=document.getElementById("WaitingListID");
	var objVisitStat=document.getElementById("VisitStatus");
	var objDate=document.getElementById("Date");
	var objFUFlag=document.getElementById("FUFlag");
	var objRecall=document.getElementById("RecallSchedID");
	var inter=""; var trans="";
	if (document.getElementById('Interpreter')) var inter=document.getElementById('Interpreter').value;
	if (document.getElementById('Transport')) var trans=document.getElementById('Transport').value;
	if (document.getElementById('IntReq')) var intreq=document.getElementById('IntReq').checked;
	if (document.getElementById('TransReq')) var transreq=document.getElementById('TransReq').checked;
	//try {AdjustHospitalList()} catch(e) {}
	//RC 55156 04/11/05 If hidden hosp string is blank and the hosp field is display only, then check the text against the
	//hidden logonhosp details and if they match, then use that ID, otherwise do nothing. If the hosp isn't display only,
	//then the broker will fire from that field and the hospdescstring will get updated in the js function, so this'll be moot.
	if ((document.getElementById('HOSPDescString').value=="")&&((document.getElementById('HOSPDesc'))&&(document.getElementById('HOSPDesc').innerHTML!=""))) {
		if (document.getElementById('HOSPDesc').innerHTML==mPiece(document.getElementById('LogonHospDescID').value,"^",0)) {
			document.getElementById('HOSPDescString').value=mPiece(document.getElementById('LogonHospDescID').value,"^",1)
		}
	}
	ClosestHospitalToPatient(); //LOG 41346 RC 4/3/04

	var obj=document.getElementById('bestplan')
	if (obj) {
		obj.disabled=true
		obj.onclick="";
	}
	var obj=document.getElementById('skipbulktrans')
	if (obj) {
		if (document.getElementById('BulkApptList').value=="") {
			obj.disabled=true
			obj.onclick="";
		}
	}

	if (document.getElementById('HCARowId')) var HCAID=document.getElementById('HCARowId').value;
	if (document.getElementById('HOSPEntered')) var HospIDs=document.getElementById('HOSPDescString').value;
	//alert("Date="+Date);
	var objTDate=document.getElementById("TodayHtmlDate");
	var TDIRTY=document.getElementById("TDIRTY");
	//SB Log 24297: See function CheckDateAgainstAdm
	if ((objAdmType.value=="I")&&(objVisitStat.value=="P")&&(objWaitID.value!="")&&(objRecall.value=="")) {
		if (objDate) objDate.value=objTDate.value
	}
	;
 	//alert(document.getElementById("autofind").value)
	//KM: Log 27340 see me Ben!!!
	var LinkedAppts=""
	var obj=document.getElementById("LinkedAppts")
	if (obj) LinkedAppts=obj.value
	var RecallSchedID=""
	var obj=document.getElementById("RecallSchedID")
	if (obj) RecallSchedID=obj.value
	var lnk = "rbdefaultfields.csp?EpisodeID="+document.getElementById("EpisodeID").value+"&PatientID="+document.getElementById("PatientID").value+"&TransAppt="+document.getElementById("TransAppt").value+"&WaitListID="+document.getElementById("WaitingListID").value+"&oeoriID="+document.getElementById("oeoriID").value+"&compref="+document.getElementById("TEVENT").value+"&autofind="+document.getElementById("autofind").value+"&FollowUpApptID="+document.getElementById("FollowUpApptID").value+"&LinkedAppts="+LinkedAppts+"&Interpreter="+inter+"&Transport="+trans+"&IntReq="+intreq+"&TransReq="+transreq+"&TDIRTY="+TDIRTY.value+"&FUFlag="+objFUFlag.value+"&HCAID="+HCAID+"&HospIDs="+HospIDs+"&DefaultLocFlag="+document.getElementById("DefaultLocFlag").value+"&ServListRows="+document.getElementById("ServListRows").value+"&ApptDate="+document.getElementById("ApptDate").value+"&CPWRowId="+document.getElementById("CPWRowId").value+"&RecallSchedID="+document.getElementById("RecallSchedID").value;
	//top.frames["TRAK_hidden"].location=lnk;
	websys_createWindow(lnk,"TRAK_hidden");


}

function ClosestHospitalToPatient() {
	//LOG 41346 RC 4/3/04 Add Closest Hospital to Patient into hospital list if it exists.
	//RC 26/05/05 Moved it to the InitDefaults because it just seemed wrong not having it in there.
	var hobj=document.getElementById("HOSPEntered");
	var chtpobj=document.getElementById("PHospDesc");
	/*var hosp=document.getElementById("HOSPDesc");
	var hospid=document.getElementById("HOSPDescString");*/
	if ((hobj)&&(chtpobj)) {  //&&(hosp)&&(hospid)) {
		/*if (hosp.value!="") {
			AddItemToList(hobj,hospid.value,hosp.value);
			AddHospIDToList(hospid.value);
		}*/
		//54005 Don't add in the hospital if it is already there.s
		if (chtpobj.value!="") {
			if (document.getElementById("HOSPDescString").value!="") {
				var hospids=document.getElementById("HOSPDescString").value
				if (hospids.indexOf(mPiece(chtpobj.value,"^",0))== -1) {
					AddItemToList(hobj,mPiece(chtpobj.value,"^",0),mPiece(chtpobj.value,"^",1));
					AddHospIDToList(mPiece(chtpobj.value,"^",0));
				}
			} else {
				AddItemToList(hobj,mPiece(chtpobj.value,"^",0),mPiece(chtpobj.value,"^",1));
				AddHospIDToList(mPiece(chtpobj.value,"^",0));
			}

		}
	}
}


function CheckBeforeUpdate(e) {
	//alert("CheckBeforeUpdate");

	var Servdoc=parent.frames["RBServList"].document;
	var Servf=Servdoc.getElementById("fRBAppointment_ServiceList");
	var ServList=Servdoc.getElementById("tRBAppointment_ServiceList");
	var addServList=Servdoc.getElementById("tRBAppointment_AdditionalServiceList");
	var TDIRTY=document.getElementById("TDIRTY");

	checkAllBoxes(Servf,ServList,"servListz")
	ServChk=checkedCheckBoxes(Servf,ServList,"servListz");
	var str=""; var sched="";
	var overbook=""
	for (var i=0;i<ServChk.length;i++) {
		var sched=Servdoc.getElementById("schedlistz"+ServChk[i]).value+"z"
		var addschedlist=Servdoc.getElementById("addStrz"+ServChk[i]).value.split("@")
		for (var ii=0;ii<addschedlist.length;ii++) {
			var addsched=addschedlist[ii].split("*");
			if (addsched[0]=="") break;
			sched=sched+addsched[0]+"z"
		}
		str=str+Servdoc.getElementById("datez"+ServChk[i]).innerText+"*"+Servdoc.getElementById("timez"+ServChk[i]).innerText+"*"+sched+"*"+Servdoc.getElementById("serIdz"+ServChk[i]).value+"*"+Servdoc.getElementById("urgentIDz"+ServChk[i]).value+"*"+Servdoc.getElementById("locIdz"+ServChk[i]).value+"*"+Servdoc.getElementById("payIdz"+ServChk[i]).value+"*"+Servdoc.getElementById("planIdz"+ServChk[i]).value+"^";
		if (Servdoc.getElementById("schedlistz"+ServChk[i]).value=="") {
			overbook=overbook + Servdoc.getElementById("datez"+ServChk[i]).innerText + "|" + Servdoc.getElementById("timez"+ServChk[i]).innerText + "|" + Servdoc.getElementById("resIdz"+ServChk[i]).value + "|" + Servdoc.getElementById("locIdz"+ServChk[i]).value + "|" + Servdoc.getElementById("serIdz"+ServChk[i]).value + "|" + Servdoc.getElementById("payIdz"+ServChk[i]).value + "|" + Servdoc.getElementById("planIdz"+ServChk[i]).value+"^";
			//alert(overbook)
		}
		//Log 31104 RC 22/01/03
		var dt=Servdoc.getElementById("datez"+ServChk[i]).innerHTML;
		if (dt && dt=="&nbsp;") dt="";
		if (Servdoc.getElementById("Interpreterz"+ServChk[i])) var inter=Servdoc.getElementById("Interpreterz"+ServChk[i]).innerHTML;
		if (inter && inter=="&nbsp;") inter=="";
		if (Servdoc.getElementById("Transportz"+ServChk[i])) var trans=Servdoc.getElementById("Transportz"+ServChk[i]).innerHTML;
		if (trans && trans=="&nbsp;") trans=="";
	}
	// SB 13/10/03 (38970): Errors when removing User/PIN from form
	var PatientID=""; if (document.getElementById("PatientID")) PatientID=document.getElementById("PatientID").value;
	var UserCode=""; if (document.getElementById("UserCode")) UserCode=document.getElementById("UserCode").value;
	var PIN=""; if (document.getElementById("PIN")) PIN=document.getElementById("PIN").value;
	var TransAppt=""; if (document.getElementById("TransAppt")) TransAppt=document.getElementById("TransAppt").value;
	var EpisodeID=""; if (document.getElementById("EpisodeID")) EpisodeID=document.getElementById("EpisodeID").value;
	var WaitListID=""; if(document.getElementById("WaitingListID")) WaitListID=document.getElementById("WaitingListID").value;
	var authoriseUser=""; if (document.getElementById("authoriseUser")) authoriseUser=document.getElementById("authoriseUser").value; //log 63705
	var authorisePIN=""; if (document.getElementById("authorisePIN")) authorisePIN=document.getElementById("authorisePIN").value; //log 63705
	var APPTReasonForTransferDR="" ; if (document.getElementById("APPTReasonForTransferDR")) APPTReasonForTransferDR=document.getElementById("APPTReasonForTransferDR").value; //log 64262
	var lnk = "rbappointment.checkbeforeupdate.csp?PatientID="+PatientID+"&Str="+str+"&Overbook="+overbook+"&UserCode="+UserCode+"&PIN="+PIN+"&TransAppt="+TransAppt+"&EpisodeID="+EpisodeID+"&WaitListID="+WaitListID+"&Date="+dt+"&Transport="+trans+"&Interpreter="+inter+"&TDIRTY="+TDIRTY.value+"&authoriseUser="+authoriseUser+"&authorisePIN="+authorisePIN+"&APPTReasonForTransferDR="+APPTReasonForTransferDR;
	//alert("rbappointment.checkbeforeupdate.csp?PatientID="+document.getElementById("PatientID").value+"&Str="+str+"&Overbook="+overbook+"&UserCode="+document.getElementById("UserCode").value+"&PIN="+document.getElementById("PIN").value+"&TransAppt="+document.getElementById("TransAppt").value+"&EpisodeID="+document.getElementById("EpisodeID").value+"&WaitListID="+document.getElementById("WaitingListID").value+"&Date="+dt+"&Transport="+trans+"&Interpreter="+inter+"&TDIRTY="+TDIRTY.value);
	//ez 3/03/08 next line added for log 66294: Update on appt search without selecting slot produces app error 
	if (dt=="") {alert("nothing selected"); return false;}
	//alert (lnk);
	//return false;
	//top.frames["TRAK_hidden"].location=lnk;
	websys_createWindow(lnk,"TRAK_hidden");
}

function UpdateClickHandler(e) {
	//alert("updateclick handler");
	var obj=document.getElementById("Update")
	if (!obj.disabled) {
		var Apptdoc=parent.frames["RBApptList"].document;
		var Apptf=Apptdoc.getElementById("fRBAppointment_ApptList");
		var ApptList=Apptdoc.getElementById("tRBAppointment_ApptList");

		var Servdoc=parent.frames["RBServList"].document;
		var Servf=Servdoc.getElementById("fRBAppointment_ServiceList");
		var ServList=Servdoc.getElementById("tRBAppointment_ServiceList");
		var addServList=Servdoc.getElementById("tRBAppointment_AdditionalServiceList");

		var ServiceIDs=document.getElementById("ServiceIDs");
		var SSServiceIDs=document.getElementById("SSServiceIDs");
		var LocationIDs=document.getElementById("LocationIDs");
		var ScheduleIDs=document.getElementById("ScheduleIDs");
		var Comments=document.getElementById("Comments");
		var OBReason=document.getElementById("OBReason");
		var Main=document.getElementById("Main");
		var OverDuration=document.getElementById("OverDuration");
		var Urgent=document.getElementById("Urgent");
		var AdmDoc=document.getElementById("AdmDocId");
		var ApptMethod=document.getElementById("ApptMethodIDs")
		var ApptLanguage=document.getElementById("ApptLanguageIDs")
		var ConsCateg=document.getElementById("ConsultCategIDs")
		var Inter=document.getElementById("Interpreters");
		var Trans=document.getElementById("Transports");
		var PayPlanIDs=document.getElementById("PayPlanIDs");
		var PatientNos=document.getElementById("PatientNos");
		var ORICred=document.getElementById("OEORIItemGroup");
		//var InsParams=document.getElementById("InsParams");
		ApptChk=checkedCheckBoxes(Apptf,ApptList,"chkz");
		checkAllBoxes(Servf,ServList,"servListz")
		ServChk=checkedCheckBoxes(Servf,ServList,"servListz");
		ServiceIDs.value="";
		ScheduleIDs.value="";
		SSServiceIDs.value="";
		PatientNos.value="";
		Comments.value="";
		OBReason.value="";
		Main.value="";
		OverDuration.value="";
		Urgent.value="";
		if (ORICred) ORICred.value="";
		msg="";
		msg2="";
		//InsParams.value="";
		LatestApptDate="";
		if (ApptMethod) ApptMethod.value="";
		if (ApptLanguage) ApptLanguage.value="";
		if (ConsCateg) ConsCateg.value="";
		if (Inter) Inter.value="";
		if (Trans) Trans.value="";
		if (PayPlanIDs) PayPlanIDs.value="";

		if (ServList.rows.length==1 || ServChk.length==0) {
			alert(t['RBNoApptSelected']);
			return 0;
		}
		//alert("ServChk:"+ServChk.length)
		for (var i=0;i<ServChk.length;i++) {
			serString=Servdoc.getElementById("schedlistz"+ServChk[i]).value+"z";
			var addschedlist=Servdoc.getElementById("addStrz"+ServChk[i]).value.split("@")
			for (var ii=0;ii<addschedlist.length;ii++) {
				var addsched=addschedlist[ii].split("*");
				if (addsched[0]=="") break;
				serString=serString+addsched[0]+"z"
			}
			//alert(serString)
			serAry=serString.split("z");
			//serAry=serString.split("^");
			//alert("serAry: "+serAry.length)
			for (var n=1;n<serAry.length;n++) {
			//EZ 22/01/2007 Changed '<=' to '<' to fix duplicate appointents issue (LOG 62248)
				//alert(serAry[n-1])
				ServiceIDs.value=ServiceIDs.value+mPiece(Servdoc.getElementById("seridz"+ServChk[i]).value,"|",0)+"^";
				Main.value=Main.value+mPiece(Servdoc.getElementById("seridz"+ServChk[i]).value,"|",1)+"^";
				var sssId=mPiece(Servdoc.getElementById("seridz"+ServChk[i]).value,"|",4);
				if (debug=="Y") //alert(sssId);
				//if (sssId=="undefined") var sssId="";
				SSServiceIDs.value=SSServiceIDs.value+sssId+"^";
				//SB: The following line must be called on every loop for overbookings to work.
				ScheduleIDs.value=ScheduleIDs.value+serAry[n-1]+"^"; //if (serAry[n-1]!="") SB: THIS CODE BREAKS OVERBOOKINGS DO NOT REINSTATE IT WITHOUT TESTING THAT OVERBOOKINGS WORK!!!
				LocationIDs.value=LocationIDs.value+Servdoc.getElementById("locIdz"+ServChk[i]).value+"^"
				Comments.value=Comments.value+Servdoc.getElementById("commentz"+ServChk[i]).value+"^";
				OverDuration.value=OverDuration.value+Servdoc.getElementById("OverDurationz"+ServChk[i]).value+"^";
				if (Servdoc.getElementById("RegistrationNoz"+ServChk[i])) {
					if (Servdoc.getElementById("RegistrationNoz"+ServChk[i]).innerHTML=='&nbsp;') Servdoc.getElementById("RegistrationNoz"+ServChk[i]).innerHTML="";
					PatientNos.value=PatientNos.value+Servdoc.getElementById("RegistrationNoz"+ServChk[i]).innerHTML+"^"
					//alert("i="+i+",n=" + n + ","+PatientNos.value)
				}
				try {CheckTransportTickbox(ServChk[i])} catch(e) {}
				if (Servdoc.getElementById("Transportz"+ServChk[i])) Trans.value=Trans.value+Servdoc.getElementById("Transportz"+ServChk[i]).innerHTML+",";
				if (Servdoc.getElementById("TransReqz"+ServChk[i])) Trans.value=Trans.value+Servdoc.getElementById("TransReqz"+ServChk[i]).value+"|";
				try {CheckInterpreterTickbox(ServChk[i])} catch(e) {}
				if (Servdoc.getElementById("Interpreterz"+ServChk[i])) Inter.value=Inter.value+Servdoc.getElementById("Interpreterz"+ServChk[i]).innerHTML+",";
				if (Servdoc.getElementById("IntReqz"+ServChk[i])) Inter.value=Inter.value+Servdoc.getElementById("IntReqz"+ServChk[i]).value+"|";
				if (Servdoc.getElementById("ApptMethodz"+ServChk[i])) ApptMethod.value=ApptMethod.value+Servdoc.getElementById("ApptMethodz"+ServChk[i]).innerHTML+"^";
				if (Servdoc.getElementById("ApptLanguagez"+ServChk[i])) ApptLanguage.value=ApptLanguage.value+Servdoc.getElementById("ApptLanguagez"+ServChk[i]).value+"^";
				//if (Servdoc.getElementById("ApptLanguagez"+ServChk[i])) ApptLanguage.value=ApptLanguage.value+Servdoc.getElementById("ApptLanguagez"+ServChk[i]).innerHTML+"^";
				if (Servdoc.getElementById("ConsultCategz"+ServChk[i])) ConsCateg.value=ConsCateg.value+Servdoc.getElementById("ConsultCategz"+ServChk[i]).value+"^";
				if ((ORICred)&&(Servdoc.getElementById("OEORIItemGroupz"+ServChk[i]))) ORICred.value=ORICred.value+Servdoc.getElementById("OEORIItemGroupz"+ServChk[i]).innerHTML+"^";
				Urgent.value=Urgent.value+Servdoc.getElementById("urgentIDz"+ServChk[i]).value+"^";
				cdate=Servdoc.getElementById("datez"+ServChk[i]).innerText;
				//alert("line 217");
				cdate=SplitDateStr(cdate)
				var cdt = new Date(cdate["yr"], cdate["mn"]-1, cdate["dy"]);
				if (cdt > LatestApptDate) {
					LatestApptDate=cdt
				}
			}
			if (Servdoc.getElementById("payIdz"+ServChk[i])) PayPlanIDs.value=PayPlanIDs.value+Servdoc.getElementById("payIdz"+ServChk[i]).value+"|";
			if (Servdoc.getElementById("planIdz"+ServChk[i])) PayPlanIDs.value=PayPlanIDs.value+Servdoc.getElementById("planIdz"+ServChk[i]).value+"^";
			var Duration=""
			if (Servdoc.getElementById("Durationz"+ServChk[i])) Duration=Servdoc.getElementById("Durationz"+ServChk[i]).innerHTML
			//alert(i+":"+Servdoc.getElementById("Durationz"+ServChk[i]).value + ", " + Servdoc.getElementById("datez"+ServChk[i]).innerText);
			if (Servdoc.getElementById("obreasonz"+ServChk[i]).value!="") {
				OBReason.value=OBReason.value+Servdoc.getElementById("locIdz"+ServChk[i]).value+"|"+Servdoc.getElementById("resIdz"+ServChk[i]).value+"|"+Servdoc.getElementById("datez"+ServChk[i]).innerText+"|"+Servdoc.getElementById("timez"+ServChk[i]).innerText+"|"+Servdoc.getElementById("obreasonz"+ServChk[i]).value+"|"+Duration+"|"+Servdoc.getElementById("urgentIDz"+ServChk[i]).value+"|"+Servdoc.getElementById("sessionidz"+ServChk[i]).value+"^";
			}
			// This is a fix for Overbookings - because no schedID is saved we need to add some "^"'s so that
			// the data remains consistant.
			if (serAry.length==1) {
				ServiceIDs.value=ServiceIDs.value+mPiece(Servdoc.getElementById("seridz"+ServChk[i]).value,"|",0)+"^";
				ScheduleIDs.value=ScheduleIDs.value+"^";
				Comments.value=Comments.value+Servdoc.getElementById("commentz"+ServChk[i]).value+"^";
				Urgent.value=Urgent.value+Servdoc.getElementById("urgentIDz"+ServChk[i]).value+"^";
				try {CheckTransportTickbox(ServChk[i])} catch(e) {}
				if (Servdoc.getElementById("Transportz"+ServChk[i])) Trans.value=Trans.value+Servdoc.getElementById("Transportz"+ServChk[i]).innerHTML+",";
				if (Servdoc.getElementById("TransReqz"+ServChk[i])) Trans.value=Trans.value+Servdoc.getElementById("TransReqz"+ServChk[i]).value+"|";
				try {CheckInterpreterTickbox(ServChk[i])} catch(e) {}
				if (Servdoc.getElementById("Interpreterz"+ServChk[i])) Inter.value=Inter.value+Servdoc.getElementById("Interpreterz"+ServChk[i]).innerHTML+",";
				if (Servdoc.getElementById("IntReqz"+ServChk[i])) Inter.value=Inter.value+Servdoc.getElementById("IntReqz"+ServChk[i]).value+"|";
				if (Servdoc.getElementById("obreasonz"+ServChk[i]).value=="") {msg=msg+Servdoc.getElementById("serDescz"+ServChk[i]).innerText+","}
			}
		}
		if (msg!="") {
			alert(t['RBInvalidAppt']+msg)
			return 0;
		}
		//SB 8/02/05 (48980): If Interpreter/Transport checkbox is on then check that Interpreter/Transport field is not blank
		if (msg2!="") {
			alert(msg2)
			return 0;
		}

		//var frm = document.forms["fRBAppointment_Find"];
		//frm.target = "_parent"

		//if (debug=="Y") {
		//alert(ServiceIDs.value+","+ScheduleIDs.value+","+SSServiceIDs.value+","+PatientNos.value+","+LocationIDs.value+","+Comments.value+","+OBReason.value+","+Main.value+","+OverDuration.value+","+Urgent.value);
		/*alert(ScheduleIDs.value);
		alert(SSServiceIDs.value);
		alert(PatientNos.value);
		alert(LocationIDs.value);
		alert(Comments.value);
		alert(OBReason.value);
		alert(Main.value);
		alert(OverDuration.value);
		alert("urg="+Urgent.value);
		}*/
		var todayDate=document.getElementById("todayDate").value;
		var RefDate=document.getElementById("PAADMRefExpiryDate").value;
		var ExtRefDate=mPiece(RefDate,"^",1)
		RefDate=mPiece(RefDate,"^",0)
		var EpisodeId=document.getElementById("EpisodeID");

		if (RefDate!="") {
			//alert("line 258");
		   RefDate=SplitDateStr(RefDate);
		   var refdt = new Date(RefDate["yr"], RefDate["mn"]-1, RefDate["dy"]);
		   if (refdt < LatestApptDate) {
		   // SB 25/09/03 (33885): Check Code Tables | System Management | System Parameters | Booking 'ExtendReferralPeriod'
			if (ExtRefDate!="Y") {
				EpisodeId.value="";
				// SB 29/11/02 (30832): Do not comment this line out, The "T" flag tells CRBAppointment1 to copy the Payor/Plan details over to the new episode.
				AdmDoc.value=AdmDoc.value+"^T"
				alert(t['RBReferral']);
			} else {
				var conf=confirm(t['RBReferralContinue']);
				if (!conf) return;
			}
		   }
		}
		//alert("Before Click")
		//return false;
		var ret=tkMakeServerCall("web.RBApptSchedule","KillSessVars")
		return Update_click();
	}
}

function HCALookUp(str) {
	var lu = str.split("^");

	var obj=document.getElementById("HCA");
	if (obj) obj.value=lu[0]

	var obj=document.getElementById("HCARowId");
	if (obj) {
		testvalue1=obj.value
		testvalue2=lu[1]
		obj.value=lu[1]
	}
	//alert(obj.value);
	//alert("HCALookUp");
	if (testvalue1!=testvalue2) {
		ClearHospitalList();
		ClearLocAndResAndServ();
	}
}

function checkedCheckBoxes(f,tbl,col) {
	var aryfound=new Array;found=0;
	for (var i=1;i<tbl.rows.length;i++) {
		if (f.elements[col+i]) {
			if (f.elements[col+i].checked && !f.elements[col+i].disabled) {
				aryfound[found]=i;found++;
			}
		}
	}
	return aryfound;
}

function checkAllBoxes(f,tbl,col) {
	for (var i=1;i<tbl.rows.length;i++) {
		if (f.elements[col+i]) {
			if (f.elements[col+i].checked==false && !f.elements[col+i].disabled) {
				f.elements[col+i].checked=true
			}
		}
	}
}

function ClearClickHandler(e) {
	//Clear All Text Fields
	var objSer=document.getElementById("SERDesc");
	var objLoc=document.getElementById("CTLOCDesc");
	var objRes=document.getElementById("ResDesc");
	var objPay=document.getElementById("InsurPayor");
	var objPlan=document.getElementById("InsurPlan");
	var objSerId=document.getElementById("servId");
	var objLocId=document.getElementById("LocId");
	var objResId=document.getElementById("ResId");
	var objPayId=document.getElementById("PayId");
	var objPlanId=document.getElementById("PlanId");
	var objTrans=document.getElementById("Transport");
	var objInter=document.getElementById("Interpreter");
	var objTraR=document.getElementById("TransReq");
	var objIntR=document.getElementById("IntReq");

	if (objSer) objSer.value="";
	if (objLoc) objLoc.value="";
	if (objRes) objRes.value="";
	if (objPay) objPay.value="";
	if (objPlan) objPlan.value="";
	if (objSerId) objSerId.value="";
	if (objLocId) objLocId.value="";
	if (objResId) objResId.value="";
	if (objPayId) objPayId.value="";
	if (objPlanId) objPlanId.value="";
	if (objTrans) objTrans.value="";
	if (objInter) objInter.value="";
	if (objTraR) objTraR.checked=false; objTraR.value="";
	if (objIntR) objIntR.checked=false; objIntR.value="";

	//Clear Service List table
	// Log 35524 12-5-2003 BC properly clear the service list
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=RBAppointment.ServiceList&tblStr=";
	parent.frames["RBServList"].location=lnk;

	//Clear Appointment List Table
	parent.frames["RBApptList"].location="websys.default.csp?WEBSYS.TCOMPONENT=RBAppointment.ApptList&TWKFL=&TWKFLI=";
}


function AddClickHandler(e) {
	//alert("AddClickHandler");
	//BR 53272 23/06/05 Removed as this was causing the Find not to work on 'Alt F'
	//no longer a problem
	if (evtTimer) {
		setTimeout('AddClickHandler();',200);
		return;
	}
	 //md per log 58200
	if (!ValidatePREUpdate()) return false;
	var objEpID=document.getElementById("EpisodeID");
	var objPtID=document.getElementById("PatientID");
	var objLoc=document.getElementById("CTLOCDesc");
	if (!CheckValidEntry(objLoc)) return false;
	var objRes=document.getElementById("ResDesc");
	if (!CheckValidEntry(objRes)) return false;
	var objSer=document.getElementById("SERDesc");
	if (!CheckValidEntry(objSer)) return false;
	var objLocId=document.getElementById("LocId");
	var objResId=document.getElementById("ResId");
	var objSerId=document.getElementById("ServId");
	var objSS_SerId=document.getElementById("SS_ServId");
	var objSESSDesc=document.getElementById("SESSDesc"); // Log 36469 BC 3/7/2003
	if (!CheckValidEntry(objSESSDesc)) return false;
	var objMsg=document.getElementById("OrderItemMess");
	if (!CheckValidEntry(objMsg)) return false;
	var objTrans=document.getElementById("Transport");	//Log 31104 RC 22/01/03
	if (!CheckValidEntry(objTrans)) return false;
	var objInter=document.getElementById("Interpreter");
	if (!CheckValidEntry(objInter)) return false;
	var objTraR=document.getElementById("TransReq");
	var objIntR=document.getElementById("IntReq");
	var disInt=document.getElementById("disInt").value;
	var disTrans=document.getElementById("disTrans").value;
	var objAPPTRemarks=document.getElementById("APPTRemarks");
	var objHCADesc=document.getElementById("HCA"); // Log 37518 BC 9-9-2003
	if (!CheckValidEntry(objHCADesc)) return false;
	var objHCARowID=document.getElementById("HCARowId"); // Log 37518 BC 9-9-2003
	var objHOSPDesc=document.getElementById("HOSPDesc"); // Log 37518 BC 9-9-2003
	var objHOSPEntered=document.getElementById("HOSPEntered"); // Log 37518 BC 9-9-2003
	var objHOSPDescString=document.getElementById("HOSPDescString"); // Log 37518 BC 9-9-2003
	var objApptMethod=document.getElementById("RBCAppointMethod"); //Log 37256  SB 12/09/03
	if (!CheckValidEntry(objApptMethod)) return false;
	var objApptLanguage=document.getElementById("PACPreferredLanguage"); //Log 38015  BR 27/10/03
	if (!CheckValidEntry(objApptLanguage)) return false;
	var objConsultCateg=document.getElementById("APPTConsultCateg"); //Log  58954 MD 10/05/2006
	if (!CheckValidEntry(objConsultCateg)) return false;
	var objComments=document.getElementById("Comments"); //Log 34387  SB 22/09/03
	var objQLDOutChk=document.getElementById("QLDOutChk");
	var objORICred=document.getElementById("OEORIItemGroup"); //Log 48619  RC 30/03/05
	if (!CheckValidEntry(objORICred)) return false;
	var objOEOrdID=document.getElementById("oeoriID");
	// Log 37518 BC 9-9-2003
	var HCADesc=""; var HCARowID=""; var HOSPDesc=""; var HospIDs="";
	if (objHCADesc) HCADesc=objHCADesc.value;
	if (objHCARowID) HCARowID=objHCARowID.value;
	if (objHOSPDescString) HospIDs=objHOSPDescString.value;
	if (objHOSPDesc) HOSPDesc=objHOSPDesc.value;
	if (objHOSPEntered) {
		for (var i=(objHOSPEntered.length-1); i>=0; i--) {
				if (HOSPDesc!="") {HOSPDesc=HOSPDesc+", "+objHOSPEntered.options[i].text} else {HOSPDesc=objHOSPEntered.options[i].text}
		}
	}
	//BR 30/11/05 56937. When adding service to list which is defaulted from rad booking workflow. If the DefaultLocFlag is set to not default the locaion, we don't
	//want to default the hospital off the default layout either.
	if (document.getElementById("DefaultLocFlag").value==2) {
		HOSPDesc=""
		HospIDs=""
	}
	// End Log 37518 BC 9-9-2003
	var transport=""; var interpreter=""; var transreq=""; var intreq=""; //End Log 31104
 	var el="";
	if (!objSer) {
		//alert(t['RBServiceMandatory']);
		alert("\'" + t['SERDesc'] + "\' " + t['XMISSING']);
		return 0;
	}
	if (objSer.value=="") {
		//alert(t['RBServiceMandatory']);
		alert("\'" + t['SERDesc'] + "\' " + t['XMISSING']);
		return 0;
	}
	var ret=true
	try{
		ret=CheckSameService();
	} catch (error) {}
	if (ret==false) {return false;}
	if (e==1) el=1;
	var loc=""
	var res=""
	var APPTRemarks="";
	var ApptMethod="";
	var ApptLanguage="";
	var ConsultCateg="";
	var ORICred=""; var SerID=""; var EpisodeID=""; var PatientID="";
	if (objEpID) EpisodeID=objEpID.value
	if (objPtID) PatientID=objPtID.value
	if (objLoc) loc=objLoc.value;
	if (objRes) res=objRes.value;
	if (objSS_SerId) SSser=objSS_SerId.value;
	if (objSerId) SerID=objSerId.value
	if (objMsg) objMsg.value="";
	if (objTrans) transport=objTrans.value
	if (objInter) interpreter=objInter.value;
	if (objTraR) transreq=objTraR.value;
	if (objIntR) intreq=objIntR.value;
	if (objAPPTRemarks) APPTRemarks=objAPPTRemarks.value;
	if (APPTRemarks=="") APPTRemarks=objComments.value;
	if (objApptMethod) ApptMethod=objApptMethod.value;
	if (objApptLanguage) ApptLanguage=objApptLanguage.value;
	if (objConsultCateg) ConsultCateg=objConsultCateg.value;
	if (objORICred) ORICred=objORICred.value;
	if (objOEOrdID) OEOrdID=objOEOrdID.value;
	//Log 31104 RC 22/01/03
	if ((transreq=="on") && ((objTrans) && (transport==""))) {
		alert("You must choose a Transport if you have selected the Transport Required checkbox");
		return false;
	}
	if ((intreq=="on") && ((objInter) && (interpreter==""))) {
		alert("You must choose an Interpreter if you have selected the Interpreter Required checkbox");
		return false;
	} //End Log 31104
	var SessType=""; // Log 36469 BC 3/7/2003
	if (objSESSDesc) SessType=objSESSDesc.value; // Log 36469 BC 3/7/2003
	var QLDOutChk="";
	if (objQLDOutChk) QLDOutChk=objQLDOutChk.value;
    // ab 18.05.02 - 25126 - ampersand in location

	var objpay=document.getElementById("PayId");
	var objplan=document.getElementById("PlanId");
	var plan="";
	var pay="";
	if (objpay) pay=objpay.value;
	if (objplan) plan=objplan.value
    if ((loc!="")&&(loc.indexOf("&")!=-1)) loc=loc.replace("&","|||amp|||");
	//var lnk = "rbvalidatedata.csp"+"?doFind=" + el + "&EpisodeID="+ EpisodeID + "&PatientID="+ PatientID + "&CTLOCDesc=" + websys_escape(loc)+ "&RESDesc="+ websys_escape(res) + "&SerID="+ encodeURIComponent(SerID) + "&SS_ServId="+ SSser + "&SessType=" + encodeURIComponent(SessType) + "&Interpreter=" + websys_escape(interpreter) + "&Transport=" + websys_escape(transport) + "&IntReq=" + intreq + "&TransReq=" + transreq + "&disInt=" + disInt + "&disTrans=" + disTrans +"&APPTRemarks="+ encodeURIComponent(APPTRemarks) +"&HCADesc="+ websys_escape(HCADesc) +"&HCARowID="+ HCARowID +"&HOSPDesc="+ websys_escape(HOSPDesc) +"&HospIDs="+ HospIDs +"&ApptMethod="+ websys_escape(ApptMethod) +"&ApptLanguage="+ websys_escape(ApptLanguage) + "&QLDOutChk=" + QLDOutChk + "&ORICred=" + websys_escape(ORICred) + "&payId=" + pay + "&planId=" + plan + "&oeoriID=" + OEOrdID;
	var lnk = "rbvalidatedata.csp"+"?doFind=" + el + "&EpisodeID="+ EpisodeID + "&PatientID="+ PatientID + "&CTLOCDesc=" + websys_escape(loc)+ "&RESDesc="+ websys_escape(res) + "&SerID="+ encodeURIComponent(SerID) + "&SS_ServId="+ SSser + "&SessType=" + encodeURIComponent(SessType) + "&Interpreter=" + websys_escape(interpreter) + "&Transport=" + websys_escape(transport) + "&IntReq=" + intreq + "&TransReq=" + transreq + "&disInt=" + disInt + "&disTrans=" + disTrans +"&APPTRemarks="+ websys_escape(APPTRemarks) +"&HCADesc="+ websys_escape(HCADesc) +"&HCARowID="+ HCARowID +"&HOSPDesc="+ websys_escape(HOSPDesc) +"&HospIDs="+ HospIDs +"&ApptMethod="+ websys_escape(ApptMethod) +"&ApptLanguage="+ websys_escape(ApptLanguage) + "&QLDOutChk=" + QLDOutChk + "&ORICred=" + websys_escape(ORICred) + "&payId=" + pay + "&planId=" + plan + "&oeoriID=" + OEOrdID+"&ConsultCateg="+ websys_escape(ConsultCateg) ;
	//alert(lnk);
	websys_createWindow(lnk,"TRAK_hidden");

}

//SB: No longer used???
/*
function DeleteClickHandler(e) {
	//alert("hello");
	var doc=parent.frames["RBServList"].document;
	var objTbl=doc.getElementById("tRBAppointment_ServiceList");

	var rowLen=objTbl.rows.length;
	var cellLen=objTbl.rows[0].cells.length;
	var str="";

	for (var i=1; i<rowLen; i++) {
		if (!doc.getElementById("servListz" + i).checked && !doc.getElementById("servListz" + i).disabled) {
			for (var j=1; j<cellLen-1; j++) {
				str=str + objTbl.rows[i].cells[j].innerText + "|";
			}
			str=str + doc.getElementById("serIdz" + i).value + "|";
			str=str + doc.getElementById("locIdz" + i).value + "|";
			str=str + doc.getElementById("resIdz" + i).value + "|";
			str=str + doc.getElementById("payIdz" + i).value + "|";
			str=str + doc.getElementById("planIdz" + i).value;
			str=str + "^"
		}
	}
	var lnk = "rbappointment.find.csp"+"?TableStr="+ str;
	parent.frames["RBServList"].location=lnk;
}
*/

function CTLOCDescLookUpSelect(str) {
	var lu = str.split("^");
	//alert(str)
	//var obj=document.getElementById('RESDesc');
	//if (obj) obj.value=lu[1];
	//var obj=document.getElementById('ResId');
	//if (obj) obj.value=lu[3];
	var obj=document.getElementById('CTLOCDesc');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('LocId');
	if (obj) obj.value=lu[1];
	var objResDesc=document.getElementById('RESDesc');
	if ((objResDesc) && (lu[5]!="")) objResDesc.value=lu[5].split("*")[0];
	var obj=document.getElementById('ResId');
	if ((obj) && (lu[5]!="")) obj.value=lu[5].split("*")[1];
	var obj=document.getElementById('SERDesc');
	if ((obj) && (lu[5]!="")) obj.value=lu[5].split("*")[2];
	var obj=document.getElementById('ServId');
	if ((obj) && (lu[5]!="")) obj.value=lu[5].split("*")[3];

	if (objResDesc) objResDesc.onchange()

	// Log 39806 BC 27-10-2003 No longer need as Interpreter and Transport no longer based on Location.  Now based on logon location so no need to clear on change
	// RC 20/01/03 LOG 31104: if either of those fields are 1, then we have to disable the relevant fields so the user
	// can't access them.

	// ab 26.02.04 - commented this out since the below was commented out
	/*
	var objT=document.getElementById("Transport");
	var objI=document.getElementById("Interpreter");
	var objTC=document.getElementById("TransReq");
	var objIC=document.getElementById("IntReq");
	var objDisT=document.getElementById('disTrans');
	var objDisI=document.getElementById('disInt');

	// Log 31104 RC 23/01/03 For some reason, when a resource and a service is added when a
	// location is selected, then there is a ^ missing in the str. This was the easiest way
	// to fix it without changing any code (which may have it missing for a reason).

	if (lu[4]!="" && lu[6]!="") {
		var disTrans=lu[7];
		var disInt=lu[8];
	} else {
		var disTrans=lu[8];
		var disInt=lu[9];
	}
	*/

		/*if (objT && objI && objTC && objIC) {
			if (disTrans==1) {
				objT.disabled=true;
				objT.className="disabledField";
				objTC.disabled=true;
				objT.value=""; objTC.checked=false;
				objDisT.value=1;
			} else {
				objT.disabled=true;
				objT.className="disabledField";
				objTC.disabled=false;
				objT.value=""; objTC.checked=false;
				objDisT.value=0;
			}
			if (disInt==1) {
				objI.disabled=true;
				objI.className="disabledField";
				objIC.disabled=true;
				objI.value=""; objIC.checked=false;
				objDisI.value=1;
			} else {
				objI.disabled=true;
				objI.className="disabledField";
				objIC.disabled=false;
				objI.value=""; objIC.checked=false;
				objDisI.value=0;
			}
		}  //End Log 31104
	*/
}

function EpGrpLocLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('EpGrpLoc');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('EpGrpLocId');
	if (obj) obj.value=lu[1];
	if (lu[0]!="") {
		var obj=document.getElementById('RBApptGroup');
		if (obj) obj.className="clsRequired";
		var obj=document.getElementById('cRBApptGroup');
		if (obj) obj.className="clsRequired";
	}
}

function RESDescLookUpSelect(str) {

	if (debug=="Y") {alert("RESDescLookUpSelect");}
	var lu = str.split("^");
	//alert(str);
	var objres=document.getElementById('RESDesc');
	if (objres) objres.value=lu[0];
	var obj=document.getElementById('ResId');
	if (obj) {
		if (lu[2]=="") {
			if (objres) objres.value=""
			obj.value=""
		} else {
			obj.value=lu[2];
		}
	}
	var obj=document.getElementById('RESCode');
	if (obj) {
		//alert(lu[1]);
		obj.value=lu[1];
	}
	//alert(obj.value)
	var obj=document.getElementById('SERDesc');
	if (obj) {
		obj.value="";
		if (lu[0]!="") obj.value=lu[4];
	}
	var obj=document.getElementById('ServId');
	if (obj) {
		obj.value="";
		if (lu[0]!="") obj.value=lu[3];
	}
	/*
	var obj=document.getElementById('CTLOCDesc');
	if (obj) obj.value=lu[0]
	var obj=document.getElementById('LocId');
	if (obj) obj.value=lu[4]
	var obj=document.getElementById('SERDesc');
	if (obj) obj.value=""
	var obj=document.getElementById('ServId');
	if (obj) obj.value=""
	*/
}


function SERDescLookUpSelect(str) {
	var lu = str.split("^");
	var char4=String.fromCharCode(4)
	var SScheck=""
	//alert("SERDescLookUpSelect: "+str);
	var obj=document.getElementById('SERDesc');
	if (obj) obj.value=lu[1];
	var obj=document.getElementById('OrderItemMess');
	if (obj) obj.value=lu[2];
	// SB 02/04/04 (42622): Param order changed, so we need to redirect the array pieces.
	SScheck=mPiece(lu[3],char4,1)

	//if (lu[4]=="SS") {	//Log 42622
	if (SScheck=="SS") {
		var obj=document.getElementById('SS_ServId');
		if (obj) obj.value=mPiece(lu[3],char4,0)
		//if (obj) obj.value=lu[3]; 		//Log 42622
	} else {
		var obj=document.getElementById('ServId');
		if (obj) obj.value=lu[3];
		// LOG 40311 BC 4-12-2003 service set error on find
		var obj=document.getElementById('SS_ServId');
		if (obj) obj.value="";
	}
	var obj=document.getElementById('ServiceGrpParams');
	if (obj) obj.value=lu[10];
}

function IntLookUpSelect(str) {
	//var lu = str.split("^");
	//alert(str);
	//var obj=document.getElementById('Interpreter');
	//var objchk=document.getElementById('IntReq');
	//if (obj) {
	//	obj.value=lu[0];
		//objchk.checked=true;
	//}
}

function TransLookUpSelect(str) {
	//var lu = str.split("^");
	//alert(str);
	//var obj=document.getElementById('Transport');
	//if (obj) obj.value=lu[0];
}

function InsurPayorLookUpSelect(str) {
	var lu = str.split("^");
	//alert(str);
	var obj=document.getElementById('PayId');
	if (obj) obj.value=lu[1];
}

function InsurPlanLookUpSelect(str) {
	var lu = str.split("^");
	//alert(str);
	var obj=document.getElementById('PlanId');
	if (obj) obj.value=lu[2];
	var obj=document.getElementById('InsurPayor');
	if (obj) obj.value=lu[1];
	var obj=document.getElementById('PayId');
	if (obj) obj.value=lu[3];
}


function ReviewPeriodLookUp(str) {
	var lu = str.split("^");
	ref=document.getElementById("RevPeriod");
	if (ref) ref.value = lu[2];
}

//SB 25/07/02: Because the TextChangeHandlers are now called from the broker, they are no longer triggered when the field is blank
//		The onBlur now handles clearing out of RowIds.
function LocTextBlurHandler(e) {
	var eSrc=websys_getSrcElement(e)
	if (eSrc && eSrc.value=="") {
		var obj=document.getElementById('LocId');
		if (obj) obj.value=""
	}
}

function ResTextBlurHandler(e) {
	var eSrc=websys_getSrcElement(e)
	if (eSrc && eSrc.value=="") {
		var ResID="";
		var obj=document.getElementById('ResId');
		if (obj) {
			ResID=obj.value;
			obj.value="";
		}
		var obj=document.getElementById('RESCode');
		if (obj) obj.value=""
		//BR 57050 When you tab out of resource after changing nothing is clearing service.
		if (ResID!="") {
			var obj=document.getElementById('SERDesc');
			if (obj) obj.value=""
			var obj=document.getElementById('ServId');
			if (obj) obj.value=""
		}
	}
}

function SerTextBlurHandler(e) {
	var eSrc=websys_getSrcElement(e)
	if (eSrc && eSrc.value=="") {
		var obj=document.getElementById('ServId');
		if (obj) obj.value=""
		// LOG 40311 BC 4-12-2003 service set error on find
		var obj=document.getElementById('SS_ServId');
		if (obj) obj.value=""
	}
}

function IntTextBlurHandler(e) {
	var eSrc=websys_getSrcElement(e)
	if (eSrc && eSrc.value=="") {
		var obj=document.getElementById('Interpreter');
		if (obj) obj.value=""
	}

}

function TransTextBlurHandler(e) {
	var eSrc=websys_getSrcElement(e)
	if (eSrc && eSrc.value=="") {
		var obj=document.getElementById('Transport');
		if (obj) obj.value=""
	}
}

function LocationTextChangeHandler() {
	//SB 12/06/02: This function is called from CTLoc.LookUpBrokerLoc, as the onchange handler overwrites the broker method.
	var obj=document.getElementById('CTLOCDesc')
	var res=document.getElementById('RESDesc')
	var ser=document.getElementById('SERDesc')
	if ((obj) && (res) && (ser)) {
		//res.value=""
		//ser.value=""
		//var obj=document.getElementById('LocId');
		//if (obj) obj.value=""
		//var obj=document.getElementById('ResId');
		//if (obj) obj.value="";
		//var obj=document.getElementById('ServId');
		//if (obj) obj.value=""
	}
	//obj.style.color = "black";
}

function ResourceTextChangeHandler() {
	//SB 12/06/02: This function is called from RBResource.LookUpBrokerRes, as the onchange handler overwrites the broker method.
	var obj=document.getElementById('CTLOCDesc')
	var res=document.getElementById('RESDesc')
	var ser=document.getElementById('SERDesc')
	if ((obj) && (res) && (ser)) {
		//res.value=""
		ser.value=""
		var obj=document.getElementById('ServId');
		if (obj) obj.value=""
	}
}

function ServiceTextChangeHandler() {
	//SB 12/06/02: This function is called from RBAppointment.LookUpBrokerServ, as the onchange handler overwrites the broker method.
	//var obj=document.getElementById('OrderItemMess')
	//if (obj) obj.value="";
	var obj=document.getElementById('ServiceGrpParams')
	if (obj) obj.value="";
}

function IntTextChangeHandler() {
	//RC 16/12/02: This function is called from PACInterpreter.LookUpBrokerInterpreterLoc, as the onchange handler overwrites the broker method.
}

function TransTextChangeHandler() {
	//RC 16/12/02: This function is called from RBCAppointTransport.LookUpBrokerTransLoc, as the onchange handler overwrites the broker method.
}

function FindClickHandler(e) {
	//alert("FindClickHandler");
	if (evtTimer) {
		setTimeout('FindClickHandler();',200);
		return;
	}

	var delim="&";
	var ServList=parent.frames["RBServList"]
	var objDate=document.getElementById("Date");
	var objAdmDate=document.getElementById("PAADMAdmDate");
	var objSTime=document.getElementById("StartTime");
	var objETime=document.getElementById("EndTime");
	var objRows=document.getElementById("Rows");
	var objLinkRes=document.getElementById("LinkFlag");
	var objAllRes=document.getElementById("AllResFlag");
	//var objConD=document.getElementById("ConsecDays");
	// Log 37518 BC 9-9-2003 Add HCA and Hospitals to Edit Service List don't use the value from RBAppointment.Find
	//var objHCA=document.getElementById("HCARowId");
	//var objHospIDs=document.getElementById("HOSPDescString");
	/*var objTrans=document.getElementById("Transport"); //Log 31104 RC 22/01/03
	var objInter=document.getElementById("Interpreter");
	var objTraR=document.getElementById("TransReq");
	var objIntR=document.getElementById("IntReq");
	var objDisI=document.getElementById("disInt");
	var objDisT=document.getElementById("disTrans");//End Log 31104*/
	var multi=document.getElementById("mselect");
	var epid=document.getElementById("EpisodeID");
	var wlid=document.getElementById("WaitingListID");
	var oeid=document.getElementById("oeoriID")
	if (epid) epid=epid.value;
	if (wlid) wlid=wlid.value;
	if (oeid) oeid=oeid.value;
	var daycaption="Mon,Tue,Wed,Thu,Fri,Sat,Sun";
	var dayAry=daycaption.split(",");
	var Ser="";
	var Res="";
	var Loc="";
	var Pay="";
	var Plan="";
	var DOW="";
	var Date="";
	var AdmDate="";
	var STime="";
	var ETime="";
	var Rows="";
	var LinkRes="";
	var HCA="";
	var AllRes="";
	var MultiDate="";
	var ssess=MultipleSessDescBuilder();
	var HospIDs=""
	var context=""; var ConD=""; var NoS="";
	var transport=""; var interpreter=""; var trareq=""; var intreq=""; var disint=""; var distra=""; //Log 31104 RC 22/01/03
	var times=getTimes()
	//alert(times);
	var multis=1;
	if (multi) {
		if ((multi.value!="") && (multi.value>1)) {multis=multi.value}
	}
	;
	//BR 33189, If fail ADM check then don't want search to continue.
	OKtoContinue=CheckDateAgainstAdm();
	;
	if (OKtoContinue=="Y") {
		var obj= document.getElementById("CONTEXT")
		if (obj) context=obj.value;
		;
		//Get the selected days for Day Search
		for (var n=0; n<7; n++) {
			var day=document.getElementById("chk"+dayAry[n])
			if ((day) && (day.checked)) {
				DOW = DOW+(n+1);
			}
		}
		;
		//Get the No. of rows to retrieve
		if (objRows) Rows = objRows.value;
		;
		//SB 30/12/02 (31580): The following was needed when Alt+F was pressed without tabbing out of date/time fields
		if (objDate) ConvertTDate(objDate);
		if (objSTime) ConvNTime(objSTime);
		if (objETime) ConvNTime(objETime);
		;
		//Get Date & Time
		if (objDate) Date=objDate.value;
		if (objAdmDate) AdmDate=objAdmDate.value;
		if (objSTime) STime=objSTime.value;
		if (objETime) ETime=objETime.value;
		//if (objHCA) HCA=objHCA.value;
		//if (objHospIDs) HospIDs=objHospIDs.value;
		//alert(Date+"  "+AdmDate);
		//Get Linked Resources
		if (objLinkRes) {
			if (objLinkRes.checked) LinkRes="ON";
		}
		// SB: 22/05/03 (35696) Get All Resources
		if (objAllRes) {
			if (objAllRes.checked) AllRes="S";
		}
		//if (objConD) {
		//	if (objConD.checked) ConD="ON";
		//}
		/*if (objTrans) transport=objTrans.value //Log 31104 RC 22/01/03
		if (objInter) interpreter=objInter.value
		if (objTraR) trareq=objTraR.value
		if (objIntR) intreq=objIntR.value
		if (objDisI) disint=objDisI.value
		if (objDisT) distra=objDisT.value //End Log 31104*/
		//alert(transport+"+"+interpreter+"+"+trareq+"+"+intreq+"+"+disint+"+"+distra);

		if (debug=="Y") {alert("FindClickHandler ServList "+ServList);}
		if (ServList) {
			var doc=parent.frames["RBServList"].document;
			var tbl=doc.getElementById("tRBAppointment_ServiceList");
			var rowLen=tbl.rows.length;
			var cellLen=tbl.rows[0].cells.length;
			;
			if (debug=="Y") {alert("rowLen="+rowLen);}
			if (rowLen==1) {
				//alert("in")
				AddClickHandler(1)
				return 1; //The find will be triggered from the AddClickHandler()
			}
			;
			if (rowLen==1) {
				alert(t['RBAddServices']);
				return;
			}
			;
			//Get selected Service List Data
			for (var i=1; i<rowLen; i++) {
				if (doc.getElementById("servListz" + i) && doc.getElementById("servListz" + i).checked && !doc.getElementById("servListz" + i).disabled) {
					Ser=Ser + doc.getElementById("serIdz" + i).value + "^";
					Loc=Loc + doc.getElementById("locIdz" + i).value + "^";
					Res=Res + doc.getElementById("resIdz" + i).value + "^";
					Pay=Pay + doc.getElementById("payIdz" + i).value + "|";
					Plan=Plan + doc.getElementById("planIdz" + i).value + "|";
					//transport=transport + doc.getElementById("Transportz" + i).innerHTML + "^";
					//interpreter=interpreter + doc.getElementById("Interpreterz" + i).innerHTML + "^";
					//trareq=trareq + doc.getElementById("TransReqz" + i).value + "^";
					//intreq=intreq + doc.getElementById("IntReqz" + i).value + "^";
					//disint=disint + doc.getElementById("disIntz" + i).value + "^";
					//distra=distra + doc.getElementById("disTransz" + i).value + "^";
					//alert(transport+"+"+interpreter+"+"+trareq+"+"+intreq+"+"+disint+"+"+distra);
					// 51537 RC 01/03/06 ConsecDays/NoOfSess for Sams Physio.
					//if (doc.getElementById("NoOfSessz" + i)) NoS=NoS + doc.getElementById("NoOfSessz" + i).value + "|";
					var NoS=""
					// Log 37518 BC 9-9-2003 Add HCA and Hospitals to Edit Service List
					HCA=HCA + doc.getElementById("HCARowIDz" + i).value + "|";
					Hosp=doc.getElementById("HospIDsz" + i).value
					// Need to change the delimiter
					HospAry=Hosp.split("|");
					Hosp=HospAry.join("^");
					HospIDs=HospIDs + Hosp + "|";
					MultiDate=MultiDate + doc.getElementById("datez" + i).innerHTML + "^";
				}
			}
			;
		} else {
			//alert("This ELSE is required when no middle grid exists in frame");
			// This ELSE is required when no middle grid exists in frame.
			// Need to Check mandatory Service field.
			var objSer=document.getElementById("SERDesc");
			var objLocId=document.getElementById("LocId");
			var objResId=document.getElementById("ResId");
			var objSerId=document.getElementById("servId");
			var objHospIDs=document.getElementById("HOSPDescString");
			if (objHospIDs) HospIDs=objHospIDs.value;
			if (!objSer) {
				//alert(t['RBServiceMandatory']);
				alert("\'" + t['SERDesc'] + "\' " + t['XMISSING']);
				return 0;
			}
			if (objSer.value=="") {
				//alert(t['RBServiceMandatory']);
				alert("\'" + t['SERDesc'] + "\' " + t['XMISSING']);
				return 0;
			}
			if (objLocId) Loc = objLocId.value + "^";
			if (objResId) Res = objResId.value + "^";
			if (objSerId) Ser = objSerId.value + "^";
		}
		//top.frames["TRAK_hidden"].document.writeln("<BR>")
		//top.frames["TRAK_hidden"].document.writeln("&ServId="+Ser+"&LocId="+Loc+"&ResId="+Res+"&PayId="+Pay+"&PlanId="+Plan+"&DOW="+DOW+"&Date="+Date+"&STime="+STime+"&ETime="+ETime+"&Rows="+Rows+"&LinkFlag="+LinkRes+"&HCA="+HCA+"&MultiSelect="+multis+"&EpisodeID="+epid+"&TransInt="+interpreter+"|"+transport+"|"+intreq+"|"+trareq+"|"+disint+"|"+distra+"&SessDesc="+ssess)
		Ser=encodeURIComponent(Ser)
		//Ser=websys_escape(Ser)
		//+"^"+ConD+"^"+NoS
		url="&TWKFL=&TWKFLI=&CONTEXT="+context+"&ServId="+Ser+"&LocId="+Loc+"&ResId="+Res+"&PayId="+Pay+"&PlanId="+Plan+"&DOW="+DOW+"&STime="+STime+"&ETime="+ETime+"&Rows="+Rows+"&Date="+Date+"&LinkFlag="+LinkRes+"^"+AllRes+"&HCA="+HCA+"PP"+times+"&HospIDs="+HospIDs+"&MultiSelect="+multis+"&EpisodeID="+epid+"&TransInt="+interpreter+"|"+transport+"|"+intreq+"|"+trareq+"|"+disint+"|"+distra+"&SessDesc="+websys_escape(ssess)+"&init=1"+"&WaitingListID="+wlid+"&OEOrdItemID="+oeid
		//alert(url)
		var obj=document.getElementById('DiaryMode');
		if (obj && obj.checked) {
			url="rbappointment.diaryview.csp?"+url
			websys_createWindow(url, "AppointmentDiary", "top=0,left=0")
		} else {
			parent.frames["RBApptList"].location="websys.default.csp?WEBSYS.TCOMPONENT=RBAppointment.ApptList"+url
		}
	}
}
// log 66154 function for external FindClickHandler
function FindExternalClickHandler(e) {
	//alert("FindExternalClickHandler");
	FindClickHandler()
	try {CustomFindExternalClickHandler()} catch(e) {}

	
}

function mPiece(s1,sep,n) {
    //Split the array with the passed delimeter
    delimArray = s1.split(sep);
    //If out of range, return a blank string
    if ((n <= delimArray.length-1) && (n >= 0)) {
        return delimArray[n];
    }
}

function SplitDateStr(strDate) {
	return DateStringToArray(strDate,dtseparator,dtformat);
}

function CheckDateAgainstAdm() {
	var objAdmDate=document.getElementById("PAADMAdmDate");
	var objDate=document.getElementById("Date");
	var objtodayDate=document.getElementById("TodayHTMLDate")
	var objAdmType=document.getElementById("AdmsnType");
	var objWaitID=document.getElementById("WaitingListID");
	var objVisitStat=document.getElementById("VisitStatus");
	var objServGrpParam=document.getElementById('ServiceGrpParams');
	var ODate="";
	var OAdmDate="";
	//BR 33189, If fail ADM check then don't want search to continue.
	CheckDate="Y";
	if (objDate) ODate=objDate.value;
	if (objtodayDate && ODate=="") ODate=objtodayDate.value
	if (objAdmDate) OAdmDate=objAdmDate.value;
	//alert (ODate+"   "+OAdmDate);
	if ((objDate)&&(objAdmDate)&&(ODate!="")&&(OAdmDate!="")){
		//alert("line 720");
		//alert (ODate["yr"]);
		ODate=DateStringToArray(ODate);
		//alert (ODate["yr"]);
	 	OAdmDate=DateStringToArray(OAdmDate);
	 	var NDate=new Date(ODate["yr"],ODate["mn"]-1,ODate["dy"]);
	 	var NAdmDate= new Date(OAdmDate["yr"],OAdmDate["mn"]-1,OAdmDate["dy"]);
	 	//alert (NDate.valueOf()+"   "+NAdmDate.valueOf());
		//SB Log 24297: 18-Apr-02  When we come from waiting lists and the Admission is an (I)npatient (P)re-admission
		//		 we need to allow the user to make a Pre-Assessment appointment.
		//		When the admission is a normal Outpatient appointment the Appointment should not be
		//		 before the admission.
		//alert(objAdmType.value+"^"+objVisitStat.value+"^"+objWaitID.value)
		if ((objAdmType.value=="I")&&(objVisitStat.value=="P")&&(objWaitID.value!="")) {
		 	if ( NAdmDate.valueOf() < NDate.valueOf() ){
		 		alert(t['RBAppAfterAdm']);
	 			objDate.value=objAdmDate.value;
				//BR 33189, If fail ADM check then don't want search to continue.
				CheckDate="N";
	 		}
		} else {
			// SB 29/07/03 (37337): If Bypass date check = Y then don't show msg
			//alert(objServGrpParam.value)
			if ((objServGrpParam)&&(objServGrpParam.value=="N")) {
			  if ( NDate.valueOf() < NAdmDate.valueOf() ){
		 		alert(t['RBAppBeforeAdm']);
	 			objDate.value=objAdmDate.value;
				//BR 33189, If fail ADM check then don't want search to continue.
				CheckDate="N";
	 		  }
			}
		}
	}
	return CheckDate
}

function DocumentClickHandler() {
	var objLoc=document.getElementById('CTLOCDesc');
	var objLocId=document.getElementById('LocId');
	var objRes=document.getElementById('RESDesc');
	var objResId=document.getElementById('ResId');
	var objSer=document.getElementById('SERDesc');
	var objSerId=document.getElementById('ServId');
	//alert("Loc: " + objLoc.value + ",LocId: " + objLocId.value + ",Res: " + objRes.value + ",ResId: " + objResId.value + ",Ser: " + objSer.value + ",SerId: " + objSerId.value)
}

//LOG 30495 BC 27-11-2002 Hospital list for the search
function HospitalDeleteClickHandler() {
	//Delete items from HOSPEntered listbox when a "Delete" button is clicked.
	var obj=document.getElementById("HOSPEntered")
	if (obj) {
		RemoveFromList(obj);
		UpdateHospitals();
	}
	return false;
}

function RemoveFromList(obj) {
	for (var i=(obj.length-1); i>=0; i--) {
		if (obj.options[i].selected)
			obj.options[i]=null;
	}
}

function AddItemToList(list,code,desc) {
	//Add an item to a listbox
	code=String.fromCharCode(2)+code
	list.options[list.options.length] = new Option(desc,code);
}

function UpdateHospitals() {
	//alert("UpdateHospitals");
	var arrItems = new Array();
	var lst = document.getElementById("HOSPEntered");
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			var code=lst.options[j].value.split(String.fromCharCode(2));
			//arrItems[j] = lst.options[j].value;
			arrItems[j] = code[1];
			//alert(code[1]);
		}
		var el = document.getElementById("HOSPDescString");
		if (el) el.value = arrItems.join("^");
		//alert (el.value);
	}
}

function HospitalLookupSelect(txt) {
	//alert("HospitalLookupSelect: "+txt);
	//Add an item to HOSPEnetered when an item is selected from
	//the Lookup, then clears the Item text field.
	var adata=txt.split("^");
	var hobj=document.getElementById("HOSPEntered");
	ClearLocAndResAndServ();

	if (hobj) {
		//Need to check if Hospital already exists in the List and alert the user
		for (var i=0; i<hobj.options.length; i++) {
			if (hobj.options[i].value == String.fromCharCode(2)+adata[1]) {
				alert("Hospital has already been selected");
				var obj=document.getElementById("HOSPDesc")
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (hobj.options[i].text == adata[0])) {
				alert("Hospital has already been selected");
				var obj=document.getElementById("HOSPDesc")
				if (obj) obj.value="";
				return;
			}
			//alert(obj.options[i].value+"****"+adata[1])
		}
	}
	//if (obj) {alert("Object found");}
	if (hobj) AddItemToList(hobj,adata[1],adata[0]);

	var obj=document.getElementById("HOSPDesc");
	if ((obj)&&(hobj)) obj.value="";
	if (hobj) {
		UpdateHospitals();
	}else {
		var obj=document.getElementById("HOSPDescString");
		if (obj) obj.value=adata[1];
	}
	//alert("adata 2="+adata);
}

function ClearLocAndResAndServ() {
		//alert("ClearLocAndResAndServ");
		//alert(doneInit);
		//md log 56808 doneInit checked to be sure that page is completly loaded
		//helpful when predefaults in action
		if (doneInit)
		{
		var obj=document.getElementById('LocId');
		if (obj) obj.value=""
		var obj=document.getElementById('ResId');
		if (obj) obj.value="";
		var obj=document.getElementById('ServId');
		if (obj) obj.value=""
		var obj=document.getElementById('CTLOCDesc');
		if (obj) obj.value=""
		var obj=document.getElementById('RESDesc');
		if (obj) obj.value="";
		var obj=document.getElementById('SERDesc');
		if (obj) obj.value="";
		var obj=document.getElementById('RESCode');
		if (obj) obj.value="";
		}

}

function ClearHospitalList(){
	//alert("ClearHospitalList");
	var el = document.getElementById("HOSPDesc");
	if (el) el.value = "";
	var el = document.getElementById("HOSPDescString");
	if (el) el.value = "";
	var obj=document.getElementById("HOSPEntered");
	if (obj) {
		for (var i=(obj.length-1); i>=0; i--) {
				obj.options[i]=null;
		}
	}
}

function HCATextBlurHandler(e) {
	//alert("HCATextBlurHandler");
	var eSrc=websys_getSrcElement(e)
	if (eSrc && eSrc.value=="") {
		var obj=document.getElementById('HCARowId');
		if (obj) obj.value=""
	}

}

function InsurPayorBlurHandler(e) {
	var eSrc=websys_getSrcElement(e)
	if (eSrc && eSrc.value=="") {
		var obj=document.getElementById('PayId');
		if (obj) obj.value=""
	}

}

function InsurPlanBlurHandler(e) {
	var eSrc=websys_getSrcElement(e)
	if (eSrc && eSrc.value=="") {
		var obj=document.getElementById('PlanId');
		if (obj) obj.value=""
	}

}

function HOSPTextBlurHandler(e) {
	//alert("HOSPTextBlurHandler");
	var eSrc=websys_getSrcElement(e)
	if (eSrc && eSrc.value=="") {
		var obj=document.getElementById('HOSPDescString');
		if (obj) obj.value=""
	}

}
//End LOG 30495 BC 27-11-2002 Hospital list for the search

//Log 30886 BC 9-12-2002
function setSameTimes() {
	//alert("setSameTimes");
	var STobj=document.getElementById('SameTime');
	var CTobj=document.getElementById('ConsecutiveTimes');
	var CTRobj=document.getElementById('ConsecTimesRes');
	var ATobj=document.getElementById('AllTimes');
	if (ATobj) {ATobj.checked="";};
	if (CTobj) {CTobj.checked="";};
	if (STobj) {STobj.checked="true";};
	if (CTRobj) {CTRobj.checked="";};

}
function setConsecutiveTimes() {
	//alert("setConsecutiveTimes");
	var STobj=document.getElementById('SameTime');
	var CTobj=document.getElementById('ConsecutiveTimes');
	var CTRobj=document.getElementById('ConsecTimesRes');
	var ATobj=document.getElementById('AllTimes');
	if (ATobj) {ATobj.checked="";};
	if (CTobj) {CTobj.checked="true";};
	if (STobj) {STobj.checked="";};
	if (CTRobj) {CTRobj.checked="";};

}
function setConsecTimesRes() {
	//alert("setConsecutiveTimes");
	var STobj=document.getElementById('SameTime');
	var CTobj=document.getElementById('ConsecutiveTimes');
	var CTRobj=document.getElementById('ConsecTimesRes');
	var ATobj=document.getElementById('AllTimes');
	if (ATobj) {ATobj.checked="";};
	if (CTobj) {CTobj.checked="";};
	if (STobj) {STobj.checked="";};
	if (CTRobj) {CTRobj.checked="true";};

}
function setAllTimes() {
	//alert("setAllTimes");
	var STobj=document.getElementById('SameTime');
	var CTobj=document.getElementById('ConsecutiveTimes');
	var CTRobj=document.getElementById('ConsecTimesRes');
	var ATobj=document.getElementById('AllTimes');
	if (ATobj) {ATobj.checked="true";};
	if (CTobj) {CTobj.checked="";};
	if (STobj) {STobj.checked="";};
	if (CTRobj) {CTRobj.checked="";};

}
function getTimes() {
	// function that returns "A" for All times (the default),"C" for Consecutive Times
	// and "S" for Same Time
	Rtimes="^N^N^"
	var STobj=document.getElementById('SameTime');
	var CTobj=document.getElementById('ConsecutiveTimes');
	var CTRobj=document.getElementById('ConsecTimesRes');
	if ((STobj)&&(STobj.checked)) {Rtimes="^Y^N^";};
	if ((CTobj)&&(CTobj.checked)) {Rtimes="^N^Y^";};
	if ((CTRobj)&&(CTRobj.checked)) {Rtimes="^N^N^";};
	// Log 34577 BC 8-4-2003
	var STimeEDobj=document.getElementById('STimeED');
	if ((STimeEDobj)&&(STimeEDobj.checked)) {Rtimes=Rtimes+"Y^";} else {Rtimes=Rtimes+"N^";}
	// SB 14/08/06 (60289)
	var GroupDateobj=document.getElementById('GroupSameDay');
	if ((GroupDateobj)&&(GroupDateobj.checked)) {Rtimes=Rtimes+"Y^";} else {Rtimes=Rtimes+"N^";}
	if ((CTRobj)&&(CTRobj.checked)) {Rtimes=Rtimes+"Y^";} else {Rtimes=Rtimes+"N^";}
	return Rtimes
}



//End Log 30886

function LocationFieldTester() {/*redundant function now, just left here in case custom scripts call it*/}

function AllResClickHandler() {
	// SB: 22/05/03 (35696)
	var objAllRes=document.getElementById("AllResFlag");
	var objMSelect=document.getElementById("mselect");
	var objRows=document.getElementById("Rows");
	if (objAllRes.checked) {
		if (objMSelect) {
			objMSelect.value="1";
			objMSelect.disabled=true;
		}
		if (objRows) {
			objRows.value="1";
			objRows.disabled=true;
		}
	} else {
		if (objMSelect) {
			objMSelect.disabled=false;
		}
		if (objRows) {
			objRows.disabled=false;
		}
	}
}

//BC 16/5/02 Log 36469
function MultipleSessDescBuilder() {
	var objSESSDesc=document.getElementById("SESSDesc")
	var SessDescs="";
	if (objSESSDesc) {
		for (var i=(objSESSDesc.length-1); i>=0; i--) {
			if (objSESSDesc.options[i].selected) {
				if (objSESSDesc.options[i].value==String.fromCharCode(2)+"B") {
					SessDescs=SessDescs+"BLANKSESSION"+"|";
				} else {
					var values=objSESSDesc.options[i].value.split(String.fromCharCode(2))
					SessDescs=SessDescs+values[1]+"|";
				}
			}
		}
		//RC 43411 17/06/04 If no sessions are selected, then use all the sessions in the box, instead of returning blank,
		//as returning blank will look up ALL sessions, not just the ones in the box, when this isn't wanted when
		//restricting sessions by security group.
		if (SessDescs=="") {
			for (var i=(objSESSDesc.length-1); i>=0; i--) {
				if (objSESSDesc.options[i].value==String.fromCharCode(2)+"B") {
					SessDescs=SessDescs+"BLANKSESSION"+"|";
				} else {
					var values=objSESSDesc.options[i].value.split(String.fromCharCode(2))
					SessDescs=SessDescs+values[1]+"|";
				}
			}
		}
	}
	//SessDescs=SessDescs.substring(0,(SessDescs.length-1));
	//alert(SessDescs);
	return SessDescs;
}
//BC 16/5/02 Log 36469
function PopulateSessionType(str){
	//alert(str)
	var objSESSDesc=document.getElementById("SESSDesc")
	if (objSESSDesc) {
		var selections=str.split("^");
		for (var jj=0;jj<selections.length;jj++) {
			var selection=selections[jj].split(String.fromCharCode(2));
			AddItemToList(objSESSDesc,selection[0],selection[0]);
			if (selection[1]=="Y"){
				objSESSDesc.options[(objSESSDesc.options.length)-1].selected=true;
			}
		}
	}
}

function AddHospIDToList(hospid) {
	if (document.getElementById("HOSPDescString").value!="") {
		document.getElementById("HOSPDescString").value=document.getElementById("HOSPDescString").value+"^"+hospid;
	}
	if (document.getElementById("HOSPDescString").value=="") {
		document.getElementById("HOSPDescString").value=hospid;
	}
}

//BC 23-10-2003 used to Test field before add
function CheckValidEntry(obj) {
	//alert(obj.className);
	if ((obj)&&(obj.className=="clsInvalid")) {
		return false
	} else {
		return true
	}
}

function WLPassValue(e) {
	//alert("CheckBeforeUpdate");
	var Servdoc=parent.frames["RBServList"].document;
	var Servf=Servdoc.getElementById("fRBAppointment_ServiceList");
	var ServList=Servdoc.getElementById("tRBAppointment_ServiceList");

	ServChk=checkedCheckBoxes(Servf,ServList,"servListz");

	var str=""
	var overbook=""
	for (var i=0;i<ServChk.length;i++) {
		str=str+Servdoc.getElementById("datez"+ServChk[i]).innerText+"*"+Servdoc.getElementById("timez"+ServChk[i]).innerText+"*"+Servdoc.getElementById("schedlistz"+ServChk[i]).value+"*"+Servdoc.getElementById("serIdz"+ServChk[i]).value+"*"+Servdoc.getElementById("urgentIDz"+ServChk[i]).value+"*"+Servdoc.getElementById("locIdz"+ServChk[i]).value+"^";
		if (Servdoc.getElementById("schedlistz"+ServChk[i]).value=="") {
			//may need to check later if appt is there, but for now we wont GR
			//if (Servdoc.getElementById("datez"+ServChk[i]).innerText=="") {
				overbook= overbook + Servdoc.getElementById("resIdz"+ServChk[i]).value + "|" + Servdoc.getElementById("locIdz"+ServChk[i]).value + "|" + Servdoc.getElementById("payIdz"+ServChk[i]).value + "|" + Servdoc.getElementById("planIdz"+ServChk[i]).value + "|" + Servdoc.getElementById("serIdz"+ServChk[i]).value +"^";
			//}
		//alert(overbook);
		}
	}
	obj=document.getElementById('WLRBPass');
	if (obj) obj.value=overbook
	//lnk=obj.href;
	//lnk=lnk + "&WaitingListID="+WaitListID+"&PatientID="+PatientID+"&RBWLFlag="+overbook ;
	//obj.href=lnk;
	//alert(obj.value);
	AddToWL_click();
	return;

}
//gr log 52559
function disableform() {
	var wlstatus=document.getElementById("wlStatus");
	if (wlstatus) {
		if (wlstatus.value=="R"){
			var frm = document.forms['fRBAppointment_Find'];
			for (i=0; i<frm.elements.length; i++) {
				var el = frm.elements[i];
				var icn= "ld570i" + el.name
				//var el = frm.elements[arrElem[i]];
				if (el) {
					el.disabled=true;
					//alert(icn);
					icon=document.getElementById(icn)
					if (icon) icon.style.visibility = "hidden";
				}
			}
			objUpdate=document.getElementById("Update");
			if (objUpdate) {
				objUpdate.disabled=true;
				objUpdate.onclick=LinkDisable;
			}
			objFind=document.getElementById("Find");
			if (objFind) {
				objFind.disabled=true;
				objFind.onclick=LinkDisable;
			}
			return 1;
		}
	}
	return 0;
}

function bestplan() {

	var lnk = "arpatbill.bestplan.csp?PatientID="+document.getElementById("PatientID").value+"&oeoriID="+document.getElementById("oeoriID").value+"&compref="+document.getElementById("TEVENT").value;
	//top.frames["TRAK_hidden"].location=lnk;

	websys_createWindow(lnk,"top=0,left=0");
}

//md per log 58200
function ValidatePREUpdate() {

	var arrElements = document.getElementsByTagName("input");
	if (arrElements) {
		var msg="";
		var fld="";	var fldfocus=""
		for (var i=0; i < arrElements.length; i++) {
			fld = arrElements[i];
			if ((fld.className == "clsInvalid") &&(fld.value!="")){
				if (fldfocus=="") fldfocus=fld;
				// Log 59212 - GC - 23-05-2006: Replaced hardcoded "is invalid" with t['RBIsInvalid']
				msg = msg + t[fld.name] + ": " + fld.value + " " + t['RBIsInvalid'] + "\n";
			}
		}
		if (msg!="") {
			alert(msg);
			websys_setfocus(fldfocus.name);
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

//log 61362 TedT
function GroupNumberLink(exist) {
	var grpobj=document.getElementById("EpisodeGroupNumber");
	if ((exist=="1")&&(grpobj)) grpobj.style.fontWeight="bold";
	if ((exist!="1")&&(grpobj)) grpobj.style.fontWeight="";
}

function DiaryModeClickHandler(e) {
	if (frameset == null) return;
	var obj=document.getElementById('DiaryMode');
	if (obj && obj.checked) {
		frameset.rows = "60%,40%,0%";
	} else {
		frameset.rows = fsrows;
	}
}

function Document2UnloadHandler() {
	//Log 62631 29/03/07 PeterC
	var obj=document.getElementById("CPWRowId");
	if((obj)&&(obj.value!="")) {
		if ((window.parent)&&(window.parent.parent)&&(window.parent.parent.parent)&&(window.parent.parent.parent.opener)) {
 			var fobj=window.parent.parent.parent.opener.document.getElementById("Find");
			var ncobj=window.parent.parent.parent.opener.document.getElementById("NewClinPathWays");
			if ((fobj)&&(ncobj)) window.parent.parent.parent.opener.FindClickHandlerFromAppt();
		}
	}
}

document.body.onload = DocumentLoadHandler;
document.body.onunload = Document2UnloadHandler;
//document.body.onclick = DocumentClickHandler;

