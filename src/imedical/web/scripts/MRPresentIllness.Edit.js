// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
// pcollins - Added code to update fields if lookup values change
function BodyPartSymSubsLookUpSelect(str) {
	var lu = str.split("^");
	var el = document.getElementById("PRESIBodyPartSymSubsDR");
	if (el) el.value = lu[0];
	var el = document.getElementById("PRESIBodyPartsSympDR");
	if (el) el.value = lu[1];
	var el = document.getElementById("PRESIBodyPartsDR");
	if (el) el.value = lu[2];
}
function BodyPartSympLookUpSelect(str) {
	BodyPartSympChangeHandler()
	var lu = str.split("^");
	var el = document.getElementById("PRESIBodyPartsDR");
	if (el) el.value = lu[2];
}
function BodyPartLookUpSelect(str) {
	BodyPartChangeHandler()
}
function BodyPartSympChangeHandler() {
	var el = document.getElementById("PRESIBodyPartSymSubsDR");
	if (el) el.value = "";
}
function BodyPartChangeHandler() {
	var el = document.getElementById("PRESIBodyPartsSympDR");
	if (el) el.value = "";
	var el = document.getElementById("PRESIBodyPartSymSubsDR");
	if (el) el.value = "";
}

function BodyLoadHandler() {
	var obj=document.getElementById('Update');
	if (obj) obj.onclick = UpdateClickHandler;
	if (tsc['Update']) websys_sckeys[tsc['Update']]=UpdateClickHandler;
	// 03-07-2002 Log 25878 AI : handle when user clicks on Delete Keyword
	obj=document.getElementById('DeletePRESIK');
	if (obj) obj.onclick=PRESIKDeleteClickHandler;
	// Log 32090 - AI - 16-04-2003 : disable the Repeat button if Editing a specific row from the List. (see Log 27280)
	var objID = document.getElementById('ID');
	if ((objID)&&(objID.value!="")) {
		DisableFields();
	}
	else {
		EnableFields();
	}
}

function DisableFields() {
	var objRepeat = document.getElementById('Repeat');
	if (objRepeat) {
		objRepeat.disabled=true;
		objRepeat.onclick=LinkDisable;
	}
}

function EnableFields()	{
	var objRepeat = document.getElementById('Repeat');
	if (objRepeat) {
		objRepeat.disabled=false;
		objRepeat.onclick=RepeatClickHandler;
	}
}

function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if (el.disabled==true) {
		return false;
	}
	return true;
}
// end Log 32090

function PRESIDesc_keydownhandler(encmeth) {
	var obj=document.getElementById("PRESIDesc");
	//lookupqryNURN,jsfuncNURN defined in epr.js
	LocateCode(obj,encmeth,0,lookupqryNURN,jsfuncNURN);
}
function PRESIDesc_lookupsel(value) {
}

function LocationTextChangeHandler() {
}

// 03-07-2002 Log 25878 AI : function modified to store the Present Illness Keywords
function ValidateUpdate() {
	//Insert code that gets the list box contents and changes it to string delimited by "String.fromCharCode(1)"
	var arrItems = new Array();
	var lst = document.getElementById("PRESIKEntered");
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			//need to pass description for reloading when update error occurs
			arrItems[j] = lst.options[j].text;
		}
		var el = document.getElementById("PRESIKDescString");
		if (el) el.value = String.fromCharCode(1)+arrItems.join(String.fromCharCode(1))+String.fromCharCode(1);
	}
	return true;
}
function UpdateClickHandler() {
	if (ValidateUpdate()) {
		// Log 43616 - AI - 23-04-2004 : Instead of simply quitting, display a message and then quit.
		var objPRESIDesc=document.getElementById("PRESIDesc");
		if ((objPRESIDesc)&&(objPRESIDesc.value=="")) {
			alert(t["DESCRIPTION_BLANK"]);
			objPRESIDesc.focus();
			return false;
		}
		// end Log 43616
		return Update_click();
	}
	return false;
}
function RepeatClickHandler(evt) {
	var el1=document.getElementById('TWKFLI');
	if ((el1)&&(el1.value!="")) {
		el1.value = el1.defaultValue - 1;
	}
	ValidateUpdate();
	return Repeat_click();
}
// 03-07-2002 Log 25878 AI : function to lookup Present Illness Keyword
function PRESIKLookupSelect(txt) {
	//Add an item to PRESIKDesc when an item is selected from the Lookup, then clears the Item text field.
	var adata=txt.split("^");
	//alert("adata="+adata);
	var obj=document.getElementById("PRESIKEntered")

	if (obj) {
		//Need to check if Condition already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if  ((adata[0] != "") && (obj.options[i].text == adata[0])) {
				alert(t['PIK_ALREADY_SELECTED']);
				var obj=document.getElementById("PRESIKDesc")
				if (obj) obj.value="";
				return;
			}
			//alert(obj.options[i].value+"****"+adata[1])
		}
	}
	AddItemToList(obj,adata[0],adata[0]);

	var obj=document.getElementById("PRESIKDesc")
	if (obj) obj.value="";
	//alert("adata="+adata);
}
// 03-07-2002 Log 25878 AI : function to delete the selected Present Illness Keyword
function PRESIKDeleteClickHandler() {
	//Delete items from PRESIKEntered listbox when the "Delete" button is clicked.
	var obj=document.getElementById("PRESIKEntered")
	if (obj)
		RemoveFromList(obj);
	return false;
}
// 03-07-2002 Log 25878 AI : function to add an item to a listbox
function AddItemToList(list,code,desc) {
	//Add an item to a listbox
	var frm=document.fMRPresentIllness_Edit;
	//TDIRTY=document.getElementById("TDIRTY")
	//frm.TDIRTY.value=2
	//alert("and now..."+frm.TDIRTY.value);
	code=String.fromCharCode(2)+code
	list.options[list.options.length] = new Option(desc,code);
}
// 03-07-2002 Log 25878 AI : function to remove an item from a listbox
function RemoveFromList(obj) {
	var frm=document.fMRPresentIllness_Edit;
	//TDIRTY=document.getElementById("TDIRTY")
	frm.TDIRTY.value=2
	for (var i=(obj.length-1); i>=0; i--) {
		if (obj.options[i].selected)
			obj.options[i]=null;
	}
}

function KeywordLoad() {
	var el = document.getElementById("PRESIKDescString");
	var lst = document.getElementById("PRESIKEntered");
	if ((lst)&&(el.value!="")) {
		var arrITEM=el.value.split(String.fromCharCode(1));
		//alert(el.value);
		for (var i=0; i<arrITEM.length; i++) {
			//var arrITEMVAL=arrITEM[i].split(String.fromCharCode(2));
			//don't add ones that have a child rowid as they would already be populated
			//alert(arrITEM[i]);
			if (arrITEM[i]!="") AddItemToList(lst,arrITEM[i],arrITEM[i]);
		}
	}
}

KeywordLoad();
document.body.onload = BodyLoadHandler;
