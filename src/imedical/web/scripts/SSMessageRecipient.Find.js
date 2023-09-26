// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var OldCheckClick=""
var objFind=document.getElementById("find1")
var objShowReadCheck=document.getElementById("ShowReadCheck");
var objShowRead=document.getElementById("ShowRead");
var objDateFrom=document.getElementById("DateFrom");
var objDateTo=document.getElementById("DateTo");
var objUser=document.getElementById("User");
var objUserHidden=document.getElementById("UserHidden");

//alert("js loaded");

function bodyLoadHandler() {

	if (objFind) objFind.onclick=FindClickHandler
	if (tsc['find1']) websys_sckeys[tsc['find1']]=FindClickHandler;

	if (objShowReadCheck) {
		OldCheckClick=objShowReadCheck.onclick;
		objShowReadCheck.onclick=ShowReadCheckClickHandler;
		EnableDisable();
	}

}

function FindClickHandler() {

	if (!CheckDates("DateFrom","DateTo")) return false;
	if (!CheckDates("DateCreatedFrom","DateCreatedTo")) return false;

	// SA 23.5.03 - log 35941: "User" field may be defaulted and set read-only by site. Because standard MT functionlity 
	// ignores read-only fields, a new hidden field has been created to deal with this.
	if ((objUser)&&(objUserHidden)) {
		//alert("objUser.tagName="+objUser.tagName);
		if (objUser.tagName=="LABEL") objUserHidden.value=objUser.innerText;
	}

	if (objShowRead) {
		if ((objShowReadCheck)&&(objShowReadCheck.checked)) {
			objShowRead.value="true"
		} else {
			objShowRead.value="false"
		}
	}

	find1_click();
}

function ShowReadCheckClickHandler() {

	if (typeof OldCheckClick!="function") OldCheckClick=new Function(OldCheckClick); 
	//call the function i.e. the original handler
	if(OldCheckClick()==false) return false;

	EnableDisable();
	
}

function EnableDisable() {
	if (objShowReadCheck) {
		if (objShowReadCheck.checked) {
			if (objDateFrom) EnableField("DateFrom");
			if (objDateTo) EnableField("DateTo");
		} else { 
			if (objDateFrom) DisableField("DateFrom");
			if (objDateTo) DisableField("DateTo");	
		}
	}
}


function EnableField(fldName) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if (fld) {
		fld.disabled = false;
		fld.className = "";
		if (lbl) lbl = lbl.className = "";
	}
}

function DisableField(fldName) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if ((fld)&&(fld.tagName=="INPUT")) {
		fld.value = "";
		fld.disabled = true;
		fld.className = "disabledField";
		if (lbl) lbl = lbl.className = "";
	}
}

function CheckDates(FromObjName,ToObjName) {
	// SA: The cache function called will do all the date from/to validation
	// This function will just check that the mandatory fields have been filled.

	var objDateFrom=document.getElementById(FromObjName)
	var objDateTo=document.getElementById(ToObjName)

	if ((objDateFrom)&&(objDateFrom.value!="")&&(objDateTo)&&(objDateTo.value!="")) {
		var fromdt=SplitDateStr(objDateFrom.value)
		var todt=SplitDateStr(objDateTo.value)
		var dtto=new Date(todt["yr"], todt["mn"]-1, todt["dy"]);
		var dtfrom=new Date(fromdt["yr"], fromdt["mn"]-1, fromdt["dy"]);
		if (dtto< dtfrom) {
			alert(t['DATE_RANGE_INVALID']);
			objDateFrom.className='clsInvalid';
			websys_setfocus(FromObjName);
			return false;
		}
	}

	return true;
}

function SplitDateStr(strDate) {
 	var arrDateComponents = new Array(3);
 	var arrDate = strDate.split(dtseparator);
 	switch (dtformat) {
  	case "YMD":
   	arrDateComponents["yr"] = arrDate[0];
   	arrDateComponents["mn"] = arrDate[1];
   	arrDateComponents["dy"] = arrDate[2];
   	break;
  	case "MDY":
   	arrDateComponents["yr"] = arrDate[2];
   	arrDateComponents["mn"] = arrDate[0];
   	arrDateComponents["dy"] = arrDate[1];
   	break;
  	default:
   	arrDateComponents["yr"] = arrDate[2];
   	arrDateComponents["mn"] = arrDate[1];
   	arrDateComponents["dy"] = arrDate[0];
   	break;
 	}
 	return arrDateComponents;
}

document.body.onload=bodyLoadHandler;