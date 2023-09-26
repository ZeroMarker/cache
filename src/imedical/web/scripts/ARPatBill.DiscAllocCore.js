// Copyright (c) 2004 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var objOrderItem = document.getElementById("OrderItem");
var objBillGroup = document.getElementById("BillingGroup");
var objBillSubGroup = document.getElementById("BillingSubGroup");
var objGroupType = document.getElementById("GroupType");

//a common functions shared by ARPatBill.DiscAllocByPercent and ARPatBill.DiscAllocByAmount

function CoreLoadHandler() {

	var GroupType=document.getElementById("GroupType").value;
	if (GroupType=="I") objOrderItem.checked = true;
	if (GroupType=="G") objBillGroup.checked = true;
	if (GroupType=="S") objBillSubGroup.checked = true;

	if (objOrderItem)	objOrderItem.onclick = GroupByListener;
	if (objBillGroup) objBillGroup.onclick = GroupByListener;
	if (objBillSubGroup) objBillSubGroup.onclick = GroupByListener;
}

function UpdateDisable(evt) {
	var el = websys_getSrcElement(evt);

	if (el.disabled||el.id=="") return false;

	return true;
}

function GroupByListener(evt) {

	var el = websys_getSrcElement(evt);

	if (el.id=="OrderItem" && objGroupType.value=="I") return false;
	if (el.id=="BillingGroup" && objGroupType.value=="G") return false;
	if (el.id=="BillingSubGroup" && objGroupType.value=="S") return false;

	var allocExists=tkMakeServerCall("web.ARPatBillDiscAlloc","GetGroupType",document.getElementById("BillRowID").value);

	if (allocExists!=""&&!confirm(t["ALLOC_EXISTS"]+"\n"+t["CONTINUE"])) return false;

	var docDiscAlloc;
	if (parent.frames["DiscAlloc"]) docDiscAlloc=parent.frames["DiscAlloc"].document;
	var objGT;
	if (docDiscAlloc) objGT=docDiscAlloc.getElementById("GroupType");

	if (objOrderItem && el==objOrderItem) {
		el.checked = true;
		objGroupType.value="I";
		if (objGT) objGT.value="I";
	} else {
		if (objOrderItem) objOrderItem.checked=false;
	}

	if (objBillGroup && el==objBillGroup) {
		el.checked = true;
		objGroupType.value="G";
		if (objGT) objGT.value="G";
	} else {
		if (objBillGroup) objBillGroup.checked=false;
	}

	if (objBillSubGroup && el==objBillSubGroup) {
		el.checked = true;
		objGroupType.value="S";
		if (objGT) objGT.value="S";
	} else {
		if (objBillSubGroup) objBillSubGroup.checked=false;
	}

	Reload(); //call method in either ARPatBill.DiscAllocByPercent.js or ARPatBill.DiscAllocByAmount.js
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


function getPayAllocID(){
	
	var tbl = document.getElementById("tARPatBill_DiscAlloc");
	
	var retStr = "";
	for(i=0; i<tbl.rows.length; i++) {
		var obj = document.getElementById("PayAllocIDz"+(i+1));
		retStr+=obj.value;
	}
	
	return retStr;
}
