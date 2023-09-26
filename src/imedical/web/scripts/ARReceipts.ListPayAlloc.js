// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var AddingNotClosing;
var bWindowUnloading=false;
var objParentWindow=window.opener;
var objMode=document.getElementById("Mode");

var objOrderItem=document.getElementById("OrderItem");
var objBillGroup=document.getElementById("BillGroup");
var objBillSub=document.getElementById("BillSub");

var objBillRowID=document.getElementById("BillRowID");
var objGroupType=document.getElementById("GroupType");
var objCurrentOutstandAmt=document.getElementById("CurrentOutstandAmt");

var objCurrentOutstandAmt=document.getElementById("CurrentOutstandAmt");
var objPayAmt=document.getElementById("PayAmt");
var objRemainOutstandAmt=document.getElementById("RemainOutstandAmt");

var objBilledAmt=document.getElementById("BilledAmt");
var objPrevAllocAmt=document.getElementById("PrevAllocAmt");
var objAmtAlloc=document.getElementById("AmtAlloc");
var objAmtRem=document.getElementById("AmtRem");

var objCurrAllocAmt=document.getElementById("CurrAllocAmt");
var objAmtToBeAlloc=document.getElementById("AmtToBeAlloc");
var objHidAmtToBeAlloc=document.getElementById("HidAmtToBeAlloc");
var objHidPayAmt=document.getElementById("HidPayAmt");

var objUpdate=document.getElementById("Update");
var objUpdateAlloc=document.getElementById("UpdateAlloc");
var objUpdateReload=document.getElementById("UpdateReload");
var objClearAlloc=document.getElementById("ClearAlloc");
var objAutoAlloc=document.getElementById("AutoAlloc");

var objTotalAllocMinusItemAlloc=document.getElementById("TotalAllocMinusItemAlloc");
var objParamString=document.getElementById("ParamString");

var objDecSepPlaces=document.getElementById("DecSepPlaces");
var DecimalPlaces="2";	//default system value
var DecimalSymbol=".";	//default system value
var GroupingSymbol=",";	//default system value

var OldPayAmtChangeHandler="";
var OldRemainOutstandAmtChangeHandler="";
var OldAmtAllocChangeHandler="";

function DocumentLoadHandler() {


	if (objDecSepPlaces) {
 		var aryDec = objDecSepPlaces.value.split("^");
		if ((aryDec[0])&&(aryDec[0].value!="")) DecimalPlaces=new Number(aryDec[0]);
		if ((aryDec[1])&&(aryDec[1].value!="")) DecimalSymbol=aryDec[1];
	}

	GroupingSymbol = (DecimalSymbol=="," ? "." : ",");

	if (objOrderItem) objOrderItem.onclick=OrderItemOnClick;
	if (objBillGroup) objBillGroup.onclick=BillGroupOnClick;
	if (objBillSub) objBillSub.onclick=BillSubOnClick;
	if (objGroupType) {
		if ((objGroupType.value=="G")&&(objBillGroup)) objBillGroup.checked=true;
		else if ((objGroupType.value=="S")&&(objBillSub)) objBillSub.checked=true;
		else if (objOrderItem) {objOrderItem.checked=true; objGroupType.value="I";}
	}

	if ((objHidPayAmt)&&(objHidAmtToBeAlloc)&&(objCurrAllocAmt)) {
		objHidAmtToBeAlloc.value = SubtractCurrencyValues(objHidPayAmt.value,objCurrAllocAmt.value);
		if((objPayAmt)&&(objHidPayAmt)) objPayAmt.value=objHidPayAmt.value;
		if((objAmtToBeAlloc)&&(objHidAmtToBeAlloc)) objAmtToBeAlloc.value=objHidAmtToBeAlloc.value;
	}


	if (objUpdate) {
		objUpdate.onclick=UpdateClickHandler;
		if (tsc['Update']) websys_sckeys[tsc['Update']]=UpdateClickHandler;
	}

	if (objClearAlloc) {
		objClearAlloc.onclick=ClearAllocClickHandler;
		if (tsc['ClearAlloc']) websys_sckeys[tsc['ClearAlloc']]=ClearAllocClickHandler;
	}
	
	if (objAutoAlloc) {
		objAutoAlloc.onclick=AutoAllocClickHandler;
		if (tsc['AutoAlloc']) websys_sckeys[tsc['AutoAlloc']]=AutoAllocClickHandler;
	}
	
	var tbl=document.getElementById("tARReceipts_ListPayAlloc");
	var TotalAmtRem=0;
	for (var i=1; i<tbl.rows.length; i++) {
		var AmtRemCol=document.getElementById("ListAmtRemz"+i);
		if (AmtRemCol) {
			var val=AmtRemCol.innerText;
			if (val!="") TotalAmtRem=TotalAmtRem+MedtrakCurrToJSMath(val);
		}
		// Not finished.
		var BillGroupTypeObj=document.getElementById("BillGroupTypez"+i);
		if ((BillGroupTypeObj)&&(BillGroupTypeObj.innerText!="")) {
			if (BillGroupTypeObj.innerText=="I") BillGroupTypeObj.innerText=t['I'];
			if (BillGroupTypeObj.innerText=="G") BillGroupTypeObj.innerText=t['G'];
			if (BillGroupTypeObj.innerText=="S") BillGroupTypeObj.innerText=t['S'];
		}
	}	
	var obj=document.getElementById("TotalAmtRem");
	if (obj) obj.value=TotalAmtRem;

	if ((objMode)&&(objMode.value=="Viewing")) {
		DisableLinks();
	} else {
		DisableZeroLinks();
	}
}

function DocumentUnloadHandler() {

	if (window.event) {
		if (window.event.clientY < 0) {
		   	//try {unloadHandler();} catch(e) {}
			//alert("The browser is closing...");
			if ((objHidAmtToBeAlloc)&&(MedtrakCurrToJSMath(objHidAmtToBeAlloc.value)!=0)) {
				// If user has hit "X" and amounts are not correct,
				// payment details will be cleared.
				alert(t['CLOSING_ERR_CLEAR']);
				bWindowUnloading=true;
				ClearAlloc_click();

				if (objParentWindow) {
					var objPaymAllocOK=objParentWindow.document.getElementById("PaymAllocOK");
					if (objPaymAllocOK) objPaymAllocOK.value="";

					var objPaymAllocAmt=objParentWindow.document.getElementById("PaymAllocAmt");
					if (objPaymAllocAmt) objPaymAllocAmt.value="0";
				}

			} else {
				if (objParentWindow) {
					var objPaymAllocOK=objParentWindow.document.getElementById("PaymAllocOK");
					if ((objPaymAllocOK)&&(objHidAmtToBeAlloc)) objPaymAllocOK.value="Y";

					var objPaymAllocAmt=objParentWindow.document.getElementById("PaymAllocAmt");
					if ((objPaymAllocAmt)&&(objHidPayAmt)) objPaymAllocAmt.value=objHidPayAmt.value;
				}
			}

			if ((objMode)&&(objMode.value="Batch")) {
				if (objUpdateReload) UpdateReload_click();
			}

		} else {
			//alert("The user is refreshing or navigating away...");
		}
	}

	//if (!(UpdateClickHandler())) return false;
}

function UpdateClickHandler() {

	//AmtToBeAlloc must equal zero 
	if (objHidAmtToBeAlloc) {
		if (MedtrakCurrToJSMath(objHidAmtToBeAlloc.value)!=0) {
			alert(t['REM_ALLOC_AMT_NOT_ZERO']);
			return false;
		}
	}

	if (objParentWindow) {
		var objPaymAllocOK=objParentWindow.document.getElementById("PaymAllocOK");
		if ((objPaymAllocOK)&&(objHidAmtToBeAlloc)) objPaymAllocOK.value="Y";

		var objPaymAllocAmt=objParentWindow.document.getElementById("PaymAllocAmt");
		if ((objPaymAllocAmt)&&(objHidPayAmt)) objPaymAllocAmt.value=objHidPayAmt.value;
	}

	return Update_click();
}

function AutoAllocClickHandler() {
	var TotalRem="";
	var val="";
	var bOKToAutoAlloc="";
	var tbl=document.getElementById("tARReceipts_ListPayAlloc");
	for (var i=1; i<tbl.rows.length; i++) {
		var AmtRemCol=document.getElementById("ListAmtRemz"+i);
		if (AmtRemCol) {
			val=AmtRemCol.innerText;
			if ((val!="")&&(MedtrakCurrToJSMath(val)>0)) {
				TotalRem=TotalRem+MedtrakCurrToJSMath(val);
			}
		}
	}	
	var AmtToBeAlloc="";
	var obj=document.getElementById("AmtToBeAlloc");
	if (obj) AmtToBeAlloc=MedtrakCurrToJSMath(obj.value);
	//alert("TotalRem="+TotalRem+" AmtToBeAlloc="+AmtToBeAlloc);
	if (TotalRem>AmtToBeAlloc) {
		bOKToAutoAlloc=confirm(t['OK_TO_AUTO_ALLOC']);
		if (!bOKToAutoAlloc) {
			return false;
		}
	}
	
	return AutoAlloc_click();
}
	
function ClearAllocClickHandler() {

	// If more than one bill exists, prompt user to confirm that payment allocations for ALL BILLS
	// will be cleared
	if ((objBillRowID)&&(!bWindowUnloading)) {
		BillAry=objBillRowID.value.split("|");
		if (BillAry[1]) {
			var bOKToClearAll=1;
			bOKToClearAll=confirm(t['OK_TO_CLEAR']);
			if (!bOKToClearAll) {
				return false;
			}
		}
	}

	return ClearAlloc_click();
}

function OrderItemOnClick() {

	if ((objOrderItem)&&(objOrderItem.checked)) {
		if (objBillGroup) objBillGroup.checked=false;
		if (objBillSub) objBillSub.checked=false;
	}
	if (objGroupType) objGroupType.value="I";
	ChangeAllocationGrouping();
}

function BillGroupOnClick() {

	if ((objBillGroup)&&(objBillGroup.checked)) {
		if (objOrderItem) objOrderItem.checked=false;
		if (objBillSub) objBillSub.checked=false;
	}
	if (objGroupType) objGroupType.value="G";
	ChangeAllocationGrouping();
}

function BillSubOnClick() {

	if ((objBillSub)&&(objBillSub.checked)) {
		if (objOrderItem) objOrderItem.checked=false;
		if (objBillGroup) objBillGroup.checked=false;
	}
	if (objGroupType) objGroupType.value="S";	
	ChangeAllocationGrouping();
}


function ChangeAllocationGrouping() {

	// SA: For now (ie. QH only), only Grouptype "I" will be used. When S and G are implemented,
	// method web.ARPatBillPaymAlloc.GetBillGroupType will need to be called to set the default
	// to whatever has been used previously (if a payment allocation has already been made 
	// against this bill), and other options will need to be disabled in DocumentLoadHandler.
	var CONTEXT="";
	var obj=document.getElementById("CONTEXT");
	if (obj) CONTEXT=obj.value;
	var BillRowID="";
	var obj=document.getElementById("BillRowID");
	if (obj) BillRowID=obj.value;
	var CurrentOutstandAmt="";
	var obj=document.getElementById("CurrentOutstandAmt2");
	if (obj) CurrentOutstandAmt=obj.value;
	var GroupType="";
	if (objGroupType) GroupType=objGroupType.value;
	var PatientID="";
	var obj=document.getElementById("PatientID");
	if (obj) PatientID=obj.value;
	var PayAmt="";
	var obj=document.getElementById("PayAmt2");
	if (obj) PayAmt=obj.value;
	//Log 64801 - 05.09.2007 - Mode should be included in the URL when allocation grouping check boxes are changed.
	var Mode="";
	var obj=document.getElementById("Mode");
	if (obj) Mode=obj.value;
	//End Log 64801		
	var url = "websys.default.csp?WEBSYS.TCOMPONENT=ARReceipts.ListPayAlloc&CONTEXT="+CONTEXT+"&BillRowID="+BillRowID+"&PatientBanner=1&CurrentOutstandAmt="+CurrentOutstandAmt+"&GroupType="+GroupType+"&PatientID="+PatientID+"&PayAmt="+PayAmt+"&Mode="+Mode;
	//alert(url);
	websys_createWindow(url,window.name,'');
}

function DisableLinks() {

	var tbl=document.getElementById("tARReceipts_ListPayAlloc");

	//for every row of the table
	for (var i=1; i<tbl.rows.length; i++) {
		DisableLink("ListAmtAllocz"+i);
	}	

}

function DisableZeroLinks() {

	// SA 16.9.03 - log 39171: Fixed problems with links disabling incorrectly, when paying
	// entire item amount, and re-entering screen to lower that amount.

	// SA 1.7.03 - log 32817: Links to be disabled if no amount required to pay against item.
	var tbl=document.getElementById("tARReceipts_ListPayAlloc");

	//for every row of the table
	for (var i=1; i<tbl.rows.length; i++) {
		var AmtRemCol=document.getElementById("ListAmtRemz"+i);
		var AmtAllocCol=document.getElementById("ListAmtAllocz"+i);
		if ((AmtRemCol)&&(AmtAllocCol)) {
			var val=AmtRemCol.innerText;
			var valAlloc=AmtAllocCol.innerText;
			if ((val!="")&&(MedtrakCurrToJSMath(val)==0)&&(valAlloc!="")&&(MedtrakCurrToJSMath(valAlloc)==0)) {
				DisableLink("ListAmtAllocz"+i);
			}
		}
	}	

}

function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if (el.disabled) {
		return false;
	}
	return true;
}

function DisableLink(fldName) {
	var fld = document.getElementById(fldName);
	if (fld) {
		fld.value = "";
		fld.disabled = true;
		fld.onclick=LinkDisable
		fld.className = "disabledLink";
	}
}

/* ----- currency related methods -------
   must be included here, becaues if saving component against the workflow these methods 
   are not generated in script_gen unless a textfield with type currency is placed on the screen.
*/


function SubtractCurrencyValues(StrNum1,StrNum2,StrNum3) {
	// Function to subtract Medtrak Currency Values
	// Up to 2 numbers can be subtracted from the first.
	var strRemainder='';
	var str1='';
	var str2='';
	var str3='';
	str1= ((!StrNum1) ? '0' : MedtrakCurrToJSMath(StrNum1));
	str2= ((!StrNum2) ? '0' : MedtrakCurrToJSMath(StrNum2));
	str3= ((!StrNum3) ? '0' : MedtrakCurrToJSMath(StrNum3));
	strRemainder=CurrencyRound(parseFloat(str1)-parseFloat(str2)-parseFloat(str3));
	return strRemainder;
}

function MedtrakCurrToJSMath(StrNum) {
	// JS Math class functions don't recognise decimal commas
	// This function will format the Medtrak currency into a string
	// JS recognises before Math function is called
	var ReturnStr=StrNum.replace(/\ /g, '');
	if (ReturnStr=='') {
		ReturnStr='0';
	} else {
		ReturnStr=ReturnStr.replace(/\,/g, '');
		if (('.'!='.')&&(ReturnStr.indexOf('.')!=-1)) {
			ReturnStr=ReturnStr.replace(/\./g, '.');
		}
	}
	return ReturnStr;
}
function CurrencyRound(flt) {
	// CurrencyRound function rounds value to system defined number of decimal places
	// and also adds grouping symbols
	var bNeg=false;
	var RoundedNum='';
	var fltStr=flt.toString();
	var fltArr=fltStr.split('.');
	if (fltArr[0]) {
		fltArr[0]=fltArr[0].replace(/\ /g, '');
		if (fltArr[0]=='') fltArr[0]='0';
	} else {
		fltArr[0]='0';
	}
	if (fltArr[1]) {
		if ((flt.toString().length - flt.toString().lastIndexOf('.')) > (parseFloat(2 + 1))) {
			var Rounder = Math.pow(10,2);
			var fltJS=flt.toString().replace(/\./g, '.');
			RoundedNum=Math.round(fltJS * Rounder) / Rounder;
			var RoundedNumStr=RoundedNum.toString();
			if ('.'!='.') RoundedNumStr=RoundedNumStr.replace(/\./g, '.');
			var RoundedNumArr=RoundedNumStr.split('.');
			if (!(RoundedNumArr[1])) {
				RoundedNumArr[1]='';
			}
			for (var j=1; RoundedNumArr[1].length<2; j++) {
				RoundedNumArr[1]+='0';
			}
			// Case 0.000000 does not get rounded correctly
			if (RoundedNumArr[1].length>2) RoundedNumArr[1]=RoundedNumArr[1].substring(0,2);
			RoundedNumArr[0] = AddGroupingSymbol(RoundedNumArr[0]);
			RoundedNum = RoundedNumArr.join('.');
			return RoundedNum;
		}
	} else {
		fltArr[1]='';
	}
	for (var i=1; fltArr[1].length<2; i++) {
		fltArr[1]+='0';
	}
	fltArr[0] = AddGroupingSymbol(fltArr[0]);
	fltStr = fltArr.join('.');
	return fltStr;
}
function AddGroupingSymbol(number) {
	// AddGroupingSymbol will add the system defined grouping symbol when passed in to
	// the integer part of the number (decimal part must NOT be passed). The group
	// length is fixed to 3. We may need to add a new system param if we run into
	// sites which group by 2.
	number = '' + number;
	if (number.length > 3) {
		var mod = number.length % 3;
		var output = (mod > 0 ? (number.substring(0,mod)) : '');
		for (i=0 ; i < Math.floor(number.length / 3); i++) {
			if ((mod == 0) && (i == 0)) {
				output += number.substring(mod+ 3 * i, mod + 3 * i + 3);
			} else {
				output+= ',' + number.substring(mod + 3 * i, mod + 3 * i + 3);
			}
		}
		if (output.substring(0,2)=='-,') {
			output='-'+output.substring(2,output.length);
		}
		return (output);
	} else { 
		return number;
	}
}


document.body.onload=DocumentLoadHandler;
document.body.onunload=DocumentUnloadHandler;

