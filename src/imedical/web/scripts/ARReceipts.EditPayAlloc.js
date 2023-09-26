// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var objBilledAmt=document.getElementById("BilledAmt");
var objPrevAllocAmt=document.getElementById("PrevAllocAmt");
var objAmtAlloc=document.getElementById("AmtAlloc");
var objAmtRem=document.getElementById("AmtRem");
var objUpdateAlloc=document.getElementById("UpdateAlloc");


function DocumentLoadHandler() {

	if (objUpdateAlloc) objUpdateAlloc.onclick=UpdateAllocClickHandler;

}

function UpdateAllocClickHandler() {

	if ((objBilledAmt)&&(objPrevAllocAmt)&&(objAmtRem)) {
		objAmtRem.value = SubtractCurrencyValues(objBilledAmt.value,objPrevAllocAmt.value,objAmtAlloc.value);

		if (MedtrakCurrToJSMath(objAmtRem.value)<0) {
			alert(t['ALLOC_MORE_BILLED']);
			objAmtAlloc.className="clsInvalid";
			websys_setfocus("AmtAlloc");
			return false;
		}
	}

	UpdateAlloc_click();
}

document.body.onload=DocumentLoadHandler;

