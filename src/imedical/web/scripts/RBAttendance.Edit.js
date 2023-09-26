// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function BodyLoadHandler() {
	AttendanceListRefresh();
	EnableReason();
	
	var outcome=document.getElementById("ATTOutcome");
	if (outcome) outcome.onblur=OutcomeOnBlur;
}

function AttendanceListRefresh() {
	if(this.parent.frames["rbattendancelist"]) {
		var obj=null;
		obj=this.parent.frames["rbattendancelist"].find
		if(obj) obj.click();
		else {
			var PatientID="";
			var objPatientID=document.getElementById("PatientID");
			if(objPatientID) PatientID=objPatientID.value;
			var url= "websys.default.csp?WEBSYS.TCOMPONENT=RBAttendance.List&PatientID="+PatientID;
			websys_createWindow(url,'rbattendancelist');
		}
	}	
}

function EnableReason() {
	var code=document.getElementById("outcomeCode");
	var reason=document.getElementById("ATTCancelReasonDR");
	var lookup=document.getElementById("ld2310iATTCancelReasonDR");
	
	if(reason && lookup) {
		reason.disabled=!(code && code.value=="C");
		lookup.disabled=!(code && code.value=="C");
	}
}

function OutcomeLookUpHandler(str) {
	var code=document.getElementById("outcomeCode");
	var strArr=str.split("^");
	if(code) code.value=strArr[2];
	EnableReason();
}

function OutcomeOnBlur() {
	var code=document.getElementById("outcomeCode");
	if (code && this.value=="") {
		code.value="";
	}
}

document.body.onload=BodyLoadHandler;
