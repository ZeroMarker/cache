// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function RESDateVerified_lookuphandler(e) {
	return false;
}

function BodyLoadHandler () {
	var obj=document.getElementById('RESDateVerified');
	if ((obj)&&(obj.value!="")) {
		obj.readOnly=true;
		obj.className = "disabledField";
	}
	var obj=document.getElementById('RESTimeVerified');
	if ((obj)&&(obj.value!="")) {
		obj.readOnly=true;
		obj.className = "disabledField";
	}
	var vf=document.getElementById('VoiceFile');
	if ((vf)&&(vf.value!="")) {
		var NSRobj=document.getElementById('NSRIRDesc');
		if (NSRobj) {
			NSRobj.disabled=true;
			NSRobj.className="disabledField";
			var NSRobj1=document.getElementById('ld1768iNSRIRDesc');
			if (NSRobj1) NSRobj1.disabled=true;
		}
	}
	var obj=document.getElementById('CheckBoxStatus');
	if ((obj)&&(obj.value==1)) {
		obj.readOnly=true;
		obj.className = "disabledField";
		var obj=document.getElementById('RESReportNotExpected');
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}
		var obj=document.getElementById('ld1768iRESDateVerified');
		if (obj) {
			obj.onclick=RESDateVerified_lookuphandler;
		}
	}
}

function LinkDisable(e) {
	var el = websys_getSrcElement(e);
	if (el.disabled) {
		return false;
	}
	return true;
}

function NonStandardReportReason(str) {   //AmiN log 31884
	//Description ** HIDDEN **  Code ** AltReport
	var lu=str.split("^");
	//alert ("147 desc ^id ^code^report= "+lu[0]+"&&"+lu[1]+"&&"+lu[2]+"&&"+lu[3]);

	obj=document.getElementById("RESReportNotExpected")
	if (obj) obj.value = lu[0] ;

	AltReportobj=document.getElementById("NSRIRAlternateReport")
	if ((lu[3]!="")&&(AltReportobj)) AltReportobj.value = lu[3] ;

	// itmobj=document.getElementById("OEORIItemStatus") //???
	// if (itmobj) itmobj.value = "RESV" ;

}

//var obj1=document.getElementById('ld1768iRESDateVerified');
//if (obj1) obj1.disabled=true;

document.body.onload=BodyLoadHandler;