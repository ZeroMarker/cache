// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function Init() {
	websys_firstfocus();

	var obj;

	//obj=document.getElementById('HARDel');
	//if (obj) obj.onclick=HARDeleteClickHandler;	

	//objHidden=document.getElementById('find1');
	//if (objHidden) objHidden.onclick= FindClickHandler;
	//if (tsc['find1']) websys_sckeys[tsc['find1']]=FindClickHandler;
	//setConsultantFilter()

	// RQG 03.07.03 L35869
	var objRepeat=document.getElementById('UpdateAndAdd');
	if (objRepeat) objRepeat.onclick=RepeatHandler;
	var objCloseWin=document.getElementById("closewindow")
	if (objCloseWin) objCloseWin.onclick=CloseWindow;
	
	var objupdate=document.getElementById("update1")
	if (objupdate) objupdate.onclick=UpdateHandler;
	
}

function CloseWindow() {
	websys_closeWindows();
	return true;
}

// Metatstatic Code
function LookUp(str) {
	//EpisodeNo^CTLOC_Desc^CTPCP_Desc^WARDDesc^hosp
 	var lu = str.split("^");
	//alert("hello^" + str + "end||start" + lu[0] + ":" + lu[1] + ":" + lu[2] + ":" + lu[3] + ":" + lu[4]);
	var obj=document.getElementById("METMetastaticSite")
	if (obj) {
		if (lu[1]) obj.value = lu[1];
		else obj.value = "";
	}
}

function RepeatHandler() {
	var PatientId=""; var PARREF="";
	var objPatId=document.getElementById('PatientID'); 
	if (objPatId) PatientId=objPatId.value;
	var objPARREF=document.getElementById('PARREF'); 
	if (objPARREF) PARREF=objPARREF.value;

	UpdateAndAdd_click();

	var url="websys.default.csp?WEBSYS.TCOMPONENT=PATumorMetatstatic.Edit&ID=&PatientBanner=1&PARREF="+PARREF+"&PatientID="+PatientId;
	window.location.href=url;
	return false;
}

function UpdateHandler() {

	// cjb 14/07/2004 45090 - check if the ICD fields are invalid
	var msg="";
	var obj=document.getElementById('MRCIDCode');
	if ((obj)&&(obj.className=="clsInvalid")) {
		msg += "\'" + t['MRCIDCode'] + "\' " + t['XINVALID'] + "\n";
	}
	if (msg != "") {alert(msg);return false;}
	
	return update1_click();
}

document.body.onload=Init;