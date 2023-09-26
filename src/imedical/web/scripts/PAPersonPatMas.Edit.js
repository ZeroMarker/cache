// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function DocumentLoadHandler(e) {
	
	var PRS2Status=document.getElementById('PRS2Status');
	if ((PRS2Status)&&(PRS2Status.value=="S")) {
		DisableAllFields("",",update1,","")
	}

}


// LookupSelect functions copied from PAPerson.Edit.js

function CityLookupSelect(str) {
       //alert(str);
	//CityChangeHandler();
	//zipcode^suburb^state^address^region
	var lu = str.split("^");
	var obj=document.getElementById("CTZIPCode")
	if (obj) obj.value = lu[0];
 	var obj1=document.getElementById("CTCITDesc")
	if (obj1) obj1.value = lu[1];
	var obj=document.getElementById("PROVDesc")
	if (obj) obj.value = lu[2];
	var obj=document.getElementById("CTRGDesc")
	if (obj) obj.value = lu[4];
	// CJB 13/09/2002 - 28533: When you pick a suburb from lookup, the suburb overwrites address
	//var obj=document.getElementById("PAPERStNameLine1")
	//JW:removed - why is this here?
	//var obj=document.getElementById("PAPERForeignAddress");
	//if ((obj)&&(lu[4])) obj.value = lu[4];
	var obj=document.getElementById("HCADesc")
	if (obj) obj.value = lu[6];
	//CTCITDescAndCTZIPCode_BlurHandler2(obj1);

}

function CityAreaLookupSelect(str) {
 	var lu = str.split("^");
	var obj=document.getElementById("CTCITDesc")
	if (obj) obj.value = lu[0];
 	obj=document.getElementById("CTZIPCode")
	if (obj) obj.value = lu[1];
 	obj=document.getElementById("CITAREADesc")
	if (obj) obj.value = lu[2];
 	obj=document.getElementById("PROVDesc")
	if (obj) obj.value = lu[3];
}

function ZipLookupSelect(str) {
	//CityChangeHandler();
	//zipcode^suburb^state^address
 	var lu = str.split("^");
	var obj1=document.getElementById("CTZIPCode")
	if (obj1) obj1.value = lu[0];
 	var obj=document.getElementById("CTCITDesc")
	if (obj) obj.value = lu[1];
	var obj=document.getElementById("PROVDesc")
	if (obj) obj.value = lu[2];
	var obj=document.getElementById("CITAREADesc")
	if (obj) obj.value = lu[3];
	var obj=document.getElementById("CTRGDesc")
	if (obj) obj.value = lu[4];
	var obj=document.getElementById("HCADesc")
	if (obj) obj.value = lu[6];
	//CTCITDescAndCTZIPCode_BlurHandler2(obj1)
}

function CityDescLookupSelect(str) {
	//code,descn,prov,cit,cityarea,hca,region
	//alert(str);
 	var lu = str.split("^");
	var obj=document.getElementById("CTZIPDesc")
	if (obj) obj.value = lu[1];
 	var obj1=document.getElementById("CTZIPCode")
	if (obj1) obj1.value = lu[0];
	var obj1=document.getElementById("CTCITDesc")
	if (obj1) obj1.value = lu[3];
	var obj=document.getElementById("PROVDesc")
	if (obj) obj.value = lu[2];
	var obj=document.getElementById("CITAREADesc")
	if (obj) obj.value = lu[4];
	var obj=document.getElementById("CTRGDesc")
	if (obj) obj.value = lu[6];
	//var obj=document.getElementById("HCADesc")
	//if (obj) obj.value = lu[5];
	//CTCITDescAndCTZIPCode_BlurHandler2(obj1)

}

function ProvinceLookupSelect(str) {
 	var lu = str.split("^");
	var obj=document.getElementById("PROVDesc")
	if (obj) obj.value = lu[0];
	
	//CTCITDescAndCTZIPCode_BlurHandler2(obj);
}



function ViewFamilyDrLookUp(str) {
	//alert(str);
	var lu = str.split("^");
	var fulladdress="";
	// cjb 03/02/2005 49474 - fulladdress now returned from the query
	if (lu[29]!="") {fulladdress=lu[29];}
	if (fulladdress=="") {
		if (lu[17]!="") {fulladdress=lu[17];}
		if (lu[10]!="") {fulladdress=fulladdress+","+lu[10];}
		if (lu[18]!="") {fulladdress=fulladdress+","+lu[18];}	
		if (lu[19]!="") {fulladdress=fulladdress+","+lu[19];}
	}
	var obj;
	obj=document.getElementById("GPCode");
	if (obj) obj.value = lu[5];
	var obj1=document.getElementById("REFDDesc");
	if (obj1) obj1.value = lu[1];
	obj=document.getElementById("DoctorCode");
	if (obj) obj.value = lu[4];
 	obj=document.getElementById("CLNCode");
	if (obj) obj.value = lu[7];
	obj=document.getElementById("CLNAddress1");
	//if (obj) obj.value = lu[10];
	if (obj) obj.value = fulladdress;
	obj=document.getElementById("PAPERFamilyDoctorClinicDR");
	if (obj) obj.value = lu[8];
	obj=document.getElementById("CLNPhone");
	if (obj) obj.value = lu[12];
	//md 29/01/2003
	obj=document.getElementById("REFDTitle");
	if (obj) obj.value = lu[0];
 	obj=document.getElementById("REFDForename");
	if (obj) obj.value = lu[3];
 	obj=document.getElementById("ClinDesc");
	if (obj) obj.value = lu[17];
 	obj=document.getElementById("ClinCity");
	if (obj) obj.value = lu[18];
 	obj=document.getElementById("ClinZip");
	if (obj) obj.value = lu[19];
	
	obj=document.getElementById("GPHCADesc");
	if (obj) obj.value = lu[22];
	if (lu[15]=="Y") setTimeout('alert(\''+t['ExpiredRefDoctor']+'\')',50);
	//md 16/05/2003 do not show confirmation for docchanging if multy active GP 
	//obj=document.getElementById("MultiActiveGP");
	//if (((obj)&&(obj.value!="Y"))||(!obj))
	//{
	//confirmChangeDoc()
	//}	
	//confirmChangeDoc();
}

function CTMARDescLookupSelect(str) {
	var lu = str.split("^");
	var objCTMARDesc=document.getElementById("CTMARDesc");
	if (objCTMARDesc) { objCTMARDesc.value=lu[0]; }
	//ReplaceHiddenCodeGlobal(1,lu[2],lu[3]);
	try {
		Custom_CTMARDescLookupSelect(str);
	} catch(e) { 
		}	finally  {
	}
}


function ASSISelect(str) {
	var lu = str.split("^");
	var objASSISDesc=document.getElementById("ASSISDesc");
	if (objASSISDesc) { objASSISDesc.value=lu[0]; }	
	//ReplaceHiddenCodeGlobal(2,lu[2],lu[3]);
	try {
		Custom_ASSISelect(str);
	} catch(e) { 
		}	finally  {
	}
}


function SexLookUp(str) {
	//if (confirmAlias=="Y") {
	//	SexChangeHandler();
	//}	
}

function CBirthSelect(str) {
	try {
		Custom_CBirthSelect(str);
	} catch(e) { 
		}	finally  {
	}
}


function CityBirthLookupSelect(str) {
	try {
		Custom_CityBirthLookupSelect(str);
	} catch(e) { 
		}	finally  {
	}
}




document.body.onload=DocumentLoadHandler;

