// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var objADDREmail=document.getElementById("ADDREmail")

function DocumentLoadHandler() {
	//alert("js loaded");
	if (objADDREmail) objADDREmail.onchange=isEmail;
	//rqg,log23316: Set PARREF equal to Care Provider ID if not the same
	var objPARREF=document.getElementById("PARREF");
	var objProvID=document.getElementById("CareProvID");
	var objAddrPARREF=document.getElementById("ADDRParRef");
	var objID=document.getElementById("ID");
	//alert("ID="+objID.value);
	if ((objID)&&(objID.value=="")) {
	   if ((objPARREF)&&(objProvID)) {
		if (objPARREF.value!=objProvID.value) {
			objPARREF.value=objProvID.value;
			objAddrPARREF=objProvID.value;
		}
	  }
	}
	
	var obj=document.getElementById("ADDRDateFrom");
	if (obj) obj.onblur=StartDateBlurHandler;
}

function StartDateBlurHandler(e) {
	var eobj=websys_getSrcElement(e);
	if (eobj) {
		var obj=document.getElementById("ADDRDateFromH");
		if ((obj)&&(eobj.value!="")) obj.value=DateStringTo$H(eobj.value);
		if ((obj)&&(eobj.value=="")) obj.value="";
	}
}

function EnablePrefMethod() {
	var objPrefMet=document.getElementById("ADDRPrefMethod");
	if ((objPrefMet) && (objPrefMet.checked)) objPrefMet.disabled=false;
}

function ZipLookupSelect(str) {
 	var lu = str.split("^");
	var obj;
 	obj=document.getElementById("CTZIPDesc")
	if (obj) obj.value = lu[0];
 	obj=document.getElementById("CTCITDesc")
	if (obj) obj.value = lu[1];
	obj=document.getElementById("PROVDesc")
	if (obj) obj.value = lu[2];
}

//check for a valid email address
/* JW: moved to websys.Edit.Tools.js
function isEmail() {
	// SA 15.8.02 - log 23316: This function has been taken from PAPerson.Edit
	//alert("checking email");

	var reEmail = /^.+\@.+\..+$/

  	if ((objADDREmail)&&(objADDREmail.value!="")) {
  		if (!(reEmail.test(objADDREmail.value))) {
			alert("\'" + t['ADDREmail'] + "\' " + t['XINVALID'] + "\n");
			objADDREmail.focus();
			return false;
	    	}
	}
	return true;
} */

document.body.onload=DocumentLoadHandler;
