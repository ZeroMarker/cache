/// DHCEQIFBDetailFind.js
function BodyLoadHandler()
{
	InitPage();
}

function InitPage()
{
	SetElement("Status",GetElementValue("GetStatus"));
	KeyUp("Mode^Vendor");
	Muilt_LookUp("Mode^Vendor");
}

function GetModeDR(value)
{
	var list=value.split("^");
	SetElement("Mode",list[0]);
	SetElement("ModeDR",list[1]);
}
function GetVendorDR(value)
{
	var list=value.split("^")
	SetElement("Vendor",list[0]);
	SetElement("VendorDR",list[1]);
}
document.body.onload = BodyLoadHandler;