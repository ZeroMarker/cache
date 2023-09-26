// Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var frm = document.forms["fPAPregDelBaby_EditOther"];

// Log 58088 - GC - 04-05-2006 : Alows mandatory list to be saved even if a value is not selected
if (document.getElementById('DELMTHEntered')) document.getElementById('DELMTHEntered').tkItemPopulate=1;

function Init() {
	var obj;

	obj=document.getElementById('Delete');
	if (obj) obj.onclick=DeleteClickHandler;

	obj=document.getElementById('DeleteDelMth');
	if (obj) obj.onclick=DelMthDeleteClickHandler;

	obj=document.getElementById('BABYAlive');
	if (obj) obj.onclick=BabyAliveHandler;

	obj=document.getElementById('BABYBirthDate');
	if (obj) obj.onchange=DOBChangeHandler;

	obj=document.getElementById('update1');
	if (obj) obj.onclick=UpdateAll;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateAll;
	
	BabyAliveHandler();
}

function BabyAliveHandler(){
	var obj=document.getElementById('BABYAlive');
	var rsnObj = document.getElementById('BABYReasonDeath');
	if(obj==null || rsnObj==null)
		return;
	if(obj.checked){
		rsnObj.value=""
		DisableGreyFldObj(rsnObj);

	}
	else{
		EnableFldObj(rsnObj);
	}	
}

function DisableGreyFldObj(fld) {
	if (fld) {
		fld.disabled = true;
		fld.className = "disabledField";
	}
}

function EnableFldObj(fld) {
	if (fld) {
		fld.disabled = false;
		fld.className = "";
	}
}

function DOBChangeHandler(){
	var dob = document.getElementById("BABYBirthDate");
	BABYBirthDate_changehandler(e)
	if(dob && DateStringCompareToday(dob.value) == 1){
		alert(t['BABYBirthDate'] + " " + t["FutureDate"]);
    		dob.value = "";
    		websys_setfocus("BABYBirthDate");
		return false;
	}
	return true;
}

function UpdateAll() {
	if(checkMandatoryFields()) {
		UpdateDelMth();

		//set Updated flag to true b/c attempting to update once now
		var obj=document.getElementById('Updated');
		if (obj){
			if(obj.value == "0") obj.value = "1";
		}

		return update1_click();
	}
}

//checks that mandatory fields are filled in
function checkMandatoryFields(){
	var valid = checkMandatoryListBoxes();
		
	return valid;
}

//checks that the mandatory listboxes are filled in
function checkMandatoryListBoxes(){
	//check delivery methods
	var obj = document.getElementById('DELMTHEntered');
	var lbl = document.getElementById("cDELMTHEntered");
	if ((obj)&&(lbl)&&(obj.options.length==0)) {		
		alert(t['DELMTHEntered'] + " " + t['XMISSING']);
		return false;
	}
	return true;
}

//PAPrDelBabyDelMthd List
function UpdateDelMth() {
	var arrItems = new Array();
	var lst = document.getElementById("DELMTHEntered");
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			//TN:need to pass description for reloading when update error occurs
			arrItems[j] = lst.options[j].value + String.fromCharCode(2) + lst.options[j].text;
		}
		var el = document.getElementById("DELMTHDescString");
		if (el) el.value = arrItems.join(String.fromCharCode(1));
	}
}

function DeleteClickHandler() {
	//Delete items from PAPrDelBabyResusMthd listbox when a "Delete" button is clicked.
	var obj=document.getElementById("DELMTHEntered")
	if (obj) RemoveFromList(obj);
	return false;
}


function DelMthDeleteClickHandler() {
	//Delete items from DelMthBEntered listbox when a "Delete" button is clicked.

	var obj=document.getElementById("DELMTHEntered")
	if (obj)
		RemoveFromList(obj);
	return false;
}


function DelMthLookupSelect(txt) {
	//Add an item to PAPrDelBabyDelMthd list when an item is selected from
	//the Lookup, then clears the Item text field.
	var adata=txt.split("^");
	var obj=document.getElementById("DELMTHEntered")

	if (obj) {
		//Need to check if Condition already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == String.fromCharCode(2)+adata[1]) {
				alert("Delivery Method has already been selected");
				var obj=document.getElementById("DELMTHDesc")
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
				alert("Delivery Method has already been selected");
				var obj=document.getElementById("DELMTHDesc")
				if (obj) obj.value="";
				return;
			}
		}
	}
	AddItemToList(obj,adata[1],adata[0]);

	var obj=document.getElementById("DELMTHDesc")
	if (obj) obj.value="";
}

function AddItemToList(list,code,desc) {
	//Add an item to a listbox
	code=String.fromCharCode(2)+code
	list.options[list.options.length] = new Option(desc,code);
}

function AddItemToList_Reload(list,code,desc) {
	//Add an item to a listbox
	list.options[list.options.length] = new Option(desc,code);
}

function RemoveFromList(obj) {
	for (var i=(obj.length-1); i>=0; i--) {
		if (obj.options[i].selected)
		obj.options[i]=null;
	}

}

function RemoveAllFromList(obj){
	for (var i=(obj.length-1); i>=0; i--) {
		obj.options[i]=null;
	}

}

//TN: reload listboxes with values in hidded fields.
//this is due to page being refreshed upon error message (such as invalid pin)
function ReloadListBoxes() {
	ListboxReload("DELMTHDescString","DELMTHEntered");
}

function ListboxReload(strName, lstName) {
	var el = document.getElementById(strName);
	var lst = document.getElementById(lstName);
	var updated = document.getElementById("Updated");
	//don't execute this when page loads for the first time b/c first time values come from db, 
	//execute for subsequent reloads (such as on error condition).
	if ((lst) && (el) && (updated.value == "1")) {
		RemoveAllFromList(lst);
		if(el.value != ""){
			var arrITEM=el.value.split(String.fromCharCode(1));
			for (var i=0; i<arrITEM.length; i++) {
				var arrITEMVAL=arrITEM[i].split(String.fromCharCode(2));
				AddItemToList_Reload(lst,arrITEMVAL[0]+String.fromCharCode(2)+arrITEMVAL[1],arrITEMVAL[2]);
			}
		}
	}
}



//TN: call this outside onload call so it can be called straight away, and not wait till everything has loaded.
ReloadListBoxes();

document.body.onload=Init;
