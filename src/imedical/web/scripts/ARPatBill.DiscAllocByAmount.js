// Copyright (c) 2006 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var objRemAmt=document.getElementById("RemainAmt");
var btnUpdate = document.getElementById("Update");

//Log 62387 - 30.01.2007 - Get values of Used and Remaining amounts of the total discount allocation
var objRemHid=document.getElementById("HiddenRem");
var objUsedHid=document.getElementById("HiddenUsed");

function BodyLoadHandler() {
	
	CoreLoadHandler(); //method in ARPatBill.DiscAllocCore.js

	var tbl = document.getElementById("tARPatBill_DiscAllocByAmount");
	for (i = 1; i<tbl.rows.length; i++) {
		var rowElem = document.getElementById("DiscAmountz"+i);
		if (rowElem) rowElem.onchange= ValidateAmount;
	}

	var docAlloc; var objByAmt;
	if (parent.frames["DiscAlloc"]) docAlloc = parent.frames["DiscAlloc"].document;
	if (docAlloc) objByAmt=docAlloc.getElementById("ByAmount");

	var obj=document.getElementById("DiscAmountz1");
	if (obj&&objByAmt&&objByAmt.value!="") {
		obj.focus();
		obj.select();
	}

	//Log 62387 - 30.01.2007 - do not disable the "Update" button anymore
	if (btnUpdate) {
		btnUpdate.onclick = UpdateClickHandler;
	}
	/*if (btnUpdate) {
		btnUpdate.onclick = UpdateDisable;
		btnUpdate.disabled=true;
	}*/
	//End Log 62387

	if (objByAmt&&objRemAmt) CalculateRemainAmount();
	if (objRemAmt) objRemAmt.disabled=true;	
}

function Reload() {
	
	var url = "websys.default.csp?WEBSYS.TCOMPONENT=ARPatBill.DiscAllocByAmount&ClearAlloc=Y&CONTEXT="+session['CONTEXT'];

	document.getElementById("PatientBanner").value=""; //no patient banner

	document.fARPatBill_DiscAllocByAmount.target="DiscAllocList";
	document.fARPatBill_DiscAllocByAmount.action=url;
	document.fARPatBill_DiscAllocByAmount.submit();
}

function ValidateAmount(evt) {
	var valid = DiscAmount_changehandler(evt);
	if (valid==false) return websys_cancel();
	
	var tbl = document.getElementById("tARPatBill_DiscAllocByAmount");
	if (tbl==null) { alert("no table found"); return 0; }
	
	var sum = 0;
	var eSrc=websys_getSrcElement(evt);
	// Log 62387 - 02.02.2007 
	var rowObj=getRow(eSrc);
	var selRow=rowObj.rowIndex;
	
	var usedAmt=0;
	var oldtmpDisc="";
	
	if (objUsedHid) usedAmt=parseFloat(MedtrakCurrToJSMath(objUsedHid.value));
	
	var objDiscHid=document.getElementById("DiscAmtOldz"+selRow);
	var objDisc=document.getElementById("DiscAmountz"+selRow);
	var objDiscTmp=document.getElementById("DiscAmtTmpz"+selRow);

	var billAmtRow = document.getElementById("BilledAmountz"+selRow);
	if (billAmtRow) {
		if (billAmtRow.innerHTML) {
			var discAmt= parseFloat(MedtrakCurrToJSMath(objDisc.value));
			if (discAmt>parseFloat(MedtrakCurrToJSMath(billAmtRow.innerHTML))) {
				alert(t['DISC_AMT_CANTBE_GREATER_THAN'] + " " + billAmtRow.innerHTML);
				websys_setfocus(eSrc.id);
				eSrc.value="";
				return false;
			}
		}
	}
	else {
		alert("Billed Amount Column must be configured on the screen");
		return false;
	}
	if ((objDiscTmp)&&(objDisc)) {
		if (parseFloat(MedtrakCurrToJSMath(objDiscTmp.value))!=parseFloat(MedtrakCurrToJSMath(objDisc.value))) {
			if (!isNaN(objDiscTmp.value)) oldtmpDisc=parseFloat(MedtrakCurrToJSMath(objDiscTmp.value));
			else  oldtmpDisc="";
			objDiscTmp.value=objDisc.value;
		}
		else {
			oldtmpDisc="NA";
		}	
	} 
	else {
		alert("Discount Amount Column must be configured on the screen");
		return false;
	}	
	
	if ((objDiscHid)&&(objDisc)) {
		discAmtOld= parseFloat(MedtrakCurrToJSMath(objDiscHid.value));
		//Log 64846 - 13.09.2007 - removed any group separatorsfrom objDisc.value
		if (!isNaN(parseFloat(MedtrakCurrToJSMath(objDisc.value)))) discAmtNew= parseFloat(MedtrakCurrToJSMath(objDisc.value));
		else discAmtNew=0;
	}
	
	if (discAmtOld!=0) {
		if (discAmtOld!=discAmtNew) {
			if (usedAmt!=0) {usedAmt=(usedAmt-discAmtOld)+discAmtNew;}
		}
	} else {
		if (oldtmpDisc=="NA") {
			if (parseFloat(MedtrakCurrToJSMath(objDiscTmp.value))!=parseFloat(MedtrakCurrToJSMath(objDisc.value))) {
				usedAmt=usedAmt+discAmtNew;
				objUsedHid.value=usedAmt;
			}	
		}
		else {
			usedAmt=(usedAmt-oldtmpDisc)+discAmtNew;
			objUsedHid.value=usedAmt;
		}	
	}
	//End Log 62387
	

	var docDiscAlloc;
	if (parent.frames["DiscAlloc"]) docDiscAlloc = parent.frames["DiscAlloc"].document;
	if (docDiscAlloc==null) return;

	var discAmount = MedtrakCurrToJSMath(docDiscAlloc.getElementById("ByAmount").value);
	
	// Log 62387 - 30.01.2007 - calculate the correct amounts
	
	if (objRemAmt) objRemAmt.value = CurrencyRound(discAmount-usedAmt);
	if (objRemHid) objRemHid.value = objRemAmt.value;
		
	if (sum==discAmount) {
		if (btnUpdate) {
			btnUpdate.disabled=false;
			btnUpdate.onclick = UpdateClickHandler;
		}
	}
	/*else {
		if (btnUpdate) {
			btnUpdate.onclick = UpdateDisable;
			btnUpdate.disabled=true;
		}
	}*/
	// End Log 62387
	return true;
}

function CalculateRemainAmount() {
	var tbl = document.getElementById("tARPatBill_DiscAllocByAmount");
	if (tbl==null) { alert("no table found"); return; }

	var sum=0;
	for (i = 1; i<tbl.rows.length; i++) {
		var discAmt=0;
		var rowElem = document.getElementById("DiscAmountz"+i);
		if (rowElem) {
			if (rowElem.value) {
				discAmt= parseFloat(MedtrakCurrToJSMath(rowElem.value));
				sum += discAmt;
			}
		}
	}

	var docDiscAlloc;
	if (parent.frames["DiscAlloc"]) docDiscAlloc = parent.frames["DiscAlloc"].document;
	if (docDiscAlloc==null) return;

	var objbyamt = docDiscAlloc.getElementById("ByAmount");
	var discAmount = MedtrakCurrToJSMath(objbyamt.value);
	
	// Log 62387 - 30.01.2007 - calculate the correct amounts
	var usedAmt=0;
	if (objUsedHid) usedAmt=parseFloat(MedtrakCurrToJSMath(objUsedHid.value));
	
	if (usedAmt=="") {
		if (objRemAmt) objRemAmt.value = CurrencyRound(discAmount-sum);
	} else {	
		if (objRemAmt) objRemAmt.value = CurrencyRound(discAmount-usedAmt);
	}	
	if (objRemHid) objRemHid.value = objRemAmt.value;
	
	/*if (objbyamt.value=="") {
		if (btnUpdate) {
			btnUpdate.onclick = UpdateDisable;
			btnUpdate.disabled=true;
		}
	}
	else if (sum==discAmount) {*/
	// End Log 62387 	

	if (sum==discAmount) {
		if (btnUpdate) {
			btnUpdate.disabled=false;
			btnUpdate.onclick = UpdateClickHandler;
			return;
		}
	}
}


function UpdateClickHandler() {
	
	var tbl = document.getElementById("tARPatBill_DiscAllocByAmount");
	var obj = document.getElementById("DiscAllocRowIDs");
	
	for (i = 1; i<tbl.rows.length; i++) {
		obj.value += document.getElementById("SubRowsz"+i).value + "^";
	}
	
	document.fARPatBill_DiscAllocByAmount.target="_parent";

	return Update_click(); // default call
}

document.body.onload=BodyLoadHandler;
