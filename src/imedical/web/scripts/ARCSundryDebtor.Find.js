// Copyright (c) 2004 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function BodyLoadHandler() {

	var objDelHosp = document.getElementById('DeleteHospital');
	if (objDelHosp) objDelHosp.onclick = DeleteHospitalClickHandler;	
}

function LookupCareProv_Select(str) {
		
	var arr = str.split("^");
	//alert(arr[1]);

	var objCareProv = document.getElementById("CareProvID");
	if (objCareProv && arr[1]) objCareProv.value=arr[1];
}

/**
 * from Lookup List, specified in LookupJSFunction
 */
function HospitalLookUpSelect(str,needalert) {
	//alert(str);  hospdesc^hospid^ ...

	if (needalert==null) needalert=true;
	var lu = str.split("^");
	var obj=document.getElementById('Hospital');
	if (obj) obj.value=lu[1];
	var objList=document.getElementById('HospitalList');
	if (objList) {
		var tfield='Hospital';
		var lfield='HospitalList';
		LookupSelectforList(tfield,lfield,str,needalert);
	}
	SetSelectedHospital();
}

function LookupSelectforList(tfield,lfield,txt,needalert) {
	//Add an item to List when an item is selected from
	//the Lookup, then clears the text field.
	var adata = txt.split("^");
	var obj = document.getElementById(lfield);  //Listbox
	if (obj) {
		//Need to check if text already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == String.fromCharCode(2) + adata[0]) {
				if (needalert) alert( adata[0] + " has already been selected");
				var obj=document.getElementById(tfield);  //Textbox with lookup 
				if (obj) obj.value="";
				return;
			}
			if  ((adata[0] != "") && (obj.options[i].text == adata[0])) {
				if (needalert) alert( adata[0] + " has already been selected");
				var obj=document.getElementById(tfield);
				if (obj) obj.value="";
				return;
			}
		}
	}
	AddItemToList(obj,adata[1],adata[0]);

	var obj=document.getElementById(tfield);
	if (obj) obj.value="";
}

/**
 * Add an item to a listbox
 */
function AddItemToList(list,rowid,desc) {

	list.options[list.options.length] = new Option(desc,rowid);
}

/**
 * Delete items from Entered listbox when "Delete" button is clicked.
 */
function DeleteHospitalClickHandler() {

	var obj=document.getElementById("HospitalList");
	if (obj) RemoveFromList(obj);
	SetSelectedHospital();

	return false;
}

function RemoveFromList(obj) {

	for (var i=(obj.length-1); i>=0; i--) {
		if (obj.options[i].selected)
			obj.options[i]=null;
	}
}

/**
 * Get all items from HospitalList and construct a series of hospID delimited by a pipe
 * SelHosp is always sent in the format hospid^hospid2
 */
function SetSelectedHospital() {
	
	var hospitals="";
	var lstHosp = document.getElementById("HospitalList");
	var numberchosen=0
	if (lstHosp) {
		var j=0;
		for (var j=0; j<lstHosp.options.length; j++) {
			if (j > 0)
				hospitals = hospitals + "^" + lstHosp.options[j].value;
			else
				hospitals = lstHosp.options[j].value;
		}

		var objSelHosp = document.getElementById("SelHospital");
		if (objSelHosp) objSelHosp.value = hospitals;

		//alert(" SetSelectedHospital " + objSelHosp.value);
	}
}



document.body.onload=BodyLoadHandler;
