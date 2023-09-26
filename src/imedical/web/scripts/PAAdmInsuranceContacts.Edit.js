// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var frm = document.forms["fPAAdmInsuranceContacts_Edit"];

function DocumentLoadHandler(e) {

	var obj;
	
	obj=document.getElementById('update1')
	if (obj) obj.onclick = UpdateHandler;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateHandler;
	
}

function UpdateHandler() {
	if (parent.frames["InsContact_edit"]) {
		
		frm.elements['TFRAME'].value=window.parent.name;
	
	}

	var obj=document.forms['fPAAdmInsuranceContacts_Edit'].elements['TWKFLI'];
	if (!(fPAAdmInsuranceContacts_Edit_submit())) return false
	if (obj.value!="") obj.value-=1;
			
	return update1_click();
}



// ------------------------------------
// Geographic Information

function CityLookupSelect(str) {
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
	var obj=document.getElementById("HCADesc")
	if (obj) obj.value = lu[6];

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
}

function NOKZipLookupSelect(str) {
 	var lu = str.split("^");
	var obj;
 	obj=document.getElementById("NOKCTZIPCode")
	if (obj) obj.value = lu[0];
 	obj=document.getElementById("NokCTCITDesc")
	if (obj) obj.value = lu[1];
}

function ProvinceLookupSelect(str) {
 	var lu = str.split("^");
	var obj=document.getElementById("PROVDesc")
	if (obj) obj.value = lu[0];
}

function CTCITDescAndCTZIPCode_BlurHandler2(obj) {
	eSrc=obj;
	
	if (eSrc.defaultValue!="")	{
		if (!AskedForSaveAddress) {
			if ((eSrc.value!=eSrc.defaultValue)&&(eSrc.value!="")) {
				AskedForSaveAddress=1;
				registeringAddressChange();
			}
		}
	}
	if ((obj)&&(obj.id!="PROVDesc")) { CheckOverseas();}
}

function convertAddress(e) {  //extended function in CUSTOMS
	if ((e)&&(e.id)) var obj=e
	else var obj=websys_getSrcElement(e);
	
	var obj=websys_getSrcElement(e);
	var obj1=document.getElementById("PAPERStNameLine1");
	var obj2=document.getElementById("CTCITDesc");
	var obj3=document.getElementById("CTZIPCode");
	if (((obj1)&&(obj1.defaultValue!=""))||((obj2)&&(obj2.defaultValue!=""))||((obj3)&&(obj3.defaultValue!=""))) {
		if (!AskedForSaveAddress) {
			if (obj.value!=obj.defaultValue) {
				AskedForSaveAddress=1;
				registeringAddressChange();
			}
		}
	}
}

function convertDoc(e) {
	var obj=websys_getSrcElement(e);
	if (obj.defaultValue!="") {
		if (obj.defaultValue!="")	{
		if (!AskedForSaveDoc) {
			if (obj.value!=obj.defaultValue) {
				AskedForSaveDoc=1;
				registeringDocChange();
				}
			}
		}
	}
}






window.onload = DocumentLoadHandler;



