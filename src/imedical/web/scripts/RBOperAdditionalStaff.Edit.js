// Copyright (c) 2004 TrakHealth Pty Limited. ALL RIGHTS RESERVED.


function DocumentLoadHandler() {
	var obj = document.getElementById("update1");
	if (obj) {
		obj.onclick = UpdateClickHandler;
		if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateClickHandler;
	}

	obj=document.getElementById('RBOPASCareProvType');
	if (obj) obj.onblur=DoCareProvTypeValidation;

	DoInitHInternalCode();

}

function UpdateClickHandler() {
	var frm = document.forms["fRBOperAdditionalStaff_Edit"];
	if (parent.frames["frm_edit"]) {
		frm.elements['TFRAME'].value=window.parent.name;
	}
	var obj=frm.elements['TWKFLI'];
	if (!(fRBOperAdditionalStaff_Edit_submit())) return false
	if (obj.value!="") obj.value-=1;
		
	return update1_click()

}

//If the careprovtype is blanked out, set HCareProvTypeId and HCPInternalCode to blank
//This is executed when page is loaded and everytime value in care provider type is changed.
function DoCareProvTypeValidation(){
	var objId = document.getElementById("HCareProvTypeId");
	var obj = document.getElementById("RBOPASCareProvType");
	var obj2 = document.getElementById("HCPInternalCode");
	var obj3 = document.getElementById("HCPFlag");
	if (objId && obj){ 
		if(obj.value == ""){ 
			objId.value = "";
			if(obj2) obj2.value = "";
			if(obj3) obj3.value = "";
		}
	}
}

//When a lookup is done on CareProvType, HCareProvTypeId is populated with the ID.
function RBOPASCareProvTypeLookUpHandler(str) {
	var lu=str.split("^");
	var obj=document.getElementById("HCareProvTypeId");
	var obj2=document.getElementById("HCPInternalCode");
	var obj3 = document.getElementById("HCPFlag");
	if (obj && obj2 && obj3) {
		obj.value=lu[1];
		if(lu[1]=="AA" || lu[1]=="SA") obj2.value = "DOCTOR";
		//if(lu[1]=="AA") obj3.value = "^Y^";
		//if(lu[1]=="SA") obj3.value = "^^Y";
		if(lu[1]=="AA") obj3.value = "|Y";
		if(lu[1]=="SA") obj3.value = "||Y";
		if(lu[1]=="SN" || lu[1]=="CN") {
			obj2.value = "NURSE";
			obj3.value="";
		}
		if(lu[1]=="O") {
			obj2.value="DOCTOR^NURSE";
			obj3.value="";
		}
	}
}

//This is run when the page loads.
//HCPInternalCode and HCPFlag are used as parameters for CT_CareProv lookup
function DoInitHInternalCode(){
	var obj=document.getElementById("HCareProvTypeId");
	var obj2=document.getElementById("HCPInternalCode");
	var obj3 = document.getElementById("HCPFlag");
	if (obj && obj2 && obj3) {
		if(obj.value=="AA" || obj.value=="SA") obj2.value = "DOCTOR";
		//if(obj.value=="AA") obj3.value = "^Y^";
		//if(obj.value=="SA") obj3.value = "^^Y";
		if(obj.value=="AA") obj3.value = "|Y";
		if(obj.value=="SA") obj3.value = "||Y";
		if(obj.value=="SN" || obj.value=="CN"){ 
			obj2.value = "NURSE";
			obj3.value = "";
		}
		if(obj.value=="O") {
			obj2.value="DOCTOR^NURSE";
			obj3.value="";
		}
	}
}

function RBOPASCareProvDRLookUpHandler(str) {
	//alert(str)
	var lu=str.split("^");
	var obj=document.getElementById("RBOPASCareProvDR");
	var obj1=document.getElementById("CareProvType");
	if (lu[0]&&obj)  obj.value=lu[0];
	if (lu[4]&&obj1)  obj1.value=lu[4];
	
	
}



document.body.onload = DocumentLoadHandler;

