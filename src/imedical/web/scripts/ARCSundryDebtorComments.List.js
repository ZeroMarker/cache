// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

objID=document.getElementById('ID');
objSunID=document.getElementById('SundryID');
objFutureDate=document.getElementById('FutureDate');
objDate=document.getElementById('Date');
objTime=document.getElementById('Time');
objUserName=document.getElementById('UserName');
objComments=document.getElementById('Comments');
objUpdate=document.getElementById('Update');
objAddNewComment=document.getElementById('AddNewComment');
objShortDesc=document.getElementById('ShortDesc');
objOnHold=document.getElementById('OnHold');
objCurrTime=document.getElementById('CurrTime');

function BodyLoadHandler() {
	if (objAddNewComment) objAddNewComment.onclick=SetNewComment;

	//Dates entered may not be in the future
	if (objDate) objDate.onchange=DateChangeHandler;
	if (objUpdate) objUpdate.onclick=UpdateClickHandler;
	if (tsc['Update']) websys_sckeys[tsc['Update']]=UpdateClickHandler;
}

function DateChangeHandler() {
	Date_changehandler();
	//Dates entered may not be in the future
	FutureDateCheck("Date");
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

function UpdateClickHandler() {
	//Dates entered may not be in the future
	if (!(FutureDateCheck("Date"))) return false;
	return Update_click();

}

function SetNewComment() {
	var ID=""; var SundryID=""; var USERNAME="";

	if (objID) objID.value="";

	if (objFutureDate) objFutureDate.value="";
	if (objDate) objDate.value="";
	if ((objCurrTime)&&(objTime)) {
		objTime.value=objCurrTime.value;
	}	
	if (objComments) objComments.value="";
	if (objShortDesc) objShortDesc.value="";
	if (objOnHold) objOnHold.checked=false;

	USERNAME=session['LOGON.USERNAME'];
	if (objUserName) objUserName.value=USERNAME;

	if (objSunID) SundryID=objSunID.value;

	var url="websys.close.csp?WEBSYS.TCOMPONENT=ARCSundryDebtorComments.List&ID="+objID.value+"&SundryID="+SundryID+"&PatientBanner=1";
	websys_createWindow(url,'','top=80,left=10,width=750,height=600,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes');
}

document.body.onload = BodyLoadHandler;