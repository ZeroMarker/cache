// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

//KM 18-Oct-2001: This JavaScript page is also included with the RBAppointment.FindRescDaySched component.
var StatusCode="";
var debug=0
var obj=document.getElementById("Status");
if (obj) obj.onblur=CheckReasonFields;

function DocumentLoadHandler() {
	var DisOrd=document.getElementById("DiscontOrd");
	// LOG 31217 BC 16-12-2002 Reason field disabling and enabling
	DisableReasonFields();
	RenableReasonFields(document.getElementById("StatusCode").value);

	SetCheckBox();
	if (DisOrd) DisOrd.onclick=SetCheckBox;
}

function SetCheckBox() {
	var WLID=document.getElementById("wlid").value;
	var DisOrd=document.getElementById("DiscontOrd");
	var RWLE=document.getElementById("ReInstate");

	if (WLID!="" && DisOrd && RWLE) {
		if (DisOrd.checked==true) RWLE.disabled=true;
		if (DisOrd.checked==false) RWLE.disabled=false;
	} else {
		if (RWLE) RWLE.disabled=true;
	}
}

function LookUpStatus(val) {
	var ary=val.split("^");StatusCode=ary[2];
	document.getElementById("StatusCode").value=StatusCode;
	// LOG 31217 BC 16-12-2002 Reason field disabling and enabling
	RenableReasonFields(StatusCode);
	DateAppt=document.getElementById("date").value;
	DateNow=document.getElementById("DateNowLogical").value
	aryID=document.getElementById("ApptID").value.split(",");
	arySt=document.getElementById("PresentStatus").value.split(",");
	var message=validateStatusChange(StatusCode,DateAppt,DateNow,aryID,arySt);
	if (message!="") {
		document.getElementById("Status").value="";
		if (aryID.length>1) message=message+"\n"+t['MultiApptsSelected'];
		DisableReasonFields();
		alert(message);
	}
}

function RBAppointment_ChangeStatus_UpdateHandler() {
	var obj=document.getElementById("ReasonCode");
	if (obj) ReasonCode=obj.value
	var linkAppt=document.getElementById("LinkedAppts");

	if (StatusCode=="X") {
		CheckforLinkedAppointments()
		var objlabel=document.getElementById("cCancelReason");
		if ((objlabel)&&(objlabel.className=="clsRequired")) {
			if (!obj) {
				alert(t['CancelRequired']);return false;
			} else if (obj.value=="") {
				alert(t['CancelRequired']);return false;
			} else {
				var obj=document.getElementById("CancelReason");
				if ((obj)&&(obj.value=="")) {alert(t['CancelRequired']);return false;}
			}
			daydiff=DateAppt-DateNow;if ((daydiff<3) && (ReasonCode=="2")) {alert(t['NotifyPatient']);}
			// Log 31218 BC 6-1-2003
			CheckForFirstAppt()
		}
	}
	if (StatusCode=="N") {
		CheckforLinkedAppointments()
		var obj=document.getElementById("NotAttendedReason");
		var objlabel=document.getElementById("cNotAttendedReason");
		if ((objlabel)&&(objlabel.className=="clsRequired")) {
			if (!obj) {alert(t['NotAttendedRequired']);return false;} else {if (obj.value=="") {alert(t['NotAttendedRequired']);return false;}}
		}
	}
	//KM 18-Feb-2002: Commented this out because target is taken care of in rbappointment.changestatusafterupdate.csp
	//SB 23/08/02 (27804): This line causes problems from single appt menu.
	//		Only call this code if the form has been opened from another popup form
	//if (window.opener.opener) {document.fRBAppointment_ChangeStatus.target=window.opener.name;}
	//alert(document.getElementById("oktocancelAdmission").value);
	var DisOrd=document.getElementById("DiscontOrd");
	if ((DisOrd)&&(DisOrd.disabled==true)) DisOrd.disabled=false;
	return update1_click();
}

var obj=document.getElementById("update1");
if (obj) obj.onclick=RBAppointment_ChangeStatus_UpdateHandler;

function CancelReasonLookUp(str) {
	var ary=str.split("^");
	var obj=document.getElementById("ReasonCode");
	if (obj) obj.value=ary[2];
}
// LOG 31217 BC 16-12-2002 Reason field disabling and enabling
function DisableReasonFields() {
	var creason=document.getElementById('CancelReason');
	var ccreason=document.getElementById('cCancelReason');
	var fcreason=document.getElementById('FreeCancelReason');
	var nareason=document.getElementById('NotAttendedReason');
	var cnareason=document.getElementById('cNotAttendedReason');
	var presentstat=document.getElementById('PresentStatus');

	if (creason && presentstat.value!='C') {
	DisableField("CancelReason");
	creason.disabled=true;
	//if (ccreason) ccreason.className=""
	}

	if (fcreason) {
	DisableField("FreeCancelReason");
	fcreason.disabled=true;
	}
	//SB 12/06/03 (36317): If previous status is Not Attended, then allow to enter a reason.
	if (nareason && presentstat.value!='N') {
	DisableField("NotAttendedReason");
	nareason.disabled=true;
	//if (cnareason) cnareason.className=""
	}

}
// LOG 31217 BC 16-12-2002 Reason field disabling and enabling
function DisableField(fldName) {
	var fld = document.getElementById(fldName);
	var lup=document.getElementById("ld589i"+fldName);
	if ((fld)&&(fld.tagName=="INPUT")) {
		fld.disabled = true;
		fld.className = "disabledField";
	}
	if (lup) {lup.disabled = true;}
}
// LOG 31217 BC 16-12-2002 Reason field disabling and enabling
function EnableField(fldName) {
	var fld = document.getElementById(fldName);
	var lup=document.getElementById("ld589i"+fldName);
	if ((fld)&&(fld.tagName=="INPUT")) {
		fld.disabled = false;
		fld.className = "";
	}
	if (lup) {lup.disabled = false;}
}
// LOG 31217 BC 16-12-2002 Reason field disabling and enabling
function RenableReasonFields(Status) {
	var creason=document.getElementById('CancelReason');
	var ccreason=document.getElementById('cCancelReason');
	var fcreason=document.getElementById('FreeCancelReason');
	var nareason=document.getElementById('NotAttendedReason');
	var cnareason=document.getElementById('cNotAttendedReason');

	if (Status=="X") {
		if (creason) {
			EnableField("CancelReason");
			creason.disabled=false;
			//if (ccreason) ccreason.className="clsRequired";
		}

		if (fcreason) {
			EnableField("FreeCancelReason");
			fcreason.disabled=false;
		}
		if (nareason) {
			DisableField("NotAttendedReason");
			nareason.disabled=true;
			//if (cnareason) cnareason.className="";
		}
	} else if (Status=="N"){
		if (creason) {
			DisableField("CancelReason");
			creason.disabled=true;
			//if (ccreason) ccreason.className="";
		}

		if (fcreason) {
			DisableField("FreeCancelReason");
			fcreason.disabled=true;
		}
		if (nareason) {
			EnableField("NotAttendedReason");
			nareason.disabled=false;
			//if (cnareason) cnareason.className="clsRequired";
		}

	} else {
		DisableReasonFields()
	}
}
// LOG 31217 BC 16-12-2002 Reason field disabling and enabling
function CheckReasonFields(){
	var obj=document.getElementById("Status");
	if ((obj)&&(obj.value=="")) {
		DisableReasonFields();
		//SB 12/06/03 (36317): I've removed the following line as we can now enter a NA reason after the status has been
		// set, and the obj.focus won't allow any other fields to be entered without Status entered.
		//obj.focus();
	}
}

// Log 31218 BC 6-1-2003
function CheckForFirstAppt() {
	//Defined in the custom javascript for Queensland Health
}

// LOG 31219 BC 28-01-2003 Ask if linked appointments (service sets) are to be cancelled
function CheckforLinkedAppointments() {
	var LinkedAppts=document.getElementById("LinkedAppts");
	if (LinkedAppts) {
		if (debug) alert(LinkedAppts.value);
		LinkedAppts.value="N";
		var messageobj=document.getElementById("LinkedApptMessage");
		if ((messageobj) && (messageobj.value!="")) {
			var message=messageobj.value
			var messagearray=message.split(String.fromCharCode(1))
			message=t["ServSet1"]+messagearray[0]+t["ServSet2"]+"\n";
			for (var i=1; i<messagearray.length; i++) {
				message=message+messagearray[i]+"\n";
			}
			message=message+t["ServSet3"];
			var conf=confirm(message);
			if (debug) alert(conf);
			if (conf) {LinkedAppts.value="Y";}
		}
	}
	if (debug) alert(LinkedAppts.value);
	return;
}

function OutPatCancel(msg1,msgAPPT,info) {
	var frm=document.forms['fRBAppointment_ChangeStatus'];
	var cnfmsg=msg1+"  "+t["CoverApptData"]+":"+msgAPPT+"\n"+t["OutPatCancel"];
	if (info==1) { cnfmsg=cnfmsg+"\n"+t["BookingAdd"] }
	if (confirm(cnfmsg)) {
		document.getElementById('NoCancel').value=0
		if (frm) frm.TOVERRIDE.value=1;
	} else {
		document.getElementById('NoCancel').value=1
		if (frm) frm.TOVERRIDE.value=1;
	}
	//alert(frm.TOVERRIDE.value);
}

document.body.onload = DocumentLoadHandler;