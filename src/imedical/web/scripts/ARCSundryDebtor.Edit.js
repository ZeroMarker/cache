
// Copyright (c) 2004 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function BodyLoadHandler(){
	var ID;
	var objID = document.getElementById("ID");
	if (objID) ID=objID.value;
	
	if (window.opener && window.opener.name=="SundryDetails") {

		var objUpdate = document.getElementById("update1");
		if (objUpdate) objUpdate.onclick=UpdateClickHandler;
		
		var objViewBill = document.getElementById("ViewBills");
		if (objViewBill) {
			objViewBill.disabled=true;
			objViewBill.onclick=LinkDisable;
		}
		var objDel = document.getElementById("delete1");
		if (objDel) {
			objDel.disabled=true;
			objDel.onclick=LinkDisable;
		}
	}


	if (ID =="") {
		var objDel = document.getElementById("delete1");
		if (objDel) {
			objDel.disabled=true;
			objDel.onclick=LinkDisable;
		}

		var objNewInv = document.getElementById("NewInvoice");
		if (objNewInv) {
			objNewInv.disabled=true;
			objNewInv.onclick=LinkDisable;
		}

		var objViewBill = document.getElementById("ViewBills");
		if (objViewBill) {
			objViewBill.disabled=true;
			objViewBill.onclick=LinkDisable;
		}
	}
}

function UpdateClickHandler(evt) {
	if (window.opener) {
		update1_click();
		window.close();
	}
}

function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if (el.disabled) {
		return false;
	}
	return true;
}

function CareProviderLookupSelect(str) {
	//alert(str);
	var arr=str.split("^");

	//var obj= document.getElementById("DEBDesc");
	//if (obj && arr[0]) obj.value=arr[0];

	obj = document.getElementById("DEBAddress");
	if (obj && arr[3]) obj.value=arr[3];

	obj = document.getElementById("DEBAddress2");
	if (obj && arr[3]) obj.value=arr[4];
		
	obj = document.getElementById("DEBCityDR");
	if (obj && arr[4]) obj.value=arr[5];

	obj = document.getElementById("DEBZipDR");
	if (obj && arr[5]) obj.value=arr[6];

	obj = document.getElementById("DEBPhone");
	if (obj && arr[6]) obj.value=arr[7];

	obj = document.getElementById("DEBPhoneExt");
	if (obj && arr[7]) obj.value=arr[8];

	obj = document.getElementById("DEBEmail");
	if (obj && arr[8]) obj.value=arr[9];

	obj = document.getElementById("DEBFax");
	if (obj && arr[9]) obj.value=arr[10];

}

function SuburbLookupSelect(str) {
	//zipcode^suburb^state^address^region
	//alert(str);
	var lu = str.split("^");
	var obj=document.getElementById("DEBZipDR")
	if (obj) obj.value = lu[0];
 	var obj1=document.getElementById("DEBCityDR")
	if (obj1) obj1.value = lu[1];
}

function AltSuburbLookupSelect(str) {
	//zipcode^suburb^state^address^region
	//alert(str);
	var lu = str.split("^");
	var obj=document.getElementById("DEBAltZipDR")
	if (obj) obj.value = lu[0];
 	var obj1=document.getElementById("DEBAltCityDR")
	if (obj1) obj1.value = lu[1];
}

function ZipLookupSelect(str) {
	//zipcode^suburb^state^address
 	var lu = str.split("^");
	var obj1=document.getElementById("DEBZipDR")
	if (obj1) obj1.value = lu[0];
 	var obj=document.getElementById("DEBCityDR")
	if (obj) obj.value = lu[1];
}

function AltZipLookupSelect(str) {
	//zipcode^suburb^state^address
 	var lu = str.split("^");
	var obj1=document.getElementById("DEBAltZipDR")
	if (obj1) obj1.value = lu[0];
 	var obj=document.getElementById("DEBAltCityDR")
	if (obj) obj.value = lu[1];
}


document.body.onload=BodyLoadHandler;