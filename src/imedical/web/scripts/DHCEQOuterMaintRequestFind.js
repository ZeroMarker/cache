
function BodyLoadHandler(){	
	document.body.scroll="no"
	InitPage();
	SetEnabled();
}

function SetEnabled()
{
	var Type=GetElementValue("Type");
	if (Type!="0")
	{
		DisableBElement("BAdd",true);
	}
	else
	{
		EQCommon_HiddenElement("WaitAD");
		EQCommon_HiddenElement("cWaitAD");
	}
	if (Type!="1")
	{
		EQCommon_HiddenElement("ReplacesAD");
		EQCommon_HiddenElement("cReplacesAD");
	}
}

function InitPage()
{
	KeyUp("Status^UseLoc")
	Muilt_LookUp("Status^UseLoc");
	var obj=document.getElementById("WaitAD");
	if (obj) obj.onchange=CheckChange;
	var obj=document.getElementById("ReplacesAD")
	if (obj) obj.onchange=CheckChange;
}

function CheckChange()
{
	var eSrc=window.event.srcElement;
	if (eSrc.checked)
	{
		if (eSrc.id=="WaitAD") SetChkElement("ReplacesAD","0");
		if (eSrc.id=="ReplacesAD") SetChkElement("WaitAD","0");
	} 
}

function GetStatus (value)
{
    GetLookUpID("StatusDR",value);
}

function GetUseLoc (value)
{
    GetLookUpID("UseLocDR",value);
}

document.body.onload = BodyLoadHandler;