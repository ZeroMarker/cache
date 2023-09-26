/// DHCEQDispatchVehicleFind.js
function BodyLoadHandler()
{		
	InitPage();
	SetBEnable();
	SetStatus();
	Muilt_LookUp("RequestUser");
}

function InitPage()
{
	KeyUp("RequestUser");
}
function SetBEnable()
{
	var WaitAD=GetElementValue("WaitAD");
	if (WaitAD!="off")
	{
		DisableBElement("BAdd",true);
	}
}
function SetStatus()
{
	SetElement("Status",GetElementValue("GetStatus"))
}
function GetRequestUser(value)
{
	GetLookUpID("RequestUserDR",value);
}

document.body.onload = BodyLoadHandler;