function BodyLoadHandler()
{
	KeyUp("Provider","N");
	Muilt_LookUp("Provider","N")
	SetElement("Status",GetElementValue("StatusDR"))
	var obj=document.getElementById("Status");
	if (obj) obj.onchange=SetStatus;
	SetBEnable();
}
function SetBEnable()
{
	var WaitAD=GetElementValue("WaitAD");
	if (WaitAD=="on")
	{
		DisableBElement("BAdd",true);
	}
}
function SetStatus()
{
	SetElement("StatusDR",GetElementValue("Status"))
}
function GetProviderID(value)
{
	GetLookUpID("ProviderDR",value);
}

document.body.onload = BodyLoadHandler;