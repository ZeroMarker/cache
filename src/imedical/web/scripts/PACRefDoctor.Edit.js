// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 


function RefDoctorBodyLoadHandler() {
	
	if (self==top) websys_reSizeT();
	
	obj=document.getElementById('REFDEmail');
	if (obj) obj.onchange=isEmail;							// cjb 24/10/2006 50857 - using standard functionality
	//if (obj) obj.onchange=EmailChangeHandler;
	
	var obj=document.getElementById('viewDr')	
	if ((obj)&&(obj.value=="1")) {
		makeReadOnly()
	}
	
	obj=document.getElementById('REFDDateActiveTo');		// cjb 11/09/2003 39073
	if (obj) obj.onchange=CodeTableValidationDate;
	
	obj=document.getElementById('REFDDateActiveFrom');
	if (obj) obj.onchange=CodeTableValidationDate;
	
	var objCode=document.getElementById('REFDCode');	// cjb 08/04/2004 42990
	var objDesc=document.getElementById('REFDDesc');
	
	// cjb 29/07/2004 44103 - don't disable/enable based on code field
	/*
	if (objCode) {
		if (objCode.value=="") DisableLinks();
		objCode.onchange=EnableLinks;
	}
	*/
	
	if (objDesc) {
		if (objDesc.value=="") DisableLinks();
		objDesc.onchange=EnableLinks;
	}
	
	var obj=document.getElementById('update1');
	if (obj) obj.onclick = UpdateClickHandler;
	
	var obj=document.getElementById('addClinic')	// cjb 22/08/2003 38366
	if (obj) obj.onclick = addClinicClickHandler;
	
	var obj=document.getElementById('delete1')
	if (obj) obj.onclick = DeleteClickHandler;
	
}

function UpdateClickHandler() {
	var obj=document.getElementById('update1');
	if ((obj)&&(obj.disabled==true)) return false;
	
	// cjb 24/10/2006 50857 - using standard functionality (isEmail)
	/*
	var msg="";
	var obj=document.getElementById('REFDEmail');
	if ((obj)&&(!ValidateEmail(obj))) {
		msg += "\'" + t['REFDEmail'] + "\' " + t['XINVALID'] + "\n";
	}
	if (msg != "") {
		alert(msg);
		return false;
	}
	*/

	var obj=document.getElementById('REFDCTZIPDR');
	if ((obj)&&(obj.value!="")) {
		var objTZip=document.getElementById('REFDZipCode');
		if (objTZip) objTZip.value = obj.value + "Z";
	}
	
	if ((window.opener)&&(window.opener.name=="PACRefDoctor_CustomFind")) {
		var obj=window.opener.document.getElementById('find1');
		if (obj) obj.click();
	}
	
	return update1_click();
}

// cjb 22/08/2003 38366: PACRefDoctor.Edit - add update functionallity to Add Clinic link
function addClinicClickHandler() {
	var obj=document.getElementById('addClinic');
	if ((obj)&&(obj.disabled==true)) return false;
	
	// cjb 24/10/2006 50857 - using standard functionality (isEmail)
	/*
	var msg="";
	var obj=document.getElementById('REFDEmail');
	if ((obj)&&(!ValidateEmail(obj))) {
		msg += "\'" + t['REFDEmail'] + "\' " + t['XINVALID'] + "\n";
	}
	if (msg != "") {
		alert(msg);
		return false;
	}
	*/

	var obj=document.getElementById('REFDCTZIPDR');
	if ((obj)&&(obj.value!="")) {
		var objTZip=document.getElementById('REFDZipCode');
		if (objTZip) objTZip.value = obj.value + "Z";
	}
	return addClinic_click();
}

function DeleteClickHandler() {
	var obj=document.getElementById('delete1');
	if ((obj)&&(obj.disabled==true)) return false;
	
	return delete1_click();
}

function DisableLinks() {
	
	var obj=document.getElementById('update1');
	if (obj) {
		obj.disabled=true;
		obj.onclick=LinkDisable;
	}
	obj=document.getElementById('addClinic');
	if (obj) {
		obj.disabled=true;
		obj.onclick=LinkDisable;
	}
	obj=document.getElementById('delete1');
	if (obj) {
		obj.disabled=true;
		obj.onclick=LinkDisable;
	}
}

function EnableLinks() {
	
	var objCode=document.getElementById('REFDCode');
	var objDesc=document.getElementById('REFDDesc');
	// cjb 29/07/2004 44103
	//if ((objCode)&&(objCode.value=="")) return;
	if ((objDesc)&&(objDesc.value=="")) return;
	
	var obj=document.getElementById('update1');
	if (obj) {
		obj.disabled=false;
	}
	obj=document.getElementById('addClinic');
	if (obj) {
		obj.disabled=false;
	}
}

function CityZipLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('REFDCTZIPDR');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('REFDCITYDR');
	if (obj) obj.value=lu[1];
}

// cjb 24/10/2006 50857 - using standard functionality (isEmail)
/*
function EmailChangeHandler(evt) {
	var eSrc = websys_getSrcElement(evt);
	var lbl = document.getElementById('c' + eSrc.id);
	if ((eSrc)&&(!ValidateEmail(eSrc))) {
		alert("\'" + t[eSrc.id] + "\' " + t['XINVALID'] + "\n");
		eSrc.focus();
	}
}
function ValidateEmail(fld) {
	var reEmail = /^.+\@.+\..+$/
  	if ((fld)&&(fld.value!="")) {
  		if (!(reEmail.test(fld.value))) {
			return false;
	    	}
	}
	return true;
}
*/

function makeReadOnly() 	{
	var el=document.forms["fPACRefDoctor_Edit"].elements;
	for (var i=0;i<el.length;i++) {
			if (!(el[i].type=="hidden")) {
			//if (el[i].tagName=="A") {
			el[i].disabled=true
			}			
		}
	var arrLookUps=document.getElementsByTagName("IMG");
	for (var i=0; i<arrLookUps.length; i++) {
			//log 61979 TedT exclude type lookup field in PAFamilyDoctor.List
			if ((arrLookUps[i].id)&&(arrLookUps[i].id.charAt(0)=="l")&&(arrLookUps[i].id.substr(7)!="type"))
			arrLookUps[i].disabled=true;
		}
	var obj=document.getElementById('update1');
	if (obj) obj.disabled=false
	var obj=document.getElementById('addClinic');
	if (obj) obj.disabled=false
	
}

// cjb 11/09/2003 39073
function CodeTableValidationDate(e) {
	var REFDDateActiveFrom;
	var REFDDateActiveTo;
	var obj;
	
	var eSrc=websys_getSrcElement(e);
	if (eSrc.id=="REFDDateActiveFrom") {REFDDateActiveFrom_changehandler(e);}
	if (eSrc.id=="REFDDateActiveTo") {REFDDateActiveTo_changehandler(e);}
	
	obj=document.getElementById('REFDDateActiveFrom');
	if ((obj)&&(obj.value!="")) REFDDateActiveFrom=DateStringTo$H(obj.value);
	
	obj=document.getElementById('REFDDateActiveTo');
	if ((obj)&&(obj.value!="")) REFDDateActiveTo=DateStringTo$H(obj.value);
	
	obj=document.getElementById('CodeTableValidationDate');
	//have to initiate CTVdate to $h in case of clearing values in target date fields
	if (obj) { obj.value=DateStringTo$HToday() };
	if ((obj)&&(obj.value!="")) {
		if ((REFDDateActiveFrom)&&(REFDDateActiveFrom.value!="")) obj.value=REFDDateActiveFrom;
		if ((REFDDateActiveTo)&&(REFDDateActiveTo.value!="")) obj.value=REFDDateActiveTo;
	}
	
}

document.body.onload = RefDoctorBodyLoadHandler;