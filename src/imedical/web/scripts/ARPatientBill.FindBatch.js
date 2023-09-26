// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

/**********************************
SA: The following functions appear in the generated scripts for this component:
(as well as all other components which contain fields with data type %Library.Currency)
CurrencyRound
SubtractCurrencyValues
AddCurrencyValues
MedtrakCurrToJSMath
**********************************/
var objBillsSelNo=document.getElementById("BillsSelNo");
var objBIN=document.getElementById("BatchInvoiceNumber");
var objBillRowIDs=document.getElementById("BillRowIDs");
var objInvoiceNumber=document.getElementById("InvoiceNumber");
var objSingleBillRowID=document.getElementById("SingleBillRowID");
var objReceiptAmt=document.getElementById("ReceiptAmt");
var objHiddenReceiptAmt=document.getElementById("HiddenReceiptAmt");
var objBillsAmtTot=document.getElementById("BillsAmtTot");
var objHiddenBillsAmtTot=document.getElementById("HiddenBillsAmtTot");
var objadd=document.getElementById("add");
var objaddBIN=document.getElementById("AddBatchInv");
var objupdate1=document.getElementById("update1");
var objremove=document.getElementById("remove");
var objReqdAmt=document.getElementById("ReqdAmt");
var objHiddenReqdAmt=document.getElementById("HiddenReqdAmt");
var objDepositsAmtTot=document.getElementById("DepositsAmtTot");
var objHiddenDepositsAmtTot=document.getElementById("HiddenDepositsAmtTot");
var objremoveDep=document.getElementById("removeDep");
var objaddDep=document.getElementById("addDep");
var objDepositRowIDs=document.getElementById("DepositRowIDs");
var objSingleDepositRowID=document.getElementById("SingleDepositRowID");
var objRecNum=document.getElementById("RecNum");
var objPayor=document.getElementById("Payor");
var objPayorLookUpIcon=document.getElementById('ld1297iPayor');
var objPayorHidden=document.getElementById("PayorHidden");
var objGroupType=document.getElementById("GroupType");
var objSelBatchInvNo=document.getElementById("SelectedInvBatchNo");
var ojbRecoupedAmt=document.getElementById("RecoupedAmt");
var objAmtToRecoup=document.getElementById("AmtToRecoup");
var objBillRowIDToRecoup=document.getElementById("BillRowIDToRecoup");
var objUnselDepositRowIDs=document.getElementById("UnselDepositRowIDs");
var objUnselBillRowIDs=document.getElementById("UnselBillRowIDs");

var objRefundChk=document.getElementById("RefundChk");
var objRefComm=document.getElementById("ARRCPRefundComments");

var GroupType="";
if (objGroupType) GroupType=objGroupType.value;

var objAddBatchInvoice=document.getElementById("AddBatchInvoice");
var objRemoveBatchInvoice=document.getElementById("RemoveBatchInvoice");

var docListAll;
if(parent.frames["BR.ARPatBillListAll"]) docListAll=parent.frames["BR.ARPatBillListAll"].document;

var winListAll;
if (parent.frames["BR.ARPatBillListAll"]) winListAll=parent.frames["BR.ARPatBillListAll"].window;



function FindBatchBodyLoadHandler() {

	if (objaddBIN) objaddBIN.onclick=AddBatchInvNum;
	if (tsc['AddBatchInv']) websys_sckeys[tsc['AddBatchInv']]=AddBatchInvNum;

	if (objAddBatchInvoice) objAddBatchInvoice.onclick=AddBatchBill;
	if (tsc['AddBatchInvoice']) websys_sckeys[tsc['AddBatchInvoice']]=AddBatchBill;	
	if (objRemoveBatchInvoice) objRemoveBatchInvoice.onclick=RemoveBatchBill;
	if (tsc['RemoveBatchInvoice']) websys_sckeys[tsc['RemoveBatchInvoice']]=RemoveBatchBill;
	
	if (objupdate1) objupdate1.onclick=UpdateAll;	
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateAll;
	
	//44252
	if (objAmtToRecoup) {
		objAmtToRecoup.disabled=true;
		objAmtToRecoup.className = "disabledField";
		objAmtToRecoup.onchange=RecoupInvoice;
	}

	// SA 11.12.02 - log 30133: If a Payor has been selected from a previous bill/deposit add
	if ((objPayor)&&(objPayor.value!="")) {	
		if (objPayor) objPayor.disabled = true;
		if (objPayorLookUpIcon) objPayorLookUpIcon.style.visibility = "hidden";
		if (objInvoiceNumber) {
		websys_setfocus("InvoiceNumber")
		} else if (objRecNum) {
			websys_setfocus("RecNum")
		}
	}

	SetRequiredAmount();
	ResetPaymentAmount();
	MakeFieldMandatory('PIN');  //43626
	
	//50945
	if (objRefundChk) objRefundChk.onclick=RefundChkClickHandler;
	
	CanRefundPayorDeposit();
}

function HospitalLookupSelect(str) {

	var lu = str.split("^");
	var objHosp=document.getElementById("Hosp");
	if (objHosp) {
		if (lu[1]!="") objHosp.value=lu[0];
	}
}

function SetRequiredAmount() {

	if ((objBillsAmtTot)&&(objDepositsAmtTot)&&(objReqdAmt)) {
		var BillsAmtTot=MedtrakCurrToJSMath(objBillsAmtTot.value);
		var DepositsAmtTot=MedtrakCurrToJSMath(objDepositsAmtTot.value);

		var RecoupedAmt=MedtrakCurrToJSMath("0");
		if (ojbRecoupedAmt) RecoupedAmt=MedtrakCurrToJSMath(ojbRecoupedAmt.value);

		objReqdAmt.value=CurrencyRound(BillsAmtTot-DepositsAmtTot-RecoupedAmt);
	}
}

function ResetPaymentAmount() {

	if (objReceiptAmt) {
		var ReceiptAmt=MedtrakCurrToJSMath(objReceiptAmt.value);
		objReceiptAmt.value=CurrencyRound(ReceiptAmt);
	}
}

function AddBill() {

	if (evtTimer) {
		setTimeout("AddBill()",200);
	} else {
		var BillRowIDs="";
		var ReceiptAmt="";
		var CONTEXT="";
		var NextBillRowID="";	
		var SingleBillRowID="";
		var objAction=document.getElementById("Action")
		var Action="";
		var Payor="";
		var DepositRowIDs="";
		var UnselBillRowIDs=objUnselBillRowIDs.value;

		if (objSingleBillRowID && objBillRowIDs) {
			
			//Broker does not call lookup select when field is cleared.
			//Will need to check if field has been cleared before continuing.
			if ((objInvoiceNumber)&&(objInvoiceNumber.value=="")) {
				objSingleBillRowID.value="";
			}

			if (objSingleBillRowID.value=="") {
				alert(t['NO_BILL']);
				return false;
			} else {

				var count=0;
				SingleBillRowID=objSingleBillRowID.value;
				BillRowIDs=objBillRowIDs.value;

				while (mPiece(BillRowIDs,"|",count) && mPiece(BillRowIDs,"|",count)!="") {
					NextBillRowID = mPiece(BillRowIDs,"|",count);
					if (NextBillRowID==SingleBillRowID) {
						alert(t['ALREADY_IN_BATCH']);
						objInvoiceNumber.value="";
						websys_setfocus(objInvoiceNumber.id);
						return false;
					}
					count=count+1;
				}
				
				count=0;
				while (mPiece(UnselBillRowIDs,"|",count) && mPiece(UnselBillRowIDs,"|",count)!="") {
					NextBillRowID = mPiece(UnselBillRowIDs,"|",count);
					if (NextBillRowID==SingleBillRowID) {
						alert(t['ALREADY_IN_BATCH']);
						objInvoiceNumber.value="";
						websys_setfocus(objInvoiceNumber.id);
						return false;
					}
					count=count+1;
				}

				if (BillRowIDs=="") {
					BillRowIDs=SingleBillRowID;			
				} else {
					BillRowIDs+="|"+SingleBillRowID;
				}
				objBillRowIDs.value = BillRowIDs;	// need this
			}
		}
	
		if (objReceiptAmt) { ReceiptAmt=objReceiptAmt.value; }
		CONTEXT=session['CONTEXT'];

	      if (objAction) Action = objAction.value;
      	if (objPayor) Payor   = objPayor.value;

	      if (objDepositRowIDs) DepositRowIDs=objDepositRowIDs.value;

		var url="arpatientbill.batchfind.csp?PageType=Batch&BillRowIDs="+BillRowIDs+"&DepositRowIDs="+DepositRowIDs;
		url +="&DontClearPayDet=1&ReceiptAmt="+ReceiptAmt+"&Payor="+websys_escape(Payor)+"&CONTEXT="+CONTEXT+"&Action="+Action;
		url += "&GroupType="+GroupType+ "&NewlyAddedBill=" + SingleBillRowID + "&SelectAll=Y";
		url += "&UnselBillRowIDs=" + objUnselBillRowIDs.value + "&UnselDepositRowIDs=" + objUnselDepositRowIDs.value;
		
		//alert(url);

		websys_createWindow(url,"TRAK_main");
	}
}

function AddDeposit() {

	if (evtTimer) {
		setTimeout("AddDeposit()",200);
	} else {

		var DepositRowIDs="";
		var ReceiptAmt="";
		var CONTEXT="";
		var NextDepositRowID="";
		var SingleDepositRowID="";
		var objAction=document.getElementById("Action");
		var Action="";
		var BillRowIDs="";
		var Payor="";
		var UnselDepositRowIDs=objUnselDepositRowIDs.value;

		if ((objSingleDepositRowID)&&(objDepositRowIDs)) {
		
			//Broker does not call lookup select when field is cleared.
			//Will need to check if field has been cleared before continuing.
			if ((objRecNum)&&(objRecNum.value=="")) {
				objSingleDepositRowID.value="";
			}
			if (objSingleDepositRowID.value=="") {
				alert(t['NO_DEPOSIT']);
				return false;
			} else {
				var count=0;
				SingleDepositRowID=objSingleDepositRowID.value;
				DepositRowIDs=objDepositRowIDs.value;

				while ((mPiece(DepositRowIDs,"^",count))&&(mPiece(DepositRowIDs,"^",count)!="")) {
					NextDepositRowID=mPiece(DepositRowIDs,"^",count);
					if (NextDepositRowID==SingleDepositRowID) {
						alert(t['DEP_ALREADY_IN_BATCH']);
						return false;
					}
					count=count+1;
				}

				count=0;
				while ((mPiece(UnselDepositRowIDs,"^",count))&&(mPiece(UnselDepositRowIDs,"^",count)!="")) {
					NextDepositRowID=mPiece(UnselDepositRowIDs,"^",count);
					if (NextDepositRowID==SingleDepositRowID) {
						alert(t['DEP_ALREADY_IN_BATCH']);
						return false;
					}
					count=count+1;
				}

				if (DepositRowIDs=="") {
					DepositRowIDs=SingleDepositRowID;			
				} else {
					DepositRowIDs+="^"+SingleDepositRowID;
				}
			
				//SA: Component object must be set, even though we are losing the component,
				//in order for List query to pick up this variable.
				objDepositRowIDs.value=DepositRowIDs;	
			}
		}

		if (objReceiptAmt) { ReceiptAmt=objReceiptAmt.value; }
		CONTEXT=session['CONTEXT'];

	      if (objAction) Action=objAction.value;
      	if (objPayor) Payor=objPayor.value;
		
		var BatchNum="";
		if (objSelBatchInvNo) BatchNum=objSelBatchInvNo.value;

		if (objBillRowIDs) BillRowIDs=objBillRowIDs.value;
		
		//50945
		var RefundComments="";
		var RefundChk="";
		if (objRefComm) RefundComments = objRefComm.value;
		if (objRefundChk) RefundChk = objRefundChk.checked ? 1 : 0;

		var url="arpatientbill.batchfind.csp?PageType=Batch&BillRowIDs="+BillRowIDs+"&DepositRowIDs="+DepositRowIDs+"&DontClearPayDet=1";
		url +="&ReceiptAmt="+ReceiptAmt+"&Payor="+websys_escape(Payor)+"&CONTEXT="+CONTEXT+"&Action="+Action+"&GroupType="+GroupType+"&SelectAll=Y";
		url +="&NewlyAddedDep=" + SingleDepositRowID;
		url += "&UnselBillRowIDs=" + objUnselBillRowIDs.value + "&UnselDepositRowIDs=" + objUnselDepositRowIDs.value;
		url += "&ARRCPRefundComments=" + RefundComments + "&RefundChk=" + RefundChk;

		//46940 - must check for BatchNum
		if (BatchNum!="")	url += "&ChkBills=Y&BatchNum="+BatchNum;

		//Also ensure that ChkBills is set to Y if passing BatchNum, otherwise MVBARPB11 won't return anything

		//alert(url);
		websys_createWindow(url,"TRAK_main");
	}
}


//46814
function BatchInvoiceNumberLookUpSelect(str) {
	try {
		var lu = str.split("^");
	
		if ((objPayor)&&(lu[1])) objPayor.value=lu[1];
		
		AddBatchInvNum();
	} catch(e) {
	}
}

function AddBatchInvNum() {

	//Log 46814

	var ReceiptAmt="";
	var CONTEXT="";
	var NextBillRowID="";	
	var SingleBillRowID="";
	var objAction=document.getElementById("Action")
	var Action="";
	var Payor="";
	var DepositRowIDs="";
	var BillRowIDs="";
	var BatchNum="";

	if (evtTimer) {
		setTimeout("AddBatchInvNum()",200);
	} else {
		if((objBIN)&&((objBIN.value=="")||(objBIN.className=="clsInvalid"))) {
			alert(t['NO_BATCH']);
			return false;
		}
	}

	if (objReceiptAmt) ReceiptAmt=objReceiptAmt.value;
	CONTEXT=session['CONTEXT'];
	if (objAction) Action=objAction.value;
      if (objPayor) Payor=objPayor.value;

	if (objBillRowIDs) BillRowIDs=objBillRowIDs.value;
	if (objDepositRowIDs) DepositRowIDs=objDepositRowIDs.value;
	if (objBIN) BatchNum=objBIN.value;

	var url="arpatientbill.batchfind.csp?PageType=Batch"+"&DepositRowIDs="+DepositRowIDs;
	url += "&DontClearPayDet=1&ReceiptAmt="+ReceiptAmt+"&Payor="+websys_escape(Payor)+"&CONTEXT="+CONTEXT+"&Action="+Action+"&GroupType="+GroupType;
	url += "&ChkBills=Y&SelectAll=Y&BatchNum="+BatchNum;

	/* NOTE:
	   Comment out &BillRowIDs="+BillRowIDs as if adding by batchNo only want the invoices contained in the batch
	   don't want other "independent" invoices. MVBARPB11 will do the hardwork finding invoices based on the BatchNum
	   Also ensure that ChkBills is set to Y if passing BatchNum, otherwise MVBARPB11 won't return anything
	*/

	websys_createWindow(url,"TRAK_main");
}


//50945
function RefundChkClickHandler(e) {

	ToggleRefundComments();
	ToggleField("InvoiceNumber");
	ToggleField("BatchInvoiceNumber");
	ToggleLink("SelectInvoices");
	ToggleLink("SearchBatchInvNo");
	ToggleLink("AddBatchInv");
}

//50945
function CanRefundPayorDeposit() {
	if ((objRefundChk)&&(!objRefundChk.checked)) DisableField("ARRCPRefundComments");

	var objDeposit=document.getElementById("DepositRowIDs");
	
	var ary=objDeposit.value.split("^");

	if (ary.length>1||objDeposit.value==""||objBillRowIDs.value!="") DisableField("RefundChk");
}

//50945
function EnableField(fldName,mandatory) {

	EnableField(fldName,false);
}

function EnableField(fldName,mandatory) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if (fld) {
		fld.disabled = false;
		fld.className = "";
		if (lbl&&mandatory)
			lbl = lbl.className = "clsRequired";
		else
			lbl = lbl.className = "";
	}
}

//50945
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

function ToggleField (name) {
	var fld = document.getElementById(name);
	if (fld==null) return;
	if (fld.disabled)
		EnableField (name)
	else
		DisableField (name);
}

function ToggleRefundComments() {

	if (objRefComm==null) return;
	if (objRefComm.disabled) {
		EnableField ("ARRCPRefundComments",true);
		websys_setfocus("ARRCPRefundComments");
	}
	else {
		DisableField ("ARRCPRefundComments");
	}
}

function CancelLink () {
	return false;
}
function DisableLink (name) {
	var link = document.getElementById(name);
	if (link==null) return;
	if (link.onclick)
		link.oldOnClick = link.onclick;
	link.onclick = CancelLink;
	link.disabled = true;
	if (link.style) link.style.cursor = 'default';
}
function EnableLink (name) {
	var link = document.getElementById(name);
	if (link==null) return;
	link.onclick = link.oldOnClick ? link.oldOnClick : null;
	link.disabled = false;
	if (link.style) link.style.cursor = document.all ? 'hand' : 'pointer';
}

function ToggleLink (name) {
	var link = document.getElementById(name);
	if (link==null) return;
	if (link.disabled)
		EnableLink (name)
	else
		DisableLink (name);
}

/**
 *  Update happens here
 */
function UpdateAll() {

	var ErrMsg="";

	//50945
	var isRefunding;
	if ((objRefundChk)&&(objRefundChk.checked)) isRefunding=true;

	if ((objReqdAmt)&&(objReceiptAmt)&&(objDepositsAmtTot)) 
	{
		//Log 63534 - 09.05.2007 - Give message ONLY if all three of following fields have no values
		if (MedtrakCurrToJSMath(objReceiptAmt.value)==0 && MedtrakCurrToJSMath(objDepositsAmtTot.value)==0 && MedtrakCurrToJSMath(ojbRecoupedAmt.value)==0) 
		{
			alert(t['NO_DEPOSIT_AND_PAYMENT']);
			return false;
		}
		
		//50945 - refund will involve negative amounts, need to get the absolute number

		if (Math.abs(MedtrakCurrToJSMath(objReceiptAmt.value))>Math.abs(MedtrakCurrToJSMath(objReqdAmt.value)) ||
		    Math.abs(MedtrakCurrToJSMath(objBillsAmtTot.value))<Math.abs(MedtrakCurrToJSMath(objDepositsAmtTot.value))
		   )
		{
			//44252 - no more restriction for overpayment, instead just display a confirmation
			//ErrMsg+=t['PAYM_GREATER']+CurrencyRound(MedtrakCurrToJSMath(objReceiptAmt.value) - MedtrakCurrToJSMath(objReqdAmt.value)); // log 32832
			
			if (!isRefunding) {

				var bOKToOverpay=1;
				bOKToOverpay=confirm(t['PAYMT_MORE_REQ_BALANCE'] + "\n" + t['CONTINUE']);
			
				if (!bOKToOverpay) return false;
			}
			else {
				if (Math.abs(MedtrakCurrToJSMath(objReceiptAmt.value))>Math.abs(MedtrakCurrToJSMath(objReqdAmt.value))) { //Log 65677 - 29.11.2007
					alert(t['REFUND_MORETHAN_DEPOSIT']);
					return false;
				}	
			}
		}
		else if (Math.abs(MedtrakCurrToJSMath(objReceiptAmt.value))-Math.abs(MedtrakCurrToJSMath(objReqdAmt.value))<0)
		{
			var errMsg=t['CANT_UPDATE_BATCH']+"\n";

			if (!isRefunding) {
				//Log 61190 - 30/10/2006 - Had to uncomment following code as we need this particular restriction - DavidS will test both worlflows thoroughly.
				//57137 - no more restrictions
				var diff=Math.abs(MedtrakCurrToJSMath(objReqdAmt.value))-Math.abs(MedtrakCurrToJSMath(objReceiptAmt.value));
				errMsg+=t['PAYM_LESS'] + CurrencyRound(diff);
				alert(errMsg);
				return false;
			}
			else {
				if (Math.abs(MedtrakCurrToJSMath(objReceiptAmt.value))==0) {
					errMsg+="Refund Amount must be entered";
					alert(errMsg);
					return false;
				}
			}
		}
	}

	if ((objPayorHidden)&&(objPayor)) {
		// log 32614: Set Payor to hidden field when paying payor bills
		// to allow payment to be saved as a payor payment

		objPayorHidden.value = objPayor.value;
	}
			
	if (!CheckPIN()) return false;  //42790,43627,43626
	
	if (objBillsAmtTot && objBillsAmtTot.value!="" && objHiddenBillsAmtTot) objHiddenBillsAmtTot.value=objBillsAmtTot.value;
	if (objDepositsAmtTot && objDepositsAmtTot.value!="" && objHiddenDepositsAmtTot) objHiddenDepositsAmtTot.value=objDepositsAmtTot.value;
	if (objReceiptAmt && objReceiptAmt.value!="" && objHiddenReceiptAmt) objHiddenReceiptAmt.value=objReceiptAmt.value;
	if (objReqdAmt && objReqdAmt.value!="" && objHiddenReqdAmt) objHiddenReqdAmt.value=objReqdAmt.value;
	
	if (!fARPatientBill_FindBatch_submit()) return false;

	update1_click();

	var url="arpatientbill.batchfind.csp?PageType=Batch&GroupType=I&CONTEXT="+session['CONTEXT'];
	websys_createWindow(url,"TRAK_main");
}


/*
 * see definition in custom script, not all sites want this
 */
function CheckPIN() {
	return true;
}

/*
 * see definition in custom script, not all sites want this
 */
function MakeFieldMandatory(fldName) {
}

function InvoiceNumberLookUpSelect(str) {
	try {
		var lu = str.split("^");
		var BillRowIDs="";

		if (lu[1]!="") objSingleBillRowID.value=lu[1];
		else	objSingleBillRowID.value="";
		
		if ((objPayor)&&(objPayor.value=="")) {
			if ((lu[2])&&(lu[2]!="")) objPayor.value=lu[2];
		}

		if (parent.frames["BR.ARPatBillFindBatch"]) { // we're in batch receipting
			//Log 63664 - 22.05.2007 - do not allow Credit Notes to be added
			if (lu[5]=="CREF") {
				alert(winListAll.t['NO_CREDITNOTE_FOR BATCH']);
				if (objInvoiceNumber) objInvoiceNumber.value="";
				websys_setfocus(objInvoiceNumber.id);
				return false;
			}		
			AddBill();
		}
		else if (parent.frames["FRAMEARPatientBillFindBatch"]) // we're in batch letter
			AddBatchBill();

	} catch(e) {
		objSingleBillRowID.value="";
	}
}

function RecNumLookUpSelect(str) {

	try {
		var lu = str.split("^");

		var DepositRowIDs="";
		if (objSingleDepositRowID) {
			if (lu[1]!="") {
				objSingleDepositRowID.value=lu[1];
			} else {
				objSingleDepositRowID.value="";
			}
		}

		if ((objPayor)&&(objPayor.value=="")) {
			if ((lu[4])&&(lu[4]!="")) {
				objPayor.value=lu[4];
			}
		}
		
		AddDeposit();

	} catch(e) {
		if (objSingleDepositRowID) objSingleDepositRowID.value="";
	}
}


function mPiece(s1,sep,n) {

	// SA 33715: Beware this function is overwritten by the mPiece function
	// in websys.Print.Tools.js - the function here previously returned undefined
	// instead of blank, causing endless loops in calls which only check 
	// that the function was returning non-blank.

	//Split the array with the passed delimeter
      delimArray = s1.split(sep);
      
	//If out of range, return a blank string
      if ((n <= delimArray.length-1) && (n >= 0)) {
        return delimArray[n];
	} else {
	  return "";
      }
	
	return "";

}

/**
 *  Used in Batch Letter screen.
 */
function AddBatchBill() {
	if (evtTimer) {
		setTimeout("AddBatchBill()",200);
	} else {
		var BillRowIDs=""; var SingleBillRowID=""; var NextBillRowID="";
		var Payor=""; var Hospital=""; var URN=""; var Surname=""; var AccountClass="";
		var PaymentClass=""; var MinAmount=""; var DaysOverdueFr=""; var DaysOverdueTo="";
		var InvoiceNumber="";
		var frm=""; var CONTEXT="";
		if(parent.frames["FRAMEARPatientBillFind"]) frm=parent.frames["FRAMEARPatientBillFind"].document.forms["fARPatientBill_Find"];
		if (frm) {
			if (frm.Hospital) Hospital=frm.Hospital.value;
			if (frm.URN) URN=frm.URN.value;
			if (frm.Surname) Surname=frm.Surname.value;
			if (frm.AccountClass) AccountClass=frm.AccountClass.value;
			if (frm.PaymentClass) PaymentClass=frm.PaymentClass.value;
			if (frm.MinAmountOwing) MinAmount=frm.MinAmountOwing.value;
			if (frm.NoDaysOverdueFrom) DaysOverdueFr=frm.NoDaysOverdueFrom.value;
			if (frm.NoDaysOverdueTo) DaysOverdueTo=frm.NoDaysOverdueTo.value;
		}
		if ((objSingleBillRowID)&&(objBillRowIDs)) {
			
			//Broker does not call lookup select when field is cleared.
			//Will need to check if field has been cleared before continuing.
			if ((objInvoiceNumber)&&(objInvoiceNumber.value=="")) {
				objSingleBillRowID.value="";
			}

			if (objSingleBillRowID.value=="") {
				alert(t['NO_BILL']);
				return false;
			} else {
				var count=0;
				SingleBillRowID=objSingleBillRowID.value;
				BillRowIDs=objBillRowIDs.value;
				//alert("PRE: BillRowIDs="+BillRowIDs);
				//alert(SingleBillRowID);
				while ((mPiece(BillRowIDs,"|",count))&&(mPiece(BillRowIDs,"|",count)!="")) {
					NextBillRowID=mPiece(BillRowIDs,"|",count);
					if (NextBillRowID==SingleBillRowID) {
						alert(t['ALREADY_IN_BATCH']);
						return false;
					}
					count=count+1;
				}
				
				if (BillRowIDs=="") {
					BillRowIDs=SingleBillRowID;			
				} else {
					BillRowIDs+="|"+SingleBillRowID;
				}
				
				objBillRowIDs.value=BillRowIDs;	
			}
		}
	
		CONTEXT=session['CONTEXT'];
      	if (objPayor) Payor=objPayor.value;
		if (objInvoiceNumber) InvoiceNumber=objInvoiceNumber.value;

		AddBatchInvoice_click();

		var url="arpatientbillbatchletter.csp?BillRowIDs="+BillRowIDs+"&Payor="+websys_escape(Payor)+"&Hospital="+Hospital;
		url+="&AccountClass="+AccountClass+"&PaymentClass="+PaymentClass; //+"&InvoiceNumber="+InvoiceNumber;
		url+="&CONTEXT="+CONTEXT + "&NewlyAddedBill=" + SingleBillRowID;
		url+="&URN="+URN+"&Surname="+Surname+"&MinAmount="+MinAmount+"&DaysOverdueFr="+DaysOverdueFr+"&DaysOverdueTo="+DaysOverdueTo;
		
		websys_createWindow(url,"TRAK_main");
	}
}

function RemoveBatchBill() {
	//alert("Remove");
	if (evtTimer) {
		setTimeout("RemoveBatchBill()",200);
	} else {
		var SingleBillRowID="";
		var NextBillRowID="";	
		var bBillFound=false;
		var BillRowIDs="";
		var CONTEXT="";
		var Payor="";
		var Hospital="";
		var frm="";
		if(parent.frames["FRAMEARPatientBillFind"]) frm=parent.frames["FRAMEARPatientBillFind"].document.forms["fARPatientBill_Find"];
		if (frm) {
			Hospital=frm.Hospital.value;
		}
		if (objSingleBillRowID) {			
			//Broker does not call lookup select when field is cleared.
			//Will need to check if field has been cleared before continuing.
			if ((objInvoiceNumber)&&(objInvoiceNumber.value=="")) {
				objSingleBillRowID.value="";
			}

			SingleBillRowID=objSingleBillRowID.value;
			if (objSingleBillRowID.value=="") {
				alert(t['NO_BILL']);
				return false;
			}	

			if (objBillRowIDs) {
				if (objBillRowIDs.value=="") {
					alert(t['BILL_NOT_IN_BATCH']);
				} else {
					var count=0;
					var BillRowIDs="";
					var NewBillRowIDs=""
					BillRowIDs=objBillRowIDs.value;
					while ((mPiece(BillRowIDs,"|",count))&&(mPiece(BillRowIDs,"|",count)!="")) {
						NextBillRowID=mPiece(BillRowIDs,"|",count);
						if (NextBillRowID!=SingleBillRowID) {
							if (NewBillRowIDs=="") {
								NewBillRowIDs=NextBillRowID;			
							} else {
								NewBillRowIDs+="|"+NextBillRowID;
							}
						} else {
							bBillFound=true;
						}
						count=count+1;
					}
		
					if (!(bBillFound)) {
						alert(t['BILL_NOT_IN_BATCH']);
						return false;
					} else {
						objBillRowIDs.value=NewBillRowIDs;
					}	

					BillRowIDs=NewBillRowIDs;
		
					CONTEXT=session['CONTEXT'];
	
     		 			if (objPayor) {
						if (BillRowIDs=="") {
							// can now clear Payor
							Payor="";
						} else {
							Payor=objPayor.value;
						}
					}

					RemoveBatchInvoice_click();
		
					var url="arpatientbillbatchletter.csp?BillRowIDs="+BillRowIDs+"&Hospital="+Hospital+"&CONTEXT="+CONTEXT;

					//alert(url);
					websys_createWindow(url,"TRAK_main");
				}
			}
		}	
	}
}

// 44252

var Nparam1;
var Nparam2;
var RecoupAtLine=1;

// 44252
function DeleteFromHiddenRowIDs(HiddenRowIDs,RowID) {
	if (RowID=="") return "";

	if (HiddenRowIDs.indexOf(RowID)!= -1) {
		var i=HiddenRowIDs.indexOf(RowID);
		var value="";

		if (i==0) { // at beginning
			value = HiddenRowIDs.substring(i + RowID.length + 1,HiddenRowIDs.length);			
		}
		else if ((i + RowID.length)==HiddenRowIDs.length) {  // at end
			value = HiddenRowIDs.substring(0,i-1);
		}
		else { // other
			value = HiddenRowIDs.substring(0,i);
			value = value + HiddenRowIDs.substring(i + RowID.length + 1,HiddenRowIDs.length);
		}
	}
	return value;
}

// 44252
function RecoupInvoice(e) {
	Nparam1 = objBillRowIDToRecoup.value; // invoice to recoup
	Nparam2 = objAmtToRecoup.value;       // amount to recoup
	
	if (AmtToRecoup_changehandler(e)==false)
		return false;

	if (MedtrakCurrToJSMath(Nparam2) < 0) {
		alert(t['WARN_LESSTHAN_ZERO']);
		objAmtToRecoup.value="";
		websys_setfocus(objAmtToRecoup.id);
		return objAmtToRecoup.value="";
	}
	
	if ((RecoupAtLine<1) || (docListAll==null)) return false;

	var objPAADMADMNo  = docListAll.getElementById("PAADMADMNoz" + RecoupAtLine);
	var objPayorBillNo = docListAll.getElementById("PayorBillNoz" + RecoupAtLine);
	var objPayorBillNo = docListAll.getElementById("PayorBillNoz" + RecoupAtLine);
	var objGivenName   = docListAll.getElementById("PAPERName2z" + RecoupAtLine);
	var objSurname     = docListAll.getElementById("PAPERNamez" + RecoupAtLine);

	var invDetail="";
	if (objGivenName && objSurname) invDetail+= "\n   Patient Name : " + objGivenName.innerText + " " + objSurname.innerText;
	if (objPAADMADMNo) invDetail+=              "\n   Episode Number : " + objPAADMADMNo.innerText;
	if (objPayorBillNo) invDetail+=             "\n   Invoice Number : " + objPayorBillNo.innerText;

	// confirm Recoup
	var bOKToRecoup=1;
	bOKToRecoup = confirm(CurrencyRound(Nparam2) + " " + t['CONFIRM_RECOUP'] + "\n\nInvoice Details" + invDetail);
	if (!bOKToRecoup) {
		objAmtToRecoup.value="";
		return websys_cancel();
	}

	var hndobj=document.getElementById("HiddenAmtToRecoup");
	if (hndobj) hndobj.onclick=hndobj.onchange;
	if (hndobj) hndobj.click();
}

// 44252
function HiddenAmtToRecoup_changehandler(encmeth) {
	
	// calling method web.ARReceipts.RecoupInvoice()
	var ReturnCode=cspRunServerMethod(encmeth,Nparam1,Nparam2);

	if (ReturnCode=="-2") {
		alert(t['CANT_RECOUP_1']);
		websys_setfocus(objAmtToRecoup.id);
		return false;
	}
	else if (ReturnCode=="-1") {
		alert("Error in recouping. Invalid Parameters being passed");
		websys_setfocus(objAmtToRecoup.id);
		return false;
	}
	else {
		objAmtToRecoup.value="";
		objRecNum.value=" "; // must set this to empty string, cannot be null
		objSingleDepositRowID.value = ReturnCode;
		
		if (ReturnCode!="") AddDeposit();
	}
	objAmtToRecoup.disabled=true;
}

// 44252
function CheckRecoup(selRowAt) {

	var objAmtToRecoup = document.getElementById("AmtToRecoup");

	if ((docListAll==null) || (winListAll==null))
		return;

	var tbl = docListAll.getElementById("tARPatientBill_ListAll");
	var f   = docListAll.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var col = "SelectBillz";
	var selRow=0;
	var TransType="";
	var objTransType;

	//alert("CheckRecoup at " + selRowAt );

	objTransType=docListAll.getElementById("TransTypez" + selRowAt);
	if (objTransType) TransType = TransType + objTransType.innerText;

	if (TransType==winListAll.t['INV'] && tbl.rows[selRowAt].className=="clsRowSelected") { // && selRow==1) {
		// for recouping
		var objBillRowIDToRecoup = document.getElementById("BillRowIDToRecoup");

		if (objBillRowIDToRecoup) {

			var objSelBillID  = docListAll.getElementById("BillRowIDz" + selRowAt);
			var objPAADMADMNo = docListAll.getElementById("PAADMADMNoz" + selRowAt);

			objBillRowIDToRecoup.value = objSelBillID.value; // for use by Recoup process, see ARPatientBill.FindBatch

			//alert("Episode No " + objPAADMADMNo.innerText + " " + objBillRowIDToRecoup.value);
		}

		if (objAmtToRecoup) {
			RecoupAtLine=selRowAt;
			objAmtToRecoup.disabled=false;
			objAmtToRecoup.className = "";
		}
	}
	else {
		if (objAmtToRecoup) {
			objAmtToRecoup.disabled=true;
			objAmtToRecoup.className = "disabledField";
		}
	}
}

/**
 * 44252
 * Function to handle row selection in batch receipting area
 * this gets called from SelectRowHandler from ARPatientBill.ListAll
 */
function HandleRowSelectionForBatchReceipting(SelRowNumber) {

	//alert("HandleRowSelectionForBatchReceipting");
	
	if ((SelRowNumber<1) || (docListAll==null) || (winListAll==null)) return;

	var tbl = docListAll.getElementById("tARPatientBill_ListAll");
	var f = docListAll.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var col="SelectBillz";
	var selRow=0;
	var TransType="";

	var objTransType=docListAll.getElementById("TransTypez"+SelRowNumber);
	if (objTransType) TransType = objTransType.innerText;

	//alert("TransType  " + TransType);
	//Log 63664 - 22.05.2007 - included Refund Invoices [REF] as well
	if ((TransType==winListAll.t['INV'] || (TransType==winListAll.t['REF'])) && f.elements[col+SelRowNumber] && !f.elements[col+SelRowNumber].disabled) {
		var objBillRowIDs= document.getElementById("BillRowIDs");
		var objSelBillID = docListAll.getElementById("BillRowIDz" + SelRowNumber);

		if (f.elements[col+SelRowNumber].checked) {
			for (var i=1;i<tbl.rows.length;i++) {
				objTransType=docListAll.getElementById("TransTypez"+i);
				if (objTransType) TransType = objTransType.innerText;	
				//Log 63664 - 22.05.2007 - included Refund Invoices [REF] as well
				if ((TransType==winListAll.t['INV'] || TransType==winListAll.t['REF']) && f.elements[col+i] && f.elements[col+i].checked && !f.elements[col+i].disabled) {
					selRow++;
				}
			}
			if (selRow==1)
				objBillRowIDs.value=objSelBillID.value;
			else
				objBillRowIDs.value += "|" + objSelBillID.value;

			var tmp = DeleteFromHiddenRowIDs(objUnselBillRowIDs.value,objSelBillID.value);
			if (tmp!=null) objUnselBillRowIDs.value=tmp;

			//alert("Bill selected " + objBillRowIDs.value);

			objBillRowIDs.onclick=objBillRowIDs.onchange;
			objBillRowIDs.click();
		}
		else {

			//alert("Bill De-selected " + objSelBillID.value);

			objBillRowIDs.value = DeleteFromHiddenRowIDs(objBillRowIDs.value,objSelBillID.value);

			if (objUnselBillRowIDs.value=="")
				objUnselBillRowIDs.value=objSelBillID.value;
			else
				objUnselBillRowIDs.value += "|" + objSelBillID.value;

			objBillRowIDs.onclick=objBillRowIDs.onchange;
			objBillRowIDs.click();
		}
	}
	else if (TransType==winListAll.t['DEP'] && f.elements[col+SelRowNumber] && !f.elements[col+SelRowNumber].disabled) {

		var objDepositRowIDs = document.getElementById("DepositRowIDs");
		var objSelDepositID = docListAll.getElementById("RecAllocIDz" + SelRowNumber);

		if (f.elements[col+SelRowNumber].checked) {
			for (var i=1;i<tbl.rows.length;i++) {
				objTransType=docListAll.getElementById("TransTypez"+i);
				if (objTransType) TransType = objTransType.innerText
				if (TransType==winListAll.t['DEP'] && f.elements[col+i] && f.elements[col+i].checked && !f.elements[col+i].disabled) {
					selRow++;
				}
			}
			if (selRow==1)
				objDepositRowIDs.value=objSelDepositID.value;
			else
				objDepositRowIDs.value += "^" + objSelDepositID.value;
			
			//alert("Deposit selected " + objDepositRowIDs.value);

			objDepositRowIDs.onclick=objDepositRowIDs.onchange;
			objDepositRowIDs.click();
		}
		else {
			objDepositRowIDs.value = DeleteFromHiddenRowIDs(objDepositRowIDs.value,objSelDepositID.value);

			if (objUnselDepositRowIDs.value=="")
				objUnselDepositRowIDs.value=objSelDepositID.value;
			else
				objUnselDepositRowIDs.value += "^" + objSelDepositID.value;

			//alert("Deposit De-selected " + objSelDepositID.value + " ** objDepositRowIDs.value " + objDepositRowIDs.value);

			objDepositRowIDs.onclick=objDepositRowIDs.onchange;
			objDepositRowIDs.click();
		}
	}
	SetRequiredAmount();
}

// 44252
function BillRowIDs_changehandler(encmeth) {
	
	// calling method web.ARPatientBill.GetBatchTotal()
	var ReturnVal= cspRunServerMethod(encmeth,objBillRowIDs.value);

	var arr = ReturnVal.split("^");
	if (arr[0] && objBillsAmtTot) objBillsAmtTot.value = arr[0];
	if (arr[1] && objBillsSelNo)   objBillsSelNo.value = arr[1];
}

// 44252
function DepositRowIDs_changehandler(encmeth) {

	// calling method web.ARPatientBill.GetBatchDepositTotal()
	var ReturnVal= cspRunServerMethod(encmeth,objDepositRowIDs.value);
	
	if (objDepositsAmtTot) objDepositsAmtTot.value = ReturnVal;
}

//md 56660 

function websys_setfocus(objName) {
	setTimeout('websys_setfocus2(\''+objName+'\')',250);
}
//md 56660

document.body.onload=FindBatchBodyLoadHandler;

