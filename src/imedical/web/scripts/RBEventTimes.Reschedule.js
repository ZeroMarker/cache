// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
var mode;
var obj=document.getElementById("mode")
if (obj) mode=obj.value
var updateclick=0

function DocumentLoadHandler() {
	MandatoryFields()

	var obj=document.getElementById("update1")
	if (obj) obj.onclick=UpdateClickHandler;

	var objStat=document.getElementById("TIMEStatus")

	if (mode=="RESCHEDULE") {
		//Cancel Reason
		var obj=document.getElementById("RFCDesc")
		if (obj) obj.disabled=true; obj.className = "disabledField";
		var obj=document.getElementById("ld1636iRFCDesc")
		if (obj) obj.disabled=true
		var obj=document.getElementById("cRFCDesc")
		if (obj) obj.disabled=true;
	} else if (mode=="CANCEL") {
		objStat.value="X"
		//Date
		var obj=document.getElementById("TIMEDate")
		if (obj) obj.disabled=true; obj.className = "disabledField";
		var obj=document.getElementById("cTIMEDate")
		if (obj) obj.disabled=true;
		//Start Time
		var obj=document.getElementById("TIMEStartTime")
		if (obj) obj.disabled=true; obj.className = "disabledField";
		var obj=document.getElementById("cTIMEStartTime")
		if (obj) obj.disabled=true;
		//Transfer Reason
		var obj=document.getElementById("APTRANDesc")
		if (obj) obj.disabled=true; obj.className = "disabledField";
		var obj=document.getElementById("ld1636iAPTRANDesc")
		if (obj) obj.disabled=true
		var obj=document.getElementById("cAPTRANDesc")
		if (obj) obj.disabled=true;
	} else {
		//Cancel Reason
		var obj=document.getElementById("RFCDesc")
		if (obj) obj.disabled=true; obj.className = "disabledField";
		var obj=document.getElementById("ld1636iRFCDesc")
		if (obj) obj.disabled=true
		var obj=document.getElementById("cRFCDesc")
		if (obj) obj.disabled=true;
		//Transfer Reason
		var obj=document.getElementById("APTRANDesc")
		if (obj) obj.disabled=true; obj.className = "disabledField";
		var obj=document.getElementById("ld1636iAPTRANDesc")
		if (obj) obj.disabled=true
		var obj=document.getElementById("cAPTRANDesc")
		if (obj) obj.disabled=true;
	}
}

function UpdateClickHandler() {
	updateclick=1
	if (CheckMandatoryFields()) return update1_click();
}

function DocumentUnloadHandler() {
	//SB 11/10/02: Tried to show validation after reschedule, but currently too hard... still thinking
	/*if ((mode=="RESCHEDULE") && (updateclick==1)) {
		var obj=document.getElementById("PARREF")
		if (obj) ID=obj.value
		var lnk="rbevent.validationresults.csp?ID="+ID
		RBEditWindow=websys_createWindow(lnk,"frmValidationResults","top=40,left=40,width=640,height=480,resizable=yes")
	}*/
}

function MandatoryFields() {
	var objTrans=document.getElementById("cAPTRANDesc");
	var objCancel=document.getElementById("cRFCDesc");
	if (mode=="RESCHEDULE") {
		if (objTrans) objTrans.className = "clsRequired";
		if (objCancel) objCancel.className = "";
	} else {
		if (objTrans) objTrans.className = "";
		if (objCancel) objCancel.className = "clsRequired";
	}
}

function CheckMandatoryFields() {
	var msg=""
	if (mode=="RESCHEDULE") {
		var objTrans = document.getElementById('APTRANDesc');
		var cobjTrans= document.getElementById('cAPTRANDesc');
		if ((objTrans)&&(objTrans.value=="")&&(cobjTrans.className=="clsRequired")) {
			msg += "\'" + t['APTRANDesc'] + "\' " + t['XMISSING'] + "\n";
		}
	} else {
		var objCancel = document.getElementById('RFCDesc');
		var cobjCancel = document.getElementById('cRFCDesc');
		if ((objCancel)&&(objCancel.value=="")&&(cobjCancel.className=="clsRequired")) {
			msg += "\'" + t['RFCDesc'] + "\' " + t['XMISSING'] + "\n";
		}
	}
	if (msg=="") {
		return true;
	} else {
		alert(msg)
		return false;
	}
}

document.body.onload = DocumentLoadHandler;
document.body.onunload = DocumentUnloadHandler;