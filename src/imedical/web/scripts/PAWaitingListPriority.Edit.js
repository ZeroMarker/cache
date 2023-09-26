// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var objEffectiveDate=document.getElementById('EffectiveDate');
//var objNextReassignDate=document.getElementById('NextReassignDate');
//var objLastReassignDate=document.getElementById('LastReassignDate');
var objDateToday=document.getElementById('DateToday');
var objVisStat=document.getElementById("disableform");
var objWLStat=document.getElementById("WLSCode");
objPriority=document.getElementById("WLPDesc");
objTRANSRowId=document.getElementById("TRANSRowId");

function DocumentLoadHandler() {
	if (objVisStat) {
		if ((objVisStat.value=="A")||(objVisStat.value=="D")||(objVisStat.value=="P")){
			disableform()
		}
	}
	if (objWLStat) {
		if ((objWLStat.value=="R")||(objWLStat.value=="PRE")) disableform()
	}
	//alert ("DocumentLoadHandler called");
	//alert ("objDateToday.value= "+objDateToday.value);	

	// SA 31.1.03 - log 32473
	DisablePriority();

	obj = document.getElementById("update1");
	obj.onclick = UpdateClickHandler;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateClickHandler;

}

/***  RQG 20.08.03 L37821: Code below were moved to Austin custom js as QH dont want any warning messages when
	changing priority.

function WarnUser() {

	var EffectiveDate="";
	var EffectiveMonth="";
	var DateToday="";
	var MonthToday="";
	var msg="";

	if (objEffectiveDate) { 
		if (objEffectiveDate.value=="") {
			// Effective Date is mandatory on this form, update1_click should
			// trap this and return the appropriate error message.
			return true;
		} else {
			EffectiveDate=SplitDateStr(objEffectiveDate.value); 
			//subtract 1 to ignore leading zero (eg. "05" and "5" will both equal "4")
			EffectiveMonth=EffectiveDate["mn"]-1;
			//alert ("EffectiveMonth= "+EffectiveMonth);	
		}
	}
	
	if (objDateToday) { 
		if (objDateToday.value=="") {
			DtToday="";
		} else {
			DateToday=SplitDateStr(objDateToday.value); 
			//subtract 1 to ignore leading zero (eg. "05" and "5" will both equal "4")
			MonthToday=DateToday["mn"]-1;
			//alert ("MonthToday= "+MonthToday);	
		}
	}

	if ((EffectiveMonth!="")&&(MonthToday!="")) {
		if (EffectiveMonth!=MonthToday) {
			msg += t['NOT_CURR_MONTH'] + "\n";
		}
	}

	msg += t['ESIS_WARNING'] + t['CONTINUE'] + "\n";
	
	var bOK="";
	bOK=confirm(msg);
	if (bOK) {
		return true;
	} else {
		return false;	
	}

}
***/

function WarnUser() {
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

function DisablePriority() {

	// SA 31.1.03 - log 32473: Priority field and PIN had previously been used to disable 
	// the priority field (see commented code below which was moved into this function). 
	// The field should only be disabled for an existing record (ie. when "TRANSRowId" is not blank). 

	if ((objPriority)&&(objTRANSRowId)) {
		if (objTRANSRowId.value!="") {
			objPriority.disabled=true;
			objPriority.className = "disabledField";
			var lookupobj=document.getElementById('ld1351iWLPDesc');
			if (lookupobj) lookupobj.style.visibility="hidden";
		}
	}

	//if (objPriority) {
	//	PINobj=document.getElementById("PIN");
	//	if (PINobj) {
	//		if ((objPriority.value!="")&&(PINobj.className!="clsInvalid")) {
	//			objPriority.disabled=true
	//			objPriority.className = "disabledField";
	//			var lookupobj=document.getElementById('ld1351iWLPDesc');
	//			if (lookupobj) lookupobj.style.visibility="hidden";
	//		}
	//	}
	//}

}

function UpdateClickHandler() {

	//alert ("UpdateClickHandler called");
	
	if (!(WarnUser())) { 
		return false; 
	}

	// SA 31.1.03 - log 32473: Priority is a disabled field when editing existing records.
	// Disabled fields are not repopulated upon refresh caused by incorrect PIN or other error.
	// Will enable this field at this point for now (until disabled fields are refreshed), 
	// to ensure it is populated on reload.
	if (objPriority) {
		objPriority.className = "";
		objPriority.disabled=false;
	}

	if (!update1_click()) {
		// SA 31.1.03 - log 32473: Need to re-disable field, which is enabled just above,
		// if a js error message is returned (eg. Password mandatory but blank)
		DisablePriority();
		return false
	} else {
		return true;
	} 

	//return update1_click()

}

function disableform() {
	var frm = document.forms['fPAWaitingListPriority_Edit'];
	for (i=0; i<frm.elements.length; i++) {
		var el = frm.elements[i];
		var icn= "ld1351i" + el.name 
		//var el = frm.elements[arrElem[i]];
		if (el) {
			el.disabled=true;
			//alert(icn);
			icon=document.getElementById(icn)
			if (icon) icon.style.visibility = "hidden";
		}
	} 
}
function ReasonLookup(str) {
 	var lu = str.split("^");
	var obj;
	obj=document.getElementById("ChangeReason")
	if (obj) obj.value = lu[0]
	obj=document.getElementById("ChangeInitiator")
	if (obj) obj.value = lu[2]
}
function InitatorLookUp(str) {

 	var lu = str.split("^");
	var obj;
	obj=document.getElementById("ChangeInitiator")
	if (obj) obj.value = lu[0]
	obj=document.getElementById("ChangeReason")
	if (obj) obj.value = ""
}


document.body.onload = DocumentLoadHandler;
