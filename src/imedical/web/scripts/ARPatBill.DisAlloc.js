// Copyright (c) 2004 TrakHealth Pty Limited. ALL RIGHTS RESERVED.


// Setup is established HERE

/* 
   checkBoxClickers is an array of objects pointing to each of the
   checkbox variables
 */
var checkBoxClickers = new Array(3);
checkBoxClickers[0] = document.getElementById("OrderItem");
checkBoxClickers[0].value = "I";
checkBoxClickers[1] = document.getElementById("BillingGroup");
checkBoxClickers[1].value = "G";
checkBoxClickers[2] = document.getElementById("BillingSubGroup");
checkBoxClickers[2].value = "S";

var checkedBox = checkBoxClickers[0];

if (document.getElementById("GroupType")) {
	checkedBox = document.getElementById("GroupType");
}

// This is a gobal variable which is used to point to the sum a column in a table
var totalAllowedValue = 0; 

/*
  This is an array to point to every error which must be picked up
  upon completion (by clicking "update")
 */
var errorArray = new Array(3);
errorArray[0] = false; // Update by Percentage
errorArray[1] = false; // Update by Summation
errorArray[2] = false; // Total checksum error


// Page load constructor
function BodyLoadHandler() {	
	var pbobj=document.getElementById("ByPercentBox");
	if (pbobj){
		//pbobj.focus = byPercentBox_OnClick;
		//pbobj.onblur  = byPercentBox_OnBlur;
		//pbobj.onchange= updateFinalCheck;
		
		/** 
			Version revised -
			This now ONLY changes on a change to the text.
		**/
		pbobj.onchange = byPercentBox_OnChange;
	}
	
	var atobj = document.getElementById("ByAmountText");
	if (atobj){
		//atobj.focus = byAmountText_OnClick;
		//atobj.onblur  = byAmountText_OnBlur;
		//atobj.onchange= updateFinalCheck;
		
		/** 
			Version revised -
			This now ONLY changes on a change to the text.
		**/

		atobj.onchange= byAmountText_OnChange;
	}
	
	
	// Proceeding to check "Order Item" first off
	// var checkedBox = document.getElementById("OrderItem");
	// checkedBox.checked = true;
	
	var checkerCheckedFlag = false;
	
	for (var i=0; i<checkBoxClickers.length; i++) {
		var objChecker = checkBoxClickers[i];
		
		if (objChecker.value != checkedBox.value) {
			objChecker.checked = false;
		} else {
			objChecker.checked = true;
			checkerCheckedFlag = true;
		}
	}
	
	if (!checkerCheckedFlag) {
		checkBoxClickers[0].checked = true;
	}
	
// Establishing Event Listeners for clickers
	checkBoxClickers[0].onclick = checkClickListener_Event0;
	checkBoxClickers[1].onclick = checkClickListener_Event1;
	checkBoxClickers[2].onclick = checkClickListener_Event2;
	
	var tbl = document.getElementById("tARPatBill_DisAlloc");
	for (i = 1; i<tbl.rows.length; i++) {
		var rowElem = document.getElementById("AllocatePercentagez"+i);
		var nextRowElem = document.getElementById("AllocateAmountz"+i);
		if (rowElem) {
			rowElem.onblur = updateFinalCheck;
		}
		if (nextRowElem) {
			nextRowElem.onblur = updateFinalCheck;
		}
	}
	
	
	// Establish Event Listener for OK/Update Button
	var okBut = document.getElementById("Update");
	okBut.onclick = updateCheck;
	
	updateFinalCheck();
	

	// Clearing the sub cells
	var tbldisable = document.getElementById("tARPatBill_DisAlloc");
	for (i = 1; i<tbl.rows.length; i++) {
		var rowElem = document.getElementById("AllocatePercentagez"+i);	
		if (rowElem) {
			disableById("AllocatePercentagez"+i);
			disableById("AllocateAmountz"+i);
		}
	}
	
	return;
}




// OnClick Functions for Top Boxes
function byPercentBox_OnClick() {
	
	clearById("ByAmountText");
	
	var tableName = document.getElementById("3");
	//tableName.innerText = "Allocate Percentage";
	
	// clearing the sub cells
	var tbl = document.getElementById("tARPatBill_DisAlloc");
	for (i = 1; i<tbl.rows.length; i++) {
		var rowElem = document.getElementById("AllocatePercentagez"+i);	
		if (rowElem) {
			clearById("AllocatePercentagez"+i);
			clearById("AllocateAmountz"+i);
			disableById("AllocateAmountz"+i);
			enableById("AllocatePercentagez"+i);
		}
	}
	
	
	return;
}

function byAmountText_OnClick() {
	clearById("ByPercentBox");
	
	var tableName = document.getElementById("3");
	
	//tableName.innerText = "Allocate Amount";
	
	
	// Clearing the sub cells
	var tbl = document.getElementById("tARPatBill_DisAlloc");
	for (i = 1; i<tbl.rows.length; i++) {
		var rowElem = document.getElementById("AllocatePercentagez"+i);	
		if (rowElem) {
			clearById("AllocatePercentagez"+i);
			clearById("AllocateAmountz"+i);
			disableById("AllocatePercentagez"+i);
			enableById("AllocateAmountz"+i);
		}
	}
	
	return;
}

function byPercentBox_OnBlur() {
	var percBox = document.getElementById("ByPercentBox");
	
	
	if (!NumericValidator(percBox)) {
		clearById("ByPercentBox");
		percBox.focus();
		errorArray[0] = false;
		updateFinalCheck();
		return false;
	}
	
	if (!checkPercent(percBox)){
		alert("The % box must have a percentage less than 100%");
		percBox.focus();
		errorArray[0] = false;
	  updateFinalCheck();
		return false;
	}
	
	totalAllowedValue = percBox.value;
	
	errorArray[0] = true;
	errorArray[1] = true;
	
	updateFinalCheck();
	
	return;
}

function byAmountText_OnBlur() {
	var amtBox = document.getElementById("ByAmountText");
	
	if (!NumericValidator(amtBox)) {
		clearById("ByAmountText");
		amtBox.focus();
		errorArray[1] = false;
		return false;
	}
	

	totalAllowedValue = amtBox.value;
	
	errorArray[0] = true;
	errorArray[1] = true;
	
	updateFinalCheck();
	
	return;
}



// OnChage Listeners
function byAmountText_OnChange() {
	byAmountText_OnClick();
	byAmountText_OnBlur();
	return;
}

function byPercentBox_OnChange() {
	byPercentBox_OnClick();
	byPercentBox_OnBlur();
	return;
}



// CheckBox Event Listeners
function checkClickListener_Event(input) {
	
	for(i=0;i<checkBoxClickers.length; i++) {
		checkBoxClickers[i].checked = false;
	}
	
	checkBoxClickers[input].checked = true;
	
	return;
}

function checkClickListener_Event0() {
	checkClickListener_Event(0);
	checkedBox = "I";
	ChangeAllocationGrouping();
	return;
}

function checkClickListener_Event1() {
	checkClickListener_Event(1);
	checkedBox = "G";
	ChangeAllocationGrouping();
	return;
}

function checkClickListener_Event2() {
	checkClickListener_Event(2);
	checkedBox = "S";
	ChangeAllocationGrouping();
	return;
}




// Percentage Event Listeners
// Function made deprecated
function percCellListener_OnBlur() {
	var total = sumEndColumn();
	
	var retVal = false;
	
	if (total > totalAllowedValue) {
		//alert("The total allocated is greater than what is allowed");
		retVal = false;
	} else {
		retVal = true;
	}
	
	errorArray[2] = retVal;
	
	updateFinalCheck();
	
	return retVal;
}


// Checksum
function checkSum() {
	var total = sumEndColumn();
	var total2 = sumEndColumn2();

	if (total2 >= total) {
		total = total2;
	}
	
	
	var retVal = false;
	
	
	if (total > totalAllowedValue) {
		retVal = false;
	} else {
		retVal = true;
	}
	
	errorArray[2] = retVal;
	
	return retVal;
}





// Validators
function checkPercent(element) {

	if (!element)
		return false;
	
	
	var retVal = false;
	var elemValInt = parseInt(element.value);
	
	if ( elemValInt > 100) {
		retVal = false;
	}
	else {
		retVal = true;
	}
		
	return retVal;
}

function NumericValidator(element) {
	
	if (!element)
		return false;
	
	var val = element.value;
	
	if (IsFloat(val)) {
		return true;
	}
	else {
		alert("This field MUST be a number");
		return false;
	}
}

function updateFinalCheck() {
	
	// This will check the summation errors if encountered
	checkSum();
	
	var updateLabel = document.getElementById("Update");
	for(i=0;i<errorArray.length;i++) {
		if (!errorArray[i]) {
			
			updateLabel.disabled = true;
			
			return;
		}
	}
	
	var pbobj=document.getElementById("ByPercentBox");
	var mntobj=document.getElementById("ByAmountText");
	
	if (!(pbobj.value || mntobj.value)) {
		updateLabel.disabled = true;
		
		return;
	}
		
	
	updateLabel.disabled = false;
}


function updateCheck() {
	
	var retVal = false;
	
	for (i=0;i<errorArray.length;i++) {
		if (!errorArray[i]) {

		        switch(i)
        		{
			        case 0:   alert("By Percentage has been filled in incorrectly\nPlease fill the form again and retry"); break
			        case 1:   alert("By Amount has been filled incorrectly\nPlease fill the form again and retry"); break
			        case 2:   alert("The sum of the amounts allocated to each individual item is greater than that allowed\nPlease fill the form again and retry"); break
				default :   alert("You have not submitted this form properly\n" +
					  "Please fill the form again and retry ERROR: "+i);        
		        }
			retVal=false;
			break;
		}else {
			retVal = true;
		}
	}
	
	if (retVal) {
		concatSubRowsIntoRowsConcat();
		return Update_click(); // default call
	} else {
		return false;
	}
}



// Random Helpers
function sumEndColumn() {
	
	var tbl = document.getElementById("tARPatBill_DisAlloc");
	
	var sum = 0;
	
	for (i = 1; i<tbl.rows.length; i++) {
		var rowElem = document.getElementById("AllocatePercentagez"+i);
		
		if (!(IsFloat(rowElem.value))) {
			alert("A non-numeric value has been inserted and will not be considered");
			rowElem.value = "";
		}
		
		if (rowElem && IsFloat(rowElem.value) && rowElem.value) {
			sum += parseFloat(rowElem.value);
		}
	}
	return sum;
}

function sumEndColumn2() {
	
	var tbl = document.getElementById("tARPatBill_DisAlloc");
	
	var sum = 0;
	
	for (i = 1; i<tbl.rows.length; i++) {
		var rowElem = document.getElementById("AllocateAmountz"+i);
		
		if (!(IsFloat(rowElem.value))) {
			alert("A non-numeric value has been inserted and will not be considered");
			rowElem.value = "";
		}
		
		if (rowElem && IsFloat(rowElem.value) && rowElem.value) {
			sum += parseFloat(rowElem.value);
		}
	}
	return sum;
}
	



// Clearing Function
function clearById(idIn) {
	var obj = document.getElementById(idIn);
	
	if (obj == null) return false;
	
	obj.value = "";
	
	return true;
}




// Disablers
function disableById(idIn) {
	var obj = document.getElementById(idIn);
	
	if (obj == null) return false;
	
	obj.disabled=true;
	
	return true;
}

// Enablers
function enableById(idIn) {
	var obj = document.getElementById(idIn);
	
	if (obj == null) return false;
	
	obj.disabled=false;
	
	return true;
}

function concatSubRowsIntoRowsConcat() {
	var objPtr = null;
	
	var tbl = document.getElementById("tARPatBill_DisAlloc");
	var rowsConcat = document.getElementById("rowsConcat");
	
	for (i = 1; i<tbl.rows.length; i++) {
		objPtr = document.getElementById("SubRowsz"+i);
		rowsConcat.value+= "^"+objPtr.value;
	}
	
	return;
}


// GOOD FUNCTION TO IMPORT ELSEWHERE
function IsFloat(s) {
	for (var i = 0; i < s.length; i++) {
		var c = s.charAt(i);
		if (!((c >= "0") && (c <= "9") || (c == "."))) {
			return false;
		}
	}
	return true;
}



/** Copied from ARReceipts.ListPayAlloc.js **/
function ChangeAllocationGrouping() {

	// SA: For now (ie. QH only), only Grouptype "I" will be used. When S and G are implemented,
	// method web.ARPatBillPaymAlloc.GetBillGroupType will need to be called to set the default
	// to whatever has been used previously (if a payment allocation has already been made 
	// against this bill), and other options will need to be disabled in DocumentLoadHandler.

	var CONTEXT="";
	var obj=document.getElementById("CONTEXT");
	if (obj) {
		CONTEXT=obj.value;
		//alert("context fixed " + CONTEXT);
	}
	
	var BillRowID="";
	var obj=document.getElementById("BillRowID");
	if (obj) {
		BillRowID=obj.value;
		//alert("BillRowID fixed " + BillRowID);
	}
	
	var CurrentOutstandAmt="";
	var obj=document.getElementById("CurrentOutstandAmt");
	if (obj) {
		CurrentOutstandAmt=obj.value;
		//alert("CurrentOutstandAmt " + CurrentOutstandAmt);
	}

	var GroupType="";
	if (checkedBox) {
		GroupType = checkedBox;
		//alert("group type " + GroupType);
	}

	var PatientID="";
	var obj=document.getElementById("PatientID");
	if (obj) PatientID=obj.value;
	var url = "websys.default.csp?WEBSYS.TCOMPONENT=ARPatBill.DisAlloc&BillRowID="+BillRowID+"&PatientBanner=1&GroupType="+GroupType+"&PatientID="+PatientID;
	//alert(url);
	window.open(url, window.name);
}


function getPayAllocID(){
	
	var tbl = document.getElementById("tARPatBill_DisAlloc");
	
	var retStr = "";
	for(i=0; i<tbl.rows.length; i++) {
		var obj = document.getElementById("PayAllocIDz"+(i+1));
		retStr+=obj.value;
	}
	
	return retStr;
}


document.body.onload=BodyLoadHandler;
