// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function EditInit() {
	websys_firstfocus();
	
	var obj;
	
	var objid=document.getElementById('ID')
	if (objid!="") {
	
	obj=document.getElementById('SURName')
	if ((obj)&&(obj.value!=="")) DisableExceptSURName();
	//if (obj) obj.onchange=DisableExceptSURName;
	
	obj=document.getElementById('SURDob')
	if ((obj)&&(obj.value!=="")) DisableExceptSURDob();
	//if (obj) obj.onblur=DisableExceptSURDob;
	
	obj=document.getElementById('GivenName')
	if ((obj)&&(obj.value!=="")) DisableExceptGivenName();
	//if (obj) obj.onchange=DisableExceptGivenName;
	
	obj=document.getElementById('OtherName')
	if ((obj)&&(obj.value!=="")) DisableExceptOtherName();
	//if (obj) obj.onchange=DisableExceptOtherName;
	
	obj=document.getElementById('CTSEXDesc')
	if ((obj)&&(obj.value!=="")) DisableExceptCTSEXDesc();
	}
	//alert(obj.value);
	//alert(obj.defaultvalue);
	//if (obj) obj.onblur=DisableExceptCTSEXDesc;

	//md 18/03/2004 code to keep enabled all fields that have values if error message
	//was displayed to have OK Update

	obj=document.getElementById('SURName')
	if ((obj)&&(obj.value!=="")) 
	{
		obj.disabled=false;
		obj.className = "";
	}
	obj=document.getElementById('SURDob')
	if ((obj)&&(obj.value!=="")) 
	{
		obj.disabled=false;
		obj.className = "";
		obj=document.getElementById('ld1762iSURDob')
		if (obj) {
		obj.disabled=false;
		obj.className = "";
		         }
	}
	obj=document.getElementById('GivenName')
	if ((obj)&&(obj.value!=="")) 
	{
		obj.disabled=false;
		obj.className = "";
	}
	obj=document.getElementById('OtherName')
	if ((obj)&&(obj.value!=="")) 
	{
		obj.disabled=false;
		obj.className = "";
	}
	obj=document.getElementById('CTSEXDesc')
	if ((obj)&&(obj.value!=="")) 
	{
		obj.disabled=false;
		obj.className = "";
		obj=document.getElementById('CTSEXDesc')
		if (obj) {
		obj.disabled=false;
		obj.className = "";
	                 }
	}
	//md 18/03/2004


}




function DisableExceptSURName() {
	obj=document.getElementById('SURDob')
	if (obj) {
		obj.disabled=true;
		obj.className = "disabledField";
	}
	obj=document.getElementById('ld1762iSURDob')
	if (obj) {
		obj.disabled=true;
		obj.className = "disabledField";
	}
	obj=document.getElementById('GivenName')
	if (obj) {
		obj.disabled=true;
		obj.className = "disabledField";
	}
	obj=document.getElementById('OtherName')
	if (obj) {
		obj.disabled=true;
		obj.className = "disabledField";
	}
	obj=document.getElementById('CTSEXDesc')
	if (obj) {
		obj.disabled=true;
		obj.className = "disabledField";
	}
	obj=document.getElementById('ld1762iCTSEXDesc')
	if (obj) {
		obj.disabled=true;
		obj.className = "disabledField";
	}
}


function DisableExceptSURDob() {
	var obj1=document.getElementById('SURDob');
	obj=document.getElementById('SURName')
	if ((obj)&&(obj1.value!="")) {
		obj.disabled=true;
		obj.className = "disabledField";
	}
	obj=document.getElementById('GivenName')
	if ((obj)&&(obj1.value!="")) {
		obj.disabled=true;
		obj.className = "disabledField";
	}
	obj=document.getElementById('OtherName')
	if ((obj)&&(obj1.value!="")) {
		obj.disabled=true;
		obj.className = "disabledField";
	}
	obj=document.getElementById('CTSEXDesc')
	if ((obj)&&(obj1.value!="")) {
		obj.disabled=true;
		obj.className = "disabledField";
	}
	obj=document.getElementById('ld1762iCTSEXDesc')
	if ((obj)&&(obj1.value!="")) {
		obj.disabled=true;
		obj.className = "disabledField";
	}
}


function DisableExceptGivenName() {
	obj=document.getElementById('SURDob')
	if (obj) {
		obj.disabled=true;
		obj.className = "disabledField";
	}
	obj=document.getElementById('ld1762iSURDob')
	if (obj) {
		obj.disabled=true;
		obj.className = "disabledField";
	}
	obj=document.getElementById('SURName')
	if (obj) {
		obj.disabled=true;
		obj.className = "disabledField";
	}
	obj=document.getElementById('OtherName')
	if (obj) {
		obj.disabled=true;
		obj.className = "disabledField";
	}
	obj=document.getElementById('CTSEXDesc')
	if (obj) {
		obj.disabled=true;
		obj.className = "disabledField";
	}
	obj=document.getElementById('ld1762iCTSEXDesc')
	if (obj) {
		obj.disabled=true;
		obj.className = "disabledField";
	}
}


function DisableExceptOtherName() {
	obj=document.getElementById('SURDob')
	if (obj) {
		obj.disabled=true;
		obj.className = "disabledField";
	}
	obj=document.getElementById('ld1762iSURDob')
	if (obj) {
		obj.disabled=true;
		obj.className = "disabledField";
	}
	obj=document.getElementById('GivenName')
	if (obj) {
		obj.disabled=true;
		obj.className = "disabledField";
	}
	obj=document.getElementById('SURName')
	if (obj) {
		obj.disabled=true;
		obj.className = "disabledField";
	}
	obj=document.getElementById('CTSEXDesc')
	if (obj) {
		obj.disabled=true;
		obj.className = "disabledField";
	}
	obj=document.getElementById('ld1762iCTSEXDesc')
	if (obj) {
		obj.disabled=true;
		obj.className = "disabledField";
	}
}

function DisableExceptCTSEXDesc() {
	var obj1=document.getElementById('CTSEXDesc');
	obj=document.getElementById('SURDob')
	if ((obj)&&(obj1.value!="")) {
		obj.disabled=true;
		obj.className = "disabledField";
	}
	obj=document.getElementById('ld1762iSURDob')
	if (obj) {
		obj.disabled=true;
		obj.className = "disabledField";
	}
	obj=document.getElementById('GivenName')
	if ((obj)&&(obj1.value!="")) {
		obj.disabled=true;
		obj.className = "disabledField";
	}
	obj=document.getElementById('SURName')
	if ((obj)&&(obj1.value!="")) {
		obj.disabled=true;
		obj.className = "disabledField";
	}
	obj=document.getElementById('OtherName')
	if ((obj)&&(obj1.value!="")) {
		obj.disabled=true;
		obj.className = "disabledField";
	}
}




document.body.onload=EditInit;