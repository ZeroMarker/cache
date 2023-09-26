// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function BodyOnloadHandler() {
	var objTable=document.getElementById("tPATreatmentProgress_List");
	if (objTable){
		var numRows=objTable.rows.length;
		for (i=1;i<numRows;i++){
			var EditObj=document.getElementById("Editz"+i);
			if (EditObj) EditObj.onclick=EditClickHandler;
		}
	}
	var NewObj=document.getElementById("New");
	if (NewObj) NewObj.onclick=NewClickHandler;
}

function EditClickHandler(e){
	var eSrc=websys_getSrcElement(e);
	var rowObj=getRow(eSrc);
	var row=rowObj.rowIndex;
	var ID="";
	var PARREF="";
	var PatientID="";
	var IDObj=document.getElementById("IDz"+row);
	if (IDObj) ID=IDObj.value;
	var obj=document.getElementById('PARREF');
	if (obj) PARREF=obj.value;
	var obj=document.getElementById('PatientID');
	if (obj) PatientID=obj.value;
	var link="websys.default.csp?WEBSYS.TCOMPONENT=PATreatmentProgress.Edit&ID="+ID+"&PARREF="+PARREF+"&PatientID="+PatientID;
	var win=window.top.frames['patreatmentprogress_edit'];
	if (win) win.open(link,win.name,'');
}

function NewClickHandler(){
	var ID="";
	var PatientID="";
	var PARREF="";
	var obj=document.getElementById('PatientID');
	if (obj) PatientID=obj.value;
	var obj=document.getElementById('PARREF');
	if (obj) PARREF=obj.value;
	if (PARREF=="") PARREF=PatientID;
	var link="websys.default.csp?WEBSYS.TCOMPONENT=PATreatmentProgress.Edit&ID="+ID+"&PARREF="+PARREF+"&PatientID="+PatientID;
	var win=window.top.frames['patreatmentprogress_edit'];
	if (win) win.open(link,win.name,'');
}

window.onload=BodyOnloadHandler;