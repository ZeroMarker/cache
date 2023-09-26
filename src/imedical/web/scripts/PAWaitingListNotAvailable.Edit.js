// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var origcode="";

function BodyLoadHandler() {

	//var obj;
      //The FromDate-ToDate validation is transfered to PAWaitingListNotAvailable.  
	//obj=document.getElementById('NADateTo');	
	//if (obj) obj.onblur=DateToChangeHandler;

	//obj=document.getElementById('NADateFrom');	
	//if (obj) obj.onblur=DateFromChangeHandler;

	obj=document.getElementById('update1')
	if (obj) obj.onclick = UpdateHandler;
	//if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateAll;

	var objREADesc=document.getElementById('READesc')
	if (objREADesc) {
		origcode=objREADesc.onchange; //copy the existing handler
		objREADesc.onchange=ReasonChangeHandler; // set the new handler
	}
	
	var obj=document.getElementById("NADateFrom")
	if (obj) obj.onblur=NADateFromHandler;
	var obj=document.getElementById("NADateTo")
	if (obj) obj.onblur=NADateToHandler;
}

function NADateFromHandler() {
	var objNA=document.getElementById("NADateFrom")
	var objNADT=document.getElementById("NADateTo")
	var objRD=document.getElementById("ReviewedDate")
	var objRC=document.getElementById("ReviewCalc")
	var objRDH=document.getElementById("ReviewDateHidden")
	if (objRD && objNA && objRC && objNADT && objNA.value!="" && objNADT.value=="") {
		objRD.value=AddToDateStrGetDateStr(objNA.value,"D",parseInt(objRC.value));
		if (objRDH) objRDH.value = objRD.value;
	}
}

function NADateToHandler() {
	var objRD=document.getElementById("ReviewedDate")
	var objRDH=document.getElementById("ReviewDateHidden")
	var objNADT=document.getElementById("NADateTo")
	var objNA=document.getElementById("NADateFrom")
	if (objNADT && objNADT.value!="") {
		if (objRD) {
			objRD.value=""
			objRDH.value=""
		}
	} else {
		NADateFromHandler();
	}
}

//SA 25.6.02 - log 25836: "Initiator" field to be cleared when "Reason" field cleared.
function ReasonChangeHandler() {
	//alert("changehandler called");

      if (typeof origcode!="function") origcode=new Function(origcode);
      //call the function i.e. the original handler
      if (origcode()==false) return false;

      //this could probably be rewritten as follows
     	//return origcode();

	obj=document.getElementById("READesc")
	if ((obj) && (obj.value=="")) {
		obj=document.getElementById("WLRGDesc")
		if (obj) obj.value ='';
	}
}

function ReasonLookup(str) {
 	var lu = str.split("^");
	var obj;
	obj=document.getElementById("READesc")
	if (obj) obj.value = lu[0]
	obj=document.getElementById("WLRGDesc")
	if (obj) obj.value = lu[2]
}


function InitatorLookUp(str) {

 	var lu = str.split("^");
	var obj;
	var obj;
	obj=document.getElementById("WLRGDesc")
	if (obj) obj.value = lu[0]
	obj=document.getElementById("READesc")
	if (obj) obj.value = ""
}

/*
//The FromDate-ToDate validation is transfered to Cache-PAWaitingListNotAvailable.websysSaveWithNoOverlap  
//KK 05-Feb-2002 The validation fails if FromDate=26/1/2002 and ToDate=30,31/1/2002.
function DateToChangeHandler(e) {
// rg - 02/01/2002, Modified to fix date array indexing
	var obj;
	var obj2;
	var date;
	var date2;
	var list;
	obj2=document.getElementById("NADateTo")
	obj=document.getElementById("NADateFrom")
	if ((obj)&&(obj.value!="")&&(obj2.value!="")) {	
		list= SplitDateStr(obj.value);
		alert(list["mn"]);
		date=new Date();
		date.setDate(list["dy"]);
		//date.setMonth(list["mn"]);
		date.setMonth(list["mn"]-1);
		date.setFullYear(list["yr"]);
		//alert("FromDate: " + date.setDate(list["dy"]) + "/" + date.setMonth(list["mn"]-1) + "/" + date.setFullYear(list["yr"]));
		list= SplitDateStr(obj2.value);
		date2=new Date();
		date2.setDate(list["dy"]);
		//date2.setMonth(list["mn"]);
		date2.setMonth(list["mn"]-1);
		date2.setFullYear(list["yr"]);
		alert("FromDate: " + date.valueOf() + "    ToDate: "+date2.valueOf())
		alert("FromDate-ToDate=" + (date.valueOf()-date2.valueOf()));
		if (date2.valueOf()<date.valueOf()) {
			alert('The "Date To" must be after "Date From"')
			obj2.value="" 
		}
	}
}

function DateFromChangeHandler(e) {
// rg - 02/01/2002, Modified to fix date array indexing
	var obj;
	var obj2;
	var date;
	var date2;
	var list;
	obj2=document.getElementById("NADateTo")
	obj=document.getElementById("NADateFrom")
	if ((obj2)&&(obj.value!="")&&(obj2.value!="")) {
		list= SplitDateStr(obj.value);
		date=new Date();
		date.setDate(list["dy"]);
		//date.setMonth(list["mn"]);
		date.setMonth(list["mn"]-1);
		date.setFullYear(list["yr"]);
		list= SplitDateStr(obj2.value);
		date2=new Date();
		date2.setDate(list["dy"]);
		//date2.setMonth(list["mn"]);
		date2.setMonth(list["mn"]-1);
		date2.setFullYear(list["yr"]);
		//alert(date.valueOf() + "    "+date2.valueOf())
		if (date2.valueOf()<date.valueOf()) {
			alert('The "Date To" must be after "Date From"')
			obj.value="" 
		}
	}
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
*/

function UpdateHandler() {
	// RQG 21.02.03 Log30708
	if (!CheckSuspDuration()) return false;

	return Update1_click();
	//gr log 30672
	/*if (self == top) {
		var win=window.opener;
		if (win) {
			win.treload('websys.csp');
		}
	}*/
	//if (window.opener) {
	//	window.opener.location.reload()
	//}


}

function CheckSuspDuration() {
	// RQG 21.02.03 LOG30708: QH custom - Suspension duration should not exceed 1000 days.
	// This is a dummy function here. Checks for QH done via custom js
	return true;
}

//functions used to enable/disable fields and display label as mandatory/non mandatory
//presently called by custom script for Austin, but left here for general use

function EnableField(fldName) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if (fld) {
		fld.disabled = false;
		fld.className = "";
		if (lbl) lbl = lbl.className = "clsRequired";
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


function labelMandatory(fld) {
	var lbl = document.getElementById('c' + fld) 
	if (lbl) {
		lbl=lbl.className = "clsRequired";
	}
}

function labelNormal(fld) {
	var lbl = document.getElementById('c' + fld) 
	if (lbl) {
		lbl=lbl.className = "";
	}
} 





function BodyUnloadHandler(e) {
	
	if (window.opener) {
		window.close()	
			
	}
}




//document.body.onunload=BodyUnloadHandler;

//document.body.onload=Init
document.body.onload=BodyLoadHandler;
//document.body.onunload=BodyUnloadHandler;







