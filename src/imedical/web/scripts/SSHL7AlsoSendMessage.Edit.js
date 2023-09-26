// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var msgItems=document.getElementById('HL7MSGType');
var msgAry = new Array();
Init();

function Init() {
	var obj=document.getElementById('HL7MSGType'); if (obj) obj.onchange=MsgTypeChangeHandler;
	var obj=document.getElementById('HL7MSGAlsoSendMsg'); if (obj) obj.onchange=AlsoSendMsgTypeChangeHandler;
	var obj=document.getElementById('update1'); if (obj) obj.onclick=UpdateClickHandler;
	msgItems.multiple=false;
}

//this needs to be called after the captions are dumped.
function BodyLoadHandler() {
	if (tsc['Update']) websys_sckeys[tsc['Update']]=UpdateClickHandler;
	if (tsc['Delete']) websys_sckeys[tsc['Delete']]=DeleteClickHandler;
	DisableAlsoSendProperties();
	//
	// Load strAry (built in web.SSHL7MessageType.getAlsoSendMessages) into REAL array.
	var objStrArry=document.getElementById('strAry');
	var str=objStrArry.value;
	var lu = str.split("^");
	for(j=0; j<lu.length; j++) {
		var lu1=lu[j].split("*");
		// type_"*"_typedesc_"*"_storedval_"*"_alsotype_"*"_alsotypedesc_"*"_alsostoredval
		msgAry[j]=new msgRecord(lu1[0],lu1[1],lu1[2],lu1[3],lu1[4],lu1[5]);
	}
}

function MsgTypeChangeHandler() {
	EnableField('HL7MSGAlsoSendMsg');
	var j = msgItems.selectedIndex;
	if (j!=-1) {
		var obj=document.getElementById('HL7MSGAlsoSendMsg');
		if (obj) obj.value=msgAry[j].alsotypedesc;
	}
}

function AlsoSendMsgTypeChangeHandler() {
	var obj=document.getElementById('HL7MSGAlsoSendMsg');
	if ((obj)&&(obj.value=="")) {
		var j = msgItems.selectedIndex;
		msgAry[j].alsotypecode="";
		msgAry[j].alsotypedesc="";
		msgAry[j].alsostoredval="";
	}

	// useful part if Broker is used...
	//var obj=document.getElementById('HL7MSGAlsoSendMsg');
	//if ((obj)&&(obj.value!="")) {
	//	obj.value=obj.value.toUpperCase();
	//}

}

function HL7MSGAlsoSendMsgLookUp(str) {
	var alsotype="";
	var alsotypedesc="";
	var alsostoredval="";
	var alsoval="";

	if (str!="") {
		var lu=str.split("^");
		alsotype=lu[1];
		alsotypedesc=lu[0];
		alsostoredval=lu[2];
	}

	// if this option = the selected Message Type (msgAry) -> ERROR, setfocus, etc ...
	var j = msgItems.selectedIndex;
	if (alsostoredval!="") alsoval=alsostoredval.substring(0,alsostoredval.length-2);

	if (alsoval==msgAry[j].storedval) {
		var obj1=document.getElementById('cHL7MSGAlsoSendMsg');
		var obj2=document.getElementById('cHL7MSGType');
		alert(t['TheSelected'] + " '" + obj1.innerText + "' " + t['Value'] + " " + t['CannotBeTheSame'] + " '" + obj2.innerText + "' " + t['Value']);
		// Clear LookUp.
		var obj=document.getElementById('HL7MSGAlsoSendMsg');
		if (obj) obj.value="";
		// Set focus to Lookup field again.
		websys_setfocus("HL7MSGAlsoSendMsg");
		return false;
	}

	msgAry[j].alsotypecode=alsotype;
	msgAry[j].alsotypedesc=alsotypedesc;
	msgAry[j].alsostoredval=alsostoredval;
}

// type_"*"_typedesc_"*"_storedval_"*"_alsotype_"*"_alsotypedesc_"*"_alsostoredval
function msgRecord(typecode,typedesc,storedval,alsotypecode,alsotypedesc,alsostoredval) {
	this.typecode=typecode;
	this.typedesc=typedesc;
	this.storedval=storedval;
	this.alsotypecode=alsotypecode;
	this.alsotypedesc=alsotypedesc;
	this.alsostoredval=alsostoredval;
}

function UpdateClickHandler() {
	var strBuffer="";
	for(i=0; i<msgItems.length; i++) {
		if (strBuffer!="") strBuffer=strBuffer + "^";
		strBuffer=strBuffer + msgAry[i].typecode + "*";
		strBuffer=strBuffer + msgAry[i].typedesc + "*";
		strBuffer=strBuffer + msgAry[i].storedval + "*";
		strBuffer=strBuffer + msgAry[i].alsotypecode + "*";
		strBuffer=strBuffer + msgAry[i].alsotypedesc + "*";
		strBuffer=strBuffer + msgAry[i].alsostoredval;
	}
	var obj = document.getElementById('strAry');
	if (obj) obj.value=strBuffer;
	return update1_click();
}

function DisableField(fldName,vGray) {
	var fld = document.getElementById(fldName);
	if ((fld)&&(fld.tagName=="INPUT")&&(fld.type!="hidden")) {
		fld.disabled = true;
		if (fld.type=="checkbox") fld.checked=false;
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

function DisableAlsoSendProperties() {
	DisableField('HL7MSGAlsoSendMsg',1);
}

function EnableAlsoSendProperties() {
	EnableField('HL7MSGAlsoSendMsg');
}


document.body.onload=BodyLoadHandler;

