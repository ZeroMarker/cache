// Copyright (c) 2004 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var objShowUnpaidBillsOnly=document.getElementById("ShowUnpaidBillsOnly");
var OldUnpaidOnclickEvent="";

var delim="^";
var aryPatBill=new Array();
var GroupType=""
var SundryID=""
var winOpener="";

var objGroupType=document.getElementById("GroupType")
if (objGroupType) GroupType=objGroupType.value;
var objSundryID=document.getElementById("SundryID")
if (objSundryID) SundryID=objSundryID.value;
var objCheckUncheck=document.getElementById("CheckUncheck");
var objSelectAll = document.getElementById("SelectAll");
var objAddBatch  = document.getElementById("AddToBatch");

/**
 *
 */
function BodyLoadHandler() {
	var obj="";
	if (top.frames["TRAK_main"]) {
		obj=top.frames["TRAK_main"].frames["SundryDetails"];
	
		if (obj) {
			var formtot=obj.document.forms['fARCSundryDebtor_ListTotal']; 
			if (formtot) {
				if (formtot.elements["RefreshCSP"].value==1) RefreshListTotals();
			}
		} else {
			// SA 28.7.03 - log 37756: Refresh was incorrectly being load on original page load for 
			// Batch Invoicing/Receipting. It is not required for these workflows.
			// PageType var set from workflow transition expressions.

			var objPageType=document.getElementById("PageType");
			if ((objPageType)&&(objPageType.value=="Batch")) {
				// no refresh/reload required
			} else {
				CheckBoxRefresh();
			}
		}
	}
	else {  // must be familiar with BatchReceipting and BatchLetter component to understand this
		
		// It's been opened in a new window eg. from batch receipting (search by Sundry)

		if (top.frames["ListBills"]) {
			var frm = top.frames["ListBills"];		
			if (frm.parent.window.opener) winOpener = frm.parent.window.opener;

			// window.opener.name -> TRAK_Main or FRAMEARCSundryFindBatch (see arcsundrybatchletter.csp)
		}
	}

	// FindBatchBodyLoadHandler appears in ARCSundryDebtor.FindBatch.js
	// Need to call this for batch receipting as it doesn't use frames
	try {
		FindBatchBodyLoadHandler();
	} catch(e) { }

	ARCSundryDebtor_DispNegOustand();
	CheckLinkDisable();
		
	if (objShowUnpaidBillsOnly) {
		OldUnpaidOnclickEvent=objShowUnpaidBillsOnly.onclick;
		objShowUnpaidBillsOnly.onclick=ShowUnpaidClickHandler;
	}

	if (objSelectAll && objSelectAll.value=="Y") SelectAllRows();

	if (objCheckUncheck) {
		objCheckUncheck.onclick = SelectAllRows;
		if (tsc['CheckUncheck']) websys_sckeys[tsc['CheckUncheck']] = SelectAllRows;
	}	

	if (top.frames["TRAK_main"]) {
		var objLAll=top.frames["TRAK_main"].frames["FRAMEARCSundryListBills"];
		if (objLAll) SelectAllRows();
	}

	if (objAddBatch)	objAddBatch.onclick=InvoiceForBatchHandler;

	//Log 44630 16/06/04 PeterC
	if (top.frames["TRAK_main"]) {
		var fobj=top.frames["TRAK_main"].frames[0];
		if ((fobj)&&(fobj.name=="SundryDetails")) fobj.treload('websys.csp');
	}
	
	//Log 61531 - 29.11.2006 - Make "Account Comments" link Bold if comments exist
	var obj=document.getElementById("AccCommExist");
	if (obj) {
		var hasComment=obj.value;
		if (hasComment=="1") {
			var obj=document.getElementById("AccComment");
			if (obj) obj.style.fontWeight="bold"; 
		}
	}
	//End Log 61531
}	

/**
 *
 */
function InvoiceForBatchHandler() {

	if (winOpener == null)  return false;

	var NextBillRowID="";
	var NewBillRowIDs="";
	var NextNewBillRowID="";
	var BillRowIDs="";
	
	var objBillRowIDs      = winOpener.document.getElementById("BillRowIDs");
	var objReceiptAmt      = winOpener.document.getElementById("ReceiptAmt");
	var objDepositRowIDs   = winOpener.document.getElementById("DepositRowIDs");
	var objCareProv        = winOpener.document.getElementById("CareProvDesc");

	try {
		delim = "|"; 
		NewBillRowIDs = BillRowIdBuilder();
		//alert(" - NewBillRowIDs*" + NewBillRowIDs +"*");
	} catch(e) {}

	if (NewBillRowIDs == "") {
		alert(t['NO_BILL_SELECTED']);

		return false;
	}
	else if (NewBillRowIDs!="" && objBillRowIDs) {
		
		BillRowIDs = objBillRowIDs.value;  // existing bill_IDs on the batch receipting list

		//alert("Current BillRowIDs "+ BillRowIDs + " - NewBillRowIDs " + NewBillRowIDs);

		if (BillRowIDs=="") {
			BillRowIDs = NewBillRowIDs;
		}
		else {
			var i = 0;
			var j = 0;
			var BillNo = BillNumberBuilder();

			while (winOpener.mPiece(NewBillRowIDs,"|",i) && winOpener.mPiece(NewBillRowIDs,"|",i)!="") {	

				NextNewBillRowID = winOpener.mPiece(NewBillRowIDs,"|",i);
				j = 0; // reset
				while (winOpener.mPiece(BillRowIDs,"|",j) && winOpener.mPiece(BillRowIDs,"|",j)!="" ) {

					NextBillRowID = winOpener.mPiece(BillRowIDs,"|",j);
					if (NextNewBillRowID == NextBillRowID) {
						if (BillNo!="")
							alert(t['INV_NUM'] + " " + winOpener.mPiece(BillNo,"^",i) + " " + t['IN_BATCH_ALREADY']);
						else
							alert(t['INV_NUM'] + " " + t['IN_BATCH_ALREADY']);

						return false;
					}
					j++;
				}
				i++;
			}
			BillRowIDs+= "|" + NewBillRowIDs;
		}

		objBillRowIDs.value = BillRowIDs;
	}

	var CONTEXT = winOpener.session['CONTEXT'];
	var ReceiptAmt="";
	var CareProv="";
	var DepositRowIDs="";
	
	if (objReceiptAmt)    ReceiptAmt    = objReceiptAmt.value;
      if (objCareProv)      CareProv      = objCareProv.value;
      if (objDepositRowIDs) DepositRowIDs = objDepositRowIDs.value;

	if (winOpener.name == "FRAMEARCSundryFindBatch") {
		
		var billfindFrm = winOpener.parent.frames["FRAMEARCSundryFindBills"];

		objBillRowIDs = billfindFrm.document.getElementById("BillRowIDs");
		objBillRowIDs.value = NewBillRowIDs;

		window.close();

		ReloadBatchLetter(billfindFrm);
	}
	else if (winOpener.name == "TRAK_main") {

		var url = "arcsundry.batchreceipt.csp?PageType=Batch&BillRowIDs="+BillRowIDs+"&DepositRowIDs="+DepositRowIDs;
		    url+= "&CONTEXT="+CONTEXT+"&CareProvDesc="+CareProv+"&ReceiptAmt="+ReceiptAmt+"&DontClearPayDet=1";

		//alert("TRAK_main" + url);

		window.close();
		winOpener.websys_createWindow(url,"TRAK_main");
	}

}

/**
 *  billfindFrm refers to ARCSundryDebtor.FindBills frame, hence ARCSundryDebtor.FindBills.js
 *  this function pretty similar to FindClickHandlerBatchLetter in ARCSundryDebtor.FindBills.js
 *  but the one in ARCSundryDebtor.FindBills.js is best to be left alone.
 *
 */
function ReloadBatchLetter(billfindFrm) {

	if (billfindFrm == null) return;

	var BillRowIDs="";
	var SingleBillRowID="";
	var InvoiceNumber="";
	var DateFrom=""; var DateTo="";
	var BatchNum="";
	var Hospital="";
	var MinAmount=""; var DaysOverdueFr=""; var DaysOverdueTo="";
	var NextBillRowID="";	
	var HiddenParams="";

	var objBatchNum   = billfindFrm.document.getElementById("BatchNum");
	var objDateFrom   = billfindFrm.document.getElementById("DateFrom");
	var objDateTo     = billfindFrm.document.getElementById("DateTo");
	var objBillRowIDs = billfindFrm.document.getElementById("BillRowIDs");
	var objHospital   = billfindFrm.document.getElementById("Hospital");
	var objCareProv	= billfindFrm.document.getElementById("CareProvDesc");
	
	if (objBatchNum)   BatchNum   = objBatchNum.value;
	if (objDateFrom)   DateFrom   = objDateFrom.value;
	if (objDateTo)     DateTo     = objDateTo.value;
	if (objBillRowIDs) BillRowIDs = objBillRowIDs.value;
	if (objHospital)   Hospital   = objHospital.value;
	if (objCareProv)   CareProv   = objCareProv.value;
	
	var HiddenParams = FormatHiddenParams(billfindFrm);
	if (HiddenParams == "false") return false;
	
	// NOTE: shouldn't pass any Hospital at all!

	var url= "arcsundry.batchletter.csp?BillRowIDs=" + BillRowIDs; // + "&Hospital="+Hospital;
	    url= url + "&CareProvDesc=" + CareProv + "&BatchNum=" + BatchNum + "&DateFrom=" + DateFrom + "&DateTo=" + DateTo;
	    url= url + "&HiddenParams=" + HiddenParams + "&CONTEXT="+billfindFrm.session['CONTEXT']+ "&ChkUnpBillsOnly=Y";

	//alert("ReloadBatchLetter " + url);

	websys_createWindow(url,"TRAK_main");
}

function FormatHiddenParams(billfindFrm) {
	var MinAmount=""; var DaysOverdueFr=""; var DaysOverdueTo="";
	var HiddenParams=""; var SundryCode=""; var SundryDesc="";

	var objSundCode         = billfindFrm.document.getElementById("SundryCode");
	var objSundDesc         = billfindFrm.document.getElementById("SundryDesc");
	var objMinAmountOwing   = billfindFrm.document.getElementById("MinAmountOwing");
	var objNoDaysOverdueFrom= billfindFrm.document.getElementById("NoDaysOverdueFrom");
	var objNoDaysOverdueTo  = billfindFrm.document.getElementById("NoDaysOverdueTo");

	if (objSundCode)          SundryCode = objSundCode.value;
	if (objSundDesc)          SundryDesc = objSundDesc.value;
	if (objMinAmountOwing)    MinAmount = objMinAmountOwing.value;
	if (objNoDaysOverdueFrom) DaysOverdueFr = objNoDaysOverdueFrom.value;
	if (objNoDaysOverdueTo)   DaysOverdueTo = objNoDaysOverdueTo.value;
	
/*	if (DaysOverdueFr=="0" || DaysOverdueTo=="0"){
		alert(t['DAYS_NONZERO']);
		websys_setfocus("NoDaysOverdueFrom");
		return "false";
	}
	if (DaysOverdueFr > DaysOverdueTo) {
		alert(t['INVALID_DAYS']);
		websys_setfocus("NoDaysOverdueFrom");
		return "false";
	}
*/

	if (SundryCode !="" || SundryDesc !="" || MinAmount!="" || DaysOverdueFr!="" || DaysOverdueTo !="") {
		HiddenParams=SundryCode + "^" + SundryDesc + "^" + MinAmount + "^" + DaysOverdueFr + "^" + DaysOverdueTo
	}
	return HiddenParams;
}

/**
 *
 */
function BillNumberBuilder() {
	var tbl= document.getElementById("tARCSundryDebtor_ListBills");
	var f  = document.getElementById("f"+tbl.id.substring(1,tbl.id.length));

	if (f && tbl) {
		var aryPatBillNo=new Array(); var aryStat=new Array(); var n=0;
		for (var i=1; i<tbl.rows.length; i++) {
			if (f.elements["SelectBillz"+i] && f.elements["SelectBillz"+i].checked) {
				aryPatBillNo[n]=document.getElementById("BillNoz"+i).innerText;
				n++;
			} else if (tbl.rows[i].className=="clsRowSelected") {
				aryPatBillNo[n]=document.getElementById("BillNoz"+i).innerText;
				n++;
			}
		}
		return aryPatBillNo.join("^");
	}
	return "";
}


function BillRowIdBuilder() {
	var tbl= document.getElementById("tARCSundryDebtor_ListBills");
	var f  = document.getElementById("f" + tbl.id.substring(1,tbl.id.length));

	if (f && tbl) {
		var aryID=new Array(); var aryStat=new Array(); 
		var n=0; 
		for (var i=1; i<tbl.rows.length; i++) {
			if (f.elements["SelectBillz"+i] && f.elements["SelectBillz"+i].checked) {
				aryID[n]= f.elements['BillRowIDz'+i].value;
				n++;
			} else if (tbl.rows[i].className=="clsRowSelected") {
				aryID[n]= f.elements['BillRowIDz'+i].value;
				n++;
			}
		}
		return aryID.join(delim);
	}
	return "";
}


/**
 *  This function will auto-select all rows in the table
 */
function SelectAllRows() {

	var tbl=document.getElementById("tARCSundryDebtor_ListBills");
	for (var i=1; i<tbl.rows.length; i++) {
		var SelectBillRow = document.getElementById("SelectBillz"+i);
		if (SelectBillRow) {
			if (objSelectAll && objSelectAll.value=="N")
				SelectBillRow.checked=false;
			else
				SelectBillRow.checked=true;
		}
	}
	
	// Reset for Select / Deselect [SelDeselectAll] Click.
	if (objSelectAll) {
		if (objSelectAll.value=="Y")
			objSelectAll.value="N";
		else
			objSelectAll.value="Y";
	}

	return false;
}

function RefreshListTotals() {

	var CONTEXT     =session['CONTEXT'];
	var objPageType =document.getElementById("PageType")
	var objAction   =document.getElementById("Action")
	
	var PageType="";
	var Action="";

	
	if (objPageType) PageType=objPageType.value;
	if (objAction)   Action  =objAction.value;
	
	var url="websys.default.csp?WEBSYS.TCOMPONENT=ARCSundryDebtor.ListTotal&SundryID="+SundryID;
	url += "&CONTEXT="+CONTEXT+"&Action="+Action+"&PageType="+PageType;
	
	websys_createWindow(url,'SundryDetails');
}

function ShowUnpaidClickHandler() {

	if (typeof OldUnpaidOnclickEvent!="function") OldUnpaidOnclickEvent=new Function(OldUnpaidOnclickEvent); 

	if (OldUnpaidOnclickEvent()==false) return false;

	CheckBoxRefresh();
}

function CheckBoxRefresh() {	

	var ShowUnpaidBillsOnly="";
	var Hospital="";
	var CONTEXT=session['CONTEXT'];

	var objPageType=document.getElementById("PageType")
	var objAction  =document.getElementById("Action")
	var objTWKFL   =document.getElementById('TWKFL');
	var objTWKFLI  =document.getElementById('TWKFLI');
	var objSundryID=document.getElementById("SundryID")

	var PageType="";
	var Action="";
	var TWKFL="";
	var TWKFLI="";

	if (objShowUnpaidBillsOnly && objSundryID) {
		if (objShowUnpaidBillsOnly.checked)
			ShowUnpaidBillsOnly="Y";
		else
			ShowUnpaidBillsOnly="N";
		
		if (objPageType) PageType=objPageType.value;
	      if (objAction)   Action=objAction.value;
		if (objTWKFL)    TWKFL=objTWKFL.value;
		if (objTWKFLI)   TWKFLI=objTWKFLI.value;

		var url ="arcsundry.listbill.csp?SundryID="+objSundryID.value+"&PageType="+PageType+"&Action="+Action+"&ShowUnpaidBillsOnly="+ShowUnpaidBillsOnly;
		url += "&TWKFL="+TWKFL+"&TWKFLI="+TWKFLI+"&CONTEXT="+CONTEXT+"&GroupType="+GroupType;

		//alert(url);
		
		websys_createWindow(url,"TRAK_main");
	} 
}

//ajiw
function ARCSundryDebtor_PaySelBillsHandler(e) {
	//Collect Allocate Payment menu

	var tbl = getTableName(window.event.srcElement);
	var BillsOK=true;

	var objShowUnpaidBillsOnly = document.getElementById("ShowUnpaidBillsOnly");
	var ShowUnpaidBillsOnly="";
	var CONTEXT=session['CONTEXT'];
	var objPageType = document.getElementById("PageType");
	var objAction   = document.getElementById("Action");
	
	var PageType="";
	var Action="";

	var f = document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var aryfound = CheckedCheckBoxesOrSelectedRow(f,tbl,"SelectBillz");

	if (aryfound.length==0) {
		alert(t['NO_BILL_SELECTED']);
		BillsOK = false;
	} else {
		//alert("aryfound.length="+aryfound.length);
		var BillRowIds="";
		var DepositIds="";
		var BillType="";
		var NextBillType="";
		var MsgBillsNotPrinted="";
		var CreatingAdmDep=false;
		var DepositEpisodeIds="";

		for (var i=0; i<aryfound.length; i++) {

			j = aryfound[i];
			NextBillType = f.elements["BillTypez"+j].value;

			// SA 30.10.03 - log 32354: Payment can no longer be made against a cancelled invoice.
			var TransactTypeCol = document.getElementById("TransTypez"+j);
			if (TransactTypeCol) {
				var val=TransactTypeCol.innerText;
				if  ((val!="")&&(val==t['CINV'])) {
					alert(t['NO_PAY_CINV_REF']);
					return false;
				}	
			}

			if (NextBillType=="D") {
				if (DepositIds=="") {
					DepositIds = f.elements["ReceiptIDz"+j].value;     // SA 27.2.03 - log 33200
				} else {					
					DepositIds = DepositIds + "^" + f.elements["ReceiptIDz"+j].value;
				}

			} else if (NextBillType=="A") {
				// do nothing
			} else {
				if (BillType=="") BillType=NextBillType;
				BillRowIds = BillRowIds + f.elements["BillRowIDz"+j].value;
				if (i < aryfound.length-1) {
					BillRowIds=BillRowIds+"|";
				}

				// SA 5.2.03 - log 32198: Warning message to appear when attempting to pay unprinted bills
				if (f.elements["BillPrintedz"+j].value=="N") {

					var MsgSingleBillNotPrinted="";
					var objInvTot=document.getElementById("InvTotalz"+j);
					var InvoiceTotal="";

					if (objInvTot) {
						InvoiceTotal=objInvTot.innerText;
						//if (PayorText!="") MsgSingleBillNotPrinted+=t['INV_TOT']+" "+InvoiceTotal;
						MsgSingleBillNotPrinted+=t['INV_TOT']+" "+InvoiceTotal;
					}

					if (MsgSingleBillNotPrinted!="") MsgBillsNotPrinted+=MsgSingleBillNotPrinted+"\n";
				}		
			}
		}
		if (BillType=="" && DepositIds=="" && !CreatingAdmDep) {
			alert(t['NO_BILL_SELECTED_PAY']+"\n"+t['SELECT_ATLEAST_ONE']);
			BillsOK = false;
		}

		// SA 5.2.03 - log 32198: Warning message to appear when attempting to pay unprinted bills
		if (MsgBillsNotPrinted!="") {
			var bConfirmBillsNotPrinted=1;
			MsgBillsNotPrinted += "\n" + t['BILLS_NOT_PRINTED'] + "\n\n" + t['CONTINUE'];
			bConfirmBillsNotPrinted = confirm(MsgBillsNotPrinted);
			if (!bConfirmBillsNotPrinted) return false;
		}

		if (BillsOK) {
			if (objShowUnpaidBillsOnly) {
				if (objShowUnpaidBillsOnly.checked)	
					ShowUnpaidBillsOnly="Y";
				else
					ShowUnpaidBillsOnly="N";
			}

			if (objPageType) PageType=objPageType.value;
	      	if (objAction)   Action  =objAction.value;
			
			//make sure SundryID is passed to ARReceipts.Edit
			var url ="websys.default.csp?WEBSYS.TCOMPONENT=ARReceipts.Edit&BillRowIDs="+BillRowIds+"&BillType="+BillType;
			url +="&SundryID="+SundryID+"&DepositIDs="+DepositIds+"&PageType="+PageType+"&Action="+Action+"&GroupType="+GroupType;
			url +="&ShowUnpaidBillsOnly="+ShowUnpaidBillsOnly+"&CONTEXT="+CONTEXT;  
                        //Log 59598 - BC - 29-06-2006 : remove statusbar variable (status=) to display the status bar.		
			websys_createWindow(url,'child2','toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes');
		}
	}
}

function ARCSundryDebtor_PayDepositHandler(e) {

	var objShowUnpaidBillsOnly = document.getElementById("ShowUnpaidBillsOnly");
	var ShowUnpaidBillsOnly="";
	var CONTEXT=session['CONTEXT'];
	var objPageType = document.getElementById("PageType")
	var objAction   = document.getElementById("Action")
	
	var PageType="";
	var Action="";

	if (objShowUnpaidBillsOnly) {
		if (objShowUnpaidBillsOnly.checked)	
			ShowUnpaidBillsOnly="Y";
		else
			ShowUnpaidBillsOnly="N";
	}

	if (objPageType) PageType=objPageType.value;
     	if (objAction)   Action  =objAction.value;
			
	//make sure SundryID is passed to ARReceipts.Edit

	var url ="websys.default.csp?WEBSYS.TCOMPONENT=ARReceipts.Edit&BillType=D&SundryID="+SundryID;
	url += "&PageType="+PageType+"&Action="+Action+"&GroupType="+GroupType;
	url +="&ShowUnpaidBillsOnly="+ShowUnpaidBillsOnly+"&CONTEXT="+CONTEXT;
        //Log 59598 - BC - 29-06-2006 : remove statusbar variable (status=) to display the status bar.			
	websys_createWindow(url,'child2','toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes');
}

function ARCSundryDebtor_AddModifyComments(e) {
	var tbl=getTableName(window.event.srcElement);

	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var aryfound=CheckedCheckBoxesOrSelectedRow(f,tbl,"SelectBillz");
	var pContext=document.getElementById("TWKFL");
	if (pContext) {
		var billContext=pContext.value;
	}

	if (aryfound.length==0) {
		alert(t['NO_BILL_SELECTED']);
	} else {
		//KK 28/Apr/2003 Log 33029 
		var obj=top.frames["TRAK_main"].frames["ListTotals"];
		if (obj) {
			var formtot=obj.document.forms['fARPatientBill_ListTotals']; 
			if (formtot) formtot.elements["RefreshCSP"].value=1;
		}

		if (aryfound.length==1) {
			var BillID=f.elements["BillRowIDz"+aryfound].value;
			//alert(BillID);
			var EpisID=f.elements["EpisodeIDz"+aryfound].value;
			var PatID=f.elements["PatientIDz"+aryfound].value;
			var objPageType=document.getElementById('PageType'); 
			var strPageType="";
			var strPageParams="";
			if (objPageType) {
				var strPageType=objPageType.value; 			
			}
			var objPageParams=document.getElementById('PageParams'); 
			if (objPageParams) {
				var strPageParams=objPageParams.value; 			
			}
			var PageParams="&PageType="+strPageType+"&PageParams="+strPageParams
			var url="websys.default.csp?WEBSYS.TCOMPONENT=PAAdm.EditComments&BillRowID="+BillID+"&EpisodeID="+EpisID+"&PatientID="+PatID+PageParams;
                        //Log 59598 - BC - 29-06-2006 : remove statusbar variable (status=) to display the status bar.			
			websys_createWindow(url,'child2','left=100,width=400,height=480,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes');

		} else {
			var TempBillRowid="";
			for (var i=0; i<aryfound.length; i++) {
				var BillAry=new Array();
				j=aryfound[i];
				if (TempBillRowid!=f.elements["BillRowIDz"+j].value) {
					alert(t['SELECT_ONLY_ONE']);
					break;
				} else {
					//var BillRowid=f.elements["BillRowIDz"+aryfound].value;
					//var EpisID=f.elements["EpisodeIDz"+aryfound].value;
					//var url="websys.default.csp?WEBSYS.TCOMPONENT=PAAdm.EditComments&BillRowID="+BillRowid+"&EpisodeID="+EpisID;
                                        //Log 59598 - BC - 29-06-2006 : remove statusbar variable (status=) to display the status bar.			
					//websys_createWindow(url,'child','left=100,width=400,height=480,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes');					
				}
				//if (f.elements["BillRowIDz"+j].value=="") f.elements["BillRowIDz"+j].value="55";							
				var TempBillRowid=f.elements["BillRowIDz"+j].value;
				BillAry[BillAry.length]=f.elements["BillRowIDz"+j].value;
			}
		}
	}
}

function ARCSundryDebtor_DispNegOustand(e) {

	var tbl=document.getElementById("tARCSundryDebtor_ListBills");
	for (var i=1; i<tbl.rows.length; i++) {
		var OutAmtCol=document.getElementById("OutstandAmtz"+i);
		if (OutAmtCol) {
			var val=parseInt(OutAmtCol.innerText,10);
			if (OutAmtCol && val<0) {
				OutAmtCol.style.color="Red";
			}
		}
	}
	
}

function CheckLinkDisable() {
	var tbl=document.getElementById("tARCSundryDebtor_ListBills");

	for (var i=1; i<tbl.rows.length; i++) {

		//CellColumnName pattern is FieldName + z + rowNo
		var TransactTypeCol=document.getElementById("TransTypez"+i);
		if (TransactTypeCol) {
			var val=TransactTypeCol.innerText;
			if  (val!="") {

				//Disable invoice total and adjustment total links if transactype is other than invoice

				if (val!=t['INV'] && val!=t['REF'] && val!=t['CREDIT_NOTE'] && val!=t['CINV']) {
					//invoice total
					var objCB=document.getElementById("InvTotalz"+i);
					if (objCB) {
						objCB.disabled=true;
						objCB.onclick=LinkDisable;
					}
					//Adjustment Total
					var objAT=document.getElementById("AdjTotalz"+i);
					if (objAT) {
						objAT.disabled=true;
						objAT.onclick=LinkDisable;
					}
				}
			}
		}
	}
}

function BillRowIdBuilder() {
	var tbl=document.getElementById("tARCSundryDebtor_ListBills");
	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	if ((f)&&(tbl)) {

		var aryID=new Array(); var aryStat=new Array(); var n=0; 
		for (var i=1;i<tbl.rows.length;i++) {
			if ((f.elements["SelectBillz"+i])&&(f.elements["SelectBillz"+i].checked)) {
				aryID[n]=f.elements['BillRowIDz'+i].value;
				n++;
			} else if (tbl.rows[i].className=="clsRowSelected") {
				aryID[n]=f.elements['BillRowIDz'+i].value;
				n++;
			}
		}
		return aryID.join(delim);
	}
	return "";
}

function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if (el.disabled) {
		return false;
	}
	return true;
}

// log 32170: Hightlighted rows which do not have the checkbox checked, are now teated as selected rows.
function CheckedCheckBoxesOrSelectedRow(f,tbl,col) {
	var aryfound=new Array;found=0;
	for (var i=1;i<tbl.rows.length;i++) {
		if (f.elements[col+i] && f.elements[col+i].checked && !f.elements[col+i].disabled) {
			aryfound[found]=i;found++;
		} else if (tbl.rows[i].className=="clsRowSelected") {
			aryfound[found]=i;found++;
		}
	} 
	return aryfound;
}

//Log 64035 - 21.06.2007 - no not need this for Sundry Bills
/*function SelectRowHandler(evt) {
	var eSrc=websys_getSrcElement(evt);
	if (eSrc.tagName=="IMG") eSrc=websys_getParentElement(eSrc);
	var eSrcAry=eSrc.id.split("z");
	if (eSrcAry[0]=="SelectBill") {
		if (eSrcAry[1]) SelectDepositsForBill(eSrcAry[1]);
	}
}*/

function PrintSelectedRowsHandler(tblname,lnk,newwin) {
	var found=0;
	var BillType="";
	var BillRowID="";

	if (tblname=="") {
		var eSrc=websys_getSrcElement();
		if(eSrc) var tbl=getTableName(eSrc);
	} else {
		var tbl=document.getElementById(tblname);
	}
	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var aryfound=CheckedCheckBoxesOrSelectedRow(f,tbl,"SelectBillz");

	if (aryfound.length==0) {
		alert(t['NO_BILL_SELECTED']);
	} else {
		if (newwin=="TRAK_hidden") {
			for (i in aryfound) {
				j=aryfound[i];
				BillRowID=f.elements["BillRowIDz"+j].value;
				NextBillType=f.elements["BillTypez"+j].value;
				if (NextBillType!="I" && NextBillType!="P") {
					//bill type other than invoice has been selected.
					alert(t['PRNT_INVOICES']);
					BillsOK=false;
					return false;
				}
				if (BillType=="") {
					BillType=NextBillType;	
				}
				if (BillType!="I" && BillType!="P") {
					alert(t['PRNT_INVOICES']);
					BillsOK=false; 
					return false;	
				}
			}
			var hiddenwin=window.open('',newwin);
			with (hiddenwin) {
				document.writeln('<HTML><HEAD></HEAD><BODY>');
				document.writeln('<FORM name="HFORM" id="HFORM" method="POST" action="' + lnk + '">');
				document.writeln('<INPUT NAME="MULTI" VALUE="1">');
				document.writeln('<INPUT NAME="MULTIITEMS" VALUE="BillRowID">');
				// for each row selected
				for (i in aryfound) {
					var row=aryfound[i];
					// check for specific values - these values must be hidden in the component
					if (!f.elements["BillRowIDz"+row]) continue;
					if (f.elements["BillRowIDz"+row].value!="") {
						document.writeln('<INPUT NAME="BillRowID" VALUE="' + f.elements["BillRowIDz"+row].value + '">');
					}
				}
				//Log 63924 - 08.06.2007 - to prevent stack overflow error
				//document.writeln('</FORM><SCR'+'IPT>');
				//document.writeln('window.HFORM.submit();');
				//document.writeln('</SCR'+'IPT></BODY></HTML>');
				document.writeln('</FORM></BODY></HTML>');
				document.close();
				document.HFORM.submit();	
				// End Log 63924 
			}
			
		} else {
			// for each row selected
			for (i in aryfound) {
				var row=aryfound[i];
				// check for specific values - these values must be hidden in the component
				if (!f.elements["BillRowIDz"+row]) continue;
				if (f.elements["BillRowIDz"+j].value!="") {
					// when the report is crystal and will be previewed pass these parameters so they can
					// be converted to prompt(n) variables.
					PassReportParametersForPreview(lnk,newwin,f.elements["BillRowIDz"+row].value);
				}
			}
		}
	}
	return false;
}

document.body.onload=BodyLoadHandler;

