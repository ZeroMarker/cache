/// DHCEQIFBFind.js
function BodyLoadHandler()
{
	InitUserInfo();
	InitPage();
	SetBEnable();
}

function InitPage()
{
	SetElement("Status",GetElementValue("GetStatus"));
	KeyUp("Mode");
	Muilt_LookUp("Mode");
}

function GetModeDR(value)
{
	var list=value.split("^");
	SetElement("Mode",list[0]);
	SetElement("ModeDR",list[1]);
}

function SetBEnable()
{
	var Type=GetElementValue("Type");
	if (Type!=0)
	{
		DisableBElement("BAdd",true);
	}
	else
	{
		EQCommon_HiddenElement("WaitAD");
		EQCommon_HiddenElement("cWaitAD");
	}
}

document.body.onload = BodyLoadHandler;