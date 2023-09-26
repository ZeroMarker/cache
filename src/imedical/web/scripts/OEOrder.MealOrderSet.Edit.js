// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var HPOSObj=document.getElementById("HidPrefOS");

function BodyLoadHandler() {
	var MealOSStr="";	
	var MOSOBJ=document.getElementById("MealOrderSets");
	if(MOSOBJ) MealOSStr=MOSOBJ.value;
	if(MealOSStr!="") AddMealOrderSetToList(MealOSStr);
	var DSOBJ=document.getElementById("Delete");
	if(DSOBJ) DSOBJ.onclick=DeleteClickHandler;
	var UOBJ=document.getElementById("Update");
	if(UOBJ) UOBJ.onclick=UpdateClickHandler;
	MOSObj=document.getElementById("ModifyOS");
	if(MOSObj) MOSObj.onclick=ModifyOSClickHandler;
	SPOSObj=document.getElementById("SetPrefOS");
	if(SPOSObj) SPOSObj.onclick=SetPrefOSHandler;
	var HPOSObj=document.getElementById("HidPrefOS");
	if(HPOSObj) HPOSObj.value="";
}

function SetPrefOSHandler() {
	var ListObj=document.getElementById("OrderSetList");
	var RtnArr= new Array();
	if(ListObj) RtnArr=getHLListItems(ListObj);
	if(RtnArr.length!=1) {
		alert(t['PREF']);
		return false;
	}
	ResetListItemsColor(ListObj);
	SetListItemsColor(ListObj);
	
	return false;
}


function ModifyOSClickHandler() {
	var CONTEXT=session['CONTEXT'];
	var MOSObj=document.getElementById("ModifyOS");
	var ListObj=document.getElementById("OrderSetList");
	var RtnArr= new Array();
	var MealOS="";
	if(MOSObj) {
		if(ListObj) RtnArr=getHLListItems(ListObj);
		if(RtnArr.length!=1) {
			alert(t['ONE_OS']);
			return false;
		}
		MealOS=RtnArr[0];
		var url="websys.default.csp?WEBSYS.TCOMPONENT=ARCOrdSetDateItem.Find&Setid="+MealOS;
		url += "&CONTEXT="+CONTEXT;
		websys_createWindow(url,'');
	}
	return false;
	

}

function UpdateClickHandler() {
	
	var ListObj=document.getElementById("OrderSetList");
	var RtnArr= new Array();
	var InsertStr="";
	if(ListObj) RtnArr=getSelectedListItems(ListObj);
	InsertStr=RtnArr.join("^");
	var ISObj=document.getElementById("InsertOSStr");
	if (ISObj) ISObj.value=InsertStr;

	return Update_click();

}

function AddMealOrderSetToList(MealOSStr) {
	var PrefOS=""
	var ListObj=document.getElementById("OrderSetList");
	var HPOSObj=document.getElementById("HidPrefOS");
	if((HPOSObj)&&(HPOSObj.value!="")) PrefOS=HPOSObj.value;
	var data=MealOSStr.split("^");
	if (ListObj) {
		ListObj.selectedIndex = -1;
		for (var i=0; i<data.length-1; i++) {
			CurrOSStr=data[i];
			ID=mPiece(CurrOSStr,"*",1);
			Desc=mPiece(CurrOSStr,"*",0);
			ListObj.options[ListObj.length] = new Option(Desc,ID);
			if(ID==PrefOS) {
				ListObj.options[ListObj.length-1].style.color="blue";
				HPOSObj.vaule="";
			}
		}
	}
}

function RemoveFromList(f,obj) {
	var deleteString="";
	var itypeLen="";
	for (var i=(obj.length-1); i>=0; i--) {
		if (obj.options[i].selected) {
			obj.options[i]=null;
		}
	}
}

function getSelectedListItems(listBox)
{
	var selArr = new Array();
	var count = 0;
	for (var i = 0; i < listBox.length; i++) {
		selArr[count] = listBox.options[i].value;
		if(listBox.options[i].style.color=="blue") HPOSObj.value=listBox.options[i].value;
		count++;
	}
	return selArr;
}

function getHLListItems(listBox)
{
	var selArr = new Array();
	var count = 0;
	for (var i = 0; i < listBox.length; i++) {
		if(listBox.options[i].selected) {
			selArr[count] = listBox.options[i].value;
			count++;
		}
	}
	return selArr;
}

function SetListItemsColor(listBox)
{
	var selArr = new Array();
	for (var i = 0; i < listBox.length; i++) {
		if(listBox.options[i].selected) {
			listBox.options[i].style.color="blue";
		}
	}
	return selArr;
}

function ResetListItemsColor(listBox)
{
	for (var i = 0; i < listBox.length; i++) {
		listBox.options[i].style.color="";
	}
	return true;
}

function DeleteClickHandler() {
	//Delete items from lstOrders listbox when a "Delete" button is clicked.
	var obj=document.getElementById("OrderSetList")
	if (obj) RemoveFromList("",obj)
}

function mPiece(s1,sep,n) {
	delimArray = s1.split(sep);	
	if ((n <= delimArray.length-1) && (n >= 0)) {
        return delimArray[n];
    }
}

function OrderSetLookUpHandler(str) {
	var desc="";
	var id="";
	var lu = str.split("^");
	if(lu[0]) desc=lu[0];
	if(lu[1]) id=lu[1];

	if((id!="")&&(desc!="")) {
		var obj=document.getElementById("OrderSetList");
		var iobj=document.getElementById("Item");
		if (obj) {
			obj.selectedIndex = -1;
			obj.options[obj.length] = new Option(desc,id);
		}
		if(iobj) iobj.value="";
	}

	
}

document.body.onload = BodyLoadHandler;

