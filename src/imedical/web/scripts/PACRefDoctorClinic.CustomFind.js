// Copyright (c) 2006 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
function findHandler() {
	var flds=document.forms["fPACRefDoctorClinic_CustomFind"].elements;
	// cjb 06/10/2004 46719 - only get the values if they are on the form...
	if (flds['ClinicCode']) {P1=websys_escape(flds['ClinicCode'].value);} else {P1="";}
	if (flds['ClinicDesc']) {P2=websys_escape(flds['ClinicDesc'].value);} else {P2="";}
	if (flds['ClinicSuburb']) {P3=websys_escape(flds['ClinicSuburb'].value);} else {P3="";}
	P4=flds['searchdone'].value;
	P5=websys_escape(flds['RefDoc'].value);
	if (flds['Multi']) {P6=websys_escape(flds['Multi'].value);} else {P6="";}
	
	if ((P1!="")||(P2!="")||(P3!="")||(P5!="")||(P6!="")) {
		P4=1;
		flds['searchdone'].value=1;
	}
	
	if (P6!="") {P1=P6; P6="true";}
	
	var namevaluepairs="&P1="+P1+"&P2="+P2+"&P3="+P3+"&P4="+P4+"&P5="+P5+"&P6="+P6;
	FindComponent_click(namevaluepairs);
	return false;
}

var obj=document.getElementById("find1");
if (obj) obj.onclick=findHandler;

//md 49260 will need to transfr this as QH custom one
//var obj1=document.getElementById("AddClinic");
//var obj2=document.getElementById("searchdone");
//if (obj1) {
//	if ((obj2)&&(obj2.value=="")) {
//		obj1.disabled=true;
//		obj1.onclick=LinkDisable;
//	}
//	if ((obj2)&&(obj2.value!="")) {
//		obj1.disabled=false;
//	}
//}

if (self==top) {
	//websys_reSizeT();
}

function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	//if (el.id=="ViewableBy") VIEWABLE=el;
	if (el.disabled) {
		return false;
	}
	return true;
}
