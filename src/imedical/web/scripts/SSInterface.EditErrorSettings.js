// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

// Log 45359 - AI - 11-08-2004 : Define actionlist so it is available to all functions.
var objactionlist=document.getElementById("actionlist");
var actionlist="";
var actionlistpart="";
if (objactionlist) actionlist=objactionlist.value;
if (actionlist!="") actionlistpart=actionlist.split("^");
// end Log 45359

Init();

function Init() {
	var obj=document.getElementById('INTMaxResponse');
	if (obj) obj.onchange=INTMaxResponseChangeHandler;
	var obj=document.getElementById('INTMaxNAKsResp');
	if (obj) obj.onchange=INTMaxNAKsRespChangeHandler;
	var obj=document.getElementById('INTMaxNAKSend');
	if (obj) obj.onchange=INTMaxNAKSendChangeHandler;
	var obj=document.getElementById('INTMaxRead');
	if (obj) obj.onchange=INTMaxReadChangeHandler;

	var obj=document.getElementById('update1');
	if (obj) obj.onclick=UpdateClickHandler;
}

function BodyLoadHandler() {
    var direction="";
    var obj=document.getElementById("INTDataDirection");
    if (obj) {direction=obj.value}

	var obj=document.getElementById('INTMaxResponse');
	if (obj) {
		if (obj.value=="") {
			var obj1=document.getElementById('cINTActionOnMaxResponse');
			if (obj1) obj1.className="";
			DisableField("INTActionOnMaxResponse",1);
			var obj2=document.getElementById("ld1776iINTActionOnMaxResponse");
			if (obj2) obj2.disabled=true;
		}
		else {
			var obj1=document.getElementById('cINTActionOnMaxResponse');
			if ((obj1)&&(direction!="I")) obj1.className="clsRequired";
			EnableField("INTActionOnMaxResponse");
			var obj2=document.getElementById("ld1776iINTActionOnMaxResponse");
			if (obj2) obj2.disabled=false;
		}
	}
	var obj=document.getElementById('INTMaxNAKsResp');
	if (obj) {
		if (obj.value=="") {
			var obj1=document.getElementById('cINTActionOnMaxNAKsResp');
			if (obj1) obj1.className="";
			DisableField("INTActionOnMaxNAKsResp",1);
			var obj2=document.getElementById("ld1776iINTActionOnMaxNAKsResp");
			if (obj2) obj2.disabled=true;
		}
		else {
			var obj1=document.getElementById('cINTActionOnMaxNAKsResp');
            if ((obj1)&&(direction!="I")) obj1.className="clsRequired";
			EnableField("INTActionOnMaxNAKsResp");
			var obj2=document.getElementById("ld1776iINTActionOnMaxNAKsResp");
			if (obj2) obj2.disabled=false;
		}
	}
	var obj=document.getElementById('INTMaxNAKSend');
	if (obj) {
		if (obj.value=="") {
			var obj1=document.getElementById('cINTActionOnMaxNAKSend');
			if (obj1) obj1.className="";
			DisableField("INTActionOnMaxNAKSend",1);
			var obj2=document.getElementById("ld1776iINTActionOnMaxNAKSend");
			if (obj2) obj2.disabled=true;
		}
		else {
			var obj1=document.getElementById('cINTActionOnMaxNAKSend');
			if (obj1) obj1.className="clsRequired";
			EnableField("INTActionOnMaxNAKSend");
			var obj2=document.getElementById("ld1776iINTActionOnMaxNAKSend");
			if (obj2) obj2.disabled=false;
		}
	}
	var obj=document.getElementById('INTMaxRead');
	if (obj) {
		if (obj.value=="") {
			var obj1=document.getElementById('cINTActionOnMaxRead');
			if (obj1) obj1.className="";
			DisableField("INTActionOnMaxRead",1);
			var obj2=document.getElementById("ld1776iINTActionOnMaxRead");
			if (obj2) obj2.disabled=true;
		}
		else {
			var obj1=document.getElementById('cINTActionOnMaxRead');
			if (obj1) obj1.className="clsRequired";
			EnableField("INTActionOnMaxMaxRead");
			var obj2=document.getElementById("ld1776iINTActionOnMaxMaxRead");
			if (obj2) obj2.disabled=false;
		}
	}

	// Log 45359 - AI - 16-08-2004 : Check to see whether the Email Notification fields should be enabled or disabled.
	CheckEnableEmailNotification();

	// Log 45359 - AI - 16-08-2004 : Check to see whether the values of the Email Notification fields resemble email addresses.
	// 				 isEmail() function found in websys.Edit.Tools.js.
	var obj=document.getElementById('INTEmailNotificationFrom');
	if (obj) obj.onchange=isEmail;
	var obj=document.getElementById('INTEmailNotificationTo');
	if (obj) obj.onchange=isEmail;
}

function INTMaxResponseChangeHandler() {
    var direction="";
    var obj=document.getElementById("INTDataDirection");
    if (obj) {direction=obj.value}
	var obj=document.getElementById('INTMaxResponse');
	if (obj) {
		if (obj.value=="") {
			var obj1=document.getElementById("INTMaxResponse");
			if (obj1) obj1.className="";
			var obj2=document.getElementById('cINTActionOnMaxResponse');
			if (obj2) obj2.className="";
			DisableField("INTActionOnMaxResponse",1);
			var obj3=document.getElementById("ld1776iINTActionOnMaxResponse");
			if (obj3) obj3.disabled=true;
			websys_setfocus("INTMaxResponse");
		}
		else {
			if ((isNaN(obj.value))||(obj.value<0)) {
				var cap=document.getElementById("cINTMaxResponse");
				alert("'"+cap.innerText + "' " + t['NotNumeric']);
				var obj1=document.getElementById("INTMaxResponse");
				if (obj1) {
					obj1.className="clsInvalid";
					// perform the actual "commit" to the field, so the invalid value is now the "old" value for onchange handler.
					var val=obj1.value;
					obj1.value=val;
				}
				websys_setfocus('INTMaxResponse');
				return false;
			}
			var obj1=document.getElementById("INTMaxResponse");
			if (obj1) obj1.className="";
			var obj2=document.getElementById('cINTActionOnMaxResponse');
			if ((obj2)&&(direction!="I")) obj2.className="clsRequired";
			EnableField("INTActionOnMaxResponse",1);
			var obj3=document.getElementById("ld1776iINTActionOnMaxResponse");
			if (obj3) obj3.disabled=false;
			websys_setfocus("INTActionOnMaxResponse");
		}
	}
}

function INTMaxNAKsRespChangeHandler() {
    var direction="";
    var obj=document.getElementById("INTDataDirection");
    if (obj) {direction=obj.value}
	var obj=document.getElementById('INTMaxNAKsResp');
	if (obj) {
		if (obj.value=="") {
			var obj1=document.getElementById("INTMaxNAKsResp");
			if (obj1) obj1.className="";
			var obj2=document.getElementById('cINTActionOnMaxNAKsResp');
			if (obj2) obj2.className="";
			DisableField("INTActionOnMaxNAKsResp",1);
			var obj3=document.getElementById("ld1776iINTActionOnMaxNAKsResp");
			if (obj3) obj3.disabled=true;
			websys_setfocus("INTMaxNAKsResp");
		}
		else {
			if ((isNaN(obj.value))||(obj.value<0)) {
				var cap=document.getElementById("cINTMaxNAKsResp");
				alert("'"+cap.innerText + "' " + t['NotNumeric']);
				var obj1=document.getElementById("INTMaxNAKsResp");
				if (obj1) {
					obj1.className="clsInvalid";
					// perform the actual "commit" to the field, so the invalid value is now the "old" value for onchange handler.
					var val=obj1.value;
					obj1.value=val;
				}
				websys_setfocus('INTMaxNAKsResp');
				return false;
			}
			var obj1=document.getElementById("INTMaxNAKsResp");
			if (obj1) obj1.className="";
			var obj2=document.getElementById('cINTActionOnMaxNAKsResp');
			if ((obj2)&&(direction!="I")) obj2.className="clsRequired";
			EnableField("INTActionOnMaxNAKsResp",1);
			var obj3=document.getElementById("ld1776iINTActionOnMaxNAKsResp");
			if (obj3) obj3.disabled=false;
			websys_setfocus("INTActionOnMaxNAKsResp");
		}
	}
}

function INTMaxNAKSendChangeHandler() {
	var obj=document.getElementById('INTMaxNAKSend');
	if (obj) {
		if (obj.value=="") {
			var obj1=document.getElementById("INTMaxNAKSend");
			if (obj1) obj1.className="";
			var obj2=document.getElementById('cINTActionOnMaxNAKSend');
			if (obj2) obj2.className="";
			DisableField("INTActionOnMaxNAKSend",1);
			var obj3=document.getElementById("ld1776iINTActionOnMaxNAKSend");
			if (obj3) obj3.disabled=true;
			websys_setfocus("INTMaxNAKSend");
		}
		else {
			if ((isNaN(obj.value))||(obj.value<0)) {
				var cap=document.getElementById("cINTMaxNAKSend");
				alert("'"+cap.innerText + "' " + t['NotNumeric']);
				var obj1=document.getElementById("INTMaxNAKSend");
				if (obj1) {
					obj1.className="clsInvalid";
					// perform the actual "commit" to the field, so the invalid value is now the "old" value for onchange handler.
					var val=obj1.value;
					obj1.value=val;
				}
				websys_setfocus('INTMaxNAKSend');
				return false;
			}
			var obj1=document.getElementById("INTMaxNAKSend");
			if (obj1) obj1.className="";
			var obj2=document.getElementById('cINTActionOnMaxNAKSend');
			if (obj2) obj2.className="clsRequired";
			EnableField("INTActionOnMaxNAKSend",1);
			var obj3=document.getElementById("ld1776iINTActionOnMaxNAKSend");
			if (obj3) obj3.disabled=false;
			websys_setfocus("INTActionOnMaxNAKSend");
		}
	}
}

function INTMaxReadChangeHandler() {
	var obj=document.getElementById('INTMaxRead');
	if (obj) {
		if (obj.value=="") {
			var obj1=document.getElementById("INTMaxRead");
			if (obj1) obj1.className="";
			var obj2=document.getElementById('cINTActionOnMaxRead');
			if (obj2) obj2.className="";
            DisableField("INTActionOnMaxRead",1);
			var obj3=document.getElementById("ld1776iINTActionOnMaxRead");
			if (obj3) obj3.disabled=true;
			websys_setfocus("INTMaxRead");
		}
		else {
			if ((isNaN(obj.value))||(obj.value<0)) {
				var cap=document.getElementById("cINTMaxRead");
				alert("'"+cap.innerText + "' " + t['NotNumeric']);
				var obj1=document.getElementById("INTMaxRead");
				if (obj1) {
					obj1.className="clsInvalid";
					// perform the actual "commit" to the field, so the invalid value is now the "old" value for onchange handler.
					var val=obj1.value;
					obj1.value=val;
				}
				websys_setfocus('INTMaxRead');
				return false;
			}
			var obj1=document.getElementById("INTMaxRead");
			if (obj1) obj1.className="";
			var obj2=document.getElementById('cINTActionOnMaxRead');
			if (obj2) obj2.className="clsRequired";
			EnableField("INTActionOnMaxRead",1);
			var obj3=document.getElementById("ld1776iINTActionOnMaxRead");
			if (obj3) obj3.disabled=false;
			websys_setfocus("INTActionOnMaxRead");
		}
	}
}

function DisableField(fldName,vGray) {
	var fld = document.getElementById(fldName);
	if ((fld)&&(fld.tagName=="INPUT")&&(fld.type!="hidden")) {
		fld.disabled = true;
		fld.value = "";
		if (vGray) fld.className = "disabledField";
	}
}

function EnableField(fldName) {
	var fld = document.getElementById(fldName);
	if ((fld)&&(fld.tagName=="INPUT")&&(fld.type!="hidden")) {
		fld.disabled = false;
		fld.className = "";
	}
}

function UpdateClickHandler() {
    var direction="";
    var obj=document.getElementById("INTDataDirection");
    if (obj) {direction=obj.value}

	// Log 45359 - AI - 16-08-2004 : re-check all of the Actions.
	var obj=document.getElementById("INTActionOnNoResponse");
	if ((obj)&&(obj.className=="clsInvalid")) {
		var cap=document.getElementById("cINTActionOnNoResponse");
		alert("'"+cap.innerText + "' : " + t['IsInvalid']);
		return false;
	}
	var obj=document.getElementById("INTActionOnMaxResponse");
	if ((obj)&&(obj.className=="clsInvalid")) {
		var cap=document.getElementById("cINTActionOnMaxResponse");
		alert("'"+cap.innerText + "' : " + t['IsInvalid']);
		return false;
	}
	var obj=document.getElementById("INTActionOnNAKResponse");
	if ((obj)&&(obj.className=="clsInvalid")) {
		var cap=document.getElementById("cINTActionOnNAKResponse");
		alert("'"+cap.innerText + "' : " + t['IsInvalid']);
		return false;
	}
	var obj=document.getElementById("INTActionOnMaxNAKsResp");
	if ((obj)&&(obj.className=="clsInvalid")) {
		var cap=document.getElementById("cINTActionOnMaxNAKsResp");
		alert("'"+cap.innerText + "' : " + t['IsInvalid']);
		return false;
	}
	var obj=document.getElementById("INTActionOnMaxNAKSend");
	if ((obj)&&(obj.className=="clsInvalid")) {
		var cap=document.getElementById("cINTActionOnMaxNAKSend");
		alert("'"+cap.innerText + "' : " + t['IsInvalid']);
		return false;
	}
	var obj=document.getElementById("INTActionOnMaxRead");
	if ((obj)&&(obj.className=="clsInvalid")) {
		var cap=document.getElementById("cINTActionOnMaxRead");
		alert("'"+cap.innerText + "' : " + t['IsInvalid']);
		return false;
	}

	// re-check all of the other numerics and dependencies.
	var obj=document.getElementById('INTMaxResponse');
	if ((obj)&&(obj.className=="clsInvalid")) {
		alert("'" + t['INTMaxResponse'] + "' " + t['NotNumeric']);
		websys_setfocus("INTMaxResponse");
		return false;
	}
	var obj=document.getElementById('INTMaxResponse');
	var obj1=document.getElementById('INTActionOnMaxResponse');
	if ((obj)&&(obj.value!="")&&(obj1)&&(obj1.value=="")&&(direction!="I")) {
		alert("'" + t['INTActionOnMaxResponse'] + "' " + t['IsRequiredWhen'] + " '" + t['INTMaxResponse'] + "' " + t['HasValue']);
		websys_setfocus("INTMaxResponse");
		return false;
	}

	var obj=document.getElementById('INTMaxNAKsResp');
	if ((obj)&&(obj.className=="clsInvalid")) {
		alert("'" + t['INTMaxNAKsResp'] + "' " + t['NotNumeric']);
		websys_setfocus("INTMaxNAKsResp");
		return false;
	}
	var obj=document.getElementById('INTMaxNAKsResp');
	var obj1=document.getElementById('INTActionOnMaxNAKsResp');
	if ((obj)&&(obj.value!="")&&(obj1)&&(obj1.value=="")&&(direction!="I")) {
		alert("'" + t['INTActionOnMaxNAKsResp'] + "' " + t['IsRequiredWhen'] + " '" + t['INTMaxNAKsResp'] + "' " + t['HasValue']);
		websys_setfocus("INTMaxNAKsResp");
		return false;
	}

	var obj=document.getElementById('INTMaxNAKSend');
	if ((obj)&&(obj.className=="clsInvalid")) {
		alert("'" + t['INTMaxNAKSend'] + "' " + t['NotNumeric']);
		websys_setfocus("INTMaxNAKSend");
		return false;
	}
	var obj=document.getElementById('INTMaxNAKSend');
	var obj1=document.getElementById('INTActionOnMaxNAKSend');
	if ((obj)&&(obj.value!="")&&(obj1)&&(obj1.value=="")) {
		alert("'" + t['INTActionOnMaxNAKSend'] + "' " + t['IsRequiredWhen'] + " '" + t['INTMaxNAKSend'] + "' " + t['HasValue']);
		websys_setfocus("INTMaxNAKSend");
		return false;
	}

	var obj=document.getElementById('INTMaxRead');
	if ((obj)&&(obj.className=="clsInvalid")) {
		alert("'" + t['INTMaxRead'] + "' " + t['NotNumeric']);
		websys_setfocus("INTMaxRead");
		return false;
	}
	var obj=document.getElementById('INTMaxRead');
	var obj1=document.getElementById('INTActionOnMaxRead');
	if ((obj)&&(obj.value!="")&&(obj1)&&(obj1.value=="")) {
		alert("'" + t['INTActionOnMaxRead'] + "' " + t['IsRequiredWhen'] + " '" + t['INTMaxRead'] + "' " + t['HasValue']);
		websys_setfocus("INTMaxRead");
		return false;
	}

	// Log 45359 - AI - 16-08-2004 : Also check for Email Notification fields.
	var obj=document.getElementById('INTEmailNotificationFrom');
	var obj1=document.getElementById('cINTEmailNotificationFrom');
	if ((obj)&&(obj.value=="")&&(obj1)&&(obj1.className=="clsRequired")) {
		alert("'" + t['INTEmailNotificationFrom'] + "' " + t['IsRequiredWhenSE']);
		websys_setfocus("INTEmailNotificationFrom");
		return false;
	}
	var obj=document.getElementById('INTEmailNotificationTo');
	var obj1=document.getElementById('cINTEmailNotificationTo');
	if ((obj)&&(obj.value=="")&&(obj1)&&(obj1.className=="clsRequired")) {
		alert("'" + t['INTEmailNotificationTo'] + "' " + t['IsRequiredWhenSE']);
		websys_setfocus("INTEmailNotificationTo");
		return false;
	}
	// end Log 45359

	// set these two fields back to enabled, so they save "" to the database.
	var obj=document.getElementById('INTEmailNotificationFrom');
	if (obj) EnableField("INTEmailNotificationFrom");
	var obj=document.getElementById('INTEmailNotificationTo');
	if (obj) EnableField("INTEmailNotificationTo");

	return update1_click();
}

// Log 45359 - AI - 16-08-2004 : Check to see whether the Email Notification fields should be enabled or disabled.
function CheckEnableEmailNotification() {
	var flg=0;
	// Remember: actionlistpart[0] is SMTPServer.
	for (var i=1;i<=6;i++) {
		if (actionlistpart[i]=="SE") flg=1;
	}
	if (flg==1) {
		EnableField("INTEmailNotificationFrom");
		EnableField("INTEmailNotificationTo");
		var obj=document.getElementById('cINTEmailNotificationFrom');
		if (obj) obj.className="clsRequired";
		var obj=document.getElementById('cINTEmailNotificationTo');
		if (obj) obj.className="clsRequired";
	} else {
		DisableField("INTEmailNotificationFrom",1);
		DisableField("INTEmailNotificationTo",1);
		var obj=document.getElementById('cINTEmailNotificationFrom');
		if (obj) obj.className="";
		var obj=document.getElementById('cINTEmailNotificationTo');
		if (obj) obj.className="";
	}
}
// end Log 45359

// Log 45359 - AI - 11-08-2004 : The LookUp functions for the six (6) Action... lookup fields.
// 				 Remember: actionlistpart[0] is SMTPServer.
function noresponseLookUp(str) {
	// piece 2 of actionlist
	var actionpart=str.split("^");
	var actionid=actionpart[2];

	// If the SMTPServer is not set up, and the Action is "SE", ERROR.
	if (actionid=="SE"&&actionlistpart[0]=="") {
		var cap=document.getElementById("cINTActionOnNoResponse");
		alert("'"+cap.innerText + "' : " + t['NoSMTPServer']);

		var obj=document.getElementById("INTActionOnNoResponse");
		if (obj) {
			obj.className="clsInvalid";
		}
		websys_setfocus('INTActionOnNoResponse');
		return false;
	}

	actionlistpart[1]=actionid;
	actionlist=actionlistpart[0]+"^"+actionid+"^"+actionlistpart[2]+"^"+actionlistpart[3]+"^"+actionlistpart[4]+"^"+actionlistpart[5]+"^"+actionlistpart[6];
	CheckEnableEmailNotification();
}

function maxresponseLookUp(str) {
	// piece 3 of actionlist
	var actionpart=str.split("^");
	var actionid=actionpart[2];

	// If the SMTPServer is not set up, and the Action is "SE", ERROR.
	if (actionid=="SE"&&actionlistpart[0]=="") {
		var cap=document.getElementById("cINTActionOnMaxResponse");
		alert("'"+cap.innerText + "' : " + t['NoSMTPServer']);

		var obj=document.getElementById("INTActionOnMaxResponse");
		if (obj) {
			obj.className="clsInvalid";
		}
		websys_setfocus('INTActionOnMaxResponse');
		return false;
	}

	actionlistpart[2]=actionid;
	actionlist=actionlistpart[0]+"^"+actionlistpart[1]+"^"+actionid+"^"+actionlistpart[3]+"^"+actionlistpart[4]+"^"+actionlistpart[5]+"^"+actionlistpart[6];
	CheckEnableEmailNotification();
}

function nakresponseLookUp(str) {
	// piece 4 of actionlist
	var actionpart=str.split("^");
	var actionid=actionpart[2];

	// If the SMTPServer is not set up, and the Action is "SE", ERROR.
	if (actionid=="SE"&&actionlistpart[0]=="") {
		var cap=document.getElementById("cINTActionOnNAKResponse");
		alert("'"+cap.innerText + "' : " + t['NoSMTPServer']);

		var obj=document.getElementById("INTActionOnNAKResponse");
		if (obj) {
			obj.className="clsInvalid";
		}
		websys_setfocus('INTActionOnNAKResponse');
		return false;
	}

	actionlistpart[3]=actionid;
	actionlist=actionlistpart[0]+"^"+actionlistpart[1]+"^"+actionlistpart[2]+"^"+actionid+"^"+actionlistpart[4]+"^"+actionlistpart[5]+"^"+actionlistpart[6];
	CheckEnableEmailNotification();
}

function maxnakresponseLookUp(str) {
	// piece 5 of actionlist
	var actionpart=str.split("^");
	var actionid=actionpart[2];

	// If the SMTPServer is not set up, and the Action is "SE", ERROR.
	if (actionid=="SE"&&actionlistpart[0]=="") {
		var cap=document.getElementById("cINTActionOnMaxNAKsResp");
		alert("'"+cap.innerText + "' : " + t['NoSMTPServer']);

		var obj=document.getElementById("INTActionOnMaxNAKsResp");
		if (obj) {
			obj.className="clsInvalid";
		}
		websys_setfocus('INTActionOnMaxNAKsResp');
		return false;
	}

	actionlistpart[4]=actionid;
	actionlist=actionlistpart[0]+"^"+actionlistpart[1]+"^"+actionlistpart[2]+"^"+actionlistpart[3]+"^"+actionid+"^"+actionlistpart[5]+"^"+actionlistpart[6];
	CheckEnableEmailNotification();
}

function maxnaksendLookUp(str) {
	// piece 6 of actionlist
	var actionpart=str.split("^");
	var actionid=actionpart[2];

	// If the SMTPServer is not set up, and the Action is "SE", ERROR.
	if (actionid=="SE"&&actionlistpart[0]=="") {
		var cap=document.getElementById("cINTActionOnMaxNAKSend");
		alert("'"+cap.innerText + "' : " + t['NoSMTPServer']);

		var obj=document.getElementById("INTActionOnMaxNAKSend");
		if (obj) {
			obj.className="clsInvalid";
		}
		websys_setfocus('INTActionOnMaxNAKSend');
		return false;
	}

	actionlistpart[5]=actionid;
	actionlist=actionlistpart[0]+"^"+actionlistpart[1]+"^"+actionlistpart[2]+"^"+actionlistpart[3]+"^"+actionlistpart[4]+"^"+actionid+"^"+actionlistpart[6];
	CheckEnableEmailNotification();
}

function maxreadLookUp(str) {
	// piece 7 of actionlist
	var actionpart=str.split("^");
	var actionid=actionpart[2];

	// If the SMTPServer is not set up, and the Action is "SE", ERROR.
	if (actionid=="SE"&&actionlistpart[0]=="") {
		var cap=document.getElementById("cINTActionOnMaxRead");
		alert("'"+cap.innerText + "' : " + t['NoSMTPServer']);

		var obj=document.getElementById("INTActionOnMaxRead");
		if (obj) {
			obj.className="clsInvalid";
		}
		websys_setfocus('INTActionOnMaxRead');
		return false;
	}

	actionlistpart[6]=actionid;
	actionlist=actionlistpart[0]+"^"+actionlistpart[1]+"^"+actionlistpart[2]+"^"+actionlistpart[3]+"^"+actionlistpart[4]+"^"+actionlistpart[5]+"^"+actionid;
	CheckEnableEmailNotification();
}
// end Log 45359


document.body.onload=BodyLoadHandler;

