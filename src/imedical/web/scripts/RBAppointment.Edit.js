// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var bReload=0;
var VIEWABLE_CLICK;
var TRANSVAR_CLICK;
var objCheck=0;

function DocumentLoadHandler() {
	//if (self==top) websys_reSize();
	InitDefaults();

	TransferAndStatus();

	//Log 38652 BC 9-9-2003 Time validation
	var starttimeobj=document.getElementById('APPTSeenTime');
	var endtimeobj=document.getElementById('APPTEndTime');
	if (starttimeobj) starttimeobj.onblur=checkStartEndTime;
	if (endtimeobj) endtimeobj.onblur=checkStartEndTime;

	//Log 41901 BC 22-1-2004 More Date&Time validation
	var seendateobj=document.getElementById('APPTSeenDate');
	//if (seendateobj) seendateobj.onblur=checkSeenDate
	//md when using calander will be fine
	if (seendateobj) seendateobj.onchange=SEENDateChanger;

	//LOG 25630 BC 25-10-02
	var obj =document.getElementById("OUTCDesc");
	var linkobj=document.getElementById("Outcomes");
	if (obj&&obj.value!="") {
		var Outcometext=obj.value;
		var PARREFobj=document.getElementById("ApptID");
		var objOutComeLUp=document.getElementById('ld597iOUTCDesc')
		if (objOutComeLUp) {
			var killed=objOutComeLUp.removeNode(false);
		}
		var outerobj=obj.parentElement
		if (!linkobj) {
			var newHTML="<A id=OUTDesc name=OUTDesc HREF="+'"'+"#"+'"'+" onClick="+'"'+"websys_lu('websys.default.csp?WEBSYS.TCOMPONENT=RBApptOutcome.List&PARREF="+PARREFobj.value+"',false,'top=30,left=20');"+'"'+" tabIndex="+'"'+0+'"'+" >"+'<img SRC="../images/websys/edit.gif" BORDER="0">'+Outcometext+'</A>';
		} else {
			// Ready for W65
			//var newHTML="<label id=OUTDesc name=OUTDesc value="+Outcometext+"><h5>"+Outcometext+"</h5></label>";
			var newHTML="<label id=OUTDesc name=OUTDesc value="+Outcometext+">"+Outcometext+"</label>";
			linkobj.style.fontWeight="bold"
		}
		killed=obj.removeNode(false);
		if (outerobj) {
			outerobj.innerHTML=newHTML;
			//alert(outerobj);
			//outerobj.className="CellData";
		}
	} else if (linkobj) {
		linkobj.disabled=true;
		linkobj.onclick=LinkDisable;
	}
	/*obj =document.getElementById("anyCorrespond")
	linkobj=document.getElementById("Correspondence");
	if (obj&&obj.value==0) {
		if (linkobj) {
			linkobj.disabled=true;
			linkobj.onclick=LinkDisable;
		}
	}
	obj =document.getElementById("anyReports")
	linkobj=document.getElementById("RequestedReportHistory");
	if (obj&&obj.value==0) {
		if (linkobj) {
			linkobj.disabled=true;
			linkobj.onclick=LinkDisable;
		}
	}*/

	obj =document.getElementById("procedure")
	linkobj=document.getElementById("Procedures");
	if (obj&&obj.value!="") {
		var Proceduretext=obj.value;
		var Apptobj=document.getElementById("ApptID");
		PARREFobj=document.getElementById("PAADMMainMRADMDR");
		var objProcLUp=document.getElementById('ld597iprocedure')
		if (objProcLUp) {
			var killed=objProcLUp.removeNode(false);
		}
		var outerobj=obj.parentElement
		if (!linkobj) {
			var newHTML="<A id=procedure name=procedure HREF="+'"'+"#"+'"'+" onClick="+'"'+"websys_lu('websys.default.csp?WEBSYS.TCOMPONENT=MRProcedures.ListByAppointment&PARREF="+PARREFobj.value+"&ApptID="+Apptobj.value+"',false,'top=30,left=20');"+'"'+" tabIndex="+'"'+0+'"'+" >"+'<img SRC="../images/websys/edit.gif" BORDER="0">'+Outcometext+'</A>';
		} else {
			// Ready for W65
			//var newHTML="<label id=procedure name=procedure value="+Proceduretext+"><h5>"+Proceduretext+"</h5></label>";
			var newHTML="<label id=procedure name=procedure value="+Proceduretext+">"+Proceduretext+"</label>";
			linkobj.style.fontWeight="bold"
		}
		killed=obj.removeNode(false);
		if (outerobj) {
			outerobj.innerHTML=newHTML;
			//outerobj.className="CellData";
		}
	} else if (linkobj) {
		linkobj.disabled=true;
		linkobj.onclick=LinkDisable;
	}
	var obj = document.getElementById('APPTSeenDoctorDesc');
	if (obj) obj.onblur=SeenByCPChange;
	//LOG 31317 BC 26-2-2003 Moved to RBAppointmentframe.csp so it works with only booked appointments and with bulk transfer
	//obj =document.getElementById("TRANSFER")
	//if (obj) obj.onclick=TransferClickEvent;
	//obj =document.getElementById("ChangeStatus")
	//if (obj) obj.onclick=ChangeStatClickEvent;
	//alert(obj.innerText)
	var obj=document.getElementById("ViewableBy");
	if (obj) VIEWABLE_CLICK=obj.onclick;
	CheckBoldOrHidden();
	// set the original link to a temp variable, then can enable/disable
	SetViewableLink();
	var obj=document.getElementById("APPTViewablebyEpCareProv");
	if (obj) obj.onclick=SetViewableLink;

	obj =document.getElementById("update1")
	if (obj) obj.onclick=UpdateClickHandler;

	obj=document.getElementById('APPTArrivalTime');
	if (obj) obj.onblur = ArrivalTimeBlurHandler;
	objT =document.getElementById("TRANSFER")
	objS =document.getElementById("StatusCode")
	objTF=document.getElementById("Transferable")

	if (objT && objS && objTF) {
		if ((objS.value=="T") || (objS.value=="X") || (objS.value=="A") || (objTF.value!=1)) {
			objT.disabled=true
			objT.onclick="";
		}
	}
}

function ArrivalTimeBlurHandler() {
	var objArr=document.getElementById('APPTArrivalTime');
	var objHid=document.getElementById('ApptTime');
	var DateAppt=document.getElementById("ApptDate").value;
	var DateNow=document.getElementById("LogicalDate").value;
	var aryID=document.getElementById("ApptID").value;
	var arySt=document.getElementById("StatusCode").value;
	var message=validateStatusChange("A",DateAppt,DateNow,aryID,arySt);
	if ((message!="")&&(objArr.value!="")) {
		document.getElementById("APPTArrivalTime").value="";
		alert(message);
		return false;
	}
	if ((objArr)&&(objHid)) objHid.value=objArr.value;
	return true;
}

function TransferAndStatus() {
	var objT =document.getElementById("TRANSFER")
	var obj = document.getElementById('APPTReasonForTransferDR')
	var objlu = document.getElementById('ld597iAPPTReasonForTransferDR')
	var objS =document.getElementById("StatusCode");
	if ((objT)&&((!obj)||(obj.value==""))) {
		TRANSVAR_CLICK=objT.onclick
		objT.disabled=true;
		objT.onclick=LinkDisable;
	}
	if (obj) obj.onblur=checktransreason;
	if ((obj)&&(objlu)&&(objS)) {
		if ((objS.value=="A")||(objS.value=="S")||(objS.value=="X")||(objS.value=="N")) {
			obj.disabled=true;
			obj.className = "disabledField";
			objlu.disabled=true;
			obj.onblur="";
			if (objT) {
				TRANSVAR_CLICK=objT.onclick
				objT.disabled=true;
				objT.onclick=LinkDisable;
			}
		}
	}
}

function checktransreason() {
	var obj = document.getElementById('APPTReasonForTransferDR')
	var objT =document.getElementById("TRANSFER");
	var objS =document.getElementById("StatusCode");
	var objTF=document.getElementById("Transferable");
	//alert("lookup");
	if (obj.value!="") {
		if (objT && objS && objTF) {
			//alert(objS.value);
			if ((objS.value=="T") || (objS.value=="C") || (objTF.value!=1)) {
				//alert("Disable 1");
				objT.disabled=true;
				objT.onclick=LinkDisable;
			}  else {
				//alert("enable");
				objT.disabled=false;
				objT.onclick=TRANSVAR_CLICK;
			}
		}
	}else {
		//alert("Disable 2");
		objT.disabled=true;
		objT.onclick=LinkDisable;
	}
}

function UpdateClickHandler() {
	bReload=1
	return update1_click();
}

function TransReason(str) {
	checktransreason();
}

function TransferClickEvent() {
	obj =document.getElementById("TRANSFER")
	var reasonobj = document.getElementById('APPTReasonForTransferDR');
	if (reasonobj) APPTReasonForTransferDR= reasonobj.value;
	//Log 27179 07/08/02 BR
	var linkAppt=document.getElementById('LinkedAppts');
	if (linkAppt && linkAppt.value=="Y") {
		var conf=confirm(t['LinkedAppts']);
		if (!conf) linkAppt.value="N";
	}
	if (obj) {
		obj.href=obj.href+"&APPTReasonForTransferDR="+APPTReasonForTransferDR+"&LinkedAppts="+linkAppt.value;
	}
	if (obj) {
		if (obj.disabled) {
			return false;
		}
	//alert (obj.href);
	}
	return true;
}


function ChangeStatClickEvent() {
	obj =document.getElementById("ChangeStatus")
	if (obj) {
		if (obj.disabled) {
			return false;
		}
	}
	return true;
}

function InitDefaults() {
	var obj=document.getElementById('ASDate')
	var ap=document.getElementById("AppPast");
	//alert(obj.innerText)
	var asdate=DateStringToArray(obj.innerText)
	if ((obj)&&(obj.value!="")) {
		var dtAppt = new Date(asdate["yr"], asdate["mn"]-1, asdate["dy"]);
		var tydate = new Date()
		tydate.setHours(0)
		tydate.setMinutes(0)
		tydate.setSeconds(0)
		tydate=Date.parse(tydate)
		dtAppt=Date.parse(dtAppt)
		if ((dtAppt < tydate) && ((ap)&&(ap.value=="N"))) {
			makeReadOnly()
		}
	}
	var obj=document.getElementById("CLNAddress1");
	if (obj) obj.disabled=true;
	var obj=document.getElementById("CLNPhone");
	if (obj) obj.disabled=true;
}

function makeReadOnly() 	{

	var el=document.forms["fRBAppointment_Edit"].elements;
	for (var i=0;i<el.length;i++) {
			if (!(el[i].type=="hidden"))  {
			el[i].disabled=true
			}
		}
	var arrLookUps=document.getElementsByTagName("IMG");
	for (var i=0; i<arrLookUps.length; i++) {
			if ((arrLookUps[i].id)&&(arrLookUps[i].id.charAt(0)=="l"))
			arrLookUps[i].disabled=true;
		}

	var obj=document.getElementById('update1');
	if (obj) obj.disabled=false


}

function HRGBlurHandler(e) {
	var eSrc=websys_getSrcElement(e)
	if (eSrc && eSrc.value=="") {
		var obj=document.getElementById('HRGDesc');
		if (obj) obj.value=""
	}
}

function HRGLookUp(str) {
	var lu = str.split("^");
	var obj = document.getElementById('HRGDesc')
	if (obj) obj.value=lu[1];
	var obj = document.getElementById('APPTHRGDR')
	if (obj) obj.value=lu[1];
}

function RevPerLookUp(str) {
	//SB 25/06/02 (25857): This lookup seems to work better without this code.
	//var lu = str.split("^");
	//alert(str)
	//var obj = document.getElementById('APPTReviewPeriodDR')
	//if (obj) obj.value=lu[1];
}

function SetViewableLink() {
	var objFlag=document.getElementById("APPTViewableByEpCareProv");
	var objLink=document.getElementById("ViewableBy");
	if ((objLink)&&((!objFlag)||((objFlag)&&(objFlag.checked==false)))) {
		objLink.disabled=true;
		objLink.onclick=LinkDisable;
		objCheck=0;
	}
	if ((objLink)&&(objFlag)&&(objFlag.checked==true)) {
		objLink.disabled=false;
		objLink.onclick=VIEWABLE_CLICK;
		objCheck=1;
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

function CheckBoldOrHidden() {
	var objFlag=document.getElementById("APPTViewableByEpCareProv");
	var objLink=document.getElementById("ViewableBy");
	var objBold=document.getElementById("BoldLinks");
	if ((objLink) && ((objBold) && (objBold.value=="1"))) {
		objLink.style.fontWeight="bold";
		if (objCheck==1) {
			objFlag.checked=true;
		}
	}
}

//LOG 31174 BC 10-12-2002

function SeenByCPLookUp(str) {
	var lu = str.split("^");
	var obj = document.getElementById('APPTSeenDoctorDesc')
	if (obj) obj.value=lu[0];
	var obj = document.getElementById('APPTSeenDoctorDR')
	if (obj) obj.value=lu[1];
	//alert(lu[2]);
	//LOG 25630 BC 7-1-2003
	var obj = document.getElementById('CTCPTDesc')
	if (obj) obj.value=lu[4];
	//alert(lu[3]);
	//alert(str);
}

function SeenByCPChange() {
	//alert("SeenByCPChange");
	var dobj = document.getElementById('APPTSeenDoctorDesc');
	var drobj = document.getElementById('APPTSeenDoctorDR');
	var CPTobj = document.getElementById('CTCPTDesc')
	if ((dobj)&&(dobj.value=="")&&(drobj)) drobj.value="";
	//LOG 25630 BC 7-1-2003
	if ((dobj)&&(dobj.value=="")&&(CPTobj)) CPTobj.value="";

}


// End Log 31174

function DocumentUnloadHandler() {
	if (bReload==1) {
		// SB 19/04/02: Do not change the following line of code without asking me first.
		// SB 01/05/02: Modified.
		if (top.window.opener.top.frames["TRAK_main"]) {
			top.window.opener.top.frames["TRAK_main"].treload('websys.csp')
		} else {
			if (window.opener) window.opener.treload('websys.csp')
		}
	}
	websys_closeWindows();
}

//Log 38652 BC 9-9-2003 Time validation
function checkStartEndTime() {
	var starttimeobj=document.getElementById('APPTSeenTime');
	//var startdateobj=document.getElementById('APPTSeenDate');
	//var enddateobj=document.getElementById('APPTEndDate');
	var endtimeobj=document.getElementById('APPTEndTime');
	if ((starttimeobj)&&(endtimeobj)) {
		if ((starttimeobj.value!="")&&(endtimeobj.value!="")) {
			var timed=TimeStringCompare(starttimeobj.value,endtimeobj.value)
			if (timed>0) {
				alert(t['APPTEndTime']+" "+t['MustBeAfter']+" "+t['APPTSeenTime']);
				starttimeobj.className="clsInvalid";
				endtimeobj.className="clsInvalid";
				return;
			}
			starttimeobj.className="";
			endtimeobj.className="";
		}
	}
	checkSeenDate();
	return;
}

function setBoldLinks(el,state) {
	obj=document.getElementById(el);
	if (obj) {
		if (state==1) obj.style.fontWeight="bold";
		else obj.style.fontWeight="normal"
	}
}

function IntTextChangeHandler() {
	//RC 16/12/02: This function is called from PACInterpreter.LookUpBrokerInterpreterLoc, as the onchange handler overwrites the broker method.
}

function TransTextChangeHandler() {
	//RC 16/12/02: This function is called from RBCAppointTransport.LookUpBrokerTransLoc, as the onchange handler overwrites the broker method.
}

function IntLookUpSelect(str) {
	var lu = str.split("^");
	//alert(str);
	//var obj=document.getElementById('INTERPDesc');
	//var objchk=document.getElementById('IntReq');
	//if (obj) {
		//obj.value=lu[0];
		//objchk.checked=true;
	//}
}

function TransLookUpSelect(str) {
	var lu = str.split("^");
	//alert(str);
	//var obj=document.getElementById('APPTTransport');
	//if (obj) obj.value=lu[0];
}

//md 05/11/2003 log 40433
function ProcedureSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById("procedure")
	if (obj) obj.value = lu[0];
	var obj=document.getElementById("procedureid")
	if (obj) obj.value = lu[1];

}



function SEENDateChanger(e) {

	var eSrc = document.getElementById('APPTSeenDate');
	if (eSrc) APPTSeenDate_changehandler(e);
	checkSeenDate();

}

//Log 41901 BC 22-1-2004 More Date&Time validation
function checkSeenDate() {
	var seenbytime="";
	var endtime="";
	var seenbydate="";
	var starttimeobj=document.getElementById('APPTSeenTime');
	var endtimeobj=document.getElementById('APPTEndTime');
	if (starttimeobj) seenbytime=starttimeobj.value;
	if (endtimeobj) endtime=endtimeobj.value;
	var seendateobj=document.getElementById('APPTSeenDate');
	if (seendateobj) seenbydate=seendateobj.value;
	var logicaldateobj=document.getElementById('LogicalDate');
	if (logicaldateobj) logicaldate=logicaldateobj.value;
	//var datediff=DateStringAndCacheCompare(seenbydate,logicaldate)
	//md LOG 56987 Better to be compated against today (THAI problem)
	var datediff=DateStringCompareToday(seenbydate)
	if (datediff==1) {
				seendateobj.className="clsInvalid";
				alert(t['APPTSeenDate']+" "+t['MustNotBe']);
				seendateobj.value="";
				seendateobj.className="";
				return;
	}
	if (datediff==0) {

		if(DateTimeStringCompareToday(seenbydate,endtime)==1){
			endtimeobj.className="clsInvalid";
			alert(t['APPTEndTime']+" "+t['MustNotBe']);
			return;
		}
		if(DateTimeStringCompareToday(seenbydate,seenbytime)==1){
			starttimeobj.className="clsInvalid";
			alert(t['APPTSeenTime']+" "+t['MustNotBe']);
			starttimeobj.value="";
			starttimeobj.className="";
			return;
		}
	}
}

//SB 24/06/03 (36452):I asked SB before removing this, the doc unload doesn't work properly you NIT!!!
//document.body.onunload = DocumentUnloadHandler;
document.body.onload = DocumentLoadHandler;