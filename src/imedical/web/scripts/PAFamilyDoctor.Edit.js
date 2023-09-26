// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 


function BodyLoadHandler() {
	removereadonly();
	var obj=document.getElementById('ID');
	if ((obj)&&(obj.value=="")) {
		var obj=document.getElementById('FAMDFamDocDR');
		if (obj) obj.onblur=InternalDrChangeHandler;
	}
	if ((obj)&&(obj.value!="")) {
		var obj1=document.getElementById('FAMDFamDocDR');
		if (obj1) obj1.disabled=true;
		var obj1=document.getElementById('ld1184iFAMDFamDocDR');
		if (obj1) obj1.disabled=true;
	}
	setreadonly();
	var obj=document.getElementById('update1');
	if (obj) obj.onclick = UpdateClickHandler;
	
}

function setreadonly() {
	var obj1;
	var obj1=document.getElementById("CLNAddress1")
	//if (obj1) obj1.disabled=true;
	if (obj1) obj1.readOnly=true;
	var obj1=document.getElementById("FAMDRefDocClincDR")
	if (obj1) obj1.disabled=true;
	var obj1=document.getElementById("CLNProviderNo")
	if (obj1) obj1.disabled=true;
	var obj1=document.getElementById("REFDCode");
	if (obj1) obj1.disabled=true;
	var obj1=document.getElementById("CLNCity");
	if (obj1) obj1.disabled=true;
	var obj1=document.getElementById("ld1184iCLNCity");
	if (obj1) obj1.disabled=true;
	
}
function removereadonly() {
	var obj1;
	var obj1=document.getElementById("CLNAddress1")
	//if (obj1) obj1.disabled=false;
	if (obj1) obj1.readOnly=false;
	var obj1=document.getElementById("FAMDRefDocClincDR")
	if (obj1) obj1.disabled=false;
	var obj1=document.getElementById("CLNProviderNo")
	if (obj1) obj1.disabled=false;
	var obj1=document.getElementById("REFDCode");
	if (obj1) obj1.disabled=false;
	var obj1=document.getElementById("CLNCity");
	if (obj1) obj1.disabled=false;
	var obj1=document.getElementById("ld1184iCLNCity");
	if (obj1) obj1.disabled=false;
	var obj1=document.getElementById("FAMDFamDocDR");
	if (obj1) obj1.disabled=false;
	
}
function DrLookUp(str) {
	//structure as on 17/10/2003
	//(DocTitle,DocDesc,DocMname,DocFname,refdId,DocCode,DocSpec,ClinCode,clinId,ClinProvNo,ClinAddr,ClinSuburb,tele,clindatefrom,clindateto,expired,type,ClinDesc,ClinCity,ClinZip)
	//  0	     1	     2	     3	      4	     5 	      6	     7         8      9	        10	     11	       12	  13	    14     15      16   17       18       19
	//MD 17/10/2003
	//alert(str);
	var lu = str.split("^");
	var fulladdress=""
	// cjb 03/02/2005 49474 - fulladdress now returned from the query
	if (lu[29]!="") {fulladdress=lu[29];}
	if (fulladdress=="") {
		if (lu[17]!="") {fulladdress=lu[17];}
		if (lu[10]!="") {fulladdress=fulladdress+","+lu[10];}
		if (lu[18]!="") {fulladdress=fulladdress+","+lu[18];}	
		if (lu[19]!="") {fulladdress=fulladdress+","+lu[19];}
	}	
	//MD 17/10/2003
	var obj;
	var obj=document.getElementById("FAMDFamDocDR")
	if (obj) obj.value = lu[1];
	obj=document.getElementById("REFDCode");
	if (obj) obj.value = lu[5];
 	
 	// cjb 25/08/2004 45838
 	obj=document.getElementById("RefDocClinc");
	if (obj) obj.value = lu[8];
 	obj=document.getElementById("FAMDRefDocClincDR");
	if (obj) obj.value = lu[7];
 	obj=document.getElementById("CLNProviderNo");
	if (obj) obj.value = lu[9];
	obj=document.getElementById("CLNAddress1");
	//if (obj) obj.value = lu[10];
	if (obj) obj.value = fulladdress;
	obj=document.getElementById("CLNCity");
	if (obj) obj.value = lu[19];
	obj=document.getElementById("REFDTitle");
	if (obj) obj.value = lu[0];
 	obj=document.getElementById("REFDForename");
	if (obj) obj.value = lu[3];
	if (lu[15]=="Y") setTimeout('alert(\''+t['ExpiredRefDoctor']+'\')',50);
 	obj=document.getElementById("RefDoc");
	if (obj) obj.value = lu[4];
}
function InternalDrChangeHandler(e) {
	// clear the ref doctor address fields if blank.
	var obj=document.getElementById("FAMDFamDocDR");
	if ((obj)&&(obj.value=="")) {
	obj=document.getElementById("REFDCode")
	if (obj) obj.value ="";
	obj=document.getElementById("FAMDRefDocClincDR");
	if (obj) obj.value ="";
 	obj=document.getElementById("CLNAddress1");
	if (obj) obj.value ="";
 	obj=document.getElementById("REFDTitle");
	if (obj) obj.value ="";
 	obj=document.getElementById("REFDForename");
	if (obj) obj.value = "";
	obj=document.getElementById("CLNProviderNo");
	if (obj) obj.value = "";
	obj=document.getElementById("CLNCity");
	if (obj) obj.value = "";
	}
}



function ClinicLookUp(str) {
	var lu = str.split("^");
	var obj="";
	var obj1="";
	//alert(str);
	
	obj=document.getElementById("FAMDRefDocClincDR")
	if (obj) obj.value = lu[0];
	obj1=document.getElementById("CLNAddress1")
	if (obj1) obj1.value = lu[14];
	obj1=document.getElementById("CLNProviderNo")
	if (obj1) obj1.value = lu[13];
	obj1=document.getElementById("Clinic")
	if (obj1) obj1.value = lu[12];
	obj1=document.getElementById("RefDocClinc")
	if (obj1) obj1.value = lu[15];
	obj1=document.getElementById("CLNCity")
	if (obj1) obj1.value = lu[10];
	
}



function UpdateClickHandler(evt) {
	removereadonly();
	return update1_click();
}

document.body.onload = BodyLoadHandler;
