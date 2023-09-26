// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var objID=document.getElementById('ID');
var objName=document.getElementById('INTCode');
var objCopy=document.getElementById('copyfrom1');
// Log 56732 - AI - 20-12-2005 : Add logic for "Run HL7 Wizard" checkbox.
var objWiz=document.getElementById('RunHL7Wizard');
var objhidWiz=document.getElementById('hiddenRunHL7Wizard');
var objCacheScriptCaption=document.getElementById('CINTCacheScript');
var objUpdate=document.getElementById('update1');


// Log 42529 - AI - 01-03-2004 : Create LoadHandler to stop modification of the "Name" (INTCode) field.
function DocumentLoadHandler() {
	if (objCopy) objCopy.onclick=CopyClickHandler;
	if (objName) objName.onchange=NameChangeHandler;
	// Log 56732 - AI - 20-12-2005 : Add logic for "Run HL7 Wizard" checkbox.
	if (objWiz) objWiz.onclick=WizClickHandler;
	if (objUpdate) objUpdate.onclick=UpdateClickHandler;

	objhidWiz.value=0;

	// Log 56732 - AI - 22-12-2005 : The Cache Script field is no longer set as "Required" on the component.
	//     Fake it when first drawing the screen. This will be changed in WizClickHandler.
	if (objCacheScriptCaption) objCacheScriptCaption.className="clsRequired";

	DisableCopyFromProperties();

	if ((objID)&&(objID.value!="")) {
		if (objName) {
			objName.disabled = true;
			objName.className = "disabledField";
		}
		if (objCopy) {
			DisableField("copyfrom1",1);
		}
		// Log 56732 - AI - 20-12-2005 : Add logic for "Run HL7 Wizard" checkbox.
		if (objWiz) {
			DisableField("RunHL7Wizard",1);
		}
		// end Log 56732
	}
}

// Log 42529 - AI - 01-03-2004 : Function to handle the enabling and disabling of the copy properties.
function CopyClickHandler() {
	if ((objCopy)&&(objCopy.disabled==true)) {
		return false;
	}

	if ((objCopy)&&(objCopy.checked==true)) {
		EnableCopyFromProperties();
		ClearDetails();
		// Log 56732 - AI - 20-12-2005 : Add logic for "Run HL7 Wizard" checkbox.
		if (objWiz) {
			DisableField("RunHL7Wizard",1);
		}
		// end Log 56732
	}
	if ((objCopy)&&(objCopy.checked==false)) {
		DisableCopyFromProperties();
		// Log 56732 - AI - 20-12-2005 : Add logic for "Run HL7 Wizard" checkbox.
		if (objWiz) {
			EnableField("RunHL7Wizard",1);
		}
		// end Log 56732
	}
}

// Log 42529 - AI - 22-03-2004 : Function to check whether the name entered is already used.
function NameChangeHandler() {
	var objAllInterfaceCodes=document.getElementById('AllInterfaceCodes');

	var str=objAllInterfaceCodes.value;
	var ary=str.split("^");
	for(j=0; j<ary.length; j++) {
		// If ID has a value, INTCode (objName) field is disabled, so no need to check ID here.
		if ((ary[j]!="")&&(ary[j].toUpperCase()==objName.value.toUpperCase())) {
			alert(t['UNIQUE']);
			objName.className="clsInvalid";
			// perform the actual "commit" to the field, so the invalid value is now the "old" value for onchange handler.
			var val=objName.value;
			objName.value=val;
			websys_setfocus("INTCode");
			return false;
		}
	}
	// if continuing, treated as the "else" of the above "if" statement, so objName is valid.
	objName.className="";
}

// Log 56732 - AI - 20-12-2005 : Add logic for "Run HL7 Wizard" checkbox.
function WizClickHandler() {
	if (objWiz) {
		if (objWiz.disabled==true) {
			return false;
		}
		// Update the hidden Wizard value (used on the websysAfterSave. Also change the Cache Script required setting.
		if (objWiz.checked) {
			objhidWiz.value=1;
			if (objCacheScriptCaption) objCacheScriptCaption.className="";
		} else {
			objhidWiz.value=0;
			if (objCacheScriptCaption) objCacheScriptCaption.className="clsRequired";
		}
	}
}

// Log 56732 - AI - 20-12-2005 : Add logic for "Run HL7 Wizard" checkbox - check the clsRequired before updating.
function UpdateClickHandler() {
	var objCacheScript=document.getElementById('INTCacheScript');
	if (objUpdate) {
		if (objUpdate.disabled==true) {
			return false;
		}
		if ((objCacheScriptCaption)&&(objCacheScriptCaption.className=="clsRequired")&&(objCacheScript)&&(objCacheScript.value=="")) {
			alert("'" + t['INTCacheScript'] + "' " + t['XMISSING']);
			return false;
		}
	}
	return update1_click();
}
// end Log 56732


document.body.onload = DocumentLoadHandler;


// Log 42529 - AI - 01-03-2004 : Function to copy Interface details from an existing Interface to a New one.
function CopyInterfaceDetails(msg) {
	var str=msg.split("^");
	var part=str[2].split("||");

	// part[0] is the rowid
	var obj=document.getElementById('INTDataDirection');
	if ((obj)&&(obj.value=="")) obj.value=part[1];

	var obj=document.getElementById('INTDataType');
	if ((obj)&&(obj.value=="")) obj.value=part[2];

	var obj=document.getElementById('INTInterfaceType');
	if ((obj)&&(obj.value=="")) obj.value=part[3];

	var obj=document.getElementById('INTLoggingLevel');
	if ((obj)&&(obj.value=="")) obj.value=part[4];

	var obj=document.getElementById('INTCacheScript');
	if ((obj)&&(obj.value=="")) obj.value=part[5].replace("@","^");

	alert(t['WARNING'] + ": " + t['CHECK_SCRIPT']);
	websys_setfocus("INTCacheScript");
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
		fld.value = "";
	}
}

function DisableCopyFromProperties() {
	DisableField("CopyFromInterface",1);
	objLU=document.getElementById('ld1629iCopyFromInterface');
	if (objLU) objLU.disabled=true;
}

function EnableCopyFromProperties() {
	EnableField('CopyFromInterface');
	var objLU = document.getElementById('ld1629iCopyFromInterface');
	if (objLU) objLU.disabled=false;
}

function ClearDetails() {
	var obj=document.getElementById('INTDataDirection');
	if (obj) obj.value="";
	var obj=document.getElementById('INTDataType');
	if (obj) obj.value="";
	var obj=document.getElementById('INTInterfaceType');
	if (obj) obj.value="";
	var obj=document.getElementById('INTLoggingLevel');
	if (obj) obj.value="";
	var obj=document.getElementById('INTCacheScript');
	if (obj) obj.value="";
}
