// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var objINTExternalHostName = document.getElementById("INTExternalHostName");
var objINTInterfaceType = document.getElementById("INTInterfaceType");
var objINTConnectionType = document.getElementById("INTConnectionType");
var objINTExternalHostPort = document.getElementById("INTExternalHostPort");
var objUpdate = document.getElementById("update1");
var objINTConnectionTypeCode = document.getElementById("INTConnectionTypeCode");

function BodyLoadHandler() 
{
	if (objUpdate)
	{
		objUpdate.onclick = UpdateClickHandler;
	}
	if ((objINTInterfaceType)&&(objINTInterfaceType.value == "T"))
	{
		EnableField("INTExternalHostName");
	}

	if(objINTConnectionTypeCode)
	{
		EnableDisableFields(objINTConnectionTypeCode.value)
	}
}

function UpdateClickHandler()
{
	var lbl = document.getElementById("cINTExternalHostName");
	if(lbl)
	{
		if(lbl.className == "clsRequired")
		{
			if(objINTExternalHostName)
			{
				if(objINTExternalHostName.value == "")
				{
					alert(t['EXTHOST_REQD']);
					return false;
				}
			}
		}	
	}
	return update1_click();
}

function INTConnectionTypeLookupHandler(str)
{
	//alert("str="+str);
 	var lu = str.split("^");
	if (objINTConnectionType ) {
		objINTConnectionType.value=lu[0];
		EnableDisableFields(lu[2])
	} 
}

function EnableDisableFields(code) {
	EnableField("INTExternalHostName");
	EnableField("INTExternalHostPort");
	EnableField("INTTimeWaitBeforeConnect");
	EnableField("INTTimeWaitPortConnect");
	EnableField("INTTimeWaitClientSend");
	EnableField("INTTimeWaitClientConnect");
	EnableField("INTTimeWaitBeforeSend");
	EnableField("INTTimeWaitForComplete");
	EnableField("INTTimeWaitForResponse");

	if((code)&&(code == "C"))
	{
		DisableField("INTExternalHostName");
		DisableField("INTTimeWaitBeforeSend");
		DisableField("INTTimeWaitForResponse");
	}
	else
	{
		DisableField("INTTimeWaitClientSend");
		DisableField("INTTimeWaitClientConnect");
	}	
}

function EnableField(fldName) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if (fld) {
		fld.disabled = false;
		fld.className = "";
		if (lbl) lbl = lbl.className = "clsRequired";
	}
}

function EnableNonMandatoryField(fldName) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if (fld) {
		//alert("fld")
		fld.disabled = false;
		fld.className = "";
		if (lbl) lbl = lbl.className = "";
	}
}

function DisableField(fldName) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if ((fld)&&(fld.tagName=="INPUT")) {
		//alert("flddis")
		fld.value = "";
		fld.disabled = true;
		fld.className = "disabledField";
		if (lbl) lbl = lbl.className = "";
	}
}

document.body.onload=BodyLoadHandler;


