// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var frm = document.forms["fRBAppointment_QMatic_Edit"];
if (self != window.parent) frm.elements['TFRAME'].value=window.parent.name;

function DocumentLoadHandler() {
	var obj=document.getElementById("Update");
	if (obj) obj.onclick=UpdateClickHandler;
	var obj=document.getElementById("UpdateClose");
	if (obj) obj.onclick=UpdateCloseClickHandler;
}

function UpdateClickHandler() {
	var QMNo=document.getElementById("QMNumber");
	var Stat=document.getElementById("QMStatus");
	var msg="";
	if ((QMNo)&&(Stat)) {
		if (QMNo.value=="") {
			msg+="\'"+t['QMNumber']+"\' "+t['XMISSING']+"\n";
		}
		if (Stat.value=="") {
			msg+="\'"+t['QMStatus']+"\' "+t['XMISSING']+"\n";
		} else if (Stat.className=="clsInvalid") {
			msg+="\'"+t['QMStatus']+"\' "+t['XINVALID'];
		}
		if (msg!="") {
			alert(msg);
			return false;
		}
		return Update_click();
	}
}

function UpdateCloseClickHandler() {
	var QMNo=document.getElementById("QMNumber");
	var Stat=document.getElementById("QMStatus");
	var msg="";
	if ((QMNo)&&(Stat)) {
		if (QMNo.value=="") {
			msg+="\'"+t['QMNumber']+"\' "+t['XMISSING']+"\n";
		}
		if (Stat.value=="") {
			msg+="\'"+t['QMStatus']+"\' "+t['XMISSING']+"\n";
		} else if (Stat.className=="clsInvalid") {
			msg+="\'"+t['QMStatus']+"\' "+t['XINVALID'];
		}
		if (msg!="") {
			alert(msg);
			return false;
		}
		return UpdateClose_click();
	}
}

document.body.onload=DocumentLoadHandler;