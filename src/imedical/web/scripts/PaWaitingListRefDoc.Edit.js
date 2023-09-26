// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
// rqg, 8.05.02 - 24812 - Populate Clinic field
var obj=document.getElementById('ID');
if ((obj)&&(obj.value=="")) {
	var obj=document.getElementById('REFDDesc');
	if (obj) obj.onkeydown=REFDDesc_lookuphandlerCustom;
	var obj=document.getElementById('ld1184iREFDDesc');
	if (obj) obj.onclick=REFDDesc_lookuphandlerCustom;
}
var objDoctor=document.getElementById("REFDDesc");
if (objDoctor) websys_setfocus("REFDDesc");

function LookupDoctorFill(str) {
	//alert(str);
	var lu = str.split("^");
	var objCLNCode=document.getElementById("CLNCode");
	if (objCLNCode) objCLNCode.value=lu[3];
	// RQG 11.12.02 - Log29267 Populate the "Type" field for new Doctor
	var objREFDType=document.getElementById("REFDType");
	if (objREFDType) {
		objREFDType.value=lu[12];
		//websys_nextfocus(objREFDType.sourceIndex);
	}
}

function TypeCodeConvert (str)
{
	//alert(str);
  	var lu = str.split("^");
	var obj=document.getElementById("TypeCode");
	if (obj) obj.value=lu[2];
}
function DrLookUp(str) {
	//alert(str);
	//structure as on 18/07/2003
	//(DocTitle,DocDesc,DocMname,DocFname,refdId,DocCode,DocSpec,ClinCode,clinId,ClinProvNo,ClinAddr,ClinSuburb,tele,clindatefrom,clindateto,expired,type,ClinDesc,ClinCity,ClinZip)
	// 0       ,1      ,2       ,3       ,4     ,5 	    ,6      ,7       ,8     ,9         ,10      ,11        ,12  ,13          ,14        ,15     ,16  ,17      ,18      ,19
	//MD 18/07/2003
	//structrure as on 29/04/2004
	//(DocTitle,DocDesc,DocMname,DocFname,refdId,DocCode,DocSpec,ClinCode,clinId,ClinProvNo,ClinAddr,ClinSuburb,tele,clindatefrom,clindateto,expired,type,ClinDesc,ClinCity,ClinZip,DoctorProvNo,DocZip,DocHCA)
	// 0       ,1      ,2       ,3       ,4     ,5 	    ,6      ,7       ,8     ,9         ,10      ,11        ,12  ,13          ,14        ,15     ,16  ,17      ,18      ,19,	     20,	     ,21   ,22
	var lu = str.split("^");
	alert(lu);
	//md 16/10/2003
	var fulladdress=""
	if (lu[17]!="") {fulladdress=lu[17];}
	if (lu[10]!="") {fulladdress=fulladdress+","+lu[10];}
	if (lu[18]!="") {fulladdress=fulladdress+","+lu[18];}
	if (lu[19]!="") {fulladdress=fulladdress+","+lu[19];}
	var obj;
	obj=document.getElementById("GPCode")
	if (obj) obj.value = lu[5];
	var obj1=document.getElementById("REFDDesc")
	if (obj1) obj1.value = lu[1];
	obj=document.getElementById("DocID");
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


function REFDDesc_lookuphandlerCustom(e) {
	//alert("LookUpOne");
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))) {
		var namevaluepairs="&P1=&P2=&P3=&P5=";
		var obj=document.getElementById('REFDDesc');
		var obj2=document.getElementById('TypeCode');

		if (obj) {namevaluepairs="&P1="+obj.value+"&P2=&P3=&P5="+obj2.value;}
		REFDDesc_lookuphandlerCustom2(namevaluepairs);
	}
}
function REFDDesc_lookuphandlerCustom2(namevaluepairs) {
	//alert("LookUpTwo");
	var url='websys.lookup.csp';
	//url += "?ID=d1184iFAMDFamDocDR&WEBSYS.TCOMPONENT=PACRefDoctor.CustomFind"+namevaluepairs;
	url += "?ID=d1184iREFDDesc&WEBSYS.TCOMPONENT=PACRefDoctor.CustomFind&CONTEXT=Kweb.PACRefDoctor:LookUpDoctor&TLUJSF=DrLookUp"+namevaluepairs;
	var tmp=url.split('%');
	url=tmp.join('%25');
	//alert(url)
	// Log 59598 - BC - 29-06-2006 : remove statusbar variable (status=) to display the status bar.
	websys_createWindow(url,"lookup","top=30,left=20,width=620,height=420,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
	return websys_cancel();
}