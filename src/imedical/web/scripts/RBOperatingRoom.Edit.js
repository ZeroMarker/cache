// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var debug="N"  //"Y" = alerts and stuff, "N" = alert free
var ProcedureStr=""
var seqChanged=false;
var totalnap=""

function DocumentLoadHandler() {
	Init();
    //alert("Doc Load Handler");

	/*var obj=document.getElementById("RESCTLOCDR");
	if (obj) obj.onblur=locationchange;
	if ((obj)&&(obj.value!="")) {MakeDisplayOnly("RESCTLOCDR");}

	var obj=document.getElementById("RBOPResourceDR");
	if (obj) obj.onblur=resourcechange;
	if ((obj)&&(obj.value!="")) {MakeDisplayOnly("RBOPResourceDR");}*/
	checkWLDefaults();
	var obj=document.getElementById("ApptDate");
	if (obj) {
		obj.onblur=datechangeb;
		if (obj.value!="") {
			var obj=document.getElementById("RBOPRequestedDateOper");
			if (obj) {
				if (document.getElementById('ld585iRBOPRequestedDateOper')) var killed=document.getElementById('ld585iRBOPRequestedDateOper').removeNode(false);
				MakeDisplayOnly("RBOPRequestedDateOper");
			}
			var obj=document.getElementById("RBOPRequestedTimeOper");
			if (obj) {
				MakeDisplayOnly("RBOPRequestedTimeOper");
			}

			//Log 48387 Chandana 24/1/05
			//If Booking Date and Time already exist and an appointment is already linked, make them display only so they can't be changed
			var apptObj = document.getElementById("RBOPAppointDR");
			if (apptObj && apptObj.value!=""){
				DisableFieldVisiable("ApptDate");
				DisableFieldVisiable("ApptTime");
				DisableField("ld585iApptDate");
				//58305 RC 20/02/06 If seq no blank, then make sure it stays blank
				var obsched=document.getElementById("OverbookSched");
				if (obsched && obsched.value=="S") DisableField("RBOPSequenceNo");
				//md
				DisableFieldVisiable("VFTime","");
				DisableFieldVisiable("VTTime","");
				DisableFieldVisiable("PSTime","");
				DisableFieldVisiable("PETime","");
				var objPST=document.getElementById("PSTime");
				var objEST = document.getElementById('EstimatedSTime');
				if (objPST&&objEST&&objPST.value!="") { objEST.innerHTML=objPST.value; }
				//md
			}
		}

	}
	var objVF=document.getElementById("VFTime");
	var objVT=document.getElementById("VTTime");
	var RBOPID=document.getElementById("ID");
	if ((RBOPID.value!="")&&((!objVF)||((objVF)&&(objVF.value!=""))||(!objVT)||((objVT)&&(objVT.value!="")))) {
		DisableFieldVisiable("VFTime","");
		DisableFieldVisiable("VTTime","");
		DisableFieldVisiable("PSTime","");
		DisableFieldVisiable("PETime","");

	}


	var obj=document.getElementById("ApptTime");
	if (obj) obj.onblur=timechangeb;
	var obj=document.getElementById("defaultstr");
	if (obj) {
		if (obj.value!="") {
			dateLookUpB(obj.value);
		}
	}

	//md %%%%%%%%%%
	var objVNAID=document.getElementById("VNAID");
	if ((objVNAID)&&(objVNAID.value=="")) {
	//alert("msd2");

	DisableFieldVisiable("VFTime","");
	DisableFieldVisiable("VTTime","");
	DisableFieldVisiable("PSTime","");
	DisableFieldVisiable("PETime","");
	/*
	MakeDisplayOnly("VFTime");
	MakeDisplayOnly("VTTime");
	MakeDisplayOnly("PSTime");
	MakeDisplayOnly("PETime");
	*/
	}
	//md %%%%%%%%%%

	var obj=document.getElementById("RBOPRequestedDateOper");
	if (obj) obj.onblur=datechange;
	//BR 21/12/05 57531, If there is already a requested date, then don't make booking date mandatory.
	if ((obj)&& (obj.value!="")){
		//alert("datechangeb() not blank");
		var obj = document.getElementById('ApptDate')
		if (obj)  {
			obj.className="";
			var obj3=document.getElementById('cApptDate')
			if (obj3) obj3.className="";
		}
		var obj = document.getElementById('ApptTime')
		if (obj) {
			obj.className="";
			var obj2=document.getElementById('cApptTime')
			if (obj2) obj2.className="";
		}
		var obj = document.getElementById('RBOPSequenceNo')
		if (obj)  {
			obj.className="";
		}
	}
	var obj=document.getElementById("RBOPRequestedTimeOper");
	if (obj) obj.onblur=timechange;
	var obj=document.getElementById('RBOPOperDepartmentDR');
	if (obj) {
		obj.onblur = RBOPOperDepartmentBlurHandler;
	}
	var obj=document.getElementById('RBOPRefDepDR');
	if (obj) {
		obj.onblur = RBOPRefDepDRBlurHandler;
	}

	var obj=document.getElementById("AdmDiagType");
	if ((obj)&&(obj.value!="")) {
		MakeDisplayOnly("AdmDiagType");
		MakeDisplayOnly("AdmDiagDesc");
	}
	var obj=document.getElementById("AdmDiagDesc");
	if ((obj)&&(obj.value!="")) {
		MakeDisplayOnly("AdmDiagType");
		MakeDisplayOnly("AdmDiagDesc");
	}

	//Chandana S Log 41689
	DisableLinks();
	InitBoldLinks();

	var readmit=document.getElementById('Readmit');
	if (readmit.value=="1") {ReadmitTheatre();}
	else {
		var RBOPReasForRet=document.getElementById("RBOPReasForRet");
		var RBOPRetBook=document.getElementById("RBOPRetBook");
		if ((RBOPReasForRet)&&(RBOPRetBook)) {
			DisableField("RBOPReasForRet")
			DisableField("ld585iRBOPReasForRet")
			DisableField("RBOPRetBook")
			if (RBOPReasForRet.value!="") {
				RBOPRetBook.checked=true;
			} else {
				RBOPReasForRet.className="disabledField";
			}
		}
	}
	//md
	var pstime=document.getElementById("PSTime");
	if (pstime) pstime.onblur=CheckVacantTime;
	var petime=document.getElementById("PETime");
	if (petime) petime.onblur=CheckVacantTime;

	//md
	var obj=document.getElementById("update1");
	if (obj) obj.onclick = UpdateClickHandler;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateClickHandler;


	//Log 56767 RC 02/05/06 Make fields Read-Only if in overbooking workflow.
	var obdata=document.getElementById("obData");
	if ((obdata)&&(obdata.value!="")) {
		var obj=document.getElementById("RESCTLOCDR");
		if (obj) DisableFieldVisiable("RESCTLOCDR","ld585iRESCTLOCDR");

		var obj=document.getElementById("RBOPResourceDR");
		if (obj) DisableFieldVisiable("RBOPResourceDR","ld585iRBOPResourceDR");

		var obj=document.getElementById("ApptDate");
		if (obj) DisableFieldVisiable("ApptDate","ld585iApptDate");

	}
}

function ReadmitTheatre() {
	var ApptDate=document.getElementById("ApptDate")
	var ApptDateLU=document.getElementById("ld585iApptDate")
	var ApptTime=document.getElementById("ApptTime")
	var RBOPSequenceNo=document.getElementById("RBOPSequenceNo")
	var EstimatedSTime=document.getElementById("EstimatedSTime")
	var RBOPSurgeonDR=document.getElementById("RBOPSurgeonDR")
	var RBOPAnaesthetistDR=document.getElementById("RBOPAnaesthetistDR")
	var RBOPRequestedDateOper=document.getElementById("RBOPRequestedDateOper")
	var RBOPRequestedDateOperc = document.getElementById('cRBOPRequestedDateOper')
	var RBOPRequestedTimeOper=document.getElementById("RBOPRequestedTimeOper")
	var RBOPRequestedTimeOperc = document.getElementById('cRBOPRequestedTimeOper')
	var RBOPDateArrived=document.getElementById("RBOPDateArrived")
	var RBOPTimeArrived=document.getElementById("RBOPTimeArrived")
	var RBOPStatus=document.getElementById("RBOPStatus")
	var RBOPRetBook=document.getElementById("RBOPRetBook")
	var RBOPReasForRet=document.getElementById("RBOPReasForRet")
	var cRBOPReasForRet=document.getElementById("cRBOPReasForRet")
	var ID=document.getElementById("ID")
	var RBOPAppointDR=document.getElementById("RBOPAppointDR")
	var ApptDateLogical=document.getElementById("ApptDateLogical")
	var readmit=document.getElementById('Readmit');

	//if (ApptDate) {ApptDate.value=""; ApptDate.disabled=false; }
	if (ApptDate) {EnableField("ApptDate"); ApptDate.value="" }//log 66130 KB The above code not working
	if (ApptDateLU) ApptDateLU.disabled=false;
	//if (ApptTime) {ApptTime.value=""; ApptTime.disabled=false; }
	if (ApptTime) {EnableField("ApptTime"); ApptTime.value=""} //log 66130 KB The above code not working
	if (RBOPSequenceNo) RBOPSequenceNo.value="";
	if (EstimatedSTime) EstimatedSTime.innerHTML=""
	if (RBOPSurgeonDR) RBOPSurgeonDR.value=""
	if (RBOPAnaesthetistDR) RBOPAnaesthetistDR.value=""
	// Log 66130 KB Needed to make these fields non mandatory for readmission
	if (RBOPRequestedDateOper) {RBOPRequestedDateOper.className=""; RBOPRequestedDateOper.innerHTML=""}
	if (RBOPRequestedDateOperc) RBOPRequestedDateOperc.className=""; 
	if (RBOPRequestedTimeOper) {RBOPRequestedTimeOper.className=""; RBOPRequestedTimeOper.innerHTML=""}
	if (RBOPRequestedTimeOperc) RBOPRequestedTimeOperc.className=""; 
	// end log 66130
	if (RBOPDateArrived) RBOPDateArrived.innerHTML=""
	if (RBOPTimeArrived) RBOPTimeArrived.innerHTML=""
	if (RBOPStatus) RBOPStatus.innerHTML=""
	if (RBOPRetBook) {RBOPRetBook.checked=true; RBOPRetBook.disabled=true;}
	if (RBOPReasForRet) RBOPReasForRet.className="clsRequired";
	if (cRBOPReasForRet) cRBOPReasForRet.className="clsRequired";
	if (ID) ID.value="";
	if (RBOPAppointDR) RBOPAppointDR.value="";
	if (ApptDateLogical) ApptDateLogical.value="";
	if (readmit) readmit.value="";
}

//Log 47113 CS 7/2/05 - Everytime the Surgeon is changed, set a flag
function RBOPSurgeonDR_changehandler(encmeth) {
	var surgFlag = document.getElementById("SurgChanged");
	if (surgFlag) {surgFlag.value = "1";}
	evtName='RBOPSurgeonDR';
	if (doneInit) { evtTimer=window.setTimeout("RBOPSurgeonDR_changehandlerX('"+encmeth+"');",200); }
	else { RBOPSurgeonDR_changehandlerX(encmeth); evtTimer=""; }
}

function RBOPSurgeonDR_lookupsel(value) {
	var surgFlag = document.getElementById("SurgChanged");
	if (surgFlag) {surgFlag.value = "1";}
	try {
		var obj=document.getElementById('RBOPSurgeonDR');
		if (obj) {
  			obj.value=unescape(value);
			obj.className='';
		websys_nextfocus(obj.sourceIndex);
		}
	} catch(e) {};
}

//Log 47113 CS 7/2/05 - Everytime the Anaesthetis is changed, set a flag
function RBOPAnaesthetistDR_changehandler(encmeth) {
	var anaeFlag = document.getElementById("AnaeChanged");
	if (anaeFlag) {anaeFlag.value = "1";}
	evtName='RBOPAnaesthetistDR';
	if (doneInit) { evtTimer=window.setTimeout("RBOPAnaesthetistDR_changehandlerX('"+encmeth+"');",200); }
	else { RBOPAnaesthetistDR_changehandlerX(encmeth); evtTimer=""; }
}

function RBOPAnaesthetistDR_lookupsel(value) {
	var anaeFlag = document.getElementById("AnaeChanged");
	if (anaeFlag) {anaeFlag.value = "1";}
	try {
		var obj=document.getElementById('RBOPAnaesthetistDR');
		if (obj) {
  			obj.value=unescape(value);
			obj.className='';
		websys_nextfocus(obj.sourceIndex);
		}
	} catch(e) {};
}

//Disable the Staff link for a new booking
function DisableLinks(){
	var objId = document.getElementById("ID");
	if (objId && objId.value==""){
		var objLink = document.getElementById("StaffLink");
		if (objLink){
			objLink.disabled=true;
			objLink.onclick="";
		}
	}

}

function setBoldLinks(el,state) {
	obj=document.getElementById(el);
	if (obj) {
		if (state==1) {obj.style.fontWeight="bold";}
		else {obj.style.fontWeight="normal";}
	}
}

function InitBoldLinks(){
	var objBold=document.getElementById('BoldLinks');
	if (objBold) {
		var BoldLink = objBold.value.split("^");
		setBoldLinks("StaffLink",BoldLink[0]);
	}
}

//CS 15/1/04 Log 41685 - Blur Handler for 'RBOPStatePPPDR'.  If the value in 'RBOPStatePPPDR' is blank,
//set Estimate Time to blank.
//CS 1/2/05 Log 48908
function RBOPStatePPPDR_changehandler(encmeth) {
	evtName='RBOPStatePPPDR';
	if (doneInit) { evtTimer=window.setTimeout("RBOPStatePPPDR_changehandlerX('"+encmeth+"');",200); }
	else { RBOPStatePPPDR_changehandlerX(encmeth); evtTimer=""; }

	var obj1 = document.getElementById('RBOPEstimatedTime');
	var obj2 = document.getElementById('RBOPStatePPPDR');
	if (obj1 && obj2){
		if (obj2.value == ""){
			obj1.value="";
		}
	}
}

//CS 15/1/04 Log 41685 - Change Handler for 'RBOPOperationDR'.  If the value in 'RBOPOperationDR' is blank,
//set Estimate Time to blank.
//CS 1/2/05 Log 48908
function RBOPOperationDR_changehandler(encmeth) {
	evtName='RBOPOperationDR';
	if (doneInit) { evtTimer=window.setTimeout("RBOPOperationDR_changehandlerX('"+encmeth+"');",200); }
	else { RBOPOperationDR_changehandlerX(encmeth); evtTimer=""; }

	var obj1 = document.getElementById('RBOPEstimatedTime');
	var obj2 = document.getElementById('RBOPOperationDR');
	if (obj1 && obj2){
		if (obj2.value == ""){
			obj1.value="";
		}
	}
}

function DisableField(fldName) {
	var fld = document.getElementById(fldName);
	if (fld) {
		fld.disabled = true;
		fld.className = "clsDisabled";
	}
}
function DisableFieldVisiable(fldName,icN) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if ((fld)&&(fld.tagName=="INPUT")) {
		//if (fld.type!="checkbox") fld.value = "";
		if (fld.type=="checkbox") fld.checked=false;
		fld.readOnly = true;
		fld.className = "clsReadOnly";
		if (lbl) lbl.className = "";
	}
	if (icN) {
		var objIcon=document.getElementById(icN);
		if (objIcon) objIcon.style.visibility = "hidden";
	}
}

function EnableField(fldName) {
	var fld = document.getElementById(fldName);
	if (fld) {
		fld.disabled = false;
		fld.className = "";
	}
}

function MakeDisplayOnly(fieldname) {
	var obj=document.getElementById(fieldname);
	var val=obj.value;
	var re=/ /gi  //if the fieldvalue has spaces in the description, replace with html 'space'.
	val=val.replace(re,"&nbsp;");
	var parentobj=obj.parentNode;
	var newobjhtml="<label id="+fieldname+" name="+fieldname+" value="+val+">"+val+"</label>";
	if (parentobj) parentobj.innerHTML=newobjhtml;
}

//CS Log 41685 - Default the estimate time based on primary procedure
function SetEstTimeProc(str){
	//alert(str);
	ProcedureStr=str;
	var arr = str.split("^");
	//alert("in js code " + arr[2] + " desc " + arr[0] + " estTime " + arr[6]);
	var obj = document.getElementById('RBOPEstimatedTime');
	if (obj) {
		obj.value = arr[6];
	} /*else {
		CalculateNewEstimatedTime;
	}*/
	var obj = document.getElementById('hidEstLOS');
	if (obj) {
		obj.value = arr[7];
	}
}

//CS Log 41685 - Default the estimate time based on primary operation
function SetEstTimeOp(str){
	//alert(str)
	ProcedureStr=str
	var arr = str.split("^");
	var obj = document.getElementById('RBOPEstimatedTime');
	if (obj) {
		obj.value = arr[3];
	} /*else {
		CalculateNewEstimatedTime;
	}*/
	var obj = document.getElementById('hidEstLOS');
	if (obj) {
		obj.value = arr[18];
	}
}

function CalculateNewEstimatedTime() {

}

function dateLookUp(str) {
	var lu = str.split("^");
	var obj = document.getElementById('RBOPRequestedDateOper')
	if (obj) obj.value=lu[0];
	var obj = document.getElementById('RBOPDateOper')
	if (obj) obj.value=lu[0];
	var obj = document.getElementById('RBOPResourceDR')
	if (obj) obj.value=lu[2];
	var obj = document.getElementById('RESCTLOCDR')
	if (obj) obj.value=lu[3];
	var obj = document.getElementById('RBOPRequestedTimeOper')
	if (obj) obj.value=lu[1];
	var obj = document.getElementById('RBOPTimeOper')
	if (obj) obj.value=lu[1];
	var obj = document.getElementById('LocationID')
	if (obj) obj.value=lu[9];
	var obj = document.getElementById('RescID')
	if (obj) obj.value=lu[8];
	//var obj = document.getElementById('SessionID')
	//if (obj) obj.value=lu[6];
	var obj = document.getElementById('LogicalDate')
	if (obj) obj.value=lu[7];
	var obj = document.getElementById('CPsSession')
	if (obj) obj.value=lu[11];
	datechange();
}

function dateLookUpB(str) {
	var lu = str.split("^");
	//alert(lu);
	var obj = document.getElementById('ApptDate')
	if (obj) obj.value=lu[0];
	var obj = document.getElementById('RBOPDateOper')
	if (obj) obj.value=lu[0];
	var obj = document.getElementById('RBOPResourceDR')
	if (obj) obj.value=lu[2];
	var obj = document.getElementById('RESCTLOCDR')
	if (obj) obj.value=lu[3];
	var obj = document.getElementById('ApptTime')
	if (obj) {
		obj.value=lu[1];
		//if (lu[17]=="") { obj.value=lu[1]; }
		//if (lu[17]!="") { DisableFieldVisiable('ApptTime'); }
	}
	var obj = document.getElementById('RBOPTimeOper')
	if (obj) obj.value=lu[1];
	var obj = document.getElementById('LocationID')
	if (obj) obj.value=lu[9];
	var obj = document.getElementById('RescID')
	if (obj) obj.value=lu[8];
	var obj = document.getElementById('SessionID')
	if (obj) obj.value=lu[6];
	//alert("session id " + lu[6] + " loc " + lu[9] + " res " + lu[8] );
	var obj = document.getElementById('LogicalDate')
	if (obj) obj.value=lu[7];
	var obj = document.getElementById('CPsSession')
	if (obj) obj.value=lu[11];
	var obj = document.getElementById('EstimatedSTime')
	if (obj) obj.innerHTML=lu[13];
	var obj = document.getElementById('nextAvailSeq')
	if (obj) obj.value=lu[14];
	var obj = document.getElementById('RBOPSequenceNo')
	if (obj) obj.value=lu[14]

	var obj = document.getElementById('RBOPSurgeonDR')
	if (obj) obj.value=lu[15];
	var obj = document.getElementById('RBOPAnaesthetistDR')
	if (obj) obj.value=lu[16];
	//
	var obj = document.getElementById('SchedID')
	if (obj) obj.value=lu[17];
	var obj = document.getElementById('VFTime')
	if ((obj)&&(lu[17])) { obj.value=lu[18]; }
	var obj = document.getElementById('VTTime')
	if ((obj)&&(lu[18]))  { obj.value=lu[19]; }
	var obj = document.getElementById('VNAID')
	if ((obj)&&(lu[19]))  { obj.value=lu[20]; }
	DisableField("VFTime");
	DisableField("VTTime");
	//
	datechangeb();
}

function resourceLookUp(str) {
	var lu = str.split("^");
	//alert(str);
	var obj = document.getElementById('RESCTLOCDR')
	if (obj) obj.value=lu[3];
	var obj = document.getElementById('LocationID')
	if (obj) obj.value=lu[4];
	var obj = document.getElementById('RBOPResourceDR')
	if (obj) obj.value=lu[0];
	var obj = document.getElementById('RescID')
	if (obj) obj.value=lu[2];

}

function resourcechange() {
	var obj = document.getElementById('RBOPResourceDR')
	if ((obj)&& (obj.value=="")){
		var obj = document.getElementById('RescID')
		if (obj) obj.value="";
	}
}

function locationchange() {
	var obj = document.getElementById('RESCTLOCDR')
	if ((obj)&& (obj.value=="")){
		// This is being done so that we can look up resources with the same name but different locations
		var obj = document.getElementById('RescID')
		if (obj) obj.value="";
		var obj = document.getElementById('LocationID')
		if (obj) obj.value="";
	}
}

function datechange() {
	//alert("datechange()");
	var RequestDateChange = document.getElementById('RequestDateChange')
	if (RequestDateChange){RequestDateChange.value="Y"}
	var obj1 = document.getElementById('RBOPRequestedDateOper')
	if ((obj1)&& (obj1.value=="")){
		// This is being done so that we can look up resources with the same name but different locations
		obj1.className="clsRequired";
		var obj = document.getElementById('RBOPRequestedTimeOper')
		if (obj) obj.value="";
		var obj = document.getElementById('LogicalDate')
		if (obj) obj.value="";
		var obj = document.getElementById('ApptDate')
		if (obj)  {
			obj.className="clsRequired";
			obj.disabled=false;
			var obj2=document.getElementById('ld585iApptDate');
			if (obj2) obj2.disabled=false;
			var obj3=document.getElementById('cApptDate')
			if (obj3) obj3.className="clsRequired";
		}
		var obj = document.getElementById('ApptTime')
		if (obj) {
			obj.className="clsRequired";
			obj.disabled=false;
			var obj2=document.getElementById('cApptTime')
			if (obj2) obj2.className="clsRequired";
		}
		var obj = document.getElementById('RBOPSequenceNo')
		if (obj)  {
			obj.className="";
			obj.disabled=false;
		}
	}
	if ((obj1)&& (obj1.value!="")){
		//alert("datechangeb() not blank");
		var obj = document.getElementById('ApptDate')
		if (obj)  {
			obj.className="disabledField";
			obj.disabled=true;
			var obj2=document.getElementById('ld585iApptDate');
			if (obj2) obj2.disabled=true;
			var obj3=document.getElementById('cApptDate')
			if (obj3) obj3.className="";
		}
		var obj = document.getElementById('ApptTime')
		if (obj) {
			obj.className="disabledField";
			obj.disabled=true;
			var obj2=document.getElementById('cApptTime')
			if (obj2) obj2.className="";
		}
		var obj = document.getElementById('RBOPSequenceNo')
		if (obj)  {
			obj.value="";
			obj.className="disabledField";
			obj.disabled=true;
		}
	}
}

function timechange() {
	var obj=document.getElementById('RBOPRequestedTimeOper')
	if ((obj)&&(obj.value=="")) obj.className="clsRequired";
}

function datechangeb() {
	//alert("datechangeb()");
	var ApptDateChange = document.getElementById('ApptDateChange')
	if (ApptDateChange){ApptDateChange.value="Y"}
	var obj1 = document.getElementById('ApptDate')
	if ((obj1)&& (obj1.value=="")){
		// This is being done so that we can look up resources with the same name but different locations
		obj1.className="clsRequired";
		var obj = document.getElementById('SessionID')
		if (obj) obj.value="";
		var obj = document.getElementById('ApptTime')
		if (obj) obj.value="";
		var obj = document.getElementById('LogicalDate')
		if (obj) obj.value="";
		var obj = document.getElementById('RBOPRequestedDateOper')
		if (obj)  {
			obj.className="clsRequired";
			obj.disabled=false;
			obj2=document.getElementById('ld585iRBOPRequestedDateOper');
			if (obj2) obj2.disabled=false;
			var obj3=document.getElementById('cRBOPRequestedDateOper')
			if (obj3) obj3.className="clsRequired";
		}
		var obj = document.getElementById('RBOPRequestedTimeOper')
		if (obj) {
			obj.className="clsRequired";
			obj.disabled=false;
			var obj2=document.getElementById('cRBOPRequestedTimeOper')
			if (obj2) obj2.className="clsRequired";
		}

		//48543 Chandana 16/2/05 - Set Estimated Start Time to blank
		var obj = document.getElementById('EstimatedSTime');
		if (obj) obj.innerHTML="";
	}
	if ((obj1)&& (obj1.value!="")){
		//alert("datechangeb() not blank");
		var obj = document.getElementById('RBOPRequestedDateOper')
		if (obj)  {
			obj.className="disabledField";
			obj.disabled=true;
			var obj2=document.getElementById('ld585iRBOPRequestedDateOper');
			if (obj2) obj2.disabled=true;
			var obj3=document.getElementById('cRBOPRequestedDateOper')
			if (obj3) obj3.className="";
		}
		var obj = document.getElementById('RBOPRequestedTimeOper')
		if (obj) {
			obj.className="disabledField";
			obj.disabled=true;
			var obj2=document.getElementById('cRBOPRequestedTimeOper')
			if (obj2) obj2.className="";
		}
	}
	//md
	var obj= document.getElementById('RBOPSurgeonDR');
	var obj1=document.getElementById('RBOPOperDepartmentDR');
	var obj2=document.getElementById('RBOPAnaesthetistDR');
	if ((obj)&&(obj.value!="")&&(obj1)&&(obj1.value=="")) {
		obj.onchange();
	}
	if ((obj2)&&(obj2.value!="")&&(obj1)&&(obj1.value=="")) {
		obj2.onchange();
	}

	var obj=document.getElementById('VNAID');
	if ((obj)&&(obj.value!="")) {
	var obj1 = document.getElementById('cPSTime')
	var obj2 = document.getElementById('PSTime')
		if ((obj1)&&(obj2)) {
			obj1.className="clsRequired";
			obj2.className="clsRequired";
			}
	var obj1 = document.getElementById('cPETime')
	var obj2 = document.getElementById('PETime')
		if ((obj1)&&(obj2)) {
			obj1.className="clsRequired";
			obj2.className="clsRequired";
			}
	}

	//md
}

function timechangeb() {
	var obj=document.getElementById('ApptTime')
	if ((obj)&&(obj.value=="")) obj.className="clsRequired";
}

function RBOperatingRoom_ChangeStatusHandler() {
	var obj= document.getElementById('ID');
	if((obj)&&(obj.value!="")) {
			websys_createWindow('websys.default.csp?WEBSYS.TCOMPONENT=RBOperatingRoom.ChangeStatus&ID='+obj.value,'Prompt','top=0,left=0,width=400,height=400');
		}
}

function ResourceTextChangeHandler() {
	//SB 12/06/02: This function is called from RBResource.LookUpBrokerRes, as the onchange handler overwrites the broker method.
	//BR 31/07/03: This function doesn't do anything on this page, but needs to be hear as the broker calls it.
}

function RBOPOperDepartmentLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('RBOPOperDepartmentDR');
	if (obj) obj.value=lu[1];
	var obj=document.getElementById('RBOPOperDepartmentID');
	if (obj) obj.value=lu[3];

}
function RBOPOperDepartmentBlurHandler(e) {
	//alert("LocTextBlurHandler");
	var eSrc=websys_getSrcElement(e)
	if (eSrc && eSrc.value=="") {
		var obj=document.getElementById('RBOPOperDepartmentID');
		if (obj) obj.value=""
	}
}

function RBOPRefDepSelector(str) {
	var lu = str.split("^");
	var obj=document.getElementById('RBOPRefDepDR');
	if (obj) obj.value=lu[1];
	var obj=document.getElementById('RBOPRefDepDRID');
	if (obj) obj.value=lu[3];

}
function RBOPRefDepDRBlurHandler(e) {
	//alert("LocTextBlurHandler");
	var eSrc=websys_getSrcElement(e)
	if (eSrc && eSrc.value=="") {
		var obj=document.getElementById('RBOPRefDepDRID');
		if (obj) obj.value=""
	}
}


function Init() {
	var obj=document.getElementById('DeleteProcedure');
	if (obj) obj.onclick=PROCDeleteClickHandler;
	var obj=document.getElementById('DeleteOperation');
	if (obj) obj.onclick=OPDeleteClickHandler;
	var obj=document.getElementById('DeleteEquip');
	if (obj) obj.onclick=EquipDeleteClickHandler;
	var check = document.getElementById("ProcedureListBoxChanged");
	check.value=0
	var check = document.getElementById("OperationListBoxChanged");
	check.value=0
	var check = document.getElementById("EquipmentListBoxChanged");
	check.value=0
	var obj=document.getElementById("PROCEntered");
	var obj1=document.getElementById("PROCDescString");
	if ((obj)&&(obj1)&&(obj1.value!="")) {
		PopulateListType(obj1.value,"PROCEntered")
	}
	var obj=document.getElementById("OPEntered");
	var obj1=document.getElementById("OPDescString");
	if ((obj)&&(obj1)&&(obj1.value!="")) {
		PopulateListType(obj1.value,"OPEntered")
	}
	var obj=document.getElementById("BookEquipList");
	var obj1=document.getElementById("EquipDescString");
	if ((obj)&&(obj1)&&(obj1.value!="")) {
		PopulateListType(obj1.value,"BookEquipList")
	}
	var readmitObj=document.getElementById("Readmit");
	var obj = document.getElementById('RBOPRequestedDateOper')
	if (obj) obj.className="clsRequired";
	var obj = document.getElementById('cRBOPRequestedDateOper')
	if (obj) obj.className="clsRequired";
	var obj = document.getElementById('RBOPRequestedTimeOper')
	if (obj) obj.className="clsRequired";
	var obj = document.getElementById('cRBOPRequestedTimeOper')
	if (obj) obj.className="clsRequired";
	var obj = document.getElementById('ApptDate')
	if (obj) obj.className="clsRequired";
	var obj = document.getElementById('cApptDate')
	if (obj) obj.className="clsRequired";
	var obj = document.getElementById('ApptTime')
	if (obj) obj.className="clsRequired";
	var obj = document.getElementById('cApptTime')
	if (obj) obj.className="clsRequired";
}


function AddItemToList(list,code,desc) {
	//Add an item to a listbox
	code=String.fromCharCode(2)+code
	//
	list.options[list.options.length] = new Option(desc,code);
}

function RemoveFromList(obj) {
	//alert("RemoveFromList");
	for (var i=(obj.length-1); i>=0; i--) {
		if (obj.options[i].selected)
			obj.options[i]=null;
	}
}




//Procedures

function UpdateProcedures(lista,hiddenfield,lbchange) {
	//alert("update");
	var arrItems = new Array();
	var lst = document.getElementById(lista);
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			arrItems[j] = lst.options[j].text+lst.options[j].value;
		}
		var el = document.getElementById(hiddenfield);
		if (el) el.value = arrItems.join(String.fromCharCode(1));
		//alert(el.value);
		var check = document.getElementById(lbchange);
		check.value=1

	}
}

function PROCDeleteClickHandler() {
	//alert("PROCDeleteClickHandler 1");
	ProcedureDeleteClickHandler("PROCEntered")
	//alert("PROCDeleteClickHandler 2");
}

function OPDeleteClickHandler() {
	ProcedureDeleteClickHandler("OPEntered")
}

function EquipDeleteClickHandler() {
	ProcedureDeleteClickHandler("BookEquipList")
}

function ProcedureDeleteClickHandler(lista) {
	//alert("ProcedureDeleteClickHandler 1 "+lista);
	var obj=document.getElementById(lista)
	if (obj) {
		//alert("ProcedureDeleteClickHandler 2 "+lista);
		RemoveFromList(obj);
		if (lista=="PROCEntered"){hiddenfield="PROCDescString";lbchange="ProcedureListBoxChanged"}
		if (lista=="OPEntered"){hiddenfield="OPDescString";lbchange="OperationListBoxChanged"}
		if (lista=="BookEquipList"){hiddenfield="EquipDescString";lbchange="EquipmentListBoxChanged"}
		UpdateProcedures(lista,hiddenfield,lbchange);
	}
	return false;
}

function ProcLookup(txt) {
	ProcedureLookupSelect(txt,"PROCEntered","PROCDesc")
}

function OPLookup(txt) {
	ProcedureLookupSelect(txt,"OPEntered","OPDesc")
}

function EquipLookup(txt) {
	//alert(txt);
	ProcedureLookupSelect(txt,"BookEquipList","BookEquip")
}

function ProcedureLookupSelect(txt,lista,field) {
	//Add an item to ALGEnetered when an item is selected from
	//the Lookup, then clears the Item text field.
	var adata=txt.split("^");
	//alert("adata 1="+adata);
	var obj=document.getElementById(lista)

	if (obj) {
		//Need to check if Procedure already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == String.fromCharCode(2)+adata[1]) {
				alert("Item has already been selected");
				var obj=document.getElementById(field)
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
				alert("Item has already been selected");
				var obj=document.getElementById(field)
				if (obj) obj.value="";
				return;
			}
			//alert(obj.options[i].value+"****"+adata[1])
		}
	}
	if (obj) AddItemToList(obj,adata[1],adata[0]);

	var obj=document.getElementById(field)
	if (obj) obj.value="";
	if (lista=="PROCEntered"){hiddenfield="PROCDescString";lbchange="ProcedureListBoxChanged"}
	if (lista=="OPEntered"){hiddenfield="OPDescString";lbchange="OperationListBoxChanged"}
	if (lista=="BookEquipList"){hiddenfield="EquipDescString";lbchange="EquipmentListBoxChanged"}
	UpdateProcedures(lista,hiddenfield,lbchange);
	//alert("adata 2="+adata);
}

function PopulateListType(str,lista){
	//alert(str)
	var obj=document.getElementById(lista)
	if (obj) {
		var selections=str.split(String.fromCharCode(1));
		for (var jj=0;jj<selections.length;jj++) {
			var selection=selections[jj].split(String.fromCharCode(2));
			AddItemToList(obj,selection[1],selection[0]);
		}
	}
}

function UpdateClickHandler(){
	//alert("update surg:"+ document.getElementById("SurgChanged").value + ": anae:" + document.getElementById("AnaeChanged").value + ":");
	//EZ 2/04 log 62735 start
		var objPAAdmLoc=document.getElementById('PAAdmLoc');

		var objRBOpDep=document.getElementById('RBOPOperDepartmentID');


		if ((objPAAdmLoc.value!="")&&(objPAAdmLoc.value!=objRBOpDep.value)) {

			var msg=t["RBOPCTLocDesc"]

			if (confirm(msg)) {
				//alert ('ok pressed')
				//if ok then episodeID, piece 4 = objRBOpDep.value
				var obj=document.getElementById('PAAdmOverride');
				obj.value=1
			}
			else {
			// if cancel then make episodeID blank thus when continue, the new episode will be created
			var objE=document.getElementById('EpisodeID');
			objE.value=""
			}

		}
	//	alert(objPAAdmLoc.value+ ' '+objRBOpDep.value)
	//	return false;
	//finish log 62735
	var objOpSeq=document.getElementById("RBOPSequenceNo")
	if (objOpSeq) {
		var objNextSeq=document.getElementById("nextAvailSeq")
		if (parseInt(objOpSeq.value) > parseInt(objNextSeq.value)) {
			alert(t["SeqNoExceeded"]+" ("+objNextSeq.value+")")
			objOpSeq.value=objNextSeq.value
			return false;
		}
	}
	var RBOPReasForRet=document.getElementById('RBOPReasForRet');
	if ((RBOPReasForRet)) {
		if ((RBOPReasForRet.className=="clsRequired")&&(RBOPReasForRet.value=="")) {
			alert("\'"+t['RBOPReasForRet']+"\' "+t["XMISSING"]);
			return false;
		}
	}
	var reqDate = document.getElementById('RBOPRequestedDateOper')
	var reqTime = document.getElementById('RBOPRequestedTimeOper')
	if ((reqDate)&&(reqTime)) {
		if (((reqDate.className=="clsRequired")&&(reqDate.value==""))||((reqTime.className=="clsRequired")&&(reqTime.value==""))) {
			alert("Request "+t['DateTimeInvalid']);
			return false;
		}
	}
	var bookDate = document.getElementById('ApptDate')
	var bookTime = document.getElementById('ApptTime')
	if ((bookDate)&&(bookTime)) {
		if (((bookDate.className=="clsRequired")&&(bookDate.value==""))||((bookTime.className=="clsRequired")&&(bookTime.value==""))) {
			alert("Booking "+t['DateTimeInvalid']);
			return false;
		}
	}
	//md
	//
	var Pstime = document.getElementById('cPSTime');
	var Petime = document.getElementById('cPETime');
	var Pstime2 = document.getElementById('PSTime');
	var Petime2 = document.getElementById('PETime');
	if ((Pstime )&&(Petime)&&(Pstime )&&(Petime)) {
		if (((Pstime.className=="clsRequired")&&(Pstime2.value=="")&&(Pstime2.disabled!=true))||((Petime.className=="clsRequired")&&(Petime2.value=="")&&(Petime2.disabled!=true))) {
			alert("Procedure "+t['DateTimeInvalid']);
			return false;
		}
	}
	//
	var  OPEstimatedTime= document.getElementById('RBOPEstimatedTime')
	var  MaxOperatingTime = document.getElementById('MaxOperatingTimeMins')
	if ((OPEstimatedTime)&&(OPEstimatedTime.value!="")&&(MaxOperatingTime)&&(MaxOperatingTime.value!="")) {
		//if (OPEstimatedTime.value>MaxOperatingTime.value) {
		if (parseInt(OPEstimatedTime.value)>parseInt(MaxOperatingTime.value)) {

			alert(t['RBOPEstimatedTime']+" "+t['MaxOpTime']);
			return false;
		}
	}

	//md
	SetHEstTime();
	if (!ReVacantOnUpdate()) return false;

	ECurrentIP();
	return update1_click()
}

function ReVacantOnUpdate() {

	var eSrc=websys_getSrcElement(e);
	var vft=document.getElementById("VFTime");
	var vet=document.getElementById("VTTime");
	var pst=document.getElementById("PSTime");
	var pet=document.getElementById("PETime");
	var esttime=document.getElementById("RBOPEstimatedTime");
	var bookdate=document.getElementById("ApptDate");
	var objtotalnap=document.getElementById("upvacant");
	var initnaperiod=""
	var scndnaperiod=""
	var cnt=0

	if ((vft)&&(vft.value!="")&&(vet)&&(vet.value!="")&&(totalnap==""))
	{
		if ((pst)&&(pst.value!="")&&(TimeStringCompare(pst.value,vft.value)!="0")) { initnaperiod=vft.value+"-"+pst.value;	 }
		if ((pet)&&(pet.value!="")&&(TimeStringCompare(pet.value,vet.value)=="-1")) { scndnaperiod=pet.value+"-"+vet.value; }
		if ((initnaperiod!="")||(scndnaperiod!=""))
		{
		var  msg=t["VacantTimes1"]+"\n"

		if  (initnaperiod!="")	{
		totalnap=initnaperiod;
		cnt=cnt+1;
		msg=msg+cnt+"."+initnaperiod+"\n"
						}
		if  (scndnaperiod!="") {
		if (totalnap!="") totalnap=totalnap+"@"+scndnaperiod
		if (totalnap=="") totalnap=scndnaperiod
		cnt=cnt+1;
		msg=msg+cnt+"."+scndnaperiod+"\n"
					      }
		msg=msg+t["VacantTimes2"]
			if (!confirm(msg)) {
			totalnap=""
			return false;
			}

		}
	if ((esttime)&&(bookdate)&&(bookdate.value!="")) {
	var diff=DateTimeDiffInHMStr(bookdate.value,pst.value,bookdate.value,pet.value);
	esttime.value=parseInt((diff.split(":")[0]*60))+parseInt((diff.split(":")[1]));
	}
	if (objtotalnap) { objtotalnap.value=totalnap }
	//alert(totalnap);
	//return false;
	return true;
}
	//alert(totalnap);
	//return false;
	return true;



}

function RBOPSurgeonLookupSelect(str) {
 	var lu = str.split("^");
	var obj=document.getElementById("RBOPOperDepartmentDR");
	if ((obj)&&(lu[2]!="")) obj.value=lu[2];
	var obj=document.getElementById('RBOPOperDepartmentID');
	if ((obj)&&(lu[4]!="")) obj.value=lu[4];

}

function RBOPAnaesthetistLookupSelect(str) {
 	var lu = str.split("^");
	var obj=document.getElementById("RBOPAnaestCode");
	if ((obj)&&(lu[2]!="")) obj.value=lu[2];
}

function CheckVacantTime(e) {

	var eSrc=websys_getSrcElement(e);
	if (eSrc.id=="PSTime") {PSTime_changehandler(e);}
	if (eSrc.id=="PETime") {PETime_changehandler(e);}
	var vft=document.getElementById("VFTime");
	var vet=document.getElementById("VTTime");
	var pst=document.getElementById("PSTime");
	var pet=document.getElementById("PETime");

	if ((vft)&&(vft.value!="")&&(vet)&&(vet.value!=""))
	{
	if ((pst)&&(pst.value!="")&&((TimeStringCompare(pst.value,vft.value)=="-1")||(TimeStringCompare(pst.value,vet.value)=="1")))
	{
	alert(t[eSrc.id] + " " + t["XINVALID"]);
  	pst.value = "";
    	websys_setfocus(eSrc.id);
	return false;
	}
	//if ((pet)&&(pet.value!="")&&((TimeStringCompare(pet.value,vft.value)=="-1")||(TimeStringCompare(pet.value,vet.value)=="1")))
	if ((pet)&&(pet.value!="")&&(TimeStringCompare(pet.value,vet.value)=="1"))
	{
	if (!confirm(t[eSrc.id] + " " + t["Biggerthen"])) {
		pet.value = "";
		websys_setfocus(eSrc.id);
		return false;
		}
	}
	if ((pst)&&(pst.value!="")&&(pet)&&(pet.value!="")&&(TimeStringCompare(pst.value,pet.value)=="1"))
	{
	alert(t[eSrc.id] + " " + t["XINVALID"]);
  	document.getElementById(eSrc.id).value = "";
    	websys_setfocus(eSrc.id);
	return false;
	}
	return true;
}

	return true;
}

function SetHEstTime() {

	var obj=document.getElementById("HEstimatedSTime");
	var obj1=document.getElementById("EstimatedSTime");
	if ((obj)&&(obj1)) {
	obj.value=obj1.innerText;
	//alert(obj.value);

	}


}

function ECurrentIP() {
	var objE=document.getElementById('EpisodeID');
	var objECIP=document.getElementById('PrevIPEpisodeID');
	if ((objE)&&(objE.value=="")&&(objECIP)&&(objECIP.value!="")){
	objE.value=objECIP.value;
	if(!confirm(t['LinkToECurrentIP'])) { objE.value="" }
	objECIP.value="";
	}


}

function checkWLDefaults() {
	var objWLAdm=document.getElementById('WLAdmID');
	var objWlDef=document.getElementById('WLDefault');
	if ((objWLAdm)&&(objWLAdm.value!="")&&(objWlDef)&&(objWlDef.value!=""))
	{
	///Oper_"^"_Careprov_"^"_procstr_"^"_sppp_"^"_anaestmeth_"^"_dateoper_"^"_Remark_"^"_ProcRemark
	var lu=objWlDef.value.split("^");
	var objOper=document.getElementById('RBOPOperationDR');
	if (objOper) objOper.value=lu[0];
	var objsurg=document.getElementById('RBOPSurgeonDR');
	if (objsurg) objsurg.value=lu[1];
	var obj1=document.getElementById('OPDescString');
	if (obj1) obj1.value=lu[2];
	var obj=document.getElementById("OPEntered");
	if ((obj)&&(obj1)&&(obj1.value!="")) {
		PopulateListType(obj1.value,"OPEntered")
	}
	var objSPPP=document.getElementById('RBOPStatePPPDR');
	if (objSPPP) objSPPP.value=lu[3];
	var objAnaestMthd=document.getElementById('RBOPAnaestMethodDR');
	if (objAnaestMthd) objAnaestMthd.value=lu[4];
	var objBookDate=document.getElementById('ApptDate');
	if (objBookDate) objBookDate.value=lu[5];
	var objRemark=document.getElementById('RBOPRemarks');
	if (objRemark) objRemark.value=lu[6];
	var objProc=document.getElementById('RBOPProcsOpers');
	if (objProc) objProc.value=lu[7];
	var objdep=document.getElementById('RBOPOperDepartmentDR');
	if (objdep) objdep.value=lu[9];
	var objdepid=document.getElementById('RBOPOperDepartmentID');
	if (objdepid) objdepid.value=lu[8];

	}

}

document.body.onload = DocumentLoadHandler;