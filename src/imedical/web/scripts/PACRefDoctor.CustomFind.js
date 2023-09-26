// Copyright (c) 2006 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function findHandler() {
	var flds=document.forms["fPACRefDoctor_CustomFind"].elements;
	if (flds['Doctor']) {P1=websys_escape(flds['Doctor'].value);} else {P1="";}
	if (flds['ClinicAdd1']) {P2=websys_escape(flds['ClinicAdd1'].value);} else {P2="";}
	if (flds['ClinicSuburb']) {P3=websys_escape(flds['ClinicSuburb'].value);} else {P3="";}
	//P4="";
	P5=websys_escape(flds['Restriction'].value);
	if (flds['DoctorFname']) {P6=websys_escape(flds['DoctorFname'].value);} else {P6="";}
	if (flds['DoctorMname']) {P7=websys_escape(flds['DoctorMname'].value);} else {P7="";}
	if (flds['Speciality']) {P8=websys_escape(flds['Speciality'].value);} else {P8="";}
	if (flds['ProvNo']) {P9=websys_escape(flds['ProvNo'].value);} else {P9="";}
	if (flds['DoctorZip']) {P10=websys_escape(flds['DoctorZip'].value);} else {P10="";}
	P11=flds['searchdone'].value;
	// cjb 22/12/2004 44167
	if (flds['ClinicZip']) {P12=websys_escape(flds['ClinicZip'].value);} else {P12="";}
	//log 61979 TedT
	P13=websys_escape(flds['notShow'].value); 
	if (((P1!="")||(P2!="")||(P3!="")||(P6!="")||(P7!="")||(P8!="")||(P9!="")||(P10!="")||(P12!=""))) {
		P11=1;
		flds['searchdone'].value=1;
	}
	
	var	namevaluepairs="&P1="+P1+"&P2="+P2+"&P3="+P3+"&P5="+P5+"&P6="+P6+"&P7="+P7+"&P8="+P8+"&P9="+P9+"&P10="+P10+"&P11="+P11+"&P12="+P12+"&P13="+P13;
	FindComponent_click(namevaluepairs);
	return false;
}

// cjb 23/10/2006 50857
var objDoctor=document.getElementById("Doctor");
var objsearchdone=document.getElementById("searchdone");
if ((objDoctor)&&(objDoctor.value!="")) objsearchdone.value=1;


var obj=document.getElementById("find1");
if (obj) obj.onclick=findHandler;
var obj1=document.getElementById("AddNewRefFamDoc");
if (obj1) {
	if (objsearchdone.value=="") {obj1.disabled=true;} else {obj1.disabled=false;}
}
if (self==top) {
	//websys_reSizeT();
}

// cjb 22/12/2004 44167
function ZipLookupSelect(str) {
	//zipcode^suburb^state^address
	var lu = str.split("^");
	var obj1=document.getElementById("ClinicZip")
	if (obj1) obj1.value = lu[0];
 	var obj=document.getElementById("ClinicSuburb")
	if (obj) obj.value = lu[1];
}



