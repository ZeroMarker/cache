// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

// Log 39276 - AI - 29-09-2003 : Declare all multi-defined objects once only, so we know which object we are talking about throughout.
var objCreateDate=document.getElementById("ALMCreateDate");
var objExpiryDate=document.getElementById("ALMExpiryDate");
var objReviewDate=document.getElementById("ALMReviewDate");
var objClosedFlag=document.getElementById("ALMClosedFlag");
var objClosedDate=document.getElementById("ALMClosedDate");
var objClosedTime=document.getElementById("ALMClosedTime");
var objNowDate=document.getElementById("NowDate");
var objNowTime=document.getElementById("NowTime");
var objUpdate1=document.getElementById("update1");
var objDelete1=document.getElementById("Delete1");
// Log 41735 - AI - 22-01-2004 : Declare hidden item StatusUpdate.
var objStatusUpdate=document.getElementById("StatusUpdate");


// Log 39276 - AI - 29-09-2003 : Declare all multi-defined flags once only, so we can access them in every function.
// UpdateAll sets ALL flags, but ALMExpiryDateChangeHandler and ALMReviewDateChangeHandler only set relevant flags.
var flgExpiryDateFuture="";
var flgExpiryDate="";
var flgReviewDateExpiryDateExp="";
var flgReviewDate="";
var flgReviewDateExpiryDateRev="";


function Init() {
	if (objClosedFlag) objClosedFlag.onclick=ALMClosedFlagChangehandler;
	var TDIRTY=document.getElementById("TDIRTY");
	if ((objClosedFlag)&&(TDIRTY)&&(TDIRTY.value!="2")) {
		if (objClosedFlag.checked) {
			makeReadOnly();
		} else {
			makeEditable();
		}
	}
	// Log 53061 YC - Disable audit trail when adding new
	var objID=document.getElementById('ID')
	var objAuditLink=document.getElementById('AuditTrailData');
	if (objID && objAuditLink) {
		if (objID.value=="") {
			objAuditLink.disabled=true;
			objAuditLink.onclick=LinkDisable;
		}
	}
	//md 03/03/2003
	if (objUpdate1) objUpdate1.onclick = UpdateAll;
	if (tsc["update1"]) websys_sckeys[tsc["update1"]]=UpdateAll;
	// Log 39276 - AI - 26-09-2003 : Add logic for Expiry Date and Review Date fields.
	if (objExpiryDate) objExpiryDate.onchange = ALMExpiryDateChangeHandler;
	if (objReviewDate) objReviewDate.onchange = ALMReviewDateChangeHandler;
}

//md 13/01/2003

function ALMMessage_keydownhandler(encmeth) {
	var obj=document.getElementById("ALMMessage");
	LocateCode(obj,encmeth,0,lookupqryNURN,jsfuncNURN);
}

function ALMMessage_lookupsel(value) {
}

function makeReadOnly() {
	var el=document.forms["fPAAlertMsg_EditNew"].elements;
	for (var i=0;i<el.length;i++) {
		if (!(el[i].type=="hidden")) {
		//if (el[i].tagName=="A") {
			el[i].disabled=true;
		}
	}
	var arrLookUps=document.getElementsByTagName("IMG");
	for (var i=0; i<arrLookUps.length; i++) {
		if ((arrLookUps[i].id)&&(arrLookUps[i].id.charAt(0)=="l")) {
			arrLookUps[i].disabled=true;
		}
	}
	if (objUpdate1) objUpdate1.disabled=false;
	if (objDelete1) objDelete1.disabled=false;
	if (objClosedFlag) objClosedFlag.disabled=false;

	var obj=document.getElementById("UserCode");
	if (obj) obj.disabled=false;
	var obj=document.getElementById("PIN");
	if (obj) obj.disabled=false;
}

function makeEditable() {
	var el=document.forms["fPAAlertMsg_EditNew"].elements;
	for (var i=0;i<el.length;i++) {
		if (!(el[i].type=="hidden")) {
		//if (el[i].tagName=="A") {
			el[i].disabled=false;
		}
	}
	var arrLookUps=document.getElementsByTagName("IMG");
	for (var i=0; i<arrLookUps.length; i++) {
		if ((arrLookUps[i].id)&&(arrLookUps[i].id.charAt(0)=="l")) {
			arrLookUps[i].disabled=false;
		}
	}
	if (objUpdate1) objUpdate1.disabled=false;
	if (objDelete1) objDelete1.disabled=false;
}

function ALMClosedFlagChangehandler(e){
	if ((objClosedFlag)&&(objClosedFlag.checked)) {
		if ((objClosedDate)&&(objNowDate)&&(objNowDate.value)) {
			objClosedDate.value=objNowDate.value;
		}
		if ((objClosedTime)&&(objNowTime)&&(objNowTime.value)) {
			objClosedTime.value=objNowTime.value;
		}
		// Log 39276 - AI - 26-09-2003 : If Closed Flag is checked, update ExpiryDate if it is blank.
		if ((objNowDate)&&(objNowDate.value)&&(objExpiryDate)&&(objExpiryDate.value=="")) {
			objExpiryDate.value=objNowDate.value;
		}
		//makeReadOnly();
	}
	if ((objClosedFlag)&&(!objClosedFlag.checked)) {
		if (objClosedDate) objClosedDate.value="";
		if (objClosedTime) objClosedTime.value="";
        
        // ab 26.07.05 54188
        if (objExpiryDate) objExpiryDate.value="";
		makeEditable();
	}
	// Log 41735 - AI - 22-01-2004 : Set the StatusUpdate component item to hold new Alert Status.
	if ((objClosedFlag)&&(objClosedFlag.checked)&&(objStatusUpdate)) {
		objStatusUpdate.value="I";
	}
	if ((objClosedFlag)&&(!(objClosedFlag.checked))&&(objStatusUpdate)) {
		objStatusUpdate.value="A";
	}
}

// Log 39276 - AI - 26-09-2003 : Add logic for Expiry Date field.
function ALMExpiryDateChangeHandler() {
	// msg holds every alert message as it is found - User is alerted to everything at the end.
	var msg="";
	// errFlag holds "Y" if there is any kind of error found.
	var errFlag="";

	var isvalid1="";
	var isvalid2="";
	var isvalid3="";
	if (!IsValidDate(objExpiryDate)) errFlag=="Y";
	//Log 51656 md isvalid can be 
	//0,1,-2 standard
	//0,1,-1 custom for sites that want  t["ExpiryDateFuture"] to be displayed
	isvalid1=CheckExpiryDateCurrentDate();
	if (isvalid1==-1) {
		msg += t["ExpiryDateFuture"] + "\n";
		errFlag="Y";
		flgExpiryDateFuture="Y";
	
	} else {
		flgExpiryDateFuture="";
	}

	isvalid2=CheckExpiryDateCreateDate();
	if (isvalid2==-1) {
		msg += t["ExpiryDate"] + "\n";
		errFlag="Y";
		flgExpiryDate="Y";
	} else {
		flgExpiryDate="";
	}

	if ((objReviewDate)&&(objExpiryDate)) {
		isvalid3=CheckReviewDateExpiryDate();
		if (isvalid3==-1) {
			msg += t["ReviewDateExpiryDate"] + "\n";
			errFlag="Y";
			flgReviewDateExpiryDateExp="Y";
		} else {
			flgReviewDateExpiryDateExp="";
			// Because the ReviewDateExpiryDate validation is OK, remove that flag from ReviewDate too. set className if required too.
			flgReviewDateExpiryDateRev="";
			if (flgReviewDate=="") objReviewDate.className="";
		}
	}

	if ((isvalid1==1)&&(isvalid2!=-1)&&(isvalid3!=-1)) {
		if (objClosedFlag) objClosedFlag.checked=true;
		// Update the Closed Date and Time as per ALMClosedFlagChangehandler.
		if ((objClosedDate)&&(objNowDate)&&(objNowDate.value)) {
			objClosedDate.value=objNowDate.value;
		}
		if ((objClosedTime)&&(objNowTime)&&(objNowTime.value)) {
			objClosedTime.value=objNowTime.value;
		}
	}
	if ((isvalid1==0)&&(isvalid2!=-1)&&(isvalid3!=-1)) {
		if (objClosedFlag) objClosedFlag.checked=false;
		// Update the Closed Date and Time as per ALMClosedFlagChangehandler.
		if (objClosedDate) objClosedDate.value="";
		if (objClosedTime) objClosedTime.value="";
	}
 	if ((objClosedFlag)&&(objClosedFlag.checked)&&(objStatusUpdate)) {
		objStatusUpdate.value="I";
	}
	if ((objClosedFlag)&&(!(objClosedFlag.checked))&&(objStatusUpdate)) {
		objStatusUpdate.value="A";
	}
	if (msg!="") alert(msg);
	if (errFlag=="Y") {
		objExpiryDate.className="clsInvalid";
		websys_setfocus("ALMExpiryDate");
	} else {
		objExpiryDate.className="";
	}
}

// Log 39276 - AI - 26-09-2003:  Called from ALMExpiryDateChangeHandler and UpdateAll.
// Returns -1 if ExpiryDate is a future date, 0 if blank, 1 if valid.
function CheckExpiryDateCurrentDate() {
	var OExpiryDate="";
	if (objExpiryDate) {
		if (objExpiryDate.value=="") {
			return 0;
		}
		if ((IsValidDate(objExpiryDate))&&(objExpiryDate.value!="")) {
			OExpiryDate=objExpiryDate.value;
			// DateStringCompareToday is found in websys.DateTime.Tools.js (included in "Other Scripts" in Component Properties).
			var datecheck=DateStringCompareToday(OExpiryDate);
			if (datecheck==1) {
				//Log 51656 md  standard to return -2 custom to return -1
				try {return CustomFEDDateError()} catch(e) {return -2;}
				//return -2;
			}
		}
	}
	return 1;
}

// Log 39276 - AI - 26-09-2003: Called from ALMExpiryDateChangeHandler and UpdateAll.
// This function returns -1 if ExpiryDate is before CreateDate, 1 if not.
function CheckExpiryDateCreateDate() {
	var OCreateDate="";
	var OExpiryDate="";
	if (objCreateDate) {
		if ((IsValidDate(objCreateDate))&&(objCreateDate.value!="")) {
			OCreateDate=objCreateDate.value;
		}
	}
	if (objExpiryDate){
		if ((IsValidDate(objExpiryDate))&&(objExpiryDate.value!="")) {
			OExpiryDate=objExpiryDate.value;
		}
	}
	if ((OCreateDate!="")&&(OExpiryDate!="")) {
		// DateStringCompare is found in websys.DateTime.Tools.js (included in "Other Scripts" in Component Properties).
		var datecheck=DateStringCompare(OCreateDate,OExpiryDate);
		if (datecheck==1) {
			return -1;
		}
	}
	return 1;
}

// Log 39276 - AI - 26-09-2003 : Add logic for Review Date field.
function ALMReviewDateChangeHandler() {
	// msg holds every alert message as it is found - User is alerted to everything at the end.
	var msg="";
	// errFlag holds "Y" if there is any kind of error found.
	var errFlag="";

	var isvalid1="";
	var isvalid2="";

	if (!IsValidDate(objReviewDate)) errFlag="Y";

	isvalid1=CheckReviewDateCreateDate();
	if (isvalid1==-1) {
		msg += t["ReviewDate"] +"\n";
		errFlag="Y";
		flgReviewDate="Y";
	} else {
		flgReviewDate="";
	}

	if ((objReviewDate)&&(objExpiryDate)) {
		isvalid2=CheckReviewDateExpiryDate();
		if (isvalid2==-1) {
			msg += t["ReviewDateExpiryDate"] +"\n";
			errFlag="Y";
			flgReviewDateExpiryDateRev="Y";
		} else {
			flgReviewDateExpiryDateRev="";
			// Because the ReviewDateExpiryDate validation is OK, remove that flag from ExpiryDate too. set className if required too.
			flgReviewDateExpiryDateExp="";
			if ((flgExpiryDateFuture=="")&&(flgExpiryDate=="")) objExpiryDate.className="";
		}
	}

	if (msg!="") alert(msg);
	if (errFlag=="Y") {
		objReviewDate.className="clsInvalid";
		websys_setfocus("ALMReviewDate");
	} else {
		objReviewDate.className="";
	}
}

// Log 39276 - AI - 26-09-2003: Called from ALMReviewDateChangeHandler and UpdateAll.
// This function returns -1 if ReviewDate is before CreateDate, 1 if valid.
function CheckReviewDateCreateDate() {
	var OCreateDate="";
	var OReviewDate="";
	if (objCreateDate) {
		if ((IsValidDate(objCreateDate))&&(objCreateDate.value!="")) {
			OCreateDate=objCreateDate.value;
		}
	}
	if (objReviewDate) {
		if ((IsValidDate(objReviewDate))&&(objReviewDate.value!="")) {
			OReviewDate=objReviewDate.value;
		}
	}
	if ((OCreateDate!="")&&(OReviewDate!="")) {
		// DateStringCompare is found in websys.DateTime.Tools.js (included in "Other Scripts" in Component Properties).
		var datecheck=DateStringCompare(OCreateDate,OReviewDate);
		if (datecheck==1) {
			return -1;
		}
	}
	return 1;
}

// Log 39276 - AI - 26-09-2003: Called from ALMReviewDateChangeHandler, ALMExpiryDateChangeHandler and UpdateAll.
// This function returns -1 if ExpiryDate is before ReviewDate, 1 if not.
function CheckReviewDateExpiryDate() {
	var OReviewDate="";
	var OExpiryDate="";
	if (objReviewDate) {
		if ((IsValidDate(objReviewDate))&&(objReviewDate.value!="")) {
			OReviewDate=objReviewDate.value;
		}
	}
	if (objExpiryDate) {
		if ((IsValidDate(objExpiryDate))&&(objExpiryDate.value!="")) {
			OExpiryDate=objExpiryDate.value;
		}
	}
	if ((OReviewDate!="")&&(OExpiryDate!="")) {
		// DateStringCompare is found in websys.DateTime.Tools.js (included in "Other Scripts" in Component Properties).
		var datecheck=DateStringCompare(OReviewDate,OExpiryDate);
		if (datecheck==1) {
			return -1;
		}
	}
	return 1;
}


function UpdateAll() {
	var msg="";
	// errReviewFlag holds "Y" if there is any kind of error found on ReviewDate.
	var errReviewFlag="";
	// errExpiryFlag holds "Y" if there is any kind of error found on ExpiryDate.
	var errExpiryFlag="";

	var isvalid1="";
	var isvalid2="";
	var isvalid3="";
	var isvalid4="";

	if (objReviewDate) {
		if (!IsValidDate(objReviewDate)) errReviewFlag=="Y";
	}
	if (objExpiryDate) {
		if (!IsValidDate(objExpiryDate)) errExpiryFlag=="Y";
	}

	if (objExpiryDate) {
		isvalid1=CheckExpiryDateCurrentDate();
		if (isvalid1==-1) {
			msg += t["ExpiryDateFuture"] + "\n";
			errExpiryFlag="Y";
			flgExpiryDateFuture="Y";
		} else {
			flgExpiryDateFuture="";
		}

		isvalid2=CheckExpiryDateCreateDate();
		if (isvalid2==-1) {
			msg += t["ExpiryDate"] + "\n";
			errExpiryFlag="Y";
			flgExpiryDate="Y";
		} else {
			flgExpiryDate="";
		}
	}

	if (objReviewDate) {
		isvalid3=CheckReviewDateCreateDate();
		if (isvalid3==-1) {
			msg += t["ReviewDate"] + "\n";
			errReviewFlag="Y";
			flgReviewDate="Y";
		} else {
			flgReviewDate="";
		}
	}

	if ((objReviewDate)&&(objExpiryDate)) {
		isvalid4=CheckReviewDateExpiryDate();
		if (isvalid4==-1) {
			msg += t["ReviewDateExpiryDate"] + "\n";
			errReviewFlag="Y";
			errExpiryFlag="Y";
			flgReviewDateExpiryDateRev="Y";
			flgReviewDateExpiryDateExp="Y";
		} else {
			flgReviewDateExpiryDateRev="";
			flgReviewDateExpiryDateExp="";
			// Because the ReviewDateExpiryDate validation is OK, set classNames if required too.
			if (flgReviewDate=="") objReviewDate.className="";
			if ((flgExpiryDateFuture=="")&&(flgExpiryDate=="")) objExpiryDate.className="";
		}
	}

	if (msg!="") alert(msg);

	if (objReviewDate) {
		if (errReviewFlag=="Y") {
			objReviewDate.className="clsInvalid";
			websys_setfocus("ALMReviewDate");
		} else {
			objReviewDate.className="";
		}
	}

	if (objExpiryDate) {
		if (errExpiryFlag=="Y") {
			objExpiryDate.className="clsInvalid";
			if (errReviewFlag!="Y") websys_setfocus("ALMExpiryDate");
		} else {
			objExpiryDate.className="";
		}
	}
		
	if ((msg!="")||(errReviewFlag=="Y")||(errExpiryFlag=="Y")) return false;

	var obj=document.getElementById("ALMStatus");
	if (obj) {
	   //alert(obj.value)
		if ((objClosedFlag)&&(objClosedFlag.checked==true)) {
			obj.value="I";
				} else if ((objClosedFlag)&&(objClosedFlag.checked==false)) {
			obj.value="A";
		}
	}
	return update1_click();
}
function AlertLookUpHandler(str) {
 	var lu = str.split("^");
	
	var alertdesc=document.getElementById('ALMAlertDR');
	var alertcat=document.getElementById('AlertCat');
	if (alertdesc) {
		alertdesc.value=lu[0];
		}
	if (alertcat) {
		alertcat.value=lu[3];
	}
}

function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if (el.disabled) {
		return false;
	}
	return true;
}

document.body.onload=Init;
