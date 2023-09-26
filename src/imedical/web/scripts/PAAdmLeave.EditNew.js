// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
// ab 12.12.02

function BodyLoadHandler() {
	var objLink=document.getElementById("lnkPATempAddress");
	var obj=document.getElementById("BoldAddr");
	if ((objLink)&&(obj)) {
		if (obj.value==1) {
			objLink.style.fontWeight="bold"
		} else {
			objLink.style.fontWeight="";
		}
	}
	
	var objCat=document.getElementById("LEACATDesc")
	if (objCat) objCat.onblur=LEACATDescBlurHandler;	

	var obj=document.getElementById("ADMLGoingOutDate");
	if (obj) obj.onblur=StartDateBlurHandler;
	
	var obj=document.getElementById("ADMLActualDateReturn");
	if (obj) obj.onblur=ADMLDateBlurHandler;
}

function LEATYPDescLookupSelect() {
}


//function LEATYPDescLookupSelect() {
//}
//md
function LEACATDescLookupSelect(str) {
	var lu=str.split("^");
	
	var objCode=document.getElementById("LEACATCode");
	if (objCode) objCode.value=lu[2];
	//alert(lu[2]);
	return true;
}

function  LEACATDescBlurHandler() {
	var objCode=document.getElementById("LEACATCode");
	var obj=document.getElementById("LEACATDesc");
	if ((obj)&&(obj.value=="")) {
		if (objCode) objCode.value="";
		}
}

function StartDateBlurHandler(e) {
	var eobj=websys_getSrcElement(e);
	if (eobj) {
		var obj=document.getElementById("ADMLGoingOutDateH");
		if ((obj)&&(eobj.value!="")) obj.value=DateStringTo$H(eobj.value);
		if ((obj)&&(eobj.value=="")) obj.value=obj.defaultValue;
	}
	ADMLDateBlurHandler(e);
}

// ab 2.08.04 - 44234 - use end date, or start date, or today for validation
function ADMLDateBlurHandler() {
	var objStart=document.getElementById("ADMLGoingOutDate");
	var objEnd=document.getElementById("ADMLActualDateReturn");
	var DateToday=document.getElementById('DateToday').value;
	var DateToday2=document.getElementById('DateToday2').value;
	var objCT=document.getElementById("CTDate");
	var objCT2=document.getElementById("CTDate2");
	
	if ((objStart)&&(objEnd)&&(objCT)&&(objCT2)) {
		if (objEnd.value!="") {
			objCT.value=DateStringTo$H(objEnd.value);
			objCT2.value=objEnd.value;
		} else {
			if (objStart.value!="") {
				objCT.value=DateStringTo$H(objStart.value);
				objCT2.value=objStart.value;
			} else {
				objCT.value=DateToday;
				objCT2.value=DateToday2;
			}
		}
	}
	
}

document.body.onload=BodyLoadHandler;
