function BodyLoadHandler(){		
	InitPage();
	Muilt_LookUp("Equip");
}

function InitPage()
{
	KeyUp("Equip");
}
function GetEquip(value)
{
	GetLookUpID("EquipDR",value);
}

document.body.onload = BodyLoadHandler;