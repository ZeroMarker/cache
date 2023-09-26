// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
// ab 17.07.06 59776


function BodyLoadHandler() {
	var obj=document.getElementById("RemItems");
	if (obj) obj.onclick=RemoveItems;
	
	var obj=document.getElementById("update1");
	if (obj) {
		obj.onclick=UpdateHandler;
		if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateHandler;
	}
	
	//PopulateOrderList();
	
}

function UpdateHandler() {
	var str=BuildOrderString();
	if (window.opener) window.opener.SetOrder(str);
	return update1_click();
}

/*
function PopulateOrderList() {
	var obj=document.getElementById("OrderList");
	var str=document.getElementById("OrderString");
	if (str) str=str.value;
	if ((obj)&&(str!="")) {
		str=str.split("*");
		for (var i=0; i<str.length; i++) {
			
		}
	}
}
*/

function BuildOrderString() {
	// builds string of order item and order set ID's to pass back to epr.DiagnosisFav.Edit
	var str="";
	var obj=document.getElementById("OrderList");
	if (obj) {
		for (var i=0; i<obj.length; i++) {
			if (str!="") str=str+"*";
			str=str+obj.options[i].value;
		}
	}
	return str;
}

function OrderItemLookup(str) {
	var lu=str.split("^");
		var obj=document.getElementById("OrderList");
		if (obj) {
			if (lu[3]=="ARCIM") AddItemSingle(obj,("ITM"+lu[1]),(t["OrdItem"]+" "+lu[0]));
			if (lu[3]=="ARCOS") {
				// stupid way that they have put order sets in their order item lookup
				code=lu[15].split(String.fromCharCode(12))[0];
				AddItemSingle(obj,("ITM"+code),(t["OrdItem"]+" "+lu[0]));
			}
			
		}
		var obj=document.getElementById("AddOrderItem");
		if (obj) {
			obj.value="";
		}
}

function OrderSetLookup(str) {
	var lu=str.split("^");
		var obj=document.getElementById("OrderList");
		if (obj) AddItemSingle(obj,("SET"+lu[1]),(t["OrdSet"]+" "+lu[0]));
		var obj=document.getElementById("AddOrderSet");
		if (obj) {
			obj.value="";
		}
}

function RemoveItems() {
	var obj=document.getElementById("OrderList");
	ClearSelectedList(obj);
}


document.body.onload = BodyLoadHandler;