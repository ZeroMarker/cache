// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function Init() {
	websys_firstfocus();

	var obj;

	obj=document.getElementById('SpecialtyDel');
	if (obj) obj.onclick=SpecialtyDeleteClickHandler;
	
	//var objlist=document.getElementById("SpecialtyList");
	//alert(objlist.value);

	//lert("chris")
	//setConsultantFilter()
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
	if (obj)
		RemoveFromList(obj);
	return false;
}

function UpdateSpecialty() {
	//alert("update");
	var arrItems = new Array();
	var lst = document.getElementById("SpecialtyList");
	//alert("lst="+lst);
	if (lst) {
		//alert("lst.options.length="+lst.options.length);
		for (var j=0; j<lst.options.length; j++) {
			var temp=lst.options[j].value;
			//alert("temp="+temp);
			temp=temp.split(String.fromCharCode(2))
			//alert("temp[1]="+temp[1]);
			if ((temp[1]!="")&&(temp[1])) {
				arrItems[j] = temp[1]
				//alert("NOT null arrItems[j]="+arrItems[j]);
			} else {
				arrItems[j] = temp
				//alert("null arrItems[j]="+arrItems[j]);
			}
		}
		var el = document.getElementById("SpecialtyString");
		//alert(el.value);
		if (el) el.value = arrItems.join(",");
	}
}

function SpecialtyDeleteClickHandler() {
	//Delete items from SpecialtyList listbox when a "Delete" button is clicked.
	var obj=document.getElementById("SpecialtyList")
	if (obj) {
		RemoveFromList(obj);
		UpdateSpecialty();
	}
	return false;
}

function RegTextBlurHandler(e) {
	var eSrc=websys_getSrcElement(e)
	if (eSrc && eSrc.value=="") {
		var obj=document.getElementById('Specialty');
		if (obj) obj.value=""
	}

	var obj=document.getElementById("Specialty")
	if (obj) obj.value="";

	UpdateSpecialty();
	var cjb = document.getElementById("SpecialtyList");
}

function SpecialtyLookupSelect(txt) {
	//Add an item to SpecialtyList when an item is selected from
	//the Lookup, then clears the Item text field.
	var adata=txt.split("^");
	//alert("adata 1="+adata);
	var obj=document.getElementById("SpecialtyList")
	//alert(obj)
	if (obj) {
		//Need to check if Specialty already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == String.fromCharCode(2)+adata[1]) {
				alert("Specialty has already been selected");
				var obj=document.getElementById("Specialty")
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
			alert("Specialty has already been selected");
				var obj=document.getElementById("Specialty")
				if (obj) obj.value="";
				return;
			}
			//alert(obj.options[i].value+"****"+adata[1])
		}
	}
	AddItemToList(obj,adata[1],adata[0]);
	//alert(adata[1]+"   "+adata[0]);
	var obj=document.getElementById("Specialty")
	if (obj) obj.value="";

	UpdateSpecialty();
	var cjb = document.getElementById("SpecialtyList");
	//alert(cjb.value)
	//alert("adata 2="+adata);
}


document.body.onload=Init;