// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

/**
 * 
 * SA: The following functions appear in the generated scripts for this component:
 * (as well as all other components which contain fields with data type %Library.Currency)
 * CurrencyRound
 * SubtractCurrencyValues
 * AddCurrencyValues
 * MedtrakCurrToJSMath
 */

var AddingNotClosing;
var cashierMode;
var OldBodyUnload;
var objParentWindow=window.opener;
var objTotAmt=document.getElementById("TotAmt");
var objRemAmt=document.getElementById("RemAmt");
var objHiddenRemAmt=document.getElementById("HiddenRemAmt"); //46386
var objTotPayAmt=document.getElementById("TotPayAmt");
var objPayAmt=document.getElementById("PayAmt");
var objPayMethod=document.getElementById("PayMethod");
var objCMCBankDesc=document.getElementById("CMCBankDesc");
var objPAYMCardChequeNo=document.getElementById("PAYMCardChequeNo");
var objPAYMChequeDate=document.getElementById("Date");
var objAuthCode=document.getElementById("AuthCode");
var objBranch=document.getElementById("Branch");
var objDrawer=document.getElementById("Drawer");
var objCARDDesc=document.getElementById("CARDDesc");
var objPAYMCardExpiryDate=document.getElementById("PAYMCardExpiryDate");
var objCardTypeLookUpIcon=document.getElementById('ld604iCARDDesc');
var objBankLookUpIcon=document.getElementById('ld604iCMCBankDesc');
var objUsingPaymAlloc=document.getElementById('UsingPaymAlloc');
var objDecSepPlaces=document.getElementById("DecSepPlaces");

var DecimalPlaces="2";	//default system value
var DecimalSymbol=".";	//default system value
var GroupingSymbol=",";	//default system value
var OrigRemainingAmt=""; //48169

//48110
var objCurrencyAmt=document.getElementById("PAYMCurrencyAmt");
var objHiddenCurrAmt=document.getElementById("HiddenPAYMCurrencyAmt");
var objCurrency=document.getElementById("PAYMCurrencyDR");

function BodyLoadHandler() {

	if (objRemAmt) OrigRemainingAmt=objRemAmt.value;  //48169

	if (objDecSepPlaces) {
 		var aryDec = objDecSepPlaces.value.split("^");
		if ((aryDec[0])&&(aryDec[0].value!="")) DecimalPlaces=new Number(aryDec[0]);
		if ((aryDec[1])&&(aryDec[1].value!="")) DecimalSymbol=aryDec[1];
	}

	GroupingSymbol = (DecimalSymbol=="," ? "." : ",");

	var addobj=document.getElementById("Add")
	if (addobj) addobj.onclick=AddClickHandler;
	if (tsc['Add']) websys_sckeys[tsc['Add']]=AddClickHandler;

	var updobj=document.getElementById("Update")
	if (updobj) updobj.onclick=UpdateClickHandler;
	if (tsc['Update']) websys_sckeys[tsc['Update']]=UpdateClickHandler;

	var delobj=document.getElementById("DeleteAll");
	if (delobj) delobj.onclick=DeleteAllClickHandler;
	if (tsc['DeleteAll']) websys_sckeys[tsc['DeleteAll']]=DeleteAllClickHandler;

	if (objPayAmt) objPayAmt.onchange = PayAmtChangeHandler; //47035

	if (objCurrencyAmt) { //48110
		objCurrencyAmt.onchange = CurrencyAmtChangeHandler;
		objCurrencyAmt.value = "";
	}

	if (objPayAmt) EnableField('PayAmt');
	if (objPayMethod) EnableField('PayMethod');

	if (objTotAmt) objTotAmt.disabled = true;
	if (objRemAmt) objRemAmt.disabled = true;
	if (objTotPayAmt) {
		objTotPayAmt.disabled = true;

		// SA 32817: Parent window is now also refreshed on page load. Do not want to refresh 
		// if no money has been entered, as this will cause ARReceipts.Edit to reset unnecessarily.
		// "0.00" filter is only problematic with single patient receipting, not with batch receipting,
		// A known problem will occur when a multiple payment exists, then all payments are deleted leaving 0.00,
		// then this page is closed via "X". The ARReceipts.Edit value will still show the last value.
		// There is no workaround (without a full rewrite), so for now, we must suggest that the "X" close
		// cannot be supported.

		if (MedtrakCurrToJSMath(objTotPayAmt.value)!=0) ResetParentWindowValues();
	}


	if ((objTotAmt)&&(objTotAmt.value < 0)) {
		cashierMode="Refund";
	} else {
		cashierMode="Payment";
	}

	AddingNotClosing=0;
	
	DisableBankFields("CH");
	AssignDeleteClickHandler();
	
}

//47035
function PayAmtChangeHandler(e) {

	var valid=PayAmt_changehandler(e);

	if (valid==false) return websys_cancel(); // !valid is not gonna work, due to PayAmt_changehandler not returning true

	//48110
	if ((objPayAmt)&&(objPayAmt.value!="")) {
		var obj=document.getElementById("CurrencyCalcDirect");
		if (obj) { obj.onclick=obj.onchange; obj.click(); }
	}
	else {
		if (objCurrencyAmt) objCurrencyAmt.value = "";
		objHiddenCurrAmt.value = "";
	}

	return ValidatePayment();
}

function CurrencyAmtChangeHandler() {

	if (objCurrencyAmt&&objCurrencyAmt.value!="") {
		if (PAYMCurrencyAmt_changehandler()==false) return false;
	}

	if (objCurrencyAmt) objHiddenCurrAmt.value = objCurrencyAmt.value;

	//48110
	if ((objCurrencyAmt)&&(objCurrencyAmt.value!="")) {
		var obj=document.getElementById("CurrencyCalcIndirect");
		if (obj) { obj.onclick=obj.onchange; obj.click(); }
	}
	else {
		if (objPayAmt) objPayAmt.value = "";
		ValidatePayment();
	}
}

function CurrencyCalcIndirect_changehandler(encmeth) {

	if (objPayAmt && objCurrency && objCurrencyAmt) {
		//calling web.ARReceipts.CalculateIndirectCurrency()
		var val = cspRunServerMethod(encmeth,objCurrency.value,objCurrencyAmt.value);
		objPayAmt.value = val;
		ValidatePayment();
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

//47035
function ValidatePayment() {

	if (objPayAmt==null) return true;

	if (!ValidateRefundAmount()) return websys_cancel();  //50945

	var remaining=0;
	
	if (objRemAmt)
		remaining = objRemAmt.value;
	else
		remaining = objHiddenRemAmt.value;
	
	remaining = MedtrakCurrToJSMath(String(remaining)) - MedtrakCurrToJSMath(objPayAmt.value);
	
	// set both RemAmt and HiddenRemAmt
	if (objRemAmt) objRemAmt.value = CurrencyRound(remaining);
	objHiddenRemAmt.value = CurrencyRound(remaining);

	return true;
}

//50945
function ValidateRefundAmount() {

	var objRefundChk=objParentWindow.document.getElementById("RefundChk");

	if ((objRefundChk)&&(objRefundChk.checked)) {
		if (objPayAmt.value!=""&&MedtrakCurrToJSMath(objPayAmt.value)>0) {
			alert("Refund Amount must be negative amount");
			objPayAmt.className='clsInvalid';
			objPayAmt.focus();
			return false;
		}
	}
	else {
		if (objPayAmt.value!=""&&MedtrakCurrToJSMath(objPayAmt.value)<0) {
			alert("Payment Amount cannot be negative amount");
			objPayAmt.className='clsInvalid';
			objPayAmt.focus();
			return false;
		}
	}
	return true;
}

function AddClickHandler() {
	if (ValidateAdd()) {
		AddingNotClosing=1;
		Add_click();
	} else {
		return;
	}
}

function ValidateAdd() {
	
	var PayAmt=0;

	if (objPayAmt) {

		PayAmt = MedtrakCurrToJSMath(objPayAmt.value);
		
		if ((cashierMode=="Refund")&&(PayAmt > 0)) {
			alert(t['ADD_PAYM_REFUND']);
			//objPayAmt.value="";
			return false;
		}

		if (!ValidateRefundAmount()) return websys_cancel();  //50945

		var remaining=0;
		if (objRemAmt) remaining = objRemAmt.value;
		else remaining = objHiddenRemAmt.value;
	
		remaining = MedtrakCurrToJSMath(String(remaining)) - MedtrakCurrToJSMath(objPayAmt.value);
		objHiddenRemAmt.value = CurrencyRound(remaining);

		// since 48169, we're checking OrigRemainingAmt to validate
		// Also, need to check RemAmt field because it's dependent on OrigRemainingAmt now
 		// (which was set from RemAmt see BodyLoadHandler). In Batch Receipting, 
		// we're not checking for PAYMT_MORE_REQ_BALANCE here. We do it in ARPatientBill.FindBatch.js 

		if (objRemAmt) {
			OrigRemainingAmt = MedtrakCurrToJSMath(OrigRemainingAmt);  //48169

			if ((PayAmt - OrigRemainingAmt > 0)&&(cashierMode=="Payment")) {
				alert(t['PAYMT_MORE_REQ_BALANCE']);
				return false;
			} else if ((PayAmt - OrigRemainingAmt < 0)&&(cashierMode=="Refund")) {
				alert(t['PAYMT_MORE_REQ_BALANCE']);
				return false;				
			}
		}
	}

	if ((objPayAmt)&&(objPayAmt.value=="")) {
		alert(t['PAY_AMOUNT_REQUIRED']);
		objPayAmt.focus();
		return false;
	}

	if ((objPayMethod)&&(objPayMethod.value=="")) {
		alert(t['PAY_METHOD_REQUIRED']);
		objPayMethod.focus();
		return false;
	}

	var errMsg="";
	var lblPAYMCardChequeNo=document.getElementById("cPAYMCardChequeNo");
	var lblAuthCode=document.getElementById("cAuthCode");
	var lblCMCBankDesc=document.getElementById("cCMCBankDesc");
	var lblPAYMChequeDate=document.getElementById("cDate");
	var lblPAYMBranch=document.getElementById("cBranch");
	var lblPAYMDrawer=document.getElementById("cDrawer");
	var lblPAYMCardDesc=document.getElementById("cCARDDesc");
	var lblPAYMCardExpiryDate=document.getElementById("cPAYMCardExpiryDate");

	if ((objPAYMCardChequeNo)&&(objPAYMCardChequeNo.value=="")&&(lblPAYMCardChequeNo)&&(lblPAYMCardChequeNo.className=="clsRequired")) {
		errMsg += t['CARD_CHQ_NUM_REQUIRED']+"\n";
		objPAYMCardChequeNo.focus();
	}
	
	if ((objAuthCode)&&(objAuthCode.value=="")&&(lblAuthCode)&&(lblAuthCode.className=="clsRequired")) {
		errMsg += t['AUTH_CODE_REQUIRED']+"\n";
		objAuthCode.focus();
	}

	if ((objCMCBankDesc)&&(objCMCBankDesc.value=="")&&(lblCMCBankDesc)&&(lblCMCBankDesc.className=="clsRequired")) {
		errMsg += t['BANK_REQUIRED']+"\n";
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
		
	if ((objCARDDesc)&&(objCARDDesc.value=="")&&(lblPAYMCardDesc)&&(lblPAYMCardDesc.className=="clsRequired")) {
		errMsg += t['CARDTYPE_REQUIRED']+"\n";
		objCARDDesc.focus();
	}

	if ((objPAYMCardExpiryDate)&&(objPAYMCardExpiryDate.value=="")&&(lblPAYMCardExpiryDate)&&(lblPAYMCardExpiryDate.className=="clsRequired")) {
		errMsg += t['CARDDATE_REQUIRED']+"\n";
		objPAYMCardExpiryDate.focus();
	}

	if (errMsg != "") {
		alert(errMsg);
		return false;
	}

	return true;
}


function UpdateClickHandler() {
	if ((objPayAmt)&&(objPayAmt.value!="")) {

		if (ValidateAdd()) {

			if (objTotPayAmt) {
				var totamt=0;
				var newamt=0;
				var temp=0;
				// Subtracting to stop javascript from implicitly concatenating.
				totamt = 0 - MedtrakCurrToJSMath(objTotPayAmt.value);
				newamt = 0 - MedtrakCurrToJSMath(objPayAmt.value);
				temp = 0 - totamt-newamt;
				temp = CurrencyRound(temp)
				objTotPayAmt.value=temp;
			}
		} else {
			return;
		}
	}

	ResetParentWindowValues();
	
	return Update_click();
}


function ResetParentWindowValues() {

	//Update parent window to get the affect of the multiple payment mode 

	if (objParentWindow) {
		//alert("objTotPayAmt.value " + objTotPayAmt.value);

		if ((objTotPayAmt)&&(MedtrakCurrToJSMath(objTotPayAmt.value)!=0)) {
			
			if (objTotPayAmt) {
				ReadOnlyParentWinField("PAYMAmt",objTotPayAmt.value);
				ReadOnlyParentWinField("PAYMCurrencyAmt",""); //48110
				ReadOnlyParentWinField("PAYMCurrencyDR",""); //48110
				ReadOnlyParentWinField("ReceiptAmt",objTotPayAmt.value); //on ARPatientBill.FindBatch

				//var objHiddenPAYMAmt = objParentWindow.document.getElementById("HiddenPAYMAmt");
				//objHiddenPAYMAmt.value = objTotPayAmt.value;
			}

			if (cashierMode!="Refund") {

				// SA 7.4.03 - log 32817: If payment allocations exists for all bills now 
				// receipting, objUsingPaymAlloc will be "Y", otherwise "N". If "Y", the total 
				// payment amount must equal the amount required - otherwise an error 
				// message will be displayed via ARReceipts.Edit. Do not set 
				// remaining OS when flag is "Y".

				if ((objUsingPaymAlloc)&&(objUsingPaymAlloc.value!="Y")) {
					ReadOnlyParentWinField("NewOutstandAmt",objHiddenRemAmt.value);
					ReadOnlyParentWinField("HidNewOutstandAmt",objHiddenRemAmt.value);
				}

				if ((objHiddenRemAmt)&&(MedtrakCurrToJSMath(objHiddenRemAmt.value)==0)) {
					DisableParentWinField("ExpectedPayDate");
					DisableParentWinField("DiscretReason");
				} else {
					// SA 7.4.03 - log 32817: See note above.
					if ((objUsingPaymAlloc)&&(objUsingPaymAlloc.value!="Y")) {
						EnableParentWinField("ExpectedPayDate");
						EnableParentWinField("DiscretReason");
						var objDiscretReasonLookUpIcon=document.getElementById('ld277iDiscretReason');
						if (objDiscretReasonLookUpIcon) objDiscretReasonLookUpIcon.style.visibility = "visible"
					}
				}
			}

			ReadOnlyParentWinField("PAYMPayModeDesc",t['MULTIPLE_PAYMENTS']);

			var objPayMethodLookUpIcon=objParentWindow.document.getElementById('ld277iPAYMPayModeDesc');
			if (objPayMethodLookUpIcon) objPayMethodLookUpIcon.style.visibility = "hidden"

			DisableParentWinField("CMCBankDesc");
			DisableParentWinField("PAYMChequeDate");			
			DisableParentWinField("PAYMCardChequeNo");
			DisableParentWinField("PAYMAuthorCode");
			DisableParentWinField("PAYMBranch");
			DisableParentWinField("PAYMDrawer");
		}
		else {

			//Reverts parent window to single payment mode	

			if ((objTotPayAmt)&&(MedtrakCurrToJSMath(objTotPayAmt.value)==0)) {
				//The following check stops unnecessary refreshing of parent window.
				var extobjPAYMAmt= objParentWindow.document.getElementById("PAYMAmt");
				if ((extobjPAYMAmt)&&(extobjPAYMAmt.disabled)&&(AddingNotClosing!="1")) {
					//.reload NOT to be used when Pay details exist as this would 
					//clear all ^TMP globals which hold the payment details.
					objParentWindow.location.reload();	
				}

				if (objTotPayAmt) ReadOnlyParentWinField("ReceiptAmt",objTotPayAmt.value); //on ARPatientBill.FindBatch
			}
		}
	}
	AddingNotClosing=0;

	try { objParentWindow.SetRequiredAmount(); } catch(e) {}
}

function EnableNonMandatoryField(fldName) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);

	if (fld) {
		//alert("fld")
		fld.disabled = false;
		fld.className = "";
		if (lbl) lbl = lbl.className = "";		
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

function ValidateField(fldName) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if (fld) {
		fld.disabled = false;
		fld.className = "";
		if (lbl) lbl = lbl.className = "clsRequired";
	} else {
		return true;
	}
}

function PaymentLookUpSelect(str) {

	var lu = str.split("^");
	
	DisableBankFields(lu[1]);

	websys_nexttab(objPayMethod.tabIndex,objPayMethod.form); //50151
}

function DisableBankFields(PayMode) {
	
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
		if (objBranch) DisableField('Branch');
		//if (objDrawer) DisableField('Drawer'); //43713
		if (objPAYMCardChequeNo) DisableField('PAYMCardChequeNo');
		if (objPAYMChequeDate) DisableField('PAYMChequeDate');
		if (objAuthCode) DisableField('AuthCode'); //43713
		if (objCARDDesc) DisableField('CARDDesc');
		if (objCardTypeLookUpIcon) objCardTypeLookUpIcon.style.visibility = "hidden";
		if (objBankLookUpIcon) objBankLookUpIcon.style.visibility = "hidden";
		if (objPAYMChequeDate) DisableField('Date');
		if (objPAYMCardExpiryDate) DisableField('PAYMCardExpiryDate');

	} else {

		//alert("1mustBank="+mustBank);
		if (objPAYMCardChequeNo) EnableField('PAYMCardChequeNo');
		if (objAuthCode) EnableField('AuthCode');

		if (PayMode=="CQ") {
			if (objCMCBankDesc) EnableField('CMCBankDesc');
			if (objBranch) EnableField('Branch');
			if (objDrawer) EnableField('Drawer');
			if (objAuthCode) DisableField('AuthCode'); //43713
			if (objCARDDesc) DisableField('CARDDesc');
			if (objCardTypeLookUpIcon) objCardTypeLookUpIcon.style.visibility = "hidden";
			if (objBankLookUpIcon) objBankLookUpIcon.style.visibility = "visible";
			if (objPAYMChequeDate) EnableField('Date');
			if (objPAYMCardExpiryDate) DisableField('PAYMCardExpiryDate');
		} else if (PayMode=="CC") {
			if (objCMCBankDesc) DisableField('CMCBankDesc');
			if (objBranch) DisableField('Branch');
			//if (objDrawer) DisableField('Drawer');  //43713
			if (objAuthCode) EnableField('AuthCode'); //43713
			if (objCARDDesc) EnableField('CARDDesc');
			if (objCardTypeLookUpIcon) objCardTypeLookUpIcon.style.visibility = "visible";
			if (objBankLookUpIcon) objBankLookUpIcon.style.visibility = "hidden";
			if (objPAYMChequeDate) DisableField('Date');
			if (objPAYMCardExpiryDate) EnableField('PAYMCardExpiryDate');
		}
	}
}


function AssignDeleteClickHandler(e) {

	var tbl=document.getElementById("tARReceipts_EditMultiPay");

	for (var i=1; i<tbl.rows.length; i++) {
		//CellColumnName pattern is FieldName + z + rowNo
		var objDelete=document.getElementById("Deletez"+i);
		if (objDelete) {
			objDelete.disabled=true;
			objDelete.onclick=DeleteClickHandler;
		}
	}
}

function DeleteClickHandler(evt) {

	AddingNotClosing=1;
	ResetParentWindowValues();
	return true;
}

//53446
function DeleteAllClickHandler(evt) {

	if (objParentWindow) {
		ReadOnlyParentWinField("ReceiptAmt",""); //on ARPatientBill.FindBatch

		objParentWindow.location.reload();

		if (objTotPayAmt) {
			var fld = objParentWindow.document.getElementById("PAYMAmt");
			if ((fld)&&(fld.tagName=="INPUT")) fld.value = "0.00";
		}
	}
	return DeleteAll_click();;
}

function EnableParentWinField(fldName) {
	var fld = objParentWindow.document.getElementById(fldName);
	var lbl = objParentWindow.document.getElementById('c'+fldName);
	if (fld) {
		fld.disabled = false;
		fld.className = "";
		if (lbl) lbl = lbl.className = "clsRequired";
	}
}

function DisableParentWinField(fldName) {
	var fld = objParentWindow.document.getElementById(fldName);
	var lbl = objParentWindow.document.getElementById('c'+fldName);

	if ((fld)&&(fld.tagName=="INPUT")) {
		fld.value = "";
		fld.disabled = true;
		fld.className = "disabledField";
		if (lbl) lbl = lbl.className = "";
	}
}

function ReadOnlyParentWinField(fldName,fldNewValue) {
	var fld = objParentWindow.document.getElementById(fldName);
	var lbl = objParentWindow.document.getElementById('c'+fldName);

	if ((fld)&&(fld.tagName=="INPUT")) {
		fld.value = fldNewValue;
		fld.disabled = true;
		if (lbl) lbl = lbl.className = "";
	}
}

//48110
function LookUpCurrencySelect(str){

	if ((objPayAmt) && (objPayAmt.value!="") &&(objCurrency)) {
		var obj=document.getElementById("CurrencyCalcDirect");
		if (obj) { obj.onclick=obj.onchange; obj.click(); }
	}
	else {
		if (objCurrencyAmt) objCurrencyAmt.value = "";
		objHiddenCurrAmt.value = "";
	}
}

document.body.onload=BodyLoadHandler;