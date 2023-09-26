/// DHCEQPayRequestListDetail.js
function BodyLoadHandler()
{
	Muilt_LookUp("Loc^Provider");
	KeyUp("Loc^Provider");
	HiddenTableIcon("DHCEQPayRequestListDetail","TRowID","TDetail");
}
function GetLocID(value)
{
	GetLookUpID('LocDR',value);
}
document.body.onload = BodyLoadHandler;