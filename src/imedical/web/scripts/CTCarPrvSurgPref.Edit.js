// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var frm = document.forms["fCTCarPrvSurgPref_Edit"];
if (self != window.parent) frm.elements['TFRAME'].value=window.parent.name;

function DocumentLoadHandler() {
	var obj=document.getElementById("Update");
	if (obj) obj.onclick=UpdateClickHandler;
	var obj=document.getElementById("UpdateClose");
	if (obj) obj.onclick=UpdateCloseClickHandler;
	var stat=document.getElementById("Stat").value;
	if (stat=="Edit") {
		var obj=document.getElementById("CTCareProv");
		if (obj) {obj.disabled=true; obj.className="disabledField";}
		var objlu=document.getElementById("ld2108iCTCareProv");
		if (objlu) {objlu.disabled=true;}
	}
	var obj=document.getElementById("ORPTurnaroundTime");
	if (obj) obj.onchange=TurnaroundTimeChangeHandler;
	var obj=document.getElementById("ORPExpectedLOS");
	if (obj) obj.onchange=ExpectLengthOfStayChangeHandler;
	var obj=document.getElementById("ORPAverageProcTime");
	if (obj) obj.onchange=AvProcTimeChangeHandler;
	if (document.getElementById("ReadOnly").value==1) ReadOnly();
}

function ReadOnly() {
	DisableField("ORPText1");
	DisableField("OPERDesc"); DisableField("ld2108iOPERDesc");
	DisableField("SPPPDesc"); DisableField("ld2108iSPPPDesc");
	DisableField("ORPTurnaroundTime");
	DisableField("ORPExpectedLOS");
	DisableField("ORPAverageProcTime");
	DisableField("Update");
	DisableField("UpdateClose");
}

function DisableField(fldName) {
	var fld = document.getElementById(fldName);
	if (fld) {
		fld.disabled = true;
		fld.className = "clsDisabled";
		if (fld.onclick!="") fld.onclick=LinkDisabled;
	}
}

function LinkDisabled() {
	return false;
}

function UpdateClickHandler() {
	var objTurnAroundTime=document.getElementById("ORPTurnaroundTime");
	var objExpLenOfStay=document.getElementById("ORPExpectedLOS");
	var objAvProcTime=document.getElementById("ORPAverageProcTime");
	
	if (objTurnAroundTime.className == "clsInvalid") {
		alert(t['ORPTurnaroundTime'] + " " + t['XINVALID']);
		return false;
	}
	if (objExpLenOfStay.className == "clsInvalid") {
		alert(t['ORPExpectedLOS'] + " " + t['XINVALID']);
		return false;
	}
	if (objAvProcTime.className == "clsInvalid") {
		alert(t['ORPAverageProcTime'] + " " + t['XINVALID']);
		return false;
	}
	
	return Update_click();
}

function UpdateCloseClickHandler() {
	var objTurnAroundTime=document.getElementById("ORPTurnaroundTime");
	var objExpLenOfStay=document.getElementById("ORPExpectedLOS");
	var objAvProcTime=document.getElementById("ORPAverageProcTime");
	
	if (objTurnAroundTime.className == "clsInvalid") {
		alert(t['ORPTurnaroundTime'] + " " + t['XINVALID']);
		return false;
	}
	if (objExpLenOfStay.className == "clsInvalid") {
		alert(t['ORPExpectedLOS'] + " " + t['XINVALID']);
		return false;
	}
	if (objAvProcTime.className == "clsInvalid") {
		alert(t['ORPAverageProcTime'] + " " + t['XINVALID']);
		return false;
	}
	return UpdateClose_click();
}

function CarPrvLookUpSelect(txt) {
	var adata=txt.split("^");
	var obj=document.getElementById("CTPCPDesc")
	if (obj) obj.value=adata[0];
	var obj=document.getElementById("ORPParRef")
	if (obj) obj.value=adata[1];
}

function TurnaroundTimeChangeHandler() {
	var objTurnAroundTime=document.getElementById("ORPTurnaroundTime");
	if (objTurnAroundTime) {
		if (objTurnAroundTime.value.length > 3) {
			objTurnAroundTime.className = "clsInvalid";
			websys_setfocus('ORPTurnaroundTime');
		}
		else {
			if (objTurnAroundTime.readOnly) objTurnAroundTime.className='clsReadOnly';
			else objTurnAroundTime.className='';
		  ORPTurnaroundTime_changehandler();
		}
	}
}

function ExpectLengthOfStayChangeHandler() {
	var objExpLenOfStay=document.getElementById("ORPExpectedLOS");
	if (objExpLenOfStay) {
			if (objExpLenOfStay.value.length > 3) {
			objExpLenOfStay.className = "clsInvalid";
			websys_setfocus('ORPExpectedLOS');
		}
		else {
			if (objExpLenOfStay.readOnly) objExpLenOfStay.className='clsReadOnly';
			else objExpLenOfStay.className='';
		  ORPExpectedLOS_changehandler();
		}
	}
}

function AvProcTimeChangeHandler() {
	var objAvProcTime=document.getElementById("ORPAverageProcTime");
	if (objAvProcTime) {
			if (objAvProcTime.value.length > 4) {
			objAvProcTime.className = "clsInvalid";
			websys_setfocus('ORPAverageProcTime');
		}
		else {
			if (objAvProcTime.readOnly) objAvProcTime.className='clsReadOnly';
			else objAvProcTime.className='';
		  ORPAverageProcTime_changehandler();
		}
	}
}

document.body.onload=DocumentLoadHandler;