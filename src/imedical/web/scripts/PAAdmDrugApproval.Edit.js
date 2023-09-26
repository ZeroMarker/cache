//Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function DrugLookUpSelect(txt) {
	//Add an item to lstOrders when an item is selected from
	//the Lookup, then clears the Item text field.	
	var adata=txt.split("^");
	var obj=document.getElementById("ARCIMPHCDFDR");
	if (obj) obj.value=adata[2];

}
