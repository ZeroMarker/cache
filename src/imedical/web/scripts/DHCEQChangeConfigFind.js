
function BodyLoadHandler(){		
	InitPage();
}

function InitPage()
{
	KeyUp("Equip");
	Muilt_LookUp("Equip");
}
function GetEquip(value)
{
	GetLookUpID("EquipDR",value)
}
document.body.onload = BodyLoadHandler;