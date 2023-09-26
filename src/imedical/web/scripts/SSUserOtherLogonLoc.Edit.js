// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

//KK 15.01.04 L:39410
function OTHLLHospitalDRLookUpSelect(str) {
	var lu = str.split("^");
	var obj;
	var obj=document.getElementById("HospitalID");
	if (obj) obj.value = lu[1]
}

function LocationLookUpSelect(str) {
	var lu = str.split("^");
	var obj;
	var obj=document.getElementById("HospitalID");
	if (obj) obj.value = lu[7];
	var obj=document.getElementById("OTHLLHospitalDR");
	if (obj) obj.value = lu[4];
	
}

function LocHospBlurHandler() {
    var objid=document.getElementById("HospitalID");
    var objld=document.getElementById("Location");
    // ab 17.01.05 - 48632
    var objhosp=document.getElementById("OTHLLHospitalDR");
    if ((objhosp)&&(objhosp.value=="")) {
	if (objid) objid.value="";
        //if ((objld)&&(objld.value=="")&&(objid)) objid.value="";
    }
}

function OTHLLHospitalDR_lookuphandlerCustom(e) {
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))) {
   		LocHospBlurHandler();
		OTHLLHospitalDR_lookuphandler(e);
	}
}


function DocumentLoadHandler() {
         var obj=document.getElementById("OTHLLHospitalDR");
         if (obj) obj.onblur=LocHospBlurHandler;
         var obj=document.getElementById("Location");
         if (obj) obj.onblur=LocHospBlurHandler;	
	// cjb 21/03/2005 50946 - added custom lookup handler that runs the blur handler (clears hidden field) before running the generated lookup handler
	var objhosp=document.getElementById("OTHLLHospitalDR");
	if (objhosp) objhosp.onkeydown=OTHLLHospitalDR_lookuphandlerCustom;
}

document.body.onload=DocumentLoadHandler;