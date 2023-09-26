// Copyright (c) 2003 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

//function BodyUnloadHandler(e) {
//	if (self == top) {
//		var win=window.opener;
//		if (win) {
//            websys_onunload();
//			win.treload('websys.reload.csp');
//		}
//	}
//}
//
//document.body.onunload=BodyUnloadHandler;
function Init() {
	var obj;
	
	obj=document.getElementById('DELTotalDurationPrev');
	if (obj){
		obj.onblur=CheckLabourDuration;
	}
	//obj=document.getElementById('Delete');
	//if (obj) obj.onclick=DeleteClickHandler;
	obj=document.getElementById('DeletePreCompl');
	if (obj) obj.onclick=PreComplDeleteClickHandler;
	obj=document.getElementById('DeleteArt');
	if (obj) obj.onclick=ArtDeleteClickHandler;
	obj=document.getElementById('deleteMenstr');
	if (obj) obj.onclick=MenstrDeleteClickHandler;
	obj=document.getElementById('deleteContrMthds');
	if (obj) obj.onclick=ContrMDeleteClickHandler;

	obj=document.getElementById('update1');
	if (obj) obj.onclick=UpdateAll;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateAll;
}

//validate that Labour duration should be in the HH:MM format
function CheckLabourDuration(){
	var obj=document.getElementById('DELTotalDurationPrev');
	if (obj && obj.value != ""){
		var val = obj.value;
		var ind = val.indexOf(":");
		var valid = true;
		if(ind == -1 || ind == 0){
			valid = false;
		}
		else {
			var arr = val.split(":");
			var hrs = arr[0];
			var mins = arr[1];
			if (hrs == "" || mins == "")
				valid = false;
			if (valid){
				if (CheckPositiveInteger(hrs) && CheckPositiveInteger(mins)){
					if(mins < 0 || mins > 59)
						valid = false;
				}
				else{
					valid = false;
				}
			}
		}
		if (!valid){
			alert(t['DELTotalDurationPrev'] + " " + t["Invalid_Msg"]);
	    		obj.value = "";
    			websys_setfocus("DELTotalDurationPrev");
			obj.className='clsInvalid'			
			return false;
		
		}
	}
	obj.className=''
	return true;
}

//Function to check if the passed value is a positive integer.  If not give error message and clear field.
function CheckPositiveInteger(val){
	if (!(IsValidIntegerVal(val) && IsPositiveNumberVal(val))){
		return false;
	}
	return true;
}

function IsValidIntegerVal(theNumber)  {
 if (theNumber.charAt(0)=='+') theNumber=theNumber.slice(1);
 var re=/\D/g;
 if ((theNumber.charAt(0)=='+')||(theNumber.charAt(0)=='-')) theNumber=theNumber.slice(1);
 if ((theNumber!='')&&(re.test(theNumber))) return false;
 return true;
}

function IsPositiveNumberVal(theNumber)  {
 if ((theNumber!='')&&(theNumber<0)) return false;
 return true;
}
//
function ReloadListBoxes() {
	//PreComplReload();
	//ArtReload();
	ListboxReload("PRECOMPLDescString","PRECOMPLEntered");
	ListboxReload("ARTDescString","ARTEntered");
	ListboxReload("MenstrHstrStr","MenstrHstrEntrd");
	ListboxReload("ContraMthdsStr","ContraMthdsEntrd");
	
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
function PreComplLookupSelect(txt) {
	//Add an item to PAPregAntenatalCompl when an item is selected from
	//the Lookup, then clears the Item text field.
	var adata=txt.split("^");
	var obj=document.getElementById("PRECOMPLEntered")

	if (obj) {
		//Need to check if Condition already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == String.fromCharCode(2)+adata[1]) {
				alert("Antenatal Complication has already been selected");
				var obj=document.getElementById("PRECOMPLDesc")
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
				alert("Antenatal Complication has already been selected");
				var obj=document.getElementById("PRECOMPLDesc")
				if (obj) obj.value="";
				return;
			}
		}
	}
	AddItemToList(obj,adata[1],adata[0]);

	var obj=document.getElementById("PRECOMPLDesc")
	if (obj) obj.value="";
}
function ArtLookupSelect(txt) {
	//Add an item to PAPregAntenatalCompl when an item is selected from
	//the Lookup, then clears the Item text field.
	var adata=txt.split("^");
	var obj=document.getElementById("ARTEntered")

	if (obj) {
		//Need to check if Condition already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == String.fromCharCode(2)+adata[1]) {
				alert("Artificial Reproductive Method has already been selected");
				var obj=document.getElementById("ARTDesc")
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
				alert("Artificial Reproductive Method has already been selected");
				var obj=document.getElementById("ARTDesc")
				if (obj) obj.value="";
				return;
			}
		}
	}
	AddItemToList(obj,adata[1],adata[0]);

	var obj=document.getElementById("ARTDesc")
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
function PreComplDeleteClickHandler() {
	//Delete items from PRECOMPLEntered listbox when a "Delete" button is clicked.

	var obj=document.getElementById("PRECOMPLEntered")
	if (obj)
		RemoveFromList(obj);
	return false;
}
function ArtDeleteClickHandler() {
	//Delete items from ARTEntered listbox when a "Delete" button is clicked.

	var obj=document.getElementById("ARTEntered")
	if (obj)
		RemoveFromList(obj);
	return false;
}
function UpdateAll() {
	UpdatePreCompl();
	UpdateArt();
	UpdateMenstr();
	UpdateContrM();

	//set Updated flag to true b/c attempting to update once now
	var obj=document.getElementById('Updated');
	if (obj){
		if(obj.value == "0") obj.value = "1";
	}

	return update1_click()
}
//PAPregAntenatalCompl List
function UpdatePreCompl() {
	var arrItems = new Array();
	var lst = document.getElementById("PRECOMPLEntered");
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			//TN:need to pass description for reloading when update error occurs
			arrItems[j] = lst.options[j].value + String.fromCharCode(2) + lst.options[j].text;
		}
		var el = document.getElementById("PRECOMPLDescString");
		if (el) el.value = arrItems.join(String.fromCharCode(1));
	}
}
//PAPregArt List
function UpdateArt() {
	var arrItems = new Array();
	var lst = document.getElementById("ARTEntered");
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			//TN:need to pass description for reloading when update error occurs
			arrItems[j] = lst.options[j].value + String.fromCharCode(2) + lst.options[j].text;
		}
		var el = document.getElementById("ARTDescString");
		if (el) el.value = arrItems.join(String.fromCharCode(1));
	}
}
function DeleteClickHandler() {
	//Delete items from listboxes when a "Delete" button is clicked.
	PreComplDeleteClickHandler();
	ArtDeleteClickHandler();
	//var obj=document.getElementById("PRECOMPLEntered")
	//if (obj) RemoveFromList(obj);
	//var obj=document.getElementById("ARTEntered")
	//if (obj) RemoveFromList(obj);
	return false;
}


function MenstLookupSelect(txt) {
	//Add an item to PAPregAntenatalCompl when an item is selected from
	//the Lookup, then clears the Item text field.
	var adata=txt.split("^");
	var obj=document.getElementById("MenstrHstrEntrd")

	if (obj) {
		//Need to check if Condition already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == String.fromCharCode(2)+adata[1]) {
				alert("Menstr Problem Method has already been selected");
				var obj=document.getElementById("MenstrHstr")
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
				alert("Menstr Problem Method has already been selected");
				var obj=document.getElementById("MenstrHstr")
				if (obj) obj.value="";
				return;
			}
		}
	}
	AddItemToList(obj,adata[1],adata[0]);

	var obj=document.getElementById("MenstrHstr")
	if (obj) obj.value="";
}

function ContrMLookupSelect(txt) {
	var adata=txt.split("^");
	var obj=document.getElementById("ContraMthdsEntrd")

	if (obj) {
		//Need to check if Condition already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == String.fromCharCode(2)+adata[1]) {
				alert("Contrc Method has already been selected");
				var obj=document.getElementById("ContraMthds")
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
				alert("Contrc Method has already been selected");
				var obj=document.getElementById("ContraMthds")
				if (obj) obj.value="";
				return;
			}
		}
	}
	AddItemToList(obj,adata[1],adata[0]);

	var obj=document.getElementById("ContraMthds")
	if (obj) obj.value="";
}
function UpdateMenstr() {
	var arrItems = new Array();
	var lst = document.getElementById("MenstrHstrEntrd");
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			//TN:need to pass description for reloading when update error occurs
			arrItems[j] = lst.options[j].value + String.fromCharCode(2) + lst.options[j].text;
		}
		var el = document.getElementById("MenstrHstrStr");
		if (el) el.value = arrItems.join(String.fromCharCode(1));
	}
}
function MenstrDeleteClickHandler() {
	

	var obj=document.getElementById("MenstrHstrEntrd")
	if (obj)
		RemoveFromList(obj);
	return false;
}

function UpdateContrM() {
	var arrItems = new Array();
	var lst = document.getElementById("ContraMthdsEntrd");
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			//TN:need to pass description for reloading when update error occurs
			arrItems[j] = lst.options[j].value + String.fromCharCode(2) + lst.options[j].text;
		}
		var el = document.getElementById("ContraMthdsStr");
		if (el) el.value = arrItems.join(String.fromCharCode(1));
	}
}

function ContrMDeleteClickHandler() {

	var obj=document.getElementById("ContraMthdsEntrd")
	if (obj)
		RemoveFromList(obj);
	return false;

}


ReloadListBoxes();

document.body.onload=Init;
