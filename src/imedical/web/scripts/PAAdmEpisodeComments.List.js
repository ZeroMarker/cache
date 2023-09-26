// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

objID=document.getElementById('ID');
objPatID=document.getElementById('PatientID');
objEpisodeID=document.getElementById('EpisodeID');
objLetterType=document.getElementById('LetterType');
objFutureDate=document.getElementById('FutureDate');
objDate=document.getElementById('Date');
objTime=document.getElementById('Time');
objUserName=document.getElementById('UserName');
objAddNewComment=document.getElementById('AddNewComment');
objComments=document.getElementById('Comments');
objUpdate=document.getElementById('Update');

function BodyLoadHandler() {
	if (objAddNewComment) objAddNewComment.onclick=SetNewComment;

	// SA 30.10.03 - log 37695: Dates entered may not be in the future
	if (objDate) objDate.onchange=DateChangeHandler;
	if (objUpdate) objUpdate.onclick=UpdateClickHandler;
	if (tsc['Update']) websys_sckeys[tsc['Update']]=UpdateClickHandler;
	
	var objBold=document.getElementById('BoldLinks');
	if ((objBold)&&(objBold.value!="")) {
		var BoldLink = objBold.value.split("^");
		//obj=document.getElementById('AddEditOtherAddresses');
		obj=document.getElementById('OtherAddresses');
		if ((obj) && (BoldLink[1]=="1")) obj.style.fontWeight="bold";
	}
}

function DateChangeHandler() {

	Date_changehandler();

	// SA 30.10.03 - log 37695: Dates entered may not be in the future
	FutureDateCheck("Date");
	
}

function setBoldLinks(el,state) {
	obj=document.getElementById(el);
	if (obj) {
		if (state==1) obj.style.fontWeight="bold";
		else obj.style.fontWeight="normal"
	}
}

function FutureDateCheck(objName) {

	// SA 30.10.03 - log 37695: Dates entered may not be in the future
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

	// SA 30.10.03 - log 37695: Dates entered may not be in the future
	if (!(FutureDateCheck("Date"))) return false;
	return Update_click();

}

function SetNewComment() {
	var ID=""; var PatientID=""; var EpisodeID=""; var USERNAME="";

	if (objID) objID.value="";
	if (objLetterType) objLetterType.value="";

	// RQG 14.10.03 L39587
	if (objFutureDate) objFutureDate.value="";
	if (objDate) objDate.value="";
	if (objTime) objTime.value="";
	if (objComments) objComments.value="";

	USERNAME=session['LOGON.USERNAME'];
	if (objUserName) objUserName.value=USERNAME;

	if (objPatID) PatientID=objPatID.value;
	if (objEpisodeID) EpisodeID=objEpisodeID.value;

	//var url="websys.default.csp?WEBSYS.TCOMPONENT=PAPAAdmEpisodeComments.List&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&PatientBanner=1";
	//var url="websys.close.csp?WEBSYS.TCOMPONENT=PAPAAdmEpisodeComments.List&ID="+objID.value+"&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&UserName="+USERNAME+"&PatientBanner=1";
	var url="websys.close.csp?WEBSYS.TCOMPONENT=PAPAAdmEpisodeComments.List&ID="+objID.value+"&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&PatientBanner=1";

	//alert(url);
        //Log 59598 - BC - 30-06-2006 : remove statusbar variable (status=) to display the status bar.       
	websys_createWindow(url,'','top=80,left=10,width=750,height=400,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes');


}

document.body.onload = BodyLoadHandler;