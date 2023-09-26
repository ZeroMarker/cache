// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var objDateFrom=document.getElementById("DateFrom");
var objDateTo=document.getElementById("DateTo");

var objDischDateFrom=document.getElementById("DischDateFrom");
var objDischDateTo=document.getElementById("DischDateTo");

var objAdmDateFrom=document.getElementById("AdmDateFrom");
var objAdmDateTo=document.getElementById("AdmDateTo");

var objOrdCat=document.getElementById("OEOrderCat");
var objOrdCatGroup=document.getElementById("OEOrderCatGroup");

/**
 * 
 */
function BodyLoadHandler() {

	// L43287 
	var objFindInv=document.getElementById('FindBatchInvoice');
	if (objFindInv) objFindInv.onclick=FindClickHandlerBatchInvoice;
	if (tsc['FindBatchInvoice']) websys_sckeys[tsc['FindBatchInvoice']]=FindClickHandlerBatchInvoice;

	var objFind=document.getElementById('FindBatchLetter');
	if (objFind) objFind.onclick=FindClickHandlerBatchLetter;
	if (tsc['FindBatchLetter']) websys_sckeys[tsc['FindBatchLetter']]=FindClickHandlerBatchLetter;

	// L32864
	var objFindAll=document.getElementById('FindAll');
	if (objFindAll) objFindAll.onclick=FindAllClickHandler;
	if (tsc['FindAll']) websys_sckeys[tsc['FindAll']]=FindAllClickHandler;

	var sbobj=document.getElementById("ShowBills");
	if (sbobj) {
		sbobj.onclick=ShowBillsClickHandler;
		ShowBillsClickHandler();
	}

	// L27282
	var objShowEps=document.getElementById("ShowEpisodes");
	if (objShowEps) {
		objShowEps.onclick=ShowEpisodesClickHandler;
		ShowEpisodesClickHandler();
	}

	// L48371 jpd
	var objPrint=document.getElementById("Print");
	if (objPrint) objPrint.onclick = PrintClickHandler;

	if (objDateFrom) objDateFrom.onchange=DateChangeHandler;
	if (objDateTo) objDateTo.onchange=DateChangeHandler;

	if (objDischDateFrom) objDischDateFrom.onchange=DateChangeHandler;
	if (objDischDateTo) objDischDateTo.onchange=DateChangeHandler;

	if (objAdmDateFrom) objAdmDateFrom.onchange=DateChangeHandler;
	if (objAdmDateTo) objAdmDateTo.onchange=DateChangeHandler;

	if (objOrdCat) objOrdCat.onchange=OEOrderCatChangeHandler;
	if (objOrdCatGroup) objOrdCatGroup.onchange=OEOrderCatGroupChangeHandler;

	var obj=document.getElementById("EpisType");
	if (obj) obj.onchange=SetAdmissionType;
	SetAdmissionType();

	var obj=document.getElementById("PayorRemove");
	if (obj) obj.onclick=PayorRemove;

	var obj=document.getElementById("OEOrderSubCatRemove");
	if (obj) obj.onclick=OEOrderSubCatRemove;
}

//jpd L48371
function PrintClickHandler() {

	var BillRowIDs="";
	var objBillRowIDs=document.getElementById("BillRowIDs");
	if (objBillRowIDs) BillRowIDs=objBillRowIDs.value;
	var PrintLetter=document.getElementById("PrintLetter");
	var LetterType=document.getElementById("LetterType");
	if ((PrintLetter) && (PrintLetter.checked==true)) {
		if ((LetterType) && (LetterType.value!="")){

			Print_click();

			//now refresh frames
			var url="websys.default.csp?WEBSYS.TCOMPONENT=ARPatientBill.Find&BillRowIDs="+BillRowIDs; 
			websys_createWindow(url,"FRAMEARPatientBillFind");

			var path="websys.default.csp?WEBSYS.TCOMPONENT=ARPatientBill.ListAll&BillRowIDs="+BillRowIDs;
			websys_createWindow(path,"FRAMEARPatientBillListAll");
		}
	}

}

function ShowBillsClickHandler() {
	var sbobj=document.getElementById("ShowBills");
	var suobj=document.getElementById("ShowUnpaidBillsOnly");
	var sunbj=document.getElementById("ShowUninvoicedBills");
	var szrbj=document.getElementById("ShowZeroBills");

	if (sbobj) {
		if (sbobj.checked) {
			if (suobj) suobj.disabled =false;
			if (sunbj) sunbj.disabled =false;
			if (szrbj) szrbj.disabled =false;
		}
		else {
			if (suobj) {
				suobj.checked = false;
				suobj.disabled = true;
			}
			if (sunbj) {
				sunbj.checked = false;
				sunbj.disabled = true;
			}
			if (szrbj) {
				szrbj.checked = false;
				szrbj.disabled = true;
			}
		}
	}
}

function ShowEpisodesClickHandler() {
	var objShowEps=document.getElementById("ShowEpisodes");
	var objShowVerEps=document.getElementById("ShowVerifiedEpisodes");
	if (objShowEps && objShowVerEps) {
		if (objShowEps.checked) 
			objShowVerEps.disabled =false;
		else {
			objShowVerEps.checked = false;
			objShowVerEps.disabled = true;
		}
	}
}

/**
 *  log 47679: Gets called by ARPatientBill.Find.Custom.js
 *  It's needed because clearing the value is currently not
 *  trigerring any event. So, generated script is overriden in xxx.Custom.js
 */
function OnValueClear(id) {
	var obj;

	if (id=='AdmLoc') {
		obj=document.getElementById("AdmLocID");
	}
	else if (id=='EpisType') {
		obj=document.getElementById("SelEpisType");
	}
	else if (id=='OEOrdItem') {
		obj=document.getElementById("OEOrdItemID");
	}

	if (obj) obj.value="";
	
	//alert("obj " + obj.value);
}

function OEOrderCatChangeHandler(e){
	var catobj=document.getElementById("OEOrderCatID");
	var subcatobj=document.getElementById("OEOrderSubCatID");
	var objOrdSubCat=document.getElementById("OEOrderSubCat");
	if (objOrdCat.value=="") {
		catobj.value="";
		subcatobj.value="";
		objOrdSubCat.value="";
	}
	if (objOrdSubCat.value=="") subcatobj.value="";
}

function OEOrderCatGroupChangeHandler(e) {
	var obj=document.getElementById("OEOrderCatGroupID");
	if (objOrdCatGroup.value=="") {
		obj.value="";
		objOrdCat.value="";
		OEOrderCatChangeHandler();
	}
}

function AdmLocLookupSelect(str) {
	lu=str.split("^");
	var obj=document.getElementById("AdmLocID");
	if (obj) obj.value=lu[1];
}

function OEOrdItemLookupSelect(str) {
	lu=str.split("^");
	var obj=document.getElementById("OEOrdItemID");
	if (obj) obj.value=lu[1];
}

function OEOrderSubCatLookupSelect(str) {
	lu=str.split("^");
	var obj=document.getElementById("OEOrderSubCatID");
	if (obj) obj.value=lu[1];
}

function OEOrderCatLookupSelect(str) {   
	lu=str.split("^");
	var obj=document.getElementById("OEOrderCatID");
	if (obj) obj.value=lu[1];
}

function OEOrderSubCatLookupSelect(str) {
	lu=str.split("^");
	var obj=document.getElementById("OEOrderSubCatID");
	if (obj) obj.value=lu[1];
}

function OEOrderCatGroupLookupSelect(str) {
	lu=str.split("^");
	var obj=document.getElementById("OEOrderCatGroupID");
	if (obj) obj.value=lu[2];
}

function EpisSubTypeLookupSelect(str) {
	//alert(str ); // Desc^RowID^Code
	var lu = str.split("^");
	var obj;
 	obj=document.getElementById("EpisSubType")
	if ((obj)&&(lu[0])) obj.value = lu[0];
 	obj=document.getElementById("EpisSubTypeRowID")
	if ((obj)&&(lu[1])) obj.value = lu[1];
	
}
function PlanLookupSelect(str) {
 	var lu = str.split("^");
	var obj;
 	obj=document.getElementById("Plan")
	if ((obj)&&(lu[0])) obj.value = lu[0];
 	obj=document.getElementById("Payor")
	if ((obj)&&(lu[1])) obj.value = lu[1];
}

function PayorChangeHandler() {
	Payor_changehandler();

 	var lu = str.split("^");
	var obj;
	obj=document.getElementById("Payor")
	if ((obj)&&(lu[0]))obj.value = lu[0];


	var obj=document.getElementById("Plan")
	if (obj) obj.value="";
	obj=document.getElementById("Office")
	if (obj) obj.value="";
}

function PayorLookupSelect(str) {

 	var lu = str.split("^");
	var obj;
	obj=document.getElementById("Payor")

	if ((obj)&&(lu[0]))obj.value = lu[0];
	var obj=document.getElementById("Plan")
	if (obj) obj.value="";
	obj=document.getElementById("Office")
	if (obj) obj.value="";

}

function PaymentClassLookupSelect(str) {
 	var lu = str.split("^");
 	var obj=document.getElementById("PaymentClass")
	if ((obj)&&(lu[0])) obj.value = lu[0];
 	obj=document.getElementById("AccountClass")
	if (obj) obj.value = "";
}

function AccountClassLookupSelect(str) {
 	var lu = str.split("^");
 	var obj=document.getElementById("AccountClass")
	if ((obj)&&(lu[0])) obj.value = lu[0];
 	obj=document.getElementById("PaymentClass")
	if ((obj)&&(lu[1])) obj.value = lu[1];
}

/**
 * 37695: Dates entered may not be in the future
 */
function DateChangeHandler(evt) {

	var src = websys_getSrcElement(evt);

	if (src.id=="DateFrom")
		DateFrom_changehandler();
	else if (src.id=="DateTo")
		DateTo_changehandler();
	else if (src.id=="DischDateFrom")
		DischDateFrom_changehandler();
	else if (src.id=="DischDateTo")
		DischDateTo_changehandler();
	else if (src.id=="AdmDateFrom")
		AdmDateFrom_changehandler();
	else if (src.id=="AdmDateTo")
		AdmDateTo_changehandler();


	if (!FutureDateCheck(src.id))	websys_setfocus(src.id);
}

function FutureDateCheck(objName) {

	// SA 30.10.03 - log 37695: Dates entered may not be in the future
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
	// 37695
	if ((objDateFrom)&&(objDateTo)&&(objDateFrom.value!="")&&(objDateTo.value!="")) {
		if (DateStringCompare(objDateFrom.value,objDateTo.value)==1) {
			alert(t['DATE_RANGE_INVALID']);
			objDateFrom.className="clsInvalid";
			websys_setfocus("DateFrom");
			return false;
		}	
	}	
	return true;
}

//rqg,Log27282: Set the hidden field to "Y" or "" depending on the state of the
//checkboxes fields
var showveponly=document.getElementById("ShowVerifiedEpisodes");
var showubionly=document.getElementById("ShowUnpaidBillsOnly");
var epi=document.getElementById("ChkEpisodes");
var bill=document.getElementById("ChkBills");
var verifiedeponly=document.getElementById("ChkEpisodesOnly");
var unpaidbionly=document.getElementById("ChkUnpBillsOnly");
var showep=document.getElementById("ShowEpisodes");
var showbi=document.getElementById("ShowBills");

/**
 * Checks if both ShowEpisodes and ShowBills is on the form, 
 * and makes sure at least one of them is selected.
 */
function Find() {

	if ((showep)&&(showbi)) {
		if ((showep.checked==false)&&(showbi.checked==false)) {
			alert(t['EPISODES_BILLS']);
			return false;
		}
	}

	if (!(CheckDateRange())) return false;

	if (!(FutureDateCheck("DateFrom"))) return false;
	if (!(FutureDateCheck("DateTo"))) return false;
	if (!(FutureDateCheck("DischDateTo"))) return false;
	if (!(FutureDateCheck("DischDateTo"))) return false;

	if (showep) {
		if (showep.tagName=="LABEL") {
			epi.value=showep.innerText;
		} else {
			if (showep.checked) {
				epi.value=showep.value;
			} else { epi.value=""; }
		}
		if (epi) {
			if ((epi.value!="")&&(epi.value=="on")) {
				epi.value="Y";
			} else { epi.value=""; }
		}
	} else {
		epi.value="";
	}

	if (showbi) {
		if (showbi.tagName=="LABEL") {
			bill.value = showbi.innerText;
   	      } else {
			if (showbi.checked) {
				bill.value=showbi.value;
			} else { bill.value=""; }
		}

		if ((bill.value!="")&&(bill.value=="on")) { 
			bill.value="Y";
		} else { bill.value="";	}
	} else {
		bill.value="Y";
	}

	if (showveponly) {
		if (showveponly.tagName=="LABEL") {
			verifiedeponly.value=showveponly.innerText;
   	      } else { 
			if (showveponly.checked) {
				verifiedeponly.value=showveponly.value;
			} else { verifiedeponly.value=""; }
		}

		if (verifiedeponly) {
			if ((verifiedeponly.value!="")&&(verifiedeponly.value=="on")) {
				verifiedeponly.value="Y";
			} else { verifiedeponly.value=""; }
		}
	} else {
		verifiedeponly.value="";
	}

	if (showubionly) {
		if (showubionly.tagName=="LABEL") {
			unpaidbionly.value=showubionly.innerText;
   	      } else { 
			if (showubionly.checked) {
				unpaidbionly.value=showubionly.value;
			} else { unpaidbionly.value=""; }
		}

		if (unpaidbionly) {
			if ((unpaidbionly.value!="")&&(unpaidbionly.value=="on")) {
				unpaidbionly.value="Y";
			} else { unpaidbionly.value=""; }
		}
	} else {
		unpaidbionly.value="Y";
	}
	//alert("epi="+epi.value+"  bill="+bill.value+"   verEpi="+verifiedeponly.value+"  UnpaidBill="+unpaidbionly.value);

	return true;
}

//This function will be overriden in a custom script, if needed
function IsPayorEmpty() {
	return true;
}

// FindBatchInvoice button

function FindClickHandlerBatchInvoice() {

	if (Find() == false)
		return false;
	
	if (!IsPayorEmpty())
		return false;
		
	return FindBatchInvoice_click();
}

// Find button
// 42819 - AJI 30.03.04

function FindClickHandlerBatchLetter() {

	if (Find() == false) 
		return false;

	var objPayor=document.getElementById("Payor");
	var objPayorGrp=document.getElementById("PayorGroup");
	if (objPayor && objPayorGrp) {
		if (objPayor.value=="" && objPayorGrp.value=="") {
			alert(t['PAYOR_AND_PAYORGRP_BLANK']);
			return false;
		}
	}

	if (evtTimer) {
		// SA 28.3.03 - no log: SP has added a timeout to the brokers.
		// This function had been being executed before the broker was called, 
		// which meant the hidden fields required had not yet been populated.
		// His suggestion was to add a timeout to this function
		setTimeout("FindClickHandlerBatchLetter()",200);
	} else {

		var BillRowIDs="";
		var SingleBillRowID="";
		var InvoiceNumber="";
		var DateFrom=""; var DateTo="";
		var Plan=""; var Office=""; var BatchNum=""; var PayorGroup="";
		var Payor=""; var Hospital=""; var URN=""; var Surname=""; var AccountClass="";
		var PaymentClass=""; var MinAmount=""; var DaysOverdueFr=""; var DaysOverdueTo="";
		var NextBillRowID="";	
		var CONTEXT=session['CONTEXT'];
		var frm="";
		var PayorList="";
	
		var objPayorGroup=document.getElementById("PayorGroup");
		if (objPayorGroup) PayorGroup=objPayorGroup.value;
		var objPayor=document.getElementById("Payor");
		if (objPayor) Payor=objPayor.value;
		var objOffice=document.getElementById("Office");
		if (objOffice) Office=objOffice.value;
		var objPlan=document.getElementById("Plan");
		if (objPlan) Plan=objPlan.value;
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
		var objURN=document.getElementById("URN");
		if (objURN) URN=objURN.value;
		var objSurname=document.getElementById("Surname");
		if (objSurname) Surname=objSurname.value;
		var objAccountClass=document.getElementById("AccountClass");
		if (objAccountClass) AccountClass=objAccountClass.value;
		var objPaymentClass=document.getElementById("PaymentClass");
		if (objPaymentClass) PaymentClass=objPaymentClass.value;
		var objMinAmountOwing=document.getElementById("MinAmountOwing");
		if (objMinAmountOwing) MinAmount=objMinAmountOwing.value;
		var objNoDaysOverdueFrom=document.getElementById("NoDaysOverdueFrom");
		if (objNoDaysOverdueFrom) DaysOverdueFr=objNoDaysOverdueFrom.value;
		var objNoDaysOverdueTo=document.getElementById("NoDaysOverdueTo");
		if (objNoDaysOverdueTo) DaysOverdueTo=objNoDaysOverdueTo.value;
		var objPayorList=document.getElementById("objPayorSel");
		if (objPayorList) PayorList=objPayorList.value;
	
		if (Payor=="") Payor=PayorList;		

		if (DaysOverdueFr=="0" || DaysOverdueTo=="0"){
			alert(t['DAYS_NONZERO']);
			websys_setfocus("NoDaysOverdueFrom");
			return false;
		}

		//Log 63897 - 07.06.2007 - added parseInt to expression
		if (parseInt(DaysOverdueFr) > parseInt(DaysOverdueTo)) {
			alert(t['INVALID_DAYS']);
			websys_setfocus("NoDaysOverdueFrom");
			return false;
		}
	
		var url= "arpatientbillbatchletter.csp?BillRowIDs="+BillRowIDs+"&Payor="+Payor+"&PayorGroup="+PayorGroup;
		url= url +"&AccountClass="+AccountClass+"&PaymentClass="+PaymentClass;
		url= url +"&Plan="+Plan+"&Office="+Office+"&BatchNum="+BatchNum+"&DateFrom="+DateFrom+"&DateTo="+DateTo;
		url= url +"&CONTEXT="+CONTEXT+"&Hospital="+Hospital;
		url= url +"&ChkBills="+bill.value+"&ChkEpisodes="+epi.value+"&ChkEpisodesOnly="+verifiedeponly.value+ "&ChkUnpBillsOnly="+unpaidbionly.value;
		url= url +"&URN="+URN+"&Surname="+Surname+"&MinAmountOwing="+MinAmount+"&NoDaysOverdueFrom="+DaysOverdueFr+"&NoDaysOverdueTo="+DaysOverdueTo;
		url= url +"&FindClk=1";		//Log 63564 - 11.05.2007 - denote find was clicked

		//alert("ARPatBill.Find " + url);

		FindBatchLetter_click();

		websys_createWindow(url,"TRAK_main");
	}
}

function FindAllClickHandler() {

	if (evtTimer) {
		// SA 28.3.03 - no log: SP has added a timeout to the brokers.
		// This function had been being executed before the broker was called, 
		// which meant the hidden fields required had not yet been populated.
		// His suggestion was to add a timeout to this function
		setTimeout("FindAllClickHandler()",200);
	} else {
		var BillRowIDs="";
		var SingleBillRowID="";
		var InvoiceNumber="";
		var Payor=""; var Hospital=""; var URN=""; var Surname=""; var AccountClass="";
		var PaymentClass=""; var MinAmount=""; var DaysOverdueFr=""; var DaysOverdueTo="";
		var NextBillRowID="";	
		var CONTEXT=session['CONTEXT'];
		var frm="";

		var objBillRowIDs=document.getElementById("BillRowIDs");
		//if (objBillRowIDs) BillRowIDs=objBillRowIDs.value;
		var objHospital=document.getElementById("Hospital");
		if (objHospital) Hospital=objHospital.value;
		var objURN=document.getElementById("URN");
		if (objURN) URN=objURN.value;
		var objSurname=document.getElementById("Surname");
		if (objSurname) Surname=objSurname.value;
		var objAccountClass=document.getElementById("AccountClass");
		if (objAccountClass) AccountClass=objAccountClass.value;
		var objPaymentClass=document.getElementById("PaymentClass");
		if (objPaymentClass) PaymentClass=objPaymentClass.value;
		var objMinAmountOwing=document.getElementById("MinAmountOwing");
		if (objMinAmountOwing) MinAmount=objMinAmountOwing.value;
		var objNoDaysOverdueFrom=document.getElementById("NoDaysOverdueFrom");
		if (objNoDaysOverdueFrom) DaysOverdueFr=objNoDaysOverdueFrom.value;
		var objNoDaysOverdueTo=document.getElementById("NoDaysOverdueTo");
		if (objNoDaysOverdueTo) DaysOverdueTo=objNoDaysOverdueTo.value;
	
		if (DaysOverdueFr=="0" || DaysOverdueTo=="0") {
			alert(t['DAYS_NONZERO']);
			websys_setfocus("NoDaysOverdueFrom");
			return false;
		}

		//Log 63897 - 07.06.2007 - added parseInt to expression
		if (parseInt(DaysOverdueFr) > parseInt(DaysOverdueTo)) {
			alert(t['INVALID_DAYS']);
			websys_setfocus("NoDaysOverdueFrom");
			return false;
		}

		if(parent.frames["FRAMEARPatientBillFindBatch"]) frm=parent.frames["FRAMEARPatientBillFindBatch"].document.forms["fARPatientBill_FindBatch"];
		if (frm) {
			Payor=frm.Payor.value;
			BillRowIDs=frm.BillRowIDs.value;
			SingleBillRowID=frm.SingleBillRowID.value;
			InvoiceNumber=frm.InvoiceNumber.value;
		}

		if (objBillRowIDs) objBillRowIDs.value=BillRowIDs;

		FindAll_click();

		var url="arpatientbillbatchletter.csp?BillRowIDs="+BillRowIDs+"&Payor="+Payor+"&Hospital="+Hospital+"&AccountClass="+AccountClass+"&PaymentClass="+PaymentClass+"&CONTEXT="+CONTEXT;
		url += "&URN="+URN+"&Surname="+Surname+"&MinAmountOwing="+MinAmount+"&NoDaysOverdueFrom="+DaysOverdueFr+"&NoDaysOverdueTo="+DaysOverdueTo;
		
		websys_createWindow(url,"TRAK_main");
	}
}

function HospLookupSelect(str) {
	var lu = str.split("^");
	var frm=""; var Hospital="";
	if(parent.frames["FRAMEARPatientBillFindBatch"]) frm=parent.frames["FRAMEARPatientBillFindBatch"].document.forms["fARPatientBill_FindBatch"];
	if (frm) {
		frm.Hosp.value=lu[0];
	}
}

//AJI 54503
function MultiOEOrderSubCatSelect(str) {
	var lu=str.split("^");
	var obj=document.getElementById("OEOrderSubCatMulti");
	if (obj) obj.value="";

	var objMulti=document.getElementById("OEOrderSubCatID");

	var lst=document.getElementById("OEOrderSubCatList");
	if (lst) {
		for (var i=0; i<lst.options.length; i++) {
			if (lst.options[i].value==lu[1]) return false;
		}
		AddItemToList(lst,lu[0],lu[1]);
		SetMultipleID(lst,objMulti);
	}
}

function OEOrderSubCatRemove() {
	var lst=document.getElementById("OEOrderSubCatList");
	var objPayorSel = document.getElementById("OEOrderSubCatID");
	if (lst) {
		RemoveFromList(lst);
		SetMultipleID(lst,objPayorSel);
	}

	return false;
}

//GR log 49702
function MultiPayorSelect(str) {
	lu=str.split("^");
	var obj=document.getElementById("PayorLookup");
	if (obj) obj.value="";
	var lst=document.getElementById("PayorList");
	var objPayorSel = document.getElementById("PayorSel");
	if (lst) {
		for (var i=0; i<lst.options.length; i++) {
			if (lst.options[i].value==lu[1]) return false;
		}
		AddItemToList(lst,lu[0],lu[1]);
		SetMultipleID(lst,objPayorSel);
	}
}

function PayorRemove() {
	var obj=document.getElementById("PayorList");
	var objPayorSel = document.getElementById("PayorSel");
	if (obj) {
		RemoveFromList(obj);
		SetMultipleID(obj,objPayorSel);
	}

	return false;
}

function SetMultipleID(lst,obj) {
	var arrItems = new Array();
	var multiID="";
	
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			if (lst.options[j].value!="") {
				multiID= multiID + lst.options[j].value + "|"
			}
		}
		multiID=multiID.substring(0,(multiID.length-1));
		if (obj) obj.value=multiID;
	}
}

function AddItemToList(list,desc,code) {
	list.options[list.options.length] = new Option(desc,code);
}

function RemoveFromList(obj) {
	for (var i=(obj.length-1); i>=0; i--) {
		if (obj.options[i].selected)
			obj.options[i]=null;
	}
}

//GR log 49703
function SetAdmissionType() {
	var arrItems = new Array();
	var types="";
	var lst = document.getElementById("EpisType");
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			if (lst.options[j].selected) {				
				types = types + lst.options[j].value + "|";
			}
		}
		types=types.substring(0,(types.length-1));
		//alert(types);
		var obj=document.getElementById("SelEpisType");
		if (obj) obj.value=types;
	}
}

//document.getElementById('Payor').onchange=PayorChangeHandler;


function BillGroupLookup(str) {
	var lu = str.split("^");
	var obj;
 	obj=document.getElementById("BillerGroup")
	if ((obj)&&(lu[0])) obj.value = lu[0];
 	obj=document.getElementById("BillGroupID")
	if ((obj)&&(lu[1])) obj.value = lu[1];
}

document.body.onload=BodyLoadHandler;
