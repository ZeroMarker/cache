// Copyright (c) 2004 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var objDateFrom  = document.getElementById("DateFrom");
var objDateTo    = document.getElementById("DateTo");
var showubionly  = document.getElementById("ShowUnpaidBillsOnly");
var unpaidbionly = document.getElementById("ChkUnpBillsOnly");


function BodyLoadHandler() {

	var objFindBatchInv = document.getElementById('FindBatchInv');
	if (objFindBatchInv) {
		objFindBatchInv.onclick = FindClickHandlerBatchInvoice;
		if (tsc['FindBatchInv']) websys_sckeys[tsc['FindBatchInv']] = FindClickHandlerBatchInvoice;
	}

	var objFindBatchLtr = document.getElementById('FindBatchLetter');
	if (objFindBatchLtr) {
		objFindBatchLtr.onclick = FindClickHandlerBatchLetter;
		if (tsc['FindBatchLetter']) websys_sckeys[tsc['FindBatchLetter']] = FindClickHandlerBatchLetter;
	}

	var sbobj=document.getElementById("ShowBills");
	if (sbobj) {
		sbobj.onclick = ShowBillsClickHandler;
		ShowBillsClickHandler();
	}

	// Date range check to be performed.
	if (objDateFrom) objDateFrom.onchange=DateFromChangeHandler;
	if (objDateTo)   objDateTo.onchange  =DateToChangeHandler;

}

function ShowBillsClickHandler() {
	var sbobj=document.getElementById("ShowBills");
	var suobj=document.getElementById("ShowUnpaidBillsOnly");
	if (sbobj && suobj) {
		if (sbobj.checked) 
			suobj.disabled =false;
		else {
			suobj.checked = false;
			suobj.disabled = true;
		}
	}
}

function Find() {

	if (! CheckDateRange()) return false;
	if (! FutureDateCheck("DateFrom")) return false;
	if (! FutureDateCheck("DateTo")) return false;


	if (showubionly) {
		if (showubionly.tagName=="LABEL") {
			if (unpaidbionly) unpaidbionly.value=showubionly.innerText;
   	      } else { 
		    if (showubionly.checked) {
			if (unpaidbionly) unpaidbionly.value=showubionly.value;
		    } else { if (unpaidbionly) unpaidbionly.value=""; }
		}

		if (unpaidbionly) {
			if (unpaidbionly.value!="" && unpaidbionly.value=="on") {
				unpaidbionly.value="Y";
			} else { unpaidbionly.value=""; }
		}
	} else {
		if (unpaidbionly) unpaidbionly.value="Y";
	}
	
	//alert(" UnpaidBill= " + unpaidbionly.value);

	return true;
}

// FindBatchInv button
function FindClickHandlerBatchInvoice() {

	if (Find() == false) 
		return false;

	if (evtTimer) {
		setTimeout("FindClickHandlerBatchInvoice()",200);
	} 
	else {

		var objHiddenParams=document.getElementById("HiddenParams");
		var HiddenParams = FormatHiddenParams();
		if (HiddenParams == "false") return false;
		if (objHiddenParams) objHiddenParams.value = HiddenParams;

		return FindBatchInv_click();
	}
}

// Find button
// 42819 - AJI 30.03.04

function FindClickHandlerBatchLetter() {

	Find();

	if (evtTimer) {
		setTimeout("FindClickHandlerBatchLetter()",200);
	} 
	else {

		var BillRowIDs=""; var SingleBillRowID=""; var NextBillRowID="";
		var InvoiceNumber=""; var BatchNum="";
		var DateFrom=""; var DateTo="";
		var Hospital=""; var CareProv="";
		var CONTEXT=session['CONTEXT'];

		var objBatchNum=document.getElementById("BatchNum");
		if (objBatchNum) BatchNum=objBatchNum.value;
		var objDateFrom=document.getElementById("DateFrom");
		if (objDateFrom) DateFrom=objDateFrom.value;
		var objDateTo=document.getElementById("DateTo");
		if (objDateTo) DateTo=objDateTo.value;

		var objBillRowIDs=document.getElementById("BillRowIDs");
		if (objBillRowIDs) BillRowIDs=objBillRowIDs.value;
		var objHospital=document.getElementById("Hospital");
		if (objHospital) Hospital=objHospital.value;
		
		var objCareProv=document.getElementById("CareProvDesc");
		if (objCareProv) CareProv=objCareProv.value;

		var HiddenParams = FormatHiddenParams();
		if (HiddenParams == "false") return false;
		
		//alert("Hidden Params " + HiddenParams);

		var url= "arcsundry.batchletter.csp?BillRowIDs=" + BillRowIDs + "&Hospital="+Hospital;
		    url= url + "&CareProvDesc=" + CareProv + "&BatchNum=" + BatchNum + "&DateFrom=" + DateFrom + "&DateTo=" + DateTo;
		    url= url + "&HiddenParams=" + HiddenParams + "&CONTEXT="+CONTEXT;
		    url= url + "&ChkUnpBillsOnly=" + unpaidbionly.value;
	
		//alert(url);

		//FindBatchLetter_click();

		websys_createWindow(url,"TRAK_main");
	}
}

function FormatHiddenParams() {

	var MinAmount=""; var DaysOverdueFr=""; var DaysOverdueTo="";
	var HiddenParams="";
	var SundryCode="";
	var SundryDesc="";

	var objSundCode         = document.getElementById("SundryCode");
	var objSundDesc         = document.getElementById("SundryDesc");
	var objMinAmountOwing   = document.getElementById("MinAmountOwing");
	var objNoDaysOverdueFrom= document.getElementById("NoDaysOverdueFrom");
	var objNoDaysOverdueTo  = document.getElementById("NoDaysOverdueTo");

	if (objSundCode)          SundryCode = objSundCode.value;
	if (objSundDesc)          SundryDesc = objSundDesc.value;
	if (objMinAmountOwing)    MinAmount = objMinAmountOwing.value;
	if (objNoDaysOverdueFrom) DaysOverdueFr = objNoDaysOverdueFrom.value;
	if (objNoDaysOverdueTo)   DaysOverdueTo = objNoDaysOverdueTo.value;
	
	if (DaysOverdueFr=="0" || DaysOverdueTo=="0"){
		alert(t['DAYS_NONZERO']);
		websys_setfocus("NoDaysOverdueFrom");
		return "false";
	}
	if (DaysOverdueFr > DaysOverdueTo) {
		alert(t['INVALID_DAYS']);
		websys_setfocus("NoDaysOverdueFrom");
		return "false";
	}

	if (SundryCode !="" || SundryDesc !="" || MinAmount!="" || DaysOverdueFr!="" || DaysOverdueTo !="") {
		HiddenParams=SundryCode + "^" + SundryDesc + "^" + MinAmount + "^" + DaysOverdueFr + "^" + DaysOverdueTo
	}
	return HiddenParams;
}

function DateFromChangeHandler() {

	DateFrom_changehandler();
	FutureDateCheck("DateFrom");	
}

function DateToChangeHandler() {

	DateTo_changehandler();
	FutureDateCheck("DateTo");	
}

function FutureDateCheck(objName) {

	var obj=document.getElementById(objName);
	if (obj) {
		if (obj.value!="") {	
			if (DateStringCompareToday(obj.value)==1) {
				alert(t['FUTURE_DATE_INVALID']);
				obj.className="clsInvalid";
				return false;
			} else {
				obj.className="";
			}
		} else {
			obj.className="";
		}
	}
	return true;
}

function CheckDateRange() {
	
	if (objDateFrom && objDateTo && objDateFrom.value!="" && objDateTo.value!="") {
		if (DateStringCompare(objDateFrom.value,objDateTo.value)==1) {
			alert(t['DATE_RANGE_INVALID']);
			objDateFrom.className="clsInvalid";
			websys_setfocus("DateFrom");
			return false;
		}	
	}
	
	return true;
}

/*

function HospLookupSelect(str) {
	//alert(str);
	var lu = str.split("^");
	var frm=""; var Hospital="";
	if(parent.frames["FRAMEARPatientBillFindBatch"]) frm=parent.frames["FRAMEARPatientBillFindBatch"].document.forms["fARPatientBill_FindBatch"];
	if (frm) {
		frm.Hosp.value=lu[0];
		//alert(frm.Hosp.value);
	}
}
*/

document.body.onload=BodyLoadHandler;


