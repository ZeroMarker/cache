// Copyright (c) 2006 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var objPercent   = document.getElementById("ByPercentage");
var objAmt       = document.getElementById("ByAmount");
var objPercentCB = document.getElementById("PercentCheckBox");
var objAmountCB  = document.getElementById("AmountCheckBox");


function DefaultHandler() {

	var allocMethod = document.getElementById("AllocMethod").value;

	if (allocMethod=="P") objPercentCB.checked=true;
	if (allocMethod=="A") objAmountCB.checked=true;
	
	if (objPercent) objPercent.onblur= PercentageChangeHandler;
	if (objAmt) objAmt.onblur= AmountChangeHandler;

	if (objPercentCB) {
		objPercentCB.onclick = AllocateByCheckboxListener;
		if (objPercentCB.checked) {
			disableById("ByAmount");
			enableById("ByPercentage");
			websys_setfocus("ByPercentage");
		}
	}

	if (objAmountCB) {
		objAmountCB.onclick = AllocateByCheckboxListener;
		if (objAmountCB.checked) {
			disableById("ByPercentage");
			enableById("ByAmount");
			websys_setfocus("ByAmount");
		}
	}
}

function AllocateByCheckboxListener(evt) {

	var el = websys_getSrcElement(evt);
	
	var GroupType=document.getElementById("GroupType").value;

	if (objPercentCB && el==objPercentCB) {
		objPercentCB.checked=true;
		if (objAmountCB) objAmountCB.checked = false;
		clearById("ByAmount");
		disableById("ByAmount");
		enableById("ByPercentage");

		objPercent.value=tkMakeServerCall("web.ARPatBillDiscAlloc","GetAllocPercentage",document.getElementById("BillRowID").value);

		var url = "websys.default.csp?WEBSYS.TCOMPONENT=ARPatBill.DiscAllocByPercent&GroupType="+GroupType+"&CONTEXT="+session['CONTEXT'];
		document.fARPatBill_DiscAllocSelector.target="DiscAllocList";
		document.fARPatBill_DiscAllocSelector.action=url;
		document.fARPatBill_DiscAllocSelector.submit();		
	}
	if (objAmountCB && el==objAmountCB) {
		objAmountCB.checked=true;
		if (objPercentCB) objPercentCB.checked = false;
		clearById("ByPercentage");
		disableById("ByPercentage");
		enableById("ByAmount");
		
		var url = "websys.default.csp?WEBSYS.TCOMPONENT=ARPatBill.DiscAllocByAmount&GroupType="+GroupType+"&CONTEXT="+session['CONTEXT'];
		document.fARPatBill_DiscAllocSelector.target="DiscAllocList";
		document.fARPatBill_DiscAllocSelector.action=url;
		document.fARPatBill_DiscAllocSelector.submit();
	}
}

function PercentageChangeHandler(e) {

	if (evtTimer) {
		setTimeout("PercentageChangeHandler()",300);
	} else {

		var valid=ByPercentage_changehandler(e);

		if (valid==false) return websys_cancel(); //don't change it to !valid, it's not gonna work

		clearById("ByAmount");

		var objPercent = websys_getSrcElement(e);
	
		if (!ValidatePercent(objPercent)){
			alert(t['INV_PERCENT']);
			websys_setfocus(objPercent);
			return false;
		}
	}
	return true;
}

function ValidatePercent(element) {

	if (!element) return false;
		
	var elemValInt = parseInt(element.value);	
	if ((elemValInt < 0) || (elemValInt > 100)) return false;
	
	return true;
}

function AmountChangeHandler(e) {

	var valid=ByAmount_changehandler(e);
	if (valid==false) return websys_cancel(); //don't change it to !valid, it's not gonna work

	clearById("ByPercentage");
	
	var winDiscAlloc;
	if (parent.frames["DiscAllocList"]) winDiscAlloc = parent.frames["DiscAllocList"].window;
	try {
		//call function on ARPatBill.DiscAllocByAmount.js
		if (winDiscAlloc) winDiscAlloc.CalculateRemainAmount();

	} catch(e) { alert("Error in AmountChangeHandler: " + e.message); }
}

function clearById(idIn) {
	var obj = document.getElementById(idIn);	
	if (obj) obj.value = "";
}

function disableById(idIn) {
	var obj = document.getElementById(idIn);
	
	if (obj) {
		obj.disabled=true;
		obj.className = "disabledField";
	}
}

function enableById(idIn) {
	var obj = document.getElementById(idIn);
	
	if (obj) {
		obj.disabled=false;
		obj.className = "";
	}
	
	return true;
}

document.body.onload=DefaultHandler;


