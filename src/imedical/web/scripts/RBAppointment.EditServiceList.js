// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
/* 	History:
		Log 231109 BC 12-12-2002 Patient and Doctor Letter Comments
		Log 31104 RC 28/01/03 Add Transport and Interpreter fields
*/

var TWKFL=document.getElementById("TWKFL");
var OBParam=document.getElementById("OBParam");
var OBParamvalue=OBParam.value;
var Servdoc=window.opener.top.frames["TRAK_main"].frames["RBServList"].document;
if (OBParamvalue=="") { var row=document.getElementById('rowId').value;}else{var row=OBParamvalue}
//alert(OBParamvalue);
var schedRowId=Servdoc.getElementById("schedlistz" + row).value
var scId=""
//Log 37518 BC 28-8-2003 Limit Location and Resource lookup by the HCA and Hospitals from RBAppointment.Find
var Finddoc=window.opener.top.frames["TRAK_main"].frames["RBApptFind"].document;

function DocumentLoadHandler() {
	//Log 37518 BC 28-8-2003 Limit Location and Resource lookup by the HCA and Hospitals from RBAppointment.Find
	/*if (Finddoc) {
		//alert("find doc");
		HCAobj=document.getElementById('HCA');
		if (HCAobj) {
			obj=Finddoc.getElementById('HCARowId');
			//alert("HCARowId="+obj.value);
			if (obj) HCAobj.value=obj.value;
		}

		HospIDsobj=document.getElementById('HospIDs');
		if (HospIDsobj) {
			obj=Finddoc.getElementById('HOSPDescString');
			//alert("HOSPDescString="+obj.value);
			if (obj) HospIDsobj.value=obj.value;
		}
	}*/

	obj=document.getElementById('Time');
	if (obj) obj.onblur= DateTimeChangeHandler;

	obj=document.getElementById('Date');
	if (obj) obj.onblur= DateTimeChangeHandler;

	obj=document.getElementById('UpdateTbl');
	if (obj) obj.onclick= UpdateClickHandler;

	var obj=document.getElementById('InsurPayor');
	if (obj) obj.change= PayorChangeHandler;

	var obj=document.getElementById('InsurPlan');
	if (obj) obj.change= PlanChangeHandler;

	var Transport=document.getElementById('Transport');
	if (obj) obj.change= TransTextChangeHandler;

	var Interpreter=document.getElementById('Interpreter');
	if (obj) obj.change= IntTextChangeHandler;

	obj=document.getElementById('InsurPayor');
	obj1=document.getElementById('PayId');
	payobj=Servdoc.getElementById("payDescz" + row);
	payidobj=Servdoc.getElementById("payIdz" + row);
	if (obj && payobj) obj.value=payobj.innerHTML;
	if (obj && obj.value=="&nbsp;") obj.value="";
	if (obj1 && payidobj) obj1.value=payidobj.value

	obj=document.getElementById('InsurPlan');
	obj1=document.getElementById('PlanId');
	planobj=Servdoc.getElementById("planDescz" + row);
	planidobj=Servdoc.getElementById("planIdz" + row);
	if (obj && planobj) obj.value=planobj.innerHTML;
	if (obj && obj.value=="&nbsp;") obj.value="";
	if (obj1 && planidobj) obj1.value=planidobj.value

	//LOG 31208 BC 5-4-2003
	obj=document.getElementById('Date');
	//alert(obj.value);
	dateobj=Servdoc.getElementById("datez" + row);
	if ((obj)&&(obj.value=="")){
	if (obj && dateobj) obj.value=dateobj.innerHTML;
	if (obj.value=='&nbsp;') obj.value="";}
	//LOG 31218 BC 5-4-2003
	obj=document.getElementById('Time');
	timeobj=Servdoc.getElementById("timez" + row)
	if ((obj)&&(obj.value=="")){
	if (obj && timeobj) obj.value=timeobj.innerHTML;
	if (obj.value=='&nbsp;') obj.value="";}

	//Log 31109 BC 12-12-2002
	var comments=Servdoc.getElementById("commentz" + row).value;
	obj=document.getElementById('APPTRemarks');
	if (obj) obj.value=mPiece(comments,String.fromCharCode(2),0)
	obj=document.getElementById('APPTDoctorLetterNotes');
	if ((obj)&&(mPiece(comments,String.fromCharCode(2),1))) obj.value=mPiece(comments,String.fromCharCode(2),1)

	obj=document.getElementById('APPTPatientLetterNotes');
	if ((obj)&&(mPiece(comments,String.fromCharCode(2),2))) obj.value=mPiece(comments,String.fromCharCode(2),2)
	//End Log 31109 BC 12-12-2002

	obj=document.getElementById('OBReason');
	//LOG 27098 BC 22-8-2002
	//if (obj) obj.onchange= OBReasonChangeHandler;
	if (obj) obj.onblur= OBReasonChangeHandler;

	obj=document.getElementById('DayDetails');
	if (obj) obj.onclick= DayDetailsClickHandler;

	var LocId=document.getElementById('LocId');
	var locId=Servdoc.getElementById("locIdz" + row).value
	if (LocId) LocId.value=locId;

	//Log 31104 RC 22/01/03
	var disint=document.getElementById("disInt").value
	var distrans=document.getElementById("disTrans").value

	if ((distrans==1) || (disint==1)) InitDefaults();

	var TransReq=document.getElementById('TransReq');
	if (TransReq) TransReq.onclick=SetCheckBox;
	var objTraR=Servdoc.getElementById("TransReqz" + row);
	if (objTraR && TransReq) var TransReq=objTraR;
	if (TransReq) TransReq.onclick=SetCheckBox;
	SetCheckBox();

	var transport=""
	var Transport=document.getElementById('Transport');
	var traobj=Servdoc.getElementById("Transportz" + row)
	if (traobj) var transport=traobj.innerHTML;
	if (traobj && transport=='&nbsp;') transport="";
	if (Transport) Transport.value=transport;

	var IntReq=document.getElementById('IntReq');
	if (IntReq) IntReq.onclick=SetCheckBox;
	var objIntR=Servdoc.getElementById("IntReqz" + row);
	if (objIntR && IntReq) var IntReq=objIntR;
	SetCheckBox();

	var interpreter="";
	var Interpreter=document.getElementById('Interpreter');
	var intobj=Servdoc.getElementById("Interpreterz" + row)
	if (intobj) var interpreter=intobj.innerHTML;
	if (intobj && interpreter=='&nbsp;') interpreter="";
	if (Interpreter) Interpreter.value=interpreter;
	//end log 31104

	//if (locId!="") {
	//	var LocDesc=document.getElementById('CTLOCDesc');
	//	var locDesc=Servdoc.getElementById("locDescz" + row).innerText
	//	if (LocDesc) LocDesc.value=locDesc
	//}

	var ResId=document.getElementById('ResId');
	var rowId=Servdoc.getElementById("resIdz" + row).value
	if (ResId) ResId.value=rowId

	var LocDesc=document.getElementById('CTLOCDesc');
	if (LocDesc) LocDesc.onblur=LocDescChangeHandler;

	var RescDesc=document.getElementById('RESDesc');
	if (RescDesc) RescDesc.onblur=RescDescChangeHandler;

	var objdate=document.getElementById('Date');
	var objresId=document.getElementById('ResId');
	var objdaydet=document.getElementById('DayDetails');
	if (!(objdate)) {
		if (objdaydet) {
			objdaydet.disabled=true
		}
	}

	DateTimeChangeHandler()

	var objIncap=document.getElementById('chkIncapacity');
	if (objIncap) objIncap.onclick=IncapClickHandler;
	//IncapClickHandler();

	//log 34392 Don't allow overbooking if appropriate user setting is set
	/* obj=document.getElementById('CantOverbook');
	if ((obj)&&(obj.value=="Y")) {
		obj=document.getElementById('OBReason');
		if (obj) {
			obj.disabled=true;
			obj.className="disabledField";
			var luopbj=document.getElementById("ld621iOBReason");
			if (luopbj) {
				luopbj.disabled=true;
			}
		}
		obj=document.getElementById('Date');
		if (obj) {
			obj.disabled=true;
			obj.className="disabledField";
			var luopbj=document.getElementById("ld621iDate");
			if (luopbj) {
				luopbj.disabled=true;
			}
		}
		obj=document.getElementById('Time');
		if (obj) {
			obj.disabled=true;
			obj.className="disabledField";
		}
	}*/

}

function IncapClickHandler() {
	//debugger;
	var duration=""
	var perIncrDur=document.getElementById("PercentIncrDur").value
	if (perIncrDur=="") return;
	var increase=parseInt(perIncrDur)/100
	//var obj=websys_getSrcElement(e);
	//if (obj.tagName=="IMG") obj=websys_getParentElement(obj);
	//var rowid=obj.id
	//var rowAry=rowid.split("z");
	//var objDurID = document.getElementById("durationIDz"+rowAry[1])
	var objDur = document.getElementById("Duration")
	if (objDur) duration=parseInt(objDur.value)
	var objIncap=document.getElementById("chkIncapacity")
	if (duration!="") {
		if (objIncap && objIncap.checked) {
			var percentIncr=duration*increase;
			var NewDur=percentIncr+duration;
			//if (objDurID) objDurID.value=NewDur
			var objDuration = document.getElementById("Duration")
			if (objDuration) objDuration.value=NewDur
		} else {
			var revPercent = duration/(increase+1)
			var objDuration = document.getElementById("Duration")
			if (objDuration) objDuration.value=revPercent
		}
	}
	//alert(increase)
	//alert(duration)
	//alert(percentIncr)
}

function SetCheckBox() {
	//Log 31104 RC 22/01/03
	var trans=document.getElementById("TransReq");
	var inter=document.getElementById("IntReq");
	var transport=document.getElementById("Transport");
	var translup=document.getElementById("ld621iTransport");
	var interpreter=document.getElementById("Interpreter");
	var interlup=document.getElementById("ld621iInterpreter");

	if (trans && transport && translup) {
		if (trans.checked==true) {
			transport.disabled=false;
			translup.disabled=false;
			transport.className="";
		}
		if (trans.checked==false) {
			transport.disabled=true;
			translup.disabled=true;
			transport.value="";
			transport.className="disabledField";
		}
	}
	if (inter && interpreter && interlup) {
		if (inter.checked==true) {
			interpreter.disabled=false;
			interlup.disabled=false;
			interpreter.className="";
		}
		if (inter.checked==false) {
			interpreter.disabled=true;
			interlup.disabled=true;
			interpreter.value="";
			interpreter.className="disabledField";
		}
	}
}

function InitDefaults() {
	//Log 31104 RC 22/01/03
	var trans=document.getElementById("TransReq");
	var inter=document.getElementById("IntReq");

	var transport=document.getElementById('Transport');
	var traobj=Servdoc.getElementById("Transportz" + row)
	if (traobj) var Transport=traobj.innerHTML;
	if (traobj && Transport=='&nbsp;') Transport="";
	if (transport) transport.value=Transport;

	var interpreter=document.getElementById('Interpreter');
	var intobj=Servdoc.getElementById("Interpreterz" + row);
	if (intobj) var Interpreter=intobj.innerHTML;
	if (intobj && Interpreter=='&nbsp;') Interpreter="";
	if (interpreter) interpreter.value=Interpreter;

	var disint=document.getElementById("disInt").value;
	var distrans=document.getElementById("disTrans").value;

	if (transport && interpreter && trans && inter) {
		if (distrans==1) {
			transport.disabled=true;
			transport.className="disabledField";
			trans.disabled=true;
			transport.value=""; trans.checked=false;
		}
		if (disint==1) {
			interpreter.disabled=true;
			interpreter.className="disabledField";
			inter.disabled=true;
			interpreter.value=""; inter.checked=false;
		}
	}
}

function DayDetailsClickHandler() {
	var objdate=document.getElementById('Date');
	var objresId=document.getElementById('ResId');
	var objdaydet=document.getElementById('DayDetails');
	var objsess=document.getElementById('SessType');

	if (objdaydet) {
		if (objdaydet.disabled)	return;
	}

	if (objresId) {
		var rowId=objresId.value;
	} else {
		var rowId=row
	}
	var obj= document.getElementById("CONTEXT")
	if (obj) context=obj.value;

	if ((objdate)) {
		var date=objdate.value;
		var sesstype=""
		if (objsess) sesstype=objsess.value
		//alert(sesstype);
		if ((date!="") && (rowId!="")) {
			var lnk = "rbloaddaydetails.csp"+"?Conv=Logical&Date=" + date + "&RescID=" + rowId+"&CONTEXT=" + context + "&Window="+window.name + "&SessType=" + sesstype;
			window.opener.top.frames["TRAK_hidden"].location=lnk;
		}
	}

	return;
}

function RescDescChangeHandler() {
	//if (e) {
		//var eSrc=websys_getSrcElement(e);
		//alert(eSrc.id);
		//if (eSrc.id=="RESDesc") {}
		//RESDesc_changehandler();
	//}

	var RescDesc=document.getElementById('RESDesc');
	var objdaydet=document.getElementById('DayDetails');
	var date=document.getElementById('Date');
	//alert(RescDesc.className);
	if (objdaydet) {
		if ((RescDesc.value=="") || (date.value=="") || (RescDesc.className=="clsInvalid")) {
			objdaydet.disabled=true
		} else {
			objdaydet.disabled=false
		}
	}
}

function DateTimeChangeHandler() {
	var date=document.getElementById('Date');
	var cdate=document.getElementById('cDate');
	var time=document.getElementById('Time');
	var ctime=document.getElementById('cTime');
	var reason=document.getElementById('OBReason');
	var creason=document.getElementById('cOBReason');
	var cloc=document.getElementById('cCTLOCDesc');
	var cres=document.getElementById('cRESDesc');
	var sess=document.getElementById('SessType');
	var csess=document.getElementById('cSessType');
	var DOW=document.getElementById('DOW');

	var objdaydet=document.getElementById('DayDetails');
	var RescDesc=document.getElementById('RESDesc');
	var ResId=document.getElementById('ResId');
	var LocDesc=document.getElementById('CTLOCDesc');
	var objIncap=document.getElementById('chkIncapacity');
	var sessid="";
	var objsessid=document.getElementById('SessionId');
	if (objsessid) sessid=objsessid.value;

	if (date) {
		if (date.value!="") document.getElementById('LogicalDate').value=DateStringTo$H(date.value);
		if (date.value=="") document.getElementById('LogicalDate').value=""
	}

	if ((date) && (time) && (reason)) {
		if (schedRowId=="" || schedRowId==" ") {
			if ((date.value=="") && (time.value=="") && (reason.value=="")) {
				creason.className = "";
				ctime.className = "";
				cdate.className = "";
				cloc.className = "";
				cres.className = "";
				//BR 31208 - Session Type is not necessarily going to be on the screen.
				if ((csess)&&(sess)) {
					csess.className = ""
					sess.value="";
					sess.disabled=true;
					sess.className = "disabledField"
					document.getElementById("ld621iSessType").disabled=true;
					DOW.value="";
					sessid=""
				}
				if (objdaydet) {objdaydet.disabled=true}
			} else {
				//alert("manditory");
				creason.className = "clsRequired";
				ctime.className = "clsRequired";
				cdate.className = "clsRequired";
				cloc.className = "clsRequired";
				cres.className = "clsRequired";
				//BR 31208 - Session Type is not necessarily going to be on the screen.
				if ((csess)&&(sess)) {
					csess.className = "clsRequired"
					sess.value="";
					sess.disabled=false;
					sess.className = "clsRequired"
					document.getElementById("ld621iSessType").disabled=false;
					DOW.value="";
					sessid=""
				}
				if (objdaydet) {objdaydet.disabled=false}
			}
			if (objIncap) objIncap.disabled=true
		} else {
			DisableAllFields();
			if (objIncap) objIncap.disabled=false
			if (objdaydet) objdaydet.disabled=true
			/*if (date.value=="") {
				if (objdaydet) {objdaydet.disabled=true}
			} else {
				if (objdaydet) {objdaydet.disabled=false}
			}*/
		}
	}
	if ((RescDesc) && (RescDesc.value=="")) {if (objdaydet) {objdaydet.disabled=true}}
	if ((date) && (date.value!="") && (time) && (time.value!="") && (RescDesc) && (RescDesc.value!="") && (LocDesc) && (LocDesc.value!="")) {
		var lnk = "rbsesstype.csp?Location=" + LocDesc.value + "&Resource=" + RescDesc.value + "&Date=" + date.value + "&Time=" + time.value + "&ResId=" + ResId.value + "&sessId=" + sessid
		//alert("Time check :"+lnk);
		// LOG 27660 BC 22-8-2002 Fix error when the appointment frame is in a popup
		if (window.opener) {
			window.opener.top.frames["TRAK_hidden"].location.href=lnk
		}
		//websys_createWindow(lnk,"TRAK_hidden");
	}
	return;
}

function DisableAllFields() {
	var cdate=document.getElementById('cDate');
	var ctime=document.getElementById('cTime');
	var creason=document.getElementById('cOBReason');
	var cloc=document.getElementById('cCTLOCDesc');
	var cres=document.getElementById('cRESDesc');
	var rem=document.getElementById('APPTRemarks');
	var crem=document.getElementById('cAPPTRemarks');
	var cplan=document.getElementById('cInsurPlan');
	var cpay=document.getElementById('cInsurPayor');
	var curg=document.getElementById('cUrgent');
	//var cdur=document.getElementById('cDuration');
	var csess=document.getElementById('cSessType');
	var cintreq=document.getElementById('cIntReq');
	var cint=document.getElementById('cInterpreter');
	var ctransreq=document.getElementById('cTransReq');
	var ctrans=document.getElementById('cTransport');

	if (ctime) {
	DisableField("Time");
	ctime.disabled=true;
	}

	if (cdate) {
	DisableField("Date");
	cdate.disabled=true;
	}

	if (cres) {
	DisableField("RESDesc");
	cRESDesc.disabled=true;
	}

	if (cloc) {
	DisableField("CTLOCDesc");
	cCTLOCDesc.disabled=true;
	}

	//SB 01/08/02 (24064): User can now update comments after an appointment row is selected
	//rem.setAttribute("disabled",1);
	//crem.disabled=true;

	DisableField("OBReason");

	if (csess) {
	DisableField("SessType");
	csess.disabled=true;
	}
	/* 31104 BR: want to be able to edit these fields after selecting appointment slots.
	if (cplan) {
	DisableField("InsurPlan");
	cplan.disabled=true;
	}

	if (cpay) {
	DisableField("InsurPayor");
	cpay.disabled=true;
	}

	if (cintreq) {
	DisableField("IntReq");
	cintreq.disabled=true;
	}

	if (cint) {
	DisableField("Interpreter");
	cint.disabled=true;
	}

	if (ctransreq) {
	DisableField("TransReq");
	ctransreq.disabled=true;
	}

	if (ctrans) {
	DisableField("Transport");
	ctrans.disabled=true;
	}
	*/
	// BC 19-April-2002 This field is used no matter if an appointment slot has been
	// chosen or not.  DO NOT DISABLE THIS FIELD!
	//if (cdur)
	//{
	//	cdur.disabled=true;
	//	DisableField("Duration");
	//}

	//if (curg)
	//{
	//	curg.disabled=true;
	//	DisableField("Urgent");
	//}
	creason.disabled=true;
}

function OBReasonLookUp(str) {
	var lu = str.split("^");
	//alert(str)
	var obj=document.getElementById('OBReasonId');
	if (obj) obj.value=lu[1];
	//LOG 27098 BC 22-8-2002
	OBReasonChangeHandler()
}

//SB, 24527
function SessionTypeLookUp(str) {
	var date=document.getElementById('Date');
	var time=document.getElementById('Time');
	var RescDesc=document.getElementById('RESDesc');
	var LocDesc=document.getElementById('CTLOCDesc');

	var lu = str.split("^");
	//alert(lu)
	SessId=lu[3]
	SessionIdx=SessId.replace("||", "?")
	SessionId=SessionIdx.replace("||", "?")

	var obj=document.getElementById('SessionId');
	if (obj) obj.value=SessionId;

	var lnk = "rbsesstype.csp?Location=" + LocDesc.value + "&Resource=" + RescDesc.value + "&Date=" + date.value + "&Time=" + time.value + "&sessId=" + SessId + "&GetMessage=1"
	if (window.opener) {
		window.opener.top.frames["TRAK_hidden"].location.href=lnk
	}
	var sessMessage=document.getElementById('sessMessage');
}

function OBReasonChangeHandler(e) {
	//alert("handler");
	var obj=document.getElementById('OBReason');
	var objId=document.getElementById('OBReasonId');
	//if (obj) && (objId) {
		if (obj.value=="") {
			objId.value="";
		}
	//}//
}

function InsurPayorLookUpSelect(str) {
	var lu = str.split("^");
	//alert(str);
	var obj=document.getElementById('PayId');
	if (obj) obj.value=lu[1];
}

function InsurPlanLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('PlanId');
	if (obj) obj.value=lu[2];
	var obj=document.getElementById('InsurPayor');
	if (obj) obj.value=lu[1];
	var obj=document.getElementById('PayId');
	if (obj) obj.value=lu[3];
}

function UpdateClickHandler(e) {
	var obreason=document.getElementById('cOBReason');
	var delim="*";
	var ServList=window.opener.document.getElementById("tRBAppointment_ServiceList");

	//Log 31104 RC 22/01/03
	var TransReq=document.getElementById('TransReq');
	var IntReq=document.getElementById('IntReq');
	var Transport=document.getElementById('Transport');
	var Interpreter=document.getElementById('Interpreter');

	if ((TransReq)&&(TransReq.checked==true) && (Transport.value=="")) {
		alert("You must choose a Transport if you have selected the Transport Required checkbox");
		return false;
	}
	if ((IntReq)&&(IntReq.checked==true) && (Interpreter.value=="")) {
		alert("You must choose an Interpreter if you have selected the Interpreter Required checkbox");
		return false;
	}
	//End Log 31104
	if (obreason.disabled) {
		var duration=document.getElementById('Duration');
		if (duration) {
			duration=duration.value
			//alert(duration);
			if (duration!="") {
				// If the duration is changed then (and only then) and over duration is saved
				var durRow=Servdoc.getElementById("Durationz" + row)
				if (durRow) durRow.innerText=duration
				var durRowID=Servdoc.getElementById("durationIDz" + row)
				if (durRowID) durRowID.value=duration
				var overdurRow=Servdoc.getElementById("OverDurationz" + row)
				if (overdurRow) overdurRow.value=duration
				// SB 16/02/04 (41522): Changing appointment duration for incapacity patients
				var objIncapServ=Servdoc.getElementById("chkIncapacityz" + row)
				var objIncapEdit=document.getElementById("chkIncapacity")
				if (objIncapServ && objIncapEdit) {
					objIncapServ.value="N"
					if (objIncapEdit.checked) objIncapServ.value="Y"
				}
			}
		}

		var urgent=document.getElementById("Urgent");
		if (urgent)
		{
			if (urgent.checked==true)
			{
				var urgentRow=Servdoc.getElementById("Urgentz" + row);
				if (urgentRow) urgentRow.checked=true;
				var urgentIDRow=Servdoc.getElementById("urgentIDz" + row);
				if (urgentIDRow) urgentIDRow.value="Y";
			} else {
				var urgentRow=Servdoc.getElementById("Urgentz" + row);
				if (urgentRow) urgentRow.checked=false;
				var urgentIDRow=Servdoc.getElementById("urgentIDz" + row);
				if (urgentIDRow) urgentIDRow.value="N";
			}
		}
		//SB 07/02/03 (): This was originally inside the above "if (urgent)" statement, but if the urgent checkbox
		// did not exist we weren't saving the comments.
		//Log 31109 BC 12-12-2002
		var comment=document.getElementById('APPTRemarks');
		var dcomment=document.getElementById('APPTDoctorLetterNotes');
		var pcomment=document.getElementById('APPTPatientLetterNotes');
		if (comment) {comment=comment.value} else {comment=""}
		if (dcomment) {comment=comment+String.fromCharCode(2)+dcomment.value} else {comment=comment+String.fromCharCode(2)}
		if (pcomment) {comment=comment+String.fromCharCode(2)+pcomment.value} else {comment=comment+String.fromCharCode(2)}
		if (comment!="") Servdoc.getElementById("commentz" + row).value=comment;
		//End Log 31109 BC 12-12-2002
		//31104 BR 11/09/03, they want to be able to update Transport and interpreter after appt slot selected.
		//Log 31104 RC 22/01/03
		var TransReq=document.getElementById('TransReq');
		if (TransReq && TransReq.checked==false) TransReq.value="";
		var objTraR=Servdoc.getElementById("TransReqz" + row);
		if (objTraR && TransReq) var objTraR=TransReq;
		if (objTraR && TransReq) objTraR.value=TransReq.value;
		var IntReq=document.getElementById('IntReq');
		if (IntReq && IntReq.checked==false) IntReq.value="";
		var objIntR=Servdoc.getElementById("IntReqz" + row);
		if (objIntR && IntReq) var objIntR=IntReq;

		var Transport=document.getElementById('Transport');
		var transport1=Servdoc.getElementById("Transportz" + row);
		if ((transport1)&&!(Transport)) {var transport=transport1.innerHTML;}
		if ((transport1)&&(Transport)) {
			var transport=transport1.innerHTML;
			if (transport!=Transport.value) transport=Transport.value;
			transport1.innerHTML=transport
		}
		if (transport=='&nbsp;') transport="";

		var Interpreter=document.getElementById('Interpreter');
		var interpreter1=Servdoc.getElementById("Interpreterz" + row);
		if (!(Interpreter)&&(interpreter1)) {var interpreter=interpreter1.innerHTML;}
		if ((Interpreter)&&(interpreter1)) {
			var interpreter=interpreter1.innerHTML;
			if (interpreter!=Interpreter.value) interpreter=Interpreter.value;
			interpreter1.innerHTML=interpreter
		}
		if (interpreter=='&nbsp;') interpreter="";

		var pay=document.getElementById('InsurPayor');
		var objPayDesc=Servdoc.getElementById("payDescz" + row);
		if (pay) {objPayDesc.innerHTML=pay.value} else {pay=""}
		var plan=document.getElementById('InsurPlan');
		var objPlanDesc=Servdoc.getElementById("planDescz" + row);
		if (plan) {objPlanDesc.innerHTML=plan.value} else {plan=""}

		var objPayId=Servdoc.getElementById("payIdz" + row);
		var objPlanId=Servdoc.getElementById("planIdz" + row);
		objPayId.value=document.getElementById('PayID').value;
		objPlanId.value=document.getElementById('PlanID').value;

		//SB 09/02/04 (42150): Need to check if object is on the form
		var objApptMethod=Servdoc.getElementById("ApptMethodz" + row);
		if (objApptMethod && document.getElementById('ApptMethod')) objApptMethod.value=document.getElementById('ApptMethod').innerText;
		var objApptLanguage=Servdoc.getElementById("ApptLanguagez" + row);
		if (objApptLanguage && document.getElementById('ApptLanguage')) objApptLanguage.value=document.getElementById('ApptLanguage').value;
		//if (objApptLanguage) objApptLanguage.value=document.getElementById('ApptLanguage').innerText;
		var objOEORIItemGroup=Servdoc.getElementById("OEORIItemGroupz" + row);
		if (objOEORIItemGroup && document.getElementById('OEORIItemGroup')) objOEORIItemGroup.innerHTML=document.getElementById('OEORIItemGroup').value;

		window.close();
		return;
	}

	if (CheckMandatoryFields()) {
		//SB 27/06/02 (26110): Show Session message when updating overbooking.
		var sessMessage=document.getElementById('sessMessage');
		if (sessMessage && sessMessage.value!="undefined" && sessMessage.value!="") {
			var conf=confirm(sessMessage.value + "\n\n\n" + t['ConfirmMsg']);
			if (!conf) return;
		}
		var tnodays=""
		var tmain=""
		var sUrgent="N"

		var date=document.getElementById('Date');
		if (date) {date=date.value} else {date=""}
		var time=document.getElementById('Time');
		if (time) {time=time.value} else {time=""}
		var pay=document.getElementById('InsurPayor');
		if (pay) {pay=pay.value} else {pay=""}
		var plan=document.getElementById('InsurPlan');
		if (plan) {plan=plan.value} else {plan=""}
		// SB 15/09/03 (37256): To be able to edit Appointment method.
		var ApptMethod=document.getElementById("ApptMethod");
		if (ApptMethod) {ApptMethod=ApptMethod.value} else {ApptMethod=""}
		// BR 27/10/03 (38015): To be able to edit Appointment Language.
		var ApptLanguage=document.getElementById("ApptLanguage");
		if (ApptLanguage) {ApptLanguage=ApptLanguage.value} else {ApptLanguage=""}

		//Log 31109 BC 12-12-2002
		var comment=document.getElementById('APPTRemarks');
		var dcomment=document.getElementById('APPTDoctorLetterNotes');
		var pcomment=document.getElementById('APPTPatientLetterNotes');
		//alert("2"+comment);
		if (comment) {comment=comment.value} else {comment=""}
		if (dcomment) {comment=comment+String.fromCharCode(2)+dcomment.value} else {comment=comment+String.fromCharCode(2)}
		if (pcomment) {comment=comment+String.fromCharCode(2)+pcomment.value} else {comment=comment+String.fromCharCode(2)}
		//End Log 31109 BC 12-12-2002
		//var obreason=document.getElementById('OBReason');
		//if (obreason) {obreason=obreason.value} else {obreason=""}
		var obrId=document.getElementById('OBReasonId').value;
		var Duration=document.getElementById('Duration');
		if (Duration) {Duration=Duration.value} else {Duration=""};
		var Urgent=document.getElementById('Urgent');
		if (Urgent)
		{
			if (Urgent.checked) sUrgent="Y"
			//else Urgent="N";
		}
		//SB 17/06/02 (24563):
		var SessType=document.getElementById('SessionId');
		if (SessType) {SessType=SessType.value} else {SessType=""}

		var SType=document.getElementById("SessTypeCode");
		var stype=Servdoc.getElementById('sesstype');
		if (SType) {stype=SType.value} else {stype=""}

		var OBreason=document.getElementById('OBReason');
		var obreason=Servdoc.getElementById("obreason");
		if (OBreason) {obreason=OBreason.value} else {obreason=""}

		var disint="";
		var disInt=document.getElementById('disInt');
		var disint=Servdoc.getElementById("disIntz" + row).value;
		if (disInt && disint) disint=disInt.value;

		var distrans="";
		var disTrans=document.getElementById('disTrans');
		var distrans=Servdoc.getElementById("disTransz" + row).value;
		if (disTrans && distrans) distrans=disTrans.value;
		//Need to update the Interpreter and Transport if fields disabled or not. So code put in a
		//seperate procedure.
		//Log 31104 RC 22/01/03
		var TransReq=document.getElementById('TransReq');
		if (TransReq && TransReq.checked==false) TransReq.value="";
		var objTraR=Servdoc.getElementById("TransReqz" + row);
		if (objTraR && TransReq) var objTraR=TransReq;

		var IntReq=document.getElementById('IntReq');
		if (IntReq && IntReq.checked==false) IntReq.value="";
		var objIntR=Servdoc.getElementById("IntReqz" + row);
		if (objIntR && IntReq) var objIntR=IntReq;

		var Transport=document.getElementById('Transport');
		var transport1=Servdoc.getElementById("Transportz" + row);
		if ((transport1)&&!(Transport)) {var transport=transport1.innerHTML;}
		if ((transport1)&&(Transport)) {
			var transport=transport1.innerHTML;
			if (transport!=Transport.value) transport=Transport.value;
			//alert(Transport.value+"+"+transport);
		}
		if (transport=='&nbsp;') transport="";

		var Interpreter=document.getElementById('Interpreter');
		var interpreter1=Servdoc.getElementById("Interpreterz" + row);
		if (!(Interpreter)&&(interpreter1)) {var interpreter=interpreter1.innerHTML;}
		if ((Interpreter)&&(interpreter1)) {
			var interpreter=interpreter1.innerHTML;
			if (interpreter!=Interpreter.value) interpreter=Interpreter.value;
			//alert(IntReq.value+"+"+interpreter);
		}
		if (interpreter=='&nbsp;') interpreter="";

		// Log 43413 RC 26/07/04 Add Patient No
		var PatNo=Servdoc.getElementById('RegistrationNoz'+ row);
		if ((PatNo)&&(PatNo.innerHTML!='&nbsp;')) {PatNo=PatNo.innerHTML} else {PatNo=""}

		var objORICred=document.getElementById("OEORIItemGroup");
		if (objORICred) {var ORICred=objORICred.value} else {var ORICred=""}

		// Log 37518 BC 9-9-2003 Add HCA and Hospitals to Edit Service List
		var HCARowID=document.getElementById('HCA').value;
		var HospIDs=document.getElementById('HospIDs').value;
		if (HospIDs!="") {
			var HospIDsAry=HospIDs.split("^");
			HospIDs=HospIDsAry.join("|");
		}
		if (Servdoc.getElementById("HCADescz" + row)) {
			var HCADesc=Servdoc.getElementById("HCADescz" + row).innerHTML;
			if (HCADesc=='&nbsp;') var HCADesc=""
		} else {
			var HCADesc="";
		}
		if (Servdoc.getElementById("HOSPDescz" + row)) {
			var HOSPDesc=Servdoc.getElementById("HOSPDescz" + row).innerHTML;
			if (HOSPDesc=='&nbsp;') var HOSPDesc=""
		} else {
			var HOSPDesc="";
		}

		//alert(HCARowID+", "+HospIDs+", "+HCADesc+", "+HOSPDesc)

		var resId=document.getElementById('ResId').value;
		var locId=document.getElementById('LocId').value;
		var payId=document.getElementById('PayID').value;
		var planId=document.getElementById('PlanID').value;
		var locDesc=document.getElementById('CTLOCDesc');
		if (locDesc) {locDesc=locDesc.value} else {locDesc=""}
		if (locDesc=="") locId=""
		var resDesc=document.getElementById('RESDesc');
		if (resDesc) {resDesc=resDesc.value} else {resDesc=""}
		if (resDesc=="") resId=""
		var ssessobj=document.getElementById('ssessdesc');
		if (ssessobj) {var ssess=ssessobj.value} else {var ssess=""}
		var main=document.getElementById('main');
		if (main) {
			if (main.checked) {
				tmain="Y"
			} else {
				tmain=""
			}
		}
		var nodays=document.getElementById('nodays');
		if (nodays) tnodays=nodays.value;

		serId=mPiece(Servdoc.getElementById("serIdz" + row).value,"|",0);
		//ez 18/10/07 added websys_escape log 65145
		serDesc=websys_escape(Servdoc.getElementById("serDescz" + row).innerText);
		//alert(objIntR.value+"+"+objTraR.value);
		var str="";
		str=delim + serDesc + delim + websys_escape(locDesc) + delim + websys_escape(resDesc) + delim + delim + date + delim + time + delim + websys_escape(pay) + delim + websys_escape(plan) + delim + serId +"|" + tmain + "|" + tnodays + delim + locId + delim + resId + delim + payId + delim + planId + delim + obreason + delim + websys_escape(comment) + delim + tmain + delim + tnodays + delim + Duration + delim + sUrgent + delim + SessType + delim + interpreter + delim + transport + delim + stype + delim + objIntR.value + delim + objTraR.value + delim + disint + delim + distrans + delim + ssess + delim + HCADesc + delim + HCARowID + delim + HOSPDesc + delim + HospIDs;
		str+=delim+ApptMethod+delim+ApptLanguage+delim+delim+PatNo+delim+delim+delim+ORICred+"^";
		window.opener.top.frames["TRAK_main"].frames["RBServList"].Refresh("Edit","",row,str);
		window.close();
	} else {
		return;
	}
}


function CheckMandatoryFields() {
//debugger;
var msg="";
var obj = document.getElementById('cOBReason');
if ((obj)&&(obj.className=="clsRequired")) {
	var obj = document.getElementById('CTLOCDesc');
	//alert(obj.value);
	if ((obj)&&(obj.value=="")) {
			msg += "\'" + t['CTLOCDesc'] + "\' " + t['XMISSING'] + "\n";
	}
	var obj = document.getElementById('Date');
	if ((obj)&&(obj.value=="")) {
			msg += "\'" + t['Date'] + "\' " + t['XMISSING'] + "\n";
	}
	var obj = document.getElementById('Time');
	if ((obj)&&(obj.value=="")) {
			msg += "\'" + t['Time'] + "\' " + t['XMISSING'] + "\n";
	}
	var obj = document.getElementById('RESDesc');
	if ((obj)&&(obj.value=="")) {
			msg += "\'" + t['RESDesc'] + "\' " + t['XMISSING'] + "\n";
	}
	var obj = document.getElementById('OBReason');
	if ((obj)&&(obj.value=="")) {
			msg += "\'" + t['OBReason'] + "\' " + t['XMISSING'] + "\n";
	}
	var obj = document.getElementById('SessType');
	if ((obj)&&(obj.value=="")) {
			msg += "\'" + t['SessType'] + "\' " + t['XMISSING'] + "\n";
	}


	if (msg=="") {
		return true;
	} else {
		alert(msg)
		return false;
	}
} else {
	return true;
}
}

function RESDescLookUpSelect(str) {
	var lu = str.split("^");
	//alert(str);
	var obj=document.getElementById('RESDesc');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('ResId');
	if (obj) obj.value=lu[2];
	//var obj=document.getElementById('CTLOCDesc');
	//if (obj) obj.value=lu[0]
	//var obj=document.getElementById('LocId');
	//if (obj) obj.value=lu[3]

	RescDescChangeHandler()
}

function CTLOCDescLookUpSelect(str) {
	var lu = str.split("^");
	//alert(str);
	//var obj=document.getElementById('RESDesc');
	//if (obj) obj.value=lu[1];
	//var obj=document.getElementById('ResId');
	//if (obj) obj.value=lu[3];
	var obj=document.getElementById('CTLOCDesc');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('LocId');
	if (obj) obj.value=lu[1];
	var obj=document.getElementById('RESDesc');
	if ((obj)&&(lu[5]!="")) obj.value=lu[5].split("*")[0];
	var obj=document.getElementById('ResId');
	if ((obj)&&(lu[5]!="")) obj.value=lu[5].split("*")[1];
	var obj=document.getElementById('SERDesc');
	if ((obj)&&(lu[5]!="")) obj.value=lu[5].split("*")[2];
	var obj=document.getElementById('ServId');
	if ((obj)&&(lu[5]!="")) obj.value=lu[5].split("*")[3];

	// RC 20/01/03 LOG 31104: if either of those fields are 1, then we have to disable the relevant fields so the user
	// can't access them.

	var objT=document.getElementById("Transport");
	var objI=document.getElementById("Interpreter");
	var objTC=document.getElementById("TransReq");
	var objIC=document.getElementById("IntReq");
	var objDisT=document.getElementById('disTrans');
	var objDisI=document.getElementById('disInt');

	// ab 26.02.04 - fixed this so it works
	var disTrans=0;
	var disInt=0;
	if (lu[6]!="") disTrans=lu[6].split("*")[0];
	if (lu[6]!="") disInt=lu[6].split("*")[1];

	if (objT && objI && objTC && objIC) {
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
			objDisT.value="";
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
			objDisI.value="";
		}
	} //End Log 31104
}

function IntLookUpSelect(str) {
	//var lu = str.split("^");
	//alert(str);
	//var obj=document.getElementById('Interpreter');
	//if (obj) obj.value=lu[0];
}

function TransLookUpSelect(str) {
	//var lu = str.split("^");
	//alert(str);
	//var obj=document.getElementById('Transport');
	//if (obj) obj.value=lu[0];
}

function LocDescChangeHandler() {
	//obj=document.getElementById('LocId');
	//if (obj) obj.value=""
}

/*
function RescDescChangeHandler() {
	//alert("change")
	//obj=document.getElementById('ResId');
	//if (obj) obj.value=""
}
*/
function PayorChangeHandler() {
	//obj=document.getElementById('PayId');
	//if (obj) obj.value=""
}

function PlanChangeHandler() {
	//obj=document.getElementById('PlanId');
	//if (obj) obj.value=""
}

function TransTextChangeHandler() {
	//obj=document.getElementById('Transport');
	//if (obj) obj.value=""
}

function IntTextChangeHandler() {
	//obj=document.getElementById('IntReq');
	//if (obj) obj.value=""
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

function DisableField(fldName) {
	var fld = document.getElementById(fldName);
	var fldLU = document.getElementById("ld621i"+fldName);
	if ((fld)&&(fld.tagName=="INPUT")) {
		fld.disabled = true;
		fld.className = "";
	}
	if (fldLU) fldLU.disabled = true;
}

function mPiece(s1,sep,n) {
    //Split the array with the passed delimeter
    delimArray = s1.split(sep);
    //If out of range, return a blank string
    if ((n <= delimArray.length-1) && (n >= 0)) {
        return delimArray[n];
    }
}

//LOG 39806 BC 22-10-2003 Need focus on password in RBAppointment.Find after this screen has unloaded
function DocumentUnLoadHandler() {
	var Finddoc=window.opener.top.frames["TRAK_main"].frames["RBApptFind"].document;
	if (Finddoc) {
		var PINobj=Finddoc.getElementById("PIN");
		if (PINobj) {
			PINobj.focus();
		}
	}
}

document.body.onload = DocumentLoadHandler;
document.body.onunload = DocumentUnLoadHandler;
