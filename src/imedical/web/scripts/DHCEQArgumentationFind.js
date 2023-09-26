
function BodyLoadHandler(){		
	InitPage();
}


function InitPage()
{
	KeyUp("RequestLoc^EquipType^Status^PurchaseType");
	Muilt_LookUp("RequestLoc^EquipType^Status^PurchaseType");
	var Type=GetElementValue("Type");
	if (Type!="1")
	{
		EQCommon_HiddenElement("ReplacesAD");
		EQCommon_HiddenElement("cReplacesAD");
	}
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

function GetRequestLoc (value)
{
    GetLookUpID("RequestLocDR",value);
}
function GetEquipType (value)
{
    GetLookUpID("EquipTypeDR",value);
}
function GetStatus (value)
{
    GetLookUpID("StatusDR",value);
}
function GetPurchaseType (value)
{
    GetLookUpID("PurchaseTypeDR",value);
}
document.body.onload = BodyLoadHandler;