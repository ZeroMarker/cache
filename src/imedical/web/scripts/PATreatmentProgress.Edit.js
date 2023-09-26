// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var frm = document.forms["fPATreatmentProgress_Edit"];
var obj=document.getElementById('Update');
if (obj) obj.onclick=UpdateClickHandler;

function UpdateClickHandler() {
	/*
	var PARREF="";
	var PatientID="";
	var obj=document.getElementById('PARREF');
	if (obj) PARREF=obj.value;
	var obj=document.getElementById('PatientID');
	if (obj) PatientID=obj.value;
	var link="patreatmentprogress.csp?PARREF="+PARREF+"&PatientID="+PatientID;
	var win=window.top;
	if (win) win.open(link,win.name,'');
	return Update_click();*/

	if (parent.frames["patreatmentprogress_edit"]) {
		frm.elements['TFRAME'].value=window.parent.name;
	}
	var obj=document.forms['fPATreatmentProgress_Edit'].elements['TWKFLI'];
	if (!(fPATreatmentProgress_Edit_submit())) return false
	if (obj.value!="") obj.value-=1;
	return Update_click();

}