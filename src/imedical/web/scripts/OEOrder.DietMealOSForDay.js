// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function BodyLoadHandler() {
	var tbl=document.getElementById("tOEOrder_DietMealOSForDay");
	if (tbl) {
		for (i=1; i<tbl.rows.length; i++) {
			var obj=document.getElementById("Deletez"+i);
			if(obj) obj.onclick=DeleteClickHandler;

			var Qobj=document.getElementById("Quantityz"+i);
			if(Qobj) Qobj.onchange=QuantityChangeHandler;
		}
	}
	var UObj=document.getElementById("Update");
	if(UObj) UObj.onclick=UpdateClickHandler;
}

function UpdateClickHandler() {
	var ARCIMIDs="";
	SaveItems();

	var OSObj=document.getElementById("ORDERSETID");
	if((OSObj)&&(OSObj.value!="")) ORDERSETID=OSObj.value;

	var MTObj=document.getElementById("MealTypeID");
	if((MTObj)&&(MTObj.value!="")) MealTypeID=MTObj.value;

	var DObj=document.getElementById("Date");
	if((DObj)&&(DObj.value!="")) Date=DObj.value;

	var AObj=document.getElementById("ARCIMIDs");
	if((AObj)&&(AObj.value!="")) ARCIMIDs=AObj.value;

	var IObj=document.getElementById("ItemID");
	if((IObj)&&(IObj.value!="")) ItemID=IObj.value;

	var url="oeorder.dietmealosday.add.csp?ORDERSETID="+ORDERSETID+"&MealTypeID="+MealTypeID+"&Date="+Date+"&ARCIMIDs="+ARCIMIDs+"&ItemID=";
	websys_createWindow(url,'TRAK_hidden');

	var IDObj=document.getElementById("ID");
	if((IDObj)&&(IDObj.value!="")) {
		var AObj=document.getElementById("ARCIMIDs");
		if((AObj)&&(AObj.value!="")) ARCIMIDs=AObj.value;
		var win=window;
		if(win.opener) {
			var CBObj=window.opener.document.getElementById(IDObj.value);
			if(CBObj) {
				if(ARCIMIDs=="") CBObj.checked=false;
				else {CBObj.checked=true;}
			}
		}
	}
	window.setTimeout("return Update_click();",2000);
}

function DeleteClickHandler() {
	SaveItems();
	return;
}

function QuantityChangeHandler() {

	var ORDERSETID="";
	var MealTypeID="";
	var Date="";
	var ARCIMIDs="";
	var ItemID="";
	var ID="";

	SaveItems();

	var OSObj=document.getElementById("ORDERSETID");
	if((OSObj)&&(OSObj.value!="")) ORDERSETID=OSObj.value;

	var MTObj=document.getElementById("MealTypeID");
	if((MTObj)&&(MTObj.value!="")) MealTypeID=MTObj.value;

	var DObj=document.getElementById("Date");
	if((DObj)&&(DObj.value!="")) Date=DObj.value;

	var AObj=document.getElementById("ARCIMIDs");
	if((AObj)&&(AObj.value!="")) ARCIMIDs=AObj.value;

	var IObj=document.getElementById("ItemID");
	if((IObj)&&(IObj.value!="")) ItemID=IObj.value;

	var IDObj=document.getElementById("ID");
	if((IDObj)&&(IDObj.value!="")) ID=IDObj.value;

	var url="oeorder.dietmealosday.add.csp?ORDERSETID="+ORDERSETID+"&MealTypeID="+MealTypeID+"&Date="+Date+"&ARCIMIDs="+ARCIMIDs+"&ItemID="+ItemID+"&ID="+ID;
	//alert(url);
	window.location=url;
	return false;
}

function SaveItems() {
	var ARCIMIDs="";
	var AObj=document.getElementById("ARCIMIDs");
	var tbl=document.getElementById("tOEOrder_DietMealOSForDay");
	if (tbl) {
		for (i=1; i<tbl.rows.length; i++) {
			var obj=document.getElementById("ItemRowidz"+i);
			var Quantity=1;
			var qobj=document.getElementById("Quantityz"+i);
			if((qobj)&&(qobj.value!="")) Quantity=qobj.value;
			if((obj)&&(obj.value!="")) ARCIMIDs=ARCIMIDs+obj.value+"*"+Quantity+"^";
		}
		if(AObj) AObj.value=ARCIMIDs;
	}
	return true;
}

function DietTypeLookupSelect(str) {
	var ORDERSETID="";
	var MealTypeID="";
	var Date="";
	var ARCIMIDs="";
	var ItemID="";
	var ID="";
	var adata=str.split("^");
	var iobj=document.getElementById("Item");
	if(iobj) iobj.value=adata[0];
	var dobj=document.getElementById("ItemID");
	if(dobj) dobj.value=adata[1];
	
	SaveItems();
	
	var OSObj=document.getElementById("ORDERSETID");
	if((OSObj)&&(OSObj.value!="")) ORDERSETID=OSObj.value;

	var MTObj=document.getElementById("MealTypeID");
	if((MTObj)&&(MTObj.value!="")) MealTypeID=MTObj.value;

	var DObj=document.getElementById("Date");
	if((DObj)&&(DObj.value!="")) Date=DObj.value;

	var AObj=document.getElementById("ARCIMIDs");
	if((AObj)&&(AObj.value!="")) ARCIMIDs=AObj.value;

	var IObj=document.getElementById("ItemID");
	if((IObj)&&(IObj.value!="")) ItemID=IObj.value;

	var IDObj=document.getElementById("ID");
	if((IDObj)&&(IDObj.value!="")) ID=IDObj.value;

	var url="oeorder.dietmealosday.add.csp?ORDERSETID="+ORDERSETID+"&MealTypeID="+MealTypeID+"&Date="+Date+"&ARCIMIDs="+ARCIMIDs+"&ItemID="+ItemID+"&ID="+ID;
	//alert(url);
	window.location=url;
	return false;
}

document.body.onload = BodyLoadHandler;

