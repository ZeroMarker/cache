// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
//var separatorDate="/";
//var formatDate="DMY";
var EXCESSIVEYEAR=1880;
var EXCESSIVEAGE=121;

// LOG 22866 BC: Allergies edit screen that is linked from PAPerson.Edit

if (document.getElementById("ALGEntered")) {document.getElementById("ALGEntered").tkItemPopulate=1;}


function Init() {
	//websys_firstfocus();
	var obj=document.getElementById('DeleteAllergy');
	if (obj) obj.onclick=AllergyDeleteClickHandler;	
	//var check = document.getElementById("ListBoxChanged");
	//check.value=0

}


function AddItemToList(list,code,desc) {
	//Add an item to a listbox
	code=String.fromCharCode(2)+code
	list.options[list.options.length] = new Option(desc,code);
}

function RemoveFromList(obj) {
	for (var i=(obj.length-1); i>=0; i--) {
		if (obj.options[i].selected)
			obj.options[i]=null;
	}
}

function DeleteClickHandler() {    
	//Delete items from EMCDesc listbox when a "Delete" button is clicked.
	var obj=document.getElementById("EMCDesc")
	if (obj) RemoveFromList(obj);
	return false;
}



//Alllergies

function UpdateAllergies() {
	//alert("update");
	var arrItems = new Array();
	var lst = document.getElementById("ALGEntered");
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			arrItems[j] = lst.options[j].value;
		}
		var el = document.getElementById("ALGDescString");
		if (el) el.value = arrItems.join(String.fromCharCode(1));
		//var check = document.getElementById("ListBoxChanged");
		//check.value=1
		
	}
}


function AllergyDeleteClickHandler() {    
	//Delete items from ALGEntered listbox when a "Delete" button is clicked.
	var obj=document.getElementById("ALGEntered")
	if (obj) {
		RemoveFromList(obj);
		UpdateAllergies();
	}
	return false;
}

function AllergyLookupSelect(txt) {
	//Add an item to ALGEnetered when an item is selected from
	//the Lookup, then clears the Item text field.	
	var adata=txt.split("^");
	//alert("adata 1="+adata);
	var obj=document.getElementById("ALGEntered")

	if (obj) {
		//Need to check if Allergy already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == String.fromCharCode(2)+adata[1]) {
				alert("Allergy has already been selected");
				var obj=document.getElementById("ALGDesc")
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
			alert("Allergy has already been selected");
				var obj=document.getElementById("ALGDesc")
				if (obj) obj.value="";
				return;
			}
			//alert(obj.options[i].value+"****"+adata[1])
		}
	}
	AddItemToList(obj,adata[1],adata[0]);

	var obj=document.getElementById("ALGDesc")
	if (obj) obj.value="";
	UpdateAllergies();
	//alert("adata 2="+adata);
}


document.body.onload=Init