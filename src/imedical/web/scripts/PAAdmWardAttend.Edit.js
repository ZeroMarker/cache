// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
// last upd: ab 18.09.03

function BodyOnloadHandler() {	
	var neweps=document.getElementById("NewEps");
	var id=document.getElementById("ID");
	var firstwa=document.getElementById("FirstWA");
	//setConsultantFilter()
	
	// ab 9.1.03
	// disable the first attendance tickbox for the very first attendance (when no other episodes with ward attendances)
	// this is because when the tickbox is checked it will create another episode and one has already been created in the workflow
	//if ((id)&&(id.value=="")&&(neweps)&&(neweps.value==1)) {
	if ((id)&&(id.value=="")&&(firstwa)&&(firstwa.value=="")) {
		var obj=document.getElementById("WATFirstAttendance");
		if (obj) {
			obj.checked=true;
			obj.disabled=true;
		}	}
	
	var obj=document.getElementById("WATDate");
	if (obj) obj.onblur=StartDateBlurHandler;
	
	return;
}

function UpdateHandler() {
	return update1_click();
}

function setConsultantFilter() {
	var obj=document.getElementById("conFlag");
	if (obj) obj.value="Y"
}

function CareProvTypeLookupSelect(str)
{
 //dummy
}

//LOG 31751 BC 17-1-2003 Loc filters CP
function LocationLookupSelect(str)
{
 	var lu = str.split("^");
	var obj=document.getElementById("WATCTLOCDR")
	if (obj) obj.value = lu[1];
	var obj=document.getElementById("WATCTCPDR")
 	if (obj) obj.value =""
	return true;
}

function StartDateBlurHandler(e) {
	var eobj=websys_getSrcElement(e);
	if (eobj) {
		var obj=document.getElementById("WATDateH");
		if ((obj)&&(eobj.value!="")) obj.value=DateStringTo$H(eobj.value);
		if ((obj)&&(eobj.value=="")) obj.value=obj.defaultValue;
	}
}

document.body.onload = BodyOnloadHandler;
