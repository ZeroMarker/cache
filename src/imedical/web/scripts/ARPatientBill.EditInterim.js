// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var objDateFrom=document.getElementById("DateFrom")
var objDateTo=document.getElementById("DateTo")
var objUpdate=document.getElementById("update1")

function BodyLoadHandler() {

	if (objUpdate) objUpdate.onclick=UpdateClickHandler;
}

function UpdateClickHandler() {

	if (!CheckDates()) return false;

	update1_click();
}

function CheckDates() {
	// SA: The cache function called will do all the date from/to validation
	// This function will just check that the mandatory fields have been filled.

	if (objDateFrom.value=="") return true;
	if (objDateTo.value=="") return true;

	var fromdt=SplitDateStr(objDateFrom.value)
	var todt=SplitDateStr(objDateTo.value)

	var dtfrom=new Date(fromdt["yr"], fromdt["mn"]-1, fromdt["dy"]);
	var dtto=new Date(todt["yr"], todt["mn"]-1, todt["dy"]);
	

	if (dtto < dtfrom) {
		alert(t['DATE_RANGE_ERROR']);
		if (objDateFrom) objDateFrom.className='clsInvalid';
		websys_setfocus("DateFrom");
		return false;
	}
	var today = new Date();
	if ((dtto > today)||(dtfrom > today)) {  //48592: advanced billing
		return confirm(t['ADVANCED_BILL']);
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

document.body.onload=BodyLoadHandler;
