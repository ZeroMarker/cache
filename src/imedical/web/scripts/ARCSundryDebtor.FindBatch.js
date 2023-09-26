// Copyright (c) 2004 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var objBillRowIDs         = document.getElementById("BillRowIDs");
var objSingleBillRowID    = document.getElementById("SingleBillRowID");
var objSingleDepositRowID = document.getElementById("SingleDepositRowID");
var objDepositRowIDs      = document.getElementById("DepositRowIDs");

var objAddBatchInv    = document.getElementById("AddBatchInv");
var objRemoveBatchInv = document.getElementById("RemoveBatchInv");
var objInvoiceNo      = document.getElementById("InvNumber");
var objRecNum         = document.getElementById("RecNum");
var objCareProv       = document.getElementById("CareProvDesc");
var objAddInv         = document.getElementById("AddInv");
var objRemoveInv      = document.getElementById("RemoveInv");
var objRemoveDep      = document.getElementById("RemoveDeposit");
var objAddDep         = document.getElementById("AddDeposit");
var objUpdateAll      = document.getElementById("update1");
var objReceiptAmt     = document.getElementById("ReceiptAmt");
var objReqdAmt        = document.getElementById("ReqdAmt");
var objBillsSelNo     = document.getElementById("BillsSelNo");
var objBillsAmtTot    = document.getElementById("BillsAmtTot");
var objDepositsAmtTot = document.getElementById("DepositsAmtTot");


/**
 *
 */
function FindBatchBodyLoadHandler() {	

	if (objAddInv) objAddInv.onclick=AddBill;
	if (tsc['AddInv']) websys_sckeys[tsc['AddInv']]=AddBill;
	if (objRemoveInv) objRemoveInv.onclick=RemoveBill;
	if (tsc['RemoveInv']) websys_sckeys[tsc['RemoveInv']]=RemoveBill;

	if (objAddBatchInv) objAddBatchInv.onclick=AddBatchBill;
	if (tsc['AddBatchInv']) websys_sckeys[tsc['AddBatchInv']]=AddBatchBill;

	if (objRemoveBatchInv) objRemoveBatchInv.onclick=RemoveBatchBill;
	if (tsc['RemoveBatchInv']) websys_sckeys[tsc['RemoveBatchInv']]=RemoveBatchBill;

	if (objAddDep) objAddDep.onclick=AddDeposit;
	if (tsc['AddDeposit']) websys_sckeys[tsc['AddDeposit']]=AddDeposit;
	if (objRemoveDep) objRemoveDep.onclick=RemoveDeposit;	
	if (tsc['RemoveDeposit']) websys_sckeys[tsc['RemoveDeposit']]=RemoveDeposit;

	if (objUpdateAll) objUpdateAll.onclick=UpdateAll;	
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateAll;


/*	if ((objCareProv)&&(objCareProv.value!="")) {	
		if (objCareProv) {
			alert("objCareProv disabled");
			objCareProv.disabled = true;
		}
		if (objCareProvLookUpIcon) objCareProvLookUpIcon.style.visibility = "hidden";
		if (objInvoiceNo) {
			websys_setfocus("InvoiceNo");
		} else if (objRecNum) {
			websys_setfocus("RecNum");
		}
	}
*/
	CountBillsSelected();
	SetRequiredAmount();
	ResetPaymentAmount();
}

/**
 *
 */
function UpdateAll() {

	//alert("UpdateAll");

	var ErrMsg="";
	var bOK = true;

	if ((objReqdAmt)&&(objReceiptAmt)) {

		if (MedtrakCurrToJSMath(objReqdAmt.value) > MedtrakCurrToJSMath(objReceiptAmt.value)) 
			bOK = false;

		if (MedtrakCurrToJSMath(objReqdAmt.value) < MedtrakCurrToJSMath(objReceiptAmt.value)) 
			bOK = false;

		if (!bOK) {
			ErrMsg=t['CANT_UPDATE_BATCH']+"\n";

			if ((MedtrakCurrToJSMath(objReceiptAmt.value) - MedtrakCurrToJSMath(objReqdAmt.value)) > 0) {
				ErrMsg+=t['PAYM_GREATER']+CurrencyRound(MedtrakCurrToJSMath(objReceiptAmt.value) - MedtrakCurrToJSMath(objReqdAmt.value));
			} else {
				ErrMsg+=t['PAYM_LESS']+CurrencyRound(MedtrakCurrToJSMath(objReqdAmt.value) - MedtrakCurrToJSMath(objReceiptAmt.value));
			}
		}
	}

	if (ErrMsg!="") {
		alert(ErrMsg);
		return false;
	}
	
	update1_click();

	var BillRowIDs="";
	var ReceiptAmt="";
	var DepositRowIDs="";

	if (objBillRowIDs) BillRowIDs = objBillRowIDs.value	
	if (objReceiptAmt) ReceiptAmt = objReceiptAmt.value;
	if (objDepositRowIDs) DepositRowIDs = objDepositRowIDs.value;

	var url="arcsundry.batchreceipt.csp?PageType=Batch&BillRowIDs="+BillRowIDs+"&DepositRowIDs="+DepositRowIDs;
	url = url + "&DontClearPayDet=1&ReceiptAmt="+ReceiptAmt+"&CONTEXT="+session['CONTEXT'];

	websys_createWindow(url,"TRAK_main");
}

/**
 *
 */
function AddBill() {

	if (evtTimer) {
		setTimeout("AddBill()",200);
	} else {
		var BillRowIDs="";
		var ReceiptAmt="";
		var CONTEXT="";
		var NextBillRowID="";
		var SingleBillRowID="";
		var CareProvDesc=""
		var DepositRowIDs="";

		if (objSingleBillRowID == null || objBillRowIDs == null)
			return false;
			
		//Broker does not call lookup select when field is cleared.
		//Will need to check if field has been cleared before continuing.

		if ((objInvoiceNo)&&(objInvoiceNo.value=="")) {
			objSingleBillRowID.value="";
		}

		if (objSingleBillRowID.value=="") {
			alert(t['NO_BILL']);
			return false;
		} else {
			var count=0;
			SingleBillRowID = objSingleBillRowID.value;
			BillRowIDs = objBillRowIDs.value;
			//alert("PRE: BillRowIDs="+BillRowIDs);
			//alert("SingleBillRowID " + SingleBillRowID);

			while (mPiece(BillRowIDs,"|",count) && mPiece(BillRowIDs,"|",count)!="") {
				NextBillRowID = mPiece(BillRowIDs,"|",count);
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

		if (objReceiptAmt)    ReceiptAmt    = objReceiptAmt.value;
	      if (objDepositRowIDs) DepositRowIDs = objDepositRowIDs.value;
		if (objCareProv)      CareProvDesc  = objCareProv.value;

		AddInv_click();

		var url="arcsundry.batchreceipt.csp?PageType=Batch&BillRowIDs="+BillRowIDs+"&DepositRowIDs="+DepositRowIDs;
		url += "&CareProvDesc="+CareProvDesc+"&DontClearPayDet=1&ReceiptAmt="+ReceiptAmt+"&CONTEXT="+session['CONTEXT'];
	
		//alert(url);

		websys_createWindow(url,"TRAK_main");
	}
}

/**
 *
 */
function RemoveBill() {

	if (evtTimer) {
		setTimeout("RemoveBill()",200);
	} else {
		var SingleBillRowID="";
		var NextBillRowID="";	
		var bBillFound=false;
		var BillRowIDs="";
		var DepositRowIDs="";
		var ReceiptAmt="";
		var CONTEXT="";

		//Broker does not call lookup select when field is cleared.
		//Will need to check if field has been cleared before continuing.

		if (objSingleBillRowID) {
			if ((objInvoiceNo) && (objInvoiceNo.value=="")) {
				objSingleBillRowID.value="";
			}

			SingleBillRowID = objSingleBillRowID.value;

			if (SingleBillRowID =="") {
				alert(t['NO_BILL']);
				return false;
			}
		}
		else return false;

		if (objBillRowIDs && objBillRowIDs.value=="") {
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
		
			if (objReceiptAmt) ReceiptAmt = objReceiptAmt.value;
			if (objDepositRowIDs) DepositRowIDs = objDepositRowIDs.value;

			RemoveInv_click();
		
			var url  = "arcsundry.batchreceipt.csp?PageType=Batch&BillRowIDs="+BillRowIDs+"&DepositRowIDs="+DepositRowIDs;
			    url += "&DontClearPayDet=1&ReceiptAmt="+ReceiptAmt+"&CONTEXT="+session['CONTEXT'];

			//alert(url);

			websys_createWindow(url,"TRAK_main");
		}	
	}
}

/**
 *
 */
function AddDeposit() {

	//alert("adding");
	if (evtTimer) {
		setTimeout("AddDeposit()",200);
	} else {

		var DepositRowIDs="";
		var ReceiptAmt="";
		var CONTEXT="";
		var NextDepositRowID="";	
		var SingleDepositRowID="";
		var BillRowIDs="";

		if (objSingleDepositRowID == null || objDepositRowIDs == null)
			return false;
		
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
			SingleDepositRowID = objSingleDepositRowID.value;
			DepositRowIDs      = objDepositRowIDs.value;

			//alert("PRE: DepositRowIDs= " + DepositRowIDs);
			//alert("SingleDepositRowID= " + SingleDepositRowID);			
			while (mPiece(DepositRowIDs,"^",count) && mPiece(DepositRowIDs,"^",count)!="") {
				NextDepositRowID = mPiece(DepositRowIDs,"^",count);
				//alert("SingleDepositRowID="+SingleDepositRowID);
				//alert("NextDepositRowID="+NextDepositRowID);
				if (NextDepositRowID==SingleDepositRowID) {
					alert(t['DEP_ALREADY_IN_BATCH']);
					return false;
				}
				count=count+1;
			}
				
			if (DepositRowIDs == "")
				DepositRowIDs = SingleDepositRowID;
			else
				DepositRowIDs += "^" + SingleDepositRowID;
			
			//Component object must be set, even though we are losing the component,
			//in order for List query to pick up this variable.

			objDepositRowIDs.value = DepositRowIDs;	
		}

		if (objReceiptAmt) ReceiptAmt = objReceiptAmt.value;
		if (objBillRowIDs) BillRowIDs = objBillRowIDs.value;
	
		AddDeposit_click();

		var url="arcsundry.batchreceipt.csp?PageType=Batch&BillRowIDs="+BillRowIDs+"&DepositRowIDs="+DepositRowIDs;
		url = url + "&DontClearPayDet=1&ReceiptAmt="+ReceiptAmt+"&CONTEXT="+session['CONTEXT'];
	
		//alert(url);

		websys_createWindow(url,"TRAK_main");
	}
}

function RemoveDeposit() {

	if (evtTimer) {
		setTimeout("RemoveDeposit()",200);
	} else {
		var SingleDepositRowID="";
		var NextDepositRowID="";	
		var bDepositFound=false;
		var DepositRowIDs="";
		var BillRowIDs="";
		var ReceiptAmt="";
		var CONTEXT="";
		var objAction=document.getElementById("Action")

		if (objSingleDepositRowID == null || objDepositRowIDs == null)
			return false;

		//Broker does not call lookup select when field is cleared.
		//Will need to check if field has been cleared before continuing.
		if ((objRecNum)&&(objRecNum.value=="")) {
			objSingleDepositRowID.value="";
		}		

		SingleDepositRowID=objSingleDepositRowID.value;
		if (objSingleDepositRowID.value=="") {
			alert(t['NO_DEPOSIT']);
			return false;
		}			

		if (objDepositRowIDs.value=="") {
			alert(t['DEPOSIT_NOT_IN_BATCH']);
		} else {
			var count=0;
			var DepositRowIDs="";
			var NewDepositRowIDs=""
			DepositRowIDs=objDepositRowIDs.value;
			while ((mPiece(DepositRowIDs,"^",count))&&(mPiece(DepositRowIDs,"^",count)!="")) {
				NextDepositRowID=mPiece(DepositRowIDs,"^",count);
				if (NextDepositRowID!=SingleDepositRowID) {
					if (NewDepositRowIDs=="") {
						NewDepositRowIDs=NextDepositRowID;			
					} else {
						NewDepositRowIDs+="^"+NextDepositRowID;
					}
				} else {
					bDepositFound=true;
				}
				count=count+1;
			}
		
			if (! bDepositFound) {
				alert(t['DEPOSIT_NOT_IN_BATCH']);
				return false;
			} else {
				objDepositRowIDs.value=NewDepositRowIDs;
			}		

			DepositRowIDs = NewDepositRowIDs;
		
			if (objReceiptAmt) ReceiptAmt = objReceiptAmt.value;
     			if (objBillRowIDs) BillRowIDs = objBillRowIDs.value;		

			RemoveDeposit_click();

			var url="arcsundry.batchreceipt.csp?PageType=Batch&BillRowIDs="+BillRowIDs+"&DepositRowIDs="+DepositRowIDs;
			url = url + "&DontClearPayDet=1&ReceiptAmt="+ReceiptAmt+"&CONTEXT="+session['CONTEXT'];

			//alert(url);

			websys_createWindow(url,"TRAK_main");
		}
	}
}

function AddBatchBill() {

	if (evtTimer) {
		// Need a timeout to the brokers.
		// This function had been being executed before the broker was called, 
		// which meant the hidden fields required had not yet been populated.
		// His suggestion was to add a timeout to this function
		setTimeout("AddBatchBill()",200);
	} else {
		var BillRowIDs=""; var SingleBillRowID=""; var NextBillRowID="";
		var Hospital=""; var CareProvDesc="";
		var HiddenParams=""; var InvoiceNumber="";
		var frm="";
		
		if (parent.frames["FRAMEARCSundryFindBills"])
			frm = parent.frames["FRAMEARCSundryFindBills"].document.forms["fARCSundryDebtor_FindBills"];

		if (frm) {

			var SundryCode    = frm.SundryCode.value;
			var SundryDesc    = frm.SundryDesc.value;
			var MinAmount     = frm.MinAmountOwing.value;
			var DaysOverdueFr = frm.NoDaysOverdueFrom.value;
			var DaysOverdueTo = frm.NoDaysOverdueTo.value;

			Hospital      = frm.Hospital.value;
			CareProvDesc  = frm.CareProvDesc.value;
	
			if (SundryCode !="" || SundryDesc !="" || MinAmount!="" || DaysOverdueFr!="" || DaysOverdueTo !="")
				HiddenParams=SundryCode + "^" + SundryDesc + "^" + MinAmount + "^" + DaysOverdueFr + "^" + DaysOverdueTo;
		}

		if (objSingleBillRowID == null || objBillRowIDs == null) return false;
			
		if (objInvoiceNo && objInvoiceNo.value=="") {
			objSingleBillRowID.value="";
		}

		if (objSingleBillRowID.value=="") {
			alert(t['NO_BILL']);
			return false;
		} else {
			var count=0;
			SingleBillRowID=objSingleBillRowID.value;
			BillRowIDs=objBillRowIDs.value;
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

		if (objInvoiceNo) InvNo = objInvoiceNo.value;

		AddBatchInv_click();

		var url  = "arcsundry.batchletter.csp?BillRowIDs="+BillRowIDs+"&Hospital="+Hospital+"&CareProvDesc="+CareProvDesc;
		    url += "&InvoiceNumber="+InvNo+"&HiddenParams="+HiddenParams+"&CONTEXT="+session['CONTEXT'];

		//alert(url);
		websys_createWindow(url,"TRAK_main");
	}
}

function RemoveBatchBill() {

	if (evtTimer) {
		setTimeout("RemoveBatchBill()",200);
	} else {
		var SingleBillRowID="";	var NextBillRowID="";
		var bBillFound=false;	var BillRowIDs="";
		var CONTEXT="";
		var Hospital="";
		var frm="";
		var CareProvDesc="";
		var HiddenParams="";

		if (parent.frames["FRAMEARCSundryFindBills"])
			frm = parent.frames["FRAMEARCSundryFindBills"].document.forms["fARCSundryDebtor_FindBills"];

		if (frm) {

			var SundryCode    = frm.SundryCode.value;
			var SundryDesc    = frm.SundryDesc.value;
			var MinAmount     = frm.MinAmountOwing.value;
			var DaysOverdueFr = frm.NoDaysOverdueFrom.value;
			var DaysOverdueTo = frm.NoDaysOverdueTo.value;

			Hospital      = frm.Hospital.value;
			CareProvDesc  = frm.CareProvDesc.value;
	
			if (SundryCode !="" || SundryDesc !="" || MinAmount!="" || DaysOverdueFr!="" || DaysOverdueTo !="")
				HiddenParams=SundryCode + "^" + SundryDesc + "^" + MinAmount + "^" + DaysOverdueFr + "^" + DaysOverdueTo;
		}

		if (objSingleBillRowID == null || objBillRowIDs == null) return false;
		
		if (objInvoiceNo && objInvoiceNo.value=="")  objSingleBillRowID.value="";

		if (objSingleBillRowID.value=="") {
			alert(t['NO_BILL']);
			return false;
		}

		if (objBillRowIDs.value=="") {
			alert(t['BILL_NOT_IN_BATCH']);
		} else {
			var count=0;
			var BillRowIDs="";
			var NewBillRowIDs=""

			SingleBillRowID = objSingleBillRowID.value;
			BillRowIDs      = objBillRowIDs.value;

			while (mPiece(BillRowIDs,"|",count) && mPiece(BillRowIDs,"|",count)!="") {
				NextBillRowID = mPiece(BillRowIDs,"|",count);
				if (NextBillRowID != SingleBillRowID) {
					if (NewBillRowIDs=="") {
						NewBillRowIDs = NextBillRowID;
					} else {
						NewBillRowIDs += "|" + NextBillRowID;
					}
				} else {
					bBillFound=true;
				}
				count = count+1;
			}
		
			if (! bBillFound) {
				alert(t['BILL_NOT_IN_BATCH']);
				return false;
			} else {
				objBillRowIDs.value = NewBillRowIDs;
			}	

			BillRowIDs = NewBillRowIDs;
	
			RemoveBatchInv_click();
		
			var url  = "arcsundry.batchletter.csp?BillRowIDs="+BillRowIDs+"&Hospital="+Hospital+"&CareProvDesc="+CareProvDesc;
			    url += "&HiddenParams="+HiddenParams+"&CONTEXT="+session['CONTEXT'];

			//alert(url);

			websys_createWindow(url,"TRAK_main");
		}
	}
}

function SetRequiredAmount() {
	//alert("SetRequiredAmount called");
	if ((objBillsAmtTot)&&(objDepositsAmtTot)&&(objReqdAmt)) {
		var BillsAmtTot=MedtrakCurrToJSMath(objBillsAmtTot.value);
		var DepositsAmtTot=MedtrakCurrToJSMath(objDepositsAmtTot.value);
		objReqdAmt.value=CurrencyRound(BillsAmtTot-DepositsAmtTot);
	}
}

/**
 * Function to display field value correctly as currency when page is refreshed.
 *
 */
function ResetPaymentAmount() {
	//alert("SetRequiredAmount called");
	if (objReceiptAmt) {
		var ReceiptAmt=MedtrakCurrToJSMath(objReceiptAmt.value);
		objReceiptAmt.value=CurrencyRound(ReceiptAmt);
	}
}


function CountBillsSelected() {

	if (objBillsSelNo) {
		if ((objBillRowIDs)&&(objBillRowIDs.value!="")) {
			var count=0;
			var BillRowIDs="";
			BillRowIDs=objBillRowIDs.value;
			while ((mPiece(BillRowIDs,"|",count))&&(mPiece(BillRowIDs,"|",count)!="")) {
				//alert("count="+count);
				count=count+1;
				//if (count=="10") return false;
			}
			objBillsSelNo.value=count;
		} else {
			objBillsSelNo.value="0";	
		}
	} 
}

function RecNumLookUpSelect(str) {

	//alert(str);
	try {
		var lu = str.split("^");
		//alert("lu[1]="+lu[1]);
		var DepositRowIDs="";
		if (objSingleDepositRowID) {
			if (lu[1]!="")
				objSingleDepositRowID.value=lu[1];
			else
				objSingleDepositRowID.value="";

			//alert("objSingleDepositRowID.value="+objSingleDepositRowID.value);
		}
	} catch(e) {
		if (objSingleDepositRowID) objSingleDepositRowID.value="";
	}
}

function InvoiceNumberLookUpSelect(str) {

	try {
		var lu = str.split("^");

		if (objSingleBillRowID) {
			if (lu[1]!="")
				objSingleBillRowID.value=lu[1];
			else
				objSingleBillRowID.value="";
			
			//alert("objSingleDepositRowID.value="+objSingleDepositRowID.value);
		}
		
	} catch(e) {
		if (objSingleBillRowID) objSingleBillRowID.value="";
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

document.body.onload=FindBatchBodyLoadHandler;
