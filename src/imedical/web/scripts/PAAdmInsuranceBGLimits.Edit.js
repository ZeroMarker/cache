// Copyright (c) 2004 TrakHealth Pty Limited. ALL RIGHTS RESERVED.


function BodyLoadHandler() {

	var obj = document.getElementById("LIMQty");
	if (obj) obj.onchange = NumberFieldChangeHandler;
	obj = document.getElementById("LIMQtyUsed");
	if (obj) obj.onchange = NumberFieldChangeHandler;
	obj = document.getElementById("LIMMaxCoverage");
	if (obj) obj.onchange = NumberFieldChangeHandler;
	obj = document.getElementById("LIMMaxCoverageUsed");
	if (obj) obj.onchange = NumberFieldChangeHandler;
	obj = document.getElementById("LIMPayorPercent");
	if (obj) obj.onchange = NumberFieldChangeHandler;
	obj = document.getElementById("LIMMaxDailyAmount");
	if (obj) obj.onchange = NumberFieldChangeHandler;
}

//Log 62310 - 05.02.2007  - get the OrderItemID from look up return values
function OrderItemLookupSelect(txt) { 
	var ItemData=txt.split("^");
	var ItemId=ItemData[1];
	var obj=document.getElementById("OrderItmId");
	if (obj) obj.value=ItemId;
}

function NumberFieldChangeHandler(evt) {

	var el = websys_getSrcElement(evt);

	if (el.id == "LIMQty") {
		LIMQty_changehandler();
	}
	else if (el.id == "LIMQtyUsed") {
		LIMQtyUsed_changehandler();
	}
	else if (el.id == "LIMMaxCoverage") {
		LIMMaxCoverage_changehandler();
	}
	else if (el.id == "LIMMaxCoverageUsed") {
		LIMMaxCoverageUsed_changehandler();
	}
	else if (el.id == "LIMPayorPercent") {
		LIMPayorPercent_changehandler();
	}
	else if (el.id == "LIMMaxDailyAmount") {
		LIMMaxDailyAmount_changehandler();
	}

	if (el.className!="clsInvalid") ValidateNumber(el);
}

function ValidateNumber(obj) {

	if (obj) {
		if (obj.value!="") {
			if ((obj.id=="LIMMaxDailyAmount"||obj.id == "LIMPayorPercent"||obj.id == "LIMMaxCoverage") && parseFloat(obj.value) < 0) {
				alert(t[obj.id] + " " + t['GREATER_EQUAL']); //should be greater than or equal to 0
				obj.className="clsInvalid";
				websys_setfocus(obj.id);
				return false;
			}
			else if (obj.id != "LIMMaxDailyAmount" && obj.id != "LIMPayorPercent" && obj.id != "LIMMaxCoverage" && parseFloat(obj.value) <= 0) {
				alert(t[obj.id] + " " + t['GREATER']);  //should be greater than 0
				obj.className="clsInvalid";
				websys_setfocus(obj.id);
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

document.body.onload=BodyLoadHandler;