// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var objStartDate=document.getElementById("StartDate");
var objEndDate=document.getElementById("EndDate");


function BodyLoadHandler() {
	if (objStartDate) objStartDate.onchange=DateChangeHandler;
	if (objEndDate) objEndDate.onchange=DateChangeHandler;
	
	var objFind=document.getElementById('find1');
	if (objFind) objFind.onclick=Find;
	if (tsc['find1']) websys_sckeys[tsc['find1']]=Find;
}	


function DateChangeHandler(evt) {

	var src = websys_getSrcElement(evt);
	if (src.id=="StartDate")
		StartDate_changehandler();
	else if (src.id=="EndDate")
		EndDate_changehandler();
	
	if (!FutureDateCheck(src.id))	websys_setfocus(src.id);
}

function FutureDateCheck(objName) {

	var obj=document.getElementById(objName);
	if (obj) {
		if (obj.value!="") {	
			if (DateStringCompareToday(obj.value)==1) {
				alert(t['FUTURE_DATE_INVALID']);
				obj.className="clsInvalid";
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

function CheckDateRange() {	
	
	if ((objStartDate)&&(objEndDate)&&(objStartDate.value!="")&&(objEndDate.value!="")) {
		if (DateStringCompare(objStartDate.value,objEndDate.value)==1) {
			alert(t['DATE_RANGE_INVALID']);
			objStartDate.className="clsInvalid";
			websys_setfocus("StartDate");
			return false;
		}	
	}	
	return true;
}


function Find() {

	
	var objData=document.getElementById('Flags');
	var arrData=new Array(2);
	
	var obj=document.getElementById('UniqReturn');
	if ((obj)&&(obj.checked)) {arrData[0]="Y"} else {arrData[0]="N"}
	var obj=document.getElementById('NoAction');
	if ((obj)&&(obj.checked)) {arrData[1]="Y"} else {arrData[1]="N"}
	objData.value=arrData.join("^");
	
	if (!(CheckDateRange())) return false;

	if (!(FutureDateCheck("StartDate"))) return false;
	if (!(FutureDateCheck("EndDate"))) return false;
	
	return find1_click();
	
}

function PAADMTypeLookupSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('AdmType');
	if (obj) obj.value=lu[2];
}


document.body.onload=BodyLoadHandler;
