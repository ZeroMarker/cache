// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var message=document.getElementById('message');
var hiddenmessage=document.getElementById('hiddenmessage');
var newmessage=document.getElementById('newmessage');
var messageHEX=document.getElementById('messageHEX');
var displayHex=document.getElementById('displayHex');
var hiddenmessageHEX=document.getElementById('hiddenmessageHEX');
var newmessageHEX=document.getElementById('newmessageHEX');
var replay=document.getElementById('replay');
var reload1=document.getElementById('reload1');
var allowEdit=document.getElementById('allowEdit');
var compId=document.getElementById('compId');

function BodyLoadHandler() {
	//debugger;

	//obj=document.getElementById('displayHex');
	if (displayHex) displayHex.onclick=displayHexHandler;
    
	// ab 12.08.05 54637
	//var obj=document.getElementById("allowEdit");
	var type=document.getElementById("type");
	if ((allowEdit)&&(type)&&(type.value=="ACK")) {
		allowEdit.disabled=true;
	}

	// Log 54649 - AI - 24-08-2005 : Functions for the "Allow Edit" (allowEdit) checkbox.
	//var obj=document.getElementById('allowEdit');
	if (allowEdit) allowEdit.onclick=allowEditClickHandler;

	//var objHEX=document.getElementById('messageHEX');
	if (messageHEX) ReadOnly(messageHEX);
	allowEditClickHandler();
	// end Log 54649

	// Log 54649 - AI - 24-08-2005 : Build the message and messageHEX values from the appropriate hidden objects.
	//     This is either the hidden new values, or the now-hidden originals.
	//var obj=document.getElementById('message');
	//var obj1=document.getElementById('hiddenmessage');
	//var obj2=document.getElementById('newmessage');
	if ((message)&&(newmessage)&&(newmessage.value!="")) {
		message.value=newmessage.value;
	} else if ((message)&&(hiddenmessage)) {
		message.value=hiddenmessage.value;
	}

	//var obj=document.getElementById('messageHEX');
	//var obj1=document.getElementById('hiddenmessageHEX');
	//var obj2=document.getElementById('newmessageHEX');
	if ((messageHEX)&&(newmessageHEX)&&(newmessageHEX.value!="")) {
		messageHEX.value=newmessageHEX.value;
	} else if ((messageHEX)&&(hiddenmessageHEX)) {
		messageHEX.value=hiddenmessageHEX.value;
	}
	// end Log 54649

	// Log 54649 - AI - 24-08-2005 : The reload Click Handler.
	//var objdisplayHex=document.getElementById('displayHex');
	//obj=document.getElementById('reload1');
	if (reload1) {
		if ((displayHex)&&(displayHex.checked)) {
			reload1.disabled=false;
			reload1.onclick=reload1ClickHandler;
		} else {
			reload1.disabled=true;
			reload1.onclick=LinkDisable;
			//obj.onclick=reload1ClickHandler;
		}
	}
	// end Log 54649

	//obj=document.getElementById('update1');
	//if (obj) obj.onclick=UpdateClickHandler;
	
	
	//obj=document.getElementById('replay');
	if (replay) replay.onclick=replayClickHandler;
	
}

// cjb 25/08/2005 54651
function replayClickHandler() {
	
	// if the hex message is displayed, rebuild the 'message' into it's propper format
	if ((message)&&(displayHex)&&(displayHex.checked)) message.value=GetRidOfExtraLines(message.value);
	
	return replay_click();
}


function str_to_hex(str) {
	num_out = "";
	if(str.value != "") {
		str_in = escape(str.value);
		for(i = 0; i < str_in.length; i++) {
			num_out += toHex(str_in.charCodeAt(i)) + " ";
		}
	}
	return num_out;
}

function toHex(dec) {
	hexChars="0123456789ABCDEF"
	if (dec > 255) {
		return null;
	}
	var i = dec % 16;
	var j = (dec - i) / 16;
	result="";
	result += hexChars.charAt(j);
	result += hexChars.charAt(i);
	return result;
}

function displayHexHandler() {
	//var code="";
	//var date="";
	//var seq="";
	//var type="";
	//var inx="";
	//var newmessage="";
	var includeBreaks="";

	//var compId="";
	//var objHex=document.getElementById('displayHex');
	//var obj=document.getElementById('compId');
	//if (obj) compId=obj.value;
	//var obj=document.getElementById('code');
	//if (obj) code=obj.value;
	//var obj=document.getElementById('date');
	//if (obj) date=obj.value;
	//var obj=document.getElementById('seq');
	//if (obj) seq=obj.value;
	//var obj=document.getElementById('type');
	//if (obj) type=obj.value;
	//var obj=document.getElementById('inx');
	//if (obj) inx=obj.value;
	// Log 54649 - AI - 24-08-2005 : Add the message as it is now to the link.
	//var obj=document.getElementById('message');
	//if (obj) newmessage=obj.value;
	// Log 54649 - AI - 24-08-2005 : New function to remove surplus carriage return/line feed sequences from the string.
	if ((displayHex)&&(!(displayHex.checked))) {
		message.value=GetRidOfExtraLines(message.value);
		includeBreaks="";
	} else {
		includeBreaks="Y";
	}
	
	//var lnk="&code="+code+"&date="+date+"&seq="+seq+"&type="+type+"&inx="+inx+"&newmessage="+escape(newmessage)+"&includeBreaks="+includeBreaks;
	// end Log 54649

	if (displayHex && displayHex.checked) {
		//window.location="websys.default.csp?WEBSYS.TCOMPONENT=SSHL7Log.Edit&CONTEXT=S"+compId+lnk;

		// Log 54649 - AI - 24-08-2005 : Check whether the messageHEX box should be enabled or disabled.
		allowEditClickHandler();
		// end Log 54649
		
		// sending the link to window.location was causing problems if the link was heaps long.  frm.submit is much nicer
		var frm=document.forms["fSSHL7Log_Edit"];
		frm.TEVENT.value="d1834idisplayHex";
		frm.CONTEXT.value="S"+compId.value;
		frm.newmessage.value=message.value;
		frm.includeBreaks.value=includeBreaks;
		frm.submit();
		
	} else {
		// Log 54649 - AI - 24-08-2005 : Make the messageHEX box enabled so we can make it disappear.
		//var objHEX=document.getElementById('messageHEX');
		NotReadOnly(messageHEX);
		// end Log 54649

		//window.location="websys.default.csp?WEBSYS.TCOMPONENT=SSHL7Log.Edit"+lnk;
		
		var frm=document.forms["fSSHL7Log_Edit"];
		frm.TEVENT.value="d1834idisplayHex";
		frm.CONTEXT.value="";
		frm.newmessage.value=message.value;
		frm.includeBreaks.value=includeBreaks;
		frm.submit();
		
	}
}

// Log 54649 - AI - 24-08-2005 : Functions for the "Allow Edit" (allowEdit) checkbox.
function allowEditClickHandler() {

	if ((allowEdit)&&(allowEdit.checked)) {
		if ((displayHex)&&(displayHex.checked)) {
			if (messageHEX) NotReadOnly(messageHEX);
			if (message) ReadOnly(message);
			if (replay) {
				replay.disabled=true;
				replay.onclick=LinkDisable;
			}
			
		} else {
			if (messageHEX) ReadOnly(messageHEX);
			if (message) NotReadOnly(message);
		}
	} else {
		if (messageHEX) ReadOnly(messageHEX);
		if (message) ReadOnly(message);
	}
}

function ReadOnly(obj) {
	obj.onfocus=DoNotAllow;
	obj.onkeydown=DoNotAllow;
	obj.style.color="gray";
	// stops copying and pasting
	obj.ondragstart=DoNotAllow;
	obj.onselectstart=DoNotAllow;
	obj.oncontextmenu=DoNotAllow;
}

function DoNotAllow() {
	return false;
}

function NotReadOnly(obj) {
	obj.onfocus=DoAllow;
	obj.onkeydown=DoAllow;
	obj.style.color="";
	// stops copying and pasting
	obj.ondragstart=DoAllow;
	obj.onselectstart=DoAllow;
	obj.oncontextmenu=DoAllow;
}

function DoAllow() {
	return true;
}
// end Log 54649

// Log 54649 - AI - 24-08-2005 : New function to remove surplus carriage return/line feed sequences from the string.
function GetRidOfExtraLines(str) {

/*
	NOTE : THIS FUNCTION COULD BE :

	var re = /\r\n\r\n/g;
	str1 = str.replace(re,"insert replace string here");

	var re = /\r\n/g;
	str1 = str1.replace(re,"");

	var re = /insert replace string here/g;
	str1 = str1.replace(re,"\r\n");
*/

	var aryWork=str.split("\r\n\r\n");
	var re = /\r\n/g;
	for (var i=0;i<aryWork.length;i++) {
		aryWork[i]=aryWork[i].replace(re,"");
	}
	str1=aryWork.join("\r\n");

	return str1;
}
// end Log 54649

// Log 54649 - AI - 24-08-2005 : The reload Click Handler.
function reload1ClickHandler() {
	
	if ((displayHex)&&(displayHex.checked)) {
		if (messageHEX) messageHEX.value=GetRidOfExtraLines(messageHEX.value);
	}
	
	return reload1_click();
	/*
	var objdisplayHex=document.getElementById('displayHex');
	if ((objdisplayHex)&&(objdisplayHex.checked)) {
alert("reload from hex not implemented yet");
		return false;
	} else {
		return false;
	}
	*/
}
// end Log 54649


document.body.onload=BodyLoadHandler;


//TO BE DELETED
/*
	var objHex=document.getElementById('displayHex');
	var objMsg=document.getElementById('message');
	if (objHex.checked) {
		if (objMsg) {
			var hex=str_to_hex(objMsg);
			objMsg.value=hex;
		}
	} else {
		if (objMsg) {
			var hex=objMsg.value; //toDec(objMsg.value)
			var regexp=/" "/g;
			hex.replace(regexp,"%");
			alert(hex);
			objMsg.value=unescape(hex);
		}	
	}
*/
