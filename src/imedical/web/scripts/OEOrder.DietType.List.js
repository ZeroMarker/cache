// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 


function HospLookup(txt) {
	var adata=txt.split("^");
	var HospID=adata[1];
	var OrigHospVal="";
	var hobj=document.getElementById("hospID");
	if (hobj) {
		OrigHospVal=hobj.value;
		hobj.value=HospID;
	}
	if(OrigHospVal!=HospID) {
		var obj=document.getElementById("Location");
		if (obj) obj.value="";
	}
}

var HObj=document.getElementById("Hospital");
if(HObj) HObj.onblur=HospitalBlurHandler;

function HospitalBlurHandler() {

	var HospObj=document.getElementById("Hospital");
	var Hobj=document.getElementById("hospID");
	if((HospObj)&&(HospObj.value=="")) Hobj.value="";
}


