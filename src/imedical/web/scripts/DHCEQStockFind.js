
function BodyLoadHandler(){		
	InitPage();
}

function InitPage()
{
	KeyUp("Loc^Equip");
	Muilt_LookUp("Loc^Equip");
}
function GetLoc(value)
{
	GetLookUpID("LocDR",value)
}
function GetEquip(value)
{
	GetLookUpID("EquipDR",value)
}
document.body.onload = BodyLoadHandler;