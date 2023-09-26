// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function Init() {
	var obj;

	obj=document.getElementById('DeleteItem');
	if (obj) obj.onclick=DeleteItemClickHandler;

	obj=document.getElementById('update1');
	if (obj) obj.onclick=UpdateOrderItems;

}

function RemoveFromList(obj) {
	for (var i=(obj.length-1); i>=0; i--) {
		if (obj.options[i].selected)
			obj.options[i]=null;
	}
}

function UpdateOrderItems() {
	var arrItems = new Array();
	var lst = document.getElementById("OrderItemsList");
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			arrItems[j] =  lst.options[j].value + String.fromCharCode(2) + lst.options[j].text;
		}
		var el = document.getElementById("OrderItemsString");
		if (el) el.value = arrItems.join(String.fromCharCode(1));
		//if (lst.options.length == 0) el.value = ""
		//alert(el.value)
	}
	return update1_click();
}


function DeleteItemClickHandler() {    
	//Delete items from OrderItemsList listbox when a "DeleteItem" button is clicked.
	var obj=document.getElementById("OrderItemsList")
	if (obj)
		RemoveFromList(obj);
	return false;
}

function OrderItemLookUpSelect(txt) {
	//Add an item to OrderItemsList when an item is selected from
	//the Lookup, then clears the Item text field.	
	//alert("Hello");
	var adata=txt.split("^");
	//alert("adata="+adata);
	var obj=document.getElementById("OrderItemsList")

	if (obj) {
		//Need to check if Item already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == String.fromCharCode(2)+adata[1]) {
				alert("Order Item has already been selected");
				var obj=document.getElementById("OrderItem")
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
			alert("Order Item has already been selected");
				var obj=document.getElementById("OrderItem")
				if (obj) obj.value="";
				return;
			}
			//alert(obj.options[i].value+"****"+adata[1])
		}
	}
	AddItemToList(obj,adata[1],adata[0]);

	var obj=document.getElementById("OrderItem")
	if (obj) obj.value="";
	//alert("adata="+adata);
}

function AddItemToList(list,code,desc) {
	//Add an item to a listbox
	//code=String.fromCharCode(2)+code
	list.options[list.options.length] = new Option(desc,code);
}

document.body.onload=Init