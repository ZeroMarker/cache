// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function BodyLoadHandler() {
	var UOBJ=document.getElementById("Update");
	if(UOBJ) UOBJ.onclick=UpdateClickHandler;
}

function UpdateClickHandler() {	
	var ListObj=document.getElementById("MealType");
	var RtnArr= new Array();
	var InsertStr="";
	if(ListObj) RtnArr=getSelectedListItems(ListObj);
	InsertStr=RtnArr.join("^");
	var ISObj=document.getElementById("MealTypeStr");
	if (ISObj) ISObj.value=InsertStr;
	
	return Update_click();
}

function getSelectedListItems(listBox)
{
	var selArr = new Array();
	var count = 0;
	for (var i = 0; i < listBox.length; i++) {
		if(listBox.options[i].selected) {
			selArr[count] = listBox.options[i].text;
			count++;
		}
	}
	return selArr;
}

function mPiece(s1,sep,n) {
	delimArray = s1.split(sep);	
	if ((n <= delimArray.length-1) && (n >= 0)) {
        return delimArray[n];
    }
}

document.body.onload = BodyLoadHandler;

