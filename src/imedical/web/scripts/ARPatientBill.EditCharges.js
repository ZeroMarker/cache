// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
//The following functions appear in the generated scripts for this component:
//(as well as all other components which contain fields with data type %Library.Currency)
//CurrencyRound

var objPrice    =document.getElementById("Price");
var objQty      =document.getElementById("Qty");
var objTotal    =document.getElementById("Total");
var objDiscon   =document.getElementById("discontinue");
var objTransDate=document.getElementById("TransDate");
var objEndDate  =document.getElementById("EndDate");
var objItemCode =document.getElementById('ItemCode');
var objItemID   =document.getElementById('ItemID');
var objupdateadd=document.getElementById('updateadd');
var objSundryID =document.getElementById('SundryID');
var objEpisodeID=document.getElementById('EpisodeID');
var objCTLocDesc=document.getElementById("CTLocDesc");
var objCTLocID  = document.getElementById("CTLocID");

function AddChargesBodyLoadHandler() {
	
	//if (objItemCode)  objItemCode.onchange = ItemCodeChangeHandler;
	if (objItemCode)  objItemCode.onblur = ItemCodeChangeHandler;
	if (objPrice)     objPrice.onchange    = PriceChangeHandler;
	if (objQty)       objQty.onchange      = QtyChangeHandler;
	if (objTransDate) objTransDate.onchange= TransDateChangeHandler;
	if (objEndDate)   objEndDate.onchange  = EndDateChangeHandler; //36748

	if (objDiscon) objDiscon.onclick    = DiscontinueClickHandler;
	if (objupdateadd) objupdateadd.onclick = UpdateAddClickHandler;

	EnableDisableDiscoutinue();
}

function PriceChangeHandler(){
	Price_changehandler();
	CalculateTotal();
}

function ItemCodeChangeHandler(evt) {
		

	if (objItemCode) {
		//if (objItemCode="" || (objItemCode.classname="clsInvalid")) {
		if (objItemCode.value=="") {
			if (objPrice) objPrice.value = CurrencyRound("0");

			if (objCTLocDesc) objCTLocDesc.value="";
			if (objCTLocID) objCTLocID.value="";
		}
	}
	CalculateTotal(evt);
}

function ItemCodeLookupHandler(str) {
	//alert(str);
	var lu = str.split("^");

	if (objItemCode && lu[0]) objItemCode.value=lu[0];
	if (objItemID && lu[1])   objItemID.value=lu[1];
	if (objPrice && lu[2])    objPrice.value=lu[2];
	//ItemCodeChangeHandler();
	CalculateTotal();

	//56998
	objItemID.onclick=objItemID.onchange;
	objItemID.click();
}

function ItemID_changehandler(encmeth) {
	//56998
	//calling web.ARPatientBill.GetOrdItemReceivingLocation()
	var val = cspRunServerMethod(encmeth,objItemID.value,objEpisodeID.value);

	val = val.split("^");
	if (val[0]) objCTLocID.value=val[0];
	if (objCTLocDesc && val[1]) objCTLocDesc.value=val[1];
}

function QtyChangeHandler(){

	Qty_changehandler();
	CalculateTotal();
}

function TransDateChangeHandler() {

	TransDate_changehandler();
	FutureDateCheck("TransDate");
}

// SA 30.10.03 - log 37695: Dates entered may not be in the future
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

//AJI 01.03.04 - log 36748: Check end date not older than Trans-date/Start-date.
function EndDateChangeHandler() {
	EndDate_changehandler();
	EndDateCheck();
}

function EndDateCheck() {

	var objEnd =document.getElementById("EndDate");
	var objTrans =document.getElementById("TransDate");

	if (objEnd && objTrans) {
		if (objEnd.value!="" && objTrans.value!="") {			
			if (DateStringCompare(objEnd.value, objTrans.value)>=0) {
				objEnd.className="";
			} else {
				alert(t['END_DATE_INVALID']);
				objEnd.className="clsInvalid";
				return false;
			}
		} else {
			obj.className="";
		}
	}
	return true;
}

function CalculateTotal(){
	if (objPrice && objQty){
		//alert("objPrice.value="+objPrice.value+" objQty.value="+objQty.value);
		if (objPrice.value=="" || objQty.value=="") objTotal.value ="";
		if (objPrice.value!="" && objQty.value!="") {
			//alert("MedtrakCurrToJSMath(objPrice.value)="+MedtrakCurrToJSMath(objPrice.value));
			var tempRes=MedtrakCurrToJSMath(objPrice.value) * objQty.value;
			//alert("MedtrakCurrToJSMath(objPrice.value) * objQty.value="+tempRes);
			tempRes=CurrencyRound(tempRes);
			//alert("CurrencyRound(MedtrakCurrToJSMath(objPrice.value) * objQty.value)="+tempRes);
			objTotal.value = CurrencyRound(MedtrakCurrToJSMath(objPrice.value) * objQty.value);
		}
	}
}

//KK 02/10/03 L:38360
function DiscontinueClickHandler(){
/*	var objReason=document.getElementById("VarianceReason");
	if ((objReason)&&(objReason.value!="")){
		return discontinue_click();
	}else{
		alert(t['REASON_REQ']);
		return false;
	}
*/
	var msg="";
	var objReason=document.getElementById("VarianceReason");
	if ((objReason)&&(objReason.value=="")) msg=t['VAR_REASON_REQ'];
	var objReasonDiscon=document.getElementById("ReasnDiscontinue");
	if ((objReasonDiscon)&&(objReasonDiscon.value=="")) msg=msg + "\n" + t['REASON_REQ'];
	if (msg!=""){
		alert(msg);
		return false;
	}
	return discontinue_click();
}
function EnableDisableDiscoutinue(){
	var objID=document.getElementById("ID");
	if ((objID)&&(objID.value=="")){
		if (objDiscon) {
			objDiscon.disabled=true;
			objDiscon.onclick=LinkDisable;
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

function UpdateAddClickHandler(e) {

	document.fARPatientBill_EditCharges.target="_parent";
	updateadd_click();
}

document.body.onload=AddChargesBodyLoadHandler;

