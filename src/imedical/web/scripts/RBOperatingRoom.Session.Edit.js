// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function BodyOnloadHandler() {
	var schedid=document.getElementById("SchedID");
	var disable=true
	if (schedid.value!="") {
		var surg=document.getElementById("Surgeon");
		if (surg && surg.value!="") EnableDisableField("Surgeon",disable)
		var ana=document.getElementById("Anaesthetist");
		if (ana && ana.value!="") EnableDisableField("Anaesthetist",disable);
		EnableDisableField("SessType",disable);
		EnableDisableField("SessDesc",disable);
	} else {
		EnableDisableField("AddStaffMember",disable)
		var addstaff=document.getElementById("AddStaffMember");
		if (addstaff) addstaff.onclick=AddStaffClickHandler;
	}

	var ndate=parseFloat(document.getElementById("ndate").value);
	var ntime=parseFloat(document.getElementById("ntime").value);
	var sdate=parseFloat(document.getElementById("Date").value);
	var stime=parseFloat(document.getElementById("sTime").value);
	var etime=parseFloat(document.getElementById("eTime").value);
	var ReadOnly=false;

	if(ndate>=sdate){if(ntime>stime) ReadOnly=true;}
	if(ReadOnly) {
		EnableDisableField("OTSessStTime",disable)
		if(ndate>=sdate){if (ntime>etime) EnableDisableField("OTSessEndTime",disable);}
		EnableDisableField("Anaesthetist",disable);
		EnableDisableField("Surgeon",disable)
		if(ndate>=sdate){if (ntime>etime)EnableDisableField("Update",disable);}
		if(ndate>=sdate){if (ntime>etime)EnableDisableField("UpdateClose",disable);}
	}

	var obj=document.getElementById("OTSessStTime");
	if (obj) obj.onblur=TimeCheckHandler
	var obj=document.getElementById("OTSessEndTime");
	if (obj) obj.onblur=TimeCheckHandler

	var objUpdate = document.getElementById("Update");
	if (objUpdate) objUpdate.onclick=UpdateClickHandler;
	var objUpdate = document.getElementById("UpdateClose");
	if (objUpdate) objUpdate.onclick=UpdateCloseClickHandler;
}

function AddStaffClickHandler(e) {
	var addstaff=document.getElementById("AddStaffMember");
	if (addstaff && addstaff.disabled) {
		return false;
	}
	return true;
}

function EnableDisableField(fldName,val) {
	//alert("Disabling fldName="+fldName+" val="+val);
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	var lu = document.getElementById('ld2127i'+fldName);
	if (fld) {
		fld.disabled = val;
		if (lu) lu.disabled=val;
		if (fld.disabled==false){
			fld.className = "";
		} else {
			fld.className = "disabledField";
		}
	}
}

function UpdateClickHandler(e) {
	var objUpdate = document.getElementById("Update");
	if (objUpdate.disabled) {
		return false
	}
	return Update_click();
}

function UpdateCloseClickHandler(e) {
	var objUpdate = document.getElementById("UpdateClose");
	if (objUpdate.disabled) {
		return false
	}
	return UpdateClose_click();
}

function TimeCheckHandler() {
	var stime=document.getElementById("OTSessStTime").value;
	var etime=document.getElementById("OTSessEndTime").value;
	if ((stime=="")||(etime=="")) return false;
	var tim=TimeStringCompare(etime,stime)
	if (tim!=1) alert(t["ConflictTime"]);
	return false;
}

document.body.onload=BodyOnloadHandler;