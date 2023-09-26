// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function Init() {
	websys_firstfocus();

	var obj;

	obj=document.getElementById('HARDel');
	if (obj) obj.onclick=HARDeleteClickHandler;

	objHidden=document.getElementById('find1');
	if (objHidden) objHidden.onclick= FindClickHandler;
	if (tsc['find1']) websys_sckeys[tsc['find1']]=FindClickHandler;
	//alert("chris")
	//setConsultantFilter()
}

// limit of 16 parameters can be passed to find query.
// create hidden field "objFindParam" to pass 16 + parameters
// It passes two flags and the Medical Record Type
function FindClickHandler(e) {
	var Allocated=""
	var Valid=""
	var Proc=""
	var AllocatedDate=""
	var ManAlloc=""
	var ReAllocate=""
	var SerialNumber=""
	var IntendedManagement=""
	
	var objAllocated=document.getElementById("Allocated")
	var objValid=document.getElementById("Valid")
	var objProc=document.getElementById("Proc")
	var objAllocatedDate=document.getElementById("AllocatedDate")
	var objManAlloc=document.getElementById("ManAlloc")
	var objReAllocate=document.getElementById("ReAllocate")
	var objSerialNumber=document.getElementById("SerialNumber")
	var objIntendedManagement=document.getElementById("IntendedManagement")

	if (objAllocated) Allocated=objAllocated.value
	if (objValid) Valid=objValid.value
	if (objProc) Proc=objProc.value
	if (objAllocatedDate) AllocatedDate=objAllocatedDate.value
	if (objManAlloc) ManAlloc=objManAlloc.value
	if (objReAllocate) ReAllocate=objReAllocate.value
	if (objSerialNumber) SerialNumber=objSerialNumber.value
	if (objIntendedManagement) IntendedManagement=objIntendedManagement.value

	//NB: objFlag should always be there as it is a hidden field...
	var objFindParam=document.getElementById("HiddenFindParam")
	if (objFindParam) objFindParam.value=Allocated+"^"+Valid+"^"+Proc+"^"+AllocatedDate+"^"+ManAlloc+"^"+ReAllocate+"^"+SerialNumber+"^"+IntendedManagement;

	//alert(objFindParam.value)
	//return false
	return find1_click();
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

function UpdateHARs() {
	//alert("update");
	var arrItems = new Array();
	var lst = document.getElementById("HARList");
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			var temp=lst.options[j].value;
			//alert(temp);
			temp=temp.split(String.fromCharCode(2))
			arrItems[j] = temp[1]
		}
		var el = document.getElementById("HARString");
		if (el) el.value = arrItems.join("^");
	}
}

function HARDeleteClickHandler() {
	//Delete items from HARList listbox when a "Delete" button is clicked.
	var obj=document.getElementById("HARList")
	if (obj) {
		RemoveFromList(obj);
		UpdateHARs();
	}
	return false;
}

function RegTextBlurHandler(e) {
	var eSrc=websys_getSrcElement(e)
	if (eSrc && eSrc.value=="") {
		var obj=document.getElementById('HAR');
		if (obj) obj.value=""
	}

	var obj=document.getElementById("HAR")
	if (obj) obj.value="";

	UpdateHARs();
	var cjb = document.getElementById("HARList");
}

function HARLookupSelect(txt) {
	//Add an item to HARList when an item is selected from
	//the Lookup, then clears the Item text field.
	var adata=txt.split("^");
	//alert("adata 1="+adata);
	var obj=document.getElementById("HARList")
	//alert(obj)
	if (obj) {
		//Need to check if HAR already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == String.fromCharCode(2)+adata[1]) {
				alert("HAR has already been selected");
				var obj=document.getElementById("HAR")
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
			alert("HAR has already been selected");
				var obj=document.getElementById("HAR")
				if (obj) obj.value="";
				return;
			}
			//alert(obj.options[i].value+"****"+adata[1])
		}
	}
	AddItemToList(obj,adata[1],adata[0]);
	//alert(adata[1]+"   "+adata[0]);
	var obj=document.getElementById("HAR")
	if (obj) obj.value="";

	UpdateHARs();
	var cjb = document.getElementById("HARList");
	//alert(cjb.value)
	//alert("adata 2="+adata);
}


document.body.onload=Init;