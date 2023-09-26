// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function BodyLoadHandler() {
	
	var obj=document.getElementById('CTCITDesc');
	if (obj) obj.onchange = CityChangeHandler;
	
	obj=document.getElementById('CLNEmail');
	if (obj) obj.onchange = isEmail;							// cjb 24/10/2006 50857 - using standard functionality
	//if (obj) obj.onchange = EmailChangeHandler;
	
	obj=document.getElementById('CLNCode');
	if ((obj)&&(obj.value=="")) DisableLinks();    // cjb 15/04/2004 42990
	if (obj) obj.onblur=ClinicCodeChangeHandler;
	
	// cjb 24/04/2004 42990
	obj=document.getElementById('CLNEmail1');
	if (obj) obj.onchange = isEmail;							// cjb 24/10/2006 50857 - using standard functionality
	//if (obj) obj.onchange = Email1ChangeHandler;
	if ((obj)&&(obj.value=="")) DefaultEmail();
	
	//obj=document.getElementById('update1');
	//if (obj) obj.onclick = UpdateClickHandler;
	
}

function UpdateClickHandler(evt) {
	
	// cjb 24/10/2006 50857 - using standard functionality
	/*
	var msg="";
	// cjb 24/04/2004 42990 - removing
	// md 49260 conditionaly returning 
	var obj = document.getElementById('CLNEmail'); 
	if ((obj)&&(!ValidateEmail(obj))) {
		msg += "\'" + t['CLNEmail'] + "\' " + t['XINVALID'] + "\n";
	}
	// md 49260 conditionaly returning 
	var obj = document.getElementById('CLNEmail1'); 
	if ((obj)&&(!ValidateEmail(obj))) {
		msg += "\'" + t['CLNEmail1'] + "\' " + t['XINVALID'] + "\n";
	}
	if (msg != "") {
		alert(msg);
		return false;
	}
	*/
	return update1_click();
}

function CityZipLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('CTZIPCode');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('CTCITDesc');
	if (obj) obj.value=lu[1];
}

// cjb 24/04/2004 42990
function PreferredContactLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('CLNPreferredContactCode');
	if (obj) obj.value=lu[2];
	ContactChangeHandler();
}

function CityChangeHandler(evt) {
	var eSrc = websys_getSrcElement(evt);
	if ((eSrc) && (eSrc.value=="")) return;
	var obj=document.getElementById('CTZIPCode');
	if (obj) obj.value="";
}

// cjb 24/10/2006 50857 - using standard functionality
/*
function EmailChangeHandler(evt) {
	var eSrc = websys_getSrcElement(evt);
	var lbl = document.getElementById('c' + eSrc.id);
	if ((eSrc)&&(!ValidateEmail(eSrc))) {
		alert("\'" + t[eSrc.id] + "\' " + t['XINVALID'] + "\n");
		eSrc.focus();
	}
}

function Email1ChangeHandler(evt) {
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

function ClinicCodeChanger(str) {
	var lu = str.split("^");
	var obj="";
	var obj1="";
	obj=document.getElementById("CLNCode")
	if (obj) {
		obj.value = lu[0];
		obj.className=""	
	}
	obj1=document.getElementById("CLNAddress1")
	if (obj1) obj1.value = lu[1];
	obj1=document.getElementById("CLNAddress2")
	if (obj1) obj1.value = lu[2];
	obj1=document.getElementById("CTCITDesc")
	if (obj1) obj1.value = lu[10];
	obj1=document.getElementById("CLNEmail")
	if (obj1) obj1.value = lu[6];
	obj1=document.getElementById("CLNEmail1")
	if ((obj1)&&(obj1.value=="")) obj1.value = lu[6];
	obj1=document.getElementById("CLNFax")
	if (obj1) obj1.value = lu[7];
	obj1=document.getElementById("CLNPhone")
	if (obj1) obj1.value = lu[8];
	obj1=document.getElementById("CTZIPCode")
	if (obj1) obj1.value = lu[11];
	obj1=document.getElementById("CLNDesc")
	if (obj1) obj1.value = lu[3];
	obj1=document.getElementById("CLNDateFrom")
	if (obj1) obj1.value = lu[4];
	obj1=document.getElementById("CLNDateTo")
	if (obj1) obj1.value = lu[5];
	obj1=document.getElementById("ClinicID")
	if (obj1) obj1.value = lu[12];
	obj1=document.getElementById("CLNProviderNo")
	if (obj1) obj1.value = lu[13];
	obj1=document.getElementById("CLNBusPhone")
	if (obj1) obj1.value = lu[14];
	
	// cjb 15/04/2004 42990
	var objCode=document.getElementById('CLNCode');
	// cjb 01/09/2004 45945 - don't enable the link before PACRefDoctorClinic has been saved
	var objID=document.getElementById('ID');
	if ((objCode)&&(objCode.value=="")) DisableLinks();
	if ((objCode)&&(objCode.value!="")) EnableLinks();
	
}

// clear the ref doctor address fields if blank.
function ClinicCodeChangeHandler(e) {
	var obj="";
	var obj1="";
	obj=document.getElementById("CLNCode");
	if ((obj)&&(obj.value=="")) {
		obj1=document.getElementById("ClinicID")
		if (obj1) obj1.value ="";
		obj1=document.getElementById("CLNAddress1")
		if (obj1) obj1.value ="";
		obj1=document.getElementById("CLNAddress2")
		if (obj1) obj1.value ="";
		obj1=document.getElementById("CTCITDesc")
		if (obj1) obj1.value ="";
		obj1=document.getElementById("CLNCityDR")	
		if (obj1) obj1.value ="";
		obj1=document.getElementById("CLNEmail")	
		if (obj1) obj1.value ="";
		obj1=document.getElementById("CLNZipDR")
		if (obj1) obj1.value ="";
		obj1=document.getElementById("CLNPhone")
		if (obj1) obj1.value ="";
		obj1=document.getElementById("CLNFax")
		if (obj1) obj1.value ="";
		obj1=document.getElementById("CLNDesc")
		if (obj1) obj1.value = "";
		obj1=document.getElementById("CTZIPCode")
		if (obj1) obj1.value = "";
		obj1=document.getElementById("CLNDateFrom")
		if (obj1) obj1.value = "";
		obj1=document.getElementById("CLNDateTo")
		if (obj1) obj1.value = "";
		obj1=document.getElementById("CLNProviderNo")
		if (obj1) obj1.value = "";
 	}
}

function setreadonly() {
	
	var obj1;
	obj1=document.getElementById("CLNAddress1")
	if (obj1) obj1.disabled=true;
	obj1=document.getElementById("CLNAddress2")
	if (obj1) obj1.disabled=true;
	obj1=document.getElementById("CTCITDesc")
	if (obj1) obj1.disabled=true;
	obj1=document.getElementById("CLNEmail")
	if (obj1) obj1.disabled=true;
	obj1=document.getElementById("CLNFax")
	if (obj1) obj1.disabled=true;
	obj1=document.getElementById("CLNPhone")
	if (obj1) obj1.disabled=true;
	obj1=document.getElementById("CTZIPCode")
	if (obj1) obj1.disabled=true;
	obj1=document.getElementById("CLNDesc")
	if (obj1) obj1.disabled=true;
	obj1=document.getElementById("CLNDateTo")
	if (obj1) obj1.disabled=true;
	obj1=document.getElementById("CLNDateFrom")
	if (obj1) obj1.disabled=true;
	obj1=document.getElementById("CLNProviderNo")
	if (obj1) obj1.disabled=true;
	obj1=document.getElementById("CLNVEMD")
	if (obj1) obj1.disabled=true;
	obj1=document.getElementById("CLNBusPhone")
	if (obj1) obj1.disabled=true;
}

function unsetreadonly() {
	
	var obj1;
	obj1=document.getElementById("CLNAddress1")
	if (obj1) obj1.disabled=false;
	obj1=document.getElementById("CLNAddress2")
	if (obj1) obj1.disabled=false;
	obj1=document.getElementById("CTCITDesc")
	if (obj1) obj1.disabled=false;
	obj1=document.getElementById("CLNEmail")
	if (obj1) obj1.disabled=false;
	obj1=document.getElementById("CLNFax")
	if (obj1) obj1.disabled=false;
	obj1=document.getElementById("CLNPhone")
	if (obj1) obj1.disabled=false;
	obj1=document.getElementById("CTZIPCode")
	if (obj1) obj1.disabled=false;
	obj1=document.getElementById("CLNDesc")
	if (obj1) obj1.disabled=false;
	obj1=document.getElementById("CLNDateTo")
	if (obj1) obj1.disabled=false;
	obj1=document.getElementById("CLNDateFrom")
	if (obj1) obj1.disabled=false;
	obj1=document.getElementById("CLNProviderNo")
	if (obj1) obj1.disabled=false;
	obj1=document.getElementById("CLNVEMD")
	if (obj1) obj1.disabled=false;
	obj1=document.getElementById("CLNBusPhone")
	if (obj1) obj1.disabled=false;
}

// cjb 24/04/2004 42990
function DefaultEmail() {
	var obj=document.getElementById("HiddenCLNEmail")
	var obj1=document.getElementById("CLNEmail1")
	if (obj) {
		obj1.value=obj.value;
	}
}

// cjb 24/04/2004 42990
function ContactChangeHandler() {
	// dummy
}

// cjb 15/04/2004 42990 start
function DisableLinks() {
	
	var obj=document.getElementById('clinic');
	if (obj) {
		obj.disabled=true;
		obj.onclick=LinkDisable;
	}
	setreadonly();
}

function EnableLinks() {
	
	var obj=document.getElementById('clinic');
	if (obj) {
		obj.disabled=false;
		obj.onclick=ClinicHandler;
	}
	// md 49260
	unsetreadonly();
}

function ClinicHandler(e) {
	var obj=document.getElementById("CLNCode");
	if ((obj)&&(obj.className=="clsInvalid")) {alert(t['InvalidClinicCode']); return}
	
	obj=websys_getSrcElement(e)
	var objid=document.getElementById("ClinicID")
	var url="websys.default.csp?WEBSYS.TCOMPONENT=PACClinic.Edit&ID="+objid.value
	websys_lu(url,false,"width=350,height=400")
	return false;
}

document.body.onload = BodyLoadHandler;