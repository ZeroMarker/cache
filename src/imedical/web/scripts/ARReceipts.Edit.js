// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

/**********************************
SA: The following functions appear in the generated scripts for this component:
(as well as all other components which contain fields with data type %Library.Currency)
CurrencyRound
SubtractCurrencyValues
AddCurrencyValues
MedtrakCurrToJSMath
**********************************/

var PayMode;
var finalAmt=0;
var TotalBillAmt;
var cashierMode;
var PayDetOnClick;
var objRefundComments=document.getElementById("ARRCPRefundComments");
var objStoreNegAsDep=document.getElementById("StoreNegAsDep");
var objDiscAmount=document.getElementById("ARRCPDiscAmt");
var objNewOutstand=document.getElementById("NewOutstandAmt");
var objRemainPayAmt=document.getElementById("RemainPayAmt");
//alert(objRemainPayAmt.value);
var objPayAmt=document.getElementById("PAYMAmt");
var objPayMethod=document.getElementById("PAYMPayModeDesc");
var objPAYMethodCode=document.getElementById("PAYMPayModeCode");
var objCMCBankDesc=document.getElementById("CMCBankDesc");
var objPAYMCardChequeNo=document.getElementById("PAYMCardChequeNo");
var objPAYMChequeDate=document.getElementById("PAYMChequeDate");
var objAuthCode=document.getElementById("PAYMAuthorCode");
var objDiscretReason=document.getElementById("DiscretReason");
var objExpectedPayDate=document.getElementById("ExpectedPayDate");
var objDiscRate=document.getElementById("ARRCPDiscRate");
var objDiscType=document.getElementById("ARCDIDesc");
var objBillType=document.getElementById("BillType");
var objPayDetLink=document.getElementById("PayDet");
var objTotalBillAmt=document.getElementById("TotalBillAmt");

var objBranch=document.getElementById("PAYMBranch");
var objDrawer=document.getElementById("PAYMDrawer");
var objDepositIDs=document.getElementById("DepositIDs");
var objPAYMCardDesc=document.getElementById("PAYMCardDesc");
var objPAYMCardExpiryDate=document.getElementById("PAYMCardExpiryDate");
var objCardTypeLookUpIcon=document.getElementById('ld277iPAYMCardDesc');
var objBankLookUpIcon=document.getElementById('ld277iCMCBankDesc');
var objPayMethodLookUpIcon=document.getElementById('ld277iPAYMPayModeDesc');
var objDiscretReasonLookUpIcon=document.getElementById('ld277iDiscretReason');
var objDiscTypeLookUpIcon=document.getElementById('ld277iARCDIDesc');
var objDepositAmountTotal=document.getElementById("DepositAmountTotal")
var objCTValDate=document.getElementById("CTValDate");
var objPaymentDate=document.getElementById("PaymentDate");

var objUsingPaymAlloc=document.getElementById("UsingPaymAlloc");
var objPaymAlloc=document.getElementById("PaymAlloc");
var objGroupType=document.getElementById("GroupType");
var objPaymAllocOK=document.getElementById("PaymAllocOK");

var objDecSepPlaces=document.getElementById("DecSepPlaces");
var DecimalPlaces="2";	//default system value
var DecimalSymbol=".";	//default system value
var GroupingSymbol=",";	//default system value

var objPatientID=document.getElementById("PatientID");
var objBillRowIDs=document.getElementById("BillRowIDs");

var objDefaultDepositAmt=document.getElementById("DefaultDepositAmt");

//jpd 48110
var objCurrencyAmt=document.getElementById("PAYMCurrencyAmt");
var objHiddenCurrAmt=document.getElementById("HiddenPAYMCurrencyAmt");
var objCurrency=document.getElementById("PAYMCurrencyDR");

var objHiddenPayAmt= document.getElementById("HiddenPAYAmt"); //53442
var objHidNewOutsAmt= document.getElementById("HidNewOutstandAmt"); //44715

var objPMChangeGiven=document.getElementById("CTPMChangeGiven"); //46828
var objTenderAmt=document.getElementById("TenderAmt"); //46828
var objPAYMChangeAmt=document.getElementById("PAYMChangeAmt"); //46828
var objSPTenderPay=document.getElementById("SPTenderPay"); //46828
var bOKToTenderOverpay=false;

//Log 59979 - 04/10/2006
var objRoundAmt=document.getElementById("RndAmt");
var objRoundAuto=document.getElementById("AutoRound");
var objRoundOnPay=document.getElementById("RndOnPayment");
var objAutoAdjustOK=document.getElementById("AutoAdjustOK");
//End Log 59979

//Log 59963 - 13.12.2007
var objEditMode=document.getElementById("EditMode");
var objPaymId=document.getElementById("PAYMRowId");
var objRemarks=document.getElementById("ARRCPRemarks");
var objModify=document.getElementById("UpdModify");
var objShift=document.getElementById("CashShift"); 
var objDepType=document.getElementById("DepType"); 
//End Log 59963 
/**
 */
function BodyLoadHandler() {
	var obj;
	var BillType;


	if (objRefundComments) DisableField("ARRCPRefundComments"); //32830 BC

	// 43123 AJIW - initialise the PayMode
	if (objPAYMethodCode) PayMode = objPAYMethodCode.value;
	if (PayMode=="") PayMode="CH";

	if (objDecSepPlaces) {
 		var aryDec = objDecSepPlaces.value.split("^");
		if ((aryDec[0])&&(aryDec[0].value!="")) DecimalPlaces=new Number(aryDec[0]);
		if ((aryDec[1])&&(aryDec[1].value!="")) DecimalSymbol=aryDec[1];
	}

	GroupingSymbol = (DecimalSymbol=="," ? "." : ",");

	if (objRemainPayAmt) finalAmt    = objRemainPayAmt.value;
	if (objTotalBillAmt) TotalBillAmt= objTotalBillAmt.value;

	if (objBillType) {
		if (objBillType.value=="D") {
			cashierMode="Deposit";
		} else if (MedtrakCurrToJSMath(String(finalAmt)) < 0) {
			cashierMode="Refund";
		} else {
			cashierMode="Payment";
		}
	}
	//alert(cashierMode + "   " + objHidNewOutsAmt.value);

 	if (cashierMode=="Refund") {
 		
		if (objRefundComments) EnableNonMandatoryField("ARRCPRefundComments"); //Log 32830 BC
		
		if (objStoreNegAsDep) {
			objStoreNegAsDep.disabled=false;
			objStoreNegAsDep.checked=true;
			objStoreNegAsDep.onclick=StoreNegAsDepChangeHandler;
			StoreNegAsDepChangeHandler();
		}
	} 
	else {
		if (objStoreNegAsDep) DisableField("StoreNegAsDep");

		// SA 16.10.02 - log 29487: If payment is being made, and deposit is being allocated
		// to the bill, the payment amount and method will not be mandatory - to allow
		// only the deposit to be assigned against the bill. Otherwise the amount and 
		// payment method will remain mandatory.
		if ((objDepositIDs)&&(objDepositIDs.value!="")) {
			if (objPayAmt) EnableNonMandatoryField("PAYMAmt");
			if (objPayMethod) EnableNonMandatoryField("PAYMPayModeDesc");
			if (objPayMethodLookUpIcon) objPayMethodLookUpIcon.style.visibility = "visible"
		} 
		else {
			if (objPayAmt) EnableField('PAYMAmt');
			if (objPayMethod) EnableField('PAYMPayModeDesc');
			if (objPayMethodLookUpIcon) objPayMethodLookUpIcon.style.visibility = "visible"
		}

		DisableBankFields();
	}
		
	// SA 27.5.03 - log 34038 (RSIB): UDF will be called from hidden field "DefaultDepositAmt"
	// to default the episode specific deposit amount. Will need to copy hidden field to PayAmt
	// if a value exists in the hidden field.

	if ((objPayAmt)&&(objDefaultDepositAmt)&&(objDefaultDepositAmt.value!="")) {
		objPayAmt.value=objDefaultDepositAmt.value;
	}

	if (objPayDetLink) PayDetOnClick=objPayDetLink.onclick;
	if (objPayDetLink) objPayDetLink.onclick=LinkEnable;

	if (objNewOutstand) objNewOutstand.onchange = NewOutstandingChangeHandler;
	if (objDiscAmount) objDiscAmount.onchange = DiscountChangeHandler;
	if (objDiscRate) objDiscRate.onchange = DiscountRateChangeHandler;
	if (objPayAmt) objPayAmt.onchange = AmtPayChangeHandler;
	if (objPayAmt) objPayAmt.onclick=objPayAmt.onchange;
	if (objPayAmt) objPayAmt.click();
	if (objTenderAmt) objTenderAmt.onchange = TernderAgainsPAyNow;
	if (objTenderAmt) objTenderAmt.onclick=objTenderAmt.onchange;
	
	if (objCurrencyAmt) {
		objCurrencyAmt.onchange = CurrencyAmtChangeHandler;
		objCurrencyAmt.value = "";
	}

	obj = document.getElementById('Refresh');
	if (obj) obj.onclick = RefreshHandler;

	// 39072. Hidden field CTValDate required to pass internal date to 
	// payor/plan lookups. CTValDate will be set to the cache equivalent of PaymentDate
	if (objPaymentDate) {
		objPaymentDate.onchange = PaymentDateChangeHandler;

		if ((objCTValDate)&&(objPaymentDate.value!="")) {
			objCTValDate.value=DateStringTo$H(objPaymentDate.value);
		}
	}

	//32817: Partial payment allocation link

	if (objPaymAlloc) {
		objPaymAlloc.onclick = PartPaymAllocHandler;
		var objDepositAmountTotal=document.getElementById("DepositAmountTotal");
		if (!objDepositAmountTotal) {
			objPaymAlloc.disabled=true;
		}
		else {
			if ((MedtrakCurrToJSMath(objDepositAmountTotal.value)==0) || (objNewOutstand && objNewOutstand.value==0))
				objPaymAlloc.disabled=true;
		}
	}

	//alert("Cashier Mode:"+ cashierMode+"  BillType:"+BillType);

	var objUpdate=document.getElementById("update1");
	if (objUpdate) {

		objUpdate.onclick=UpdateClickHandler;
		if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateClickHandler;
	} else {
		var objUpdate=document.getElementById("update2");
		if (objUpdate) {
			objUpdate.onclick=UpdateClickHandler;
			if (tsc['update2']) websys_sckeys[tsc['update2']]=UpdateClickHandler;
		}
	}
	//
	CheckTenderSP();
	
	//Log 59963
	var objModify=document.getElementById("UpdModify");
	if (objModify) {

		objModify.onclick=ModifyClickHandler;
		if (tsc['UpdModify']) websys_sckeys[tsc['UpdModify']]=ModifyClickHandler;
	}	
	if ((objEditMode)&&(objEditMode.value=="1")) {
		DisableAllFields();
		EnableNonMandatoryField("PAYMPayModeDesc");
		EnableNonMandatoryField("PAYMChequeDate");
		EnableNonMandatoryField("PAYMCardChequeNo");
		EnableNonMandatoryField("CMCBankDesc");
		EnableNonMandatoryField("PAYMBranch");
		EnableNonMandatoryField("PAYMDrawer");
		EnableNonMandatoryField("PAYMCardDesc");
		EnableNonMandatoryField("PAYMCardExpiryDate");
		EnableNonMandatoryField("PAYMAuthorCode");
		EnableNonMandatoryField("ARRCPRemarks");
		EnableNonMandatoryField("DepType");
		EnableNonMandatoryField("DiscretReason");
		EnableNonMandatoryField("ExpectedPayDate");
		
		if ((objPaymId)&&(objPaymId.value!="")) {
			var PaymId=objPaymId.value;
			var BillRowID="";
			if (objBillRowIDs) BillRowID=objBillRowIDs.value;
			var PaymDetails=tkMakeServerCall("web.ARRcptPayMode","GetPaymentDetails",PaymId,BillRowID);
			if (PaymDetails!="") {
				PaymDetails=PaymDetails.split("^");
				if (objPayAmt) objPayAmt.value=PaymDetails[0];
				if (objPaymentDate) objPaymentDate.value=PaymDetails[1];
				if (objPayMethod) objPayMethod.value=PaymDetails[2];
				if (objPAYMCardChequeNo) objPAYMCardChequeNo.value=PaymDetails[3];
				if (objPAYMChequeDate) objPAYMChequeDate.value=PaymDetails[4];
				if (objCMCBankDesc) objCMCBankDesc.value=PaymDetails[5];
				if (objBranch) objBranch.value=PaymDetails[6];
				if (objDrawer) objDrawer.value=PaymDetails[7];
				if (objPAYMCardDesc) objPAYMCardDesc.value=PaymDetails[8];
				if (objPAYMCardExpiryDate) objPAYMCardExpiryDate.value=PaymDetails[9];
				if (objAuthCode) objAuthCode.value=PaymDetails[10];
				if (objRemarks) objRemarks.value=PaymDetails[11];
				if (objPAYMethodCode) objPAYMethodCode.value=PaymDetails[12];
				if (objPAYMethodCode) PayMode = objPAYMethodCode.value;
				if (PayMode=="") PayMode="CH";
				if (objShift) objShift.value=PaymDetails[13];
				if (objDiscretReason) objDiscretReason.value=PaymDetails[14];
				if (objExpectedPayDate) objExpectedPayDate.value=PaymDetails[15];
				if (objDepType) objDepType.value=PaymDetails[16];
			}	
		}	
		DisableBankFields();
	}
	//End Log 59963
}

//Log 59963
function DisableAllFields() {
	for (var i=0;i<document.fARReceipts_Edit.elements.length;i++) {
		var fld = document.getElementById(document.fARReceipts_Edit.elements[i].name);
		
		if ((fld)&&(fld.type!="hidden")) {
			if (document.fARReceipts_Edit.elements[i].name!="") {
				DisableField(document.fARReceipts_Edit.elements[i].name,"1");
			}
		}	
	}
}

//Log 59963
function ModifyClickHandler(evt){
	if ((objShift)&&(objShift.value!="")) {
		alert(t['SHIFT_CLOSED']);
		return false;
	}
	UpdModify_click();
}

function NewOutstandingChangeHandler() {
	
	//alert("NewOutstandingChangeHandler");

	NewOutstandAmt_changehandler();

	if (MedtrakCurrToJSMath(objNewOutstand.value) - MedtrakCurrToJSMath(String(finalAmt)) > 0) {
		alert(t['NEW_OUT_MORE_FINAL_BALANCE']);

		objNewOutstand.value=CurrencyRound("0");
		if (objDiscretReason) objDiscretReason.value = "";
		if (objDiscretReason) DisableField('DiscretReason');
		if (objDiscretReasonLookUpIcon) objDiscretReasonLookUpIcon.style.visibility = "hidden"
		if (objExpectedPayDate) DisableField('ExpectedPayDate');
		if (objPaymAlloc) objPaymAlloc.disabled=true;	//SA: 32817
	} else {
		SetPaymentBalance();
	}
}

function SetPaymentBalance() {
	
	//payAmt = finalAmt - discount - newOutstandingAmt
	
	if (cashierMode!="Refund") {

		var disc=parseFloat(0);
		if (objDiscAmount) disc=MedtrakCurrToJSMath(objDiscAmount.value);

		var outstand=MedtrakCurrToJSMath(objHidNewOutsAmt.value);

		var temp = MedtrakCurrToJSMath(String(finalAmt)) - disc - outstand;
		
		if (temp < 0) {
			var val = CurrencyRound(MedtrakCurrToJSMath(String(finalAmt)) - disc);
			if (objNewOutstand) objNewOutstand.value = val;
			objHidNewOutsAmt.value = val;
		}
		if (outstand==0) {
			if (objDiscretReason) DisableField('DiscretReason');
			if (objDiscretReasonLookUpIcon) objDiscretReasonLookUpIcon.style.visibility = "hidden"
			if (objExpectedPayDate) DisableField('ExpectedPayDate');
			if (objPaymAlloc) objPaymAlloc.disabled=true;	//SA: 32817
		} else {
			if (objDiscretReason) EnableField('DiscretReason');
			if (objDiscretReasonLookUpIcon) objDiscretReasonLookUpIcon.style.visibility = "visible"
			if (objExpectedPayDate) EnableField('ExpectedPayDate');
			if (objPaymAlloc) objPaymAlloc.disabled=false;	//SA: 32817
		} 

		if ((objPayAmt)&&(!objPayAmt.disabled)) objPayAmt.value = CurrencyRound(temp);

		// SA 32817: Reset payment allocation flag if amount is adjusted after payment allocation is made.
		if ((objPaymAllocOK)&&(objPaymAllocOK.value=="Y")) objPaymAllocOK.value="";
	}
}

function DiscountChangeHandler() {

	ARRCPDiscAmt_changehandler();

	if (MedtrakCurrToJSMath(objDiscAmount.value) < 0) {
		alert(t['DISC_LESS_ZERO']);
		return;
	} else {
		if (cashierMode!="Refund") {
   			if (MedtrakCurrToJSMath(objDiscAmount.value) - MedtrakCurrToJSMath(String(finalAmt)) > 0) {		
				alert(t['DISC_MORE_BALANCE']);
				return;
			} else {
				if (objPayAmt) {
					var temp = MedtrakCurrToJSMath(String(finalAmt)) - MedtrakCurrToJSMath(objPayAmt.value) - MedtrakCurrToJSMath(objDiscAmount.value);
					if (temp < 0) temp = 0;

					if (objNewOutstand) objNewOutstand.value = CurrencyRound(temp);
					objHidNewOutsAmt.value = CurrencyRound(temp); //in case, balance outs. does not exist
				}
			}
		}
	}
	if (MedtrakCurrToJSMath(objDiscAmount.value)==0) {
		if ((objDiscRate)&&(MedtrakCurrToJSMath(objDiscRate.value)==0)) {
			DisableField('ARCDIDesc');
		} else {
			EnableField('ARCDIDesc');
		}
	} else {
		EnableField('ARCDIDesc');
	}
	SetPaymentBalance();
}

function DiscountRateChangeHandler() {

	if (objDiscRate) {
		if (isNaN(objDiscRate.value)) {
			return;
		}
		var disc = MedtrakCurrToJSMath(objDiscRate.value) / 100 * MedtrakCurrToJSMath(String(TotalBillAmt));
		disc = CurrencyRound(disc);
		if (objDiscAmount)  {
			objDiscAmount.value = disc;
			DiscountChangeHandler();
		}
	}
}

//48110
function LookUpCurrencySelect(str) {

	if ((objPayAmt) && (objPayAmt.value!="") &&(objCurrency)) {
		var obj=document.getElementById("CurrencyCalcDirect");
		if (obj) { obj.onclick=obj.onchange; obj.click(); }
	}
	else {
		if (objCurrencyAmt) objCurrencyAmt.value = "";
		objHiddenCurrAmt.value = "";
	}
}

function CurrencyAmtChangeHandler() {

	if (objCurrencyAmt&&objCurrencyAmt.value!="") {
		if (PAYMCurrencyAmt_changehandler()==false) return false;
	}

	if (objCurrencyAmt) objHiddenCurrAmt.value = objCurrencyAmt.value;

	var depoFlag = document.getElementById("DepositFlag");
	if (depoFlag.value=="Y")
	{
	//md  LOG 58878 should  not be on system level
	if ((objRemainPayAmt) && (MedtrakCurrToJSMath(objRemainPayAmt.value)>=0)) {
		if (!validateNumericAndPositive(objCurrencyAmt)) return false;
	}
	}
	
	//48110
	if ((objCurrencyAmt)&&(objCurrencyAmt.value!="")) {
		var obj=document.getElementById("CurrencyCalcIndirect");
		if (obj) { obj.onclick=obj.onchange; obj.click(); }
	}
	else {
		if (objPayAmt) {
			EnableField("PAYMAmt");	//Log 64151 - 03.07.2007 - enable this here. otherwise onclick event doesnt get fired.
			objPayAmt.value = "";
			objPayAmt.click();
		}
	}
}

function CurrencyCalcIndirect_changehandler(encmeth) {

	if (objPayAmt && objCurrency && objCurrencyAmt) {
		//calling web.ARReceipts.CalculateInirectCurrency()
		var val = cspRunServerMethod(encmeth,objCurrency.value,objCurrencyAmt.value);
		EnableField("PAYMAmt");	//Log 64151 - 03.07.2007 - enable this here. otherwise onclick event doesnt get fired.
		objPayAmt.value = val;
		objPayAmt.click();
	}
}

function CurrencyCalcDirect_changehandler(encmeth) {

	if (objPayAmt && objCurrency) {
		//calling web.ARReceipts.CalculateDirectCurrency()
		var val = cspRunServerMethod(encmeth,objCurrency.value,objPayAmt.value);
		if (objCurrencyAmt) objCurrencyAmt.value = val;
		objHiddenCurrAmt.value = val;
	}
}

function AmtPayChangeHandler() {
	
	if (objPayAmt&&objPayAmt.value!="") {
		if (PAYMAmt_changehandler()==false) return false; //57031: added if
	}

	//53442: PAYAmt is possibly disabled, so need a hidden field.
	if (objPayAmt) objHiddenPayAmt.value=objPayAmt.value;

	 
	var depoFlag = document.getElementById("DepositFlag");
	if (depoFlag.value=="Y")
	{
	//md  LOG 58878 should  not be on system level
	//check for invalid negative amounts entered for payment.	//50149
	if ((objRemainPayAmt) && (MedtrakCurrToJSMath(objRemainPayAmt.value)>=0)) {
		if (!validateNumericAndPositive(objPayAmt)) return false;
	}
	}
	
	//48110
	if ((objPayAmt)&&(objPayAmt.value!="")) {
		var obj=document.getElementById("CurrencyCalcDirect");
		if (obj) { obj.onclick=obj.onchange; obj.click(); }
	}
	else {
		if (objCurrencyAmt) objCurrencyAmt.value = "";
		objHiddenCurrAmt.value = "";
	}

	if (cashierMode=="Refund")
		EnableField("ARRCPRefundComments");
	else
		DisableField("ARRCPRefundComments");

	if (objPayAmt) {
		if ((cashierMode=="Refund")&&(MedtrakCurrToJSMath(objPayAmt.value) > 0)) {
			alert(t['ADD_PAYM_REFUND']);
			return;
		}
			
		var OutsAmt = MedtrakCurrToJSMath(String(finalAmt)) - MedtrakCurrToJSMath(objPayAmt.value); 
		if (objDiscAmount) OutsAmt = OutsAmt - MedtrakCurrToJSMath(objDiscAmount.value);
		
		if (OutsAmt < 0) {
			if (cashierMode!="Refund") {
				
				if (objNewOutstand) objNewOutstand.value=CurrencyRound("0");
				objHidNewOutsAmt.value=CurrencyRound("0");

				if (objDiscretReason) DisableField('DiscretReason');
				if (objDiscretReasonLookUpIcon) objDiscretReasonLookUpIcon.style.visibility = "hidden"
				if (objExpectedPayDate) DisableField('ExpectedPayDate');
				if (objPaymAlloc) objPaymAlloc.disabled=true;	//SA: 32817

				//45960 
				if (objStoreNegAsDep) {
					objStoreNegAsDep.disabled=false;
					objStoreNegAsDep.checked=true;
				}
			}
		} else {
			if ((cashierMode=="Refund")&&(OutsAmt > 0)) {
				alert(t['PAYMT_MORE_REQ_BALANCE']);
			} else {
				
				if (cashierMode!="Refund") {

					if (objNewOutstand) objNewOutstand.value = CurrencyRound(OutsAmt);
					objHidNewOutsAmt.value = CurrencyRound(OutsAmt);  //53442

					if (OutsAmt==0) {
						if (objDiscretReason) DisableField('DiscretReason');
						if (objDiscretReasonLookUpIcon) objDiscretReasonLookUpIcon.style.visibility = "hidden"
						if (objExpectedPayDate) DisableField('ExpectedPayDate');
						if (objPaymAlloc) objPaymAlloc.disabled=true;	//SA: 32817
					} else {
						if (objDiscretReason) EnableField('DiscretReason');
						if (objDiscretReasonLookUpIcon) objDiscretReasonLookUpIcon.style.visibility = "visible"
						if (objExpectedPayDate) EnableField('ExpectedPayDate');
						if (objPaymAlloc) objPaymAlloc.disabled=false;	//SA: 32817
					}
				}
				if (objStoreNegAsDep) DisableField("StoreNegAsDep");
			}
		}
		
		// SA 32817: Reset payment allocation flag if amount is adjusted after payment allocation is made.
		if ((objPaymAllocOK)&&(objPaymAllocOK.value=="Y")) objPaymAllocOK.value="";
	}
}

 function EnableField(fldName) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if (fld) {
		fld.disabled = false;
		fld.className = "";
		if (lbl) lbl = lbl.className = "clsRequired";
	}
}

function EnableNonMandatoryField(fldName) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if (fld) {
		fld.disabled = false;
		fld.className = "";
		if (lbl) lbl = lbl.className = "";
	}
}

/**
 * log 45407: AJIW 28/07
 * Need to override this method from the generated JS, 
 * this is because users can set a field as "Required" from layout editor
 * and that's causing a side effect even a field has been disabled and set to be
 * not mandatory programmatically. See the detailed side effect on the log desc.
 */
function RequiredMsg(itemname,islist) {
	return "";
}

function DisableField(fldName,flag) {

	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if ((fld)&&(fld.tagName=="INPUT")) {
		if (flag!="1") fld.value = "";	//Log 59963 - we send the flag as one only when we want the value to be there
		fld.disabled = true;
		fld.className = "disabledField";
		if (lbl) lbl = lbl.className = "";
	}
}


function DisableBankFields() {
	//**************************************************************************************
	// SA 25.2.03 - log 33156: This function has been overwritten for STAN in their custom js.
	//**************************************************************************************
	// SA 13.11.02 - log 30271: Functionality for enabling/disabling fields now as follows:
	// "CH" = Cash, "CQ" = Cheque, "CC"= Credit Card, "DP" = Direct Payment (same as "CH")
	// Pay Amount and Payment Method ALWAYS mandatory
	// Card/Cheque Number, Authority Code disabled for CH, mandatory for CQ,CC
	// Cheque Date mandatory for CQ, disabled for CH,CC
	// Bank Card Exp. Date mandatory for CC, disabled for CH,CQ
	// Bank, Branch, Drawer mandatory for CQ, disabled for CH,CC
	// Bank Card Type mandatory for CC, disabled for CH,CQ
	//**************************************************************************************
	if ((PayMode=="CH")||(PayMode=="DP")) {

		if (objCMCBankDesc) DisableField('CMCBankDesc');
		if (objBranch) DisableField('PAYMBranch');
		if (objDrawer) DisableField('PAYMDrawer');
		if (objPAYMCardChequeNo) DisableField('PAYMCardChequeNo');
		if (objAuthCode) DisableField('PAYMAuthorCode');
		if (objPAYMChequeDate) DisableField('PAYMChequeDate');
		if (objPAYMCardDesc) DisableField('PAYMCardDesc');
		if (objPAYMCardExpiryDate) DisableField('PAYMCardExpiryDate');		
		if (objCardTypeLookUpIcon) objCardTypeLookUpIcon.style.visibility = "hidden";
		if (objBankLookUpIcon) objBankLookUpIcon.style.visibility = "hidden";

	} else {

		if (objPAYMCardChequeNo) EnableField('PAYMCardChequeNo');
		if (objAuthCode) EnableField('PAYMAuthorCode');

		if (PayMode=="CQ") {
			if (objCMCBankDesc) EnableField('CMCBankDesc');
			if (objBranch) EnableField('PAYMBranch');
			if (objDrawer) EnableField('PAYMDrawer');
			if (objPAYMCardDesc) DisableField('PAYMCardDesc');
			if (objCardTypeLookUpIcon) objCardTypeLookUpIcon.style.visibility = "hidden";
			if (objBankLookUpIcon) objBankLookUpIcon.style.visibility = "visible";
			if (objPAYMChequeDate) EnableField('PAYMChequeDate');
			if (objPAYMCardExpiryDate) DisableField('PAYMCardExpiryDate');
		} else if (PayMode=="CC") {
			if (objCMCBankDesc) DisableField('CMCBankDesc');
			if (objBranch) DisableField('PAYMBranch');
			if (objDrawer) DisableField('PAYMDrawer');
			if (objPAYMCardDesc) EnableField('PAYMCardDesc');
			if (objCardTypeLookUpIcon) objCardTypeLookUpIcon.style.visibility = "visible";
			if (objBankLookUpIcon) objBankLookUpIcon.style.visibility = "hidden";
			if (objPAYMChequeDate) DisableField('PAYMChequeDate');
			if (objPAYMCardExpiryDate) EnableField('PAYMCardExpiryDate');
		}
	}
}

function CheckForAllMendatoryFields() {
	var AllGetValue="";
	for (var i=0;i<document.fARReceipts_Edit.elements.length;i++) {
		if (document.fARReceipts_Edit.elements[i].id!="") {
			var elemid="c"+document.fARReceipts_Edit.elements[i].id;
			var elemc=document.getElementById(elemid);
			var elem=document.getElementById(document.fARReceipts_Edit.elements[i].id);
			if ((elemc) && (elemc.className=="clsRequired")) {
				if ((elem)&&(elem.value=="")) AllGetValue=AllGetValue+ "'" + elemc.innerText + "' "+t['XMISSING']+"\n";
			}
		}
	}
	return AllGetValue;
}

var validPIN=true;

function ValidatePIN_changehandler(encmeth) {
	//58584
	var objPIN=document.getElementById("PIN");
	var objUser=document.getElementById("UserCode");
	var objValidatePin=document.getElementById("ValidatePIN");
	
	if (objPIN && objUser) {
		validPIN=true;
		if (cspRunServerMethod(encmeth,objUser.value,objPIN.value)!=1) validPIN=false;
	}
}

function UpdateClickHandler(evt) {
    if (evtTimer) {
		setTimeout("UpdateClickHandler()",400);   //43123: timer needed.
	} else {
	
		if (cashierMode=="Refund") {
			if (objNewOutstand) objNewOutstand.value="";
			objHidNewOutsAmt.value="";
		}
		//md here comes code for tender/change given
		ReTender();
		//md 
		CheckAutoAdjust();			//Log 59979
		var depoFlag = document.getElementById("DepositFlag");
		if ((depoFlag.value=="Y")&&(objPayAmt)&&(!validateNumericAndPositive(objPayAmt))) return false; //49818
		var warnMsg = CheckForAllMendatoryFields();
		if (warnMsg!="") {
			alert(warnMsg);
			return false;
		}
		//58484: trigger PIN validation, don't wanna do it after AutoPaymAllocRequired()
		var obj=document.getElementById("ValidatePIN");
		if (obj) { obj.onclick=obj.onchange; obj.click(); }
		//33029
		if (window.opener && window.opener.parent.frames[1]) {
			var win=window.opener.parent.frames[1];
			if (win) {
				var formPatTot=win.document.forms['fARPatientBill_ListTotals'];
				if (formPatTot) formPatTot.elements["RefreshCSP"].value="1";
			}
		}
		//36748
		if (window.opener && window.opener.parent.frames[0]) {
			var win=window.opener.parent.frames[0];
			if (win) {
				var formSundTot=win.document.forms['fARCSundryDebtor_ListTotal'];
				if (formSundTot) formSundTot.elements["RefreshCSP"].value="1";
			}
		}
		if (ValidateUpdate() && DeceasedPatientCheck() && DrawerPatientCheck()) {
			//50080
			var objPIN=document.getElementById("PIN");
			if (AutoPaymAllocRequired()) {

				if (validPIN) {
					PartPaymAllocHandler(); // open up a new window (partial payment allocation)
					return true;
				}

				alert(t['PIN'] + " " + t['XINVALID'] + "\n");
				websys_setfocus(objPIN.name);
				objPIN.className="clsInvalid";

				return false;
			}
			//50080
			if (!validPIN) {
				alert(t['PIN'] + " " + t['XINVALID'] + "\n");
				websys_setfocus(objPIN.name);
				objPIN.className="clsInvalid";

				return false;
			}
			if (objPaymAllocOK) objPaymAllocOK.value = "Y";
			if ((objStoreNegAsDep)&&(objStoreNegAsDep.checked==true)) {
				var obj=document.getElementById("hiddenStoreNegAsDep");
				if (obj) obj.value="on";
			}
			//57914: if user clicks the update button, check the source id
			/*var srcel = websys_getSrcElement(evt);
			
			if (srcel.id=="update1") 
				update1_click();
			else if (srcel.id=="update2") 
				update2_click();*/
						
			//but if user do Alt+U instead of click,
			//srcel.id != button name, the source would be 
			//a text field where the cursor is at that time
			
			//if ((srcel.id!="update1")&&(srcel.id!="update2")) {
				var objUpdate1=document.getElementById("update1");
				var objUpdate2=document.getElementById("update2");
				if (objUpdate1) 
					update1_click();
				if (objUpdate2) 
					update2_click();
			//}
		}
	}
}

function DrawerPatientCheck(){
	//dummy function.
	//function in custom scripts - QH - Log 32820 
	return true;
}

function DeceasedPatientCheck(){
	//dummy function
	//function in custom scripts - QH - Log 32820 
	return true;
}

function AutoPaymAllocRequired() {
	//dummy function
	//function in custom scripts - QH - Log 32817
	return false;
}

function ValidateUpdate() {
		
	var arrElements = document.getElementsByTagName("input");
	if (arrElements) {   // 43123: added validity check here.
		var msg="";
		var fld="";	var fldfocus=""
		for (var i=0; i < arrElements.length; i++) {
			fld = arrElements[i];
			if (fld.className == "clsInvalid" && fld.name!="PIN") {
				if (fldfocus=="") fldfocus=fld;
				// Log 59360 - GC - 24-05-2006: Replaced hardedcoded message with translatable constant
				msg = msg + t[fld.name] + ": " + fld.value + " " + t['NOTVALID'] + "\n";
			}
		}
		if (msg!="") {
			alert(msg);
			websys_setfocus(fldfocus.name);
			return false;
		}
	}

	if (objPayAmt) {

		var lblPayAmt=document.getElementById("cPAYMAmt");
		if ((lblPayAmt)&&(lblPayAmt.className=="clsRequired")&&(objPayAmt.value=="")) {
			alert(t['PAYM_AMT_REQD']);
			return false;
		}
	
		if ((cashierMode=="Refund")&&(MedtrakCurrToJSMath(objPayAmt.value) > 0)) {
			alert(t['ADD_PAYM_REFUND']);
			//objPayAmt.value="";	
			return false;
		}
	}

	var lblPayMethod=document.getElementById("cPAYMPayModeDesc");
	if ((objPayMethod)&&(objPayMethod.value=="")&&(lblPayMethod)&&(lblPayMethod.className=="clsRequired")) {
		alert(t['PAYM_METH_REQD']);
		return false;
	}
	
	if ((objNewOutstand)&&(objDiscretReason)) {
		if ((MedtrakCurrToJSMath(objNewOutstand.value) > 0)&&(objDiscretReason.value=="")) {
			alert(t['OUT_BALANCE_REQ_REASON']);
			objDiscretReason.focus();
			return false;
		}
	}	
	
	
	if ((objDiscAmount)&&(objDiscType)) {
		if ((MedtrakCurrToJSMath(objDiscAmount.value) > 0)&&(objDiscType.value=="")) {
			alert(t['DISC_REQ_DISC_TYPE']);
			objDiscType.focus();
			return false;
		}
	}

	var errMsg="";
	var lblPAYMCardChequeNo=document.getElementById("cPAYMCardChequeNo");
	var lblPAYMAuthorCode=document.getElementById("cPAYMAuthorCode");
	var lblCMCBankDesc=document.getElementById("cCMCBankDesc");
	var lblPAYMChequeDate=document.getElementById("cPAYMChequeDate");
	var lblPAYMBranch=document.getElementById("cPAYMBranch");
	var lblPAYMDrawer=document.getElementById("cPAYMDrawer");
	var lblPAYMCardDesc=document.getElementById("cPAYMCardDesc");
	var lblPAYMCardExpiryDate=document.getElementById("cPAYMCardExpiryDate");

	if ((objPAYMCardChequeNo)&&(objPAYMCardChequeNo.value=="")&&(lblPAYMCardChequeNo)&&(lblPAYMCardChequeNo.className=="clsRequired")) {
		errMsg += t['CARD_CHEQUE_NUMBER_REQUIRED']+"\n";
		objPAYMCardChequeNo.focus();
	}
	
	if ((objAuthCode)&&(objAuthCode.value=="")&&(lblPAYMAuthorCode)&&(lblPAYMAuthorCode.className=="clsRequired")) {
		errMsg += t['AUTHORISATION_CODE_REQUIRED']+"\n";
		objAuthCode.focus();
	}

	if ((objCMCBankDesc)&&(objCMCBankDesc.value=="")&&(lblCMCBankDesc)&&(lblCMCBankDesc.className=="clsRequired")) {
		errMsg += t['BANK_DETAILS_REQUIRED']+"\n";
		objCMCBankDesc.focus();
	}
	
	if ((objPAYMChequeDate)&&(objPAYMChequeDate.value=="")&&(lblPAYMChequeDate)&&(lblPAYMChequeDate.className=="clsRequired")) {
		errMsg += t['DATE_REQUIRED']+"\n";
		objPAYMChequeDate.focus();
	}

	if ((objBranch)&&(objBranch.value=="")&&(lblPAYMBranch)&&(lblPAYMBranch.className=="clsRequired")) {
		errMsg += t['BRANCH_REQUIRED']+"\n";
		objBranch.focus();
	}

	if ((objDrawer)&&(objDrawer.value=="")&&(lblPAYMDrawer)&&(lblPAYMDrawer.className=="clsRequired")) {
		errMsg += t['DRAWER_REQUIRED']+"\n";
		objDrawer.focus();
	}
		
	if ((objPAYMCardDesc)&&(objPAYMCardDesc.value=="")&&(lblPAYMCardDesc)&&(lblPAYMCardDesc.className=="clsRequired")) {
		errMsg += t['CARDTYPE_REQUIRED']+"\n";
		objPAYMCardDesc.focus();
	}

	if ((objPAYMCardExpiryDate)&&(objPAYMCardExpiryDate.value=="")&&(lblPAYMCardExpiryDate)&&(lblPAYMCardExpiryDate.className=="clsRequired")) {
		errMsg += t['CARDDATE_REQUIRED']+"\n";
		objPAYMCardExpiryDate.focus();
	}

	if (errMsg != "") {
		alert(errMsg);
		return false;
	}

	//Check for overpayment
	var payamt=0;
	var disc=0;
	var topay=0;

	if (objDiscAmount) disc=MedtrakCurrToJSMath(objDiscAmount.value);
	if (objRemainPayAmt) topay=MedtrakCurrToJSMath(objRemainPayAmt.value);
	if (objPayAmt) payamt=MedtrakCurrToJSMath(objPayAmt.value);

	var temp=topay - payamt - disc;
	if (bOKToTenderOverpay==1) { temp=0; }
	if ((temp < 0)&&((cashierMode!="Deposit")&&(cashierMode!="Refund"))) {		
		var bOKToOverpay=1;
		bOKToOverpay=confirm(t['PAYMT_MORE_REQ_BALANCE']+"\n"+t['CONTINUE']);
		if (!bOKToOverpay) {
			return false;
		}
	}

	return true;
}

function PaymentLookUpSelect(str) {
	//alert(str)
	var lu = str.split("^");
	PayMode=lu[1];

	if (objPAYMethodCode) objPAYMethodCode.value=PayMode;  // 43123 AJIW
	
	if (objPMChangeGiven) objPMChangeGiven.value=lu[3]; //46828

	DisableBankFields();

	websys_nexttab(objPayMethod.tabIndex,objPayMethod.form); //57820
}

function RefreshHandler() {
	location.reload();
	window.event.cancelBubble;
	return false;
}

function StoreNegAsDepChangeHandler() {
	if (objStoreNegAsDep.checked) {
		if (objDiscAmount) DisableField("ARRCPDiscAmt");
		if (objNewOutstand) DisableField("NewOutstandAmt");
		if (objPayAmt) DisableField("PAYMAmt");
		if (objPayMethod) DisableField("PAYMPayModeDesc");
		if (objPayMethodLookUpIcon) objPayMethodLookUpIcon.style.visibility = "hidden"
		if (objCMCBankDesc) DisableField("CMCBankDesc");
		if (objPAYMCardChequeNo) DisableField("PAYMCardChequeNo");
		if (objPAYMChequeDate) DisableField("PAYMChequeDate");
		if (objAuthCode) DisableField("PAYMAuthorCode");
		if (objDiscretReason) DisableField("DiscretReason");
		if (objExpectedPayDate) DisableField("ExpectedPayDate");
		if (objDiscRate) DisableField("ARRCPDiscRate");
		if (objDiscType) DisableField("ARCDIDesc");
		if (objDiscTypeLookUpIcon) objDiscTypeLookUpIcon.style.visibility = "hidden";
		if (objPayDetLink) objPayDetLink.disabled=true;
		if (objBranch) DisableField("PAYMBranch");
		if (objDrawer) DisableField("PAYMDrawer");
	} else {
		if (objDiscAmount) EnableNonMandatoryField("ARRCPDiscAmt");

		if ((objUsingPaymAlloc)&&(objUsingPaymAlloc.value=="Y")) {
			// SA 7.4.03 - log 32817: If payment allocations exists for all bills and deposit
			// is being used, no additional payment can be made		
			if ((objPayAmt)&&(objRemainPayAmt)) {
				objPayAmt.value=objRemainPayAmt.value;
				objPayAmt.className="";
				objPayAmt.disabled=true;
			}
		} else {
			if (objPayAmt) EnableField("PAYMAmt");
		}

		if (objPayMethod) EnableField("PAYMPayModeDesc");
		if (objPayMethodLookUpIcon) objPayMethodLookUpIcon.style.visibility = "visible"
		//if (objCMCBankDesc) EnableField("CMCBankDesc");
		//if (objPAYMCardChequeNo) EnableField("PAYMCardChequeNo");
		//if (objPAYMChequeDate) EnableField("PAYMChequeDate");
		//if (objAuthCode) EnableField("PAYMAuthorCode");
		if (objDiscretReason) DisableField("DiscretReason");
		if (objNewOutstand) DisableField("NewOutstandAmt");
		if (objExpectedPayDate) DisableField("ExpectedPayDate");
		if (objDiscRate) EnableNonMandatoryField("ARRCPDiscRate");
		if (objDiscType) EnableNonMandatoryField("ARCDIDesc");
		if (objDiscTypeLookUpIcon) objDiscTypeLookUpIcon.style.visibility = "visible"

		//SA 24.10.01: Multi-Payment Details now disabled for ALL refunds.
		//ARReceipts.EditMultiPay which is called from the Paydetails link
		//has the code to cope with negative amounts, but the code behind the 
		//call to ARInsert^CPaymentUpdate does not account for the case where
		//the refund shall be made by multiple methods. This will need to be 
		//written if the PayDet is enabled for this case.
		//if (objPayDetLink) objPayDetLink.disabled=false;

		DisableBankFields();
	}
}

function LinkEnable(evt) {

	var el = websys_getSrcElement(evt);
	
	if (!el.disabled) {
		//websys_lu(el.href,false,"width=750,height=380,top=58,left=20");
		if (typeof PayDetOnClick!="function") PayDetOnClick = new Function(PayDetOnClick); //call the function i.e. the original handler
		if (PayDetOnClick()==false) return false;
		ProcessPayDetailHandler();  //Aji - log 37539
	} else if ((cashierMode=="Refund")&&(!objStoreNegAsDep.checked)) {
		//alert(t['NO_PAY_DET_REFUNDS']);
	}
	return false;
}

//Aji 9/9/03 - log 37539
function ProcessPayDetailHandler() {
	var PatientID;
	var usingPaymAlloc="";
	var paymDate="";

	var payAlloc = document.getElementById("UsingPaymAlloc")
	if (payAlloc) UsingPaymAlloc = payAlloc.value;

	var payDate = document.getElementById("PaymentDate")
	if (payDate) paymDate = payDate.value;
	
	var patid = document.getElementById("PatientID");
	if (patid) PatientID = patid.value;

	var CONTEXT=session['CONTEXT'];

	var url = "websys.default.csp?WEBSYS.TCOMPONENT=ARReceipts.EditMultiPay&CONTEXT=" + CONTEXT + "&UsingPaymAlloc=" + usingPaymAlloc;
	url += "&PaymentDate=" + paymDate + "&PatientBanner=1&PatientID="+PatientID;
        //Log 59598 - BC - 30-06-2006 : remove statusbar variable (status=) to display the status bar.
	websys_createWindow(url,'child3','width=770,height=400,top=58,left=20,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes');
}


function PartPaymAllocHandler(evt) {
	var BillRowID=""; var GroupType="I"; var PayAmt=""; var PatientID=""; var NextPatientID="";
	if ((objPaymAlloc)&&(objPaymAlloc.disabled)) return false;
	if ((objGroupType)&&(objGroupType.value!="")) GroupType=objGroupType.value;
	if (objPayAmt) {
		if ((objDepositAmountTotal)&&(objDepositAmountTotal.value!="")) {
			PayAmt=MedtrakCurrToJSMath(AddCurrencyValues(objPayAmt.value,objDepositAmountTotal.value));
		} else {
			PayAmt=MedtrakCurrToJSMath(objPayAmt.value);
		}
	}
	if (objBillRowIDs) BillRowID=objBillRowIDs.value;

	// There may be more than one bill, from same or different patients.
	// Banner will not appear if bills from more than one patient are being paid.	
	if (objPatientID) {
 		var aryPatientIDs = objPatientID.value.split("|");

		if (aryPatientIDs[0]) {
			PatientID=aryPatientIDs[0];
			for (var i=1; i<aryPatientIDs.length; i++) {
				if (PatientID!="") {
					if (aryPatientIDs[i]!=PatientID) {
						PatientID="";
					}
				}
			}
		}
	}

	var url="websys.default.csp?WEBSYS.TCOMPONENT=ARReceipts.ListPayAlloc&BillRowID="+BillRowID;
	url += "&PatientBanner=1&GroupType="+GroupType+"&PayAmt="+PayAmt+"&PatientID="+PatientID;

	//alert(url);
        //Log 59598 - BC - 30-06-2006 : remove statusbar variable (status=) to display the status bar.
	websys_createWindow(url,'child3','width=750,height=500,top=50,left=50,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes');
}

function PaymentDateChangeHandler(e) {
	// Note this function may be overwritten by Payment Date Handler in custom js (eg. QH)

	PaymentDate_changehandler(e);
	
	var PayDate,val=""
	if (objPaymentDate) PayDate=objPaymentDate.value
	if (PayDate!="") val=DateStringCompareToday(PayDate,dtseparator,dtformat)
	
	if (val==1) {
		objPaymentDate.className='clsInvalid';
		alert(t['FUTURE_PAY_DATE']);
		// BC 10.12.2003 - log 33273 clear the invalid date so one can't save it
		objPaymentDate.value="";
		return true;
	}
	SetCTValDate();
}

function SetCTValDate() {

	// SA 11.9.03 - log 39072. Hidden field CTValDate required to pass internal date to 
	// payor/plan lookups. CTValDate will be set to the cache equivalent of PaymentDate
	if ((objCTValDate)&&(objPaymentDate)) {
		if ((objPaymentDate.value!="")&&(objPaymentDate.className!="clsInvalid")) {
			objCTValDate.value=DateStringTo$H(objPaymentDate.value);
		} else {
			objCTValDate.value="";
		}
	}

}

function validateNumericAndPositive(field) {

	var amt = parseInt(field.value)	
	if (amt<0){
		alert(t["NEGATIVE_AMNT"]);
		websys_setfocus(field.name);
		field.className="clsInvalid"
		return false;
		
	}
	return true;
}

// Clearing Function
function clearById(idIn) {
	var obj = document.getElementById(idIn);
	
	if (obj == null) return false;
	
	obj.value = "";
	
	return true;
}

// Log 59979 - 04/10/2006 - If "Rounding Automatic" is not enabled in settings, this function asks whether to round the outstanding amount.
function CheckAutoAdjust() {
	var bOKToAutoAdjust=0;
	if ((objRoundOnPay)&&(objRoundOnPay.value=="Y")) {
		if ((objNewOutstand)&&(objRoundAmt)&&(parseFloat(MedtrakCurrToJSMath(objNewOutstand.value))>0)&&(parseFloat(MedtrakCurrToJSMath(objNewOutstand.value))<parseFloat(MedtrakCurrToJSMath(objRoundAmt.value)))) {
			if ((objRoundAuto)&&(objRoundAuto.value=="N")) {
				bOKToAutoAdjust=confirm(t['OUSTAMT']+objNewOutstand.value+"\n"+t['AUTOROUND']);
				if (!bOKToAutoAdjust) {
					if (objAutoAdjustOK) objAutoAdjustOK.value="0";
				} else {
					if (objAutoAdjustOK) objAutoAdjustOK.value="1";
				}
			} else {	
				if (objAutoAdjustOK) objAutoAdjustOK.value="1";
			}
		}	
	}	
}
// End Log 59979

//
function ReTender() {


if ((objSPTenderPay)&&(objSPTenderPay.value=="Y")&&(cashierMode!="Deposit")&&(cashierMode!="Refund"))	
 {
	if ((objPMChangeGiven)&&(objPMChangeGiven.value!="Y")) { NoChangeGiven() ; }
        else if ((objPMChangeGiven)&&(objPMChangeGiven.value=="Y")) { ChangeGiven() ; }	
  }
  if (cashierMode=="Deposit") { TenderForDeposit();    }
}  
function NoChangeGiven() {

if ((!objTenderAmt)||(objTenderAmt.value=="")) return true;
  if ((objTenderAmt)&&(objRemainPayAmt)) {
				//alert(MedtrakCurrToJSMath(objTenderAmt.value)-MedtrakCurrToJSMath(objRemainPayAmt.value));	
				//if (objTenderAmt.value<=objRemainPayAmt.value)
				if (!((MedtrakCurrToJSMath(objTenderAmt.value)-MedtrakCurrToJSMath(objRemainPayAmt.value))>0))
					{ 
						if (objPayAmt) 
						{
							//objPayAmt.value=MedtrakCurrToJSMath(objTenderAmt.value);
							EnableField("PAYMAmt");	//Log 64151 - 03.07.2007 - enable this here. otherwise onclick event doesnt get fired.
							objPayAmt.value=objTenderAmt.value;
							objPayAmt.click();		
						}
				}else
				{
					//var bOKToTenderOverpay=1;
					bOKToTenderOverpay=confirm(t['PAYMT_MORE_REQ_BALANCE']+"\n"+t['CONTINUE']);	
					//alert(bOKToTenderOverpay);
					if (bOKToTenderOverpay==1)
					{
						if (objPayAmt) {
						//objPayAmt.value=MedtrakCurrToJSMath(objTenderAmt.value);
						EnableField("PAYMAmt");	//Log 64151 - 03.07.2007 - enable this here. otherwise onclick event doesnt get fired.
						objPayAmt.value=objTenderAmt.value;
						objPayAmt.click();		
							   }
						//if (objPAYMChangeAmt) { objPAYMChangeAmt.value=MedtrakCurrToJSMath("")	}		   
					}
					if (bOKToTenderOverpay!=1)	 {  
						EnableField("PAYMAmt");		//Log 64151 - 03.07.2007 - enable this here. otherwise onclick event doesnt get fired.
						objTenderAmt.value="";
						return false;
					}	
				}
	}			
}
function ChangeGiven() {

if ((!objTenderAmt)||(objTenderAmt.value=="")) return true;
		if ((objTenderAmt)&&(objRemainPayAmt))
		{
			//if (objTenderAmt.value<=objRemainPayAmt.value)
			if (!((MedtrakCurrToJSMath(objTenderAmt.value)-MedtrakCurrToJSMath(objRemainPayAmt.value))>0))
			{ 
				if (objPayAmt) 
				{
					//objPayAmt.value=MedtrakCurrToJSMath(objTenderAmt.value);
					EnableField("PAYMAmt");	//Log 64151 - 03.07.2007 - enable this here. otherwise onclick event doesnt get fired.
					objPayAmt.value=objTenderAmt.value;
					objPayAmt.click();		
				}
			} else 
			{
				//var bOKToTenderOverpay=1;
				//alert("amt more than is needed");
				bOKToTenderOverpay=confirm(t['PAYMT_MORE_REQ_BALANCE']+"\n"+t['CONTINUE']);	
				//alert(bOKToTenderOverpay);
				if (bOKToTenderOverpay!=1)	 { 
					if (objPayAmt) EnableField("PAYMAmt");		//Log 64151 - 03.07.2007 - enable this here. otherwise onclick event doesnt get fired.
					objTenderAmt.value="";
					return false;
				}	
				
				if (bOKToTenderOverpay==1)
			       {
				        var bOKToTVhange=1;	
					//Log 63376 - 26.04.2007 - Take the discount amount into consideration when calculating the change to be given
					if (objDiscAmount) {
						if (MedtrakCurrToJSMath(objDiscAmount.value)>0) {
							var billAmount=MedtrakCurrToJSMath(objRemainPayAmt.value)-MedtrakCurrToJSMath(objDiscAmount.value);
						} else {	// Log 63475 - 03.05.2007
							var billAmount=MedtrakCurrToJSMath(objRemainPayAmt.value);
						}
					} else {
						var billAmount=MedtrakCurrToJSMath(objRemainPayAmt.value);
					}
					
					var changetobegiven=MedtrakCurrToJSMath(objTenderAmt.value)-billAmount;
					
					//var changetobegiven=MedtrakCurrToJSMath(objTenderAmt.value)-MedtrakCurrToJSMath(objRemainPayAmt.value);
					var changetobegiven=tkMakeServerCall("websys.Conversions","CurrencyLogicalToHtml",changetobegiven);
					//End Log 63376
					
					bOKToTVhange=confirm(t['PAYMChangeAmt']+"="+changetobegiven+ "\n"+t['CONTINUE']);	
					if (bOKToTVhange==1) 
					{
						//alert("to give change");
						if (objPayAmt) 
						{
						 //objPayAmt.value=MedtrakCurrToJSMath(objRemainPayAmt.value);
						 //objPayAmt.value=objRemainPayAmt.value;
						 //Log 63376 - 26.04.2007 - Take into account any discounts given
						 EnableField("PAYMAmt");	//Log 64151 - 03.07.2007 - enable this here. otherwise onclick event doesnt get fired.
						 objPayAmt.value=billAmount;
						 objPayAmt.click();		
						}
						if (objPAYMChangeAmt) { 
						objPAYMChangeAmt.value=changetobegiven;
						//PAYMChangeAmt_changehandler();
						}	   
					}
					if (bOKToTVhange!=1)
					{
						//alert("do not give change");
						 if (objPayAmt) 
						{
					           //objPayAmt.value=MedtrakCurrToJSMath(objTenderAmt.value);
							EnableField("PAYMAmt");	//Log 64151 - 03.07.2007 - enable this here. otherwise onclick event doesnt get fired.
						    objPayAmt.value=objTenderAmt.value;
					        objPayAmt.click();		
						}
						//if (objPAYMChangeAmt) { objPAYMChangeAmt.value=MedtrakCurrToJSMath("")	}	
					}
				}		
						
			}
	}	  
}

function TenderForDeposit() {

	if ((objTenderAmt)&&(objPayAmt)&&(objTenderAmt.value!="")) 
				{
					//objPayAmt.value=MedtrakCurrToJSMath(objTenderAmt.value);
					EnableField("PAYMAmt");	//Log 64151 - 03.07.2007 - enable this here. otherwise onclick event doesnt get fired.
					objPayAmt.value=objTenderAmt.value;
					objPayAmt.click();		
				}

}

function CheckTenderSP() {
//var objTenderAmt=document.getElementById("TenderAmt"); //46828
//var objPAYMChangeAmt=document.getElementById("PAYMChangeAmt"); //46828

if (((objSPTenderPay)&&(objSPTenderPay.value!="Y"))||(cashierMode=="Refund"))	
 {
 if (objTenderAmt)  DisableField("TenderAmt"); 
 if (objPAYMChangeAmt) DisableField("PAYMChangeAmt"); 
  }
  
}

function TernderAgainsPAyNow() {
	if (objTenderAmt&&objTenderAmt.value!="") {
		if (TenderAmt_changehandler()==false) return false; 
	}

	//Log 64151 - 03.07.2007 - disable PAYMAmt field and Partial Payment Allocation link if Tender Amt is entered. This is because we still dont handle partial payments using the Tender Amt
	if (objTenderAmt&&objTenderAmt.value!="") {
		if (objPayAmt) DisableField("PAYMAmt");
		if (objPaymAlloc) objPaymAlloc.disabled=true;
	} else {
		if (objPayAmt) EnableField("PAYMAmt");
		if (objPaymAlloc) objPaymAlloc.disabled=false;
	}
	//End Log 64151 
	
	if (((MedtrakCurrToJSMath(objTenderAmt.value)-MedtrakCurrToJSMath(objRemainPayAmt.value))>0) ||((MedtrakCurrToJSMath(objTenderAmt.value)-MedtrakCurrToJSMath(objRemainPayAmt.value))==0))
					{
						if (objDiscretReason) DisableField('DiscretReason');
						if (objDiscretReasonLookUpIcon) objDiscretReasonLookUpIcon.style.visibility = "hidden"
						if (objExpectedPayDate) DisableField('ExpectedPayDate');
							
						
						
					} else {
						if (objDiscretReason) EnableField('DiscretReason');
						if (objDiscretReasonLookUpIcon) objDiscretReasonLookUpIcon.style.visibility = "visible"
						if (objExpectedPayDate) EnableField('ExpectedPayDate');
					}

}

document.body.onload=BodyLoadHandler;