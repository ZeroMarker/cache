
function BodyLoadHandler(){		
	InitPage();
}


function InitPage()
{
	KeyUp("Equip^ManageLoc^UseLoc^Status","N");
	Muilt_LookUp("Equip^ManageLoc^UseLoc^Status");
	var Type=GetElementValue("Type")
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



function GetEquip (value)
{
    GetLookUpID("EquipDR",value);
}
function GetManageLoc (value)
{
    GetLookUpID("ManageLocDR",value);
}
function GetUseLoc (value)
{
    GetLookUpID("UseLocDR",value);
}
function GetStatus (value)
{
    GetLookUpID("StatusDR",value);
}


document.body.onload = BodyLoadHandler;