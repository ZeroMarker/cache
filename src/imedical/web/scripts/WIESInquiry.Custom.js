// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function DocumentLoadHandler() {
	var name;
	var objSameDay=document.getElementById("SameDay");
	var objLOS=document.getElementById("LOS");
	var objMVH=document.getElementById("MVH");
	var objDRGVersion=document.getElementById("DRGVersion");
	var objDRGCode=document.getElementById("DRGCode");
	var objWIESVersion=document.getElementById("WIESVersion");


	if (objDRGVersion) objDRGVersion.onblur=MRCDRGVersionChangeHandler;
	if (objDRGCode) objDRGCode.onblur=DRGCodeChangeHandler;
	if (objWIESVersion) objWIESVersion.onblur=WIESVersionChangeHandler;

	//if (objLOS) objLOS.onchange=SetSameDayValue;
	if (objLOS) objLOS.onblur=SetSameDayValue;
	if ((objLOS)&&(objLOS.value==1)) {
		if (objSameDay) objSameDay.disabled=false;
	} else {
		if (objSameDay) objSameDay.disabled=true;
	}

	if (objMVH) objMVH.onblur=CheckMechVentHours;

	var frm=document.forms["fWIESInquiry_Custom"];
	//alert(frm.elements.length);
	// RQG 28.11.02 - Log28512: Bypass focus on DRG Version field
	for (var i=0;i<frm.elements.length;i++) {
		if (frm.elements[i].name==objDRGVersion.name) {
			name=frm.elements[i+1].name;
		}
	}
	websys_setfocus(name);

}

function SetSameDayValue() {
	var objSameDay=document.getElementById("SameDay");
	var objLOS=document.getElementById("LOS");
	if ((objLOS)&&(objLOS.value==1)) {
		if (objSameDay) objSameDay.disabled=false;
	} else {
		if (objSameDay) {
			objSameDay.checked=false;
			objSameDay.disabled=true;
		}
	}
}

function CheckMechVentHours() {
	var objLOS=document.getElementById("LOS");
	var objMVH=document.getElementById("MVH");
	var maxhrs;
	if (objLOS)	maxhrs=objLOS.value * 24;
	if (objMVH) {
		if (objMVH.value > maxhrs) {
			alert(t['MAX_HRS_EXCEEDED']+" "+maxhrs);
			websys_setfocus("MVH");
			return false;
		}
	}
	return true;
}
	
function MRCDRGVersionLookUpHandler(str) {
	//alert(str);
 	var lu = str.split("^");
	var obj;
	obj=document.getElementById("DRGVersion");
	if (obj) obj.value = lu[0];
	obj=document.getElementById("DRGVersionStartDate");
	if (obj) obj.innerText = lu[3];
	obj=document.getElementById("DRGVersionEndDate");
	if (obj) obj.innerText = lu[4];
}

function MRCDRGVersionChangeHandler() {
	//alert("MRCDRGVersionChangeHandler");
	var objDRGVersion=document.getElementById("DRGVersion");
	if ((objDRGVersion)&&(objDRGVersion.value=="")) {
		var obj;
		obj=document.getElementById("DRGVersionStartDate");	
		if (obj) obj.innerText ="";
		obj=document.getElementById("DRGVersionEndDate");	
		if (obj) obj.innerText ="";
	}
}

function WIESVersionChangeHandler() {
	//alert("WIESVersionChangeHandler");
	var objWIESVersion=document.getElementById("WIESVersion");
	if ((objWIESVersion)&&(objWIESVersion.value=="")) {
		var obj=document.getElementById("WIESCode");	
		if (obj) obj.value="";
	}
}

function LookUpDRGCodeSelect(str) {
	//alert(str);
 	var lu = str.split("^");
	var obj;
	obj=document.getElementById("DRGCode")
	if (obj) obj.value = lu[0];
	obj=document.getElementById("DRGDesc")
	if (obj) obj.innerText = lu[1];
}

function DRGCodeChangeHandler() {
	var objDRGCode=document.getElementById("DRGCode");
	if ((objDRGCode)&&(objDRGCode.value=="")) {
		var obj;
		obj=document.getElementById("DRGDesc");	
		if (obj) obj.innerText ="";
	}
}

function LookUpWIESVersionSelect(str) {
 	//alert(str);
	var lu = str.split("^");
	var obj;
	obj=document.getElementById("WIESVersion")
	if (obj) obj.value = lu[2];
	obj=document.getElementById("WIESCode")
	if (obj) obj.value = lu[0];
}

document.body.onload=DocumentLoadHandler;
