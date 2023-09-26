// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function Init() {
	var objUpdate=document.getElementById('update1');
	if (objUpdate) objUpdate.onclick=UpdateHandler;
	var objRepeat=document.getElementById('UpdateAndAdd');
	if (objRepeat) objRepeat.onclick=RepeatHandler;
	var objCloseWin=document.getElementById("closewindow")
	if (objCloseWin) objCloseWin.onclick=CloseWindow;


}

function UpdateHandler() {
	//AJI log 35869 - 30.10.03
	var lbl=document.getElementById("cCDRComment");
	var fld=document.getElementById("CDRComment");
	
	if (lbl && fld) {
		if (lbl.className=="clsRequired" && fld.value=="") {
			alert(t['REASON_REQTXT']);
			websys_setfocus("CDRComment");
			return false;
		}
	}

	update1_click();
	//KK 24/01/05 L:48873 commented the following 2 lines...
	//window.location="websys.close.csp";		//Close current window
	//window.location="websys.reload.csp";	//Refresh the pacancerframe.csp page
}

function RepeatHandler() {
	var PatientId=""; var PARREF="";
	var objPatId=document.getElementById('PatientID'); 
	if (objPatId) PatientId=objPatId.value;
	var objPARREF=document.getElementById('PARREF'); 
	if (objPARREF) PARREF=objPARREF.value;

	UpdateAndAdd_click();

	var url="websys.default.csp?WEBSYS.TCOMPONENT=PATumorClinDiagReason.Edit&ID=&PatientBanner=1&PARREF="+PARREF+"&PatientID="+PatientId;
	//alert(url);
	window.location.href=url;
	return false;
}

//AJI log35869 - 30.10.03, lookup select method
function ClinicalDiagReasonSelect(str) {

 	var lu = str.split("^");
	var obj=document.getElementById("CLDRDesc")
	if (obj && lu[0]) obj.value = lu[0];
	
	var lbl=document.getElementById("cCDRComment")
	var field=document.getElementById("CDRComment")
	try {
		if (lu[2]=="Y") {
			lbl.className="clsRequired";
			field.disabled=false;
			field.className="";
		}
		else {
			lbl.className="";
			field.value="";
			field.disabled=true;
			field.className="disabledField";
		}
	} catch(e) {}
}

function CloseWindow() {
	websys_closeWindows();
	return true;
}

document.body.onload=Init;